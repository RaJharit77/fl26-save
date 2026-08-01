--Stadium Boards for PES 2020
--Edited by FuNZoTiK on 01/06/2020

local fileroot = ".\\content\\Stadium_Board"
local tid

local function set_random(ctx)
	tid = ctx.tournament_id
	home = ctx.home_team
	away = ctx.away_team
end

function make_key(ctx, filename)
	-- Master League/BAL/League/Cup
    if tid == 17 then
		 Stadium_Board = "Premier League"
	elseif home == 114 then
		 Stadium_Board = "Ligue 1\\PSG"
	elseif (home == 414 or home == 403 or home == 115 or home == 4123 or home == 1328 or home == 1329 or home == 213 or home == 112 or home == 215 or home == 216 or home == 217 or home == 1910 or home == 181 or home == 113 or home == 218 or home == 418 or home == 1330 or home == 4213 or home == 182) and (tid == 20) then
		 Stadium_Board = "Ligue 1"
	elseif tid == 18 then
	     Stadium_Board = "Serie A"
	elseif tid == 21 then
		 Stadium_Board = "Eredivisie"
	elseif tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159 then
		 Stadium_Board = "Jupiler Pro League"
	elseif tid == 50 then
	     Stadium_Board = "Bundesliga"
	elseif tid == 53 then
	     Stadium_Board = "DFB Pokal"
	elseif tid == 95 then
	     Stadium_Board = "DFL Supercup"
	elseif tid == 79 or tid == 83 then
		 Stadium_Board = "EFL"
	elseif tid == 19 then
		 Stadium_Board = "LaLiga"
	elseif tid == 29 then
		 Stadium_Board = "Brasileiro Serie A"
    elseif tid == 65535 or tid == 47 or tid == 48 or tid == 99 or tid == 9400 or tid == 9401 or tid == 9402 or tid == 9403 or tid == 9404 or tid == 9405 or tid == 9406 or tid == 9407 then
		 --Exhibition
	     if (home == 101 or home == 104 or home == 107 or home == 378 or home == 377 or home == 102 or home == 382 or home == 177 or home == 399 or home == 4194 or home == 204 or home == 103 or home == 173 or home == 100 or home == 106 or home == 207 or home == 179 or home == 178 or home == 105 or home == 208) and (away == 101 or away == 104 or away == 107 or away == 378 or away == 377 or away == 102 or away == 382 or away == 177 or away == 399 or away == 4194 or away == 204 or away == 103 or away == 173 or away == 100 or away == 106 or away == 207 or away == 179 or away == 178 or away == 105 or away == 208) then
	         Stadium_Board = "Premier League"
		 elseif (home == 1588 or home == 201 or home == 176 or home == 4071 or home == 4180 or home == 1760 or home == 379 or home == 4183 or home == 383 or home == 2610 or home == 4363 or home == 205 or home == 387 or home == 388 or home == 389 or home == 4192 or home == 4193 or home == 1327 or home == 391 or home == 394 or home == 395 or home == 1909 or home == 398 or home == 5096) and (away == 1588 or away == 201 or away == 176 or away == 4071 or away == 4180 or away == 1760 or away == 379 or away == 4183 or away == 383 or away == 2610 or away == 4363 or away == 205 or away == 387 or away == 388 or away == 389 or away == 4192 or away == 4193 or away == 1327 or away == 391 or away == 394 or away == 395 or away == 1909 or away == 398 or away == 5096) then
	         Stadium_Board = "EFL"
		 elseif (home == 414 or home == 403 or home == 115 or home == 4123 or home == 1328 or home == 1329 or home == 213 or home == 112 or home == 215 or home == 216 or home == 217 or home == 1910 or home == 181 or home == 113 or home == 218 or home == 418 or home == 1330 or home == 4213 or home == 182) and (away == 414 or away == 403 or away == 115 or away == 4123 or away == 1328 or away == 1329 or away == 213 or away == 112 or away == 215 or away == 216 or away == 217 or away == 1910 or away == 181 or away == 113 or away == 114 or away == 218 or away == 418 or away == 1330 or away == 4213 or away == 182) then
	         Stadium_Board = "Ligue 1"
	     elseif (home == 234 or home == 186 or home == 1363 or home == 320 or home == 124 or home == 323 or home == 336 or home == 119 or home == 120 or home == 122 or home == 121 or home == 327 or home == 123 or home == 125 or home == 240 or home == 1919 or home == 1600 or home == 4232 or home == 333 or home == 190) and (away == 234 or away == 186 or away == 1363 or away == 320 or away == 124 or away == 323 or away == 336 or away == 119 or away == 120 or away == 122 or away == 121 or away == 327 or away == 123 or away == 125 or away == 240 or away == 1919 or away == 1600 or away == 4232 or away == 333 or away == 190) then
			 Stadium_Board = "Serie A"
		 elseif (home == 4145 or home == 258 or home == 108 or home == 4146 or home == 362 or home == 1765 or home == 361 or home == 366 or home == 4308 or home == 109 or home == 172 or home == 2188 or home == 263 or home == 265 or home == 194 or home == 110 or home == 266 or home == 196 or home == 195 or home == 267) and (away == 4145 or away == 258 or away == 108 or away == 4146 or away == 362 or away == 1765 or away == 361 or away == 366 or away == 4308 or away == 109 or away == 172 or away == 2188 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 196 or away == 195 or away == 267) then
			 Stadium_Board = "LaLiga"		 
		 elseif (home == 1930 or home == 2451 or home == 1245 or home == 2453 or home == 1246 or home == 2459 or home == 2454 or home == 1247 or home == 1931 or home == 1248 or home == 1249 or home == 5143 or home == 1933 or home == 1250 or home == 1252 or home == 137 or home == 1254 or home == 1255 or home == 1936 or home == 136) and (away == 1930 or away == 2451 or away == 1245 or away == 2453 or away == 1246 or away == 2459 or away == 2454 or away == 1247 or away == 1931 or away == 1248 or away == 1249 or away == 5143 or away == 1933 or away == 1250 or away == 1252 or away == 137 or away == 1254 or away == 1255 or away == 1936 or away == 136) then
			 Stadium_Board = "Brasileiro Serie A"
		 elseif (home == 174 or home == 5191 or home == 2009 or home == 269 or home == 1195 or home == 1196 or home == 5190 or home == 2013 or home == 5192 or home == 1200 or home == 5193 or home == 5194 or home == 2010 or home == 1197 or home == 5195 or home == 2019 or home == 5217 or home == 5216) and (away == 174 or away == 5191 or away == 2009 or away == 269 or away == 1195 or away == 1196 or away == 5190 or away == 2013 or away == 5192 or away == 1200 or away == 5193 or away == 5194 or away == 2010 or away == 1197 or away == 5195 or away == 2019 or away == 5217 or away == 5216) then
			 Stadium_Board = "Jupiler Pro League"
		 else
			 Stadium_Board = "Generic"
			 --Stadium_Board = "Default"
		 end
	else
			 --Stadium_Board = "Default"
			 Stadium_Board = "Generic"
    end

    if tid then
       return string.format("%s:%s", Stadium_Board, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s\\%s", fileroot, Stadium_Board, filename)
    end
end

local function trophy_rewrite(ctx, tournament_id)
	if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4 then
	   	 log("------- UEFA Champions League")
    elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
	   	 log("------- UEFA Europa League")
    elseif tid == 7 then
	   	 log("------- UEFA Super Cup")
	elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 then
		 log("------- FIFA World Cup")
	else
	   	 log("------- " .. Stadium_Board)
	end
end

local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("set_teams", set_random)
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
    ctx.register("trophy_rewrite", trophy_rewrite)
end

return { init = init }