local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector-light'
local Timer = require 'lib.hump.timer'

local Character = require 'scripts.entities.characters.character'

local Base = Character

local Player = Class {__includes = Base}

function Player:init(properties)
  properties.model = 'chr_chef'

  Base.init(self, properties)

  self.type = 'Player'

  self.timer = Timer.new()

  self.speed = 5
  self.maxSpeed = 100
  self.rotationSpeed = 5

  self.vehicle = nil

  self.canInteract = true
end

function Player:update(dt)
  self.timer:update(dt)

  if self:isInVehicle() then
    self.vehicle:handleInput(dt)
    -- TODO cooldown on getting in/out of vehicles
    if love.keyboard.isDown('f') and self.canInteract then
      self:exitVehicle()
    end
  else
    assert(Game.world:hasItem(self), 'Not in game world')

    Base.update(self, dt)

    self:handleInput(dt)
  end
end

-- TODO have a single class that handles inputs for both characters and vehicles
function Player:handleInput(dt)
  local dx,dy = 0,0
  if love.keyboard.isDown('a', 'left') then
    self.rotation = self.rotation - self.rotationSpeed * dt
  elseif love.keyboard.isDown('d', 'right') then
    self.rotation = self.rotation + self.rotationSpeed * dt
  end
  if love.keyboard.isDown('w', 'up') then
    dy = -1
  elseif love.keyboard.isDown('s', 'down') then
    dy =  1
  end

  self.vx = self.vx + (dy * math.cos(self.rotation + math.pi/2)) * self.speed
  self.vy = self.vy + (dy * math.sin(self.rotation + math.pi/2)) * self.speed

  if Vector.len(self.vx, self.vy) > self.maxSpeed then
      self.vx, self.vy = Vector.mul(self.maxSpeed,
                          Vector.normalize(self.vx, self.vy))
  end

  Game.camera:moveTo(self.x, self.y)

  -- TODO this function is also called in car.lua, which can be confusing
  if self.type == 'Player' then
    -- TODO sometimes when lerping back in, it lerps from some value way outside of the range 0->2pi
    Game.camera:rotateTo(math.lerp(Game.camera.rotation, -self.rotation, dt * 10))
  end
end

function Player:draw()
  if not self:isInVehicle() then
    Base.draw(self)
  end
end

function Player:collide(other)
  if other.type and other.type == 'Car' then
    if not self.vehicle and self.canInteract and love.keyboard.isDown('f') then
      self:enterVehicle(other)
    end
  end
end

function Player:isInVehicle()
  return self.vehicle ~= nil
end

function Player:enterVehicle(vehicle)
  self:interact()
  self.vx, self.vy = 0, 0

  self.vehicle = vehicle

  Game.world:remove(self)
  self.timer:tween(0.5, Game.camera, {scale = 2}, 'in-out-quad')
end

function Player:exitVehicle()
  self:interact()

  Game.world:add(self, self.vehicle.x + self.vehicle.model.width, self.vehicle.y, self.model.width, self.model.height)
  self.rotation = self.vehicle.rotation
  self.vehicle = nil

  self.timer:tween(0.5, Game.camera, {scale = 5}, 'in-out-quad')
end

function Player:interact()
  self.canInteract = false
  self.timer:after(1, function() self.canInteract = true end)
end

return Player
