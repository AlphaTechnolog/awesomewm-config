--==================================================================
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- https://github.com/alphatechnolog
-- https://github.com/alphatechnolog/awesomewm-config.git
--==================================================================

local wibox = require "wibox"
local awful = require "awful"
local gshape = require "gears.shape"
local gtimer = require "gears.timer"
local general = require "lib.general"
local animation = require "lib.animation"
local color = require "lib.color"
local string = require "lib.string"
local oop = require "lib.oop"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local content = {}

local tabs = require "ui.popups.core.tabs"

function content:constructor()
  self:prepare_tabs_uuid()
  self:make_widget()
  gtimer.delayed_call(function ()
    self:emit_signal("tabs::goto", tabs[1])
  end)
end

function content:close_button()
  local btn = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.red,
    shape = gshape.circle,
    forced_width = dpi(11),
    forced_height = dpi(11),
    valign = 'center',
    halign = 'center',
  }

  btn.hover_animation = animation:new {
    duration = 1,
    easing = animation.easing.outExpo,
    pos = color.hex_to_rgba(beautiful.colors.red),
    update = function (_, pos)
      btn.bg = color.rgba_to_hex(pos)
    end
  }

  function btn:set_color(new_color)
    self.hover_animation:set {
      target = color.hex_to_rgba(new_color)
    }
  end

  btn:connect_signal("mouse::enter", function (self)
    self:set_color(beautiful.colors.light_red_15)
  end)

  btn:connect_signal("mouse::leave", function (self)
    self:set_color(beautiful.colors.red)
  end)

  btn:add_button(awful.button({}, 1, function ()
    local s = awful.screen.focused()
    local window = s.core_window
    if not window then
      error("[internal] cannot get s.focused().core_window!")
    end

    -- reset color and then toggling the window
    btn:set_color(beautiful.colors.red)
    window:toggle()
  end))

  return btn
end

function content:make_list_entry(tab)
  local btn = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_2,
    shape = general:srounded(dpi(7)),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(7),
        left = dpi(7),
        bottom = dpi(7),
        right = dpi(128)
      },
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(6),
        {
          widget = wibox.widget.textbox,
          markup = tab.metadata.misc.icon,
          font = beautiful.fonts:choose("icons", 14),
          valign = 'center',
        },
        {
          widget = wibox.widget.textbox,
          markup = tab.metadata.misc.name,
          valign = 'center',
        }
      }
    }
  }

  btn.selected = false

  btn.animation = animation:new {
    duration = 1,
    easing = animation.easing.outExpo,
    pos = color.hex_to_rgba(beautiful.colors.light_background_2),
    update = function (_, pos)
      btn.bg = color.rgba_to_hex(pos)
    end
  }

  function btn:set_color(new_color)
    if not self.selected then
      self.animation:set { target = color.hex_to_rgba(new_color) }
    end
  end

  self:connect_signal("tabs::goto", function (_, selected_tab)
    if selected_tab.metadata._id == tab.metadata._id then
      btn.selected = true
      btn.animation:set {
        target = color.hex_to_rgba(beautiful.colors.light_background_8)
      }
    else
      btn.selected = false
      btn.animation:set {
        target = color.hex_to_rgba(beautiful.colors.light_background_2)
      }
    end
  end)

  btn:connect_signal("mouse::enter", function (self)
    self:set_color(beautiful.colors.light_background_8)
  end)

  btn:connect_signal("mouse::leave", function (self)
    self:set_color(beautiful.colors.light_background_2)
  end)

  local tmpself = self

  btn:add_button(awful.button({}, 1, function ()
    tmpself:emit_signal("tabs::goto", tab)
  end))

  return btn
end

local function tabs_renderer(self, position)
  local layout = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(6)
  }

  for _, tab in ipairs(tabs) do
    local metadata = tab.metadata
    metadata.sidebar = metadata.sidebar or {}
    metadata.sidebar.position = metadata.sidebar.position or "top"
    if metadata.sidebar.position == position then
      layout:add(self:make_list_entry(tab))
    end
  end

  return layout
end

function content:normal_tabs()
  return tabs_renderer(self, "top")
end

function content:bottom_tabs()
  return tabs_renderer(self, "bottom")
end

function content:content_layout()
  local layout = wibox.layout.flex.horizontal()

  local States = {
    TURNING_ON = "turning_on",
    TURNING_OFF = "turning_off",
    IDLE = "idle"
  }

  layout.current_state = States.IDLE

  local tmp_new_widget = nil
  
  layout.transition = animation:new {
    duration = 0.15,
    easing = animation.easing.linear,
    pos = 1,
    update = function (_, pos)
      layout.opacity = pos
    end,
    signals = {
      ["ended"] = function ()
        if layout.current_state == States.TURNING_OFF and tmp_new_widget ~= nil then
          layout.current_state = States.TURNING_ON
          layout:reset()
          layout:add(tmp_new_widget)
          tmp_new_widget = nil

          -- a little bit of delay between animations
          gtimer {
            timeout = 0.205,
            call_now = false,
            autostart = true,
            single_shot = true,
            callback = function ()
              layout.transition:set { target = 1 }
            end
          }

          return
        end

        layout.current_state = States.IDLE
      end
    }
  }

  function layout:switch_widget(w)
    tmp_new_widget = w
    self.current_state = States.TURNING_OFF
    self.transition:set { target = 0 }
  end

  self:connect_signal("tabs::goto", function (_, tab)
    layout:switch_widget(tab.instance:render())
  end)

  return layout
end

function content:make_widget()
  self._private.widget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_2,
      {
        layout = wibox.layout.align.vertical,
        {
          widget = wibox.container.margin,
          margins = {
            left = dpi(14),
            top = dpi(13),
          },
          {
            widget = wibox.container.place,
            valign = 'center',
            halign = 'left',
            self:close_button(),
          }
        },
        {
          widget = wibox.container.margin,
          margins = dpi(10),
          {
            layout = wibox.layout.align.vertical,
            self:normal_tabs()
          }
        },
        {
          widget = wibox.container.margin,
          margins = {
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10),
          },
          {
            layout = wibox.layout.align.vertical,
            self:bottom_tabs()
          }
        }
      }
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      self:content_layout()
    }
  }

  return self._private.widget
end

function content:prepare_tabs_uuid()
  for _, tab in ipairs(tabs) do
    tab.metadata._id = string.random_uuid()
  end
end

function content:render()
  return self._private.widget
end

return oop(content)
