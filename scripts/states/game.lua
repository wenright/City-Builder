local Lovox = require 'lovox'

local Bump = require 'lib.bump.bump'

local Entity = require 'scripts.entities.entity'
local CameraInput = require 'scripts.camerainput'

local Events = require 'scripts.events'
local Economy = require 'scripts.economy'
local ConstructionUi = require 'scripts.constructionui'

local EntitySystem = require 'scripts.entitysystem'

local Game = {}

function Game:init()
  self.camera = Lovox.camera
  self.cameraInput = CameraInput({camera = self.camera})

  self.world = Bump.newWorld()

  self.events = Events()
  self.economy = Economy()
  self.constructionUi = ConstructionUi()

  self.entities = EntitySystem()

  self.entities:add(Entity({x = 50, y = 0, model = 'obj_statue1'}))
  -- self.entities:add(Entity({x = 50, y = 100, model = 'obj_store06'}))
  self.entities:add(Entity({x = 150, y = 100, model = 'obj_store10'}))
end

function Game:update(dt)
  self.cameraInput:update(dt)

  self.events:update(dt)
  self.economy:update(dt)
  self.constructionUi:update(dt)

  self.entities:update(dt)
end

function Game:draw()
  self.entities:draw()

  self.constructionUi:draw()

  -- Render all our models
  self.camera:render()
end

function Game:wheelmoved(x, y)
  self.cameraInput:scroll(x, y)
end

-- TODO place this into a different camera scripts
-- Draws a plane on the ground that will rotate/scale/move with the camera
function Game:drawPlane(x, y, w, h)
  local x1, y1 = Game.camera:worldToScreen(x, y, 0)
  local x2, y2 = Game.camera:worldToScreen(x + w, y, 0)
  local x3, y3 = Game.camera:worldToScreen(x + w, y + h, 0)
  local x4, y4 = Game.camera:worldToScreen(x, y + h, 0)

  love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4, x1, y1)
end

return Game
