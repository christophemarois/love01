local Player = class('Player', GameObject)

-- Static config
local walkingSpeed = 60
local runningSpeed = walkingSpeed * 1.85

local spriteGridSize = 32
local spriteRow = 3
local spriteW = 6
local spriteH = 24
local spriteXOffset = 13
local spriteYOffset = spriteGridSize - spriteH

local gravity = 200

-- Slice sprite
local image = love.graphics.newImage('characters.png')
local sprite = anim8.newGrid(spriteGridSize, spriteGridSize, image:getWidth(), image:getHeight())

-- Set animations
local animations = {
  right = {
    idle = anim8.newAnimation(sprite(1, spriteRow), 1),
    walking = anim8.newAnimation(sprite('1-4', spriteRow), 0.1),
    jumping = anim8.newAnimation(sprite(5, spriteRow), 1),
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
  self.vy = gravity
  self.speed = walkingSpeed

  self.jumpState = nil
  self.yBeforeJump = 0
  self.wasRunningBeforeJump = false

  self.state = 'idle'
  self.direction = 'right'

  self.collider = { uuid = self.uuid }
  world:add(self.collider, self.x, self.y, self.w, self.h)
  table.insert(map.bump_collidables, self.collider)

  function love.keyreleased(key)
    if key == "right" or key == "left" then
      self.state = 'idle'
      self.vx = 0
    end
  end

  Graph.static.graphs.playerPos = Graph:new('PL pos: %s')
end

function Player:isOnGround ()
  local actualX, actualY, cols, len = world:check(self.collider, self.x, self.y + 1)
  return len > 0
end

function Player:jump ()
  if self.jumpState then return end
  if not self:isOnGround() then return end
  
  self.wasRunningBeforeJump = self.state == 'running'
  self.yBeforeJump = self.y

  self.vy = -275
  self.jumpState = 1

  self.state = 'jumping'

  Timer.tween(0.20, self, { vy = 20 }, 'in-circ')

  Timer.after(0.20, function ()
    self.jumpState = 2
    Timer.tween(1, self, { vy = gravity + 100 }, 'out-expo')
  end)
end

function Player:update(dt)
  if self.jumpState or love.keyboard.isDown('right') or love.keyboard.isDown('left') then
    local speed

    if self.jumpState then
      speed = self.wasRunningBeforeJump and runningSpeed or walkingSpeed
      speed = speed * 1.5
    else
      if love.keyboard.isDown('z') then
        self.state = 'running'
        speed = runningSpeed
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
  end

  local goalX = self.x + math.round(self.vx * dt)
  local goalY = self.y + math.round(self.vy * dt)
  
  local actualX, actualY, cols, len = world:move(self.collider, goalX, goalY, function (item, other)
    local x, y, w, h = world:getRect(self.collider)

    if other.type == 'collider' then
      return 'slide'
    end

    -- If collider is `from_top` and player is on top of it, collide.
    -- Otherwise, do nothing
    if other.properties.from_top and (y + h <= other.y) then
      return 'slide'
    end

    return nil
  end)

  if self.jumpState == 2 then
    for i = 1, len do
      local other = cols[i].other
      self.state = 'idle'
      self.jumpState = nil
    end
  end

  self.x, self.y = actualX, actualY
  animations[self.direction][self.state]:update(dt)

  Graph.static.graphs.playerPos.value = string.format('%s,%s', world:getRect(self.collider))
end

function Player:draw()
  animations[self.direction][self.state]:draw(image, self.x, self.y, nil, nil, nil, spriteXOffset, spriteYOffset)
end

return Player