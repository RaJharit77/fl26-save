local m = { version = "2.0" }

local FREQUENCY_AOB = '\x3B\xC7\x0F\x8D\xDA\x01\x00\x00'
local SEVERITY_AOB = '\xC7\x44\x24\x60\x0D\x00\x00\x00\x48\x8D\x95'
local CAVE_AOB = string.rep('\xCC', 32)

local frequency_addr = nil
local severity_addr = nil
local cave_addr = nil
local frequency_num = nil
local severity_num = nil
local cave_num = nil

local enabled_frequency = false
local enabled_severity = false

local WEIGHTING_LEVEL = 3

local WEIGHTING_PRESETS = {
    {
        name = "Safe Space",
        desc = "Nearly no long term injuries",
        weights = {
            {0x17, 88},   -- 88%: max 29 days (under 1 month)
            {0x3C, 7},    -- 7%: max 66 days (~2 months)
            {0x78, 3},    -- 3%: max 126 days (~4 months)
            {0xB4, 1},    -- 1%: max 186 days (~6 months)
            {0xF8, 1}     -- 1%: max 254 days (~8 months)
        }
    },
    {
        name = "Standard",
        desc = "slight chance of long term injuries",
        weights = {
            {0x17, 55},   -- 55%: max 29 days
            {0x3C, 22},   -- 22%: max 66 days
            {0x78, 13},   -- 13%: max 126 days
            {0xB4, 6},    -- 6%: max 186 days
            {0xF8, 4}     -- 4%: max 254 days
        }
    },
    {
        name = "Realistic",
        desc = "You will see long term injuries!",
        weights = {
            {0x17, 30},   -- 30%: max 29 days
            {0x3C, 30},   -- 30%: max 66 days
            {0x78, 22},   -- 22%: max 126 days
            {0xB4, 11},   -- 11%: max 186 days
            {0xF8, 7}     -- 7%: max 254 days
        }
    },
    {
        name = "Severe",
        desc = "60% of injuries are serious",
        weights = {
            {0x17, 18},   -- 18%: max 29 days
            {0x3C, 28},   -- 28%: max 66 days
            {0x78, 28},   -- 28%: max 126 days
            {0xB4, 16},   -- 16%: max 186 days
            {0xF8, 10}    -- 10%: max 254 days
        }
    },
    {
        name = "Brutal",
        desc = "Good luck!",
        weights = {
            {0x17, 8},    -- 8%: max 29 days
            {0x3C, 20},   -- 20%: max 66 days
            {0x78, 32},   -- 32%: max 126 days
            {0xB4, 24},   -- 24%: max 186 days
            {0xF8, 16}    -- 16%: max 254 days
        }
    }
}

local function save_settings(freq, weight)
    local file = io.open("injury_mod_settings.txt", "w")
    if file then
        file:write(tostring(freq) .. "\n")
        file:write(tostring(weight))
        file:close()
    end
end

local function load_settings()
    local file = io.open("injury_mod_settings.txt", "r")
    if file then
        local freq = tonumber(file:read("*l"))
        local weight = tonumber(file:read("*l"))
        file:close()
        return freq, weight
    end
    return nil, nil
end

local saved_freq, saved_weight = load_settings()
local FREQUENCY_MODIFIER = saved_freq or 1
WEIGHTING_LEVEL = saved_weight or 3

local function int_to_bytes(n)
    if n < 0 then
        n = n + 0x100000000
    end
    local b1 = n % 256
    local b2 = math.floor(n / 256) % 256
    local b3 = math.floor(n / 65536) % 256
    local b4 = math.floor(n / 16777216) % 256
    return string.char(b1, b2, b3, b4)
end

local function ptr_to_num(ptr)
    local str = tostring(ptr)
    local hex = string.match(str, "0x(%x+)")
    if hex then
        local result = 0
        for i = 1, #hex do
            local digit = tonumber(string.sub(hex, i, i), 16)
            result = result * 16 + digit
        end
        return result
    end
    return nil
end

local function write_frequency_cave()
    if not cave_addr or not cave_num or not frequency_num then
        return false
    end
    
    local return_addr = frequency_num + 8
    local original_jnl_target = frequency_num + 8 + 0x1DA
    local jnl_offset = original_jnl_target - (cave_num + 11)
    local jmp_back = return_addr - (cave_num + 16)
    
    local cave_code = 
        string.char(0x83, 0xC7, FREQUENCY_MODIFIER) ..
        string.char(0x3B, 0xC7) ..
        string.char(0x0F, 0x8D) .. int_to_bytes(jnl_offset) ..
        string.char(0xE9) .. int_to_bytes(jmp_back)
    
    memory.write(cave_addr, cave_code)
    return true
end

