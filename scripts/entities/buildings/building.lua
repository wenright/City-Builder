local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Base = Entity

local Building = Class {__includes = Base}

function Building:init(properties)
  Base.init(self, properties)

  self.type = 'Building'
end

function Building:update(dt)
  Base.update(self, dt)
end

function Building:draw()
  Base.draw(self)
end

return Building
