--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

local aspawn = require "awful.spawn"

for _, cmd in ipairs(autostart) do
  aspawn.with_shell(cmd)
end
