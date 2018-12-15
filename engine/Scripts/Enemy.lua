require('../engine/Character')
require("../engine/Hub")

Enemy = {
  character = nil,
  state = "none",
  attack_time = 0,
  patrol_time = 0,
  alert_time = 0,
  search_time = 0,
  path = {},
  current_path = nil,
  attack_field = 100,
  speed = 300,
  sprite = nil,
  direction = "Forward",
  hub = nil,
  stats = nil
}

Enemy.__index = Enemy

ENEMY_PATROL = "patrol"
ENEMY_ALERT = "alert"
ENEMY_ATTACK = "attack"

ENEMY_PATROL_TIME = 0.3

ENEMY_ALERT_TIME = 10

ENEMY_ATTACK_TIME = 5
ENEMY_SEARCH_TIME = 1

ENEMY_LEVEL = {atk = 15, def = 5, spd = 200, mp = 20, hp = 20, exp = 500}

function Enemy:new(world, x, y, name, speed)
  local this = setmetatable({}, self)

  this.stats = Stats:new(ENEMY_LEVEL)
  
  this.speed = speed
  this.sprite = Sprites:new("assets/graphics/Spritesheet/Wizoob.xml", "assets/graphics/Spritesheet/Wizoob_r.png", this.direction, x, y)
  this.character = Character:newFromSprite(world, x, y, name, this.speed, this.sprite)
  this.state = ENEMY_PATROL
  this.path = {}
  this.hub = Hub:new(this.stats.hp, this.character.w)
  
  return this
end

function Enemy:lookForPlayer(world)
  
  local result = world:detectBody(self.character.name, "player", 500)
  
  if result == true then
    
    print(self.character.name .. " detect player")
    
    self.state = ENEMY_ALERT
    self.alert_time = 0
    
  end
  
end

function Enemy:findPlayer(world, dt)
  
  self.path = world:findPath(self.character.name, "player")
  
  local result = world:detectBody(self.character.name, "player", self.attack_field)
  
  if result == true then
    print(self.character.name .. " find player and attack")
    self.state = ENEMY_ATTACK
    self.attack_time = 0
  end
  
end

function Enemy:goToPlayer(world, dt)
  
  if #self.path ~= 0 then
    local boolean = self:goTo(self.path[#self.path], world, dt)
    
    --print("the point to go to : ")
    --print(self.path[#self.path]:toString())
  
    if boolean then
      local p = table.remove(self.path)
      --print("the point reached : ")
      --print(p:toString())
    end
  end
  
end

function Enemy:attack(world)
  
  local result = world:detectBody(self.character.name, "player", self.attack_field)
  
  if result == false then
    print(self.character.name .. " follow player")
    self.state = ENEMY_ALERT
    self.search_time = 0
  end
  
end

function Enemy:die(world, fightSystem)
  
  world:removeBody("dynamic", self.character.name)
  fightSystem:removeCharacter(self.character.name)

  return self.character.name
  
end

function Enemy:update(world, fightSystem, dt)
  
  if self.state == ENEMY_PATROL then

    if self.patrol_time > ENEMY_PATROL_TIME then
      self:lookForPlayer(world)
      self.patrol_time = 0
    end
    
    self.patrol_time = self.patrol_time + dt
    
  elseif self.state == ENEMY_ALERT then
    
    if self.search_time > ENEMY_SEARCH_TIME then
      self:findPlayer(world, dt)
      self.search_time = 0
    end
    
    self:goToPlayer(world, dt)
    
    self.search_time = self.search_time + dt
    
    self.alert_time = self.alert_time + dt
    
    if self.alert_time > ENEMY_ALERT_TIME then
      self.state = ENEMY_PATROL
    end
    
  elseif self.state == ENEMY_ATTACK then
    
    if self.attack_time > ENEMY_ATTACK_TIME then
      fightSystem:attack(self.character.name, "player")
      self:attack(world)
      self.attack_time = 0
    end
    self.attack_time = self.attack_time + dt
    
  end

  self.character:update(world, dt)
  
end

function Enemy:goTo(point, world, dt)
  
  local x = false
  local y = false
  
  local dist_x = math.abs(self.character.box_collision.x - point.x - 10)
  
  if dist_x < self.character.character_speed * dt then
    self.character.character_speed = dist_x / dt
  end
  
  if self.character.box_collision.x < point.x - 10 then

    if self.direction ~= "Right" then
      self.direction = "Right"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveRight(world, dt, nil)
  elseif self.character.box_collision.x > point.x + 10 then

    if self.direction ~= "Left" then
      self.direction = "Left"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveLeft(world, dt, nil)
  else
    x = true
  end
  
  if self.character.character_speed ~= self.speed then
    self.character.character_speed = self.speed
  end
  
  local dist_y = math.abs(self.character.box_collision.y - point.y - 10)
  
  if dist_y < self.character.character_speed * dt then
    self.character.character_speed = dist_y / dt
  end
  
  if self.character.box_collision.y < point.y - 10 then

    if self.direction ~= "Forward" then
      self.direction = "Forward"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveDown(world, dt, nil)
  elseif self.character.box_collision.y > point.y + 10 then

    if self.direction ~= "Back" then
      self.direction = "Back"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveUp(world, dt, nil)
  else
    y = true
  end
  
  if self.character.character_speed ~= self.speed then
    self.character.character_speed = self.speed
  end
  
  return x and y
  
end

function Enemy:draw()
  
  love.graphics.setColor(255, 0, 0, 255)
  self.character:draw()
  self.hub:draw(self.character:getX(), self.character:getY() - self.character.box_collision.h)
  love.graphics.setColor(255, 255, 255, 255)
  
end
