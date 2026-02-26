--Entrances / Trophies / Animations for PES 2021
--Edited by FuNZoTiK on 06/07/2020
--Edited and corrected by VirtuaRed Team on April 2024

local fileroot = ".\\content\\Entrance"
local entry
local tid

local function set_random(ctx)
	rdm = math.random (1,5)
	tid = ctx.tournament_id
	home = ctx.home_team
	away = ctx.away_team
end

function make_key(ctx, filename)
    	if tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 then
	     entry = 16
	     Entrance = "UEFA Champions League\\Group_Knockout"
	
	elseif tid == 4 then
	     entry = 16
	   if ctx.match_info == 53 then
	      Entrance = "UEFA Champions League\\Final"
	   else
	      Entrance = "UEFA Champions League\\Group_Knockout"
	   end
    elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 or tid == 6 then
	   	 entry = 16
	   if ctx.match_info == 53 then
	      Entrance = "UEFA Europa League\\Final"
	   else
	      Entrance = "UEFA Europa League\\Group_Knockout"
	   end
	elseif tid == 7 then
	     entry = 16
		 Entrance = "UEFA Super Cup"
    elseif tid == 17 then
         entry = 16
			if home == 101 then
				Entrance = "Premier League\\Arsenal"
			elseif home == 107 then
				Entrance = "Premier League\\Aston Villa"
			elseif home == 4071 then
				Entrance = "Premier League\\Bournemouth"
			elseif home == 4180 then
				Entrance = "Premier League\\Brentford"
			elseif home == 377 then
				Entrance = "Premier League\\Brighton"
			elseif home == 378 then
				Entrance = "Premier League\\Burnley"
			elseif home == 102 then
				Entrance = "Premier League\\Chelsea"
			elseif home == 382 then
				Entrance = "Premier League\\Crystal Palace"
			elseif home == 177 then
				Entrance = "Premier League\\Everton"
			elseif home == 178 then
				Entrance = "Premier League\\Fulham"
			elseif home == 103 then
				Entrance = "Premier League\\Liverpool"
			elseif home == 4363 then
				Entrance = "Premier League\\Luton Town"
			elseif home == 173 then
				Entrance = "Premier League\\Man City"
			elseif home == 100 then
				Entrance = "Premier League\\Man Utd"
			elseif home == 106 then
				Entrance = "Premier League\\Newcastle"
			elseif home == 389 then
				Entrance = "Premier League\\Nottingham Forest"
			elseif home == 4194 then
				Entrance = "Premier League\\Sheffield Utd"
			elseif home == 179 then
				Entrance = "Premier League\\Tottenham"
			elseif home == 105 then
				Entrance = "Premier League\\West Ham Utd"
			elseif home == 208 then
				Entrance = "Premier League\\Wolverhampton"
			elseif home == 207 then
				Entrance = "Premier League\\Southampton"
			elseif home == 386 then
				Entrance = "Premier League\\Ipswich Town"
			elseif home == 204 then
				Entrance = "Premier League\\Leicester"
			else
				Entrance = "Premier League\\Generic"
			end
	elseif tid == 20 then
         entry = 16
			if home == 403 then
				Entrance = "Ligue 1\\Angers"
			elseif home == 115 then
				Entrance = "Ligue 1\\Bordeaux"
			elseif home == 1329 then
				Entrance = "Ligue 1\\Brest"
			elseif home == 1328 then
				Entrance = "Ligue 2"
			elseif home == 213 then
				Entrance = "Ligue 1\\Lille"
			elseif home == 414 then
				Entrance = "Ligue 1\\Lorient"
			elseif home == 4123 then
				Entrance = "Ligue 1\\Metz"
			elseif home == 112 then
				Entrance = "Ligue 1\\Monaco"
			elseif home == 215 then
				Entrance = "Ligue 1\\Montpellier"
			elseif home == 181 then
				Entrance = "Ligue 1\\Lyon"
			elseif home == 113 then
				Entrance = "Ligue 1\\Marseille"
			elseif home == 216 then
				Entrance = "Ligue 1\\Nantes"
			elseif home == 217 then
				Entrance = "Ligue 1\\Nice"
			elseif home == 1910 then
				Entrance = "Ligue 1\\Nimes"
			elseif home == 114 then
				Entrance = "Ligue 1\\PSG"
			elseif home == 182 then
				Entrance = "Ligue 1\\Lens"
			elseif home == 218 then
				Entrance = "Ligue 1\\Rennes"
			elseif home == 418 then
				Entrance = "Ligue 1\\Saint Etienne"
			elseif home == 1330 then
				Entrance = "Ligue 1\\Reims"
			elseif home == 4213 then
				Entrance = "Ligue 1\\Strasbourg"
			else
				Entrance = "Ligue 1\\Generic"
			end
	elseif tid == 81 then
         entry = 16
		 Entrance = "Ligue 2"
	elseif tid == 26 then
         entry = 16
		 Entrance = "Coupe De La Ligue"
	elseif tid == 118 then
         entry = 16
		 Entrance = "Super Lig"
	elseif tid == 23 then
         entry = 16
	     Entrance = "FA Cup"
	elseif tid == 18 then
         entry = 16
	     Entrance = "Serie A"
	elseif tid == 82 or tid == 85 then
         entry = 16
	     Entrance = "Serie B"
	elseif tid == 21 then
         entry = 16
		 Entrance = "Eredivisie"
	elseif tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159 then
         entry = 16
		 Entrance = "Jupiler Pro League"
	elseif tid == 50 then
         entry = 16
		 Entrance = "Bundesliga"
	elseif tid == 53 then
         entry = 16
	     Entrance = "DFB Pokal"
	elseif tid == 95 then
         entry = 16
	     Entrance = "DFL Supercup"
	elseif tid == 59 then
	 	 entry = 16
	     if ctx.match_info == 53 then
			Entrance = "Copa Argentina\\Final"
		 else
			Entrance = "Copa Argentina\\Eliminatorias"
		 end 
	elseif tid == 30 then
		if home == 138 or home == 2722 then
			entry = 16
			Entrance = "LPFv2 - Arriba"	
		else
        	entry = 16
		 	Entrance = "LPFv2"
		end
	elseif tid == 8 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 9 or tid == 1033 or tid == 2057 or tid == 3081 or tid == 4105 or tid == 5129  or tid == 6153 or tid == 7177 or tid == 8201 or tid == 10 then
		 entry = 16
		 if ctx.match_info == 53 then
			Entrance = "Copa Libertadores\\Final"
		 else
			Entrance = "Copa Libertadores\\Group_Knockout"
		 end

	elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 then
          entry = 42
          		Entrance = "FIFA World Cup\\Group Stage"
      elseif tid == 34 or tid == 35 then
	     entry = 42
	     	 if ctx.match_info == 53 then
			Entrance = "FIFA World Cup\\Final"
		else
			Entrance = "FIFA World Cup\\Knockout"
		end
    elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 then
         entry = 42
		 if ctx.match_info == 53 then
			Entrance = "UEFA Euro\\Final"
		 else
			Entrance = "UEFA Euro\\Group_Knockout"
		 end
	elseif tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176 then
		 entry = 42
		 if ctx.match_info == 53 then
			Entrance = "Copa America\\Final"
		 else
			Entrance = "Copa America\\Group_Knockout"
		 end
		elseif tid == 44 or tid == 1068 or tid == 2092 or tid == 3116 or tid == 4140 then
		entry = 42
			Entrance = "AFC Asian Cup\\Regular_Fase"
		elseif tid == 45 then
		entry = 42
			if ctx.match_info == 53 then
				Entrance = "AFC Asian Cup\\Final"
			else
				Entrance = "AFC Asian Cup\\Knockout"
		end
	elseif tid == 46 then
		entry = 42
			if ctx.match_info == 46 then
				Entrance = "Africa Cup of Nations\\Knockout"
			else
			if ctx.match_info == 53 then
				Entrance = "Africa Cup of Nations\\Final"
			else
			Entrance = "Africa Cup of Nations\\Knockout"
			end
	end	
	elseif tid == 1 then
