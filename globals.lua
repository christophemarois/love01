IS_DEV = true
DEBUG_COLLISIONS = false

GRID_SIZE = 16
CANVAS_WIDTH = GRID_SIZE * 10
CANVAS_HEIGHT = GRID_SIZE * 8
CANVAS_SCALE = 5

-- https://github.com/kikito/middleclass/wiki/Reference
class = require('lib/middleclass')

-- https://github.com/Yonaba/Moses/blob/master/doc/tutorial.md
_ = require('lib/moses')

-- http://karai17.github.io/Simple-Tiled-Implementation/index.html
sti = require('lib/sti')

-- Pretty print anything
local inspect = require('lib/inspect')
log = function (obj) print(inspect(obj)) end

GameObject = require('objects/GameObject')
Player = require('objects/Player')