cBlocksOverworld = {}
cBlocksOverworld.__index = cBlocksOverworld

function cBlocksOverworld.new()
	local self = setmetatable({}, cBlocksOverworld)

	self.m_FoodTypes = { E_BLOCK_POTATOES, E_BLOCK_CROPS,  E_BLOCK_CARROTS }
	self.m_MobTypes = { 50, 51, 52, 54, 55, 59, 65 }

	self:CreateBlockList();

	return self
end



function cBlocksOverworld:GetRandomBlock()
	local rnd = math.random(100)

	for _, list in pairs(self.blockList) do
		if ((rnd >=list.probability[1]) and (rnd <= list.probability[2])) then
			return self:GetFromBlockList(list.blocks)
		end
	end
end



function cBlocksOverworld:CheckSpecificBlocks(a_ChunkDesc, a_X, a_Y, a_Z, a_Block, a_Meta)
	local rnd = math.random(1, 100)

	if ((rnd >= 75) and (a_X > 0) and (a_X < 15) and (a_Z > 0) and (a_Z < 15)) then
		local rnd2 = math.random(0, 3)
		if ((a_Block == E_BLOCK_LOG) and (a_Meta == 3)) then
			local x = a_X
			local z = a_Z
			if (rnd2 == 0) then
				z = z - 1
			elseif (rnd2 == 1) then
				x = x + 1
			elseif (rnd2 == 2) then
				z = z + 1
			elseif (rnd2 == 3) then
				x = x - 1
			end
			a_ChunkDesc:SetBlockTypeMeta(x, a_Y, z, E_BLOCK_COCOA_POD, rnd2)
			return
		end

		if (a_Block == E_BLOCK_SAND) then
			if (rnd2 == 0) then
				a_ChunkDesc:SetBlockType(a_X - 1, a_Y, a_Z, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 1) then
				a_ChunkDesc:SetBlockType(a_X + 1, a_Y, a_Z, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 2) then
				a_ChunkDesc:SetBlockType(a_X, a_Y, a_Z - 1, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 3) then
				a_ChunkDesc:SetBlockType(a_X, a_Y, a_Z + 1, E_BLOCK_STATIONARY_WATER)
			end
			a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, E_BLOCK_SUGARCANE)
			return
		end

		if (a_Block == E_BLOCK_DIRT) then
			if (rnd2 == 0) then
				a_ChunkDesc:SetBlockType(a_X - 1, a_Y, a_Z, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 1) then
				a_ChunkDesc:SetBlockType(a_X + 1, a_Y, a_Z, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 2) then
				a_ChunkDesc:SetBlockType(a_X, a_Y, a_Z - 1, E_BLOCK_STATIONARY_WATER)
			elseif (rnd2 == 3) then
				a_ChunkDesc:SetBlockType(a_X, a_Y, a_Z + 1, E_BLOCK_STATIONARY_WATER)
			end
			a_ChunkDesc:SetBlockType(a_X, a_Y, a_Z, E_BLOCK_FARMLAND)
			a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, self.m_FoodTypes[math.random(#self.m_FoodTypes)])
			return
		end
	end

	if ((rnd >= 75) and (a_Block == E_BLOCK_GRASS)) then
		if (a_Y > 230) then
			return
		end
		local sapling = math.random(0, 5)
		if ((sapling == 3) and (a_Y > 200)) then
			return
		end
		a_ChunkDesc:SetBlockTypeMeta(a_X, a_Y + 1, a_Z, E_BLOCK_SAPLING, sapling)
		return
	end

	if (a_Block == E_BLOCK_CHEST) then -- Todo: Testing required: More chests, more items?
		local chest = tolua.cast(a_ChunkDesc:GetBlockEntity(a_X, a_Y, a_Z), "cChestEntity")
		chest:GetContents():AddItems(GetRandomItems())
		return
	end

	if (a_Block == E_BLOCK_MOB_SPAWNER) then
		local mobSpawner = tolua.cast(a_ChunkDesc:GetBlockEntity(a_X, a_Y, a_Z), "cMobSpawnerEntity")
		mobSpawner:SetEntity(self.m_MobTypes[math.random(#self.m_MobTypes)])
		return
	end
end



function cBlocksOverworld:GetFromBlockList(a_BlockList)
	local block = a_BlockList[math.random(#a_BlockList)]

	-- Check if table
	if (type(block) == "table") then
		return block[1], math.random(block[2], block[3])
	end

	return block, 0
end



function cBlocksOverworld:CreateBlockList()
	self.blockList = {}
	self.blockList.abundant = {}
	self.blockList.abundant.probability = { 1, 84 }
	self.blockList.abundant.blocks =
	{
		E_BLOCK_STONE,
		E_BLOCK_DIRT,
		E_BLOCK_COBBLESTONE,
		{ E_BLOCK_PLANKS,  0, 5 },
		{ E_BLOCK_LOG, 0, 3 },
		{ E_BLOCK_NEW_LOG, 0, 1 },
		{ E_BLOCK_SILVERFISH_EGG, 0, 5 }
	}

	self.blockList.seldom = {}
	self.blockList.seldom.probability = { 85, 89 }
	self.blockList.seldom.blocks =
	{
		E_BLOCK_GRASS,
		{ E_BLOCK_SAND, 0, 1 },
		{ E_BLOCK_SANDSTONE, 0, 2 },
		{ E_BLOCK_RED_SANDSTONE, 0, 2 },
		E_BLOCK_GRAVEL,
		E_BLOCK_WOOL
	}

	self.blockList.rare = {}
	self.blockList.rare.probability = { 90, 93 }
	self.blockList.rare.blocks =
	{
		E_BLOCK_IRON_ORE,
		E_BLOCK_COAL_ORE,
		E_BLOCK_GLASS,
		E_BLOCK_SNOW_BLOCK,
		E_BLOCK_PRISMARINE_BLOCK,
		E_BLOCK_SEA_LANTERN,
		E_BLOCK_HAY_BALE,
		E_BLOCK_CAKE,
		E_BLOCK_MELON,
		E_BLOCK_PUMPKIN,
		E_BLOCK_COAL_ORE,
	}

	self.blockList.epic = {}
	self.blockList.epic.probability = { 94, 96 }
	self.blockList.epic.blocks =
	{
		E_BLOCK_GOLD_ORE,
		E_BLOCK_STATIONARY_LAVA,
		E_BLOCK_STATIONARY_WATER,
		E_BLOCK_LAPIS_ORE,
		E_BLOCK_NOTE_BLOCK,
		E_BLOCK_BOOKCASE,
		E_BLOCK_OBSIDIAN,
		E_BLOCK_SLIME_BLOCK,
		{ E_BLOCK_CHEST, 2, 5 }
	}

	self.blockList.legend = {}
	self.blockList.legend.probability = { 97, 100 }
	self.blockList.legend.blocks =
	{
		E_BLOCK_SPONGE,
		E_BLOCK_LAPIS_BLOCK,
		E_BLOCK_GOLD_BLOCK,
		E_BLOCK_IRON_BLOCK,
		E_BLOCK_TNT,
		E_BLOCK_MOB_SPAWNER,
		{ E_BLOCK_ENDER_CHEST, 2, 5 },
		E_BLOCK_DIAMOND_ORE,
		E_BLOCK_MYCELIUM
	}
end