entry = 16
if ctx.match_info == 53 then
Entrance = "FIFA Club World Cup\\Final"
else
Entrance = "FIFA Club World Cup\\Knockout"
end

elseif tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239 then
entry = 16
Entrance = "FIFA Club World Cup\\Groupstage"
elseif tid == 47 or tid == 48 then
entry = 16
if ctx.match_info == 53 then
Entrance = "FIFA Club World Cup\\Final"
else
Entrance = "FIFA Club World Cup\\Knockout"
end

	--elseif tid == 105 or tid == 106 or tid == 107 then
         --entry = 16
		 --Entrance = "International Champions Cup"
	elseif tid == 79 then
         entry = 16
		 Entrance = "EFL\\Championship"
	elseif tid == 83 then
         entry = 16
		 Entrance = "EFL\\Play-Off"
	elseif tid == 86 then
         entry = 16
		 Entrance = "Community Shield"
        elseif tid == 19 then
         entry = 16
			if home == 108 then
				Entrance = "LaLiga\\Fc Barcelona"
			elseif home == 109 then
				Entrance = "LaLiga\\Real Madrid"
			elseif home == 265 then
				Entrance = "LaLiga\\Sevilla"
			elseif home == 258 then
				Entrance = "LaLiga\\Bilbao"
			elseif home == 366 then
				Entrance = "LaLiga\\Levante UD"
			elseif home == 172 then
				Entrance = "LaLiga\\Atletico"
			elseif home == 1765 then
				Entrance = "LaLiga\\Granada"
			elseif home == 196 then
				Entrance = "LaLiga\\Sociedad"
			elseif home == 194 then
				Entrance = "LaLiga\\Betis"
			elseif home == 267 then
				Entrance = "LaLiga\\Villareal"
			elseif home == 4146 then
				Entrance = "LaLiga\\Eibar"
			elseif home == 4145 then
				Entrance = "LaLiga\\Alaves"
			elseif home == 110 then
				Entrance = "LaLiga\\Valencia"
			elseif home == 362 then
				Entrance = "LaLiga\\Getafe"
			elseif home == 195 then
				Entrance = "LaLiga\\Celta"
			elseif home == 266 then
				Entrance = "LaLiga\\Valladolid"
			elseif home == 4308 then
				Entrance = "LaLiga\\Cadiz"
			elseif home == 261 then
				Entrance = "LaLiga\\Mallorca"
			elseif home == 4272 then
				Entrance = "LaLiga\\Leganes"
			elseif home == 259 then
				Entrance = "LaLiga\\Espanyol"
			elseif home == 2187 then
				Entrance = "LaLiga\\Girona"
			elseif home == 363 then
				Entrance = "LaLiga\\Sporting"
			elseif home == 2188 then
				Entrance = "LaLiga\\Huesca"
			elseif home == 361 then
				Entrance = "LaLiga\\Elche"
			elseif home == 263 then
				Entrance = "LaLiga\\Osasuna"
			elseif home == 364 then
				Entrance = "LaLiga\\Las Palmas"
			elseif home == 260 then
				Entrance = "LaLiga\\Malaga"
			elseif home == 2393 then
				Entrance = "LaLiga\\Alcorcon"
			elseif home == 370 then
				Entrance = "LaLiga\\Rayo Vallecano"
			elseif home == 261 then
				Entrance = "LaLiga\\Mallorca"
			elseif home == 4272 then
				Entrance = "LaLiga\\Leganes"
			elseif home == 259 then
				Entrance = "LaLiga\\Espanyol"
			elseif home == 2187 then
				Entrance = "LaLiga\\Girona"
			elseif home == 363 then
				Entrance = "LaLiga\\Sporting"
			elseif home == 2188 then
				Entrance = "LaLiga\\Huesca"
			elseif home == 361 then
				Entrance = "LaLiga\\Elche"
			elseif home == 364 then
				Entrance = "LaLiga\\Las Palmas"
			elseif home == 260 then
				Entrance = "LaLiga\\Malaga"
			elseif home == 2393 then
				Entrance = "LaLiga\\Alcorcon"
			elseif home == 4146 then
				Entrance = "LaLiga\\Eibar"
			elseif home == 4145 then
				Entrance = "LaLiga\\Alaves"
			elseif home == 266 then
				Entrance = "LaLiga\\Valladolid"
			elseif home == 4308 then
				Entrance = "LaLiga\\Cadiz"
			elseif home == 370 then
				Entrance = "LaLiga\\Rayo Vallecano"
			elseif home == 357 then
				Entrance = "LaLiga\\Almeria"
			elseif home == 4147 then
				Entrance = "LaLiga\\Tenerife"
			elseif home == 4264 then
				Entrance = "LaLiga\\Amorebieta"
			elseif home == 5644 then
				Entrance = "LaLiga\\Andorra"
			elseif home == 2616 then
				Entrance = "LaLiga\\Mirandes"
			elseif home == 4247 then
				Entrance = "LaLiga\\Burgos"
			elseif home == 4309 then
				Entrance = "LaLiga\\Cartagena"
			elseif home == 4988 then
				Entrance = "LaLiga\\Eldense"
			elseif home == 4301 then
				Entrance = "LaLiga\\Villareal"
			elseif home == 268 then
				Entrance = "LaLiga\\Zaragoza"
			elseif home == 264 then
				Entrance = "LaLiga\\Racing Santander"
			elseif home == 4302 then
				Entrance = "LaLiga\\Albacete"
			else
				Entrance = "LaLiga\\Generic"
			end
	elseif tid == 80 then
         entry = 16
			if home == 108 then
				Entrance = "LaLiga\\Fc Barcelona"
			elseif home == 109 then
				Entrance = "LaLiga\\Real Madrid"
			elseif home == 265 then
				Entrance = "LaLiga\\Sevilla"
			elseif home == 258 then
				Entrance = "LaLiga\\Bilbao"
			elseif home == 366 then
				Entrance = "LaLiga\\Levante UD"
			elseif home == 172 then
				Entrance = "LaLiga\\Atletico"
			elseif home == 1765 then
				Entrance = "LaLiga\\Granada"
			elseif home == 196 then
				Entrance = "LaLiga\\Sociedad"
			elseif home == 194 then
				Entrance = "LaLiga\\Betis"
			elseif home == 267 then
				Entrance = "LaLiga\\Villareal"
			elseif home == 4146 then
				Entrance = "LaLiga\\Eibar"
			elseif home == 4145 then
				Entrance = "LaLiga\\Alaves"
			elseif home == 110 then
				Entrance = "LaLiga\\Valencia"
			elseif home == 362 then
				Entrance = "LaLiga\\Getafe"
			elseif home == 195 then
				Entrance = "LaLiga\\Celta"
			elseif home == 266 then
				Entrance = "LaLiga\\Valladolid"
			elseif home == 4308 then
				Entrance = "LaLiga\\Cadiz"
			elseif home == 261 then
				Entrance = "LaLiga\\Mallorca"
			elseif home == 4272 then
				Entrance = "LaLiga\\Leganes"
			elseif home == 259 then
				Entrance = "LaLiga\\Espanyol"
			elseif home == 2187 then
				Entrance = "LaLiga\\Girona"
			elseif home == 363 then
				Entrance = "LaLiga\\Sporting"
			elseif home == 2188 then
				Entrance = "LaLiga\\Huesca"
			elseif home == 361 then
				Entrance = "LaLiga\\Elche"
			elseif home == 263 then
				Entrance = "LaLiga\\Osasuna"
			elseif home == 364 then
				Entrance = "LaLiga\\Las Palmas"
			elseif home == 260 then
				Entrance = "LaLiga\\Malaga"
			elseif home == 2393 then
				Entrance = "LaLiga\\Alcorcon"
			elseif home == 370 then
				Entrance = "LaLiga\\Rayo Vallecano"
			elseif home == 261 then
				Entrance = "LaLiga\\Mallorca"
			elseif home == 4272 then
				Entrance = "LaLiga\\Leganes"
			elseif home == 259 then
				Entrance = "LaLiga\\Espanyol"
			elseif home == 2187 then
				Entrance = "LaLiga\\Girona"
			elseif home == 363 then
				Entrance = "LaLiga\\Sporting"
			elseif home == 2188 then
				Entrance = "LaLiga\\Huesca"
			elseif home == 361 then
				Entrance = "LaLiga\\Elche"
			elseif home == 364 then
				Entrance = "LaLiga\\Las Palmas"
			elseif home == 260 then
				Entrance = "LaLiga\\Malaga"
			elseif home == 2393 then
				Entrance = "LaLiga\\Alcorcon"
			elseif home == 4146 then
				Entrance = "LaLiga\\Eibar"
			elseif home == 4145 then
				Entrance = "LaLiga\\Alaves"
			elseif home == 266 then
				Entrance = "LaLiga\\Valladolid"
			elseif home == 4308 then
				Entrance = "LaLiga\\Cadiz"
			elseif home == 370 then
				Entrance = "LaLiga\\Rayo Vallecano"
			elseif home == 357 then
				Entrance = "LaLiga\\Almeria"
			elseif home == 4147 then
				Entrance = "LaLiga\\Tenerife"
			elseif home == 4264 then
				Entrance = "LaLiga\\Amorebieta"
			elseif home == 5644 then
				Entrance = "LaLiga\\Andorra"
			elseif home == 2616 then
				Entrance = "LaLiga\\Mirandes"
			elseif home == 4247 then
				Entrance = "LaLiga\\Burgos"
			elseif home == 4309 then
				Entrance = "LaLiga\\Cartagena"
			elseif home == 4988 then
				Entrance = "LaLiga\\Eldense"
			elseif home == 4301 then
				Entrance = "LaLiga\\Villareal"
			elseif home == 268 then
				Entrance = "LaLiga\\Zaragoza"
			elseif home == 264 then
				Entrance = "LaLiga\\Racing Santander"
			elseif home == 4302 then
				Entrance = "LaLiga\\Albacete"
			else
				Entrance = "LaLiga Smartbank\\Championship"
			end
	elseif tid == 84 then
         entry = 16
		 Entrance = "LaLiga Smartbank\\Play-Off"
	elseif tid == 25 then
         entry = 16
		 if ctx.match_info == 53 then
			Entrance = "Copa del Rey\\Final"
		 else
			Entrance = "Copa del Rey\\Group_Knockout"
		 end
	elseif tid == 87 then
         entry = 16
		 Entrance = "Supercopa de Espana"
	elseif tid == 88 then
         entry = 16
		 Entrance = "Trophee des Champions"
	elseif tid == 22 then
         entry = 16
		 Entrance = "Liga NOS"
	elseif tid == 24 then
         entry = 16
		 Entrance = "Coppa Italia"
	elseif tid == 89 then
         entry = 16
		 Entrance = "Supercoppa Italiana"
	elseif tid == 27 then
         entry = 16
		 Entrance = "KNVB Beker"
	elseif tid == 90 then
         entry = 21
		 Entrance = "Johan Cruijff Schaal"
	elseif tid == 28 then
         entry = 16
		 Entrance = "Taca de Portugal"
	elseif tid == 91 then
         entry = 16
		 Entrance = "Supertaca Candido de Oliveira"
	elseif tid == 116 then
         entry = 16
		 Entrance = "Russian Premier League"
	elseif tid == 123 then
         entry = 16
		 Entrance = "Russian Cup"
	elseif tid == 123 then
         entry = 16
		 Entrance = "Russian Super Cup"
	elseif tid == 117 then
         entry = 16
		 Entrance = "Raiffeisen SL"
	--elseif tid == 124 then
         --entry = 16
		 --Entrance = "Swiss Cup"
	--elseif tid == 112 then
         --entry = 16
		 --Entrance = "Crocky Cup"
	--elseif tid == 128 then
         --entry = 16
		 --Entrance = "Belgian Super Cup"
	--elseif tid == 125 then
         --entry = 16
		 --Entrance = "Turkish Cup"
	--elseif tid == 130 then
         --entry = 16
		 --Entrance = "Turkish Super Cup"
	elseif tid == 141 or tid == 142 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151 then
         entry = 16
		 Entrance = "Danish Superliga"
	elseif tid == 133 or tid == 134 or tid == 135 or tid == 136 then
         entry = 16
		 Entrance = "SPFL"
	elseif tid == 137 then
         entry = 16
		 Entrance = "Scottish Cup"
	elseif tid == 119 or tid == 23800 or tid == 23801 or tid == 160 or tid == 161 or tid == 168 or tid == 169 then
         entry = 16
   		Entrance = "Categoria Primera A"
 	elseif tid == 126 then
         entry = 16
   		Entrance = "Copa Colombia"
 	elseif tid == 131 then
         entry = 16
  		 Entrance = "Superliga de Colombia"
	elseif tid == 67 or tid == 13400 or tid == 13401 then
         entry = 16
		 Entrance = "Campeonato AFP Planvital"
	elseif tid == 68 then
         entry = 16
		 Entrance = "Copa Chile"
	elseif tid == 92 then
         entry = 16
		 Entrance = "Supercopa Argentina"
	elseif tid == 29 then
         entry = 16
		 Entrance = "Brasileirao Serie A"
	elseif tid == 163 then
         entry = 16
		 Entrance = "Brasileirao Serie B"
	elseif tid == 31 then
         entry = 16
		 if ctx.match_info == 53 then
			Entrance = "Copa do Brasil\\Final"
		 else
			Entrance = "Copa do Brasil\\Group_Knockout"
		 end
	elseif tid == 51 then
         entry = 16
		 Entrance = "MLS"
	elseif tid == 54 then
         entry = 16
		 Entrance = "MLS_Cup"		 
	elseif tid == 52 or tid == 55 or tid == 97 then
         entry = 16
		 Entrance = "J1 League"	 		 
	elseif tid == 125 then
	    entry = 16
		  Entrance = "Chinese Super League"		 
	elseif tid == 36 or tid == 1060 or tid == 2084 or tid == 3108 or tid == 4142 or tid == 5156 or tid == 6180 or tid == 7204 or tid == 8228 then
		 Entrance = "European Qualifiers"
	elseif tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239 or tid == 48 then
         entry = 16
		 Entrance = "FCWC 25"	


    elseif tid == 65535 or tid == 9400 or tid == 9401 or tid == 9402 or tid == 9403 or tid == 9404 or tid == 9405 or tid == 9406 or tid == 9407 then



