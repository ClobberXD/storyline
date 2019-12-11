storyline = {}

local modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/"
dofile(modpath .. "helpers.lua")
dofile(modpath .. "api.lua")

dofile(modpath .. "test.lua")

--------------------------------------------------------------------------------

storyline.load()

minetest.register_on_shutdown(storyline.save)
