--==================================================================
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- https://github.com/alphatechnolog
-- https://github.com/alphatechnolog/awesomewm-config.git
--==================================================================

local gtable = require "gears.table"

local simple_fs = {}
local File = { mt = {}, _private = {} }
local setmetatable = setmetatable

File = setmetatable(File, File.mt)

local function get_instance(self)
  return io.open(self._private.filename, "r")
end

function File:exists()
  local f = get_instance(self)
  if f ~= nil then
    io.close(f)
  end

  return f ~= nil
end

function File:write(content)
  local f = io.open(self._private.filename, "w")

  if f == nil then
    error(self._private.filename .. ": no such file or directory")
  end

  print("writing into " .. self._private.filename .. " -> " .. tostring(content))

  f:write(content)
  f:close()
end

function File:create()
  os.execute("touch " .. self._private.filename)
end

function File:read()
  local f = get_instance(self)
  if f == nil then
    error(self._private.filename .. ": no such file or directory")
  end

  local content = f:read "*a"

  f:close()

  return content
end

function File.mt:__call(filename)
  local ret = {}
  gtable.crush(ret, File, true)

  ret._private.filename = filename

  return ret
end

function simple_fs:create_file_instance(filename)
  return File(filename)
end

return simple_fs
