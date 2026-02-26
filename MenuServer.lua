-- Menu Server for PES 2021: Assign a menu based on the competition mode
-- Custom content is used, not LiveCPK/game: content\menu-server is the root
-- Author: Hawke & Zlac, 2020
-- Originally posted on Evo-Web
-- Massive thanks to Zlac... I 100% could not have done this without him, thanks mate
-- Version: 5.3 edited by EDWARD7777 july/2024 (Paid patches are NOT allowed to use, I am serious)
-- New update to include menus, seasons, derbies, stadiums and special opening, knockouts and final stages ALL-IN-ONE

-- local new_menu_path
local menuroot = ".\\content\\menu-server"
local random_num
local competition_assignment_map = {}
local exhib_same_league_tid
local version = "5.3"
local current_path = ""

-- remove trailing and leading whitespace from string
local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
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



local function load_map_txt(filename)
    local delim = ","
    local data = assert(io.lines(menuroot .. "\\" .. filename))
    log(filename .. " found in " .. menuroot .. "\\" .. filename)

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
	      	  	 log(string.format(" ==> %s menu assignment::   %s: %s ", filename, fields[1], fields[2]))
	      	  end
	       end
	   end
    end
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function dump_table(o)
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


local function is_edit_mode(ctx)
    -- sorta works now, but probably needs to be more robust
	-- if all three values are known, we should not be in edit mode
    return not(ctx.tournament_id and ctx.home_team and ctx.away_team)
end


local function is_it_menu_file(filename)
    filename = string.lower(filename)
    if
        string.match(filename, "common\\menu\\system") or
        string.match(filename, "common\\menu\\general") or
        string.match(filename, "common\\script\\flow") or
        string.match(filename, "common\\render\\symbol\\blank") or
        string.match(filename, "common\\render\\symbol\\flag")
    then
        return true
    else
        return false
    end
end
local function file_exists(name)
    local f = io.open(name,"r")
    if f ~=nil then 
        io.close(f) 
        return true 
    else 
        return false 
    end
end

local function update_overlay(mode_text)
    local overlay_text = "Current Menu: " .. current_menu_path .. " (" .. mode_text .. ")"
    -- Assuming 'overlay' is the function to update the overlay text
    overlay.show_text(overlay_text)
end

-- Define `current_path` globally or at an appropriate scope where it's accessible.
local current_path

local function get_new_menu_path(ctx)
    local tid = tonumber(ctx.tournament_id)
    local menu_path

    if exhib_same_league_tid then
        if competition_assignment_map[exhib_same_league_tid] ~= nil and random_num ~= nil then
            menu_path = competition_assignment_map[exhib_same_league_tid][random_num][1]  -- use the menu assigned for this competition
        end
    elseif tid then
        if competition_assignment_map[tid] ~= nil and random_num ~= nil then
            menu_path = competition_assignment_map[tid][random_num][1]  -- use the menu assigned for this competition
        end
    end

    -- Update the current_path variable
    current_path = menu_path

    return menu_path
end


