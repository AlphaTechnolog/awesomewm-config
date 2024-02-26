local awful = require "awful"
local wibox = require "wibox"
local gshape = require "gears.shape"
local general = require "lib.general"
local animation = require "lib.animation"
local color = require "lib.color"
local widget = require "ui.guards.widget"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local List = {}

function List:handle_args(tasks)
  self._private.tasks = tasks
end

function List:contained(children)
  return wibox.widget {
    widget = wibox.container.place,
    valign = "top",
    halign = "center",
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(12),
        bottom = dpi(12),
      },
      children
    }
  }
end

function List:goto_task_button(task)
  local background = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_2,
    shape = gshape.circle,
    {
      widget = wibox.container.margin,
      margins = dpi(2),
      {
        widget = wibox.widget.textbox,
        markup = general:tint_markup(beautiful.colors.accent, ""),
        font = beautiful.fonts:choose("icons", 14),
        valign = "center",
        align = "center",
      }
    }
  }

  background.transition = animation:new {
    duration = 1,
    easing = animation.easing.outExpo,
    pos = color.hex_to_rgba(beautiful.colors.light_background_2),
    update = function (_, pos)
      background.bg = color.rgba_to_hex(pos)
    end
  }

  function background:set_color(new_color)
    self.transition:set { target = color.hex_to_rgba(new_color) }
  end

  background:connect_signal("mouse::enter", function ()
    background:set_color(beautiful.colors.light_background_8)
  end)

  background:connect_signal("mouse::leave", function ()
    background:set_color(beautiful.colors.light_background_2)
  end)

  background:add_button(awful.button({}, 1, function ()
    require "naughty".notify { title = task.title }
  end))

  return background
end

function List:item(task)
  return wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_2,
    shape = general:srounded(dpi(12)),
    forced_width = dpi(420),
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(12),
        bottom = dpi(12),
        left = dpi(13),
        right = dpi(13),
      },
      {
        layout = wibox.layout.align.horizontal,
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(2),
          {
            widget = wibox.widget.textbox,
            markup = task.title,
            valign = "center",
            align = "left",
          },
          {
            widget = wibox.widget.textbox,
            markup = general:tint_markup(beautiful.colors.light_background_12, task.description),
            font = beautiful.fonts:choose("normal", 8),
            valign = "center",
            align = "left",
          }
        },
        self:goto_task_button(task)
      }
    }
  }
end

function List:hydrate(layout)
  for _, task in ipairs(self._private.tasks) do
    layout:add(self:item(task))
  end
end

function List:get_layout()
  local layout = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(12),
  }

  self:hydrate(layout)

  return layout
end

function List:render()
  return self:contained(self:get_layout())
end

return widget(List)