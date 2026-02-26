-- Super Games Stadium CornerFlags

local fileroot = ".\\content\\Stadium_CornerFlag"

local tid

local function set_random(ctx)
tid = ctx.tournament_id
home = ctx.home_team
away = ctx.away_team
matchid = ctx.match_info

end

function make_key(ctx, filename)
tid = ctx.tournament_id
home = ctx.home_team
away = ctx.away_team
matchid = ctx.match_info

-- Master League/BAL/League/Cup

if tid == 4 and matchid == 53 then
CornerFlag = "Competitions\\UEFA Champions League Final"
elseif tid == 6 and matchid == 53 then
CornerFlag = "Competitions\\UEFA Europa League Final"
elseif tid == 23 and matchid == 53 then
CornerFlag = "Competitions\\FA Cup"
elseif tid == 86 then
CornerFlag = "Competitions\\Community Shield"
elseif tid == 7 then
CornerFlag = "Competitions\\UEFA Super Cup"
elseif tid == 1 then
CornerFlag = "Competitions\\FIFA Club World Cup"
elseif tid == 105 or tid == 106 or tid == 107 then
CornerFlag = "Competitions\\International Champions Cup"
elseif tid == 53 and matchid == 53 then
CornerFlag = "Competitions\\DFB Pokal Final"
elseif tid == 95 then
CornerFlag = "Competitions\\DFL Supercup"
elseif tid == 24 and matchid == 53 then
CornerFlag = "Competitions\\Coppa Italia"
elseif tid == 89 then
CornerFlag = "Competitions\\Supercoppa Italiana"
elseif tid == 25 and matchid == 53 then
CornerFlag = "Competitions\\Copa del Rey"
elseif tid == 87 then
CornerFlag = "Competitions\\Supercopa de Espana"
elseif tid == 99 then
CornerFlag = "Competitions\\VRED\\League"
elseif tid == 48 and matchid == 53 then
CornerFlag = "Competitions\\VRED\\Cup"
elseif tid == 10 and matchid == 53 then
CornerFlag = "Competitions\\Copa Libertadores Final"
elseif tid == 90 then
CornerFlag = "Competitions\\Johan Cruijff Schaal"
elseif tid == 92 then
CornerFlag = "Competitions\\Supercopa Argentina"
elseif tid == 27 and matchid == 53 then
CornerFlag = "Competitions\\KNVB Beker"
elseif tid == 28 and matchid == 53 then
CornerFlag = "Competitions\\Taca de Portugal"
elseif tid == 91 then
CornerFlag = "Competitions\\Supertaca Candido de Oliveira"
elseif tid == 58 then
CornerFlag = "Default"
elseif tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42 then
CornerFlag = "Competitions\\UEFA Euro"
elseif tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176 then
CornerFlag = "Competitions\\Copa America"
elseif tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35 then
CornerFlag = "Competitions\\FIFA World Cup"

--Spain Teams

