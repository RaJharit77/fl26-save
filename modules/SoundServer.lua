local m = {}
m.version = "1.2"
local hex = memory.hex
local settings

local RESTORE_KEY = 0x38
local PREV_PROP_KEY = 0x39
local NEXT_PROP_KEY = 0x30
local PREV_VALUE_KEY = 0xbd
local NEXT_VALUE_KEY = 0xbb

local delta = 0
local frame_count = 0

local overlay_curr = 1

local modroot = ".\\modules"

local overlay_states = {
    { ui = "Menu volume: %0.2f", prop = "menu_vol", decr = -0.05, incr = 0.05 },
    { ui = "Music Volume: %0.2f", prop = "music_vol", decr = -0.05, incr = 0.05 },
    { ui = "Commentary volume: %0.2f", prop = "comm_vol", decr = -0.05, incr = 0.05 },
	{ ui = "Crowd volume: %0.2f", prop = "crowd_vol", decr = -0.05, incr = 0.05 },
	{ ui = "Announcer Volume: %0.2f", prop = "ann_vol", decr = -0.05, incr = 0.05 },
	{ ui = "Stadium Volume: %0.2f", prop = "stadmus_vol", decr = -0.05, incr = 0.05 },
	{ ui = "Field Volume (ball..): %0.2f", prop = "stad_vol", decr = -0.05, incr = 0.05 },
	
}
local ui_lines = {}


local bases = {
  amenuvol = 0x00,
  amusicvol = 0x00,
  acommvol = 0x00,
  acrowdvol = 0x00,
  aannvol = 0x00,
  astadmusvol = 0x00,
  astadsvol = 0x00,
}
local game_info = {
    menu_vol   = { base = "amenuvol", offs = 0x00, format = "f", len = 4, def = 1 },
	music_vol   = { base = "amusicvol", offs = 0x00, format = "f", len = 4, def = 1 },
	comm_vol   = { base = "acommvol", offs = 0x00, format = "f", len = 4, def = 1 },
	crowd_vol   = { base = "acrowdvol", offs = 0x00, format = "f", len = 4, def = 1 },
	ann_vol   = { base = "aannvol", offs = 0x00, format = "f", len = 4, def = 1 },
	stadmus_vol   = { base = "astadmusvol", offs = 0x00, format = "f", len = 4, def = 1 },
	stad_vol   = { base = "astadsvol", offs = 0x00, format = "f", len = 4, def = 1 },
}

local function save_ini(ctx, filename)
    local f,err = io.open(ctx.sider_dir .. "\\" .. filename, "wt")
    if not f then
        log(string.format("PROBLEM saving settings: %s", tostring(err)))
        return
    end
    f:write(string.format("# SoundServer settings \n"))
    f:write(string.format("menu_vol = %0.2f\n", settings.menu_vol or game_info.menu_vol.def))
    f:write(string.format("music_vol = %0.2f\n", settings.music_vol or game_info.music_vol.def))
	f:write(string.format("comm_vol = %0.2f\n", settings.comm_vol or game_info.comm_vol.def))
	f:write(string.format("crowd_vol = %0.2f\n", settings.crowd_vol or game_info.crowd_vol.def))
	f:write(string.format("ann_vol = %0.2f\n", settings.ann_vol or game_info.ann_vol.def))
	f:write(string.format("stadmus_vol = %0.2f\n", settings.stadmus_vol or game_info.stadmus_vol.def))
	f:write(string.format("stad_vol = %0.2f\n", settings.stad_vol or game_info.stad_vol.def))
    f:write("\n")
    f:close()
end

local function file_exists(name)
	log(name)
	local f=io.open(name,"r")
	if f~=nil then 
		io.close(f) 
		return true 
	else 
		return false 
	end
end

local function load_ini(ctx, filename)
    local t = {}
    -- initialize with defaults
    for prop,info in pairs(game_info) do
        t[prop] = info.def
    end
	
    
    local f,err = io.open(ctx.sider_dir .. "\\" .. filename)
    if not f then
        return t
    end
    f:close()
    for line in io.lines(ctx.sider_dir .. "\\" .. filename) do
        local name, value = string.match(line, "^([%w_]+)%s*=%s*([-%w%d.]+)")
        if name and value then
            value = tonumber(value) or value
            t[name] = value
            log(string.format("Using setting: %s = %s", name, value))
        end
    end
    return t
end


local function apply_settings(ctx, log_it, save_it)
    for name,value in pairs(settings) do
        local entry = game_info[name]
        if entry then
            local base = bases[entry.base]
            if base then
                if entry.value_map then
                    value = entry.value_map[value]
                end
                local addr = base + entry.offs
                local old_value, new_value
                if entry.format ~= "" then
                    old_value = memory.unpack(entry.format, memory.read(addr, entry.len))
                    memory.write(addr, memory.pack(entry.format, value))
                    new_value = memory.unpack(entry.format, memory.read(addr, entry.len))
                    if log_it then
                        log(string.format("%s: changed at %s: %s --> %s",
                            name, hex(addr), old_value, new_value))
                    end
                else
                    old_value = memory.read(addr, entry.len)
                    memory.write(addr, value)
                    new_value = memory.read(addr, entry.len)
                    if log_it then
                        log(string.format("%s: changed at %s: %s --> %s",
                            name, hex(addr), hex(old_value), hex(new_value)))
                    end
                end
            end
        end
    end
    if (save_it) then
	       
               save_ini(ctx, "modules\\SoundServer.ini")   	--file name
		    
    end
