local utils = require "mp.utils"

function notify_current_media()
	local path = mp.get_property_native("path")
	local origin, title = utils.split_path(path)

	local metadata = mp.get_property_native("metadata")
	if metadata then
		function tag(name)
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
	mp.command_native({"run", "pkill", "-RTMIN", "sb"})
	return mp.command_native({"run", "env", "HERBE_ID=/music", "herbe", title, origin})
end

mp.register_event("file-loaded", notify_current_media)
