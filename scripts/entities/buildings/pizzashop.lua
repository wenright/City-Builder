local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('obj_store10')

local PizzaShop = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function PizzaShop:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'PizzaShop'
end

function PizzaShop:update(dt)
  Base.update(self, dt)
end

function PizzaShop:draw()
  Base.draw(self)
end

return PizzaShop
