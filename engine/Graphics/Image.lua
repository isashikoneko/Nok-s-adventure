Image = {
    img = nil,
    x = 0,
    y = 0,
    w = 0,
    h = 0,
    r = 0,
    ox = 0,
    oy = 0
}

Image.__index = Image

function Image:new(path, x, y)
    local this = setmetable(self, {})

    this.img = love.graphics.newImage(path)
    this.x = x 
    this.y = y 
    this.w = this.img:getWidth()
    this.h = this.img:getHeight()

    return this
end

function Image:new(path, x, y, w, h)
    local this = setmetable(self, {})

    this.img = love.graphics.newImage(path)
    this.x = x 
    this.y = y 
    this.w = w 
    this.h = h 

    return this
end

function Image:new(path, x, y, w, h, r)
    local this = setmetable(self, {})

    this.img = love.graphics.newImage(path)
    this.x = x 
    this.y = y 
    this.w = w 
    this.h = h
    this.r = r 

    return this
end

function Image:new(path, x, y, w, h, r, ox, oy)
    local this = setmetable(self, {})

    this.img = love.graphics.newImage(path)
    this.x = x 
    this.y = y 
    this.w = w 
    this.h = h
    this.r = r 
    this.ox = ox 
    this.oy = oy

    return this
end

function Image:setWidth()
    self.w = w
end

function Image:setHeight(h)
    self.h = h
end

function Image:getWidth()
    return self.w
end

function Image:getHeight()
    return self.h
end

function Image:display()
    love.graphics.draw(self.img, self.x, self.y, self.r, self.w / self.img:getWidth(), self.h / self.img:getHeight(), self.ox, self.oy, 0, 0)
end
