require("game_state/GameState")
require("game_state/Splash")
require("game_state/Main")
require("game_state/Game")
require("game_state/Levels")

local game_state

function love.load()

    game_state = GameState:new(Splash:new(), SPLASH_SCREEN)

end

function love.update(dt)

    local bool, r = game_state:update(dt)

    if not bool then 

        local state
        if game_state.current_state == SPLASH_SCREEN then
            game_state.loading = true 
            state = Main:new()
            game_state:changeState(state, MAIN_MENU)
        elseif game_state.current_state == MAIN_MENU then
            game_state.loading = true 
            state = Levels:new()
            game_state:changeState(state, LEVEL_MENU)
        elseif game_state.current_state == GAME_STATE then 
            game_state.loading = true 
            state = Main:new()
            game_state:changeState(state, MAIN_MENU)
        elseif game_state.current_state == LEVEL_MENU then
            game_state.loading = true 
            state = Game:new(r)
            game_state:changeState(state, GAME_STATE)
        end

    else

        if r == "main" then 
            game_state.loading = true 
            state = Main:new()
            game_state:changeState(state, MAIN_MENU)
        end

    end

end

function love.draw()

    love.graphics.clear()

    game_state:draw()

end