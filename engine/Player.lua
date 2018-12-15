require('../engine/Character')
require('../engine/Hub')
require("../engine/Graphics/Sprites")
require('../engine/Stats')
require("../engine/Graphics/Shape")

Player = {
  character = nil,
  hub = nil,
  sprite = nil,
  direction = "Forward",
  stats = nil,
}

Player.__index = Player

PLAYER_SPEED = 100
PLAYER_LIFE = 200

PLAYER_LEVEL0 = {atk = 10, def = 10, spd = 100, mp = 10, hp = 30, exp = 10}
PLAYER_LEVEL1 = {atk = 15, def = 20, spd = 150, mp = 20, hp = 45, exp = 20}

function Player:new(world, init_x, init_y)
  local this = setmetatable({}, self)

  this.stats = Stats:new(PLAYER_LEVEL0)
  
  this.sprite = Sprites:new("assets/graphics/Spritesheet/Wizoob.xml", "assets/graphics/Spritesheet/Wizoob_r.png", this.direction, init_x, init_y)

  this.character = Character:newFromSprite(world, init_x, init_y, "player", this.stats.spd, this.sprite)

  this.hub = Hub:new(this.stats.hp, this.character.w)
  
  return this
end

function Player:update(world, fightSystem, camera, dt)
  
  if love.keyboard.isDown("right") then 

    if self.direction ~= "Right" then
      self.direction = "Right"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveRight(world, dt, camera)
  end

  if love.keyboard.isDown("left") then

    if self.direction ~= "Left" then
      self.direction = "Left"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveLeft(world, dt, camera)
  end

  if love.keyboard.isDown("up") then 

    if self.direction ~= "Back" then
      self.direction = "Back"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveUp(world, dt, camera)
  end
  
  if love.keyboard.isDown("down") then 

    if self.direction ~= "Forward" then
      self.direction = "Forward"
      self.character.sprite:changeAnimation(self.direction)
    end

    self.character:moveDown(world, dt, camera)
  end

  if love.keyboard.isDown("s") then
    if self.character:attack(world, dt) then
      local enemy = world:detectAllBody(self.character.hitbox)
      for i,v in ipairs(enemy) do
        if v ~= self.character.name then
          fightSystem:attack(self.character.name, v)
        end
      end
    end
  end

  self.character:update(world, dt)
    
end

function Player:die(world, fightSystem)
  -- body
  world:removeBody("dynamic", self.character.name)
  fightSystem:removeCharacter(self.character.name)

  return self.character.name
end

function Player:levelUp()
  self.stats:changeStats(level1)
end

function Player:draw()
  
  self.character:draw()
  self.hub:draw(self.character:getX(), self.character:getY() - self.character.box_collision.h)
  
end
