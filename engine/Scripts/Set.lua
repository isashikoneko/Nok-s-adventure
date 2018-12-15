Set = {
  list = {}
}

Set.__index = Set

function Set:new()
  local this = setmetatable({}, self)
  
  this.list = {}
  
  return this
end

function Set:add(value)
  table.insert(self.list, value)
end

function Set:find(value)
  
  for i = 1, #self.list do
    
    if value:equal(self.list[i]) then
      return true
    end
    
  end
  return false

end

