local function csp(name, str)
	minetest.chat_send_player(name, minetest.colorize("#AA33AA", str))
end

local evt_count = 0
local function new_event()
	evt_count = evt_count + 1
	return storyline.register_event({
		description = "Test Event " .. evt_count,
		on_run = function(name)
			local evt_id = storyline.get_script(name).curr_evt
			csp(name, "*** Event #" .. evt_id .. " | on_run(" .. name .. ")")
		end
	})
end

local test_events = {
	new_event(),
	new_event(),
	new_event(),
	new_event(),
	new_event(),
	new_event()
}


minetest.register_chatcommand("storyline_test", {
	description = "Initialise unit-tests",
	func = function(name)
		local msg = "*** Script | "
		storyline.set_script(name, {
			events = test_events,
			on_begin = function(name)
				csp(name, msg .. "on_begin")
			end,
			on_trigger_event = function(name)
				csp(name, msg .. "on_trigger_event")
			end,
			on_end = function(name)
				csp(name, msg .. "on_end")
			end
		})

		return true, "Initialised unit-tests. Type /storyline_begin to start the script."
	end
})

minetest.register_chatcommand("storyline_begin", {
	description = "Start unit-tests",
	func = function(name)
		storyline.begin_script(name)
		return true, "Started script. Type /storyline_finish_event to finish the current event."
	end
})

minetest.register_chatcommand("storyline_finish_event", {
	description = "Finish current event",
	func = function(name)
		storyline.finish_event(name)
	end
})

-- Commented out for now, as setting a nil script probably doesn't work yet
--[[
minetest.register_chatcommand("storyline_end", {
	description = "Terminate script.",
	func = function(name)
		storyline.set_script(name, nil)
	end
})
--]]
