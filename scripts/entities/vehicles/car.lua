local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector-light'

local Entity = require 'scripts.entities.entity'
local Player = require 'scripts.entities.characters.player'

local Base = Entity

local Car = Class {__includes = Base}

function Car:init(properties)
  Base.init(self, properties)

  self.type = 'Car'

  self.speed = 0.4
  self.maxSpeed = 400
  self.friction = 0.1
end

function Car:update(dt)
  local speed = Vector.len(self.vx, self.vy)
  self.rotationSpeed = math.min(speed, 3)

  Base.update(self, dt)
end

function Car:handleInput(dt)
  local oldRotation = self.rotation

  Player.handleInput(self, dt)

  local dr = self.rotation - oldRotation
  self.vx, self.vy = Vector.rotate(dr, self.vx, self.vy)
end

function Car:draw()
  -- Base.draw(self)

  -- TODO the model is drawn flipped compared to player (I think)
  self.model:draw(self.x, self.y, self.z, self.rotation + math.pi, self.scale, self.scale)
end

function Car:collide(other)

end

return Car
