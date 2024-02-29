local wibox = require("wibox")
local awful = require("awful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local animation = require("lib.animation")
local color = require("lib.color")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local capi = { client = client }

local function create_button(color_key, callback)
  local button = wibox.widget({
    widget = wibox.container.background,
    bg = beautiful.colors[color_key],
    shape = gshape.circle,
    forced_width = dpi(12),
    forced_height = dpi(12),
  })

  button.animation = animation:new {
    duration = 0.25,
    easing = animation.easing.linear,
    pos = color.hex_to_rgba(beautiful.colors[color_key]),
    update = function (_, pos)
      button.bg = color.rgba_to_hex(pos)
    end
  }

  function button.animation:switch_color(new_color)
    self:set { target = color.hex_to_rgba(new_color) }
  end

  button:connect_signal("mouse::enter", function ()
    button.animation:switch_color(beautiful.colors["light_" .. color_key .. "_15"])
  end)

  button:connect_signal("mouse::leave", function ()
    button.animation:switch_color(beautiful.colors[color_key])
  end)

  button:add_button(awful.button({}, 1, function ()
    if callback then
      callback()
    end
  end))

  return button
end

return function ()
  capi.client.connect_signal("request::titlebars", function (c)
    if c.requests_no_titlebar then
      return
    end

    local titlebar = awful.titlebar(c, {
      bg_normal = beautiful.colors.light_background_1,
      bg_focus = beautiful.colors.light_background_2,
      position = "top",
      size = 35,
    })

    local close_button = create_button('red', function ()
      c:kill()
    end)

    local maximize_button = create_button('yellow', function ()
      c.maximized = not c.maximized
    end)

    local minimize_button = create_button('green', function ()
      gtimer.delayed_call(function ()
        c.minimized = not c.minimized
      end)
    end)

    titlebar:setup({
      layout = wibox.layout.align.horizontal,
      {
        widget = wibox.container.margin,
        margins = {
          left = dpi(16),
          top = dpi(4),
          bottom = dpi(4),
        },
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(7),
          close_button,
          maximize_button,
          minimize_button,
        }
      }
    })
  end)
end
