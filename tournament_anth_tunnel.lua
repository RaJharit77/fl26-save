-- Tournament Anthems (Entrance/Half-Time/Full-Time/Celebration) for PES2021 & PES2020
-- Author: Predator002 on 07/02/2025
-- Version: 3.0c
-- Originally posted on Evo-Web
-- Massive thanks to Juce & Zlac because their assistance made this lua possible
-- match-stats.enabled = 1  needs to be added to your sider.ini
-- added config section at line 23 with manual options on whether to play the EPL anthem at lineup AND OR EPL teams 2nd anthem

local m = {}
local pretunnel_anthem
local tunnel_anthem
local lineup_anthem
local format_anthem
local halftime_anthem
local fulltime_anthem
local celebr_anthem
local delay_anthem
local rdm
local past_kickoff
local hex = memory.hex
local nolineupanthem_epl
local no2ndteamanthem_epl

-- MANUAL CONFIG ---------
nolineupanthem_epl = false
no2ndteamanthem_epl = false
-- -----------------------

local function get_ids(ctx)
    rdm = math.random (1,6)
end

local function stop_pretunnelanthem()
    if pretunnel_anthem then
        log(string.format("pretunnel anthem finishing: %s", pretunnel_anthem:get_filename()))
        pretunnel_anthem:fade_to(0, 3)
        pretunnel_anthem:finish()
        pretunnel_anthem = nil
    end
end

local function stop_tunnelanthem()
    if tunnel_anthem then
        log(string.format("tunnel anthem finishing: %s", tunnel_anthem:get_filename()))
        tunnel_anthem:fade_to(0, 3)
        tunnel_anthem:finish()
        tunnel_anthem = nil
    end
end

local function stop_tunnelanthem_quiet()
    if tunnel_anthem then
        log(string.format("tunnel anthem fading: %s", tunnel_anthem:get_filename()))
        tunnel_anthem:fade_to(0, 3)
    end
end

local function stop_tunnelanthem_slowly()
    if tunnel_anthem then
        log(string.format("tunnel anthem fading: %s", tunnel_anthem:get_filename()))
        tunnel_anthem:fade_to(0, 7)
    end
end

local function stop_lineupanthem()
    if lineup_anthem then
        log(string.format("lineup anthem finishing: %s", lineup_anthem:get_filename()))
        lineup_anthem:fade_to(0, 3)
        lineup_anthem:finish()
        lineup_anthem = nil
    end
end

local function stop_formatanthem()
    if format_anthem then
        log(string.format("formation anthem finishing: %s", format_anthem:get_filename()))
        format_anthem:fade_to(0, 3)
        format_anthem:finish()
        format_anthem = nil
    end
end

local function stop_halftimeanthem()
    if halftime_anthem then
        log(string.format("halftime anthem finishing: %s", halftime_anthem:get_filename()))
        halftime_anthem:fade_to(0, 3)
        halftime_anthem:finish()
        halftime_anthem = nil
    end
end

local function stop_fulltimeanthem()
    if fulltime_anthem then
        log(string.format("fulltime anthem finishing: %s", fulltime_anthem:get_filename()))
        fulltime_anthem:fade_to(0, 3)
        fulltime_anthem:finish()
        fulltime_anthem = nil
    end
end

local function stop_celebranthem()
    if celebr_anthem then
        log(string.format("celebration anthem finishing: %s", celebr_anthem:get_filename()))
        celebr_anthem:fade_to(0, 3)
        celebr_anthem:finish()
        celebr_anthem = nil
    end
end

local function stop_delayanthem()
    if delay_anthem then
        log(string.format("celebration anthem finishing: %s", delay_anthem:get_filename()))
        delay_anthem:fade_to(0, 1)
        delay_anthem:finish()
        delay_anthem = nil
    end
end

local function teams_selected(ctx, home_team_id, away_team_id)
    past_kickoff = false
end

function m.data_ready(ctx, filename)
tid = ctx.tournament_id
teamid = ctx.home_team
awayid = ctx.away_team
daynightid = ctx.timeofday
cuproundid = ctx.match_info
stadiumid = ctx.stadium
local stats = match.stats()
    if filename == "common\\script\\flow\\Match\\MatchSetupRematch.json" then
	past_kickoff = false
    end

 -- END ANTHEMS AT KICKOFF OR WHEN PAUSED
    if string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_hug_run_aim.*") or string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal_.*") or string.match(filename, "common\\demo\\fixdemo\\goal\\cut_data\\goal.*") or filename == "common\\script\\flow\\Match\\MatchPrePause.json" then
	--log("game loaded: " .. filename)
        stop_pretunnelanthem()
	stop_tunnelanthem()
	stop_lineupanthem()
        stop_formatanthem()
	stop_halftimeanthem()
        --past_kickoff = true
        
 -- END ANTHEMS AT END OF MATCH
    elseif filename == "common\\script\\flow\\Match\\MatchEnd.json" then
	--log("game loaded: " .. filename)
        stop_halftimeanthem()
	stop_fulltimeanthem()
	stop_celebranthem()
	stop_delayanthem()

