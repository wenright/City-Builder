local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('obj_store_bank')

local Bank = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function Bank:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'Bank'
end

function Bank:update(dt)
  Base.update(self, dt)
end

function Bank:draw()
  Base.draw(self)
end

return Bank
