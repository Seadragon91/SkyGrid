cBlocksEnd = {}
cBlocksEnd.__index = cBlocksEnd

function cBlocksEnd.new()
	local self = setmetatable({}, cBlocksEnd)

	self.m_MobTypes = { 58, 67 }

	self:CreateBlockList();

	return self
end



function cBlocksEnd:GetRandomBlock()
	local rnd = math.random(100)

	for _, list in pairs(self.blockList) do
		if ((rnd >= list.probability[1]) and (rnd <= list.probability[2])) then
			return self:GetFromBlockList(list.blocks)
		end
	end
end



function cBlocksEnd:CheckSpecificBlocks(a_ChunkDesc, a_X, a_Y, a_Z, a_Block, a_Meta)
	local rnd = math.random(1, 100)

	if (a_Block == E_BLOCK_MOB_SPAWNER) then
		local mobSpawner = tolua.cast(a_ChunkDesc:GetBlockEntity(a_X, a_Y, a_Z), "cMobSpawnerEntity")
		mobSpawner:SetEntity(self.m_MobTypes[math.random(#self.m_MobTypes)])
		return
	end
end



function cBlocksEnd:GetFromBlockList(a_BlockList)
	local block = a_BlockList[math.random(#a_BlockList)]

	-- Check if table
	if (type(block) == "table") then
		return block[1], math.random(block[2], block[3])
	end

	return block, 0
end



function cBlocksEnd:CreateBlockList()
	self.blockList = {}
	self.blockList.abundant = {}
	self.blockList.abundant.probability = { 1, 90 }
	self.blockList.abundant.blocks =
	{
		E_BLOCK_OBSIDIAN,
		E_BLOCK_END_STONE
	}

	self.blockList.rare = {}
	self.blockList.rare.probability = { 91, 100 }
	self.blockList.rare.blocks =
	{
		E_BLOCK_MOB_SPAWNER,
	}
end
