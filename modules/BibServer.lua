-- Bib Server module for PES 2021: assign bibs to tournaments
-- Custom content is used, not LiveCPK/game: content\bibserver is the root
-- Author: Hawke, 2022
-- Version: 1.0
-- Originally posted on evo-web

local fileroot = ".\\content\\bibserver"

local function make_key(ctx, filename)
	tid = ctx.tournament_id

--Tournament Bibs
	if (tid == 2 or tid == 1026 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or tid == 3 or tid == 1027  or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195 or tid == 4) then
	bibserver = "Bibs\\UCL"
	elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4101 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
        bibserver = "Bibs\\UEL"
	elseif tid == 7 then
        bibserver = "Bibs\\USC"
	elseif tid == 19 then
	bibserver = "Bibs\\Liga Santander"
        elseif tid == 25 then
	bibserver = "Bibs\\Copa del Rey"
        elseif tid == 87 then
	bibserver = "Bibs\\Supercopa de España"
        elseif (tid == 80 or tid == 84) then
	bibserver = "Bibs\\Liga Smartbank"
	elseif tid == 50 then
        bibserver = "Bibs\\Bundesliga"
        elseif tid == 53 then
        bibserver = "Bibs\\DFB-Pokal"
        elseif tid == 95 then
        bibserver = "Bibs\\DFL-Supercup"
	elseif tid == 18 then
        bibserver = "Bibs\\Serie A"
        elseif (tid == 82 or tid == 85) then
	bibserver = "Bibs\\Serie B"
        elseif tid == 24 then
        bibserver = "Bibs\\Coppa Italia"
        elseif tid == 89 then
        bibserver = "Bibs\\Supercoppa Italiana"
        elseif tid == 17 then
	bibserver = "Bibs\\Premier League"
        elseif (tid == 79 or tid == 83) then
	bibserver = "Bibs\\EFL"
        elseif tid == 23 then
	bibserver = "Bibs\\FA Cup"
        elseif tid == 86 then
	bibserver = "Bibs\\FA Community Shield"
        elseif tid == 22 then
	bibserver = "Bibs\\Liga Portugal"
        elseif tid == 20 then
        bibserver = "Bibs\\Ligue1"
        elseif tid == 81 then
	bibserver = "Bibs\\Ligue2"
        elseif tid == 26 then
        bibserver = "Bibs\\Coupe de France"
        elseif tid == 88 then
        bibserver = "Bibs\\Trophée des Champions"
        elseif (tid == 105 or tid == 106 or tid == 107) then
        bibserver = "Bibs\\ICC"
        elseif tid == 1 then
	bibserver = "Bibs\\FCWC"
        elseif (tid == 34 or tid == 35 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226) then
        bibserver = "Bibs\\FWC"
        elseif (tid == 41 or tid == 42 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185) then
        bibserver = "Bibs\\Euro 2024"
    else
        bibserver = "Default"
	end
    if bibserver ~= nil then
        return string.format("%s:%s", bibserver, filename)
    end
end

local function get_filepath(ctx, filename, key)
    if key and bibserver ~= nil then
        return string.format("%s\\%s\\%s", fileroot, bibserver, filename)
    end
end



local function init(ctx)
    if fileroot:sub(1,1)=='.' then
        fileroot = ctx.sider_dir .. fileroot
    end
    ctx.register("livecpk_make_key", make_key)
    ctx.register("livecpk_get_filepath", get_filepath)
end

return { init = init }