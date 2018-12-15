require("../engine/Player")
require("../engine/Physics/World")
require("../engine/Graphics/Camera")
require("../engine/Map")
require("../engine/Scripts/Enemy")
require("../engine/FightSystem")

Game = {
    world = nil,
    player = nil,
    enemy = {},
    camera = nil,
    map = nil,
    fightSystem = nil
}

windows_width = 1200
windows_height = 720

player_init_x = 0
player_init_y = 0

Game.__index = Game

function Game:new()
    local this = setmetatable({}, self)

    player_init_x = windows_width / 2
    player_init_y = windows_height / 2

    this:load()

    return this
end

function Game:load()

    self.world = World:new(0, 0, 0)
    self.camera = Camera:new()
    self.map = Map:new(self.world)
    self.fightSystem = FightSystem:new()
    --self.player = Player:new(self.world, player_init_x, player_init_y)

    self.camera:zoom(windows_width / love.graphics.getWidth(), windows_height / love.graphics.getHeight())
    --self.fightSystem:addCharacter(self.player)

end

function Game:disposeEnemy(nb)

    for i=1,nb do
        self.enemy["Enemy_" .. i] = Enemy:new(self.world, 100, 100, "Enemy_"..i, 150)
        self.fightSystem:addCharacter(self.enemy["Enemy_"..i])
    end

end

function Game:update(dt)

    --self.player:update(self.world, self.fightSystem, self.camera, dt)

    for i, v in pairs(self.enemy) do
        v:update(self.world, self.fightSystem, dt)
    end

    local name = self.fightSystem:update()

    if name == self.player.character.name then 
        self.player:die(self.world, self.fightSystem)
        print("Game Over")
        return false
    elseif name ~= "" then

        for i, v in pairs(self.enemy) do
            if name == i then
                v:die(self.world, self.fightSystem)
                table.remove( self.enemy, name )
                break
            end
        end

    end
    
    self.world:update(dt)
    
    return true

end

function Game:draw()

    self.camera:set()

    self.map:draw()

    for i,v in ipairs(self.enemy) do
        v:draw()
    end

    --self.player:draw()

    self.camera:unset()

end