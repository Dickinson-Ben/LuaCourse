function love.load()
sprites = {}
sprites.player = love.graphics.newImage('CourseAssets/player.png')
sprites.bullet = love.graphics.newImage('CourseAssets/bullet.png')
sprites.bg = love.graphics.newImage('courseAssets/background.png')
sprites.zombie = love.graphics.newImage('courseAssets/Zombie.png')

player = {}
player.x = love.graphics.getWidth()/2
player.y = love.graphics.getHeight()/2
player.moveSpeed = 180

zombies = {}
bullets = {}





movingUp = false
movingDown = false
movingLeft = false
movingRight = false



end

function love.update(dt)

  --upward movement
  if love.keyboard.isDown("w") then
  player.y = player.y - player.moveSpeed * dt
  end
  --downward movement
  if love.keyboard.isDown("s") then
  player.y = player.y + player.moveSpeed * dt
    end
    --left movement
    if love.keyboard.isDown("a") then
    player.x = player.x - player.moveSpeed * dt
  end
  --Right movement
  if love.keyboard.isDown("d") then
  player.x = player.x + player.moveSpeed * dt
  end

--zombie movement

  for i, z in ipairs(zombies) do
    z.x = z.x  + math.cos(zombie_face_player(z)) * z.speed * dt
    z.y = z.y + math.sin(zombie_face_player(z)) * z.speed * dt

    if distanceBetween(z.x, z.y, player.x, player.y) < 100 then
      for i, z in ipairs(zombies) do
        zombies[i] = nil --zombies[i] refers to the current index in the zombies table
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


  --bullet movement
  for i, b in ipairs(bullets) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end
end





function love.draw()
  love.graphics.draw(sprites.bg, 0, 0) --background image.
  love.graphics.draw(sprites.player, player.x, player.y, player_face_mouse(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2 ) -- draws the player character sprite and positions it in the centre o
-- to do: Adjust the origin offset


  for i,z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y, zombie_face_player(z), nil, nil, sprites.zombie:getWidth()/2, sprites.player:getHeight()/2)

  end


  for i, b in pairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
  end

end

function player_face_mouse()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
  -- returns angles and radians for the points provided. Used to rotate one object to face another here i.e. rotates the player
  --sprite to face the mouse! (remembe this it's super important for many aspects of game development!)
end

function zombie_face_player(enemy)
  return math.atan2(enemy.y - player.y, enemy.x - player.x) + math.pi
end



function spawnZombie()
  zombie = {}
  zombie.x = math.random(0, love.graphics.getHeight()) --sets the zombies initial spawn to be random but within the limits of the screen
  zombie.y  = math.random(0, love.graphics.getWidth()) -- can still spawn slightly off screen due to image origin point but that is desired to give the feeling
                                                    -- that they are coming ffrom somewhere? Perhaps tweek so they all come off screen.
  zombie.health = 10
  zombie.speed = 100

  table.insert(zombies, zombie)
end

function spawnBullet()
  bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 140
  bullet.direction = player_face_mouse() --call teh player_face_mouse function to give the bullet it's directional radian value!

  table.insert(bullets, bullet)
end


function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    spawnZombie()
  end

function love.mousepressed(x, y, b, isTouch)
  if b == 1 then
    spawnBullet()
  end
  -- body...
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 ^ (x2 - x1) ^2)
end

end
