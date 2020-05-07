function love.load()
  sprites = {}
  sprites.coinSheet = love.graphics.newImage("sprites/coin_sheet.png")
  sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
  sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")
  sprites.tiles = love.graphics.newImage("maps/tiles_spritesheet.png")

  require('player') --requirements just need the file name not the extension.
end

function love.update(dt)
  -- body...
end

function love.draw()
  love.graphics.draw(sprites.player_stand, player.x, player.y)
end
