-- kitglobal.lua
-- global run-time enforcement of TightKit and other attributes for kits
-- author: juce, 2020

local version = "1.00"

local global_kit_attributes

local org_kits_set
local org_kits_set_gk

local function load_ini(ctx)
    local t = {}
    local f = io.open(ctx.sider_dir .. "modules\\kitglobal.ini")
    if f then
        for line in f:lines() do
            local name, value = string.match(line, "^([%w_]+)%s*=%s*([-%w%d.#]+)")
            if name and value then
                value = tonumber(value) or value
                t[name] = value
                log(string.format("loaded setting: %s=%s", name, value))
            end
        end
    end
    return t
end

local function kits_set(team_id, kit_id, cfg, home_or_away)
    for k,v in pairs(global_kit_attributes) do
        cfg[k] = v
        log(string.format("ctx.kits.set: enforcing %s=%s", k, v))
    end
    return org_kits_set(team_id, kit_id, cfg, home_or_away)
end

local function kits_set_gk(team_id, cfg)
    for k,v in pairs(global_kit_attributes) do
        cfg[k] = v
        log(string.format("ctx.kits.set_gk: enforcing %s=%s", k, v))
    end
    return org_kits_set_gk(team_id, cfg)
end

local function set_kits(ctx, home_info, away_info)
    for k,v in pairs(global_kit_attributes) do
        log(string.format("set_kits: enforcing %s=%s", k, v))
    end
    return global_kit_attributes, global_kit_attributes
end

local function update_kits(ctx, team_id, home_or_away)
    local kit_id = ctx.kits.get_current_kit_id(home_or_away)
    local cfg = ctx.kits.get(team_id, kit_id)
    ctx.kits.set(team_id, kit_id, cfg, home_or_away)
    cfg = ctx.kits.get_gk(team_id)
    ctx.kits.set_gk(team_id, cfg)
end

local function finalize_kits(ctx)
    update_kits(ctx, ctx.home_team, 0)
    update_kits(ctx, ctx.away_team, 1)
end

local function init(ctx)
    if not ctx.kits then
        error("ctx.kits not found. Upgrade your sider")
    end
    org_kits_set = ctx.kits.set
    org_kits_set_gk = ctx.kits.set_gk
    ctx.kits.set = kits_set
    ctx.kits.set_gk = kits_set_gk

    global_kit_attributes = load_ini(ctx)

    ctx.register("set_kits", set_kits)
    ctx.register("after_set_conditions", finalize_kits)
end

return { init = init }
