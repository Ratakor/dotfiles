local mp = require("mp")

local id = 0

local function notify_current_media(key)
    local title = mp.get_property(key)
    mp.command("run pkill -RTMIN+1 waybar")
    local cmd = "notify-send -p -r " .. tostring(id) .. " '" .. title .. "'"
    local handle = io.popen(cmd)
    if handle then
        local new_id = handle:read("*a")
        id = tonumber(new_id) or id
        handle:close()
    end
end

mp.observe_property("media-title", string, notify_current_media)
