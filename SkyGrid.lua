-- Bad, bad random generator
math.randomseed(os.time())
math.random(); math.random(); math.random()

function Initialize(a_Plugin)
	a_Plugin:SetName("SkyGrid")
	a_Plugin:SetVersion(1)

	PLUGIN = a_Plugin

	-- Load all lua files
	LoadLuaFiles()

	SKYGRID = cRoot:Get():GetWorld("skygrid")
	if (SKYGRID == nil) then
		LOGWARN("This plugin requires the world skygrid. Please add this line")
		LOGWARN("World=skygrid")
		LOGWARN("to the section [Worlds] in the settings.ini.")
		LOGWARN("Then stop and start the server again.")
	end

	CreateRecipes()

	-- The classes containing the blocks for the generator
	BLOCKS_OVERWORLD = cBlocksOverworld.new()
	BLOCKS_NETHER = cBlocksNether.new()
	BLOCKS_END = cBlocksEnd.new()

	-- Hooks
	cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
	cPluginManager:AddHook(cPluginManager.HOOK_CRAFTING_NO_RECIPE, OnCraftingNoRecipe)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BROKEN_BLOCK, OnPlayerBrokenBlock)

	-- Commands
	cPluginManager.BindCommand("/skygrid", "skygrid.command", CommandSkygrid , " - Access to the skygrid commands")

	LOG("Initialized " .. a_Plugin:GetName())
	return true
end



function OnDisable()
	LOG(PLUGIN:GetName() .. " is shutting down...")
end



function LoadLuaFiles()
	local folders =  { "/code", "/code/classes", "/code/commands" }

	for _, folder in pairs(folders) do
		local files = cFile:GetFolderContents(PLUGIN:GetLocalFolder() .. folder)
		if (#files > 2) then
			for _, file in pairs(files) do
				if (string.sub(file, #file -3, #file) == ".lua") then
					dofile(PLUGIN:GetLocalFolder() .. folder .. "/" .. file)
				end
			end
		end
	end
end