--Exhibition


--Premier League Teams

		 if home == 101 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Arsenal"
		 elseif home == 107 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Aston Villa"
		 elseif home == 4071 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Bournemouth"
		 elseif home == 4180 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Brentford"
		 elseif home == 377 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Brighton"
		 elseif home == 378 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Burnley"
		 elseif home == 102 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Chelsea"
		 elseif home == 382 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Crystal Palace"
		 elseif home == 177 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Everton"
		 elseif home == 178 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Fulham"
		 elseif home == 103 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Liverpool"
		 elseif home == 4363 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Luton Town"
		 elseif home == 173 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Man City"
		 elseif home == 100 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Man Utd"
		 elseif home == 106 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Newcastle"
		 elseif home == 389 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Nottingham Forest"
		 elseif home == 4194 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Sheffield Utd"
		 elseif home == 179 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Tottenham"
		 elseif home == 105 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\West Ham Utd"
		 elseif home == 208 and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Wolverhampton"


--Premier League Generic


	     elseif (home == 101 or home == 107 or home == 4071 or home == 4180 or home == 377 or home == 378 or home == 102 or home == 382 or home == 177 or home == 178 or home == 103 or home == 4363 or home == 173 or home == 100 or home == 106 or home == 389 or home == 4194 or home == 179 or home == 105 or home == 208) and (away == 101 or away == 107 or away == 4071 or away == 4180 or away == 377 or away == 378 or away == 102 or away == 382 or away == 177 or away == 178 or away == 103 or away == 4363 or away == 173 or away == 100 or away == 106 or away == 389 or away == 4194 or away == 179 or away == 105 or away == 208) then
		 	 entry = 16
			 Entrance = "Premier League\\Generic"
