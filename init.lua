--All content of this file are licensed under MIT. See LICENSE.txt for more information.


mcg_lockworkshop_crafts = {}

dofile(minetest.get_modpath("mcg_lockworkshop").."/config.txt")

--default support
if minetest.get_modpath("default") then
	dofile(minetest.get_modpath("mcg_lockworkshop").."/crafts_default.lua")
end

--hec_nopvp support
if minetest.get_modpath("hec_nopvp") then
	dofile(minetest.get_modpath("mcg_lockworkshop").."/crafts_hec_nopvp.lua")
end

--drawers support
if wl2_drawers == true then
	if minetest.get_modpath("drawers") then
		dofile(minetest.get_modpath("mcg_lockworkshop").."/crafts_drawers.lua")
	end
end

--3d_armor_stand support
if minetest.get_modpath("3d_armor_stand") then
	dofile(minetest.get_modpath("mcg_lockworkshop").."/crafts_3d_armor_stand.lua")
end

--protector support
if minetest.get_modpath("protector") then
	dofile(minetest.get_modpath("mcg_lockworkshop").."/crafts_protector.lua")
end


--Lock
minetest.register_craftitem("mcg_lockworkshop:lock", {
	description = "Lock",
	inventory_image = "mcg_lockworkshop_lock.png",
	wield_image = "mcg_lockworkshop_lock.png"
})

minetest.register_craft({
	output = "mcg_lockworkshop:lock 3",
	recipe = {
		{"","default:steel_ingot", ""},
		{"default:copper_ingot", "default:steel_ingot", "default:copper_ingot"}
	}
})


-- Lock Workshop
minetest.register_node ("mcg_lockworkshop:lock_workshop", {
	tiles = {
		"default_chest_top.png^mcg_lockworkshop_lock_workshop_top.png", "default_chest_top.png", 
		"default_chest_side.png^mcg_lockworkshop_lock_workshop_side_a.png","default_chest_side.png^mcg_lockworkshop_lock_workshop_side_b.png", 
		"default_chest_side.png^mcg_lockworkshop_lock_workshop_side_c.png", "default_chest_side.png^mcg_lockworkshop_lock_workshop_side_d.png"
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	description = "Lock Workshop",
	after_place_node = function (pos) 
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		meta:set_string("infotext", "Lock Workshop") 
		inv:set_size("input_a", 1)
		inv:set_size("input_b", 1)
		inv:set_size("output", 1)
		meta:set_string("formspec", [[
			size[8,6.75]
			list[context;input_a;3,0;1,1;]
			list[context;input_b;4,0;1,1;]
			list[context;output;3.5,1.5;1,1;]
			list[current_player;main;0,3;8,4;]
			label[2,0;Input:]
			label[2,1.5;Output:]
		]])
	end,
	can_dig = function (pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("input_a") == true and inv:is_empty("input_b") == true and inv:is_empty("output") == true then
			return true
		else
			return false
		end
	end
})

minetest.register_craft({
	output = "mcg_lockworkshop:lock_workshop",
	recipe = {
		{"group:wood", "group:stick", "group:wood"},
		{"group:stick", "default:steel_ingot", "group:stick"},
		{"group:wood", "group:stick", "group:wood"}
	}
})

minetest.register_abm ({
	nodenames = {"mcg_lockworkshop:lock_workshop"},
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local input_a_stack = inv:get_stack("input_a", 1)
		local input_b_stack = inv:get_stack("input_b", 1)
		local input_a_name = input_a_stack:get_name()
		local input_b_name = input_b_stack:get_name()
		local input_a_type = string.gsub(input_a_name, ":", "-")
		local input_b_type = string.gsub(input_b_name, ":", "-")

		if inv:room_for_item ("output", mcg_lockworkshop_crafts[input_a_type.."-"..input_b_type]) and 
		mcg_lockworkshop_crafts[input_a_type.."-"..input_b_type] then
			inv:remove_item("input_a", {name = input_a_name, count=1})
			inv:remove_item("input_b", {name = input_b_name, count=1})
			inv:add_item ("output", mcg_lockworkshop_crafts[input_a_type.."-"..input_b_type])
		elseif inv:room_for_item("output", mcg_lockworkshop_crafts[input_b_type.."-"..input_a_type]) and
		mcg_lockworkshop_crafts[input_b_type.."-"..input_a_type] then
			inv:remove_item("input_a", {name = input_a_name, count=1})
			inv:remove_item("input_b", {name = input_b_name, count=1})
			inv:add_item ("output", mcg_lockworkshop_crafts[input_b_type.."-"..input_a_type])
		end

	end,
	interval = 0.5
})