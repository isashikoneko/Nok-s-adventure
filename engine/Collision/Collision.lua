require("../engine/Math/Projection")
require("../engine/Math/Point")
require("../engine/Math/Vector2")
require("../engine/Graphics/Shape")

Collision = {
    a = nil,
    b = nil,
    axis = {}
}

Collision.__index = Collision

function Collision:new()
    local this = setmetatable({}, self)


    return this
end

local function getAxis(vertex)

    local axis = {}

    for i = 1, #vertex do

        local p1 = vertex[i]
        local p2 = vertex[i + 1] or vertex[1]

        local edge = Vector2:new(p1, p2)

        --print(edge:getString())

        local normal = edge:getNormal()

        normal:normalize()

        axis[#axis + 1] = normal

    end

    --print()

    return axis

end

local function project(vertex, axis)
    -- body
    local min = axis:dot(vertex[1])
    local max = min 

    for i = 1, #vertex do

        local proj = axis:dot(vertex[i])

        if proj < min then min = proj end
        if proj > max then max = proj end

    end

    return min, max

end

function Collision:SAT(poly1, poly2)
    
    --print("polygone 1")
    self.axis = getAxis(poly1.vertex)
    --print("polygone 2")
    local axis2 = getAxis(poly2.vertex)

    local overlap = 9999999999
    local min_axis_penetration = nil
    
    for i = 1, #axis2 do
        self.axis[#self.axis + 1] = axis2[i]
    end

    for i = 1, #self.axis do

        local axis = self.axis[i]
        local min1, max1 = project(poly1.vertex, axis)
        local min2, max2 = project(poly2.vertex, axis)

        --print("polygone 1 : " .. min1 .. ", " .. max1)
        --print("polygone 2 : " .. min2 .. ", " .. max2)

        if max2 < min1 or max1 < min2 then 
            return nil 
        end

        local o = math.min( max1, max2 ) - math.max( min1, min2 )

        if overlap > o then
            overlap = o 
            min_axis_penetration = axis
        end

    end

    --print("min axis penetration = " .. min_axis_penetration:getString() .. " and overlap = " .. overlap)

    return min_axis_penetration, overlap
    
end

