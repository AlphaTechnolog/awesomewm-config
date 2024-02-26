local wibox = require "wibox"
local awful = require "awful"
local gshape = require "gears.shape"
local widget = require "ui.guards.widget"
local hoverable = require "ui.guards.hoverable"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local Notifications = {}

function Notifications:clear_button()
  local button = hoverable(wibox.widget {
    widget = wibox.container.background,
    shape = gshape.circle,
    bg = beautiful.colors.light_background_2,
    {
      widget = wibox.container.margin,
      margins = dpi(4),
      {
        widget = wibox.widget.textbox,
        font = beautiful.fonts:choose("icons", 14),
        valign = "center",
        align = "center",
        markup = "",
      },
    },
  })

  button:setup_hover {
    colors = {
      normal = beautiful.colors.light_background_2,
      hovered = beautiful.colors.light_background_4,
    },
  }

  button:add_button(awful.button({}, 1, function()
    self:emit_signal "clear_notifications"
  end))

  return button
end

function Notifications:header()
  return wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(8),
        bottom = dpi(8),
        left = dpi(14),
        right = dpi(14),
      },
      {
        layout = wibox.layout.align.horizontal,
        {
          widget = wibox.widget.textbox,
          markup = "Notifications",
          font = beautiful.fonts:choose("normal", 18),
          valign = "center",
          align = "left",
        },
        nil,
        self:clear_button(),
      },
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_5,
      forced_height = dpi(1),
    },
  }
end

function Notifications:body()
  local layout = wibox.layout.fixed.vertical()

  layout.spacing = dpi(6)

  layout:add(wibox.widget {
    widget = wibox.widget.textbox,
    markup = "first",
    valign = "center",
    align = "left",
  })

  return wibox.widget {
    widget = wibox.container.margin,
    margins = {
      top = dpi(6),
      bottom = dpi(6),
      left = dpi(12),
      right = dpi(12),
    },
    layout,
  }
end

function Notifications:content()
  return wibox.widget {
    layout = wibox.layout.align.vertical,
    self:header(),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(6),
      },
      self:body(),
    },
  }
end

function Notifications:render()
  return self:content()
end

return widget(Notifications)
