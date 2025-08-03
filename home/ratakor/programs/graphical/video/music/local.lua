local mp = require "mp"
local utils = require "mp.utils"

local id = 0

local function notify_current_media()
    local path = mp.get_property_native("path")
    local origin, title = utils.split_path(path)

    local metadata = mp.get_property_native("metadata")
    if metadata then
        local function tag(name)
            return metadata[string.upper(name)] or metadata[name]
        end

        title = tag("title") or title
        origin = tag("artist_credit") or tag("artist") or ""

        local album = tag("album")
        if album then
            origin = string.format("%s — %s", origin, album)
        end

        local year = tag("original_year") or tag("year")
        if year then
            origin = string.format("%s (%s)", origin, year)
        end
    end

    mp.command("run pkill -RTMIN+1 waybar")
    local cmd = "notify-send -p -r " .. tostring(id) .. " '" .. title .. "' '" .. origin .. "'"
    local handle = io.popen(cmd)
    if handle then
        local new_id = handle:read("*a")
        id = tonumber(new_id) or id
        handle:close()
    end
end

mp.register_event("file-loaded", notify_current_media)
