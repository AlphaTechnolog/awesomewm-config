local wibox = require "wibox"
local general = require "lib.general"
local oop = require "lib.oop"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local youtube = {}

function youtube:metadata()
  return {
    misc = {
      name = "Youtube",
      icon = ""
    }
  }
end

function youtube:render()
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
        markup = general:tint_markup(beautiful.colors.red, ''),
        valign = 'center',
        align = 'center',
      },
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(2),
        {
          widget = wibox.widget.textbox,
          font = beautiful.fonts:choose("normal", 24),
          markup = general:tint_markup(beautiful.colors.white, "<b>" .. general:tint_markup(beautiful.colors.red, "Youtube") .. " Manager</b>"),
          valign = "center",
          align = "center"
        },
        {
          widget = wibox.widget.textbox,
          font = beautiful.fonts:choose("normal", 14),
          markup = general:tint_markup(beautiful.colors.light_black_4, "<b>Coming soon...</b>"),
          valign = "center",
          align = "center"
        },
      }
    }
  }
end

return oop(youtube)
