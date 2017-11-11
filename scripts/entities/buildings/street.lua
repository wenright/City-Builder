local Class = require 'lib.hump.class'
local Entity = require 'scripts.entities.entity'

local Building = require 'scripts.entities.buildings.building'

local Base = Building

local modelData = Entity.loadModelData('env_crete1b')

local Street = Class {
  __includes = Base,
  modelData = modelData,
  width = modelData.width,
  height = modelData.height
}

function Street:init(properties)
  Base.init(self, properties)

  self.model = Entity.modelDataToModel(self.modelData)

  self.type = 'Street'
end

function Street:update(dt)
  Base.update(self, dt)
end

function Street:draw()
  Base.draw(self)
end

return Street
