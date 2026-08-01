-- HexX Scoreboard Editor for Sider.
-- Initially written by Mohamed2746, Update and researched by afandix.
-- This version is designed for the Afandix Premier League scoreboard.
-- Version 2.0.7 Patreon-Exclusive
-----------------------------
-- This is important !!!
-- The contents of map_competitions.txt and folder must be named Afandix Premier League
-- for example: 17, Afandix Premier League or 17, England\Afandix Premier League (if have subfolder).
-- All config colors are located in the "content\scoreboard-hexx\colors.ini".

-- There is a bug displaying the background color of the photo on the lineup which is always the home color. Due to 'Limitation' - cannot load more texture/color texture after game/match starting.

local m = {}

local sbhroot = ".\\content\\scoreboard-hexx"
local version = "2.0.7.EPL(Animation)"
local info_text = "No active match..."

m.load_teamcolors_map = {}
offsets = {}
goaltexture_str = {}

local EPLInGame = false
local isEPL = false

-- game2dEnglandEnter.bin offsets.
local wave0_enter
local wave1_enter
local wave2_enter
local wave3_enter
local wave4_enter
local homeName_enter
local awayName_enter
local lineupShape_enter 
local lineupName_enter

-- game2dEngland.bin offsets.
local wave0
local wave1
local wave2
local wave3
local wave4
local homeName
local awayName
local CardTime
local CardScorer
local CardTeamLogo
local goalShape
local goalShape2
local goalName
local CardPlate
local CardShape
local GoalTeamLogo
local CardGoal
local CardTexGoal

-- texture color offsets (have to research again if the texture changes).
local statsHome
local statsHome03
local statsAway
local statsAway01
local statsAway03
-- unicolor1
local platehome
local plateaway
local plateaway03
-- unicolor2
local plate2home
local plate2home03
local plate2away
local plate2away03
-- unicolor3/gradient color
local plate3home
local plate3away
local plate3away01
local plate3goalhome
local plate3goalhome01
local plate3goalhome03
local plate3goalaway
local plate3goalaway01
local plate3goalaway03
local stats_hide 
local stats_bkg

-- pauseMenu.bin offsets.
local homePause
local awayPause

-- licenceTextureEngland.bin offsets.
local card_3rdHome
local card_3rdHome2
local card_3rdHome3
local card_3rdAway
local card_3rdAway2
local card_3rdAway3
local card_3rdaway_missing

local RELOAD_COLORS_VKEY = 0x30 -- 0 key (not the NUMPAD zero!!)
local DEL_TEXT_KEY = 0x2E


local function load_all_offsets(ctx, ini_name)
	log(string.format("Loading %s", ini_name))
	local t = {}
	local f = io.open(sbhroot .. "//" .. ini_name)
	if not f then
		log("Error: Unable to open " .. ini_name)
		return nil  -- Ensure that return nil if the file can't be opened
	end

	local current_section
	for line in f:lines() do
		-- log("Reading line: " .. line)
		local section = string.match(line, "^%[([%w_]+)%]$")
		if section then
			-- log("Found section: " .. section)
			current_section = section
			t[current_section] = {}
		else
			local index, value = string.match(line, "%s*([%w_]+)%s*=%s*([%w_]+)")
			if index and value and current_section then
				-- log("Found key-value pair in section " .. current_section .. ": " .. index .. " = " .. value)
				index = tonumber(index) or index
				t[current_section][index] = value
			end
		end
	end
	f:close()
	return t
end

local function load_all_str(ctx, ini_name)
	log(string.format("Loading %s", ini_name))
	local t = {}
	local f = io.open(sbhroot .. "//" .. ini_name)
	local current_section
	if f then
		for line in f:lines() do
			-- log("Reading line: " .. line)
			local section = string.match(line, "^%[([%w_]+)%]$")
			if section then
				current_section = section
				t[current_section] = {}
			else
				local index, value = string.match(line, "%s*([%w_]+)%s*=%s*(.+)")
				if index and value and current_section then
					-- log("Found key-value pair in section " .. current_section .. ": " .. index .. " = " .. value)
					index = tonumber(index) or index
					t[current_section][index] = value
				end
			end
		end
		f:close()
	else
		log("Error: Unable to open " .. ini_name)
	end
	return t
end

local function load_colors(ctx, ini_name)
	log(string.format("Loading %s", ini_name))
	local t = {}
	local f = io.open(sbhroot .. "//" .. ini_name)
	local current_team_id
	local current_team_name
	if f then
		for line in f:lines() do
			local team_id, team_name = string.match(line, "^%[(%d+)%]%s*(.-)$")
			if team_id then
				current_team_id = team_id
				current_team_name = team_name
				t[current_team_id] = { name = current_team_name, kits = {} }
			else
				local kit_id, plate_clr, plate2_clr, text_clr, shape_clr, shape2_clr, text_shape_clr, shape3_clr =
					string.match(line, "(%d+) = (#%x+), (#%x+), (#%x+), (#%x+), (#%x+), (#%x+), (#%x+)")
				if
					kit_id
					and plate_clr
					and plate2_clr
					and text_clr
					and shape_clr
					and shape2_clr
					and text_shape_clr
					and shape3_clr
				then
					t[current_team_id].kits[kit_id] = {
						plate_clr = plate_clr,
						plate2_clr = plate2_clr,
						text_clr = text_clr,
						shape_clr = shape_clr,
						shape2_clr = shape2_clr,
						text_shape_clr = text_shape_clr,
						shape3_clr = shape3_clr,
					}
				end
			end
		end
		failed = false
		f:close()
	else
		failed = true
		log("Error: Unable to open " .. ini_name)
	end
	return t
end

local function hex_to_bin(hex_str)
	local clean_hex = hex_str:gsub("%s+", "")  -- Remove all spaces
	return (clean_hex:gsub('..', function (cc)
		return string.char(tonumber(cc, 16))
	end))
end

local function colorHexToBytes(colorHex)
	return memory.pack("u8", tonumber(colorHex:sub(2, 3), 16))
		.. memory.pack("u8", tonumber(colorHex:sub(4, 5), 16))
		.. memory.pack("u8", tonumber(colorHex:sub(6, 7), 16))
end

local function colorHexToLittleEndianBytes(colorHex)
	return memory.pack("u8", tonumber(colorHex:sub(6, 7), 16))
		.. memory.pack("u8", tonumber(colorHex:sub(4, 5), 16))
		.. memory.pack("u8", tonumber(colorHex:sub(2, 3), 16))
end

-- define a function to get color.
local function getColor(team_id, kit_id, color_type)
	local team = m.load_teamcolors_map[tostring(team_id)]
	local kit = team and team.kits[tostring(kit_id)]
	return kit and kit[color_type]
