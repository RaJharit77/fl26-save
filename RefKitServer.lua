-- Referee Kit server for PES 2021 & PES 2020: assign the referee kits manually or based on the competition mode
-- Custom content is used, not LiveCPK/game: content\referee_kit-server is the root
-- author: zlac, 2018-2020
-- edited script: Hawke
-- Collar 01 PES2020 fix: MJTS-140914
-- version: 7 (module) 11 (kits)
-- originally posted on evo-web
-- Massive thanks to zlac... I 100% could not have done this without him, thanks mate

-- local new_refkit_path
local refkitroot = ".\\content\\referee_kit-server"
local version = "1.0"
local random_num
local settings
local _empty = {}

local competition_assignment_map = {}
local all_refkit_map = {}

local info_text = ""
local manual_refkit_idx
local manual_refkit_info = "Manually selected referee kit: None"
local manual_selection_status = "Off"
local manual_selection_status_info = "Selection mode: automatic map assignments"
local total_referee_kits

local _refkit_info = {}
local current_refkit_preview_path

local exhib_same_league_tid

local RELOAD_MAPS_KEY = 0x30 -- 0 key (not the NUMPAD zero!!)
local SET_AS_FAVORITE_REFKIT_KEY = 0x37 -- 7 key (not the NUMPAD 7!!)
local USE_FAVORITE_REFKIT_KEY = 0x38 -- 8 key (not the NUMPAD 8!!)
local SWITCH_SELECTION_MODE_KEY = 0x39 -- 9 key (not the NUMPAD 9!!)
local DEL_TEXT_KEY = 0x2E
local PREVIOUS_REFKIT_KEY = 0x21 -- Page Up
local NEXT_REFKIT_KEY = 0x22 -- Page Down


-- remove trailing and leading whitespace from string
local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

local function nil2str(value)
	if value ~= nil then
		return value
	else
		return "N/A"
	end
end

local function get_common_lib(ctx)
    return ctx.common_lib or _empty
end

