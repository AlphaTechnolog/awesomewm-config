local wibox = require("wibox")
local awful = require("awful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local animation = require("lib.animation")
local color = require("lib.color")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local capi = { client = client }

local function create_button(c, color_key, callback)
  local button = wibox.widget({
    widget = wibox.container.background,
    bg = beautiful.colors[color_key],
    shape = gshape.circle,
    forced_width = dpi(13),
    forced_height = dpi(13),
  })

  button.animation = animation:new {
    duration = 0.25,
    easing = animation.easing.inOutCubic,
    pos = color.hex_to_rgba(beautiful.colors[color_key]),
    update = function (_, pos)
      button.bg = color.rgba_to_hex(pos)
    end
  }

  function button:update_state()
    local color = self.has_focus
      and beautiful.colors[color_key]
      or beautiful.colors.light_black_5

    self.animation:switch_color(color)
  end
  
  function button:update_has_focus()
    self.has_focus = client.focus == c
    self:update_state()
  end

  function button.animation:switch_color(new_color)
    self:set { target = color.hex_to_rgba(new_color) }
  end

  button:connect_signal("mouse::enter", function (self)
    if self.has_focus then
      self.animation:switch_color(beautiful.colors["light_" .. color_key .. "_15"])
    end
  end)

  button:connect_signal("mouse::leave", function (self)
    if self.has_focus then
      button.animation:switch_color(beautiful.colors[color_key])
    end
  end)

  button:add_button(awful.button({}, 1, function ()
    if callback then
      callback()
    end
  end))

  gtimer.delayed_call(function ()
    button:update_has_focus()
    client.connect_signal("focus", function ()
      print("updating")
      button:update_has_focus()
    end)
  end)

  return button
end

return function ()
  capi.client.connect_signal("request::titlebars", function (c)
    if c.requests_no_titlebar then
      return
    end

    local titlebar = awful.titlebar(c, {
      bg = beautiful.colors.background,
      position = "top",
      size = 32,
    })

    local close_button = create_button(c, 'red', function ()
      c:kill()
    end)

    local maximize_button = create_button(c, 'yellow', function ()
      c.maximized = not c.maximized
    end)

    local minimize_button = create_button(c, 'green', function ()
      gtimer.delayed_call(function ()
        c.minimized = not c.minimized
      end)
    end)

    titlebar:setup({
      layout = wibox.layout.align.horizontal,
      {
        widget = wibox.container.margin,
        margins = {
          left = dpi(15),
          top = dpi(3),
          bottom = dpi(3),
        },
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(6),
          close_button,
          maximize_button,
          minimize_button,
        }
      },
      {
        widget = wibox.container.background,
        buttons = {
          awful.button({}, 1, function ()
            c:activate { context = "titlebar", action = "mouse_move" }
          end),
          awful.button({}, 3, function ()
            c:activate { context = "titlebar", action = "mouse_resize" }
          end)
        }
      }
    })
  end)
end