end


local function repeat_change(ctx, after_num_frames, change)
    if change ~= 0 then
        frame_count = frame_count + 1
        if frame_count >= after_num_frames then
            local s = overlay_states[overlay_curr]
            settings[s.prop] = settings[s.prop] + change
            apply_settings(ctx, false, false) -- apply
        end
    end
end

function m.overlay_on(ctx)	
	apply_settings(ctx, true)
    repeat_change(ctx, 30, delta)
    for i,v in ipairs(overlay_states) do
        local s = overlay_states[i]
        local setting = string.format(s.ui, settings[s.prop])
        if i == overlay_curr then
            ui_lines[i] = string.format("\n---> %s <---", setting)
        else
            ui_lines[i] = string.format("\n     %s", setting)
        end
    end
    return string.format([[version %s
Keys: [9][0] - choose setting, [-][+] - modify value, [8] - restore defaults
Gamepad: RS up/down - choose setting, RS left/right - modify value
%s]], m.version, table.concat(ui_lines))
end


function m.key_down(ctx, vkey)
    if vkey == NEXT_PROP_KEY then
        if overlay_curr < #overlay_states then
            overlay_curr = overlay_curr + 1
        end
    elseif vkey == PREV_PROP_KEY then
        if overlay_curr > 1 then
            overlay_curr = overlay_curr - 1
        end
    elseif vkey == NEXT_VALUE_KEY then
        local s = overlay_states[overlay_curr]
        if s.incr ~= nil then
            settings[s.prop] = settings[s.prop] + s.incr
        elseif s.nextf ~= nil then
            settings[s.prop] = s.nextf(settings[s.prop])
        end
        apply_settings(ctx, false, true)
    elseif vkey == PREV_VALUE_KEY then
        local s = overlay_states[overlay_curr]
        if s.decr ~= nil then
            settings[s.prop] = settings[s.prop] + s.decr
        elseif s.prevf ~= nil then
            settings[s.prop] = s.prevf(settings[s.prop])
        end
        apply_settings(ctx, false, true)
    elseif vkey == RESTORE_KEY then
        for i,s in ipairs(overlay_states) do
            settings[s.prop] = game_info[s.prop].def
        end
        apply_settings(ctx, false, true)
    end
end

function m.gamepad_input(ctx, inputs)
    local v = inputs["RSy"]
    if v then
        if v == -1 and overlay_curr < #overlay_states then -- moving down
            overlay_curr = overlay_curr + 1
        elseif v == 1 and overlay_curr > 1 then -- moving up
            overlay_curr = overlay_curr - 1
        end
    end

    v = inputs["RSx"]
    if v then
        if v == -1 then -- moving left
            local s = overlay_states[overlay_curr]
            if s.decr ~= nil then
                settings[s.prop] = settings[s.prop] + s.decr
                -- set up the repeat change
                delta = s.decr
                frame_count = 0
            elseif s.prevf ~= nil then
                settings[s.prop] = s.prevf(settings[s.prop])
            end
            apply_settings(ctx, false, false) -- apply
        elseif v == 1 then -- moving right
            local s = overlay_states[overlay_curr]
            if s.decr ~= nil then
                settings[s.prop] = settings[s.prop] + s.incr
                -- set up the repeat change
                delta = s.incr
                frame_count = 0
            elseif s.nextf ~= nil then
                settings[s.prop] = s.nextf(settings[s.prop])
            end
            apply_settings(ctx, false, false) -- apply
        elseif v == 0 then -- stop change
            delta = 0
            apply_settings(ctx, false, true) -- apply and save
        end
    end
end




function m.set_teams(ctx)
local loc = 0x143AA1178
    local mpointer = 0x00
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x88
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x498
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x7C0
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x730
	
	bases.amenuvol = loc - 0x50
	bases.amusicvol = loc
	bases.acommvol = loc + 0x50
	bases.acrowdvol = loc + 0xA0
	bases.aannvol = loc + 0xF0
	bases.astadmusvol = loc + 0x40
	bases.astadsvol = loc + 0x190
	
	
	
	settings = load_ini(ctx, "modules\\SoundServer.ini")	
	apply_settings(ctx, true)
end

local function set_conditions(ctx)  
local loc = 0x143AA1178
    local mpointer = 0x00
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x88
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x498
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x7C0
    mpointer = memory.unpack("i64", memory.read(loc, 8))
    loc = mpointer + 0x730
	
	bases.amenuvol = loc - 0x50
	bases.amusicvol = loc
	bases.acommvol = loc + 0x50
	bases.acrowdvol = loc + 0xA0
	bases.aannvol = loc + 0xF0
	bases.astadmusvol = loc + 0x40
	bases.astadsvol = loc + 0x190
	
	settings = load_ini(ctx, "modules\\SoundServer.ini")		--file name
	apply_settings(ctx, true)
end

function m.init(ctx)   
    -- register for events
    ctx.register("set_teams", m.set_teams)
    ctx.register("overlay_on", m.overlay_on)
    ctx.register("key_down", m.key_down)
    ctx.register("gamepad_input", m.gamepad_input)
	ctx.register("set_conditions", set_conditions)
end

return m
