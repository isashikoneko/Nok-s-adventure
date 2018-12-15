
require('../Math/Vector2')
require('../Graphics/Shape')
require('../Math/Point')

Particle = {
  start_color = {},
  end_color = {},
  color = {},
  shape = nil,
  lifetime = 0,
  time = 0,
  speed = nil
}

Particle.__index = Particle

SPEED_UNIT = 10
SIZE = 1

function Particle:new(x, y, start_color, end_color, lifetime, initial_speed)
  
  local this = setmetatable({}, self)
  
  this.shape = Shape:new(x, y, {Point:new(0, 0), Point:new(SIZE, 0), Point:new(SIZE, SIZE), Point:new(0, SIZE)})

  this.start_color = start_color
  this.end_color = end_color
  this.color = this.start_color
  
  this.time = 0
  this.lifetime = lifetime
  this.speed = initial_speed
  
  return this
  
end

function Particle:update(dt)
  
  self.time = self.time + dt
  
  if self.time > self.lifetime then
    return false
  end
  
  if self.speed.x > 0 then
    self.speed.x = self.speed.x - SPEED_UNIT * dt
  else
    self.speed.x = self.speed.x + SPEED_UNIT * dt
  end
  
  if self.speed.y > 0 then
    self.speed.y = self.speed.y - SPEED_UNIT * dt
  else
    self.speed.y = self.speed.y + SPEED_UNIT * dt
  end
  
  return true
  
end

function Particle:draw()
  
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], 255)
  self.shape:draw()
  
end
