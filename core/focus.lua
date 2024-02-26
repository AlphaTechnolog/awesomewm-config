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

local capi = { client = client }

capi.client.connect_signal("mouse::enter", function(c)
  c:activate {
    context = "mouse_enter",
    raise = false,
  }
end)
