local MapDrawing = require "src.ecs.system.mapdrawing"
local File = require "src.file"

local Drawing = {}
Drawing.__index = Drawing

function Drawing.draw(game)  
  local c = game:get_camera()
  local x , y  =  c:get_position()
  local sx , sy  =  c:get_scale()
  local r = c:get_rotate()
  local width, height = love.graphics.getDimensions( )
  love.graphics.push()
  love.graphics.translate(width / 2 , height / 2)  
  love.graphics.scale(sx , sy)
  love.graphics.rotate(r)
  love.graphics.translate(-x , -y)  
  
  -- Tile Map
  MapDrawing.draw(game)
  
  -- Graphics
	for k,v in pairs( game:get_component_table("graphics") ) do
		local transform = game:get_entity_component( k , "transform" )
		if transform then
			local x = transform.x - v.width / 2
			local y = transform.y - v.height / 2
			local r = 0
			local sx = transform.dx
			local image = File.load_image(v.image_path)
			love.graphics.draw( image, x , y , r, sx) -- Update to use offset if necessary  
      --love.graphics.setColor(0,255,0)
      love.graphics.print( math.floor(x)..' / '..math.floor(y),x,y,0,3)
      --love.graphics.setColor(255,255,255)
		end
	end  
  
  -- Animation
  game.cache.animation = game.cache.animation  or {}
  local animation_cache = game.cache.animation 
  for k,v in pairs( game:get_component_table("animation") ) do
		local transform = game:get_entity_component( k , "transform" )
		if transform then
      for i,a in ipairs(v._list) do
        local data = animation_cache[a.path]
        if not data then
          local ok , result = File.load_lua(a.path)
          if ok then
            data = result
            animation_cache[a.path] = data
            data.cache = {}
            data.cache.image = File.load_image(data.sprite_sheet)
            data.cache.mapping = {}
            for an,aq in pairs(data.mapping) do
              data.cache.mapping[an] = {}              
              data.cache.mapping[an].quads = {}
              for i2,q in ipairs(aq.quads) do
                data.cache.mapping[an].quads[i2] = love.graphics.newQuad(q.x, q.y, q.w, q.h, 
                  data.cache.image:getDimensions())
              end
            end
          else
            Log.warn("Animation file not found! Path: " .. a.path)
          end
        end
        if data then
          local animation_data = data.mapping[a.name]
          if animation_data then
            a.time = a.time % animation_data.duration
            local spriteNum = math.floor(a.time / animation_data.duration * #animation_data.quads) + 1
            local x = transform.x - animation_data.quads[spriteNum].w / 2
            local y = transform.y - animation_data.quads[spriteNum].h / 2
            love.graphics.draw(data.cache.image, data.cache.mapping[a.name].quads[spriteNum], x, y, r, sx)
          else
            Log.warn("Animation data not found! Name: " .. a.name .. " Path: " .. a.path)
          end
        end
      end
    else
      Log.warn("Transofrm component not found for entity: " .. k)
		end
	end
  
  -- Collision
  for k,v in pairs( game:get_component_table("collision") ) do
		local transform = game:get_entity_component( k , "transform" )
		if transform then
			local x = transform.x - v.width / 2
			local y = transform.y - v.height / 2
			love.graphics.rectangle( "line", x, y, v.width, v.height )
		end
	end
  
  -- Lifespan
	for k,v in pairs( game:get_component_table("lifespan") ) do
		local transform = game:get_entity_component( k , "transform" )
		if transform then
      love.graphics.print( math.floor(v.time),transform.x,transform.y,0,3,3,0,-5)
    end
	end
  
  love.graphics.pop()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Current size: "..tostring(width / sx).." / "..tostring(height / sy), 10, 30)
end



return Drawing