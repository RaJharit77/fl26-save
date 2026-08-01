--FansServer.lua module 

local fileroot = ".\\content\\fans-server"

local function make_key(ctx, filename)
	rdm = math.random(1,3)
	tid = ctx.tournament_id
	home = ctx.home_team
	away = ctx.away_team
	stad = ctx.stadium

	if ctx.match_info == 53 then
		choreo = "Finals"

	--UEFA
	elseif (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or 
		tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or 
		tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or 
		tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or 
		tid == 7171 or tid == 8195 or tid == 4 or tid == 5 or 
		tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or 
		tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or 
		tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6) then
			choreo = "Scarf"
			if ctx.match_info ~= 53 then
				--FC Barcelona
				if home == 108 then
					if stad == 2 then
						-- MUN or CHE or RMA or PSG or INT or ESP
						if away == 100 or away == 102 or away == 109 or away == 114 or away == 119 or away == 259 then
							choreo = "Choreo\\Spain\\Barcelona"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\Spain\\Barcelona"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Real Madrid CF
				elseif home == 109 then
					if stad == 21 then
						-- BAR or VAL or PSG or JUV or BVB or FCB or ATL or ATH or GET
						if away == 108 or away == 110 or away == 114 or away == 120 or away == 126 or away == 127 or away == 172 or away == 258 or away == 362 then
							if rdm == 1 then
								choreo = "Choreo\\Spain\\Real Madrid\\UEFA_1"
							elseif rdm == 2 then
								choreo = "Choreo\\Spain\\Real Madrid\\UEFA_2"
							elseif rdm == 3 then
								choreo = "Choreo\\Spain\\Real Madrid\\UEFA_2"
							end
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\Spain\\Real Madrid\\UEFA_1"
							elseif rdm == 2 then
								choreo = "Choreo\\Spain\\Real Madrid\\UEFA_2"
							elseif rdm == 3 then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Valencia CF
				elseif home == 110 then
					-- RMA or VIL or LEV
					if away == 109 or away == 267 or away == 366 then
						choreo = "Choreo\\Spain\\Valencia"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Valencia"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Atlético Madrid
				elseif home == 172 then
					if stad == 56 then
						-- RMA or GET
						if away == 109 or away == 362 then
							choreo = "Choreo\\Spain\\Atletico Madrid\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\Spain\\Atletico Madrid\\League"
							elseif rdm == 2 then
								choreo = "Scarf"
							elseif rdm == 3 then
								choreo = "Choreo\\Spain\\Atletico Madrid\\UEFA"
							end
						else
							choreo = nil
						end
					end
				--Real Betis
				elseif home == 194 then
					-- MAL or SEV or GRA
					if away == 260 or away == 265 or away == 1765 then
						choreo = "Choreo\\Spain\\Real Betis\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Real Betis\\UEFA"
						elseif rdm == 2 then
							choreo = "Scarf"
						elseif rdm == 3 then
							choreo = "Choreo\\Spain\\Real Betis\\League"
						end
					else
						choreo = nil
					end
				--Celta de Vigo
				elseif home == 195 then
					-- DEP
					if away == 111 then
						choreo = "Choreo\\Spain\\Celta"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Celta"
					end
				--Real Sociedad
				elseif home == 196 then
					-- ATH or ALA
					if away == 258 or away == 4145 then
						choreo = "Choreo\\Spain\\Real Sociedad"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Real Sociedad"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Athletic Bilbao
				elseif home == 258 then
					-- RMA or RSO or ALA
					if away == 109 or away == 196 or away == 4145 then
						choreo = "Choreo\\Spain\\Athletic Club"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Athletic Club"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--RCD Espanyol
				elseif home == 259 then
					-- BAR
					if away == 108 then
						choreo = "Choreo\\Spain\\Espanyol"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Espanyol"
					end
				--Málaga CF
				elseif home == 260 then
					-- BET or SEV or GRA
					if away == 194 or away == 265 or away == 1765 then
						choreo = "Choreo\\Spain\\Malaga"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Malaga"
					end
				--RCD Mallorca
				elseif home == 261 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Mallorca"
					end
				--CA Osasuna
				elseif home == 263 then
					-- ALA or LOG
					if away == 4145 or away == 4255 then
						choreo = "Choreo\\Spain\\Osasuna"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Osasuna"
					end
				--Racing Santander
				elseif home == 264 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Racing"
					end
				--Sevilla FC
				elseif home == 265 then
					-- BET or MAL
					if away == 194 or away == 260 then
						choreo = "Choreo\\Spain\\Sevilla"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Spain\\Sevilla"
						end
					else
						choreo = nil
					end
				--Real Valladolid
				elseif home == 266 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Valladolid"
					end
				--Villarreal CF
				elseif home == 267 then
					-- VAL
					if away == 110 then
						choreo = "Choreo\\Spain\\Villareal"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Villareal"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Real Zaragoza
				elseif home == 268 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Zaragoza"
					end
				--Elche CF
				elseif home == 361 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Elche"
					end
				--Getafe CF
				elseif home == 362 then
					-- RMA or ATL
					if away == 109 or away == 172 then
						choreo = "Choreo\\Spain\\Getafe"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Getafe"
					end
				--Sporting Gijón
				elseif home == 363 then
					-- OVI
					if away == 4260 then
						choreo = "Choreo\\Spain\\Sporting De Gijon"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Sporting De Gijon"
					end
				--UD Las Palmas
				elseif home == 364 then
					-- ELC or TEN
					if away == 361 or away == 4147 then
						choreo = "Choreo\\Spain\\Las Palmas"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Las Palmas"
					end
				--Levante UD
				elseif home == 366 then
					-- VAL or ELC
					if away == 110 or away == 361 then
						choreo = "Choreo\\Spain\\Levante"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Levante"
					end
				--Rayo Vallecano
				elseif home == 370 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Rayo Vallecano"
					end
				--SD Ponferradina
				elseif home == 1595 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Ponferradina"
					end
				--Granada CF
				elseif home == 1765 then
					-- BET or MAL
					if away == 194 or away == 260 then
						choreo = "Choreo\\Spain\\Granada"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Granada"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Girona FC
				elseif home == 2187 then
					-- SAB
					if away == 2523 then
						choreo = "Choreo\\Spain\\Girona"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Girona"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Deportivo Alavés
				elseif home == 4145 then
					-- RSO or ATH or OSA or EIB
					if away == 196 or away == 258 or away == 263 or away == 4146 then
						choreo = "Choreo\\Spain\\Alaves"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Alaves"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Albacete Balompié
				elseif home == 4302 then
					-- ELC
					if away == 361 then
						choreo = "Choreo\\Spain\\Albacete"
					elseif rdm == 1 then
						choreo = "Choreo\\Spain\\Albacete"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Borussia Dortmund
				elseif home == 126 then
					if stad == 51 then
						-- RMA or FCB or S04 or BMG
						if away == 109 or away == 127 or away == 184 or away == 225 then
							choreo = "Choreo\\Germany\\Borussia Dortmund\\UEFA_2"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\Germany\\Borussia Dortmund\\UEFA_2"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Germany\\Borussia Dortmund\\UEFA_1"
							end
						end
					end
				--Bayern Munich
				elseif home == 127 then
					if stad == 11 then
						-- MUN or RMA or BVB or B04 or S04 or VFB
						if away == 100 or away == 109 or away == 126 or away == 128 or away == 184 or away == 231 then
							choreo = "Choreo\\Germany\\Bayern Munich\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 3 then
								choreo = "Choreo\\Germany\\Bayern Munich\\UEFA_1"
							elseif rdm == 2 then
								choreo = "Choreo\\Germany\\Bayern Munich\\UEFA_2"
							elseif rdm == 1 then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Bayer Leverkusen
				elseif home == 128 then
					-- FCB or KOE
					if away == 127 or away == 4137 then
						choreo = "Choreo\\Germany\\Bayer Leverkusen"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Bayer Leverkusen"
						elseif rdm == 1 then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Schalke
				elseif home == 184 then
					if stad == 63 then
						-- BVB or FCB
						if away == 126 or away == 127 then
							choreo = "Choreo\\Germany\\Schalke"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Germany\\Schalke"
							elseif rdm == 1 then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Werder Bremen
				elseif home == 185 then
					-- FCB
					if away == 127 then
						choreo = "Choreo\\Germany\\Werder Bremen"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Werder Bremen"
						elseif rdm == 1 then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Borussia Monchengladbach
				elseif home == 225 then
					-- BVB or KOE
					if away == 126 or away == 4137 then
						choreo = "Choreo\\Germany\\Borussia Monchengladbach"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Borussia Monchengladbach"
						elseif rdm == 1 then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Frankfurt
				elseif home == 226 then
					-- M05
					if away == 436 then
						choreo = "Choreo\\Germany\\Frankfurt"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Frankfurt"
						elseif rdm == 1 then
							choreo = "Scarf"
						end
					end
				--Freiburg
				elseif home == 227 then
					-- VFB
					if away == 231 then
						choreo = "Choreo\\Germany\\Freiburg"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Germany\\Freiburg"
					end
				--VfL Wolfsburg
				elseif home == 232 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Germany\\VfL Wolfsburg"
					end
				--FSV Mainz
				elseif home == 436 then
					-- SGE
					if away == 226 then
						choreo = "Choreo\\Germany\\FSV Mainz"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Germany\\FSV Mainz"
					end
				--FC Augsburg
				elseif home == 4124 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Germany\\FC Augsburg"
					end
				--Hertha Berlin
				elseif home == 4125 then
					if stad == 38 then
						-- UNB
						if away == 4140 then
							choreo = "Choreo\\Germany\\Hertha Berlin"
						elseif rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Hertha Berlin"
						end
					end
				--TSG 1899 Hoffenheim
				elseif home == 4126 then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Germany\\Hoffenheim"
					end
				--FC Koln
				elseif home == 4137 then
					-- B04 or BMG or BOC
					if away == 128 or away == 225 or away == 4128 then
						choreo = "Choreo\\Germany\\FC Koln"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Germany\\FC Koln"
					end
				--Union Berlin
				elseif home == 4140 then
					-- BSC
					if away == 4125 then
						choreo = "Choreo\\Germany\\Union Berlin"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Germany\\Union Berlin"
					end
				--RB Leipzig
				elseif home == 5010 then
					if (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						elseif rdm == 1 then
							choreo = "Choreo\\Germany\\RB Leipzig"
						end
					end
				--Manchester United
				elseif home == 100 then
					if stad == 7 then
						-- ARS or CHE or LIV or BAR or JUV or FCB or MCI
						if away == 101 or away == 102 or away == 103 or away == 108 or away == 120 or away == 127 or away == 173 then
							choreo = "Choreo\\England\\Manchester United\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\England\\Manchester United\\UEFA"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Arsenal FC
				elseif home == 101 then
					if stad == 52 then
						-- MUN or CHE or TOT
						if away == 100 or away == 102 or away == 179 then
							choreo = "Choreo\\England\\Arsenal\\UEFA_1"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\England\\Arsenal\\UEFA_1"
							elseif rdm == 2 then
								choreo = "Scarf"
							elseif rdm == 3 then
								choreo = "Choreo\\England\\Arsenal\\UEFA_2"
							end
						else
							choreo = nil
						end
					end
				--Chelsea FC
				elseif home == 102 then
					-- MUN or ARS or LIV or BAR or TOT
					if away == 100 or away == 101 or away == 103 or away == 108 or away == 179 then
						choreo = "Choreo\\England\\Chelsea\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Chelsea\\UEFA"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				--Liverpool FC
				elseif home == 103 then
					if stad == 4 then
						-- MUN or CHE or MIL or MCI or EVE
						if away == 100 or away == 102 or away == 121 or away == 173 or away == 177 then
							choreo = "Choreo\\England\\Liverpool\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Choreo\\England\\Liverpool\\UEFA"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Scarf"
							end
						else
							choreo = nil
						end
					end
				--Leeds United
				elseif home == 104 then
					-- CHE or HUD or BAR or HUL or SHU
					if away == 102 or away == 2610 or away == 1588 or away == 1589 or away == 4194 then
						choreo = "Choreo\\England\\Leeds"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Leeds"
					end
				--West Ham United
				elseif home == 105 then
					-- CHE or MIL
					if away == 102 or away == 387 then
						choreo = "Choreo\\England\\West Ham United\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\West Ham United\\UEFA"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Newcastle United
				elseif home == 106 then
					-- MID or SUN
					if away == 205 or away == 396 then
						choreo = "Choreo\\England\\Newcastle"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Newcastle"
					end
				--Aston Villa FC
				elseif home == 107 then
					-- BIR or WOL or WBA
					if away == 201 or away == 208 or away == 399 then
						choreo = "Choreo\\England\\Aston Villa"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Aston Villa"
					end
				--Manchester City
				elseif home == 173 then 
					-- MUN or LIV or RMA
					if away == 100 or away == 103 or away == 109 then
						choreo = "Choreo\\England\\Manchester City\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Manchester City\\UEFA"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Everton FC
				elseif home == 177 then
					-- LIV
					if away == 103 then
						choreo = "Choreo\\England\\Everton"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Everton"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Fulham FC
				elseif home == 178 then
					-- QPR or BRE
					if away == 1327 or away == 4180 then
						choreo = "Choreo\\England\\Fulham"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Fulham"
					end
				--Tottenham Hotspur
				elseif home == 179 then
					-- ARS or CHE or WHU
					if away == 101 or away == 102 or away == 105 then
						choreo = "Choreo\\England\\Tottenham\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Tottenham\\UEFA"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Birmingham City
				elseif home == 201 then
					-- ASV or WOL or WBA or COV
					if away == 107 or away == 208 or away == 399 or away == 4183 then
						choreo = "Choreo\\England\\Birmingham"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Birmingham"
					end
				--Leicester City
				elseif home == 204 then
					-- DER or NFO
					if away == 383 or away == 389 then
						choreo = "Choreo\\England\\Leicester City\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Leicester City\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				--Southampton FC
				elseif home == 207 then
					-- BHA or BOU
					if away == 377 or away == 4071 then
						choreo = "Choreo\\England\\Southampton"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Southampton"
					end
				--Wolverhampton Wanderers
				elseif home == 208 then
					-- ASV or BIR or WBA or COV
					if away == 107 or away == 201 or away == 399 or away == 4183 then
						choreo = "Choreo\\England\\Wolverhampton"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Wolverhampton"
					end
				--Brighton and Hove
				elseif home == 377 then
					-- SOU or CRY or BOU
					if away == 207 or away == 382 or away == 4071 then
						choreo = "Choreo\\England\\Brighton and Hove"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Brighton and Hove"
					end
				--Burnley FC
				elseif home == 378 then
					-- BLB or BLP or PNE
					if away == 176 or away == 1761 or away == 4192 then
						choreo = "Choreo\\England\\Burnley"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Burnley"
					end
				--Crystal Palace FC
				elseif home == 382 then
					-- SOU or BHA or MIL
					if away == 207 or away == 377 or away == 387 then
						choreo = "Choreo\\England\\Crystal Palace"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Crystal Palace"
					end
				--Derby County
				elseif home == 383 then
					-- LEI or NFO
					if away == 204 or away == 389 then
						choreo = "Choreo\\England\\Derby County"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Derby County"
					end
				--Millwall FC
				elseif home == 387 then
					-- WHU or CRY
					if away == 105 or away == 382 then
						choreo = "Choreo\\England\\Millwall"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Millwall"
					end
				--Nottingham Forest
				elseif home == 389 then
					-- LEI or DER or SHU
					if away == 204 or away == 383 or away == 4194 then
						choreo = "Choreo\\England\\Nottingham Forest"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Nottingham Forest"
					end
				--Watford FC
				elseif home == 398 then
					-- RDG or LUT
					if away == 391 or away == 4363 then
						choreo = "Choreo\\England\\Watford"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Watford"
					end
				--West Bromvich Albion
				elseif home == 399 then
					-- ASV or BIR or WOL
					if away == 107 or away == 201 or away == 208 then
						choreo = "Choreo\\England\\West Bromvich Albion"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\West Bromvich Albion"
					end
				--Queens Park Rangers
				elseif home == 1327 then
					-- FUL or BRE
					if away == 178 or away == 4180 then
						choreo = "Choreo\\England\\QPR"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\QPR"
					end
				--Huddersfield Town
				elseif home == 2610 then
					-- LEE or BAR or SHU
					if away == 104 or away == 1588 or away == 4194 then
						choreo = "Choreo\\England\\Huddersfield"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Huddersfield"
					end
				--AFC Bournemouth
				elseif home == 4071 then
					-- SOU or BHA or RDG
					if away == 207 or away == 377 or away == 391 then
						choreo = "Choreo\\England\\Bournemouth"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Bournemouth"
					end
				--Coventry City
				elseif home == 4183 then
					-- BIR or WOL
					if away == 201 or away == 208 then
						choreo = "Choreo\\England\\Coventry"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Coventry"
					end
				--Sheffield United
				elseif home == 4194 then
					-- LEE or NFO or BAR or HUD
					if away == 104 or away == 389 or away == 1588 or away == 2610 then
						choreo = "Choreo\\England\\Sheffield United"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\England\\Sheffield United"
					end
				--Internazionale
				elseif home == 119 then
					if stad == 1 then
						-- MIL
						if away == 121 then
							choreo = "Choreo\\Italy\\Inter\\AC Milan\\1"
						-- BAR or JUV or ROM or NAP
						elseif away == 108 or away == 120 or away == 125 or away == 327 then
							choreo = "Choreo\\Italy\\Inter\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Italy\\Inter\\UEFA"
							end
						else
							choreo = nil
						end
					end
				--Juventus FC
				elseif home == 120 then
					if stad == 22 then
						-- MUN or RMA or INT or MIL or FIO or ROM or GEN or NAP or TOR
						if away == 100 or away == 109 or away == 119 or away == 121  or away == 124 or away == 125 or away == 323 or away == 327 or away == 333 then
							choreo = "Choreo\\Italy\\Juventus"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Italy\\Juventus"
							end
						else
							choreo = nil
						end
					end
				--AC Milan
				elseif home == 121 then
					if stad == 30 then
						-- INT
						if away == 119 then
							choreo = "Choreo\\Italy\\AC Milan\\Inter\\1"
						-- LIV or JUV or ROM or GEN or NAP
						elseif away == 103 or away == 119 or away == 120 or away == 125 or away == 323 or away == 327 then
							choreo = "Choreo\\Italy\\AC Milan\\UEFA"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Italy\\AC Milan\\UEFA"
							end
						else
							choreo = nil
						end
					end
				--SS Lazio
				elseif home == 122 then
					if stad == 6 then
						-- FIO or NAP
						if away == 124 or away == 327 then
							choreo = "Choreo\\Italy\\Lazio\\UEFA"
						-- ROM
						elseif away == 125 then
							choreo = "Choreo\\Italy\\Lazio\\Roma"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Italy\\Lazio\\UEFA"
							end
						else
							choreo = nil
						end
					end
				--ACF Fiorentina
				elseif home == 124 then
					-- JUV or LAZ or ROM or BOL or EMP or NAP or PIS
					if away == 120 or away == 122 or away == 125 or away == 186 or away == 235 or away == 327 or away == 4241 then
						choreo = "Choreo\\Italy\\Fiorentina"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Fiorentina"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Parma Calcio
				elseif home == 123 then
					-- BOL or REG
					if away == 186 or away == 4225 then
						choreo = "Choreo\\Italy\\Parma"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Parma"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--AS Roma
				elseif home == 125 then
					if stad == 6 then
						-- INT or JUV or MIL or FIO or NAP
						if away == 119 or away == 120 or away == 121 or away == 124 or away == 327 then
							choreo = "Choreo\\Italy\\Roma\\UEFA"
						-- LAZ
						elseif away == 122 then
							choreo = "Choreo\\Italy\\Roma\\Lazio"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Italy\\Roma\\Lazio"
							end
						else
							choreo = nil
						end
					end
				--Bologna FC
				elseif home == 186 then
					-- PAR or FIO or SPA
					if away == 123 or away == 124 or away == 240 or away == 4923 then
						choreo = "Choreo\\Italy\\Bologna"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Bologna"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Brescia Calcio
				elseif home == 187 then
					-- ATA or EMP or HEL or VIC
					if away == 234 or away == 235 or away == 336 or away == 337 then
						choreo = "Choreo\\Italy\\Brescia"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Brescia"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Udinese Calcio
				elseif home == 190 then
					-- VEN
					if away == 4229 then
						choreo = "Choreo\\Italy\\Udinese"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Udinese"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Atalanta BC
				elseif home == 234 then
					-- BRE or NAP or HEL
					if away == 187 or away == 327 or away == 336 then
						choreo = "Choreo\\Italy\\Atalanta"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Atalanta"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--FC Empoli
				elseif home == 235 then
					-- FIO or BRE
					if away == 124 or away == 187 then
						choreo = "Choreo\\Italy\\Empoli"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Empoli"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--UC Sampdoria
				elseif home == 240 then
					-- GEN
					if away == 323 then
						choreo = "Choreo\\Italy\\Sampdoria\\Genoa"
					-- BOL or NAP or TOR or PIS
					elseif away == 186 or away == 327 or away == 333 or away == 4241 then
						choreo = "Choreo\\Italy\\Sampdoria\\League"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Sampdoria\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Ascoli Calcio
				elseif home == 317 then
					-- PES
					if away == 328 then
						choreo = "Choreo\\Italy\\Ascoli"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Italy\\Ascoli"
					end
				--Cagliari Calcio
				elseif home == 320 then
					-- NAP
					if away == 327 then
						choreo = "Choreo\\Italy\\Cagliari"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Cagliari"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Genoa CFC
				elseif home == 323 then
					-- SAM
					if away == 240 then
						choreo = "Choreo\\Italy\\Genoa\\Sampdoria"
					-- JUV or MIL or HEL or SPE
					elseif away == 120 or away == 121 or away == 336 or away == 1600 then
						choreo = "Choreo\\Italy\\Genoa\\League"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Genoa\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--SSC Napoli
				elseif home == 327 then
					-- INT or JUV or MIL or LAZ or FIO or ROM or ATA or SAM or CAG or HEL 
					if away == 119 or away == 120 or away == 121 or away == 122 or away == 124 or away == 125 or away == 234 or away == 240 or away == 320 or away == 336 then
						choreo = "Choreo\\Italy\\Napoli\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Italy\\Napoli\\UEFA"
						end
					else
						choreo = nil
					end
				--Torino FC
				elseif home == 333 then
					-- JUV or SAM
					if away == 120 or away == 240 then
						choreo = "Choreo\\Italy\\Torino"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Torino"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Hellas Verona
				elseif home == 336 then
					-- BRE or CHI or ATA or GEN or NAP
					if away == 187 or away == 188 or away == 234 or away == 323 or away == 327 then
						choreo = "Choreo\\Italy\\Hellas Verona"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Hellas Verona"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Spezia Calcio
				elseif home == 1600 then
					-- GEN or REG
					if away == 323 or away == 4225 then
						choreo = "Choreo\\Italy\\Spezia"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Spezia"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--US Sassuolo
				elseif home == 1919 then
					-- REG
					if away == 4225 then
						choreo = "Choreo\\Italy\\Sassuolo"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Sassuolo"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Benevento Calcio
				elseif home == 4232 then
					-- CRO
					if away == 1363 then
						choreo = "Choreo\\Italy\\Benevento"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Benevento"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Frosinone Calcio
				elseif home == 4234 then
					-- PER
					if away == 4240 then
						choreo = "Choreo\\Italy\\Frosinone"
					elseif rdm == 1 then
						choreo = "Choreo\\Italy\\Frosinone"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--US Lecce
				elseif home == 4237 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Lecce"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Ajax Amsterdam
				elseif home == 116 then
					if stad == 70 then
						-- FEY or PSV or ALK or ADH or UTR
						if away == 117 or away == 118 or away == 242 or away == 243 or away == 251 then
							choreo = "Choreo\\Netherlands\\Ajax"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Netherlands\\Ajax"
							end
						else
							choreo = nil
						end
					end
				--PSV Eindhoven
				elseif home == 118 then 
					-- AJA or FEY
					if away == 116 or away == 117 then
						choreo = "Choreo\\Netherlands\\PSV"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Netherlands\\PSV"
						end
					else
						choreo = nil
					end
				--FC Groningen
				elseif home == 244 then 
					-- HEE or ZWO or EMM
					if away == 245 or away == 256 or away == 342 then
						choreo = "Choreo\\Netherlands\\Groningen"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Netherlands\\Groningen"
					end
				--FC Utrecht
				elseif home == 251 then
					-- AJA or FEY or ADH
					if away == 116 or away == 117 or away == 243 then
						choreo = "Choreo\\Netherlands\\Utrecht"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Netherlands\\Utrecht"
					end
				--Monaco
				elseif home == 112 then
					if stad == 41 then
						-- OM or NIC
						if away == 113 or away == 217 then
							choreo = "Choreo\\France\\Monaco"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\France\\Monaco"
							end
						else
							choreo = nil
						end
					end
				--Olympique Marseille
				elseif home == 113 then
					-- MON or PSG
					if away == 112 or away == 114 then
						choreo = "Choreo\\France\\Olympique Marseille"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\France\\Olympique Marseille"
						end
					else
						choreo = nil
					end
				--Paris Saint Germain
				elseif home == 114 then
					-- BAR or RMA or OM or LYO
					if away == 108 or away == 109 or away == 113 or away == 181 then
						choreo = "Choreo\\France\\PSG\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\France\\PSG\\UEFA"
						elseif rdm == 2 then
							choreo = "Scarf"
						elseif rdm == 3 then
							choreo = "Choreo\\France\\PSG\\League"
						end
					else
						choreo = nil
					end
				--Olympique Lyonnais
				elseif home == 181 then
					-- PSG or SAE
					if away == 114 or away == 418 then
						choreo = "Choreo\\France\\Olympique Lyonnais"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\France\\Olympique Lyonnais"
						end
					else
						choreo = nil
					end
				--Lens
				elseif home == 182 then
					-- LIL
					if away == 213 then
						choreo = "Choreo\\France\\Lens"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Lens"
					end
				--Montpellier
				elseif home == 215 then
					-- NIM
					if away == 1910 then
						choreo = "Choreo\\France\\Montpellier"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Montpellier"
					end
				--Nantes
				elseif home == 216 then
					-- BOR or REN
					if away == 115 or away == 218 then
						choreo = "Choreo\\France\\Nantes"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Nantes"
					end
				--Lorient
				elseif home == 414 then
					-- REN
					if away == 218 then
						choreo = "Choreo\\France\\Lorient"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Lorient"
					end
				--Saint-Étienne
				elseif home == 418 then
					-- LYO
					if away == 181 then
						choreo = "Choreo\\France\\Saint-Étienne"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Saint-Étienne"
					end
				--Stade de Reims
				elseif home == 1330 then
					-- TRO
					if away == 420 then
						choreo = "Choreo\\France\\Stade Reims"
					elseif rdm == 1 then
							choreo = "Choreo\\France\\Stade Reims"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Nimes
				elseif home == 1910 then
					-- MNT
					if away == 215 then
						choreo = "Choreo\\France\\Nimes"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Nimes"
					end
				--Metz
				elseif home == 4123 then
					-- ASN or STR
					if away == 415 or away == 4213 then
						choreo = "Choreo\\France\\Metz"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\France\\Metz"
					end
				--Copenhagen
				elseif home == 1207 then
					-- BNY or FCN or AAL or FCM or RAN or AAR
					if away == 1832 or away == 1208 or away == 1818 or away == 2069 or away == 2071 or away == 2067 then
						choreo = "Choreo\\Denmark\\Copenhagen"
					elseif rdm == 1 then
						choreo = "Choreo\\Denmark\\Copenhagen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Benfica
				elseif home == 191 then
					-- POR
					if away == 192 then
						choreo = "Choreo\\Portugal\\Benfica\\UEFA"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Portugal\\Benfica\\UEFA"
						end
					else
						choreo = nil
					end
				--Porto
				elseif home == 192 then
					-- SLB or SCP or BOA
					if away == 191 or away == 193 or away == 4323 then
						choreo = "Choreo\\Portugal\\Porto"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Portugal\\Porto"
						end
					else
						choreo = nil
					end
				--Vitória Guimarães
				elseif home == 1804 then
					-- BRA or BOA
					if away == 1974 or away == 4323 then
						choreo = "Choreo\\Portugal\\Guimarães"
					elseif rdm == 1 then
						choreo = "Choreo\\Denmark\\Copenhagen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Braga
				elseif home == 1974 then
					-- GUI or BOA
					if away == 1804 or away == 4323 then
						choreo = "Choreo\\Portugal\\Braga"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Portugal\\Braga"
						end
					else
						choreo = nil
					end
				--Moreirense
				elseif home == 1804 then
					-- GIL or VIZ
					if away == 2387 or away == 5115 then
						choreo = "Choreo\\Portugal\\Moreirense"
					elseif rdm == 1 then
						choreo = "Choreo\\Portugal\\Moreirense"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Boavista
				elseif home == 4323 then
					-- POR or GUI or BRA
					if away == 192 or away == 1804 or away == 1974 then
						choreo = "Choreo\\Portugal\\Boavista"
					elseif rdm == 1 then
						choreo = "Choreo\\Portugal\\Boavista"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Spartak Moskva
				elseif home == 135 then
					-- LMO or CSK or ZSP or DIN
					if away == 271 or away == 1217 or away == 1218 or away == 1753 then
						choreo = "Choreo\\Russia\\Spartak Moskva"
					elseif rdm == 1 then
						choreo = "Choreo\\Russia\\Spartak Moskva"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Dinamo Moskva
				elseif home == 1753 then
					-- SPM or LMO or CSK or ZSP 
					if away == 135 or away == 271 or away == 1217 or away == 1218 then
						choreo = "Choreo\\Russia\\Dinamo Moskva\\UEFA"
					elseif rdm == 1 then
						choreo = "Choreo\\Russia\\Dinamo Moskva\\UEFA"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Ural
				elseif home == 5201 then
					-- ARS or KHI
					if away == 5197 or away == 5298 then
						choreo = "Choreo\\Russia\\Ural"
					elseif rdm == 1 then
						choreo = "Choreo\\Russia\\Ural"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Celtic
				elseif home == 131 then
					if stad == 64 then
						-- RAN or HIB or HEA
						if away == 132 or away == 1221 or away == 1222 then
							choreo = "Choreo\\Scotland\\Celtic"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Scotland\\Celtic"
							end
						else
							choreo = nil
						end
					end
				--Rangers
				elseif home == 132 then
					if stad == 65 then
						-- CEL or ABE or HEA or HIB
						if away == 131 or away == 1219 or away == 1221 or away == 1222 then
							choreo = "Choreo\\Scotland\\Rangers"
						elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
							if rdm == 1 then
								choreo = "Scarf"
							elseif (rdm == 2 or rdm == 3) then
								choreo = "Choreo\\Scotland\\Rangers"
							end
						else
							choreo = nil
						end
					end
				--Aberdeen
				elseif home == 1219 then
					-- RAN or DUD or HEA or INV or MOT
					if away == 132 or away == 1220 or away == 1221 or away == 1984 or away == 1986 then
						choreo = "Choreo\\Scotland\\Aberdeen"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Scotland\\Aberdeen"
					end
				--Dundee United
				elseif home == 1220 then
					-- ABE or DFC
					if away == 1219 or away == 2621 then
						choreo = "Choreo\\Scotland\\Dundee United"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Scotland\\Dundee United"
					end
				--Hearts
				elseif home == 1221 then
					-- CEL or RAN or ABE or HIB
					if away == 131 or away == 132 or away == 1219 or away == 1222 then
						choreo = "Choreo\\Scotland\\Hearts"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Scotland\\Hearts"
					end
				--Hibernian
				elseif home == 1222 then
					-- CEL or RAN or HEA
					if away == 131 or away == 132 or away == 1221 then
						choreo = "Choreo\\Scotland\\Hibernian"
					elseif rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Scotland\\Hibernian"
					end
				--Basel
				elseif home == 1706 then
					if stad == 49 then
						-- YB or FCZ or LUZ
						if away == 1950 or away == 1957 or away == 4962 then
							choreo = "Choreo\\Switzerland\\Basel"
						elseif rdm == 1 then
							choreo = "Choreo\\Switzerland\\Basel"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				--St. Gallen
				elseif home == 4937 then
					-- LUZ
					if away == 4962 then
						choreo = "Choreo\\Switzerland\\St. Gallen"
					elseif rdm == 1 then
						choreo = "Choreo\\Switzerland\\St. Gallen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Galatasaray
				elseif home == 130 then
					-- FB or BJK
					if away == 197 or away == 273 then
						choreo = "Choreo\\Turkey\\Galatasaray\\UEFA"
					elseif rdm == 1 then
						choreo = "Choreo\\Turkey\\Galatasaray\\UEFA"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Fenerbahce
				elseif home == 197 then
					if stad == 66 then
						-- GS or BJK or TS
						if away == 130 or away == 273 or away == 1945 then
							choreo = "Choreo\\Turkey\\Fenerbahce\\Cup"
						elseif rdm == 1 then
							choreo = "Choreo\\Turkey\\Fenerbahce\\Cup"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				--Beşiktaş JK
				elseif home == 273 then
					-- GS or FB or BFK
					if away == 130 or away == 197 or away == 1995 then
						choreo = "Choreo\\Turkey\\Besiktas"
					elseif rdm == 1 then
						choreo = "Choreo\\Turkey\\Besiktas"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Trabzonspor
				elseif home == 1945 then
					-- FB or SIV
					if away == 197 or away == 1809 then
						choreo = "Choreo\\Turkey\\Trabzonspor"
					elseif rdm == 1 then
						choreo = "Choreo\\Turkey\\Trabzonspor"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Kayserispor
				elseif home == 1996 then
					-- SIV
					if away == 1809 then
						choreo = "Choreo\\Turkey\\Kayserispor"
					elseif rdm == 1 then
						choreo = "Choreo\\Turkey\\Kayserispor"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				--Sparta Praga
				elseif home == 175 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Sparta Praga"
					end
				--Partizan Belgrade
				elseif home == 272 then
					if rdm == 1 then
						choreo = "Choreo\\Rest of Europe\\Partizan Belgrade\\UEFA_1"
					elseif rdm == 2 then
						choreo = "Scarf"
					elseif rdm == 3 then
						choreo = "Choreo\\Rest of Europe\\Partizan Belgrade\\UEFA_2"
					end
				--Dinamo Zagreb
				elseif home == 1203 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Dinamo Zagreb"
					end
				--Rosenborg BK
				elseif home == 1215 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Rosenborg BK"
					end
				--Red Star Belgrade
				elseif home == 1223 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Red Star Belgrade"
					end
				--RB Salzburg
				elseif home == 1586 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\RB Salzburg"
					end
				--Rijeka
				elseif home == 2526 then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Rijeka"
					end
				--Hajduk Split
				elseif home == 2525 then
					if rdm == 1 then
						choreo = "Choreo\\Rest of Europe\\Hajduk Split\\UEFA_2"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Rest of Europe\\Hajduk Split\\UEFA_1"
					elseif rdm == 3 then
						choreo = "Scarf"
					end
				else
					choreo = "Scarf"
				end
			end


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

	--Spanish Teams
	--LaLiga and LigaSantander
	elseif (tid == 19 or tid == 80 or tid == 84 or tid == 25) then
		if ctx.match_info ~= 53 then
			--FC Barcelona
			if home == 108 then
				if stad == 2 then
					-- RMA
					if away == 109 then
						choreo = "Choreo\\Spain\\Barcelona"
					-- ESP
					elseif away == 259 then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Barcelona"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Real Madrid CF
			elseif home == 109 then
				if stad == 21 then
					-- BAR
					if away == 108 or away == 172 then
						choreo = "Choreo\\Spain\\Real Madrid\\League"
					-- VAL or ATL or ATH or GET
					elseif away == 110 or away == 172 or away == 258 or away == 362 then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Real Madrid\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Valencia CF
			elseif home == 110 then
				-- RMA or VIL or LEV
				if away == 109 or away == 267 or away == 366 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Valencia"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Atlético Madrid
			elseif home == 172 then
				if stad == 56 then
					-- RMA or GET
					if away == 109 or away == 362 then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Atletico Madrid\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Real Betis
			elseif home == 194 then
				-- MAL or SEV or GRA
				if away == 260 or away == 265 or away == 1765 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Real Betis\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Celta de Vigo
			elseif home == 195 then
				-- DEP
				if away == 111 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Celta"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Real Sociedad
			elseif home == 196 then
				-- ATH or ALA
				if away == 258 or away == 4145 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Real Sociedad"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Athletic Bilbao
			elseif home == 258 then
				-- RMA or RSO or ALA
				if away == 109 or away == 196 or away == 4145 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Athletic Club"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--RCD Espanyol
			elseif home == 259 then
				-- BAR
				if away == 108 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Espanyol"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Málaga CF
			elseif home == 260 then
				-- BET or SEV or GRA
				if away == 194 or away == 265 or away == 1765 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Malaga"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--CA Osasuna
			elseif home == 263 then
				-- ALA or LOG
				if away == 4145 or away == 4255 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Osasuna"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Sevilla FC
			elseif home == 265 then
				-- BET or MAL
				if away == 194 or away == 260 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Sevilla"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Villarreal CF
			elseif home == 267 then
				-- VAL
				if away == 110 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Villareal"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Elche CF
			elseif home == 361 then
				-- LAP or LEV or ALB
				if away == 364 or away == 366 or away == 4302 then
					choreo = "Choreo\\Spain\\Elche"
				else
					choreo = nil
				end
			--Getafe CF
			elseif home == 362 then
				-- RMA or ATL
				if away == 109 or away == 172 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Getafe"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Sporting Gijón
			elseif home == 363 then
				-- OVI
				if away == 4260 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Sporting De Gijon"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--UD Las Palmas
			elseif home == 364 then
				-- ELC or TEN
				if away == 361 or away == 4147 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Las Palmas"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Levante UD
			elseif home == 366 then
				-- VAL or ELC
				if away == 110 or away == 361 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Levante"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Granada CF
			elseif home == 1765 then
				-- BET or MAL
				if away == 194 or away == 260 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Granada"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Girona FC
			elseif home == 2187 then
				-- SAB
				if away == 2523 then
					choreo = "Choreo\\Spain\\Girona"
				else
					choreo = nil
				end
			--CD Mirandés
			elseif home == 2616 then
				-- BRG
				if away == 4247 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Deportivo Alavés
			elseif home == 4145 then
				-- RSO or ATH or OSA or EIB
				if away == 196 or away == 258 or away == 263 or away == 4146 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Alaves"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--SD Eibar
			elseif home == 4146 then
				-- ALA
				if away == 4145 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Eibar"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--CD Tenerife
			elseif home == 4147 then
				-- LAP
				if away == 364 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Tenerife"	
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Burgos CF
			elseif home == 4247 then
				-- MIR or FUE 
				if away == 2616 or away == 4269 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Real Oviedo
			elseif home == 4260 then
				-- SPO
				if away == 363 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--CD Leganés
			elseif home == 4272 then
				-- ALC or FUE
				if away == 2393 or away == 4269 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Leganes"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Albacete Balompié
			elseif home == 4302 then
				-- ELC
				if away == 361 then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Albacete"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			end
		end
	--Playoff and Copa Del Rey
	elseif (tid == 84 or tid == 25) then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--FC Barcelona
			if home == 108 then
				if stad == 2 then
					-- RMA or ESP
					if away == 109 or away == 259 then
						choreo = "Choreo\\Spain\\Barcelona"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Barcelona"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Real Madrid CF
			elseif home == 109 then
				if stad == 21 then
					-- BAR or VAL or ATL or ATH or GET
					if away == 108 or away == 110 or away == 172 or away == 258 or away == 362 then
						choreo = "Choreo\\Spain\\Real Madrid\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Real Madrid\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Valencia CF
			elseif home == 110 then
				-- RMA or VIL or LEV
				if away == 109 or away == 267 or away == 366 then
					choreo = "Choreo\\Spain\\Valencia"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Spain\\Valencia"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Atlético Madrid
			elseif home == 172 then
				if stad == 56 then
					-- RMA or GET
					if away == 109 or away == 362 then
						choreo = "Choreo\\Spain\\Atletico Madrid\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Spain\\Atletico Madrid\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Real Betis
			elseif home == 194 then
				-- MAL or SEV or GRA
				if away == 260 or away == 265 or away == 1765 then
					choreo = "Choreo\\Spain\\Real Betis\\League"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Real Betis\\League"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Celta de Vigo
			elseif home == 195 then
				-- DEP
				if away == 111 then
					choreo = "Choreo\\Spain\\Celta"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Celta"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Real Sociedad
			elseif home == 196 then
				-- ATH or ALA
				if away == 258 or away == 4145 then
					choreo = "Choreo\\Spain\\Real Sociedad"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Real Sociedad"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Athletic Bilbao
			elseif home == 258 then
				-- RMA or RSO or ALA
				if away == 109 or away == 196 or away == 4145 then
					choreo = "Choreo\\Spain\\Athletic Club"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Athletic Club"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--RCD Espanyol
			elseif home == 259 then
				-- BAR
				if away == 108 then
					choreo = "Choreo\\Spain\\Espanyol"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Espanyol"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Málaga CF
			elseif home == 260 then
				-- BET or SEV or GRA
				if away == 194 or away == 265 or away == 1765 then
					choreo = "Choreo\\Spain\\Malaga"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Malaga"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--RCD Mallorca
			elseif home == 261 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Mallorca"
				end
			--CA Osasuna
			elseif home == 263 then
				-- ALA or LOG
				if away == 4145 or away == 4255 then
					choreo = "Choreo\\Spain\\Osasuna"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Osasuna"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Racing Santander
			elseif home == 264 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Racing"
				end
			--Sevilla FC
			elseif home == 265 then
				-- BET or MAL
				if away == 194 or away == 260 then
					choreo = "Choreo\\Spain\\Sevilla"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Scarf"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Spain\\Sevilla"
					end
				end
			--Real Valladolid
			elseif home == 266 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Valladolid"
				end
			--Villarreal CF
			elseif home == 267 then
				-- VAL
				if away == 110 then
					choreo = "Choreo\\Spain\\Villareal"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Villareal"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Real Zaragoza
			elseif home == 268 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Zaragoza"
				end
			--Elche CF
			elseif home == 361 then
				-- LAP or LEV or ALB
				if away == 364 or away == 366 or away == 4302 then
					choreo = "Choreo\\Spain\\Elche"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Elche"
				end
			--Getafe CF
			elseif home == 362 then
				-- RMA or ATL
				if away == 109 or away == 172 then
					choreo = "Choreo\\Spain\\Getafe"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Getafe"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Sporting Gijón
			elseif home == 363 then
				-- OVI
				if away == 4260 then
					choreo = "Choreo\\Spain\\Sporting De Gijon"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Sporting De Gijon"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--UD Las Palmas
			elseif home == 364 then
				-- ELC or TEN
				if away == 361 or away == 4147 then
					choreo = "Choreo\\Spain\\Las Palmas"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Las Palmas"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Levante UD
			elseif home == 366 then
				-- VAL or ELC
				if away == 110 or away == 361 then
					choreo = "Choreo\\Spain\\Levante"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Levante"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Rayo Vallecano
			elseif home == 370 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Rayo Vallecano"
				end
			--SD Ponferradina
			elseif home == 1595 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Ponferradina"
				end
			--Granada CF
			elseif home == 1765 then
				-- BET or MAL
				if away == 194 or away == 260 then
					choreo = "Choreo\\Spain\\Granada"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Granada"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Girona FC
			elseif home == 2187 then
				-- SAB
				if away == 2523 then
					choreo = "Choreo\\Spain\\Girona"
				elseif rdm == 1 then
					choreo = "Scarf"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Choreo\\Spain\\Girona"
				end
			--Deportivo Alavés
			elseif home == 4145 then
				-- RSO or ATH or OSA or EIB
				if away == 196 or away == 258 or away == 263 or away == 4146 then
					choreo = "Choreo\\Spain\\Alaves"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Alaves"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--CD Tenerife
			elseif home == 4147 then
				-- LAP
				if away == 364 then
					choreo = "Choreo\\Spain\\Tenerife"
				elseif rdm == 1 then
					choreo = "Scarf"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Choreo\\Spain\\Tenerife"
				end
			--Oviedo
			elseif home == 4260 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Oviedo"
				end
			--CD Leganés
			elseif home == 4272 then
				-- ALC or FUE
				if away == 2393 or away == 4269 then
					choreo = "Choreo\\Spain\\Leganes"
				elseif rdm == 1 then
					choreo = "Scarf"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Choreo\\Spain\\Leganes"
				end
			--Cádiz CF
			elseif home == 4308 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Cadiz"
				end
			--FC Cartagena
			elseif home == 4309 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Cartagena"
				end
			--Albacete Balompié
			elseif home == 4302 then
				-- ELC
				if away == 361 then
					choreo = "Choreo\\Spain\\Albacete"
				elseif rdm == 1 then
					choreo = "Choreo\\Spain\\Albacete"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--German Teams
	--Bundesliga
	elseif tid == 50 then
		if ctx.match_info ~= 53 then
			--Borussia Dortmund
			if home == 126 then
				if stad == 51 then
					-- FCB
					if away == 127 then
						choreo = "Choreo\\Germany\\Borussia Dortmund\\Bayern"
					elseif away == 184 or away == 225 then
					-- S04 or BMG
						if rdm == 1 then
							choreo = "Choreo\\Germany\\Borussia Dortmund\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Bayern München
			elseif home == 127 then
				if stad == 11 then
					-- BVB or B04 or S04 or VFB
					if away == 126 or away == 128 or away == 184 or away == 231 then
						if rdm == 1 then
							choreo = "Choreo\\Germany\\Bayern Munich\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Bayer 04 Leverkusen
			elseif home == 128 then
				-- FCB or KOE
				if away == 127 or away == 4137 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Bayer Leverkusen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Schalke 04
			elseif home == 184 then
				if stad == 63 then
					-- BVB or FCB
					if away == 126 or away == 127 then
						if rdm == 1 then
							choreo = "Choreo\\Germany\\Schalke"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--SV Werder Bremen
			elseif home == 185 then
				-- FCB
				if away == 127 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Werder Bremen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Borussia Mönchengladbach
			elseif home == 225 then
				-- BVB or KOE
				if away == 126 or away == 4137 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Borussia Monchengladbach"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Eintracht Frankfurt
			elseif home == 226 then
				-- M05
				if away == 436 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Frankfurt"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--SC Freiburg
			elseif home == 227 then
				-- VFB
				if away == 231 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Freiburg"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--VfB Stuttgart
			elseif home == 231 then
				-- FCB or SCF
				if away == 127 or away == 227 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FSV Mainz 05
			elseif home == 436 then
				-- SGE
				if away == 226 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\FSV Mainz"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Hertha BSC
			elseif home == 4125 then
				if stad == 38 then
					-- UNB
					if away == 4140 then
						if rdm == 1 then
							choreo = "Choreo\\Germany\\Hertha Berlin"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--VfL Bochum
			elseif home == 4128 then
				-- KOE
				if away == 4137 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Köln
			elseif home == 4137 then
				-- B04 or BMG or BOC
				if away == 128 or away == 225 or away == 4128 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\FC Koln"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Union Berlin
			elseif home == 4140 then
				-- BSC
				if away == 4125 then
					if rdm == 1 then
						choreo = "Choreo\\Germany\\Union Berlin"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			end
		end
	
	--DFB Pokal
	elseif tid == 53 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Borussia Dortmund
			if home == 126 then
				if stad == 51 then
					-- FCB or S04 or BMG
					if away == 127 or away == 184 or away == 225 then
						choreo = "Choreo\\Germany\\Borussia Dortmund\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Scarf"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Germany\\Borussia Dortmund\\League"
						end
					end
				end
			--Bayern München
			elseif home == 127 then
				if stad == 11 then
					-- BVB or B04 or S04 or VFB
					if away == 126 or away == 128 or away == 184 or away == 231 then
						choreo = "Choreo\\Germany\\Bayern Munich\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						elseif rdm == 1 then
							choreo = "Choreo\\Germany\\Bayern Munich\\UEFA_2"
						end
					end
				end
			--Bayer 04 Leverkusen
			elseif home == 128 then
				-- FCB or KOE
				if away == 127 or away == 4137 then
					choreo = "Choreo\\Germany\\Bayer Leverkusen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Bayer Leverkusen"
				end
			--FC Schalke 04
			elseif home == 184 then
				if stad == 63 then
					-- BVB or FCB
					if away == 126 or away == 127 then
						choreo = "Choreo\\Germany\\Schalke"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Germany\\Schalke"
					end
				end
			--SV Werder Bremen
			elseif home == 185 then
				-- FCB
				if away == 127 then
					choreo = "Choreo\\Germany\\Werder Bremen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Werder Bremen"
				end
			--Borussia Mönchengladbach
			elseif home == 225 then
				-- BVB or KOE
				if away == 126 or away == 4137 then
					choreo = "Choreo\\Germany\\Borussia Monchengladbach"
				elseif rdm == 1 then
						choreo = "Choreo\\Germany\\Borussia Monchengladbach"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Eintracht Frankfurt
			elseif home == 226 then
				-- M05
				if away == 436 then
					choreo = "Choreo\\Germany\\Frankfurt"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Frankfurt"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--SC Freiburg
			elseif home == 227 then
				-- VFB
				if away == 231 then
					choreo = "Choreo\\Germany\\Freiburg"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Freiburg"
				end
			--VfL Wolfsburg
			elseif home == 232 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\VfL Wolfsburg"
				end
			--FSV Mainz 05
			elseif home == 436 then
				-- SGE
				if away == 226 then
					choreo = "Choreo\\Germany\\FSV Mainz"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\FSV Mainz"
				end
			--FC Augsburg
			elseif home == 4124 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\FC Augsburg"
				end
			--Hertha BSC
			elseif home == 4125 then
				if stad == 38 then
					-- UNB
					if away == 4140 then
						choreo = "Choreo\\Germany\\Hertha Berlin"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\Germany\\Hertha Berlin"
					end
				end
			--TSG 1899 Hoffenheim
			elseif home == 4126 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Hoffenheim"
				end
			--FC Köln
			elseif home == 4137 then
				-- B04 or BMG or BOC
				if away == 128 or away == 225 or away == 4128 then
					choreo = "Choreo\\Germany\\FC Koln"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\FC Koln"
				end
			--FC Union Berlin
			elseif home == 4140 then
				-- BSC
				if away == 4125 then
					choreo = "Choreo\\Germany\\Union Berlin"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\Union Berlin"
				end
			--RB Leipzig
			elseif home == 5010 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Germany\\RB Leipzig"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--English Teams
	--Premier League and SkyBet Championship
	elseif (tid == 17 or tid == 79) then
		if ctx.match_info ~= 53 then
			--Manchester United
			if home == 100 then
				if stad == 7 then
					-- ARS or CHE or LIV or MCI
					if away == 101 or away == 102 or away == 103 or away == 173 then
						choreo = "Scarf"
					else
						choreo = nil
					end
				end
			--Arsenal FC
			elseif home == 101 then
				if stad == 52 then
					-- MUN or CHE or TOT
					if away == 100 or away == 102 or away == 179 then
						if rdm == 1 then
							choreo = "Choreo\\England\\Arsenal\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Chelsea FC
			elseif home == 102 then
				-- MUN or ARS or LIV or TOT
				if away == 100 or away == 101 or away == 103 or away == 179 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Liverpool FC
			elseif home == 103 then
				if stad == 4 then
					-- MUN or CHE or MCI or EVE
					if away == 100 or away == 102 or away == 173 or away == 177 then
						choreo = "Scarf"
					else
						choreo = nil
					end
				end
			--Leeds United
			elseif home == 104 then
				-- CHE or HUD or BAR or HUL or SHU
				if away == 102 or away == 2610 or away == 1588 or away == 1589 or away == 4194 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Leeds"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--West Ham United
			elseif home == 105 then
				-- CHE or MIL
				if away == 102 or away == 387 then
					if rdm == 1 then
						choreo = "Choreo\\England\\West Ham United\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Newcastle United
			elseif home == 106 then
				-- MID or SUN
				if away == 205 or away == 396 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Newcastle"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Aston Villa FC
			elseif home == 107 then
				-- BIR or WOL or WBA
				if away == 201 or away == 208 or away == 399 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Aston Villa"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Manchester City
			elseif home == 173 then
				-- MUN or LIV
				if away == 100 or away == 103 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Manchester City\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Blackburn Rovers
			elseif home == 176 then
				-- BUR or WIG or BLP or PNE 
				if away == 378 or away == 400 or away == 1761 or away == 4192 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Everton FC
			elseif home == 177 then
				-- LIV
				if away == 103 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Everton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Fulham FC
			elseif home == 178 then
				-- QPR or BRE
				if away == 1327 or away == 4180 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Fulham"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Tottenham Hotspur
			elseif home == 179 then
				-- ARS or CHE or WHU
				if away == 101 or away == 102 or away == 105 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Tottenham\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Birmingham City
			elseif home == 201 then
				-- ASV or WOL or WBA or COV
				if away == 107 or away == 208 or away == 399 or away == 4183 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Birmingham"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Leicester City
			elseif home == 204 then
				-- DER or NFO
				if away == 383 or away == 389 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Leicester City\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Middlesbrough FC
			elseif home == 205 then
				-- NEW or SUN
				if away == 106 or away == 396 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Southampton FC
			elseif home == 207 then
				-- BHA or BOU
				if away == 377 or away == 4071 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Southampton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Wolverhampton Wanderers
			elseif home == 208 then
				-- ASV or BIR or WBA or COV
				if away == 107 or away == 201 or away == 399 or away == 4183 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Wolverhampton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Brighton and Hove
			elseif home == 377 then
				-- SOU or CRY or BOU
				if away == 207 or away == 382 or away == 4071 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Brighton and Hove"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Burnley FC
			elseif home == 378 then
				-- BLB or WIG or BLP or PNE
				if away == 176 or away == 400 or away == 1761 or away == 4192 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Burnley"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Cardiff City
			elseif home == 379 then
				-- BCI or SWA
				if away == 1760 or away == 1909 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Crystal Palace FC
			elseif home == 382 then
				-- SOU or BHA or MIL
				if away == 207 or away == 377 or away == 387 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Crystal Palace"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Derby County
			elseif home == 383 then
				-- LEI or NFO
				if away == 204 or away == 389 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Derby County"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Millwall FC
			elseif home == 387 then
				-- WHU or CRY
				if away == 105 or away == 382 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Millwall"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Nottingham Forest
			elseif home == 389 then
				-- LEI or DER or SHU
				if away == 204 or away == 383 or away == 4194 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Nottingham Forest"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Reading FC
			elseif home == 391 then
				-- WAT or BOU or BRE
				if away == 398 or away == 4071 or away == 4180 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Sunderland
			elseif home == 396 then
				-- NEW or MID
				if away == 106 or away == 205 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Watford FC
			elseif home == 398 then
				-- RDG or LUT
				if away == 391 or away == 4363 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Watford"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--West Bromvich Albion
			elseif home == 399 then
				-- ASV or BIR or WOL
				if away == 107 or away == 201 or away == 208 then
					if rdm == 1 then
						choreo = "Choreo\\England\\West Bromvich Albion"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Wigan Athletic
			elseif home == 400 then
				-- BLB or BUR or BLP
				if away == 176 or away == 378 or away == 1761 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Queens Park Rangers
			elseif home == 1327 then
				-- FUL or BRE
				if away == 178 or away == 4180 then
					if rdm == 1 then
						choreo = "Choreo\\England\\QPR"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Barnsley
			elseif home == 1588 then
				-- LEE or SHW or HUD or ROT or SHU
				if away == 104 or away == 394 or away == 2610 or away == 4193 or away == 4194 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Hull City
			elseif home == 1589 then
				-- LEE
				if away == 104 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Bristol City
			elseif home == 1760 then
				-- CAR
				if away == 379 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Blackpool FC
			elseif home == 1761 then
				-- BLR or BUR or WIG or PNE
				if away == 176 or away == 378 or away == 400 or away == 4192 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Swansea City
			elseif home == 1909 then
				-- CAR
				if away == 379 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Huddersfield Town
			elseif home == 2610 then
				-- LEE or BAR or ROT or SHU
				if away == 104 or away == 1588 or away == 4193 or away == 4194 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Huddersfield"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--AFC Bournemouth
			elseif home == 4071 then
				-- SOU or BHA or RDG
				if away == 207 or away == 377 or away == 391 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Bournemouth"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Brentford FC
			elseif home == 4180 then
				-- FUL or RDG or QPR
				if away == 178 or away == 391 or away == 1327 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Coventry City
			elseif home == 4183 then
				-- BIR or WOL
				if away == 201 or away == 208 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Coventry"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Preston North End
			elseif home == 4192 then
				-- BLR or BUR or BLP
				if away == 176 or away == 378 or away == 1761 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Rotherham
			elseif home == 4193 then
				-- SHW or BAR or HUD or SHU
				if away == 394 or away == 1588 or away == 2610 or away == 4194 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Sheffield United
			elseif home == 4194 then
				-- LEE or NFO or BAR or HUD or ROT
				if away == 104 or away == 389 or away == 1588 or away == 2610 or away == 4193 then
					if rdm == 1 then
						choreo = "Choreo\\England\\Sheffield United"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Luton Town
			elseif home == 4363 then
				-- WAT
				if away == 398 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	--FA Cup or Playoff
	elseif (tid == 23 or tid == 83) then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Arsenal FC
			if home == 101 then
				if stad == 52 then
					-- MUN or CHE or TOT
					if away == 100 or away == 102 or away == 179 then
						choreo = "Choreo\\England\\Arsenal\\League"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\England\\Arsenal\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Leeds United
			elseif home == 104 then
				-- CHE or HUD or BAR or HUL or SHU
				if away == 102 or away == 2610 or away == 1588 or away == 1589 or away == 4194 then
					choreo = "Choreo\\England\\Leeds"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Leeds"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--West Ham United
			elseif home == 105 then
				-- CHE or MIL
				if away == 102 or away == 387 then
					choreo = "Choreo\\England\\West Ham United\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\West Ham United\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Newcastle United
			elseif home == 106 then
				-- MID or SUN
				if away == 205 or away == 396 then
					choreo = "Choreo\\England\\Newcastle"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Newcastle"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Aston Villa FC
			elseif home == 107 then
				-- BIR or WOL or WBA
				if away == 201 or away == 208 or away == 399 then
					choreo = "Choreo\\England\\Aston Villa"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Aston Villa"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Manchester City
			elseif home == 173 then
				-- MUN or LIV
				if away == 100 or away == 103 then
					choreo = "Choreo\\England\\Manchester City\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Manchester City\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Everton FC
			elseif home == 177 then
				-- LIV
				if away == 103 then
					choreo = "Choreo\\England\\Everton"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Everton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Fulham FC
			elseif home == 178 then
				-- QPR or BRE
				if away == 1327 or away == 4180 then
					choreo = "Choreo\\England\\Fulham"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Fulham"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Tottenham Hotspur
			elseif home == 179 then
				-- ARS or CHE or WHU
				if away == 101 or away == 102 or away == 105 then
					choreo = "Choreo\\England\\Tottenham\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Tottenham\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Birmingham City
			elseif home == 201 then
				-- ASV or WOL or WBA or COV
				if away == 107 or away == 208 or away == 399 or away == 4183 then
					choreo = "Choreo\\England\\Birmingham"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Birmingham"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Leicester City
			elseif home == 204 then
				-- DER or NFO
				if away == 383 or away == 389 then
					choreo = "Choreo\\England\\Leicester City\\Cup"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Leicester City\\Cup"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Southampton FC
			elseif home == 207 then
				-- BHA or BOU
				if away == 377 or away == 4071 then
					choreo = "Choreo\\England\\Southampton"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Southampton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Wolverhampton Wanderers
			elseif home == 208 then
				-- ASV or BIR or WBA or COV
				if away == 107 or away == 201 or away == 399 or away == 4183 then
					choreo = "Choreo\\England\\Wolverhampton"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Wolverhampton"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Brighton and Hove
			elseif home == 377 then
				-- SOU or CRY or BOU
				if away == 207 or away == 382 or away == 4071 then
					choreo = "Choreo\\England\\Brighton and Hove"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Brighton and Hove"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Burnley FC
			elseif home == 378 then
				-- BLB or WIG or BLP or PNE
				if away == 176 or away == 400 or away == 1761 or away == 4192 then
					choreo = "Choreo\\England\\Burnley"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Burnley"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Crystal Palace FC
			elseif home == 382 then
				-- SOU or BHA or MIL
				if away == 207 or away == 377 or away == 387 then
					choreo = "Choreo\\England\\Crystal Palace"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Crystal Palace"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Derby County
			elseif home == 383 then
				-- LEI or NFO
				if away == 204 or away == 389 then
					choreo = "Choreo\\England\\Derby County"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Derby County"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Millwall FC
			elseif home == 387 then
				-- WHU or CRY
				if away == 105 or away == 382 then
					choreo = "Choreo\\England\\Millwall"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Millwall"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Norwich City
			elseif home == 388 then
				if (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					elseif rdm == 1 then
						choreo = "Choreo\\England\\Norwich"
					end
				end
			--Nottingham Forest
			elseif home == 389 then
				-- LEI or DER or SHU
				if away == 204 or away == 383 or away == 4194 then
					choreo = "Choreo\\England\\Nottingham Forest"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Nottingham Forest"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Watford FC
			elseif home == 398 then
				-- RDG or LUT
				if away == 391 or away == 4363 then
					choreo = "Choreo\\England\\Watford"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Watford"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--West Bromvich Albion
			elseif home == 399 then
				-- ASV or BIR or WOL
				if away == 107 or away == 201 or away == 208 then
					choreo = "Choreo\\England\\West Bromvich Albion"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\West Bromvich Albion"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Queens Park Rangers
			elseif home == 1327 then
				-- FUL or BRE
				if away == 178 or away == 4180 then
					choreo = "Choreo\\England\\QPR"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\QPR"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Huddersfield Town
			elseif home == 2610 then
				-- LEE or BAR or ROT or SHU
				if away == 104 or away == 1588 or away == 4193 or away == 4194 then
					choreo = "Choreo\\England\\Huddersfield"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Huddersfield"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--AFC Bournemouth
			elseif home == 4071 then
				-- SOU or BHA or RDG
				if away == 207 or away == 377 or away == 391 then
					choreo = "Choreo\\England\\Bournemouth"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Bournemouth"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Coventry City
			elseif home == 4183 then
				-- BIR or WOL
				if away == 201 or away == 208 then
					choreo = "Choreo\\England\\Coventry"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Coventry"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Sheffield United
			elseif home == 4194 then
				-- LEE or NFO or BAR or HUD or ROT
				if away == 104 or away == 389 or away == 1588 or away == 2610 or away == 4193 then
					choreo = "Choreo\\England\\Sheffield United"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\England\\Coventry"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Italian Teams
	--Serie A and Serie B
	elseif (tid == 18 or tid == 82 or tid == 85) then
		if ctx.match_info ~= 53 then
			--Internazionale
			if home == 119 then
				if stad == 1 then
					-- JUV or ROM or NAP
					if away == 120 or away == 125 or away == 327 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Inter\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					-- MIL
					elseif away == 121 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Inter\\AC Milan\\1"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Italy\\Inter\\AC Milan\\2"
						end
					else
						choreo = nil
					end
				end
			--Juventus FC
			elseif home == 120 then
				if stad == 22 then
					-- INT or MIL or FIO or ROM or GEN or NAP or TOR
					if away == 119 or away == 121 or away == 124 or away == 125 or away == 323 or away == 327 or away == 333 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Juventus"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--AC Milan
			elseif home == 121 then
				if stad == 30 then
					-- JUV or ROM or GEN or NAP
					if away == 120 or away == 125 or away == 323 or away == 327 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\AC Milan\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					-- INT
					elseif away == 119 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\AC Milan\\Inter\\1"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Italy\\AC Milan\\Inter\\2"
						end
					else
						choreo = nil
					end
				end
			--SS Lazio
			elseif home == 122 then
				if stad == 6 then
					-- FIO or NAP
					if away == 124 or away == 327 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Lazio\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					-- ROM
					elseif away == 125 then
						choreo = "Choreo\\Italy\\Lazio\\Roma"
					else
						choreo = nil
					end
				end
			--Parma Calcio
			elseif home == 123 then
				-- BOL or REG
				if away == 186 or away == 4225 then
					choreo = "Choreo\\Italy\\Parma"
				else
					choreo = nil
				end
			--ACF Fiorentina
			elseif home == 124 then
				-- JUV or LAZ or ROM or BOL or EMP or NAP or PIS
				if away == 120 or away == 122 or away == 125 or away == 186 or away == 235 or away == 327 or away == 4241 then
					choreo = "Choreo\\Italy\\Fiorentina"
				else
					choreo = nil
				end
			--AS Roma
			elseif home == 125 then
				if stad == 6 then
					-- INT or JUV or MIL or FIO or NAP
					if away == 119 or away == 120 or away == 121 or away == 124 or away == 327 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Roma\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					-- LAZ
					elseif away == 122 then
						choreo = "Choreo\\Italy\\Roma\\Lazio"
					else
						choreo = nil
					end
				end
			--Bologna FC
			elseif home == 186 then
				-- PAR or FIO or SPA
				if away == 123 or away == 124 or away == 240 or away == 4923 then
					choreo = "Choreo\\Italy\\Bologna"
				else
					choreo = nil
				end
			--Brescia Calcio
			elseif home == 187 then
				-- ATA or EMP or HEL or VIC
				if away == 234 or away == 235 or away == 336 or away == 337 then
					choreo = "Choreo\\Italy\\Brescia"
				else
					choreo = nil
				end
			--Udinese Calcio
			elseif home == 190 then
				-- VEN
				if away == 4229 then
					choreo = "Choreo\\Italy\\Udinese"
				else
					choreo = nil
				end
			--Atalanta BC
			elseif home == 234 then
				-- BRE or NAP or HEL
				if away == 187 or away == 327 or away == 336 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Atalanta"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Empoli
			elseif home == 235 then
				-- FIO or BRE
				if away == 124 or away == 187 then
					choreo = "Choreo\\Italy\\Empoli"
				else
					choreo = nil
				end
			--Reggina 1914
			elseif home == 239 then
				-- CRO
				if away == 1363 then
					choreo = "Choreo\\Italy\\Reggina\\League"
				else
					choreo = nil
				end
			--UC Sampdoria
			elseif home == 240 then
				-- GEN
				if away == 323 then
					choreo = "Choreo\\Italy\\Sampdoria\\Genoa"
				-- BOL or NAP or TOR or PIS
				elseif away == 186 or away == 327 or away == 333 or away == 4241 then
					choreo = "Choreo\\Italy\\Sampdoria\\League"
				else
					choreo = nil
				end
			--Ascoli Calcio
			elseif home == 317 then
				-- PES
				if away == 328 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Ascoli"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Cagliari Calcio
			elseif home == 320 then
				-- NAP
				if away == 327 then
					choreo = "Choreo\\Italy\\Cagliari"
				else
					choreo = nil
				end
			--Genoa CFC
			elseif home == 323 then
				-- SAM
				if away == 240 then
					choreo = "Choreo\\Italy\\Genoa\\Sampdoria"
				-- JUV or MIL or HEL or SPE
				elseif away == 120 or away == 121 or away == 336 or away == 1600 then
					choreo = "Choreo\\Italy\\Genoa\\League"
				else
					choreo = nil
				end
			--SSC Napoli
			elseif home == 327 then
				-- INT or JUV or MIL or LAZ or FIO or ROM or ATA or SAM or CAG or HEL 
				if away == 119 or away == 120 or away == 121 or away == 122 or away == 124 or away == 125 or away == 234 or away == 240 or away == 320 or away == 336 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Napoli\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Torino FC
			elseif home == 333 then
				-- JUV or SAM
				if away == 120 or away == 240 then
					choreo = "Choreo\\Italy\\Torino"
				else
					choreo = nil
				end
			--Hellas Verona
			elseif home == 336 then
				-- BRE or CHI or ATA or GEN or NAP
				if away == 187 or away == 188 or away == 234 or away == 323 or away == 327 then
					choreo = "Choreo\\Italy\\Hellas Verona"
				else
					choreo = nil
				end
			--Spezia Calcio
			elseif home == 1600 then
				-- GEN or REG
				if away == 323 or away == 4225 then
					choreo = "Choreo\\Italy\\Spezia"
				else
					choreo = nil
				end
			--Como 1907
			elseif home == 4219 then
				-- MON
				if away == 4914 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--US Sassuolo
			elseif home == 1919 then
				-- REG
				if away == 4225 then
					choreo = "Choreo\\Italy\\Sassuolo"
				else
					choreo = nil
				end
			--Reggiana 1919
			elseif home == 4225 then
				-- PAR or SAS or SPE or SPA
				if away == 123 or away == 1919 or away == 1600 or away == 4923 then
					choreo = "Choreo\\Italy\\Reggiana"
				else
					choreo = nil
				end
			--Venezia FC
			elseif home == 4229 then
				-- UDI or VIN
				if away == 190 or away == 337 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Benevento Calcio
			elseif home == 4232 then
				-- CRO
				if away == 1363 then
					choreo = "Choreo\\Italy\\Benevento"
				else
					choreo = nil
				end
			--Frosinone Calcio
			elseif home == 4234 then
				-- PER
				if away == 4240 then
					choreo = "Choreo\\Italy\\Frosinone"
				else
					choreo = nil
				end
			--AC Perugia Calcio
			elseif home == 4240 then
				-- FRO
				if away == 4234 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Pisa Sporting Club
			elseif home == 4241 then
				-- FIO or SAM
				if away == 124 or away == 240 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--AC Monza
			elseif home == 4914 then
				-- COM
				if away == 4219 then
					choreo = "Choreo\\Italy\\Monza"
				else
					choreo = nil
				end
			--SPAL
			elseif home == 4923 then
				-- BOL or REG
				if away == 186 or away == 4225 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	--Coppa Italia
	elseif tid == 24 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Internazionale
			if home == 119 then
				if stad == 1 then
					-- JUV or ROM or NAP
					if away == 120 or away == 125 or away == 327 then
						choreo = "Choreo\\Italy\\Inter\\Cup"
					-- MIL
					elseif away == 121 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Inter\\AC Milan\\1"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Italy\\Inter\\AC Milan\\2"
						end
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Inter\\Cup"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Juventus FC
			elseif home == 120 then
				if stad == 22 then
					-- INT or MIL or FIO or ROM or GEN or NAP or TOR
					if away == 119 or away == 121 or away == 124 or away == 125 or away == 323 or away == 327 or away == 333 then
						choreo = "Choreo\\Italy\\Juventus"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Juventus"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end	
				end
			--AC Milan
			elseif home == 121 then
				if stad == 30 then
					-- JUV or ROM or GEN or NAP
					if away == 120 or away == 125 or away == 323 or away == 327 then
						choreo = "Choreo\\Italy\\AC Milan\\Cup"
					-- INT
					elseif away == 119 then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\AC Milan\\Inter\\1"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Choreo\\Italy\\AC Milan\\Inter\\2"
						end
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\AC Milan\\Cup"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--SS Lazio
			elseif home == 122 then
				if stad == 6 then
					-- FIO or NAP
					if away == 124 or away == 327 then
						choreo = "Choreo\\Italy\\Lazio\\League"
					-- ROM
					elseif away == 125 then
						choreo = "Choreo\\Italy\\Lazio\\Roma"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Lazio\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--ACF Fiorentina
			elseif home == 124 then
				-- JUV or LAZ or ROM or BOL or EMP or NAP or PIS
				if away == 120 or away == 122 or away == 125 or away == 186 or away == 235 or away == 327 or away == 4241 then
					choreo = "Choreo\\Italy\\Fiorentina"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Fiorentina"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Parma Calcio
			elseif home == 123 then
				-- BOL or REG
				if away == 186 or away == 4225 then
					choreo = "Choreo\\Italy\\Parma"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Parma"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--AS Roma
			elseif home == 125 then
				if stad == 6 then
					-- INT or JUV or MIL or FIO or NAP
					if away == 119 or away == 120 or away == 121 or away == 124 or away == 327 then
						choreo = "Choreo\\Italy\\Roma\\League"
					-- LAZ
					elseif away == 122 then
						choreo = "Choreo\\Italy\\Roma\\Lazio"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Italy\\Roma\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Bologna FC
			elseif home == 186 then
				-- PAR or FIO or SPA
				if away == 123 or away == 124 or away == 240 or away == 4923 then
					choreo = "Choreo\\Italy\\Bologna"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Bologna"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Brescia Calcio
			elseif home == 187 then
				-- ATA or EMP or HEL or VIC
				if away == 234 or away == 235 or away == 336 or away == 337 then
					choreo = "Choreo\\Italy\\Brescia"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Brescia"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Udinese Calcio
			elseif home == 190 then
				-- VEN
				if away == 4229 then
					choreo = "Choreo\\Italy\\Udinese"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Udinese"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Atalanta BC
			elseif home == 234 then
				-- BRE or NAP or HEL
				if away == 187 or away == 327 or away == 336 then
					choreo = "Choreo\\Italy\\Atalanta"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Atalanta"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Empoli
			elseif home == 235 then
				-- FIO or BRE
				if away == 124 or away == 187 then
					choreo = "Choreo\\Italy\\Empoli"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Empoli"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Reggina 1914
			elseif home == 239 then
				-- CRO
				if away == 1363 then
					choreo = "Choreo\\Italy\\Reggina\\Cup"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Reggina\\Cup"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--UC Sampdoria
			elseif home == 240 then
				-- GEN
				if away == 323 then
					choreo = "Choreo\\Italy\\Sampdoria\\Genoa"
				-- BOL or NAP or TOR or PIS
				elseif away == 186 or away == 327 or away == 333 or away == 4241 then
					choreo = "Choreo\\Italy\\Sampdoria\\League"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Sampdoria\\League"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Ascoli Calcio
			elseif home == 317 then
				-- PES
				if away == 328 then
					choreo = "Choreo\\Italy\\Ascoli"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Ascoli"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Cagliari Calcio
			elseif home == 320 then
				-- NAP
				if away == 327 then
					choreo = "Choreo\\Italy\\Cagliari"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Cagliari"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Genoa CFC
			elseif home == 323 then
				-- SAM
				if away == 240 then
					choreo = "Choreo\\Italy\\Genoa\\Sampdoria"
				-- JUV or MIL or HEL or SPE
				elseif away == 120 or away == 121 or away == 336 or away == 1600 then
					choreo = "Choreo\\Italy\\Genoa\\League"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Genoa\\League"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--SSC Napoli
			elseif home == 327 then
				-- INT or JUV or MIL or LAZ or FIO or ROM or ATA or SAM or CAG or HEL 
				if away == 119 or away == 120 or away == 121 or away == 122 or away == 124 or away == 125 or away == 234 or away == 240 or away == 320 or away == 336 then
					choreo = "Choreo\\Italy\\Napoli\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Napoli\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Torino FC
			elseif home == 333 then
				-- JUV or SAM
				if away == 120 or away == 240 then
					choreo = "Choreo\\Italy\\Torino"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Torino"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Hellas Verona
			elseif home == 336 then
				-- BRE or CHI or ATA or GEN or NAP
				if away == 187 or away == 188 or away == 234 or away == 323 or away == 327 then
					choreo = "Choreo\\Italy\\Hellas Verona"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Hellas Verona"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Crotone
			elseif home == 1363 then
				if rdm == 1 then
					choreo = "Choreo\\Italy\\Crotone"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Spezia Calcio
			elseif home == 1600 then
				-- GEN or REG
				if away == 323 or away == 4225 then
					choreo = "Choreo\\Italy\\Spezia"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Spezia"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--US Sassuolo
			elseif home == 1919 then
				-- REG
				if away == 4225 then
					choreo = "Choreo\\Italy\\Sassuolo"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Sassuolo"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--AS Cittadella
			elseif home == 1920 then
				if rdm == 1 then
					choreo = "Choreo\\Italy\\Cittadella"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Reggiana 1919
			elseif home == 4225 then
				-- PAR or SAS or SPE or SPA
				if away == 123 or away == 1919 or away == 1600 or away == 4923 then
					choreo = "Choreo\\Italy\\Reggiana"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Reggiana"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Benevento Calcio
			elseif home == 4232 then
				-- CRO
				if away == 1363 then
					choreo = "Choreo\\Italy\\Benevento"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Benevento"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Frosinone Calcio
			elseif home == 4234 then
				-- PER
				if away == 4240 then
					choreo = "Choreo\\Italy\\Frosinone"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Frosinone"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--US Lecce
			elseif home == 4237 then
				if rdm == 1 then
					choreo = "Choreo\\Italy\\Lecce"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--US Salernitana
			elseif home == 4244 then
				if rdm == 1 then
					choreo = "Choreo\\Italy\\Salernitana"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--AC Monza
			elseif home == 4914 then
				-- COM
				if away == 4219 then
					choreo = "Choreo\\Italy\\Monza"
				elseif rdm == 1 then
					choreo = "Choreo\\Italy\\Monza"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Eredivisie
	elseif tid == 21 then
		if ctx.match_info ~= 53 then
			--Ajax Amsterdam
			if home == 116 then
				if stad == 70 then
					-- FEY or PSV or ALK or ADH or UTR
					if away == 117 or away == 118 or away == 242 or away == 243 or away == 251 then
						if rdm == 1 then
							choreo = "Choreo\\Netherlands\\Ajax"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Feyenoord Rotterdam
			elseif home == 117 then
				if stad == 71 then
					-- AJA or PSV or UTR or EXC or ROT
					if away == 116 or away == 118 or away == 251 or away == 344 or away == 351 then
						choreo = "Scarf"
					else
						choreo = nil
					end
				end
			--PSV Eindhoven
			elseif home == 118 then 
				-- AJA or FEY
				if away == 116 or away == 117 then
					if rdm == 1 then
						choreo = "Choreo\\Netherlands\\PSV"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--AZ Alkmaar
			elseif home == 242 then
				-- AJA
				if away == 116 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--ADO Den Haag
			elseif home == 243 then
				-- AJA or UTR or ROT
				if away == 116 or away == 251 or away == 351 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Groningen
			elseif home == 244 then 
				-- HEE or ZWO or EMM
				if away == 245 or away == 256 or away == 342 then
					if rdm == 1 then
						choreo = "Choreo\\Netherlands\\Groningen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--SC Heerenveen
			elseif home == 245 then
				-- GRO or ZWO or SCC
				if away == 244 or away == 256 or away == 338 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--NEC Nijmegen
			elseif home == 247 then
				-- VIT
				if away == 252 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Twente
			elseif home == 250 then
				-- HER
				if away == 349 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Utrecht
			elseif home == 251 then
				-- AJA or FEY or ADH
				if away == 116 or away == 117 or away == 243 then
					if rdm == 1 then
						choreo = "Choreo\\Netherlands\\Utrecht"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Vitesse Arnhem
			elseif home == 252 then
				-- NIJ or GAE
				if away == 247 or away == 346 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--RKC Waalwijk
			elseif home == 254 then
				-- WIL
				if away == 255 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--PEC Zwolle
			elseif home == 256 then
				-- GRO or HEE or GAE
				if away == 244 or away == 245 or away == 346 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--SC Cambuur-Leeuwarden
			elseif home == 338 then
				-- GRO
				if away == 244 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Emmen
			elseif home == 342 then
				-- GRO
				if away == 244 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Excelsior Rotterdam
			elseif home == 344 then
				-- FEY or ROT
				if away == 117 or away == 351 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Go Ahead Eagles
			elseif home == 346 then
				-- TWE or VIT or ZWO or HER
				if away == 250 or away == 252 or away == 256 or away == 349 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Heracles Almelo
			elseif home == 349 then
				-- TWE or GAE
				if away == 250 or away == 346 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Sparta Rotterdam
			elseif home == 351 then
				-- FEY or ADH or EXC
				if away == 117 or away == 243 or away == 344 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	
	--Netherlands Cup
	elseif tid == 27 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Ajax Amsterdam
			if home == 116 then
				if stad == 70 then
					-- FEY or PSV or ALK or ADH or UTR
					if away == 117 or away == 118 or away == 242 or away == 243 or away == 251 then
						choreo = "Choreo\\Netherlands\\Ajax"
					elseif rdm == 1 then
						choreo = "Choreo\\Netherlands\\Ajax"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--PSV Eindhoven
			elseif home == 118 then 
				-- AJA or FEY
				if away == 116 or away == 117 then
					choreo = "Choreo\\Netherlands\\PSV"
				elseif rdm == 1 then
					choreo = "Choreo\\Netherlands\\PSV"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Groningen
			elseif home == 244 then 
				-- HEE or ZWO or EMM
				if away == 245 or away == 256 or away == 342 then
					choreo = "Choreo\\Netherlands\\Groningen"
				elseif rdm == 1 then
					choreo = "Choreo\\Netherlands\\Groningen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Utrecht
			elseif home == 251 then
				-- AJA or FEY or ADH
				if away == 116 or away == 117 or away == 243 then
					choreo = "Choreo\\Netherlands\\Utrecht"
				elseif rdm == 1 then
					choreo = "Choreo\\Netherlands\\Utrecht"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Willem II
			elseif home == 255 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\Netherlands\\Willem"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--French Teams
	--Ligue 1 and Ligue 2
	elseif (tid == 20 or tid == 81) then
		if ctx.match_info ~= 53 then
			--AS Monaco
			if home == 112 then
				if stad == 41 then
					-- OM or NIC
					if away == 113 or away == 217 then
						if rdm == 1 then
							choreo = "Choreo\\France\\Monaco"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Olympique Marseille
			elseif home == 113 then
				-- MON or PSG
				if away == 112 or away == 114 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Olympique Marseille"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Paris Saint-Germain
			elseif home == 114 then
				-- OM or LYO
				if away == 113 or away == 181 then
					if rdm == 1 then
						choreo = "Choreo\\France\\PSG\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Girondins de Bordeaux
			elseif home == 115 then
				-- NAN or TOU
				if away == 216 or away == 221 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--AJ Auxerre
			elseif home == 180 then
				-- TRO or DIJ
				if away == 420 or away == 1328 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Olympique Lyonnais
			elseif home == 181 then
				-- PSG or SAE
				if away == 114 or away == 418 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Olympique Lyonnais"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--RC Lens
			elseif home == 182 then
				-- LIL
				if away == 213 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Lens"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--AC Ajaccio
			elseif home == 209 then
				-- BAS
				if away == 210 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--SC Bastia
			elseif home == 210 then
				-- AJA or NIC
				if away == 209 or away == 217 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--EA Guingamp
			elseif home == 211 then
				-- REN or BRE
				if away == 218 or away == 1329 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--LOSC Lille
			elseif home == 213 then
				-- LEN or VAL
				if away == 182 or away == 1528 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Montpellier HSC
			elseif home == 215 then
				-- NIM
				if away == 1910 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Montpellier"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Nantes
			elseif home == 216 then
				-- BOR or REN
				if away == 115 or away == 218 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Nantes"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--OGC Nice
			elseif home == 217 then
				-- MON or BAS
				if away == 112 or away == 210 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Stade Rennais FC
			elseif home == 218 then
				-- GUI or NAN or BRE
				if away == 211 or away == 216 or away == 1329 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Toulouse
			elseif home == 221 then
				-- BOR
				if away == 115 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--SCO Angers
			elseif home == 403 then
				-- LAV
				if away == 412 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Stade Malherbe Caen
			elseif home == 405 then
				-- HAV
				if away == 413 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Clermont Foot
			elseif home == 407 then
				-- GRE
				if away == 4370 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Clermont Foot"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Stade Lavallois
			elseif home == 412 then
				-- ANG
				if away == 403 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--AC Le Havre
			elseif home == 413 then
				-- SMC or QRM
				if away == 405 or away == 5100 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Lorient
			elseif home == 414 then
				-- REN
				if away == 218 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Lorient"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--AS Saint-Étienne
			elseif home == 418 then
				-- LYO
				if away == 181 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Saint-Étienne"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--ES Troyes AC
			elseif home == 420 then
				-- AUX or REI
				if away == 180 or away == 1330 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Dijon FCO
			elseif home == 1328 then
				-- AUX
				if away == 180 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Stade Brestois
			elseif home == 1329 then
				-- GUI or REN
				if away == 211 or away == 218 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Stade de Reims
			elseif home == 1330 then
				-- TRO
				if away == 420 then
					choreo = "Choreo\\France\\Stade Reims"
				else
					choreo = nil
				end
			--Valenciennes FC
			elseif home == 1528 then
				-- LIL
				if away == 213 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Nîmes Olympique
			elseif home == 1910 then
				-- MNT
				if away == 215 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Nimes"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Metz
			elseif home == 4123 then
				-- ASN or STR
				if away == 415 or away == 4213 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Metz"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--RC Strasbourg Alsace
			elseif home == 4213 then
				-- MET
				if away == 4123 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Grenoble Foot 38
			elseif home == 4370 then
				-- CLE
				if away == 407 then
					if rdm == 1 then
						choreo = "Choreo\\France\\Grenoble Foot"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Quevilly
			elseif home == 5100 then
				-- HAV
				if away == 413 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	
	--Coupe de la Ligue BKT
	elseif tid == 26 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--AS Monaco
			if home == 112 then
				if stad == 41 then
					-- OM or NIC
					if away == 113 or away == 217 then
						choreo = "Choreo\\France\\Monaco"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\France\\Monaco"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Olympique Marseille
			elseif home == 113 then
				-- MON or PSG
				if away == 112 or away == 114 then
					choreo = "Choreo\\France\\Olympique Marseille"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\France\\Olympique Marseille"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Paris Saint-Germain
			elseif home == 114 then
				-- OM or LYO
				if away == 113 or away == 181 then
					choreo = "Choreo\\France\\PSG\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\France\\PSG\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Olympique Lyonnais
			elseif home == 181 then
				-- PSG or SAE
				if away == 114 or away == 418 then
					choreo = "Choreo\\France\\Olympique Lyonnais"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\France\\Olympique Lyonnais"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--RC Lens
			elseif home == 182 then
				-- LIL
				if away == 213 then
					choreo = "Choreo\\France\\Lens"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Lens"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Montpellier HSC
			elseif home == 215 then
				-- NIM
				if away == 1910 then
					choreo = "Choreo\\France\\Montpellier"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Montpellier"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Nantes
			elseif home == 216 then
				-- BOR or REN
				if away == 115 or away == 218 then
					choreo = "Choreo\\France\\Nantes"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Nantes"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Clermont Foot
			elseif home == 407 then
				-- GRE
				if away == 4370 then
					choreo = "Choreo\\France\\Clermont Foot"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Clermont Foot"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Lorient
			elseif home == 414 then
				-- REN
				if away == 218 then
					choreo = "Choreo\\France\\Lorient"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Lorient"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--AS Saint-Étienne
			elseif home == 418 then
				-- LYO
				if away == 181 then
					choreo = "Choreo\\France\\Saint-Étienne"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Saint-Étienne"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Stade de Reims
			elseif home == 1330 then
				-- TRO
				if away == 420 then
					choreo = "Choreo\\France\\Stade Reims"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Stade Reims"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Nîmes Olympique
			elseif home == 1910 then
				-- MNT
				if away == 215 then
					choreo = "Choreo\\France\\Nimes"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Nimes"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--FC Metz
			elseif home == 4123 then
				-- ASN or STR
				if away == 415 or away == 4213 then
					choreo = "Choreo\\France\\Metz"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Metz"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Amiens FC
			elseif home == 4200 then
				if (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Amiens"
				end
			--Grenoble Foot 38
			elseif home == 4370 then
				-- CLE
				if away == 407 then
					choreo = "Choreo\\France\\Grenoble Foot"
				elseif rdm == 1 then
					choreo = "Choreo\\France\\Grenoble Foot"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	
	--Danish Teams
	--3F Superliga
	elseif tid == 141 then
		if ctx.match_info ~= 53 then
			--FC København
			if home == 1207 then
				-- BNY or FCN or AAL or FCM or RAN or AAR
				if away == 1832 or away == 1208 or away == 1818 or away == 2069 or away == 2071 or away == 2067 then
					if rdm == 1 then
						choreo = "Choreo\\Denmark\\Copenhagen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Nordsjælland
			elseif home == 1208 then
				-- AAL or FCK or LYN
				if away == 1818 or away == 1207 or away == 5224 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Aalborg BK
			elseif home == 1818 then
				-- AAR or BRO or FCK or FCN or MID
				if away == 2067 or away == 1832 or away == 1207 or away == 1208 or away == 2069 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Brøndby IF
			elseif home == 1832 then
				-- FCK or AAR or OB or AAL or FCM
				if away == 1207 or away == 2067 or away == 2070 or away == 1818 or away == 2069 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--AC Horsens
			elseif home == 2066 then
				-- VEJ or AAR or SON
				if away == 5235 or away == 2067 or away == 5226 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Aarhus GF
			elseif home == 2067 then
				-- AAL or BRO or FCK or RAN or MID or HOR
				if away == 1818 or away == 1832 or away == 1207 or away == 2071 or away == 2069 or away == 2066 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FC Midtjylland
			elseif home == 2069 then
				-- AAL or BRO or FCK or AAR or SIF
				if away == 1818 or away == 1832 or away == 1207 or away == 2067 or away == 5225 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Odense Boldklub
			elseif home == 2070 then
				-- BRO or SON 
				if away == 1832 or away == 5226 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Randers FC
			elseif home == 2071 then
				-- FCK or AAR
				if away == 1207 or away == 2067 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Lyngby BK
			elseif home == 5224	then
				-- FCN
				if away == 1208 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Silkeborg IF
			elseif home == 5225	then
				-- MID or VFF
				if away == 2069 or 5237 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Sønderjyske
			elseif home == 5226 then
				-- HOR or OB 
				if away == 2066 or away == 2070 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Vejle
			elseif home == 5235	then
				-- ACH
				if away == 2066 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Viborg FF
			elseif home == 5237	then
				-- AAL or AAR or MID or LYN or SIF
				if away == 1818 or away == 2067 or away == 2069 or away == 5224 or away == 5225 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	
	--Danish Cup
	elseif tid == 142 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--FC København
			if home == 1207 then
				-- BNY or FCN or AAL or FCM or RAN or AAR
				if away == 1832 or away == 1208 or away == 1818 or away == 2069 or away == 2071 or away == 2067 then
					choreo = "Choreo\\Denmark\\Copenhagen"
				elseif rdm == 1 then
					choreo = "Choreo\\Denmark\\Copenhagen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Portuguese Teams
	--Liga NOS
	elseif tid == 22 then
		if ctx.match_info ~= 53 then
			--SL Benfica
			if home == 191 then
				-- POR
				if away == 192 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Benfica\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Porto
			elseif home == 192 then
				-- SLB or SCP or BOA
				if away == 191 or away == 193 or away == 4323 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Porto"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Sporting CP
			elseif home == 193 then
				-- POR 
				if away == 192 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Vitória Guimarães
			elseif home == 1804 then
				-- BRA or BOA
				if away == 1974 or away == 4323 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Guimarães"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Sporting Braga
			elseif home == 1974 then
				-- GUI or BOA
				if away == 1804 or away == 4323 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Braga"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Gil Vicente FC
			elseif home == 2387 then
				-- MOR 
				if away == 2388 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Moreirense
			elseif home == 1804 then
				-- GIL or VIZ
				if away == 2387 or away == 5115 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Moreirense"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Boavista FC
			elseif home == 4323 then
				-- POR or GUI or BRA
				if away == 192 or away == 1804 or away == 1974 then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Boavista"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FC Vizela
			elseif home == 5115 then
				-- MOR 
				if away == 2388 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	
	--Portugal Cup
	elseif tid == 28 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--SL Benfica
			if home == 191 then
				-- POR
				if away == 192 then
					choreo = "Choreo\\Portugal\\Benfica\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Benfica\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--FC Porto
			elseif home == 192 then
				-- SLB or SCP or BOA
				if away == 191 or away == 193 or away == 4323 then
					choreo = "Choreo\\Portugal\\Porto"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Portugal\\Porto"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Vitória Guimarães
			elseif home == 1804 then
				-- BRA or BOA
				if away == 1974 or away == 4323 then
					choreo = "Choreo\\Portugal\\Guimarães"
				elseif rdm == 1 then
					choreo = "Choreo\\Portugal\\Guimarães"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Sporting Braga
			elseif home == 1974 then
				-- GUI or BOA
				if away == 1804 or away == 4323 then
					choreo = "Choreo\\Portugal\\Braga"
				elseif rdm == 1 then
					choreo = "Choreo\\Portugal\\Braga"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Moreirense
			elseif home == 1804 then
				-- GIL or VIZ
				if away == 2387 or away == 5115 then
					choreo = "Choreo\\Portugal\\Moreirense"
				elseif rdm == 1 then
					choreo = "Choreo\\Portugal\\Moreirense"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Boavista FC
			elseif home == 4323 then
				-- POR or GUI or BRA
				if away == 192 or away == 1804 or away == 1974 then
					choreo = "Choreo\\Portugal\\Boavista"
				elseif rdm == 1 then
					choreo = "Choreo\\Portugal\\Boavista"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Russian Teams
	--Russian Premier League
	elseif tid == 116 then
		if ctx.match_info ~= 53 then
			--Spartak Moskva
			if home == 135 then
				-- LMO or CSK or ZSP or DIN
				if away == 271 or away == 1217 or away == 1218 or away == 1753 then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Spartak Moskva"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Lokomotiv Moskva
			elseif home == 271 then
				-- SPM or ZSP or CSK or DMO or TOR
				if away == 135 or away == 1218 or away == 1217 or away == 1753 or away == 2021 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--CSKA Moskva
			elseif home == 1217 then
				-- SPM or LMO or ZSP or DMO or KRA
				if away == 135 or away == 271 or away == 1218 or away == 1753 or away == 2618 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Zenit St. Petersburg
			elseif home == 1218 then
				-- SPM or LMO or CSK or DMO or TOR
				if away == 135 or away == 271 or away == 1217 or away == 1753 or away == 2021 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Dinamo Moskva
			elseif home == 1753 then
				-- SPM or LMO or CSK or ZSP or TOR
				if away == 135 or away == 271 or away == 1217 or away == 1218 or away == 2021 then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Dinamo Moskva\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Rubin Kazan
			elseif home == 1941 then
				-- KSS
				if away == 4143 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Torpedo Moscow
			elseif home == 2021 then
				-- LMO or ZSP or DMO
				if away == 271 or away == 1218 or away == 1753 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--FK Krasnodar
			elseif home == 2618 then
				-- CSK
				if away == 1217 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Krylya Sovetov Samara
			elseif home == 4143 then
				-- RKA or AKH
				if away == 1941 or away == 5196 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Akhmat Grozny
			elseif home == 5196 then
				-- KSS
				if away == 4143 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Arsenal Tula
			elseif home == 5197 then
				-- FCU
				if away == 5201 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Ural Yekaterinburg
			elseif home == 5201 then
				-- ARS or KHI
				if away == 5197 or away == 5298 then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Ural"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--FK Khimki
			elseif home == 5298 then
				-- FCU
				if away == 5201 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	--Russian Cup
	elseif tid == 123 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Spartak Moskva
			if home == 135 then
				-- LMO or CSK or ZSP or DIN
				if away == 271 or away == 1217 or away == 1218 or away == 1753 then
					choreo = "Choreo\\Russia\\Spartak Moskva"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Spartak Moskva"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Dinamo Moskva
			elseif home == 1753 then
				-- SPM or LMO or CSK or ZSP 
				if away == 135 or away == 271 or away == 1217 or away == 1218 then
					choreo = "Choreo\\Russia\\Dinamo Moskva\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Dinamo Moskva\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Ural
			elseif home == 5201 then
				-- ARS or KHI
				if away == 5197 or away == 5298 then
					choreo = "Choreo\\Russia\\Ural"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Russia\\Ural"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Scottish Teams
	--SPFL
	elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
		if ctx.match_info ~= 53 then
			--Celtic FC
			if home == 131 then
				if stad == 64 then
					-- RAN or HIB or HEA
					if away == 132 or away == 1221 or away == 1222 then
						if rdm == 1 then
							choreo = "Choreo\\Scotland\\Celtic"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Rangers FC
			elseif home == 132 then
				if stad == 65 then
					-- CEL or ABE or HEA or HIB
					if away == 131 or away == 1219 or away == 1221 or away == 1222 then
						if rdm == 1 then
							choreo = "Choreo\\Scotland\\Rangers"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Aberdeen
			elseif home == 1219 then
				-- RAN or DUD or HEA or INV or MOT
				if away == 132 or away == 1220 or away == 1221 or away == 1984 or away == 1986 then
					if rdm == 1 then
						choreo = "Choreo\\Scotland\\Aberdeen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Dundee United
			elseif home == 1220 then
				-- ABE or DFC
				if away == 1219 or away == 2621 then
					if rdm == 1 then
						choreo = "Choreo\\Scotland\\Dundee United"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Heart of Midlothian
			elseif home == 1221 then
				-- CEL or RAN or ABE or HIB
				if away == 131 or away == 132 or away == 1219 or away == 1222 then
					if rdm == 1 then
						choreo = "Choreo\\Scotland\\Hearts"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Hibernian FC
			elseif home == 1222 then
				-- CEL or RAN or HEA
				if away == 131 or away == 132 or away == 1221 then
					if rdm == 1 then
						choreo = "Choreo\\Scotland\\Hibernian"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Kilmarnock FC
			elseif home == 1985 then
				-- STM
				if away == 1987 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Motherwell FC
			elseif home == 1986 then
				-- STM
				if away == 1219 or away == 5312 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--St. Mirren FC
			elseif home == 1987 then
				-- KIL
				if away == 1985 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--St. Johnstone FC
			elseif home == 2365 then
				-- DFC
				if away == 2621 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Ross County FC
			elseif home == 2622 then
				-- INV
				if away == 1984 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	--Scottish Cup
	elseif tid == 137 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Celtic FC
			if home == 131 then
				if stad == 64 then
					-- RAN or HIB or HEA
					if away == 132 or away == 1221 or away == 1222 then
						choreo = "Choreo\\Scotland\\Celtic"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Scotland\\Celtic"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Rangers FC
			elseif home == 132 then
				if stad == 65 then
					-- CEL or ABE or HEA or HIB
					if away == 131 or away == 1219 or away == 1221 or away == 1222 then
						choreo = "Choreo\\Scotland\\Rangers"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Scotland\\Rangers"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Aberdeen
			elseif home == 1219 then
				-- RAN or DUD or HEA or INV or MOT
				if away == 132 or away == 1220 or away == 1221 or away == 1984 or away == 1986 then
					choreo = "Choreo\\Scotland\\Aberdeen"
				elseif rdm == 1 then
					choreo = "Choreo\\Scotland\\Aberdeen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Dundee United
			elseif home == 1220 then
				-- ABE or DFC
				if away == 1219 or away == 2621 then
					choreo = "Choreo\\Scotland\\Dundee United"
				elseif rdm == 1 then
					choreo = "Choreo\\Scotland\\Dundee United"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Heart of Midlothian
			elseif home == 1221 then
				-- CEL or RAN or ABE or HIB
				if away == 131 or away == 132 or away == 1219 or away == 1222 then
					choreo = "Choreo\\Scotland\\Hearts"
				elseif rdm == 1 then
					choreo = "Choreo\\Scotland\\Hearts"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Hibernian FC
			elseif home == 1222 then
				-- CEL or RAN or HEA
				if away == 131 or away == 132 or away == 1221 then
					choreo = "Choreo\\Scotland\\Hibernian"
				elseif rdm == 1 then
					choreo = "Choreo\\Scotland\\Hibernian"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------
	
	--Belgian Teams
	--Jupiler Pro League
	elseif (tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159) then
		if ctx.match_info ~= 53 then
			--RSC Anderlecht
			if home == 174 then
				-- BRU or GNK or GNT or STA or ZUL 
				if away == 269 or away == 1195 or away == 1196 or away == 1197 or away == 2019 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Club Brugge KV
			elseif home == 269 then
				-- AND or GNT or STA or CER or ZUL or KVO 
				if away == 174 or away == 1196 or away == 1197 or away == 2009 or away == 2019 or away == 5192 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--KRC Genk
			elseif home == 1195 then
				-- AND or STA or STV
				if away == 174 or away == 1197 or away == 5194 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--KAA Gent
			elseif home == 1196 then
				-- AND or BRU or STA or ZUL or STV
				if away == 174 or away == 269 or away == 1197 or away == 2019 or away == 5194 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Standard Liège
			elseif home == 1197 then
				-- AND or BRU or GNK or GNT or CHA
				if away == 174 or away == 269 or away == 1195 or away == 1196 or away == 2010 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--KV Mechelen
			elseif home == 1200 then
				-- ANT or OHL
				if away == 5191 or away == 5217 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Cercle Brugge
			elseif home == 2009 then
				-- BRU or KVO
				if away == 269 or away == 5192 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Sporting Charleroi
			elseif home == 2010 then
				-- STA or REM or SER
				if away == 1197 or away == 5193 or away == 5684 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--KV Kortrijk
			elseif home == 2013 then
				-- ZUL
				if away == 2019 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--SV Zulte-Waregem
			elseif home == 2019 then
				-- AND or BRU or GNT or KVK
				if away == 174 or away == 269 or away == 1196 or away == 2013 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Royal Antwerp FC
			elseif home == 5191 then
				-- BEE
				if away == 5216 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--KV Oostende
			elseif home == 5192 then
				-- BRU or CER
				if away == 269 or away == 2009 then
					if rdm == 1 then
						choreo = "Choreo\\Belgium\\Oostende"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Sint-Truiden VV
			elseif home == 5194 then
				-- ZUL
				if away == 1195 or away == 1196 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--K Beerschot VA
			elseif home == 5216 then
				-- ANT
				if away == 5191 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--OH Leuven
			elseif home == 5217 then
				-- KVM
				if away == 1200 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--RFC Seraing
			elseif home == 5684 then
				-- CHA
				if away == 2010 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	--Belgian Cup
	elseif tid == 122 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--KV Oostende
			if home == 5192 then
				-- BRU or CER
				if away == 269 or away == 2009 then
					choreo = "Choreo\\Belgium\\Oostende"
				elseif rdm == 1 then
					choreo = "Choreo\\Belgium\\Oostende"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Swiss Teams
	--Raiffeisen Super League
	elseif tid == 117 then
		if ctx.match_info ~= 53 then
			--Basel
			if home == 1706 then
				if stad == 49 then
					-- YB or FCZ or LUZ
					if away == 1950 or away == 1957 or away == 4962 then
						if rdm == 1 then
							choreo = "Choreo\\Switzerland\\Basel"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Young Boys
			elseif home == 1950 then
				-- BAS or FCZ
				if away == 1706 or away == 1957 then
					choreo = "Choreo\\Switzerland\\Young Boys"
				else
					choreo = nil
				end
			--FC Sion
			elseif home == 1955 then
				-- LAU or LUG
				if away == 4964 or away == 4965 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			--Zurich
			elseif home == 1957 then
				-- BAS or YB
				if away == 1706 or away == 1950 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			--Servette
			elseif home == 1958 then
				-- LAU
				if away == 4964 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			--St. Gallen
			elseif home == 4937 then
				-- LUZ
				if away == 4962 then
					if rdm == 1 then
						choreo = "Choreo\\Switzerland\\St. Gallen"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Luzern
			elseif home == 4962 then
				-- BAS or SG
				if away == 1706 or away == 4937 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			--Lausanne-Sport
			elseif home == 4964 then
				-- SIO or SER
				if away == 1955 or away == 1958 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			--FC Lugano
			elseif home == 4965 then
				-- SIO
				if away == 1955 then
					choreo = "Scarf"  
				else
					choreo = nil
				end
			end
		end

	--Swiss Cup
	elseif tid == 124 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Basel
			if home == 1706 then
				if stad == 49 then
					-- YB or FCZ or LUZ
					if away == 1950 or away == 1957 or away == 4962 then
						choreo = "Choreo\\Switzerland\\Basel"
					elseif rdm == 1 then
						choreo = "Choreo\\Switzerland\\Basel"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--St. Gallen
			elseif home == 4937 then
				-- LUZ
				if away == 4962 then
					choreo = "Choreo\\Switzerland\\St. Gallen"
				elseif rdm == 1 then
					choreo = "Choreo\\Switzerland\\St. Gallen"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Young Boys
			elseif home == 1950 then
				-- BAS or FCZ
				if away == 1706 or away == 1957 then
					choreo = "Choreo\\Switzerland\\Young Boys"
				elseif rdm == 1 then
					choreo = "Choreo\\Switzerland\\Young Boys"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Turkish Teams
	--Spor Toto Süper Lig
	elseif tid == 118 then
		if ctx.match_info ~= 53 then
			--Galatasaray SK
			if home == 130 then
				-- FB
				if away == 197 then
					choreo = "Choreo\\Turkey\\Galatasaray\\League"
				-- BJK
				elseif away == 273 then
					if rdm == 1 then
						choreo = "Choreo\\Turkey\\Galatasaray\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Fenerbahçe SK
			elseif home == 197 then
				if stad == 66 then
					-- GS
					if away == 130 then
						choreo = "Choreo\\Turkey\\Fenerbahce\\Cup"
					-- BJK or TS
					elseif away == 273 or away == 1945 then
						if rdm == 1 then
							choreo = "Choreo\\Turkey\\Fenerbahce\\League"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					else
						choreo = nil
					end
				end
			--Beşiktaş JK
			elseif home == 273 then
				-- GS or FB or BFK
				if away == 130 or away == 197 or away == 1995 then
					choreo = "Choreo\\Turkey\\Besiktas"
				else
					choreo = nil
				end
			--Sivasspor
			elseif home == 1809 then
				-- TS or KAY or KON
				if away == 1945 or away == 1996 or away == 5204 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Trabzonspor
			elseif home == 1945 then
				-- FB or SIV
				if away == 197 or away == 1809 then
					if rdm == 1 then
						choreo = "Choreo\\Turkey\\Trabzonspor"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Antalyaspor
			elseif home == 1989 then
				-- ALA or HTY
				if away == 5202 or away == 5452 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Istanbul Başakşehir FK
			elseif home == 1995 then
				-- BJK
				if away == 273 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Kayserispor
			elseif home == 1996 then
				-- SIV
				if away == 1809 then
					if rdm == 1 then
						choreo = "Choreo\\Turkey\\Kayserispor"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				else
					choreo = nil
				end
			--Kasimpaşa SK
			elseif home == 2625 then
				-- FKS
				if away == 5652 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Alanyaspor
			elseif home == 5202 then
				-- ANT
				if away == 1989 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Goztepe
			elseif home == 5203 then
				-- ALT
				if away == 5451 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Konyaspor
			elseif home == 5204 then
				-- SIV
				if away == 1809 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Caykur Rizespor
			elseif home == 5354 then
				-- GIR
				if away == 5357 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Giresunspor
			elseif home == 5357 then
				-- RIZ
				if away == 5354 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Istanbulspor AŞ
			elseif home == 5358 then
				-- BFK
				if away == 5358 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Altay
			elseif home == 5451 then
				-- GOZ
				if away == 5203 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Hatayspor
			elseif home == 5452 then
				-- ANT
				if away == 1989 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			--Fatih Karagümrük
			elseif home == 5652 then
				-- KAS
				if away == 2625 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		end
	
	--Turkish Cup
	elseif tid == 125 then
		choreo = "Scarf"
		if ctx.match_info ~= 53 then
			--Galatasaray SK
			if home == 130 then
				-- FB or BJK
				if away == 197 and away == 273 then
					choreo = "Choreo\\Turkey\\Galatasaray\\League"
				elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
					if rdm == 1 then
						choreo = "Choreo\\Turkey\\Galatasaray\\League"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Scarf"
					end
				end
			--Fenerbahçe SK
			elseif home == 197 then
				if stad == 66 then
					-- GS or BJK or TS
					if away == 130 or away == 273 or away == 1945 then
						choreo = "Choreo\\Turkey\\Fenerbahce\\Cup"
					elseif (ctx.match_info == 46 or ctx.match_info == 47 or ctx.match_info == 51 or ctx.match_info == 52) then
						if rdm == 1 then
							choreo = "Choreo\\Turkey\\Fenerbahce\\Cup"
						elseif (rdm == 2 or rdm == 3) then
							choreo = "Scarf"
						end
					end
				end
			--Beşiktaş JK
			elseif home == 273 then
				-- GS or FB or BFK
				if away == 130 or away == 197 or away == 1995 then
					choreo = "Choreo\\Turkey\\Besiktas"
				elseif rdm == 1 then
					choreo = "Choreo\\Turkey\\Besiktas"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Trabzonspor
			elseif home == 1945 then
				-- FB or SIV
				if away == 197 or away == 1809 then
					choreo = "Choreo\\Turkey\\Trabzonspor"
				elseif rdm == 1 then
					choreo = "Choreo\\Turkey\\Trabzonspor"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			--Kayserispor
			elseif home == 1996 then
				-- SIV
				if away == 1809 then
					choreo = "Choreo\\Turkey\\Kayserispor"
				elseif rdm == 1 then
					choreo = "Choreo\\Turkey\\Kayserispor"
				elseif (rdm == 2 or rdm == 3) then
					choreo = "Scarf"
				end
			end
		end
	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Argentina Teams
	elseif (tid == 30 or tid == 59) then
		--River Plate
		if home == 138 then
			-- BOC
			if away == 139 then
				choreo = "Choreo\\Argentina\\River"
			else
				choreo = nil
			end
		--Boca Juniors
		elseif home == 139 then
			-- RIV
			if away == 138 then
				choreo = "Choreo\\Argentina\\Boca Juniors"
			else
				choreo = nil
			end
		end

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	--Brazilian Teams
	elseif (tid == 29 or tid == 163 or tid == 31) then
		--Vasco da Gama
		if home == 136 then
			if stad == 59 then
				-- BOT or FLA or FLU
				if away == 1246 or away == 1248 or away == 1249 then
					choreo = "Choreo\\Brazil\\Vasco da Gama"
				else
					choreo = nil
				end
			end
		--Palmeiras
		elseif home == 137 then
			if stad == 33 then
				-- COR or SAN or SPA
				if away == 1247 or away == 1254 or away == 1255 then
					choreo = "Choreo\\Brazil\\Palmeiras"
				else
					choreo = nil
				end
			end
		--Cruzeiro
		elseif home == 274 then
			-- CAM
			if away == 1245 then
				choreo = "Choreo\\Brazil\\Cruzeiro"
			else
				choreo = nil
			end
		--Atlético Mineiro
		elseif home == 1245 then
			-- CRU or FLA
			if away == 274 or away == 1248 then
				choreo = "Choreo\\Brazil\\Atleticomg"
			else
				choreo = nil
			end
		--Botafogo
		elseif home == 1246 then
			-- VSC or FLA or FLU
			if away == 136 or away == 1248 or away == 1249 then
				choreo = "Choreo\\Brazil\\Botafogo"
			else
				choreo = nil
			end
		--Corinthians
		elseif home == 1247 then
			if stad == 35 then
				-- PAL or FLA or SAN or SPA
				if away == 137 or away == 1248 or away == 1254 or away == 1255 then
					choreo = "Choreo\\Brazil\\Corinthians"
				else
					choreo = nil
				end
			end
		--Flamengo
		elseif home == 1248 then
			if stad == 24 then
				-- VSC or CAM or BOT or COR or FLU
				if away == 136 or away == 1245 or away == 1246 or away == 1247 or away == 1249 then
					choreo = "Choreo\\Brazil\\Flamengo"
				else
					choreo = nil
				end
			end
		--Fluminense
		elseif home == 1249 then
			if stad == 24 then
				-- VSC or BOT or FLA
				if away == 136 or away == 1246 or away == 1248 then
					choreo = "Choreo\\Brazil\\Fluminense"
				else
					choreo = nil
				end
			end
		--Gremio
		elseif home == 1250 then
			-- SCI
			if away == 1252 then
				choreo = "Choreo\\Brazil\\Gremio"
			else
				choreo = nil
			end
		--Internacional Porto Alegre
		elseif home == 1252 then
			if stad == 36 then
				-- CAM or GRE or VIT or CEA or FOR
				if away == 1245 or away == 1250 or away == 1937 or away == 2454 or away == 5143 then
					choreo = "Choreo\\Brazil\\Internacional Porto Alegre"
				else
					choreo = nil
				end
			end
		--Santos
		elseif home == 1254 then
			if stad == 16 then
				-- PAL or COR or SPA
				if away == 137 or away == 1247 or away == 1255 then
					choreo = "Choreo\\Brazil\\Santos"
				else
					choreo = nil
				end
			end
		--Sao Paulo
		elseif home == 1255 then
			if stad == 14 then
				-- PAL or COR or SAN
				if away == 137 or away == 1247 or away == 1254 then
					choreo = "Choreo\\Brazil\\Sao Paulo"
				else
					choreo = nil
				end
			end
		--Atletico Paranaense
		elseif home == 1930 then
			-- CRU
			if away == 1931 then
				choreo = "Choreo\\Brazil\\Atletico Paranaense"
			else
				choreo = nil
			end
		end

	---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------

	-- Exhibition
	elseif (tid == 65535 or tid == 9400 or tid == 9401 or tid == 9402 or tid == 9403 or tid == 9404 or tid == 9405 or tid == 9406 or tid == 9407) then
		--FC Barcelona
		if home == 108 then
			if stad == 2 then
				-- RMA or ESP
				if away == 109 or away == 259 then
					choreo = "Choreo\\Spain\\Barcelona"
				else
					choreo = nil
				end
			end
		--Real Madrid CF
		elseif home == 109 then
			if stad == 21 then
				-- BAR or VAL or ATL or ATH or GET
				if away == 108 or away == 110 or away == 172 or away == 258 or away == 362 then
					choreo = "Choreo\\Spain\\Real Madrid\\League"
				else
					choreo = nil
				end
			end
		--Valencia CF
		elseif home == 110 then
			-- RMA or VIL or LEV
			if away == 109 or away == 267 or away == 366 then
				choreo = "Choreo\\Spain\\Valencia"
			else
				choreo = nil
			end
		--Atlético Madrid
		elseif home == 172 then
			if stad == 56 then
				-- RMA or GET
				if away == 109 or away == 362 then
					choreo = "Choreo\\Spain\\Atletico Madrid\\League"
				else
					choreo = nil
				end
			end
		--Real Betis
		elseif home == 194 then
			-- MAL or SEV or GRA
			if away == 260 or away == 265 or away == 1765 then
				choreo = "Choreo\\Spain\\Real Betis\\League"
			else
				choreo = nil
			end
		--Celta de Vigo
		elseif home == 195 then
			-- DEP
			if away == 111 then
				choreo = "Choreo\\Spain\\Celta"
			else
				choreo = nil
			end
		--Real Sociedad
		elseif home == 196 then
			-- ATH or ALA
			if away == 258 or away == 4145 then
				choreo = "Choreo\\Spain\\Real Sociedad"
			else
				choreo = nil
			end
		--Athletic Bilbao
		elseif home == 258 then
			-- RMA or RSO or ALA
			if away == 109 or away == 196 or away == 4145 then
				choreo = "Choreo\\Spain\\Athletic Club"
			else
				choreo = nil
			end
		--RCD Espanyol
		elseif home == 259 then
			-- BAR
			if away == 108 then
				choreo = "Choreo\\Spain\\Espanyol"
			else
				choreo = nil
			end
		--Málaga CF
		elseif home == 260 then
			-- BET or SEV or GRA
			if away == 194 or away == 265 or away == 1765 then
				choreo = "Choreo\\Spain\\Malaga"
			else
				choreo = nil
			end
		--CA Osasuna
		elseif home == 263 then
			-- ALA or LOG
			if away == 4145 or away == 4255 then
				choreo = "Choreo\\Spain\\Osasuna"
			else
				choreo = nil
			end
		--Sevilla FC
		elseif home == 265 then
			-- BET or MAL
			if away == 194 or away == 260 then
				choreo = "Choreo\\Spain\\Sevilla"
			else
				choreo = nil
			end
		--Villarreal CF
		elseif home == 267 then
			-- VAL
			if away == 110 then
				choreo = "Choreo\\Spain\\Villareal"
			else
				choreo = nil
			end
		--Elche CF
		elseif home == 361 then
			-- LAP or LEV or ALB
			if away == 364 or away == 366 or away == 4302 then
				choreo = "Choreo\\Spain\\Elche"
			else
				choreo = nil
			end
		--Getafe CF
		elseif home == 362 then
			-- RMA or ATL
			if away == 109 or away == 172 then
				choreo = "Choreo\\Spain\\Getafe"
			else
				choreo = nil
			end
		--Sporting Gijón
		elseif home == 363 then
			-- OVI
			if away == 4260 then
				choreo = "Choreo\\Spain\\Sporting De Gijon"
			else
				choreo = nil
			end
		--UD Las Palmas
		elseif home == 364 then
			-- ELC or TEN
			if away == 361 or away == 4147 then
				choreo = "Choreo\\Spain\\Las Palmas"
			else
				choreo = nil
			end
		--Levante UD
		elseif home == 366 then
			-- VAL or ELC
			if away == 110 or away == 361 then
				choreo = "Choreo\\Spain\\Levante"
			else
				choreo = nil
			end
		--Granada CF
		elseif home == 1765 then
			-- BET or MAL
			if away == 194 or away == 260 then
				choreo = "Choreo\\Spain\\Granada"
			else
				choreo = nil
			end
		--Girona FC
		elseif home == 2187 then
			-- SAB
			if away == 2523 then
				choreo = "Choreo\\Spain\\Girona"
			else
				choreo = nil
			end
		--Deportivo Alavés
		elseif home == 4145 then
			-- RSO or ATH or OSA or EIB
			if away == 196 or away == 258 or away == 263 or away == 4146 then
				choreo = "Choreo\\Spain\\Alaves"
			else
				choreo = nil
			end
		--SD Eibar
		elseif home == 4146 then
			-- ALA
			if away == 4145 then
				choreo = "Choreo\\Spain\\Eibar"
			else
				choreo = nil
			end
		--CD Tenerife
		elseif home == 4147 then
			-- LAP
			if away == 364 then
				choreo = "Choreo\\Spain\\Tenerife"	
			else
				choreo = nil
			end
		--Real Oviedo
		elseif home == 4260 then
			-- SPO
			if away == 363 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--CD Leganés
		elseif home == 4272 then
			-- ALC or FUE
			if away == 2393 or away == 4269 then
				choreo = "Choreo\\Spain\\Leganes"
			else
				choreo = nil
			end
		--Albacete Balompié
		elseif home == 4302 then
			-- ELC
			if away == 361 then
				choreo = "Choreo\\Spain\\Albacete"
			else
				choreo = nil
			end
		--Borussia Dortmund
		elseif home == 126 then
			if stad == 51 then
				-- FCB
				if away == 127 then
					choreo = "Choreo\\Germany\\Borussia Dortmund\\Bayern"
				elseif away == 184 or away == 225 then
				-- S04 or BMG
					choreo = "Choreo\\Germany\\Borussia Dortmund\\UEFA_1"
				else
					choreo = nil
				end
			end
		--Bayern Munich
		elseif home == 127 then
			if stad == 11 then
				-- BVB or LEV or S04 or VFB
				if away == 126 or away == 128 or away == 184 or away == 231 then
					choreo = "Choreo\\Germany\\Bayern Munich\\League"
				else
					choreo = nil
				end
			end
		--Bayer Leverkusen
		elseif home == 128 then
			-- FCB or KOE
			if away == 127 or away == 4137 then
				choreo = "Choreo\\Germany\\Bayer Leverkusen"
			else
				choreo = nil
			end
		--Schalke
		elseif home == 184 then
			if stad == 63 then
				-- BVB or FCB
				if away == 126 or away == 127 then
					choreo = "Choreo\\Germany\\Schalke"
				else
					choreo = nil
				end
			end
		--Werder Bremen
		elseif home == 185 then
			-- FCB
			if away == 127 then
				choreo = "Choreo\\Germany\\Werder Bremen"
			else
				choreo = nil
			end
		--Borussia Monchengladbach
		elseif home == 225 then
			-- BVB or FCK
			if away == 126 or away == 4137 then
				choreo = "Choreo\\Germany\\Borussia Monchengladbach"
			else
				choreo = nil
			end
		--VfL Wolfsburg
		elseif home == 232 then
			choreo = "Choreo\\Germany\\VfL Wolfsburg"
		--Frankfurt
		elseif home == 226 then
			-- M05
			if away == 436 then
				choreo = "Choreo\\Germany\\Frankfurt"
			else
				choreo = nil
			end
		--Freiburg
		elseif home == 227 then
			-- VFB
			if away == 231 then
				choreo = "Choreo\\Germany\\Freiburg"
			else
				choreo = nil
			end
		--Stuttgart
		elseif home == 231 then
			-- FCB or SCF
			if away == 127 or away == 227 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FSV Mainz
		elseif home == 436 then
			-- SGE
			if away == 226 then
				choreo = "Choreo\\Germany\\FSV Mainz"
			else
				choreo = nil
			end
		--Hertha Berlin
		elseif home == 4125 then
			if stad == 38 then
				-- UNB
				if away == 4140 then
					choreo = "Choreo\\Germany\\Hertha Berlin"
				else
					choreo = nil
				end
			end
		--VFL Bochum
		elseif home == 4128 then
			-- KOE
			if away == 4137 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FC Koln
		elseif home == 4137 then
			-- LEV or BMG or BOC
			if away == 128 or away == 225 or away == 4128 then
				choreo = "Choreo\\Germany\\FC Koln"
			else
				choreo = nil
			end
		--Union Berlin
		elseif home == 4140 then
			-- BSC
			if away == 4125 then
				choreo = "Choreo\\Germany\\Union Berlin"
			else
				choreo = nil
			end
		--Manchester United
		elseif home == 100 then
			if stad == 7 then
				-- ARS or CHE or LIV or MCI
				if away == 101 or away == 102 or away == 103 or away == 173 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		--Arsenal FC
		elseif home == 101 then
			if stad == 52 then
				-- MUN or CHE or TOT
				if away == 100 or away == 102 or away == 179 then
					choreo = "Choreo\\England\\Arsenal\\UEFA_1"
				else
					choreo = nil
				end
			end
		--Chelsea FC
		elseif home == 102 then
			-- MUN or ARS or LIV or TOT
			if away == 100 or away == 101 or away == 103 or away == 179 then
				choreo = "Choreo\\England\\Chelsea\\League"
			else
				choreo = nil
			end
		--Liverpool FC
		elseif home == 103 then
			if stad == 4 then
				-- MUN or CHE or MCI or EVE
				if away == 100 or away == 102 or away == 173 or away == 177 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		--Leeds United
		elseif home == 104 then
			-- CHE or HUD or BAR or HUL or SHU
			if away == 102 or away == 2610 or away == 1588 or away == 1589 or away == 4194 then
				choreo = "Choreo\\England\\Leeds"
			else
				choreo = nil
			end
		--West Ham United
		elseif home == 105 then
			-- CHE or MIL
			if away == 102 or away == 387 then
				choreo = "Choreo\\England\\West Ham United\\League"
			else
				choreo = nil
			end
		--Newcastle United
		elseif home == 106 then
			-- MID or SUN
			if away == 205 or away == 396 then
				choreo = "Choreo\\England\\Newcastle"
			else
				choreo = nil
			end
		--Aston Villa FC
		elseif home == 107 then
			-- BIR or WOL or WBA
			if away == 201 or away == 208 or away == 399 then
				choreo = "Choreo\\England\\Aston Villa"
			else
				choreo = nil
			end
		--Manchester City
		elseif home == 173 then
			-- MUN or LIV
			if away == 100 or away == 103 then
				choreo = "Choreo\\England\\Manchester City\\UEFA"
			else
				choreo = nil
			end
		--Blackburn Rovers
		elseif home == 176 then
			-- BUR or BLP or PNE 
			if away == 378 or away == 1761 or away == 4192 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Everton FC
		elseif home == 177 then
			-- LIV
			if away == 103 then
				choreo = "Choreo\\England\\Everton"
			else
				choreo = nil
			end
		--Fulham FC
		elseif home == 178 then
			-- QPR or BRE
			if away == 1327 or away == 4180 then
				choreo = "Choreo\\England\\Fulham"
			else
				choreo = nil
			end
		--Tottenham Hotspur
		elseif home == 179 then
			-- ARS or CHE or WHU
			if away == 101 or away == 102 or away == 105 then
				choreo = "Choreo\\England\\Tottenham\\League"
			else
				choreo = nil
			end
		--Birmingham City
		elseif home == 201 then
			-- ASV or WOL or WBA or COV
			if away == 107 or away == 208 or away == 399 or away == 4183 then
				choreo = "Choreo\\England\\Birmingham"
			else
				choreo = nil
			end
		--Leicester City
		elseif home == 204 then
			-- DER or NFO
			if away == 383 or away == 389 then
				choreo = "Choreo\\England\\Leicester City\\League"
			else
				choreo = nil
			end
		--Middlesbrough FC
		elseif home == 205 then
			-- NEW or SUN
			if away == 106 or away == 396 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Southampton FC
		elseif home == 207 then
			-- BHA or BOU
			if away == 377 or away == 4071 then
				choreo = "Choreo\\England\\Southampton"
			else
				choreo = nil
			end
		--Wolverhampton Wanderers
		elseif home == 208 then
			-- ASV or BIR or WBA or COV
			if away == 107 or away == 201 or away == 399 or away == 4183 then
				choreo = "Choreo\\England\\Wolverhampton"
			else
				choreo = nil
			end
		--Brighton and Hove
		elseif home == 377 then
			-- SOU or CRY or BOU
			if away == 207 or away == 382 or away == 4071 then
				choreo = "Choreo\\England\\Brighton and Hove"
			else
				choreo = nil
			end
		--Burnley FC
		elseif home == 378 then
			-- BLB or BLP or PNE
			if away == 176 or away == 1761 or away == 4192 then
				choreo = "Choreo\\England\\Burnley"
			else
				choreo = nil
			end
		--Cardiff City City
		elseif home == 379 then
			-- BCI or SWA
			if away == 1760 or away == 1909 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Crystal Palace FC
		elseif home == 382 then
			-- BHA or MIL
			if away == 207 or away == 377 or away == 387 then
				choreo = "Choreo\\England\\Crystal Palace"
			else
				choreo = nil
			end
		--Derby County
		elseif home == 383 then
			-- LEI or NFO
			if away == 204 or away == 389 then
				choreo = "Choreo\\England\\Derby County"
			else
				choreo = nil
			end
		--Millwall FC
		elseif home == 387 then
			-- WHU or CRY
			if away == 105 or away == 382 then
				choreo = "Choreo\\England\\Millwall"
			else
				choreo = nil
			end
		--Nottingham Forest
		elseif home == 389 then
			-- LEI or DER or SHU
			if away == 204 or away == 383 or away == 4194 then
				choreo = "Choreo\\England\\Nottingham Forest"
			else
				choreo = nil
			end
		--Reading FC
		elseif home == 391 then
			-- WAT or BOU or BRE
			if away == 398 or away == 4071 or away == 4180 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Watford FC
		elseif home == 398 then
			-- RDG or LUT
			if away == 391 or away == 4363 then
				choreo = "Choreo\\England\\Watford"
			else
				choreo = nil
			end
		--West Bromvich Albion
		elseif home == 399 then
			-- ASV or BIR or WOL
			if away == 107 or away == 201 or away == 208 then
				choreo = "Choreo\\England\\West Bromvich Albion"
			else
				choreo = nil
			end
		--Queens Park Rangers
		elseif home == 1327 then
			-- FUL or BRE
			if away == 178 or away == 4180 then
				choreo = "Choreo\\England\\QPR"
			else
				choreo = nil
			end
		--Hull City
		elseif home == 1589 then
			-- LEE
			if away == 104 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Bristol City
		elseif home == 1760 then
			-- CAR
			if away == 379 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Blackpool FC
		elseif home == 1761 then
			-- BLR or BUR or PNE
			if away == 176 or away == 378 or away == 4192 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Swansea City
		elseif home == 1909 then
			-- CAR
			if away == 379 then
				choreo = "Choreo\\England\\Swansea"
			else
				choreo = nil
			end
		--Amiens FC
		-- elseif home == 4200 then
		-- 	choreo = "Choreo\\France\\Amiens"
		--Huddersfield Town
		elseif home == 2610 then
			-- LEE or BAR or SHU
			if away == 104 or away == 1588 or away == 4194 then
				choreo = "Choreo\\England\\Huddersfield"
			else
				choreo = nil
			end
		--AFC Bournemouth
		elseif home == 4071 then
			-- SOU or BHA or RDG
			if away == 207 or away == 377 or away == 391 then
				choreo = "Choreo\\England\\Bournemouth"
			else
				choreo = nil
			end
		--Brentford FC
		elseif home == 4180 then
			-- FUL or RDG or QPR
			if away == 178 or away == 391 or away == 1327 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Coventry City
		elseif home == 4183 then
			-- BIR or WOL
			if away == 201 or away == 208 then
				choreo = "Choreo\\England\\Coventry"
			else
				choreo = nil
			end
		--Preston North End
		elseif home == 4192 then
			-- BLR or BUR or BLP
			if away == 176 or away == 378 or away == 1761 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Sheffield United
		elseif home == 4194 then
			-- LEE or NFO or BAR or HUD
			if away == 104 or away == 389 or away == 1588 or away == 2610 then
				choreo = "Choreo\\England\\Sheffield United"
			else
				choreo = nil
			end
		--Luton Town
		elseif home == 4363 then
			-- WAT
			if away == 398 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Inter
		elseif home == 119 then
			if stad == 1 then
				-- JUV or ROM or NAP
				if away == 120 or away == 125 or away == 327 then
					choreo = "Choreo\\Italy\\Inter\\League"
				-- MIL
				elseif away == 121 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\Inter\\AC Milan\\1"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Italy\\Inter\\AC Milan\\2"
					end
				else
					choreo = nil
				end
			end
		--Juventus
		elseif home == 120 then
			if stad == 22 then
				-- INT or MIL or FIO or ROM or GEN or NAP or TOR
				if away == 119 or away == 121 or away == 124 or away == 125 or away == 323 or away == 327 or away == 333 then
					choreo = "Choreo\\Italy\\Juventus"
				else
					choreo = nil
				end
			end
		--AC Milan
		elseif home == 121 then
			if stad == 30 then
				-- JUV or ROM or GEN or NAP
				if away == 120 or away == 125 or away == 323 or away == 327 then
					choreo = "Choreo\\Italy\\AC Milan\\League"
				-- INT
				elseif away == 119 then
					if rdm == 1 then
						choreo = "Choreo\\Italy\\AC Milan\\Inter\\1"
					elseif (rdm == 2 or rdm == 3) then
						choreo = "Choreo\\Italy\\AC Milan\\Inter\\2"
					end
				else
					choreo = nil
				end
			end
		--Lazio
		elseif home == 122 then
			if stad == 6 then
				-- ROM
				if away == 125 then
					choreo = "Choreo\\Italy\\Lazio\\Roma"
				-- FIO or NAP
				elseif away == 124 or away == 327 then
					choreo = "Choreo\\Italy\\Lazio\\League"
				else
					choreo = nil
				end
			end
		--Parma Calcio
		elseif home == 123 then
			-- BOL or REG
			if away == 186 or away == 4225 then
				choreo = "Choreo\\Italy\\Parma"
			else
				choreo = nil
			end
		--Fiorentina
		elseif home == 124 then
			-- JUV or LAZ or ROM or BOL or EMP or NAP or PIS
			if away == 120 or away == 122 or away == 125 or away == 186 or away == 235 or away == 327 or away == 4241 then
				choreo = "Choreo\\Italy\\Fiorentina"
			else
				choreo = nil
			end
		--Roma
		elseif home == 125 then
			if stad == 6 then
				-- INT or JUV or MIL or FIO or NAP
				if away == 119 or away == 120 or away == 121 or away == 124 or away == 327 then
					choreo = "Choreo\\Italy\\Roma\\League"
				-- LAZ
				elseif away == 122 then
					choreo = "Choreo\\Italy\\Roma\\Lazio"
				else
					choreo = nil
				end
			end
		--Bologna
		elseif home == 186 then
			-- PAR or FIO or SPA
			if away == 123 or away == 124 or away == 240 or away == 4923 then
				choreo = "Choreo\\Italy\\Bologna"
			else
				choreo = nil
			end
		--Brescia
		elseif home == 187 then
			-- ATA or EMP or HEL or VIC
			if away == 234 or away == 235 or away == 336 or away == 337 then
				choreo = "Choreo\\Italy\\Brescia"
			else
				choreo = nil
			end
		--Udinese Calcio
		elseif home == 190 then
			-- VEN
			if away == 4229 then
				choreo = "Choreo\\Italy\\Udinese"
			else
				choreo = nil
			end
		--Atalanta
		elseif home == 234 then
			-- BRE or NAP or HEL
			if away == 187 or away == 327 or away == 336 then
				choreo = "Choreo\\Italy\\Atalanta"
			else
				choreo = nil
			end
		--Empoli
		elseif home == 235 then
			-- FIO or BRE
			if away == 124 or away == 187 then
				choreo = "Choreo\\Italy\\Empoli"
			else
				choreo = nil
			end
		--Reggina 1914
		elseif home == 239 then
			-- CRO
			if away == 1363 then
				choreo = "Choreo\\Italy\\Reggina\\League"
			else
				choreo = nil
			end
		--UC Sampdoria
		elseif home == 240 then
			-- GEN
			if away == 323 then
				choreo = "Choreo\\Italy\\Sampdoria\\Genoa"
			-- BOL or NAP or TOR or PIS
			elseif away == 186 or away == 327 or away == 333 or away == 4241 then
				choreo = "Choreo\\Italy\\Sampdoria\\League"
			else
				choreo = nil
			end
		--Ascoli
		elseif home == 317 then
			-- PES
			if away == 328 then
				choreo = "Choreo\\Italy\\Ascoli"
			else
				choreo = nil
			end
		--Cagliari
		elseif home == 320 then
			-- NAP
			if away == 327 then
				choreo = "Choreo\\Italy\\Cagliari"
			else
				choreo = nil
			end
		--Genoa CFC
		elseif home == 323 then
			-- SAM
			if away == 240 then
				choreo = "Choreo\\Italy\\Genoa\\Sampdoria"
			-- JUV or MIL or HEL or SPE
			elseif away == 120 or away == 121 or away == 336 or away == 1600 then
				choreo = "Choreo\\Italy\\Genoa\\League"
			else
				choreo = nil
			end
		--Napoli
		elseif home == 327 then
			-- INT or JUV or MIL or LAZ or FIO or ROM or ATA or SAM or CAG or HEL 
			if away == 119 or away == 120 or away == 121 or away == 122 or away == 124 or away == 125 or away == 234 or away == 240 or away == 320 or away == 336 then
				choreo = "Choreo\\Italy\\Napoli\\League"
			else
				choreo = nil
			end
		--Torino FC
		elseif home == 333 then
			-- JUV or SAM
			if away == 120 or away == 240 then
				choreo = "Choreo\\Italy\\Torino"
			else
				choreo = nil
			end
		--Hellas
		elseif home == 336 then
			-- BRE or CHI or ATA or GEN or NAP
			if away == 187 or away == 188 or away == 234 or away == 323 or away == 327 then
				choreo = "Choreo\\Italy\\Hellas Verona"
			else
				choreo = nil
			end
		--US Sassuolo
		elseif home == 1919 then
			-- REG
			if away == 4225 then
				choreo = "Choreo\\Italy\\Sassuolo"
			else
				choreo = nil
			end
		--Spezia Calcio
		elseif home == 1600 then
			-- GEN or REG
			if away == 323 or away == 4225 then
				choreo = "Choreo\\Italy\\Spezia"
			else
				choreo = nil
			end
		--Como 1907
		elseif home == 4219 then
			-- MON
			if away == 4914 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Reggiana 1919
		elseif home == 4225 then
			-- PAR or SAS or SPE or SPA
			if away == 123 or away == 1919 or away == 1600 or away == 4923 then
				choreo = "Choreo\\Italy\\Reggiana"
			else
				choreo = nil
			end
		--Venezia
		elseif home == 4229 then
			-- UDI or VIN
			if away == 190 or away == 337 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Benevento
		elseif home == 4232 then
			-- CRO
			if away == 1363 then
				choreo = "Choreo\\Italy\\Benevento"
			else
				choreo = nil
			end
		--Frosinone
		elseif home == 4234 then
			-- PER
			if away == 4240 then
				choreo = "Choreo\\Italy\\Frosinone"
			else
				choreo = nil
			end
		--Perugia
		elseif home == 4240 then
			-- FRO
			if away == 4234 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Pisa
		elseif home == 4241 then
			-- FIO or SAM
			if away == 124 or away == 240 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--AC Monza
		elseif home == 4914 then
			-- COM
			if away == 4219 then
				choreo = "Choreo\\Italy\\Monza"
			else
				choreo = nil
			end
		--SPAL
		elseif home == 4923 then
			-- BOL or REG
			if away == 186 or away == 4225 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Ajax
		elseif home == 116 then
			if stad == 70 then
				-- FEY or PSV or ALK or ADH or UTR
				if away == 117 or away == 118 or away == 242 or away == 243 or away == 251 then
					choreo = "Choreo\\Netherlands\\Ajax"
				else
					choreo = nil
				end
			end
		--Feyenoord
		elseif home == 117 then
			if stad == 71 then
				-- AJA or PSV or UTR or ROT
				if away == 116 or away == 118 or away == 251 or away == 351 then
					choreo = "Scarf"
				else
					choreo = nil
				end
			end
		--PSV
		elseif home == 118 then 
			-- AJA or FEY
			if away == 116 or away == 117 then
				choreo = "Choreo\\Netherlands\\PSV"
			else
				choreo = nil
			end
		--AZ Alkmaar
		elseif home == 242 then
			-- AJA
			if away == 116 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--ADO Den Haag
		elseif home == 243 then
			-- AJA or UTR or ROT
			if away == 116 or away == 251 or away == 351 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FC Groningen
		elseif home == 244 then 
			-- HEE or ZWO or EMM
			if away == 245 or away == 256 or away == 342 then
				choreo = "Choreo\\Netherlands\\Groningen"
			else
				choreo = nil
			end
		--Heerenveen
		elseif home == 245 then
			-- GRO or ZWO
			if away == 244 or away == 256 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--NEC Nijmegen
		elseif home == 247 then
			-- VIT
			if away == 252 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FC Twente
		elseif home == 250 then
			-- HER
			if away == 349 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FC Utrecht
		elseif home == 251 then 
			-- AJA or FEY or ADH
			if away == 116 or away == 117 or away == 243 then
				choreo = "Choreo\\Netherlands\\Utrecht"
			else
				choreo = nil
			end
		--Vitesse
		elseif home == 252 then
			-- NIJ or GAE
			if away == 247 or away == 346 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--RKC Waalwijk
		elseif home == 254 then
			-- WIL
			if away == 255 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--PEC Zwolle
		elseif home == 256 then
			-- GRO or HEE or GAE
			if away == 244 or away == 245 or away == 346 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--FC Emmen
		elseif home == 342 then
			-- GRO
			if away == 244 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Go Ahead Eagles
		elseif home == 346 then
			-- TWE or VIT or ZWO or HER
			if away == 250 or away == 252 or away == 256 or away == 349 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Heracles Almelo
		elseif home == 349 then
			-- TWE or GAE
			if away == 250 or away == 346 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Sparta Rotterdam
		elseif home == 351 then
			-- FEY or ADH
			if away == 117 or away == 243 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Celtic
		elseif home == 131 then
			if stad == 64 then
				-- RAN or HIB or HEA
				if away == 132 or away == 1221 or away == 1222 then
					choreo = "Choreo\\Scotland\\Celtic"
				else
					choreo = nil
				end
			end
		--Rangers
		elseif home == 132 then
			if stad == 65 then
				-- CEL or ABE or HEA or HIB
				if away == 131 or away == 1219 or away == 1221 or away == 1222 then
					choreo = "Choreo\\Scotland\\Rangers"
				else
					choreo = nil
				end
			end
		--Aberdeen
		elseif home == 1219 then
			-- RAN or DUD or HEA or INV or MOT
			if away == 132 or away == 1220 or away == 1221 or away == 1984 or away == 1986 then
				choreo = "Choreo\\Scotland\\Aberdeen"
			else
				choreo = nil
			end
		--Dundee United
		elseif home == 1220 then
			-- ABE or DFC
			if away == 1219 or away == 2621 then
				choreo = "Choreo\\Scotland\\Dundee United"
			else
				choreo = nil
			end
		--Hearts
		elseif home == 1221 then
			-- CEL or RAN or ABE or HIB
			if away == 131 or away == 132 or away == 1219 or away == 1222 then
				choreo = "Choreo\\Scotland\\Hearts"
			else
				choreo = nil
			end
		--Hibernian
		elseif home == 1222 then
			-- CEL or RAN or HEA
			if away == 131 or away == 132 or away == 1221 then
				choreo = "Choreo\\Scotland\\Hibernian"
			else
				choreo = nil
			end
		--Kilmarnock
		elseif home == 1985 then
			-- STM
			if away == 1987 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Motherwell
		elseif home == 1986 then
			-- STM
			if away == 1219 or away == 5312 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--St. Mirren
		elseif home == 1987 then
			-- KIL
			if away == 1985 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--St. Johnstone
		elseif home == 2365 then
			-- DFC
			if away == 2621 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Ross County
		elseif home == 2622 then
			-- INV
			if away == 1984 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Monaco
		elseif home == 112 then
			if stad == 41 then
				-- OM or NIC
				if away == 113 or away == 217 then
					choreo = "Choreo\\France\\Monaco"
				else
					choreo = nil
				end
			end
		--Olympique Marseille
		elseif home == 113 then
			-- MON or PSG
			if away == 112 or away == 114 then
				choreo = "Choreo\\France\\Olympique Marseille"
			else
				choreo = nil
			end
		--Paris Saint Germain
		elseif home == 114 then
			-- OM or LYO
			if away == 113 or away == 181 then
				choreo = "Choreo\\France\\PSG\\League"
			else
				choreo = nil
			end
		--Bordeaux
		elseif home == 115 then
			-- NAN or TOU
			if away == 216 or away == 221 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Auxerre
		elseif home == 180 then
			-- TRO or DIJ
			if away == 420 or away == 1328 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Olympique Lyonnais
		elseif home == 181 then
			-- PSG or SAE
			if away == 114 or away == 418 then
				choreo = "Choreo\\France\\Olympique Lyonnais"
			else
				choreo = nil
			end
		--Lens
		elseif home == 182 then
			-- LIL
			if away == 213 then
				choreo = "Choreo\\France\\Lens"
			else
				choreo = nil
			end
		--Ajaccio
		elseif home == 209 then
			-- BAS
			if away == 210 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--SC Bastia
		elseif home == 210 then
			-- AJA or NIC
			if away == 209 or away == 217 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Guingamp
		elseif home == 211 then
			-- REN or BRE
			if away == 218 or away == 1329 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Lille
		elseif home == 213 then
			-- LEN or VAL
			if away == 182 or away == 1528 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Montpellier
		elseif home == 215 then
			-- NIM
			if away == 1910 then
				choreo = "Choreo\\France\\Montpellier"
			else
				choreo = nil
			end
		--Nantes
		elseif home == 216 then
			-- BOR or REN
			if away == 115 or away == 218 then
				choreo = "Choreo\\France\\Nantes"
			else
				choreo = nil
			end
		--Nice
		elseif home == 217 then
			-- MON or BAS
			if away == 112 or away == 210 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Rennais
		elseif home == 218 then
			-- GUI or NAN or BRE
			if away == 211 or away == 216 or away == 1329 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Toulouse
		elseif home == 221 then
			-- BOR
			if away == 115 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Caen
		elseif home == 405 then
			-- HAV
			if away == 413 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Clermont
		elseif home == 407 then
			-- GRE
			if away == 4370 then
				choreo = "Choreo\\France\\Clermont Foot"
			else
				choreo = nil
			end
		--Le Havre
		elseif home == 413 then
			-- SMC
			if away == 405 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Lorient
		elseif home == 414 then
			-- REN
			if away == 218 then
				choreo = "Choreo\\France\\Lorient"
			else
				choreo = nil
			end
		--Saint-Étienne
		elseif home == 418 then
			-- LYO
			if away == 181 then
				choreo = "Choreo\\France\\Saint-Étienne"
			else
				choreo = nil
			end
		--Troyes
		elseif home == 420 then
			-- AUX or REI
			if away == 180 or away == 1330 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Dijon
		elseif home == 1328 then
			-- AUX
			if away == 180 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Brest
		elseif home == 1329 then
			-- GUI or REN
			if away == 211 or away == 218 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Reims
		elseif home == 1330 then
			-- TRO
			if away == 420 then
				choreo = "Choreo\\France\\Stade Reims"
			else
				choreo = nil
			end
		--Valenciennes
		elseif home == 1528 then
			-- LIL
			if away == 213 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Nimes
		elseif home == 1910 then
			-- MNT
			if away == 215 then
				choreo = "Choreo\\France\\Nimes"
			else
				choreo = nil
			end
		--Metz
		elseif home == 4123 then
			-- ASN or STR
			if away == 415 or away == 4213 then
				choreo = "Choreo\\France\\Metz"
			else
				choreo = nil
			end
		--Strasbourg
		elseif home == 4213 then
			-- MET
			if away == 4123 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Grenoble
		elseif home == 4370 then
			-- CLE
			if away == 407 then
				choreo = "Choreo\\France\\Grenoble Foot"
			else
				choreo = nil
			end
		--Copenhagen
		elseif home == 1207 then
			-- BNY or FCN or AAL or FCM or RAN or AAR
			if away == 1832 or away == 1208 or away == 1818 or away == 2069 or away == 2071 or away == 2067 then
				choreo = "Choreo\\Denmark\\Copenhagen"
			else
				choreo = nil
			end
		--Nordsjaelland
		elseif home == 1208 then
			-- AAL or FCK or LYN
			if away == 1818 or away == 1207 or away == 5224 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Aalborg
		elseif home == 1818 then
			-- AAR or BRO or FCK or FCN or MID
			if away == 2067 or away == 1832 or away == 1207 or away == 1208 or away == 2069 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Brondby
		elseif home == 1832 then
			-- FCK or AAR or OB or AAL or FCM
			if away == 1207 or away == 2067 or away == 2070 or away == 1818 or away == 2069 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Horsens
		elseif home == 2066 then
			-- VEJ or AAR
			if away == 5235 or away == 2067 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Aarhus
		elseif home == 2067 then
			-- AAL or BRO or FCK or RAN or MID or HOR
			if away == 1818 or away == 1832 or away == 1207 or away == 2071 or away == 2069 or away == 2066 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Midtjylland
		elseif home == 2069 then
			-- AAL or BRO or FCK or AAR
			if away == 1818 or away == 1832 or away == 1207 or away == 2067 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Randers
		elseif home == 2071 then
			-- FCK or AAR
			if away == 1207 or away == 2067 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Lyngby
		elseif home == 5224	then
			-- FCN
			if away == 1208 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Vejle
		elseif home == 5235	then
			-- ACH
			if away == 2066 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Basel
		elseif home == 1706 then
			if stad == 49 then
				-- YB or FCZ or LUZ
				if away == 1950 or away == 1957 or away == 4962 then
					choreo = "Choreo\\Switzerland\\Basel"
				else
					choreo = nil
				end
			end
		--Young Boys
		elseif home == 1950 then
			-- BAS or FCZ
			if away == 1706 or away == 1957 then
				choreo = "Choreo\\Switzerland\\Young Boys"
			else
				choreo = nil
			end
		--FC Sion
		elseif home == 1955 then
			-- LAU or LUG
			if away == 4964 or away == 4965 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--Zurich
		elseif home == 1957 then
			-- BAS or YB
			if away == 1706 or away == 1950 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--Servette
		elseif home == 1958 then
			-- LAU
			if away == 4964 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--St. Gallen
		elseif home == 4937 then
			-- LUZ
			if away == 4962 then
				choreo = "Choreo\\Switzerland\\St. Gallen"
			else
				choreo = nil
			end
		--Luzern
		elseif home == 4962 then
			-- BAS or SG
			if away == 1706 or away == 4937 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--Lausanne-Sport
		elseif home == 4964 then
			-- SIO or SER
			if away == 1955 or away == 1958 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--FC Lugano
		elseif home == 4965 then
			-- SIO
			if away == 1955 then
				choreo = "Scarf"  
			else
				choreo = nil
			end
		--Anderlecht
		elseif home == 174 then
			-- BRU or GNK or GNT or STA or ZUL 
			if away == 269 or away == 1195 or away == 1196 or away == 1197 or away == 2019 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Club Brugge
		elseif home == 269 then
			-- AND or GNT or STA or CER or ZUL or KVO 
			if away == 174 or away == 1196 or away == 1197 or away == 2009 or away == 2019 or away == 5192 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Genk
		elseif home == 1195 then
			-- AND or STA or STV
			if away == 174 or away == 1197 or away == 5194 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Gent
		elseif home == 1196 then
			-- AND or BRU or STA or ZUL or STV
			if away == 174 or away == 269 or away == 1197 or away == 2019 or away == 5194 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Standard Liege
		elseif home == 1197 then
			-- AND or BRU or GNK or GNT or CHA
			if away == 174 or away == 269 or away == 1195 or away == 1196 or away == 2010 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--KV Mechelen
		elseif home == 1200 then
			-- ANT or OHL
			if away == 5191 or away == 5217 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Cercle Brugge
		elseif home == 2009 then
			-- BRU or KVO
			if away == 269 or away == 5192 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Sporting Cherleroi
		elseif home == 2010 then
			-- STA or REM
			if away == 1197 or away == 5193 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--KV Kortrijk
		elseif home == 2013 then
			-- ZUL
			if away == 2019 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Zulte-Waregem
		elseif home == 2019 then
			-- AND or BRU or GNT or KVK
			if away == 174 or away == 269 or away == 1196 or away == 2013 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Oostende
		elseif home == 5192 then
			-- BRU or CER
			if away == 269 or away == 2009 then
				choreo = "Choreo\\Belgium\\Oostende"
			else
				choreo = nil
			end
		--St Truiden
		elseif home == 5194 then
			-- ZUL
			if away == 1195 or away == 1196 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--OHV Leuven
		elseif home == 5217 then
			-- KVM
			if away == 1200 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Galatasaray
		elseif home == 130 then
			-- FB or BJK
			if away == 197 or away == 273 then
				choreo = "Choreo\\Turkey\\Galatasaray\\League"
			else
				choreo = nil
			end
		--Fenerbahce
		elseif home == 197 then
			if stad == 66 then
				-- GS or BJK or TS
				if away == 130 or away == 273 or away == 1945 then
					choreo = "Choreo\\Turkey\\Fenerbahce\\League"
				else
					choreo = nil
				end
			end
		--Besiktas
		elseif home == 273 then
			-- GS or FB or BFK
			if away == 130 or away == 197 or away == 1995 then
				choreo = "Choreo\\Turkey\\Besiktas"
			else
				choreo = nil
			end
		--Sivasspor
		elseif home == 1809 then
			-- TS or KAY or KON
			if away == 1945 or away == 1996 or away == 5204 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Trabzonspor
		elseif home == 1945 then
			-- FB or SIV
			if away == 197 or away == 1809 then
				choreo = "Choreo\\Turkey\\Trabzonspor"
			else
				choreo = nil
			end
		--İstanbul Başakşehir
		elseif home == 1995 then
			-- BJK
			if away == 273 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Kayserispor
		elseif home == 1996 then
			-- SIV
			if away == 1809 then
				choreo = "Choreo\\Turkey\\Kayserispor"
			else
				choreo = nil
			end
		--Antalyaspor
		elseif home == 1989 then
			-- ALA or HTY
			if away == 5202 or away == 5452 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Kasimpaşa
		elseif home == 2625 then
			-- FKS
			if away == 5652 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Alanyaspor
		elseif home == 5202 then
			-- ANT
			if away == 1989 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Goztepe
		elseif home == 5203 then
			-- ALT
			if away == 5451 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Konyaspor
		elseif home == 5204 then
			-- SIV
			if away == 1809 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Caykur
		elseif home == 5354 then
			-- GIR
			if away == 5357 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Giresunspor
		elseif home == 5357 then
			-- RIZ
			if away == 5354 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Altay
		elseif home == 5451 then
			-- GOZ
			if away == 5203 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Hatayspor
		elseif home == 5452 then
			-- ANT
			if away == 1989 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Fatih Karagümrük
		elseif home == 5652 then
			-- KAS
			if away == 2625 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Benfica
		elseif home == 191 then
			-- POR
			if away == 192 then
				choreo = "Choreo\\Portugal\\Benfica\\League"
			else
				choreo = nil
			end
		--Porto
		elseif home == 192 then
			-- SLB or SCP or BOA
			if away == 191 or away == 193 or away == 4323 then
				choreo = "Choreo\\Portugal\\Porto"
			else
				choreo = nil
			end
		--Sporting FC
		elseif home == 193 then
			-- POR 
			if away == 192 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Vitória Guimarães
		elseif home == 1804 then
			-- BRA or BOA
			if away == 1974 or away == 4323 then
				choreo = "Choreo\\Portugal\\Guimarães"
			else
				choreo = nil
			end
		--Braga
		elseif home == 1974 then
			-- GUI or BOA
			if away == 1804 or away == 4323 then
				choreo = "Choreo\\Portugal\\Braga"
			else
				choreo = nil
			end
		--Gil Vicente
		elseif home == 2387 then
			-- MOR 
			if away == 2388 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Moreirense
		elseif home == 1804 then
			-- GIL or VIZ
			if away == 2387 or away == 5115 then
				choreo = "Choreo\\Portugal\\Moreirense"
			else
				choreo = nil
			end
		--Boavista
		elseif home == 4323 then
			-- POR or GUI or BRA
			if away == 192 or away == 1804 or away == 1974 then
				choreo = "Choreo\\Portugal\\Boavista"
			else
				choreo = nil
			end
		--Vizela
		elseif home == 5115 then
			-- MOR 
			if away == 2388 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Spartak Moskva
		elseif home == 135 then
			-- LMO or CSK or ZSP or DIN
			if away == 271 or away == 1217 or away == 1218 or away == 1753 then
				choreo = "Choreo\\Russia\\Spartak Moskva"
			else
				choreo = nil
			end
		--Lokomotiv Moskva
		elseif home == 271 then
			-- SPM or ZSP or CSK or DMO
			if away == 135 or away == 1218 or away == 1217 or away == 1753 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--CSKA Moskva
		elseif home == 1217 then
			-- SPM or LMO or ZSP or DMO or KRA
			if away == 135 or away == 271 or away == 1218 or away == 1753 or away == 2618 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Zenit
		elseif home == 1218 then
			-- SPM or LMO or CSK or DMO 
			if away == 135 or away == 271 or away == 1217 or away == 1753 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Dinamo Moskva
		elseif home == 1753 then
			-- SPM or LMO or CSK or ZSP 
			if away == 135 or away == 271 or away == 1217 or away == 1218 then
				choreo = "Choreo\\Russia\\Dinamo Moskva\\League"
			else
				choreo = nil
			end
		--Rubin Kazan
		elseif home == 1941 then
			-- KSS
			if away == 4143 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Krasnodar
		elseif home == 2618 then
			-- CSK
			if away == 1217 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Krylia Sovetov Samara
		elseif home == 4143 then
			-- RKA or AKH
			if away == 1941 or away == 5196 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Arsenal Tula
		elseif home == 5197 then
			-- FCU
			if away == 5201 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		--Ural
		elseif home == 5201 then
			-- ARS or KHI
			if away == 5197 or away == 5298 then
				choreo = "Choreo\\Russia\\Ural"
			else
				choreo = nil
			end
		--Khimki
		elseif home == 5298 then
			-- FCU
			if away == 5201 then
				choreo = "Scarf"
			else
				choreo = nil
			end
		end
	else
		choreo = nil
	end

	if choreo ~= nil then
		return string.format("%s:%s", choreo, filename)
	end
end

local function get_filepath(ctx, filename, key)
	if key and choreo ~= nil then
		return string.format("%s\\%s\\%s", fileroot, choreo, filename)
	end
end

function make_log(ctx)
	if choreo ~= nil then
		logResult = choreo
		logResult = string.gsub(logResult, "Choreo\\", "")
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