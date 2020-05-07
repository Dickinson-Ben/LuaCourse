--Completed as far as course goes however I have additions to make
--To do:
--add zombie variants
--make screen space bigger
--power-ups
--hp or lives system
--Fine tune spawning mechanic
--alternate weapons
--"local leader boards"

function love.load()
sprites = {}
sprites.player = love.graphics.newImage('CourseAssets/player.png')
sprites.bullet = love.graphics.newImage('CourseAssets/bullet.png')
sprites.bg = love.graphics.newImage('courseAssets/background.png')
sprites.zombie = love.graphics.newImage('courseAssets/Zombie.png')

player = {}
player.x = love.graphics.getWidth()/2
player.y = love.graphics.getHeight()/2 --starts the player in the center of the screen
player.moveSpeed = 180

zombies = {}
bullets = {}

gameState = 1 --


score = 0
highScore = 0
timer = 2
maxTimer = 2
gameTimer = 0

movingUp = false
movingDown = false
movingLeft = false
movingRight = false
end

function love.update(dt)

  if gameState == 2 then
    --upward movement
    if love.keyboard.isDown("w") and player.y > 0 then
    player.y = player.y - player.moveSpeed * dt
    end
    --downward movement
    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
    player.y = player.y + player.moveSpeed * dt
      end
      --left movement
      if love.keyboard.isDown("a") and player.x > 0 then
      player.x = player.x - player.moveSpeed * dt
    end
    --Right movement
    if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
    player.x = player.x + player.moveSpeed * dt
    end

  end
--zombie movement


  for i, z in ipairs(zombies) do
    z.x = z.x  + math.cos(zombie_face_player(z)) * z.speed * dt
    z.y = z.y + math.sin(zombie_face_player(z)) * z.speed * dt


--odd problem, the player position returns nil if the player hasn't moved. Odd --REsolved! Issue was with an excess end statement at the bottom of the code.
--additional issue, the zombies seem to despawn at random almost, collision either isn't involved or the detection is wrong.
--Resolved! THe distance between calculation had a typo in it! It was doin ^ of co-ordinate sets instead of +ing them

    if distanceBetween(z.x, z.y, player.x, player.y) < 10 then
      for i, z in ipairs(zombies) do
        zombies[i] = nil --zombies[i] refers to the current index in the zombies table
        score = 0
        if score > highScore then
          highScore = Score
        end
        timer = 2
        gameTimer = 0
        gameState = 1
      end
    end
  end
  --the rotational aspect really throws you off when trying to igure it out, it's really somewhat simple. Using the cosin you get the X vallue of the zombies currently facing directoin
  --then using the sin you get the y value of the zomies currently facing direction.
  --You're then given a decimal equivelant to + or _ from the zombies respective X and y, making it move slowly towards the direction the sprite is facing
  --it's hard to explain but it makes sense. Refer to the radian table
  --remember these values will be between 0 and 1.


--check to see if bullets go out of bounds
for i=#bullets,1, -1 do
  local b = bullets[i]
  if b.x <0 or b.y <0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
    table.remove(bullets, i) --the table to remove an item from, then the item to be removed. in this case, the current loop position
    end
end

--bullet collision with zombies. Despawn particular zombie on hit
for i, z in ipairs(zombies) do
  for j, b in ipairs(bullets) do
    if distanceBetween(z.x, z.y, b.x, b.y) < 5 then
      z.dead = true
      b.dead = true
      score = score + 1
    end
  end
end

for i=#zombies, 1, -1 do
  local z = zombies[i]
    if z.dead == true then
      table.remove(zombies, i)
    end
  end


for i=#bullets, 1, -1 do
  local b = bullets[i]
    if b.dead == true then
      table.remove(bullets, i)
    end
  end
  --bullet movement
  for i, b in ipairs(bullets) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end

  if gameState == 2 then
      timer = timer - dt
      if timer <= 0 then
        spawnZombie()
        maxTimer = maxTimer * 0.95
        timer = maxTimer
      end
  end

  if gameState == 2 then
    gameTimer = gameTimer + dt
  end
end




function love.draw()
  love.graphics.draw(sprites.bg, 0, 0) --background image.
  love.graphics.draw(sprites.player, player.x, player.y, player_face_mouse(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2 ) -- draws the player character sprite and positions it in the centre o

  if gameState == 1 then
    love.graphics.setFont(love.graphics.newFont(50)) --actually takes a font file name parameter but not needed when used like this
    love.graphics.printf("Press S to start!", 0, 50, love.graphics.getWidth(), "center")
  end


  if gameState  == 2 then
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("Score: " .. score, 0, 0, love.graphics.getWidth(), "center")
    love.graphics.printf("Timer: " .. math.ceil(gameTimer),0, 0, love.graphics.getWidth(), "left")
    love.graphics.printf("High Score: " .. highScore, 0, 0, love.graphics.getWidth(), "right")
  end

  for i,z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y, zombie_face_player(z), nil, nil, sprites.zombie:getWidth()/2, sprites.player:getHeight()/2)
  end


  for i, b in pairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
  end

end

function player_face_mouse()
  if gameState == 2 then
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end
  -- returns angles and radians for the points provided. Used to rotate one object to face another here i.e. rotates the player
  --sprite to face the mouse! (remembe this it's super important for many aspects of game development!)
end

function zombie_face_player(enemy)
  return math.atan2(enemy.y - player.y, enemy.x - player.x) + math.pi
end



function spawnZombie()
  zombie = {}
  zombie.x = 0 --sets the zombies initial spawn to be random but within the limits of the screen
  zombie.y  = 0 -- can still spawn slightly off screen due to image origin point but that is desired to give the feeling

  edge = math.random(1, 4)

  if edge == 1 then
    zombie.x = math.random(0,love.graphics.getWidth())
    zombie.y = 0
  end

  if edge == 2 then
    zombie.x = 0
    zombie.y = math.random(0, love.graphics.getHeight())
  end

  if edge == 3 then
      zombie.x = love.graphics.getWidth()
      zombie.y = math.random(0, love.graphics.getHeight())
  end

  if edge == 4 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight()
  end

  zombie.health = 10
  zombie.speed = 100
  zombie.dead = false
  table.insert(zombies, zombie)
end

function spawnBullet()
    bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 180
    bullet.direction = player_face_mouse() --call teh player_face_mouse function to give the bullet it's directional radian value!
    bullet.dead = false
    table.insert(bullets, bullet)
  end

--manual spawning for debugging zombie spawn, uncomment if needed
--function love.keypressed(key, scancode, isrepeat)
--  if key == "space" then
--    spawnZombie()
--  end
--end

function love.keypressed(key, scancode, isrepeat)
  if key == "s" then
    gameState = 2
  end
end

function love.mousepressed(x, y, b, isTouch)
  if b == 1 then
      if gameState == 2 then
        spawnBullet()
      end
  end
end


function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
