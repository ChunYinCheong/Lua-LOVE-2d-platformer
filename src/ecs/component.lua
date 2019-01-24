local Component = {}
local map = {}

local function require_component( component_name )
	assert(component_name, "Component_name cannot be nil!")
	local component_module = map[component_name]
	if not component_module then
		Log.debug("Component - Lazy require: " .. component_name)
		component_module = require("src.ecs.components." .. component_name)
		map[component_name] = component_module
	end
	assert(component_module, "Cannot find component module:" .. component_name)
	return component_module
end

function Component.new( name , component )
	local o = component or {}
  o.__index = o
  
  if getmetatable(o) == nil then
    local component_module = require_component( name )
    setmetatable(o,component_module)
  end
	
  if o.init then
    o:init()
  end
	return o
end

return Component