elseif (home == 108) and (tid == 19) then
CornerFlag = "Teams\\Spain\\Barcelona\\LaLiga"
elseif (home == 108) and (tid == 25) then
CornerFlag = "Teams\\Spain\\Barcelona\\LaLiga"
elseif (home == 108) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Spain\\Barcelona\\UCL"
elseif home == 108 then
CornerFlag = "Teams\\Spain\\Barcelona\\LaLiga"
elseif (home == 109) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Spain\\Real Madrid\\CL"
elseif home == 109 then
CornerFlag = "Teams\\Spain\\Real Madrid\\Liga"
elseif home == 110 then
CornerFlag = "Teams\\Spain\\Valencia"
elseif (home == 172) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Spain\\Atletico de Madrid\\UCL"
elseif home == 172 then
CornerFlag = "Teams\\Spain\\Atletico de Madrid"
elseif home == 194 then
CornerFlag = "Teams\\Spain\\Betis"
elseif home == 195 then
CornerFlag = "Teams\\Spain\\Celta"
elseif (home == 196) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Spain\\Real Sociedad\\UCL"
elseif home == 196 and (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6 or tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\Spain\\Real Sociedad\\UEL"
elseif home == 196 then
CornerFlag = "Teams\\Spain\\Real Sociedad"
elseif home == 258 then
CornerFlag = "Teams\\Spain\\Athletic"
elseif home == 263 then
CornerFlag = "Teams\\Spain\\Osasuna"
elseif (home == 265) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Spain\\Sevilla\\UCL"
elseif home == 265 and (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6 or tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\Spain\\Sevilla\\UEL"
elseif home == 265 then
CornerFlag = "Teams\\Spain\\Sevilla"
elseif home == 266 then
CornerFlag = "Teams\\Spain\\Valladolid"
elseif home == 267 then
CornerFlag = "Teams\\Spain\\Villarreal"
elseif home == 362 then
CornerFlag = "Teams\\Spain\\Getafe"
elseif home == 366 then
CornerFlag = "Teams\\Spain\\Levante"
elseif home == 1765 then
CornerFlag = "Teams\\Spain\\Granada"
elseif home == 4145 then
CornerFlag = "Teams\\Spain\\Alaves"
elseif home == 4146 then
CornerFlag = "Teams\\Spain\\Eibar"
elseif home == 4308 then
CornerFlag = "Teams\\Spain\\Cadiz"
elseif home == 361 then
CornerFlag = "Teams\\Spain\\Elche"
elseif home == 2188 then
CornerFlag = "Teams\\Spain\\SD Huesca"


elseif home == 4302 then
CornerFlag = "Teams\\Spain\\Albacete"
elseif home == 2393 then
CornerFlag = "Teams\\Spain\\Alcorcon"
elseif home == 357 then
CornerFlag = "Teams\\Spain\\Almeria"
elseif home == 4309 then
CornerFlag = "Teams\\Spain\\Cartagena"
elseif home == 4395 then
CornerFlag = "Teams\\Spain\\Castellon"
elseif home == 4269 then
CornerFlag = "Teams\\Spain\\Fuenlabrada"
elseif home == 2187 then
CornerFlag = "Teams\\Spain\\Girona"
elseif home == 4255 then
CornerFlag = "Teams\\Spain\\Logroñes"
elseif home == 2615 then
CornerFlag = "Teams\\Spain\\Lugo"
elseif home == 260 then
CornerFlag = "Teams\\Spain\\Malaga"
elseif home == 1595 then
CornerFlag = "Teams\\Spain\\Ponferradina"
elseif home == 370 then
CornerFlag = "Teams\\Spain\\Rayo Vallecano"
elseif home == 268 then
CornerFlag = "Teams\\Spain\\Real Zaragoza"
elseif home == 2532 then
CornerFlag = "Teams\\Spain\\Sabadell"
elseif home == 4147 then
CornerFlag = "Teams\\Spain\\Tenerife"
elseif home == 364 then
CornerFlag = "Teams\\Spain\\Las Palmas"
elseif home == 2616 then
CornerFlag = "Teams\\Spain\\Mirandes"
elseif home == 4260 then
CornerFlag = "Teams\\Spain\\Oviedo"
elseif home == 363 then
CornerFlag = "Teams\\Spain\\Sporting"
elseif home == 4272 then
CornerFlag = "Teams\\Spain\\Leganes"
elseif home == 259 then
CornerFlag = "Teams\\Spain\\Espanyol"
elseif home == 261 then
CornerFlag = "Teams\\Spain\\Mallorca"
elseif home == 4276 then
CornerFlag = "Teams\\Spain\\Real Sociedad"
elseif home == 5572 then
CornerFlag = "Teams\\Spain\\Ibiza"


elseif home == 111 then
CornerFlag = "Teams\\Spain\\Depor"
elseif home == 5127 then
CornerFlag = "Teams\\Spain\\Extremadura"

--England Teams

elseif home == 101 then
CornerFlag = "Teams\\England\\Arsenal"
elseif home == 107 then
CornerFlag = "Teams\\England\\Aston Villa"
elseif home == 4071 then
CornerFlag = "Teams\\England\\Bournemouth"
elseif home == 377 then
CornerFlag = "Teams\\England\\Brighton"
elseif home == 378 then
CornerFlag = "Teams\\England\\Burnley"
elseif home == 102 then
CornerFlag = "Teams\\England\\Chelsea"
elseif home == 382 then
CornerFlag = "Teams\\England\\Crystal Palace"
elseif home == 177 then
CornerFlag = "Teams\\England\\Everton"
elseif home == 204 then
CornerFlag = "Teams\\England\\Leicester"
elseif home == 103 and (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6 or tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\England\\Liverpool\\UEFA"
elseif home == 103 then
CornerFlag = "Teams\\England\\Liverpool"
elseif (home == 173) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\England\\Manchester City\\UCL"
elseif home == 173 then
CornerFlag = "Teams\\England\\Manchester City"
elseif home == 100 then
CornerFlag = "Teams\\England\\Manchester United"
elseif home == 106 then
CornerFlag = "Teams\\England\\Newcastle"
elseif home == 388 then
CornerFlag = "Teams\\England\\Norwich"
elseif home == 4194 then
CornerFlag = "Teams\\England\\Sheffield"
elseif home == 207 then
CornerFlag = "Teams\\England\\Southampton"
elseif (home == 179) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\England\\Tottenham\\UCL"
elseif home == 179 then
CornerFlag = "Teams\\England\\Tottenham"
elseif home == 398 then
CornerFlag = "Teams\\England\\Watford"
elseif home == 105 then
CornerFlag = "Teams\\England\\West Ham"
elseif home == 208 then
CornerFlag = "Teams\\England\\Wolverhampton"
elseif home == 1588 then
CornerFlag = "Teams\\England\\Barnsley"
elseif home == 201 then
CornerFlag = "Teams\\England\\Birmingham"
elseif home == 176 then
CornerFlag = "Teams\\England\\Blackburn"
elseif home == 4180 then
CornerFlag = "Teams\\England\\Brentford"
elseif home == 1760 then
CornerFlag = "Teams\\England\\Bristol"
elseif home == 379 then
CornerFlag = "Teams\\England\\Cardiff"
elseif home == 203 then
CornerFlag = "Teams\\England\\Charlton"
elseif home == 383 then
CornerFlag = "Teams\\England\\Derby County"
elseif home == 178 then
CornerFlag = "Teams\\England\\Fulham"
elseif home == 2610 then
CornerFlag = "Teams\\England\\Huddersfield"
elseif home == 1589 then
CornerFlag = "Teams\\England\\Hull City"
elseif home == 104 then
CornerFlag = "Teams\\England\\Leeds"
elseif home == 4363 then
CornerFlag = "Teams\\England\\Luton"
elseif home == 205 then
CornerFlag = "Teams\\England\\Middlesbrough"
elseif home == 387 then
CornerFlag = "Teams\\England\\Millwall"
elseif home == 389 then
CornerFlag = "Teams\\England\\Nottingham Forest"
elseif home == 4192 then
CornerFlag = "Teams\\England\\Preston North End"
elseif home == 1327 then
CornerFlag = "Teams\\England\\QPR"
elseif home == 391 then
CornerFlag = "Teams\\England\\Reading"
elseif home == 394 then
CornerFlag = "Teams\\England\\Sheffield W"
elseif home == 395 then
CornerFlag = "Teams\\England\\stoke city"
elseif home == 1909 then
CornerFlag = "Teams\\England\\Swansea"
elseif home == 399 then
CornerFlag = "Teams\\England\\WBA"
elseif home == 394 then
CornerFlag = "Teams\\England\\Wigan"
elseif home == 1327 then
CornerFlag = "Teams\\England\\QPR"
elseif home == 205 then
CornerFlag = "Teams\\England\\Middlesbrough"
elseif home == 395 then
CornerFlag = "Teams\\England\\stoke City"
elseif home == 5096 then
CornerFlag = "Teams\\England\\Wycombe"
elseif home == 4193 then
CornerFlag = "Teams\\England\\Rotherham United"
elseif home == 4183 then
CornerFlag = "Teams\\England\\Coventry City"

--Germany Teams

elseif (home == 126) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Germany\\Dortmund\\UCL"
elseif home == 126 and (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6 or tid == 2 or tid == 4 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\Germany\\Dortmund\\UEFA"
elseif home == 126 then
CornerFlag = "Teams\\Germany\\Dortmund"
elseif home == 232 then
CornerFlag = "Teams\\Germany\\Wolfsburg"
elseif home == 128 then
CornerFlag = "Teams\\Germany\\Leverkusen"
elseif (home == 185) and (tid == 50 or tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 65535) then
CornerFlag = "Teams\\Germany\\Werder Bremen"
elseif (home == 225) and (tid == 50) then
CornerFlag = "Teams\\Germany\\Gladbach"
elseif (home == 226) and (tid == 50 or tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 65535) then
CornerFlag = "Teams\\Germany\\Frankfurt"
elseif home == 2347 then
CornerFlag = "Teams\\Germany\\Freiburg"
elseif home == 431 then
CornerFlag = "Teams\\Germany\\Dusseldorf"
elseif home == 436 then
CornerFlag = "Teams\\Germany\\Mainz"
elseif home == 4124 then
CornerFlag = "Teams\\Germany\\Augsburg"
elseif home == 4125 then
CornerFlag = "Teams\\Germany\\Hertha"
elseif home == 4126 then
CornerFlag = "Teams\\Germany\\Hoffenheim"
elseif home == 4137 then
CornerFlag = "Teams\\Germany\\Koln"
elseif home == 4140 then
CornerFlag = "Teams\\Germany\\Union Berlin"
elseif home == 4324 then
CornerFlag = "Teams\\Germany\\Paderborn"
elseif (home == 5010) and (tid == 50 or tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 65535) then
CornerFlag = "Teams\\Germany\\Leipzig"
elseif home == 127 then
CornerFlag = "Teams\\Germany\\Bayern Munich"
elseif home == 184 then
CornerFlag = "Teams\\Germany\\Schalke 04"
elseif home == 231 then
CornerFlag = "Teams\\Germany\\Stuttgart"
elseif home == 4127 then
CornerFlag = "Teams\\Germany\\bielefeld"

--Italy Teams

elseif (home == 119) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Italy\\Inter\\UCL"
elseif home == 119 then
CornerFlag = "Teams\\Italy\\Inter"
elseif home == 120 then
CornerFlag = "Teams\\Italy\\Juve"
elseif (home == 121) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
CornerFlag = "Teams\\Italy\\Milan\\UCL"
elseif home == 121 then
CornerFlag = "Teams\\Italy\\Milan"
elseif home == 122 then
CornerFlag = "Teams\\Italy\\Lazio"
elseif home == 123 then
CornerFlag = "Teams\\Italy\\Parma"
elseif home == 124 then
CornerFlag = "Teams\\Italy\\Fiorentina"
elseif home == 125 then
CornerFlag = "Teams\\Italy\\Roma"
elseif home == 186 then
CornerFlag = "Teams\\Italy\\Bologna"
elseif home == 190 then
CornerFlag = "Teams\\Italy\\Udinese"
elseif home == 234 then
CornerFlag = "Teams\\Italy\\Atalanta"
elseif home == 240 then
CornerFlag = "Teams\\Italy\\Sampdoria"
elseif home == 320 then
CornerFlag = "Teams\\Italy\\Cagliari"
elseif home == 323 then
CornerFlag = "Teams\\Italy\\Genoa"
elseif home == 336 then
CornerFlag = "Teams\\Italy\\Hellas"

--France Teams

elseif (home == 114) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\PSG"
elseif (home == 181) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Lyon"
elseif (home == 213) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Lille"
elseif (home == 114) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Marseille"
elseif (home == 114) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Monaco"
elseif (home == 114) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Rennes"
elseif (home == 216) and (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
CornerFlag = "Teams\\France\\Nantes"


--Portuguese Teams

elseif home == 191 then
CornerFlag = "Teams\\Portugal\\Benfica"
elseif home == 192 then
CornerFlag = "Teams\\Portugal\\Porto"
elseif home == 193 then
CornerFlag = "Teams\\Portugal\\Sporting CP"
elseif home == 1974 then
CornerFlag = "Teams\\Portugal\\Braga"
elseif home == 1973 then
CornerFlag = "Teams\\Portugal\\Belenenses"
elseif home == 4323 then
CornerFlag = "Teams\\Portugal\\Boavista"
elseif home == 5028 then
CornerFlag = "Teams\\Portugal\\Famalicao"
elseif home == 2387 then
CornerFlag = "Teams\\Portugal\\Gil Vicente"
elseif home == 2388 then
CornerFlag = "Teams\\Portugal\\Moreirense"
elseif home == 1979 then
CornerFlag = "Teams\\Portugal\\Rio Ave"
elseif home == 1804 then
CornerFlag = "Teams\\Portugal\\Vitoria Guimaraes"
elseif home == 1944 then
CornerFlag = "Teams\\Portugal\\Nacional"
elseif home == 4086 then
CornerFlag = "Teams\\Portugal\\Farense"
elseif home == 2614 then
CornerFlag = "Teams\\Portugal\\Tondela"
elseif home == 1976 then
CornerFlag = "Teams\\Portugal\\Maritimo"
elseif home == 2391 then
CornerFlag = "Teams\\Portugal\\Santa Clara"
elseif home == 1978 then
CornerFlag = "Teams\\Portugal\\Pacos de Ferreira"
elseif home == 2369 then
CornerFlag = "Teams\\Portugal\\Portimonense"

--Netherlands Teams

elseif home == 243 then
CornerFlag = "Teams\\Netherlands\\Ado"
elseif home == 116 then
CornerFlag = "Teams\\Netherlands\\Ajax"
elseif home == 242 then
CornerFlag = "Teams\\Netherlands\\AZ"
elseif home == 342 then
CornerFlag = "Teams\\Netherlands\\Emmen"
elseif home == 117 then
CornerFlag = "Teams\\Netherlands\\Feyenord"
elseif home == 345 then
CornerFlag = "Teams\\Netherlands\\Fortuna"
elseif home == 244 then
CornerFlag = "Teams\\Netherlands\\Groningen"
elseif home == 245 then
CornerFlag = "Teams\\Netherlands\\Heerenveen"
elseif home == 349 then
CornerFlag = "Teams\\Netherlands\\Heracles"
elseif home == 256 then
CornerFlag = "Teams\\Netherlands\\PEC"
elseif home == 118 then
CornerFlag = "Teams\\Netherlands\\PSV"
elseif home == 254 then
CornerFlag = "Teams\\Netherlands\\Waalwijk"
elseif home == 251 then
CornerFlag = "Teams\\Netherlands\\Sparta"
elseif home == 250 then
CornerFlag = "Teams\\Netherlands\\Twente"
elseif home == 251 then
CornerFlag = "Teams\\Netherlands\\Utrecht"
elseif home == 252 then
CornerFlag = "Teams\\Netherlands\\Vitesse"
elseif home == 355 then
CornerFlag = "Teams\\Netherlands\\VVV"
elseif home == 255 then
CornerFlag = "Teams\\Netherlands\\Willem II"

--Belgium Teams

elseif home == 174 then
CornerFlag = "Teams\\Belgium\\Anderletch"
elseif home == 5191 then
CornerFlag = "Teams\\Belgium\\Antwerp"
elseif home == 2009 then
CornerFlag = "Teams\\Belgium\\Cercle Brugge"
elseif home == 269 then
CornerFlag = "Teams\\Belgium\\Club Brugge"
elseif home == 1195 then
CornerFlag = "Teams\\Belgium\\Genk"
elseif home == 1196 then
CornerFlag = "Teams\\Belgium\\Gent"
elseif home == 5190 then
CornerFlag = "Teams\\Belgium\\Eupen"
elseif home == 2013 then
CornerFlag = "Teams\\Belgium\\Kortrijk"
elseif home == 5192 then
CornerFlag = "Teams\\Belgium\\Oostende"
elseif home == 1200 then
CornerFlag = "Teams\\Belgium\\Mechelen"
elseif home == 5193 then
CornerFlag = "Teams\\Belgium\\Royal Excel Mouscron"
elseif home == 5194 then
CornerFlag = "Teams\\Belgium\\Sint-Truiden"
elseif home == 2010 then
CornerFlag = "Teams\\Belgium\\Charleroi"
elseif home == 1197 then
CornerFlag = "Teams\\Belgium\\Standard Liege"
elseif home == 5195 then
CornerFlag = "Teams\\Belgium\\Waasland-Beveren"
elseif home == 2019 then
CornerFlag = "Teams\\Belgium\\Zulte-Waregem"
elseif home == 5216 then
CornerFlag = "Teams\\Belgium\\Beerschot"
elseif home == 5217 then
CornerFlag = "Teams\\Belgium\\OH Leuven"

--Russian Teams

elseif home == 1753 then
CornerFlag = "Teams\\Russia\\Dinamo"
elseif home == 5196 then
CornerFlag = "Teams\\Russia\\Akhmat"
elseif home == 1217 then
CornerFlag = "Teams\\Russia\\CSKA"
elseif home == 5298 then
CornerFlag = "Teams\\Russia\\Khimki"
elseif home == 2618 then
CornerFlag = "Teams\\Russia\\Krasnodar"
elseif home == 9999 then
CornerFlag = "Teams\\Russia\\Krylia"
elseif home == 271 then
CornerFlag = "Teams\\Russia\\Lokomotiv"
elseif home == 9998 then
CornerFlag = "Teams\\Russia\\Nizniy"
elseif home == 2229 then
CornerFlag = "Teams\\Russia\\Rostov"
elseif home == 5302 then
CornerFlag = "Teams\\Russia\\Rotor"
elseif home == 1941 then
CornerFlag = "Teams\\Russia\\Rubin"
elseif home == 5296 then
CornerFlag = "Teams\\Russia\\Sochi"
elseif home == 135 then
CornerFlag = "Teams\\Russia\\Spartak"
elseif home == 5306 then
CornerFlag = "Teams\\Russia\\Tambov"
elseif home == 5197 then
CornerFlag = "Teams\\Russia\\Tula"
elseif home == 5200 then
CornerFlag = "Teams\\Russia\\Ufa"
elseif home == 5201 then
CornerFlag = "Teams\\Russia\\Ural"
elseif home == 1218 then
CornerFlag = "Teams\\Russia\\Zenit"

--Argentina Teams

elseif home == 2717 then
CornerFlag = "Teams\\Argentina\\Aldosivi"
elseif home == 1236 then
CornerFlag = "Teams\\Argentina\\Argentinos Juniors"
elseif home == 1921 then
CornerFlag = "Teams\\Argentina\\Arsenal"
elseif home == 2719 then
CornerFlag = "Teams\\Argentina\\Atletico Tucuman"
elseif home == 1927 then
CornerFlag = "Teams\\Argentina\\Banfield"
elseif home == 139 then
CornerFlag = "Teams\\Argentina\\Boca Juniors"
elseif home == 4995 then
CornerFlag = "Teams\\Argentina\\Central Cordoba Sde"
elseif home == 1923 then
CornerFlag = "Teams\\Argentina\\Colon"
elseif home == 2722 then
CornerFlag = "Teams\\Argentina\\Defensa Y Justicia"
elseif home == 1238 then
CornerFlag = "Teams\\Argentina\\Estudiantes de la Plata"
elseif home == 1239 then
CornerFlag = "Teams\\Argentina\\Gimnasia La Plata"
elseif home == 1924 then
CornerFlag = "Teams\\Argentina\\Godoy Cruz"
elseif home == 1922 then
CornerFlag = "Teams\\Argentina\\Huracan"
elseif home == 1240 then
CornerFlag = "Teams\\Argentina\\Independiente"
elseif home == 1929 then
CornerFlag = "Teams\\Argentina\\Lanus"
elseif home == 1241 then
CornerFlag = "Teams\\Argentina\\Newell's Old Boys"
elseif home == 2729 then
CornerFlag = "Teams\\Argentina\\Patronato"
elseif home == 1237 then
CornerFlag = "Teams\\Argentina\\Racing Club"
elseif home == 138 then
CornerFlag = "Teams\\Argentina\\River Plate"
elseif home == 1242 then
CornerFlag = "Teams\\Argentina\\Rosario Central"
elseif home == 1243 then
CornerFlag = "Teams\\Argentina\\San Lorenzo"
elseif home == 5046 then
CornerFlag = "Teams\\Argentina\\Talleres De Cordoba"
elseif home == 2538 then
CornerFlag = "Teams\\Argentina\\Union de Santa Fe"
elseif home == 1244 then
CornerFlag = "Teams\\Argentina\\Velez Sarsfield"
elseif home == 1926 then
CornerFlag = "Teams\\Argentina\\Tigre"

--Turkey Teams

elseif home == 5202 then
CornerFlag = "Teams\\Turkey\\Alanyaspor"
elseif home == 5360 then
CornerFlag = "Teams\\Turkey\\Ankaragucu"
elseif home == 1989 then
CornerFlag = "Teams\\Turkey\\Antalyaspor"
elseif home == 273 then
CornerFlag = "Teams\\Turkey\\Besiktas"
elseif home == 5355 then
CornerFlag = "Teams\\Turkey\\Denizlispor"
elseif home == 197 then
CornerFlag = "Teams\\Turkey\\Fenerbahce"
elseif home == 130 then
CornerFlag = "Teams\\Turkey\\Galatasaray"
elseif home == 5356 then
CornerFlag = "Teams\\Turkey\\Gazisehir Gaziantep"
elseif home == 1230 then
CornerFlag = "Teams\\Turkey\\Genclerbirligi"
elseif home == 5203 then
CornerFlag = "Teams\\Turkey\\Goztepe"
elseif home == 1995 then
CornerFlag = "Teams\\Turkey\\Istanbul Basaksehir"
elseif home == 2625 then
CornerFlag = "Teams\\Turkey\\Kasimpasa"
elseif home == 1996 then
CornerFlag = "Teams\\Turkey\\Kayserispor"
elseif home == 5204 then
CornerFlag = "Teams\\Turkey\\Konyaspor"
elseif home == 5354 then
CornerFlag = "Teams\\Turkey\\Rizespor"
elseif home == 1809 then
CornerFlag = "Teams\\Turkey\\Sivasspor"
elseif home == 1945 then
CornerFlag = "Teams\\Turkey\\Trabzonspor"
elseif home == 5206 then
CornerFlag = "Teams\\Turkey\\Yeni Malatyaspor"

--Scotish Teams

elseif home == 1219 then
CornerFlag = "Teams\\Scotland\\Aberdeen"
elseif home == 132 then
CornerFlag = "Teams\\Scotland\\Rangers"
elseif home == 131 then
CornerFlag = "Teams\\Scotland\\Celtic"

--Denmark Teams

elseif home == 1207 then
CornerFlag = "Teams\\Denmark\\København"

--Other UEFA Teams

elseif home == 270 then
CornerFlag = "Teams\\Other UEFA\\AEK Athens"
elseif home == 1203 then
CornerFlag = "Teams\\Other UEFA\\Dinamo Zagreb"
elseif home == 134 then
CornerFlag = "Teams\\Other UEFA\\Dynamo Kyiv"
elseif home == 133 then
CornerFlag = "Teams\\Other UEFA\\Olympiacos"
elseif home == 198 then
CornerFlag = "Teams\\Other UEFA\\Panatinaikos"
elseif home == 1212 then
CornerFlag = "Teams\\Other UEFA\\PAOK"
elseif home == 1232 then
CornerFlag = "Teams\\Other UEFA\\Shakhtar Donetsk"
elseif home == 5189 then
CornerFlag = "Teams\\Other UEFA\\Slavia Praha"
elseif home == 175 then
CornerFlag = "Teams\\Other UEFA\\Sparta Praha"
elseif home == 1756 then
CornerFlag = "Teams\\Other UEFA\\Legia Warsaw"
elseif home == 1586 then
CornerFlag = "Teams\\Other UEFA\\Red Bull Salzburg"
elseif home == 1702 then
CornerFlag = "Teams\\Other UEFA\\Malmo"
elseif home == 1950 then
CornerFlag = "Teams\\Other UEFA\\Young-Boys"
elseif home == 4355 then
CornerFlag = "Teams\\Other UEFA\\Ludogorets"
elseif home == 1957 then
CornerFlag = "Teams\\Other UEFA\\Zurich"
elseif home == 4326 then
CornerFlag = "Teams\\Other UEFA\\Qaraba?"

--Chile Teams

elseif home == 2209 then
CornerFlag = "Teams\\Chile\\Universidad de Chile"

--Ecuador Teams

elseif home == 2658 then
CornerFlag = "Teams\\Ecuador\\Barcelona SC"

--Paraguay Teams

elseif home == 1261 then
CornerFlag = "Teams\\Paraguay\\Olimpia"

--Uruguay Teams

elseif home == 1263 then
CornerFlag = "Teams\\Uruguay\\Peñarol"
elseif home == 1262 then
CornerFlag = "Teams\\Uruguay\\Nacional"

--Brazilian Teams

elseif home == 2450 then
CornerFlag = "Teams\\Brazil\\América Mineiro"
elseif home == 1246 then
CornerFlag = "Teams\\Brazil\\Botafogo"
elseif home == 5047 then
CornerFlag = "Teams\\Brazil\\Brasil de Pelotas"
elseif home == 1245 then
CornerFlag = "Teams\\Brazil\\CAM"
elseif home == 4108 then
CornerFlag = "Teams\\Brazil\\Chapecoense"
elseif home == 274 then
CornerFlag = "Teams\\Brazil\\Cruzeiro"
elseif home == 1248 then
CornerFlag = "Teams\\Brazil\\Flamengo"
elseif home == 1249 then
CornerFlag = "Teams\\Brazil\\Fluminense"
elseif home == 1252 then
CornerFlag = "Teams\\Brazil\\Internacional"
elseif home == 5433 then
CornerFlag = "Teams\\Brazil\\Operario PR"
elseif home == 137 then
CornerFlag = "Teams\\Brazil\\Palmeiras"
elseif home == 2459 then
CornerFlag = "Teams\\Brazil\\RB Bragantino"
elseif home == 1254 then
CornerFlag = "Teams\\Brazil\\Santos"
elseif home == 1255 then
CornerFlag = "Teams\\Brazil\\São Paulo"
elseif home == 1451 then
CornerFlag = "Teams\\Brazil\\ACG"
elseif home == 1930 then
CornerFlag = "Teams\\Brazil\\Athletico Paranaense"
elseif home == 2453 then
CornerFlag = "Teams\\Brazil\\Bahia"
elseif home == 2454 then
CornerFlag = "Teams\\Brazil\\Ceará"
elseif home == 1250 then
CornerFlag = "Teams\\Brazil\\Gremio"
elseif home == 5137 then
CornerFlag = "Teams\\Brazil\\Juventude"
elseif home == 1936 then
CornerFlag = "Teams\\Brazil\\Sport Recife"
elseif home == 136 then
CornerFlag = "Teams\\Brazil\\Vasco da Gama"
elseif home == 5660 then
CornerFlag = "Teams\\Brazil\\Brusque"
elseif home == 1247 then
CornerFlag = "Teams\\Brazil\\Corinthians"
elseif home == 2506 then
CornerFlag = "Teams\\Brazil\\CRB"
elseif home == 5142 then
CornerFlag = "Teams\\Brazil\\Cuiabá"
elseif home == 5143 then
CornerFlag = "Teams\\Brazil\\Fortaleza"
elseif home == 1933 then
CornerFlag = "Teams\\Brazil\\Goiás"
elseif home == 1935 then
CornerFlag = "Teams\\Brazil\\Náutico"
elseif home == 2465 then
CornerFlag = "Teams\\Brazil\\Ponte Preta"
elseif home == 1937 then
CornerFlag = "Teams\\Brazil\\Vitória"
elseif home == 4111 then
CornerFlag = "Teams\\Brazil\\Sampaio Corrêa"
elseif home == 5145 then
CornerFlag = "Teams\\Brazil\\Remo"

--National Teams

elseif home == 5 then
CornerFlag = "Teams\\NT\\England"
elseif home == 7 then
CornerFlag = "Teams\\NT\\Spain"
elseif home == 8 then
CornerFlag = "Teams\\NT\\France"
elseif home == 9 then
CornerFlag = "Teams\\NT\\Belgium"
elseif home == 10 then
CornerFlag = "Teams\\NT\\Netherlands"
elseif home == 11 then
CornerFlag = "Teams\\NT\\Switzerland"
elseif home == 12 then
CornerFlag = "Teams\\NT\\Italy"
elseif home == 14 then
CornerFlag = "Teams\\NT\\Germany"
elseif home == 15 then
CornerFlag = "Teams\\NT\\Denmark"
elseif home == 17 then
CornerFlag = "Teams\\NT\\Sweden"
elseif home == 22 then
CornerFlag = "Teams\\NT\\Hungary"
elseif home == 24 then
CornerFlag = "Teams\\NT\\Croatia"
elseif home == 30 then
CornerFlag = "Teams\\NT\\Ukraine"
elseif home == 44 then
CornerFlag = "Teams\\NT\\Colombia"
elseif home == 45 then
CornerFlag = "Teams\\NT\\Brasil"
elseif home == 46 then
CornerFlag = "Teams\\NT\\Peru"
elseif home == 47 then
CornerFlag = "Teams\\NT\\Chile"
elseif home == 48 then
CornerFlag = "Teams\\NT\\Paraguay"
elseif home == 49 then
CornerFlag = "Teams\\NT\\Uruguay"
elseif home == 1128 then
CornerFlag = "Teams\\NT\\Bolivia"
elseif home == 51 then
CornerFlag = "Teams\\NT\\Ecuador"
elseif home == 42 then
CornerFlag = "Teams\\NT\\Costa Rica"
elseif home == 1099 then
CornerFlag = "Teams\\NT\\Canada"
elseif home == 6 then
CornerFlag = "Teams\\NT\\Portugal"


--Competitions

elseif tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8194 or tid == 3 or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 then
CornerFlag = "Competitions\\UEFA Champions League"
elseif tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245 or tid == 11269 or tid == 12293 then
CornerFlag = "Competitions\\UEFA Europa League"
elseif tid == 17 then
CornerFlag = "Competitions\\Premier League"
elseif tid == 79 then
CornerFlag = "Competitions\\EFL\\Championship"
elseif tid == 83 then
CornerFlag = "Competitions\\EFL\\Play-Off"
elseif tid == 80 then
CornerFlag = "Competitions\\LaLiga Smartbank"
elseif (home == 187 or 327 or 333 or 336 or 1919 or 4237 or 4923) and (tid == 18) then
CornerFlag = "Competitions\\Seria A"
elseif tid == 50 then
CornerFlag = "Competitions\\Bundesliga"
elseif tid == 53 then
CornerFlag = "Competitions\\DFB Pokal"
elseif tid == 20 then
CornerFlag = "Competitions\\Ligue 1"
elseif tid == 81 then
CornerFlag = "Competitions\\Ligue 2"
elseif tid == 26 then
CornerFlag = "Competitions\\Coupe de France"
elseif tid == 21 then
CornerFlag = "Competitions\\Eredivisie"
elseif tid == 118 then
CornerFlag = "Competitions\\Super Lig"
elseif tid == 115 or tid == 155 or tid == 156 or tid == 157 or tid == 158 or tid == 159 then
CornerFlag = "Competitions\\Jupiler Pro League"
elseif tid == 133 or tid == 134 or tid == 135 or tid == 136 or tid == 137 then
CornerFlag = "Competitions\\SPFL"
elseif tid == 30 then
CornerFlag = "Competitions\\Superliga Argentina"
elseif tid == 59 then
CornerFlag = "Competitions\\Copa Argentina"
elseif tid == 8 or tid == 9 or tid == 10 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 3081 or tid == 4105 or tid == 5129 or tid == 7177 or tid == 8201 then
CornerFlag = "Competitions\\Copa Libertadores"
elseif tid == 44 then
CornerFlag = "Competitions\\AFC Asian Cup"
elseif tid == 46 then
CornerFlag = "Competitions\\Africa Cup of Nations"
elseif tid == 88 then
CornerFlag = "Competitions\\Trophee des Champions"
elseif tid == 22 then
CornerFlag = "Competitions\\Liga NOS"
elseif tid == 27 then
CornerFlag = "Competitions\\KNVB Beker"
elseif tid == 28 then
CornerFlag = "Competitions\\Taca de Portugal"
elseif tid == 116 then
CornerFlag = "Competitions\\Russian Premier League"
elseif tid == 123 then
CornerFlag = "Competitions\\Russian Cup"
elseif tid == 129 then
CornerFlag = "Competitions\\Russian Super Cup"
elseif tid == 117 then
CornerFlag = "Competitions\\Raiffeisen Super League"
elseif tid == 124 then
CornerFlag = "Competitions\\Swiss Cup"
elseif tid == 112 then
CornerFlag = "Competitions\\Croky Cup"
elseif tid == 128 then
CornerFlag = "Competitions\\Belgian Super Cup"
elseif tid == 125 then
CornerFlag = "Competitions\\Turkish Cup"
elseif tid == 130 then
CornerFlag = "Competitions\\Turkish Super Cup"
elseif tid == 141 or tid == 142 or tid == 147 or tid == 148 or tid == 149 or tid == 150 or tid == 151 then
CornerFlag = "Competitions\\Danish Superliga"
elseif tid == 119 or tid == 23800 or tid == 23801 or tid == 160 or tid == 161 then
CornerFlag = "Competitions\\Liga BetPlay Dimayor"
elseif tid == 126 then
CornerFlag = "Competitions\\Copa Colombia"
elseif tid == 131 then
CornerFlag = "Competitions\\Superliga Colombiana"
elseif tid == 67 or tid == 13400 or tid == 13401 then
CornerFlag = "Competitions\\Chilean Primera Division"
elseif tid == 68 then
CornerFlag = "Competitions\\Copa Chile"
elseif tid == 29 then
CornerFlag = "Competitions\\Brasileiro"
elseif tid == 31 then
CornerFlag = "Competitions\\Copa do Brasil"
elseif tid == 51 or tid == 166 or tid == 167 then
CornerFlag = "Competitions\\Liga 1_Movistar"
elseif tid == 52 then
CornerFlag = "Competitions\\J1 League"
elseif tid == 55 then
CornerFlag = "Competitions\\YBC Levain Cup"
elseif tid == 97 then
CornerFlag = "Competitions\\Xerox Super Cup"
elseif tid == 120 then
CornerFlag = "CSL"
elseif tid == 126 then
CornerFlag = "Competitions\\Copa China"
elseif tid == 127 then
CornerFlag = "Competitions\\Supercopa China"

elseif tid == 65535 or tid == 47 or tid == 99 or tid == 9400 or tid == 9401 or tid == 9402 or tid == 9403 or tid == 9404 or tid == 9405 or tid == 9406 or tid == 9407 or tid == 48 then


--Exhibition


if (home == 101 or home == 4071 or home == 377 or home == 378 or home == 379 or home == 102 or home == 382 or home == 177 or home == 178 or home == 2610 or home == 204 or home == 103 or home == 173 or home == 100 or home == 106 or home == 207 or home == 179 or home == 398 or home == 105 or home == 208) and (away == 101 or away == 4071 or away == 377 or away == 378 or away == 379 or away == 102 or away == 382 or away == 177 or away == 178 or away == 2610 or away == 204 or away == 103 or away == 173 or away == 100 or away == 106 or away == 207 or away == 179 or away == 398 or away == 105 or away == 208) then
CornerFlag = "Competitions\\Premier League"
elseif (home == 4200 or home == 403 or home == 115 or home == 405 or home == 1328 or home == 211 or home == 213 or home == 112 or home == 215 or home == 216 or home == 217 or home == 1910 or home == 181 or home == 113 or home == 114 or home == 218 or home == 418 or home == 1330 or home == 4213 or home == 221) and (away == 4200 or away == 403 or away == 115 or away == 405 or away == 1328 or away == 211 or away == 213 or away == 112 or away == 215 or away == 216 or away == 217 or away == 1910 or away == 181 or away == 113 or away == 114 or away == 218 or away == 418 or away == 1330 or away == 4213 or away == 221) then
CornerFlag = "Competitions\\Ligue 1"
elseif (home == 209 or home == 180 or home == 5019 or home == 1329 or home == 406 or home == 407 or home == 2611 or home == 4370 or home == 413 or home == 414 or home == 4123 or home == 415 or home == 416 or home == 4210 or home == 4211 or home == 182 or home == 4212 or home == 219 or home == 420 or home == 1528) and (away == 209 or away == 180 or away == 5019 or away == 1329 or away == 406 or away == 407 or away == 2611 or away == 4370 or away == 413 or away == 414 or away == 4123 or away == 415 or away == 416 or away == 4210 or away == 4211 or away == 182 or away == 4212 or away == 219 or away == 420 or away == 1528) then
CornerFlag = "Competitions\\Ligue 2"
elseif (home == 107 or home == 201 or home == 176 or home == 202 or home == 4180 or home == 1760 or home == 383 or home == 1589 or home == 386 or home == 104 or home == 205 or home == 387 or home == 388 or home == 389 or home == 4192 or home == 1327 or home == 391 or home == 4193 or home == 4194 or home == 394 or home == 395 or home == 1909 or home == 399 or home == 400) and (away == 107 or away == 201 or away == 176 or away == 202 or away == 4180 or away == 1760 or away == 383 or away == 1589 or away == 386 or away == 104 or away == 205 or away == 387 or away == 388 or away == 389 or away == 4192 or away == 1327 or away == 391 or away == 4193 or away == 4194 or away == 394 or away == 395 or away == 1909 or away == 399 or away == 400) then
CornerFlag = "Competitions\\EFL\\Championship"
elseif (home == 4124 or home == 4125 or home == 4140 or home == 185 or home == 126 or home == 431 or home == 226 or home == 227 or home == 4126 or home == 4137 or home == 5010 or home == 128 or home == 436 or home == 225 or home == 127 or home == 4324 or home == 184 or home == 232) and (away == 4124 or away == 4125 or away == 4140 or away == 185 or away == 126 or away == 431 or away == 226 or away == 227 or away == 4126 or away == 4137 or away == 5010 or away == 128 or away == 436 or away == 225 or away == 127 or away == 4324 or away == 184 or away == 232) then
CornerFlag = "Competitions\\Bundesliga"
elseif (home == 234 or home == 186 or home == 320 or home == 188 or home == 235 or home == 124 or home == 323 or home == 119 or home == 120 or home == 122 or home == 121 or home == 327 or home == 123 or home == 125 or home == 240 or home == 1919 or home == 4923 or home == 4234 or home == 333 or home == 190) and (away == 234 or away == 186 or away == 320 or away == 188 or away == 235 or away == 124 or away == 323 or away == 119 or away == 120 or away == 122 or away == 121 or away == 327 or away == 123 or away == 125 or away == 240 or away == 1919 or away == 4923 or away == 4234 or away == 333 or away == 190) then
CornerFlag = "Competitions\\Serie A"
elseif (home == 243 or home == 116 or home == 242 or home == 339 or home == 342 or home == 344 or home == 117 or home == 345 or home == 244 or home == 245 or home == 349 or home == 246 or home == 256 or home == 118 or home == 251 or home == 252 or home == 355 or home == 255) and (away == 243 or away == 116 or away == 242 or away == 339 or away == 342 or away == 344 or away == 117 or away == 345 or away == 244 or away == 245 or away == 349 or away == 246 or away == 256 or away == 118 or away == 251 or away == 252 or away == 355 or away == 255) then
CornerFlag = "Competitions\\Eredivisie"
elseif (home == 2623 or home == 5202 or home == 5360 or home == 1989 or home == 5353 or home == 273 or home == 1991 or home == 197 or home == 130 or home == 5203 or home == 1995 or home == 2625 or home == 1996 or home == 5204 or home == 5354 or home == 1809 or home == 1945 or home == 5206) and (away == 2623 or away == 5202 or away == 5360 or away == 1989 or away == 5353 or away == 273 or away == 1991 or away == 197 or away == 130 or away == 5203 or away == 1995 or away == 2625 or away == 1996 or away == 5204 or away == 5354 or away == 1809 or away == 1945 or away == 5206) then
CornerFlag = "Competitions\\Super Lig"
elseif (home == 174 or home == 5191 or home == 2009 or home == 269 or home == 1195 or home == 1196 or home == 5190 or home == 2013 or home == 5192 or home == 1199 or home == 5193 or home == 5194 or home == 2010 or home == 1197 or home == 5195 or home == 2019) and (away == 174 or away == 5191 or away == 2009 or away == 269 or away == 1195 or away == 1196 or away == 5190 or away == 2013 or away == 5192 or away == 1199 or away == 5193 or away == 5194 or away == 2010 or away == 1197 or away == 5195 or away == 2019) then
CornerFlag = "Competitions\\Jupiler Pro League"
elseif (home == 2717 or home == 1236 or home == 2719 or home == 1927 or home == 2536 or home == 139 or home == 1923 or home == 2722 or home == 1238 or home == 1239 or home == 1924 or home == 1922 or home == 1240 or home == 1929 or home == 1241 or home == 2729 or home == 1237 or home == 138 or home == 1242 or home == 1243 or home == 1925 or home == 2702 or home == 5046 or home == 1926 or home == 2538 or home == 1244) and (away == 2717 or away == 1236 or away == 2719 or away == 1927 or away == 2536 or away == 139 or away == 1923 or away == 2722 or away == 1238 or away == 1239 or away == 1924 or away == 1922 or away == 1240 or away == 1929 or away == 1241 or away == 2729 or away == 1237 or away == 138 or away == 1242 or away == 1243 or away == 1925 or away == 2702 or away == 5046 or away == 1926 or away == 2538 or away == 1244) then
CornerFlag = "Competitions\\Superliga Argentina"
elseif (home == 2450 or home == 1245 or home == 1930 or home == 2453 or home == 1246 or home == 2454 or home == 4108 or home == 1247 or home == 274 or home == 1248 or home == 1249 or home == 1250 or home == 1252 or home == 137 or home == 2464 or home == 1254 or home == 1255 or home == 1936 or home == 136 or home == 1937) and (away == 2450 or away == 1245 or away == 1930 or away == 2453 or away == 1246 or away == 2454 or away == 4108 or away == 1247 or away == 274 or away == 1248 or away == 1249 or away == 1250 or away == 1252 or away == 137 or away == 2464 or away == 1254 or away == 1255 or away == 1936 or away == 136 or away == 1937) then
CornerFlag = "Competitions\\Brasileiro"
elseif (home == 2287 or home == 5583 or home == 5492 or home == 2672 or home == 5488 or home == 5486 or home == 2705 or home == 2202 or home == 2675 or home == 2731 or home == 5493 or home == 2674 or home == 5489 or home == 2676 or home == 2503 or home == 2216 or home == 2678 or home == 2215 or home == 2200 or home == 4407) and (away == 2287 or away == 5583 or away == 5492 or away == 2672 or away == 5488 or away == 5486 or away == 2705 or away == 2202 or away == 2675 or away == 2731 or away == 5493 or away == 2674 or away == 5489 or away == 2676 or away == 2503 or away == 2216 or away == 2678 or away == 2215 or away == 2200 or away == 4407) then
CornerFlag = "Competitions\\Liga 1_Movistar"
else
CornerFlag = "Default"
end
else
CornerFlag = "Default"
end

if tid then
return string.format("%s:%s", CornerFlag, filename)
end
end

local function get_filepath(ctx, filename, key)
if key then
return string.format("%s\\%s\\%s", fileroot, CornerFlag, filename)
end
end

local function trophy_rewrite(ctx, tournament_id)
log("-- " .. CornerFlag)
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