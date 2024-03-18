--==================================================================
-- ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
-- ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
--
-- https://github.com/alphatechnolog
-- https://github.com/alphatechnolog/awesomewm-config.git
--==================================================================

local awful = require "awful"

awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey, "Control", "Shift" },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  },
}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings {
  awful.button({}, 4, awful.tag.viewprev),
  awful.button({}, 5, awful.tag.viewnext),
}
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings {
  awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit", group = "awesome" }),

  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),

  awful.key({ modkey, "Shift" }, "Return", function()
    awful.spawn(launcher)
  end, {
    description = "open a launcher (" .. launcher .. ")",
    group = "launcher",
  }),

  awful.key({ modkey }, "d", function ()
    local s = awful.screen.focused()

    if not s.core_window then
      error("cannot get the dashboard instance?")
    end

    s.core_window:toggle()
  end, {
    description = "open the dashboard",
    group = "launcher"
  }),

  awful.key({ modkey }, "n", function ()
    local s = awful.screen.focused()

    if not s.notifications_panel then
      error("cannot get the notifications panel instance")
    end

    s.notifications_panel:toggle()
  end, {
    description = "open the notifications panel",
    group = "launcher",
  })
}

-- Tags related keybindings
local tags_binds = {
  { key = "Left", docb = awful.tag.viewprev, description = "view previous" },
  { key = "Right", docb = awful.tag.viewnext, description = "view next" },
  { key = "Escape", docb = awful.tag.history.restore, description = "go back" },
}

for _, bind in ipairs(tags_binds) do
  awful.keyboard.append_global_keybindings {
    awful.key({ modkey, "Shift" }, bind.key, bind.docb, {
      description = bind.description,
      group = "tag",
    }),
  }
end

-- Focus related keybindings
local function byidx(focus, idx)
  return function()
    local symbol
    if focus then
      symbol = "focus"
    else
      symbol = "swap"
    end
    awful.client[symbol].byidx(idx)
  end
end

local function toggle_maximize()
  local c = client.focus
  if c then
    c.maximized = not c.maximized
    c:raise()
  end
end

local focus_bindings = {
  { prefix = { modkey }, key = "j", docb = byidx(true, 1), description = "focus next by index" },
  { prefix = { modkey }, key = "k", docb = byidx(true, -1), description = "focus previous by index" },
  { prefix = { modkey, "Shift" }, key = "j", docb = byidx(false, 1), description = "swap with next client by index" },
  {
    prefix = { modkey, "Shift" },
    key = "k",
    docb = byidx(false, -1),
    description = "swap with previous client by index",
  },
  {
    prefix = { modkey },
    key = "m",
    docb = toggle_maximize,
    description = "toggle current focused client maximization",
  },
}

for _, bind in ipairs(focus_bindings) do
  awful.keyboard.append_global_keybindings {
    awful.key(bind.prefix, bind.key, bind.docb, {
      description = bind.description,
      group = "client",
    }),
  }
end

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings {
    awful.button({}, 1, function(c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate { context = "mouse_click", action = "mouse_move" }
    end),
    awful.button({ modkey }, 3, function(c)
      c:activate { context = "mouse_click", action = "mouse_resize" }
    end),
  }
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings {
    awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {
      description = "toggle fullscreen",
      group = "client",
    }),

    awful.key({ modkey }, "w", function(c)
      c:kill()
    end, { description = "close app", group = "client" }),

    awful.key({ modkey }, "space", awful.client.floating.toggle, {
      description = "toggle floating",
      group = "client",
    }),
  }
end)
