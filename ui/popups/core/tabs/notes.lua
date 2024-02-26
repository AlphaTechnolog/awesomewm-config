local wibox = require "wibox"
local oop = require "lib.oop"

local notes = {}

function notes:metadata()
  return {
    misc = {
      name = "Notes",
      icon = ""
    }
  }
end

function notes:render()
  return wibox.widget {
    widget = wibox.widget.textbox,
    markup = 'notes',
    valign = 'center',
    align = 'center',
  }
end

return oop(notes)