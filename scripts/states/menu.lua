local Menu = {}

local Gamestate = require 'lib.hump.gamestate'

function Menu:init()
  print('Entering menu')
  Gamestate.switch(Game)
end

function Menu:update(dt)

end

function Menu:draw()

end

return Menu
