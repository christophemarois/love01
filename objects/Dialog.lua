local font = love.graphics.newFont('assets/Novitiate.ttf', 16)
font:setFilter('nearest', 'nearest')

local exports = {
  current = nil
}

exports.show = function (message, x, y)
  if exports.current then exports.destroy() end

  assert(type(x) == 'number' and x >= 0, 'Dialog.x must be a positive number')
  assert(type(y) == 'number' and y >= 0, 'Dialog.y must be a positive number')

  exports.current = {
    text = love.graphics.newText(font, message),
    x = x,
    y = y
  }
end

exports.destroy = function ()
  exports.current = nil
end

exports.draw = function ()
  if not exports.current then return end
  love.graphics.draw(exports.current.text, exports.current.x, exports.current.y)
end

return exports