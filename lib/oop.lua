local gtable = require "gears.table"
local gobject = require "gears.object"
local tbl = require "lib.tbl"

local setmetatable = setmetatable

return function(prototype)
  prototype.mt = {}

  if not prototype.constructor then
    prototype.constructor = function(_)
      -- @void
    end
  end

  local function new(...)
    local ret = gobject {}
    gtable.crush(ret, prototype, true)

    ret._private = {}

    if tbl.contains_key("handle_args", prototype) then
      ret:handle_args(...)
    end

    ret:constructor()

    return ret
  end

  function prototype.mt:__call(...)
    return new(...)
  end

  return setmetatable(prototype, prototype.mt)
end
