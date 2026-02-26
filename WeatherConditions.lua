local m = {}
local leagues = {}
local contentPath = ".\\content\\weather-conditions"

-- csv indices
INDEX_TOURNAMENT_ID = 1
INDEX_SUMMER_SUNNY = 2
INDEX_SUMMER_CLOUDY = 3
INDEX_SUMMER_RAINY = 4
INDEX_WINTER_SUNNY = 5
INDEX_WINTER_CLOUDY = 6
INDEX_WINTER_RAINY = 7
INDEX_WINTER_SNOWY = 8

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

-- calculate random weather for given league
function getWeatherConditionWithHighestProbability(league, season)
    log("Realistic Weather: season=" .. season)
    -- calculate probabilities
    local sunnyProb = ternary(season == 0, league.summer.sunny, league.winter.sunny)
	log("Realistic Weather: sunnyProb=" .. sunnyProb)
    local cloudyProb = ternary(season == 0, league.summer.cloudy, league.winter.cloudy)
	log("Realistic Weather: cloudyProb=" .. cloudyProb)
    local rainyProb = ternary(season == 0, league.summer.rainy, league.winter.rainy)
	log("Realistic Weather: rainyProb=" .. rainyProb)
    -- disable "snow" if current season is summer
    local snowyProb = ternary(season == 0, 0, league.winter.snowy)
	log("Realistic Weather: snowyProb=" .. snowyProb)

    -- create table with N elements per weather condition respecting the given probability
    local probabilities = {}
    addElementsN(probabilities, sunnyProb, "sunny")
    addElementsN(probabilities, cloudyProb, "cloudy")
    addElementsN(probabilities, rainyProb, "rainy")
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
            if #fields == 8 then
                local league = {
                    summer = { sunny = tonumber(fields[INDEX_SUMMER_SUNNY]), cloudy = tonumber(fields[INDEX_SUMMER_CLOUDY]), rainy = tonumber(fields[INDEX_SUMMER_RAINY]), snowy = 0 },
                    winter = { sunny = tonumber(fields[INDEX_WINTER_SUNNY]), cloudy = tonumber(fields[INDEX_WINTER_CLOUDY]), rainy = tonumber(fields[INDEX_WINTER_RAINY]), snowy = tonumber(fields[INDEX_WINTER_SNOWY]) }
                }
                csvFile[tonumber(fields[INDEX_TOURNAMENT_ID])] = league
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
    local league = leagues[ctx.tournament_id]
	
	-- CHANGE #2
	-- here we (ab)use the new "source" parameter
	if source and source == "StadiumServer" then
		log("Tournament_id received from stadium server: " .. tostring(ctx.tournament_id ))
	end
	-- END CHANGE #2
	
    if league == nil then
        return nil
    end

    -- local isSummer = ternary(options.season == 0, 1, 0)
    local weather = getWeatherConditionWithHighestProbability(league, options.season)
	
	-- log(league)
    -- log("Realistic Weather: isSummer=" .. isSummer .. " :: weather=" .. weather)
    
    -- set calculated weather
    -- weather:         0-Fine, 1-Rainy, 2-Snowy
    -- weather_effects: 2-enforce weather effects (rain/snow falling)
    if weather == "sunny" then
        options.weather = 0
        --options.weather_effects = 0
    elseif weather == "cloudy" then
        options.weather = 1
        --options.weather_effects = 0
    elseif weather == "rainy" then
        options.weather = 1
        options.weather_effects = 2
    elseif weather == "snowy" then
        options.weather = 2
        options.weather_effects = 2
    end

    return options
end


function m.init(ctx)
    math.randomseed(os.clock() * 100000000000)

	if contentPath:sub(1,1) == "." then
		contentPath = ctx.sider_dir .. contentPath
    end
    leagues = readCsv(contentPath .. "\\map_competitions.csv", ";");

    ctx.register("set_conditions", m.set_conditions)
	
	-- CHANGE #3
	-- MOST IMPORTANT CHANGE:
	-- put self (i.e. the entire module m) into the context under some arbitrary name e.g. "weather_conditions"
	-- so that other modules can access the module-level functions from this module (functions with "m." prefix) via ctx object
    ctx.weather_conditions = m
	-- END CHANGE #3
end

return m