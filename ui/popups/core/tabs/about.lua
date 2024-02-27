local wibox = require "wibox"
local general = require "lib.general"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local oop = require "lib.oop"

local about = {}

function about:metadata()
  return {
    misc = {
      name = "About",
      icon = "",
    },
    sidebar = {
      position = "bottom"
    }
  }
end

function about:render()
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
        markup = general:tint_markup(beautiful.colors.blue, ''),
        valign = 'center',
        align = 'center',
      },
      {
        widget = wibox.widget.textbox,
        font = beautiful.fonts:choose("normal", 24),
        markup = "<b>About the system</b>",
        valign = "center",
        align = "center"
      }
    }
  }
end

return oop(about)
