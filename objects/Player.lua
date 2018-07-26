local Player = class('Player', GameObject)

local image = love.graphics.newImage('characters.png')
local sprite = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())

local walkingSpeed = 60

local spriteW = 14
local spriteH = 23
local spriteXOffset = 9
local colliderYOffset = (GRID_SIZE * 2) - spriteH

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

  self.state = 'walking'

  self.animation = anim8.newAnimation(sprite('1-3', 3), 0.1)

  self.collider = { uuid = self.uuid }
  world:add(self.collider, self.x, self.y + colliderYOffset, self.w, self.h)
  table.insert(map.bump_collidables, self.collider)
  
  function love.keyreleased(key)
    if key == "right" or key == "left" then
      self.vx = 0
    end
  end

  Graph.static.graphs.playerPos = Graph:new('PL pos: %s')
  Graph.static.graphs.playerVx = Graph:new('PL vx: %s')
end

function Player:update(dt)
  if love.keyboard.isDown('right') then
    self.vx = walkingSpeed
  elseif love.keyboard.isDown('left') then
    self.vx = walkingSpeed * -1
  end

  local goalX = self.x + math.round(self.vx * dt)
  local goalY = self.y + math.round(self.vy * dt)
  
  local actualX, actualY, cols, len = world:move(self.collider, goalX, goalY)
  self.x, self.y = actualX, actualY

  self.animation:update(dt)

  Graph.static.graphs.playerPos.value = string.format('%s,%s', world:getRect(self.collider))
  Graph.static.graphs.playerVx.value = self.vx
end

function Player:draw()
  self.animation:draw(image, self.x, self.y, nil, nil, nil, spriteXOffset)
end

return Player