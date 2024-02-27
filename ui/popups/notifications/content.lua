local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widget = require("ui.guards.widget")

local Notifications = require("ui.popups.notifications.components.notifications")
local Github = require("ui.popups.notifications.components.github")

local Content = {}

local function base_container(w)
  local container = wibox.container.background(w)
  container.bg = beautiful.colors.background
  container.fg = beautiful.colors.foreeground
  return container
end

function Content:render()
  return base_container(wibox.widget {
    layout = wibox.layout.align.vertical,
    nil,
    Notifications():render(),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(6),
      },
      Github():render(),
    }
  })
end

return widget(Content)
