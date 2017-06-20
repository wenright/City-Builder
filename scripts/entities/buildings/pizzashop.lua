local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local PizzaShop = Class {__includes = Base}

function PizzaShop:init(properties)
  properties.model = 'obj_store10'

  Base.init(self, properties)

  self.type = 'PizzaShop'
end

function PizzaShop:update(dt)
  Base.update(self, dt)
end

function PizzaShop:draw()
  Base.draw(self)
end

return PizzaShop
