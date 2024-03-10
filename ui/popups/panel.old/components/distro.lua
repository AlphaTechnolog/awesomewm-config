local wibox = require "wibox"
local Widget = require "ui.guards.widget"
local general = require "lib.general"
local gfs = require "gears.filesystem"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local assets = gfs.get_configuration_dir() .. "/assets/"

local distro = {}

function distro:constructor()
  self._private.image = assets .. "/distro.svg"
end

function distro:render()
  return wibox.widget {
    widget = wibox.widget.imagebox,
    valign = 'center',
    halign = 'center',
    forced_width = dpi(20),
    forced_height = dpi(20),
    clip_shape = general:srounded(dpi(4)),
    image = self._private.image
  }
end

return Widget(distro)
