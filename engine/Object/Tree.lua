require('../engine/Graphics/Shape')

Tree = {
  box_collision = nil,
  x = 0,
  y = 0
}

Tree.__index = Tree

TREE_WIDTH = 100
TREE_HEIGHT = 100

function Tree:new(world, x, y)
  local this = setmetatable({}, self)
  
  this.x = x
  this.y = y
  
  this.box_collision = Shape:new(this.x, this.y, {Point:new(0, 0), Point:new(TREE_WIDTH, 0), Point:new(TREE_WIDTH, TREE_HEIGHT), Point:new(0, TREE_HEIGHT)})
  
  return this
end

function Tree:draw()
  
  love.graphics.setColor(0, 255, 0, 255)
  
  self.box_collision:draw()
  
  love.graphics.setColor(255, 255, 255, 255)
  
end