--EFL

		 elseif (home == 201 or home == 176 or home == 1761 or home == 1760 or home == 378 or home == 379 or home == 4183 or home == 2610 or home == 1589 or home == 4363 or home == 205 or home == 387 or home == 388 or home == 4192 or home == 1327 or home == 391 or home == 4193 or home == 4194 or home == 395 or home == 396 or home == 1909 or home == 398 or home == 399 or home == 400) and (away == 201 or away == 176 or away == 1761 or away == 1760 or away == 378 or away == 379 or away == 4183 or away == 2610 or away == 1589 or away == 4363 or away == 205 or away == 387 or away == 388 or away == 4192 or away == 1327 or away == 391 or away == 4193 or away == 4194 or away == 395 or away == 396 or away == 1909 or away == 398 or away == 399 or away == 400) then
	         entry = 16
	         Entrance = "EFL\\Championship"

--Ligue 1

		 elseif (home == 112 or home == 113 or home == 114 or home == 180 or home == 181 or home == 182 or home == 213 or home == 215 or home == 216 or home == 217 or home == 218 or home == 221 or home == 403 or home == 413 or home == 418 or home == 1329 or home == 1330 or home == 4213) and (away == 112 or away == 113 or away == 114 or away == 180 or away == 181 or away == 182 or away == 213 or away == 215 or away == 216 or away == 217 or away == 218 or away == 221 or away == 403 or away == 413 or away == 418 or away == 1329 or away == 1330 or away == 4213) then
			entry = 16
			Entrance = "Ligue 1\\Generic"

