local fileroot = ".\\content\\movieintro"
local intro = 1

function data_ready(ctx, filename)
    check = "common\\script\\flow\\Common\\CmnUpdateDayEnd.json"
    tid = ctx.tournament_id 
    leg = ctx.match_leg
    home = ctx.home_team
    away = ctx.away_team

--------------------------------------
if string.match(filename, ".usm") then
intro_folder = nil
if tid == 25 or tid == 23 or tid == 125 then
intro = 0
end

else
if tid == 17 then
if ctx.match_info == 0 then
intro_file = "en1"
if filename == check then ctx.match_info = ctx.match_info
end
else
intro_file = nil
end

elseif tid == 79 and ctx.match_info == 0 then
intro_file = "en2"
if filename == check then ctx.match_info = ctx.match_info
end

elseif tid == 18 and ctx.match_info == 0 then
intro_file = "ita1_a"
if filename == check then ctx.match_info = ctx.match_info
end

elseif tid == 19 and ctx.match_info == 0 then
intro_file = "spa1"
if filename == check then ctx.match_info = ctx.match_info
end

elseif tid == 80 and ctx.match_info == 0 then
intro_file = "spa2"
if filename == check then ctx.match_info = ctx.match_info
end

elseif tid == 50 and ctx.match_info == 0 then
intro_file = "ger1"
if filename == check then ctx.match_info = ctx.match_info
end

elseif tid == 166 or tid == 167 or tid == 51 and ctx.match_info == 0 then
intro_file = "mls"
if filename == check then ctx.match_info = ctx.match_info
end
	
elseif tid == 52 and ctx.match_info == 0 then
intro_file = "jap"
if filename == check then ctx.match_info = ctx.match_info
end	

elseif tid == 87 and leg == 1 then
intro_file = "spasc"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 86 then
intro_file = "ensc"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 89 then
intro_file = "itasc"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 95 then
intro_file = "gersc"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 25 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
intro_file = "spac"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 23 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
intro_file = "enc"
if filename == check then ctx.tournament_id = ctx.tournament_id
end

elseif tid == 24 and (((ctx.match_info == 46 or ctx.match_info == 47) and leg == 1 and intro == 1) or ctx.match_info == 53) then
intro_file = "itac"

elseif tid == 53 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
intro_file = "gerc"

elseif tid == 31 and (((ctx.match_info == 46 or ctx.match_info == 47) and leg == 1 and intro == 1) or ctx.match_info == 53) then
intro_file = "brc"

elseif tid == 59 and (((ctx.match_info == 46 or ctx.match_info == 47) and leg == 1 and intro == 1) or ctx.match_info == 53) then
intro_file = "argc"

elseif tid == 125 and (((ctx.match_info == 46 or ctx.match_info == 47) and leg == 1 and intro == 1) or ctx.match_info == 53) then
intro_file = "turc"

elseif tid == 123 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
intro_file = "rusc"

elseif tid == 1 and ctx.match_info == 46 then
intro_file = "fcwc"
elseif ((tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 
or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) and (ctx.match_info == 0 or ctx.match_info == 53)) then
intro_file = "fwc"
if filename == check then ctx.match_info = ctx.match_info
end


elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 
or tid == 3081 or tid == 4105 or tid == 5129  or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then
if ctx.match_info == 0 then
intro_file = "lib"
if filename == check then ctx.match_info = ctx.match_info
end

else
intro_file = nil
end

elseif tid == 7 then
intro_file = "sc_a"
elseif tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 
or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3  or tid == 1027 or tid == 2051 or tid == 3075 
or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 then
if ctx.match_info == 0 then
intro_file = "cl_a"
if filename == check then ctx.match_info = ctx.match_info
end
elseif ctx.match_info == 46 and leg == 1 then
intro_file = "cl_b"
if filename == check then ctx.match_info = ctx.match_info
end
elseif ctx.match_info == 53 and leg == nil then
intro_file = "cl_b"
if filename == check then ctx.match_info = ctx.match_info
end
elseif ctx.match_info == 53 and leg == 2 then
intro_file = nil
if filename == check then ctx.match_info = ctx.match_info
end
else
intro_file = nil
end


elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 
or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
if ctx.match_info == 0 then
intro_file = "el_a"
if filename == check then ctx.match_info = ctx.match_info
end
elseif (ctx.match_info == 46 and leg == 1) or ctx.match_info == 53 then
intro_file = "el_b"
if filename == check then ctx.match_info = ctx.match_info
end
elseif ctx.match_info == 53 and leg == 2 then
intro_file = nil
if filename == check then ctx.match_info = ctx.match_info
end
else
intro_file = nil
end
else
intro_file = nil
end
end
--------------------------------------

	if intro_file == nil then intro_folder = nil
	elseif intro_file == "uefa_best_player" or intro_file == "oth_ballon_d'or" then
		intro_folder = "before_cutscene"
	else
		intro_folder = "after_cutscene"
	end

	if filename == "common\\demo\\fixdemoobj\\board_mvp_south_hi\\#windx11\\board_mvp_south_hi_srm.ftex" 
		or filename == "common\\script\\flow\\TopMenu\\TopMenuNew.json" then intro = 1
	end

    if tid then
       return string.format("%s:%s", intro_folder, filename)
    end
end

function rewrite(ctx, filename)
	if tid ~= nil and intro_file ~= nil and string.match(filename, ".usm") then
		log(string.format("renaming %s to %s", filename , string.gsub(filename, "movie\\intro\\(.*).usm", "movie\\intro\\" .. intro_file .. ".usm")))
    	return string.gsub(filename, "movie\\intro\\(.*).usm", "movie\\intro\\" .. intro_file .. ".usm")
	end
end


local function get_filepath(ctx, filename, key)
    if key then
        return string.format("%s\\%s\\%s", fileroot, intro_folder, filename)
    end
end

function overlay_on(ctx)
	if tid then
		if intro_folder == nil then
      		return string.format("tid:%s | match:%s | leg:%s | intro:%s | home:%s | away:%s", tid, ctx.match_info, leg, intro, home, away)
      	else
      		return string.format("tid:%s | match:%s | leg:%s | intro:%s | home:%s | away:%s | using: %s - %s", tid, ctx.match_info, leg, intro, home, away, intro_file, intro_folder)
      	end
    else
      return string.format("Loading...")
    end
end

function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
	ctx.register("overlay_off", overlay_on)
	ctx.register("livecpk_data_ready", data_ready)
	ctx.register("livecpk_rewrite", rewrite)
	ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }