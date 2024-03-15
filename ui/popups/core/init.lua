--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

local awful = require "awful"
local gtimer = require "gears.timer"
local oop = require "lib.oop"
local animation = require "lib.animation"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local Content = require "ui.popups.core.content"

local _core = {}

local capi = {
  debugging = debugging
}

-- enums
local Positions = {
  SHOWN = "shown",
  HIDDEN = "hidden"
}

local Statuses = {
  IDLE = "idle",
  SHOWING = "showing",
  HIDDING = "hidding"
}

function _core:handle_args(s)
  self._private.s = s
end

-- yes, i like using () everywhere ok ( even when not needed :> ).
function _core:constructor()
  local s = self._private.s

  -- basic +, -, * and / for getting the right dimensions and positions
  -- maybe can be simplified af but im that lazy, also it already works lmao
  self._private.dimensions = {
    width = 870,
    height = 680,
  }

  self._private.positions = {
    [Positions.SHOWN] = {
      x = s.geometry.x + ((s.geometry.width - self._private.dimensions.width) / 2),
      y = s.geometry.y + ((s.geometry.height - self._private.dimensions.height) / 2),
    },
    [Positions.HIDDEN] = {
      x = s.geometry.x + ((s.geometry.width - self._private.dimensions.width) / 2),
      y = s.geometry.y + s.geometry.height + self._private.dimensions.height + beautiful.useless_gap * 2,
    }
  }
end

function _core:get_widget()
  local content = Content()
  return content:render()
end

function _core:make_window()
  self._private.s.core_window = awful.popup {
    type = "popup_menu",
    screen = self._private.s,
    visible = false,
    ontop = true,
    x = self._private.positions[Positions.HIDDEN].x,
    y = self._private.positions[Positions.HIDDEN].y,
    minimum_width = self._private.dimensions.width,
    minimum_height = self._private.dimensions.height,
    widget = self:get_widget()
  }

  local window = self._private.s.core_window

  -- default status
  window.current_status = Statuses.IDLE

  window.moving_animation = animation:new {
    duration = 0.75,
    easing = animation.easing.inOutCubic,
    pos = self._private.positions[Positions.HIDDEN],
    update = function (_, pos)
      if pos.x then
        window.x = pos.x
      end
      if pos.y then
        window.y = pos.y
      end
    end,
    signals = {
      ["ended"] = function ()
        if window.current_status == Statuses.HIDDING then
          window.visible = false
        end

        -- restore idle
        window.current_status = Statuses.IDLE
      end
    }
  }
end

function _core:make_bindings()
  local window = self._private.s.core_window
  if not window then
    error("[internal] `Core::make_bindings()`: have you called `Core::make_window()` first?")
  end

  local safe_do = function (self, callback)
    gtimer.delayed_call(function ()
      if self[callback] ~= nil then
        self[callback](self)
      end
    end)
  end

  function window:toggle()
    if self.current_status ~= Statuses.IDLE then
      return
    end

    if self.visible then
      safe_do(self, "hide")
    else
      safe_do(self, "show")
    end
  end

  local positions = self._private.positions

  function window:show()
    self.current_status = Statuses.SHOWING
    self.visible = true
    self.moving_animation:set(positions[Positions.SHOWN])
  end

  function window:hide()
    self.current_status = Statuses.HIDDING
    self.moving_animation:set(positions[Positions.HIDDEN])
  end
end

function _core:debug()
  if capi.debugging.popups.core then
    self._private.s.core_window:toggle()
  end
end

function _core:setup()
  self:make_window()
  self:make_bindings()
  self:debug()
end

local Core = oop(_core)

gtimer.delayed_call(function ()
  awful.screen.connect_for_each_screen(function (s)
    local core = Core(s)
    core:setup()
  end)
end)
