require("../engine/XmlReader/Tag")
require("../engine/XmlReader/Tree")

XmlReader = {
    tree = {},
    child_tab = {},
    root = {}
}

XmlReader.__index = XmlReader

function XmlReader:new(file)
    -- body
    local this = setmetatable({}, self)

    io.open(file)

    self:getTags(file)
    self:dispose()

    return this
end

function XmlReader:getTags(file)
    local parent_t = {}
    parent_t[1] = "root"
    local first_tag = true
    for line in io.lines(file) do

        local comment_line = string.find( line,"<!" )
        local xml_dec = string.find( line,"?>" )

        if xml_dec == nil and comment_line == nil then 

            local name = ""
            local attr = {}
            local parent
            local type = ""

            --print(" ")
            --print("Tag : ")

            local end_tag = string.find( line,"</" )

            if end_tag == nil then

                local start_tag = string.find( line,"<" )

                if end_tag ~= start_tag then

                    local start_tag_i = start_tag + 1
                    local end_tag_i = string.find( line, ">", start_tag_i )

                    local start_tag_attr_i = string.find( line, " ", start_tag_i )

                    if start_tag_attr_i ~= nil then
                        name = string.sub( line, start_tag_i, start_tag_attr_i - 1 )

                        while start_tag_attr_i ~= nil do

                            start_tag_attr_i = start_tag_attr_i + 1
                            
                            end_tag_attr_i = string.find( line, " ", start_tag_attr_i )
        
                            if end_tag_attr_i == nil then
                                end_tag_attr_i = string.find( line, ">", start_tag_attr_i ) or string.find( line, " />", start_tag_attr_i )
                                if end_tag_attr_i == nil then
                                    break
                                end
                            end

                            --end_tag_attr_i = string.find( line, " ", start_tag_attr_i )

                            local egal_attr_i = string.find( line, "=", start_tag_attr_i, end_tag_attr_i )
                        
                            if egal_attr_i ~= nil then 
        
                                local attrib = {}

                                attrib["name"] = string.sub( line, start_tag_attr_i, egal_attr_i - 1 )

                                if start_tag_attr_i < end_tag_attr_i then
                                    attrib["value"] = string.sub( line, egal_attr_i + 2, end_tag_attr_i - 2 )
                                else
                                    attrib["value"] = string.sub( line, egal_attr_i + 2, end_tag_i - 2 )
                                end
        
                                attr[attrib.name] = attrib.value
                                --print("Attribut : " .. attrib.name .. " = " .. attr[attrib.name])
        
                            end

                            start_tag_attr_i = end_tag_attr_i
        
                        end

                    else
                        name = string.sub( line, start_tag_i, end_tag_i - 1 )
                    end

                    parent = parent_t[#parent_t]

                    if string.find( line, " />" ) == nil then

                        --print("add parent " .. name)
    
                        table.insert( parent_t, name )
                        --print("parent number: " .. #parent_t)
                        type = "open"

                    else
                        type = "single"
                    end

                    local tag = {}
                    tag.parent = parent 
                    tag.name = name 
                    tag.attr = attr
                    tag.type = type

                    --print("Parent : " .. parent)
                    --print("Name : " .. tag.name)

                    --print("")

                    table.insert( self.tree, tag )

                end

            else

                local start_tag = string.find( line,"<" )

                if start_tag ~= end_tag then
                    
                    local end_tag_i = string.find( line,">" )

                    name = string.sub( line, start_tag + 1, end_tag_i - 1 )
    
                    child = string.sub( line, end_tag_i + 1, end_tag - 1 )
                    
                    parent = parent_t[#parent_t]

                    local tag = {}
                    tag.parent = parent 
                    tag.name = name
                    tag.value = child
                    tag.attr = attr
                    tag.type = "value"

                    table.insert( self.tree, tag )

                else

                    local end_tag_i = string.find( line,">" )

                    name = string.sub( line, start_tag + 2, end_tag_i - 1 )

                    local tag = {}
                    tag.parent = nil
                    tag.name = name
                    tag.attr = attr 
                    tag.type = "close"

                    table.insert( self.tree, tag )

                    table.remove(parent_t)
    
                end
                
            end

            --self:dispose()
        end

    end
end

--[[ function XmlReader:getTags(file)
    local parent_t = {}
    parent_t[1] = "root"
    local first_tag = true
    for line in io.lines(file) do

        local comment_line = string.find( line,"<!" )
        local xml_dec = string.find( line,"?>" )

        if xml_dec == nil and comment_line == nil then 

            local name = ""
            local attr = {}
            local parent

            --print(" ")
            --print("Tag : ")

            local end_tag = string.find( line,"</" )

            if end_tag == nil then

                local start_tag = string.find( line,"<" )

                if end_tag ~= start_tag then

                    local start_tag_i = start_tag + 1
                    local end_tag_i = string.find( line, ">", start_tag_i )

                    local start_tag_attr_i = string.find( line, " ", start_tag_i )

                    if start_tag_attr_i ~= nil then
                        name = string.sub( line, start_tag_i, start_tag_attr_i - 1 )

                        while start_tag_attr_i ~= nil do

                            start_tag_attr_i = start_tag_attr_i + 1
                            
                            end_tag_attr_i = string.find( line, " ", start_tag_attr_i )
        
                            if end_tag_attr_i == nil then
                                end_tag_attr_i = string.find( line, ">", start_tag_attr_i ) or string.find( line, " />", start_tag_attr_i )
                                if end_tag_attr_i == nil then
                                    break
                                end
                            end

                            --end_tag_attr_i = string.find( line, " ", start_tag_attr_i )

                            local egal_attr_i = string.find( line, "=", start_tag_attr_i, end_tag_attr_i )
                        
                            if egal_attr_i ~= nil then 
        
                                local attrib = {}

                                attrib["name"] = string.sub( line, start_tag_attr_i, egal_attr_i - 1 )

                                if start_tag_attr_i < end_tag_attr_i then
                                    attrib["value"] = string.sub( line, egal_attr_i + 2, end_tag_attr_i - 2 )
                                else
                                    attrib["value"] = string.sub( line, egal_attr_i + 2, end_tag_i - 2 )
                                end
        
                                attr[attrib.name] = attrib.value
                                --print("Attribut : " .. attrib.name .. " = " .. attr[attrib.name])
        
                            end

                            start_tag_attr_i = end_tag_attr_i
        
                        end

                    else
                        name = string.sub( line, start_tag_i, end_tag_i - 1 )
                    end

                    parent = parent_t[#parent_t]

                    if string.find( line, " />" ) == nil then

                        --print("add parent " .. name)
    
                        table.insert( parent_t, name )
                        --print("parent number: " .. #parent_t)
                    end

                    local tag = {}
                    tag.parent = parent 
                    tag.name = name 
                    tag.attr = attr

                    --print("Parent : " .. parent)
                    --print("Name : " .. tag.name)

                    --print("")

                    table.insert( self.tree, tag )

                end

            else

                local start_tag = string.find( line,"<" )

                if start_tag ~= end_tag then
                    
                    local end_tag_i = string.find( line,">" )

                    name = string.sub( line, start_tag + 1, end_tag_i - 1 )
    
                    child = string.sub( line, end_tag_i + 1, end_tag - 1 )
                    
                    parent = parent_t[#parent_t]

                    local tag = {}
                    tag.parent = parent 
                    tag.name = name
                    tag.value = child
                    tag.attr = attr

                    table.insert( self.tree, tag )

                else

                    table.remove(parent_t)
    
                end
                
            end

            --self:dispose()
        end

    end
end ]]

function XmlReader:dispose()

    --print("")
    self.child_tab = self.tree

    for i,v in ipairs(self.tree) do
        local child = self:getChild(i)
        --print("current element is :" .. v.name)
        --print(#child)
        --print("his children are :")
        if #child ~= 0 then

            local child_name = child[1].name

            if child_name == child[#child].name then
                --print("Same name: ")
                v[child_name] = {}
                for j, val in ipairs(child) do
                    --print(val.name)
                    table.insert(v[val.name], val)
                end
            else
                --print("Different name: ")
                for j, val in ipairs(child) do
                    --print(val.name)
                    v[val.name] = val
                end
            end

        end
    end

    self.root = self.tree[1]

    --print("")

end

--[[ function XmlReader:getChildTemplate()

    --print("")
    local child_tab = self.tree

    local tab = {}

    for i, v in ipairs(self.tree) do

        if v.type == "open" then 

            local child = {}

            print("Open tag :" .. v.name)

            for j = i + 1, #self.tree do 

                if self.tree[j].name == v.name then 

                    local child = {}

                    print("Tag at : " .. i)

                    local a = i + 1

                    local bool = true

                    while a < j - 1 do

                        if self.tree[a].type == "single" then

                            if self.tree[a + 1].name == self.tree[a].name then

                                if bool == true then
                                    child[self.tree[a].name] = {}
                                    bool = false
                                end

                                if bool == false then
                                    print("     Add child single :" .. self.tree[a].name ..  " at " .. #child[self.tree[a].name] + 1)
                                    table.insert(child[self.tree[a].name], self.tree[a])
                                end

                            else

                                bool = true
                                print("     Add child single :" .. self.tree[a].name ..  " at " .. #child + 1)
                                child[self.tree[a].name] = self.tree[a]

                            end

                        elseif self.tree[a].type == "open" then
                            local c = a
                            for b = a + 1, j - 1 do

                                if self.tree[b].name == self.tree[a].name then
                                    a = b 
                                    break 
                                end

                            end

                            if self.tree[a + 1].name == self.tree[c].name then

                                if bool == true then
                                    child[self.tree[c].name] = {}
                                    bool = false
                                end

                                if bool == false then
                                    print("     Add child open :" .. self.tree[a].name ..  " at " .. #child[self.tree[c].name] + 1)
                                    table.insert(child[self.tree[c].name], self.tree[c])
                                end

                            else

                                bool = true
                                print("     Add child open :" .. self.tree[a].name ..  " at " .. #child + 1)
                                child[self.tree[c].name] = self.tree[c]

                            end

                        end

                        a = a + 1

                    end

                    local attr = v.attr 
                    local name = v.name
                    v = child
                    v.attr = attr
                    v.name = name

                    child.attr = attr

                    table.insert( tab, v )

                    print("close tag :" .. name)

                    break

                else

                    --print("         Tag : " .. self.tree[j].name .. " not close tag of : " .. v.name)

                end

            end

        end

        if v.type == "single" or v.type == "value" then
            local child = {}
            child.attr = v.attr 
            table.insert(tab, v)
        end

    end

    self.root = self.tree[1]

    --print("")

    return tab

end ]]

function XmlReader:getChild(index)

    --print("")

    local child = {}

    if self.tree[index].type == "open" then 

        --print("Open tag :" .. self.tree[index].name)

        for j = index + 1, #self.tree do 

            if self.tree[j].name == self.tree[index].name then 

                --print("Tag at : " .. index)

                local a = index + 1

                local bool = true

                while a <= j - 1 do

                    if self.tree[a].type == "single" or self.tree[a].type == "value" then

                        table.insert(child, self.tree[a])
                        --print("single " .. child[#child].name .. " at " .. a)

                    elseif self.tree[a].type == "open" then
                        local c = a
                        for b = a + 1, j - 1 do

                            if self.tree[b].name == self.tree[a].name then
                                a = b 
                                break 
                            end

                        end

                        table.insert(child, self.tree[c])
                        --print("open " .. child[#child].name)

                    end

                    a = a + 1

                end

                --print("close tag :" .. self.tree[index].name)

                break

            end

        end

    end

    --print(#child)

    return child

end

--[[ function XmlReader:getChild(parent)
    local child = {}
    local bool = false
    for i,v in ipairs(self.child_tab) do
        if v.parent == parent then 
            table.insert(child, v)
            --table.remove( self.child_tab, i )
            --bool = true
        else
            if bool == true then
                break
            end
        end
    end

    return child

end ]]
