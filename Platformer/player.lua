player = {}
player.body = love.physics.newBody(gameWorld, 150, 100, "dynamic")--this is basically a rigid body for the 2d plane. It contains physical attributes
--4 variables here needed. The gameworld that physics originate from, the starting position, and either static or dynamic. I.e. is it gonna move
player.shape = love.physics.newRectangleShape(66, 92)--width and height of player box. This is a hit box!
player.fixture = love.physics.newFixture(player.body, player.shape) --tethers the rigid body to the hitbox, third parameter is available for density!
player.speed = 200
player.direction = 1
player.isJumping = true
player.sprite = sprites.player_stand
player.body:setFixedRotation(true)

function playerUpdate(dt)
  --movement left and right
  if love.keyboard.isDown("a") then
    player.body:setX(player.body:getX()-player.speed * dt)--moves the character ot the left
    player.direction = -1
  end

  if love.keyboard.isDown("d") then
    player.body:setX(player.body:getX()+player.speed * dt)
    player.direction = 1
  end

  if player.isJumping == true then
    player.sprite = sprites.player_jump
  else
      player.sprite = sprites.player_stand
  end
end
