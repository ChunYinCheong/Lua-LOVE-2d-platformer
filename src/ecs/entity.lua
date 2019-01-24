local File = require "src.file"

local Entity = {}
Entity.__index = Entity

local cache = {}

local Component = require "src.ecs.component"

function Entity.prototype( path )
	if not cache[path] then
		Log.debug("Entity - Loading entity prototype file: " .. path)
    local ok, data = File.load_lua(path)
    if not ok then
      Log.error("Entity - Fail: " .. tostring(data))
      return ok , data
    end
    local result, prototype = Entity.init(data)
		cache[path] = { result = (ok and result), prototype = prototype}
	end
	return cache[path].result , cache[path].prototype
end

function Entity.init(o)
  local data = o or {}
  data.__index = data
  data.component = data.component or {}

  if not data.prototype then
    for k,v in pairs(data.component) do
      Component.new( k , v )
    end
    return true , data
  else
    local ok , p = Entity.prototype( data.prototype )
    if not ok then
      return ok , p
    end
    
    setmetatable( data , p )
    for k,v in pairs(data.component) do
      if p.component[k] then
        setmetatable( v , p.component[k] )
      end
      Component.new( k , v )
    end
    for k,v in pairs(p.component) do
      if not data.component[k] then
        local c = setmetatable( {} , p.component[k] )
        data.component[k] = Component.new( k , c )
      end
    end
    return ok , data
  end
end

function Entity.new( path , entity )
  local o = entity or {}
  o.prototype = path
	return Entity.init(o)
end


return Entity