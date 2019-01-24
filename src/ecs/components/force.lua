local Force = {	
	x = 0,
  y = 0,
  base_x = 0,
  base_y = 300,
  step_x = 1000,
  step_y = 1000
}

function Force:add(x,y)
  self.x = self.x + x
  self.y = self.y + y
end

Force.__index = Force

return Force