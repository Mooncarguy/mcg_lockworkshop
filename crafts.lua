if minetest.get_modpath("default") then
	mcg_lockworkshop.register_craft("default:chest", "default:chest_locked")
end

if minetest.get_modpath("3d_armor_stand") then
	mcg_lockworkshop.register_craft("3d_armor_stand:armor_stand", "3d_armor_stand:locked_armor_stand")
end

if minetest.get_modpath("protector") then
	mcg_lockworkshop.register_craft("default:chest_locked", "protector:chest")
end
