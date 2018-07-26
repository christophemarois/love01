local X = 10
local Y = 5
local WIDTH = 200
local HEIGHT = 30
local DELAY = 0.5
local FONT = love.graphics.newFont(14)

local y = Y
local DISTANCE = HEIGHT + 10

local Graph = class('Graph')
function Graph:initialize (label)
  self.value = nil

  self.label = label
  self.data = {}
  self._max = 0
  self._time = 0

  self.y = y
  y = y + DISTANCE

  -- Build base data
  for i = 0, math.floor(WIDTH / 2) do
    table.insert(self.data, 0)
  end
end

-- Updating the graph
function Graph:update(dt)
  local lastTime = self._time
  self._time = (self._time + dt) % DELAY

  -- Check if the minimum amount of time has past
  if dt > DELAY or lastTime > self._time then
    -- pop the old data and push new data
    table.remove(self.data, 1)
    table.insert(self.data, self.value)

    -- Find the highest value
    local max = 0
    for i=1, #self.data do
      local v = self.data[i]
      if type(v) == 'number' and v > max then
        max = v
      end
    end

    self._max = max
  end
end

function Graph:draw()
  -- Store the currently set font and change the font to our own
  local fontCache = love.graphics.getFont()
  love.graphics.setFont(FONT)

  local max = math.ceil(self._max/10) * 10 + 20
  local len = #self.data
  local steps = WIDTH / len

  -- Build the line data
  local lineData = {}
  for i=1, len do
    local x = steps * (i - 1) + X
    table.insert(lineData, x)

    if type(self.data[i]) == 'number' then
      local y = HEIGHT * (-self.data[i] / max + 1) + self.y
      table.insert(lineData, y)
    else
      local y = 0
      table.insert(lineData, y)
    end
  end

  love.graphics.setColor(rgba(255, 255, 255, 0.5))
  love.graphics.setLineWidth(2)
  love.graphics.line(X - 5, self.y, X - 5, self.y + HEIGHT)

  love.graphics.setColor(rgba(255, 255, 255, 0.5))
  love.graphics.setLineWidth(1)
  love.graphics.line(unpack(lineData))

  -- Print the text
  local val = type(self.data[#self.data]) == 'number'
    and math.floor(self.data[#self.data] * 100) / 100
    or tostring(self.data[#self.data])
  
  love.graphics.setColor(rgba(255, 255, 255, 1))
  love.graphics.print(string.format(self.label, val), X, self.y + HEIGHT - FONT:getHeight())

  -- Reset the font
  love.graphics.setFont(fontCache)
end

Graph.static.graphs = {}
Graph.static.isVisible = false

function Graph.static:updateAll (dt)
  for id, graph in pairs(Graph.static.graphs) do
    graph:update(dt)
  end
end

function Graph.static:drawAll ()
  if Graph.static.isVisible then
    love.graphics.setColor(rgba(0, 0, 0, 0.5))
  
    local boxWidth = WIDTH + (X * 2) - 5
    local boxHeight = ((_.size(Graph.static.graphs) + 1) * HEIGHT) + (Y * 2)
  
    love.graphics.rectangle('fill', 0, 0, boxWidth, boxHeight)
    
    for id, graph in pairs(Graph.static.graphs) do
      graph:draw()
    end
  end
end

function Graph.static:toggle ()
  Graph.static.isVisible = not Graph.static.isVisible
end

return Graph