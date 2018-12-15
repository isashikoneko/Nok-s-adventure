
require("../game_state/Loading")

GameState = {
    current_state = 0,
    state = nil,
    loading = false,
    loading_state = nil
}

GameState.__index = GameState

SPLASH_SCREEN = 0
MAIN_MENU = 2
LEVEL_MENU = 3
GAME_STATE = 4

function GameState:new(initstate, name)
    local this = setmetatable({}, self)

    this.loading_state = Loading:new()
    this.state = initstate
    this.current_state = name

    return this
end

function GameState:update(dt)

    if not self.loading then

        return self.state:update(dt)

    else

        return true

    end

end

function GameState:changeState(state, name)

    self.state = state

    self.current_state = name

    self.loading = false

    print("new state: " .. self.current_state)

end

function GameState:draw()

    if self.loading == true then
        self.loading_state:draw()
    else
        if self.state ~= nil then
            self.state:draw()
        end
    end

end