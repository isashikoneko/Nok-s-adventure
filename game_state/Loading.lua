require("../engine/Graphics/Text")

Loading = {
    text = nil,
    timer = 0,
    interval_time = 0.2,
    point = 0,
    windows_w = 500,
    windows_h = 350,
    fps = 20
}

Loading.__index = Loading

function Loading:new()
    local this = setmetatable({}, self)

    this.camera = Camera:new()

    this.text = Text:new("Loading ", 400, 320, 12)

    this.camera:zoom(this.windows_w / love.graphics.getWidth(), this.windows_h / love.graphics.getHeight())

    return this
end

function Loading:update(dt)

    --[[ if self.timer > self.interval_time then
        
        self.point = self.point + 1

        if self.point > 3 then

            self.text.text = "Loading"
            self.point = 0

        else

            self.text.text = self.text.text .. "."

        end

    end

    self.timer = self.timer + dt ]]

end

function Loading:draw()

    print("loading")

    if self.timer > self.interval_time then
        
        self.point = self.point + 1

        if self.point > 3 then

            self.text.text = "Loading"
            self.point = 0

        else

            self.text.text = self.text.text .. "."

        end

    end

    self.timer = self.timer + 1 / self.fps

    self.camera:set()

    self.text:draw()

    self.camera:unset()
    
end