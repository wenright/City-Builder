local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local Economy = Class {}

function Economy:init(properties)
  self.timer = Timer.new()
end

function Economy:update(dt)
  self.timer:update(dt)
end

return Economy
