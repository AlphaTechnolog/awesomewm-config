local wibox = require "wibox"
local awful = require "awful"
local gtable = require "gears.table"
local gobject = require "gears.object"
local gtimer = require "gears.timer"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local BarWindow = { mt = {}, _private = {} }
local setmetatable = setmetatable

local Distro = require "ui.popups.panel.components.distro"
local Tagslist = require "ui.popups.panel.components.tagslist"
local SettingsToggler = require "ui.popups.panel.components.settings_toggler"
local NotificationToggler = require "ui.popups.panel.components.notifications_toggler"
local Clock = require "ui.popups.panel.components.clock"
local Poweroff = require "ui.popups.panel.components.poweroff"

local function make_window(self)
  local s = self._private.s

  if not s then
    error "cannot fetch the screen from the panel window"
  end

  local WIDTH = dpi(40)

  local panel = awful.popup {
    type = "dock",
    x = s.geometry.x,
    y = s.geometry.y,
    minimum_width = WIDTH,
    minimum_height = s.geometry.height,
    visible = false,
    ontop = false,
    widget = wibox.widget {
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      {
        layout = wibox.layout.align.vertical,
        {
          widget = wibox.container.margin,
          top = dpi(8),
          {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(10),
            Distro():render(),
            Tagslist(s):render(),
          },
        },
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(6),
          SettingsToggler():render(),
          NotificationToggler():render(),
          Clock():render(),
          Poweroff():render(),
        },
      }
    },
  }

  panel:struts {
    left = WIDTH,
  }

  function panel:toggle()
    gtimer.delayed_call(function()
      if self.visible then
        self:hide()
      else
        self:show()
      end
    end)
  end

  function panel:show()
    self.visible = true
  end

  function panel:hide()
    self.visible = false
  end

  if not self._private.panels then
    self._private.panels = {}
  end

  self._private.panel = panel
  s.panel = panel
end

function BarWindow:render()
  local popup = self._private.panel

  if not popup then
    error("cannot get the created popup window")
  end

  popup:toggle()
end

local function new(s)
  local ret = gobject {}
  gtable.crush(ret, BarWindow, true)

  ret._private.s = s

  make_window(ret)

  return ret
end

function BarWindow.mt:__call(...)
  return new(...)
end

return setmetatable(BarWindow, BarWindow.mt)
