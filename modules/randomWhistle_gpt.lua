-- RandomMenu Mod Loader edited by eulinho credits PESWEB

local m = {}

local contentPath = ".\\content\\whistle_ref"
local whistle_ref = {}
local currentWhistle
local lastWhistle  -- NEU: letzter verwendeter Whistle

function getFolders(path)
    local command = string.format([[dir "%s" /b /ad]], path)

    for dir in io.popen(command):lines() do
        table.insert(whistle_ref, dir)
    end

    return whistle_ref
end

function m.livecpk_get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s", contentPath, key)
    end
end

function m.livecpk_make_key(ctx, filename)
    if currentWhistle ~= nil then
        return currentWhistle .. "\\" .. filename
    end
end

function getRandomMod()
    math.randomseed(os.time())

    -- Wenn nur ein Whistle vorhanden ist, gib ihn zurück
    if #whistle_ref == 1 then
        return whistle_ref[1]
    end

    -- NEU: Zufällig auswählen, aber nicht denselben wie beim letzten Mal
    local index = math.random(1, #whistle_ref)

    -- Wiederholen, bis ein anderer als der letzte gewählt wurde
    while whistle_ref[index] == lastWhistle do
        index = math.random(1, #whistle_ref)
    end

    return whistle_ref[index]
end

function chooseWhistle()
    lastWhistle = currentWhistle  -- Merken, was zuletzt gewählt war
    currentWhistle = getRandomMod()
    log("Current whistle is = " .. currentWhistle)
end

function m.init(ctx)
    if contentPath:sub(1, 1) == "." then
        contentPath = ctx.sider_dir .. contentPath
    end

    whistle_ref = getFolders(contentPath)
    chooseWhistle()  -- ruft getRandomMod auf und berücksichtigt Wiederholungen

    ctx.register("livecpk_make_key", m.livecpk_make_key)
    ctx.register("livecpk_get_filepath", m.livecpk_get_filepath)
    ctx.register("set_teams", chooseWhistle)
end

return m