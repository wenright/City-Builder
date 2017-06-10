local _PATH       = (...):gsub('%.[^%.]+$', '')
local Vox_model   = require(_PATH..".vox2png.vox_model")
local Vox_texture = require(_PATH..".vox2png.vox_texture")

local flagFormat = [[
return {
	frames = %1.f,
	width  = %1.f,
	height = %1.f,
}
]]
local function vox2png(file)
   file:open("r")
		local model = Vox_model.new(file:read())
	file:close()

   local texture = vox_texture.new(model)

   return texture.canvas:newImageData():encode("png"), string.format(flagFormat, texture.canvas:getWidth() / texture.sizeX, texture.sizeX, texture.sizeY)
end

return {
   _VERSION     = "Voxol 1.0.0",
   _DESCRIPTION = "A set of modules to load and render voxels in Love2d",
   _URL         = "https://github.com/tjakka5",
   _LICENSE     = [[
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
   ]],

   zlist     = require(_PATH..".zlist"),
   camera    = require(_PATH..".camera"),
   modelData = require(_PATH..".modelData"),
	animModel = require(_PATH..".animModel"),
   model     = require(_PATH..".model"),
   vox2png   = vox2png,
}
