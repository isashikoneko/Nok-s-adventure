--require("Point")

Vector2 = {
    a = nil,
    b = nil,
    x = 0,
    y = 0
}

Vector2.__index = Vector2

function Vector2:new(a, b)
    local this = setmetatable({}, self)

    this.a = a
    this.b = b
    this.x = b.x - a.x
    this.y = b.y - a.y 

    return this
end

function Vector2:newFromCoord(x, y)
    local this = setmetatable({}, self)

    this.a = nil
    this.b = nil
    this.x = x
    this.y = y

    return this
end

function Vector2:getString()
  
  return "(" .. self.x .. ", " .. self.y .. ")"
  
end


function Vector2:getNormal()

    return Vector2:newFromCoord(self.y, -self.x)

end

function Vector2:normalize()
  local norme = math.sqrt(self.x * self.x + self.y * self.y)
  
  self.x = self.x / norme
  self.y = self.y / norme
  
end

function Vector2:mul(scalar)

    self.x = self.x * scalar
    self.y = self.y * scalar

end

function Vector2:add(vector)

    self.x = self.x + vector.x 
    self.y = self.y + vector.y 

end

function Vector2:dot(p)
    --[[ local point
    
    local c = 3

    local x = (self.y * c - self.y * (self.x * p.x - self.y * p.y) + (self.x * p.x - self.y * p.y)) / (self.y - self.x)
    local y = ((-self.y * c + self.y * (self.x * p.x - self.y * p.y) - (self.x * p.x - self.y * p.y)) / (self.y - self.x)) + c + (self.x * p.x - self.y * p.y)

    point = Point:new(x, y)

    return point ]]

    return self.x * p.x + self.y * p.y 
end

function Vector2:getPoint()
    return self.a, self.b
end

function Vector2:setPoint(a, b)
    self.a = a
    self.b = b
    self.x = b.x - a.x
    self.y = b.y - a.y 
end