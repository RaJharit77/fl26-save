-- noscript.lua
-- PES 2021 Sider Lua Module
-- Purpose: Reduce scripting / momentum / dynamic difficulty
-- Author: Holland
-- Compatibility: Juce Sider

local m = {}

-- Internal state
local match_started = false

-- Utility: clamp value
local function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-- Called when match starts
function m.init(ctx)
    ctx.register("set_teams", m.on_set_teams)
    ctx.register("match_start", m.on_match_start)
    ctx.register("match_end", m.on_match_end)
    ctx.register("livecpk_data", m.on_livecpk_data)
end

-- Teams loaded
function m.on_set_teams(ctx, home, away)
    match_started = false
end

-- Match start hook
function m.on_match_start(ctx)
    match_started = true
end

-- Match end hook
function m.on_match_end(ctx)
    match_started = false
end

-- Core logic: gameplay parameter manipulation
function m.on_livecpk_data(ctx, filename, data)
    if not match_started then
        return data.unchanged
    end

    -- Gameplay balance table (known patterns used by Sider mods)
    if filename:find("Gameplay") or filename:find("dt18") then

        -- Reduce AI assistance
        data:write_float(0x30, 0.95) -- AI reaction boost
        data:write_float(0x34, 0.95) -- AI speed boost
        data:write_float(0x38, 0.95) -- AI stamina recovery

        -- Reduce player nerfing
        data:write_float(0x40, 1.00) -- Player pass error modifier
        data:write_float(0x44, 1.00) -- Player shot error modifier

        -- Reduce momentum swings
        data:write_float(0x50, 1.00) -- Comeback factor
        data:write_float(0x54, 1.00) -- Late-match bias
        data:write_float(0x58, 1.00) -- Underdog boost

        -- Goal-based difficulty scaling OFF
        data:write_float(0x60, 0.00) -- Goal difference scaling

        return data.modified
    end

    return data.unchanged
end

return m
