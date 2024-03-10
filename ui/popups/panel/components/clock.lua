local wibox = require("wibox")
local gtimer = require("gears.timer")
local widget = require("ui.guards.widget")

local Clock = {}

function Clock:constructor()
  self._private.value = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center"
  }
end

function Clock:perform_poll()
  gtimer {
    timeout = 10,
    call_now = true,
    autostart = true,
    single_shot = false,
    callback = function ()
      self._private.value:set_markup_silently(os.date("%I:%M %p"))
    end
  }
end

function Clock:render()
  self:perform_poll()
  return self._private.value
end

return widget(Clock)