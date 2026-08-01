-- SP Football Life Tournament Audio
-- DONT REMOVE CREDITS:
-- Author: Predator002 on 27/01/2023
-- Version: 3.0
-- Originally posted on Evo-Web
-- Massive thanks to Juce & Zlac because their assistance made this lua possible

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
    rdm = math.random (1,7)
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
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\FIFA\\World_Cup\\tunnel_anthem_pre.mp3")
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
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Euro\\tunnel_anthem_pre.mp3")
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
	        			pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_pre.mp3")
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
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_Testimonial\\tunnel_anthem_pre.mp3")
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
	        		pretunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_World_Selection\\tunnel_anthem_pre.mp3")
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
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Anderlecht_intro.mp3")
			elseif teamid == 2009 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Cercle_Brugge_intro.mp3")
			elseif teamid == 269 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Club_Brugge_intro.mp3")
			elseif teamid == 1195 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Genk_intro.mp3")
			elseif teamid == 1196 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Gent_intro.mp3")
			elseif teamid == 1197 and (tid == 65535 or tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Belgium\\Standard_Liege_intro.mp3")
			elseif teamid == 1247 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Brazil\\Corinthians.mp3")
			elseif teamid == 1248 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Brazil\\Flamengo_intro.mp3")
			elseif teamid == 137 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Brazil\\Palmeiras.mp3")
			elseif teamid == 1255 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Brazil\\Sao_Paulo.mp3")
			elseif teamid == 136 and (tid == 65535 or tid == 29) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Brazil\\Vasco_da_Gama.mp3")
			elseif teamid == 1256 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Chile\\ColoColo_intro.mp3")
			elseif teamid == 2548 and (tid == 65535 or tid == 67) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Chile\\Palestino_intro.mp3")
			elseif teamid == 2193 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Colombia\\AtleticoNacional_intro.mp3")
			elseif teamid == 2285 and (tid == 65535 or tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Colombia\\Junior_intro.mp3")
			elseif teamid == 1832 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Denmark\\Brondby_intro.mp3")
			elseif teamid == 1207 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Denmark\\Kobenhavn_intro.mp3")
			elseif teamid == 2071 and (tid == 65535 or tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Denmark\\Randers_intro.mp3")
			elseif teamid == 101 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal_intro.mp3")
			elseif teamid == 107 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\AstonVilla_intro.mp3")
			elseif teamid == 1588 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Barnsley_intro.mp3")
			elseif teamid == 201 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Birmingham_intro.mp3")
			elseif teamid == 176 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Blackburn_intro.mp3")
			elseif teamid == 4071 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Bournemouth_intro.mp3")
			elseif teamid == 4180 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Brentford2_intro.mp3")
			elseif teamid == 377 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Brighton_intro.mp3")
			elseif teamid == 378 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Burnley_intro.mp3")
			elseif teamid == 379 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Cardiff_intro.mp3")
			elseif teamid == 102 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Chelsea2_intro.mp3")
			elseif teamid == 4183 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Coventry_intro.mp3")
			elseif teamid == 382 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\CrystalPalace_intro.mp3")
			elseif teamid == 383 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Derby_intro.mp3")
			elseif teamid == 177 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Everton_intro.mp3")
			elseif teamid == 178 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		       	 	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Fulham_intro.mp3")
			elseif teamid == 2610 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Huddersfield_intro.mp3")
			elseif teamid == 1589 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Hull_intro.mp3")
			elseif teamid == 386 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Ipswich_Town_intro.mp3")
			elseif teamid == 104 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Leeds2_intro.mp3")
			elseif teamid == 204 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Leicester_intro.mp3")
			elseif teamid == 103 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool_intro.mp3")
			elseif teamid == 4363 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Luton_intro.mp3")
			elseif teamid == 173 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity_intro.mp3")
			elseif teamid == 100 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited1_intro.mp3")
			elseif teamid == 100 and (tid == 58 or tid == 103 or tid == 108) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited2_intro.mp3")
			elseif teamid == 205 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Middlesbrough_intro.mp3")
			elseif teamid == 387 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Millwall_intro.mp3")
			elseif teamid == 106 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle_intro.mp3")
			elseif teamid == 388 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Norwich_intro.mp3")
			elseif teamid == 389 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\NottsForest2_intro.mp3")
			elseif teamid == 4364 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Plymouth_Argyle_intro.mp3")
			elseif teamid == 4192 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\PrestonNorthEnd_intro.mp3")
			elseif teamid == 1327 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\QPR_intro.mp3")
			elseif teamid == 4193 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Rotherham_intro.mp3")
			elseif teamid == 4194 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\SheffieldUnited_intro.mp3")
			elseif teamid == 394 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\SheffieldWednesday_intro.mp3")
			elseif teamid == 207 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton_intro.mp3")
			elseif teamid == 395 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Stoke_intro.mp3")
			elseif teamid == 396 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Sunderland_intro.mp3")
			elseif teamid == 1909 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea_intro.mp3")
			elseif teamid == 179 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham_intro.mp3")
			elseif teamid == 398 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Watford_intro.mp3")
			elseif teamid == 399 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestBrom_intro.mp3")
			elseif teamid == 105 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam2_intro.mp3")
			elseif teamid == 208 and (tid == 65535 or tid == 17 or tid == 79 or tid == 83 or tid == 23) and cuproundid ~= 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Wolves_intro.mp3")
			elseif teamid == 209 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Ajaccio_intro.mp3")
			elseif teamid == 4200 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Amiens_intro.mp3")
			elseif teamid == 403 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Angers_intro.mp3")
			elseif teamid == 180 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Auxerre_intro.mp3")
			elseif teamid == 115 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Bordeaux_intro.mp3")
			elseif teamid == 1329 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Brest_intro.mp3")
			elseif teamid == 407 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Clermont_intro.mp3")
			elseif teamid == 413 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Le_Havre_intro.mp3")
			elseif teamid == 182 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lens_intro.mp3")
			elseif teamid == 213 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lille_intro.mp3")
			elseif teamid == 414 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lorient_intro.mp3")
			elseif teamid == 181 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lyon_intro.mp3")
			elseif teamid == 113 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Marseille_intro.mp3")
			elseif teamid == 4123 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Metz_intro.mp3")
			elseif teamid == 112 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Monaco_intro.mp3")
			elseif teamid == 215 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Montpellier_intro.mp3")
			elseif teamid == 216 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Nantes_intro.mp3")
			elseif teamid == 217 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Nice_intro.mp3")
			elseif teamid == 114 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Paris_SG_intro.mp3")
			elseif teamid == 418 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Saint_Etienne_intro.mp3")
			elseif teamid == 1330 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Stade_de_Reims_intro.mp3")
			elseif teamid == 218 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Stade_Rennais_intro.mp3")
			elseif teamid == 4213 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Strasbourg_intro.mp3")
			elseif teamid == 221 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Toulouse_intro.mp3")
			elseif teamid == 420 and (tid == 65535 or tid == 20) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Troyes_intro.mp3")
			elseif teamid == 4124 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Augsburg_intro.mp3")
			elseif teamid == 128 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Bayer_Leverkusen_intro.mp3")
			elseif teamid == 127 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Bayern_Munich_intro.mp3")
			elseif teamid == 4128 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Bochum_intro.mp3")
			elseif teamid == 126 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Borussia_Dortmund_intro.mp3")
			elseif teamid == 225 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Borussia_Monchengladbach_intro.mp3")
			elseif teamid == 5008 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Darmstadt_intro.mp3")
			elseif teamid == 226 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Eintracht_Frankfurt_intro.mp3")
			elseif teamid == 227 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Freiburg_intro.mp3")
			elseif teamid == 5009 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Heidenheim_intro.mp3")
			elseif teamid == 4126 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Hoffenheim_intro.mp3")
			elseif teamid == 4137 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Koln_intro.mp3")
			elseif teamid == 436 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Mainz_intro.mp3")
			elseif teamid == 5010 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\RB_Leipzig_intro.mp3")
			elseif teamid == 184 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Schalke_04_intro.mp3")
			elseif teamid == 231 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Stuttgart_intro.mp3")
			elseif teamid == 4140 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Union_Berlin_intro.mp3")
			elseif teamid == 185 and (tid == 65535 or tid == 50) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Werder_Bremen_intro.mp3")
			elseif teamid == 121 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\AC_Milan_intro.mp3")
			elseif teamid == 234 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Atalanta_intro.mp3")
			elseif teamid == 319 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Bari_intro.mp3")
			elseif teamid == 186 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Bologna_intro.mp3")
			elseif teamid == 187 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Brescia_intro.mp3")
			elseif teamid == 320 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Cagliari_intro.mp3")
			elseif teamid == 4220 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Cremonese_intro.mp3")
			elseif teamid == 1363 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Crotone_intro.mp3")
			elseif teamid == 235 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Empoli_intro.mp3")
			elseif teamid == 124 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Fiorentina_intro.mp3")
			elseif teamid == 4234 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Frosinone_intro.mp3")
			elseif teamid == 323 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Genoa_intro.mp3")
			elseif teamid == 336 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Hellas_Verona_intro.mp3")
			elseif teamid == 119 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Inter_intro.mp3")
			elseif teamid == 120 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Juventus_intro.mp3")
			elseif teamid == 122 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Lazio_intro.mp3")
			elseif teamid == 4237 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Lecce_intro.mp3")
			elseif teamid == 4914 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Monza_intro.mp3")
			elseif teamid == 327 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Napoli_intro.mp3")
			elseif teamid == 238 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Palermo_intro.mp3")
			elseif teamid == 123 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Parma_intro.mp3")
			elseif teamid == 4241 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Pisa_intro.mp3")
			elseif teamid == 125 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Roma_intro.mp3")
			elseif teamid == 4244 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Salernitana_intro.mp3")
			elseif teamid == 240 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Sampdoria_intro.mp3")
			elseif teamid == 1919 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Sassuolo_intro.mp3")
			elseif teamid == 1600 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Spezia_intro.mp3")
			elseif teamid == 4228 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Sudtirol_intro.mp3")
			elseif teamid == 333 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Torino_intro.mp3")
			elseif teamid == 190 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Udinese_intro.mp3")
			elseif teamid == 4229 and (tid == 65535 or tid == 18) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Venezia_intro.mp3")
			elseif teamid == 116 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Netherlands\\Ajax_intro.mp3")
			elseif teamid == 242 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Netherlands\\AZAlkmaar_intro.mp3")
			elseif teamid == 117 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Netherlands\\Feyenoord_intro.mp3")
			elseif teamid == 118 and (tid == 65535 or tid == 21) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Netherlands\\PSV_intro.mp3")
			elseif teamid == 191 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Portugal\\Benfica_intro.mp3")
			elseif teamid == 1974 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Portugal\\Braga_intro.mp3")
			elseif teamid == 192 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Portugal\\Porto_intro.mp3")
			elseif teamid == 193 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Portugal\\Sporting_intro.mp3")
			elseif teamid == 1804 and (tid == 65535 or tid == 22) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Portugal\\Vitoria_de_Guimaraes_intro.mp3")
			elseif teamid == 1217 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Russia\\CSKA_Moscow_intro.mp3")
			elseif teamid == 271 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Russia\\Lokomotiv_Moscow_intro.mp3")
			elseif teamid == 135 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Russia\\Spartak_Moscow_intro.mp3")
			elseif teamid == 1218 and (tid == 65535 or tid == 116) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Russia\\Zenit_St_Petersburg_intro.mp3")
			elseif teamid == 131 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Celtic_intro.mp3")
			elseif teamid == 132 and (tid == 65535 or tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Rangers_intro.mp3")
			elseif teamid == 357 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Almeria_intro.mp3")
			elseif teamid == 258 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Athletic_Bilbao_intro.mp3")
			elseif teamid == 172 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Atletico_Madrid_intro.mp3")
			elseif teamid == 108 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Barcelona.mp3")
			elseif teamid == 4308 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Cadiz_intro.mp3")
			elseif teamid == 195 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Celta_Vigo_intro.mp3")
			elseif teamid == 4145 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Deportivo_Alaves_intro.mp3")
			elseif teamid == 4146 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Eibar_intro.mp3")
			elseif teamid == 361 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Elche_intro.mp3")
			elseif teamid == 259 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Espanyol_intro.mp3")
			elseif teamid == 362 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Getafe_intro.mp3")
			elseif teamid == 2187 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Girona_intro.mp3")
			elseif teamid == 1765 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Granada_intro.mp3")
			elseif teamid == 2188 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Huesca_intro.mp3")
			elseif teamid == 4272 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Leganes_intro.mp3")
			elseif teamid == 366 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Levante_intro.mp3")
			elseif teamid == 261 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Mallorca_intro.mp3")
			elseif teamid == 263 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Osasuna_intro.mp3")
			elseif teamid == 370 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Rayo_Vallecano_intro.mp3")
			elseif teamid == 194 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Real_Betis_intro.mp3")
			elseif teamid == 109 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Real_Madrid_intro.mp3")
			elseif teamid == 196 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Real_Sociedad_intro.mp3")
			elseif teamid == 266 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Real_Valladolid_intro.mp3")
			elseif teamid == 265 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Sevilla_intro.mp3")
			elseif teamid == 110 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Valencia_intro.mp3")
			elseif teamid == 267 and (tid == 65535 or tid == 19) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Villarreal_intro.mp3")
			elseif teamid == 279 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\South Korea\\Jeonbuk_Hyundai_Motors_intro.mp3")
			elseif teamid == 281 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\South Korea\\Pohang_Steelers_intro.mp3")
			elseif teamid == 4174 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\South Korea\\Ulsan_Hyundai_intro.mp3")
			elseif teamid == 276 and (tid == 65535 or tid == 52) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\South Korea\\Ulsan_Hyundai_intro.mp3")
			elseif teamid == 1706 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Switzerland\\Basel_intro.mp3")
			elseif teamid == 1950 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Switzerland\\Young_Boys_intro.mp3")
			elseif teamid == 1957 and (tid == 65535 or tid == 117) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Switzerland\\Zurich_intro.mp3")
			elseif teamid == 273 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Besiktas_intro.mp3")
			elseif teamid == 5354 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Caykur_Rizespor_intro.mp3")
			elseif teamid == 197 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Fenerbahce_intro.mp3")
			elseif teamid == 130 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Galatasaray_intro.mp3")
			elseif teamid == 5356 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Gaziantep_intro.mp3")
			elseif teamid == 1995 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Istanbul_Basaksehir_intro.mp3")
			elseif teamid == 1945 and (tid == 65535 or tid == 118) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Turkey\\Trabzonspor_intro.mp3")

		     -- TOURNAMENT ANTHEMS -- ATTEMPT TO PLAY THESE IF NO TEAM ANTHEMS EXIST
		    	elseif (tid == 58 or tid == 103) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_Testimonial\\tunnel_anthem.mp3")
		    	elseif tid == 108 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_World_Selection\\tunnel_anthem.mp3")
			elseif tid == 59 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Copa_Argentina\\tunnel_anthem.mp3")
			elseif tid == 30 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Superliga\\tunnel_anthem.mp3")
			elseif tid == 122 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Croky_Cup\\tunnel_anthem.mp3")
			elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Jupilar_Pro_League\\tunnel_anthem.mp3")
			elseif tid == 67 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Chile\\Primera_Division\\tunnel_anthem.mp3")
			elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_Libertadores\\tunnel_anthem.mp3")

			elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\tunnel_anthem.mp3")

			elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\tunnel_anthem.mp3")

			elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Denmark\\Superliga\\tunnel_anthem.mp3")
			elseif tid == 86 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\Community_Shield\\tunnel_anthem.mp3")
			elseif (tid == 79 or tid == 83) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EFL\\tunnel_anthem.mp3")
			elseif tid == 17 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EPL\\tunnel_anthem.mp3")
			elseif tid == 23 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\FA_Cup\\tunnel_anthem.mp3")
			elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\FIFA\\World_Cup\\tunnel_anthem.mp3")
			elseif tid == 26 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Coupe_De_La_Ligue\\tunnel_anthem.mp3")
			elseif tid == 20 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_1\\tunnel_anthem.mp3")
			elseif tid == 81 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_2\\tunnel_anthem.mp3")
			elseif tid == 50 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\Bundesliga\\tunnel_anthem.mp3")
			elseif tid == 53 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFB_Pokal\\tunnel_anthem.mp3")
			elseif tid == 95 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFL_SuperCup\\tunnel_anthem.mp3")
			elseif tid == 107 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\Asia\\tunnel_anthem.mp3")
			elseif tid == 105 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\North_America\\tunnel_anthem.mp3")
			elseif tid == 106 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\South_America\\tunnel_anthem.mp3")
			elseif tid == 24 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Coppa_Italia\\tunnel_anthem.mp3")
			elseif tid == 18 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_A\\tunnel_anthem.mp3")
			elseif (tid == 82 or tid == 85) then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_B\\tunnel_anthem.mp3")
			elseif tid == 89 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Supercoppa_Italiana\\tunnel_anthem.mp3")
			elseif tid == 52 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\J1_League\\tunnel_anthem.mp3")
			elseif tid == 55 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Emperors_Cup\\tunnel_anthem.mp3")
			elseif tid == 97 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Super_Cup\\tunnel_anthem.mp3")
			elseif tid == 21 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\Eredevisie\\tunnel_anthem.mp3")
			elseif tid == 22 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Portugal\\Liga_NOS\\tunnel_anthem.mp3")
			elseif tid == 116 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Russia\\Premier_League\\tunnel_anthem.mp3")
			elseif tid == 25 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\Copa_Del_Rey\\tunnel_anthem.mp3")
			elseif tid == 19 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\LaLiga\\tunnel_anthem.mp3")
			elseif tid == 87 then
 			       	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\SuperCopa\\tunnel_anthem.mp3")
			elseif tid == 118 then
		        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Turkey\\SuperLig\\tunnel_anthem.mp3")
	       		elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
	                        if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
	                        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\tunnel_anthem_delay.mp3")
	                        else
	                        	tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\tunnel_anthem.mp3")
	                        end
	                elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
				if cuproundid == 53 then
					if rdm == 1 then
		        			tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2009.mp3")
					elseif rdm == 2 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2010.mp3")
					elseif rdm == 3 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2011.mp3")
					elseif rdm == 4 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2013.mp3")
					elseif rdm == 5 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2018.mp3")
					elseif rdm == 6 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2019.mp3")
					elseif rdm == 7 then
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_pes2018.mp3")
					else
						tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\tunnel_anthem_2009.mp3")
					end
				else
	       	                 	if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
	                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\tunnel_anthem_delay.mp3")
        	                	else
                	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\tunnel_anthem.mp3")
                        		end
				end
			elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Euro\\tunnel_anthem.mp3")
			elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
                        	if (stadiumid == 2 or stadiumid == 7 or stadiumid == 22 or stadiumid == 63) then
                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\tunnel_anthem_delay.mp3")
                        	else
                        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\tunnel_anthem.mp3")
                        	end

			elseif tid == 7 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Super_Cup\\tunnel_anthem.mp3")
			elseif (tid == 51 or tid == 166 or tid == 167) then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS\\tunnel_anthem.mp3")
			elseif tid == 54 then
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS_Cup\\tunnel_anthem.mp3")
			else
	        		tunnel_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\tunnel_anthem.mp3")
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
			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem.mp3")
			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
			lineup_anthem:set_volume(0.7)
			lineup_anthem:play()
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then
			else
				if (teamid == 234 or teamid == 124 or teamid == 327 or teamid == 1919 or teamid == 186 or teamid == 323 or teamid == 122 or teamid == 123 or teamid == 4923 or teamid == 187 or teamid == 336 or teamid == 4237 or teamid == 125 or teamid == 333 or teamid == 320 or teamid == 119 or teamid == 121 or teamid == 240 or teamid == 190 or teamid == 317 or teamid == 4928 or teamid == 4234 or teamid == 328 or teamid == 1600 or teamid == 4232 or teamid == 4220 or teamid == 2517 or teamid == 4241 or teamid == 4077 or teamid == 188 or teamid == 1363 or teamid == 325 or teamid == 4915 or teamid == 4229 or teamid == 1920 or teamid == 235 or teamid == 4240 or teamid == 4244 or teamid == 4230) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem_scream.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 108) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem_whistle.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 173) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem_boo.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 120) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem_classic_scream.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				elseif (teamid == 102 or teamid == 109 or teamid == 110 or teamid == 127 or teamid == 128 or teamid == 181) then
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem_classic.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				else
					--log("game loaded: " .. filename)
					stop_tunnelanthem_quiet()
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\lineup_anthem.mp3")
					log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
					lineup_anthem:set_volume(0.7)
					lineup_anthem:play()
				end
			end
        	elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
			if (teamid == 108 or teamid == 173) then
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\lineup_anthem_whistle.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
			else
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\lineup_anthem.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
			end
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
			--log("game loaded: " .. filename)
			stop_tunnelanthem_quiet()
			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_Libertadores\\lineup_anthem.mp3")
			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
			lineup_anthem:set_volume(0.7)
			lineup_anthem:play()

		elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
			--log("game loaded: " .. filename)
			stop_tunnelanthem_quiet()
			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\lineup_anthem.mp3")
			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
			lineup_anthem:set_volume(0.7)
			lineup_anthem:play()

        	elseif (tid == 18) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_A\\lineup_anthem.mp3")
            		log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            		lineup_anthem:set_volume(0.7)
            		lineup_anthem:play()
        	elseif (tid == 24) then
            		if cuproundid == 53 then
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Coppa_Italia\\lineup_anthem_final.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
            		else
            			--log("game loaded: " .. filename)
            			stop_tunnelanthem_quiet()
            			lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Coppa_Italia\\lineup_anthem.mp3")
            			log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            			lineup_anthem:set_volume(0.7)
            			lineup_anthem:play()
            		end
        	elseif (tid == 89) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Supercoppa_Italiana\\lineup_anthem.mp3")
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
					lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EPL\\lineup_anthem.mp3")
            				log(string.format("lineup anthem starting: %s", lineup_anthem:get_filename()))
            				lineup_anthem:set_volume(0.7)
            				lineup_anthem:play()
				end
			end
        	elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
            		--log("game loaded: " .. filename)
            		stop_tunnelanthem_quiet()
            		lineup_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Jupilar_Pro_League\\lineup_anthem.mp3")
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
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal_format.mp3")
					elseif teamid == 107 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\AstonVilla_format.mp3")
					elseif teamid == 1588 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Barnsley_format.mp3")
					elseif teamid == 201 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Birmingham_format.mp3")
					elseif teamid == 176 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Blackburn_format.mp3")
					elseif teamid == 1761 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Blackpool_format.mp3")
					elseif teamid == 4071 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Bournemouth_format.mp3")
					elseif teamid == 4180 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Brentford2_format.mp3")
					elseif teamid == 377 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Brighton_format.mp3")
					elseif teamid == 378 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Burnley_format.mp3")
					elseif teamid == 379 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Cardiff_format.mp3")
					elseif teamid == 102 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Chelsea_format.mp3")
					elseif teamid == 4183 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Coventry_format.mp3")
					elseif teamid == 382 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\CrystalPalace_format.mp3")
					elseif teamid == 177 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Everton_format.mp3")
					elseif teamid == 178 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Fulham_format.mp3")
					elseif teamid == 2610 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Huddersfield_format.mp3")
					elseif teamid == 1589 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Hull_format.mp3")
					elseif teamid == 386 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Ipswich_Town_format.mp3")
					elseif teamid == 104 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Leeds2_format.mp3")
					elseif teamid == 204 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Leicester_format.mp3")
					elseif teamid == 103 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool_format.mp3")
					elseif teamid == 4363 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Luton_format.mp3")
					elseif teamid == 173 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity3_format.mp3")
					elseif teamid == 100 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited1_format.mp3")
					elseif teamid == 205 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Middlesbrough_format.mp3")
					elseif teamid == 387 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Millwall_format.mp3")
					elseif teamid == 106 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle_format.mp3")
					elseif teamid == 388 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Norwich_format.mp3")
					elseif teamid == 389 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\NottsForest2_format.mp3")
					elseif teamid == 4364 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Plymouth_Argyle_format.mp3")
					elseif teamid == 4192 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\PrestonNorthEnd_format.mp3")
					elseif teamid == 1327 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\QPR_format.mp3")
					elseif teamid == 4193 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Rotherham_format.mp3")
					elseif teamid == 4194 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\SheffieldUnited_format.mp3")
					elseif teamid == 394 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\SheffieldWednesday_format.mp3")
					elseif teamid == 207 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton_format.mp3")
					elseif teamid == 395 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Stoke_format.mp3")
					elseif teamid == 396 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Sunderland_format.mp3")
					elseif teamid == 1909 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea_format.mp3")
					elseif teamid == 179 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham_format.mp3")
					elseif teamid == 398 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Watford_format.mp3")
					elseif teamid == 399 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestBrom_format.mp3")
					elseif teamid == 105 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam_format.mp3")
					elseif teamid == 208 then
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Wolves_format.mp3")
					end
				end
			elseif nolineupanthem_epl == true then
				if no2ndteamanthem_epl == false then
					if teamid == 101 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal_format.mp3")
					elseif teamid == 201 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Birmingham_format.mp3")
					elseif teamid == 1761 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Blackpool_format.mp3")
					elseif teamid == 4180 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Brentford2_format.mp3")
					elseif teamid == 379 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Cardiff_format.mp3")
					elseif teamid == 102 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Chelsea_format.mp3")
					elseif teamid == 4183 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Coventry_format.mp3")
					elseif teamid == 177 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Everton_format.mp3")
					elseif teamid == 178 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Fulham_format.mp3")
					elseif teamid == 386 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Ipswich_Town_format.mp3")
					elseif teamid == 173 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity3_format.mp3")
					elseif teamid == 100 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited1_format.mp3")
					elseif teamid == 389 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\NottsForest2_format.mp3")
					elseif teamid == 4364 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Plymouth_Argyle_format.mp3")
					elseif teamid == 1327 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\QPR_format.mp3")
					elseif teamid == 4193 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Rotherham_format.mp3")
					elseif teamid == 394 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\SheffieldWednesday_format.mp3")
					elseif teamid == 395 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Stoke_format.mp3")
					elseif teamid == 396 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Sunderland_format.mp3")
					elseif teamid == 1909 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea_format.mp3")
					elseif teamid == 179 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham_format.mp3")
					elseif teamid == 399 then
						stop_tunnelanthem_slowly()
            					format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestBrom_format.mp3")
					end
				end
			end
		elseif (tid == 18) then
			if teamid == 121 then
            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\AC_Milan_format.mp3")
			elseif teamid == 120 then
            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Juventus_format.mp3")
			end
		elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool2_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam2_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Celtic2_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			else
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 102 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Chelsea_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool3_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam3_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Celtic_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
			if cuproundid == 53 then
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool2_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam2_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Celtic2_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			else
				if teamid == 101 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Arsenal2_format.mp3")
				elseif teamid == 102 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Chelsea_format.mp3")
				elseif teamid == 103 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Liverpool3_format.mp3")
				elseif teamid == 173 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterCity2_format.mp3")
				elseif teamid == 100 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\ManchesterUnited2_format.mp3")
				elseif teamid == 106 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Newcastle2_format.mp3")
				elseif teamid == 207 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Southampton2_format.mp3")
				elseif teamid == 1909 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Swansea2_format.mp3")
				elseif teamid == 179 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\Tottenham2_format.mp3")
				elseif teamid == 105 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\England\\WestHam3_format.mp3")
				elseif teamid == 181 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Lyon_format.mp3")
				elseif teamid == 113 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Marseille_format.mp3")
				elseif teamid == 114 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\France\\Paris_SG_format.mp3")
				elseif teamid == 232 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Germany\\Wolfsburg_format.mp3")
				elseif teamid == 234 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Atalanta2_format.mp3")
				elseif teamid == 119 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Italy\\Inter2_format.mp3")
				elseif teamid == 131 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Celtic_format.mp3")
				elseif teamid == 132 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Scotland\\Rangers_format.mp3")
				elseif teamid == 108 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Barcelona2_format.mp3")
				elseif teamid == 172 then
	            			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Teams\\Spain\\Atletico_Madrid_format.mp3")
				end
			end
        	elseif (tid == 107) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\Asia\\format_anthem.mp3")
        	elseif (tid == 105) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\North_America\\format_anthem.mp3")
        	elseif (tid == 106) then
            		format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\South_America\\format_anthem.mp3")
		else
			format_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\format_anthem.mp3")
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
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_Testimonial\\intro_anthem.mp3")
	    	elseif tid == 108 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_World_Selection\\intro_anthem.mp3")
		elseif (tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\AFC\\AFC_Champions_League\\intro_anthem.mp3")
		elseif (tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 or tid == 45) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 46 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 120 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 127 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 132 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 142 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 88 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 28 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 91 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 123 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 129 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 124 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 139 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\KSA\\Saudi_Pro_League\\intro_anthem.mp3")
	    	elseif tid == 164 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 165 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 125 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 130 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
		elseif tid == 59 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Copa_Argentina\\intro_anthem.mp3")
		elseif tid == 92 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Supercopa_Argentina\\intro_anthem.mp3")
		elseif tid == 30 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Superliga\\intro_anthem.mp3")
		elseif tid == 122 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Croky_Cup\\intro_anthem.mp3")
		elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Jupilar_Pro_League\\intro_anthem.mp3")
		elseif tid == 31 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Copa_do_Brasil\\intro_anthem.mp3")
		elseif tid == 29 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Serie_A\\intro_anthem.mp3")
		elseif tid == 163 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Serie_B\\intro_anthem.mp3")
		elseif tid == 68 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Chile\\Copa_Chile\\intro_anthem.mp3")
		elseif tid == 67 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Chile\\Primera_Division\\intro_anthem.mp3")
		elseif tid == 126 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Copa_Colombia\\intro_anthem.mp3")
		elseif (tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Primera_A\\intro_anthem.mp3")
		elseif tid == 131 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Superliga_Colombiana\\intro_anthem.mp3")
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_Libertadores\\intro_anthem.mp3")

		elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\intro_anthem.mp3")

		elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Denmark\\Superliga\\intro_anthem.mp3")
		elseif tid == 86 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\Community_Shield\\intro_anthem.mp3")
		elseif (tid == 79 or tid == 83) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EFL\\intro_anthem.mp3")
		elseif tid == 17 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EPL\\intro_anthem.mp3")
		elseif tid == 23 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\FA_Cup\\intro_anthem.mp3")
		elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\FIFA\\World_Cup\\intro_anthem.mp3")
		elseif tid == 26 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Coupe_De_La_Ligue\\intro_anthem.mp3")
		elseif tid == 20 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_1\\intro_anthem.mp3")
		elseif tid == 81 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_2\\intro_anthem.mp3")
		elseif tid == 50 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\Bundesliga\\intro_anthem.mp3")
		elseif tid == 53 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFB_Pokal\\intro_anthem.mp3")
		elseif tid == 95 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFL_SuperCup\\intro_anthem.mp3")
		elseif tid == 107 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\Asia\\intro_anthem.mp3")
		elseif tid == 105 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\North_America\\intro_anthem.mp3")
		elseif tid == 106 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\South_America\\intro_anthem.mp3")
		elseif tid == 24 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Coppa_Italia\\intro_anthem.mp3")
		elseif tid == 18 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_A\\intro_anthem.mp3")
		elseif (tid == 82 or tid == 85) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_B\\intro_anthem.mp3")
		elseif tid == 89 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Supercoppa_Italiana\\intro_anthem.mp3")
		elseif tid == 52 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\J1_League\\intro_anthem.mp3")
		elseif tid == 55 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Emperors_Cup\\intro_anthem.mp3")
		elseif tid == 97 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Super_Cup\\intro_anthem.mp3")
		elseif tid == 21 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\Eredevisie\\intro_anthem.mp3")
		elseif tid == 90 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\Johan_Cruyff_Shield\\intro_anthem.mp3")
		elseif tid == 27 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\KNVB_Cup\\intro_anthem.mp3")
		elseif tid == 22 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Portugal\\Liga_NOS\\intro_anthem.mp3")
		elseif tid == 116 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Russia\\Premier_League\\intro_anthem.mp3")
		elseif (tid == 137) then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Scotland\\Scottish_Cup\\intro_anthem.mp3")
		elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Scotland\\SPFL\\intro_anthem.mp3")
		elseif tid == 25 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\Copa_Del_Rey\\intro_anthem.mp3")
		elseif tid == 19 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\LaLiga\\intro_anthem.mp3")
		elseif tid == 87 then
 		       	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\SuperCopa\\intro_anthem.mp3")
		elseif tid == 118 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Turkey\\SuperLig\\intro_anthem.mp3")
		elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Euro\\intro_anthem.mp3")
                elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
                        halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then 
	        		halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\intro_anthem.mp3")
			else
	        		halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\intro_anthem.mp3")
		elseif tid == 7 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Super_Cup\\intro_anthem.mp3")
		elseif (tid == 51 or tid == 166 or tid == 167) then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS\\intro_anthem.mp3")
		elseif tid == 54 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS_Cup\\intro_anthem.mp3")
		elseif tid == 65535 then
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic\\intro_anthem.mp3")
		else
	        	halftime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\intro_anthem.mp3")
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
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_Testimonial\\intro_anthem.mp3")
	    	elseif tid == 108 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\ML_World_Selection\\intro_anthem.mp3")
		elseif (tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\AFC\\AFC_Champions_League\\intro_anthem.mp3")
		elseif (tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 or tid == 45) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 46 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 120 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 127 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 132 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 142 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 88 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 28 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
	    	elseif tid == 91 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_03\\intro_anthem.mp3")
	    	elseif tid == 123 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 129 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 124 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 139 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\KSA\\Saudi_Pro_League\\intro_anthem.mp3")
	    	elseif tid == 164 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_04\\intro_anthem.mp3")
	    	elseif tid == 165 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_05\\intro_anthem.mp3")
	    	elseif tid == 125 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_06\\intro_anthem.mp3")
	    	elseif tid == 130 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic_02\\intro_anthem.mp3")
		elseif tid == 59 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Copa_Argentina\\intro_anthem.mp3")
		elseif tid == 92 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Supercopa_Argentina\\intro_anthem.mp3")
		elseif tid == 30 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Argentina\\Superliga\\intro_anthem.mp3")
		elseif tid == 122 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Croky_Cup\\intro_anthem.mp3")
		elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Belgium\\Jupilar_Pro_League\\intro_anthem.mp3")
		elseif tid == 31 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Copa_do_Brasil\\intro_anthem.mp3")
		elseif tid == 29 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Serie_A\\intro_anthem.mp3")
		elseif tid == 163 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Brazil\\Serie_B\\intro_anthem.mp3")
		elseif tid == 68 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Chile\\Copa_Chile\\intro_anthem.mp3")
		elseif tid == 67 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Chile\\Primera_Division\\intro_anthem.mp3")
		elseif tid == 126 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Copa_Colombia\\intro_anthem.mp3")
		elseif (tid == 119 or tid == 160 or tid == 161 or tid == 168 or tid == 169) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Primera_A\\intro_anthem.mp3")
		elseif tid == 131 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Colombia\\Superliga_Colombiana\\intro_anthem.mp3")
		elseif (tid == 8 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 or tid == 10) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_Libertadores\\intro_anthem.mp3")

		elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\intro_anthem.mp3")

		elseif (tid == 141 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Denmark\\Superliga\\intro_anthem.mp3")
		elseif tid == 86 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\Community_Shield\\intro_anthem.mp3")
		elseif (tid == 79 or tid == 83) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EFL\\intro_anthem.mp3")
		elseif tid == 17 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EPL\\intro_anthem.mp3")
		elseif tid == 23 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\FA_Cup\\intro_anthem.mp3")
		elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\FIFA\\World_Cup\\intro_anthem.mp3")
		elseif tid == 26 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Coupe_De_La_Ligue\\intro_anthem.mp3")
		elseif tid == 20 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_1\\intro_anthem.mp3")
		elseif tid == 81 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_2\\intro_anthem.mp3")
		elseif tid == 50 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\Bundesliga\\intro_anthem.mp3")
		elseif tid == 53 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFB_Pokal\\intro_anthem.mp3")
		elseif tid == 95 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFL_SuperCup\\intro_anthem.mp3")
		elseif tid == 107 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\Asia\\intro_anthem.mp3")
		elseif tid == 105 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\North_America\\intro_anthem.mp3")
		elseif tid == 106 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\ICC\\South_America\\intro_anthem.mp3")
		elseif tid == 24 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Coppa_Italia\\intro_anthem.mp3")
		elseif tid == 18 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_A\\intro_anthem.mp3")
		elseif (tid == 82 or tid == 85) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_B\\intro_anthem.mp3")
		elseif tid == 89 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Supercoppa_Italiana\\intro_anthem.mp3")
		elseif tid == 52 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\J1_League\\intro_anthem.mp3")
		elseif tid == 55 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Emperors_Cup\\intro_anthem.mp3")
		elseif tid == 97 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Japan\\Super_Cup\\intro_anthem.mp3")
		elseif tid == 21 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\Eredevisie\\intro_anthem.mp3")
		elseif tid == 90 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\Johan_Cruyff_Shield\\intro_anthem.mp3")
		elseif tid == 27 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Netherlands\\KNVB_Cup\\intro_anthem.mp3")
		elseif tid == 22 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Portugal\\Liga_NOS\\intro_anthem.mp3")
		elseif tid == 116 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Russia\\Premier_League\\intro_anthem.mp3")
		elseif (tid == 137) then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Scotland\\Scottish_Cup\\intro_anthem.mp3")
		elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Scotland\\SPFL\\intro_anthem.mp3")
		elseif tid == 25 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\Copa_Del_Rey\\intro_anthem.mp3")
		elseif tid == 19 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\LaLiga\\intro_anthem.mp3")
		elseif tid == 87 then
 		       	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\SuperCopa\\intro_anthem.mp3")
		elseif tid == 118 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Turkey\\SuperLig\\intro_anthem.mp3")
		elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Euro\\intro_anthem.mp3")
                elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194) then
                        fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
		elseif (tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
			if cuproundid == 53 then 
	        		fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\intro_anthem.mp3")
			else
	        		fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League\\intro_anthem.mp3")
			end
		elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\intro_anthem.mp3")
		elseif tid == 7 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Super_Cup\\intro_anthem.mp3")
		elseif (tid == 51 or tid == 166 or tid == 167) then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS\\intro_anthem.mp3")
		elseif tid == 54 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\United_States\\MLS_Cup\\intro_anthem.mp3")
		elseif tid == 65535 then
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic\\intro_anthem.mp3")
		else
	        	fulltime_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\intro_anthem.mp3")
		end

                stop_tunnelanthem()
                delay_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\delay3_anthem.mp3")

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
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic\\celebration_anthem.mp3")
				end
			elseif (tid == 21 or tid == 22 or tid == 29 or tid == 30 or tid == 51 or tid == 52 or tid == 67 or tid == 80 or tid == 82 or tid == 99 or tid == 116 or tid == 117 or tid == 118 or tid == 120 or tid == 162 or tid == 163) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic\\celebration_anthem.mp3")
			elseif (tid == 4) then
				if cuproundid == 53 then
					if stats.home_score > stats.away_score then
						if teamid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					elseif stats.pk_home_score > stats.pk_away_score then
						if teamid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					else
						if awayid == 103 then
	       	     					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_liverpool.mp3")
						elseif awayid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_mancity.mp3")
						elseif awayid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_celtic.mp3")
						elseif awayid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_rangers.mp3")
						elseif awayid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Champions_League_Final\\celebration_anthem.mp3")
						end
					end
				end
			elseif (tid == 6) then
				if cuproundid == 53 then
					if stats.home_score > stats.away_score then
						if teamid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					elseif stats.pk_home_score > stats.pk_away_score then
						if teamid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif teamid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif teamid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif teamid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif teamid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					else
						if awayid == 103 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_liverpool.mp3")
						elseif awayid == 173 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_mancity.mp3")
						elseif awayid == 131 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_celtic.mp3")
						elseif awayid == 132 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_rangers.mp3")
						elseif awayid == 108 then
	            					celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem_barcelona.mp3")
						else
		            				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Europa_League\\celebration_anthem.mp3")
						end
					end
				end
			elseif (tid == 7) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Generic\\celebration_anthem.mp3")
				end
			elseif (tid == 10) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_Libertadores\\celebration_anthem.mp3")
				end
			elseif (tid == 43) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\CONMEBOL\\Copa_America\\celebration_anthem.mp3")
				end
			elseif (tid == 17) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\England\\EPL\\celebration_anthem.mp3")
			elseif (tid == 18) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Italy\\Serie_A\\celebration_anthem.mp3")
			elseif (tid == 19) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Spain\\LaLiga\\celebration_anthem.mp3")
			elseif (tid == 20) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_1\\celebration_anthem.mp3")
			elseif (tid == 42) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\UEFA\\UEFA_Euro\\celebration_anthem.mp3")
				end
			elseif (tid == 50) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\Bundesliga\\celebration_anthem.mp3")
			elseif (tid == 53) then
				if cuproundid == 53 then
		            		celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Germany\\DFB_Pokal\\celebration_anthem.mp3")
				end
			elseif (tid == 81) then
		            	celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\France\\Ligue_2\\celebration_anthem.mp3")
			else
				celebr_anthem = audio.new(ctx.sider_dir .. "content\\audio\\Other\\Unused\\celebration_anthem.mp3")
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
