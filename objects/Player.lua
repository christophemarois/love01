local Player = class('Player', GameObject)

function Player.static:makeQuads (image, w, h)
  local quads = {}

  for y = 0, image:getHeight() - h, h do
    for x = 0, image:getWidth() - w, w do
      local quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
      _.push(quads, quad)
    end
  end

  return quads
end

function Player:initialize(options)
  GameObject.initialize(self, 'player', options)

  self.image = options.image or error('Player.image cannot be nil')
  self.w = options.w or error('Player.w cannot be nil')
  self.h = options.h or error('Player.h cannot be nil')
  self.speed = options.speed or error('Player.speed cannot be nil')
  self.acceleration = options.acceleration or error('Player acceleration cannot be nil')
  self.maxSpeed = options.maxSpeed or options.speed
  
  self.quads = Player:makeQuads(self.image, self.w, self.h)
  
  self.currentTime = 0
  self.direction = 1
  self.duration = duration or 1
  self.isMoving = false
  self.velocity = self.speed
  
  function love.keyreleased(key)
    if key == "right" or key == "left" then
      self.velocity = self.speed
      self.isMoving = false
    end
  end

  if IS_DEV then
    debugGraphs.heroSpeed = debugGraph:new('custom', 10, 90, 80, 30, 0.5, 'Hero speed', love.graphics.newFont(14))
  end
end

function Player:update(dt)
  if self.isMoving then
    self.currentTime = self.currentTime + dt
    
    if self.currentTime >= self.duration then
      self.currentTime = self.currentTime - self.duration
    end
  end

  if love.keyboard.isDown('right') then
    self.velocity = self.velocity + self.acceleration
    self.isMoving = true
    self.direction = 1

    local movement = math.min(self.maxSpeed, self.velocity * dt)
    self.x = math.min(self.x + movement, CANVAS_WIDTH - self.w)
    
    if IS_DEV then
      debugGraphs.heroSpeed:update(dt, movement)
      debugGraphs.heroSpeed.label = 'H Speed: '..math.floor(movement)
    end
  elseif love.keyboard.isDown('left') then
    self.velocity = self.velocity + self.acceleration
    self.isMoving = true
    self.direction = -1

    local movement = math.min(self.maxSpeed, self.velocity * dt)
    self.x = math.max(self.x - movement, 0)
    
    if IS_DEV then
      debugGraphs.heroSpeed:update(dt, movement)
      debugGraphs.heroSpeed.label = 'H Speed: '..math.floor(movement)
    end
  end
end

function Player:draw()
  local quadI

  if self.isMoving then
    quadI = math.floor(self.currentTime / self.duration * #self.quads) + 1
  else
    quadI = 1
  end
  
  if DEBUG_COLLISIONS then
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle('rough')
    love.graphics.setColor(255, 0, 0, 0.7)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    love.graphics.setColor(255, 255, 255)
  end

  love.graphics.draw(
    self.image,
    self.quads[quadI],
    self.x + self.w / 2,
    self.y - math.max(0, self.h - GRID_SIZE) + 2, -- 2 IS AN OFFSET. MAKE DYNAMIC
    0,
    self.direction,
    1,
    self.w / 2
  )
end

return Player