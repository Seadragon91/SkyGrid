function OnPlayerBrokenBlock(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_BlockType, _BlockMeta)
	local world = a_Player:GetWorld()

	if (world:GetName() ~= "skygrid") then
		return
	end

	if (a_BlockType == E_BLOCK_SILVERFISH_EGG) then
		world:SpawnMob(a_BlockX, a_BlockY, a_BlockZ, mtSilverfish)
		return true
	end
end



function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	if (a_World:GetName() ~= "skygrid") then
		return
	end

	a_ChunkDesc:SetUseDefaultBiomes(false)
	a_ChunkDesc:SetUseDefaultHeight(false)
	a_ChunkDesc:SetUseDefaultComposition(false)
	a_ChunkDesc:SetUseDefaultFinish(false)

	for x = 0, 15, 4 do
		for z = 0, 15, 4 do
			for y = 118, 255, 4 do
				local block, meta = BLOCKS_OVERWORLD:GetRandomBlock()
				a_ChunkDesc:SetBlockTypeMeta(x, y, z, block, meta)
				BLOCKS_OVERWORLD:CheckSpecificBlocks(a_ChunkDesc, x, y, z, block, meta)
			end

			for y = 66, 114, 4 do
				
			end
		end
	end
end



function OnCraftingNoRecipe(a_Player, a_Grid, a_Recipe)
	if (a_Player:GetWorld():GetName() ~= "skygrid") then
		return
	end

	local resultItem, amountIngredient = CheckRecipes(a_Grid)
	if (resultItem == nil) then
		return
	end

	-- Set ingredient
	local sizeGrid = a_Grid:GetHeight()
	for x = 0, sizeGrid - 1 do
		for y = 0, sizeGrid - 1 do
			if (not a_Grid:GetItem(x, y):IsEmpty()) then
				a_Recipe:SetIngredient(x, y, a_Grid:GetItem(x, y).m_ItemType, amountIngredient, 0)
			end
		end
	end

	a_Recipe:SetResult(resultItem);
	a_Recipe:ConsumeIngredients(a_Grid)
	return true
end
