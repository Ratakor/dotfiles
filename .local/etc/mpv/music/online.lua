local utils = require "mp.utils"

function notify_current_media(key)
	local title = mp.get_property(key)
	mp.command_native({"run", "pkill", "-RTMIN+9", "dwmblocks"})
	return mp.command_native({"run", "notify-send", title})
end

mp.observe_property("media-title", string, notify_current_media)
