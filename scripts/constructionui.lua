local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local PizzaShop = require 'scripts.entities.buildings.pizzashop'

local ConstructionUi = Class {}

function ConstructionUi:init(properties)
  self.timer = Timer.new()

  self.mx, self.my = 0, 0
  self.w, self.h = 50, 50

  self.rotation = 0
  self.canRotate = true

  self.canPlace = false
end

function ConstructionUi:update(dt)
  self.timer:update(dt)

  self.mx, self.my = love.mouse.getPosition()

  if love.keyboard.isDown('r') then
    if self.canRotate then
      self.canRotate = false
      -- TODO use love.onbuttondown
      self.timer:after(0.5, function() self.canRotate = true end)

      self.rotation = self.rotation + math.pi / 2
    end
  end

  if love.keyboard.isDown('1') then
    -- TODO select some building type
    -- TODO Building class
    self.selectedBuilding = PizzaShop
    self.w, self.h = self.selectedBuilding.model.width, self.selectedBuilding.model.height
  end

  if self.selectedBuilding ~= nil then
    local x, y = self:getMousePosition()

    self.canPlace = true

    local items, len

    local roundedCosine = math.floor(math.cos(self.rotation) + 0.5)

    if roundedCosine == 0 then
      items, len = Game.world:queryRect(x, y, self.w, self.h)
    else
      items, len = Game.world:queryRect(x, y, self.h, self.w)
    end

    if len > 0 then
      self.canPlace = false
    end

    if love.mouse.isDown(1) and self.canPlace then
      love.graphics.setColor(255, 255, 255)

      Game.entities:add(PizzaShop({x = x, y = y, rotation = self.rotation}))

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

    Game:drawPlane(x, y, self.w, self.h, self.rotation)
  end
end

-- Returns the mouse position in terms of world coordinates
function ConstructionUi:getMousePosition()
  -- Apply given rotation first
  Game.camera:rotate(self.rotation)

  -- Convert mouse coordinates into world coordinates
  local x, y = Game.camera:screenToWorld(self.mx, self.my)

  -- Center x/y coords
  x = x - self.w / 2
  y = y - self.h / 2

  -- Break the coordinates into multiples of 10
  local gridSize = 10

  x = x - (x % gridSize) + gridSize / 2
  y = y - (y % gridSize) + gridSize / 2

  -- Revert rotation
  Game.camera:rotate(-self.rotation)

  return x, y
end

return ConstructionUi
