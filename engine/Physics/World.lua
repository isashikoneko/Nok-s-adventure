require("../engine/Collision/Collision")
require("../engine/Scripts/Agent")

--Initialize the world object
World = {
  unit = 1,
  gx = 0,
  gy = 0,
  static_body = {},
  dynam_body = {},
  particle_body = {},
  collisionMgr = nil
}

--Declaration of the global world viariable
SPACE_BOX_W = 200
SPACE_BOX_H = 200

World.__index = World

--function constructor for initialization of all object parameter
function World:new(gravity_x, gravity_y, unit)
  local this = setmetatable({}, self)
  
  this.unit = unit
  this.gx = gravity_x
  this.gy = gravity_y
  this.collisionMgr = Collision:new()
  this.static_body = {}
  this.dynam_body = {}
  this.particle_body = {}
  
  return this
end


--function to add a new body in the world
function World:addBody(nature, body, body_name)
  
  if nature == "static" then
    table.insert(self.static_body, body)
    return #self.static_body
  elseif nature == "particle" then
    table.insert(self.particle_body, body)
    return #self.particle_body
  else
    self.dynam_body[body_name] = body
    return body_name
  end
  
end


--function to remove a specific body from this world
function World:removeBody(nature, index)
  if nature == "static" then
    table.remove(self.static_body, index)
    return #self.static_body
  elseif nature == "particle" then
    table.remove(self.particle_body, index)
    return #self.particle_body
  else
    self.dynam_body[index] = nil
    return index
  end
end

function World:replaceBody(body, body_name)

  self.dynam_body[body_name] = body 

end

--function to update the world property
function World:update(dt)
  
  for i, v in pairs(self.dynam_body) do
    
    self:applyForce(self.gx, self.gy, dt, i)
    
  end
  
  for i, v in ipairs(self.particle_body) do
    
    self:applyParticleForce(self.gx, self.gy, dt, i)
    
  end
  
end


--function to detect and get all object around a specific body
function World:detectCollisionSpace(body, name)
  
  local collider = {}
  
  for i, v in ipairs(self.static_body) do
    
    if ((v.x > body.x - SPACE_BOX_W and v.x < body.x + body.w + SPACE_BOX_W) or (v.x + v.w > body.x - SPACE_BOX_W and v.x + v.w < body.x + body.w + SPACE_BOX_W)) and ((v.y > body.y - SPACE_BOX_H and v.y < body.y + body.h + SPACE_BOX_H) or (v.y + v.h > body.y - SPACE_BOX_H and v.y + v.h < body.y + body.h + SPACE_BOX_H)) then
      table.insert(collider, v)
    end
    
  end
  
  --print(name)
  
  for i, v in pairs(self.dynam_body) do
    
    if ((v.x > body.x - SPACE_BOX_W and v.x < body.x + body.w + SPACE_BOX_W) or (v.x + v.w > body.x - SPACE_BOX_W and v.x + v.w < body.x + body.w + SPACE_BOX_W)) and ((v.y > body.y - SPACE_BOX_H and v.y < body.y + body.h + SPACE_BOX_H) or (v.y + v.h > body.y - SPACE_BOX_H and v.y + v.h < body.y + body.h + SPACE_BOX_H)) and i ~= name then
      table.insert(collider, v)
    end
    
  end
  
  return collider
  
end


--function to apply a translation force on a specific body with collision avoid
function World:applyForce(fx, fy, dt, body_name)
  
  self.dynam_body[body_name]:moveX(fx * dt)
  self.dynam_body[body_name]:moveY(fy * dt)
  
  --make first phase of collision detection
  local collider = self:detectCollisionSpace(self.dynam_body[body_name], body_name)
  
  for i, v in ipairs(collider) do
    
    local min_vector, overlap = self.collisionMgr:SAT(self.dynam_body[body_name], v)
  
    if min_vector ~= nil then
      --print("shape x = " .. self.dynam_body[body_name].x .. " et y = " .. self.dynam_body[body_name].y .. " collision with " .. i .. " (" .. v.x .. ", " .. v.y ..") and w=" .. v.w .. " and h=" .. v.h .. " min vector penetration = " .. min_vector:getString() .. " and overlap = " .. overlap)
      min_vector:mul(-overlap)

      self.dynam_body[body_name]:translate(min_vector)
      
      local min_v, over = self.collisionMgr:SAT(self.dynam_body[body_name], v)
      
      if min_v ~= nil and over ~= 0 then
        min_vector:mul(-2)
        self.dynam_body[body_name]:translate(min_vector)
      end
      
      return true
      
    end
    
  end
  
  return false
  
end


--function to apply a translation force on a particle with collision avoid
function World:applyParticleForce(fx, fy, dt, i)
  
  self.particle_body[i]:moveX(fx * dt)
  self.particle_body[i]:moveY(fy * dt)
  
  --make first phase of collision detection
  local collider = self:detectCollisionSpace(self.particle_body[i])
  
  for u, v in ipairs(collider) do
    
    local min_vector, overlap = self.collisionMgr:SAT(self.particle_body[i], v)
  
    if min_vector ~= nil then
      --print("shape x = " .. self.dynam_body[body_name].x .. " et y = " .. self.dynam_body[body_name].y .. " collision with " .. i .. " (" .. v.x .. ", " .. v.y ..") and w=" .. v.w .. " and h=" .. v.h .. " min vector penetration = " .. min_vector:getString() .. " and overlap = " .. overlap)
      
      --print("particle " .. i .. " sur " .. #self.particle_body)
      min_vector:mul(-overlap)

      self.particle_body[i]:translate(min_vector)
      
      local min_v, over = self.collisionMgr:SAT(self.particle_body[i], v)
      
      if min_v ~= nil and over ~= 0 then
        min_vector:mul(-2)
        self.particle_body[i]:translate(min_vector)
      end
      
    end
    
  end
  
end


--function to detect and get a specific body around a other specific body
function World:detectBody(body_name, target_name, rayon)
  
  local target = self.dynam_body[target_name]
  local body = self.dynam_body[body_name]
  
  if target ~= nil then
    self.dynam_body[body_name]:getGravity()
    for i = 1, #target.vertex do
      
      local distance = body.center:getDistance(target.vertex[i])
      local boolean = distance <= rayon
      if boolean then
        return boolean
      end
      
    end
  end

  return false
  
end

function World:detectAllBody(zone)

  local all = {}

  for i,target in pairs(self.dynam_body) do

    local min_vector = self.collisionMgr:SAT(zone, target)
  
    if min_vector ~= nil then
      
      table.insert( all, i )
      
    end

  end

  return all

end

function World:detectCollisionWith(body_name, target_name)
  
  local target = self.dynam_body[target_name]
  local body = self.dynam_body[body_name]
  
  local min_vector = self.collisionMgr:SAT(body, target)
  
  if min_vector ~= nil then
    
    return true
    
  end
  
  return false
  
end

--function to find a path from a body to another without touch any other body
function World:findPath(body_name, target_name)
  
  self.dynam_body[body_name]:getGravity()
  self.dynam_body[target_name]:getGravity()
  local init = self.dynam_body[body_name].center
  local goal = self.dynam_body[target_name].center
  
  local agent = Agent:new()
  
  --print("init : " .. init:toString() .. " and goal : " .. goal:toString())
  
  return agent:greedySearch(init, goal, 10, 10)
  
end


