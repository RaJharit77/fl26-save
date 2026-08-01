-- Soundtrack-Server for PES2021 & PES2020 via Sider
-- Author: Predator002 on 13/10/2024 - Version: 6.0
-- Massive thanks to Juce for his coding improvements and optimisation, such an amazing person!
-- Please consult the Instructions.txt within content\soundtrack-server\ for important additional information
-- Improvements: D4nt - sanatxu on 26/09/2024: Added music tag reader V2, random key to change the track, more comments

local m = {}
local rdm
local result_check
local tid_new
local tid_type
local track_main
local track_main_next
local track_edit_mode
local track_edit_mode_next
local track_competitions
local track_competitions_next
local track_competitions_cup
local track_competitions_cup_next
local track_competitions_lgecup
local track_competitions_lgecup_next
local track_results
local track_results_next
local track_highlights
local track_highlights_next
local artist
local title
local track_delay
local track_active
local track_volume 					= 0.3
local track_fade 					= 3
local Main_Other 					= "content\\soundtrack-server\\0_Other\\"
local Main_Soundtrack 					= "content\\soundtrack-server\\1_Soundtrack\\"
local Main_Edit_Mode 					= "content\\soundtrack-server\\2_Edit_Mode\\"
local Main_Competitions_Generic 			= "content\\soundtrack-server\\3_Competitions_Generic\\"
local Main_Competitions_Specific 			= "content\\soundtrack-server\\4_Competitions_Specific\\"
local Main_Results_Generic 				= "content\\soundtrack-server\\5_Results_Generic\\"
local Main_Results_Specific 				= "content\\soundtrack-server\\6_Results_Specific\\"
local Main_Highlights_Generic 				= "content\\soundtrack-server\\7_Highlights_Generic\\"
local Main_Highlights_Specific 				= "content\\soundtrack-server\\8_Highlights_Specific\\"
local Main_Soundtrack_MaxCount 				= 177
local Main_Edit_Mode_MaxCount 				= 0
local Main_Competitions_Generic_MaxCount 		= 21
local Main_Competitions_Specific_MaxCount 		= 18
local Main_Results_Generic_MaxCount 			= 40
local Main_Results_Specific_MaxCount 			= 1
local Main_Highlights_Generic_MaxCount 			= 25
local Main_Highlights_Specific_MaxCount 		= 10

-- Function to read ID3v2 tags from an MP3 file
-- @param pathfinal: The path to the MP3 file
-- @return artist1, title1: The artist and title extracted from the ID3v2 tags
local function readID3v2Tags(pathfinal)
    artist1, title1 = nil, nil  -- Initialize artist and title as nil
    local file = io.open(pathfinal, "rb")  -- Open the file in binary mode
    if not file then
        -- log("Failed to open file")
        return nil, nil
    end

    -- Read the ID3 header
    local header = file:read(10)
    if not header or header:sub(1, 3) ~= "ID3" then
        -- log("No ID3v2 tag found")
        file:close()
        return nil, nil
    end

    -- Try to find the artist and title frames (TPE1 for artist, TIT2 for title)
    while true do
        local frameHeader = file:read(10)
        if not frameHeader then break end  -- End of file or error

        local frameID = frameHeader:sub(1, 4)
        local size = 0
        for i = 5, 8 do
            size = size * 256 + frameHeader:byte(i)
        end

        local frameContent = file:read(size)
        if frameID == "TPE1" then
            artist1 = frameContent
        elseif frameID == "TIT2" then
            title1 = frameContent
        end

        if artist1 and title1 then   -- Found both, no need to continue
           break
        end
    end

    file:close()

    -- Process and return the artist and title, removing any potential null bytes
    if artist1 and title1 then
        artist1 = artist1:gsub("[^%w ` ()-]", "")
        title1 = title1:gsub("[^%w ` ()-]", "")
        artist = artist1
        title = title1
        return artist, title
    else
        log("Artist or Title tag not found")
        return nil, nil
    end
end




-- Function to handle overlay display, showing the current track's artist and title
-- @param ctx: The context object
function m.overlay_on(ctx)

  -- Declare local variables for each call

   
    if track_main and track_main:get_state() == "playing" then 
        local file = track_main
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end
    
    if track_main_next and track_main_next:get_state() == "playing" then
        local file = track_main_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end  

    if track_edit_mode and track_edit_mode:get_state() == "playing" then
        local file = track_edit_mode
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_edit_mode_next and track_edit_mode_next:get_state() == "playing" then
        local file = track_edit_mode_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values

    end

    if track_competitions and track_competitions:get_state() == "playing" then
        local file = track_competitions
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_competitions_next and track_competitions_next:get_state() == "playing" then
        local file = track_competitions_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_competitions_cup and track_competitions_cup:get_state() == "playing" then
        local file = track_competitions_cup
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_competitions_cup_next and track_competitions_cup_next:get_state() == "playing" then
        local file = track_competitions_cup_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_competitions_lgecup and track_competitions_lgecup:get_state() == "playing" then
        local file = track_competitions_lgecup
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_competitions_lgecup_next and track_competitions_lgecup_next:get_state() == "playing" then
        local file = track_competitions_lgecup_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_results and track_results:get_state() == "playing" then
        local file = track_results
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_results_next and track_results_next:get_state() == "playing" then        
        local file = track_results_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_highlights and track_highlights:get_state() == "playing" then      
        local file = track_highlights
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    if track_highlights_next and track_highlights_next:get_state() == "playing" then      
        local file = track_highlights_next
        local pathfinal = file:get_filename()
        local artist, title = readID3v2Tags(pathfinal) -- Use returned values
    end

    

    return(string.format("Press--/[5]/--to change the Track -- NowPlaying --[ Artist:%s - Title:%s ]", artist, title))
end


-- Function to start the main soundtrack
function start_main_soundtrack(ctx)
    if track_active == 999 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_main and track_main:get_state() == "playing" then
            -- Main track is playing; do nothing
        elseif track_main_next and (track_main_next:get_state() == "created" or track_main_next:get_state() == "playing" or track_main_next:get_state() == "fading") then
            -- Next main track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_main:set_volume(track_volume)
                track_main:when_done(function(ctx)
                    if track_main == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 999 then
                        if Main_Soundtrack_MaxCount ~= 0 then
                            rdm = math.random(1, Main_Soundtrack_MaxCount)
                            track_main_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                            next_main_soundtrack(ctx)
                        end
                    end
                end)
                track_main:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next main soundtrack
