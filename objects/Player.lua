local Player = class('Player', GameObject)

-- Static config
local walkingSpeed = 60
local spriteRow = 3
local spriteW = 14
local spriteH = 23
local spriteXOffset = 9
local colliderYOffset = (GRID_SIZE * 2) - spriteH

local gravity = 80

-- Slice sprite
local image = love.graphics.newImage('characters.png')
local sprite = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())

-- Set animations
local animations = {
  right = {
    idle = anim8.newAnimation(sprite(1, spriteRow), 1),
    walking = anim8.newAnimation(sprite('1-4', spriteRow), 0.1),
    jumpPrepare = anim8.newAnimation(sprite(5, spriteRow), 1),
    jumpUp = anim8.newAnimation(sprite(6, spriteRow), 1),
    jumpDuring = anim8.newAnimation(sprite(7, spriteRow), 1),
    jumpDown = anim8.newAnimation(sprite(8, spriteRow), 1),
    running = anim8.newAnimation(sprite('15-18', spriteRow), 0.1),
    climbing = anim8.newAnimation(sprite('19-22', spriteRow), 0.1),
    idleBack = anim8.newAnimation(sprite(1, spriteRow), 1),
  }
}

-- Clone and flip all animations for reverse direction
animations.left = _.map(animations.right, function(name, animation)
  return animation:clone():flipH()
end)

function Player:initialize(options)
  GameObject.initialize(self, 'player', options)

  assert(type(options.gridX) == 'number', 'Player.gridX must be a number')
  assert(type(options.gridY) == 'number', 'Player.gridY must be a number')
  
  self.w = spriteW
  self.h = spriteH
  self.x = (GRID_SIZE * options.gridX) + ((GRID_SIZE - self.w) / 2)
  self.y = (GRID_SIZE * options.gridY)
  self.vx = 0
  self.vy = 0

  self.jumpState = nil
  self.yBeforeJump = 0

  self.state = 'idle'
  self.direction = 'right'

  self.collider = { uuid = self.uuid }
  world:add(self.collider, self.x, self.y + colliderYOffset, self.w, self.h)
  table.insert(map.bump_collidables, self.collider)

  function love.keyreleased(key)
    if key == "right" or key == "left" then
      self.state = 'idle'
      self.vx = 0
    end
  end

  Graph.static.graphs.playerPos = Graph:new('PL pos: %s')
  Graph.static.graphs.playerVx = Graph:new('PL vx: %s')
  Graph.static.graphs.playerVy = Graph:new('PL vy: %s')
end

function Player:jump ()
  if self.jumpState then return end

  self.yBeforeJump = self.y
  self.vy = gravity - 200
  self.jumpState = 1
end

function Player:update(dt)
  if self.jumpState or love.keyboard.isDown('right') or love.keyboard.isDown('left') then
    local speed

    if self.jumpState then
      self.state = 'jumpDuring'
      speed = walkingSpeed
    else
      if love.keyboard.isDown('z') then
        self.state = 'running'
        speed = walkingSpeed * 1.85
      else
        self.state = 'walking'
        speed = walkingSpeed
      end
    end

    if love.keyboard.isDown('right') then
      self.vx = speed
      self.direction = 'right'
    end

    if love.keyboard.isDown('left') then
      self.vx = speed * -1
      self.direction = 'left'
    end

    if self.jumpState == 1 and (self.y < self.yBeforeJump - 40) then
      self.vy = gravity
      self.jumpState = 2
    end
  end

  local goalX = self.x + math.round(self.vx * dt)
  local goalY = self.y + math.round(self.vy * dt)
  
  local actualX, actualY, cols, len = world:move(self.collider, goalX, goalY)

  self.x, self.y = actualX, actualY
  animations[self.direction][self.state]:update(dt)

  if self.jumpState == 2 then
    for i = 1, len do
      local other = cols[i].other
      self.jumpState = nil
    end
  end

  Graph.static.graphs.playerPos.value = string.format('%s,%s', world:getRect(self.collider))
  Graph.static.graphs.playerVx.value = self.vx
  Graph.static.graphs.playerVy.value = self.vy
end

function Player:draw()
  animations[self.direction][self.state]:draw(image, self.x, self.y, nil, nil, nil, spriteXOffset)
end

return Player