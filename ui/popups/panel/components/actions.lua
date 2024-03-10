local wibox = require("wibox")
local gshape = require("gears.shape")
local widget = require("ui.guards.widget")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Actions = {}

function Actions:constructor()
  self._private.layout = wibox.layout.fixed.horizontal()
  self._private.layout.spacing = dpi(7)
end

-- just for showcasing
local function dummy_icon(icon)
  return wibox.widget({
    widget = wibox.widget.textbox,
    markup = icon,
    font = beautiful.fonts:choose("icons", 10),
    valign = "center",
    align = "center"
  })
end

function Actions:register_actions()
  self._private.layout:add(dummy_icon(""))
  self._private.layout:add(dummy_icon(""))
  self._private.layout:add(dummy_icon(""))
end

function Actions:render()
  self:register_actions()

  return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_shade_1,
    shape = gshape.rounded_bar,
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(2),
        bottom = dpi(2),
        left = dpi(12),
        right = dpi(12)
      },
      self._private.layout
    }
  }
end

return widget(Actions)