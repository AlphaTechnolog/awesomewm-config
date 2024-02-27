local awful = require "awful"

local NotificationsWindow = require("ui.popups.notifications.window")

local capi =  { screen = screen }

capi.screen.connect_signal("request::desktop_decoration", function(s)
  NotificationsWindow(s)
end)
