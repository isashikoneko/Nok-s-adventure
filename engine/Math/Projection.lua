--require("Point")

Projection = {
    min = nil,
    max = nil 
}

Projection.__index = Projection

function Projection:new(a, b)
    local this = setmetatable({}, self)

    this.min = a 
    this.max = b

    return this
end

function Projection:overlap(p)
    --if (self.min.x > p.max.x or self.max.x < p.min.x) or (self.min.y > p.max.y or self.max.y < p.min.y) then 
    --if (self.min > p.max or p.min > self.max) then
    if p.max:inferior(self.min) or self.max:inferior(p.min) then
        return false
    else
      
        if self.min:inferior(p.max) and p.min:inferior(self.min) then
          return true, self.min, p.max
        end
        
        if p.min:inferior(self.max) and self.min:inferior(p.min) then
          return true, p.min, self.max
        end
        
        return true, Point:new(0, 0), Point:new(0, 0)
        
    end
end

function Projection:getOverlap(p)
  
  return self.max:min(p.max):getDistance(self.min:max(p.min))
  
end