end

local function getColorFunction(color_type)
	return function(team_id, kit_id)
		return getColor(team_id, kit_id, color_type)
	end
end

-- generate get color functions.
local plateClr = getColorFunction("plate_clr")
local plate2Clr = getColorFunction("plate2_clr")
local textClr = getColorFunction("text_clr")
local shapeClr = getColorFunction("shape_clr")
local shape2Clr = getColorFunction("shape2_clr")
local textShapeClr = getColorFunction("text_shape_clr")
local shape3Clr = getColorFunction("shape3_clr")
local goalClr = getColorFunction("goal_clr")
local textureClr = getColorFunction("texture_clr")

-- define a function to write color.
local function writeColorFunction(color_type)
	return function(data, colorAddresses, team_id, kit_id)
		if not colorAddresses or #colorAddresses == 0 then
			log("Warning: colorAddresses is nil or empty for color_type: " .. color_type)
			return
		end

		local colorHex = getColor(team_id, kit_id, color_type)
		if colorHex then
			for n = 1, #colorAddresses do
				local address = data + tonumber(colorAddresses[n], 16)
				memory.write(address, colorHexToBytes(colorHex))
			end
		else
			log(
				"Error: colorHex is nil for team_id: "
					.. tostring(team_id)
					.. ", kit_id: "
					.. tostring(kit_id)
					.. ", color_type: "
					.. color_type
			)
		end
	end
end

-- generate write color functions.
local writePlateClr = writeColorFunction("plate_clr")
local writePlate2Clr = writeColorFunction("plate2_clr")
local writeTextClr = writeColorFunction("text_clr")
local writeShapeClr = writeColorFunction("shape_clr")
local writeShape2Clr = writeColorFunction("shape2_clr")
local writeTextShapeClr = writeColorFunction("text_shape_clr")
local writeShape3Clr = writeColorFunction("shape3_clr")
local writeGoalClr = writeColorFunction("goal_clr")
local writeTextureClr = writeColorFunction("texture_clr")

-- get team and kit IDs.
function get_team_kit_ids(ctx)
    local home_team_id = ctx.home_team
    local home_kit_id = ctx.kits.get_current_kit_id(0)
    local away_team_id = ctx.away_team
    local away_kit_id = ctx.kits.get_current_kit_id(1)

    return home_team_id, home_kit_id, away_team_id, away_kit_id
end

function get_texture(goaltexture_str, team_id, kit_id, is_home)
    local prefix = is_home and "home_" or "away_"
    local section = prefix .. tostring(team_id)
    local key = "kit_" .. tostring(kit_id)
    if goaltexture_str[section] and goaltexture_str[section][key] then
		log("Found string: " .. goaltexture_str[section][key])
        return hex_to_bin(goaltexture_str[section][key])
    else
		log("Texture string not found for team: " .. section .. ", key: " .. key)
        return nil
    end
end

local function clear_table(t)
	for k, v in pairs(t) do
		t[k] = nil
	end
end

function reset_color()
	home_team_id, home_kit_id, away_team_id, away_kit_id,
	plate_clr, plate2_clr, text_clr,
	shape_clr, shape2_clr, text_shape_clr, shape3_clr, goal_clr, texture_clr = nil
end

-- check if the tournament ID is correct.
function EPL(ctx)
    local tid = tonumber(ctx.tournament_id)
    local exhib_same_league_tid = ctx.common_lib.tid_same_league(ctx.home_team, ctx.away_team)
    local homeid = ctx.home_team
    local awayid = ctx.away_team

    -- List of England teams for manually selected EPL scoreboard
    local englandteams = {
        101, 107, 4071, 4180, 377, 102, 382, 177, 178, 386, 204, 103, 173, 100, 106, 389, 
        207, 179, 105, 208, 176, 1760, 378, 379, 4183, 383, 1589, 104, 4363, 205, 387, 
        388, 5086, 4364, 4365, 4192, 1327, 4194, 394, 395, 396, 1909, 398, 399
    }

    local function is_england_team(team_id)
        for _, id in ipairs(englandteams) do
            if id == team_id then
                return true
            end
        end
        return false
    end

    local exhib_epl = tid == 65535 and exhib_same_league_tid == 17
    -- local exhib_efl = tid == 65535 and exhib_same_league_tid == 79
    local exhib_eflefl = tid == 65535 and is_england_team(homeid) and is_england_team(awayid)

    return tid == 17 or exhib_epl or exhib_eflefl -- or exhib_efl
end

local Afandix_epl_sb = false

local function after_set_conditions(ctx)
	if not isEPL then return end
	local sb_path = ctx.scoreboard_server and ctx.scoreboard_server['active_scoreboard'] or ""
	if sb_path:match("Afandix Premier League$") then
		Afandix_epl_sb = true
		EPLInGame = true
		log("It's afandix EPL Scoreboard")
		info_text = ""
		info_text = "Waiting for search Address..."
	else
		Afandix_epl_sb = false
		EPLInGame = false
		log("It's not afandix EPL Scoreboard")
		info_text = ""
		info_text = "Wrong scoreboard selected. Please check the scoreboard name on the map or scoreboard server!"
	end
end

local function teams_selected(ctx, home_team_id, away_team_id)
	if ctx.mis and EPL(ctx) then
		isEPL = true
		log("It's EPL")
		reset_scores(ctx, home_team_id, away_team_id)
	else
		isEPL = false
		log("Isn't EPL")
	end
end

-- Search important startpoint address for .bin in memory address.
local startAddress, endAddress
local game2dEnglandEnterAddress, game2dEnglandAddress

function resetSearch()
	startAddress = nil
	endAddress = nil
	game2dEnglandEnterAddress = nil
	game2dEnglandAddress = nil
end

function searchStr(type)
	local searchStr, foundAddress

	if type == "lineup" then
		searchStr = "\x0c\x00\xc0\x1f\x26\x00\x00\x00\x01\x00\x36\x00\x0c\x00\xbc\x05"
    elseif type == "goalplate" then
		searchStr = "\x0c\x00\xc0\x1f\x46\x00\x00\x00\x01\x00\x9f\x00\x06\x00\x0b\x00"
	end

	if type == "lineup" or type == "goalplate" then
		foundAddress = memory.safe_search(searchStr, startAddress, endAddress)
	end

	if foundAddress then
		if type == "lineup" then
            game2dEnglandEnterAddress = foundAddress - 0x3faf
			log("game2dEnglandEnter.bin Address: " .. tostring(game2dEnglandEnterAddress):match('0x%x+'))
		elseif type == "goalplate" then
			game2dEnglandAddress = foundAddress - 0x65d7
			log("game2dEngland.bin Address: " .. tostring(game2dEnglandAddress):match('0x%x+'))
		end
	else
		resetSearch()
		info_text = "Address not found or invalid !"
		log("Address not found or invalid for type: " .. type)
	end
