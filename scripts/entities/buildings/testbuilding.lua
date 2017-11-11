local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('obj_store07')

local TestBuilding = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function TestBuilding:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'TestBuilding'
end

function TestBuilding:update(dt)
  Base.update(self, dt)
end

function TestBuilding:draw()
  Base.draw(self)
end

return TestBuilding
