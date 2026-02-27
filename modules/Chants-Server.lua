--[[
Chants Server for PES 2021

Overrides original Konami chants from .awb files with randomly selected .mp3 chants from content\Chants-Server folder
 
Script cannot dictate when and/or how many times any of the chants will be played.
When PES decides to load one of its own internal chants, script will randomly select ONE custom .mp3 chant ...
... belonging to EITHER home team 

version: 1.01-fix
author: nesa, 2021
credits: zlac (overlay, disabling chants after goal is scored)

]]--

local m = {}
m.version = "1.01-fix"
local modroot = ".\\modules"
local chants_map = {}
local homefolder = nil
local     folder = nil
local chants_root = nil

local chants_list = {}
local chants_enable = false
local chants_sound
local chants_HoA = {}

local derby_list = {}

local chants_files_map = {}


-- v1.00 ..
local master_volume = 0.4
local no_chants_period = false

local info_text = ""
local RELOAD_MAPS_KEY = 0x30	-- 0 key (not the NUMPAD zero!!)
local DEL_TEXT_KEY = 0x2E		-- DEL key
local PREV_PROP_KEY = 0x21 		-- PageUp
local NEXT_PROP_KEY = 0x22 		-- PageDown
local PREV_VALUE_KEY = 0xbd 	--  - key
local NEXT_VALUE_KEY = 0xbb 	--  + key
local delta = 0
local frame_count = 0

local function tableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

local function tableInvert(T) -- swaps keys with values
   local s={}
   for k,v in pairs(T) do
     s[v]=k
   end
   return s
end

local function table_copy(t)
    local new_t = {}
    for k,v in pairs(t) do
        new_t[k] = v
    end
    return new_t
end

local function rot_left(k, v, cv)
    for i, val in pairs(table_copy(v)) do
        if v[1] ~= cv then
            -- keep rotating to the left, until current value is reached
            table.insert( v, tableLength(v), table.remove( v, 1 ) )
        else
            break
        end
    end
    -- then rotate once more, to reach next value
    table.insert( v, tableLength(v), table.remove( v, 1 ) )
    return v[1], k[v[1]]
end

local function rot_right(k, v, cv)
    for i, val in pairs(table_copy(v)) do
        if v[1] ~= cv then
            -- keep rotating to the right, until current value is reached
            table.insert( v, 1, table.remove( v, tableLength(v) ) )
        else
            break
        end
    end
    -- then rotate once more, to reach previous value
    table.insert( v, 1, table.remove( v, tableLength(v) ) )
    return v[1], k[v[1]]
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

local overlay_curr = 1
local overlay_states = {
	{ ui = "Master volume: %0.3f", prop = "master_volume", decr = -0.01, incr = 0.01, min = 0, max = 1  },
}
local ui_lines = {}
local settings = { ["master_volume"] = master_volume }
-- end v1.00

local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

local function split(s, inSplitPattern)
   local outResults = {}
   local theCommentStart = string.find( s, "#", 1 )
   local data = s
   if theCommentStart ~= nil then
      data = string.sub(s, 1, theCommentStart-1)
   end

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

local function has_value(tab, val)
    for key, value in pairs(tab) do	
		if value:find(val, 1, true) then 
			table.insert(chants_HoA, chants_root .. value)
			chants_enable = true
		end
    end
end

local function its_derby(tab, team1, team2)
    for key, value in pairs(tab) do	
		if value:find(team1, 1, true) then 
			if value:find(team2, 1, true) then 
				table.insert(chants_HoA, chants_root .. value)
				chants_enable = true
				log(string.format("****** Derbi: %s ", chants_root .. value))
			end
		end
    end
end

local function load_map_txt(filename)
    local delim = ","
    local data = assert(io.lines(filename))
    for line in data do
	   local fields = split(line, delim)
       if #fields > 1 then	      
	       if fields[1] ~= nil and fields[1] ~= "" then
	          if fields[2] ~= nil then
	      	  	 if chants_map[tonumber(fields[1])] ~= nil then
	      	  	 	table.insert(chants_map[tonumber(fields[1])], {fields[2]})
	      	  	 else
	      	  	 	chants_map[tonumber(fields[1])] = { {fields[2]} }
	      	  	 end
	      	  end
	       end
	   end
    end
end


local function load_songs_txt(filename)
    local delim = ","
    local data = assert(io.lines(filename))
    for line in data do
		table.insert(chants_list,line)
    end
end

local function load_derby_txt(filename)
    local delim = ","
    local data = assert(io.lines(filename))
    for line in data do
		table.insert(derby_list,line)
    end
end




local function checkHome(tab, val)
    for key, value in pairs(tab) do
        if val == key then		
			homefolder = value[1][1]	
			return true
		end
    end                            
	return false
