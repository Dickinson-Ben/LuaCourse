--to do:
--Add sound for jump, coin collection, bg music, lava touching hiss
--implement lives function
--implement game timer because it's good practice


function love.load()
  love.window.setMode(900, 700)
  love.graphics.setBackgroundColor(1, 0.5, 1, 100)

  gameWorld = love.physics.newWorld(0, 500, false ) -- the sleep property (last one) means an object that stops moving no longer has physics applied to it
  gameWorld:setCallbacks(beingContact, endContact, preSolve, postSolve)
  sprites = {}
  sprites.coinSheet = love.graphics.newImage("sprites/coin_sheet.png")
  sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
  sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")
  sprites.tiles = love.graphics.newImage("maps/tiles_spritesheet.png")

  require('player') --requirements just need the file name not the extension.
  require('coin')
  require('show')
  cameraFile = require('hump-master/camera')
  anim8 = require('anim8-master/anim8')
  sti = require("Simple-Tiled-Implementation-master/sti")

  cam = cameraFile()

  platforms = {}

  score = 0
  highScore = 0
  lives = 3

  gameState = 1
  timer = 0

  saveData = {}
  saveData.bestTime = 999


  if love.filesystem.getInfo("data.lua") then
      local data = love.filesystem.load("data.lua")
      data()
  end



--spawn coins using the attributes defined in coin.lua and the positions from the
--tile map
  gameMap = sti("maps/gameMap.lua")
  for i, obj in pairs(gameMap.layers["coinsLayer"].objects) do
    spawnCoin(obj.x, obj.y)
  end
  --spawn in the platforms using the pre-defined physical properties from the
  --table, and the positions from the tile map!
    for i, obj in pairs(gameMap.layers["platformLayer"].objects) do
      spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
end

function love.update(dt)
  gameWorld:update(dt) --needed to update the world physics interactions. Without it, nothing will move as it should under the effects of physics
  playerUpdate(dt)
  gameMap:update(dt)
  coinUpdate(dt)

  if gameState == 2 then
    timer = timer + dt
  end

  if #coins == 0 and gameState == 2 then
    gameState = 1
    player.body:setPosition(150, 100)
  end

if #coins == 0 then
  gameMap = sti("maps/gameMap.lua")
  for i, obj in pairs(gameMap.layers["coinsLayer"].objects) do
    spawnCoin(obj.x, obj.y)
  end
end

if timer < saveData.bestTime then
  saveData.bestTime = math.ceil(timer)
  love.filesystem.write("data.lua", table.show(saveData, "saveData")) --this is where the table.show comes in.
  --the serialization takes 2 variables. The table we want serialized, then the name of the table this data will go to when it's loaded
end

  cam:lookAt(player.body:getX(), player.body:getY())

  for i, c in ipairs(coins) do
    c.animation:update(dt)
  end
end

function love.draw()
  cam:attach() --calling this function draws everything below (in the draw function) relevant to the cameras position
  --draws the visuals for all the platforms and anythin else on that layer!
  gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil ,  player.direction, 1 , sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)
  --utilising player.direction within the scaling factor is a trick to change the directional facing of the sprite. Since a necative
  --horozontal scaling results in the image being scaled to the point of rotation!
  for i, c in ipairs(coins) do
    c.animation:draw(sprites.coinSheet, c.x, c.y, nil, nil, nil, 20.5, 21)
  end
  --detatches the camera
    cam:detach()
--basic UI Elements for tracking player stats
    love.graphics.setFont(love.graphics.newFont(25))
    love.graphics.printf("Coins Collected: " .. score, 0, 0, love.graphics.getWidth(), "center")
    love.graphics.printf("Time: " .. math.ceil(timer), 0, 0, love.graphics.getWidth(), "right")

  if gameState == 1 then
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.printf("Press any key to begin!" ,0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" and player.isJumping == false and gameState == 2 then
    player.body:applyLinearImpulse(0, -3600) --takes x and y values
    player.isJumping = true
  end

  if gameState == 1 then
    gameState = 2
    score = 0
    timer = 0
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

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
