local wibox = require "wibox"
local gshape = require "gears.shape"
local Widget = require "ui.guards.widget"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local actions = {}

function actions:render()
  return wibox.widget {
    widget = wibox.container.margin,
    margins = {
      left = dpi(6),
      right = dpi(6),
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_3,
      shape = gshape.rounded_bar,
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(5),
          bottom = dpi(5)
        },
        {
          widget = wibox.widget.textbox,
          markup = ' ',
          valign = 'center',
          align = 'center',
        }
      }
    }
  }
end

return Widget(actions)
