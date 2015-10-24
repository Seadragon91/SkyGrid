cBlocksNether = {}
cBlocksNether.__index = cBlocksNether

function cBlocksNether.new()
	local self = setmetatable({}, cBlocksNether)

	self.m_MobTypes = { 57, 61, 62 }

	self:CreateBlockList();

	return self
end



function cBlocksNether:GetRandomBlock()
	local rnd = math.random(100)

	for _, list in pairs(self.blockList) do
		if ((rnd >= list.probability[1]) and (rnd <= list.probability[2])) then
			return self:GetFromBlockList(list.blocks)
		end
	end
end



function cBlocksNether:CheckSpecificBlocks(a_ChunkDesc, a_X, a_Y, a_Z, a_Block, a_Meta)
	local rnd = math.random(1, 100)

	if (rnd >= 90) then
		if (a_Block == E_BLOCK_NETHERRACK) then
			local rnd2 = math.random(1, 3)
			if (rnd2 == 1) then
				a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, E_BLOCK_BROWN_MUSHROOM)
			elseif (rnd == 2) then
				a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, E_BLOCK_RED_MUSHROOM)
			elseif (rnd == 3) then
				a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, E_BLOCK_FIRE)
			end
		end

		if (a_Block == E_BLOCK_SOULSAND) then
			a_ChunkDesc:SetBlockType(a_X, a_Y + 1, a_Z, E_BLOCK_NETHER_WART)
		end
	end

	if (a_Block == E_BLOCK_MOB_SPAWNER) then
		local mobSpawner = tolua.cast(a_ChunkDesc:GetBlockEntity(a_X, a_Y, a_Z), "cMobSpawnerEntity")
		mobSpawner:SetEntity(self.m_MobTypes[math.random(#self.m_MobTypes)])
		return
	end
end



function cBlocksNether:GetFromBlockList(a_BlockList)
	local block = a_BlockList[math.random(#a_BlockList)]

	-- Check if table
	if (type(block) == "table") then
		return block[1], math.random(block[2], block[3])
	end

	return block, 0
end



function cBlocksNether:CreateBlockList()
	self.blockList = {}
	self.blockList.abundant = {}
	self.blockList.abundant.probability = { 1, 65 }
	self.blockList.abundant.blocks =
	{
		E_BLOCK_NETHERRACK,
		E_BLOCK_SOULSAND
	}

	self.blockList.seldom = {}
	self.blockList.seldom.probability = { 66, 89 }
	self.blockList.seldom.blocks =
	{
		E_BLOCK_STATIONARY_LAVA,
		E_BLOCK_GRAVEL,
		E_BLOCK_GLOWSTONE
	}

	self.blockList.rare = {}
	self.blockList.rare.probability = { 90, 100 }
	self.blockList.rare.blocks =
	{
		E_BLOCK_NETHER_QUARTZ_ORE,
		E_BLOCK_MOB_SPAWNER,
		E_BLOCK_NETHER_BRICK
	}
end
