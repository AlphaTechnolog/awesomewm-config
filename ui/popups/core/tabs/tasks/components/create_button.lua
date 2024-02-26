local awful = require "awful"
local wibox = require "wibox"
local gshape = require "gears.shape"
local animation = require "lib.animation"
local color = require "lib.color"
local widget = require "ui.guards.widget"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local CreateButton = {}

function CreateButton:render()
  local container = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.accent,
    fg = beautiful.colors.background,
    shape = gshape.circle,
    {
      widget = wibox.container.margin,
      margins = dpi(8),
      {
        widget = wibox.widget.textbox,
        markup = "",
        font = beautiful.fonts:choose("icons", 16),
        valign = "center",
        align = "center"
      }
    }
  }

  container.transition = animation:new {
    duration = 1,
    easing = animation.easing.outExpo,
    pos = color.hex_to_rgba(beautiful.colors.accent),
    update = function (_, pos)
      container.bg = color.rgba_to_hex(pos)
    end
  }

  function container:set_color(new_color)
    self.transition:set { target = color.hex_to_rgba(new_color) }
  end

  container:connect_signal("mouse::enter", function ()
    container:set_color(color.lighten(beautiful.colors.accent, 50))
  end)

  container:connect_signal("mouse::leave", function ()
    container:set_color(beautiful.colors.accent)
  end)

  container:add_button(awful.button({}, 1, function ()
    require "naughty".notify { title = "TODO" }
  end))

  return container
end

return widget(CreateButton)