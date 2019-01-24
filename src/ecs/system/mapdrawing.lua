local File = require "src.file"

local Drawing = {}
Drawing.__index = Drawing

local function updateTilesetBatchInRange(game,x1,x2,y1,y2,x_size,y_size)
  local map = game:get_map()
  
  for y = y1, y2 do
    for x = x1, x2 do
      local batch_id = x % x_size + y % y_size * x_size + 1
      if map.tile_map[y] and map.tile_map[y][x] and map.tile_map[y][x] ~= -1 then
        map.cache.tilesetBatch:set(batch_id,
          map.cache.tileQuads[map.tile_map[y][x]],
          x*map.tile_size, y*map.tile_size, 0, 1, 1)
      else
        map.cache.tilesetBatch:set(batch_id,
          0,0,0,0,0)
      end
    end
  end
end

local function setupTileset(game)
  local map = game:get_map()
  map.cache = {}
  local tilesetImage = File.load_image( map.tile_set )
  tilesetImage:setFilter("nearest", "linear") -- this "linear filter" removes some artifacts if we were to scale the tiles
  map.cache.tilesetImage = tilesetImage
  
  local tileSize = map.tile_size
  
  local w,h = tilesetImage:getDimensions()
  local tileQuads = {}
  local my = math.floor(h/tileSize)
  local mx = math.floor(w/tileSize)
  for y = 0 , my do
    for x = 0, mx do
      tileQuads[mx*y+x] = love.graphics.newQuad(x * tileSize, y* tileSize, tileSize, tileSize, w, h)
    end
  end
  map.cache.tileQuads = tileQuads
  
  map.cache.tilesetBatch = love.graphics.newSpriteBatch(tilesetImage)
end

function Drawing.draw(game)
   
  local c = game:get_camera()
  local x , y  =  c:get_position()
  local sx , sy  =  c:get_scale()
  local r = c:get_rotate()
  local width, height = love.graphics.getDimensions( )
  local ox,oy = width / sx / 2, height / sy / 2
  local x1,x2,y1,y2 = x-ox,x+ox,y-oy,y+oy
  local x3,y3 = width / sx , height / sy

  local map = game:get_map()
  local tile_size = map.tile_size
  local tile_in_x = math.ceil(x3 / tile_size) + 1
  local tile_in_y = math.ceil(y3 / tile_size) + 1
  local tile_start_x = math.floor( x1 / tile_size )
  local tile_start_y = math.floor( y1 / tile_size )

  if not map.cache then
    setupTileset(game)
  end

  if map.cache.tile_in_x ~= tile_in_x 
    or map.cache.tile_in_y ~= tile_in_y 
  then
    -- Reset SpriteBatch when screen resize
    map.cache.tilesetBatch:clear()
    
    for i = 1, tile_in_x * tile_in_y  do
      map.cache.tilesetBatch:add(0,0,0,0,0)
    end
    
    for y = tile_start_y, tile_start_y + tile_in_y - 1  do
      if map.tile_map[y] then
        for x = tile_start_x, tile_start_x + tile_in_x - 1 do
          if map.tile_map[y][x] then
            local batch_id = x % tile_in_x + y % tile_in_y * tile_in_x + 1            
            map.cache.tilesetBatch:set(batch_id,
              map.cache.tileQuads[map.tile_map[y][x]],
              x*map.tile_size, y*map.tile_size, 0, 1, 1)
          end
        end
      end
    end
    
    map.cache.tilesetBatch:flush()
    Log.debug("MapDrawing - number of drawing tile: " .. tile_in_x .. " * " .. tile_in_y .. " = " .. tile_in_x * tile_in_y)
  elseif map.cache.tile_start_x ~= tile_start_x 
    or map.cache.tile_start_y ~= tile_start_y 
  then
    -- Update Sprite in SpriteBatch when screen move
    local x_diff = tile_start_x - map.cache.tile_start_x
    if x_diff > 0 then
      updateTilesetBatchInRange(game,
        map.cache.tile_start_x + map.cache.tile_in_x , map.cache.tile_start_x + map.cache.tile_in_x + x_diff - 1,
        tile_start_y, tile_start_y + tile_in_y - 1,
        tile_in_x, tile_in_y)
    elseif x_diff < 0 then
      updateTilesetBatchInRange(game,
        map.cache.tile_start_x + x_diff, map.cache.tile_start_x - 1,
        tile_start_y, tile_start_y + tile_in_y - 1,
        tile_in_x, tile_in_y)
    end
    
    local y_update_x1 = math.max(map.cache.tile_start_x,tile_start_x)
    local y_update_x2 = math.min(map.cache.tile_start_x + map.cache.tile_in_x - 1,tile_start_x + tile_in_x - 1)
    local y_diff = tile_start_y - map.cache.tile_start_y
    if y_diff > 0 then
      updateTilesetBatchInRange(game,
        y_update_x1 , y_update_x2,
        map.cache.tile_start_y + map.cache.tile_in_y, map.cache.tile_start_y + map.cache.tile_in_y + y_diff - 1,
        tile_in_x, tile_in_y)
    elseif y_diff < 0 then
      updateTilesetBatchInRange(game,
        y_update_x1 , y_update_x2,
        map.cache.tile_start_y + y_diff, map.cache.tile_start_y - 1,
        tile_in_x, tile_in_y)
    end
    
  end
  map.cache.tile_in_x = tile_in_x 
  map.cache.tile_in_y = tile_in_y 
  map.cache.tile_start_x = tile_start_x 
  map.cache.tile_start_y = tile_start_y 
  
  love.graphics.draw(map.cache.tilesetBatch)  
end


return Drawing