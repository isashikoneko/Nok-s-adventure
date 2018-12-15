

Stats = {
    atk = 0,
    def = 0,
    spd = 0,
    mp = 0,
    hp = 0,
    exp = 0,
    total_exp = 0,
    current_level = nil
}

Stats.__index = Stats

function Stats:new(level0)
    local this = setmetatable({}, self)

    this.atk = level0.atk
    this.def = level0.def
    this.spd = level0.spd
    this.mp = level0.mp
    this.hp = level0.hp
    this.current_level = level0
    this.exp = 0
    this.total_exp = 0

    return this
end

function Stats:gainExp(exp)
    self.exp = self.exp + exp

    self.total_exp = self.total_exp + exp

    if self.exp >= self.current_level.exp then 
        self.exp = self.exp - self.current_level.next_exp
        return true
    else
        return false
    end

end

function Stats:changeStats(level)

    self.atk = self.atk + level.atk
    self.def = self.def + level.def
    self.spd = self.spd + level.spd
    self.mp = self.mp + level.mp
    self.hp = self.hp + level.hp
    self.current_level = level

end