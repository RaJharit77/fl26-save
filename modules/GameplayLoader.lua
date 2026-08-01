-- Gameplay Mod Loader by Baris
-- Injects randomly a gameplay mod located in "content\\gameplay-loader" if the game started.

-- path, which should contain the different gameplay mods (extracted files, no CPKs!)
local contentPath  = ".\\content\\gameplay-loader"
local GAMEPLAY_MODS_CSV = "gameplay-mods.csv"
local TEAM_GAMEPLAY_MODS_CSV = "team-gameplay-mods.csv"
local version = "2.7"
local KEY_FAVORITE_GAMEPLAY_MOD = "favorite_gameplay_mod"
local KEY_IS_RANDOM_GAMEPLAY_MOD_ENABLED = "is_random_gameplay_mod_enabled"
local KEY_IS_TEAM_GAMEPLAY_MOD_ENABLED = "is_team_gameplay_mod_enabled"
local KEY_LOAD_NO_MOD = "load_no_mod"
local NO_MOD = "No Mod"

local gameplayMods = {}
local teamGameplayMods = {}
local settings = {}
local manualIdx = 1
local selectedMod
local isGameplayModRandomEnabled
local isTeamGameplayModEnabled
local loadNoMod
local infoText = "";

-- KEYS ----------------------------------------------------------------
local USE_TEAM_GAMEPLAY_KEY = 0x32      -- 2 key (not the NUMPAD 2)
local RELOAD_MAPS_KEY = 0x33            -- 3 key (not the NUMPAD 3)
local RELOAD_TEAM_MAPS_KEY = 0x34       -- 4 key (not the NUMPAD 4)
local LOAD_NO_MOD = 0x35                -- 5 key (not the NUMPAD 5)
local REMOVE_FAVORITE_SB_KEY = 0x36     -- 6 key (not the NUMPAD 6)
local SET_AS_FAVORITE_SB_KEY = 0x37     -- 7 key (not the NUMPAD 7)
local USE_FAVORITE_SB_KEY = 0x38        -- 8 key (not the NUMPAD 8)
local USE_RANDOM_GAMEPLAY_KEY = 0x39    -- 9 key (not the NUMPAD 9)
local DEL_TEXT_KEY = 0x2E               -- Delete Key
local PREVIOUS_SB_KEY = 0x21            -- Page Up
local NEXT_SB_KEY = 0x22                -- Page Down
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
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

