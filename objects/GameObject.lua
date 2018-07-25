local GameObject = class('GameObject')

GameObject.static.objects = {}

function GameObject.static:where (props)
  return _.where(GameObject.static.objects, props or {})
end

function GameObject.static:find (props)
  return _.findWhere(GameObject.static.objects, props or {})
end

function GameObject.static:updateAll (dt)
  for i, obj in ipairs(GameObject.static.objects) do
    if type(obj.update) == 'function' then
      obj:update(dt)
    end
  end
end

function GameObject.static:drawAll ()
  for i, obj in ipairs(GameObject.static.objects) do
    if type(obj.draw) == 'function' then
      obj:draw()
    end
  end
end

function GameObject:initialize(objectType, options)
  self.type = type or error('GameObject.objectType cannot be empty')
  self.x = options.x or 0
  self.y = options.y or 0
  
  self.uuid = _.uniqueId(objectType..'$'..'%s')
  self.createdTime = love.timer.getTime()

  _.push(GameObject.static.objects, self)
end

function GameObject:destroy()
  _.pull(GameObject.static.objects, self)
end

return GameObject