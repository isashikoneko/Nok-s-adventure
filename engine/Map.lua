require('../engine/Graphics/Shape')
require('../engine/Math/Point')
require('../engine/Object/Tree')

Map = {
  bloc = {},
  Character_init_x = 1200,
  Character_init_y = 800
}

Map.__index = Map

function Map:new(world)
  local this = setmetatable({}, self)
  
  this:generateMap(world)
  
  return this
end

function Map:generateMap(world)
  
  local x = 0
  local y = 500
  
  --local shape = self:getRectangle(-20, 0, 20, 500, 0)
  --self:addShape(world, shape)
  
  for i = 0, 5 do
    local tree = Tree:new(world, x, y)
    self:addShape(world, tree.box_collision)
    x = x + 400
  end
    
end

function Map:addShape(world, shape)
  
  table.insert(self.bloc, shape)
  world:addBody("static", shape, "")
  
end

function Map:getRectangle(x, y, long, larg, angle)
  
  local p1 = Point:new(0, 0)
  local p2 = Point:new(long, 0)
  local p3 = Point:new(0, larg)
  local p4 = Point:new(long, larg)
  
  return Shape:new(x, y, {p1, p2, p4, p3})
    
end

function Map:draw()
  
  for i, v in ipairs(self.bloc) do
    
    v:draw()
    
  end
  
end
