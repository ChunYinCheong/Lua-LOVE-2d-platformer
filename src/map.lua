
local File = require "src.file"

local Map = {}
Map.__index = Map

Map.tile_size = 32
Map.tile_map = {}
Map.tile_set = "data/tile/default.png"
Map.collision_map = {}

function Map:new( map_path )  
  Log.debug("Map - Loading map file: " .. map_path)
  local ok, result
  ok , result = File.load_lua(map_path)
  if ok then
    result = setmetatable(result,Map)
    Log.debug("Map - Loading map file: " .. map_path .. ". Done!")
  else
    Log.error(tostring(result))
  end  
	return ok , result
end

function Map:detect_collision( x1,x2,y1,y2 )
  local tile_min_x = math.floor( math.min(x1,x2) / self.tile_size )
  local tile_max_x = math.floor( math.max(x1,x2) / self.tile_size )
  local tile_min_y = math.floor( math.min(y1,y2) / self.tile_size )
  local tile_max_y = math.floor( math.max(y1,y2) / self.tile_size )

  for y = tile_min_y, tile_max_y do
    if self.tile_map[y] then
      for x = tile_min_x, tile_max_x do
        if self.tile_map[y][x] then
          if self.tile_collision[self.tile_map[y][x]] and self.tile_collision[self.tile_map[y][x]] ~= 0  then
            -- print(x,y,map[y][x])
            -- Collision detected!
            return true
          end
        end
      end
    end
  end
  return false
end

return Map