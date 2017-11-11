local Class = require 'lib.hump.class'
local Timer = require 'lib.hump.timer'

local PizzaShop = require 'scripts.entities.buildings.pizzashop'
local Bank = require 'scripts.entities.buildings.bank'
local Apartment = require 'scripts.entities.buildings.apartment'
local Grocery = require 'scripts.entities.buildings.grocery'
local TestBuilding = require 'scripts.entities.buildings.testbuilding'
local Street = require 'scripts.entities.buildings.street'

local ConstructionUi = Class {}

function ConstructionUi:init(properties)
  self.timer = Timer.new()

  self.mx, self.my = 0, 0
  self.w, self.h = 64, 64

  self.blockSize = 32

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
  elseif love.keyboard.isDown('2') then
    self.selectedBuilding = Bank
  elseif love.keyboard.isDown('3') then
    self.selectedBuilding = Apartment
  elseif love.keyboard.isDown('4') then
    self.selectedBuilding = Grocery
  elseif love.keyboard.isDown('5') then
    self.selectedBuilding = Street
  end

  if self.selectedBuilding ~= nil then
    self.w, self.h = self.selectedBuilding.width, self.selectedBuilding.height

    local x, y = self:getMousePosition()

    self.canPlace = true

    local items, len

    local roundedCosine = math.floor(math.cos(self.rotation) + 0.5)

    if roundedCosine == 0 then
      items, len = Game.world:queryRect(x, y, self.h, self.w)
    else
      items, len = Game.world:queryRect(x, y, self.w, self.h)
    end

    if len > 0 then
      self.canPlace = false
    end

    if love.mouse.isDown(1) and self.canPlace then
      love.graphics.setColor(255, 255, 255)
      Game.entities:add(self.selectedBuilding({x = x, y = y}))

      self.selectedBuilding = nil
    end
  end
end

function ConstructionUi:draw()
  if self.selectedBuilding ~= nil then
    local x, y = self:getMousePosition()

    local color = nil
    if self.canPlace then
      color = {101, 142, 156}
    else
      color = {232, 116, 97}
    end

    love.graphics.setColor(color)

    local roundedCosine = math.floor(math.cos(self.rotation) + 0.5)

    Game:drawPlane(x, y, self.w, self.h, math.acos(roundedCosine))
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
