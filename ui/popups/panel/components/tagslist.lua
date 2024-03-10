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
    [Statuses.INACTIVE] = dpi(28),
    [Statuses.OCCUPIED] = dpi(42),
    [Statuses.ACTIVE] = dpi(62),
  }

  local colors = {
    [Statuses.INACTIVE] = beautiful.colors.dark_black_6,
    [Statuses.OCCUPIED] = beautiful.colors.light_black_6,
    [Statuses.ACTIVE] = beautiful.colors.accent,
  }

  return awful.widget.taglist {
    screen = self._private.s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(8),
    },
    widget_template = {
      widget = wibox.container.background,
      forced_width = sizes[Statuses.INACTIVE],
      forced_height = dpi(4),
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
            self.forced_width = pos.size
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
end

function tagslist:render()
  return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.background_shade,
    shape = general:srounded(dpi(12)),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(8),
        bottom = dpi(8),
        left = dpi(16),
        right = dpi(16)
      },
      {
        widget = wibox.container.place,
        valign = 'center',
        halign = 'center',
        self:base_taglist()
      },
    }
  }
end

return Widget(tagslist)
