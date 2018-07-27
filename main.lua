require 'globals'

love.graphics.setDefaultFilter('nearest', 'nearest', 0)
local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

function love.load()
  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  love.graphics.setBackgroundColor(rgba(255, 255, 255, 1))

  love.physics.setMeter(16)
  map = sti('maps/map.lua', { 'bump' })
  world = bump.newWorld(16)
  map:bump_init(world)

  if map.layers.events then map.layers.events.visible = false end
  
  -- musicBackground = love.audio.newSource('assets/sfx_ambience_night.mp3', 'stream')
  -- musicBackground:setLooping(true)
  -- musicBackground:play()

  Player:new({ gridX = 1, gridY = 5 })

  Graph.static.graphs.fps = Graph:new('FPS: %s')
  Graph.static.graphs.ram = Graph:new('RAM: %s MB')
end

function love.update(dt)
  Timer.update(dt)

  Graph.static.graphs.fps.value = (0.75 * 1 / dt) + (0.25 * love.timer.getFPS())
  Graph.static.graphs.ram.value = collectgarbage('count') / 1024

  map:update(dt)
  GameObject:updateAll(dt)

  if IS_DEV then
    -- lurker.update()
    lovebird.update()
    Graph:updateAll(dt)
  end
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setColor(rgba(255, 255, 255, 1))
  map:draw()
  
  GameObject:drawAll()

  -- Draw Collision Map (doesn't work with GameObject debug yet)
  if DEBUG_COLLISIONS then
    map:bump_draw(world)
  end

  Dialog.draw()

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

  if key == 'x' then
    GameObject:get('player'):jump()
  end

  if key == 'q' then
    love.event.quit()
  end
end
