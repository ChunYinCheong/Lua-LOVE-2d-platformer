local State = require "src.states.state"
local Idle = {}
Idle.__index = Idle
setmetatable(Idle,State)

function Idle:init( )

end

function Idle:enter( )

end

function Idle:update( )

end

function Idle:exit( )

end

return Idle