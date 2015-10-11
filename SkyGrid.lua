PLUGIN = nil
SKYGRID = nil
BLOCKS_OVERWORLD = nil

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
		LOGERROR("This plugin requires the world skygrid. Please add this line")
		LOGERROR("World=skygrid")
		LOGERROR("to the section [Worlds] in the settings.ini.")
		LOGERROR("Then stop and start the server again.")
	end

	CreateRecipes()

	BLOCKS_OVERWORLD = cBlocksOverWorld.new()

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
	-- code
	local files = cFile:GetFolderContents(PLUGIN:GetLocalFolder() .. "/code")
	if (#files > 2) then
		for _, file in pairs(files) do
			if (string.sub(file, #file -3, #file) == ".lua") then
				dofile(PLUGIN:GetLocalFolder() .. "/code/" .. file)
			end
		end
	end

	-- code/classes
	files = cFile:GetFolderContents(PLUGIN:GetLocalFolder() .. "/code/classes")
	if (#files > 2) then
		for _, file in pairs(files) do
			if (string.sub(file, #file -3, #file) == ".lua") then
				dofile(PLUGIN:GetLocalFolder() .. "/code/classes/" .. file)
			end
		end
	end

	-- code/commands
	files = cFile:GetFolderContents(PLUGIN:GetLocalFolder() .. "/code/commands")
	if (#files > 2) then
		for _, file in pairs(files) do
			if (string.sub(file, #file -3, #file) == ".lua") then
				dofile(PLUGIN:GetLocalFolder() .. "/code/commands/" .. file)
			end
		end
	end
end
