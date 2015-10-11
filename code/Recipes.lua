function CheckRecipes(a_CraftingGrid)
	for _, recipe in pairs(shapelessRecipes) do
		local resultItem, amountIngredient = recipe:CheckIfMatch(a_CraftingGrid)
		if (resultItem ~= nil) then
			return resultItem, amountIngredient
		end
	end

	for _, recipe in pairs(shapedRecipes) do
		local resultItem, amountIngredient = recipe:CheckIfMatch(a_CraftingGrid)
		if (resultItem ~= nil) then
			return resultItem, amountIngredient
		end
	end

	return nil
end



function CreateRecipes()
	shapelessRecipes =
	{
		cShapelessRecipe.new(cItem(E_ITEM_WATER_BUCKET, 2))
		:AddIngredient(1, E_ITEM_WATER_BUCKET)
		:AddIngredient(1, E_ITEM_BUCKET),

		cShapelessRecipe.new(cItem(E_ITEM_LAVA_BUCKET, 1))
		:AddIngredient(1, E_BLOCK_OBSIDIAN)
		:AddIngredient(1, E_ITEM_BLAZE_ROD)
		:AddIngredient(1, E_ITEM_FLINT_AND_STEEL)
		:AddIngredient(1, E_ITEM_BUCKET),

		cShapelessRecipe.new(cItem(E_ITEM_ENDER_PEARL, 2))
		:AddIngredient(4, E_BLOCK_COBBLESTONE),

		cShapelessRecipe.new(cItem(E_ITEM_BLAZE_ROD, 1))
		:AddIngredient(1, E_ITEM_RAW_FISH)
		:AddIngredient(1, E_ITEM_RAW_FISH, E_META_RAW_FISH_SALMON)
	}

	shapedRecipes =
	{
		cShapedRecipe.new(cItem(E_ITEM_BLAZE_ROD, 1))
		:Shape("S W", " X ", "W S")
		:SetIngredient("S", E_ITEM_RAW_FISH)
		:SetIngredient("W", E_ITEM_RAW_FISH, E_META_RAW_FISH_SALMON)
		:SetIngredient("X", E_BLOCK_OBSIDIAN),

		cShapedRecipe.new(cItem(E_BLOCK_OBSIDIAN, 1))
		:Shape(" S","SBS"," S")
		:SetIngredient("S", E_BLOCK_STONE):SetIngredient("S", E_BLOCK_COBBLESTONE) -- Different items for same char possible
		:SetIngredient("B", E_ITEM_BLAZE_ROD),

		cShapedRecipe.new(cItem(E_BLOCK_COBWEB, 1))
		:Shape("W W"," W","W W")
		:SetIngredient("W", E_ITEM_STRING),

		cShapedRecipe.new(cItem(E_BLOCK_END_PORTAL_FRAME, 1))
		:Shape("BIB","ECE","EEE")
		:SetIngredient("B", E_ITEM_BLAZE_ROD)
		:SetIngredient("I", E_ITEM_ENDER_PEARL)
		:SetIngredient("E", E_BLOCK_END_STONE)
		:SetIngredient("C", E_ITEM_CAULDRON),
	}
end
