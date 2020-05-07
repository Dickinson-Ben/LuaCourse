function love.load()

  gameWorld = love.physics.newWorld(0, 500)
  gameWorld:setCallbacks(beingContact, endContact, preSolve, postSolve)
  sprites = {}
  sprites.coinSheet = love.graphics.newImage("sprites/coin_sheet.png")
  sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
  sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")
  sprites.tiles = love.graphics.newImage("maps/tiles_spritesheet.png")

  require('player') --requirements just need the file name not the extension.

platforms = {}
spawnPlatform(100, 400, 500, 40)

end

function love.update(dt)
  gameWorld:update(dt) --needed to update the world physics interactions. Without it, nothing will move as it should under the effects of physics
  playerUpdate(dt)
end

function love.draw()
  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil ,  player.direction, 1 , sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)
--utilising player.direction within the scaling factor is a trick to change the directional facing of the sprite. Since a necative
--horozontal scaling results in the image being scaled to the point of rotation!

  for i, p in ipairs(platforms) do
    love.graphics.rectangle("fill", p.body:getX(), p.body:getY() , p.width, p.height)
  end
end
function love.keypressed(key, scancode, isrepeat)
  if key == "space" and player.isJumping == false then
    player.body:applyLinearImpulse(0, -2500) --takes x and y values
    player.isJumping = true

  end
end


function spawnPlatform(x, y, width, height)
  --function for spawning in a platform
local platform  = {}
platform.body = love.physics.newBody(gameWorld, x, y, "static")
platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
platform.fixture = love.physics.newFixture(platform.body, platform.shape)
--these two properties make it easier to access the width and height
platform.width = width
platform.height = height

table.insert(platforms, platform)
end


--the following functions determine the players "isJumping" status.
--this is how collision detection between the player and the
function beingContact(a, b, coll)
player.isJumping = false
end

function endContact(a, b, coll)
  player.isJumping = true
end
