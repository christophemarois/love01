local GameObject = class('GameObject')

GameObject.static.objects = {}

function GameObject:initialize(kind, options)
  self.kind = type(kind) == 'string' and kind or error('GameObject.kind must be a string')
  
  self.uuid = _.uniqueId(self.kind..'_'..'%s')
  self.createdTime = love.timer.getTime()

  _.push(GameObject.static.objects, self)
end

function GameObject:destroy()
  _.pull(GameObject.static.objects, self)
end

function GameObject.static:where (props)
  return _.where(GameObject.static.objects, props or {})
end

function GameObject.static:findWhere (props)
  return _.findWhere(GameObject.static.objects, props or {})
end

function GameObject.static:get (kind)
  return _.findWhere(GameObject.static.objects, { kind = kind })
end

function GameObject.static:updateAll (dt)
  for i, obj in ipairs(GameObject.static.objects) do
    obj:update(dt)
  end
end

function GameObject.static:drawAll ()
  for i, obj in ipairs(GameObject.static.objects) do
    obj:draw()
  end
end

return GameObject