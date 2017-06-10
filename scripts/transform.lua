--- A transform contains an x and a y component

local Class = require 'lib.hump.class'

local Transform = Class {}

function Transform:init(properties)
  assert(properties, 'Properties value is null')
  assert(properties.x and properties.y, 'A transform needs an x and a y component')

  self.x, self.y = properties.x, properties.y
  self.z = properties.z or 0
end

return Transform
