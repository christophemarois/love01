local font = love.graphics.newFont('assets/Novitiate.ttf', 16)
font:setFilter('nearest', 'nearest')

local paddingW = 4
local paddingH = 0
local triangleW = 6
local triangleH = 7

local offsetTop = 17

local timer = nil
local Dialog = { current = nil }

Dialog.showEvent = function (message, event)
  if Dialog.current then Dialog.destroy() end

  Dialog.current = {
    text = love.graphics.newText(font, event.properties.text),
    x = event.x,
    y = event.y,
    w = event.width,
    h = event.height
  }
end

Dialog.destroy = function ()
  Dialog.current = nil
end

Dialog.draw = function ()
  if not Dialog.current then return end

  local cameraX, cameraY = camera:toCameraCoords(Dialog.current.x, Dialog.current.y)

  local textW, textH = Dialog.current.text:getDimensions()
  
  local canvasWidth = textW + paddingW * 2
  local canvasHeight = textH + paddingH * 2 + triangleH

  local canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)

  canvas:renderTo(function ()
    love.graphics.setColor(rgba(0, 0, 0, 0.6))
    love.graphics.rectangle('fill', 0, 0, textW + paddingW * 2, textH + paddingH * 2)

    love.graphics.polygon('fill',
      textW / 2, textH + paddingH * 2,
      textW / 2 + triangleW, textH + paddingH * 2,
      textW / 2 + triangleW / 2, canvasHeight
    )
    
    love.graphics.setColor(rgba(0, 0, 0, 1))
    love.graphics.draw(Dialog.current.text, paddingW + 1, paddingH + 1)
    love.graphics.setColor(rgba(255, 255, 255, 1))
    love.graphics.draw(Dialog.current.text, paddingW + 0, paddingH + 0)
  end)

  local canvasX = cameraX - (textW / 2) + (Dialog.current.w / 2) - paddingW
  local canvasY = cameraY - textH - paddingH - offsetTop

  love.graphics.setColor(rgba(255, 255, 255, 1))
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, canvasX, canvasY)

  if DEBUG_COLLISIONS then
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle('line', canvasX, canvasY, canvasWidth, canvasHeight)
  end
end

return Dialog