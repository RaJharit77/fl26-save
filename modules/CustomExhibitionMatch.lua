-- CustomExhibitionMatch.lua --
-------------------------------
-- A sider module to imitate competition style in local/exhibition match for PES 2021
-- This is possible by "tricking" the game and sider to think that the current competition & tournament ID is a certain value
-- LuaJIT FFI should be enabled. Enable it with "luajit.ext.enabled = 1" in sider.ini'
-- This sider module should be placed first on top of others, since it modifies the game and sider competition & tournament ID
--
-- Written and researched by mochnaufals
-- Credits to juce for sider
-- Originally posted on evoweb.uk
--
-- Version 1.0 (experimental)
-- Version 1.1 (experimental, added several competitions and polished the text UI)
-- Version 1.2 (experimental,
--              fix qualifiers comp_id using ejogc327's editor,
--              added cups, testimonials, world selection, ICC, and more,
--              added favorite selection feature)
-- Version 1.3 (experimental,
--              added final matches,
--              added AFC Champions League,
--              fix favorite selection settings (always load the favorite competition at the beginning of the game).
--              Notes on Final Match:
--              If you play Exhibition Match, mostly you will get the correct trophy, but sometimes the trophy will not be displayed.
--                                          However, there will be no trophy celebration at all.
--              If you play one legged final KONAMI Cup, there always will be trophy celebration.
--                                          However, sometimes the game will not display the correct trophy.
--                                          This is probably due to the module only changes the sider ctx.match_info,
--                                          not the actual game memory value that relates to final match.)

local m = {}

m.version = "1.3 (experimental)"
local raw_address_A = "-"
local raw_address_B = "-"
local mod_status = "DISABLED"
local final_pre_text = ""
local final_status = ""
local final_comment_text = ""
local final_press_text = ""
local selected_competition_index = 56
local favorite_competition
local folder = ".\\content\\custom-exhibition-match"
local settings
local TOGGLE_ENABLE_DISABLE_KEY = 0x30 -- 0 key (not the NUMPAD zero!!)
local TOGGLE_FINAL_KEY = 0x39 -- 9 key (not the NUMPAD 9!!)
local USE_FAV_COMP_KEY = 0x38  -- 8 key (not the NUMPAD 8!!)
local SET_FAV_COMP_KEY = 0x37  -- 7 key (not the NUMPAD 7!!)
local PAGE_UP_KEY = 0x21 -- PageUp key
local PAGE_DOWN_KEY = 0x22 -- PageDown key
local MAX_VISIBLE_COMPETITIONS = 5  -- Maximum number of competitions visible on the screen at once

