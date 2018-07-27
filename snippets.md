## Make GameObject follow cursor

In GameObject's `update(dt)` callback

```lua
local x, y = love.mouse.getPosition()
self.x = (x / CANVAS_SCALE) - (self.w / 2)
self.y = (y / CANVAS_SCALE) - (self.h / 2)
```

TODO:
1. climbing
2. bounds collision
3. camera