-- cpu_realism.lua
-- PES 2021 Sider Lua Module
-- Purpose: Smart AI, not boosted AI
-- Author: Holland
-- Compatibility: Juce Sider

local m = {}

function m.init(ctx)
    ctx.register("livecpk_data", m.data)
end

function m.data(ctx, filename, data)
    if not _G.NOSCRIPT_ENABLED then return data.unchanged end

    if filename:find("dt18") then
        data:write_float(0x70, 0.95) -- Over-pressing reduction
        data:write_float(0x74, 1.05) -- Positional discipline
        data:write_float(0x78, 0.96) -- Aggression control
        return data.modified
    end

    return data.unchanged
end

return m
