message="Called it"

testScores = {13, 43, 24, 76}

message = testScores[3]


function love.draw()
  love.graphics.setFont(love.graphics.newFont(50))
  love.graphics.print(message)
end