--Ligue 2

	     elseif (home == 4200 or home == 5685 or home == 210 or home == 405 or home == 1328 or home == 4370 or home == 211 or home == 412 or home == 413 or home == 4123 or home == 1910 or home == 416 or home == 4211 or home == 5099 or home == 5100 or home == 4372 or home == 418 or home == 219 or home == 1528) and (away == 4200 or away == 5685 or away == 210 or away == 405 or away == 1328 or away == 4370 or away == 211 or away == 412 or away == 413 or away == 4123 or away == 1910 or away == 416 or away == 4211 or away == 5099 or away == 5100 or away == 4372 or away == 418 or away == 219 or away == 1528) then
		 	entry = 16
			Entrance = "Ligue 2"

--Serie A

	     elseif (home == 121 or home == 234 or home == 186 or home == 4220 or home == 235 or home == 124 or home == 119 or home == 1600 or home == 122 or home == 4237 or home == 240 or home == 4914 or home == 327 or home == 120 or home == 125 or home == 4244 or home == 1919 or home == 333 or home == 190 or home == 336) and (away == 121 or away == 234 or away == 186 or away == 4220 or away == 235 or away == 124 or away == 119 or away == 1600 or away == 122 or away == 4237 or away == 240 or away == 4914 or away == 327 or away == 120 or away == 125 or away == 4244 or away == 1919 or away == 333 or away == 190 or away == 336) then
		 	 entry = 16
			 Entrance = "Serie A"

