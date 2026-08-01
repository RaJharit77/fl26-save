-- IntroServer for PES 2021
-- Created by ginda01

local fileroot = ".\\content\\IntroServer"
local intro = 1

function data_ready(ctx, filename)
    check = "common\\script\\flow\\Common\\CmnUpdateDayEnd.json"
    tid = ctx.tournament_id 
    leg = ctx.match_leg
    home = ctx.home_team
    away = ctx.away_team

    if string.match(filename, ".usm") then
		intro_folder = nil
		if tid == 25 or tid == 23 or tid == 125 then -- Put your Cup ID here..
			intro = 0
		end
    else
    	-- Others -- 
		if ctx.match_info == 13 then
			intro_file = "oth_ballon_d'or"
			if filename == check then ctx.match_info = ctx.match_info + 1 end	
		elseif ctx.match_info == 55 then
			intro_file = "uefa_best_player" 
			if filename == check then ctx.match_info = ctx.match_info + 1 end	
		elseif (tid == 105 or tid == 106 or tid == 107) and ctx.match_info == 0 then
			intro_file = "oth_international_champions_cup"
			if filename == check then ctx.match_info = ctx.match_info + 1 end	

		-- League --
		elseif tid == 19 then
			if ctx.match_info == 0 then
				intro_file = "spa_laliga_santander"
				if filename == check then ctx.match_info = ctx.match_info + 55 end	
			elseif (home == 109 and away == 108) or (home == 108 and away == 109) then -- Derby match must be inside League..
				intro_file = "spa_el_clasico"
			else
				intro_file = nil
		    end
		elseif tid == 17 then
			if ctx.match_info == 0 then
				intro_file = "eng_premier_league_1"
				if filename == check then ctx.match_info = ctx.match_info + 55 end	
			elseif ctx.match_info == 19 then -- If you want mid-season intro, make it like this..
				intro_file = "eng_premier_league_2"
				if filename == check then ctx.match_info = ctx.match_info + 17 end	
			elseif (home == 100 and away == 173) or (home == 173 and away == 100) then
				intro_file = "eng_manchester_derby"
			else
				intro_file = nil
		    end
		elseif tid == 30 and ctx.match_info == 0 then
			intro_file = "ags_superliga_argentina"
			if filename == check then ctx.match_info = ctx.match_info + 1 end
		elseif tid == 50 and ctx.match_info == 0 then
			intro_file = "ger_bundesliga"
			if filename == check then ctx.match_info = ctx.match_info + 55 end	
		elseif tid == 18 and ctx.match_info == 0 then
			intro_file = "ita_serie_a"
			if filename == check then ctx.match_info = ctx.match_info + 55 end		
                elseif tid == 26 and ctx.match_info == 0 then
			intro_file = "fra_ligue_1"
			if filename == check then ctx.match_info = ctx.match_info + 55 end	
		elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) and ctx.match_info == 0 then
			intro_file = "bel_jupiler_pro_league"
			if filename == check then ctx.match_info = ctx.match_info + 55 end	
		elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) and ctx.match_info == 0 then
			intro_file = "sco_spfl_premiership"
			if filename == check then ctx.match_info = ctx.match_info + 55 end	
		elseif tid == 118 and ctx.match_info == 0 then
			intro_file = "tur_super_lig"
                        if filename == check then ctx.match_info = ctx.match_info + 55 end
                elseif tid == 82 and ctx.match_info == 0 then 
                        if filename == check then ctx.match_info = ctx.match_info + 55 end
			intro_file = "tur_tff1_lig"
                        if filename == check then ctx.match_info = ctx.match_info + 55 end
                elseif tid == 22 and ctx.match_info == 0 then
			intro_file = "POR_ligabetclic"
			if filename == check then ctx.match_info = ctx.match_info + 55 end	
            elseif tid == 52 and ctx.match_info == 0 then
			intro_file = "jpn_j1_league"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
            elseif tid == 162 and ctx.match_info == 0 then
			intro_file = "tha_toyota_thai_league"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
            elseif (tid == 51 or tid == 166 or tid == 167) and ctx.match_info == 0 then
			intro_file = "mex_liga_mx"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
            elseif tid == 116 and ctx.match_info == 0 then
			intro_file = "rus_russian_premier_league"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
            elseif (tid == 160 or tid == 161 or tid == 168 or tid == 169) and ctx.match_info == 0 then
			intro_file = "col_liga_betplay_dimayor"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
            elseif tid == 79 and ctx.match_info == 0 then
			intro_file = "eng_championship"
			if filename == check then ctx.match_info = ctx.match_info + 55 end
				
				-- Copy the code from "elseif" to "end" and change the ID on "tid"
				-- The "intro_file" is the name of your intro video 
				-- Derby match must be inside League, look LaLiga for example

		-- Cup --
		elseif tid == 26 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1 and intro == 1) or ctx.match_info == 53) then
			intro_file = "fra_coupe_de_france"
		elseif tid == 25 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "spa_copa_del_rey"
		elseif tid == 23 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "eng_fa_cup"
		elseif tid == 27 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "nld_knvb_beker"
		elseif tid == 125 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "tur_ziraat_turkish_cup"
		elseif tid == 26 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "fra_coupe_de_france"
		elseif tid == 126 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "col_copa_betplay_dimayor"
            elseif tid == 59 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "ags_copa_argentina"
            elseif tid == 31 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "bra_copa_do_brasil"
            elseif tid == 54 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "mex_copa_mx"
            elseif tid == 53 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "ger_dfb_pokal"
            elseif tid == 130 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "tur_super_cup"              
            elseif tid == 89 and (((ctx.match_info == 46 or ctx.match_info == 47) and intro == 1) or ctx.match_info == 53) then
			intro_file = "ita_SUPERCOPPA_ITALIA"              


				-- Copy the code from "elseif" to "intro_file = ...." and change the ID on "tid"
				-- If the Cup is two-legged knock-out match, the code must be like "tur_ziraat_turkish_cup"

		-- SuperCup --
		elseif tid == 86 then
			intro_file = "eng_community_shield"
			if filename == check then ctx.tournament_id = ctx.tournament_id + 2 end
		elseif tid == 87 then
			intro_file = "spa_supercopa_de_espana"
			if filename == check then ctx.tournament_id = ctx.tournament_id + 1 end
	      elseif tid == 130 then
			intro_file = "tur_super_cup"
			if filename == check then ctx.tournament_id = ctx.tournament_id + 1 end

				-- Copy the code from "elseif" to "end" and change the ID on "tid"
				-- If the SuperCup is two-legged match, the code must be like "spa_supercopa_de_espana"

                elseif (home == 130 and away == 197) or (home == 197 and away == 130) then
		        intro_file = "tur_FB_GS"
                elseif (home == 130 and away == 273) or (home == 273 and away == 130) then
			intro_file = "tur_BJK_GS"
                elseif (home == 197 and away == 273) or (home == 273 and away == 197) then
			intro_file = "tur_FB_BJK"
                elseif (home == 273 and away == 1945) or (home == 1945 and away == 273) then
			intro_file = "tur_BJK_TS"

		-- Others --
		elseif tid == 1 and ctx.match_info == 46 then
			intro_file = "fifa_club_world_cup"
		elseif tid == 46 then
	    	        intro_file = "africa_cup_of_nations"
		elseif ((tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) and (ctx.match_info == 0 or ctx.match_info == 53)) then
	    	        intro_file = "copa_america"
		elseif ((tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 or tid == 45) and (ctx.match_info == 0 or ctx.match_info == 53)) then
	    	        intro_file = "afc_asian_cup"
		elseif ((tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 
			or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) and (ctx.match_info == 0 or ctx.match_info == 53)) then
	    	        intro_file = "fifa_world_cup"
			if filename == check then ctx.match_info = ctx.match_info + 1 end	
		elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 
			or tid == 3081 or tid == 4105 or tid == 5129  or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then
				if ctx.match_info == 0 then
					intro_file = "oth_copa_libertadores"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif (ctx.match_info == 46 and leg == 1) or ctx.match_info == 53 then
					intro_file = "oth_copa_libertadores"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif ctx.match_info == 53 and leg == 2 then
		    		intro_file = nil
					if filename == check then ctx.match_info = ctx.match_info + 2 end
				else
					intro_file = nil
				end
		elseif tid == 7 then
			intro_file = "uefa_super_cup"

		elseif tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 
			or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3  or tid == 1027 or tid == 2051 or tid == 3075 
			or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 then
				if ctx.match_info == 0 then
					intro_file = "uefa_champions_league"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif ctx.match_info == 46 and leg == 1 then
					intro_file = "uefa_champions_league_k"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif ctx.match_info == 53 and leg == nil then
					intro_file = "uefa_champions_league_f"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif ctx.match_info == 53 and leg == 2 then
					intro_file = nil
					if filename == check then ctx.match_info = ctx.match_info + 2 end
				else
					intro_file = nil
				end
    	elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 
    		or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
    			if ctx.match_info == 0 then
					intro_file = "uefa_europa_league"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif (ctx.match_info == 46 and leg == 1) or ctx.match_info == 53 then
					intro_file = "uefa_europa_league_f"
					if filename == check then ctx.match_info = ctx.match_info + 1 end
				elseif ctx.match_info == 53 and leg == 2 then
		    		intro_file = nil
					if filename == check then ctx.match_info = ctx.match_info + 2 end
				else
					intro_file = nil
				end
		else
			intro_file = nil
		end
	end

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
	ctx.register("overlay_on", overlay_on)
    ctx.register("livecpk_data_ready", data_ready)
    ctx.register("livecpk_rewrite", rewrite)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }
