local Log = {}


local function output( level , ... )
	-- body
	local info = debug.getinfo(3)
	-- %c	date and time (e.g., 09/16/98 23:48:10)
	-- %X	time (e.g., 23:48:10)
  local s = string.format("[%s] %s" , os.date("%X") , level )
  local s1 = info.name .. info.source  .. ":" .. info.currentline
	print( s , s1 , ... )
end


function Log.debug( ... )
	output('DEBUG' , ...)
end

function Log.warn( ... )
	output('!WARN !' , ...)
end

function Log.error( ... )
	output('!!!ERROR!!!' , ...)
end


return Log
