
Tag = {
    name = "",
    attr = {},
    child = {},
    parent = nil
}

Tag.__index = Tag

function Tag:new()
    local this = setmetatable({}, self)

    return this
end

function Tag:equals(tag)

    if self.name ~= tag.name then 
        return false 
    else
        for i,v in pairs(self.attr) do
            if tag.attr[i] == nil then
                return false
            else
                if tag.attr[i] ~= v then
                    return false 
                end
            end
        end
    end

    return self.parent:equals(tag.parent)
        
end