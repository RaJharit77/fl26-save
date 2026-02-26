-- ml_bal_noscript.lua
-- PES 2021 Sider Lua Module
-- Purpose: League & BAL scripting reduction
-- Author: Holland
-- Compatibility: Juce Sider

local m = {}

function m.init(ctx)
    ctx.register("livecpk_data", m.data)
end

function m.data(ctx, filename, data)
    if not _G.NOSCRIPT_ENABLED then return data.unchanged end

    if filename:find("dt18") then
        data:write_float(0x90, 1.00) -- Form bias OFF
        data:write_float(0x94, 1.00) -- Team role inflation OFF
        data:write_float(0x98, 1.00) -- Morale scripting OFF
        return data.modified
    end

    return data.unchanged
end

return m