end

-- Change the away color of the line-up
function changeColorAway(team, team_id, kit_id, lineupShape_enter, lineupName_enter)
	local function changeColor(colorFunction, offsets)
		local colorStr = colorHexToLittleEndianBytes(colorFunction(team_id, kit_id))
		for _, offset in ipairs(offsets) do
			local addr = game2dEnglandEnterAddress + tonumber(offset, 16)
			memory.write(addr, colorStr)
		end
	end

	changeColor(shapeClr, lineupShape_enter)
	changeColor(textShapeClr, lineupName_enter)
end

-- Change team colors for goalcard
function changeGoalColor(team_id, kit_id, goalShape, goalShape2, goalName)
	local function changeColor(colorFunction, offsets)
		local colorStr = colorHexToLittleEndianBytes(colorFunction(team_id, kit_id))
		for _, offset in ipairs(offsets) do
			local addr = game2dEnglandAddress + tonumber(offset, 16)
			memory.write(addr, colorStr)
		end
	end

	changeColor(plateClr, goalShape)
	changeColor(plate2Clr, goalShape2)
	changeColor(textClr, goalName)
end

-- Function to check goal score and change scorer texture
local curr_home_score = 0
local curr_away_score = 0
local who_scored
local score_changed = false
local msg = ""
local dont_score = false
local rematch = false
local end_game = false
local hide_time = nil
local last_home_goal_time = nil
local goalsts = false

function convert_to_seconds(minutes, seconds)
    return (minutes * 60) + seconds
end

function reset_scores(ctx, home_team_id, away_team_id)
	local stats = match.stats()
	--if stats == nil then return end
	if not stats then return end
	stats.home_score = 0
	stats.away_score = 0
	curr_home_score = 0
	curr_away_score = 0
	log("score has been reset")
end

function check_goal_score(ctx, home_team_id, home_kit_id, away_team_id, away_kit_id)
	if end_game then
		return "no game"
	end
	local stats = match.stats()
	if not stats then return end

	local home_score = stats.home_score or 0
	local away_score = stats.away_score or 0
	local period = stats.period
	local minutes = stats.clock_minutes
	local seconds = stats.clock_seconds
	local add_minutes = stats.added_minutes

	if EPL(ctx) and game2dEnglandAddress then
		if dont_score then
			log("Don't count the scores!")
			return
		end
		if home_score > curr_home_score then
			curr_home_score = home_score
			who_scored = "home team"
			score_changed = true
		elseif away_score > curr_away_score then
			curr_away_score = away_score
			who_scored = "away team"
			score_changed = true
		else
			score_changed = false
		end
		if score_changed and period < 5 then -- 5 = penalty shootout
			local home_team_id, home_kit_id, away_team_id, away_kit_id = get_team_kit_ids(ctx)
			msg = string.format("(%s : %d) (%s : %d) %s scored", home_team_id, curr_home_score, away_team_id, curr_away_score, who_scored)
			log("Score change: " .. msg)
			if who_scored == "home team" then
				changeGoalColor(home_team_id, home_kit_id, goalShape, goalShape2, goalName)
				log("The goal card is home team's colors.")
				resetHalftime("\xba\x3a\xff\xff\x99\x51\x00\x00")
				changeScorer("\x18\xfc\xfe\xff")
				moveLogo("\xa7\x01\x00\x00")
				goalsts = false
			elseif who_scored == "away team" then
				changeGoalColor(away_team_id, away_kit_id, goalShape, goalShape2, goalName)
				log("The goal card is away team's colors.")
				resetHalftime("\xba\x3a\xff\xff\x99\x51\x00\x00")
				changeScorer("\x15\x55\xff\xff")
				moveLogo("\xa7\x01\x00\x00")
				goalsts = false
			end
		end

		if period == 1 and minutes == 00 and seconds == 01 then
			if rematch then
				rematch = false
				log("re-match false")
			end
		end
		-- change team logo position when injury time.
		if add_minutes then
			if period == 1 and (minutes >= 45 + add_minutes) then
				moveLogo("\x7d\x03\x00\x00")
				-- log("add minute 1st")
			elseif period == 2 and (minutes >= 90 + add_minutes) then
				moveLogo("\x7d\x03\x00\x00")
				-- log("add minute 2nd")
			elseif period == 3 and (minutes >= 105 + add_minutes) then
				HalfTime(stats)
				-- log("add minute Extra 1st")
			elseif period == 4 and (minutes >= 120 + add_minutes) then
				moveLogo("\x7d\x03\x00\x00")
				-- log("add minute Extra 2nd")
			end
		end
		curr_home_score, curr_away_score = home_score, away_score
    end
end

-- Change team goalcard texture based on home or away score
local str_homePlate = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_awayPlate = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_homeShape = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_awayShape = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_homeGoal = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_awayGoal = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_homeTexGoal = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_awayTexGoal = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_homeLogo = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_awayLogo = "\x00\x00\x00\x00\x00\x00\x00\x00"
local str_hide = "\x00\x00\x00\x00\x00\x00\x00\x00"

local function write_to_memory(addresses, str_data, operation_desc)
    for _, offset in ipairs(addresses) do
        local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
        memory.write(addr, str_data)
    end
    log(operation_desc)
end

local function change_goal(team_id, kit_id, is_home)
    local sig_str_goalTex = get_texture(goaltexture_str, team_id, kit_id, is_home)
    local plate_str, shape_str, logo_str, goal_str, texGoal_str = 
        is_home and str_homePlate or str_awayPlate,
        is_home and str_homeShape or str_awayShape,
        is_home and str_homeLogo or str_awayLogo,
        is_home and str_homeGoal or str_awayGoal,
        is_home and str_homeTexGoal or str_awayTexGoal

    local log_prefix = is_home and "home" or "away"
    
    log("Writing " .. log_prefix .. " str to memory")
    write_to_memory(CardPlate, plate_str, "Finished writing " .. log_prefix .. " plate str to memory")
    write_to_memory(CardShape, shape_str, "Finished writing " .. log_prefix .. " shape str to memory")
    write_to_memory(GoalTeamLogo, logo_str, "Finished writing " .. log_prefix .. " logo str to memory")
    write_to_memory(CardGoal, goal_str, "Finished writing " .. log_prefix .. " goal str to memory")
    write_to_memory(CardTexGoal, texGoal_str, "Finished writing " .. log_prefix .. " tex goal str to memory")
	
	if sig_str_goalTex then return end -- skip code for goal_animation.lua

    if not sig_str_goalTex then
        log("No special " .. log_prefix .. " texture goal string found for team_id: " .. tostring(team_id) .. ", kit_id=" .. tostring(kit_id))
        return
    end

    write_to_memory(CardPlate, str_hide, "Hiding " .. log_prefix .. " plate str")
    write_to_memory(CardShape, str_hide, "Hiding " .. log_prefix .. " shape str")
    log("Writing " .. log_prefix .. " signature goal texture str to memory")
    write_to_memory(CardTexGoal, sig_str_goalTex, "Finished writing signature " .. log_prefix .. " str goal to memory")
