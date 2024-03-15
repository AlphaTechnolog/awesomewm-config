local wibox = require "wibox"
local awful = require "awful"
local ascreen = require "awful.screen"
local gtimer = require "gears.timer"
local animation = require "lib.animation"
local color = require "lib.color"
local general = require "lib.general"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local widget = require "ui.guards.widget"

local settings_toggler = {}

function settings_toggler:render()
  local container = wibox.widget {
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
    {
      id = "background_element",
      widget = wibox.container.background,
      shape = general:srounded(6),
      bg = beautiful.colors.background,
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(4),
          bottom = dpi(4),
          left = dpi(6),
          right = dpi(6),
        },
        {
          widget = wibox.widget.textbox,
          markup = general:tint_markup(beautiful.colors.light_black_10, ""),
          font = beautiful.fonts:choose("icons", 12),
        },
      }
    },
  }

  container.hover_animation = animation:new {
    duration = 0.25,
    easing = animation.easing.linear,
    pos = color.hex_to_rgba(beautiful.colors.background),
    update = function (_, pos)
      if pos then
        container.background_element.bg = color.rgba_to_hex(pos)
      end
    end
  }

  function container.hover_animation:set_color(new_color)
    self:set { target = color.hex_to_rgba(new_color) }
  end

  function container:onhover()
    self.hover_animation:set_color(beautiful.colors.light_background_4)
  end

  function container:onhoverlost()
    self.hover_animation:set_color(beautiful.colors.background)
  end

  -- binding functions
  local function binder(v)
    return function ()
      container[v](container)
    end
  end

  container:connect_signal("mouse::enter", binder("onhover"))
  container:connect_signal("mouse::leave", binder("onhoverlost"))

  container:add_button(awful.button({}, 1, function ()
    local window = ascreen.focused().core_window
    if not window then
      error("cannot grab the core window")
    end

    gtimer.delayed_call(function ()
      window:toggle()
    end)
  end))

  return container
end

return widget(settings_toggler)
