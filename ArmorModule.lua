local ArmorModule = {}
ArmorModule.Armor = {
	["Tribal Hat"] = {
		MaxHealth = 20,
		Walkspeed = 5,
	},
}

function ArmorModule.EquipArmor(Armor, Character)
	local humanoid = Character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	local previousArmor = Character:GetAttribute("EquippedArmor")
	if previousArmor and ArmorModule.Armor[previousArmor] then
		local previousStats = ArmorModule.Armor[previousArmor]
		humanoid.MaxHealth -= previousStats.MaxHealth
		humanoid.WalkSpeed -= previousStats.Walkspeed
	end

	local accessories = Character:GetChildren()
	for i = 1, #accessories do
		if accessories[i]:IsA("Accessory") and accessories[i]:FindFirstChild("Armor") then
			accessories[i]:Destroy()
		end
	end

	local ArmorAcc = game.ReplicatedStorage:WaitForChild("ArmorAccessories"):FindFirstChild(tostring(Armor))
	if ArmorAcc then
		ArmorAcc:Clone().Parent = Character
	end

	local stats = ArmorModule.Armor[Armor]
	if stats then
		humanoid.MaxHealth += stats.MaxHealth
		humanoid.WalkSpeed += stats.Walkspeed
	end

	Character:SetAttribute("EquippedArmor", Armor)

	local player = game.Players:GetPlayerFromCharacter(Character)
	if player and player:FindFirstChild("stats") and player.stats:FindFirstChild("Armor") then
		player.stats.Armor.Value = Armor
	end
end

function ArmorModule.UnequipArmor(Character)
	local humanoid = Character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	local previousArmor = Character:GetAttribute("EquippedArmor")
	if previousArmor and ArmorModule.Armor[previousArmor] then
		local previousStats = ArmorModule.Armor[previousArmor]
		humanoid.MaxHealth -= previousStats.MaxHealth
		humanoid.WalkSpeed -= previousStats.Walkspeed
	end

	local accessories = Character:GetChildren()
	for i = 1, #accessories do
		if accessories[i]:IsA("Accessory") and accessories[i]:FindFirstChild("Armor") then
			accessories[i]:Destroy()
		end
	end

	Character:SetAttribute("EquippedArmor", nil)

	local player = game.Players:GetPlayerFromCharacter(Character)
	if player and player:FindFirstChild("stats") and player.stats:FindFirstChild("Armor") then
		player.stats.Armor.Value = ""
	end
end

return ArmorModule
