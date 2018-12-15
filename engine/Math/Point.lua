Point = {
    x = 0,
    y = 0
}

Point.__index = Point

function Point:new(x, y)
    local this = setmetatable({}, self)

    this.x = x
    this.y = y

    return this
end

function Point:getDistance( b )
    return math.sqrt( (b.x - self.x) * (b.x - self.x) + (b.y - self.y) * (b.y - self.y) )
end

function Point:equal(point)
  
  if self.x == point.x and self.y == point.y then
    return true
  end
  
  return false
  
end

function Point:isAround(point, r)
  
  if self:getDistance(point) < r then
    return true
  else
    return false
  end
  
end

function Point:inferior(p)

    if self.x < p.x then 
        return true
    elseif self.x == p.x then 
        if self.y < p.y then
            return true 
        else
            return false 
        end
    else
        return false 
    end

end

function Point:max(p)
  
  if self:inferior(p) then
    return p
  else
    return self
  end
  
end

function Point:min(p)
  
  if self:inferior(p) then
    return self
  else
    return p
  end
  
end

function Point:toString()
  return "(" .. self.x .. ", " .. self.y .. ")"
end


