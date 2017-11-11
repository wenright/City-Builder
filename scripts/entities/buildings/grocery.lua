local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('obj_store_groc')

local Grocery = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function Grocery:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'Grocery'
end

function Grocery:update(dt)
  Base.update(self, dt)
end

function Grocery:draw()
  Base.draw(self)
end

return Grocery
