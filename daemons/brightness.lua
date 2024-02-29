--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

-- thanks to rxyhn

local aspawn = require "awful.spawn"
local gobject = require "gears.object"
local gtable = require "gears.table"
local tonumber = tonumber

local brightness = {}
local instance = nil

function brightness:increase_brightness(step)
  aspawn("brightnessctl set +" .. step .. "%", false)
end

function brightness:decrease_brightness(step)
  aspawn("brightnessctl set " .. step .. "%-", false)
end

function brightness:set_brightness(new_value)
  aspawn("brightnessctl set " .. new_value .. "%", false)
end

local function get_brightness(self)
  aspawn.with_line_callback("brightnessctl g", {
    stdout = function(value)
      aspawn.with_line_callback("brightnessctl m", {
        stdout = function(max)
          local percentage = tonumber(value) / tonumber(max) * 100
          self:emit_signal("update", percentage)
        end,
      })
    end,
  })
end

local function new()
  local ret = gobject {}
  gtable.crush(ret, brightness, true)

  get_brightness(ret)

  aspawn.easy_async_with_shell(
    "ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill",
    function()
      -- Update brightness status with each line printed
      aspawn.with_line_callback(
        'bash -c "while (inotifywait -e modify /sys/class/backlight/?**/brightness -qq) do echo; done"',
        {
          stdout = function(_)
            get_brightness(ret)
          end,
        }
      )
    end
  )

  return ret
end

if not instance then
  instance = new()
end
return instance
