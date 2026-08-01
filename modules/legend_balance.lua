-- legend_balance.lua
-- PES 2021 Sider Lua Module
-- Purpose: Legend difficulty without cheating
-- Author: Holland
-- Compatibility: Juce Sider

local m = {}

function m.init(ctx)
    ctx.register("livecpk_data", m.data)
end

function m.data(ctx, filename, data)
    if not _G.NOSCRIPT_ENABLED then return data.unchanged end

    if filename:find("dt18") then
        data:write_float(0x20, 1.00) -- Speed
        data:write_float(0x24, 0.98) -- Acceleration
        data:write_float(0x28, 0.97) -- Reaction
        data:write_float(0x2C, 0.95) -- Physical boost
        return data.modified
    end

    return data.unchanged
end

return m
