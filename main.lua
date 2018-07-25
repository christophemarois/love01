require 'globals'

love.graphics.setDefaultFilter('nearest', 'nearest', 0)
local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

function love.load()
  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  love.graphics.setBackgroundColor(rgba(22, 1, 96, 1.00))

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

  if IS_DEV then
    debugGraphs.fps = debugGraph:new('fps', 10, 10, 80, 30, 0.5, nil, love.graphics.newFont(14))
    debugGraphs.mem = debugGraph:new('mem', 10, 50, 80, 30, 0.5, nil, love.graphics.newFont(14))

    -- debugGraphs.fps = debugGraph:new('fps', 0, 0)
    print("Binding dev console on http://localhost:8000")
  end
end

function love.update(dt)
  if IS_DEV then
    lurker.update()
    lovebird.update()

    debugGraphs.fps:update(dt)
    debugGraphs.mem:update(dt)
  end

  map:update(dt)
  GameObject:updateAll(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setColor(255, 255, 255)
	map:draw()

  -- Draw Collision Map (doesn't work with GameObject debug yet)
  if DEBUG_COLLISIONS then
    love.graphics.setColor(255, 0, 0)
    map:box2d_draw()
  end
  
  GameObject:drawAll()

  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0, CANVAS_SCALE, CANVAS_SCALE)

  if IS_DEV then
    for _, graph in pairs(debugGraphs) do graph:draw() end
  end
end