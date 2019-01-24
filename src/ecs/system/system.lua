local System = {}

local function update_transform( entity_id , x , y , game)
	-- body
	local transform = game:get_entity_component(entity_id,"transform")
	if transform then
		local new_x = transform.x + x
		local new_y = transform.y + y

		local collision = game:get_entity_component(entity_id,"collision")
		if collision then
			-- Collision checking with tile map
			local map = game:get_map()

      local min_x = new_x - collision.width / 2
      local max_x = new_x + collision.width / 2
      local min_y = new_y - collision.height / 2
      local max_y = new_y + collision.height / 2

      if map:detect_collision(min_x,max_x,min_y,max_y) then
        return {
          collider_type = "map",
          collider_id = nil
        }        
      end
      
      for k2 , c2 in pairs( game:get_component_table("collision") ) do
        if entity_id ~= k2 then
          if collision.check_layer_and_mask(collision,c2) then
            local t2 = game:get_entity_component( k2 , "transform" )
            if t2 then
              local ax = math.abs(new_x - t2.x)
              local w = ( collision.width + c2.width ) / 2
              if w >= ax then
                local ay = math.abs(new_y - t2.y)
                local h = ( collision.height + c2.height ) / 2
                if h >= ay then
                  return {
                    collider_type = "collision",
                    collider_id = k2
                  }   
                end
              end
            end
          end
        end
      end
      
			transform.x = new_x
			transform.y = new_y				
		else
			transform.x = new_x
			transform.y = new_y
		end
	else
		Log.warn("Transofrm component not found for entity: " .. entity_id)
	end
  return nil
end

local function send_collision_event(game , k , k2 , event)
  if k then
    local e = {}
    e.collider_type = event.collider_type
    e.collider_id = k2
    table.insert( game:get_entity_component(k,"collision").event , e )
  end
  if k2 then
    local e = {}
    e.collider_type = event.collider_type
    e.collider_id = k
    table.insert( game:get_entity_component(k2,"collision").event , e )
  end
end

function System.update( dt , game )

  -- Player Controller System
  for k,v in pairs( game:get_component_table("playercontroller") ) do
    -- v:update(dt,game,k)
    if #v.commands > 0 then
      local u = game:get_entity_component( k , "unit")
      if u then
        for i,c in ipairs (v.commands) do
          v.commands [i] = nil
          u.state:receive(c , game , k)
        end
      else
        v.commands = {}
        Log.warn("Unit component not found for entity: " .. k )
      end
    end
	end
  -- AI Controller System
  for k,v in pairs( game:get_component_table("aicontroller") ) do
    -- v:update(dt,game,k)
	end
  
  -- Unit
  for k,v in pairs( game:get_component_table("unit") ) do
    if v.state then
      local n = v.state:update( dt , game , k )
      if n then
        v:switch_state(n)
      end
    end
	end
  
  -- Movement System
  for k,v in pairs( game:get_component_table("movement") ) do
    if v.speed ~= 0 then
      local t = game:get_entity_component(k,"transform")
      if t then
        t:push_move(v.dx * v.speed , v.dy * v.speed )
      end
    end
	end
  
  --[[
	-- Gravity System
	for k,v in pairs( game:get_component_table("gravity") ) do
		local y = ( v.gravity - v.velocity ) * dt
		v.velocity = math.max( v.velocity - dt * v.gravity , 0 )
		update_transform( k , 0 , y , game )
	end
  --]]
  
  -- Force System
	for k,v in pairs( game:get_component_table("force") ) do
    local t = game:get_entity_component(k,"transform")
    if t then
      t:push_move(v.x * dt , v.y * dt)
    end

    if v.x > v.base_x then
      v.x = v.x - v.step_x * dt
      if v.x < v.base_x then
        v.x = v.base_x
      end
    elseif v.x < v.base_x then
      v.x = v.x + v.step_x * dt
      if v.x > v.base_x then
        v.x = v.base_x
      end
    end
    if v.y > v.base_y then
      v.y = v.y - v.step_y * dt
      if v.y < v.base_y then
        v.y = v.base_y
      end
    elseif v.y < v.base_y then
      v.y = v.y + v.step_y * dt
      if v.y > v.base_y then
        v.y = v.base_y
      end
    end
	end
  
	-- Lifespan System
	for k,v in pairs( game:get_component_table("lifespan") ) do
		v.time = v.time - dt
		if v.time <= 0 then
			game:remove_entity( k )
		end
	end
  
  -- Transform System
	for k,v in pairs( game:get_component_table("transform") ) do
		-- TODO: handle collision duplicate, eg: tile
    local t = update_transform( k , v._ox , 0  , game )
    if t then
      send_collision_event(game, k, t.collider_id, t)
    end
    local t2 = update_transform( k , 0 , v._oy  , game )
    if t2 then
      if not t1 or t1.collider_id ~= t2.collider_id then
        send_collision_event(game, k, t2.collider_id, t2)
      end
    end
    
    v:reset_move()
	end
  
  -- Collision System
  for k,v in pairs( game:get_component_table("collision") ) do
    if #v.event > 0 then
      for i,e in ipairs (v.event) do
        v.event [i] = nil
        v:on_collision(e , game , k)
      end
    end
	end
  
  -- Animation
  for k,v in pairs( game:get_component_table("animation") ) do
    for _,a in ipairs(v._list) do
      a.time = a.time + dt
    end
  end
  
end


return System