local function split(s, inSplitPattern)
   local outResults = {}
   -- chop off the trailing comment, if present
   local theCommentStart = string.find( s, "#", 1 )
   local data = s
   if theCommentStart ~= nil then
      data = string.sub(s, 1, theCommentStart-1)
   end

   -- now do the splits by main separator (inSplitPattern)
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( data, inSplitPattern, theStart )
   while theSplitStart do
      outResults[#outResults+1] = trim(string.sub( data, theStart, theSplitStart-1 ))
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( data, inSplitPattern, theStart )
   end
   outResults[#outResults+1] = trim(string.sub( data, theStart ))
   return outResults
end

local function clear_table(t)
    for k,v in pairs(t) do
        t[k]=nil
    end
end

local function load_map_txt(filename)
    local delim = ","
    local data = assert(io.lines(refkitroot .. "\\" .. filename))
    log(filename .. " found in " .. refkitroot)

    if filename == "map_competitions.txt" then
        clear_table(competition_assignment_map)
    end

    for line in data do
       line = trim(string.gsub(line, "^\239\187\191", "")) -- removes UTF BOM bytes at the beginning of the first line in .txt file and leading/trailing whitespaces in every line
       local fields = split(line, delim)
       if #fields > 1 then
	       for i=1,#fields do
	           fields[i] = trim(fields[i])
	       end
	       if fields[1] ~= nil and fields[1] ~= "" then
	          if filename == "map_competitions.txt" and fields[2] ~= nil then
	      	  	 if competition_assignment_map[tonumber(fields[1])] ~= nil then
	      	  	 	table.insert(competition_assignment_map[tonumber(fields[1])], {fields[2]})
	      	  	 else
	      	  	 	competition_assignment_map[tonumber(fields[1])] = { {fields[2]} }
	      	  	 end
	      	  	 log(string.format(" ==> %s referee_kit assignment::   %s: %s ", filename, fields[1], fields[2]))
	      	  end
	       end
	   end
    end
end

local function has_value(tab, val)
    for index, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function dump_table(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump_table(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function valueArrayExistsInTable(tbl, val, startAt)
    for key, value in pairs(tbl) do
        if val[startAt] == value[1] then
            return true
        end
    end
    return false
end

local function compare_refkit_names(a,b)
  return a[1] < b[1] -- only one string item passed in {} - sb name, compare names
end

local function merge_maps()
    local idx = 1
    clear_table(all_refkit_map)

    for key, value in pairs(competition_assignment_map) do
        for index, row in pairs(value) do
            if row[1] ~= nil and row[1] ~= "" and not valueArrayExistsInTable(all_refkit_map, row, 1) then
                all_refkit_map[idx] = {row[1]}
                idx = idx + 1
            end
        end
    end

    total_referee_kits = #all_refkit_map
    if total_referee_kits > 0 then
        manual_refkit_idx = 1
    end
    log(string.format("%s unique referee_kits available for manual selection.", total_referee_kits))
    -- log(dump_table(all_refkit_map))
    table.sort(all_refkit_map, compare_refkit_names)
    -- log(dump_table(all_refkit_map))
end


local function is_it_referee_kit_file(filename)
    filename = string.lower(filename)
    if
       string.match(filename, "asset\\model\\character\\uniform\\texture\\#windx11\\referee") or
       string.match(filename, "asset\\model\\character\\uniform\\nocloth\\#win\\referee") or
       string.match(filename, "asset\\model\\character\\uniform\\nocloth\\#win\\pants")
    then
          return true
    else
          return false
    end
end

local function get_refkit_preview_path(refkit_info)
    if refkit_info then
        local refkit_prefix = refkit_info[1]
        return string.format("%s\\%s\\preview.dds", refkitroot, refkit_prefix)
    end
end


local function get_new_refkit_path(ctx)
	local tid = tonumber(ctx.tournament_id)
	local refkit_path

	if tid then
        if manual_selection_status == "On" and manual_refkit_idx then
            -- manual selection from overlay trumps everything
            refkit_path = all_refkit_map[manual_refkit_idx][2]
            refkit_path = all_refkit_map[manual_refkit_idx][1]
        elseif exhib_same_league_tid and competition_assignment_map[exhib_same_league_tid] ~= nil and random_num ~= nil then
            refkit_path = competition_assignment_map[exhib_same_league_tid][random_num][1]
		elseif competition_assignment_map[tid] ~= nil and random_num ~= nil then
            refkit_path = competition_assignment_map[tid][random_num][1]  -- use the referee_kit assigned for this competition
        end
    end
    if refkit_path and manual_selection_status == "Off" then
        manual_selection_status_info = string.format("Selection mode: automatic map assignments (using referee kit: %s)", refkit_path)
    elseif manual_selection_status == "Off" then
        manual_selection_status_info = string.format("Selection mode: automatic map assignments (using referee kit: %s)", "No referee kits assigned to this competition")
    end
	
	if refkit_path then
		_refkit_info[1] = refkit_path
		current_refkit_preview_path = get_refkit_preview_path(_refkit_info)
	end
			
	return refkit_path
end


local function teams_selected(ctx, home_team_id, away_team_id)
	--whenever game selects new home_team, pick a random index of a referee_kit to be used in selected competition (e.g. if multiple referee_kits are assigned to one competition_ID)
    local tid = tonumber(ctx.tournament_id)
	random_num = nil
	exhib_same_league_tid = nil
	
	if manual_selection_status == "Off" then
        _refkit_info[1] = nil
		-- _refkit_info = nil
		current_refkit_preview_path = nil
	end

	if tid == 65535 then
        -- are both teams in exhibition mode from the same playable league?
        log("Checking if both teams in exhibition belong to the same league ... ")
		exhib_same_league_tid = get_common_lib(ctx).tid_same_league(home_team_id, away_team_id)
		
		if exhib_same_league_tid ~= nil then
			log("... they do!")
			log("... mapped TournamentID for exhibition mode: " .. nil2str((get_common_lib(ctx).compID_to_tournamentID_map or _empty)[index]) )
			
			if competition_assignment_map[exhib_same_league_tid] ~= nil then
				log(string.format("... competition with ID %s has %s referee kits assigned.", exhib_same_league_tid, #competition_assignment_map[exhib_same_league_tid]))
				if #competition_assignment_map[exhib_same_league_tid] == 1 then
					-- if there's only one referee kit assigned to competition, set "random" number to 1
					-- do the same if replay mode is active - tid is not reliably available, so assume there's only 1 referee kit available
					random_num = 1
				else
					-- if there are more referee kits, select one index rendomly
					-- random_num = math.random(1, #competition_assignment_map[tid])
					random_num = math.random(#competition_assignment_map[exhib_same_league_tid])
				end
				log("Selecting random referee kit for competition ID " .. tostring(exhib_same_league_tid) .. " in exhibition mode (both teams belong to the same league): Referee kit no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[exhib_same_league_tid]) .. " referee kit(s) available)")
			else
				log(string.format("... competition with ID %s has no referee kits assigned.", exhib_same_league_tid))
				-- since the mapped competition does not have its own referee kits, revert to default exhibition mode random selection
				if competition_assignment_map[tid] ~= nil then
					if #competition_assignment_map[tid] == 1 then
						random_num = 1
					else
						random_num = math.random(#competition_assignment_map[tid])
					end
					log("Selecting random referee kit for exhibition mode: Referee kit no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " referee kit(s) available)")
				end
			end
		else
			log("... they don't!")
            -- if not from the same league, make sure we still generate random_num for exhibition mode ...
            if competition_assignment_map[tid] ~= nil then
                if #competition_assignment_map[tid] == 1 then
                    random_num = 1
                else
                    random_num = math.random(#competition_assignment_map[tid])
                end
                log("Selecting random referee kit for exhibition mode: Referee kit no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " referee kit(s) available)")
            end
        end
	--
	elseif competition_assignment_map[tid] ~= nil and manual_selection_status == "Off" then
		-- if #competition_assignment_map[tid] == 1 or ctx.is_replay_gallery == true then
        if #competition_assignment_map[tid] == 1 then
			random_num = 1
		else
            random_num = math.random(1, #competition_assignment_map[tid])
		end
		log("Selecting random referee_kit for competition ID " .. tostring(tid) .. ": referee_kit no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " referee_kit(s) available)")
	end
	
	-- in Exhibition mode, we can update refkit info in overlay
    if tid == 65535 then
        get_new_refkit_path(ctx)
    end
end


local function make_key(ctx, filename)
	-- if ctx.is_edit_mode == nil then -- do something only if edit mode is NOT active
		-- local refkit_fname = which_referee_kit(filename)
		if is_it_referee_kit_file(filename) then
              -- log(string.format("Into make_key (referee_kit file) ... (%s)", filename))
		      local new_refkit_path = get_new_refkit_path(ctx)
		      if new_refkit_path then
                 -- log("Into make_key (referee_kit file): " .. new_refkit_path .. "\\" .. filename)
		      	 return new_refkit_path .. "\\" .. filename
		      end
		end

	-- end
end

local function get_filepath(ctx, filename, key)
    -- log(string.format("Into get_filepath ... (%s, %s)", filename, key))
	-- if ctx.is_edit_mode == nil then -- do something only if edit mode is NOT active
	    -- if new_refkit_path then
        if key and filename and filename ~= key then -- filename ~= key shoud ensure that it really is a file from custom repository, with modified path prefix???
	        -- log(string.format("referee_kit file assignment for competition ID %s - %s\\%s", nil2str(ctx.tournament_id), refkitroot, key))
            -- log(string.format("%s\\%s", refkitroot, key))
	        return string.format("%s\\%s", refkitroot, key)
	    end
	-- end
end

local opts = { image_width = 0.15, image_hmargin = 0, image_vmargin = 10 }
local function overlay_on(ctx)
    local text = string.format("version %s\nRefKitServer commands:\nPress [0] to reload map .txt files\nPress [DEL] to clear info messages\nPress [9] to switch between using map assignments/manual selection\n     Manual selection mode subcommands:\n       [PageUp][PageDn] to manually select previous/next referee kit\n       [7] to set current manual selection as favorite referee kit\n       [8] to use your favorite referee kit \n\n%s\n%s\n\n%s", version, manual_selection_status_info, manual_refkit_info, info_text)
	local image = current_refkit_preview_path
	return text, image, opts
end

local function load_ini(filename)
    local t = {}
    local data = assert(io.lines(refkitroot .. "\\" .. filename))
    log(filename .. " found in " .. refkitroot)

    for line in data do
        local name, value = string.match(line, "^([%w_]+)%s*=%s*([-%w%d.]+)")
        if name and value then
            value = tonumber(value) or value
            t[name] = value
            log(string.format("Using setting: %s = %s", name, value))
        end
    end
    return t
end

local function save_ini(filename)
    local f = io.open(refkitroot .. "\\" .. filename, "wt")
    f:write(string.format("# referee_kitServer settings. Generated by referee_kitServer.lua\n"))
    f:write("\n")
    local keys = {}
    for name,value in pairs(settings) do
        keys[#keys + 1] = name
    end
    table.sort(keys)
    for i,name in ipairs(keys) do
        local value = settings[name]
        f:write(string.format("%s = %s\n", name, value))
    end
    f:write("\n")
    f:close()
end

local function key_down(ctx, vkey)
    if vkey == RELOAD_MAPS_KEY then
        log("Starting manual map files reload ... ")
        load_map_txt("map_competitions.txt")
        merge_maps()
        manual_refkit_idx = nil
        manual_refkit_info = "Manually selected referee kit: None"
        if total_referee_kits > 0 then
            manual_refkit_idx = 1
        end
        info_text = info_text .. "map_competitions.txt reloaded\n"
        log("Manual map files reloading finished.")
    elseif vkey == DEL_TEXT_KEY then
        info_text = ""
    elseif vkey == SWITCH_SELECTION_MODE_KEY then
        if manual_selection_status == "Off" then
            manual_selection_status = "On"
            manual_selection_status_info = "Selection mode: manual selection [PageUp]/[PageDn]"
            manual_refkit_info = string.format("Manually selected referee kit: %s\n", all_refkit_map[manual_refkit_idx][1])
			current_refkit_preview_path = get_refkit_preview_path(all_refkit_map[manual_refkit_idx])
        else
            manual_selection_status = "Off"
            manual_selection_status_info = "Selection mode: automatic map assignments"
            manual_refkit_info = string.format("Manually selected referee kit: None")
            info_text = ""
			current_refkit_preview_path = nil
        end
    elseif vkey == PREVIOUS_REFKIT_KEY then
       if manual_selection_status == "On" and total_referee_kits > 0 and manual_refkit_idx then
            manual_refkit_idx = manual_refkit_idx - 1
            if manual_refkit_idx < 1 then
                manual_refkit_idx = total_referee_kits
            end
            manual_refkit_info = string.format("Manually selected referee kit: %s\n", all_refkit_map[manual_refkit_idx][1])
			current_refkit_preview_path = get_refkit_preview_path(all_refkit_map[manual_refkit_idx])
        end
    elseif vkey == NEXT_REFKIT_KEY then
       if manual_selection_status == "On" and total_referee_kits > 0 and manual_refkit_idx then
            manual_refkit_idx = manual_refkit_idx + 1
            if manual_refkit_idx > total_referee_kits then
                manual_refkit_idx = 1
            end
            manual_refkit_info = string.format("Manually selected referee kit: %s\n", all_refkit_map[manual_refkit_idx][1])
			current_refkit_preview_path = get_refkit_preview_path(all_refkit_map[manual_refkit_idx])
        end
    elseif vkey == SET_AS_FAVORITE_REFKIT_KEY then
        if manual_selection_status == "On" and manual_refkit_idx then
            if all_refkit_map[manual_refkit_idx] then
                settings["favorite_referee_kit"] = manual_refkit_idx
                save_ini("config.ini")
                info_text = info_text .. string.format("referee_kit %s saved as favorite\n", all_refkit_map[manual_refkit_idx][1])
            else
                info_text = info_text .. "Could not save favorite referee_kit\n"
            end
        end
    elseif vkey == USE_FAVORITE_REFKIT_KEY then
        if manual_selection_status == "On" and settings["favorite_referee_kit"] then
            if all_refkit_map[tonumber(settings["favorite_referee_kit"])] then
                manual_refkit_idx = settings["favorite_referee_kit"]
                manual_refkit_info = string.format("Manually selected referee kit: %s\n", all_refkit_map[manual_refkit_idx][1])
				current_refkit_preview_path = get_refkit_preview_path(all_refkit_map[manual_refkit_idx])
                info_text = info_text .. string.format("Favorite referee_kit %s set as active\n", all_refkit_map[manual_refkit_idx][1])
            else
                info_text = info_text .. string.format("Could not find favorite referee_kit (idx: %s)\n", settings["favorite_referee_kit"])
            end
        end
    end
end

local function after_set_conditions(ctx)
    -- final update of refkit preview in overlay
    local refkit_path = get_new_refkit_path(ctx)
	if refkit_path then
		log(string.format("Referee kit assigned: %s", refkit_path))
	end
end

local function init(ctx)
    if refkitroot:sub(1,1)=='.' then
        refkitroot = ctx.sider_dir .. refkitroot
    end
    load_map_txt("map_competitions.txt")
    merge_maps()
    settings = load_ini("config.ini")
	math.randomseed(os.time())

    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
    ctx.register("set_teams", teams_selected)
    ctx.register("overlay_on", overlay_on)
    ctx.register("key_down", key_down)
	ctx.register("after_set_conditions", after_set_conditions)
end

return { init = init }