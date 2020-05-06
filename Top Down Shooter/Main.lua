function love.load()
sprites = {}
sprites.player = love.graphics.newImage('CourseAssets/player.png')
sprites.bullet = love.graphics.newImage('CourseAssets/bullet.png')
sprites.bg = love.graphics.newImage('courseAssets/background.png')
sprites.zombie = love.graphics.newImage('courseAssets/Zombie.png')

end

function love.update(dt)
  -- body...
end

function love.draw()
  love.graphics.draw(sprites.bg, 0, 0)
  love.graphics.draw(sprites.player, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end
