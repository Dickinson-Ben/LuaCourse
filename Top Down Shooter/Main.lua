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
end
--to do, add rotation based on mouse position. Look up Radian Circle for reference

function love.draw()
  love.graphics.draw(sprites.bg, 0, 0) --background image.
  love.graphics.draw(sprites.player, player.x, player.y, player_face_mouse() ) -- draws the player character sprite and positions it in the centre o
-- to do: Adjust the origin offset

end

function player_face_mouse()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX())
end
