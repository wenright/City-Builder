local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local Entity = require 'scripts.entities.entity'

local ConstructionUi = Class {}

function ConstructionUi:init(properties)
  self.timer = Timer.new()

  self.mx, self.my = 0, 0
  self.w, self.h = 50, 50
end

function ConstructionUi:update(dt)
  self.timer:update(dt)

  self.mx, self.my = love.mouse.getPosition()

  if love.keyboard.isDown('1') then
    -- TODO select some building type
    -- TODO Building class
    self.selectedBuilding = 1
  end

  if self.selectedBuilding ~= nil then
    if love.mouse.isDown(1) then
      love.graphics.setColor(255, 255, 255)

      local x, y = self:getMousePosition()
      Game.entities:add(Entity({x = x, y = y, model = 'obj_store04'}))

      self.selectedBuilding = nil
    end
  end
end

function ConstructionUi:draw()
  if self.selectedBuilding ~= nil then
    local x, y = self:getMousePosition()
    Game:drawPlane(x, y, self.w, self.h)
  end
end

-- Returns the mouse position in terms of world coordinates
function ConstructionUi:getMousePosition()
  local x, y = Game.camera:screenToWorld(self.mx, self.my)
  return x - self.w / 2, y - self.h / 2
end

return ConstructionUi
