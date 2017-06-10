local Lovox = require 'lovox'

local Bump = require 'lib.bump.bump'

local Entity = require 'scripts.entities.entity'
local Car = require 'scripts.entities.vehicles.car'
local CameraInput = require 'scripts.camerainput'

local EntitySystem = require 'scripts.entitysystem'

local Game = {}

function Game:init()
  self.camera = Lovox.camera
  self.cameraInput = CameraInput({camera = self.camera})

  self.zoom = 5
  self.camera:zoom(self.zoom)

  self.world = Bump.newWorld()

  self.entities = EntitySystem()

  self.entities:add(Entity({x = 50, y = 0, model = 'obj_statue1'}))
  self.entities:add(Entity({x = 50, y = 100, model = 'obj_store06'}))
  self.entities:add(Entity({x = 150, y = 100, model = 'obj_store10'}))
end

function Game:update(dt)
  self.cameraInput:update(dt)
  self.entities:update(dt)
end

function Game:draw()
  self.entities:draw()

  -- Render all our models
  self.camera:render()
end

return Game
