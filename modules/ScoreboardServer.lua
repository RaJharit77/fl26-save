-- Scoreboard server for PES 2020/2021: assign the scoreboard manually or based on the competition mode
-- Custom content is used, not LiveCPK/game: content\scoreboard-server is the root
-- author: zlac, 2018-2022
-- exrtra credits: juce, predator002
-- version: 1.40
-- originally posted on evo-web

local sbroot = ".\\content\\scoreboard-server"
local version = "1.40"
local random_num
local settings
local _empty = {}

local competition_assignment_map = {}
local all_sb_map = {}

local info_text = ""
local manual_sb_idx
local manual_sb_info = "Manually selected scoreboard: None"
local manual_selection_status = "Off"
local manual_selection_status_info = "Selection mode: automatic map assignments"
local total_scoreboards

local _sb_info = {}
local current_sb_preview_path

local exhib_same_league_tid

local intro_anthem
local past_kickoff

local fg_clr_home, fg_clr_away
-- EDITABLE VALUE:
local luma_margin = 150  -- lowered from default 165
-- END EDITABLE VALUE

local RELOAD_MAPS_KEY = 0x30 -- 0 key (not the NUMPAD zero!!)
local SET_AS_FAVORITE_SB_KEY = 0x37 -- 7 key (not the NUMPAD 7!!)
local USE_FAVORITE_SB_KEY = 0x38 -- 8 key (not the NUMPAD 8!!)
local SWITCH_SELECTION_MODE_KEY = 0x39 -- 9 key (not the NUMPAD 9!!)
local DEL_TEXT_KEY = 0x2E
local PREVIOUS_SB_KEY = 0x21 -- Page Up
local NEXT_SB_KEY = 0x22 -- Page Down


-- remove trailing and leading whitespace from string
local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

local function tableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

local function get_common_lib(ctx)
    return ctx.common_lib or _empty
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
    local data = assert(io.lines(sbroot .. "\\" .. filename))
    log(filename .. " found in " .. sbroot)

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
                     log(string.format(" ==> %s scoreboard assignment::   %s: %s ", filename, fields[1], fields[2]))
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

local function compare_sb_names(a,b)
  return a[1] < b[1] -- only one string item passed in {} - sb name, compare names
end

local function merge_maps()
    local idx = 1
    clear_table(all_sb_map)

    for key, value in pairs(competition_assignment_map) do
        for index, row in pairs(value) do
            if row[1] ~= nil and row[1] ~= "" and not valueArrayExistsInTable(all_sb_map, row, 1) then
                all_sb_map[idx] = {row[1]}
                idx = idx + 1
            end
        end
    end

    total_scoreboards = #all_sb_map
    if total_scoreboards > 0 then
        manual_sb_idx = 1
    end
    log(string.format("%s unique scoreboards available for manual selection.", total_scoreboards))
    -- log(dump_table(all_sb_map))
    table.sort(all_sb_map, compare_sb_names)
    -- log(dump_table(all_sb_map))
end


local function is_it_scoreboard_file(filename)
    filename = string.lower(filename)
    if
       string.match(filename, "common\\menu") or
       string.match(filename, "common\\render\\symbol\\flag") or
       string.match(filename, "movie\\fade")
    then
          return true
    else
          return false
    end
end


local function get_sb_preview_path(sb_info)
    if sb_info then
        local sb_prefix = sb_info[1]
        if sb_prefix and file_exists(string.format("%s\\%s\\preview.dds", sbroot, sb_prefix)) then
            return string.format("%s\\%s\\preview.dds", sbroot, sb_prefix)
        end
    end
end


local function get_new_sb_path(ctx)
    local tid = tonumber(ctx.tournament_id)
    local sb_path

    if tid then
        if manual_selection_status == "On" and manual_sb_idx then
            -- manual selection from overlay trumps everything
            -- sb_path = all_sb_map[manual_sb_idx][2]
            sb_path = all_sb_map[manual_sb_idx][1]
        elseif exhib_same_league_tid and competition_assignment_map[exhib_same_league_tid] ~= nil and random_num ~= nil then
            sb_path = competition_assignment_map[exhib_same_league_tid][random_num][1]
        elseif competition_assignment_map[tid] ~= nil and random_num ~= nil then
            sb_path = competition_assignment_map[tid][random_num][1]  -- use the scoreboard assigned for this competition
        end
    end

    if sb_path and manual_selection_status == "Off" then
        manual_selection_status_info = string.format("Selection mode: automatic map assignments (using scoreboard: %s)", sb_path)
    elseif manual_selection_status == "Off" then
        manual_selection_status_info = string.format("Selection mode: automatic map assignments (using scoreboard: %s)", "No scoreboard(s) assigned to this competition")
    end
    
    if sb_path then
        _sb_info[1] = sb_path
        current_sb_preview_path = get_sb_preview_path(_sb_info)
    end
    
    return sb_path
