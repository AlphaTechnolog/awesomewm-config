--==================================================================
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- https://github.com/alphatechnolog
-- https://github.com/alphatechnolog/awesomewm-config.git
--==================================================================

---@diagnostic disable: lowercase-global

local gfs = require "gears.filesystem"
local general = require "lib.general"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

--[[
- ░█░█░█▀▀░█▀▀░█▀▄░░░░░█░░░▀█▀░█░█░█▀▀░█▀▀
- ░█░█░▀▀█░█▀▀░█▀▄░▄▄▄░█░░░░█░░█▀▄░█▀▀░▀▀█
- ░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀
--]]

terminal = "bash -c 'WINIT_X11_SCALE_FACTOR=1.0 alacritty'"
launcher = "rofi -show drun"
editor = os.getenv "EDITOR" or "nvim"
editor_cmd = terminal .. " -e " .. editor
visual_editor = "code"
modkey = "Mod4"
tags_num = 6
bar_height = dpi(40)

--[[
- ░█▀▄░█▀▀░█░█░█▀█░█░█░▀█▀░█▀█░█▀▄
- ░█▀▄░█▀▀░█▀█░█▀█░▀▄▀░░█░░█░█░█▀▄
- ░▀▀░░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀
--]]

enable_notification_sounds = true -- enable sounds for notifications
want_optimisation = true -- enable garbagecollector optimisations

--- autostart these commands when initialising AwesomeWM, e.g:
--- ```lua
--- autostart = {
---   "pgrep -x picom || picom -b"
--- }
--- ```
local autostart_filename = os.getenv "HOME" .. "/.autostart.sh"

autostart = {
  "pgrep -x picom || picom -b",
  "test -f " .. autostart_filename .. " && bash " .. autostart_filename,
}

--[[
- ░█▀▀░█▀▀░█▀▄░█░█░▀█▀░█▀▀░█▀▀░█▀▀
- ░▀▀█░█▀▀░█▀▄░▀▄▀░░█░░█░░░█▀▀░▀▀█
- ░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀
--]]

services = {
  -- enable github notifications in the notifications panel.
  github = {
    enabled = true,
    username = "AlphaTechnolog",
    api_key = general:quick_read(os.getenv "HOME" .. "/.awesomewm-user-config/github-api-key"),
  },
}

--[[
- ░█░█░█▀█░█░░░█░░░█▀█░█▀█░█▀█░█▀▀░█▀▄
- ░█▄█░█▀█░█░░░█░░░█▀▀░█▀█░█▀▀░█▀▀░█▀▄
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀░░░▀▀▀░▀░▀
--]]

--- sample wallpaper configuration for tiled image wallpaper ==
--- wallpaper_config = {
---   mode = "tiled",
---   path = gfs.get_configuration_dir() .. "assets/tile.png",
--- }

--- sample wallpaper configuration for stretched image wallpaper
wallpaper_config = {
  mode = "image",
  path = gfs.get_configuration_dir() .. "assets/wallpaper.png",
}

--- sample wallpaper configuration for solid color wallpaper
-- wallpaper_config = {
--   mode = "color",
--   color = beautiful.colors.light_background_8
-- }

--[[
- ░█▀▄░█▀▀░█▀▄░█░█░█▀▀
- ░█░█░█▀▀░█▀▄░█░█░█░█
- ░▀▀░░▀▀▀░▀▀░░▀▀▀░▀▀▀
--]]

-- these are for debugging purposes, don't touch if you want to use this as your daily driver.
-- these just opens the desired popup on startup for making it easier to me to mess with their code
debugging = {
  popups = {
    core = false,
    notifications = false,
  },
}
