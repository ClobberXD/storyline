local scripts = {}
local events  = {}

local copy = table.copy

do
local storage    = minetest.get_mod_storage()
local parse_json = minetest.parse_json
local write_json = minetest.write_json

function storyline.load()
	scripts = storage.contains("scripts") and parse_json(storage.get("scripts")) or {}
	events  = storage.contains("events")  and parse_json(storage.get("events"))  or {}
end

function storyline.save()
	storage.set_string("scripts", write_json("scripts"))
	storage.set_string("events",  write_json("events"))
end
end

-- Sets script to the following order of valid events
function storyline.set_script(name, script)
	if not storyline.is_valid_script(script) then
		error("storyline.set_script | Invalid script!", 2)
	end

	script.curr_evt = nil
	scripts[name] = script
end

function storyline.delete_script(name)
	scripts[name] = nil
end

function storyline.get_script(name)
	return copy(scripts[name])
end

-- Separate script setting from initialization, to defer the latter if need be
function storyline.begin_script(name)
	local script = scripts[name]
	if not script or script.curr_evt then
		return
	end

	-- Run script's on_begin callback
	if script.on_begin then
		script.on_begin(name)
	end

	-- Run the first event's on_run callback
	script.curr_evt = 1
	storyline.get_event(script.curr_evt).on_run(name)
end

-- Registers events, which can be later compiled into a script
-- Returns event ID
function storyline.register_event(evt)
	if not storyline.is_valid_event(evt) then
		error("storyline.register_event | Invalid event!", 2)
	end

	local evt_id   = #events + 1
	events[evt_id] = evt
	return evt_id
end

function storyline.get_event(evt_id)
	return copy(events[evt_id])
end

function storyline.finish_event(name)
	local script = scripts[name]
	if not script then
		return
	end

	-- If finished event is the last event in script, finish script. Else
	-- bump to next event, invoke on_trigger_event and the event's on_run
	if script.curr_evt == #script.events and script.on_end then
		script.on_end(name)
	else
		script.curr_evt = script.curr_evt + 1
		if script.on_trigger_event then
			script.on_trigger_event(name)
		end
		storyline.get_event(script.curr_evt).on_run(name)
	end
end
