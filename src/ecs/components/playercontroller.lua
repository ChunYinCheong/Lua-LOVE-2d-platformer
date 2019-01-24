local MoveCommand = require "src.commands.move"

local PlayerController = {
  commands = nil,
  is_right_down = false,
  is_left_down = false,
  is_right_down_first = false,
  is_left_down_first = false,
  is_up_down = false, 
  movement = 0,
  is_attack_down = false,
  
  move = function (self)
    local c = MoveCommand:new()
    c.dx = self.movement
    c.speed = 5 * math.abs(self.movement)
    table.insert(self.commands,c)
  end,
  
  update = function (self,dt,game,k)    

  end,
  key_pressed = function ( self , key ) 
    if key == 'right' then
      self.is_right_down = true
      self.movement = self.movement + 1
      if not self.is_left_down then
        self.is_right_down_first = true
        self.movement = 1
      end
      self:move()
      return true
    elseif key == 'left' then
      self.is_left_down = true
      self.movement = self.movement - 1
      if not self.is_right_down then
        self.is_left_down_first = true
        self.movement = -1
      end
      self:move()
      return true
    elseif key == 'up' then
      self.is_up_down = true      
      table.insert(self.commands,"jump")
      return true
    elseif key == 'z' then
      self.is_attack_down = true
      return true
    end
  end,
  key_released = function ( self , key  )
    if key == 'right' then
      self.is_right_down = false
      self.is_right_down_first = false
      self.movement = self.movement - 1
      if self.is_left_down_first then
        self.movement = self.movement - 1
      elseif self.is_left_down then
        self.movement = -1
        self.is_left_down_first = true
      else
        self.movement = 0 
      end
      self:move()
      return true
    elseif key == 'left' then
      self.is_left_down = false
      self.is_left_down_first = false
      self.movement = self.movement + 1
      if self.is_right_down_first then
        self.movement = self.movement + 1
      elseif self.is_right_down then
        self.movement = 1
        self.is_right_down_first = true
      else
        self.movement = 0 
      end
      self:move()
      return true
    elseif key == 'up' then
      self.is_up_down = false
      return true
    elseif key == 'z' then
      table.insert(self.commands,"attack")
      return true
    end
  end
}

function PlayerController:init()
  self.commands = {}
end

PlayerController.__index = PlayerController

return PlayerController