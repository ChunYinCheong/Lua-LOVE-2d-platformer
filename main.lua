-- Global 
Log = require "src.log"
-- Local
local Game = require "src.game"
local System = require "src.ecs.system.system"
local InputDispatch = require "src.inputdispatch"
local Drawing = require "src.ecs.system.drawing"

local profiling = false -- Cannot use breakpoint when profiling
if profiling then
  local Profiler = require "lib.ProFi" 
end

local game = nil

function love.load()
  -- Debug setting
  if arg[#arg] == "-debug" then 
    require("mobdebug").start() 
  end
  io.stdout:setvbuf("no")
  
  -- Create game
	game = Game:new()
  
	game:load_map("data/map/test.lua")
	local ok, entity = game:load_entity("data/prototype/superplayerchar.lua")
  if ok then
    debug_character = entity
    InputDispatch.push_handler(entity.component['playercontroller'])  
    game:get_camera():set_target(entity)
    entity.component.animation:play("data/animation/test.lua","run",true)
  end
  game:load_entity("src/ecs/entities/projectile.lua")
  if profiling then
    Profiler:start()
  end
end

function love.quit()
  if profiling then
    Profiler:stop()
    Profiler:writeReport('report.txt')
  end
end
 
function love.update(dt)
  System.update(dt , game)  
end

function love.draw()    
  Drawing.draw(game)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
  elseif key == "kp-" then
    game.camera:scale(0.5)
  elseif key == "kp+" then
    game.camera:scale(2)
	end
	InputDispatch.key_pressed(key)
end

function love.keyreleased(key)
	InputDispatch.key_released(key)
end
