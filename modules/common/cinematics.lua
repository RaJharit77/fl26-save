-- SP Football Life Cinematics

--------------------------------
-- do not delete this credits
-- programming by: juce
-- using save data files by: saintric
-- originally posted on evo-web
--------------------------------


local fileroot = ".\\content\\cinematics"
local entry
local tid

local function set_random(ctx)
	rdm = math.random (1,4)
	tid = ctx.tournament_id
	home = ctx.home_team
	away = ctx.away_team
end

function make_key(ctx, filename)
	if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 then
		entry = 16
		Entrance = "UEFA Champions League"

	elseif tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4 then
		entry = 16
	if ctx.match_info == 53 then
		Entrance = "UEFA Champions League F"
	else
		Entrance = "UEFA Champions League"
	end

	elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
		entry = 16
	if ctx.match_info == 53 then
		Entrance = "UEFA Europa League F"
	else
		Entrance = "UEFA Europa League"
	end

	elseif tid == 7 then
		entry = 16
		Entrance = "UEFA Super Cup"


	elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 then
		entry = 42
		Entrance = "EURO"

	elseif tid == 65535 then
		entry = 16
		Entrance = "Default"

	elseif tid == 17 then
		entry = 16
		Entrance = "ENG1"

	elseif tid == 20 then
		entry = 16
		Entrance = "FRA1"

	elseif tid == 81 then
		entry = 16
		Entrance = "FRA2"

	elseif tid == 26 then
		entry = 16
		Entrance = "FRAC"

	elseif tid == 118 then
		entry = 16
		Entrance = "TUR"

	elseif tid == 125 then
		entry = 16
		Entrance = "TURC"

	elseif tid == 23 then
		entry = 16
		Entrance = "ENGC"

	elseif tid == 18 then
		entry = 16
		Entrance = "ITAA"

	elseif tid == 82 or tid == 85 then
		entry = 16
		Entrance = "ITAB"

	elseif tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159 or tid == 172 then
		entry = 16
		 Entrance = "BEL"

	elseif tid == 50 then
		entry = 16
		Entrance = "GER"

	elseif tid == 138 then
		entry = 16
		Entrance = "GER2"

	elseif tid == 53 then
		entry = 16
		Entrance = "GERC"

	elseif tid == 95 then
		entry = 16
		Entrance = "GERS"

	elseif tid == 30 then
		entry = 16
		Entrance = "ARG"

	elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129  or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then
		entry = 10
		Entrance = "LIB"

	elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 then
		entry = 42
		Entrance = "WC"

	elseif tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176 then
		entry = 42
		if ctx.match_info == 53 then
		Entrance = "CopaAmerica F"
		else
		Entrance = "CopaAmerica"
		end

	elseif tid == 46 then
		entry = 46
		Entrance = "CAF"

	elseif tid == 1 then
		entry = 16
		Entrance = "CWC"

	elseif tid == 79 then
		entry = 16
		Entrance = "ENG2"

	elseif tid == 86 then
		entry = 16
		Entrance = "ENGS"

	elseif tid == 19 then
		entry = 16
		Entrance = "ESP1"

	elseif tid == 80 or tid == 84 then
		entry = 16
		Entrance = "ESP2"

	elseif tid == 25 then
		entry = 16
		if ctx.match_info == 53 then
		Entrance = "ESPC"
	else
		Entrance = "ESPC"
	end

	elseif tid == 87 then
		entry = 16
		Entrance = "ESPS"

	elseif tid == 88 then
		entry = 16
		Entrance = "FRAS"

	elseif tid == 24 then
		entry = 16
		Entrance = "ITAC"

	elseif tid == 89 then
		entry = 16
		Entrance = "ITAS"

	elseif tid == 116 then
		entry = 16
		Entrance = "RUS"

	elseif tid == 117 then
		entry = 16
		Entrance = "GRE"

	elseif tid == 52 then
		entry = 16
		Entrance = "JAP"

	elseif tid == 120 then
		entry = 16
		Entrance = "CHN"

	elseif tid == 123 then
		entry = 16
		Entrance = "RUSC"

	elseif tid == 67 or tid == 13400 or tid == 13401 then
		entry = 16
		Entrance = "CHL"

	elseif tid == 68 then
		entry = 16
		Entrance = "CHLC"

	elseif tid == 92 then
		entry = 16
		Entrance = "ARGS"

	elseif tid == 59 then
		entry = 16
	if ctx.match_info == 53 then
		Entrance = "ARGCF"
	else
		Entrance = "ARGC"
	end 

	elseif tid == 29 then
		entry = 16
		Entrance = "BRA1"

	elseif tid == 163 then
		entry = 16
		Entrance = "BRA2"

	elseif tid == 31 then
		entry = 16
		Entrance = "BRAC"

	else
		entry = nil
	end

	if tid then
       return string.format("%s:%s", Entrance, filename)
    end
end

function trophy_rewrite(ctx, tournament_id)
   if entry ~= nil then
      local tid = entry
      if tid then
	     Entrance = string.gsub(Entrance, "\\Final", "")
	     Entrance = string.gsub(Entrance, "\\Group_Knockout", "")
	     log("---- " .. Entrance)
    	 return tid
      end
   else
	  log("---- Default")
   end
end

local function get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s\\%s", fileroot, Entrance, filename)
    end
end

function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
	math.randomseed(os.time())
    ctx.register("set_teams", set_random)
    ctx.register("trophy_rewrite", trophy_rewrite)
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }
