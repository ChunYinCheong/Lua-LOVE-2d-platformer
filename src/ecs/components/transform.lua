local Transform = {
	x = 300,
	y = 300,
	dx = 1,
  _ox = 0,
  _oy = 0
}


function Transform:push_move(x,y)
  self._ox = self._ox + x
  self._oy = self._oy + y
end


function Transform:reset_move(x,y)
  self._ox = 0
  self._oy = 0
end

Transform.__index = Transform

return Transform