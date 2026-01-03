# A simple snow effect in the LÖVE2D framework

![demo](/snow.gif)

## Run

Download the repo and run

```bash
love .
```

in the repo root directory.

## Config

Change the corresponding values in the `config` table (`local config` in the `main.lua` file) to
see the difference.

To change the text you can use the `text.txt` file --- the first line in this file will be
taken as the text to display.

Also see the keys below:

```Lua
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
```

## Acknowledgements

 - Font: https://www.1001freefonts.com/vcr-osd-mono.font
 - LÖVE2D chat, thank you for your help - you are the best !
