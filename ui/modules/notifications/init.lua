--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

local wibox = require "wibox"
local awful = require "awful"
local naughty = require "naughty"
local oop = require "lib.oop"
local gtimer = require "gears.timer"
local gfs = require "gears.filesystem"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local NotificationContent = require "ui.modules.notifications.content"

local capi = { enable_notification_sounds = enable_notification_sounds }
local Notifications = {}

-- making notifications binding
function Notifications:constructor()
  self:subscribe(function (...)
    self:make_notification(...)
  end)
end

function Notifications:subscribe(callback)
  naughty.connect_signal("request::display", function(n)
    if callback then
      gtimer.delayed_call(function ()
        callback(n)
      end)
    end
  end)
end

-- @requires: vorbis
local function play_notif_sound()
  local sound_path = gfs.get_configuration_dir() .. "assets/sounds/notification.ogg"
  awful.spawn("ogg123 " .. sound_path)
end

function Notifications:make_notification(n)
  if capi.enable_notification_sounds then
    play_notif_sound()
  end

  naughty.layout.box {
    notification = n,
    position = "top_middle",
    minimum_width = dpi(300),
    widget_template = {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_1,
      NotificationContent(n):render(),
    }
  }
end

return oop(Notifications)
