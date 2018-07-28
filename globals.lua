IS_DEV = true
DEBUG_COLLISIONS = false

GRID_SIZE = 16
CANVAS_WIDTH = GRID_SIZE * 10
CANVAS_HEIGHT = GRID_SIZE * 8
CANVAS_SCALE = 5

-- https://github.com/kikito/bump.lua
bump = require('lib/bump')

-- https://github.com/kikito/middleclass/wiki/Reference
class = require('lib/middleclass')

-- https://github.com/Yonaba/Moses/blob/master/doc/tutorial.md
_ = require('lib/moses')

-- http://karai17.github.io/Simple-Tiled-Implementation/index.html
sti = require('lib/sti')

-- https://github.com/kikito/anim8
anim8 = require('lib/anim8')

-- http://hump.readthedocs.io/en/latest/timer.html
Timer = require('lib/hump/timer')

-- https://github.com/SSYGEN/STALKER-X#quick-start
Camera = require('lib/camera')

-- Pretty print anything
local inspect = require('lib/inspect')
log = function (obj) print(inspect(obj)) end

-- Debug graphs
Graph = require('graphs')

-- Development tools
if IS_DEV then
  -- https://github.com/rxi/lovebird
  lovebird = require('lib/lovebird')
  print("Binding dev console on http://localhost:8000")
end

-- Additional functions
function rgba (r, g, b, a)
  return unpack({ r / 255, g / 255, b / 255, a })
end

math.round = function(n) return n >= 0.0 and n-n%-1 or n-n% 1 end

-- Classes
GameObject = require('objects/GameObject')
Player = require('objects/Player')
Dialog = require('objects/Dialog')

