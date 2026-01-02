love.graphics.setDefaultFilter("nearest")

local font = love.graphics.newFont('VCR_OSD_MONO.ttf', 60)
love.graphics.setFont(font)

local config = {
    canvas = {
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
        { x = 45,  y = 125 },
    },

    snowflake = 'snowflake.png',  -- snowflake sprite
    scale     = 1.7,              -- scale step between layers
    layers    = 5,                -- number of layers with different scales of the snowflakes 
    speed     = 30,               -- falling speed
    text      = 'Hello, World !', -- text to place at the center of the screen
}

local snowflake = love.graphics.newImage(config.snowflake)

local canvas = love.graphics.newCanvas(config.canvas.w, config.canvas.h)
    canvas:setWrap("repeat")

local innerBatch = love.graphics.newSpriteBatch(snowflake)
local outerBatch = love.graphics.newSpriteBatch(canvas)

local screenW, screenH = love.window.getMode()
local textW, textH = font:getWidth(config.text), font:getHeight(config.text)
local textX, textY = (screenW - textW) / 2, (screenH - textH) / 2

local function init ()
    local q = love.graphics.newQuad(0, 0, screenW, screenH, canvas)

    for i = 1, config.layers do
        outerBatch:add(q, 0, 0, 0, i * config.scale, i * config.scale)
    end
end

local y    = 0 -- current vertical displacement of the snowflakes
local step = 0 -- just an auxiliary variable (see below)

function love.load ()
    init()
end

function love.update (dt)
    step = step + config.speed * 0.03
    if step >= 1 then
        y = (y + 1) % config.canvas.h
        step = step % 1
    end
end

function love.draw ()
    love.graphics.print(love.timer.getFPS(), 0, 0)
    love.graphics.print(config.text, textX, textY)
    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        innerBatch:clear()

        for _, c in ipairs(config.coordinates) do
            innerBatch:add(c.x, c.y + y)
        end

        love.graphics.draw(innerBatch)
        love.graphics.draw(innerBatch, 0, -config.canvas.h)
        love.graphics.draw(innerBatch, 0, -2 * config.canvas.h)
    love.graphics.setCanvas()

    love.graphics.draw(outerBatch)
end

function love.keypressed (key)
    if key == 'q' then
        love.event.push('quit')
    end
end
