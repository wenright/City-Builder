local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local Events = Class {}

function Events:init(properties)
  self.timer = Timer.new()

  self.eventDelay = 45
  self.timer:every(self.eventDelay, function()
    self:generateEvent()
  end)
end

function Events:update(dt)
  self.timer:update(dt)
end

-- Generates a new random event
function Events:generateEvent()

end

return Events
