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
				if (meta == 0) then
					a_ChunkDesc:SetBlockType(x, y, z, block)
				else
					a_ChunkDesc:SetBlockTypeMeta(x, y, z, block, meta)
				end
				BLOCKS_OVERWORLD:CheckSpecificBlocks(a_ChunkDesc, x, y, z, block, meta)
			end

			for y = 66, 114, 4 do
				local block, meta = BLOCKS_NETHER:GetRandomBlock()
				if (meta == 0) then
					a_ChunkDesc:SetBlockType(x, y, z, block)
				else
					a_ChunkDesc:SetBlockTypeMeta(x, y, z, block, meta)
				end
				BLOCKS_NETHER:CheckSpecificBlocks(a_ChunkDesc, x, y, z, block, meta)
			end

			for y = 2, 62, 4 do
				local block, meta = BLOCKS_END:GetRandomBlock()
				if (meta == 0) then
					a_ChunkDesc:SetBlockType(x, y, z, block)
				else
					a_ChunkDesc:SetBlockTypeMeta(x, y, z, block, meta)
				end
				BLOCKS_END:CheckSpecificBlocks(a_ChunkDesc, x, y, z, block, meta)
			end
		end
	end
end



function OnCraftingNoRecipe(a_Player, a_Grid, a_Recipe)
	if (a_Player:GetWorld():GetName() ~= "skygrid") then
		return
	end

	local matchFound = CheckRecipes(a_Grid, a_Recipe)
	if (not matchFound) then
		return
	end
	return true
end
