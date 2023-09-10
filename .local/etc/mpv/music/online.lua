local mp = require "mp"

local function notify_current_media(key)
	local title = mp.get_property(key)
	mp.command_native({"run", "pkill", "-RTMIN", "sb"})
	return mp.command_native({"run", "env", "HERBE_ID=/music", "herbe", title})
end

mp.observe_property("media-title", string, notify_current_media)
