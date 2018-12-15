require('../Physics/World')
require("../Graphics/Particle")
require('../Math/Vector2')

ParticleSystem = {
  particle = {},
  particle_index = {},
  center = nil,
  lifetime = 0,
  nb = 0,
  emit = false,
  emit_style = "",
  start_color = {},
  end_color = {},
  speed = 0,
  interval = 0,
  interval_time = 0,
  initial_time = 0
}

ParticleSystem.__index = ParticleSystem

function ParticleSystem:new(center, nb, lifetime, emit_style, start_color, end_color)
  local this = setmetatable({}, self)
  
  this.center = center
  
  this.lifetime = lifetime
  this.nb = nb
  this.emit = false
  this.emit_style = emit_style
  
  if this.emit_style == "explode" then
    this.interval = this.nb
  else
    this.interval = 1
  end
  
  --this.speed = speed,
  this.start_color = start_color
  this.end_color = end_color
  
  return this
end

function ParticleSystem:createParticle(world)
  table.insert(self.particle, Particle:new(self.center.x, self.center.y, self.start_color, self.end_color, self.lifetime, self.speed))
    
  i = world:addBody('particle', self.particle[#self.particle].shape, '')
  table.insert(self.particle_index, i)
end

local function getSpeed()
  
  local sign = math.random(0, 2) - 1
  
  if sign == 0 then
    sign = math.random(0, 2) - 1
  end
  
  local speed_x = 5 * math.random(1, 10) * sign
  
  local sign = math.random(0, 2) - 1
  
  if sign == 0 then
    sign = math.random(0, 2) - 1
  end
  
  local speed_y = 5 * math.random(1, 10) * sign
  
  return speed_x, speed_y
end

function ParticleSystem:start(world, interval_time)
  self.emit = true
  
  for i = 1, self.interval do
    
    local speed_x, speed_y = getSpeed()
    
    self.speed = Vector2:newFromCoord(speed_x, speed_y)
    
    self:createParticle(world)
    
  end
  
  self.initial_time = interval_time
  
  self.interval_time = interval_time
  
end

function ParticleSystem:stop()
  self.emit = false
  self.particle = {}
  self.particle_index = {}
end

function ParticleSystem:update(world, dt)
  
  local index = {}
  
  if self.emit_style ~= "explode" then
    self.interval_time = self.interval_time - dt
  
    if self.interval_time < 0 then
      
      local speed_x, speed_y = getSpeed()
      
      self.speed = Vector2:newFromCoord(speed_x, speed_y)
      
      self:createParticle(world)
      
      if #self.particle < self.nb then
        self.interval_time = self.initial_time
      else
        self.interval_time = 0
      end
      
    end
  end
  
  for i = 1, #self.particle do
    
    if not self.particle[i]:update(dt) then
      table.insert(index, i)
    end
    
    world:applyParticleForce(self.particle[i].speed.x, self.particle[i].speed.y, dt, self.particle_index[i])
    
  end
  
  for i = 1, #index do
    
    table.remove(self.particle, index[i])
    world:removeBody('particle', self.particle_index[index[i]])
    
--    if #self.particle < self.nb then
    
--      local speed_x = 10 * math.random(0, 5) * (math.random(0, 1) - 1)
--      local speed_y = -40
      
--      self.speed = Vector2:newFromCoord(speed_x, speed_y)
      
--      self:createParticle(world)
      
--    end
    
  end
  
end

function ParticleSystem:draw()
  
  for i, v in ipairs(self.particle) do
    v:draw()
  end
  
end
