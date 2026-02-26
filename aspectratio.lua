-- Based on lua by Durandil67

local m = { version = "1.0" }

function m.init(ctx)
    local addr = memory.search_process("\x80\x7B\x7C\x00\x0F\x28")
    if addr then
        log(string.format("found magic string at: %s", memory.hex(addr)))
        memory.write(addr, "\x80\x7B\x7C\x01\x0F\x28")
    else
        error("unable to find magic string")
    end
end

return m