end


local function teams_selected(ctx, home_team_id, away_team_id)
    --whenever game selects new home_team, pick a random index of a scoreboard to be used in selected competition (e.g. if multiple scoreboards are assigned to one competition_ID)
    local tid = tonumber(ctx.tournament_id)
    random_num = nil
    exhib_same_league_tid = nil
    fg_clr_home = nil
    fg_clr_away = nil
    past_kickoff = false
    
    if manual_selection_status == "Off" then
        _sb_info[1] = nil
        current_sb_preview_path = nil
    end


    if tid == 65535 then
        -- are both teams in exhibition mode from the same playable league?
        log("Checking if both teams in exhibition belong to the same league ... ")
        exhib_same_league_tid = get_common_lib(ctx).tid_same_league(home_team_id, away_team_id)
        
        if exhib_same_league_tid ~= nil then
            log("... they do!")
            log("... mapped TournamentID for exhibition mode: " .. exhib_same_league_tid )
            if competition_assignment_map[exhib_same_league_tid] ~= nil then
                log(string.format("... competition with ID %s has %s scoreboards assigned.", exhib_same_league_tid, #competition_assignment_map[exhib_same_league_tid]))
                if #competition_assignment_map[exhib_same_league_tid] == 1 then
                    -- if there's only one scoreboard assigned to competition, set "random" number to 1
                    -- do the same if replay mode is active - tid is not reliably available, so assume there's only 1 scoreboard available
                    random_num = 1
                else
                    -- if there are more scoreboards, select one index rendomly
                    -- random_num = math.random(1, #competition_assignment_map[tid])
                    random_num = math.random(#competition_assignment_map[exhib_same_league_tid])
                end
                log("Selecting random scoreboard for competition ID " .. tostring(exhib_same_league_tid) .. " in exhibition mode (both teams belong to the same league): Scoreboard no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[exhib_same_league_tid]) .. " scoreboard(s) available)")
            else
                log(string.format("... competition with ID %s has no scoreboards assigned.", exhib_same_league_tid))
                -- since the mapped competition does not have its own scoreboards, revert to default exhibition mode random selection
                if competition_assignment_map[tid] ~= nil then
                    if #competition_assignment_map[tid] == 1 then
                        random_num = 1
                    else
                        random_num = math.random(#competition_assignment_map[tid])
                    end
                    log("Selecting random scoreboard for exhibition mode: Scoreboard no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " scoreboard(s) available)")
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
                log("Selecting random scoreboard for exhibition mode: Scoreboard no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " scoreboard(s) available)")
            end
        end
    --
    elseif competition_assignment_map[tid] ~= nil and manual_selection_status == "Off" then
        -- if #competition_assignment_map[tid] == 1 or ctx.is_replay_gallery == true then
        if #competition_assignment_map[tid] == 1 then
            random_num = 1
        else
            random_num = math.random(#competition_assignment_map[tid])
        end
        log("Selecting random scoreboard for competition ID " .. tostring(tid) .. ": Scoreboard no. " .. tostring(random_num) .. " (from " .. tostring(#competition_assignment_map[tid]) .. " scoreboard(s) available)")
    end

    if tid == 65535 then
        -- in Exhibition mode, we can update scoreboard info in overlay
        get_new_sb_path(ctx)
    end

end


local function make_key(ctx, filename)
    -- if ctx.is_edit_mode == nil then -- do something only if edit mode is NOT active
        -- local sb_fname = which_scoreboard(filename)
        if is_it_scoreboard_file(filename) then
              -- log(string.format("Into make_key (scoreboard file) ... (%s)", filename))
            local new_sb_path = get_new_sb_path(ctx)
            if new_sb_path then
                -- log("Into make_key (scoreboard file): " .. new_sb_path .. "\\" .. filename)
                -- adjust new_sb_path to include contrast-color files, if available ...
                if fg_clr_home and fg_clr_away then
                    if file_exists(sbroot .. "\\" .. new_sb_path .. string.format("\\contrast_names_teams\\%s\\%s\\%s_%s\\%s", ctx.home_team, ctx.away_team, fg_clr_home, fg_clr_away, filename)) then
                        new_sb_path = new_sb_path .. string.format("\\contrast_names_teams\\%s\\%s\\%s_%s", ctx.home_team, ctx.away_team, fg_clr_home, fg_clr_away)
						-- log("contrast_names_teams: " .. new_sb_path .. "\\" .. filename)
                    elseif file_exists(sbroot .. "\\" .. new_sb_path .. string.format("\\contrast_names\\%s_%s\\%s", fg_clr_home, fg_clr_away, filename)) then
                        new_sb_path = new_sb_path .. string.format("\\contrast_names\\%s_%s", fg_clr_home, fg_clr_away) 
						-- log("contrast_names: " .. new_sb_path .. "\\" .. filename)
                    end
                end
                return new_sb_path .. "\\" .. filename
            end
        end

    -- end
end

local function get_filepath(ctx, filename, key)
    -- log(string.format("Into get_filepath ... (%s, %s)", filename, key))
    -- if ctx.is_edit_mode == nil then -- do something only if edit mode is NOT active
        -- if new_sb_path then
        if key and filename and filename ~= key then -- filename ~= key shoud ensure that it really is a file from custom repository, with modified path prefix???
            -- log(string.format("Scoreboard file assignment for competition ID %s - %s\\%s", nil2str(ctx.tournament_id), sbroot, key))
            -- log(string.format("%s\\%s", sbroot, key))
            return string.format("%s\\%s", sbroot, key)
        end
    -- end
end


local opts = { image_width = 0.15, image_hmargin = 0, image_vmargin = 10 }
local function overlay_on(ctx)
    local text = string.format("version %s\nScoreboardServer commands:\nPress [0] to reload map .txt files\nPress [DEL] to clear info messages\nPress [9] to switch between using map assignments/manual selection\n     Manual selection mode subcommands:\n       [PageUp][PageDn] to manually select previous/next scoreboard\n       [7] to set current manual selection as favorite scoreboard\n       [8] to use your favorite scoreboard \n\n%s\n%s\n\n%s", version, manual_selection_status_info, manual_sb_info, info_text)
    local image = current_sb_preview_path
    return text, image, opts
end

local function load_ini(filename)
    local t = {}
    local data = assert(io.lines(sbroot .. "\\" .. filename))
    log(filename .. " found in " .. sbroot)

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
    local f = io.open(sbroot .. "\\" .. filename, "wt")
    f:write(string.format("# ScoreboardServer settings. Generated by ScoreboardServer.lua\n"))
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
        manual_sb_idx = nil
        manual_sb_info = "Manually selected scoreboard: None"
        if total_scoreboards > 0 then
            manual_sb_idx = 1
        end
        info_text = info_text .. "map_competitions.txt reloaded\n"
        log("Manual map files reloading finished.")
    elseif vkey == DEL_TEXT_KEY then
        info_text = ""
    elseif vkey == SWITCH_SELECTION_MODE_KEY then
        if manual_selection_status == "Off" then
            manual_selection_status = "On"
            manual_selection_status_info = "Selection mode: manual selection [PageUp]/[PageDn]"
            manual_sb_info = string.format("Manually selected scoreboard: %s\n", all_sb_map[manual_sb_idx][1])
            current_sb_preview_path = get_sb_preview_path(all_sb_map[manual_sb_idx])
        else
            manual_selection_status = "Off"
            manual_selection_status_info = "Selection mode: automatic map assignments"
            manual_sb_info = string.format("Manually selected scoreboard: None")
            current_sb_preview_path = nil
            info_text = ""
        end
    elseif vkey == PREVIOUS_SB_KEY then
        -- log("PageUp")
        -- log(manual_selection_status .. " " .. total_scoreboards .. " " .. nil2str(manual_sb_idx))
        if manual_selection_status == "On" and total_scoreboards > 0 and manual_sb_idx then
            manual_sb_idx = manual_sb_idx - 1
            if manual_sb_idx < 1 then
                manual_sb_idx = total_scoreboards
            end
            manual_sb_info = string.format("Manually selected scoreboard: %s\n", all_sb_map[manual_sb_idx][1])
            current_sb_preview_path = get_sb_preview_path(all_sb_map[manual_sb_idx])
        end
    elseif vkey == NEXT_SB_KEY then
        -- log("PageDn")
        -- log(manual_selection_status .. " " .. total_scoreboards .. " " .. nil2str(manual_sb_idx))
        if manual_selection_status == "On" and total_scoreboards > 0 and manual_sb_idx then
            manual_sb_idx = manual_sb_idx + 1
            if manual_sb_idx > total_scoreboards then
                manual_sb_idx = 1
            end
            manual_sb_info = string.format("Manually selected scoreboard: %s\n", all_sb_map[manual_sb_idx][1])
            current_sb_preview_path = get_sb_preview_path(all_sb_map[manual_sb_idx])
        end
    elseif vkey == SET_AS_FAVORITE_SB_KEY then
        if manual_selection_status == "On" and manual_sb_idx then
            if all_sb_map[manual_sb_idx] then
                settings["favorite_scoreboard"] = manual_sb_idx
                save_ini("config.ini")
                info_text = info_text .. string.format("Scoreboard %s saved as favorite\n", all_sb_map[manual_sb_idx][1])
            else
                info_text = info_text .. "Could not save favorite scoreboard\n"
            end
        end
    elseif vkey == USE_FAVORITE_SB_KEY then
        if manual_selection_status == "On" and settings["favorite_scoreboard"] then
            if all_sb_map[tonumber(settings["favorite_scoreboard"])] then
                manual_sb_idx = settings["favorite_scoreboard"]
                manual_sb_info = string.format("Manually selected scoreboard: %s\n", all_sb_map[manual_sb_idx][1])
                info_text = info_text .. string.format("Favorite scoreboard %s set as active\n", all_sb_map[manual_sb_idx][1])
                current_sb_preview_path = get_sb_preview_path(all_sb_map[manual_sb_idx])
            else
                info_text = info_text .. string.format("Could not find favorite scoreboard (idx: %s)\n", settings["favorite_scoreboard"])
            end
        end
    end
end

local function calculate_luma(clr)
    -- credits to: https://stackoverflow.com/a/6511606
    local R = clr:sub(2, 3)
    local G = clr:sub(4, 5)
    local B = clr:sub(6, 7)
    -- log(string.format("R: %s, G: %s, B: %s", R, G, B))
    
    return 0.2126 * tonumber(R, 16) + 0.7152 * tonumber(G, 16) + 0.0722 * tonumber(B, 16) -- SMPTE C, Rec. 709 weightings
end

local function after_set_conditions(ctx)
    -- final update of scoreboard preview in overlay
    local sb_path = get_new_sb_path(ctx)
    if sb_path then
        -- add info about selected scoreboard to context ... may be useful to retrieve it somewhere else
        ctx.scoreboard_server = {['active_scoreboard'] = sb_path}
        log(string.format("Scoreboard assigned: %s", sb_path))
        
        -- determine unicolor values for selected home and away kits
        -- ... for scoreboards that use dynamic background plates for team names and need to adapt to contrasting colors for team abbreviations/names
        -- 
        local bg_clr_home, bg_clr_away        
        local home_cfg = ctx.kits.get(ctx.home_team, ctx.kits.get_current_kit_id(0))
        local away_cfg = ctx.kits.get(ctx.away_team, ctx.kits.get_current_kit_id(1))
        if home_cfg then
            bg_clr_home = home_cfg.UniColor_Color1 or home_cfg.ShirtColor1
            log(string.format("home color: %s", bg_clr_home))
            local uni1_luma = calculate_luma(bg_clr_home)
            if uni1_luma >= luma_margin then
                -- bright background ...
                fg_clr_home = "DarkHome"
                log(string.format("home team: UniColor1 luma value (margin: %s):: %s, selected fg: %s", luma_margin, uni1_luma, fg_clr_home))
            else
                -- dark background ...
                fg_clr_home = "LightHome"
                log(string.format("home team: UniColor1 luma value (margin: %s):: %s, selected fg: %s", luma_margin, uni1_luma, fg_clr_home))
            end
        end
        if away_cfg then
            bg_clr_away = away_cfg.UniColor_Color1 or away_cfg.ShirtColor1
            log(string.format("away color: %s", bg_clr_away))
            local uni2_luma = calculate_luma(bg_clr_away)
            if uni2_luma >= luma_margin then
                fg_clr_away = "DarkAway"
                log(string.format("away team: UniColor1 luma value (margin: %s):: %s, selected fg: %s", luma_margin, uni2_luma, fg_clr_away))
            else
                fg_clr_away = "LightAway"
                log(string.format("away team: UniColor1 luma value (margin: %s):: %s, selected fg: %s", luma_margin, uni2_luma, fg_clr_away))
            end
        end
    end
end

local function play_intro_anthem()
    if intro_anthem then
        intro_anthem:set_volume(0.7)
        intro_anthem:play()
    end
end

local function stop_intro_anthem()
    if intro_anthem then
        intro_anthem:fade_to(0, 2)
        intro_anthem:finish()
        intro_anthem = nil
    end
end

local function data_ready(ctx, filename)
    if filename == "common\\script\\flow\\Match\\MatchSetupRematch.json" then
        -- log("Rematch detected ... ")
        past_kickoff = false
    end
    
    if string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_hug_run_aim.*") then
        past_kickoff = true  -- avoid playing intro during half-time ...
    end
    
    -- if scoreboard was served from scoreboard server ...
    if ctx.scoreboard_server and ctx.scoreboard_server.active_scoreboard then
        local tid = ctx.tournament_id
        local sb_path = ctx.scoreboard_server.active_scoreboard
        -- trigger the intro anthem ...
        -- if filename == "common\\script\\flow\\Match\\MatchSetup.json" then
        if string.match(filename, "common\\demo\\fixdemoobj\\passage\\passage_%d+\\#Win\\light_config%.fpkd") or string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_007_st%d+_cmn_cam.*%.fdc") then
            if intro_anthem == nil then -- if anthem isn't already playing ...
                -- if exhibition mode, play only generic intro
                if tid == 65535 and past_kickoff == false then
                    log("generic intro_anthem starting (exhibition mode match), game loaded: " .. filename)
                    intro_anthem = audio.new(sbroot .. "\\Default\\intro_anthem.mp3")
                    play_intro_anthem()
                elseif tid < 65535 and past_kickoff == false then -- competitions
                    log("game loaded: " .. filename)
                    log("intro_anthem started: " .. sb_path)
                    intro_anthem = audio.new(sbroot .. "\\" .. sb_path .. "\\intro_anthem.mp3")
                    play_intro_anthem()
                end
            end
        -- and fade it out when players appear in the tunnel (or if entire intro gets skipped abruptly)
        -- elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_009_st%d+_cmn_cam.*%.fdc") or 
        elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_+d+_st%d+_cmn_cam.*%.fdc") or
                string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_hug_run_aim.*") or 
                filename == "common\\script\\flow\\Match\\MatchPrePause.json" then
            if intro_anthem then
                log("intro_anthem ending, game loaded: " .. filename)
                log(string.format("intro_anthem finishing: %s", intro_anthem:get_filename()))
                stop_intro_anthem()
            end
        end
    -- if scoreboard wasn't served, fall back to Default folder and play generic intro tune - this competition does not have socreboard assigned in scoreboard server
    else
        -- if filename == "common\\script\\flow\\Match\\MatchSetup.json" then
        if string.match(filename, "common\\demo\\fixdemoobj\\passage\\passage_%d+\\#Win\\light_config%.fpkd") or string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_007_st%d+_cmn_cam.*%.fdc") then
            log("generic intro_anthem starting (no scoreboard(s) assigned in scoreboard server), game loaded: " .. filename)
            if intro_anthem == nil and past_kickoff == false then -- if anthem isn't already playing ...
                intro_anthem = audio.new(sbroot .. "\\Default\\intro_anthem.mp3")
                play_intro_anthem()
            end
        -- and fade it out when players appear in the tunnel
        -- elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_009_st%d+_cmn_cam.*%.fdc") or 
        elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_+d+_st%d+_cmn_cam.*%.fdc") or
                string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_hug_run_aim.*") or 
                filename == "common\\script\\flow\\Match\\MatchPrePause.json" then
            if intro_anthem then
                log("generic intro_anthem ending, game loaded: " .. filename)
                log(string.format("intro_anthem finishing: %s", intro_anthem:get_filename()))
                stop_intro_anthem()
            end
        end
    end
    
    -- do something when match ends ... remove scoreboard_server from ctx
    if filename == "common\\script\\flow\\Match\\MatchDiscontinue.json" or 
            filename == "common\\script\\flow\\Match\\MatchDiscontinueTeam.json" or
            filename == "common\\script\\flow\\Match\\MatchEnd.json" then
        ctx.scoreboard_server = nil
    end
end

local function init(ctx)
    if sbroot:sub(1,1)=='.' then
        sbroot = ctx.sider_dir .. sbroot
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
    ctx.register("livecpk_data_ready", data_ready)
end

return { init = init }