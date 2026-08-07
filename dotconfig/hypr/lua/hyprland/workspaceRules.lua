-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- workspaceRules.lua by Andy3153
-- created   07/08/26 ~ 05:02:10
--

local workspaceRules =
{
  -- {{{ Name workspace
  --{ workspace = "1",  default_name = "default" },
  --{ workspace = "3",  default_name = "browser" },
  --{ workspace = "7",  default_name = "download" },
  --{ workspace = "8",  default_name = "game" },
  --{ workspace = "9",  default_name = "social" },
  --{ workspace = "10", default_name = "music" },
  -- }}}
}

-- {{{ Setting the workspace rules in the array
for _, value in pairs(workspaceRules) do
  hl.workspace_rule(value)
end
-- }}}