-- INTRO ANTHEM 1 - PRE-STADIUM TUNNEL ANTHEM LEADING TO STADIUM ANTHEM
    elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_007_passage%d+_cmn_cam.*%.fdc") or string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_007_st%d+_cmn_cam.*%.fdc") or string.match(filename, "common\\demo\\anime\\FoxAnim\\FixDemo\\Animations\\dml_mobH_cam01_idel02.gani") or string.match(filename, "common\\demo\\anime\\FoxAnim\\FixDemo\\Animations\\dml_mobH_cam%d+_tachi2rollright_fukan_mob_prop_camera%d+.gani") then
	if pretunnel_anthem then
	else
                if past_kickoff == false then
			if (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
                	        --log("game loaded: " .. filename)
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\FIFA\\World_Cup_2022\\tunnel_anthem_pre.mp3")
				if tunnel_anthem then
					log(string.format("pretunnel anthem cannot start due to tunnel already playing: %s", pretunnel_anthem:get_filename()))
				else
					log(string.format("pretunnel anthem starting: %s", pretunnel_anthem:get_filename()))
	        			pretunnel_anthem:set_volume(0.7)
	        			pretunnel_anthem:play()
					past_kickoff = true
				end
			elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
                	        --log("game loaded: " .. filename)
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Euro\\tunnel_anthem_pre.mp3")
				if tunnel_anthem then
					log(string.format("pretunnel anthem cannot start due to tunnel already playing: %s", pretunnel_anthem:get_filename()))
				else
					log(string.format("pretunnel anthem starting: %s", pretunnel_anthem:get_filename()))
	        			pretunnel_anthem:set_volume(0.7)
	        			pretunnel_anthem:play()
					past_kickoff = true
				end
	                elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
				if cuproundid == 53 then
                	        	--log("game loaded: " .. filename)
	        			pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_pre.mp3")
					if tunnel_anthem then
						log(string.format("pretunnel anthem cannot start due to tunnel already playing: %s", pretunnel_anthem:get_filename()))
					else
						log(string.format("pretunnel anthem starting: %s", pretunnel_anthem:get_filename()))
	        				pretunnel_anthem:set_volume(0.7)
	        				pretunnel_anthem:play()
						past_kickoff = true
					end
				end
	                elseif (tid == 58 or tid == 103) then
                	        --log("game loaded: " .. filename)
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_Testimonial\\tunnel_anthem_pre.mp3")
				if tunnel_anthem then
					log(string.format("pretunnel anthem cannot start due to tunnel already playing: %s", pretunnel_anthem:get_filename()))
				else
					log(string.format("pretunnel anthem starting: %s", pretunnel_anthem:get_filename()))
	        			pretunnel_anthem:set_volume(0.7)
	        			pretunnel_anthem:play()
					past_kickoff = true
				end
	                elseif (tid == 108) then
                	        --log("game loaded: " .. filename)
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_World_Selection\\tunnel_anthem_pre.mp3")
				if tunnel_anthem then
					log(string.format("pretunnel anthem cannot start due to tunnel already playing: %s", pretunnel_anthem:get_filename()))
				else
					log(string.format("pretunnel anthem starting: %s", pretunnel_anthem:get_filename()))
	        			pretunnel_anthem:set_volume(0.7)
	        			pretunnel_anthem:play()
					past_kickoff = true
				end
			end
		end
        end

 -- INTRO ANTHEM 2 - STADIUM TUNNEL ANTHEM LEADING TO STADIUM ANTHEM (CLUB TEAMS
    elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_%d+_st%d+_cmn_cam.*%.fdc") then
	if tunnel_anthem then
	else
			--log("game loaded: " .. filename)
		
		     -- TEAM ANTHEMS -- ATTEMPT TO PLAY THESE FIRST
			if teamid == 174 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Anderlecht_intro.mp3")
			elseif teamid == 5191 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Antwerp_intro.mp3")
			elseif teamid == 5216 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Beerschot_intro.mp3")
			elseif teamid == 5195 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Beveren_intro.mp3")
			elseif teamid == 2009 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Cercle_Brugge_intro.mp3")
			elseif teamid == 2010 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Charleroi_intro.mp3")
			elseif teamid == 269 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Club_Brugge_intro.mp3")
			elseif teamid == 5190 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Eupen_intro.mp3")
			elseif teamid == 1195 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Genk_intro.mp3")
			elseif teamid == 1196 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Gent_intro.mp3")
			elseif teamid == 2013 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Kortrijk_intro.mp3")
			elseif teamid == 5217 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Leuven_OH_intro.mp3")
			elseif teamid == 1200 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Mechelen_intro.mp3")
			elseif teamid == 5193 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Mouscron_intro.mp3")
			elseif teamid == 5192 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Oostende_intro.mp3")
			elseif teamid == 5684 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Seraing_intro.mp3")
			elseif teamid == 5194 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Sint_Truidense_intro.mp3")
			elseif teamid == 1197 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Standard_Liege_intro.mp3")
			elseif teamid == 5220 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Union_SG_intro.mp3")
			elseif teamid == 5221 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Westerlo_intro.mp3")
			elseif teamid == 2019 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Belgium\\Zulte_Waregem_intro.mp3")
			elseif teamid == 1247 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Brazil\\Corinthians.mp3")
			elseif teamid == 1248 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Brazil\\Flamengo_intro.mp3")
			elseif teamid == 137 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Brazil\\Palmeiras.mp3")
			elseif teamid == 1255 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Brazil\\Sao_Paulo.mp3")
			elseif teamid == 136 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Brazil\\Vasco_da_Gama.mp3")
			elseif teamid == 2192 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\AudaxItaliano_intro.mp3")
			elseif teamid == 2553 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Cobresal_intro.mp3")
			elseif teamid == 1256 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\ColoColo_intro.mp3")
			elseif teamid == 2707 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\CoquimboUnido_intro.mp3")
			elseif teamid == 2708 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\CuricoUnido_intro.mp3")
			elseif teamid == 2547 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\DepAntofagasta_intro.mp3")
			elseif teamid == 2543 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\DepIquique_intro.mp3")
			elseif teamid == 2544 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\DepLaSerena_intro.mp3")
			elseif teamid == 2710 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Deportes_Copiapo_intro.mp3")
			elseif teamid == 2208 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\EvertonVinaDelMar_intro.mp3")
			elseif teamid == 2545 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Huachipato_intro.mp3")
			elseif teamid == 2712 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Magallanes_intro.mp3")
			elseif teamid == 2699 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Nublense_intro.mp3")
			elseif teamid == 2541 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\OHiggins_intro.mp3")
			elseif teamid == 2548 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\Palestino_intro.mp3")
			elseif teamid == 2714 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\SanLuis_intro.mp3")
			elseif teamid == 2542 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\SantiagoWanderers_intro.mp3")
			elseif teamid == 2360 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\UnionEspanola_intro.mp3")
			elseif teamid == 2546 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\UnionLaCalera_intro.mp3")
			elseif teamid == 2191 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\UnivCatolica_intro.mp3")
			elseif teamid == 2209 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\UnivChile_intro.mp3")
			elseif teamid == 2551 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Chile\\UnivConcepcion_intro.mp3")
			elseif teamid == 5207 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\AlianzaPetrolera_intro.mp3")
			elseif teamid == 1257 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\AmericaDeCali_intro.mp3")
			elseif teamid == 2648 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\AtleticoHuila_intro.mp3")
			elseif teamid == 2193 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\AtleticoNacional_intro.mp3")
			elseif teamid == 2195 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\BoyacaChico_intro.mp3")
			elseif teamid == 5208 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Bucaramanga_intro.mp3")
			elseif teamid == 2194 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\CucutaDeportivo_intro.mp3")
			elseif teamid == 2650 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\DeportivoCali_intro.mp3")
			elseif teamid == 2651 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\DeportivoPasto_intro.mp3")
			elseif teamid == 5370 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\DeportivoPereira_intro.mp3")
			elseif teamid == 2652 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Envigado_intro.mp3")
			elseif teamid == 5210 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Jaguares_intro.mp3")
			elseif teamid == 2285 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Junior_intro.mp3")
			elseif teamid == 2654 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\LaEquidad_intro.mp3")
			elseif teamid == 2210 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Medellin_intro.mp3")
			elseif teamid == 1258 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Millonarios_intro.mp3")
			elseif teamid == 2284 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\OnceCaldas_intro.mp3")
			elseif teamid == 2655 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Patriotas_intro.mp3")
			elseif teamid == 2653 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\RionegroAguilas_intro.mp3")
			elseif teamid == 2657 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\SantaFe_intro.mp3")
			elseif teamid == 2361 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\Tolima_intro.mp3")
			elseif teamid == 5376 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Colombia\\UnionMagdalena_intro.mp3")
			elseif teamid == 1818 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Aalborg_intro.mp3")
			elseif teamid == 2067 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Aarhus_intro.mp3")
			elseif teamid == 1832 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Brondby_intro.mp3")
			elseif teamid == 2068 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Esbjerg_intro.mp3")
			elseif teamid == 5229 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Fredericia_intro.mp3")
			elseif teamid == 5222 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Helsingor_intro.mp3")
			elseif teamid == 5223 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Hobro_intro.mp3")
			elseif teamid == 2066 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Horsens_intro.mp3")
			elseif teamid == 5423 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Hvidovre_intro.mp3")
			elseif teamid == 1207 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Kobenhavn_intro.mp3")
			elseif teamid == 5224 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Lyngby_intro.mp3")
			elseif teamid == 2069 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Midtjylland_intro.mp3")
			elseif teamid == 1208 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Nordsjaelland_intro.mp3")
			elseif teamid == 2070 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Odense_intro.mp3")
			elseif teamid == 2071 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Randers_intro.mp3")
			elseif teamid == 5225 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Silkeborg_intro.mp3")
			elseif teamid == 5226 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\SonderjyskE_intro.mp3")
			elseif teamid == 5235 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Vejle_intro.mp3")
			elseif teamid == 5237 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Denmark\\Viborg_intro.mp3")
			elseif teamid == 101 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal_intro.mp3")
			elseif teamid == 107 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\AstonVilla_intro.mp3")
			elseif teamid == 1588 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Barnsley_intro.mp3")
			elseif teamid == 201 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Birmingham_intro.mp3")
			elseif teamid == 176 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Blackburn_intro.mp3")
			elseif teamid == 1761 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Blackpool_intro.mp3")
			elseif teamid == 202 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Bolton_intro.mp3")
			elseif teamid == 4071 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Bournemouth_intro.mp3")
			elseif teamid == 4180 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Brentford2_intro.mp3")
			elseif teamid == 377 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Brighton_intro.mp3")
			elseif teamid == 1760 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\BristolCity_intro.mp3")
			elseif teamid == 378 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Burnley_intro.mp3")
			elseif teamid == 379 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Cardiff_intro.mp3")
			elseif teamid == 203 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Charlton_intro.mp3")
			elseif teamid == 102 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Chelsea2_intro.mp3")
			elseif teamid == 4183 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Coventry_intro.mp3")
			elseif teamid == 382 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\CrystalPalace_intro.mp3")
			elseif teamid == 383 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Derby_intro.mp3")
			elseif teamid == 177 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Everton_intro.mp3")
			elseif teamid == 178 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		       	 	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Fulham_intro.mp3")
			elseif teamid == 2610 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Huddersfield_intro.mp3")
			elseif teamid == 1589 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Hull_intro.mp3")
			elseif teamid == 386 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Ipswich_Town_intro.mp3")
			elseif teamid == 104 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Leeds2_intro.mp3")
			elseif teamid == 204 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Leicester_intro.mp3")
			elseif teamid == 103 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool_intro.mp3")
			elseif teamid == 4363 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Luton_intro.mp3")
			elseif teamid == 173 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity_intro.mp3")
			elseif teamid == 100 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited1_intro.mp3")
			elseif teamid == 100 and (tid == 58 or tid == 103 or tid == 108) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited2_intro.mp3")
			elseif teamid == 205 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Middlesbrough_intro.mp3")
			elseif teamid == 387 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Millwall_intro.mp3")
			elseif teamid == 106 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle_intro.mp3")
			elseif teamid == 388 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Norwich_intro.mp3")
			elseif teamid == 389 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\NottsForest2_intro.mp3")
			elseif teamid == 2317 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Peterborough_intro.mp3")
			elseif teamid == 4364 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Plymouth_Argyle_intro.mp3")
			elseif teamid == 4192 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\PrestonNorthEnd_intro.mp3")
			elseif teamid == 1327 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\QPR_intro.mp3")
			elseif teamid == 391 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Reading_intro.mp3")
			elseif teamid == 4193 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Rotherham_intro.mp3")
			elseif teamid == 4194 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\SheffieldUnited_intro.mp3")
			elseif teamid == 394 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\SheffieldWednesday_intro.mp3")
			elseif teamid == 207 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton_intro.mp3")
			elseif teamid == 395 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Stoke_intro.mp3")
			elseif teamid == 396 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Sunderland_intro.mp3")
			elseif teamid == 1909 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea_intro.mp3")
			elseif teamid == 179 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham_intro.mp3")
			elseif teamid == 398 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Watford_intro.mp3")
			elseif teamid == 399 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestBrom_intro.mp3")
			elseif teamid == 105 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam2_intro.mp3")
			elseif teamid == 400 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wigan_intro.mp3")
			elseif teamid == 208 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wolves_intro.mp3")
			elseif teamid == 9990 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wrexham_intro.mp3")
			elseif teamid == 5096 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wycombe_intro.mp3")
			elseif teamid == 209 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Ajaccio_intro.mp3")
			elseif teamid == 4200 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Amiens_intro.mp3")
			elseif teamid == 403 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Angers_intro.mp3")
			elseif teamid == 180 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Auxerre_intro.mp3")
			elseif teamid == 115 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Bordeaux_intro.mp3")
			elseif teamid == 1329 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Brest_intro.mp3")
			elseif teamid == 407 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Clermont_intro.mp3")
			elseif teamid == 1328 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Dijon_intro.mp3")
			elseif teamid == 413 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Le_Havre_intro.mp3")
			elseif teamid == 182 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lens_intro.mp3")
			elseif teamid == 213 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lille_intro.mp3")
			elseif teamid == 414 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lorient_intro.mp3")
			elseif teamid == 181 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lyon_intro.mp3")
			elseif teamid == 113 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Marseille2_intro.mp3")
			elseif teamid == 4123 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Metz_intro.mp3")
			elseif teamid == 112 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Monaco_intro.mp3")
			elseif teamid == 215 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Montpellier_intro.mp3")
			elseif teamid == 216 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Nantes_intro.mp3")
			elseif teamid == 217 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Nice_intro.mp3")
			elseif teamid == 1910 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Nimes_intro.mp3")
			elseif teamid == 114 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Paris_SG2_intro.mp3")
			elseif teamid == 418 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Saint_Etienne_intro.mp3")
			elseif teamid == 219 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Sochaux_intro.mp3")
			elseif teamid == 1330 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Stade_de_Reims_intro.mp3")
			elseif teamid == 218 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Stade_Rennais_intro.mp3")
			elseif teamid == 4213 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Strasbourg_intro.mp3")
			elseif teamid == 221 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Toulouse_intro.mp3")
			elseif teamid == 420 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Troyes_intro.mp3")
			elseif teamid == 4127 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Arminia_Bielefeld_intro.mp3")
			elseif teamid == 4124 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Augsburg_intro.mp3")
			elseif teamid == 128 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Bayer_Leverkusen_intro.mp3")
			elseif teamid == 127 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Bayern_Munich_intro.mp3")
			elseif teamid == 4128 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Bochum_intro.mp3")
			elseif teamid == 126 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Borussia_Dortmund_intro.mp3")
			elseif teamid == 225 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Borussia_Monchengladbach_intro.mp3")
			elseif teamid == 5008 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Darmstadt_intro.mp3")
			elseif teamid == 4129 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Dynamo_Dresden_intro.mp3")
			elseif teamid == 226 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Eintracht_Frankfurt_intro.mp3")
			elseif teamid == 431 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Fortuna_Dusseldorf_intro.mp3")
			elseif teamid == 227 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Freiburg_intro.mp3")
			elseif teamid == 4133 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Greuther_Furth_intro.mp3")
			elseif teamid == 129 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Hamburg_intro.mp3")
			elseif teamid == 5009 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Heidenheim_intro.mp3")
			elseif teamid == 4125 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Hertha_Berlin_intro.mp3")
			elseif teamid == 4126 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Hoffenheim_intro.mp3")
			elseif teamid == 5720 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Jahn_Regensburg_intro.mp3")
			elseif teamid == 4137 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Koln_intro.mp3")
			elseif teamid == 436 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Mainz_intro.mp3")
			elseif teamid == 437 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Nurnberg_intro.mp3")
			elseif teamid == 4324 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Paderborn_intro.mp3")
			elseif teamid == 5010 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\RB_Leipzig_intro.mp3")
			elseif teamid == 184 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Schalke_04_intro.mp3")
			elseif teamid == 231 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Stuttgart_intro.mp3")
			elseif teamid == 4140 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Union_Berlin_intro.mp3")
			elseif teamid == 185 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Werder_Bremen_intro.mp3")
			elseif teamid == 121 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\AC_Milan_intro.mp3")
			elseif teamid == 234 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Atalanta_intro.mp3")
			elseif teamid == 319 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Bari_intro.mp3")
			elseif teamid == 4232 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Benevento_intro.mp3")
			elseif teamid == 186 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Bologna_intro.mp3")
			elseif teamid == 187 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Brescia_intro.mp3")
			elseif teamid == 320 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Cagliari_intro.mp3")
			elseif teamid == 4220 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Cremonese_intro.mp3")
			elseif teamid == 1363 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Crotone_intro.mp3")
			elseif teamid == 235 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Empoli_intro.mp3")
			elseif teamid == 124 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Fiorentina_intro.mp3")
			elseif teamid == 4234 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Frosinone_intro.mp3")
			elseif teamid == 323 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Genoa_intro.mp3")
			elseif teamid == 336 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Hellas_Verona_intro.mp3")
			elseif teamid == 119 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Inter_intro.mp3")
			elseif teamid == 120 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Juventus_intro.mp3")
			elseif teamid == 122 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Lazio_intro.mp3")
			elseif teamid == 4237 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Lecce_intro.mp3")
			elseif teamid == 4914 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Monza_intro.mp3")
			elseif teamid == 327 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Napoli_intro.mp3")
			elseif teamid == 238 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Palermo_intro.mp3")
			elseif teamid == 123 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Parma_intro.mp3")
			elseif teamid == 4241 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Pisa_intro.mp3")
			elseif teamid == 239 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Reggina_intro.mp3")
			elseif teamid == 125 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Roma_intro.mp3")
			elseif teamid == 4244 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Salernitana_intro.mp3")
			elseif teamid == 240 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Sampdoria_intro.mp3")
			elseif teamid == 1919 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Sassuolo_intro.mp3")
			elseif teamid == 1600 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Spezia_intro.mp3")
			elseif teamid == 4228 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Sudtirol_intro.mp3")
			elseif teamid == 333 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Torino_intro.mp3")
			elseif teamid == 190 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Udinese_intro.mp3")
			elseif teamid == 4229 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Venezia_intro.mp3")
			elseif teamid == 243 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\ADODenHaag_intro.mp3")
			elseif teamid == 116 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Ajax_intro.mp3")
			elseif teamid == 242 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\AZAlkmaar_intro.mp3")
			elseif teamid == 338 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Cambuur_intro.mp3")
			elseif teamid == 339 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\DeGraafschap_intro.mp3")
			elseif teamid == 342 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Emmen_intro.mp3")
			elseif teamid == 344 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Excelsior_intro.mp3")
			elseif teamid == 117 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Feyenoord_intro.mp3")
			elseif teamid == 345 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\FortunaSittard_intro.mp3")
			elseif teamid == 346 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Go_Ahead_Eagles_intro.mp3")
			elseif teamid == 244 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Groningen_intro.mp3")
			elseif teamid == 245 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Heerenveen_intro.mp3")
			elseif teamid == 349 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Heracles_intro.mp3")
			elseif teamid == 246 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\NACBreda_intro.mp3")
			elseif teamid == 247 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\NEC_Nijmegen_intro.mp3")
			elseif teamid == 256 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\PECZwolle_intro.mp3")
			elseif teamid == 118 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\PSV_intro.mp3")
			elseif teamid == 254 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\RKCWaalwijk_intro.mp3")
			elseif teamid == 351 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\SpartaRotterdam_intro.mp3")
			elseif teamid == 250 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Twente_intro.mp3")
			elseif teamid == 251 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Utrecht_intro.mp3")
			elseif teamid == 252 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Vitesse_intro.mp3")
			elseif teamid == 253 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\Volendam_intro.mp3")
			elseif teamid == 355 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\VVVVenlo_intro.mp3")
			elseif teamid == 255 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Netherlands\\WillemII_intro.mp3")
			elseif teamid == 2380 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Arouca_intro.mp3")
			elseif teamid == 1973 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Belenenses_intro.mp3")
			elseif teamid == 191 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Benfica_intro.mp3")
			elseif teamid == 4323 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Boavista_intro.mp3")
			elseif teamid == 1974 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Braga_intro.mp3")
			elseif teamid == 5633 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Casa_Pia_intro.mp3")
			elseif teamid == 4085 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Chaves_intro.mp3")
			elseif teamid == 2383 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Estoril_Praia_intro.mp3")
			elseif teamid == 5028 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Famalicao_intro.mp3")
			elseif teamid == 4086 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Farense_intro.mp3")
			elseif teamid == 2385 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Feirense_intro.mp3")
			elseif teamid == 2387 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Gil_Vicente_intro.mp3")
			elseif teamid == 1976 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Maritimo_intro.mp3")
			elseif teamid == 2388 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Moreirense_intro.mp3")
			elseif teamid == 1944 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Nacional_intro.mp3")
			elseif teamid == 1978 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Pacos_De_Ferreira_intro.mp3")
			elseif teamid == 2369 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Portimonense_intro.mp3")
			elseif teamid == 192 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Porto_intro.mp3")
			elseif teamid == 1979 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Rio_Ave_intro.mp3")
			elseif teamid == 2391 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Santa_Clara_intro.mp3")
			elseif teamid == 193 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Sporting_intro.mp3")
			elseif teamid == 2614 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Tondela_intro.mp3")
			elseif teamid == 1804 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Vitoria_de_Guimaraes_intro.mp3")
			elseif teamid == 5115 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Portugal\\Vizela_intro.mp3")
			elseif teamid == 1217 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Russia\\CSKA_Moscow_intro.mp3")
			elseif teamid == 271 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Russia\\Lokomotiv_Moscow_intro.mp3")
			elseif teamid == 135 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Russia\\Spartak_Moscow_intro.mp3")
			elseif teamid == 1218 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Russia\\Zenit_St_Petersburg_intro.mp3")
			elseif teamid == 1219 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Aberdeen_intro.mp3")
			elseif teamid == 5448 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Ayr_United_intro.mp3")
			elseif teamid == 131 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Celtic_intro.mp3")
			elseif teamid == 2621 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Dundee_intro.mp3")
			elseif teamid == 1220 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\DundeeUnited_intro.mp3")
			elseif teamid == 5312 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Hamilton_intro.mp3")
			elseif teamid == 1221 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Hearts_intro.mp3")
			elseif teamid == 1222 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Hibernian_intro.mp3")
			elseif teamid == 1985 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Kilmarnock_intro.mp3")
			elseif teamid == 5319 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Livingston_intro.mp3")
			elseif teamid == 1986 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Motherwell_intro.mp3")
			elseif teamid == 5313 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\PartickThistle_intro.mp3")
			elseif teamid == 9991 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Queens_Park_intro.mp3")
			elseif teamid == 132 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Rangers_intro.mp3")
			elseif teamid == 2622 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\RossCounty_intro.mp3")
			elseif teamid == 2365 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\StJohnstone_intro.mp3")
			elseif teamid == 1987 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\StMirren_intro.mp3")
			elseif teamid == 357 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Almeria_intro.mp3")
			elseif teamid == 258 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Athletic_Bilbao_intro.mp3")
			elseif teamid == 172 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Atletico_Madrid_intro.mp3")
			elseif teamid == 108 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Barcelona.mp3")
			elseif teamid == 4308 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Cadiz_intro.mp3")
			elseif teamid == 195 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Celta_Vigo_intro.mp3")
			elseif teamid == 4145 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Deportivo_Alaves_intro.mp3")
			elseif teamid == 4146 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Eibar_intro.mp3")
			elseif teamid == 361 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Elche_intro.mp3")
			elseif teamid == 259 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Espanyol_intro.mp3")
			elseif teamid == 362 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Getafe_intro.mp3")
			elseif teamid == 2187 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Girona_intro.mp3")
			elseif teamid == 1765 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Granada_intro.mp3")
			elseif teamid == 2188 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Huesca_intro.mp3")
			elseif teamid == 4272 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Leganes_intro.mp3")
			elseif teamid == 366 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Levante_intro.mp3")
			elseif teamid == 261 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Mallorca_intro.mp3")
			elseif teamid == 263 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Osasuna_intro.mp3")
			elseif teamid == 370 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Rayo_Vallecano_intro.mp3")
			elseif teamid == 194 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Real_Betis_intro.mp3")
			elseif teamid == 109 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Real_Madrid_intro.mp3")
			elseif teamid == 4260 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Real_Oviedo_intro.mp3")
			elseif teamid == 196 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Real_Sociedad_intro.mp3")
			elseif teamid == 266 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Real_Valladolid_intro.mp3")
			elseif teamid == 265 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Sevilla_intro.mp3")
			elseif teamid == 110 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Valencia_intro.mp3")
			elseif teamid == 267 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Villarreal_intro.mp3")
			elseif teamid == 283 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Busan_IPark_intro.mp3")
			elseif teamid == 5596 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Daegu_intro.mp3")
			elseif teamid == 285 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Daegu_intro.mp3")
			elseif teamid == 280 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Daejeon_Hana_Citizen_intro.mp3")
			elseif teamid == 284 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Gimcheon_Sangmu_intro.mp3")
			elseif teamid == 5597 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Gyeongnam_intro.mp3")
			elseif teamid == 287 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Incheon_United_intro.mp3")
			elseif teamid == 5135 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Jeju_United_intro.mp3")
			elseif teamid == 286 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Jeju_United_intro.mp3")
			elseif teamid == 279 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Jeonbuk_Hyundai_Motors_intro.mp3")
			elseif teamid == 5874 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Jeonnam_Dragons_intro.mp3")
			elseif teamid == 278 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Jeonnam_Dragons_intro.mp3")
			elseif teamid == 281 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Pohang_Steelers_intro.mp3")
			elseif teamid == 4942 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Seongnam_intro.mp3")
			elseif teamid == 275 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Seongnam_intro.mp3")
			elseif teamid == 282 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Seoul_intro.mp3")
			elseif teamid == 277 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Suwon_Samsung_Bluewings_intro.mp3")
			elseif teamid == 4174 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Ulsan_Hyundai_intro.mp3")
			elseif teamid == 276 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\South Korea\\Ulsan_Hyundai_intro.mp3")
			elseif teamid == 1706 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Basel_intro.mp3")
			elseif teamid == 1228 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Grasshopper_intro.mp3")
			elseif teamid == 4964 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Lausanne_Sport_intro.mp3")
			elseif teamid == 4965 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Lugano_intro.mp3")
			elseif teamid == 4962 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Luzern_intro.mp3")
			elseif teamid == 5346 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Neuchatel_Xamax_intro.mp3")
			elseif teamid == 1958 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Servette_intro.mp3")
			elseif teamid == 1955 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Sion_intro.mp3")
			elseif teamid == 4937 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\St_Gallen_intro.mp3")
			elseif teamid == 4938 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Thun_intro.mp3")
			elseif teamid == 1956 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Vaduz_intro.mp3")
			elseif teamid == 4968 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Winterthur_intro.mp3")
			elseif teamid == 1950 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Young_Boys_intro.mp3")
			elseif teamid == 1957 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Switzerland\\Zurich_intro.mp3")
			elseif teamid == 5348 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Adana_Demirspor_intro.mp3")
			elseif teamid == 5202 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Alanyaspor_intro.mp3")
			elseif teamid == 5205 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Ankaragucu_intro.mp3")
			elseif teamid == 1989 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Antalyaspor_intro.mp3")
			elseif teamid == 273 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Besiktas_intro.mp3")
			elseif teamid == 5354 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Caykur_Rizespor_intro.mp3")
			elseif teamid == 5355 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Denizlispor_intro.mp3")
			elseif teamid == 5353 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Erzurumspor_intro.mp3")
			elseif teamid == 5652 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Fatih_Karagumruk_intro.mp3")
			elseif teamid == 197 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Fenerbahce_intro.mp3")
			elseif teamid == 130 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Galatasaray_intro.mp3")
			elseif teamid == 5356 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Gaziantep_intro.mp3")
			elseif teamid == 1230 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Genclerbirligi_intro.mp3")
			elseif teamid == 5357 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Giresunspor_intro.mp3")
			elseif teamid == 5203 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Goztepe_intro.mp3")
			elseif teamid == 5452 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Hatayspor_intro.mp3")
			elseif teamid == 1995 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Istanbul_Basaksehir_intro.mp3")
			elseif teamid == 5358 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Istanbulspor_intro.mp3")
			elseif teamid == 2625 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Kasimpasa_intro.mp3")
			elseif teamid == 1996 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Kayserispor_intro.mp3")
			elseif teamid == 5204 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Konyaspor_intro.mp3")
			elseif teamid == 1809 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Sivasspor_intro.mp3")
			elseif teamid == 1945 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Trabzonspor_intro.mp3")
			elseif teamid == 5362 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Umraniyespor_intro.mp3")
			elseif teamid == 5206 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Turkey\\Yeni_Malatyaspor_intro.mp3")

		     -- TOURNAMENT ANTHEMS -- ATTEMPT TO PLAY THESE IF NO TEAM ANTHEMS EXIST
		    	elseif (tid == 58 or tid == 103) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_Testimonial\\tunnel_anthem.mp3")
		    	elseif tid == 108 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_World_Selection\\tunnel_anthem.mp3")
			elseif tid == 59 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Copa_Argentina\\tunnel_anthem.mp3")
			elseif tid == 30 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Superliga\\tunnel_anthem.mp3")
			elseif tid == 122 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Croky_Cup\\tunnel_anthem.mp3")
			elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Jupilar_Pro_League\\tunnel_anthem.mp3")
			elseif tid == 67 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Chile\\Primera_Division\\tunnel_anthem.mp3")
			elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\CONMEBOL\\Copa_Libertadores\\tunnel_anthem.mp3")
			elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Denmark\\Superliga\\tunnel_anthem.mp3")
			elseif tid == 86 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\Community_Shield\\tunnel_anthem.mp3")
			elseif (tid == 79 or tid == 83) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EFL\\tunnel_anthem.mp3")
			elseif tid == 17 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EPL\\tunnel_anthem.mp3")
			elseif tid == 23 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\FA_Cup\\tunnel_anthem.mp3")
			elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\FIFA\\World_Cup_2022\\tunnel_anthem.mp3")
			elseif tid == 26 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Coupe_De_La_Ligue\\tunnel_anthem.mp3")
			elseif tid == 20 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_1\\tunnel_anthem.mp3")
			elseif tid == 81 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_2\\tunnel_anthem.mp3")
			elseif tid == 50 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\Bundesliga\\tunnel_anthem.mp3")
			elseif tid == 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFB_Pokal\\tunnel_anthem.mp3")
			elseif tid == 95 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFL_SuperCup\\tunnel_anthem.mp3")
			elseif tid == 107 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\Asia\\tunnel_anthem.mp3")
			elseif tid == 105 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\North_America\\tunnel_anthem.mp3")
			elseif tid == 106 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\South_America\\tunnel_anthem.mp3")
			elseif tid == 24 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Coppa_Italia\\tunnel_anthem.mp3")
			elseif tid == 18 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_A\\tunnel_anthem.mp3")
			elseif (tid == 82 or tid == 85) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_B\\tunnel_anthem.mp3")
			elseif tid == 89 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Supercoppa_Italiana\\tunnel_anthem.mp3")
			elseif tid == 52 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\J1_League\\tunnel_anthem.mp3")
			elseif tid == 55 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Emperors_Cup\\tunnel_anthem.mp3")
			elseif tid == 97 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Super_Cup\\tunnel_anthem.mp3")
			elseif tid == 21 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\Eredevisie\\tunnel_anthem.mp3")
			elseif tid == 22 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Portugal\\Liga_NOS\\tunnel_anthem.mp3")
			elseif tid == 116 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Russia\\Premier_League\\tunnel_anthem.mp3")
			elseif tid == 25 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Copa_Del_Rey\\tunnel_anthem.mp3")
			elseif tid == 19 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\LaLiga\\tunnel_anthem.mp3")
			elseif tid == 80 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Segunda\\tunnel_anthem.mp3")
			elseif tid == 87 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\SuperCopa\\tunnel_anthem.mp3")
			elseif tid == 117 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Switzerland\\Raiffeisen_Super_League\\tunnel_anthem.mp3")
			elseif tid == 118 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Turkey\\SuperLig\\tunnel_anthem.mp3")
	       		elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
	                        if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
	                        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\tunnel_anthem_delay.mp3")
	                        else
	                        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\tunnel_anthem.mp3")
	                        end
	                elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
				if cuproundid == 53 then
					if rdm == 1 then
		        			tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2009.mp3")
					elseif rdm == 2 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2010.mp3")
					elseif rdm == 3 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2011.mp3")
					elseif rdm == 4 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2018.mp3")
					elseif rdm == 5 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2019.mp3")
					elseif rdm == 6 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_pes2018.mp3")
					else
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2009.mp3")
					end
				else
	       	                 	if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
	                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\tunnel_anthem_delay.mp3")
        	                	else
                	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\tunnel_anthem.mp3")
                        		end
				end
			elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Euro\\tunnel_anthem.mp3")
			elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
                        	if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\tunnel_anthem_delay.mp3")
                        	else
                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\tunnel_anthem.mp3")
                        	end
			elseif (tid == 99) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\tunnel_anthem.mp3")
			elseif (tid == 48 or tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\tunnel_anthem.mp3")
			elseif tid == 7 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Super_Cup\\tunnel_anthem.mp3")
			elseif (tid == 51 or tid == 166 or tid == 167) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS\\tunnel_anthem.mp3")
			elseif tid == 54 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS_Cup\\tunnel_anthem.mp3")
			else
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\tunnel_anthem.mp3")
			end
				if pretunnel_anthem then
					log(string.format("tunnel anthem cannot start due to pretunnel already playing: %s", tunnel_anthem:get_filename()))
	                			if (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
							if cuproundid == 53 then
								log(string.format("tunnel anthem starting: %s", tunnel_anthem:get_filename()))
	        						tunnel_anthem:set_volume(0.7)
	        						tunnel_anthem:play()
							end
						end
				else
					log(string.format("tunnel anthem starting: %s", tunnel_anthem:get_filename()))
	        			tunnel_anthem:set_volume(0.7)
	        			tunnel_anthem:play()
				end
	end

 -- INTRO ANTHEM 3 - STADIUM TOURNAMENT ANTHEM DURING  STATIC  PLAYER LINEUP
    elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_018_cmn_all_pl.fdc") or string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_009_st%d+_south.*%.fdc") then
	if lineup_anthem then
	else
                if (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
			--log("game loaded: " .. filename)
			stop_tunnelanthem_quiet()
			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem.mp3")
			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
			lineup_anthem:set_volume(0.7)
			lineup_anthem:play()
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then
			else
				if (teamid == 234 or teamid == 124 or teamid == 327 or teamid == 1919 or teamid == 186 or teamid == 323 or teamid == 122 or teamid == 123 or teamid == 4923 or teamid == 187 or teamid == 336 or teamid == 4237 or teamid == 125 or teamid == 333 or teamid == 320 or teamid == 119 or teamid == 121 or teamid == 240 or teamid == 190 or teamid == 317 or teamid == 4928 or teamid == 4234 or teamid == 328 or teamid == 1600 or teamid == 4232 or teamid == 4220 or teamid == 2517 or teamid == 4241 or teamid == 4077 or teamid == 188 or teamid == 1363 or teamid == 325 or teamid == 4915 or teamid == 4229 or teamid == 1920 or teamid == 235 or teamid == 4240 or teamid == 4244 or teamid == 4230) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem_scream.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 108) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem_whistle.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 173) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem_boo.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 120) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem_classic_scream.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 102 or teamid == 109 or teamid == 110 or teamid == 127 or teamid == 128 or teamid == 181) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem_classic.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				else
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\lineup_anthem.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				end
			end
        	elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
			if (teamid == 108 or teamid == 173) then
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\lineup_anthem_whistle.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
			else
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\lineup_anthem.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
			end
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
			--log("game loaded: " .. filename)
			stop_tunnelanthem_quiet()
			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\CONMEBOL\\Copa_Libertadores\\lineup_anthem.mp3")
			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
			lineup_anthem:set_volume(0.7)
			lineup_anthem:play()
        	elseif (tid == 18) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_A\\lineup_anthem.mp3")
            		log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            		lineup_anthem:set_volume(0.7)
            		lineup_anthem:play()
        	elseif (tid == 24) then
            		if cuproundid == 53 then
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Coppa_Italia\\lineup_anthem_final.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
            		else
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Coppa_Italia\\lineup_anthem.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
            		end
        	elseif (tid == 89) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Supercoppa_Italiana\\lineup_anthem.mp3")
            		log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            		lineup_anthem:set_volume(0.7)
            		lineup_anthem:play()
        	elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
            		--log("game loaded: " .. filename)
                        stop_pretunnelanthem()
            		stop_tunnelanthem_quiet()
        	elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
            		--log("game loaded: " .. filename)
                        stop_pretunnelanthem()
            		stop_tunnelanthem_quiet()
		end
	end

 -- INTRO ANTHEM 4 - STADIUM TOURNAMENT ANTHEM DURING  WARMUP  PLAYER LINEUP
    elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_016_.*") then
        if lineup_anthem then
	else
		if (tid == 17) then
			if nolineupanthem_epl == false then
				if no2ndteamanthem_epl == false then
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EPL\\lineup_anthem.mp3")
            				log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            				lineup_anthem:set_volume(0.7)
            				lineup_anthem:play()
				end
			end
        	elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Jupilar_Pro_League\\lineup_anthem.mp3")
            		log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            		lineup_anthem:set_volume(0.7)
            		lineup_anthem:play()
        	elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
            		--log("game loaded: " .. filename)
                        stop_pretunnelanthem()
            		stop_tunnelanthem_quiet()
        	elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
            		--log("game loaded: " .. filename)
                        stop_pretunnelanthem()
            		stop_tunnelanthem_quiet()
		end
	end

 -- INTRO ANTHEM 5 - STADIUM MUSIC DURING FORMATION SCREENS
    elseif string.match(filename, "common\\demo\\fixdemo\\ent\\cut_data\\ent_020_.*") then
	if format_anthem then
	else
		--log("game loaded: " .. filename)
		if (tid == 17) then
			if nolineupanthem_epl == false then
				if no2ndteamanthem_epl == false then
					if teamid == 101 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal3_format.mp3")
					elseif teamid == 107 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\AstonVilla_format.mp3")
					elseif teamid == 1588 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Barnsley_format.mp3")
					elseif teamid == 201 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Birmingham_format.mp3")
					elseif teamid == 176 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Blackburn_format.mp3")
					elseif teamid == 1761 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Blackpool_format.mp3")
					elseif teamid == 202 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Bolton_format.mp3")
					elseif teamid == 4071 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Bournemouth_format.mp3")
					elseif teamid == 4180 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Brentford2_format.mp3")
					elseif teamid == 377 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Brighton_format.mp3")
					elseif teamid == 1760 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\BristolCity_format.mp3")
					elseif teamid == 378 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Burnley_format.mp3")
					elseif teamid == 379 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Cardiff_format.mp3")
					elseif teamid == 203 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Charlton_format.mp3")
					elseif teamid == 102 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Chelsea_format.mp3")
					elseif teamid == 4183 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Coventry_format.mp3")
					elseif teamid == 382 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\CrystalPalace_format.mp3")
					elseif teamid == 383 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Derby_format.mp3")
					elseif teamid == 177 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Everton_format.mp3")
					elseif teamid == 178 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Fulham_format.mp3")
					elseif teamid == 2610 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Huddersfield_format.mp3")
					elseif teamid == 1589 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Hull_format.mp3")
					elseif teamid == 386 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Ipswich_Town_format.mp3")
					elseif teamid == 104 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Leeds2_format.mp3")
					elseif teamid == 204 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Leicester_format.mp3")
					elseif teamid == 103 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool_format.mp3")
					elseif teamid == 4363 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Luton_format.mp3")
					elseif teamid == 173 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity3_format.mp3")
					elseif teamid == 100 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited1_format.mp3")
					elseif teamid == 205 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Middlesbrough_format.mp3")
					elseif teamid == 387 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Millwall_format.mp3")
					elseif teamid == 106 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle_format.mp3")
					elseif teamid == 388 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Norwich_format.mp3")
					elseif teamid == 389 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\NottsForest2_format.mp3")
					elseif teamid == 2317 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Peterborough_format.mp3")
					elseif teamid == 4364 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Plymouth_Argyle_format.mp3")
					elseif teamid == 4192 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\PrestonNorthEnd_format.mp3")
					elseif teamid == 1327 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\QPR_format.mp3")
					elseif teamid == 391 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Reading_format.mp3")
					elseif teamid == 4193 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Rotherham_format.mp3")
					elseif teamid == 4194 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\SheffieldUnited_format.mp3")
					elseif teamid == 394 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\SheffieldWednesday_format.mp3")
					elseif teamid == 207 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton_format.mp3")
					elseif teamid == 395 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Stoke_format.mp3")
					elseif teamid == 396 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Sunderland_format.mp3")
					elseif teamid == 1909 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea_format.mp3")
					elseif teamid == 179 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham_format.mp3")
					elseif teamid == 398 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Watford_format.mp3")
					elseif teamid == 399 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestBrom_format.mp3")
					elseif teamid == 105 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam_format.mp3")
					elseif teamid == 400 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wigan_format.mp3")
					elseif teamid == 208 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wolves_format.mp3")
					elseif teamid == 9990 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wrexham_format.mp3")
					elseif teamid == 5096 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wycombe_format.mp3")
					end
				end
			elseif nolineupanthem_epl == true then
				if no2ndteamanthem_epl == false then
					if teamid == 101 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal3_format.mp3")
					elseif teamid == 201 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Birmingham_format.mp3")
					elseif teamid == 1761 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Blackpool_format.mp3")
					elseif teamid == 4180 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Brentford2_format.mp3")
					elseif teamid == 202 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Bolton_format.mp3")
					elseif teamid == 379 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Cardiff_format.mp3")
					elseif teamid == 102 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Chelsea_format.mp3")
					elseif teamid == 4183 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Coventry_format.mp3")
					elseif teamid == 383 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Derby_format.mp3")
					elseif teamid == 177 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Everton_format.mp3")
					elseif teamid == 178 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Fulham_format.mp3")
					elseif teamid == 386 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Ipswich_Town_format.mp3")
					elseif teamid == 173 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity3_format.mp3")
					elseif teamid == 100 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited1_format.mp3")
					elseif teamid == 389 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\NottsForest2_format.mp3")
					elseif teamid == 2317 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Peterborough_format.mp3")
					elseif teamid == 4364 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Plymouth_Argyle_format.mp3")
					elseif teamid == 1327 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\QPR_format.mp3")
					elseif teamid == 391 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Reading_format.mp3")
					elseif teamid == 4193 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Rotherham_format.mp3")
					elseif teamid == 394 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\SheffieldWednesday_format.mp3")
					elseif teamid == 395 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Stoke_format.mp3")
					elseif teamid == 396 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Sunderland_format.mp3")
					elseif teamid == 1909 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea_format.mp3")
					elseif teamid == 179 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham_format.mp3")
					elseif teamid == 399 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestBrom_format.mp3")
					elseif teamid == 9990 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wrexham_format.mp3")
					elseif teamid == 5096 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Wycombe_format.mp3")
					end
				end
			end
		elseif (tid == 18) then
			if teamid == 121 then
            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\AC_Milan_format.mp3")
			elseif teamid == 120 then
            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Juventus_format.mp3")
			end
		elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool2_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam2_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Celtic2_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			else
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 102 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Chelsea_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool3_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam3_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Celtic_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
			if cuproundid == 53 then
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool2_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam2_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Celtic2_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			else
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 102 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Chelsea_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Liverpool3_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\England\\WestHam3_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Celtic_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			end
        	elseif (tid == 107) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\Asia\\format_anthem.mp3")
        	elseif (tid == 105) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\North_America\\format_anthem.mp3")
        	elseif (tid == 106) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\South_America\\format_anthem.mp3")
		else
			format_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\format_anthem.mp3")
		end
            		log(string.format("formation anthem starting: %s", format_anthem:get_filename()))
            		format_anthem:set_volume(0.7)
            		format_anthem:play()
	end

 -- ANTHEM 6 - HALF TIME WALK OFF TOURNAMENT TV ANTHEM
    elseif string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_half_cmn_02_.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_half_cmn_02.*") then
	if halftime_anthem then
	else
		--log("game loaded: " .. filename)
	    	if (tid == 58 or tid == 103) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_Testimonial\\intro_anthem.mp3")
	    	elseif tid == 108 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_World_Selection\\intro_anthem.mp3")
		elseif (tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\AFC\\AFC_Champions_League\\intro_anthem.mp3")
		elseif (tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 or tid == 45) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 46 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 120 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 127 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 132 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 142 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 88 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 28 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 91 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 123 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 129 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 124 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 162 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 164 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 165 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 125 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 130 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
		elseif tid == 59 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Copa_Argentina\\intro_anthem.mp3")
		elseif tid == 92 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Supercopa_Argentina\\intro_anthem.mp3")
		elseif tid == 30 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Superliga\\intro_anthem.mp3")
		elseif tid == 122 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Croky_Cup\\intro_anthem.mp3")
		elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Jupilar_Pro_League\\intro_anthem.mp3")
		elseif tid == 31 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Copa_do_Brasil\\intro_anthem.mp3")
		elseif tid == 29 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Serie_A\\intro_anthem.mp3")
		elseif tid == 163 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Serie_B\\intro_anthem.mp3")
		elseif tid == 68 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Chile\\Copa_Chile\\intro_anthem.mp3")
		elseif tid == 67 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Chile\\Primera_Division\\intro_anthem.mp3")
		elseif tid == 126 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Copa_Colombia\\intro_anthem.mp3")
		elseif (tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Primera_A\\intro_anthem.mp3")
		elseif tid == 131 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Superliga_Colombiana\\intro_anthem.mp3")
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\CONMEBOL\\Copa_Libertadores\\intro_anthem.mp3")
		elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Denmark\\Superliga\\intro_anthem.mp3")
		elseif tid == 86 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\Community_Shield\\intro_anthem.mp3")
		elseif (tid == 79 or tid == 83) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EFL\\intro_anthem.mp3")
		elseif tid == 17 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EPL\\intro_anthem.mp3")
		elseif tid == 23 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\FA_Cup\\intro_anthem.mp3")
		elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\FIFA\\World_Cup_2022\\intro_anthem.mp3")
		elseif tid == 26 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Coupe_De_La_Ligue\\intro_anthem.mp3")
		elseif tid == 20 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_1\\intro_anthem.mp3")
		elseif tid == 81 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_2\\intro_anthem.mp3")
		elseif tid == 50 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\Bundesliga\\intro_anthem.mp3")
		elseif tid == 53 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFB_Pokal\\intro_anthem.mp3")
		elseif tid == 95 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFL_SuperCup\\intro_anthem.mp3")
		elseif tid == 107 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\Asia\\intro_anthem.mp3")
		elseif tid == 105 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\North_America\\intro_anthem.mp3")
		elseif tid == 106 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\South_America\\intro_anthem.mp3")
		elseif tid == 24 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Coppa_Italia\\intro_anthem.mp3")
		elseif tid == 18 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_A\\intro_anthem.mp3")
		elseif (tid == 82 or tid == 85) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_B\\intro_anthem.mp3")
		elseif tid == 89 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Supercoppa_Italiana\\intro_anthem.mp3")
		elseif tid == 52 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\J1_League\\intro_anthem.mp3")
		elseif tid == 55 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Emperors_Cup\\intro_anthem.mp3")
		elseif tid == 97 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Super_Cup\\intro_anthem.mp3")
		elseif tid == 21 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\Eredevisie\\intro_anthem.mp3")
		elseif tid == 90 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\Johan_Cruyff_Shield\\intro_anthem.mp3")
		elseif tid == 27 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\KNVB_Cup\\intro_anthem.mp3")
		elseif tid == 22 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Portugal\\Liga_NOS\\intro_anthem.mp3")
		elseif tid == 116 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Russia\\Premier_League\\intro_anthem.mp3")
		elseif (tid == 137) then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Scotland\\Scottish_Cup\\intro_anthem.mp3")
		elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Scotland\\SPFL\\intro_anthem.mp3")
		elseif tid == 25 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Copa_Del_Rey\\intro_anthem.mp3")
		elseif tid == 19 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\LaLiga\\intro_anthem.mp3")
		elseif tid == 80 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Segunda\\intro_anthem.mp3")
		elseif tid == 87 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\SuperCopa\\intro_anthem.mp3")
		elseif tid == 117 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Switzerland\\Raiffeisen_Super_League\\intro_anthem.mp3")
		elseif tid == 118 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Turkey\\SuperLig\\intro_anthem.mp3")
		elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Euro\\intro_anthem.mp3")
                elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
                        halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then 
	        		halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\intro_anthem.mp3")
			else
	        		halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\intro_anthem.mp3")
		elseif tid == 99 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\intro_anthem.mp3")
		elseif (tid == 48 or tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\intro_anthem.mp3")
		elseif tid == 7 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Super_Cup\\intro_anthem.mp3")
		elseif (tid == 51 or tid == 166 or tid == 167) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS\\intro_anthem.mp3")
		elseif tid == 54 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS_Cup\\intro_anthem.mp3")
		elseif tid == 65535 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic\\intro_anthem.mp3")
		else
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\intro_anthem.mp3")
		end

		log(string.format("halftime anthem starting: %s", halftime_anthem:get_filename()))
                stop_tunnelanthem()
	        halftime_anthem:set_volume(0.6)
	        halftime_anthem:play()
            	halftime_anthem:when_done(function(ctx)
                halftime_anthem = nil
            	end)
	end

 -- ANTHEM 7 - FULL TIME WALK OFF TOURNAMENT TV ANTHEM
    elseif string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_01_.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_01.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_02_.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_02.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_cut_.*") or string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_cut.*") then
	if fulltime_anthem then
	else
		--log("game loaded: " .. filename)
	    	if (tid == 58 or tid == 103) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_Testimonial\\intro_anthem.mp3")
	    	elseif tid == 108 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\ML_World_Selection\\intro_anthem.mp3")
		elseif (tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\AFC\\AFC_Champions_League\\intro_anthem.mp3")
		elseif (tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 or tid == 45) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 46 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 120 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 127 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 132 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 142 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 88 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 28 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 91 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 123 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 129 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 124 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 162 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 164 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 165 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 125 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 130 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic_02\\intro_anthem.mp3")
		elseif tid == 59 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Copa_Argentina\\intro_anthem.mp3")
		elseif tid == 92 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Supercopa_Argentina\\intro_anthem.mp3")
		elseif tid == 30 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Argentina\\Superliga\\intro_anthem.mp3")
		elseif tid == 122 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Croky_Cup\\intro_anthem.mp3")
		elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Belgium\\Jupilar_Pro_League\\intro_anthem.mp3")
		elseif tid == 31 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Copa_do_Brasil\\intro_anthem.mp3")
		elseif tid == 29 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Serie_A\\intro_anthem.mp3")
		elseif tid == 163 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Brazil\\Serie_B\\intro_anthem.mp3")
		elseif tid == 68 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Chile\\Copa_Chile\\intro_anthem.mp3")
		elseif tid == 67 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Chile\\Primera_Division\\intro_anthem.mp3")
		elseif tid == 126 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Copa_Colombia\\intro_anthem.mp3")
		elseif (tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Primera_A\\intro_anthem.mp3")
		elseif tid == 131 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Colombia\\Superliga_Colombiana\\intro_anthem.mp3")
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\CONMEBOL\\Copa_Libertadores\\intro_anthem.mp3")
		elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Denmark\\Superliga\\intro_anthem.mp3")
		elseif tid == 86 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\Community_Shield\\intro_anthem.mp3")
		elseif (tid == 79 or tid == 83) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EFL\\intro_anthem.mp3")
		elseif tid == 17 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EPL\\intro_anthem.mp3")
		elseif tid == 23 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\FA_Cup\\intro_anthem.mp3")
		elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\FIFA\\World_Cup_2022\\intro_anthem.mp3")
		elseif tid == 26 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Coupe_De_La_Ligue\\intro_anthem.mp3")
		elseif tid == 20 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_1\\intro_anthem.mp3")
		elseif tid == 81 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_2\\intro_anthem.mp3")
		elseif tid == 50 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\Bundesliga\\intro_anthem.mp3")
		elseif tid == 53 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFB_Pokal\\intro_anthem.mp3")
		elseif tid == 95 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFL_SuperCup\\intro_anthem.mp3")
		elseif tid == 107 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\Asia\\intro_anthem.mp3")
		elseif tid == 105 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\North_America\\intro_anthem.mp3")
		elseif tid == 106 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\ICC\\South_America\\intro_anthem.mp3")
		elseif tid == 24 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Coppa_Italia\\intro_anthem.mp3")
		elseif tid == 18 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_A\\intro_anthem.mp3")
		elseif (tid == 82 or tid == 85) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_B\\intro_anthem.mp3")
		elseif tid == 89 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Supercoppa_Italiana\\intro_anthem.mp3")
		elseif tid == 52 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\J1_League\\intro_anthem.mp3")
		elseif tid == 55 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Emperors_Cup\\intro_anthem.mp3")
		elseif tid == 97 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Japan\\Super_Cup\\intro_anthem.mp3")
		elseif tid == 21 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\Eredevisie\\intro_anthem.mp3")
		elseif tid == 90 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\Johan_Cruyff_Shield\\intro_anthem.mp3")
		elseif tid == 27 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Netherlands\\KNVB_Cup\\intro_anthem.mp3")
		elseif tid == 22 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Portugal\\Liga_NOS\\intro_anthem.mp3")
		elseif tid == 116 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Russia\\Premier_League\\intro_anthem.mp3")
		elseif (tid == 137) then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Scotland\\Scottish_Cup\\intro_anthem.mp3")
		elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Scotland\\SPFL\\intro_anthem.mp3")
		elseif tid == 25 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Copa_Del_Rey\\intro_anthem.mp3")
		elseif tid == 19 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\LaLiga\\intro_anthem.mp3")
		elseif tid == 80 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Segunda\\intro_anthem.mp3")
		elseif tid == 87 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\SuperCopa\\intro_anthem.mp3")
		elseif tid == 117 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Switzerland\\Raiffeisen_Super_League\\intro_anthem.mp3")
		elseif tid == 118 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Turkey\\SuperLig\\intro_anthem.mp3")
		elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Euro\\intro_anthem.mp3")
                elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
                        fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then 
	        		fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\intro_anthem.mp3")
			else
	        		fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\intro_anthem.mp3")
		elseif tid == 99 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\intro_anthem.mp3")
		elseif (tid == 48 or tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Nations_League\\intro_anthem.mp3")
		elseif tid == 7 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Super_Cup\\intro_anthem.mp3")
		elseif (tid == 51 or tid == 166 or tid == 167) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS\\intro_anthem.mp3")
		elseif tid == 54 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\United_States\\MLS_Cup\\intro_anthem.mp3")
		elseif tid == 65535 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic\\intro_anthem.mp3")
		else
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\intro_anthem.mp3")
		end

                stop_tunnelanthem()
                delay_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\delay3_anthem.mp3")

		log(string.format("fulltime anthem(1) starting: %s", delay_anthem:get_filename()))
	        delay_anthem:set_volume(0.6)
	        delay_anthem:play()
            	delay_anthem:when_done(function(ctx)
                delay_anthem = nil
		log(string.format("fulltime anthem(2) starting: %s", fulltime_anthem:get_filename()))
	        fulltime_anthem:set_volume(0.6)
	        fulltime_anthem:play()
            	fulltime_anthem:when_done(function(ctx)
                fulltime_anthem = nil
            	end)
                end)
	end

 -- ANTHEM 8 - TROPHY WINNING CELEBRATION STADIUM ANTHEM
    elseif string.match(filename, "common\\demo\\fixdemo\\end\\cut_data\\end_timeup.*") or string.match(filename, "common\\demo\\fixdemo\\end\\cut_data\\end_pk_win_.*") then
	if celebr_anthem then
	else
		if stats then
			--log("game loaded: " .. filename)
			if (tid == 1 or tid == 23 or tid == 24 or tid == 25  or tid == 26 or tid == 27 or tid == 28 or tid == 31 or tid == 35 or tid == 43 or tid == 45 or tid == 46 or tid == 48 or tid == 54 or tid == 55 or tid == 59 or tid == 68 or tid == 83 or tid == 84 or tid == 85 or tid == 86 or tid == 87 or tid == 88 or tid == 89 or tid == 90 or tid == 91 or tid == 92 or tid == 95 or tid == 97 or tid == 105 or tid == 106 or tid == 107 or tid == 122 or tid == 123 or tid == 124 or tid == 125 or tid == 126 or tid == 127 or tid == 128 or tid == 129 or tid == 130 or tid == 131 or tid == 132 or tid == 137 or tid == 142 or tid == 151 or tid == 159 or tid == 160 or tid == 161 or tid == 162 or tid == 164 or tid == 165) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic\\celebration_anthem.mp3")
				end
			elseif (tid == 21 or tid == 22 or tid == 29 or tid == 30 or tid == 51 or tid == 52 or tid == 67 or tid == 82 or tid == 99 or tid == 116 or tid == 117 or tid == 118 or tid == 120 or tid == 162 or tid == 163) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic\\celebration_anthem.mp3")
			elseif (tid == 4) then
				if cuproundid == 53 then
					if stats.home_score > stats.away_score then
						if teamid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					elseif stats.pk_home_score > stats.pk_away_score then
						if teamid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					else
						if awayid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif awayid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif awayid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif awayid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif awayid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					end
				end
			elseif (tid == 6) then
				if cuproundid == 53 then
					if stats.home_score > stats.away_score then
						if teamid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					elseif stats.pk_home_score > stats.pk_away_score then
						if teamid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					else
						if awayid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif awayid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif awayid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif awayid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif awayid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					end
				end
			elseif (tid == 7) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Generic\\celebration_anthem.mp3")
				end
			elseif (tid == 10) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\CONMEBOL\\Copa_Libertadores\\celebration_anthem.mp3")
				end
			elseif (tid == 17) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\England\\EPL\\celebration_anthem.mp3")
			elseif (tid == 18) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Italy\\Serie_A\\celebration_anthem.mp3")
			elseif (tid == 19) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\LaLiga\\celebration_anthem.mp3")
			elseif (tid == 80) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Spain\\Segunda\\celebration_anthem.mp3")
			elseif (tid == 20) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_1\\celebration_anthem.mp3")
			elseif (tid == 42) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\UEFA\\UEFA_Euro\\celebration_anthem.mp3")
				end
			elseif (tid == 50) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\Bundesliga\\celebration_anthem.mp3")
			elseif (tid == 53) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFB_Pokal\\celebration_anthem.mp3")
				end
			elseif (tid == 81) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\France\\Ligue_2\\celebration_anthem.mp3")
			elseif (tid == 95) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Germany\\DFL_SuperCup\\celebration_anthem.mp3")
			else
				celebr_anthem = audio.new(ctx.sider_dir .. "content\\tournament_anth_tunnel\\Other\\Unused\\celebration_anthem.mp3")
			end
		end

		log(string.format("celebration anthem starting: %s", celebr_anthem:get_filename()))
            	celebr_anthem:set_volume(0.8)
            	celebr_anthem:play()
	end
    end
end

function m.init(ctx)
    ctx.register("set_teams", teams_selected)
    ctx.register("after_set_conditions", get_ids)
    ctx.register("livecpk_data_ready", m.data_ready)
end

return m
