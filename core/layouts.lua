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

local alayout = require "awful.layout"

local capi = { tag = tag }

capi.tag.connect_signal("request::default_layouts", function()
  alayout.append_default_layouts { alayout.suit.tile.right }
end)
