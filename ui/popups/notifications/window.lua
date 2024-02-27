local awful = require("awful")
local wibox = require("wibox")
local gtimer = require("gears.timer")
local animation = require("lib.animation")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local oop = require("lib.oop")

local Content = require("ui.popups.notifications.content")

local capi = { debugging = debugging }
local NotificationsWindow = {}

function NotificationsWindow:handle_args(s)
  self._private.s = s
end

function NotificationsWindow:make_window()
  local s = self._private.s

  if not s then
    error("[notifications.window]: invalid screen value")
  end

  local WIDTH = dpi(340)

  local PanelPositions = {
    SHOWN = "Shown",
    HIDDEN = "Hidden",
  }

  local positions = {
    [PanelPositions.SHOWN] = {
      x = s.geometry.width - WIDTH,
      y = s.geometry.y,
    },
    [PanelPositions.HIDDEN] = {
      x = s.geometry.width,
      y = s.geometry.y,
    }
  }

  function positions:apply(panel, key)
    panel.x = self[key].x
    panel.y = self[key].y
  end

  local panel = awful.popup {
    type = "dock",
    minimum_width = WIDTH,
    minimum_height = s.geometry.height,
    visible = false,
    ontop = true,
    widget = Content():render(),
  }

  positions:apply(panel, PanelPositions.HIDDEN)

  local PanelStates = {
    SHOWING = "Showing",
    HIDDING = "Hidding",
    IDLE = "Idle",
  }

  panel.state = PanelStates.IDLE

  panel.movement_animation = animation:new {
    duration = 0.55,
    easing = animation.easing.inOutExpo,
    pos = positions[PanelPositions.HIDDEN],
    update = function (_, pos)
      panel.x = pos.x
      panel.y = pos.y
    end,
    signals = {
      ["ended"] = function ()
        if panel.state == PanelStates.HIDDING then
          panel.visible = false
        end

        -- indicate toggle() that the animation has ended
        -- so it can change the panel state again if requested
        panel.state = PanelStates.IDLE
      end
    }
  }

  function panel.movement_animation:switch_pos(pos_key)
    self:set { target = positions[pos_key] }
  end

  function panel:hide()
    self.state = PanelStates.HIDDING
    self.movement_animation:switch_pos(PanelPositions.HIDDEN)
  end

  function panel:show()
    self.visible = true
    self.state = PanelStates.SHOWING
    self.movement_animation:switch_pos(PanelPositions.SHOWN)
  end

  function panel:toggle()
    gtimer.delayed_call(function ()
      if self.visible and self.state == PanelStates.IDLE then
        self:hide()
      elseif self.state == PanelStates.IDLE then
        self:show()
      end
    end)
  end

  self._private.panels[s] = panel
  s.notifications_panel = panel

  if capi.debugging.popups.notifications then
    print("calling toggle")
    s.notifications_panel:toggle()
  end
end

function NotificationsWindow:constructor()
  self._private.panels = {}
  self:make_window()
end

return oop(NotificationsWindow)
