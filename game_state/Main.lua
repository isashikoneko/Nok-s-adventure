require("../engine/Graphics/Button")
require("../engine/Graphics/Camera")
require("../engine/Graphics/Text")

Main = {
    buttons = {},
    background = nil,
    camera = nil,
    windows_w = 500,
    windows_h = 350,
    title = nil
}

Main.__index = Main

function Main:new()
    local this = setmetatable({}, self)

    this.camera = Camera:new()

    this.background = nil

    this.title = Text:newWithFont("RESCUE A NOK'S ADVENTURE", "assets/Font/CFIRobotRegular.ttf", 30)

    local w = 50
    local h = 20
    local x = 225
    local y = 150

    if this.background ~= nil then
        this.windows_w = this.background:getWidth()
        this.windows_h = this.background:getHeight()
    end

    this.camera:zoom(this.windows_w / love.graphics.getWidth(), this.windows_h / love.graphics.getHeight())

    local game_content = {
        text = "PLAY",
        w = w,
        h = h
    }

    local quit_content = {
        text = "QUIT",
        w = w,
        h = h
    }

    table.insert(this.buttons, Button:new("", x, y, game_content))
    table.insert(this.buttons, Button:new("", x, y + 80, quit_content))

    return this
end

function Main:update(dt)

    if self.buttons[2]:update(dt, self.camera) then
        love.event.push("quit")
    elseif self.buttons[1]:update(dt, self.camera) then
        return false
    end

    return true

end

function Main:draw()

    self.camera:set()

    if self.background ~= nil then 
        love.graphics.draw(self.background, 0, 0)
    else
        self.title:draw(40, 50)
    end

    for i,v in ipairs(self.buttons) do
        v:draw()
    end

    self.camera:unset()

end