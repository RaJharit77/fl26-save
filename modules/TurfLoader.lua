-- Turf Mod Loader by Mohamed2746
-- Injects randomly a turf mod located in "content\\turf-loader" if the game started.

-- path, which should contain the different turf mods (extracted files, no CPKs!)
local contentPath = ".\\content\\turf-loader"
local TURF_MODS_CSV = "turf-mods.csv"
local LIGHT_MODS_CSV = "light-mods.csv"
local TEAM_TURF_MODS_CSV = "team-turf-mods.csv"
local version = "2.2"
local KEY_FAVORITE_TURF_MOD = "favorite_turf_mod"
local KEY_FAVORITE_LIGHT_MOD = "favorite_light_mod"
local KEY_IS_RANDOM_TURF_MOD_ENABLED = "is_random_turf_mod_enabled"
local KEY_IS_RANDOM_LIGHT_MOD_ENABLED = "is_random_light_mod_enabled"
local KEY_IS_TEAM_TURF_MOD_ENABLED = "is_team_turf_mod_enabled"
local KEY_LOAD_NO_TURF = "load_no_turf"
local KEY_LOAD_NO_LIGHT = "load_no_light"
local NO_MOD = "No Mod"

local TurfMods = {}
local LightMods = {}
local teamTurfMods = {}
local settings = {}
local manualIdx = 1
local selectedTurf
local selectedLight
local isTurfModRandomEnabled
local isLightModRandomEnabled
local isTeamTurfModEnabled
local loadNoTurf
local loadNoLight
local infoText = ""

-- KEYS ----------------------------------------------------------------
local USE_TEAM_TURF_KEY = 0x32 -- 2 key (not the NUMPAD 2)
local RELOAD_MAPS_KEY = 0x33 -- 3 key (not the NUMPAD 3)
local RELOAD_TEAM_MAPS_KEY = 0x34 -- 4 key (not the NUMPAD 4)
local LOAD_NO_MOD = 0x35 -- 5 key (not the NUMPAD 5)
local REMOVE_FAVORITE_SB_KEY = 0x36 -- 6 key (not the NUMPAD 6)
local SET_AS_FAVORITE_SB_KEY = 0x37 -- 7 key (not the NUMPAD 7)
local USE_FAVORITE_SB_KEY = 0x38 -- 8 key (not the NUMPAD 8)
local USE_RANDOM_TURF_KEY = 0x39 -- 9 key (not the NUMPAD 9)
local USE_RANDOM_LIGHT_KEY = 0x30 -- 0 key (not the NUMPAD 0)
local DEL_TEXT_KEY = 0x2E -- Delete Key
local PREVIOUS_SB_KEY = 0x21 -- Page Up
local NEXT_SB_KEY = 0x22 -- Page Down
------------------------------------------------------------------------

