-- Class for a shapeless recipe

cShapelessRecipe = {}
cShapelessRecipe.__index = cShapelessRecipe

-- Creates a shapeless recipe
function cShapelessRecipe.new(a_ResultItem)
	local self = setmetatable({}, cShapelessRecipe)

	self.m_ResultItem = a_ResultItem
	self.m_Ingredients = {}
	return self
end


-- Add a ingredient
function cShapelessRecipe:AddIngredient(a_Amount, a_ItemType, a_Data)
	assert(a_Amount ~= nil, "a_Amount can not be nil.")
	assert(a_ItemType ~= nil, "a_ItemType can not be nil.")
	assert(a_Amount <= 9, "Max number of a_Amount can only be 9.")

	-- Set a_Data to 0 if it's nil, 0 is default data value for items
	if (a_Data == nil) then
		a_Data = 0
	end

	for x = 1, a_Amount do
		if (self.m_Ingredients[a_Data] == nil) then
			self.m_Ingredients[a_Data] = {}
		end
		table.insert(self.m_Ingredients[a_Data], a_ItemType)
	end
	return self
end


-- Checks if the crafting grid is empty
function cShapelessRecipe:IsCraftingridEmpty(a_ItemsGrid)
	for x = 1, #a_ItemsGrid do
		for y = 1, #a_ItemsGrid[1] do
			if (not a_ItemsGrid[x][y]:IsEmpty()) then
				return false
			end
		end
	end
	return true
end


-- Adds the not empty items to a array
function cShapelessRecipe:ToItemArray(a_CraftingGrid)
	local items = {}
	for x = 0, a_CraftingGrid:GetHeight() - 1 do
		for y = 0, a_CraftingGrid:GetHeight() - 1 do
			if not a_CraftingGrid:GetItem(x, y):IsEmpty() then
				table.insert(items, a_CraftingGrid:GetItem(x, y))
			end
		end
	end
	return items
end


-- Returns the minium amount of a ingredient in the grid
function cShapelessRecipe:GetAmount(a_ItemsGrid)
	local amount = 100
	for x = 1, #a_ItemsGrid do
		if (amount > a_ItemsGrid[x].m_ItemCount) then
			amount = a_ItemsGrid[x].m_ItemCount
		end
	end
	return amount
end


-- Checks the content of the grid and if it's match, returns the result item
-- and the minium amount of the ingredient
function cShapelessRecipe:CheckIfMatch(a_CraftingGrid)
	-- Check if same amount of items
	local itemsGrid = self:ToItemArray(a_CraftingGrid)
	local sizeIngredients = 0
	for dataValue, arrItemTypes in pairs(self.m_Ingredients) do
		sizeIngredients = sizeIngredients + #arrItemTypes
	end
	if sizeIngredients ~= #itemsGrid then
		return nil
	end

	-- Check if items match
	local checkedSlots = {}
	for dataValue, arrItemTypes in pairs(self.m_Ingredients) do
		for x = 1, #arrItemTypes do
			local found = false
			for y = 1, #itemsGrid do
				if
				(
					(not checkedSlots[y]) and
					(itemsGrid[y].m_ItemType == arrItemTypes[x]) and
					(itemsGrid[y].m_ItemDamage == dataValue)
				) then
					checkedSlots[y] = true
					found = true
					break
				end
			end
			if not found then
				return nil
			end
		end
	end

	-- Workaround: Directly set the max item count of the result item that are
	-- possible with the ingredient(s)
	-- If #2503 has been fixed, remove it
	local amountIngredient = self:GetAmount(itemsGrid)
	local resultItem = cItem(self.m_ResultItem)
	resultItem.m_ItemCount = resultItem.m_ItemCount * amountIngredient

	return resultItem, amountIngredient
end
