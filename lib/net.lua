local awful = require "awful"
local gtimer = require "gears.timer"
local json = require "lib.json"
local oop = require "lib.oop"

local Net = {}

function Net:handle_args(url)
  self._private.url = url
end

function Net:set_url(url)
  self._private.url = url
end

function Net:fetch(callback)
  local script = ([[bash -c 'curl %s']]):format(self._private.url)

  awful.spawn.easy_async(script, function(result)
    gtimer.delayed_call(function()
      callback(json.decode(result))
    end)
  end)
end

function Net:github_fetch(api_key, callback)
  local curl_command = ([[
    curl -L -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer %s" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      %s
  ]]):format(api_key, self._private.url)

  awful.spawn.easy_async(("bash -c '%s'"):format(curl_command), function(result)
    gtimer.delayed_call(function()
      callback(json.decode(result))
    end)
  end)
end

return oop(Net)