local competition_list = {
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Format {name = "Competition Name", comp_id = Competition ID (game), sider_tid = Tournament ID (sider), sider_tid_final = Tournament ID of Final Match (sider), selected = false} --
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    {name = "Default Exhibition Mode (No Competition)", comp_id = -1, sider_tid = 65535, sider_tid_final = 65535, selected = false},
    {name = "AFC Asian Cup", comp_id = 35, sider_tid = 44, sider_tid_final = 45, selected = false},
    {name = "AFC Asian Qualifiers", comp_id = 31, sider_tid = 39, sider_tid_final = 39, selected = false},
    {name = "AFC Champions League", comp_id = 8, sider_tid = 15, sider_tid_final = 16, selected = false},
    {name = "Belgian Cup", comp_id = 112, sider_tid = 122, sider_tid_final = 122, selected = false},
    {name = "Belgian Super Cup", comp_id = 113, sider_tid = 128, sider_tid_final = 128, selected = false},
    {name = "CAF Africa Cup of Nations", comp_id = 36, sider_tid = 46, sider_tid_final = 46, selected = false},
    {name = "CAF African Qualifiers", comp_id = 32, sider_tid = 40, sider_tid_final = 40, selected = false},
    {name = "Chinese FA Cup", comp_id = 126, sider_tid = 127, sider_tid_final = 127, selected = false},
    {name = "Chinese FA Super Cup", comp_id = 127, sider_tid = 132, sider_tid_final = 132, selected = false},
    {name = "CONCACAF Qualifiers", comp_id = 29, sider_tid = 37, sider_tid_final = 37, selected = false},
    {name = "CONMEBOL Copa America", comp_id = 34, sider_tid = 104, sider_tid_final = 43, selected = false},
    {name = "CONMEBOL Libertadores", comp_id = 5, sider_tid = 8, sider_tid_final = 10, selected = false},
    {name = "CONMEBOL South American Qualifiers", comp_id = 30, sider_tid = 38, sider_tid_final = 38, selected = false},
    {name = "Copa Argentina", comp_id = 49, sider_tid = 59, sider_tid_final = 59, selected = false},
    {name = "Copa Chile", comp_id = 56, sider_tid = 68, sider_tid_final = 68, selected = false},
    {name = "Copa Colombia", comp_id = 123, sider_tid = 126, sider_tid_final = 126, selected = false},
    {name = "Copa del Rey", comp_id = 17, sider_tid = 25, sider_tid_final = 25, selected = false},
    {name = "Copa do Brasil", comp_id = 24, sider_tid = 31, sider_tid_final = 31, selected = false},
    {name = "Coppa Italia", comp_id = 16, sider_tid = 24, sider_tid_final = 24, selected = false},
    {name = "Coupe de France", comp_id = 18, sider_tid = 26, sider_tid_final = 26, selected = false},
    {name = "Danish Cup", comp_id = 129, sider_tid = 142, sider_tid_final = 142, selected = false},
    {name = "DFB Pokal (PEU Cup)", comp_id = 42, sider_tid = 53, sider_tid_final = 53, selected = false},
    {name = "DFL-Supercup (PEU Super Cup)", comp_id = 82, sider_tid = 95, sider_tid_final = 95, selected = false},
    {name = "FA Community Shield", comp_id = 73, sider_tid = 86, sider_tid_final = 86, selected = false},
    {name = "FA Cup", comp_id = 15, sider_tid = 23, sider_tid_final = 23, selected = false},
    {name = "FIFA Club World Cup", comp_id = 1, sider_tid = 1, sider_tid_final = 1, selected = false},
    {name = "FIFA World Cup", comp_id = 27, sider_tid = 34, sider_tid_final = 35, selected = false},
    {name = "Greek Football Cup (Swiss Cup)", comp_id = 118, sider_tid = 124, sider_tid_final = 124, selected = false},
    {name = "International Champions Cup NA", comp_id = 100, sider_tid = 105, sider_tid_final = 105, selected = false},
    {name = "International Champions Cup SA", comp_id = 101, sider_tid = 106, sider_tid_final = 106, selected = false},
    {name = "International Champions Cup Asia", comp_id = 102, sider_tid = 107, sider_tid_final = 107, selected = false},
    {name = "Japanese Super Cup (PAS Super Cup)", comp_id = 84, sider_tid = 97, sider_tid_final = 97, selected = false},
    {name = "JFA Emperor's Cup (PAS Cup)", comp_id = 44, sider_tid = 55, sider_tid_final = 55, selected = false},
    {name = "Johan Cruijff Schaal", comp_id = 77, sider_tid = 90, sider_tid_final = 90, selected = false},
    {name = "KNVB Cup", comp_id = 19, sider_tid = 27, sider_tid_final = 27, selected = false},
    {name = "KONAMI Cup", comp_id = 37, sider_tid = 47, sider_tid_final = 48, selected = false},
    {name = "KONAMI League", comp_id = 86, sider_tid = 99, sider_tid_final = 99, selected = false},
    {name = "MLS Cup / US Open Cup (PLA Cup)", comp_id = 43, sider_tid = 54, sider_tid_final = 54, selected = false},
    {name = "Practice/Training Match", comp_id = 46, sider_tid = 57, sider_tid_final = 57, selected = false},
    {name = "Russian Cup", comp_id = 115, sider_tid = 123, sider_tid_final = 123, selected = false},
    {name = "Russian Supercup", comp_id = 116, sider_tid = 129, sider_tid_final = 129, selected = false},
    {name = "Saudi King's Cup (Thai Cup)", comp_id = 140, sider_tid = 164, sider_tid_final = 164, selected = false},
    {name = "Saudi Super Cup (Thai Super Cup)", comp_id = 141, sider_tid = 165, sider_tid_final = 165, selected = false},
    {name = "Scottish Cup", comp_id = 138, sider_tid = 137, sider_tid_final = 137, selected = false},
    {name = "Supercopa Argentina", comp_id = 79, sider_tid = 92, sider_tid_final = 92, selected = false},
    {name = "Supercopa de España", comp_id = 74, sider_tid = 87, sider_tid_final = 87, selected = false},
    {name = "Supercoppa Italiana", comp_id = 76, sider_tid = 89, sider_tid_final = 89, selected = false},
    {name = "Superliga Colombiana", comp_id = 124, sider_tid = 131, sider_tid_final = 131, selected = false},
    {name = "Supertaça Cândido de Oliveira", comp_id = 78, sider_tid = 91, sider_tid_final = 91, selected = false},
    {name = "Taça de Portugal", comp_id = 20, sider_tid = 28, sider_tid_final = 28, selected = false},
    {name = "Testimonial Match", comp_id = 47, sider_tid = 58, sider_tid_final = 58, selected = false},
    {name = "TFF Süper Kupa", comp_id = 121, sider_tid = 130, sider_tid_final = 130, selected = false},
    {name = "Trophée des Champions", comp_id = 75, sider_tid = 88, sider_tid_final = 88, selected = false},
    {name = "Türkiye Kupası", comp_id = 120, sider_tid = 125, sider_tid_final = 125, selected = false},
    {name = "UEFA Champions League", comp_id = 2, sider_tid = 2, sider_tid_final = 4, selected = false},
    {name = "UEFA EURO", comp_id = 33, sider_tid = 41, sider_tid_final = 42, selected = false},
    {name = "UEFA Europa League", comp_id = 3, sider_tid = 5, sider_tid_final = 6, selected = false},
    {name = "UEFA European Qualifiers", comp_id = 28, sider_tid = 36, sider_tid_final = 36, selected = false},
    {name = "UEFA Super Cup", comp_id = 4, sider_tid = 7, sider_tid_final = 7, selected = false},
    {name = "World Selection Challenge", comp_id = 103, sider_tid = 108, sider_tid_final = 108, selected = false}
}
local comp_text

