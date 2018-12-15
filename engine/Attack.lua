require('Graphics/Shape')

Attack = {
  box = nil,
  power = 0
}

Attack.__index = Attack

function Attack:new(power)
  local this = setmetatable({}, self)
  
  return this
end

function Attack:draw()
  
end