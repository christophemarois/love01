local font = love.graphics.newFont('assets/Novitiate.ttf', 16)
font:setFilter('nearest', 'nearest')

local paddingW = 4
local paddingH = 0
local triangleW = 6
local triangleH = 7

local offsetTop = 17

local timer = nil
local exports = { current = nil }

exports.showEvent = function (message, event)
  if exports.current then exports.destroy() end

  exports.current = {
    text = love.graphics.newText(font, event.properties.text),
    x = event.x,
    y = event.y,
    w = event.width,
    h = event.height
  }
end

exports.destroy = function ()
  exports.current = nil
end

exports.draw = function ()
  if not exports.current then return end

  local textW, textH = exports.current.text:getDimensions()
  local canvas = love.graphics.newCanvas(textW + paddingW * 2, textH + paddingH * 2 + triangleH)

  canvas:renderTo(function ()
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle('fill', 0, 0, textW + paddingW * 2, textH + paddingH * 2)

    love.graphics.polygon('fill',
      textW / 2, textH + paddingH * 2,
      textW / 2 + triangleW, textH + paddingH * 2,
      textW / 2 + triangleW / 2, textH + paddingH * 2 + triangleH
    )
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(exports.current.text, paddingW + 1, paddingH + 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(exports.current.text, paddingW + 0, paddingH + 0)
  end)

  local canvasX = exports.current.x - (textW / 2) + (exports.current.w / 2) - paddingW
  local canvasY = exports.current.y - textH - paddingH - offsetTop

  love.graphics.draw(canvas, canvasX, canvasY)
end

return exports