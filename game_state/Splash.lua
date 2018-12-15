
Splash = {
    license = {},
    current_license = 1,
    time = 0,
    interval_time = 0.5,
    camera = nil,
    windows_w = 500,
    windows_h = 350
}

Splash.__index = Splash

function Splash:new()
    local this = setmetatable({}, self)

    this.camera = Camera:new()

    this.license = {}
    this.current_license = 1

    if #this.license ~= 0 then
        this.windows_w = this.license[1]:getWidth()
        this.windows_h = this.license[1]:getHeight()
    end

    this.camera:zoom(this.windows_w / love.graphics.getWidth(), this.windows_h / love.graphics.getHeight())

    return this
end

function Splash:update(dt)

    if self.time > self.interval_time then 
        if not self:nextLicense() then
            return false 
        end
        self.time = 0
    end

    self.time = self.time + dt

    return true
end

function Splash:nextLicense()

    if self.current_license >= #self.license then
        return false
    else
        self.current_license = self.current_license + 1
        return true
    end

end

function Splash:draw()

    self.camera:set()

    if #self.license ~= 0 then
        love.graphics.draw(self.license[self.current_license], 0, 0)
    end

    self.camera:unset()

end