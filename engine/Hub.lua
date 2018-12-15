Hub = {
  max_life = 0,
  life = 0,
  pourcentage = 0,
  w = 0,
  h = 0
}

Hub.__index = Hub

HUB_HEIGHT = 10

function Hub:new(max_life, w)
  local this = setmetatable({}, self)
  
  this.max_life = max_life
  this.life = this.max_life
  this.pourcentage = 100
  
  this.w = w
  this.h = HUB_HEIGHT
  
  return this
end

function Hub:reduceLife(life)
  self.life = self.life - life

  if self.life <= 0 then 

    self.life = 0

  end
  
  self.pourcentage = (self.life * 100) / self.max_life

  if self.pourcentage == 0 then
    return true 
  else
    return false 
  end

end

function Hub:riseLife(life)
  self.life = self.life + life
  
  if self.life > self.max_life then
    self.life = self.max_life
  end
  
  self.pourcentage = (self.life * 100) / self.max_life
  
end

function Hub:draw(x, y)
  
  love.graphics.setColor(255, 255, 255, 100)
  
  love.graphics.rectangle("line", x, y - self.h - 10, self.w, self.h)
  
  if self.pourcentage > 50 then
    love.graphics.setColor(0, 255, 0, 100)
  elseif self.pourcentage > 25 then
    love.graphics.setColor(255, 255, 0, 255)
  else
    love.graphics.setColor(255, 0, 0, 255)
  end
  
  love.graphics.rectangle("fill", x + 1, y - self.h - 9, (self.pourcentage * (self.w - 1)) / 100, self.h - 1)
  
  love.graphics.setColor(255, 255, 255, 255)
  
end
