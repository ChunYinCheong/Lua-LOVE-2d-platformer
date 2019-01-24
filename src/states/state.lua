local State = {}
State.__index = State

function State:new( t )
  local o = t or {}
  setmetatable(o,self)
  o:init()
  return o
end

function State:init( )

end

function State:enter( game , k )

end

function State:update( dt , game , k )

end

function State:exit( game , k )

end

function State:transit(next_state , game , k)
  
end

function State:receive(command , game , k)
  if (type(command) == "table") then
    if command.name == "move" then
      local movement = game:get_entity_component( k , "movement" )
      if movement then
        movement.dx = command.dx
        movement.dy = command.dy
        movement.speed = command.speed
      end
      return true
    end
  else
    if command == "jump" then
      local map = game:get_map()
      local tran = game:get_entity_component( k , "transform" )
      local collision = game:get_entity_component(k,"collision")
      local x1 = tran.x - collision.width / 2
      local x2 = tran.x + collision.width / 2
      local y1 = tran.y - collision.height / 2
      local y2 = tran.y + collision.height / 2
      local fx = 0
      local fy = -500
      if map:detect_collision(x1,x2,y2,y2+8) then
        -- ground
      elseif map:detect_collision(x1,x1-8,y1,y2) then
        -- left
        fx = 600
      elseif map:detect_collision(x2,x2+8,y1,y2) then
        -- right
        fx = -600
      else
        return true
      end  
      
      local force = game:get_entity_component( k , "force" )
      if force then
        force.y = fy
        force.x = fx
      end
      return true
    elseif command == "attack" then
      local ok , e = game:load_entity("src/ecs/entities/projectile.lua")
      if ok then
        local tran = game:get_entity_component( k , "transform" )
        e.component.transform.x = tran.x + tran.dx * 50
        e.component.transform.y = tran.y + 2
      end
    end
  end
  return false
end

return State