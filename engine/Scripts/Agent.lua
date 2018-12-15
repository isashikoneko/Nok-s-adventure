require('../engine/Scripts/Heap')
require('../engine/Scripts/Node')
require('../engine/Scripts/Set')

Agent = {
  
}

Agent.__index = Agent

function Agent:new()
  local this = setmetatable({}, self)
  
  return this
end

function Agent:astarSearch(init, goal, w, h)
  
  local initialState = Node:new(nil, init, init:getDistance(goal), 0)
  local goalState = Node:new(nil, goal, 0, 0)
  local frontier = Heap:new(initialState)
  local explored = Set:new()
  
  print("initial state heuristic " .. self:getHeuristicF(initialState, goalState))
  
  local index = 1
  
  while not frontier:isEmpty() do
    
    print("level " .. index)
    
    print("Frontier number " .. #frontier.list)
    
    local state = frontier:deleteMin()
    
    print("Current state " .. self:getHeuristicF(state, goalState))
    
    print("Distance between current state and goal " .. state.point:getDistance(goal))
    
    if state:isAGoal(w, h) then
      break
    end
    
    explored:add(state)
    
    local children = state:getChildren(w, h)
    
    print("children number " .. #children)
    
    for i = 1, #children do
      
      local child = Node:new(state, children[i], self:getHeuristicH(children[i], goal), self:getHeuristicG(state, children[i]))
      
      print("child point : " .. child.point:toString())
      
      local node = frontier:find(child)
      if not explored:find(child) and node == false then
        frontier:add(child)
      elseif node ~= false then
        
        if child.heuristic < frontier.list[node].heuristic then
          frontier.list[node] = child
        end
        
      end
      
      print("Child heuristic " .. self:getHeuristicF(child, goalState))
      
    end
    
    print("")
    
    index = index + 1
    
  end
  
  --print(#explored.list)
  
  goalState = explored.list[#explored.list]
  local parent = goalState.parent
  
  local path = {}
  
  while parent ~= nil do
    table.insert(path, parent.point)
    parent = parent.parent
  end
  
  return path
  
end

function Agent:greedySearch(init, goal, w, h)
  
  local initialState = Node:new(nil, init, init:getDistance(goal), 0)
  local goalState = Node:new(nil, goal, 0, 0)
  local frontier = Heap:new(initialState)
  local explored = Set:new()
  
  --print("initial state heuristic " .. self:getHeuristicH(initialState.point, goal))
  
  local index = 1
  
  while not frontier:isEmpty() do
    
    --print("level " .. index)
    
    --print("Frontier number " .. #frontier.list)
    
    local state = frontier:deleteMin()
    
    --print("Current state " .. self:getHeuristicH(state.point, goal))
    
    --print("Distance between current state and goal " .. state.point:getDistance(goal))
    
    explored:add(state)
    
    if state:isGoal(goal, w, h) then
      break
    end
    
    local children = state:getChildren(w, h)
    
    --print("children number " .. #children)
    
    for i = 1, #children do
      
      local child = Node:new(state, children[i], self:getHeuristicH(children[i], goal), 0)
      
      --print("child point : " .. child.point:toString())
      
      local node = frontier:find(child)
      if not explored:find(child) and node == false then
        frontier:add(child)
      elseif node ~= false then
        
        if child.heuristic < frontier.list[node].heuristic then
          frontier.list[node] = child
        end
        
      end
      
      --print("Child heuristic " .. self:getHeuristicH(child.point, goal))
      
    end
    
    --print("")
    
    index = index + 1
    
  end
  
  --print(#explored.list)
  
  goalState = explored.list[#explored.list]
  local parent = goalState.parent
  
  local path = {}
  
  table.insert(path, goalState.point)
  
  while parent ~= nil do
    table.insert(path, parent.point)
    parent = parent.parent
  end
  
  return path
  
end

function Agent:getHeuristicG(parent, point)
  
  if parent == nil then
    return 0
  else
    return parent.g + parent.point:getDistance(point)
  end
  
end

function Agent:getHeuristicH(node, goal)
  
  return node:getDistance(goal)
  
end

function Agent:getHeuristicF(node, goal)
  
  return self:getHeuristicH(node.point, goal.point) + self:getHeuristicG(node.parent, node.point)
  
end