--[[
Goalsong server for PES 2020: plays the goal song of the home teams when they score
Custom content is used, not LiveCPK/game: content\goalsong-server is the root
author: zlac, 2020
version: 1.00
originally posted on evo-web
credits: juce, for always having good tips and advices


This script uses "match" library, to detect which team scored the goal - either home or away.
IMPORTANT: the lib is still experimental, so it is disabled by default.
To enable, you need to have this line in your sider.ini:

match-stats.enabled = 1

--]]

local m = {}
m.version = "1.0"
local hex = memory.hex

local gsroot = ".\\content\\goalsong-server"
local settings

local team_assignment_map = {}
local competition_assignment_map = {}
local random_num
local comp_both_teams_songs = {
		105,	-- ICC
		106,	-- ICC
		107,	-- ICC
	}

local curr_home_score = 0
local curr_away_score = 0
local who_scored
local score_changed = false
local msg = ""

local goal_song
local goal_songs = {}
local dont_start2 = false
local default_volume = 0.4

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

local overlay_curr = 1
local overlay_states = {
	{ ui = "Master volume: %0.3f", prop = "master_volume", decr = -0.01, incr = 0.01, min = 0, max = 1  },
    { ui = "Stop on replays: %s", prop = "stop_on_replays", vals = {"On", "Off"}, keys = {["On"] = 1, ["Off"] = 0},
        nextf = rot_left,
        prevf = rot_right,
    },
}
local ui_lines = {}



-- misc #2
-- remove trailing and leading whitespace from string
local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

local function get_common_lib(ctx)
    return ctx.common_lib or _empty
end

local function file_exists(filename)
    local f = io.open(filename)
    if f then
        f:close()
        return true
    end
end

local function nil2str(value)
	if value ~= nil then
		return value
	else
		return "N/A"
	end
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

local function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then 
		io.close(f) 
		return true 
	else 
		return false 
	end
end

local function load_map_txt(filename)
    local delim = ","
    local data = assert(io.lines(gsroot .. "\\" .. filename))
    log(filename .. " found in " .. gsroot)

    if filename == "map_teams.txt" then
		log("clear map_team")
        clear_table(team_assignment_map)
    end
	
	if filename == "map_competitions.txt" then
		log("clear map comp")
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
				if filename == "map_teams.txt" and fields[2] ~= nil and fields[3] ~= nil then
					fields[3] = math.min(math.max(-1, tonumber(fields[3]) or 0), 1) -- clamp to -1 <= x <= 1 interval or default with 0
					if team_assignment_map[tonumber(fields[1])] ~= nil then
						table.insert(team_assignment_map[tonumber(fields[1])], {fields[2], fields[3]})
					else
						team_assignment_map[tonumber(fields[1])] = { {fields[2], fields[3]} }
					end
					log(string.format(" ==> %s goalsong assignment (team)::   %s: %s, volume correction: %s", filename, fields[1], fields[2], fields[3]))
				end
				
				if filename == "map_competitions.txt" and fields[2] ~= nil and fields[3] ~= nil and fields[4] ~= nil then
					fields[3] = math.min(math.max(-1, tonumber(fields[3]) or 0), 1) -- clamp to -1 <= x <= 1 interval or default with 0
					if competition_assignment_map[tonumber(fields[1])] ~= nil then
						table.insert(competition_assignment_map[tonumber(fields[1])], {fields[2], tonumber(fields[3]), tonumber(fields[4])})
					else
						competition_assignment_map[tonumber(fields[1])] = { {fields[2], tonumber(fields[3]), tonumber(fields[4])} }
					end
					log(string.format(" ==> %s goalsong assignment (competition)::   %s: %s, volume correction: %s, exclusivity: %s ", filename, fields[1], fields[2], fields[3], fields[4]))
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
-- end misc #2


