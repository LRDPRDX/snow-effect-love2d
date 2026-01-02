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
    speed     = 30,               -- falling speed
    text      = 'Hello, World !', -- text to place at the center of the screen
}

local snowflake = love.graphics.newImage(config.snowflake)
local texture = love.graphics.newCanvas(config.texture.w, config.texture.h)
    texture:setWrap('repeat')

local screenW, screenH = love.window.getMode()
local textW, textH = font:getWidth(config.text), font:getHeight(config.text)
local textX, textY = (screenW - textW) / 2, (screenH - textH) / 2

local canvas = love.graphics.newCanvas(config.texture.w, config.texture.h)
    canvas:setWrap('repeat')
local outerBatch = love.graphics.newSpriteBatch(canvas)

local function init ()
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

local y    = 0 -- current vertical displacement of the snowflakes
local step = 0 -- just an auxiliary variable (see below)

function love.load ()
    init()
end

function love.update (dt)
    step = step + config.speed * 0.03
    if step >= 1 then
        y = (y + 1) % config.texture.h
        step = step % 1
    end
end

local quad = love.graphics.newQuad(0, 0, config.texture.w, config.texture.h, texture)

function love.draw ()
    love.graphics.print(love.timer.getFPS(), 0, 0)
    love.graphics.print(config.text, textX, textY)

    quad:setViewport(0, -y, config.texture.w, config.texture.h, config.texture.w, config.texture.h)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.draw(texture, quad)
    love.graphics.setCanvas()

    love.graphics.draw(outerBatch)
end

function love.keypressed (key)
    if key == 'q' then
        love.event.push('quit')
    end
end
