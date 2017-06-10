local Lovox = require 'lovox'

local Bump = require 'lib.bump.bump'

local Entity = require 'scripts.entities.entity'
local Car = require 'scripts.entities.vehicles.car'

local EntitySystem = require 'scripts.entitysystem'

local Game = {}

function Game:init()
  Game.camera = Lovox.camera

  self.zoom = 5
  Game.camera:zoom(self.zoom)

  self.world = Bump.newWorld()

  self.entities = EntitySystem()

  self.entities:add(Entity({x = 50, y = 0, model = 'obj_statue1'}))
  self.entities:add(Entity({x = 50, y = 100, model = 'obj_store06'}))
  self.entities:add(Entity({x = 150, y = 100, model = 'obj_store10'}))
end

function Game:update(dt)
  self.entities:update(dt)
end

function Game:draw()
  self.entities:draw()

  -- Render all our models
  Game.camera:render()
end

return Game
