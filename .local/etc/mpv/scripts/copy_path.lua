local mp = require "mp"

local function copy_path()
	local path = mp.get_property("path")
	mp.osd_message(string.format("Copied to clipboard: %s", path))
	os.execute("printf '%s' "..path.." | xclip -sel clip")
end

mp.add_key_binding("y", "copy_path", copy_path)
