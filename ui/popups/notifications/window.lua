local wibox = require "wibox"
local awful = require "awful"
local gobject = require "gears.object"
local gtable = require "gears.table"
local gtimer = require "gears.timer"
local general = require "lib.general"
local animation = require "lib.animation"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local capi = {
  debugging = debugging,
  side_popups_struts = side_popups_struts,
}

local notifications = { mt = {}, _private = {} }
local setmetatable = setmetatable

local Notifications = require "ui.popups.notifications.components.notifications"
local GitHub = require "ui.popups.notifications.components.github"

function notifications:get_widget()
  return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.background,
    fg = beautiful.colors.foreground,
    {
      layout = wibox.layout.align.vertical,
      nil,
      Notifications():render(),
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(6),
        },
        GitHub():render(),
      },
    },
  }
end

local function make_window(self)
  local s = self._private.s

  if not s then
    error "cannot fetch the screen from the notifications panel"
  end

  local WIDTH = dpi(340)

  local positions = {
    shown = {
      x = s.geometry.x + (s.geometry.width - WIDTH - beautiful.useless_gap * 2),
      y = s.geometry.y + s.panel.minimum_height + beautiful.useless_gap * 4,
    },
    hidden = {
      x = s.geometry.x + s.geometry.width + beautiful.useless_gap * 2,
      y = s.geometry.y + s.panel.minimum_height + beautiful.useless_gap * 4,
    },
  }

  local panel = awful.popup {
    type = "desktop",
    x = positions.hidden.x,
    y = positions.hidden.y,
    ontop = true,
    visible = false,
    minimum_width = WIDTH,
    minimum_height = s.geometry.height - s.panel.minimum_height - beautiful.useless_gap * 6,
    widget = self:get_widget(),
  }

  local PanelState = {
    SHOWING = "Showing",
    HIDDING = "Hidding",
    IDLE = "Idle",
  }

  -- not set
  panel.state = PanelState.IDLE

  function panel:toggle()
    gtimer.delayed_call(function()
      if self.visible and self.state == PanelState.IDLE then
        self:hide()
      elseif self.state == PanelState.IDLE then
        self:show()
      end
    end)
  end

  panel.animation = animation:new {
    duration = 0.55,
    easing = animation.easing.inOutExpo,
    pos = positions.hidden,
    update = function(_, pos)
      if pos.x ~= nil then
        panel.x = pos.x
      end

      if pos.y ~= nil then
        panel.y = pos.y
      end
    end,
    signals = {
      ["ended"] = function()
        if panel.state == PanelState.HIDDING then
          panel.visible = false
        end

        -- reset panel state so toggle() can operate.
        panel.state = PanelState.IDLE
      end,
    },
  }

  function panel:show()
    self.visible = true
    self.state = PanelState.SHOWING
    self.animation:set(positions.shown)
  end

  function panel:hide()
    self.state = PanelState.HIDDING
    self.animation:set(positions.hidden)
  end

  self._private.panel = panel
  s.notifications_panel = panel

  if capi.debugging.popups.notifications then
    gtimer.delayed_call(function()
      self._private.panel:toggle()
    end)
  end
end

local function new(s)
  local ret = gobject {}
  gtable.crush(ret, notifications, true)

  ret._private.s = s

  make_window(ret)

  return ret
end

function notifications.mt:__call(...)
  return new(...)
end

return setmetatable(notifications, notifications.mt)
