--[[
   Copyright (c) 2016 Justin van der Leij 'Tjakka5'

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use,
   copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following
   conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   OTHER DEALINGS IN THE SOFTWARE.
]]

local _PATH  = (...):gsub('%.[^%.]+$', '')
local Zlist  = require(_PATH..".zlist")

-- Internally used to render a model, can be used to directly draw a model without using the z-buffer
local function renderModel(model, self)
   love.graphics.draw(model.spritebatch, model.x, model.y, nil, self.scale, self.scale)
end


-- Setters for position
local function move(self, dx, dy) self.x, self.y = self.x + dx, self.y + dy end
local function moveTo(self, x, y) self.x, self.y = x, y end

-- Setters for rotation
local function rotate(self, r)
   self.rotation = self.rotation + r
   self:updateRotations()
end
local function rotateTo(self, r)
   self.rotation = r
   self:updateRotations()
end

-- Setters for scale
local function zoom(self, s) self.scale = self.scale * s end
local function zoomTo(self, s) self.scale = s end


-- Updates the camera importance values
local function updateRotations(self)
   self.psin, self.nsin = math.sin(self.rotation), math.sin(-self.rotation)
   self.pcos, self.ncos = math.cos(self.rotation), math.cos(-self.rotation)
end

-- Returns x, y, w, h of the camera as a bounding box
local function getBoundingBox(self)
   local s, c = self.psin, self.pcos
   if s < 0 then s = -s end
   if c < 0 then c = -c end
   local w, h = self.w / self.scale, self.h / self.scale
   local sw, sh = h * s + w * c, h * c + w * s
   return self.x - sw / 2, self.y - sh / 2, sw, sh
end

-- Translates x, y, z in the world into x, y on the screen.
-- !! Code taken from Hump's camera. Credit goes to vrld !!
local function worldToScreen(self, x, y, z)
	local c, s = self.pcos, self.psin
	x, y = x - self.x, y - self.y
	x, y = c * x - s * y, s * x + c * y
	return x * self.scale + self.w / 2, y * self.scale + self.h / 2 - z
end

-- Translates x, y on the screen into x, y, z in the world. z is 0
-- !! Code taken from Hump's camera. Credit goes to vrld !!
local function screenToWorld(self, x, y)
	local c, s = self.ncos, self.nsin
	x, y = (x - self.w / 2) / self.scale, (y - self.h / 2) / self.scale
	x, y = c * x - s * y, s * x + c * y
	return x + self.x, y + self.y, 0
end


-- Adds a model to the z-buffer
local function draw(self, model)
   self.buffer:add(model, model.y)
end

-- Renders all the models and clears the z-buffer
local function render(self)
   local r, g, b, a = love.graphics.getColor()
   love.graphics.setColor(255, 255, 255)

  --  TODO sort based on order?
   self.buffer:forEach(renderModel, self)
   self.buffer:clear()

   love.graphics.setColor(r, g, b, a)
end

-- Resizes the camera size to the screen size
local function resize(self, w, h)
   w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
   self.w = w
   self.h = h
end

-- Constructor
local function new(x, y, rotation, scale)
   return {
      x = x or 0,
      y = y or 0,
      w = love.graphics.getWidth()  * (scale or 1),
      h = love.graphics.getHeight() * (scale or 1),
      rotation    = rotation or 0,
      scale       = scale    or 1,
      psin = math.sin(rotation or 0), nsin = math.sin(rotation or 0),
      pcos = math.cos(rotation or 0), ncos = math.cos(rotation or 0),
      buffer      = Zlist(),

      move     = move,
      moveTo   = moveTo,
      rotate   = rotate,
      rotateTo = rotateTo,
      zoom     = zoom,
      zoomTo   = zoomTo,

      updateRotations = updateRotations,
      getBoundingBox  = getBoundingBox,
      worldToScreen   = worldToScreen,
      screenToWorld   = screenToWorld,

      draw   = draw,
      update = update,
      render = render,
      resize = resize,

      renderModel = renderModel,
   }
end

-- Return a camera
local Module = {
   current = new(),

   new      = new,
   move     = move,
   moveTo   = moveTo,
   rotate   = rotate,
   rotateTo = rotateTo,
   zoom     = zoom,
   zoomTo   = zoomTo,

   updateRotations = updateRotations,
   getBoundingBox  = getBoundingBox,
   worldToScreen   = worldToScreen,
   screenToWorld   = screenToWorld,

   draw   = draw,
   update = update,
   render = render,
   resize = resize,

   renderModel = renderModel,
}

return setmetatable(Module, {
   __index = Module.current,
   __call  = function(_, ...) return new(...) end,
})
