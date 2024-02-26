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

local aspawn = require "awful.spawn"

for _, cmd in ipairs(autostart) do
  aspawn.with_shell(cmd)
end
