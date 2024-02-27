local Home = require "ui.popups.core.tabs.home"
local Tasks = require "ui.popups.core.tabs.tasks"
local Notes = require "ui.popups.core.tabs.notes"
local Youtube = require "ui.popups.core.tabs.youtube"
local About = require "ui.popups.core.tabs.about"
local Settings = require "ui.popups.core.tabs.settings"

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
  mkentry(Youtube()),
  mkentry(About()),
  mkentry(Settings()),
}
