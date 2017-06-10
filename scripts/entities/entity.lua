--- All entities have a 3D voxel model associated with them
-- They also have a physics body and shape attached to them

local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector-light'

local Bump = require 'lib.bump.bump'

local Transform = require 'scripts.transform'

-- Load Lovox
local Lovox     = require 'lovox'
local ModelData = Lovox.modelData
local Model     = Lovox.model
local Camera    = Lovox.camera

local Base = Transform

local Entity = Class {__includes = Base}

function Entity:init(properties)
  Base.init(self, properties)

  assert(properties.model, 'Attempted to instantiate an entitiy without a model')
  assert(type(properties.model) == 'string', 'Entity\'s model paramater must be a string')

  -- Load a model from a .vox file
  local fileString = 'models/' .. properties.model .. '.vox'
  assert(love.filesystem.exists(fileString), 'Voxel file \'' .. fileString .. '\' does not exist')
  local voxelFile = love.filesystem.newFile(fileString)
  print('Loading ' .. fileString)
  local modelData = ModelData.newFromVox(voxelFile)
  local model = Model(modelData)

  self.model = model

  self.rotation = properties.rotation or 0

  self.vx, self.vy = 0, 0
  self.friction = 0.99
  self.scale = 1

  local w, h = self.model.width, self.model.height

  self.disableCollider = properties.disableCollider or false

  Game.world:add(self, self.x, self.y, w, h)
end

function Entity:update(dt)
  -- Calculate the position that the object should be moved to
  local x, y = Game.world:getRect(self)
  local goalX = x + self.vx * dt
  local goalY = y + self.vy * dt

  -- Place the object at the new position
  self.x, self.y = Game.world:getRect(self)

  -- Offset the entity position so that its collider is centered on the model
  self.x = self.x + self.model.width / 2
  self.y = self.y + self.model.height / 2

  -- TODO use a better friction function
  self.vx, self.vy = Vector.sub(self.vx, self.vy, Vector.mul(self.friction * 10 * dt, self.vx, self.vy))

  -- Attempt to move the object to that position
  local actualX, actualY, cols, len = Game.world:move(self, goalX, goalY, function(this, other)
    if this.disableCollider or other.disableCollider then
      return nil
    end

    -- TODO this should also check if the z positions are the same

    return 'bounce'
  end)

  if len > 0 then
    -- TODO handle collisions encountered
    for k, collision in pairs(cols) do
      local other = collision.other

      if self.collide and type(self.collide) == 'function' then
        self:collide(other)
      end

      -- TODO reduce velocities on collision
    end
  end
end

function Entity:draw()
  self.model:draw(self.x, self.y, self.z, self.rotation, self.scale, self.scale)

  -- Draw the entity's shadow
  --[[
  love.graphics.setColor(25, 25, 25, 25)
  local x, y, w, h = Game.world:getRect(self)

  Game.camera:rotate(self.rotation)
  local x1, y1 = Game.camera:worldToScreen(x, y, 0)
  local x2, y2 = Game.camera:worldToScreen(x + w, y, 0)
  local x3, y3 = Game.camera:worldToScreen(x + w, y + h, 0)
  local x4, y4 = Game.camera:worldToScreen(x, y + h, 0)
  Game.camera:rotate(-self.rotation)

  love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4, x1, y1)
  ]]
end

return Entity
