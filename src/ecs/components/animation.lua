local Animation = {
  _list = nil
  
}

function Animation:init()
  local pl = self._list
  self._list = {}
  if pl then
    for k,v in ipairs(pl) do
      local a = {}
      for k2,v2 in pairs(v) do
        a[k2] = v2
      end
      self._list[k] = a
    end
  end
end

function Animation:play(path,name,loop)
  local a = {}
  a.path = path
  a.name = name
  a.loop = loop
  a.time = 0
  self._list = {}
  table.insert(self._list,a)
end




Animation.__index = Animation

return Animation