--Serie B

	     elseif (home == 317 or home == 319 or home == 4232 or home == 187 or home == 320 or home == 1920 or home == 4219 or home == 4928 or home == 4234 or home == 323 or home == 237 or home == 238 or home == 123 or home == 4240 or home == 4241 or home == 239 or home == 4923 or home == 4228 or home == 331 or home == 4229) and (away == 317 or away == 319 or away == 4232 or away == 187 or away == 320 or away == 1920 or away == 4219 or away == 4928 or away == 4234 or away == 323 or away == 237 or away == 238 or away == 123 or away == 4240 or away == 4241 or away == 239 or away == 4923 or away == 4228 or away == 331 or away == 4229) then
		 	 entry = 16
			 Entrance = "Serie B"

--La Liga Teams

		 elseif home == 108 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Fc Barcelona"
		 elseif home == 109 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Real Madrid"
		 elseif home == 265 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Sevilla"
		 elseif home == 258 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Bilbao"
		 elseif home == 366 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Levante UD"
		 elseif home == 172 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Atletico"
		 elseif home == 1765 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Granada"
		 elseif home == 196 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Sociedad"
		 elseif home == 194 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Betis"
		 elseif home == 267 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Villareal"
		 elseif home == 4146 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Eibar"
		 elseif home == 4145 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Alaves"
		 elseif home == 110 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Valencia"
		 elseif home == 362 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Getafe"
		 elseif home == 195 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Celta"
		 elseif home == 266 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Valladolid"
		 elseif home == 4308 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Cadiz"
		 elseif home == 2188 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Huesca"
		 elseif home == 361 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Elche"
		 elseif home == 263 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Osasuna"
		 elseif home == 370 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Rayo Vallecano"
		 elseif home == 4272 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Leganes"
		 elseif home == 261 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Mallorca"
		 elseif home == 259 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Espanyol"
		 elseif home == 2187 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Girona"
		 elseif home == 363 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Sporting"
		 elseif home == 364 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Las Palmas"
		 elseif home == 260 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Malaga"
		 elseif home == 2393 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Alcorcon"
		 elseif home == 357 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Almeria"
		 elseif home == 4147 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Tenerife"
		 elseif home == 4264 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Amorebieta"
		 elseif home == 5644 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Andorra"
		 elseif home == 2616 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Mirandes"
		 elseif home == 4247 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Burgos"
		 elseif home == 4309 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Cartagena"
		 elseif home == 4988 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Eldense"
		 elseif home == 4301 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Villareal"
		 elseif home == 268 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Zaragoza"
		 elseif home == 264 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Racing Santander"
		 elseif home == 4302 and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267 or away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga\\Albacete"

--La Liga Generic

		 elseif (home == 357 or home == 258 or home == 4308 or home == 361 or home == 108 or home == 362 or home == 2187 or home == 259 or home == 109 or home == 172 or home == 261 or home == 263 or home == 265 or home == 194 or home == 110 or home == 266 or home == 370 or home == 196 or home == 195 or home == 267) and (away == 357 or away == 258 or away == 4308 or away == 361 or away == 108 or away == 362 or away == 2187 or away == 259 or away == 109 or away == 172 or away == 261 or away == 263 or away == 265 or away == 194 or away == 110 or away == 266 or away == 370 or away == 196 or away == 195 or away == 267) then
		 	 entry = 16
			 Entrance = "LaLiga\\Generic"

--La Liga Smartbank

		 elseif (home == 4145 or home == 4302 or home == 5644 or home == 4247 or home == 4309 or home == 4146 or home == 363 or home == 1765 or home == 2188 or home == 5572 or home == 364 or home == 4272 or home == 366 or home == 2615 or home == 260 or home == 2616 or home == 4260 or home == 1595 or home == 264 or home == 4147 or home == 4301 or home == 268) and (away == 4145 or away == 4302 or away == 5644 or away == 4247 or away == 4309 or away == 4146 or away == 363 or away == 1765 or away == 2188 or away == 5572 or away == 364 or away == 4272 or away == 366 or away == 2615 or away == 260 or away == 2616 or away == 4260 or away == 1595 or away == 264 or away == 4147 or away == 4301 or away == 268) then
		 	 entry = 16
			 Entrance = "LaLiga Smartbank\\Championship"

--Bundesliga

		elseif (home == 126 or home == 127 or home == 128 or home == 185 or home == 225 or home == 226 or home == 227 or home == 231 or home == 232 or home == 436 or home == 4124 or home == 4126 or home == 4128 or home == 4137 or home == 4140 or home == 5008 or home == 5009 or home == 5010) and (away == 126 or away == 127 or away == 128 or away == 185 or away == 225 or away == 226 or away == 227 or away == 231 or away == 232 or away == 436 or away == 4124 or away == 4126 or away == 4128 or away == 4137 or away == 4140 or away == 5008 or away == 5009 or away == 5010) then
			entry = 16
			Entrance = "Bundesliga"

--Liga NOS

		elseif (home == 2380 or home == 191 or home == 4323 or home == 5633 or home == 4085 or home == 2383 or home == 5028 or home == 2387 or home == 1976 or home == 1978 or home == 2369 or home == 192 or home == 1979 or home == 2391 or home == 1974 or home == 193 or home == 1804 or home == 5115) and (away == 2380 or away == 191 or away == 4323 or away == 5633 or away == 4085 or away == 2383 or away == 5028 or away == 2387 or away == 1976 or away == 1978 or away == 2369 or away == 192 or away == 1979 or away == 2391 or away == 1974 or away == 193 or away == 1804 or away == 5115) then
		 	 entry = 16
			 Entrance = "Liga NOS"	

