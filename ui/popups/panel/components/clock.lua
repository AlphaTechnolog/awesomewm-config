local wibox = require "wibox"
local Widget = require "ui.guards.widget"
local gtimer = require "gears.timer"
local general = require "lib.general"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local clock = {}

function clock:constructor()
  self._private.values = {}
  self:setup()
end

function clock:update()
  self._private.values.hour = os.date("%H")
  self._private.values.minutes = os.date("%M")
end

function clock:setup()
  gtimer {
    call_now = true,
    autostart = true,
    single_shot = false,
    callback = function ()
      self:update()
      self:rehydratate()
    end
  }
end

function clock:rehydratate()
  if not self._private.hour_widget or not self._private.minutes_widget then
    return
  end

  for _, key in ipairs {'hour', 'minutes'} do
    self._private[key .. '_widget']:set_markup_silently(
      self._private.values[key]
    )
  end
end

function clock:contained(child)
  return wibox.widget {
    widget = wibox.container.margin,
    margins = {
      left = dpi(6),
      right = dpi(6),
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_3,
      shape = general:srounded(dpi(12)),
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(10),
          bottom = dpi(9),
          left = dpi(4),
          right = dpi(4)
        },
        child,
      }
    }
  }
end

function clock:text()
  return wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.fonts:choose("normal", 10),
    valign = 'center',
    align = 'center',
  }
end

function clock:make_widgets()
  self._private.hour_widget = self:text()
  self._private.minutes_widget = self:text()
end

function clock:render()
  self:make_widgets()

  return self:contained {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(8),
    self._private.hour_widget,
    self._private.minutes_widget
  }
end

return Widget(clock)
