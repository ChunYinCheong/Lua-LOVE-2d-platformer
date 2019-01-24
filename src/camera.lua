local Camera = {}
Camera.__index = Camera

function Camera:new(  )
  local camera = {}
  setmetatable(camera, self)
  
  camera.x = 0
  camera.y = 0
  camera.scaleX = 1
  camera.scaleY = 1
  camera.rotation = 0
  camera.target = nil
  return camera
end

function Camera:set_target(t)
  self.target = t
  self.x = 0
  self.y = 0
end  

function Camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function Camera:set_position(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function Camera:get_position()
  if self.target then
    local tran = self.target.component.transform
    return self.x + tran.x , self.y + tran.y
  else
    return self.x , self.y
  end
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:set_scale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function Camera:get_scale()
  return self.scaleX , self.scaleX
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:set_rotate(dr)
  self.rotation = dr
end

function Camera:get_rotate()
  return self.rotation
end

return Camera