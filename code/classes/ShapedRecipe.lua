-- Class for a shaped recipe

cShapedRecipe = {}
cShapedRecipe.__index = cShapedRecipe

-- Creates a shaped recipe
function cShapedRecipe.new(a_ResultItem)
	local self = setmetatable({}, cShapedRecipe)

	self.m_ResultItem = a_ResultItem
	self.m_Shape = nil
	self.m_Ingredients = {}
	return self
end


-- Shape as array in format :  "WS ", " S ", "WWW" or "S", "WW"
function cShapedRecipe:Shape(...)
	assert(#arg ~= 0, "No shape has been passed.")
	assert(#arg <= 3, "Only max 3 strings can be passed.")

	local sizeY = #arg[1]
	local resize = false
	self.m_Shape = {}

	-- Change to array, every char own cell
	for x = 1, #arg do
		self.m_Shape[x] = {}
		for y = 1, #arg[x] do
			assert(#arg[x] <= 3, "One string can be only max 3 characters long.")
			if #arg[x] > sizeY then
				sizeY = #arg[x]
				resize = true
			end

			local c =  arg[x]:sub(y, y)
			if (c == " ") then
				self.m_Shape[x][y] = ""
			else
				self.m_Shape[x][y] = c
			end
		end
	end

	-- Resize y side of the array if necessary
	if resize then
		for x = 1, #self.m_Shape do
			if #self.m_Shape[x] ~= sizeY then
				for y = #self.m_Shape[x], sizeY do
					if self.m_Shape[x][y] == nil then
						self.m_Shape[x][y] = ""
					end
				end
			end
		end
	end

	-- Reduce the array
	self.m_Shape = self:Reduce(self.m_Shape, false)
	return self
end


-- a_Char can be a "W" or "S", a_ItemType the item type, a_Data the data value
function cShapedRecipe:SetIngredient(a_Char, a_ItemType, a_Data)
	assert(a_Char ~= nil, "a_Char can not be nil.")
	assert(#a_Char == 1, "a_Char can be only 1 character long.")
	assert(a_ItemType ~= nil, "a_ItemType can not be nil.")

	-- Set a_Data to 0 if it's nil, 0 is default data value for items
	if (a_Data == nil) then
		a_Data = 0
	end

	if (self.m_Ingredients[a_Char] == nil) then
		self.m_Ingredients[a_Char] = {}
		self.m_Ingredients[a_Char][a_Data] = {}
	end

	if (self.m_Ingredients[a_Char][a_Data] == nil) then
		self.m_Ingredients[a_Char][a_Data] = {}
	end

	table.insert(self.m_Ingredients[a_Char][a_Data], a_ItemType)
	return self
end


-- Returns the minnium amount of a ingredient in the grid
function cShapedRecipe:GetAmount(a_ItemsGrid)
	local amount = 100
	for x = 1, #a_ItemsGrid do
		for y = 1, #a_ItemsGrid[x] do
			if (not a_ItemsGrid[x][y]:IsEmpty()) then
				if (amount > a_ItemsGrid[x][y].m_ItemCount) then
					amount = a_ItemsGrid[x][y].m_ItemCount
				end
			end
		end
	end
	return amount
end


-- Checks if the crafting grid is empty
function cShapedRecipe:IsCraftingridEmpty(a_ItemsGrid)
	for x = 1, #a_ItemsGrid do
		for y = 1, #a_ItemsGrid[x] do
			if (not a_ItemsGrid[x][y]:IsEmpty()) then
				return false
			end
		end
	end
	return true
end

-- Checks the content of the grid and if it's match, returns the result item
-- and the minium amount of the ingredient
function cShapedRecipe:CheckIfMatch(a_CraftingGrid)
	assert(self.m_Shape ~= nil, "No shape has been set.")

	local sizeGrid = a_CraftingGrid:GetHeight()

	-- Check size
	if ((#self.m_Shape > sizeGrid) or (#self.m_Shape[1] > sizeGrid)) then
		return nil
	end

	local itemsGrid = self:ToItemArray(a_CraftingGrid)
	-- Check if empty
	if (self:IsCraftingridEmpty(itemsGrid)) then
		return nil
	end

	if ((#self.m_Shape ~= sizeGrid) or (#self.m_Shape[1] ~= sizeGrid)) then
		-- Reduce
		itemsGrid = self:Reduce(itemsGrid, true)

		-- Recheck size
		if ((#itemsGrid ~= #self.m_Shape) or (#itemsGrid[1] ~= #self.m_Shape[1])) then
			return nil
		end
	end

	for x = 1, #itemsGrid do
		for y = 1, #itemsGrid[x] do
			local itemGrid = itemsGrid[x][y]
			local tbIngredients = self:GetItemTypes(x, y)

			if (itemGrid:IsEmpty() and (tbIngredients ~= nil)) then
				-- Item in grid is empty but tbIngredients is not nil
				return nil
			end

			if ((not itemGrid:IsEmpty()) and (tbIngredients == nil)) then
				-- Item in grid is not empty but tbIngredients is nil
				return nil
			end

			-- Check if match
			if (tbIngredients ~= nil) then
				local foundMatch = false
				for dataValue, arrItemTypes in pairs(tbIngredients) do
					for _, itemIngredient in pairs(arrItemTypes) do
						if
						(
							(itemGrid.m_ItemType == itemIngredient) and
							(itemGrid.m_ItemDamage == dataValue)
						) then
							foundMatch = true
							break
						end
					end
				end
				if (not foundMatch) then
					return nil
				end
			end
		end
	end

	-- Found a match
	local amountIngredient = self:GetAmount(itemsGrid)
	local resultItem = cItem(self.m_ResultItem)
	resultItem.m_ItemCount = resultItem.m_ItemCount * amountIngredient
	return resultItem, amountIngredient
end


-- Create a item array from the crafting grid contents
function cShapedRecipe:ToItemArray(a_CraftingGrid)
	local items = {}
	for x = 0, a_CraftingGrid:GetHeight() - 1 do
		items[x + 1] = {}
		for y = 0, a_CraftingGrid:GetHeight() - 1 do
			items[x + 1][y + 1] = a_CraftingGrid:GetItem(y, x)
		end
	end
	return items
end


-- Empty checker for cShapedRecipe:Reduce
function cShapedRecipe:IsEmpty(a_ToCheck, a_IsItem)
	if (a_IsItem) then
		return (a_ToCheck:IsEmpty())
	else
		return (a_ToCheck == "")
	end
end


-- Reduces the passed array
function cShapedRecipe:Reduce(a_Shape, a_IsItem)
	local reducedArray = {}
	local startX = 0
	local endX = 0
	local startY = 0
	local endY = 0

	for x = 1, #a_Shape do
		for y = 1, #a_Shape[1] do
			if (not self:IsEmpty(a_Shape[x][y], a_IsItem)) then
				if ((startX == 0) or (startX > x)) then
					startX = x
				end

				if ((endX == 0) or (x > endX)) then
					endX = x
				end

				if ((startY == 0) or (startY > y)) then
					startY = y
				end

				if ((endY == 0) or(y > endY)) then
					endY = y
				end

				if (x == 3) then
					endX = x
				end

				if (y == 3) then
					endY = y
				end
			end
		end
	end

	for x = startX, endX do
		reducedArray[x - startX + 1] = {}
		for y = startY, endY do
			reducedArray[x - startX + 1][y - startY + 1] = a_Shape[x][y]
		end
	end
	return reducedArray
end


-- Returns the possible ingredients
function cShapedRecipe:GetItemTypes(a_X, a_Y)
	local chr = self.m_Shape[a_X][a_Y]
	if (chr == "") then
		return nil
	end
	return self.m_Ingredients[chr]
end
