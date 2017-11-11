local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('obj_store_apt')

local Apartment = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function Apartment:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'Apartment'
end

function Apartment:update(dt)
  Base.update(self, dt)
end

function Apartment:draw()
  Base.draw(self)
end

return Apartment
