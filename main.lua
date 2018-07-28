require 'globals'

love.graphics.setDefaultFilter('nearest', 'nearest', 0)

local canvas
local player

function love.load()
  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  love.graphics.setBackgroundColor(rgba(255, 255, 255, 1))

  love.physics.setMeter(16)
  map = sti('maps/map.lua', { 'bump' })
  world = bump.newWorld(16)
  map:bump_init(world)

  if map.layers.events then map.layers.events.visible = false end
  
  musicBackground = love.audio.newSource('assets/bg.ogg', 'stream')
  musicBackground:setLooping(true)
  musicBackground:setVolume(0.5)
  musicBackground:play()

  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

  camera = Camera(nil, nil, CANVAS_WIDTH, CANVAS_HEIGHT)
  -- camera:setFollowStyle('PLATFORMER')
  camera:setBounds(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
  camera:setFollowLerp(1)

  player = Player:new({ gridX = 1, gridY = 6 })

  Graph.static.graphs.camera = Graph:new('Cam: %s')
  Graph.static.graphs.fps = Graph:new('FPS: %s')
  Graph.static.graphs.ram = Graph:new('RAM: %s MB')
end

function love.update(dt)
  Timer.update(dt)

  Graph.static.graphs.fps.value = (0.75 * 1 / dt) + (0.25 * love.timer.getFPS())
  Graph.static.graphs.ram.value = collectgarbage('count') / 1024

  map:update(dt)
  camera:update(dt)
  GameObject:updateAll(dt)
  
  camera:follow(player.x, player.y)

  Graph.static.graphs.camera.value = string.format('[%s, %s]', camera.x, camera.y)

  if IS_DEV then
    lovebird.update()
    Graph:updateAll(dt)
  end
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  -- [Inside camera canvas]
  camera:attach()

  love.graphics.setColor(rgba(255, 255, 255, 1))
  map:draw(math.floor(-camera.x + CANVAS_WIDTH / 2), math.floor(-camera.y + CANVAS_HEIGHT / 2))
  GameObject:drawAll()

  -- Draw Collision Map
  if DEBUG_COLLISIONS then
    map:bump_draw(world)
  end

  camera:detach()
  -- [/Inside camera canvas] )
  
  camera:draw()
  Dialog.draw()

  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, CANVAS_SCALE, CANVAS_SCALE)
  love.graphics.setBlendMode('alpha')

  if IS_DEV then
    Graph:drawAll()
  end
end

function love.keypressed(key, scancode)
  if IS_DEV and scancode == 'd' then
    Graph:toggle()
    DEBUG_COLLISIONS = not DEBUG_COLLISIONS
    camera.draw_deadzone = not camera.draw_deadzone
  end

  if key == 'x' then
    player:jump()
  end

  if key == 'q' then
    love.event.quit()
  end
end