--Brasileirao Serie A

		elseif (home == 1930 or home == 2451 or home == 1245 or home == 2453 or home == 1246 or home == 5671 or home == 274 or home == 5142 or home == 1247 or home == 1248 or home == 1249 or home == 5143 or home == 1250 or home == 1252 or home == 5137 or home == 137 or home == 2459 or home == 1255 or home == 136 or home == 1937) and (away == 1930 or away == 2451 or away == 1245 or away == 2453 or away == 1246 or away == 5671 or away == 274 or away == 5142 or away == 1247 or away == 1248 or away == 1249 or away == 5143 or away == 1250 or away == 1252 or away == 5137 or away == 137 or away == 2459 or away == 1255 or away == 136 or away == 1937) then
		 	 entry = 16
			 Entrance = "Brasileirao Serie A"

--Brasileirao Serie B

		 elseif (home == 2453 or home == 5660 or home == 4108 or home == 2506 or home == 2460 or home == 274 or home == 5141 or home == 1250 or home == 1251 or home == 5661 or home == 5048 or home == 1935 or home == 5768 or home == 5433 or home == 2465 or home == 136 or home == 4111 or home == 1936 or home == 5147 or home == 2468) and (away == 2452 or away == 1246 or away == 5047 or away == 5660 or away == 5140 or away == 1931 or away == 2506 or away == 274 or away == 5141 or away == 1933 or away == 1251 or away == 5048 or away == 1935 or away == 5433 or away == 2465 or away == 5145 or away == 4111 or away == 136 or away == 2468 or away == 1937) then
		 	 entry = 16
			 Entrance = "Brasileirao Serie B"

--Campeonato AFP Planvital

		 elseif (home == 2192 or home == 2553 or home == 1256 or home == 2707 or home == 2708 or home == 2547 or home == 2544 or home == 2208 or home == 2545 or home == 2699 or home == 2541 or home == 2548 or home == 2360 or home == 2546 or home == 2191 or home == 2209) and (away == 2192 or away == 2553 or away == 1256 or away == 2707 or away == 2708 or away == 2547 or away == 2544 or away == 2208 or away == 2545 or away == 2699 or away == 2541 or away == 2548 or away == 2360 or away == 2546 or away == 2191 or away == 2209) then
		 	 entry = 16
			 Entrance = "Campeonato AFP Planvital"

--Super Lig

		 elseif (home == 5202 or home == 5360 or home == 1989 or home == 273 or home == 5355 or home == 197 or home == 130 or home == 5356 or home == 1230 or home == 5203 or home == 1995 or home == 2625 or home == 1996 or home == 5204 or home == 5354 or home == 1809 or home == 1945 or home == 5206 or home == 5652 or home == 5452 or home == 5353) and (away == 5202 or away == 5360 or away == 1989 or away == 273 or away == 5355 or away == 197 or away == 130 or away == 5356 or away == 1230 or away == 5203 or away == 1995 or away == 2625 or away == 1996 or away == 5204 or away == 5354 or away == 1809 or away == 1945 or away == 5206 or away == 5652 or away == 5452 or away == 5206) then
		 	 entry = 16
			 Entrance = "Super Lig"

--Russian Premier League

		 elseif (home == 5196 or home == 5197 or home == 1217 or home == 1753 or home == 2618 or home == 5298 or home == 271 or home == 5302 or home == 2229 or home == 1941 or home == 5296 or home == 135 or home == 5306 or home == 5200 or home == 5201 or home == 1218) and (away == 5196 or away == 5197 or away == 1217 or away == 1753 or away == 2618 or away == 5298 or away == 271 or away == 5302 or away == 2229 or away == 1941 or away == 5296 or away == 135 or away == 5306 or away == 5200 or away == 5201 or away == 1218) then
		 	 entry = 16
			 Entrance = "Russian Premier League"

--LPF Argentina

		 elseif (home == 138 or home == 2722) and (away == 1236 or away == 5454 or away == 4034 or away == 1921 or away == 2719 or away == 1927 or away == 139 or away == 4995 or away == 1923 or away == 2722 or away == 1238 or away == 1239 or away == 1924 or away == 1922 or away == 1240 or away == 1929 or away == 1241 or away == 1237 or away == 138 or away == 1242 or away == 1243 or away == 5046 or away == 2538 or away == 1244) then
			entry = 16
			Entrance = "LPFv2 - Arriba"
		 elseif (home == 1236 or home == 1921 or home == 2719 or home == 1927 or home == 139 or home == 4995 or home == 1923 or home == 2722 or home == 1238 or home == 1239 or home == 1924 or home == 1922 or home == 1240 or home == 5454 or home == 4034 or home == 1929 or home == 1241 or home == 1237 or home == 1242 or home == 1243 or home == 5046 or home == 2538 or home == 1244) and (away == 5454 or away == 4034 == 1236 or away == 1921 or away == 2719 or away == 1927 or away == 139 or away == 4995 or away == 1923 or away == 2722 or away == 1238 or away == 1239 or away == 1924 or away == 1922 or away == 1240 or away == 1929 or away == 1241 or away == 1237 or away == 138 or away == 1242 or away == 1243 or away == 5046 or away == 2538 or away == 1244) then
			entry = 16
			Entrance = "LPFv2"

