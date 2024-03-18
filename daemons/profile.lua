--==================================================================
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- https://github.com/alphatechnolog
-- https://github.com/alphatechnolog/awesomewm-config.git
--==================================================================

local aspawn = require "awful.spawn"
local gtable = require "gears.table"
local gobject = require "gears.object"
local lgeneral = require "lib.general"
local lfs_simple = require "lib.fs.simple"

local profile = {}
local instance = nil

function profile:fetch_pfp()
  local pfp = os.getenv "HOME" .. "/.config/awesome/assets/default-pfp.png"
  for _, filename in ipairs { ".face.png", ".face.jpg" } do
    local file = lfs_simple:create_file_instance(filename)
    if file:exists() then
      pfp = filename
    end
  end

  return pfp
end

function profile:whoami(callback)
  aspawn.easy_async("whoami", function(stdout)
    if callback then
      callback(lgeneral:string_trim(stdout))
    end
  end)
end

local function new()
  local ret = gobject {}
  gtable.crush(ret, profile, true)

  return ret
end

if not instance then
  instance = new()
end

return instance
