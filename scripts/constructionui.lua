local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local ConstructionUi = Class {}

function ConstructionUi:init(properties)
  self.timer = Timer.new()

  self.mx, self.my = 0, 0
  self.w, self.h = 50, 50
end

function ConstructionUi:update(dt)
  self.timer:update(dt)

  if love.keyboard.isDown('1') then
    -- TODO select some building type
    -- TODO Building class
    self.selectedBuilding = 1
  end

  self.mx, self.my = love.mouse.getPosition()
end

function ConstructionUi:draw()
  if self.selectedBuilding ~= nil then
    local x, y = Game.camera:screenToWorld(self.mx, self.my)
    Game:drawPlane(x - self.w / 2, y - self.h / 2, self.w, self.h)
  end
end

return ConstructionUi
