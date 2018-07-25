require 'globals'

love.graphics.setDefaultFilter('nearest', 'nearest', 0)
local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

function love.load()
  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)

  love.physics.setMeter(16)
  map = sti('maps/map.lua', { 'box2d' })
  world = love.physics.newWorld(0, 0)
  map:box2d_init(world)
  
  -- musicBackground = love.audio.newSource('assets/sfx_ambience_night.mp3', 'stream')
  -- musicBackground:setLooping(true)
  -- musicBackground:play()

  Player:new({
    image = love.graphics.newImage("oldHero.png"),
    x = GRID_SIZE * 5,
    y = GRID_SIZE * 6,
    w = 16,
    h = 18,
    duration = 0.55,
    speed = 50,
    acceleration = 2,
    maxSpeed = 3
  })

  Graph.static.graphs.fps = Graph:new('FPS: %s')
  Graph.static.graphs.ram = Graph:new('RAM: %s MB')
end

function love.update(dt)
  Graph.static.graphs.fps.value = (0.75 * 1 / dt) + (0.25 * love.timer.getFPS())
  Graph.static.graphs.ram.value = collectgarbage('count') / 1024

  if IS_DEV then
    lurker.update()
    lovebird.update()
    Graph:updateAll(dt)
  end

  map:update(dt)
  GameObject:updateAll(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setColor(rgba(255, 255, 255, 1))
  map:draw()
  
  GameObject:drawAll()

  -- Draw Collision Map (doesn't work with GameObject debug yet)
  -- if DEBUG_COLLISIONS then
  --   love.graphics.setColor(rgba(0, 255, 0, 1))
  --   map:box2d_draw()
  -- end

  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0, CANVAS_SCALE, CANVAS_SCALE)

  if IS_DEV then
    Graph:drawAll()
  end
end

function love.keypressed(key, scancode)
  if IS_DEV and scancode == 'd' then
    Graph:toggle()
    DEBUG_COLLISIONS = not DEBUG_COLLISIONS
  end
end
