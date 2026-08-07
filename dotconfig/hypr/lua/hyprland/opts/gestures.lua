-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Gestures config
--

hl.config(
{
  gestures =
  {
    workspace_swipe_distance       = 800,
    workspace_swipe_create_new     = false,
    workspace_swipe_direction_lock = false,
    workspace_swipe_use_r          = true
  }
})

local gestures =
{
  { fingers = 3, direction = "vertical",   action = "workspace" },
  { fingers = 3, direction = "horizontal", action = "scroll_move" },
}

-- {{{ Applying the gestures in the array
for _, value in pairs(gestures) do
  hl.gesture(value)
end
-- }}}
