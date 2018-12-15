require("../engine/XmlReader/Tag")

Tree = {
    root = {},
    tag_list = {}
}

Tree.__index = Tree

function Tree:new()
    local this = setmetatable({}, self)

    print("hello")

    this.root = "hello"
    this.tag_list = {}

    return this
end

function Tree:addTag(tag)

    table.insert(self.tag_list, tag)

end

function Tree:addChild(parent, child)

    for i,v in ipairs(self.tag_list) do
        if v.name == parent then 
            v[child.name] = {}
            table.insert(v[child.name], child)
            break
        end
    end

end

