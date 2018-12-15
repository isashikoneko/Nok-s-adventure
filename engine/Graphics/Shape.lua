require("../../engine/Math/Projection")
require("../../engine/Math/Point")
require("../../engine/Math/Vector2")

Shape = {
    points = {},
    vertex = {},
    x = 0,
    y = 0,
    angle = 0,
    w = 0,
    h = 0,
    center = nil
}

Shape.__index = Shape

function Shape:new(x, y, vertex)
    local this = setmetatable({}, self)

    this.x = x 
    this.y = y 
    this.vertex = vertex

    this.points = {}
    
    local point = this.vertex[1]
    local min_x = point.x
    local min_y = point.y
    
    local max_x = min_x
    local max_y = min_y

    for i,v in ipairs(this.vertex) do
      
        if min_x > v.x then
          min_x = v.x
        end
        
        if min_y > v.y then
          min_y = v.y
        end
        
        if max_x < v.x then
          max_x = v.x
        end
        
        if max_y < v.y then
          max_y = v.y
        end
        
    end
    
    this.w = math.abs(max_x - min_x)
    this.h = math.abs(max_y - min_y)

    for i,v in ipairs(this.vertex) do
        v.x = v.x + this.x
        v.y = v.y + this.y - this.h
        table.insert( this.points, v.x )
        table.insert( this.points, v.y )
    end
    
    this:getGravity()

    return this

end


function Shape:moveX(x)
    self.x = self.x + x

    self.points = {}

    for i,v in ipairs(self.vertex) do
        v.x = v.x + x
        table.insert( self.points, v.x )
        table.insert( self.points, v.y )
    end
end

function Shape:moveY(y)
    self.y = self.y + y

    self.points = {}

    for i,v in ipairs(self.vertex) do
        v.y = v.y + y
        table.insert( self.points, v.x )
        table.insert( self.points, v.y )
    end
end

function Shape:translate(vector)

    self.y = self.y + vector.y 
    self.x = self.x + vector.x

    self.points = {}

    for i, v in ipairs(self.vertex) do
        v.x = v.x + vector.x
        v.y = v.y + vector.y
        table.insert( self.points, v.x )
        table.insert( self.points, v.y )
    end

end

function Shape:getGravity()
  
  local x = 0
  local y = 0
  
  for i, v in ipairs(self.vertex) do
    x = x + v.x
    y = y + v.y
  end
  
  x = x / #self.vertex
  y = y / #self.vertex
  
  self.center = Point:new(x, y)
  
end

function Shape:rotate(angle)
  
  self:getGravity()
  
  local center = self.center
    
    for i = 1, #self.vertex do
      
      self.vertex[i].x = (self.vertex[i].x - center.x) * math.cos(angle) - (self.vertex[i].y - center.y) * math.sin(angle) + center.x
      self.vertex[i].y = (self.vertex[i].x - center.x) * math.sin(angle) + (self.vertex[i].y - center.y) * math.cos(angle) + center.y
      
    end

end

function Shape:getX()
    return self.x
end

function Shape:getY()
    return self.y
end

function Shape:reset(vertex)
  
  self.vertex = vertex
  self.points = {}
    
  local point = self.vertex[1]
  local min_x = point.x
  local min_y = point.y
  
  local max_x = min_x
  local max_y = min_y

  for i,v in ipairs(self.vertex) do
    
      if min_x > v.x then
        min_x = v.x
      end
      
      if min_y > v.y then
        min_y = v.y
      end
      
      if max_x < v.x then
        max_x = v.x
      end
      
      if max_y < v.y then
        max_y = v.y
      end
      
  end
  
  local h = self.h
  
  self.w = math.abs(max_x - min_x)
  self.h = math.abs(max_y - min_y)
  
  local distance = self.h - h
  
  self.y = self.y - distance - 1
  
  self.points = {}
  
  for i,v in ipairs(self.vertex) do
    v.x = v.x + self.x
    v.y = v.y + self.y
    table.insert( self.points, v.x )
    table.insert( self.points, v.y )
  end
  
end

function Shape:project(axis)

    local min = axis:dot(self.vertex[1])
    local max = axis:dot(self.vertex[1])

    for i,v in ipairs(self.vertex) do

        local p = axis:dot(v)
        
        if p:inferior(min) then 
            min = p
        end

        if not p:inferior(max) then
            max = p
        end

    end

    return Projection:new(min, max)
end

function Shape:draw()
    love.graphics.polygon("line", self.points)
end