-- Realistic Weather Conditions by Baris
-- fix by sltpn3
-- StadiumServer compatibility by zlac
local m = {}

-- probablities for teams
local teams = {}
-- path to weather conditions, which should contain the file "map_teams.csv"
local contentPath = ".\\content\\weather-conditions"

-- csv indices
INDEX_TEAM_ID = 1
INDEX_SUMMER_CLEAR = 2
INDEX_SUMMER_CLOUDY = 3
INDEX_SUMMER_SHOWERS = 4
INDEX_SUMMER_RAINY = 5
INDEX_WINTER_CLEAR = 6
INDEX_WINTER_CLOUDY = 7
INDEX_WINTER_SHOWERS = 8
INDEX_WINTER_RAINY = 9
INDEX_WINTER_FLURRY = 10
INDEX_WINTER_SNOWY = 11

-- help methods
function ternary(cond, T, F)
    if cond then return T else return F end
end

function starts_with(str, start)
    return str:sub(1, #start) == start
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

-- print table (for debugging)
function tprint(t, s)
    if t == nil then
        return;
    end

    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) .. '"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"' .. tostring(v) .. '"'
        if type(v) == 'table' then
            tprint(v, (s or '') .. kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t) .. (s or '') .. kfmt .. ' = ' .. vfmt)
        end
    end
end
------

-- add n (amount) elements to given table, with the given value
function addElementsN(probabilities, amount, value)
    for i = 1, amount do
        table.insert(probabilities, value)
    end
end

-- calculate random weather for given team
function getWeatherConditionWithHighestProbability(team, season)
    log("Realistic Weather: season=" .. season)
    -- calculate probabilities
    local clearProb = ternary(season == 0, team.summer.clear, team.winter.clear)
	log("Realistic Weather: clearProb=" .. clearProb)
    local cloudyProb = ternary(season == 0, team.summer.cloudy, team.winter.cloudy)
	log("Realistic Weather: cloudyProb=" .. cloudyProb)
    local showersProb = ternary(season == 0, team.summer.showers, team.winter.showers)
	log("Realistic Weather: showersProb=" .. showersProb)
    local rainyProb = ternary(season == 0, team.summer.rainy, team.winter.rainy)
	log("Realistic Weather: rainyProb=" .. rainyProb)
    -- disable "snow" if current season is summer
    local flurryProb = ternary(season == 0, 0, team.winter.flurry)
	log("Realistic Weather: flurryProb=" .. flurryProb)
    local snowyProb = ternary(season == 0, 0, team.winter.snowy)
	log("Realistic Weather: snowyProb=" .. snowyProb)

    -- create table with N elements per weather condition respecting the given probability
    local probabilities = {}
    addElementsN(probabilities, clearProb, "clear")
    addElementsN(probabilities, cloudyProb, "cloudy")
    addElementsN(probabilities, showersProb, "showers")
    addElementsN(probabilities, rainyProb, "rainy")
    addElementsN(probabilities, flurryProb, "flurry")
    addElementsN(probabilities, snowyProb, "snowy")
    -- tprint(probabilities)

    -- draw a random number and get weather via index
    return probabilities[math.random(#probabilities)];
end

function readCsv(path, sep)
    sep = sep or ','
    local csvFile = {}
    local file = assert(io.open(path, "r"))
    for line in file:lines() do
        if not starts_with(line, "#") then
            local fields = line:split(sep)
            if #fields == 11 then
                local team = {
                    summer = { clear = tonumber(fields[INDEX_SUMMER_CLEAR]), cloudy = tonumber(fields[INDEX_SUMMER_CLOUDY]), showers = tonumber(fields[INDEX_SUMMER_SHOWERS]), rainy = tonumber(fields[INDEX_SUMMER_RAINY]), flurry = 0, snowy = 0 },
                    winter = { clear = tonumber(fields[INDEX_WINTER_CLEAR]), cloudy = tonumber(fields[INDEX_WINTER_CLOUDY]), showers = tonumber(fields[INDEX_WINTER_SHOWERS]), rainy = tonumber(fields[INDEX_WINTER_RAINY]), flurry = tonumber(fields[INDEX_WINTER_FLURRY]), snowy = tonumber(fields[INDEX_WINTER_SNOWY]) }
                }
                csvFile[tonumber(fields[INDEX_TEAM_ID])] = team
            end
        end
    end
    file:close()

    log("read csv file successfully: " .. #csvFile);

    return csvFile
end


-- CHANGE #1
-- one extra parameter added, 'source' ... nothing really important
-- sider shouldn't set this parameter ... but external scripts could, to indicate who's calling :)
function m.set_conditions(ctx, options, source) 
    local team = teams[ctx.home_team]
    local tid = ctx.tournament_id
	
	-- CHANGE #2
	-- here we (ab)use the new "source" parameter
	if source and source == "StadiumServer" then
		log("team_id received from stadium server: " .. tostring(ctx.team_id))
	end
	-- END CHANGE #2
	
    --if team == nil then
    --    return nil
    --end

    -- local isSummer = ternary(options.season == 0, 1, 0)

    if tid ~= 65535 or tid ~= 43 or tid ~= 104 or tid ~= 1128 or tid ~= 2152 or tid ~= 3176 or tid ~= 46 or 
    tid ~= 44 or tid ~= 1068 or tid ~= 2092 or tid ~= 3116 or tid ~= 4140 or tid ~= 45 or tid ~= 34 or tid ~= 1058 or 
    tid ~= 2082 or tid ~= 3106 or tid ~= 4130 or tid ~= 5154 or tid ~= 6178 or tid ~= 7202 or tid ~= 8226 or tid ~= 35 or tid ~= 7 or 
    tid ~= 105 or tid ~= 106 or tid ~= 107 then
        local weather = getWeatherConditionWithHighestProbability(team, options.season)
        -- log(team)
        -- log("Realistic Weather: isSummer=" .. isSummer .. " :: weather=" .. weather)
        
        -- set calculated weather
        -- weather:         0-Fine, 1-Rainy, 2-Snowy
        -- weather_effects: 1-dynamic rain effects (rain after some time), 2-enforce weather effects (rain/snow falling)
        if weather == "clear" then
            options.weather = 0
            options.weather_effects = 0
        elseif weather == "cloudy" then
            options.weather = 1
            options.weather_effects = 0
        elseif weather == "showers" then
            options.weather = 1
            options.weather_effects = 1
        elseif weather == "rainy" then
            options.weather = 1
            options.weather_effects = 2
        elseif weather == "flurry" then
            options.weather = 2
            options.weather_effects = 1
        elseif weather == "snowy" then
            options.weather = 2
            options.weather_effects = 2
        end
    end

    return options
end


function m.init(ctx)
    math.randomseed(os.clock() * 100000000000)

	if contentPath:sub(1,1) == "." then
		contentPath = ctx.sider_dir .. contentPath
    end
    --teams = readCsv(contentPath .. "\\map_teams.csv", ";");
    teams = readCsv(contentPath .. "\\map_teams.csv", ";");
    ctx.register("set_conditions", m.set_conditions)
	
	-- CHANGE #3
	-- MOST IMPORTANT CHANGE:
	-- put self (i.e. the entire module m) into the context under some arbitrary name e.g. "weather4teams"
	-- so that other modules can access the module-level functions from this module (functions with "m." prefix) via ctx object
    ctx.weather_conditions = m
	-- END CHANGE #3
end

return m