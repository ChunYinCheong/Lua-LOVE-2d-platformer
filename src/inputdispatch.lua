local Input = {}

local input_handler = {}

function Input.push_handler( handler )
	-- body
	local i = #input_handler + 1
	input_handler[i] = handler
end

function Input.pop_handler()
	-- body
	local i = #input_handler
	local handler = input_handler[i]
	input_handler[i] = nil
	return handler
end

function Input.key_pressed( key )
	for i = #input_handler , 1 , -1 do
		if input_handler[i]:key_pressed(key) then
			return
		end
	end
end

function Input.key_released( key )
	for i = #input_handler , 1 , -1 do
		if input_handler[i]:key_released(key) then
			return
		end
	end
end

return Input