function next_main_soundtrack(ctx)
    if track_active == 999 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_main_next and track_main_next:get_state() == "playing" then
            -- Next main track is playing; do nothing
        elseif track_main and (track_main:get_state() == "created" or track_main:get_state() == "playing" or track_main:get_state() == "fading") then
            -- Main track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_main_next:set_volume(track_volume)
                track_main_next:when_done(function(ctx)
                    if track_main_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 999 then
                        if Main_Soundtrack_MaxCount ~= 0 then
                            rdm = math.random(1, Main_Soundtrack_MaxCount)
                            track_main = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                            start_main_soundtrack(ctx)
                        end
                    end
                end)
                track_main_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the edit mode soundtrack
function start_edit_mode_soundtrack(ctx)
    if track_active == 998 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_edit_mode and track_edit_mode:get_state() == "playing" then
            -- Edit mode track is playing; do nothing
        elseif track_edit_mode_next and (track_edit_mode_next:get_state() == "created" or track_edit_mode_next:get_state() == "playing" or track_edit_mode_next:get_state() == "fading") then
            -- Next edit mode track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_edit_mode:set_volume(track_volume)
                track_edit_mode:when_done(function(ctx)
                    if track_edit_mode == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 998 then
                        if Main_Edit_Mode_MaxCount ~= 0 then
                            if file_exists(ctx.sider_dir .. Main_Edit_Mode .. "Track_1.mp3") then
                                rdm = math.random(1, Main_Edit_Mode_MaxCount)
                                track_edit_mode_next = audio.new(ctx.sider_dir .. Main_Edit_Mode .. "Track_" .. rdm .. ".mp3")
                                next_edit_mode_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_edit_mode:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next edit mode soundtrack
function next_edit_mode_soundtrack(ctx)
    if track_active == 998 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_edit_mode_next and track_edit_mode_next:get_state() == "playing" then
            -- Next edit mode track is playing; do nothing
        elseif track_edit_mode and (track_edit_mode:get_state() == "created" or track_edit_mode:get_state() == "playing" or track_edit_mode:get_state() == "fading") then
            -- Edit mode track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_edit_mode_next:set_volume(track_volume)
                track_edit_mode_next:when_done(function(ctx)
                    if track_edit_mode_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 998 then
                        if Main_Edit_Mode_MaxCount ~= 0 then
                            if file_exists(ctx.sider_dir .. Main_Edit_Mode .. "Track_1.mp3") then
                                rdm = math.random(1, Main_Edit_Mode_MaxCount)
                                track_edit_mode = audio.new(ctx.sider_dir .. Main_Edit_Mode .. "Track_" .. rdm .. ".mp3")
                                start_edit_mode_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_edit_mode_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the competitions soundtrack
function start_competitions_soundtrack(ctx)
    if track_active == 997 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions and track_competitions:get_state() == "playing" then
            -- Competitions track is playing; do nothing
        elseif track_competitions_next and (track_competitions_next:get_state() == "created" or track_competitions_next:get_state() == "playing" or track_competitions_next:get_state() == "fading") then 
            -- Next competitions track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_competitions:set_volume(track_volume)
                track_competitions:when_done(function(ctx)
                    if track_competitions == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions_next = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                next_competitions_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions_next = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                next_competitions_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                next_competitions_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next competitions soundtrack
function next_competitions_soundtrack(ctx)
    if track_active == 997 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions_next and track_competitions_next:get_state() == "playing" then
            -- Next competitions track is playing; do nothing
        elseif track_competitions and (track_competitions:get_state() == "created" or track_competitions:get_state() == "playing" or track_competitions:get_state() == "fading") then
            -- Competitions track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_competitions_next:set_volume(track_volume)
                track_competitions_next:when_done(function(ctx)
                    if track_competitions_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                start_competitions_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                start_competitions_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                start_competitions_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the competitions cup soundtrack
function start_competitions_cup_soundtrack(ctx)
    if track_active == 997 .. "cup" then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions_cup and track_competitions_cup:get_state() == "playing" then
            -- Competitions cup track is playing; do nothing
        elseif track_competitions_cup_next and (track_competitions_cup_next:get_state() == "created" or track_competitions_cup_next:get_state() == "playing" or track_competitions_cup_next:get_state() == "fading") then
            -- Next competitions cup track is created or playing or fading; do nothing 
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_competitions_cup:set_volume(track_volume)
                track_competitions_cup:when_done(function(ctx)
                    if track_competitions_cup == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 .. "cup" then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions_cup_next = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                next_competitions_cup_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions_cup_next = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                next_competitions_cup_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions_cup_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                next_competitions_cup_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions_cup:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next competitions cup soundtrack
function next_competitions_cup_soundtrack(ctx)
    if track_active == 997 .. "cup" then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions_cup_next and track_competitions_cup_next:get_state() == "playing" then
            -- Next competitions cup track is playing; do nothing
        elseif track_competitions_cup and (track_competitions_cup:get_state() == "created" or track_competitions_cup:get_state() == "playing" or track_competitions_cup:get_state() == "fading") then
            -- Competitions cup track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_competitions_cup_next:set_volume(track_volume)
                track_competitions_cup_next:when_done(function(ctx)
                    if track_competitions_cup_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 .. "cup" then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions_cup = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                start_competitions_cup_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions_cup = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                start_competitions_cup_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions_cup = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                start_competitions_cup_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions_cup_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the competitions league cup soundtrack
function start_competitions_lgecup_soundtrack(ctx)
    if track_active == 997 .. "lgecup" then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions_lgecup and track_competitions_lgecup:get_state() == "playing" then
            -- Competitions league cup track is playing; do nothing
        elseif track_competitions_lgecup_next and (track_competitions_lgecup_next:get_state() == "created" or track_competitions_lgecup_next:get_state() == "playing" or track_competitions_lgecup_next:get_state() == "fading") then
            -- Next competitions league cup track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_competitions_lgecup:set_volume(track_volume)
                track_competitions_lgecup:when_done(function(ctx)
                    if track_competitions_lgecup == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 .. "lgecup" then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions_lgecup_next = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                next_competitions_lgecup_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "lgecup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions_lgecup_next = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                next_competitions_lgecup_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions_lgecup_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                next_competitions_lgecup_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions_lgecup:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next competitions league cup soundtrack
function next_competitions_lgecup_soundtrack(ctx)
    if track_active == 997 .. "lgecup" then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_competitions_lgecup_next and track_competitions_lgecup_next:get_state() == "playing" then
            -- Next competitions league cup track is playing; do nothing
        elseif track_competitions_lgecup and (track_competitions_lgecup:get_state() == "created" or track_competitions_lgecup:get_state() == "playing" or track_competitions_lgecup:get_state() == "fading") then
            -- Competitions league cup track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3") 
            track_delay:when_done(function(ctx)
                track_competitions_lgecup_next:set_volume(track_volume)
                track_competitions_lgecup_next:when_done(function(ctx)
                    if track_competitions_lgecup_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 997 .. "lgecup" then
                        if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Competitions_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                                track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                start_competitions_lgecup_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "lgecup" then
                            if Main_Competitions_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                                track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                                start_competitions_lgecup_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                start_competitions_lgecup_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_competitions_lgecup_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the results soundtrack
function start_results_soundtrack(ctx)
    if track_active == 996 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_results and track_results:get_state() == "playing" then
            -- Results track is playing; do nothing
        elseif track_results_next and (track_results_next:get_state() == "created" or track_results_next:get_state() == "playing" or track_results_next:get_state() == "fading") then
            -- Next results track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_results:set_volume(track_volume)
                track_results:when_done(function(ctx)
                    if track_results == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 996 then
                        if file_exists(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Results_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Results_Specific_MaxCount)
                                track_results_next = audio.new(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                next_results_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Results_Generic .. "Track_1.mp3") then
                            if Main_Results_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Results_Generic_MaxCount)
                                track_results_next = audio.new(ctx.sider_dir .. Main_Results_Generic .. "Track_" .. rdm .. ".mp3")
                                next_results_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_results_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                next_results_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_results:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next results soundtrack
function next_results_soundtrack(ctx)
    if track_active == 996 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_results_next and track_results_next:get_state() == "playing" then
            -- Next results track is playing; do nothing
        elseif track_results and (track_results:get_state() == "created" or track_results:get_state() == "playing" or track_results:get_state() == "fading") then
            -- Results track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_results_next:set_volume(track_volume)
                track_results_next:when_done(function(ctx)
                    if track_results_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 996 then
                        if file_exists(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Results_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Results_Specific_MaxCount)
                                track_results = audio.new(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                start_results_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Results_Generic .. "Track_1.mp3") then
                            if Main_Results_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Results_Generic_MaxCount)
                                track_results = audio.new(ctx.sider_dir .. Main_Results_Generic .. "Track_" .. rdm .. ".mp3")
                                start_results_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_results = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                start_results_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_results_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the highlights soundtrack
function start_highlights_soundtrack(ctx)
    if track_active == 995 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_highlights and track_highlights:get_state() == "playing" then
            -- Highlights track is playing; do nothing
        elseif track_highlights_next and (track_highlights_next:get_state() == "created" or track_highlights_next:get_state() == "playing" or track_highlights_next:get_state() == "fading") then
            -- Next highlights track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_highlights:set_volume(track_volume)
                track_highlights:when_done(function(ctx)
                    if track_highlights == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 995 then
                        if file_exists(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Highlights_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Highlights_Specific_MaxCount)
                                track_highlights_next = audio.new(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                next_highlights_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Highlights_Generic .. "Track_1.mp3") then
                            if Main_Highlights_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Highlights_Generic_MaxCount)
                                track_highlights_next = audio.new(ctx.sider_dir .. Main_Highlights_Generic .. "Track_" .. rdm .. ".mp3")
                                next_highlights_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_highlights_next = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                next_highlights_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_highlights:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to start the next highlights soundtrack
function next_highlights_soundtrack(ctx)
    if track_active == 995 then
        if track_delay and track_delay:get_state() == "playing" then
            -- Delay track is playing; do nothing
        elseif track_highlights_next and track_highlights_next:get_state() == "playing" then
            -- Next highlights track is playing; do nothing
        elseif track_highlights and (track_highlights:get_state() == "created" or track_highlights:get_state() == "playing" or track_highlights:get_state() == "fading") then
            -- Highlights track is created or playing or fading; do nothing
        else
            -- Start delay track
            track_delay = audio.new(ctx.sider_dir .. Main_Other .. "Track_Delay_1.mp3")
            track_delay:when_done(function(ctx)
                track_highlights_next:set_volume(track_volume)
                track_highlights_next:when_done(function(ctx)
                    if track_highlights_next == nil then
                        -- Soundtrack stopped; do not start next song
                        return
                    end
                    if track_active == 995 then
                        if file_exists(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                            if Main_Highlights_Specific_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Highlights_Specific_MaxCount)
                                track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                                start_highlights_soundtrack(ctx)
                            end
                        elseif file_exists(ctx.sider_dir .. Main_Highlights_Generic .. "Track_1.mp3") then
                            if Main_Highlights_Generic_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Highlights_Generic_MaxCount)
                                track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Generic .. "Track_" .. rdm .. ".mp3")
                                start_highlights_soundtrack(ctx)
                            end
                        else
                            if Main_Soundtrack_MaxCount ~= 0 then
                                rdm = math.random(1, Main_Soundtrack_MaxCount)
                                track_highlights = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                                start_highlights_soundtrack(ctx)
                            end
                        end
                    end
                end)
                track_highlights_next:play()
            end)
            track_delay:play()
        end
    end
end

-- Function to stop the current soundtrack
local function stop_soundtrack()
    if track_main and (track_main:get_state() == "created" or track_main:get_state() == "playing" or 
    track_main:get_state() == "fading" or track_main:get_state() == "pausing" or track_main:get_state() == "paused") then
        track_main:fade_to(0, track_fade)
        track_main:finish()
        track_main = nil
        track_active = nil
    elseif track_main_next and (track_main_next:get_state() == "created" or track_main_next:get_state() == "playing" or 
    track_main_next:get_state() == "fading" or track_main_next:get_state() == "pausing" or track_main_next:get_state() == "paused") then
        track_main_next:fade_to(0, track_fade)
        track_main_next:finish()
        track_main_next = nil
        track_active = nil
    elseif track_edit_mode and (track_edit_mode:get_state() == "created" or track_edit_mode:get_state() == "playing" or 
    track_edit_mode:get_state() == "fading" or track_edit_mode:get_state() == "pausing" or track_edit_mode:get_state() == "paused") then
        track_edit_mode:fade_to(0, track_fade)
        track_edit_mode:finish()
        track_edit_mode = nil
        track_active = nil
    elseif track_edit_mode_next and (track_edit_mode_next:get_state() == "created" or track_edit_mode_next:get_state() == "playing" or 
    track_edit_mode_next:get_state() == "fading" or track_edit_mode_next:get_state() == "pausing" or track_edit_mode_next:get_state() == "paused") then
        track_edit_mode_next:fade_to(0, track_fade)
        track_edit_mode_next:finish()
        track_edit_mode_next = nil
        track_active = nil
    elseif track_competitions and (track_competitions:get_state() == "created" or track_competitions:get_state() == "playing" or 
    track_competitions:get_state() == "fading" or track_competitions:get_state() == "pausing" or track_competitions:get_state() == "paused") then
        track_competitions:fade_to(0, track_fade)
        track_competitions:finish()
        track_competitions = nil
        track_active = nil
    elseif track_competitions_next and (track_competitions_next:get_state() == "created" or track_competitions_next:get_state() == "playing" or 
    track_competitions_next:get_state() == "fading" or track_competitions_next:get_state() == "pausing" or track_competitions_next:get_state() == "paused") then
        track_competitions_next:fade_to(0, track_fade)
        track_competitions_next:finish()
        track_competitions_next = nil
        track_active = nil
    elseif track_competitions_cup and (track_competitions_cup:get_state() == "created" or track_competitions_cup:get_state() == "playing" or 
    track_competitions_cup:get_state() == "fading" or track_competitions_cup:get_state() == "pausing" or track_competitions_cup:get_state() == "paused") then
        track_competitions_cup:fade_to(0, track_fade)
        track_competitions_cup:finish()
        track_competitions_cup = nil
        track_active = nil
    elseif track_competitions_cup_next and (track_competitions_cup_next:get_state() == "created" or track_competitions_cup_next:get_state() == "playing" or 
    track_competitions_cup_next:get_state() == "fading" or track_competitions_cup_next:get_state() == "pausing" or track_competitions_cup_next:get_state() == "paused") then
        track_competitions_cup_next:fade_to(0, track_fade)
        track_competitions_cup_next:finish()
        track_competitions_cup_next = nil
        track_active = nil
    elseif track_competitions_lgecup and (track_competitions_lgecup:get_state() == "created" or track_competitions_lgecup:get_state() == "playing" or 
    track_competitions_lgecup:get_state() == "fading" or track_competitions_lgecup:get_state() == "pausing" or track_competitions_lgecup:get_state() == "paused") then
        track_competitions_lgecup:fade_to(0, track_fade)
        track_competitions_lgecup:finish()
        track_competitions_lgecup = nil
        track_active = nil
    elseif track_competitions_lgecup_next and (track_competitions_lgecup_next:get_state() == "created" or track_competitions_lgecup_next:get_state() == "playing" or 
    track_competitions_lgecup_next:get_state() == "fading" or track_competitions_lgecup_next:get_state() == "pausing" or track_competitions_lgecup_next:get_state() == "paused") then
        track_competitions_lgecup_next:fade_to(0, track_fade)
        track_competitions_lgecup_next:finish()
        track_competitions_lgecup_next = nil
        track_active = nil
    elseif track_results and (track_results:get_state() == "created" or track_results:get_state() == "playing" or 
    track_results:get_state() == "fading" or track_results:get_state() == "pausing" or track_results:get_state() == "paused") then
        track_results:fade_to(0, track_fade)
        track_results:finish()
        track_results = nil
        track_active = nil
    elseif track_results_next and (track_results_next:get_state() == "created" or track_results_next:get_state() == "playing" or 
    track_results_next:get_state() == "fading" or track_results_next:get_state() == "pausing" or track_results_next:get_state() == "paused") then
        track_results_next:fade_to(0, track_fade)
        track_results_next:finish()
        track_results_next = nil
        track_active = nil
    elseif track_highlights and (track_highlights:get_state() == "created" or track_highlights:get_state() == "playing" or 
    track_highlights:get_state() == "fading" or track_highlights:get_state() == "pausing" or track_highlights:get_state() == "paused") then
        track_highlights:fade_to(0, track_fade)
        track_highlights:finish()
        track_highlights = nil
        track_active = nil
    elseif track_highlights_next and (track_highlights_next:get_state() == "created" or track_highlights_next:get_state() == "playing" or 
    track_highlights_next:get_state() == "fading" or track_highlights_next:get_state() == "pausing" or track_highlights_next:get_state() == "paused") then
        track_highlights_next:fade_to(0, track_fade)
        track_highlights_next:finish()
        track_highlights_next = nil
        track_active = nil
    end
end

-- Function to check if a file exists
function file_exists(filename)
    local f = io.open(filename, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Function to handle team selection
local function teams_selected(ctx, home_team_id, away_team_id)
    result_check = 0
end
-- Function to handle data readiness and soundtrack settings based on the context and filename.
-- @param ctx: The context object containing tournament information and directory paths.
-- @param filename: The name of the file triggering the data readiness check.
function m.data_ready(ctx, filename)
    -- Get the tournament ID from the context
    tid = ctx.tournament_id

    -- Reset result_check if the specific rematch setup file is detected
    if filename == "common\\script\\flow\\Match\\MatchSetupRematch.json" then
        result_check = 0
    end

    -- Determine the tournament type and new ID based on the tournament ID
    if tid == nil then
        tid_new = 0
        tid_type = "none"
    elseif (tid == 2 or tid == 1026 or tid == 4 or tid == 2050 or tid == 3074 or tid == 4098 or tid == 5122 or tid == 6146 or tid == 7170 or tid == 8149 or 
        tid == 3  or tid == 1027 or tid == 2051 or tid == 3075 or tid == 4099 or tid == 5123 or tid == 6147 or tid == 7171 or tid == 8195) then
        tid_new = "UCL"
        tid_type = "cup"
    elseif (tid == 5 or tid == 1029 or tid == 2053 or tid == 3077 or tid == 4104 or tid == 5125 or tid == 6149 or tid == 7173 or tid == 8197 or tid == 9221 or 
        tid == 10245  or tid == 11269 or tid == 12293 or tid == 6) then
        tid_new = "UEL"
        tid_type = "cup"
    elseif (tid == 8 or tid == 9 or tid == 6153 or tid == 1032 or tid == 2056 or tid == 3080 or tid == 4104 or tid == 3081 or tid == 4105 or tid == 5129 or 
        tid == 7177 or tid == 8201 or tid == 10) then
        tid_new = "CCL"
        tid_type = "cup"
    elseif (tid == 15 or tid == 1039 or tid == 2063 or tid == 3087 or tid == 4111 or tid == 5135 or tid == 6159 or tid == 7183 or tid == 8207 or tid == 16) then
        tid_new = "ACL"
        tid_type = "cup"
    elseif (tid == 34 or tid == 1058 or tid == 2082 or tid == 3106 or tid == 4130 or tid == 5154 or tid == 6178 or tid == 7202 or tid == 8226 or tid == 35) then
        tid_new = "FWC"
        tid_type = "cup"
    elseif (tid == 41 or tid == 1065 or tid == 2089 or tid == 3113 or tid == 4137 or tid == 5161 or tid == 6185 or tid == 42) then
        tid_new = "EURO"
        tid_type = "cup"
    elseif (tid == 43 or tid == 104 or tid == 1128 or tid == 2152 or tid == 3176) then
        tid_new = "CCA"
        tid_type = "cup"
    elseif (tid == 105 or tid == 106 or tid == 107) then
        tid_new = "ICC"
        tid_type = "cup"
    elseif (tid == 48 or tid == 47 or tid == 1071 or tid == 2095 or tid == 3119 or tid == 4143 or tid == 5167 or tid == 6191 or tid == 7215 or tid == 8239) then
        tid_new = "KC"
        tid_type = "cup"
    elseif (tid == 133 or tid == 134 or tid == 135 or tid == 136) then
        tid_new = "SPFL"
        tid_type = "league"
    elseif (tid == 7) then
        tid_new = tid
        tid_type = "cup"
    elseif (tid == 23 or tid == 24 or tid == 25 or tid == 26 or tid == 27 or tid == 28 or tid == 31 or 
        tid == 53 or tid == 54 or tid == 55 or tid == 59 or tid == 68 or tid == 86 or tid == 87 or tid == 88 or 
        tid == 89 or tid == 90 or tid == 91 or tid == 92 or tid == 95 or tid == 97 or tid == 122 or tid == 123 or 
        tid == 124 or tid == 125 or tid == 126 or tid == 127 or tid == 128 or tid == 129 or tid == 130 or tid == 131 or 
        tid == 132 or tid == 137 or tid == 142 or tid == 164 or tid == 165) then
        tid_new = tid
        tid_type = "lgecup"
    else
        tid_new = tid
        tid_type = "league"
    end

-- STOP SOUNDTRACK SLOWLY AT MATCH LOADING SCREEN
    if string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\table_mode.bin") or 
        string.match(filename, "common\\demo\\fixdemo\\ent\\table_ent.bin") or 
        string.match(filename, "common\\demo\\fixdemo\\pk\\table_pk.bin") then
        track_fade = 10
        stop_soundtrack()

-- STOP SOUNDTRACK AT ADDITIONAL POINTS
    elseif filename == "common\\script\\flow\\Common\\MenuMovieOffMode.json" or 
        filename == "common\\script\\flow\\Common\\MenuMovieOffModePreMain.json" or
        filename == "common\\script\\flow\\Match\\MatchHalfTime.json" or
        filename == "common\\script\\flow\\Match\\MatchResult.json" or
        filename == "common\\script\\flow\\Match\\MatchStatsHalf.json" or
        filename == "common\\script\\flow\\Match\\MatchStatsResult.json" or
        filename == "common\\script\\flow\\Match\\MatchPause.json" or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_award_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_cardpack_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_circuittraining_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_firstday_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_locker_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_meeting_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_player_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_press_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_randomselect_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_testimonial_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_transfer_.*") or
        string.match(filename, "common\\demo\\fixdemo\\mode\\cut_data\\mode_visit_.*") then
        if result_check == 1 then
            result_check = 0
        end
        track_fade = 3
        stop_soundtrack()

-- START SOUNDTRACK AT MAIN MENU
    elseif filename == "common\\script\\flow\\Intro\\MenuTitle.json" or 
        filename == "common\\script\\flow\\TopMenu\\TopMenu.json" or 
        filename == "common\\script\\flow\\TopMenu\\TopMenuNew.json" or 
        filename == "common\\script\\flow\\Exhibition\\ExhibiTeamSel.json" then
        if track_active == 999 then
            log(string.format("Main menu soundtrack cannot start due to track already playing: %s", track_main:get_filename()))
        else
            track_fade = 3
            if Main_Soundtrack_MaxCount ~= 0 then
                track_fade = 3
                stop_soundtrack()
                track_active = 999
                rdm = math.random(1, Main_Soundtrack_MaxCount)
                track_main = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                start_main_soundtrack(ctx)
            end
        end

-- START SOUNDTRACK AT EDIT MODE MENU
    elseif filename == "common\\script\\flow\\Edit\\EditMenu.json" then
        if track_active == 998 then
            log(string.format("Edit mode soundtrack cannot start due to track already playing: %s", track_edit_mode:get_filename()))
        else
            track_fade = 3
            if Main_Edit_Mode_MaxCount ~= 0 then
                if file_exists(ctx.sider_dir .. Main_Edit_Mode .. "Track_1.mp3") then
                    stop_soundtrack()
                    track_active = 998
                    rdm = math.random(1, Main_Edit_Mode_MaxCount)
                    track_edit_mode = audio.new(ctx.sider_dir .. Main_Edit_Mode .. "Track_" .. rdm .. ".mp3")
                    start_edit_mode_soundtrack(ctx)
                end
            end
        end

-- START SOUNDTRACK AT COMPETITION MENU
    elseif filename == "common\\script\\flow\\League\\LeagueMainMenu.json" or 
        filename == "common\\script\\flow\\Compe\\CompeMainMenu.json" or
        filename == "common\\script\\flow\\Common\\CmnModeMatchMenu.json" or
        filename == "common\\script\\flow\\BL\\BLMainMenu.json" or
        filename == "common\\script\\flow\\ML\\MLMainManu.json" then
        if tid_type == "cup" then
            if track_active == 997 .. "cup" then
                log(string.format("Competition cup soundtrack cannot start due to track already playing: %s", track_competitions_cup:get_filename()))
            else
                track_fade = 3
                if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                    if Main_Competitions_Specific_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "cup"
                        rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                        track_competitions_cup = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                        start_competitions_cup_soundtrack(ctx)
                    end
                elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                    if Main_Competitions_Generic_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "cup"
                        rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                        track_competitions_cup = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                        start_competitions_cup_soundtrack(ctx)
                    end
                else
                    if Main_Soundtrack_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "cup"
                        rdm = math.random(1, Main_Soundtrack_MaxCount)
                        track_competitions_cup = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                        start_competitions_cup_soundtrack(ctx)
                    end
                end
            end
        elseif tid_type == "lgecup" then
            if track_active == 997 .. "lgecup" then
                log(string.format("Competition league cup soundtrack cannot start due to track already playing: %s", track_competitions_cup:get_filename()))
            else
                track_fade = 3
                if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                    if Main_Competitions_Specific_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "lgecup"
                        rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                        track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                        start_competitions_lgecup_soundtrack(ctx)
                    end
                elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "lgecup" then
                    if Main_Competitions_Generic_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "lgecup"
                        rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                        track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                        start_competitions_lgecup_soundtrack(ctx)
                    end
                else
                    if Main_Soundtrack_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997 .. "lgecup"
                        rdm = math.random(1, Main_Soundtrack_MaxCount)
                        track_competitions_lgecup = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                        start_competitions_lgecup_soundtrack(ctx)
                    end
                end
            end
        else
            if track_active == 997 then
                log(string.format("Competition soundtrack cannot start due to track already playing: %s", track_competitions:get_filename()))
            else
                track_fade = 3
                if file_exists(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                    if Main_Competitions_Specific_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997
                        rdm = math.random(1, Main_Competitions_Specific_MaxCount)
                        track_competitions = audio.new(ctx.sider_dir .. Main_Competitions_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                        start_competitions_soundtrack(ctx)
                    end
                elseif file_exists(ctx.sider_dir .. Main_Competitions_Generic .. "Track_1.mp3") and tid_type == "cup" then
                    if Main_Competitions_Generic_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997
                        rdm = math.random(1, Main_Competitions_Generic_MaxCount)
                        track_competitions = audio.new(ctx.sider_dir .. Main_Competitions_Generic .. "Track_" .. rdm .. ".mp3")
                        start_competitions_soundtrack(ctx)
                    end
                else
                    if Main_Soundtrack_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 997
                        rdm = math.random(1, Main_Soundtrack_MaxCount)
                        track_competitions = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                        start_competitions_soundtrack(ctx)
                    end
                end
            end
        end

-- START SOUNDTRACK AT RESULTS MENU
    elseif filename == "common\\menu\\general\\matchList.bin" then
        if track_active == 996 then
            log(string.format("Results soundtrack cannot start due to track already playing: %s", track_results:get_filename()))
        else
            track_fade = 3
            if file_exists(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                if Main_Results_Specific_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 996
                    rdm = math.random(1, Main_Results_Specific_MaxCount)
                    track_results = audio.new(ctx.sider_dir .. Main_Results_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                    start_results_soundtrack(ctx)
                end
            elseif file_exists(ctx.sider_dir .. Main_Results_Generic .. "Track_1.mp3") then
                if Main_Results_Generic_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 996
                    rdm = math.random(1, Main_Results_Generic_MaxCount)
                    track_results = audio.new(ctx.sider_dir .. Main_Results_Generic .. "Track_" .. rdm .. ".mp3")
                    start_results_soundtrack(ctx)
                end
            else
                if Main_Soundtrack_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 996
                    rdm = math.random(1, Main_Soundtrack_MaxCount)
                    track_results = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                    start_results_soundtrack(ctx)
                end
            end
        end

-- START SOUNDTRACK WHEN HIGHLIGHTS IS SELECTED FROM HALFTIME OR FULLTIME MENU
    elseif filename == "common\\script\\flow\\Match\\MatchHalftimeHighlight.json" or 
        filename == "common\\script\\flow\\Match\\MatchResultHighlight.json" then
        if track_active == 995 then
            log(string.format("Highlights soundtrack cannot start due to track already playing: %s", track_highlights:get_filename()))
        else
            track_fade = 3
            if file_exists(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                if Main_Highlights_Specific_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 995
                    rdm = math.random(1, Main_Highlights_Specific_MaxCount)
                    track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                    start_highlights_soundtrack(ctx)
                end
            elseif file_exists(ctx.sider_dir .. Main_Highlights_Generic .. "Track_1.mp3") then
                if Main_Highlights_Generic_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 995
                    rdm = math.random(1, Main_Highlights_Generic_MaxCount)
                    track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Generic .. "Track_" .. rdm .. ".mp3")
                    start_highlights_soundtrack(ctx)
                end
            else
                if Main_Soundtrack_MaxCount ~= 0 then
                    stop_soundtrack()
                    track_active = 995
                    rdm = math.random(1, Main_Soundtrack_MaxCount)
                    track_highlights = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                    start_highlights_soundtrack(ctx)
                end
            end
        end

-- SET FLAG WHETHER THE MATCH AS ENDED
    elseif string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_01_.*") or 
        string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_02_.*") or 
        string.match(filename, "common\\demo\\fixdemo\\timeup\\cut_data\\tu_full_cut_.*") or
        string.match(filename, "common\\demo\\fixdemo\\end\\cut_data\\end_pk_.*") then
        result_check = 1

-- SET FLAG TO WORKAROUND A HATTRICK
    elseif string.match(filename, "common\\demo\\anime\\FoxAnim\\FixDemo\\Animations\\dml_tu_pickup_hattrick01_.*") then
        result_check = 2
    elseif string.match(filename, "Asset\\model\\ball\\ball.*%\\#Win\\ball.fpkd") then
        if result_check == 2 then
            result_check = 1
        end

-- START SOUNDTRACK DURING AUTOMATIC HIGHLIGHTS AT END OF MATCH
    elseif string.match(filename, "Asset\\model\\ball\\ball.*%\\#Win\\ball.fpk") then
        if result_check == 1 then
            if track_active == 995 then
                log(string.format("Highlights soundtrack cannot start due to track already playing: %s", track_highlights:get_filename()))
            else
                track_fade = 3
                if file_exists(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_1.mp3") then
                    if Main_Highlights_Specific_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 995
                        rdm = math.random(1, Main_Highlights_Specific_MaxCount)
                        track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Specific .. tid_new .. "\\" .. "Track_" .. rdm .. ".mp3")
                        start_highlights_soundtrack(ctx)
                    end
                elseif file_exists(ctx.sider_dir .. Main_Highlights_Generic .. "Track_1.mp3") then
                    if Main_Highlights_Generic_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 995
                        rdm = math.random(1, Main_Highlights_Generic_MaxCount)
                        track_highlights = audio.new(ctx.sider_dir .. Main_Highlights_Generic .. "Track_" .. rdm .. ".mp3")
                        start_highlights_soundtrack(ctx)
                    end
                else
                    if Main_Soundtrack_MaxCount ~= 0 then
                        stop_soundtrack()
                        track_active = 995
                        rdm = math.random(1, Main_Soundtrack_MaxCount)
                        track_highlights = audio.new(ctx.sider_dir .. Main_Soundtrack .. "Track_" .. rdm .. ".mp3")
                        start_highlights_soundtrack(ctx)
                    end
                end
            end
        end
    end
end

-- Function to handle key press events
function m.key_up(ctx, vkey)
-- Check if the pressed key is the designated key (0x35)
    if vkey == 0x35 then
            if track_main or track_main_next then
                -- Stop the current main track if it's playing
                if track_main and track_main:get_state() == "playing" then
                   track_main:fade_to(0, 1)
                   track_main:finish() -- Stop the main track
                elseif track_main_next and track_main_next:get_state() == "playing" then
                track_main_next:fade_to(0, 1)
                track_main_next:finish()  -- Stop the next main track
                
                elseif track_main and track_main:get_state() == "playing" or track_main_next and track_main_next:get_state() == "playing" then
                track_edit_mode = stop_soundtrack() 
                track_edit_mode_next = stop_soundtrack() 
                track_competitions = stop_soundtrack()  
                track_competitions_next = stop_soundtrack()  
                track_competitions_cup = stop_soundtrack() 
                track_competitions_cup_next = stop_soundtrack() 
                track_competitions_lgecup = stop_soundtrack()  
                track_competitions_lgecup_next = stop_soundtrack()    
                track_results = stop_soundtrack()  
                track_results_next = stop_soundtrack()  
                track_highlights = stop_soundtrack()
                track_highlights_next = stop_soundtrack()

                else
                    -- If a different key is pressed, check the state of the tracks
                    if track_main and track_main:get_state() == "stopped" then
                    next_main_soundtrack(ctx) 
                    elseif track_main_next and track_main_next:get_state() == "stopped" then
                    start_main_soundtrack(ctx) 
                    end
                    
                end
            end
        
            if track_edit_mode or track_edit_mode_next then
                    if track_edit_mode and track_edit_mode:get_state() == "playing" then
                       track_edit_mode:fade_to(0, 1)
                       track_edit_mode:finish() -- Stop the main track
                
                    elseif track_edit_mode_next and track_edit_mode_next:get_state() == "playing" then
                    track_edit_mode_next:fade_to(0, 1)
                    track_edit_mode_next:finish()  -- Stop the next main track
                
                    elseif track_edit_mode and track_edit_mode:get_state() == "playing" or track_edit_mode_next and track_edit_mode_next:get_state() == "playing" then
                    track_main = stop_soundtrack() 
                    track_main_next = stop_soundtrack() 
                    track_competitions = stop_soundtrack()  
                    track_competitions_next = stop_soundtrack()  
                    track_competitions_cup = stop_soundtrack() 
                    track_competitions_cup_next = stop_soundtrack() 
                    track_competitions_lgecup = stop_soundtrack()  
                    track_competitions_lgecup_next = stop_soundtrack()  
                    track_results = stop_soundtrack()  
                    track_results_next = stop_soundtrack()  
                    track_highlights = stop_soundtrack()
                    track_highlights_next = stop_soundtrack()

                    else
                        -- If a different key is pressed, check the state of the tracks
                        if track_edit_mode and track_edit_mode:get_state() == "stopped" then
                        next_edit_mode_soundtrack(ctx)
                        elseif track_edit_mode_next and track_edit_mode_next:get_state() == "stopped" then
                        start_edit_mode_soundtrack(ctx) 
                        end
                    end
            end
       
            if track_competitions or track_competitions_next then
                    if track_competitions and track_competitions:get_state() == "playing" then
                       track_competitions:fade_to(0, 1)
                       track_competitions:finish() -- Stop the main track
                
                    elseif track_competitions_next and track_competitions_next:get_state() == "playing" then
                    track_competitions_next:fade_to(0, 1)
                    track_competitions_next:finish()  -- Stop the next main track
                                
                    elseif track_competitions and track_competitions:get_state() == "playing" or track_competitions_next and track_competitions_next:get_state() == "playing" then
                    track_main = stop_soundtrack() 
                    track_main_next = stop_soundtrack() 
                    track_edit_mode = stop_soundtrack()  
                    track_edit_mode_next = stop_soundtrack()  
                    track_competitions_cup = stop_soundtrack() 
                    track_competitions_cup_next = stop_soundtrack() 
                    track_competitions_lgecup = stop_soundtrack()  
                    track_competitions_lgecup_next = stop_soundtrack()  
                    track_results = stop_soundtrack()  
                    track_results_next = stop_soundtrack()  
                    track_highlights = stop_soundtrack()
                    track_highlights_next = stop_soundtrack()

                    else 
                    -- If a different key is pressed, check the state of the tracks
                        if track_competitions and track_competitions:get_state() == "stopped" then
                        next_competitions_soundtrack(ctx)
                        elseif track_competitions_next and track_competitions_next:get_state() == "stopped" then
                        start_competitions_soundtrack(ctx)
                        end
                    end 
            end
            
            if track_competitions_cup or track_competitions_cup_next  then
                if track_competitions_cup and track_competitions_cup:get_state() == "playing" then
                   track_competitions_cup:fade_to(0, 1)
                   track_competitions_cup:finish() -- Stop the main track
                
                elseif track_competitions_cup_next and track_competitions_cup_next:get_state() == "playing" then
                track_competitions_cup_next:fade_to(0, 1)
                track_competitions_cup_next:finish()  -- Stop the next main track
                                
                elseif track_competitions_cup and track_competitions_cup:get_state() == "playing" or track_competitions_cup_next and track_competitions_cup_next:get_state() == "playing" then
                track_main = stop_soundtrack() 
                track_main_next = stop_soundtrack() 
                track_edit_mode = stop_soundtrack()  
                track_edit_mode_next = stop_soundtrack()  
                track_competitions = stop_soundtrack() 
                track_competitions = stop_soundtrack() 
                track_competitions_lgecup = stop_soundtrack()  
                track_competitions_lgecup_next = stop_soundtrack()  
                track_results = stop_soundtrack()  
                track_results_next = stop_soundtrack()  
                track_highlights = stop_soundtrack()
                track_highlights_next = stop_soundtrack()
                
                else 
                    -- If a different key is pressed, check the state of the tracks
                    if track_competitions_cup and track_competitions_cup:get_state() == "stopped" then
                    next_competitions_cup_soundtrack(ctx)
                    elseif track_competitions_cup_next and track_competitions_cup_next:get_state() == "stopped" then
                    start_competitions_cup_soundtrack(ctx)
                    end
                end
            end
        
            if track_competitions_lgecup or track_competitions_lgecup_next then
                if track_competitions_lgecup and track_competitions_lgecup:get_state() == "playing" then
                   track_competitions_lgecup:fade_to(0, 1)
                   track_competitions_lgecup:finish() -- Stop the main track
 
                elseif track_competitions_lgecup_next and track_competitions_lgecup_next:get_state() == "playing" then
                track_competitions_lgecup_next:fade_to(0, 1)
                track_competitions_lgecup_next:finish()  -- Stop the next main track
                                
                elseif track_competitions_lgecup and track_competitions_lgecup:get_state() == "playing" or track_competitions_lgecup_next and track_competitions_lgecup_next:get_state() == "playing" then
                track_main = stop_soundtrack() 
                track_main_next = stop_soundtrack() 
                track_edit_mode = stop_soundtrack()  
                track_edit_mode_next = stop_soundtrack()  
                track_competitions = stop_soundtrack() 
                track_competitions = stop_soundtrack() 
                track_competitions_cup = stop_soundtrack()  
                track_competitions_cup_next = stop_soundtrack()  
                track_results = stop_soundtrack()  
                track_results_next = stop_soundtrack()  
                track_highlights = stop_soundtrack()
                track_highlights_next = stop_soundtrack()
                
                else 
                    -- If a different key is pressed, check the state of the tracks
                    if track_competitions_lgecup and track_competitions_lgecup:get_state() == "stopped" then
                    next_competitions_lgecup_soundtrack(ctx)
                    elseif track_competitions_lgecup_next and track_competitions_lgecup_next:get_state() == "stopped" then
                    start_competitions_lgecup_soundtrack(ctx)
                    end
                end
            end
        
            if track_results or track_results_next then
                if track_results and track_results:get_state() == "playing" then
                   track_results:fade_to(0, 1)
                   track_results:finish() -- Stop the main track
                
                elseif track_results_next and track_results_next:get_state() == "playing" then
                track_results_next:fade_to(0, 1)
                track_results_next:finish()  -- Stop the next main track
                
                elseif track_results and track_results:get_state() == "playing" or track_results_next and track_results_next:get_state() == "playing" then
                track_main = stop_soundtrack() 
                track_main_next = stop_soundtrack() 
                track_edit_mode = stop_soundtrack()  
                track_edit_mode_next = stop_soundtrack()  
                track_competitions = stop_soundtrack() 
                track_competitions = stop_soundtrack() 
                track_competitions_cup = stop_soundtrack()  
                track_competitions_cup_next = stop_soundtrack()  
                track_competitions_lgecup = stop_soundtrack()  
                track_competitions_lgecup_next = stop_soundtrack()  
                track_highlights = stop_soundtrack()
                track_highlights_next = stop_soundtrack()

                else 
                    -- If a different key is pressed, check the state of the tracks
                    if track_results and track_results:get_state() == "stopped" then
                    next_results_soundtrack(ctx)
                    elseif track_results_next and track_results_next:get_state() == "stopped" then
                    start_results_soundtrack(ctx)
                    end
                end
            end
                
            if track_highlights or track_highlights_next then
                if track_highlights and track_highlights:get_state() == "playing" then
                   track_highlights:fade_to(0, 1)
                   track_highlights:finish() -- Stop the main track
                
                elseif track_highlights_next and track_highlights_next:get_state() == "playing" then
                track_highlights_next:fade_to(0, 1)
                track_highlights_next:finish()  -- Stop the next main track
                
                elseif track_highlights and track_highlights:get_state() == "playing" or track_highlights_next and track_highlights_next:get_state() == "playing" then
                track_main = stop_soundtrack() 
                track_main_next = stop_soundtrack() 
                track_edit_mode = stop_soundtrack()  
                track_edit_mode_next = stop_soundtrack()  
                track_competitions = stop_soundtrack() 
                track_competitions = stop_soundtrack() 
                track_competitions_cup = stop_soundtrack()  
                track_competitions_cup_next = stop_soundtrack()  
                track_competitions_lgecup = stop_soundtrack()  
                track_competitions_lgecup_next = stop_soundtrack()  
                track_results = stop_soundtrack()
                track_results_next = stop_soundtrack()

                else 
                    -- If a different key is pressed, check the state of the tracks
                    if track_highlights and track_highlights:get_state() == "stopped" then
                    next_highlights_soundtrack(ctx)
                    elseif track_highlights_next and track_highlights_next:get_state() == "stopped" then
                    start_highlights_soundtrack(ctx)
                    end
                end
            end
    end
end
    
-- Function to initialize the module by registering event handlers.
-- @param ctx: The context object used for registering events.
function m.init(ctx)
    ctx.register("key_up", m.key_up) -- Register event handlers for team selection and data readiness
    ctx.register("set_teams", teams_selected)
    ctx.register("livecpk_data_ready", m.data_ready)
    ctx.register("overlay_on", m.overlay_on)    
end

-- Return the module
return m

