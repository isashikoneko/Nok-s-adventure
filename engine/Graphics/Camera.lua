
Camera = {
  x = 0,
  y = 0,
  scalex = 1,
  scaley = 1,
  rotation = 0
}

Camera.__index = Camera

function Camera:new()
  local this = setmetatable({}, self)
  
  return this
end

function Camera:set()
  
  love.graphics.push()
  
  love.graphics.rotate(self.rotation)
  love.graphics.scale(1 / self.scalex, 1 / self.scaley)
  love.graphics.translate(self.x, self.y)
  
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:rotate(rotation)
  self.rotation = rotation
end

function Camera:translate(x, y)
  
  self.x = self.x + x
  
--  if self.x > 0 then
--    self.x = 0
--  end
  
  self.y = self.y + y
  
end

function Camera:zoom(scalex, scaley)
  self.scalex = scalex
  self.scaley = scaley
end
