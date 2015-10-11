function CommandSkygrid (a_Split, a_Player)
	for x = 0, 1 do
		for z = 0, 1 do
			if
			(
				not a_Player:GetWorld():ForEachChestInChunk(x, z, function(a_Chestentity)
					a_Player:TeleportToCoords(a_Chestentity:GetPosX(), a_Chestentity:GetPosY(), a_Chestentity:GetPosZ())
					return true
				end)
			) then
				return true
			end
		end
	end

	a_Player:SendMessage("No chest found.")
	return true
end
