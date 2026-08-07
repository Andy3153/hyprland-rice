-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- functions.lua by Andy3153
-- created   06/08/26 ~ 19:15:03
--

-- {{{ Inspect table
local function inspectTable(t, indent, visited)
  indent  = indent or 0
  visited = visited or {}

  if type(t) ~= "table" then return tostring(t) end

  if visited[t] then return "[circular reference]" end

  visited[t] = true

  local result     = "{\n"
  local indent_str = string.rep("  ", indent + 1)

  for k, v in pairs(t) do
    local key_str = type(k) == "string" and '"' .. k .. '"' or k
    local val_str = inspectTable(v, indent + 1, visited)

    result = result .. indent_str .. key_str .. " = " .. val_str .. ",\n"
  end

  result = result .. string.rep("  ", indent) .. "}"

  return result
end
-- }}}

-- {{{ Print to Hyprland notifications
function Print(text)
  local text       = inspectTable(text)
  local timeout    = string.len(text) * 1000
  local maxTimeout = 20000

  if timeout > maxTimeout then timeout = maxTimeout end

  hl.notification.create(
  {
    timeout = timeout,
    text    = text
  })
end
-- }}}
