require("../engine/Graphics/Button")
require("../engine/Graphics/Camera")
require("../engine/Graphics/Text")

Levels = {
    buttons = {},
    background = nil,
    camera = nil,
    windows_w = 500,
    windows_h = 350,
    title = nil,
    back = nil,
    current_level = 1
}

Levels.__index = Levels

NB_LEVEL = 5

function Levels:new()
    local this = setmetatable({}, self)

    this.camera = Camera:new()

    this.background = nil

    this.title = Text:new("Select a level", 30)

    local w = 50
    local h = 20
    local x = 225
    local y = 100

    if this.background ~= nil then
        this.windows_w = this.background:getWidth()
        this.windows_h = this.background:getHeight()
    end

    this.camera:zoom(this.windows_w / love.graphics.getWidth(), this.windows_h / love.graphics.getHeight())    

    local back_content = {
        text = "Back",
        w = w,
        h = h
    }

    for i=1,NB_LEVEL do
        local level = {
            text = "LEVEL " .. i,
            w = w,
            h = h
        }

        table.insert(this.buttons, Button:new("", x, y + (i - 1) * 40, level))
    end

    this.buttons[NB_LEVEL + 1] = Button:new("", 420, 300, back_content)

    local l = love.filesystem.read("Data/level.cpk")

    l = tonumber(l)

    if l ~= NB_LEVEL then
        this.current_level = math.mod(l, NB_LEVEL)
    else
        this.current_level = NB_LEVEL
    end

    return this
end

function Levels:update(dt)

    if self.buttons[NB_LEVEL + 1]:update(dt, self.camera) then
        return true, "main"
    end

    for i=1,self.current_level do
        if self.buttons[i]:update(dt, self.camera) then
            return false, i
        end
    end

    return true

end

function Levels:draw()

    self.camera:set()

    if self.background ~= nil then 
        love.graphics.draw(self.background, 0, 0)
    else
        self.title:draw(190, 20)
    end

    for i,v in ipairs(self.buttons) do

        --[[ if i > self.current_level then
            love.graphics.setColor(200, 200, 200, 200)
        else
            love.graphics.setColor(255, 255, 255, 255)
        end ]]

        v:draw()    
    end

    self.camera:unset()

end