-- HELPER BEGIN --------------------------------------------------------
function t2s(t)
	local parts = {}
	for k, v in pairs(t) do
		parts[#parts + 1] = string.format("%s=%s", k, v)
	end
	table.sort(parts) -- sort alphabetically
	return string.format("{%s}", table.concat(parts, ", "))
end

function startsWith(str, start)
	return str:sub(1, #start) == start
end

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)

	return fields
end

function getRandomIdx(tableMod)
	-- get randomly a turf mod
	math.randomseed(os.clock() * 100000000000)

	if tostring(loadNoTurf) == "true" then
		return math.random(1, #tableMod)
	else
		return math.random(2, #tableMod)
	end
end

function isTurfFile(filename)
	if
		string.match(filename, "Asset\\model\\bg\\common\\effect\\")
		or string.match(filename, "Asset\\model\\bg\\common\\goal\\")
		or string.match(filename, "Asset\\model\\bg\\common\\lut\\")
		or string.match(filename, "Asset\\model\\bg\\common\\pitch\\")
		or string.match(filename, "Asset\\model\\bg\\common\\turf3d\\")
		or string.match(filename, "Asset\\model\\bg\\st%d%d%d\\sourceimages\\tga\\#windx11\\")
	then
		return true
	else
		return false
	end
end

function isLightFile(filename)
	if string.match(filename, "Asset\\model\\bg\\st%d%d%d\\light\\#Win\\") then
		return true
	else
		return false
	end
end

function tableContainsValue(table, desiredValue)
	for _, value in pairs(table) do
		if value == desiredValue then
			return true
		end
	end

	return false
end

function readMapTurfMods(path, sep)
	sep = sep or ","
	local csvFile = {}
	local file = assert(io.open(path, "r"))

	-- add option "no mods" which disabled loading a turf mod
	table.insert(csvFile, NO_MOD)

	for line in file:lines() do
		if not startsWith(line, "#") then
			local fields = line:split(sep)
			if #fields == 1 then
				local turfModFolderName = fields[1]
				table.insert(csvFile, turfModFolderName)
			end
		end
	end
	file:close()

	return csvFile
end

function readMapLightMods(path, sep)
	sep = sep or ","
	local csvFile = {}
	local file = assert(io.open(path, "r"))

	-- add option "no mods" which disabled loading a light mod
	table.insert(csvFile, NO_MOD)

	for line in file:lines() do
		if not startsWith(line, "#") then
			local fields = line:split(sep)
			if #fields == 1 then
				local lightModFolderName = fields[1]
				table.insert(csvFile, lightModFolderName)
			end
		end
	end
	file:close()

	return csvFile
end

function readMapTeams(path, sep)
	sep = sep or ","
	local csvFile = {}
	local file = assert(io.open(path, "r"))
	for line in file:lines() do
		if not startsWith(line, "#") then
			local fields = line:split(sep)
			if #fields == 2 then
				-- <team id = turf mod>
				csvFile[tonumber(fields[1])] = fields[2]
			end
		end
	end
	file:close()
	return csvFile
end

-- team turf mod can be only loaded if one of the teams has a turf mod.
-- If both teams have a turf mod assigned, no turf mod will be injected.
function getTeamTurfMod(homeTeamId, awayTeamId)
	if teamTurfMods[homeTeamId] ~= nil and teamTurfMods[awayTeamId] == nil then
		return teamTurfMods[homeTeamId]
	end

	if teamTurfMods[homeTeamId] == nil and teamTurfMods[awayTeamId] ~= nil then
		return teamTurfMods[awayTeamId]
	end

	return nil
end

--- copied from ScoreboardServer.lua, slightly adjusted regex to read values with spaces
local function load_ini(filename)
	local t = {}
	local data = assert(io.lines(contentPath .. "\\" .. filename))

	for line in data do
		local name, value = string.match(line, "^([%w_]+)%s*=%s*([-%w%d. ]+)")
		if name and value then
			value = tonumber(value) or value
			t[name] = value
		end
	end
	return t
end

--- copied from ScoreboardServer.lua
local function save_ini(filename)
	local f = io.open(contentPath .. "\\" .. filename, "wt")
	f:write(string.format("# TurfLoader settings. Generated by TurfLoader.lua\n"))
	f:write("\n")
	local keys = {}
	for name, value in pairs(settings) do
		keys[#keys + 1] = name
	end

	table.sort(keys)

	for i, name in ipairs(keys) do
		local value = settings[name]
		f:write(string.format("%s = %s\n", name, value))
	end
	f:write("\n")
	f:close()
end

local function getFavoriteTurfMod()
	local favoriteTurfMod = settings[KEY_FAVORITE_TURF_MOD]

	if favoriteTurfMod and tableContainsValue(TurfMods, favoriteTurfMod) then
		return favoriteTurfMod
	else
		return nil
	end
end

local function getFavoriteLightMod()
	local favoriteLightMod = settings[KEY_FAVORITE_LIGHT_MOD]

	if favoriteLightMod and tableContainsValue(TurfMods, favoriteLightMod) then
		return favoriteLightMod
	else
		return nil
	end
end

local function getTableModIdx(Mod, tableMods)
	for idx, value in pairs(tableMods) do
		if value == Mod then
			return idx
		end
	end

	return nil
end
-- HELPER END ----------------------------------------------------------

-- EVENTS BEGIN --------------------------------------------------------
function livecpk_make_key(ctx, filename)
	-- don't load any turf mod if NO_MOD is chosen
	if selectedTurf ~= nil and selectedTurf ~= NO_MOD and isTurfFile(filename) then
		return selectedTurf .. "\\" .. filename:gsub("st%d%d%d", "st000")
	end

	if selectedLight ~= nil and selectedLight ~= NO_MOD and isLightFile(filename) then
		return selectedLight .. "\\" .. filename:gsub("st%d%d%d", "st000")
	end
end

function livecpk_get_filepath(ctx, filename, key)
	if key then
		return string.format("%s\\%s", contentPath, key)
	end
end

-- note "isTeamTurfModEnabled" takes precedence over "isTurfModRandomEnabled"
function set_teams(ctx, home_team_id, away_team_id)
	isTeamTurfModEnabled = settings[KEY_IS_TEAM_TURF_MOD_ENABLED]
	if tostring(isTeamTurfModEnabled) == "true" then
		local teamturfMod = getTeamTurfMod(home_team_id, away_team_id)
		if teamturfMod ~= nil then
			selectedTurf = teamturfMod
		end
	end

	-- select only random turf mod if it was enabled
	isTurfModRandomEnabled = settings[KEY_IS_RANDOM_TURF_MOD_ENABLED]
	if tostring(isTurfModRandomEnabled) == "true" then
		manualIdx = getRandomIdx(TurfMods)
		selectedTurf = TurfMods[manualIdx]
	end
	isLightModRandomEnabled = settings[KEY_IS_RANDOM_LIGHT_MOD_ENABLED]
	if tostring(isLightModRandomEnabled) == "true" then
		manualIdx = getRandomIdx(LightMods)
		selectedLight = LightMods[manualIdx]
	end
end

local function overlay_on(ctx)
	return string.format(
		[[
Version %s

          [PageUp]  to manu select next light mod
        [PageDown]  to manually select next turf mod
             [DEL]  to clear info messages
               [2]  to enable/disable choosing team turf mod
               [3]  to reload map %s files
               [4]  to reload map %s files
               [5]  to enable/disable loading "No Mod" while automatically choosing a random turf mod
               [6]  to remove current favorite combination
               [7]  to set current selection as favorite combination
               [8]  to use your favorite combination
               [9]  to enable/disable automatically choosing a random turf mod per match
               [0]  to enable/disable automatically choosing a random light mod per match

      Selected Turf Mod: %s
     Selected Light Mod: %s
  Team Turf Mod Enabled: %s
Enabled Random Turf Mod: %s (Load "No Mod": %s)
Enabled Random Light Mod: %s (Load "No Mod": %s)

%s
]],
		version,
		TURF_MODS_CSV,
		TEAM_TURF_MODS_CSV,
		selectedTurf,
		selectedLight,
		isTeamTurfModEnabled,
		isTurfModRandomEnabled,
		loadNoTurf,
		isLightModRandomEnabled,
		loadNoLight,
		infoText
	)
end

local function key_down(ctx, vkey)
	if vkey == DEL_TEXT_KEY then
		infoText = ""
	end

	if vkey == RELOAD_MAPS_KEY then
		TurfMods = readMapTurfMods(contentPath .. "\\" .. TURF_MODS_CSV, ";")
		LightMods = readMapLightMods(contentPath .. "\\" .. LIGHT_MODS_CSV, ";")
		settings = load_ini("config.ini")
	end

	if vkey == RELOAD_TEAM_MAPS_KEY then
		teamTurfMods = readMapTeams(contentPath .. "\\" .. TEAM_TURF_MODS_CSV, ";")
		settings = load_ini("config.ini")
	end

	if vkey == PREVIOUS_SB_KEY then
		manualIdx = manualIdx % #LightMods + 1
		selectedLight = LightMods[manualIdx]
	end

	if vkey == NEXT_SB_KEY then
		manualIdx = manualIdx % #TurfMods + 1
		selectedTurf = TurfMods[manualIdx]
	end

	if vkey == SET_AS_FAVORITE_SB_KEY then
		if selectedTurf and tableContainsValue(TurfMods, selectedTurf) then
			settings[KEY_FAVORITE_TURF_MOD] = selectedTurf
			infoText = infoText .. string.format("Turf mod %s saved as favorite\n", selectedTurf)
		else
			infoText = infoText .. "Could not save favorite Turf mod\n"
		end
		if selectedLight and tableContainsValue(LightMods, selectedLight) then
			settings[KEY_FAVORITE_LIGHT_MOD] = selectedLight
			infoText = infoText .. string.format("Light mod %s saved as favorite\n", selectedLight)
		else
			infoText = infoText .. "Could not save favorite Light mod\n"
		end
		save_ini("config.ini")
	end

	if vkey == REMOVE_FAVORITE_SB_KEY then
		local favoriteTurfMod = settings[KEY_FAVORITE_TURF_MOD]
		settings[KEY_FAVORITE_TURF_MOD] = ""
		local favoriteLightMod = settings[KEY_FAVORITE_LIGHT_MOD]
		settings[KEY_FAVORITE_LIGHT_MOD] = ""
		save_ini("config.ini")
		infoText = infoText .. string.format("Removed Turf mod %s as favorite\n", favoriteTurfMod)
		infoText = infoText .. string.format("Removed Light mod %s as favorite\n", favoriteLightMod)
	end

	if vkey == USE_FAVORITE_SB_KEY then
		local favoriteTurfMod = getFavoriteTurfMod()
		local favoriteLightMod = getFavoriteLightMod()

		if favoriteTurfMod then
			infoText = infoText .. string.format("Favorite turf mod %s set as active\n", favoriteTurfMod)
			manualIdx = getTableModIdx(favoriteTurfMod, TurfMods)
			selectedTurf = favoriteTurfMod
		else
			infoText = infoText .. string.format("Could not find favorite turf mod\n")
		end

		if favoriteLightMod then
			infoText = infoText .. string.format("Favorite light mod %s set as active\n", favoriteLightMod)
			manualIdx = getTableModIdx(favoriteLightMod, LightMods)
			selectedLight = favoriteLightMod
		else
			infoText = infoText .. string.format("Could not find favorite light mod\n")
		end
	end

	if vkey == USE_RANDOM_TURF_KEY then
		local settingsIsRandomEnabled = settings[KEY_IS_RANDOM_TURF_MOD_ENABLED]
		if settingsIsRandomEnabled == "false" then
			isTurfModRandomEnabled = "true"
		else
			isTurfModRandomEnabled = "false"
		end

		settings[KEY_IS_RANDOM_TURF_MOD_ENABLED] = isTurfModRandomEnabled
		save_ini("config.ini")
	end

	if vkey == USE_RANDOM_LIGHT_KEY then
		local settingsIsRandomEnabled = settings[KEY_IS_RANDOM_LIGHT_MOD_ENABLED]
		if settingsIsRandomEnabled == "false" then
			isLightModRandomEnabled = "true"
		else
			isLightModRandomEnabled = "false"
		end

		settings[KEY_IS_RANDOM_LIGHT_MOD_ENABLED] = isLightModRandomEnabled
		save_ini("config.ini")
	end

	if vkey == USE_TEAM_TURF_KEY then
		local settingsIsTeamTurfModEnabled = settings[KEY_IS_TEAM_TURF_MOD_ENABLED]
		if settingsIsTeamTurfModEnabled == "false" then
			isTeamTurfModEnabled = "true"
		else
			isTeamTurfModEnabled = "false"
		end

		settings[KEY_IS_TEAM_TURF_MOD_ENABLED] = isTeamTurfModEnabled
		save_ini("config.ini")
	end

	if vkey == LOAD_NO_MOD then
		local settingsloadNoMod = settings[KEY_LOAD_NO_TURF]
		if settingsloadNoMod == "false" then
			loadNoTurf = "true"
		else
			loadNoTurf = "false"
		end

		settings[KEY_LOAD_NO_TURF] = loadNoTurf

		local settingsloadNoMod = settings[KEY_LOAD_NO_LIGHT]
		if settingsloadNoMod == "false" then
			loadNoLight = "true"
		else
			loadNoLight = "false"
		end

		settings[KEY_LOAD_NO_LIGHT] = loadNoLight
		save_ini("config.ini")
	end
end
-- EVENTS END --------------------------------------------------------

function init(ctx)
	if contentPath:sub(1, 1) == "." then
		contentPath = ctx.sider_dir .. contentPath
	end

	TurfMods = readMapTurfMods(contentPath .. "\\" .. TURF_MODS_CSV, ";")
	LightMods = readMapTurfMods(contentPath .. "\\" .. LIGHT_MODS_CSV, ";")
	teamTurfMods = readMapTeams(contentPath .. "\\" .. TEAM_TURF_MODS_CSV, ";")
	settings = load_ini("config.ini")

	local favoriteTurfMod = getFavoriteTurfMod()
	if favoriteTurfMod ~= nil then
		manualIdx = getTableModIdx(favoriteTurfMod, TurfMods)
	end

	selectedTurf = TurfMods[manualIdx]

	local favoriteLightMod = getFavoriteLightMod()
	if favoriteLightMod ~= nil then
		manualIdx = getTableModIdx(favoriteLightMod, LightMods)
	end

	selectedLight = LightMods[manualIdx]

	isTurfModRandomEnabled = settings[KEY_IS_RANDOM_TURF_MOD_ENABLED]
	if isTurfModRandomEnabled == nil then
		isTurfModRandomEnabled = "false"
	end

	isLightModRandomEnabled = settings[KEY_IS_RANDOM_LIGHT_MOD_ENABLED]
	if isLightModRandomEnabled == nil then
		isLightModRandomEnabled = "false"
	end

	isTeamTurfModEnabled = settings[KEY_IS_TEAM_TURF_MOD_ENABLED]
	if isTeamTurfModEnabled == nil then
		isTeamTurfModEnabled = "false"
	end

	loadNoTurf = settings[KEY_LOAD_NO_TURF]
	if loadNoTurf == nil then
		loadNoTurf = "false"
	end

	loadNoLight = settings[KEY_LOAD_NO_LIGHT]
	if loadNoLight == nil then
		loadNoLight = "false"
	end

	ctx.register("livecpk_make_key", livecpk_make_key)
	ctx.register("livecpk_get_filepath", livecpk_get_filepath)
	ctx.register("overlay_on", overlay_on)
	ctx.register("key_down", key_down)
	ctx.register("set_teams", set_teams)
end

return { init = init }
