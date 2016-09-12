cPlayerInfo = {}
cPlayerInfo.__index = cPlayerInfo


function cPlayerInfo.new()
	local self = setmetatable({}, cPlayerInfo)
	return self
end
