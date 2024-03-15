local wibox = require "wibox"
local general = require "lib.general"
local hoverable = require "ui.guards.hoverable"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local oop = require "lib.oop"

local about = {}

local Distro = require "ui.popups.panel.components.distro"

function about:metadata()
  return {
    misc = {
      name = "About",
      icon = "",
    },
    sidebar = {
      position = "bottom"
    }
  }
end

local function item(w, opts)
  opts = opts or {
    position_hint = "regular",
    shape = nil
  }

  local content = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_4,
    forced_width = dpi(460),
    shape = opts.shape,
    {
      widget = wibox.container.margin,
      margins = {
        top = dpi(14),
        bottom = dpi(14),
        left = dpi(18),
        right = dpi(18),
      },
      w
    }
  }

  local function borders_margins()
    local base = { left = 1, right = 1 }

    local key = opts.position_hint == "first"
      and "top"
      or "bottom"

    if opts.position_hint ~= "regular" then
      base[key] = 1
    end

    return base
  end

  return {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_8,
    shape = opts.shape,
    {
      widget = wibox.container.margin,
      margins = borders_margins(),
      content
    }
  }
end

function about:os_name()
  local osrelease = general:quick_read("/etc/os-release")

  print(osrelease)

  return wibox.widget {
    layout = wibox.layout.align.horizontal,
    {
      widget = wibox.widget.textbox,
      markup = 'brou'
    }
  }
end

local function list_layout()
  local base = wibox.layout.fixed.vertical()

  base.spacing = 1

  local function mkutil(name, tl, tr, br, bl)
    base[name] = function (self, w)
      self:add(item(w, {
        position_hint = name,
        shape = general:prounded(dpi(12), tl, tr, br, bl)
      }))
    end
  end

  mkutil("first", true, true, false, false)
  mkutil("last", false, false, true, true)

  function base:insert(w)
    self:add(item(w))
  end

  return base
end

function about:data_list()
  local layout = list_layout()

  layout:first(self:os_name())

  layout:insert(self:os_name())
  layout:insert(self:os_name())

  layout:last(self:os_name())

  return {
    widget = wibox.container.background,
    bg = beautiful.colors.light_background_8,
    shape = general:srounded(dpi(12)),
    layout
  }
end

function about:render()
  return wibox.widget {
    widget = wibox.container.place,
    valign = "center",
    halign = "center",
    {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(12),
      Distro({
        width = 72,
        height = 72
      }):render(),
      self:data_list()
    }
  }
end

return oop(about)
