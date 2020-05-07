player = {}
player.body = love.physics.newBody(gameWorld, 100, 100, "dynamic")--this is basically a rigid body for the 2d plane. It contains physical attributes
--4 variables here needed. The gameworld that physics originate from, the starting position, and either static or dynamic. I.e. is it gonna move
player.shape = love.physics.newRectangleShape(66, 92)--width and height of player box. This is a hit box!
player.fixture = love.physics.newFixture(player.body, player.shape) --tethers the rigid body to the hitbox, third parameter is available for density!
