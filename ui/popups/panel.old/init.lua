local awful = require "awful"

local BarWindow = require "ui.popups.panel.window"

local capi = {
  screen = screen,
}

capi.screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
  BarWindow(s):render()
end)
