local wibox = require "wibox"
local general = require "lib.general"
local color = require "lib.color"
local animation = require "lib.animation"
local widget = require "ui.guards.widget"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local Header = {}

function Header:search_input()
  local background = wibox.widget {
    widget = wibox.container.background,
    forced_width = dpi(320),
    shape = general:srounded(dpi(7)),
    bg = beautiful.colors.light_background_2,
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(3),
        bottom = dpi(3),
        left = dpi(8),
        right = dpi(8),
      },
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(4),
        {
          widget = wibox.widget.textbox,
          markup = general:tint_markup(beautiful.colors.accent, ""),
          font = beautiful.fonts:choose("icons", 14),
          valign = "center",
          align = "left",
        },
        {
          widget = wibox.widget.textbox,
          markup = general:tint_markup(beautiful.colors.light_background_12, "Search task"),
          font = beautiful.fonts:choose("normal", 8),
          valign = "center",
          align = "left",
        }
      }
    }
  }

  background.transition = animation:new {
    duration = 0.25,
    easing = animation.easing.linear,
    pos = color.hex_to_rgba(beautiful.colors.light_background_2),
    update = function (_, pos)
      background.bg = color.rgba_to_hex(pos)
    end
  }

  function background:set_color(new_color)
    self.transition:set { target = color.hex_to_rgba(new_color) }
  end

  background:connect_signal("mouse::enter", function ()
    background:set_color(beautiful.colors.light_background_3)
  end)

  background:connect_signal("mouse::leave", function ()
    background:set_color(beautiful.colors.light_background_2)
  end)

  return background
end

function Header:render()
  return wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(8),
        left = dpi(12),
        right = dpi(12),
        bottom = dpi(8),
      },
      {
        layout = wibox.layout.stack,
        {
          widget = wibox.widget.textbox,
          markup = "<b>Tasks</b>",
          font = beautiful.fonts:choose("normal", 18),
          valign = "center",
          align = "left"
        },
        {
          widget = wibox.container.place,
          valign = "center",
          halign = "center",
          -- TODO: Make it be a real search input, for now, just template
          self:search_input()
        }
      }
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_3,
      forced_height = dpi(1),
    }
  }
end

return widget(Header)