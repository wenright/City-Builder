local Class = require 'lib.hump.class'
local Vector = require 'lib.hump.vector-light'

local CameraInput = Class {}

function CameraInput:init(properties)
  assert(properties.camera, 'Must assign a camera to the camera input controller')

  self.camera = properties.camera

  self.rotateSpeed = 2
  self.moveSpeed = 100
end

function CameraInput:update(dt)
  --- Camera rotation
  if love.keyboard.isDown('q') then
    self.camera:rotate(self.rotateSpeed * dt)
  end

  if love.keyboard.isDown('e') then
    self.camera:rotate(-self.rotateSpeed * dt)
  end


  --- Camera movement
  local dx, dy = 0, 0

  -- Get input from keyboard to initialize movement vector
  if love.keyboard.isDown('a') then dx = -1 end
  if love.keyboard.isDown('d') then dx = 1 end
  if love.keyboard.isDown('w') then dy = -1 end
  if love.keyboard.isDown('s') then dy = 1 end

  -- Rotate vector according to camera rotation
  local rdx, rdy = Vector.rotate(-self.camera.rotation, dx, dy)

  -- Normalize vector so that diagonal movement is just as fast as horizontal and vertical
  local rdxn, rdyn = Vector.normalize(rdx, rdy)

  -- Multiply by move speed and delta time to get final movement step
  local mx, my = Vector.mul(dt * self.moveSpeed, rdxn, rdyn)

  -- Move camera
  self.camera:move(mx, my)
end

return CameraInput
