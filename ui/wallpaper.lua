--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

local awful = require "awful"
local wibox = require "wibox"
local lgeneral = require "lib.general"
local beautiful = require "beautiful"

local capi = { screen = screen }

capi.screen.connect_signal("request::wallpaper", function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      fg = beautiful.colors.foreground,
      wallpaper_config.mode == "color" and {
        widget = wibox.container.background,
        bg = wallpaper_config.color,
      } or wallpaper_config.mode == "tiled" and {
        widget = wibox.container.tile,
        tiled = true,
        valign = "top",
        halign = "left",
        horizontal_spacing = 0,
        vertical_spacing = 0,
        {
          widget = wibox.widget.imagebox,
          image = wallpaper_config.path,
          resize = false,
        },
      } or {
        widget = wibox.widget.imagebox,
        image = wallpaper_config.path,
        valign = "center",
        halign = "center",
        horizontal_fit_policy = "fit",
        vertical_fit_policy = "fit",
      },
    },
  }
end)