local function teams_selected(ctx, home_team_id, away_team_id)
	--whenever game selects new home_team, pick a random index of a menu to be used in selected competition (e.g. if multiple menus are assigned to one competition_ID)
    local tid = tonumber(ctx.tournament_id)
	random_num = nil
	exhib_same_league_tid = nil

	if tid == 65535 then
        -- are both teams in exhibition mode from the same playable league?
        log("Checking if both teams in exhibition belong to the same league ... ")
		exhib_same_league_tid = get_common_lib(ctx).tid_same_league(home_team_id, away_team_id)
		        
		if exhib_same_league_tid ~= nil then
			log("... they do!")
			log("... mapped TournamentID for exhibition mode: " .. exhib_same_league_tid )
			if competition_assignment_map[exhib_same_league_tid] ~= nil then
				log(string.format("... competition with ID %s has %s menu(s) assigned.", exhib_same_league_tid, #competition_assignment_map[exhib_same_league_tid]))
				if #competition_assignment_map[exhib_same_league_tid] == 1 then
					-- if there's only one menu assigned to competition, set "random" number to 1
					-- do the same if replay mode is active - tid is not reliably available, so assume there's only 1 menu available
					random_num = 1
				else
					-- if there are more menus, select one index rendomly
					-- random_num = math.random(1, #competition_assignment_map[tid])
					random_num = math.random(#competition_assignment_map[exhib_same_league_tid])
				end
				log("Selecting random menu for competition ID " .. tostring(exhib_same_league_tid) .. " in exhibition mode (both teams belong to the same league): Menu no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[exhib_same_league_tid]) .. " menu(s) available)")
			else
				log(string.format("... competition with ID %s has no menus assigned.", exhib_same_league_tid))
				-- since the mapped competition does not have its own menus, revert to default exhibition mode random selection
				if competition_assignment_map[tid] ~= nil then
					if #competition_assignment_map[tid] == 1 then
						random_num = 1
					else
						random_num = math.random(#competition_assignment_map[tid])
					end
					log("Selecting random menu for exhibition mode: Menu no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " menu(s) available)")
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
                log("Selecting menu for exhibition mode: Menu no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " menu(s) available)")
            end
        end
	--
	elseif competition_assignment_map[tid] ~= nil then
		-- if #competition_assignment_map[tid] == 1 or ctx.is_replay_gallery == true then
        if #competition_assignment_map[tid] == 1 then
			random_num = 1
		else
            random_num = math.random(#competition_assignment_map[tid])
		end
		log("Selecting random menu for competition ID " .. tostring(tid) .. ": menu no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " menu(s) available)")
	end
end

local SWITCH_MODE = 0x39 -- 9 key (not the NUMPAD 9!!)
local Master_League_mode = "on"

local function log_mode_change(current_mode)
    local mode_text = current_mode == "on" and "Master League" or "League/Cup"
    log("Mode changed to: " .. mode_text)
end

local function key_down(ctx, vkey)
    if vkey == SWITCH_MODE then
        -- Toggle the Master_League_mode
        Master_League_mode = (Master_League_mode == "on") and "off" or "on"
        log_mode_change(Master_League_mode)
    end
end

-- Initialize these variables globally or within a persistent scope
local previous_match_info = nil
local background_folders = { "background_0", "background_1", "background_2", "background_3", "background_4", "background_5", "background_6", "background_7", "background_8", "background_9" }
local current_background_folder = nil

-- Function to make key based on context and filename
local function make_key(ctx, filename)
    if not is_edit_mode(ctx) and is_it_menu_file(filename) then
        local new_menu_path = get_new_menu_path(ctx)
        if new_menu_path then
            -- Special paths based on match info
            if Master_League_mode == "off" then
                if ctx.match_info == 0 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\opening_cup\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\opening_cup")
                        return new_menu_path .. "\\" .. filename
                    end
                end
                if ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\knockouts_cup\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\knockouts_cup")
                        return new_menu_path .. "\\" .. filename
                    end
                end
                if ctx.match_info == 53 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\final_cup\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\final_cup")
                        return new_menu_path .. "\\" .. filename
                    end
                end
            end

            if Master_League_mode == "on" then
                if ctx.match_info == 0 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\opening\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\opening")
                        return new_menu_path .. "\\" .. filename
                    end
                end
                if ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\knockouts\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\knockouts")
                        return new_menu_path .. "\\" .. filename
                    end
                end
                if ctx.match_info == 53 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\special\\final\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\special\\final")
                        return new_menu_path .. "\\" .. filename
                    end
                end
            end
           
	    -- Derby paths  
            if Master_League_mode == "off" then
                if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\derbies\\%s\\%s_league\\%s", ctx.home_team, ctx.away_team, filename)) then
                    new_menu_path = new_menu_path .. string.format("\\derbies\\%s\\%s_league", ctx.home_team, ctx.away_team)
                    return new_menu_path .. "\\" .. filename
                end
            end
            if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\derbies\\%s\\%s\\%s", ctx.home_team, ctx.away_team, filename)) then
                new_menu_path = new_menu_path .. string.format("\\derbies\\%s\\%s", ctx.home_team, ctx.away_team)
                return new_menu_path .. "\\" .. filename
            end

            -- Master League Mode specific paths
            if Master_League_mode == "on" then
                if ctx.match_info >= 30 and ctx.match_info <= 40 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\final_road\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\final_road")
                        return new_menu_path .. "\\" .. filename
                    end
                end
            elseif Master_League_mode == "off" then
                if ctx.match_info >= 30 and ctx.match_info <= 40 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\final_road_league\\%s", filename)) then
                        new_menu_path = new_menu_path .. string.format("\\final_road_league")
                        return new_menu_path .. "\\" .. filename
                    end
                end
            end


            -- Stadium paths based on time of day
            if Master_League_mode == "off" then
                if ctx.timeofday == 0 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\stadiums\\%s\\day\\%s", ctx.home_team, filename)) then
                        new_menu_path = new_menu_path .. string.format("\\stadiums\\%s\\day", ctx.home_team)
                        return new_menu_path .. "\\" .. filename
                    end
                elseif ctx.timeofday == 1 then
                    if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\stadiums\\%s\\night\\%s", ctx.home_team, filename)) then
                        new_menu_path = new_menu_path .. string.format("\\stadiums\\%s\\night", ctx.home_team)
                        return new_menu_path .. "\\" .. filename
                    end
                end
            end

            if ctx.timeofday == 0 then
                if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\stadiums\\%s\\day_league\\%s", ctx.home_team, filename)) then
                    new_menu_path = new_menu_path .. string.format("\\stadiums\\%s\\day_league", ctx.home_team)
                    return new_menu_path .. "\\" .. filename
                end
            elseif ctx.timeofday == 1 then
                if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\stadiums\\%s\\night_league\\%s", ctx.home_team, filename)) then
                    new_menu_path = new_menu_path .. string.format("\\stadiums\\%s\\night_league\\%s", ctx.home_team)
                    return new_menu_path .. "\\" .. filename
                end
            end 

-- League/cup backgrounds
if Master_League_mode == "off" then
    if ctx.match_info >= 0 and ctx.match_info <= 29 then
        -- Check if the match_info has changed
        if ctx.match_info ~= previous_match_info then
            local valid_background_folders = {}
            -- Filter folders that contain the filename
            for _, folder in ipairs(background_folders) do
                local folder_path = string.format("%s\\%s\\seasons\\%s\\%s", menuroot, new_menu_path, folder, filename)
                if file_exists(folder_path) then
                    table.insert(valid_background_folders, folder)
                end
            end
            
            -- Randomly select a background folder from the filtered list
            if #valid_background_folders > 0 then
                local new_background_folder
                repeat
                    local index = math.random(#valid_background_folders)
                    new_background_folder = valid_background_folders[index]
                until new_background_folder ~= current_background_folder
                current_background_folder = new_background_folder
                previous_match_info = ctx.match_info
                log("Selected background folder: " .. current_background_folder)
            else
                log("No valid background folders found.")
            end
        end
        
        -- Use the selected background folder
			if file_exists(menuroot .. "\\" .. new_menu_path .. string.format("\\seasons\\%s\\%s", current_background_folder, filename)) then
				new_menu_path = new_menu_path .. string.format("\\seasons\\%s", current_background_folder)
				return new_menu_path .. "\\" .. filename
			end
		end
	end

            return new_menu_path .. "\\" .. filename
        end
    end
end




local function nil2str(value)
	if value ~= nil then
		return value
	else
		return "N/A"
	end
end

local function get_filepath(ctx, filename, key)
		if key and filename and filename ~= key then 
			return string.format("%s\\%s", menuroot, key)
		end
end

local function overlay_on(ctx)
    local mode = (Master_League_mode == "on") and "Master League" or "League/Cup"
    local path_display = current_path or "None"  -- Use "None" if current_path is nil
    return string.format(
        "Version: %s\nPress [9] to change mode\nMode: %s\nLast Path: %s",
        version,
        mode,
        path_display
    )
end

local function init(ctx)
    if menuroot:sub(1, 1) == '.' then
        menuroot = ctx.sider_dir .. menuroot
    end
    load_map_txt("map_competitions.txt")

    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
    ctx.register("overlay_on", overlay_on)
    ctx.register("key_down", key_down)
    ctx.register("set_teams", teams_selected)

end

return { init = init }