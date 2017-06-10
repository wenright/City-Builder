local Lovox = require 'lovox'

local Bump = require 'lib.bump.bump'

local Entity = require 'scripts.entities.entity'
local CameraInput = require 'scripts.camerainput'

local Events = require 'scripts.events'
local Economy = require 'scripts.economy'

local EntitySystem = require 'scripts.entitysystem'

local Game = {}

function Game:init()
  self.camera = Lovox.camera
  self.cameraInput = CameraInput({camera = self.camera})

  self.world = Bump.newWorld()

  self.events = Events()
  self.economy = Economy()

  self.entities = EntitySystem()

  self.entities:add(Entity({x = 50, y = 0, model = 'obj_statue1'}))
  self.entities:add(Entity({x = 50, y = 100, model = 'obj_store06'}))
  self.entities:add(Entity({x = 150, y = 100, model = 'obj_store10'}))
end

function Game:update(dt)
  self.cameraInput:update(dt)

  self.events:update(dt)
  self.economy:update(dt)

  self.entities:update(dt)
end

function Game:draw()
  self.entities:draw()

  -- Render all our models
  self.camera:render()
end

function Game:wheelmoved(x, y)
  self.cameraInput:scroll(x, y)
end

return Game
