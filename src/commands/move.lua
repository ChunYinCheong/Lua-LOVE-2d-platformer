local Move = {
	name = "move",
  dx = 0,
  dy = 0,
  speed = 100
}

function Move:new()
  local o = {}
  setmetatable(o, self)
  return o
end


Move.__index = Move

return Move