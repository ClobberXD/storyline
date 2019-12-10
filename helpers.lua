function storyline.is_valid_event(evt)
	if type(evt) ~= "table" then
		return false
	end

	if not evt.description or type(evt.description) ~= "string" or
			not evt.on_run or type(evt.on_run) ~= "function" then
		return false
	end

	return true
end

function storyline.is_valid_script(script)
	if not script or type(script) ~= "table" then
		return false
	end

	if not script.events or type(script.events) ~= "table" then
		return false
	end

	local count = 1
	for i, evt_id in pairs(script.events) do
		-- Script table must be an array-type Lua table!
		-- Compare with count, to check for array-type table
		if type(i) ~= "number" or i ~= count then
			return false
		end

		-- Check if each event is valid
		if not storyline.get_event(evt_id) then
			return false
		end

		count = count + 1
	end

	return true
end
