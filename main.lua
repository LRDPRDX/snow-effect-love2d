love.graphics.setDefaultFilter("nearest")

local font = love.graphics.newFont('VCR_OSD_MONO.ttf', 60)
love.graphics.setFont(font)

local config = {
    texture = {
        w = 128,
        h = 128,
    },

    -- Just some random snowflake positions which are
    -- drawn on the canvas, which in turn is repeatedly drawn on the screen
    coordinates = {
        { x = 0,   y = 0 },
        { x = 7,   y = 13 },
        { x = 61,  y = 29 },
        { x = 31,  y = 43 },
        { x = 94,  y = 69 },
        { x = 103, y = 81 },
        { x = 18,  y = 93 },
        { x = 78,  y = 105 },
        { x = 45,  y = 120 },
    },

    snowflake = 'snowflake.png',  -- snowflake sprite
    scale     = 1.7,              -- scale step between layers
    layers    = 5,                -- number of layers with different scales of the snowflakes 
    speed     = 50,               -- falling speed
    text      = 'Hello, World !', -- text to place at the center of the screen (default)
    show      = {
        info = true, -- display the current FPS at the upper left corner
        text = true, -- display the text at the center of the screen
    },
}

local keys = {
    ['q'] = {
        description = 'Quit',
        action = function () love.event.push('quit') end,
    },

    ['up'] = {
        description = 'Speed up',
        action = function () config.speed = math.min(100, config.speed + 10) end,
    },

    ['down'] = {
        description = 'Speed down',
        action = function () config.speed = math.max(10, config.speed - 10) end,
    },

    ['f'] = {
        description = 'Toggle info',
        action = function () config.show.info = not config.show.info end,
    },

    ['t'] = {
        description = 'Toggle text',
        action = function () config.show.text = not config.show.text end,
    }
}

local snowflake = love.graphics.newImage(config.snowflake)
local texture = love.graphics.newCanvas(config.texture.w, config.texture.h)
    texture:setWrap('repeat')

local screenW, screenH = love.window.getMode()
local text = {}

local canvas = love.graphics.newCanvas(config.texture.w, config.texture.h)
    canvas:setWrap('repeat')
local outerBatch = love.graphics.newSpriteBatch(canvas)

local y    = 0 -- current vertical displacement of the snowflakes
local step = 0 -- just an auxiliary variable (see below)

function love.load ()
    -- Read the text to place from the file if exists.
    -- Otherwise the text is taken from the config table above
    local file, status = nil, nil
    local baseDir = love.filesystem.getSourceBaseDirectory()
    local success = love.filesystem.mount(baseDir, 'game')

    if success then
        file, status = love.filesystem.newFile ('game/text.txt', 'r')
    else
        file, status = love.filesystem.newFile ('text.txt', 'r')
    end

    if file then
        local lines = file:lines()
        local line = lines()
        config.text = line or config.text
        if file:isOpen() then
            file:close()
        end
    end

    -- Calculate the position of the text to place it right at the center of the screen
    text.w, text.h = font:getWidth(config.text), font:getHeight(config.text)
    text.x, text.y = (screenW - text.w) / 2, (screenH - text.h) / 2

    -- Draw snowflakes with the coordinates specified in the config table above
    love.graphics.setCanvas(texture)
    for _, c in ipairs(config.coordinates) do
        love.graphics.draw(snowflake, c.x, c.y)
    end
    love.graphics.setCanvas()

    local q = love.graphics.newQuad(0, 0, screenW, screenH, config.texture.w, config.texture.h)

    for i = 1, config.layers do
        -- -screenW / 2 in order to eliminate the pattern at the (0, 0) coordinate otherwise
        outerBatch:add(q, -screenW / 2, 0, 0, i * config.scale, i * config.scale)
    end
end

function love.update (dt)
    step = step + config.speed * 0.03
    if step >= 3 then
        y = (y + 1) % config.texture.h
        step = step % 1
    end
end

local quad = love.graphics.newQuad(0, 0, config.texture.w, config.texture.h, texture)

function love.draw ()
    if config.show.info then
        love.graphics.print(('FPS: %d, Speed: %d'):format(love.timer.getFPS(), config.speed), 0, 0)
    end

    if config.show.text then
        love.graphics.print(config.text, text.x, text.y)
    end

    quad:setViewport(0, -y, config.texture.w, config.texture.h, config.texture.w, config.texture.h)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.draw(texture, quad)
    love.graphics.setCanvas()

    love.graphics.draw(outerBatch)
end

function love.keypressed (key)
    local k = keys[key]
    if k then
        k.action()
    end
end
