-- Stadium Tunnel module for PES 2020: assign a stadium tunnel to home team
-- Custom content is used, not LiveCPK/game: content\Stadium_Tunnel is the root
-- author: Hawke, 2018 (from PES 2019)
-- edited script: FuNZoTiK, 2020
-- version: 1.1
-- originally posted on evo-web

local fileroot = ".\\content\\Stadium_Tunnel"
local rdm = 1

local function get_ids(ctx)
    rdm = math.random(1,4)
end

local function make_key(ctx, filename)

-- Competition ----------------------------------------------------------------

    if ctx.tournament_id == 2 or ctx.tournament_id == 1026 or ctx.tournament_id == 2050
        or ctx.tournament_id == 3074 or ctx.tournament_id == 4098 or ctx.tournament_id == 5122
        or ctx.tournament_id == 6146 or ctx.tournament_id == 7170 or ctx.tournament_id == 8194 then

        Stadium_Tunnel = "Competition\\UEFA Champions League\\Group_Knockout\\cutscene_" .. rdm

    elseif ctx.tournament_id == 3 or ctx.tournament_id == 1027 or ctx.tournament_id == 2051
        or ctx.tournament_id == 3075 or ctx.tournament_id == 4099 or ctx.tournament_id == 5123
        or ctx.tournament_id == 6147 or ctx.tournament_id == 7171 or ctx.tournament_id == 8195
        or ctx.tournament_id == 4 then

        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\UEFA Champions League\\Final"
        else
            Stadium_Tunnel = "Competition\\UEFA Champions League\\Group_Knockout\\cutscene_" .. rdm
        end

    elseif ctx.tournament_id == 7 then
        Stadium_Tunnel = "Competition\\UEFA Super Cup"

    elseif ctx.tournament_id == 41 or ctx.tournament_id == 42 or ctx.tournament_id == 43
        or ctx.tournament_id == 1065 or ctx.tournament_id == 2089 or ctx.tournament_id == 3113
        or ctx.tournament_id == 4137 or ctx.tournament_id == 5161 or ctx.tournament_id == 6185 then

        Stadium_Tunnel = "Competition\\UEFA Euro"

    elseif ctx.tournament_id == 34 or ctx.tournament_id == 1058 or ctx.tournament_id == 2082
        or ctx.tournament_id == 3106 or ctx.tournament_id == 4130 or ctx.tournament_id == 5154
        or ctx.tournament_id == 6178 or ctx.tournament_id == 7202 or ctx.tournament_id == 8226
        or ctx.tournament_id == 35 then

        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\FIFA World Cup\\Final"
        else
            Stadium_Tunnel = "Competition\\FIFA World Cup"
        end

    elseif ctx.tournament_id == 1 then
        Stadium_Tunnel = "Competition\\FIFA Club World Cup"

    elseif ctx.tournament_id == 43 or ctx.tournament_id == 104 or ctx.tournament_id == 1128
        or ctx.tournament_id == 2152 or ctx.tournament_id == 3176 then

        Stadium_Tunnel = "Competition\\Copa America"

    elseif ctx.tournament_id == 40 or ctx.tournament_id == 46 or ctx.tournament_id == 1064
        or ctx.tournament_id == 2088 then

        Stadium_Tunnel = "Competition\\Africa Nations League"

    elseif ctx.tournament_id == 39 or ctx.tournament_id == 46 or ctx.tournament_id == 1063
        or ctx.tournament_id == 2087 or ctx.tournament_id == 44 or ctx.tournament_id == 1068
        or ctx.tournament_id == 2092 or ctx.tournament_id == 3116 or ctx.tournament_id == 4140
        or ctx.tournament_id == 45 then

        Stadium_Tunnel = "Competition\\Asia Nations League"

    elseif ctx.tournament_id == 24 then
        Stadium_Tunnel = "Competition\\Coppa Italia"

    elseif ctx.tournament_id == 89 then
        Stadium_Tunnel = "Competition\\Supercoppa Italiana"

    elseif ctx.tournament_id == 23 then
        Stadium_Tunnel = "Competition\\FA CUP"

    elseif ctx.tournament_id == 86 then
        Stadium_Tunnel = "Competition\\COMMUNITY SHIELD"

    elseif ctx.tournament_id == 26 then
        Stadium_Tunnel = "Competition\\Coupe de France"

    elseif ctx.tournament_id == 88 then
        Stadium_Tunnel = "Competition\\Trophee des champions"

    elseif ctx.tournament_id == 25 then
        Stadium_Tunnel = "Competition\\Copa del Rey"

    elseif ctx.tournament_id == 87 then
        Stadium_Tunnel = "Competition\\Supercopa de Espana"

    elseif ctx.tournament_id == 53 then
        Stadium_Tunnel = "Competition\\DFB-Pokal"

    elseif ctx.tournament_id == 17 then
        Stadium_Tunnel = "Competition\\Premier League"

    elseif ctx.tournament_id == 79 or ctx.tournament_id == 83 then
        Stadium_Tunnel = "Competition\\EFL"

    elseif ctx.tournament_id == 18 then
        Stadium_Tunnel = "Competition\\Serie A"

    elseif ctx.tournament_id == 20 then
        Stadium_Tunnel = "Competition\\Ligue 1 Uber Eats"

    elseif ctx.tournament_id == 19 then
        Stadium_Tunnel = "Competition\\La Liga"

    elseif ctx.tournament_id == 80 or ctx.tournament_id == 84 then
        Stadium_Tunnel = "Competition\\La Liga2"

    elseif ctx.tournament_id == 119 or ctx.tournament_id == 160 or ctx.tournament_id == 161
        or ctx.tournament_id == 168 or ctx.tournament_id == 169 then

        Stadium_Tunnel = "Competition\\Liga BetPlay Dimayor"

    elseif ctx.tournament_id == 51 or ctx.tournament_id == 166 or ctx.tournament_id == 167 then
        Stadium_Tunnel = "Competition\\Liga 1Betsson"

    elseif ctx.tournament_id == 120 then
        Stadium_Tunnel = "Competition\\MLS"

    elseif ctx.tournament_id == 50 then
        Stadium_Tunnel = "Competition\\Bundesliga"

    elseif ctx.tournament_id == 67 then
        Stadium_Tunnel = "Competition\\Campeonato PlanVital"

    elseif ctx.tournament_id == 68 then
        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\Copa Chile\\Final"
        elseif ctx.home_team == 1256 then
            Stadium_Tunnel = "Team\\Colo Colo"
        else
            Stadium_Tunnel = "Competition\\Copa Chile\\Group_Knockout\\cutscene_" .. rdm
        end

    elseif ctx.tournament_id == 59 then
        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\Copa Argentina\\Final"
        else
            Stadium_Tunnel = "Competition\\Copa Argentina\\Group_Knockout\\cutscene_" .. rdm
        end

    elseif ctx.tournament_id == 5 or ctx.tournament_id == 1029 or ctx.tournament_id == 2053
        or ctx.tournament_id == 3077 or ctx.tournament_id == 4101 or ctx.tournament_id == 5125
        or ctx.tournament_id == 6149 or ctx.tournament_id == 7173 or ctx.tournament_id == 8197
        or ctx.tournament_id == 9221 or ctx.tournament_id == 10245 or ctx.tournament_id == 11269
        or ctx.tournament_id == 12293 or ctx.tournament_id == 6 then

        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\UEFA Europa League\\Final"
        else
            Stadium_Tunnel = "Competition\\UEFA Europa League\\Group_Knockout\\cutscene_" .. rdm
        end

    elseif ctx.tournament_id == 8 or ctx.tournament_id == 1032 or ctx.tournament_id == 2056
        or ctx.tournament_id == 3080 or ctx.tournament_id == 4104 or ctx.tournament_id == 9
        or ctx.tournament_id == 1033 or ctx.tournament_id == 2057 or ctx.tournament_id == 3081
        or ctx.tournament_id == 4105 or ctx.tournament_id == 5129 or ctx.tournament_id == 6153
        or ctx.tournament_id == 7177 or ctx.tournament_id == 8201 or ctx.tournament_id == 10 then

        if ctx.match_info == 53 then
            Stadium_Tunnel = "Competition\\CONMEBOL Libertadores\\Final"
        else
            Stadium_Tunnel = "Competition\\CONMEBOL Libertadores\\Group_Knockout\\cutscene_" .. rdm
        end

    elseif ctx.tournament_id == 15 or ctx.tournament_id == 1039 or ctx.tournament_id == 2063
        or ctx.tournament_id == 3087 or ctx.tournament_id == 4111 or ctx.tournament_id == 5135
        or ctx.tournament_id == 6159 or ctx.tournament_id == 7183 or ctx.tournament_id == 8207
        or ctx.tournament_id == 16 then

        Stadium_Tunnel = "Competition\\AFC Champions League"
    end

