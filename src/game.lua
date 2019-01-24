local Entity = require "src.ecs.entity"
local Map = require "src.map"
local Camera = require "src.camera"

local Game = {}
Game.__index = Game

function Game:new(o)
  o = o or {}
  setmetatable(o, self)
    
  o.component_table_mapping = {}
  o.entity_table = {}
  o.map_table = nil
  o.camera = Camera:new()
  o.cache = {}
  return o
end

function Game:load_map(map_path)
  Log.debug("Game - Loading map file: " .. map_path)
  local ok, result
  ok , result = Map:new(map_path)
  if ok then
    self.map_table = result
    Log.debug("Game - Loading map file: " .. map_path .. ". Done!")
  else
    Log.error(tostring(result))
  end
  return ok , result
end

function Game:load_entity(entity_path)  
  Log.debug("Game - Loading entity file: " .. entity_path)
  local ok, result
  ok, result = Entity.new( entity_path )
  if ok then
    -- assign id
    local id = #self.entity_table + 1
    self.entity_table[id] = result
    result.id = id
    -- register component
    for k,v in pairs(result.component) do
      self:get_component_table( k )[id] = v
    end
    Log.debug("Game - Loading entity file: " .. entity_path .. ". Done!")
  else
    Log.error(tostring(result))    
  end
  return ok , result
end

function Game:remove_entity( entity_id )
  local entity = self.entity_table[entity_id]
  if entity then
    for k,v in pairs(entity.component) do
      self:get_component_table(k)[entity_id] = nil
    end
  end
  self.entity_table[entity_id] = false
end

function Game:get_component_table( component_name )
  if not self.component_table_mapping[component_name] then
    self.component_table_mapping[component_name] = {}
  end
  return self.component_table_mapping[component_name]
end

function Game:get_entity_component( entity_id , component_name )
  return self:get_component_table(component_name)[entity_id]
end

function Game:get_camera()
  return self.camera
end

function Game:get_map()
  return self.map_table
end

return Game









  