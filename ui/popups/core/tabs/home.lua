local wibox = require "wibox"
local general = require "lib.general"
local oop = require "lib.oop"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local home = {}

function home:metadata()
  return {
    misc = {
      name = "Home",
      icon = ""
    }
  }
end

function home:render()
  return wibox.widget {
    widget = wibox.container.place,
    valign = 'center',
    halign = 'center',
    {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(0),
      {
        widget = wibox.widget.textbox,
        font = beautiful.fonts:choose("icons", 128),
        markup = general:tint_markup(beautiful.colors.light_background_15, ''),
        valign = 'center',
        align = 'center',
      },
      {
        widget = wibox.widget.textbox,
        font = beautiful.fonts:choose("normal", 24),
        markup = "<b>Home</b>",
        valign = "center",
        align = "center"
      }
    }
  }
end

return oop(home)