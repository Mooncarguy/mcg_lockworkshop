--All content of this file are licensed under MIT. See LICENSE.txt for more information.

mcg_lockworkshop = {}
mcg_lockworkshop.crafts = {}

mcg_lockworkshop.register_craft = function(item_from, item_to)
	if not minetest.registered_nodes[item_from] or not minetest.registered_nodes[item_to] then
		return
	end
	minetest.clear_craft({output = item_to})
	mcg_lockworkshop.crafts[item_from] = item_to
end

dofile(minetest.get_modpath("mcg_lockworkshop") .."/crafts.lua")

local function craft(pos, listname, index, stack, player)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1):get_name()
	local lock = inv:get_stack("lock", 1):is_empty()
	
	if mcg_lockworkshop.crafts[input] and inv:room_for_item("output", mcg_lockworkshop.crafts[input]) and not lock then
		inv:remove_item("input", {name = input, count = 1})
		inv:remove_item("lock", {name = "mcg_lockworkshop:lock", count = 1})
		inv:add_item("output", mcg_lockworkshop.crafts[input])
	end
end

minetest.register_node("mcg_lockworkshop:lock_workshop", {
	description = "Lock Workshop",
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	tiles = {
		"default_chest_top.png^mcg_lockworkshop_lock_workshop_top.png", "default_chest_top.png", 
		"default_chest_side.png^mcg_lockworkshop_lock_workshop_side_a.png","default_chest_side.png^mcg_lockworkshop_lock_workshop_side_b.png", 
		"default_chest_side.png^mcg_lockworkshop_lock_workshop_side_c.png", "default_chest_side.png^mcg_lockworkshop_lock_workshop_side_d.png"
	},
	after_place_node = function(pos) 
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		meta:set_string("infotext", "Lock Workshop")
		inv:set_size("input", 1)
		inv:set_size("lock", 1)
		inv:set_size("output", 1)
		meta:set_string("formspec", [[
			size[8,4.8]
			box[-0.01,0;1.84,0.9;#555555]
			image[0,0;1,1;mcg_lockworkshop_lock_workshop_side_a.png]
			label[1,0.25;Lock]
			list[context;input;2,0;1,1;]
			list[context;lock;3,0;1,1;]
			image[3,0;1,1;mcg_lockworkshop_lock_layout.png]
			image[4,0;1,1;gui_furnace_arrow_bg.png^[transformR270]
			list[context;output;5,0;1,1;]
			list[current_player;main;0,1.1;8,4;]
		]].. default.gui_bg .. default.gui_bg_img .. default.gui_slots .. default.get_hotbar_bg(0, 1.1))
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local stackname = stack:get_name()
		if (listname == "input" and mcg_lockworkshop.crafts[stackname]) or
			 (listname == "lock" and stackname == "mcg_lockworkshop:lock") then
			return stack:get_count()
		end
		return 0
	end,
	on_metadata_inventory_put = craft,
	on_metadata_inventory_take = craft,
	can_dig = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		if inv:is_empty("input") and inv:is_empty("lock") and inv:is_empty("output") then
			return true
		else
			return false
		end
end})

minetest.register_craft({
	output = "mcg_lockworkshop:lock_workshop",
	recipe = {
		{"group:wood", "group:stick", "group:wood"},
		{"group:stick", "default:steel_ingot", "group:stick"},
		{"group:wood", "group:stick", "group:wood"}
	}
})

minetest.register_craftitem("mcg_lockworkshop:lock", {
	description = "Lock",
	inventory_image = "mcg_lockworkshop_lock.png",
	wield_image = "mcg_lockworkshop_lock.png"
})

minetest.register_craft({
	output = "mcg_lockworkshop:lock 1",
	recipe = {
		{"","default:steel_ingot", ""},
		{"default:copper_ingot", "default:steel_ingot", "default:copper_ingot"}
	}
})