function getRandomIdx()
    -- get randomly a gameplay mod
    math.randomseed(os.clock() * 100000000000)

    if (tostring(loadNoMod) == "true") then
        return math.random(1, #gameplayMods)
    else
        return math.random(2, #gameplayMods)
    end
end

function isGameplayFile(filename)
    if      string.match(filename, "common\\match\\constant\\constant_match.bin")           or
            string.match(filename, "common\\match\\constant\\constant_player.bin")          or
            string.match(filename, "common\\match\\constant\\constant_positionCK.bin")      or
            string.match(filename, "common\\match\\constant\\constant_positionPK.bin")      or
            string.match(filename, "common\\match\\constant\\constant_shootAging.bin")      or
            string.match(filename, "common\\match\\constant\\constant_stadium.bin")         or
            string.match(filename, "common\\match\\constant\\constant_team.bin")            or
            string.match(filename, "common\\match\\constant\\constant_tutorial.bin")        or
            string.match(filename, "common\\match\\constant\\constant_tutorialConsole.bin") or
            string.match(filename, "common\\match\\constant\\constant_tutorialConsole.bin")
    then
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

function readMapGameplayMods(path, sep)
    sep = sep or ','
    local csvFile = {}
    local file = assert(io.open(path, "r"))

    -- add option "no mods" which disabled loading a gameplay mod
    table.insert(csvFile, NO_MOD)

    for line in file:lines() do
        if not startsWith(line, "#") then
            local fields = line:split(sep)
            if #fields == 1 then
                local gameplayModFolderName = fields[1]
                table.insert(csvFile, gameplayModFolderName)
            end
        end
    end
    file:close()

    return csvFile
end

function readMapTeams(path, sep)
    sep = sep or ','
    local csvFile = {}
    local file = assert(io.open(path, "r"))
    for line in file:lines() do
        if not startsWith(line, "#") then
            local fields = line:split(sep)
            if #fields == 2 then
                -- <team id = gameplay mod>
                csvFile[tonumber(fields[1])] = fields[2]
            end
        end
    end
    file:close()

    return csvFile
end

-- team gameplay mod can be only loaded if one of the teams has a gameplay mod.
-- If both teams have a gameplay mod assigned, no gameplay mod will be injected.
function getTeamGameplayMod(homeTeamId, awayTeamId)
    if teamGameplayMods[homeTeamId] ~= nil and teamGameplayMods[awayTeamId] == nil then
        return teamGameplayMods[homeTeamId]
    end

    if teamGameplayMods[homeTeamId] == nil and teamGameplayMods[awayTeamId] ~= nil then
        return teamGameplayMods[awayTeamId]
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
    f:write(string.format("# GameplayLoader settings. Generated by GameplayLoader.lua\n"))
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

local function getFavoriteGameplayMod()
    local favoriteGameplayMod = settings[KEY_FAVORITE_GAMEPLAY_MOD]

    if favoriteGameplayMod and tableContainsValue(gameplayMods, favoriteGameplayMod) then
        return favoriteGameplayMod
    else
        return nil
    end
end

local function getGameplayModIdx(gameplayMod)
    for idx, value in pairs(gameplayMods) do
        if value == gameplayMod then
            return idx
        end
    end

    return nil
end
-- HELPER END ----------------------------------------------------------



-- EVENTS BEGIN --------------------------------------------------------
function livecpk_make_key(ctx, filename)
    -- don't load any gameplay mod if NO_MOD is chosen
    if selectedMod ~= nil and selectedMod ~= NO_MOD and isGameplayFile(filename) then
        --log(selectedMod .. "\\" .. filename)

        return selectedMod .. "\\" .. filename
    end
end

function livecpk_get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s", contentPath, key)
    end
end

-- note "isTeamGameplayModEnabled" takes precedence over "isGameplayModRandomEnabled"
function set_teams(ctx, home_team_id, away_team_id)

    isTeamGameplayModEnabled = settings[KEY_IS_TEAM_GAMEPLAY_MOD_ENABLED]
    if tostring(isTeamGameplayModEnabled) == "true" then
        local teamGameplayMod = getTeamGameplayMod(home_team_id, away_team_id)
        if teamGameplayMod ~= nil then
            selectedMod = teamGameplayMod
			
            return
        end
    end

    -- select only random gameplay mod if it was enabled
    isGameplayModRandomEnabled = settings[KEY_IS_RANDOM_GAMEPLAY_MOD_ENABLED]
    if tostring(isGameplayModRandomEnabled) == "true" then
        manualIdx = getRandomIdx()
        selectedMod = gameplayMods[manualIdx]
        -- infoText = infoText .. string.format("Random gameplay mod chosen: %s\n", selectedMod)

        return
    end
end

local function overlay_on(ctx)
    return string.format([[
Version %s

[PageUp][PageDown]  to manually select previous/next gameplay mod
             [DEL]  to clear info messages
               [2]  to enable/disable choosing team gameplay mod
               [3]  to reload map %s files
               [4]  to reload map %s files
               [5]  to enable/disable loading "No Mod" while automatically choosing a random gameplay mod
               [6]  to remove current favorite gameplay mod
               [7]  to set current selection as favorite gameplay mod
               [8]  to use your favorite gameplay mod
               [9]  to enable/disable automatically choosing a random gameplay mod per match

      Selected Gameplay Mod: %s
  Team Gameplay Mod Enabled: %s
Enabled Random Gameplay Mod: %s (Load "No Mod": %s)

%s
]],
        version, GAMEPLAY_MODS_CSV, TEAM_GAMEPLAY_MODS_CSV, selectedMod, isTeamGameplayModEnabled,
        isGameplayModRandomEnabled, loadNoMod, infoText)
end

local function key_down(ctx, vkey)
    if vkey == DEL_TEXT_KEY then
        infoText = ""
    end

    if vkey == RELOAD_MAPS_KEY then
        gameplayMods = readMapGameplayMods(contentPath .. "\\" .. GAMEPLAY_MODS_CSV, ";");
        settings = load_ini("config.ini")
    end

    if vkey == RELOAD_TEAM_MAPS_KEY then
        teamGameplayMods = readMapTeams(contentPath .. "\\" .. TEAM_GAMEPLAY_MODS_CSV, ";");
        settings = load_ini("config.ini")
    end

    if vkey == PREVIOUS_SB_KEY then
        manualIdx = ((manualIdx - 1) + #gameplayMods - 1) % #gameplayMods + 1
        selectedMod = gameplayMods[manualIdx]
    end

    if vkey == NEXT_SB_KEY then
        manualIdx = manualIdx % #gameplayMods + 1
        selectedMod = gameplayMods[manualIdx]
    end

    if vkey == SET_AS_FAVORITE_SB_KEY then
        if selectedMod and tableContainsValue(gameplayMods, selectedMod) then
            settings[KEY_FAVORITE_GAMEPLAY_MOD] = selectedMod
            save_ini("config.ini")
            infoText = infoText .. string.format("Gameplay mod %s saved as favorite\n", selectedMod)
        else
            infoText = infoText .. "Could not save favorite gameplay mod\n"
        end
    end

    if vkey == REMOVE_FAVORITE_SB_KEY then
        local favoriteGameplayMod = settings[KEY_FAVORITE_GAMEPLAY_MOD]
        settings[KEY_FAVORITE_GAMEPLAY_MOD] = ""
        save_ini("config.ini")
        infoText = infoText .. string.format("Removed gameplay mod %s as favorite\n", favoriteGameplayMod)
    end

    if vkey == USE_FAVORITE_SB_KEY then
        local favoriteGameplayMod = getFavoriteGameplayMod()

        if favoriteGameplayMod then
            infoText = infoText .. string.format("Favorite gameplay mod %s set as active\n", favoriteGameplayMod)
            manualIdx = getGameplayModIdx(favoriteGameplayMod)
            selectedMod = favoriteGameplayMod
        else
            infoText = infoText .. string.format("Could not find favorite gameplay mod\n")
        end
    end

    if vkey == USE_RANDOM_GAMEPLAY_KEY then
        local settingsIsRandomEnabled = settings[KEY_IS_RANDOM_GAMEPLAY_MOD_ENABLED]
        if (settingsIsRandomEnabled == "false") then
            isGameplayModRandomEnabled = "true"
        else
            isGameplayModRandomEnabled = "false"
        end

        settings[KEY_IS_RANDOM_GAMEPLAY_MOD_ENABLED] = isGameplayModRandomEnabled
        save_ini("config.ini")
    end

    if vkey == USE_TEAM_GAMEPLAY_KEY then
        local settingsIsTeamGameplayModEnabled = settings[KEY_IS_TEAM_GAMEPLAY_MOD_ENABLED]
        if (settingsIsTeamGameplayModEnabled == "false") then
            isTeamGameplayModEnabled = "true"
        else
            isTeamGameplayModEnabled = "false"
        end

        settings[KEY_IS_TEAM_GAMEPLAY_MOD_ENABLED] = isTeamGameplayModEnabled
        save_ini("config.ini")
    end

    if vkey == LOAD_NO_MOD then
        local settingsloadNoMod = settings[KEY_LOAD_NO_MOD]
        if (settingsloadNoMod == "false") then
            loadNoMod = "true"
        else
            loadNoMod = "false"
        end

        settings[KEY_LOAD_NO_MOD] = loadNoMod
        save_ini("config.ini")
    end

end
-- EVENTS END --------------------------------------------------------



function init(ctx)
    if contentPath:sub(1, 1) == "." then
        contentPath = ctx.sider_dir .. contentPath
    end

    gameplayMods = readMapGameplayMods(contentPath .. "\\" .. GAMEPLAY_MODS_CSV, ";");
    teamGameplayMods = readMapTeams(contentPath .. "\\" .. TEAM_GAMEPLAY_MODS_CSV, ";")
    settings = load_ini("config.ini")

    local favoriteGameplayMod = getFavoriteGameplayMod()
    if favoriteGameplayMod ~= nil then
        manualIdx = getGameplayModIdx(favoriteGameplayMod)
    end

    selectedMod = gameplayMods[manualIdx]

    isGameplayModRandomEnabled = settings[KEY_IS_RANDOM_GAMEPLAY_MOD_ENABLED]
    if isGameplayModRandomEnabled == nil then
        isGameplayModRandomEnabled = "false"
    end

    isTeamGameplayModEnabled = settings[KEY_IS_TEAM_GAMEPLAY_MOD_ENABLED]
    if isTeamGameplayModEnabled == nil then
        isTeamGameplayModEnabled = "false"
    end

    loadNoMod = settings[KEY_LOAD_NO_MOD]
    if loadNoMod == nil then
        loadNoMod = "false"
    end

    ctx.register("livecpk_make_key", livecpk_make_key)
    ctx.register("livecpk_get_filepath", livecpk_get_filepath)
    ctx.register("overlay_on", overlay_on)
    ctx.register("key_down", key_down)
    ctx.register("set_teams", set_teams)
end

return { init = init }