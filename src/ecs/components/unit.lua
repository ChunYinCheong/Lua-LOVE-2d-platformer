local Unit = {
  init_state = nil,
  state = nil,
  hp = 1000
}

function Unit:init()
  self.cache = {}
  if self.init_state and self.state == nil then
    Log.debug("Unit - init: " , self.init_state)
    local state = require("src.states." .. self.init_state)
    local s = state:new()
    self.state = s
  end
end

function Unit:switch_state(state)
  self.state:exit()
  local cache = self.cache[state]
  if not cache then
    cache = (require("src.states." .. state)):new()
    self.cache[state] = cache
  end
  self.state = cache
  self.state:enter()
end

function Unit:damage(d)
  self.hp = self.hp - d
  Log.debug("Unit take damage: " .. d)
end

Unit.__index = Unit

return Unit