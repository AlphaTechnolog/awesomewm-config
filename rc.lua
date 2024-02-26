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

---@diagnostic disable: lowercase-global
---@diagnostic disable: param-type-mismatch

--[[
- ░▀█▀░█▄█░█▀█░█▀█░█▀▄░▀█▀░█▀▀
- ░░█░░█░█░█▀▀░█░█░█▀▄░░█░░▀▀█
- ░▀▀▀░▀░▀░▀░░░▀▀▀░▀░▀░░▀░░▀▀▀
-- ]]

pcall(require, "luarocks.loader")

local beautiful = require "beautiful"
local gfs = require "gears.filesystem"
local gtimer = require "gears.timer"
local collectgarbage = collectgarbage

--[[
- ░▀█▀░█▀█░▀█▀░▀█▀░▀█▀░█▀█░█░░░▀█▀░▀▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█
- ░░█░░█░█░░█░░░█░░░█░░█▀█░█░░░░█░░▄▀░░█▀█░░█░░░█░░█░█░█░█
- ░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀
--]]

beautiful.init(gfs.get_configuration_dir() .. "theme.lua")

--[[
- ░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░█▀▀
- ░█░█░█░█░█░█░█░█░█░░░█▀▀░▀▀█
- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀
--]]

require "awful.autofocus"
require "awful.hotkeys_popup.keys"
require "user"
require "core"
require "ui"

--[[
- ░█▀█░█▀█░▀█▀░▀█▀░█▄█░▀█▀░█▀▀░█▀█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
- ░█░█░█▀▀░░█░░░█░░█░█░░█░░▀▀█░█▀█░░█░░░█░░█░█░█░█░▀▀█
- ░▀▀▀░▀░░░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀
--]]

-- these optimisations ensures a high performance
-- and a low memory usage (specially on low-end devices)

local function optimise()
  collectgarbage("setpause", 110)
  collectgarbage("setstepmul", 1000)

  gtimer {
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
      collectgarbage "collect"
    end,
  }
end

if want_optimisation then
  optimise()
end

--[[
- ░█░█░▀█▀░▀█▀░█░░░█▀▀
- ░█░█░░█░░░█░░█░░░▀▀█
- ░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀
--]]

awesome = awesome
client = client
mouse = mouse
mousegrabber = mousegrabber
root = root
screen = screen
selection = selection
tag = tag
