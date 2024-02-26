local wibox = require "wibox"
local oop = require "lib.oop"

local settings = {}

function settings:metadata()
  return {
    misc = {
      name = "Settings",
      icon = "",
    },
    sidebar = {
      position = "bottom"
    }
  }
end

function settings:render()
  return wibox.widget {
    widget = wibox.widget.textbox,
    markup = 'settings',
    valign = 'center',
    align = 'center',
  }
end

return oop(settings)