-- .ini file
local function load_ini(filename)
    local t = {}
	local data = assert(io.lines(gsroot .. "\\" .. filename))
	log(filename .. " found in " .. gsroot)

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
    local f = io.open(gsroot .. "\\" .. filename, "wt")
    f:write(string.format("# GoalSongServer settings. Generated by GoalSongServer.lua\n"))
    f:write("\n")
    local keys = {}
    for name,value in pairs(settings) do
		if name ~= 'corrected_volume' and name ~= 'volume_correction' then -- don't save 'corrected_volume' or 'volume_correction'
			keys[#keys + 1] = name
		end
    end
    table.sort(keys)
    for i,name in ipairs(keys) do
        local value = settings[name]
        f:write(string.format("%s = %s\n", name, value))
    end
    f:write("\n")
    f:close()
end
-- end .ini file



function m.teams_selected(ctx, home_team_id, away_team_id)
	curr_home_score = 0
	curr_away_score = 0
	msg = ""
end

local function process_matchstats(ctx, filename)
	local stats = match.stats()
	if stats then
		if stats.home_score > curr_home_score then 
			curr_home_score = curr_home_score + 1
			who_scored = "home team"
			score_changed = true
		elseif stats.away_score > curr_away_score then
			curr_away_score = curr_away_score + 1
			who_scored = "away team"
			score_changed = true
		else
			score_changed = false
		end
		
		if score_changed == true then
			msg = msg .. string.format("\n (curr_home_score: %d) (curr_away_score: %d) %s scored ", curr_home_score, curr_away_score, who_scored)
			log("Score change: " .. msg)
			log("Triggered by loaded file: " .. filename)
			local tid = tonumber(ctx.tournament_id)
			
			-- specifics 
			--- a) competitions with official goal songs, exclusive (one for all teams) or non-exclusive (tournament song followed by team song) - UEFA EURO, FIFA WC
			--- b) competitions where goal songs are played for both teams, no official tournament song - ICC
			--- c) everything else - goal song plays only when home team scores
			
			--- a)
			if competition_assignment_map[tid] and stats.period < 5 then  -- 5 = penalty shootout
				random_num = nil
				if #competition_assignment_map[tid] == 1 then
					random_num = 1
				else
					random_num = math.random(#competition_assignment_map[tid])
				end				
				log("Selecting random goal song for competition ID " .. tostring(tid) .. ": Goal song no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " goal songs(s) available)")
				--- a1) exclusive song
				if random_num and competition_assignment_map[tid][random_num][3] == 1 and competition_assignment_map[tid][random_num][1] ~= nil then
					log("Competition-exclusive song playing ... compID: " .. tid)
					goal_song = audio.new(gsroot .. string.format("\\%s", competition_assignment_map[tid][random_num][1]))
					local volume_corr = competition_assignment_map[tid][random_num][2] or 0
					settings['volume_correction'] = volume_corr
					settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr
					log("volume: " .. settings['corrected_volume'])
					goal_song:set_volume(settings['corrected_volume'])
					goal_song:play()
					goal_song:when_done(function(ctx)
						goal_song = nil
					end)
				--- a2) non-exclusive song - competition song first, then either home or away team's song
				elseif random_num and competition_assignment_map[tid][random_num][3] == 0 and competition_assignment_map[tid][random_num][1] ~= nil then
					dont_start2 = false
					local comp_song_path = competition_assignment_map[tid][random_num][1]
					local team_song_path = nil
					local random_num_team = nil
					local volume_corr_comp = competition_assignment_map[tid][random_num][2] or 0
					log("vol corr competition_assignment_map[tid][random_num][4]: " .. competition_assignment_map[tid][random_num][2])
					log("vol corr competition_assignment_map[tid][random_num][4] or 0: " .. competition_assignment_map[tid][random_num][2] or 0)
					local volume_corr_team = 0
					if who_scored == "home team" then
						if team_assignment_map[ctx.home_team] ~= nil then
							if #team_assignment_map[ctx.home_team] == 1 then
								random_num_team = 1
							else
								random_num_team = math.random(#team_assignment_map[ctx.home_team])
							end
							log("Selecting random goal song for a team: Goal song no. " .. tostring(random_num_team) .. " (from " .. tostring(#team_assignment_map[ctx.home_team]) .. " goal songs(s) available)")
							team_song_path = team_assignment_map[ctx.home_team][random_num_team][1]
							volume_corr_team = team_assignment_map[ctx.home_team][random_num_team][2] or 0
						end
					elseif who_scored == "away team" then
						if team_assignment_map[ctx.away_team] ~= nil then
							if #team_assignment_map[ctx.away_team] == 1 then
								random_num_team = 1
							else
								random_num_team = math.random(#team_assignment_map[ctx.away_team])
							end
							log("Selecting random goal song for away team: Goal song no. " .. tostring(random_num_team) .. " (from " .. tostring(#team_assignment_map[ctx.away_team]) .. " goal songs(s) available)")
							team_song_path = team_assignment_map[ctx.away_team][random_num_team][1]
							volume_corr_team = team_assignment_map[ctx.away_team][random_num_team][2] or 0
						end
					end
					--- data collected, now let's create a sequence of songs ...
					if team_song_path == nil and comp_song_path ~= nil then
						-- only comp song to play, no sequence here ...
						log("Competition song playing (team songs not found) ... compID: " .. tid)
						goal_song = audio.new(gsroot .. string.format("\\%s", competition_assignment_map[tid][random_num][1]))
						settings['volume_correction'] = volume_corr_comp
						settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_comp
						log("volume: " .. settings['corrected_volume'])
						goal_song:set_volume(settings['corrected_volume'])
						goal_song:play()
						goal_song:when_done(function(ctx)
							goal_song = nil
						end)
					elseif team_song_path ~= nil and comp_song_path ~= nil then
						-- comp first, team to follow
						log("Competition song playing first (team song to follow) ... compID: " .. tid)
						local gs1 = audio.new(gsroot .. string.format("\\%s", comp_song_path))
						goal_songs['gs1'] = {gs1, true}
						settings['volume_correction'] = volume_corr_comp
						settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_comp
						log("volume (comp): " .. settings['corrected_volume'])
						gs1:set_volume(settings['corrected_volume'])
						gs1:play()
						gs1:when_done(function(ctx)
							goal_songs['gs1'] = nil
							if dont_start2 == false then
								local gs2 = audio.new(gsroot .. string.format("\\%s", team_song_path))
								goal_songs['gs2'] = {gs2, true}
								gs2:when_done(function(ctx)
									goal_songs['gs2'] = nil
								end)
								settings['volume_correction'] = volume_corr_team
								settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_team
								log("volume (team followup): " .. settings['corrected_volume'])
								gs2:set_volume(settings['corrected_volume'])
								gs2:play()
							end
							--goal_song = nil
						end)
					end
				
				end
			--- b)
			elseif has_value(comp_both_teams_songs, tid) == true and stats.period < 5 then  -- 5 = penalty shootout
				random_num = nil
				local volume_corr_team = 0
				if who_scored == "home team" then
					if team_assignment_map[ctx.home_team] ~= nil then
						if #team_assignment_map[ctx.home_team] == 1 then
							random_num = 1
						else
							random_num = math.random(#team_assignment_map[ctx.home_team])
						end
						volume_corr_team = team_assignment_map[ctx.home_team][random_num][2] or 0
						log("Selecting random goal song for a team: Goal song no. " .. tostring(random_num) .. " (from " .. tostring(#team_assignment_map[ctx.home_team]) .. " goal songs(s) available)")
					
						if team_assignment_map[ctx.home_team][random_num][1] ~= nil then
							goal_song = audio.new(gsroot .. string.format("\\%s", team_assignment_map[ctx.home_team][random_num][1]))
							settings['volume_correction'] = volume_corr_team
							settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_team
							log("volume: " .. settings['corrected_volume'])
							goal_song:set_volume(settings['corrected_volume'])
							goal_song:play()
							goal_song:when_done(function(ctx)
								goal_song = nil
							end)
						end
					end
				elseif who_scored == "away team" then
					if team_assignment_map[ctx.away_team] ~= nil then
						if #team_assignment_map[ctx.away_team] == 1 then
							random_num = 1
						else
							random_num = math.random(#team_assignment_map[ctx.away_team])
						end
						volume_corr_team = team_assignment_map[ctx.away_team][random_num][2] or 0
						log("Selecting random goal song for away team: Goal song no. " .. tostring(random_num) .. " (from " .. tostring(#team_assignment_map[ctx.away_team]) .. " goal songs(s) available)")
					
						if team_assignment_map[ctx.away_team][random_num][1] ~= nil then
							goal_song = audio.new(gsroot .. string.format("\\%s", team_assignment_map[ctx.away_team][random_num][1]))
							settings['volume_correction'] = volume_corr_team
							settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_team
							log("volume: " .. settings['corrected_volume'])
							goal_song:set_volume(settings['corrected_volume'])
							goal_song:play()
							goal_song:when_done(function(ctx)
								goal_song = nil
							end)
						end
					end	
				end
			--- c)
			elseif who_scored == "home team" and stats.period < 5 then  -- 5 = penalty shootout
				random_num = nil
				local volume_corr_team = 0
				if team_assignment_map[ctx.home_team] ~= nil then
					if #team_assignment_map[ctx.home_team] == 1 then
						random_num = 1
					else
						random_num = math.random(#team_assignment_map[ctx.home_team])
					end
					volume_corr_team = team_assignment_map[ctx.home_team][random_num][2] or 0
					log("Selecting random goal song: Goal song no. " .. tostring(random_num) .. " (from " .. tostring(#team_assignment_map[ctx.home_team]) .. " goal songs(s) available)")
				
					if team_assignment_map[ctx.home_team][random_num][1] ~= nil then
						goal_song = audio.new(gsroot .. string.format("\\%s", team_assignment_map[ctx.home_team][random_num][1]))
						settings['volume_correction'] = volume_corr_team
						settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + volume_corr_team
						log("volume: " .. settings['corrected_volume'])
						goal_song:set_volume(settings['corrected_volume'])
						goal_song:play()
						goal_song:when_done(function(ctx)
							goal_song = nil
						end)
					end
				end	
			end
		end
		
		
	end
end

function m.data_ready(ctx, filename)
	-- catch-all stats processing
	process_matchstats(ctx, filename)
	
	if filename == "common\\script\\flow\\Match\\MatchSetupRematch.json" then
		-- log("Rematch detected ... ")
		curr_home_score = 0
		curr_away_score = 0
	end
	
	if settings['stop_on_replays'] == 1 and string.match(filename, "Asset\\model\\ball\\ball%d+\\#Win\\ball%.fpk") then
		if goal_song then
			log("goal_song ending, game loaded: " .. filename)
			log(string.format("goal_song finishing: %s", goal_song:get_filename()))
			goal_song:fade_to(0, 2)
			goal_song:finish()
			goal_song = nil
		else
			if goal_songs['gs1'] then
				goal_songs['gs1'][1]:fade_to(0, 2)
				dont_start2 = true
				goal_songs['gs1'][1]:finish()
			elseif goal_songs['gs2'] then
				goal_songs['gs2'][1]:fade_to(0, 2)
				goal_songs['gs2'][1]:finish()
			end
		end
	end
	
	if string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_hug_run_aim.*") or 
				filename == "common\\script\\flow\\Match\\MatchPrePause.json" or
				filename == "common\\script\\flow\\Match\\MatchDiscontinue.json" or 
				filename == "common\\script\\flow\\Match\\MatchDiscontinueTeam.json" or
				filename == "common\\script\\flow\\Match\\MatchEnd.json" or
				filename == "common\\script\\flow\\Match\\MatchStatsResult.json" then
		if goal_song then
			log("goal_song ending, game loaded: " .. filename)
			log(string.format("goal_song finishing: %s", goal_song:get_filename()))
			goal_song:fade_to(0, 2)
			goal_song:finish()
			goal_song = nil
		else
			if goal_songs['gs1'] then
				goal_songs['gs1'][1]:fade_to(0, 2)
				dont_start2 = true
				goal_songs['gs1'][1]:finish()
			elseif goal_songs['gs2'] then
				goal_songs['gs2'][1]:fade_to(0, 2)
				goal_songs['gs2'][1]:finish()
			end

		end
	end
end

local function apply_settings(ctx, log_it, save_it)
    -- apply master volume change 
	if goal_song then
		-- log("apply (goal_song): tonumber(settings['corrected_volume'] or 0): " .. tonumber(settings['corrected_volume'] or 0))
		goal_song:set_volume((tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0) )
		settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0)
		-- log("new settings['corrected_volume']: (goal_song) " .. settings['corrected_volume'])
	else
		if goal_songs['gs1'] then
			-- log("apply (gs1): tonumber(settings['corrected_volume'] or 0): " .. tonumber(settings['corrected_volume'] or 0))
			goal_songs['gs1'][1]:set_volume((tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0) )
			settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0)
			-- log("new settings['corrected_volume']: (gs1) " .. settings['corrected_volume'])
		end
		if goal_songs['gs2'] then
			-- log("apply (gs2): tonumber(settings['corrected_volume'] or 0): " .. tonumber(settings['corrected_volume'] or 0))
			goal_songs['gs2'][1]:set_volume((tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0) )
			settings['corrected_volume'] = (tonumber(settings['master_volume']) or default_volume) + (tonumber(settings['volume_correction']) or 0)
			-- log("new settings['corrected_volume']: (gs2) " .. settings['corrected_volume'])
		end
	end
	
	if save_it then
        save_ini("config.ini")
    end
end

function m.key_down(ctx, vkey)
    if vkey == RELOAD_MAPS_KEY then
        log("Starting manual map file reload ... ")
        load_map_txt("map_teams.txt")
        info_text = info_text .. "map_teams.txt reloaded\n"
		load_map_txt("map_competitions.txt")
		info_text = info_text .. "map_competitions.txt reloaded\n"
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
        apply_settings(ctx, false, true)
    elseif vkey == PREV_VALUE_KEY then
        local s = overlay_states[overlay_curr]
        if s.decr ~= nil then
            settings[s.prop] = math.max(settings[s.prop] + s.decr, s.min)
        elseif s.prevf ~= nil then
            local curr_disp_val = tableInvert(s.keys)[settings[s.prop]]
            local disp_val, conf_val = s.prevf(s.keys, s.vals, curr_disp_val)
			settings[s.prop] = conf_val
        end
        apply_settings(ctx, false, true)
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
            apply_settings(ctx, false, false) -- apply
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
            apply_settings(ctx, false, false) -- apply
        elseif v == 0 then -- stop change
            delta = 0
            apply_settings(ctx, false, true) -- apply and save
        end
    end
end

local function repeat_change(ctx, after_num_frames, change)
    if change ~= 0 then
        frame_count = frame_count + 1
        if frame_count >= after_num_frames then
            local s = overlay_states[overlay_curr]
			settings[s.prop] = math.min(math.max(s.min, settings[s.prop] + change), s.max)
            apply_settings(ctx, false, false) -- apply
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

function m.init(ctx)
	if gsroot:sub(1,1)=='.' then
        gsroot = ctx.sider_dir .. gsroot
    end
	math.randomseed(os.time())
	settings = load_ini("config.ini")
	load_map_txt("map_teams.txt")
	load_map_txt("map_competitions.txt")
	
    ctx.register("overlay_on", m.overlay_on)
	ctx.register("set_teams", m.teams_selected)
	ctx.register("livecpk_data_ready", m.data_ready)
	ctx.register("key_down", m.key_down)
    ctx.register("gamepad_input", m.gamepad_input)
end

return m
