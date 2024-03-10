local awful = require "awful"
local wibox = require "wibox"
local gtimer = require "gears.timer"
local gshape = require "gears.shape"
local gtable = require "gears.table"
local Widget = require "ui.guards.widget"
local general = require "lib.general"
local animation = require "lib.animation"
local color = require "lib.color"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local tagslist = {}

function tagslist:handle_args(s)
  self._private.s = s
end

function tagslist:base_taglist()
  local Statuses = {
    INACTIVE = "inactive",
    OCCUPIED = "occupied",
    ACTIVE = "active"
  }

  local sizes = {
    [Statuses.INACTIVE] = dpi(14),
    [Statuses.OCCUPIED] = dpi(25),
    [Statuses.ACTIVE] = dpi(32),
  }

  local colors = {
    [Statuses.INACTIVE] = beautiful.colors.light_background_7,
    [Statuses.OCCUPIED] = beautiful.colors.light_background_15,
    [Statuses.ACTIVE] = beautiful.colors.accent,
  }

  local taglist = awful.widget.taglist {
    screen = self._private.s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(8),
    },
    widget_template = {
      widget = wibox.container.background,
      forced_height = sizes[Statuses.INACTIVE],
      forced_width = dpi(4),
      bg = colors[Statuses.INACTIVE],
      shape = gshape.rounded_bar,
      create_callback = function (self, tag)
        local transition = animation:new {
          duration = 1,
          easing = animation.easing.outExpo,
          pos = {
            color = color.hex_to_rgba(colors[Statuses.INACTIVE]),
            size = sizes[Statuses.INACTIVE],
          },
          update = function (_, pos)
            self.bg = color.rgba_to_hex(pos.color)
            self.forced_height = pos.size
          end
        }

        function transition:animate(payload)
          local cpy = {}
          gtable.crush(cpy, payload, true)

          if cpy.color ~= nil then
            cpy.color = color.hex_to_rgba(cpy.color)
          end

          self:set(cpy)
        end

        function self:set_status(key)
          transition:set {
            color = color.hex_to_rgba(colors[key]),
            size = sizes[key],
          }
        end

        function self:update()
          if tag.selected then
            self:set_status(Statuses.ACTIVE)
          elseif #tag:clients() > 0 then
            self:set_status(Statuses.OCCUPIED)
          else
            self:set_status(Statuses.INACTIVE)
          end
        end

        self:update()
      end,
      update_callback = function (self)
        if self.update ~= nil then
          gtimer.delayed_call(function ()
            self:update()
          end)
        end
      end
    }
  }

  return taglist
end

function tagslist:render()
  return wibox.widget {
    widget = wibox.container.margin,
    margins = {
      left = dpi(8),
      right = dpi(8),
    },
    {
      widget = wibox.container.background,
      bg = beautiful.colors.light_background_3,
      shape = general:srounded(dpi(12)),
      {
        widget = wibox.container.margin,
        margins = {
          top = dpi(10),
          bottom = dpi(10),
        },
        {
          widget = wibox.container.place,
          valign = 'center',
          halign = 'center',
          self:base_taglist()
        }
      }
    }
  }
end

return Widget(tagslist)
