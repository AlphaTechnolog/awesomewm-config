--[[
- ░█░█░█▀█░█▀▀░█▀█░█▀▄░█▀█░█▀▀░█░█░▀█▀░░░█▀▀░█░█░█▀▀░█░░░█░░
- ░█▀▄░█░█░█░█░█▀█░█▀▄░█▀█░▀▀█░█▀█░░█░░░░▀▀█░█▀█░█▀▀░█░░░█░░
- ░▀░▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀
- Copyleft © 2023 Gabriel Guerra
- Licensed under the MIT license
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/kogarashi-shell
--]]

local wibox = require "wibox"
local naughty = require "naughty"
local oop = require "lib.oop"
local gtimer = require "gears.timer"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local NotificationContent = require "ui.modules.notifications.content"

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

function Notifications:make_notification(n)
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