end

local function check(tab, val)
    for key, value in pairs(tab) do
        if val == key then
			folder = value[1][1]  
			return true
		end
    end                            
	return false
end


function m.data_ready(ctx, filename)

	-- v1.00
	-- check for goal scoring animation (celebration, own goal, ...) and mute chant if playing ...
	if  string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_.*_owngoal_.*%.fdc") or
		string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_celebrate_.*%.fdc") 
	then
		--log("goal scored??? ")
		no_chants_period = true
		if chants_sound then
			chants_sound:fade_to(0, 1)   
			chants_sound:finish() 
		else end
	end
	
	-- re-enable chants at goal-kick, if currently disabled ...
	if no_chants_period == true and string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_.*_run_.*%.fdc") then
		no_chants_period = false
		-- log("goal_*_run related re-enabling of chants (i.e. kick off sequence has begun??)")
	end
	
	
    if no_chants_period == false then
		if string.match(filename, "common\\sound\\match\\awb\\Chant\\") and chants_enable == true and #chants_HoA > 0 then
			log("starting a chant ...")
			log("value of chants_enable: " .. tostring(chants_enable))
			chants_sound = audio.new(chants_HoA[math.random(#chants_HoA)])
			chants_sound:set_volume(master_volume)
			chants_sound:play()
			chants_enable = false
			chants_sound:when_done(function()
										chants_enable = true
									end)
		end
	end
	-- end v1.00
	
	if filename == "common\\script\\flow\\MatchMenuSub\\MatchMenuEnd.json" then
		if chants_sound then
			chants_sound:fade_to(0, 2)   
			chants_sound:finish() 
			chants_enable = true
		else end
    else end
	
	if filename == "common\\script\\flow\\Match\\MatchDiscontinue.json" then
		if chants_sound then
			chants_sound:fade_to(0, 2)
			chants_sound:finish()
			chants_enable = true
		else end
    else end
	
	if filename == "common\\script\\flow\\Match\\MatchDiscontinueTeam.json" then
		if chants_sound then
			chants_sound:fade_to(0, 2)
			chants_sound:finish()
			chants_enable = true
		else end
    else end
	
	
	if filename == "common\\menu\\general\\teamSelectMatch.bin" then
		if chants_sound then
			chants_sound:fade_to(0, 2)
			chants_sound:finish()
			chants_enable = true
		else end
    else end
	
	
end


function m.set_teams(ctx)
	chants_HoA = {}
	-- v1.00
	no_chants_period = true 
	-- end v1.00
	
	if checkHome(chants_map, ctx.home_team) then
		has_value(chants_list,homefolder)
	else
	end
	
	if checkAway(chants_map, ctx.away_team) then
		has_value(chants_list,awayfolder)
	else
	end
	
	
	its_derby(derby_list, ctx.home_team, ctx.away_team)
	--[[
	log("... in set_teams:")
	log("Vars:")
	log("=====")
	log(" -- homefolder: " .. homefolder)
	log(" -- awayfolder: " .. awayfolder)
	log(" -- chants_enable: " .. tostring(chants_enable))
	
	log("Tables:")
	log("=======")
	log("chants_list: ")
	log(dump_table(chants_list))
	log("chants_map: ")
	log(dump_table(chants_map))
	log("derby_list: ")
	log(dump_table(derby_list))
	log("chants_HoA: ")
	log(dump_table(chants_HoA))
	]]--
	
end

-- v1.00
local function apply_settings(ctx)
    -- apply volume change 
	if chants_sound then
		master_volume = tonumber(settings['master_volume'])
		chants_sound:set_volume( master_volume )
	else
		
	end
	
end

function m.key_down(ctx, vkey)
    if vkey == RELOAD_MAPS_KEY then
        log("Starting manual map file reload ... ")
        load_map_txt(ctx.sider_dir .. "content\\Chants-Server\\Chants-Server.txt")
        info_text = info_text .. "Chants-Server.txt reloaded\n"
		load_songs_txt(ctx.sider_dir .. "content\\Chants-Server\\Chants-List.txt")
		info_text = info_text .. "Chants-List.txt reloaded\n"
		load_derby_txt(ctx.sider_dir .. "content\\Chants-Server\\Derby-List.txt")
		info_text = info_text .. "Derby-List.txt reloaded\n"
        log("Manual map file reloading finished.")
    elseif vkey == DEL_TEXT_KEY then
        info_text = ""
	elseif vkey == NEXT_PROP_KEY then
        if overlay_curr < #overlay_states then
            overlay_curr = overlay_curr + 1
        end
    elseif vkey == PREV_PROP_KEY then
        if overlay_curr > 1 then
            overlay_curr = overlay_curr - 1
        end
    elseif vkey == NEXT_VALUE_KEY then
        local s = overlay_states[overlay_curr]
        if s.incr ~= nil then
            settings[s.prop] = math.min(settings[s.prop] + s.incr, s.max)
        elseif s.nextf ~= nil then
            local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
            local disp_val, conf_val = s.nextf(s.keys, s.vals, curr_disp_val)
			settings[s.prop] = conf_val
        end
        apply_settings(ctx)
    elseif vkey == PREV_VALUE_KEY then
        local s = overlay_states[overlay_curr]
        if s.decr ~= nil then
            settings[s.prop] = math.max(settings[s.prop] + s.decr, s.min)
        elseif s.prevf ~= nil then
            local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
            local disp_val, conf_val = s.prevf(s.keys, s.vals, curr_disp_val)
			settings[s.prop] = conf_val
        end
        apply_settings(ctx)
    end
end


function m.gamepad_input(ctx, inputs)
    local v = inputs["RSy"]
    if v then
        if v == -1 and overlay_curr < #overlay_states then -- moving down
            overlay_curr = overlay_curr + 1
        elseif v == 1 and overlay_curr > 1 then -- moving up
            overlay_curr = overlay_curr - 1
        end
    end

    v = inputs["RSx"]
    if v then
        if v == -1 then -- moving left
            local s = overlay_states[overlay_curr]
            if s.decr ~= nil then
                settings[s.prop] = math.max(settings[s.prop] + s.decr, s.min)
                -- set up the repeat change
                delta = s.decr
                frame_count = 0
            elseif s.prevf ~= nil then
				local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
				local disp_val, conf_val = s.prevf(s.keys, s.vals, curr_disp_val)
				settings[s.prop] = conf_val
            end
            apply_settings(ctx) -- apply
        elseif v == 1 then -- moving right
            local s = overlay_states[overlay_curr]
            if s.decr ~= nil then
                settings[s.prop] = math.min(settings[s.prop] + s.incr, s.max)
                -- set up the repeat change
                delta = s.incr
                frame_count = 0
            elseif s.nextf ~= nil then
				local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
				local disp_val, conf_val = s.nextf(s.keys, s.vals, curr_disp_val)
				settings[s.prop] = conf_val
            end
            apply_settings(ctx) -- apply
        elseif v == 0 then -- stop change
            delta = 0
            apply_settings(ctx) -- apply
        end
    end
end

local function repeat_change(ctx, after_num_frames, change)
    if change ~= 0 then
        frame_count = frame_count + 1
        if frame_count >= after_num_frames then
            local s = overlay_states[overlay_curr]
			settings[s.prop] = math.min(math.max(s.min, settings[s.prop] + change), s.max)
            apply_settings(ctx) -- apply
        end
    end
end

function m.overlay_on(ctx)
	-- repeat change from gamepad, if delta exists
    repeat_change(ctx, 30, delta)
    -- construct ui text
    for i,v in ipairs(overlay_states) do
        local s = overlay_states[i]
        if i == overlay_curr then
			if s.incr ~= nil then
				ui_lines[i] = string.format("\n---> %s <---", string.format(s.ui, settings[s.prop]))
			elseif s.nextf ~= nil then
				local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
				ui_lines[i] = string.format("\n---> %s <---", string.format(s.ui, curr_disp_val))
			end
        else
			if s.incr ~= nil then
				ui_lines[i] = string.format("\n     %s", string.format(s.ui, settings[s.prop]))
			elseif s.nextf ~= nil then
				local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
				ui_lines[i] = string.format("\n     %s", string.format(s.ui, curr_disp_val))
			end
        end
    end
    return string.format([[version %s
Press [0] to reload map .txt files
Press [DEL] to clear info messages
	
Keys: [PageUp][PageDown] - choose setting, [-][+] - modify value
Gamepad: RS up/down - choose setting, RS left/right - modify value
%s

%s]], m.version, table.concat(ui_lines), info_text)
end

-- end v1.00


function m.init(ctx)

    chants_root = ctx.sider_dir .. "content\\Chants-Server\\" 
	load_map_txt(ctx.sider_dir .. "content\\Chants-Server\\Chants-Server.txt")
	load_songs_txt(ctx.sider_dir .. "content\\Chants-Server\\Chants-List.txt")
	load_derby_txt(ctx.sider_dir .. "content\\Chants-Server\\Derby-List.txt")
    ctx.register("livecpk_data_ready", m.data_ready)
	ctx.register("set_teams", m.set_teams)
	ctx.register("overlay_on", m.overlay_on)
	ctx.register("key_down", m.key_down)
    ctx.register("gamepad_input", m.gamepad_input)
end

return m