-- TEAM SECTION (fixed start!) ------------------------------------------------

    ------------------------------------------------
    -- IMPORTANT FIX: new IF instead of ELSEIF !!!
    ------------------------------------------------
    if ctx.home_team == 116 then
        Stadium_Tunnel = "Team\\Ajax"
    elseif ctx.home_team == 2717 then
        Stadium_Tunnel = "Team\\Aldosivi"
    elseif ctx.home_team == 1236 then
        Stadium_Tunnel = "Team\\Argentinos Juniors"
    elseif ctx.home_team == 101 then
        Stadium_Tunnel = "Team\\Arsenal"
    elseif ctx.home_team == 1921 then
        Stadium_Tunnel = "Team\\Arsenal de Sarandi"
    elseif ctx.home_team == 317 then
        Stadium_Tunnel = "Team\\Ascoli"
    elseif ctx.home_team == 107 then
        Stadium_Tunnel = "Team\\Aston Villa"
    elseif ctx.home_team == 172 then
        Stadium_Tunnel = "Team\\Atletico Madrid"
    elseif ctx.home_team == 180 then
        Stadium_Tunnel = "Team\\Auxerre"
    elseif ctx.home_team == 242 then
        Stadium_Tunnel = "Team\\AZ"
    elseif ctx.home_team == 1927 then
        Stadium_Tunnel = "Team\\Banfield"
    elseif ctx.home_team == 191 then
        Stadium_Tunnel = "Team\\Benfica"
    elseif ctx.home_team == 194 then
        Stadium_Tunnel = "Team\\Betis"
    elseif ctx.home_team == 139 then
        Stadium_Tunnel = "Team\\Boca Juniors"
    elseif ctx.home_team == 186 then
        Stadium_Tunnel = "Team\\Bologna"
    elseif ctx.home_team == 115 then
        Stadium_Tunnel = "Team\\Bordeaux"
    elseif ctx.home_team == 45 then
        Stadium_Tunnel = "Team\\Brasil"
    elseif ctx.home_team == 405 then
        Stadium_Tunnel = "Team\\Caen"
    elseif ctx.home_team == 2719 then
        Stadium_Tunnel = "Team\\CA Tucuman"
    elseif ctx.home_team == 131 then
        Stadium_Tunnel = "Team\\Celtic"
    elseif ctx.home_team == 102 then
        Stadium_Tunnel = "Team\\Chelsea"
    elseif ctx.home_team == 1923 then
        Stadium_Tunnel = "Team\\Colon"
    elseif ctx.home_team == 4995 then
        Stadium_Tunnel = "Team\\Cordoba"
    elseif ctx.home_team == 2722 then
        Stadium_Tunnel = "Team\\Defensa y Justicia"
    elseif ctx.home_team == 1239 then
        Stadium_Tunnel = "Team\\Esgrima la plata"
    elseif ctx.home_team == 1238 then
        Stadium_Tunnel = "Team\\Estudiantes la plata"
    elseif ctx.home_team == 126 then
        Stadium_Tunnel = "Team\\Dortmund"
    elseif ctx.home_team == 5 then
        Stadium_Tunnel = "Team\\England"
    elseif ctx.home_team == 251 then
        Stadium_Tunnel = "Team\\FC Utrecht"
    elseif ctx.home_team == 244 then
        Stadium_Tunnel = "Team\\FC Groningen"
    elseif ctx.home_team == 117 then
        Stadium_Tunnel = "Team\\Feyenoord"
    elseif ctx.home_team == 8 then
        Stadium_Tunnel = "Team\\France"
    elseif ctx.home_team == 14 then
        Stadium_Tunnel = "Team\\Germany"
    elseif ctx.home_team == 2187 then
        Stadium_Tunnel = "Team\\Girona"
    elseif ctx.home_team == 1924 then
        Stadium_Tunnel = "Team\\Godoy Cruz"
    elseif ctx.home_team == 211 then
        Stadium_Tunnel = "Team\\Guingamp"
    elseif ctx.home_team == 1922 then
        Stadium_Tunnel = "Team\\Huracan"
    elseif ctx.home_team == 1240 then
        Stadium_Tunnel = "Team\\Independiente"
    elseif ctx.home_team == 119 then
        Stadium_Tunnel = "Team\\Inter"
    elseif ctx.home_team == 1929 then
        Stadium_Tunnel = "Team\\Lanus"
    elseif ctx.home_team == 122 then
        Stadium_Tunnel = "Team\\Lazio"
    elseif ctx.home_team == 103 then
        Stadium_Tunnel = "Team\\Liverpool"
    elseif ctx.home_team == 181 then
        Stadium_Tunnel = "Team\\Lyon"
    elseif ctx.home_team == 173 then
        Stadium_Tunnel = "Team\\Manchester City"
    elseif ctx.home_team == 113 then
        Stadium_Tunnel = "Team\\Marseille"
    elseif ctx.home_team == 121 then
        Stadium_Tunnel = "Team\\Milan"
    elseif ctx.home_team == 112 then
        Stadium_Tunnel = "Team\\Monaco"
    elseif ctx.home_team == 327 then
        Stadium_Tunnel = "Team\\Napoli"
    elseif ctx.home_team == 217 then
        Stadium_Tunnel = "Team\\Nice"
    elseif ctx.home_team == 2729 then
        Stadium_Tunnel = "Team\\Patronato"
    elseif ctx.home_team == 114 then
        Stadium_Tunnel = "Team\\Paris SG"
    elseif ctx.home_team == 5454 then
        Stadium_Tunnel = "Team\\Platense"
    elseif ctx.home_team == 47 then
        Stadium_Tunnel = "Team\\Chile"
    elseif ctx.home_team == 19 then
        Stadium_Tunnel = "Team\\Poland"
    elseif ctx.home_team == 192 then
        Stadium_Tunnel = "Team\\Porto"
    elseif ctx.home_team == 256 then
        Stadium_Tunnel = "Team\\PEC Zwolle"
    elseif ctx.home_team == 1237 then
        Stadium_Tunnel = "Team\\Racing Club"
    elseif ctx.home_team == 109 then
        Stadium_Tunnel = "Team\\Real Madrid"
    elseif ctx.home_team == 218 then
        Stadium_Tunnel = "Team\\Rennes"
    elseif ctx.home_team == 138 then
        Stadium_Tunnel = "Team\\River Plate"
    elseif ctx.home_team == 125 then
        Stadium_Tunnel = "Team\\Roma"
    elseif ctx.home_team == 1242 then
        Stadium_Tunnel = "Team\\Rosario Central"
    elseif ctx.home_team == 1243 then
        Stadium_Tunnel = "Team\\San Lorenzo"
    elseif ctx.home_team == 418 then
        Stadium_Tunnel = "Team\\Saint Etienne"
    elseif ctx.home_team == 265 then
        Stadium_Tunnel = "Team\\Sevilla"
    elseif ctx.home_team == 5046 then
        Stadium_Tunnel = "Team\\Talleres"
    elseif ctx.home_team == 5655 then
        Stadium_Tunnel = "Team\\Alvarado"
    elseif ctx.home_team == 2702 then
        Stadium_Tunnel = "Team\\San Martin"
    elseif ctx.home_team == 179 then
        Stadium_Tunnel = "Team\\Tottenham"
    elseif ctx.home_team == 110 then
        Stadium_Tunnel = "Team\\Valencia"
    elseif ctx.home_team == 267 then
        Stadium_Tunnel = "Team\\Villarreal"
    elseif ctx.home_team == 208 then
        Stadium_Tunnel = "Team\\Wolverhampton"
    elseif ctx.home_team == 1262 then
        Stadium_Tunnel = "Team\\Club Nacional"
    elseif ctx.home_team == 4108 then
        Stadium_Tunnel = "Team\\Chapecoense"
    elseif ctx.home_team == 1250 then
        Stadium_Tunnel = "Team\\Gremio"
    elseif ctx.home_team == 137 then
        Stadium_Tunnel = "Team\\Palmeiras"
    elseif ctx.home_team == 2287 then
        Stadium_Tunnel = "Team\\Alianza Lima"
    elseif ctx.home_team == 2730 then
        Stadium_Tunnel = "Team\\Sarmiento"
    elseif ctx.home_team == 2216 then
        Stadium_Tunnel = "Team\\Sporting Cristal"
    elseif ctx.home_team == 2538 then
        Stadium_Tunnel = "Team\\Union"
    elseif ctx.home_team == 2215 then
        Stadium_Tunnel = "Team\\Universitario"
    elseif ctx.home_team == 46 then
        Stadium_Tunnel = "Team\\Peru"
    elseif ctx.home_team == 2202 then
        Stadium_Tunnel = "Team\\Cienciano"
    elseif ctx.home_team == 2674 then
        Stadium_Tunnel = "Team\\Melgar"
    elseif ctx.home_team == 1241 then
        Stadium_Tunnel = "Team\\Newells"
    elseif ctx.home_team == 1244 then
        Stadium_Tunnel = "Team\\Velez"
    elseif ctx.home_team == 2544 then
        Stadium_Tunnel = "Team\\Deportes La Serena"
    elseif ctx.home_team == 2191 then
        Stadium_Tunnel = "Team\\Universidad Católica"
    elseif ctx.home_team == 1264 then
        Stadium_Tunnel = "Team\\America"
    elseif ctx.home_team == 1265 then
        Stadium_Tunnel = "Team\\Cruz Azul"
    elseif ctx.home_team == 1700 then
        Stadium_Tunnel = "Team\\Chivas"
    elseif ctx.home_team == 1775 then
        Stadium_Tunnel = "Team\\Pumas"
    elseif ctx.home_team == 1773 then
        Stadium_Tunnel = "Team\\Toluca"
    elseif ctx.home_team == 1782 then
        Stadium_Tunnel = "Team\\Tigres"
    elseif ctx.home_team == 1778 then
        Stadium_Tunnel = "Team\\Monterrey"
    elseif ctx.home_team == 1789 then
        Stadium_Tunnel = "Team\\Leon"
    elseif ctx.home_team == 1777 then
        Stadium_Tunnel = "Team\\Atlas"
    elseif ctx.home_team == 5379 then
        Stadium_Tunnel = "Team\\San Luis"
    elseif ctx.home_team == 1785 then
        Stadium_Tunnel = "Team\\Tijuana"
    elseif ctx.home_team == 5153 then
        Stadium_Tunnel = "Team\\Juarez"
    elseif ctx.home_team == 1792 then
        Stadium_Tunnel = "Team\\Queretaro"
    elseif ctx.home_team == 5730 then
        Stadium_Tunnel = "Team\\Mazatlan"
    elseif ctx.home_team == 5130 then
        Stadium_Tunnel = "Team\\Necaxa"
    elseif ctx.home_team == 1699 then
        Stadium_Tunnel = "Team\\Pachuca"
    elseif ctx.home_team == 1772 then
        Stadium_Tunnel = "Team\\Puebla"
    elseif ctx.home_team == 1779 then
        Stadium_Tunnel = "Team\\Santos Laguna"

    elseif ctx.home_team == 377 then
        Stadium_Tunnel = "EPL\\BRIGHTON"
    elseif ctx.home_team == 378 then
        Stadium_Tunnel = "EPL\\BURNLEY"
    elseif ctx.home_team == 382 then
        Stadium_Tunnel = "EPL\\Crystal Palace"
    elseif ctx.home_team == 106 then
        Stadium_Tunnel = "EPL\\Newcastle"
    elseif ctx.home_team == 399 then
        Stadium_Tunnel = "EPL\\West Brom"
    elseif ctx.home_team == 4194 then
        Stadium_Tunnel = "EPL\\Sheff Utd"
    elseif ctx.home_team == 207 then
        Stadium_Tunnel = "EPL\\Southampton"
    elseif ctx.home_team == 178 then
        Stadium_Tunnel = "EPL\\Fulham"
    elseif ctx.home_team == 104 then
        Stadium_Tunnel = "EPL\\Leeds"
    elseif ctx.home_team == 105 then
        Stadium_Tunnel = "EPL\\West Ham"
    elseif ctx.home_team == 204 then
        Stadium_Tunnel = "EPL\\Leicester City"
    elseif ctx.home_team == 177 then
        Stadium_Tunnel = "EPL\\Everton"

    elseif ctx.home_team == 4124 then
        Stadium_Tunnel = "Bundesliga\\Augsburg"
    elseif ctx.home_team == 4127 then
        Stadium_Tunnel = "Bundesliga\\Bielefeld"
    elseif ctx.home_team == 185 then
        Stadium_Tunnel = "Bundesliga\\Bremen"
    elseif ctx.home_team == 226 then
        Stadium_Tunnel = "Bundesliga\\Frankfurt"
    elseif ctx.home_team == 225 then
        Stadium_Tunnel = "Bundesliga\\Gladbach"
    elseif ctx.home_team == 4125 then
        Stadium_Tunnel = "Bundesliga\\Hertha BSC"
    elseif ctx.home_team == 436 then
        Stadium_Tunnel = "Bundesliga\\Mainz"
    elseif ctx.home_team == 231 then
        Stadium_Tunnel = "Bundesliga\\Stuttgart"
    elseif ctx.home_team == 232 then
        Stadium_Tunnel = "Bundesliga\\Wolfsburg"
    else
        Stadium_Tunnel = "Generic"
    end

    if Stadium_Tunnel ~= nil then
        return string.format("%s:%s", Stadium_Tunnel, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key and Stadium_Tunnel ~= nil then
        return string.format("%s\\%s\\%s", fileroot, Stadium_Tunnel, filename)
    end
end

local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("set_conditions", get_ids)
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }
