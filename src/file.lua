local File = {}

function File.load_lua(name)
  Log.debug("File - Loading file: " .. name)
  
  local ext = name:sub(-4, -1)
	assert(ext == ".lua", string.format(
			"Invalid file type: %s. File must be of type: lua.",
			ext
	))
  
  local ok, chunk, result, info
  info = love.filesystem.getInfo( name )
  if not info then
    local message = "Could not open file " .. name .. ". Does not exist."
    Log.error(message)
    return false, message
  end
  ok, chunk = pcall( love.filesystem.load, name ) -- load the chunk safely
  if not ok then
    Log.error(tostring(chunk))
    return false, chunk
  else
    ok, result = pcall(chunk) -- execute the chunk safely
   
    if not ok then -- will be false if there is an error
      Log.error(tostring(result))
      return false, result
    else
      Log.debug("File - Loading file: " .. name .. ". Done!")    
      return true, result
    end
  end
end

local image_cache = {}
function File.load_image( image_path , cache )
	-- body
  if cache == nil then cache = true end
	local image = image_cache[image_path]
	if not image or not cache then
		-- local default_path = "data/img/"
		local status, err = pcall( love.graphics.newImage , image_path )
		if status then
			image = err
		else
			Log.error(err)
			image = love.graphics.newImage("data/img/error.png")
		end
    if cache then
      image_cache[image_path] = image
    end
	end
	return image
end

return File
