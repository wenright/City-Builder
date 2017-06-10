love.graphics.setBackgroundColor(225, 225, 225)
love.graphics.setDefaultFilter('nearest', 'nearest')

require 'scripts.math'

local Gamestate = require 'lib.hump.gamestate'

-- TODO use non-global variables
Game = require 'scripts.states.game'
Menu = require 'scripts.states.menu'

DEBUG = true

function love.load()
  Gamestate.registerEvents()

  -- TODO menu
  Gamestate.switch(Game)
end

function love.update(dt)
  -- TODO remove for releases
  require 'lib.bird.lovebird'.update()
end

function love.draw()

end

function love.resize(w, h)
   Camera:resize(w, h)
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
