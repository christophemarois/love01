local Player = class('Player', GameObject)

-- Static config
local walkingSpeed = 60
local runningSpeed = walkingSpeed * 1.95
local jumpHeight = 46
local jumpDuration = 0.2
local jumpRunningMultiplier = 1.25

local spriteGridSize = 32
local spriteRow = 3
local spriteW = 6
local spriteH = 24
local spriteXOffset = 13
local spriteYOffset = spriteGridSize - spriteH

local gravity = 200

-- Global references
local jumpTimerHandle = nil
local respawning = false

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
      if not self.jumpState then self.state = 'idle' end
      self.vx = 0
    end
  end

  Graph.static.graphs.playerPos = Graph:new('PL pos: %s')
end

-- NOTE: THIS MIGHT ALSO RETURN TRUE WITH NON-COLLIDABLE EVENT OBJECTS
-- THIS IS NOT DESIRABLE
function Player:isOnGround ()
  local actualX, actualY, cols, len = world:check(self.collider, self.x, self.y + 1)
  return len > 0
end

function Player:jump ()
  if self.jumpState then return end
  if not self:isOnGround() then return end
  
  self.wasRunningBeforeJump = self.state == 'running'
  self.yBeforeJump = self.y

  self.vy = -1 * jumpHeight / jumpDuration

  -- If player was running before jump, it will go farther, but less high
  if self.wasRunningBeforeJump then self.vy = self.vy / jumpRunningMultiplier end

  self.jumpState = 1
  self.state = 'jumping'

  jumpTimerHandle = Timer.tween(jumpDuration, self, { vy = 0 }, 'in-expo', function ()
    self.jumpState = 2
    jumpTimerHandle = Timer.tween(jumpDuration, self, { vy = gravity }, 'out-quad')
  end)
end

function Player:update(dt)
  if respawning then
    self.vx = 0
  else
    if self.jumpState or love.keyboard.isDown('right') or love.keyboard.isDown('left') then
      local speed

      if self.jumpState then
        speed = self.wasRunningBeforeJump and runningSpeed or walkingSpeed
        speed = speed * jumpRunningMultiplier
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

  if len > 0 then
    respawning = false
  end

  if self.jumpState == 2 then
    for i = 1, len do
      local other = cols[i].other
      self.state = 'idle'
      self.jumpState = nil
      self.vy = gravity
      Timer.cancel(jumpTimerHandle)
    end
  end

  self.x, self.y = actualX, actualY
  animations[self.direction][self.state]:update(dt)

  if (not respawning) and self.y > CANVAS_HEIGHT then
    respawning = true

    Timer.after(0.25, function ()
      self.x = 10
      self.y = -1 * self.h
    end)
  end

  Graph.static.graphs.playerPos.value = string.format('%s,%s', world:getRect(self.collider))
end

function Player:draw()
  animations[self.direction][self.state]:draw(image, math.round(self.x), math.round(self.y), nil, nil, nil, spriteXOffset, spriteYOffset)
end

return Player