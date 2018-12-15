Heap = {
  list = {}
}

Heap.__index = Heap

function Heap:new(value)
  local this = setmetatable({}, self)
  
  this.list = {}
  table.insert(this.list, value)
  
  return this
end

function Heap:add(value)
  
  table.insert(self.list, value)
  
end

function Heap:deleteMin()
  
  local min = 1
  
  for i = 1, #self.list do
    
    if self.list[i].heuristic < self.list[min].heuristic then
      min = i
    end
    
  end
  
  return table.remove(self.list, min)
end

function Heap:decreaseKey()
  
end

function Heap:isEmpty()
  if #self.list == 0 then return true end
  return false
end

function Heap:find(value)
  
  for i = 1, #self.list do
    
    if value:equal(self.list[i]) then
      return i
    end
    
  end
  return false

end

