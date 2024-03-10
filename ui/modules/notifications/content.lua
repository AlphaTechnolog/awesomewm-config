--[[
- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
-
- https://github.com/alphatechnolog
- https://github.com/alphatechnolog/awesomewm-config.git
--]]

local wibox = require "wibox"
local gshape = require "gears.shape"
local widget = require "ui.guards.widget"
local beautiful = require "beautiful"
local general   = require "lib.general"
local dpi = beautiful.xresources.apply_dpi

local NotificationContent = {}

function NotificationContent:handle_args(notification)
  self._private.notification = notification
end

function NotificationContent:render()
  local notif = self._private.notification

  -- storing original timeout in order to play with it
  self._private.notification.original_timeout = notif.timeout

  return wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
      widget = wibox.container.background,
      bg = beautiful.colors.background_shade,
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(7),
          bottom = dpi(7),
          left = dpi(10),
          right = dpi(10),
        },
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(4),
          {
            widget = wibox.widget.textbox,
            markup = general:tint_markup(beautiful.colors.accent, ""),
            font = beautiful.fonts:choose("icons", 12),
            valign = "center",
            align = "left",
          },
          {
            widget = wibox.widget.textbox,
            markup = "<b>" .. notif.app_name .. "</b>",
            valign = "center",
            align = "left",
          }
        }
      }
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(12),
          bottom = dpi(12),
          left = dpi(10),
          right = dpi(10),
        },
        {
          layout = wibox.layout.align.horizontal,
          {
            widget = wibox.widget.imagebox,
            image = notif.icon,
            valign = "center",
            halign = "left",
            forced_width = 24,
            forced_height = 24,
            clip_shape = gshape.circle,
          },
          {
            widget = wibox.container.margin,
            margins = {
              left = dpi(7),
            },
            {
              layout = wibox.layout.fixed.vertical,
              spacing = dpi(2),
              notif.title and {
                widget = wibox.widget.textbox,
                markup = "<b>" .. notif.title .. "</b>",
                valign = "center",
                align = "left",
              } or nil,
              {
                widget = wibox.widget.textbox,
                valign = "center",
                align = "left",
                markup = notif.title and general:tint_markup(
                  beautiful.colors.light_black_15,
                  notif.text
                ) or "<b>" .. notif.text .. "</b>",
              }
            }
          }
        }
      }
    }
  }

  -- return wibox.widget {
  --   layout = wibox.layout.align.vertical,
  --   nil,
  --   layout,
  --   {
  --     layout = wibox.layout.fixed.vertical,
  --     {
  --       widget = wibox.container.background,
  --       bg = beautiful.colors.light_background_5,
  --       forced_height = dpi(1),
  --     },
  --     {
  --       widget = wibox.container.background,
  --       bg = beautiful.colors.light_background_3,
  --       {
  --         widget = wibox.widget.textbox,
  --         markup = "<b>" .. notif.app_name .. "</b>",
  --         valign = "center",
  --         align = "left",
  --       }
  --     }
  --   }
  -- }
end

return widget(NotificationContent)