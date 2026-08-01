-- BallBoys module for PES 2021: assign ballboys + bench players for the home team/competitions
-- Custom content is used, not LiveCPK/game: content\ballboys_server is the root
-- Author: Hawke, 2021
-- version: 2.0
-- originally posted on evo-web

local fileroot = ".\\content\\ballboys_server"

local function make_key(ctx, filename)
	tid = ctx.tournament_id
	home = ctx.home_team
        away = ctx.away_team
	stadium = ctx.stadium
    
    --Tournaments
    if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 
    or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4 then ballboys_server= "Ballboys\\UCL"
    elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 
    or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then ballboys_server = "Ballboys\\UEL"
    elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 
    then ballboys_server = "Ballboys\\EURO 2024"
    elseif tid == 7 then ballboys_server = "Ballboys\\USC"
    elseif tid == 105 or tid == 106 or tid == 107 then ballboys_server = "Ballboys\\ICC"
    elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 
    or tid == 4105 or tid == 5129 or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then ballboys_server = "Ballboys\\Copa Lib"
    elseif tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16 then ballboys_server = "Ballboys\\AFC"
    elseif tid == 43 or tid == 1128 or tid == 2152 or tid == 3176 or tid == 104 then ballboys_server = "Ballboys\\Copa America"
    elseif tid == 86 then ballboys_server = "Ballboys\\FA Com"
    elseif tid == 23 then ballboys_server = "Ballboys\\FA Cup"

    --Teams
	elseif home == 5 then
        ballboys_server = "Ballboys\\England"
	elseif home == 100 then
        ballboys_server = "Ballboys\\Man United"
    elseif home == 101 then
        ballboys_server = "Ballboys\\Arsenal"		
    elseif home == 102 then
        ballboys_server = "Ballboys\\Chelsea"
    elseif home == 103 then
        ballboys_server = "Ballboys\\Liverpool"		
    elseif home == 104 then
        ballboys_server = "Ballboys\\Leeds"		
    elseif home == 108 and stadium == 2 then
        ballboys_server = "Ballboys\\Barcelona" 
    elseif home == 109 then
        ballboys_server = "Ballboys\\Real Madrid"
	elseif home == 110 then
		ballboys_server = "Ballboys\\Valencia CF"
    elseif home == 113 then
        ballboys_server = "Ballboys\\Marseille"		
    elseif home == 114 then
        ballboys_server = "Ballboys\\PSG"
	elseif home == 116 then
		ballboys_server = "Ballboys\\Ajax Amsterdan"
	elseif home == 120 then
		ballboys_server = "Ballboys\\Juventus"
	elseif home == 121 then
		ballboys_server = "Ballboys\\AC Milan"
	elseif home == 125 then
		ballboys_server = "Ballboys\\AS Roma"
	elseif home == 138 then
		ballboys_server = "Ballboys\\River Plate"
	elseif home == 139 then
		ballboys_server = "Ballboys\\Boca Juniors"
    elseif home == 173 then
        ballboys_server = "Ballboys\\Man City"
    elseif home == 127 then
        ballboys_server = "Ballboys\\Bayern"
    elseif home == 172 then
        ballboys_server = "Ballboys\\Atletico"		
    elseif home == 179 then
        ballboys_server = "Ballboys\\Spurs"
	elseif home == 181 then
		ballboys_server = "Ballboys\\Olympique Lyonnais"
	elseif home == 191 then
		ballboys_server = "Ballboys\\Benfica"
	elseif home == 192 then
		ballboys_server = "Ballboys\\Porto"
	elseif home == 193 then
		ballboys_server = "Ballboys\\Sporting Lisboa"
    elseif home == 207 then
        ballboys_server = "Ballboys\\Southampton"		
    elseif home == 208 then
        ballboys_server = "Ballboys\\Wolves"
    elseif home == 327 then
        ballboys_server = "Ballboys\\Napoli"		
    elseif home == 394 then
        ballboys_server = "Ballboys\\Sheffield Wed"
    elseif home == 1252 then
        ballboys_server = "Ballboys\\Inter"		
    elseif home == 2293 then
        ballboys_server = "Ballboys\\Dortmund"

    else
        ballboys_server = nil
    end

    if ballboys_server ~= nil then
        return string.format("%s:%s", ballboys_server, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key and ballboys_server ~= nil then
        return string.format("%s\\%s\\%s", fileroot, ballboys_server, filename)
    end
end

function make_log(ctx)
    if ballboys_server ~= nil then
       logResult = ballboys_server
       logResult = string.gsub(logResult, "Ballboys\\", "")
       log("-------- " .. logResult)
    end
end

local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("trophy_rewrite", make_log)
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }