coins = {}

function spawnCoin(x, y)
  local coin = {}
  coin.x = x
  coin.y = y
  coin.collected = false

  coin.grid = anim8.newGrid(41, 42, 123, 126)--image size, total sprite sheet size
  coin.animation = anim8.newAnimation(coin.grid('1-3', 1, '1-3', 2, '1-2', 3), 0.1)
  --'1-3' refers to the "images" in the row, the size of an image is determined by the parameters
  --set in the new grid section. It will itterate the number of times stated here. so 1 - 3 means the first three images
  --and the ,1 determins which row to get said images from! it's super handy
  --finally it takes the time between each frame in secionds
  table.insert (coins, coin)
end

function coinUpdate(dt)
  for i, c in ipairs(coins) do
    if distanceBetween(c.x, c.y, player.body:getX(), player.body:getY()) < 50 then
    c.collected = true
    score = score + 1
    end
  end

  for i=#coins, 1, -1 do
    local c = coins[i]
      if c.collected == true then
        table.remove(coins, i)
      end
    end
end
