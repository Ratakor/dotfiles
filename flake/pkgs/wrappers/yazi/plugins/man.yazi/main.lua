local M = {}

function M:peek(job)
  local cmd = "man " .. ya.quote(tostring(job.file.url)) .. " | col -bx | bat -l man --color=always"
  local child = Command("sh"):arg({ "-c", cmd }):stdout(Command.PIPED):stderr(Command.PIPED):spawn()
  if not child then
    return self:fallback_to_builtin(job)
  end

  local limit = job.area.h
  local i, lines = 0, ""
  repeat
    local next, event = child:read_line()
    if event == 1 then
      return self:fallback_to_builtin(job)
    elseif event ~= 0 then
      break
    end

    i = i + 1
    if i > job.skip then
      lines = lines .. next
    end
  until i >= job.skip + limit

  child:start_kill()
  if job.skip > 0 and i < job.skip + limit then
    ya.manager_emit("peek", {
      math.max(0, i - limit),
      only_if = job.file.url,
      upper_bound = true,
    })
  else
    lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
    ya.preview_widgets(job, { ui.Paragraph.parse(job.area, lines) })
  end
end

function M:seek(job)
  local h = cx.active.current.hovered
  if h and h.url == job.file.url then
    local step = math.floor(job.units * job.area.h / 10)
    ya.manager_emit("peek", {
      math.max(0, cx.active.preview.skip + step),
      only_if = job.file.url,
    })
  end
end

function M:fallback_to_builtin(job)
  local err, bound = ya.preview_code(job)
  if bound then
    ya.manager_emit("peek", { bound, only_if = job.file.url, upper_bound = true })
  elseif err and not err:find("cancelled", 1, true) then
    ya.preview_widgets(job, {
      ui.Paragraph(job.area, { ui.Line(err):reverse() }),
    })
  end
end

return M
