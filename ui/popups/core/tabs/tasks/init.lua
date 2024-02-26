local wibox = require "wibox"
local oop = require "lib.oop"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local Header = require "ui.popups.core.tabs.tasks.components.header"
local TasksList = require "ui.popups.core.tabs.tasks.components.list"
local CreateButton = require "ui.popups.core.tabs.tasks.components.create_button"

local tasks = {}

function tasks:constructor()
  self._private.tasks = {
    {
      title = "Task 1",
      description = "This is a description for task 1",
      status = "pending"
    },
    {
      title = "Task 2",
      description = "This is a description for task 2",
      status = "pending"
    },
    {
      title = "Task 3",
      description = "This is a description for task 3",
      status = "pending"
    },
    {
      title = "Task 4",
      description = "This is a description for task 4",
      status = "pending"
    },
    {
      title = "Task 5",
      description = "This is a description for task 5",
      status = "pending"
    },
  }
end

function tasks:metadata()
  return {
    misc = {
      name = "Tasks",
      icon = ""
    }
  }
end

function tasks:render_content()
  local content = wibox.layout.flex.vertical()

  function content:switch_widget(w)
    self:reset()
    self:add(w:render())
  end

  content:switch_widget(TasksList(self._private.tasks))

  return content
end

function tasks:render()
  return wibox.widget {
    layout = wibox.layout.stack,
    {
      layout = wibox.layout.align.vertical,
      Header():render(),
      self:render_content()
    },
    {
      widget = wibox.container.place,
      valign = "bottom",
      halign = "right",
      {
        widget = wibox.container.margin,
        margins = {
          right = dpi(12),
          bottom = dpi(12),
        },
        CreateButton():render()
      }
    }
  }
end

return oop(tasks)