local function get_weighted_range()
    local preset = WEIGHTING_PRESETS[WEIGHTING_LEVEL]
    local weights = preset.weights
    
    local roll = math.random(100)
    local cumulative = 0
    
    for i, w in ipairs(weights) do
        cumulative = cumulative + w[2]
        if roll <= cumulative then
            return w[1]
        end
    end
    
    return weights[#weights][1]
end

local function write_weighted_severity()
    if not severity_addr then
        return false
    end
    
    local range_value = get_weighted_range()
    local severity_byte_addr = severity_addr + 4
    memory.write(severity_byte_addr, string.char(range_value))
    
    return true
end

local function get_frequency_label()
    if FREQUENCY_MODIFIER == 1 then
        return "Standard"
    elseif FREQUENCY_MODIFIER == 2 then
        return "Realistic"
    elseif FREQUENCY_MODIFIER == 3 then
        return "High"
    elseif FREQUENCY_MODIFIER == 4 then
        return "Very High"
    elseif FREQUENCY_MODIFIER >= 5 and FREQUENCY_MODIFIER <= 7 then
        return "Injury Crisis"
    elseif FREQUENCY_MODIFIER >= 8 and FREQUENCY_MODIFIER <= 10 then
        return "Injury Plague"
    else
        return "CHAOS MODE"
    end
end

local function overlay_on(ctx)
    if enabled_severity then
        write_weighted_severity()
    end
    
    local freq_text = "OFF"
    local weight_text = "OFF"
    
    if enabled_frequency then
        freq_text = FREQUENCY_MODIFIER .. " (" .. get_frequency_label() .. ")"
    end
    
    if enabled_severity then
        local preset = WEIGHTING_PRESETS[WEIGHTING_LEVEL]
        weight_text = WEIGHTING_LEVEL .. " - " .. preset.name .. " (" .. preset.desc .. ")"
    end
    
    return "\n========== INJURY MOD v2.0 ==========\n\nFrequency:  " .. freq_text .. "\nWeighting:  " .. weight_text .. "\n\n[-/+] Change Frequency\n[/]   Change Weighting\n\nWeighting Levels:\n1 = Light (No serious injuries)\n2 = Moderate (Rarely serious injuries)\n3 = Realistic (Sometimes serious Injuries)\n4 = Severe (60% serious)\n5 = Brutal (80% serious injuries)\n\n======================================"
end

local function key_down(ctx, vkey)
    if vkey == 0xBD and enabled_frequency and FREQUENCY_MODIFIER > 1 then
        FREQUENCY_MODIFIER = FREQUENCY_MODIFIER - 1
        write_frequency_cave()
        save_settings(FREQUENCY_MODIFIER, WEIGHTING_LEVEL)
        log("Injury Mod: Frequency = " .. FREQUENCY_MODIFIER .. " (" .. get_frequency_label() .. ")")
    end
    
    if vkey == 0xBB and enabled_frequency and FREQUENCY_MODIFIER < 255 then
        FREQUENCY_MODIFIER = FREQUENCY_MODIFIER + 1
        write_frequency_cave()
        save_settings(FREQUENCY_MODIFIER, WEIGHTING_LEVEL)
        log("Injury Mod: Frequency = " .. FREQUENCY_MODIFIER .. " (" .. get_frequency_label() .. ")")
    end
    
    if vkey == 0xDB and enabled_severity and WEIGHTING_LEVEL > 1 then
        WEIGHTING_LEVEL = WEIGHTING_LEVEL - 1
        save_settings(FREQUENCY_MODIFIER, WEIGHTING_LEVEL)
        local preset = WEIGHTING_PRESETS[WEIGHTING_LEVEL]
        log("Injury Mod: Weighting = " .. WEIGHTING_LEVEL .. " (" .. preset.name .. ")")
    end
    
    if vkey == 0xDD and enabled_severity and WEIGHTING_LEVEL < 5 then
        WEIGHTING_LEVEL = WEIGHTING_LEVEL + 1
        save_settings(FREQUENCY_MODIFIER, WEIGHTING_LEVEL)
        local preset = WEIGHTING_PRESETS[WEIGHTING_LEVEL]
        log("Injury Mod: Weighting = " .. WEIGHTING_LEVEL .. " (" .. preset.name .. ")")
    end
end

function m.init(ctx)
    log("Injury Mod v2.0: Initializing...")
    log("Injury Mod: Final calibrated system")
    
    math.randomseed(os.time())
    
    frequency_addr = memory.search_process(FREQUENCY_AOB)
    if frequency_addr then
        log("Injury Mod: Found frequency code")
        frequency_num = ptr_to_num(frequency_addr)
    else
        log("Injury Mod: Frequency code NOT FOUND")
    end
    
    severity_addr = memory.search_process(SEVERITY_AOB)
    if severity_addr then
        log("Injury Mod: Found severity code")
        severity_num = ptr_to_num(severity_addr)
    else
        log("Injury Mod: Severity code NOT FOUND")
    end
    
    if frequency_addr then
        cave_addr = memory.search_process(CAVE_AOB)
        if not cave_addr then
            CAVE_AOB = string.rep('\x00', 32)
            cave_addr = memory.search_process(CAVE_AOB)
        end
        if cave_addr then
            log("Injury Mod: Found code cave")
            cave_num = ptr_to_num(cave_addr)
        end
    end
    
    if frequency_addr and cave_addr and frequency_num and cave_num then
        write_frequency_cave()
        local jmp_to_cave = cave_num - (frequency_num + 5)
        local patch = string.char(0xE9) .. int_to_bytes(jmp_to_cave) .. string.char(0x90, 0x90, 0x90)
        memory.write(frequency_addr, patch)
        enabled_frequency = true
        log("Injury Mod: Frequency ENABLED")
    end
    
    if severity_addr then
        enabled_severity = true
        log("Injury Mod: Weighted severity ENABLED")
    end
    
    log("====================================")
    if enabled_frequency and enabled_severity then
        log("Injury Mod v2.0: FULLY OPERATIONAL")
    elseif enabled_frequency then
        log("Injury Mod v2.0: Frequency only")
    else
        log("Injury Mod v2.0: FAILED")
    end
    log("====================================")
    
    log("Injury Mod: Frequency = " .. FREQUENCY_MODIFIER .. " (" .. get_frequency_label() .. ")")
    local preset = WEIGHTING_PRESETS[WEIGHTING_LEVEL]
    log("Injury Mod: Weighting = " .. WEIGHTING_LEVEL .. " (" .. preset.name .. ")")
    
    ctx.register("overlay_on", overlay_on)
    ctx.register("key_down", key_down)
end

return m
