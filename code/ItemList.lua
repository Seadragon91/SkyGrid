function GetRandomItems()
	local rnd = math.random(100)
	local items = cItems()

	for _, list in pairs(chestContent) do
		if ((rnd >= list.probability[1]) and (rnd <= list.probability[2])) then
			for amount = 1, math.random(1, list.amountItems) do
				items:Add(GetItemFromList(list.items, math.random(list.itemCount[1], list.itemCount[2])))
			end
			return items
		end
	end

	return items
end


function GetItemFromList(a_ItemList, a_ItemCount)
	local obj = a_ItemList[math.random(#a_ItemList)]
	local item = cItem()

	-- Check if table
	if (type(obj) == "table") then
		if (#obj == 3) then
			item.m_ItemType = obj[1]
			item.m_ItemDamage = math.random(obj[2], obj[3])
			item.m_ItemCount = a_ItemCount
		elseif (#obj == 2) then
			item.m_ItemType = obj[1]
			item.m_ItemDamage = math.random(1, #obj[2])
			item.m_ItemCount = a_ItemCount
		end
		return item
	end

	item.m_ItemType = obj
	item.m_ItemCount = a_ItemCount
	return item
end


chestContent = {}
chestContent.building_blocks = {}
chestContent.building_blocks.amountItems = 4
chestContent.building_blocks.itemCount = { 5, 10 }
chestContent.building_blocks.probability = { 45, 95 }
chestContent.building_blocks.items =
{
	{ E_BLOCK_PLANKS, 0, 5 },
	E_BLOCK_STONE,
	{ E_BLOCK_LOG, 0, 3 },
	{ E_BLOCK_NEW_LOG, 0, 1 },
	{ E_BLOCK_SAND, 0, 1 },
	{ E_BLOCK_SANDSTONE, 0, 2 },
	{ E_BLOCK_RED_SANDSTONE, 0, 2 },
	E_BLOCK_DIRT,
	E_BLOCK_GRAVEL,
	E_BLOCK_COBBLESTONE,
}

chestContent.material_items = {}
chestContent.material_items.amountItems = 4
chestContent.material_items.itemCount = { 3, 8 }
chestContent.material_items.probability = { 30, 44 }
chestContent.material_items.items =
{
	E_ITEM_PAPER,
	E_BLOCK_TORCH,
	E_ITEM_STICK,
	E_ITEM_LEATHER,
	E_ITEM_SNOWBALL,
	E_ITEM_WHEAT,
	E_BLOCK_SAPLING,
	E_ITEM_STRING,
	E_ITEM_CLAY,
	E_ITEM_DYE,
	E_ITEM_COAL,
	E_ITEM_ARROW
}

chestContent.food_items = {}
chestContent.food_items.amountItems = 3
chestContent.food_items.itemCount = { 3, 8 }
chestContent.food_items.probability = { 20, 29 }
chestContent.food_items.items =
{
	E_ITEM_COOKED_PORKCHOP,
	E_ITEM_STEAK,
	E_ITEM_COOKED_MUTTON,
	{ E_ITEM_COOKED_FISH, 0, 3 },
	E_ITEM_BAKED_POTATO,
	E_ITEM_COOKED_CHICKEN,
	E_ITEM_RABBIT_STEW,
	E_ITEM_MUSHROOM_SOUP,
	E_ITEM_BREAD,
	E_ITEM_CARROT,
	E_ITEM_PUMPKIN_PIE,
	E_ITEM_RED_APPLE,
	E_ITEM_RAW_BEEF,
	E_ITEM_RAW_PORKCHOP,
	E_ITEM_RAW_MUTTON,
	E_ITEM_RAW_CHICKEN,
	E_ITEM_RAW_RABBIT,
	E_ITEM_POISONOUS_POTATO,
	E_ITEM_MELON_SLICE,
	E_ITEM_POTATO,
	E_ITEM_COOKIE,
	E_ITEM_ROTTEN_FLESH,
	{ E_ITEM_RAW_FISH, 0, 3 }
}

chestContent.equipment_items = {}
chestContent.equipment_items.amountItems = 2
chestContent.equipment_items.itemCount = { 1, 1 }
chestContent.equipment_items.probability = { 10, 19 }
chestContent.equipment_items.items =
{
	E_ITEM_STONE_SWORD,
	E_ITEM_STONE_AXE,
	E_ITEM_STONE_PICKAXE,
	E_ITEM_STONE_SHOVEL,
	E_ITEM_STONE_HOE,
	E_ITEM_BOW,
	E_ITEM_LEATHER_BOOTS,
	E_ITEM_LEATHER_TUNIC,
	E_ITEM_LEATHER_CAP,
	E_ITEM_LEATHER_PANTS,

}

chestContent.rare_items = {}
chestContent.rare_items.amountItems = 1
chestContent.rare_items.itemCount = { 1, 1 }
chestContent.rare_items.probability = { 4, 9 }
chestContent.rare_items.items =
{
	E_ITEM_BUCKET,
	E_ITEM_IRON_PICKAXE,
	E_ITEM_BED,
	E_BLOCK_VINES,
	E_ITEM_WATER_BUCKET,
	E_ITEM_LAVA_BUCKET,
	E_ITEM_MILK,
	E_ITEM_IRON,
	E_ITEM_GOLD,
	E_ITEM_GUNPOWDER,
	E_ITEM_BONE,
	E_BLOCK_OBSIDIAN,
	E_BLOCK_CACTUS,
	E_ITEM_SUGARCANE,
}

chestContent.legendary_items = {}
chestContent.legendary_items.amountItems = 1
chestContent.legendary_items.itemCount = { 1, 1 }
chestContent.legendary_items.probability = { 1, 3 }
chestContent.legendary_items.items =
{
	E_ITEM_13_DISC,
	E_ITEM_CAT_DISC,
	E_ITEM_BLOCKS_DISC,
	E_ITEM_CHIRP_DISC,
	E_ITEM_FAR_DISC,
	E_ITEM_MALL_DISC,
	E_ITEM_MELLOHI_DISC,
	E_ITEM_STAL_DISC,
	E_ITEM_STRAD_DISC,
	E_ITEM_WARD_DISC,
	E_ITEM_11_DISC,
	E_ITEM_LAST_DISC,
	E_ITEM_LAST_DISC_PLUS_ONE,
	{ E_ITEM_SPAWN_EGG, { 90, 91, 92, 93, 95, 100, 101, 120 } },
	E_ITEM_DIAMOND,
	E_ITEM_EMERALD,
	E_ITEM_BOTTLE_O_ENCHANTING,
	E_ITEM_SADDLE,
	E_ITEM_NAME_TAG,
	E_ITEM_GOLDEN_APPLE,
	E_ITEM_GOLDEN_CARROT
}
