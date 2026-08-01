local m = {}

local KEY_PAGEUP   = 0x21
local KEY_PAGEDOWN = 0x22
local KEY_HOME     = 0x24
local KEY_END      = 0x23

local base_step = 10000        
local max_limit = 10000000     
local hold_timer = 0
local turbo_limit = 15

local hook_addr, cave_addr, data_addr = nil, nil, nil
local orig_bytes = "\x8B\x87\xF4\xCB\x6E\x01\x89\x45\xC4\x48\x8D\x55\xC4\x48\x8D\x4D\xD0"

local function format_money(val)
    local display_val = val * 100
    local formatted = tostring(display_val)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then break end
    end
    return formatted .. " EUR"
end

function m.key_down(ctx, vkey)
    if data_addr then
        local r_data = memory.read(data_addr, 8)
        if r_data and #r_data == 8 then
            local rdi_val = memory.unpack("u64", r_data)
            if rdi_val and rdi_val > 0 then
                hold_timer = hold_timer + 1
                local step = (hold_timer > turbo_limit) and (base_step * 5) or base_step

                if vkey == KEY_PAGEUP or vkey == KEY_PAGEDOWN then
                    local addr = rdi_val + 0x016ECBF4
                    local val = memory.unpack("u32", memory.read(addr, 4))
                    if vkey == KEY_PAGEUP then val = math.min(max_limit, val + step)
                    else val = math.max(0, val - step) end
                    memory.write(addr, memory.pack("u32", val))
                end

                if vkey == KEY_HOME or vkey == KEY_END then
                    local addr = rdi_val + 0x016ECC08
                    local val = memory.unpack("u32", memory.read(addr, 4))
                    if vkey == KEY_HOME then val = math.min(max_limit, val + step)
                    else val = math.max(0, val - step) end
                    memory.write(addr, memory.pack("u32", val))
                end
            end
        end
    end
end

function m.key_up(ctx, vkey) hold_timer = 0 end

function m.overlay_on(ctx)
    local t_val, s_val = 0, 0
    if data_addr then
        local r_data = memory.read(data_addr, 8)
        if r_data and #r_data == 8 then
            local rdi_val = memory.unpack("u64", r_data)
            if rdi_val and rdi_val > 0 then
                t_val = memory.unpack("u32", memory.read(rdi_val + 0x016ECBF4, 4))
                s_val = memory.unpack("u32", memory.read(rdi_val + 0x016ECC08, 4))
            end
        end
    end

    return string.format(
        "Realistic Budget Manager by JamesHoward333\n" ..
        "--------------------------------------\n" ..
        "Transfer Budget: %s\n" ..
        "Salary Budget:   %s\n\n" ..
        "[Page Up/Down] : +/- Transfer\n" ..
        "[Home/End]      : +/- Salary",
        format_money(t_val), format_money(s_val)
    )
end

function m.init(ctx)
    hook_addr = memory.search_process(orig_bytes)
    if not hook_addr then return end
    cave_addr = memory.allocate_codecave(128)
    data_addr = cave_addr + 0x30
    local ret_addr = hook_addr + 17
    local cave_code = "\x48\x89\x3D\x29\x00\x00\x00" .. orig_bytes .. "\xFF\x25\x00\x00\x00\x00" .. memory.pack("u64", ret_addr)
    memory.write(cave_addr, cave_code)
    memory.write(hook_addr, "\xFF\x25\x00\x00\x00\x00" .. memory.pack("u64", cave_addr) .. "\x90\x90\x90")
    ctx.register("key_down", m.key_down)
    ctx.register("key_up", m.key_up)
    ctx.register("overlay_on", m.overlay_on)
end

return m