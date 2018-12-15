require("../engine/Graphics/Shape")
require("../engine/Math/Point")

Character = {
  name = "",
  sprite = nil,
  box_collision = nil,
  jump_state = false,
  speed = 0,
  character_speed = 0,
  hit_box = nil,
  attack_state = false,
  attack_time = 0,
  w = 50,
  h = 50
}

Character.__index = Character

SPEED = 100
JUMP_SPEED = 200

SPEED_INTERVAL = 5
ATTACK_INTERVAL = 1

--a function constructor to initialization of character attribut
function Character:new(world, x, y, name, speed)

  local this = setmetatable({}, self)
  
  this.w = 50
  this.h = 50
  
  this.character_speed = speed
  
  x = x - this.w / 2
  y = y - this.h / 2
  
  this.box_collision = Shape:new(x, y, {Point:new(0, 0), Point:new(this.w, 0), Point:new(this.w, this.h), Point:new(0, this.h)})
  
  this.name = name
  world:addBody("dynamic", this.box_collision, this.name)
  
  this.jump_state = false
  this.speed = 0
  
  return this

end

function Character:newFromSprite(world, x, y, name, speed, sprite)

  local this = setmetatable({}, self)

  this.sprite = sprite
  
  this.character_speed = speed

  this.box_collision = this.sprite.sprite_box

  this.w = this.box_collision.w
  this.h = this.box_collision.h
  
  this.name = name
  world:addBody("dynamic", this.box_collision, this.name)
  
  this.jump_state = false
  this.speed = 0
  
  return this

end

function Character:changeBox(world, box)

  self.box_collision = box
  world:replaceBody(self.box_collision, self.name)
  self.w = self.box_collision.w 
  self.h = self.box_collision.h 

end

function Character:update(world, dt)

  self.sprite:update(dt, 0.5)
  self.sprite:setPosition(self.box_collision.x, self.box_collision.y)
  self:changeBox(world, self.sprite.sprite_box)

end

function Character:moveRight(world, dt, camera)
  if not world:applyForce(self.character_speed, 0, dt, self.name) then
    
    if camera ~= nil then
      camera:translate(-self.character_speed * dt, 0)
    end
    
  end
  
  self.sprite:setPosition(self.box_collision.x, self.box_collision.y)

end

function Character:moveLeft(world, dt, camera)
  if not world:applyForce(-self.character_speed, 0, dt, self.name) then
    if camera ~= nil then
      camera:translate(self.character_speed * dt, 0)
    end
  end
end

function Character:attack(direction, dt)
  self.attack_state = true

  if self.attack_time > ATTACK_INTERVAL then
    self.attack_time = 0
    
    if direction == "Forward" then 
      self.hit_box = Shape:new(self.box_collision.x, self.box_collision.y + self.box_collision.h, self.box_collision.w, self.box_collision.h)
    elseif direction == "Back" then
      self.hit_box = Shape:new(self.box_collision.x, self.box_collision.y - self.box_collision.h, self.box_collision.w, self.box_collision.h)
    elseif direction == "Right" then
      self.hit_box = Shape:new(self.box_collision.x + self.box_collision.w, self.box_collision.y, self.box_collision.w, self.box_collision.h)
    else
      self.hit_box = Shape:new(self.box_collision.x - self.box_collision.w, self.box_collision.y, self.box_collision.w, self.box_collision.h)
    end

    return true
  end

  self.attack_time = self.attack_time + dt
  return false
end

function Character:moveUp(world, dt, camera)
  
  if not world:applyForce(0, -self.character_speed, dt, self.name) then
    if camera ~= nil then
      camera:translate(0, self.character_speed * dt)
    end
  end

end

function Character:moveDown(world, dt, camera)
  
  if not world:applyForce(0, self.character_speed, dt, self.name) then
    if camera ~= nil then
      camera:translate(0, -self.character_speed * dt)
    end
  end
  
end

function Character:jump()
  self.jump_state = true
  self.speed = -JUMP_SPEED
end

function Character:jumping(world, dt)
  
  if self.speed < 0 then
    world:applyForce(0, self.speed, dt, self.name)
    self.speed = self.speed + SPEED_INTERVAL
  end
  
end

function Character:rotate(angle)
  
  self.box_collision:rotate(angle)
  
end

function Character:getX()
  return self.box_collision.x
end

function Character:getY()
  return self.box_collision.y
end

function Character:draw()

  self.box_collision:draw()
  
  if self.attack_state == true then
    --self.hit_box:draw()
  end

  if self.sprite ~= nil then
    self.sprite:draw()
    self.sprite.sprite_box:draw()
  end
  
end