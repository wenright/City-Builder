local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local PizzaShop = require 'scripts.entities.buildings.pizzashop'

local ConstructionUi = Class {}

function ConstructionUi:init(properties)
  self.timer = Timer.new()

  self.mx, self.my = 0, 0
  self.w, self.h = 64, 64

  self.blockSize = 32

  self.canPlace = false
end

-- TODO querying works, but uses an arbitrary w/h. Use w/h of actual model to be placed
function ConstructionUi:update(dt)
  self.timer:update(dt)

  self.mx, self.my = love.mouse.getPosition()

  if love.keyboard.isDown('1') then
    -- TODO select some building type
    -- TODO Building class
    self.selectedBuilding = PizzaShop
    self.w, self.h = self.selectedBuilding.model.width, self.selectedBuilding.model.height
  end

  if self.selectedBuilding ~= nil then
    local x, y = self:getMousePosition()

    self.canPlace = true
    local items, len = Game.world:queryRect(x, y, self.w, self.h)
    if len > 0 then
      self.canPlace = false
    end

    if love.mouse.isDown(1) and self.canPlace then
      love.graphics.setColor(255, 255, 255)

      Game.entities:add(PizzaShop({x = x, y = y}))

      self.selectedBuilding = nil
    end
  end
end

function ConstructionUi:draw()
  if self.selectedBuilding ~= nil then
    local x, y = self:getMousePosition()

    local color = {255, 0, 0}
    if self.canPlace then
      color = {0, 255, 0}
    end

    love.graphics.setColor(color)

    Game:drawPlane(x, y, self.w, self.h)
  end
end

-- Returns the mouse position in terms of world coordinates
function ConstructionUi:getMousePosition()
  -- Convert mouse coordinates into world coordinates
  local x, y = Game.camera:screenToWorld(self.mx, self.my)

  -- Center x/y coords
  x = x - self.w / 2 + self.blockSize / 2
  y = y - self.h / 2 + self.blockSize / 2

  -- Break the coordinates into multiples of 10
  x = x - (x % self.blockSize)
  y = y - (y % self.blockSize)

  return x, y
end

return ConstructionUi
