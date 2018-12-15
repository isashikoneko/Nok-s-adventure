require('../engine/Graphics/Shape')
require("../engine/XmlReader/XmlReader")

Sprites = {
  texture = nil,
  animation = {},
  sprite = {},
  sprite_box = {},
  current_animation = "",
  current_sprite = 0,
  current_quad = nil,
  frame_rate = 0,
  x = 0,
  y = 0
}

Sprites.__index = Sprites

function Sprites:new(xmlfile, img, init_animation, x, y)
  local this = setmetatable({}, self)

  local xml = XmlReader:new(xmlfile)
  
  local sprite_map = xml.tree[1]
  
  this.texture = love.graphics.newImage(img)
  
  local sprites = sprite_map.Sprites.Sprite

  --print(#sprites)
  
  for i, v in ipairs(sprites) do
    
    local x = tonumber(v.Coordinates[1].X.value)
    local y = tonumber(v.Coordinates[1].Y.value)
    local w = tonumber(v.Coordinates[1].Width.value)
    local h = tonumber(v.Coordinates[1].Height.value)

    this.sprite[v.attr.Id] = {x = x, y = y, w = w, h = h}
    
  end
  
  local animations = sprite_map.Animations.Animation
  
  for i, v in pairs(animations) do
    this.animation[v.attr.Name] = {}
    --print("Animation : " .. v.attr.Name)
    
    local frames = v.Frames[1].Frame
    
    for j, val in ipairs(frames) do
      table.insert(this.animation[v.attr.Name], this.sprite[val.attr.SpriteId])
    end
    
  end

  --[[ for i, v in pairs(this.animation) do
    print(i)

    for j, val in pairs(v) do
      print(j)
    end

  end ]]

  this.current_animation = init_animation
  this.current_sprite = 1

  this:setPosition(x, y)
  
  this:setQuad()
  
  return this
end

function Sprites:setPosition(x, y)
  self.x = x
  self.y = y
end

function Sprites:setQuad()
  --print(self.current_sprite)
  --print(self.current_animation)
  self.current_quad = love.graphics.newQuad(self.animation[self.current_animation][self.current_sprite].x, self.animation[self.current_animation][self.current_sprite].y, self.animation[self.current_animation][self.current_sprite].w, self.animation[self.current_animation][self.current_sprite].h, self.texture:getDimensions())
  self.sprite_box = Shape:new(self.x, self.y, {Point:new(0, 0), Point:new(self.animation[self.current_animation][self.current_sprite].w, 0), Point:new(self.animation[self.current_animation][self.current_sprite].w, self.animation[self.current_animation][self.current_sprite].h), Point:new(0, self.animation[self.current_animation][self.current_sprite].h)})
  
  --print("current sprite id : " .. self.current_sprite)
  --print("current animation name : " .. self.current_animation)
  --print("w = " .. self.animation[self.current_animation][self.current_sprite].w .. " and h = " .. self.animation[self.current_animation][self.current_sprite].h)
end

function Sprites:changeAnimation(animation)
  self.current_animation = animation
  self.current_sprite = 1
  self:setQuad()
end

function Sprites:update(dt, frame)

  if self.frame_rate > frame then 

    self.current_sprite = self.current_sprite + 1

    if self.current_sprite > #self.animation[self.current_animation] then 
      self.current_sprite = 1
    end

    self:setQuad()

    self.frame_rate = 0
    
  end

  self.frame_rate = self.frame_rate + dt

end

function Sprites:draw()
  
  love.graphics.draw(self.texture, self.current_quad, self.x, self.y - self.animation[self.current_animation][self.current_sprite].h)
  
end
