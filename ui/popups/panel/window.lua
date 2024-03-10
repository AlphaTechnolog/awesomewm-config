local wibox = require "wibox"
local awful = require "awful"
local gtable = require "gears.table"
local gobject = require "gears.object"
local gtimer = require "gears.timer"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local BarWindow = { mt = {}, _private = {} }
local setmetatable = setmetatable

local Actions = require("ui.popups.panel.components.actions")
local Tagslist = require("ui.popups.panel.components.tagslist")
local Clock = require("ui.popups.panel.components.clock")

local function contained(w)
  return wibox.widget {
    widget = wibox.container.margin,
    left = dpi(12),
    right = dpi(12),
    top = dpi(4),
    bottom = dpi(4),
    w
  }
end

local function get_widget(s)
  return contained(wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.background,
    fg = beautiful.colors.foreground,
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        nil,
        nil,
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(12),
          Actions():render(),
          Clock():render(),
        }
      },
      {
        widget = wibox.container.place,
        valign = "center",
        halign = "center",
        Tagslist(s):render()
      }
    }
  })
end

local function make_window(self)
  local s = self._private.s

  if not s then
    error "cannot fetch the screen from the panel window"
  end

  local HEIGHT = dpi(30)

  local panel = awful.popup {
    type = "dock",
    x = s.geometry.x,
    y = s.geometry.y,
    minimum_height = HEIGHT,
    maximum_height = HEIGHT,
    minimum_width = s.geometry.width,
    maximum_width = s.geometry.width,
    visible = false,
    ontop = false,
    widget = get_widget(s)
  }

  panel:struts {
    top = HEIGHT,
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
