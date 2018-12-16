require("engine/Graphics/Text")
require("engine/Graphics/Camera")

Story = {
    text = nil,
    camera = nil,
    sentences = {},
    current_sentence = "",
    timer = 0,
    interval_timer = 0.05,
    n = 1,
    index = 1,
    x_limit = 300,
    x = 50,
    y = 100,
    windows_w = 500,
    windows_h = 350,
    title = nil,
    skip = nil,
    line = "",
    text_line = nil,
    end_text = false
}

Story.__index = Story

function Story:new(level)
    local this = setmetatable({}, self)

    this.camera = Camera:new()
    this.camera:zoom(this.windows_w / love.graphics.getWidth(), this.windows_h / love.graphics.getHeight())
    this.text = Text:newWithFont("", "assets/Font/robotech.ttf", 10)

    this.title = Text:new("Story", 30)

    this.sentences = require("Data/level")
    this.sentences = this.sentences[level]

    local w = 50
    local h = 20

    local back_content = {
        text = "Skip",
        w = w,
        h = h
    }

    this.skip = Button:new("", 420, 300, back_content)

    this.line = ""
    this.text_line = Text:new(this.line, 10)

    return this
end 

function Story:update(dt)

    if self.timer > self.interval_timer then

        if self.end_text == true then
            return false, r
        end

        if self.x_limit < self.text_line:getLength() then
            self.current_sentence = self.current_sentence .. "\n"
            self.line = ""
            self.text_line:setText("")
        end

        if self.index > string.len( self.sentences[self.n] ) then
            self.n = self.n + 1

            if self.n > #self.sentences then 
                self.end_text = true
                self.interval_timer = 1
            else
                self.index = 0
                self.current_sentence = self.current_sentence .. "\n" .. string.sub(self.sentences[self.n], self.index, self.index)
                self.line = string.sub(self.sentences[self.n], self.index, self.index)
            end

        elseif self.index == string.len( self.sentences[self.n] ) then
            self.current_sentence = self.current_sentence .. string.sub(self.sentences[self.n], self.index)
            self.line = self.line .. string.sub(self.sentences[self.n], self.index)
        else
            self.current_sentence = self.current_sentence .. string.sub(self.sentences[self.n], self.index, self.index)
            self.line = self.line .. string.sub(self.sentences[self.n], self.index, self.index)
        end

        --print(self.current_sentence, self.index)

        self.text:setText(self.current_sentence)
        self.text_line:setText(self.line)

        self.index = self.index + 1

        self.timer = 0

    end

    self.timer = self.timer + dt

    if self.skip:update(dt, self.camera) then
        return false
    end

    return true

end

function Story:draw()

    self.camera:set()

    self.title:draw(10, 20)

    self.text:draw(self.x, self.y)

    self.skip:draw()

    self.camera:unset()

end