function save_ini(filename)
    local f = io.open(folder .. "\\" .. filename, "wt")
    f:write(string.format("# CustomExhibitionMatch settings. Generated by CustomExhibitionMatch.lua\n"))
    f:write("\n")
    local keys = {}
    for name,value in pairs(settings) do
        keys[#keys + 1] = name
    end
    table.sort(keys)
    for i,name in ipairs(keys) do
        local value = settings[name]
        f:write(string.format("%s = %s\n", name, value))
    end
    f:write("\n")
    f:close()
end

function load_ini(filename)
    local t = {}
    local filepath = folder .. "\\" .. filename

    -- Attempt to open the file for reading
    local file, err = io.open(filepath, "r")

    if not file then
        -- If the file doesn't exist, create an empty one
        log("Creating a new file: " .. filepath)
        file, err = io.open(filepath, "w")

        if not file then
            error("Error creating file: " .. err)
        end
		
		-- Write default lines
		file:write(string.format("# CustomExhibitionMatch settings. Generated by CustomExhibitionMatch.lua\n"))
		file:write("\n")
		file:write(string.format("version = %s", m.version))
		file:write("\n")
		file:write(string.format("favorite_competition = %s", selected_competition_index))

        -- Close the file after creating it
        file:close()
		
		t["version"] = m.version
		t["favorite_competition"] = selected_competition_index
    else
        -- Log that the file is found
        log(filename .. " found in " .. folder)

        -- Read the content of the file (always return string)
        for line in file:lines() do
            local name, value = string.match(line, "^([%w_]+)%s*=%s*([-%w%d.]+)")
            if name and value then
                -- value = tonumber(value) or value
                t[name] = value
                log(string.format("Using setting: %s = %s", name, value))
            end
        end

        -- Close the file after reading it
        file:close()
		
		selected_competition_index = tonumber(t["favorite_competition"])
    end

    return t
end

function update_options()
	comp_text = ""
	
    -- Calculate the start_index to ensure the selected competition is visible
    local start_index = math.max(1, selected_competition_index - math.floor(MAX_VISIBLE_COMPETITIONS / 2))
    
    -- Calculate the end_index based on the start_index and the maximum visible competitions
    local end_index = math.min(start_index + MAX_VISIBLE_COMPETITIONS - 1, #competition_list)
    
    -- Adjust the start_index if the end_index is too close to the end of the competition list
    start_index = math.max(1, end_index - MAX_VISIBLE_COMPETITIONS + 1)
	
	-- for i, option in ipairs(competition_list) do
	for i = start_index, end_index do
		local checkbox = "[ ]"
		if i == selected_competition_index then
			checkbox = "[x]"
		end
		comp_text = comp_text .. checkbox .. " " .. competition_list[i].name .. "\n"
	end

    -- Add a placeholder line when not all competitions are visible
    if start_index > 1 then
        comp_text = "---------- (more) ----------\n" .. comp_text
    end

    if end_index < #competition_list then
        comp_text = comp_text .. "---------- (more) ----------\n"
    end
end

function toggle_selection()
	for i, option in ipairs(competition_list) do
		competition_list.selected = (i == selected_competition_index)
	end
end

function change_tid(ctx)
	-- Game competition ID addres should be at 0x7FF4____5970
	-- This address is appeared on ctx.mis address
	-- We can use that address, assign it to a pointer, and change the value
	if ctx.mis then
		raw_address_A = ("%p"):format(ctx.mis)
		raw_address_B = string.format("0x%x", tonumber(raw_address_A)+0x84) -- New finding: +0x84 offset from original memory address
		if string.sub(raw_address_A, 1, 2) == "0x" and mod_status == "ENABLED" then
			local ptr_A = ffi.cast("int*", tonumber(raw_address_A))		
			local ptr_B = ffi.cast("int*", tonumber(raw_address_B))
			
			-- change value
			ptr_A[0] = competition_list[selected_competition_index]["comp_id"]
			ptr_B[0] = competition_list[selected_competition_index]["comp_id"]
			
			-- change tournament_id
			-- sider tournament_id is actually different than the game competiton ID
			-- so, we need to change it manually
			ctx.tournament_id = competition_list[selected_competition_index]["sider_tid"]
			
			if final_status == "SIMULATED" then
				-- Simulate final match if activated
				-- This will assign the sider_tid_final value to ctx.tournament_id
				-- This will also change the ctx.match_info to 53
				ctx.tournament_id = competition_list[selected_competition_index]["sider_tid_final"]
				ctx.match_info = 53
			end
		end
	end
end

function m.overlay_on(ctx)
	return string.format([[version %s
A sider module to imitate competition style in local/exhibition match by mochnaufals.
Target memory addresses: %s, %s

This module is currently %s%s%s%s
Press [0] to toggle enable/disable the mod.%s
Press [8] to use your favorite competition.
Press [7] to set your favorite competition.
Press [PageUp] and [PageDown] to change the selected competition:

%s
]], m.version, raw_address_A, raw_address_B, mod_status, final_pre_text, final_status, final_comment_text, final_press_text, comp_text)
end

function m.key_down(ctx, vkey)
	if vkey == TOGGLE_ENABLE_DISABLE_KEY then
		if mod_status == "DISABLED" then
			mod_status = "ENABLED"
			final_pre_text = "\nFinal match is currently "
			final_status = "NOT SIMULATED"
			final_comment_text = ""
			final_press_text = "\nPress [9] to toggle final match simulation."
		elseif mod_status == "ENABLED" then
			mod_status = "DISABLED"
			final_pre_text = ""
			final_status = ""
			final_comment_text = ""
			final_press_text = ""
		end
	end
	if vkey == TOGGLE_FINAL_KEY then
		if final_status == "NOT SIMULATED" then
			final_status = "SIMULATED"
			final_comment_text = " (play KONAMI Cup for better final match experience)"
		elseif final_status == "SIMULATED" then
			final_status = "NOT SIMULATED"
			final_comment_text = ""
		end
	end
	if vkey == PAGE_UP_KEY and selected_competition_index > 1 then
		selected_competition_index = selected_competition_index - 1
		toggle_selection()
		update_options()
		change_tid(ctx)
	end
	if vkey == PAGE_DOWN_KEY and selected_competition_index < #competition_list then
		selected_competition_index = selected_competition_index + 1
		toggle_selection()
		update_options()
		change_tid(ctx)
	end
	if vkey == SET_FAV_COMP_KEY then
		settings["version"] = m.version
		settings["favorite_competition"] = selected_competition_index
		save_ini("config.ini")
	end
	if vkey == USE_FAV_COMP_KEY then
		settings = load_ini("config.ini")
		toggle_selection()
		update_options()
		change_tid(ctx)
	end
end

function m.set_teams(ctx, home, away)
	change_tid(ctx)
end

function m.data_ready(ctx, filename, data, size, total_size, offset, cpk_filename)
	change_tid(ctx)
end

-- function m.make_key(ctx, filename)
-- -- I'm not sure but I don't think we need to change the tournament_id during making key
	-- change_tid(ctx)
-- end

function m.init(ctx)
    if not ffi then
        error('LuaJIT FFI is disabled. Enable it with "luajit.ext.enabled = 1" in sider.ini')
    end
	if folder:sub(1,1)=='.' then
        folder = ctx.sider_dir .. folder
    end
	settings = load_ini("config.ini")
    ctx.register("set_teams", m.set_teams)
	ctx.register("livecpk_data_ready", m.data_ready)
	-- ctx.register("livecpk_make_key", m.make_key)
	ctx.register("overlay_on", m.overlay_on)
	ctx.register("key_down", m.key_down)
	update_options()
end

return m