end

function change_goalhome(home_team_id, home_kit_id)
    change_goal(home_team_id, home_kit_id, true)
end

function change_goalaway(away_team_id, away_kit_id)
    change_goal(away_team_id, away_kit_id, false)
end

-- Change Statscard texture randomly
bkg_restore = "\xd7\xd0\xff\xff"
stats_restore = "\x00\x04\x00\x00"
hide_str = "\x00\x00\x00\x00"

function statshide(str)
	for _, offset in ipairs(stats_hide) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
	end
end

function move_stats(str)
    for _, offset in ipairs(stats_bkg) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
    end
end

local refere_str = {
	{ "\xfb\x2f\xff\xff", "Peter Bankes" },
	{ "\xa8\x14\xff\xff", "David Coote" },
	{ "\x68\xf9\xfe\xff", "Michael Oliver" },
	{ "\x29\xde\xfe\xff", "Thomas Bramall" },
	{ "\xea\xc2\xfe\xff", "Tim Robinson" }
}

local function random_ref()
    local index = math.random(1, #refere_str)
    return refere_str[index][1], refere_str[index][2]
end

function referee()
    local ref_str, ref_name = random_ref()
    move_stats(ref_str)
    statshide(hide_str)
    log("Random referee: " .. ref_name)
end

function socmed()
	move_stats("\x4e\x4b\xff\xff")
	statshide(hide_str)
	log("Social media")
end

function hublot()
	move_stats("\x79\x66\xff\xff")
	statshide(hide_str)
	log("Hublot logo")
end

function noracism()
	move_stats("\xb9\x81\xff\xff")
	statshide(hide_str)
	log("No room for racism")
end

function eafc()
	move_stats("\x44\x9a\xff\xff")
	statshide(hide_str)
	log("EA FC")
end

function winsts()
	move_stats("\xab\xb5\xff\xff")
	statshide(hide_str)
	log("win probabilty")
end

function normalsts()
	move_stats(bkg_restore)
	statshide(stats_restore)
	log("Normal stats")
end

local stats_funcs = {
    {func = socmed, weight = 4},
    {func = hublot, weight = 4},
    {func = noracism, weight = 5},
    {func = eafc, weight = 4},
    {func = winsts, weight = 2},
    {func = normalsts, weight = 6}
}

local referee_called = false

local function weighted_random()
	local sum = 0
	for _, item in ipairs(stats_funcs) do
		sum = sum + item.weight
	end

	local rand = math.random() * sum

	for _, item in ipairs(stats_funcs) do
		if rand < item.weight then
			return item.func
		else
			rand = rand - item.weight
		end
	end
end

local last_executed_time = nil

local function log_stats_change(message, current_time)
    log(message .. " at time: " .. current_time)
end

local function check_not_change_stats()
    if dont_score then
        log("Stat's not change for rematch or discontinue")
        last_executed_time = nil
        return true
    end
    return false
end

local function handle_referee_change(period, minutes, current_time)
    if period == 1 and minutes <= 10 and not referee_called then
		game2dEnglandEnterAddress = nil
		log("Match stats available")
		log("Kick off so game2dEnglandEnterAddress is nil")
        referee()
        log_stats_change("Referee stats change first", current_time)
        referee_called = true
    end
end

local function handle_regular_stats_change(period, minutes, seconds, current_time)
    if (period == 1 and minutes > 10 and minutes <= 45 or period == 2 and minutes >= 45 and minutes <= 90) and minutes % 1 == 0 and seconds == 0 then
        local func = weighted_random()
        func()
        log_stats_change("Stat's change", current_time)
        last_executed_time = current_time
    end
end

function change_stats(ctx)
    if end_game then return "no game" end

    local stats = match.stats()
    if not stats or goalsts then return "no stats" end

    local period = stats.period
    local minutes = stats.clock_minutes
    local seconds = stats.clock_seconds
    local current_time = string.format("%02d:%02d", minutes, seconds)

    if last_executed_time == current_time then return end

    if EPL(ctx) and game2dEnglandAddress then
        if check_not_change_stats() then return "no stats" end
        handle_referee_change(period, minutes, current_time)
        handle_regular_stats_change(period, minutes, seconds, current_time)
    end
end

-- Change first half or second half for gamecard.
function change1st2nd(str)
	for _, offset in ipairs(CardTime) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
	end
end

-- Change halftime or fulltime for gamecard.
function changeHalftime(home_score, away_score, str1, str2)
	for _, offset in ipairs(CardTime) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		if home_score <= 1 and away_score <= 1 then
			memory.write(addr, str1)
		elseif home_score > 1 or away_score > 1 then
			memory.write(addr, str2)
		end
	end
end

function resetHalftime(str)
	for _, offset in ipairs(CardTime) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
	end
end

-- Change scorer texture home or away for gamecard.
function changeScorer(str)
    for _, offset in ipairs(CardScorer) do
        local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
    end
end

function resetScorer(str)
	for _, offset in ipairs(CardScorer) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
	end
end

-- Change position team logo home or away for gamecard.
function moveLogo(str)
	for _, offset in ipairs(CardTeamLogo) do
		local addr = game2dEnglandAddress - 0x1 + tonumber(offset, 16)
		memory.write(addr, str)
	end
end

-- Change the stats bar, gradient and unicolor1-plate color (hex code texture).
-- If the texture has been modified then offsets color 'with 01 or 03' code must be searched again.
function writeColorSkip(data, address, colorHex, skipStart, skipEnd)
    if not data then
        log("Error: data is nil")
        return
    end
    if not address then
        log("Error: address is nil")
        return
    end

    if colorHex:sub(1, 1) == "#" then
        colorHex = colorHex:sub(2)
    end

    -- Calculate part1 and part2 correctly.
    local part1 = colorHex:sub(1, (skipStart - 1) * 2) -- Up to skipStart
    local part2 = colorHex:sub(skipEnd * 2 + 1) -- After skipEnd
	--log(string.format("colorHex: %s, part1: %s, part2: %s", colorHex, part1, part2))

    -- Write the first part of the color.
    for i = 1, #part1, 2 do
        local byteStr = part1:sub(i, i + 1)
        local byte = tonumber(byteStr, 16)
        if byte then
			--log(string.format("Writing byte %02X to address %08X", byte, data + address))
			memory.write(data + address, memory.pack("u8", byte))
            address = address + 1
        else
            log(string.format("Error: byte is nil for byteStr: %s", byteStr))
        end
    end

    -- Skip the specified positions.
    address = address + (skipStart - skipEnd)

    -- Write the remaining part of the color.
    for i = 1, #part2, 2 do
        local byteStr = part2:sub(i, i + 1)
        local byte = tonumber(byteStr, 16)
        if byte then
			--log(string.format("Writing byte %02X to address %08X", byte, data + address))
			memory.write(data + address, memory.pack("u8", byte))
            address = address + 1
        else
            log(string.format("Error: byte is nil for byteStr: %s", byteStr))
        end
    end
end

function colorStatsImage(color_type, skipStart, skipEnd)
    return function(data, colorAddresses, team_id, kit_id)
        local colorHex = getColor(team_id, kit_id, color_type)
        if colorHex then
            for n = 1, #colorAddresses do
                local address = tonumber(colorAddresses[n], 16)
                writeColorSkip(data, address, colorHex, skipStart, skipEnd)
            end
        end
    end
end

function writeColorSkip2(data, address, colorHex, skipStart, skipEnd)
    if not data then
        log("Error: data is nil")
        return
    end
    if not address then
        log("Error: address is nil")
        return
    end

    if colorHex:sub(1, 1) == "#" then
        colorHex = colorHex:sub(2)
    end

    -- Extract the second and third hex colors.
    local secondColor = colorHex:sub(3, 4)
    local thirdColor = colorHex:sub(5, 6)

    -- Combine them into the new color.
    local newColorHex = secondColor .. "ab" .. thirdColor

    -- Write the new color to memory.
    for i = 1, #newColorHex, 2 do
        local byteStr = newColorHex:sub(i, i + 1)
        local byte = tonumber(byteStr, 16)
        if byte then
			--log(string.format("Writing byte %02X to address %08X", byte, data + address))
            memory.write(data + address, memory.pack("u8", byte))
            address = address + 1
        else
            log(string.format("Error: byte is nil for byteStr: %s", byteStr))
        end
    end
end

function colorStatsImage2(color_type, skipStart, skipEnd)
    return function(data, colorAddresses, team_id, kit_id)
        local colorHex = getColor(team_id, kit_id, color_type)
        if colorHex then
            for n = 1, #colorAddresses do
                local address = tonumber(colorAddresses[n], 16)
                writeColorSkip2(data, address, colorHex, skipStart, skipEnd)
            end
        end
    end
end

-- Example usage skip 01 or else : #afafaf to afaf01af.
local statsClr01 = colorStatsImage("shape_clr", 3, 2)
local shapeClr01 = colorStatsImage("shape3_clr", 3, 2)
local plateClr01 = colorStatsImage("plate_clr", 3, 2)

-- Just write 1 hex 2nd color  #aeabaf to ab.
local shapeClr01_1b_2nd = colorStatsImage("shape3_clr", 1, 1)

-- Just write 1 hex last color  #aeabaf to af.
local shapeClr01_1b_3rd = colorStatsImage("shape3_clr", 1, 2)
local plate2Clr_3rd = colorStatsImage("plate2_clr", 1, 2)
local plate1Clr_3rd = colorStatsImage("plate_clr", 1, 2)

-- example #ffacde: Write last #acde then separate again to #acabde.
local shapeClr01_ab = colorStatsImage2("shape3_clr", 1, 1)

-- Just write 2 hex last color  #aeafaf to afaf
local shapeClr01_2b = colorStatsImage("shape3_clr", 1, 1)

-- Example usage skip 03 or else : #afafaf to af03afaf.
local statsClr03 = colorStatsImage("shape_clr", 2, 1)
local shapeClr03 = colorStatsImage("shape3_clr", 2, 1)
local plateClr03 = colorStatsImage("plate_clr", 2, 1)

function EnterScreen(data, home_team_id, home_kit_id, away_team_id, away_kit_id)
    writePlateClr(data, wave1_enter, home_team_id, home_kit_id)
    writePlateClr(data, wave0_enter, away_team_id, away_kit_id)
    writePlate2Clr(data, wave3_enter, home_team_id, home_kit_id)
    writePlate2Clr(data, wave2_enter, away_team_id, away_kit_id)
    writeTextClr(data, homeName_enter, home_team_id, home_kit_id)
    writeTextClr(data, awayName_enter, away_team_id, away_kit_id)
    writeShapeClr(data, lineupShape_enter, home_team_id, home_kit_id)
    writeTextShapeClr(data, lineupName_enter, home_team_id, home_kit_id)
end

function Scoreboards(data, home_team_id, home_kit_id, away_team_id, away_kit_id)
    writePlateClr(data, wave1, home_team_id, home_kit_id)
    writePlateClr(data, wave0, away_team_id, away_kit_id)
    writePlate2Clr(data, wave3, home_team_id, home_kit_id)
    writePlate2Clr(data, wave2, away_team_id, away_kit_id)
    writeTextClr(data, homeName, home_team_id, home_kit_id)
    writeTextClr(data, awayName, away_team_id, away_kit_id)
    writePlateClr(data, goalShape, home_team_id, home_kit_id)
    writePlate2Clr(data, goalShape2, home_team_id, home_kit_id)
    writeTextClr(data, goalName, home_team_id, home_kit_id)
end

function LineupScreen(away_team_id, away_kit_id, lineupShape_enter, lineupName_enter)
	changeColorAway("away", away_team_id, away_kit_id, lineupShape_enter, lineupName_enter)
end

function PauseMenuScreen(data, homePause, home_team_id, home_kit_id, awayPause, away_team_id, away_kit_id)
	writeShapeClr(data, homePause, home_team_id, home_kit_id)
	writeShapeClr(data, awayPause, away_team_id, away_kit_id)
end

function ColorStats(
	data,
	home_team_id,
	home_kit_id,
	away_team_id,
	away_kit_id,
	statsHome,
	statsHome03,
	statsAway,
	statsAway01,
	statsAway03
)
	writeShapeClr(data, statsHome, home_team_id, home_kit_id)
	statsClr03(data, statsHome03, home_team_id, home_kit_id)
	writeShapeClr(data, statsAway, away_team_id, away_kit_id)
	statsClr01(data, statsAway01, away_team_id, away_kit_id)
	statsClr03(data,statsAway03, away_team_id, away_kit_id)
end

function ColorPlate(
	data,
	home_team_id,
	home_kit_id,
	away_team_id,
	away_kit_id,
	platehome,
	plate2home,
	plate2home03,
	plate3home,
	plateaway,
	plateaway03,
	plate2away,
	plate2away03,
	plate3away,
	plate3away01,
	plate3goalhome,
	plate3goalhome01,
	plate3goalhome03,
	plate3goalaway,
	plate3goalaway01,
	plate3goalaway03
)
	writePlateClr(data, platehome, home_team_id, home_kit_id)
	writePlate2Clr(data, plate2home, home_team_id, home_kit_id)
	plate2Clr_3rd(data, plate2home03, home_team_id, home_kit_id)
	writeShape3Clr(data, plate3home, home_team_id, home_kit_id)
	plateClr03(data, plateaway, away_team_id, away_kit_id)
	plate1Clr_3rd(data, plateaway03, away_team_id, away_kit_id)
	writePlate2Clr(data, plate2away, away_team_id, away_kit_id)
	plate2Clr_3rd(data, plate2away03, away_team_id, away_kit_id)
	writeShape3Clr(data, plate3away, away_team_id, away_kit_id)
	shapeClr01(data, plate3away01, away_team_id, away_kit_id)
	writeShape3Clr(data, plate3goalhome, home_team_id, home_kit_id)
	shapeClr01(data, plate3goalhome01, home_team_id, home_kit_id)
	shapeClr03(data, plate3goalhome03, home_team_id, home_kit_id)
	writeShape3Clr(data, plate3goalaway, away_team_id, away_kit_id)
	shapeClr01(data, plate3goalaway01, away_team_id, away_kit_id)
	shapeClr03(data, plate3goalaway03, away_team_id, away_kit_id)
end

function ColorNewCard(
	data,
	home_team_id,
	home_kit_id,
	away_team_id,
	away_kit_id,
	card_3rdHome,
	card_3rdHome2,
	card_3rdHome3,
	card_3rdAway,
	card_3rdAway2,
	card_3rdAway3,
	card_3rdaway_missing,
	card_3rdaway_2nd_ab
)
	writeShape3Clr(data, card_3rdHome, home_team_id, home_kit_id)
	writeShape3Clr(data, card_3rdAway, away_team_id, away_kit_id)
	shapeClr01(data, card_3rdHome2, home_team_id, home_kit_id)
	shapeClr01(data, card_3rdAway2, away_team_id, away_kit_id)
	shapeClr03(data, card_3rdHome3, home_team_id, home_kit_id)
	shapeClr03(data, card_3rdAway3, away_team_id, away_kit_id)
	shapeClr01_2b(data, card_3rdaway_missing, away_team_id, away_kit_id)
	shapeClr01_ab(data, card_3rdaway_2nd_ab,away_team_id, away_kit_id)
end

function FirstTime()
	change1st2nd("\xc8\xff\xff\xff\x16\xfd\xfe\xff")
	moveLogo("\x7d\x03\x00\x00")
	-- log("First Half")
end

function HalfTime(stats)
	moveLogo("\x7d\x03\x00\x00")
	resetScorer("\xf6\x01\x00\x00")
	changeHalftime(
		stats.home_score,
		stats.away_score,
		"\xba\x3a\xff\xff\x32\xac\xff\xff",
		"\xba\x3a\xff\xff\x16\xac\xff\xff"
	)
	-- log("Half Time")
end

function FullTime(stats)
	resetScorer("\xf6\x01\x00\x00")
	changeHalftime(
		stats.home_score,
		stats.away_score,
		"\xc8\xff\xff\xff\x32\xac\xff\xff",
		"\xc8\xff\xff\xff\x16\xac\xff\xff"
	)
	moveLogo("\x7d\x03\x00\x00")
	-- log("Full Time")
end

function SecondTime()
	change1st2nd("\xc8\xff\xff\xff\xf7\x55\xff\xff")
	moveLogo("\x7d\x03\x00\x00")
	-- log("Second Half")
end

-- afandix signature codes in bin files.
local Afandix = "\x50\x2e\x61\x70\x6b" -- P.apk

local AfandixBars = "\xe6\x38\x3d" -- Special hex color code to specify the startpoint of the color 4 bytes "writeColorSkip" for bars, gradient and plate color. Otherwise it will be used from texture (Amarant Red or Spring Green).

local sts_no = false

function m.data_ready(ctx, filename, addr, len, total_size, offset, cpk_filename)
	if not EPLInGame then return end

	if Afandix_epl_sb then
		local data = tostring(addr):sub(11, -1)
		local home_team_id, home_kit_id, away_team_id, away_kit_id = get_team_kit_ids(ctx)
		local stats = match.stats()
		if not stats and not sts_no then log("No match stats available") sts_no = true end

		-- Check filename and modify data accordingly.
		if string.match(filename, "game2dEnglandEnter.bin") or string.match(filename, "game2dPesEnter.bin") then
			end_game = false
			if memory.read(data + 0x2a, 5) == Afandix then
				EnterScreen(data, home_team_id, home_kit_id, away_team_id, away_kit_id)
			else
				log("Wrong scoreboard it's not Afandix EPL sb file")
				info_text = ""
				info_text = "Scoreboard wrong version, Please update the file!"
				Afandix_epl_sb = false
			end
		elseif string.match(filename, "game2dEngland.bin") or string.match(filename, "game2dPes.bin") then
			dont_score = false -- Continue counting scores
			if memory.read(data + 0x25, 5) == Afandix then
				local EndAdr = tonumber(ffi.cast("intptr_t", addr))
				endAddress = EndAdr + 0x1000000 --0xB00000
				log("set endpoint Address: " .. string.format("0x%x", endAddress))
				if endAddress < 0x100000000 then
					log("Address is too low so it's skipped to prevent long search")
					return
				else
					startAddress = endAddress - 0x25000000 --0x20B00000
					log("set startpoint Address: " .. string.format("0x%x", startAddress))
				end
				Scoreboards(data, home_team_id, home_kit_id, away_team_id, away_kit_id)
				if memory.read(data + 0x231864, 3) == AfandixBars then
					ColorStats(
						data,
						home_team_id,
						home_kit_id,
						away_team_id,
						away_kit_id,
						statsHome,
						statsHome03,
						statsAway,
						statsAway01,
						statsAway03
					)
					ColorPlate(
						data,
						home_team_id,
						home_kit_id,
						away_team_id,
						away_kit_id,
						platehome,
						plate2home,
						plate2home03,
						plate3home,
						plateaway,
						plateaway03,
						plate2away,
						plate2away03,
						plate3away,
						plate3away01,
						plate3goalhome,
						plate3goalhome01,
						plate3goalhome03,
						plate3goalaway,
						plate3goalaway01,
						plate3goalaway03
					)
					info_text = ""
					log("2.0.7.EPL(Patreon-Exclusive)")
				else
					info_text = "Scoreboard wrong version/Not original, Please update the file!"
					log("startpoint writeColorSkip for bars, gradient and plate color not found")
				end
			else
				info_text = ""
				info_text = "Scoreboard wrong version, Please update the file!"
				log("Wrong version an Afandix EPL sb file")
			end
		elseif string.match(filename, "licenceTextureEngland.bin") or string.match(filename, "licenceTexturePes.bin") then
			if memory.read(data + 0x2d, 5) == Afandix then
				if startAddress == nil then
					log("StartAddress not found then skip")
					return
				else
					log("Afandix EPL sb file confirm to search startpoint address")
				end
				if rematch then
					game2dEnglandEnterAddress = nil
					log("skip rematch lineup")
					goto jump_to
				end
				-- Search for important starting points.
				searchStr("lineup")
				::jump_to::
				searchStr("goalplate")
				if game2dEnglandAddress then
					startAddress, endAddress = nil
				end
				ColorNewCard(
					data,
					home_team_id,
					home_kit_id,
					away_team_id,
					away_kit_id,
					card_3rdHome,
					card_3rdHome2,
					card_3rdHome3,
					card_3rdAway,
					card_3rdAway2,
					card_3rdAway3,
					card_3rdaway_missing,
					card_3rdaway_2nd_ab
				)
			else
				resetSearch()
				info_text = "\nScoreboard wrong version, Please update the file!"
				log("Wrong version an Afandix EPL sb file - previous address lookup value will be nil")
			end
		end
		if string.match(filename, "game2dPes.bin") and not memory.read(data + 0x2a, 5) == Afandix
			or string.match(filename, "game2dBrazil.bin")
			or string.match(filename, "game2dFrance.bin")
			or string.match(filename, "game2dItaly.bin")
			or string.match(filename, "game2dSpain.bin")
			or string.match(filename, "game2dUcl.bin")
			or string.match(filename, "game2dAcl.bin")
			or string.match(filename, "game2dEuro.bin")
		then
			resetSearch()
			log("Wrong use of scoreboard, use auto selection..")
		end
		if string.match(filename, "ent_022_pl_cmn_home.fdc") and EPL(ctx) then
			if game2dEnglandEnterAddress then
				LineupScreen(away_team_id, away_kit_id, lineupShape_enter, lineupName_enter)
				log("Away lineup coloring")
			end
		elseif string.match(filename, "ent_.*_cmn_cam.fdc")
			or string.match(filename, "ENG1wipe.usm")
			or string.match(filename, "ENG2wipe.usm")
			or string.match(filename, "MatchStatsResult.json")
			or string.match(filename, "WEPESwipe_hd.usm") and EPL(ctx)
		then
			if game2dEnglandAddress then
				FirstTime()
			end
		end

		if stats then sts_no = false
			if string.match(filename, "tu_half_cmn.*cam.*st.*.fdc") and EPL(ctx) then
				if game2dEnglandAddress then
					HalfTime(stats)
				end
			elseif
				string.match(filename, "tu_full_.*_cut_st.*.fdc")
				or string.match(filename, "tu_pickup_good_.*_cam.fdc")
				or string.match(filename, "tu_pickup_cmn_.*_cam_st.*.fdc") and EPL(ctx)
			then
				if game2dEnglandAddress then
					FullTime(stats)
					end_game = true
				end
			elseif string.match(filename, "MatchHalfTime.json") and EPL(ctx) then
				if game2dEnglandAddress then
					SecondTime()
				end
			end
			if string.match(filename, "pauseMenu.bin") and memory.read(data + 0x21, 5) == Afandix then
				PauseMenuScreen(data, homePause, home_team_id, home_kit_id, awayPause, away_team_id, away_kit_id)
			end
			if string.match(filename, "MatchSetupRematch.json") and EPL(ctx) then
				if game2dEnglandAddress then
					dont_score = true
					referee_called = false
					reset_scores(ctx, home_team_id, away_team_id)
					last_home_goal_time = nil
					rematch = true
				end
			elseif
				string.match(filename, "MatchDiscontinue.*.json")
				or string.match(filename, "MatchEnd.json") and EPL(ctx)
			then
				if game2dEnglandAddress then
					dont_score = true
					referee_called = false
					reset_scores(ctx, home_team_id, away_team_id)
					reset_color()
					last_home_goal_time = nil
					rematch = false
					Afandix_epl_sb = false
					resetSearch()
				end
				EPLInGame = false
				isEPL = false
				info_text = ""
				info_text = "No active match..."
			end
	
			-- Change the color of the goal card early during celebration.
			check_goal_score(ctx, home_team_id, home_kit_id, away_team_id, away_kit_id)
			change_stats(ctx)
			local minutes = stats.clock_minutes
			local seconds = stats.clock_seconds
			local current_time_in_seconds = convert_to_seconds(minutes, seconds)
			if string.match(filename, "goal_S_offsideGoal_start.fdc") and EPL(ctx) then
				return stats
			else
				if string.match(filename, "SE_Cheers_CM_Goal.*.awb") and offset == 0x20 and EPL(ctx) then
					if game2dEnglandAddress then
						last_home_goal_time = current_time_in_seconds
						changeGoalColor(home_team_id, home_kit_id, goalShape, goalShape2, goalName)
						change_goalhome(home_team_id, home_kit_id)
						goalsts = true
						log("Correction goal card is home color")
					end
				elseif string.match(filename, "goal_celebrate_%d+_base.fdc") and EPL(ctx) then
					if last_home_goal_time and (current_time_in_seconds - last_home_goal_time <= 25) then
						if rematch then
							goto jump_here
						else
							log(string.format("No more goal card coloring at time: %02d:%02d", minutes, seconds))
							return nil
						end
					end
					::jump_here::
					i,j = string.find(filename, "%d+")
					if string.sub(filename, i, j) ~= "0025"
						and string.sub(filename, i, j) ~= "0045"
						and string.sub(filename, i, j) ~= "0163"
						and string.sub(filename, i, j) ~= "0217"
						and string.sub(filename, i, j) ~= "0218"
						and string.sub(filename, i, j) ~= "0307"
						and string.sub(filename, i, j) ~= "0308"
						and string.sub(filename, i, j) ~= "0309"
						and string.sub(filename, i, j) ~= "0313"
					then
						if game2dEnglandAddress then
							last_home_goal_time = current_time_in_seconds
							changeGoalColor(away_team_id, away_kit_id, goalShape, goalShape2, goalName)
							change_goalaway(away_team_id, away_kit_id)
							goalsts = true
							log("Goal card is away color")
						end
					end
				end
			end
		end
	else
		return
	end
end

local function overlay_on(ctx)
	local text = string.format('version %s', version)
	if ctx.mis and EPL(ctx) then
		isEPL = true
		local p = ffi.cast("char*", ctx.mis)
        local home_name = memory.read(p + 0x13c, 0x46):match('[^%z]*')
        local away_name = memory.read(p + 0x690 + 0x13c, 0x46):match('[^%z]*')
		local home_coachname = memory.read(p + 0xe60, 0x46):match('[^%z]*')
		local away_coachname = memory.read(p + 0x10b8, 0x46):match('[^%z]*')
		local game2dEnglandEnterAddressStr = tostring(game2dEnglandEnterAddress):match('0x%x+')
		local game2dEnglandAddressStr = tostring(game2dEnglandAddress):match('0x%x+')
		return string.format([[
Version: %s
game2dEnglandEnter: %s | game2dEngland: %s
Match: %s vs %s
Coach: %s vs %s

Press [0] to reload team colors .ini files
Press [DEL] to clear info messages
%s
]],
		version,
		game2dEnglandEnterAddressStr,
		game2dEnglandAddressStr,
		home_name, away_name,
		home_coachname, away_coachname,
		info_text)
	end
	return text
end

function m.key_down(ctx, vkey)
    if vkey == RELOAD_COLORS_VKEY then
		clear_table(m.load_teamcolors_map)
		clear_table(offsets)
		clear_table(goaltexture_str)
        m.load_teamcolors_map = load_colors(ctx, "colors.ini")
        offsets = load_all_offsets(ctx, "all_offset.ini")
		goaltexture_str = load_all_str(ctx, "teams_str.ini")
		if failed == false then
			info_text = info_text .. "colors, teams_str and all_offsets.ini file reloaded\n"
			log("Team colors, teams str and all offset reload finished.")
		else
			info_text = info_text .. "Failed to open ini's file please restart game!\n"
			log("Failed to open ini's file.")
		end
    elseif vkey == DEL_TEXT_KEY then
        info_text = ""
    end    
end

function m.load_offsets_map(ctx)
    offsets = load_all_offsets(ctx, "all_offset.ini")
    m.assign_offsets(offsets)
end

function m.assign_offsets(offsets)
    m.assign_game2dEnglandEnter(offsets)
    m.assign_game2dEngland(offsets)
	m.assign_pauseMenu(offsets)
	m.assign_licenceTextureEngland(offsets)
end

function m.assign_game2dEnglandEnter(offsets)
	wave0_enter = offsets["wave0_enter"]
	wave1_enter = offsets["wave1_enter"]
	wave2_enter = offsets["wave2_enter"]
	wave3_enter = offsets["wave3_enter"]
	wave4_enter = offsets["wave4_enter"]
	-- wave5_enter = offsets["wave5_enter"]
	homeName_enter = offsets["homeName_enter"]
	awayName_enter = offsets["awayName_enter"]
	lineupShape_enter = offsets["lineupShape_enter"]
	lineupName_enter = offsets["lineupName_enter"]
end

function m.assign_game2dEngland(offsets)
	wave0 = offsets["wave0"]
	wave1 = offsets["wave1"]
	wave2 = offsets["wave2"]
	wave3 = offsets["wave3"]
	wave4 = offsets["wave4"]
	-- wave5 = offsets["wave5"]
	homeName = offsets["homeName"]
	awayName = offsets["awayName"]
	statsHome = offsets["statsHome"]
	statsHome03 = offsets["statsHome03"]
	statsAway = offsets["statsAway"]
	statsAway01 = offsets["statsAway01"]
	statsAway03 = offsets["statsAway03"]
	platehome = offsets["platehome"]
	plate2home = offsets["plate2home"]
	plate2home03 = offsets["plate2home03"]
	plateaway = offsets["plateaway"]
	plateaway03 = offsets["plateaway03"]
	plate2away = offsets["plate2away"]
	plate2away03 = offsets["plate2away03"]
	plate3home = offsets["plate3home"]
	plate3away = offsets["plate3away"]
	plate3away01 = offsets["plate3away01"]
	goalShape = offsets["goalShape"]
	goalShape2 = offsets["goalShape2"]
	goalName = offsets["goalName"]
	CardTime = offsets["CardTime"]
	CardScorer = offsets["CardScorer"]
	CardTeamLogo = offsets["CardTeamLogo"]
	CardPlate = offsets["CardPlate"]
	CardShape = offsets["CardShape"]
	GoalTeamLogo  = offsets["GoalTeamLogo"]
	CardGoal = offsets["CardGoal"]
	CardTexGoal = offsets["CardTexGoal"]
	plate3goalhome = offsets["plate3goalhome"]
	plate3goalhome01 = offsets["plate3goalhome01"]
	plate3goalhome03 = offsets["plate3goalhome03"]
	plate3goalaway = offsets["plate3goalaway"]
	plate3goalaway01 = offsets["plate3goalaway01"]
	plate3goalaway03 = offsets["plate3goalaway03"]
	stats_hide = offsets["stats_hide"]
	stats_bkg = offsets["stats_bkg"]
end

function m.assign_pauseMenu(offsets)
	homePause = offsets["homePause"]
	awayPause = offsets["awayPause"]
end
	
function m.assign_licenceTextureEngland(offsets)
	card_3rdHome = offsets["card_3rdHome"]
	card_3rdHome2 = offsets["card_3rdHome2"]
	card_3rdHome3 = offsets["card_3rdHome3"]
	card_3rdAway = offsets["card_3rdAway"]
	card_3rdAway2 = offsets["card_3rdAway2"]
	card_3rdAway3 = offsets["card_3rdAway3"]
	card_3rdaway_missing = offsets["card_3rdaway_missing"]
	card_3rdaway_2nd_ab = offsets["card_3rdaway_2nd_ab"]
end

function m.init(ctx)
	if sbhroot:sub(1,1)=='.' then
		sbhroot = ctx.sider_dir .. sbhroot
	end
	ctx.register("set_teams", teams_selected)
	ctx.register("after_set_conditions", after_set_conditions)
	ctx.register("livecpk_data_ready", m.data_ready)
	ctx.register("key_down", m.key_down)
	ctx.register("overlay_on", overlay_on)
	clear_table(m.load_teamcolors_map)
	clear_table(offsets)
	clear_table(goaltexture_str)
	m.load_teamcolors_map = load_colors(ctx, "colors.ini")
	m.load_offsets_map(ctx)
    goaltexture_str = load_all_str(ctx, "teams_str.ini")
	if not m.load_teamcolors_map then
		log("Error: table is nil")
	else
		log("Colors: " .. tostring(m.load_teamcolors_map))
		log("Offsets: " .. tostring(offsets))
		log("Texture Strings: " .. tostring(goaltexture_str))
	end
end

return m
