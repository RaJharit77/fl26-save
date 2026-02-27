local fileroot = ".\\content\\SubBoard"

function make_key(ctx, filename)
	tid = ctx.tournament_id
	home = ctx.home_team

    if tid == 1 or tid == 34 or tid == 1058 or tid == 2082 or tid == 56 or tid == 57 or tid == 58 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 or tid == 36 or tid == 1060 or tid == 2084 or tid == 3108 or tid == 4132 or tid == 5156 or tid == 6180 or tid == 7204 or tid == 8228 or tid == 37 or tid == 1061 or tid == 38 or tid == 1062 or tid == 39 or tid == 1063 or tid == 2087 or tid == 40 or tid == 1064 or tid == 2088 or tid == 65535 then
		   SubBoard = "FIFA"
    elseif tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 then
		   SubBoard = "UEFA\\Champions League"
    elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
		   SubBoard = "UEFA\\Europa League"
    elseif tid == 7 then
		   SubBoard = "UEFA\\Super Cup"
    elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 then
		   SubBoard = "UEFA\\Euro 2020"
    elseif tid == 36 or tid == 1060 or tid == 2084 or tid == 3108 or tid == 4132 or tid == 5156 or tid == 6180 or tid == 7204 or tid == 8228 then
           SubBoard = "UEFA\\European Qualifiers"
    elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then
		   SubBoard = "CONMEBOL\\Conmebol Libertadores"
    elseif tid == 36 or tid == 1060 or tid == 2084 or tid == 3108 or tid == 4132 or tid == 5156 or tid == 6180 or tid == 7204 or tid == 8228 or tid == 37 or tid == 1061 or tid == 38 or tid == 1062 or tid == 39 or tid == 1063 or tid == 2087 or tid == 40 or tid == 1064 or tid == 2088 then
		   SubBoard = "CONMEBOL\\Conmebol Eliminatorias"
    elseif tid == 104 or tid == 1128 or tid == 2152 or tid == 3176 or tid == 43 then
		   SubBoard = "CONMEBOL\\Copa America"
    elseif tid == 17 then
		   SubBoard = "England\\Premier League"
    elseif tid == 79 or tid == 83 then
		   SubBoard = "England\\EFL Championship"
    elseif tid == 23 then
		   SubBoard = "England\\FA Cup"
    elseif tid == 86 then
		   SubBoard = "England\\Community Shield"
    elseif tid == 50 then
            SubBoard = "France\\Ligue 1"
    elseif tid == 20 then
            SubBoard = "Germany\\Bundesliga"
    elseif tid == 26 then
            SubBoard = "Germany\\DFB Pokal"
    elseif tid == 81 then
            SubBoard = "Germany\\Bundesliga"
    elseif tid == 18 then
           SubBoard = "Italy\\Serie A"
    elseif tid == 24 then
           SubBoard = "Italy\\Coppa Italia"
    elseif tid == 24 then
           SubBoard = "Italy\\Supercoppa"
    elseif tid == 19 then
		   SubBoard = "Spain\\La Liga"
    elseif tid == 117 then
		   SubBoard = "Swiss\\Raiffeisen SL"
    elseif tid == 67 or tid == 68 then
		   SubBoard = "Chile\\Campeonato AFP Planvital"
    elseif tid == 29 or tid == 31 or tid == 163 then
		   SubBoard = "Argentina\\Liga Profesional de Futbol"
    elseif tid == 52 or tid == 55 or tid == 97 then
		   SubBoard = "Japan"
    elseif tid == 120 or tid == 127 or tid == 132 then
            SubBoard = "Liga MX"
	else
		   SubBoard = nil
    end
    if tid then
       return string.format("%s:%s", SubBoard, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s\\%s", fileroot, SubBoard, filename)
    end
end

function make_log(ctx)
    if SubBoard ~= nil then
       logResult = SubBoard
       log("-------- " .. logResult)
    end
end

local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
	ctx.register("livecpk_make_log", make_log)
end

return { init = init }