-- core_noscript.lua
-- PES 2021 Sider Lua Module
-- Purpose: Global momentum & scripting suppre
-- Author: Holland
-- Compatibility: Juce Sider

local m = {}
local match = false

function m.init(ctx)
    ctx.register("match_start", function() match = true end)
    ctx.register("match_end", function() match = false end)
    ctx.register("livecpk_data", m.data)
end

function m.data(ctx, filename, data)
    if not match or not _G.NOSCRIPT_ENABLED then
        return data.unchanged
    end

    if filename:find("dt18") then
        data:write_float(0x50, 1.00) -- Momentum
        data:write_float(0x54, 1.00) -- Comeback
        data:write_float(0x58, 1.00) -- Underdog
        data:write_float(0x60, 0.00) -- Goal diff scaling OFF
        return data.modified
    end

    return data.unchanged
end

return m
