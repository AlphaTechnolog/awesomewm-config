-- TODO: Add PRS and Issues to the github notifications
-- supported modules.

local wibox = require "wibox"
local general = require "lib.general"
local libdate = require "lib.date"
local gshape = require "gears.shape"
local widget = require "ui.guards.widget"
local GitHubService = require "services.github"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local github = {}

function github:constructor()
  self._private.service = GitHubService()
  self._private.content = wibox.layout.flex.horizontal()
  self._private.content.forced_height = dpi(285)

  function self._private.content:switch_widget(w)
    self:reset()
    self:add(w)
  end
end

function github:make_widget()
  self._private.widget = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_2,
    shape = general:prounded(dpi(12), true, false, false, false),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(8),
      },
      self._private.content,
    },
  }
end

function github:alert(txt)
  return wibox.widget {
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
    {
      layout = wibox.layout.fixed.vertical,
      {
        widget = wibox.container.margin,
        right = dpi(20),
        {
          widget = wibox.widget.textbox,
          font = beautiful.fonts:choose("nerdfonts", 100),
          markup = general:tint_markup(beautiful.colors.foreground, ""),
          valign = "center",
          align = "center",
        },
      },
      {
        widget = wibox.container.scroll.horizontal,
        max_size = 290,
        speed = 60,
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        {
          widget = wibox.widget.textbox,
          markup = txt,
          font = beautiful.fonts:choose("normal", 14),
          valign = "center",
          align = "center",
        },
      },
    },
  }
end

function github:fetching()
  return self:alert("Fetching content to display" .. general:tint_markup(beautiful.colors.light_background_12, "..."))
end

function github:no_items()
  local no_items = general:tint_markup(beautiful.colors.accent, "no items")
  return self:alert(("There are %s here"):format(no_items))
end

function github:not_enabled()
  local github_notification = general:tint_markup(beautiful.colors.accent, "GitHub Service")
  return self:alert(("Enable the %s to see content here."):format(github_notification))
end

function github:make_notifs_layout()
  self._private.notifs_layout = wibox.layout.fixed.vertical()
  self._private.notifs_layout.spacing = dpi(8)

  function self._private.notifs_layout:create(...)
    self:insert(1, ...)
  end

  general:make_widget_scrollable(self._private.notifs_layout)
end

function github:event_card(event, pfp_path)
  return wibox.widget {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.flex.vertical,
      {
        widget = wibox.widget.imagebox,
        valign = "center",
        halign = "center",
        forced_width = dpi(32),
        forced_height = dpi(32),
        clip_shape = gshape.squircle,
        image = pfp_path .. "/pfp_" .. event.actor.id .. ".png",
      },
    },
    {
      widget = wibox.container.margin,
      margins = {
        left = dpi(6),
        right = dpi(6),
      },
      {
        layout = wibox.layout.fixed.vertical,
        {
          widget = wibox.container.margin,
          left = dpi(2), -- ?
          {
            widget = wibox.container.scroll.horizontal,
            max_size = 60,
            speed = 60,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            {
              widget = wibox.widget.textbox,
              valign = "center",
              align = "left",
              markup = ("<b>%s</b> %s <b>%s</b>"):format(
                event.actor.login,
                event.type == "WatchEvent" and "starred" or "forked",
                event.repo.url:gsub("https://api.github.com/repos/", "")
              ),
            },
          },
        },
        {
          layout = wibox.layout.align.horizontal,
          {
            widget = wibox.widget.textbox,
            markup = "",
            font = beautiful.fonts:choose("icons", dpi(17)),
            valign = "center",
            align = "left",
          },
          {
            widget = wibox.container.margin,
            margins = {
              left = dpi(2),
            },
            {
              widget = wibox.widget.textbox,
              valign = "center",
              align = "left",
              markup = libdate:to_time_ago(os.difftime(os.time(os.date "!*t"), libdate:parse_date(event.created_at))),
            },
          },
        },
      },
    },
  }
end

local function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

function github:hydrate_received_events(opts)
  self._private.notifs_layout:reset()

  local received_events = opts.received_events
  local pfp_path = opts.pfp_path

  if #received_events == 0 then
    self._private.content:switch_widget(self:no_items())
    return
  end

  for _, event in pairs(received_events) do
    self._private.notifs_layout:create(self:event_card(event, pfp_path))
  end
end

function github:fetch_data()
  if not self._private.notifs_layout then
    self:make_notifs_layout()
  end

  self._private.service:start_monitoring()
  self._private.content:switch_widget(self:fetching())

  self._private.service:connect_signal("received_events::data", function(_, received_events, pfp_path)
    self._private.content:switch_widget(wibox.widget {
      widget = wibox.container.margin,
      margins = {
        left = dpi(12),
        right = dpi(12),
      },
      self._private.notifs_layout,
    })

    self:hydrate_received_events {
      received_events = received_events,
      pfp_path = pfp_path,
    }
  end)
end

function github:initial_content()
  if self._private.service:status() == false then
    self._private.content:switch_widget(self:not_enabled())
    return
  end

  self:fetch_data()
end

function github:render()
  if not self._private.widget then
    self:make_widget()
  end

  self:initial_content()

  return self._private.widget
end

return widget(github)
