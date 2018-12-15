Node = {
  point = nil,
  heuristic = 0,
  h = 0,
  g = 0,
  parent = nil
}

Node.__index = Node

function Node:new(parent, point, h, g)
  local this = setmetatable({}, self)
  
  this.parent = parent
  this.point = point
  this.h = h
  this.g = g
  this.heuristic = this.h + this.g
  this.children = {}
  
  return this
end

function Node:equal(node)
  
  if self.point:equal(node) then
    return true
  end
  
  return false
  
end

function Node:isGoal(goal, w, h)
  
  if self.point:isAround(goal, math.sqrt(w * w + h * h)) then
    return true
  end
  
  return false
  
end

function Node:isAGoal(w, h)
  
  if self.h < math.sqrt(w * w + h * h) then
    return true
  else
    return false
  end
  
end

function Node:getChildren(w, h)
  
  local children = {}
  
  table.insert(children, Point:new(self.point.x + w, self.point.y))
  table.insert(children, Point:new(self.point.x - w, self.point.y))
  table.insert(children, Point:new(self.point.x, self.point.y - h))
  table.insert(children, Point:new(self.point.x, self.point.y + h))
  table.insert(children, Point:new(self.point.x + w, self.point.y - h))
  table.insert(children, Point:new(self.point.x + w, self.point.y + h))
  table.insert(children, Point:new(self.point.x - w, self.point.y + h))
  table.insert(children, Point:new(self.point.x - w, self.point.y -h))
  
  return children
end

