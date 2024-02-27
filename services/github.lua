local awful = require "awful"
local gtimer = require "gears.timer"
local tbl = require "lib.tbl"
local json = require "lib.json"
local fs = require "lib.fs.simple"
local Net = require "lib.net"
local oop = require "lib.oop"

local capi = {
  services = services,
}

local GitHubService = {}

function GitHubService:constructor()
  self._private.config = capi.services.github
  self:validate()
end

function GitHubService:dispatch_error(err)
  error("GitHubService: " .. err)
end

function GitHubService:validate()
  if not self._private.config then
    self:dispatch_error "cannot get the service configuration"
  end

  if self._private.config.enabled and self._private.config.api_key == nil then
    print "GitHubService: warning: service is enabled but there is no available api key"
  end
end

function GitHubService:status()
  return self._private.config.enabled and self._private.config.api_key ~= nil
end

-- TODO: Sanitize api-key notifications + consume from UI
local function notifications(self)
  local url = "https://api.github.com/notifications"

  ---@diagnostic disable-next-line: redefined-local
  Net(url):github_fetch(self._private.config.api_key, function(notifications)
    if notifications == nil then
      self:emit_signal("notifications::error", "cannot decode notifications")
    end

    self:emit_signal("notifications::data", notifications)
  end)
end

local function received_events(self)
  -- preparing filesystem if needed
  local cache_dir = os.getenv "HOME" .. "/.cache/kogarashi-shell/github"
  local pfp_folders = cache_dir .. "/cached_photos"

  os.execute("mkdir -p " .. cache_dir)
  os.execute("mkdir -p " .. pfp_folders)

  -- fetching users received events.
  local url = ("https://api.github.com/users/%s/received_events"):format(self._private.config.username)

  ---@diagnostic disable-next-line: redefined-local
  Net(url):github_fetch(self._private.config.api_key, function(received_events)
    if received_events == nil then
      self:emit_signal("received_events::error", "cannot decode received_events")
    end

    -- filtering by supported events
    received_events = tbl.filter(received_events, pairs, function(_, x)
      return x.type == "ForkEvent" or x.type == "WatchEvent"
    end)

    -- initial data emission
    self:emit_signal("received_events::data", received_events, pfp_folders)

    -- fetching profile photos if needed
    for _, event in pairs(received_events) do
      local profile_photo_path = pfp_folders .. "/pfp_" .. event.actor.id .. ".png"
      local profile_photo = fs:create_file_instance(profile_photo_path)

      if not profile_photo:exists() then
        local download_cmd = ("bash -c 'wget %s -O %s'"):format(event.actor.avatar_url, profile_photo_path)
        awful.spawn.easy_async(download_cmd, function()
          -- reloading the UI when the photo is done downloading
          self:emit_signal("received_events::data", received_events, pfp_folders)
        end)
      end
    end
  end)
end

function GitHubService:start_monitoring()
  gtimer {
    timeout = 60 * 60 * 1, -- one hour
    call_now = true,
    autostart = true,
    single_shot = false,
    callback = function()
      notifications(self)
      received_events(self)
    end,
  }
end

return oop(GitHubService)