--Jupiler Pro League

		 elseif (home == 174 or home == 5191 or home == 2009 or home == 269 or home == 1195 or home == 1196 or home == 5190 or home == 2013 or home == 5192 or home == 1200 or home == 5193 or home == 5194 or home == 2010 or home == 1197 or home == 5195 or home == 2019 or home == 5217 or home == 5216) and (away == 174 or away == 5191 or away == 2009 or away == 269 or away == 1195 or away == 1196 or away == 5190 or away == 2013 or away == 5192 or away == 1200 or away == 5193 or away == 5194 or away == 2010 or away == 1197 or away == 5195 or away == 2019 or away == 5217 or away == 5216) then
		 	 entry = 16
			 Entrance = "Jupiler Pro League"

--Campeonato AFP Planvital

		elseif (home == 2192 or home == 2553 or home == 1256 or home == 2708 or home == 2547 or home == 2544 or home == 5389 or home == 2208 or home == 2545 or home == 2699 or home == 2541 or home == 2548 or home == 2542 or home == 2360 or home == 2546 or home == 2191 or home == 2209) and (away == 2192 or away == 2553 or away == 1256 or away == 2708 or away == 2547 or away == 2544 or away == 5389 or away == 2208 or away == 2545 or away == 2699 or away == 2541 or away == 2548 or away == 2542 or away == 2360 or away == 2546 or away == 2191 or away == 2209) then
		 	 entry = 16
			 Entrance = "Campeonato AFP Planvital"


--Chinese League

		elseif (home == 295 or home == 5168 or home == 4092 or home == 310 or home == 4943 or home == 5170 or home == 5171 or home == 306 or home == 5183 or home == 4168 or home == 5173 or home == 4094 or home == 5184 or home == 5185 or home == 5175 or home == 4095) and (away == 295 or away == 5168 or away == 4092 or away == 310 or away == 4943 or away == 5170 or away == 5171 or away == 306 or away == 5183 or away == 4168 or away == 5173 or away == 4094 or away == 5184 or away == 5185 or away == 5175 or away == 4095) then
			entry = 16
			Entrance = "Chinese Super League"

--National Teams

		 elseif (home == 1 or home == 2 or home == 3 or home == 4 or home == 5 or home == 6 or home == 7 or home == 8 or home == 9 or home == 10 or home == 11 or home == 12 or home == 13 or home == 14 or home == 15 or home == 16 or home == 17 or home == 18 or home == 19 or home == 20 or home == 21 or home == 22 or home == 23 or home == 24 or home == 26 or home == 27 or home == 28 or home == 29 or home == 30 or home == 31 or home == 32 or home == 33 or home == 34 or home == 35 or home == 36 or home == 37 or home == 38 or home == 39 or home == 40 or home == 41 or home == 42 or home == 43 or home == 44 or home == 45 or home == 46 or home == 47 or home == 48 or home == 49 or home == 50 or home == 51 or home == 52 or home == 53 or home == 54 or home == 55 or home == 56 or home == 57 or home == 59 or home == 1010 or home == 1011 or home == 1012 or home == 1013 or home == 1015 or home == 1022 or home == 1026 or home == 1031 or home == 1032 or home == 1040 or home == 1044 or home == 1050 or home == 1051 or home == 1056 or home == 1058 or home == 1059 or home == 1067 or home == 1083 or home == 1099 or home == 1113 or home == 1128 or home == 1129 or home == 1141 or home == 1164 or home == 1165 or home == 1166 or home == 1167 or home == 1168 or home == 1169 or home == 1171 or home == 1172 or home == 1173 or home == 1174  or home == 1175 or home == 1176 or home == 1177 or home == 1178 or home == 1179 or home == 1180 or home == 1181 or home == 1182 or home == 1183 or home == 1550 or home == 1551 or home == 5439 or home == 5440) and (away == 1 or away == 2 or away == 3 or away == 4 or away == 5 or away == 6 or away == 7 or away == 8 or away == 9 or away == 10 or away == 11 or away == 12 or away == 13 or away == 14 or away == 15 or away == 16 or away == 17 or away == 18 or away == 19 or away == 20 or away == 21 or away == 22 or away == 23 or away == 24 or away == 26 or away == 27 or away == 28 or away == 29 or away == 30 or away == 31 or away == 32 or away == 33 or away == 34 or away == 35 or away == 36 or away == 37 or away == 38 or away == 39 or away == 40 or away == 41 or away == 42 or away == 43 or away == 44 or away == 45 or away == 46 or away == 47 or away == 48 or away == 49 or away == 50 or away == 51 or away == 52 or away == 53 or away == 54 or away == 55 or away == 56 or away == 57 or away == 59 or away == 1010 or away == 1011 or away == 1012 or away == 1013 or away == 1015 or away == 1022 or away == 1026 or away == 1031 or away == 1032 or away == 1040 or away == 1044 or away == 1050 or away == 1051 or away == 1056 or away == 1058 or away == 1059 or away == 1067 or away == 1083 or away == 1099 or away == 1113 or away == 1128 or away == 1129 or away == 1141 or away == 1164 or away == 1165 or away == 1166 or away == 1167 or away == 1168 or away == 1169 or away == 1171 or away == 1172 or away == 1173 or away == 1174  or away == 1175 or away == 1176 or away == 1177 or away == 1178 or away == 1179 or away == 1180 or away == 1181 or away == 1182 or away == 1183 or away == 1550 or away == 1551 or away == 5439 or away == 5440) then
		 Entrance = "Default"

	     else
			entry = 16
			Entrance = "Default"

	     end
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
