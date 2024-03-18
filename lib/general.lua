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
local gtable = require "gears.table"

local _general = {}

function _general:srounded(fact)
  return function(cr, w, h)
    gshape.rounded_rect(cr, w, h, fact)
  end
end

function _general:prounded(fact, tl, tr, br, bl)
  return function(cr, w, h)
    gshape.partially_rounded_rect(cr, w, h, tl, tr, br, bl, fact)
  end
end

function _general:quick_read(filename)
  local file = io.open(filename, "r")
  if not file then
    return nil -- no such file or directory
  end

  local content = file:read "a"

  file:close()

  return content
end

function _general:scrollable_text(widget)
  return wibox.widget {
    widget = wibox.container.scroll.horizontal,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 100,
    max_width = 20,
    widget,
  }
end

-- dummy scrolling
function _general:make_widget_scrollable(widget)
  widget:buttons(gtable.join(
    awful.button({}, 4, nil, function()
      if #widget.children == 1 then
        return
      end
      widget:insert(1, widget.children[#widget.children])
      widget:remove(#widget.children)
    end),
    awful.button({}, 5, nil, function()
      if #widget.children == 1 then
        return
      end
      widget:insert(#widget.children + 1, widget.children[1])
      widget:remove(1)
    end)
  ))
end

function _general:string_trim(string)
  return string:gsub("^%s*(.-)%s*$", "%1")
end

function _general:string_capitalize(string)
  return string:gsub("^%l", string.upper)
end

function _general:tint_markup(color, fmt)
  return "<span foreground='" .. color .. "'>" .. fmt .. "</span>"
end

function _general:in_table(fact, tbl, iterator)
  if not iterator then
    iterator = ipairs
  end

  for _, i in iterator(tbl) do
    if i == fact then
      return true
    end
  end

  return false
end

return _general
