local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Base = Entity

local Character = Class {__includes = Base}

function Character:init(properties)
  Base.init(self, properties)
end

function Character:update(dt)
  Base.update(self, dt)
end

function Character:draw()
  Base.draw(self)
end

return Character
