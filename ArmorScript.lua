local tool = script.Parent
local equipped = false

local armorname = tool.ArmorName.Value

local armormodule = require(game.ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("ArmorModule"))

local function getPlayer()
	if tool.Parent:IsA("Model") then
		return game.Players:GetPlayerFromCharacter(tool.Parent)
	elseif tool.Parent:IsA("Backpack") then
		return tool.Parent.Parent
	end
	return nil
end

local player = getPlayer()

if player then
	local stats = player:WaitForChild("stats")
	local armorVal = stats:WaitForChild("Armor")

	if armorVal.Value == armorname then
		tool.Name = tool.Name .. " (Equipped)"
		equipped = true
	end
end

tool.Activated:Connect(function()
	local char = tool.Parent
	if not char:IsA("Model") then return end

	if equipped then
		armormodule.UnequipArmor(char)
		tool.Name = armorname
		equipped = false
	else
		armormodule.EquipArmor(armorname, char)
		tool.Name = armorname .. " (Equipped)"
		equipped = true
	end
end)
