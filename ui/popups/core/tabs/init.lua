local Home = require "ui.popups.core.tabs.home"
local Settings = require "ui.popups.core.tabs.settings"
local Tasks = require "ui.popups.core.tabs.tasks"
local Notes = require "ui.popups.core.tabs.notes"

local function mkentry(ins)
  return {
    metadata = ins:metadata(),
    instance = ins,
  }
end

return {
  mkentry(Home()),
  mkentry(Tasks()),
  mkentry(Notes()),
  mkentry(Settings()),
}