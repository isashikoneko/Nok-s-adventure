FightSystem = {
    character = {},
    dead = ""
}

FightSystem.__index = FightSystem

function FightSystem:new()
    local this = setmetatable({}, self)

    this.character = {}

    return this
end

function FightSystem:addCharacter(character)
    self.character[character.character.name] = character
end

function FightSystem:attack(player_name, enemy_name)
    
    if self.character[enemy_name].character.attack_state == true then 
        
    else
        self.character[enemy_name].stats.hp = self.character[enemy_name].stats.hp - self.character[player_name].stats.atk + self.character[enemy_name].stats.def
        print(player_name .. " attack " .. enemy_name)
        if self.character[enemy_name].hub:reduceLife(self.character[enemy_name].stats.hp) then 
            if self.character[player_name].stats:gainExp(self.character[enemy_name].stats.current_level.exp) then
                self.character[player_name]:levelUp()
            end
            self.dead = enemy_name
        end
    end

end

function FightSystem:update()
    local name = self.dead
    self.dead = ""
    return name
end

function FightSystem:removeCharacter(character_name)
    table.remove( self.character, character_name )
end

function FightSystem:draw()

end