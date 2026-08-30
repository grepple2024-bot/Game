local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("PlayerData")

local function calculaterequiredEXP(currentlevel)
	return 1.1 * 100 * currentlevel
end

local datasaveorders = {
	[1] = "Level",
	[2] = "EXP",
	[3] = "RequiredEXP",
	[4] = "Armor"
}

local ArmorModule = require(game:GetService("ReplicatedStorage").Modules:FindFirstChild("ArmorModule"))

game:GetService("Players").PlayerAdded:Connect(function(player)
	if player then

		local data = nil

		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player

		local statsfolder = Instance.new("Folder")
		statsfolder.Name = "stats"
		statsfolder.Parent = player

		local levelval = Instance.new("IntValue")
		levelval.Parent = leaderstats
		levelval.Name = "Level"

		local armorval = Instance.new("StringValue")
		armorval.Parent = statsfolder
		armorval.Name = "Armor"
		armorval.Value = ""

		local exp = Instance.new("IntValue")
		exp.Parent = statsfolder
		exp.Name = "EXP"

		local requiredexp = Instance.new("IntValue")
		requiredexp.Parent = statsfolder
		requiredexp.Name = "RequiredEXP"
		requiredexp.Value = 100

		local function updateHealth(char)
			if not char then return end
			task.spawn(function()
				local hum = char:WaitForChild("Humanoid", 5)
				if hum then
					task.wait() 
					hum.MaxHealth = 100 + (levelval.Value * 5)
					hum.Health = hum.MaxHealth
					if armorval.Value ~= "" and ArmorModule.Armor[armorval.Value] then
						local stats = ArmorModule.Armor[armorval.Value]
						hum.MaxHealth += stats.MaxHealth
						hum.Health = hum.MaxHealth
					end
				end
			end)
		end

		player.CharacterAdded:Connect(updateHealth)

		levelval.Changed:Connect(function()
			updateHealth(player.Character)
		end)

		if player.Character then
			updateHealth(player.Character)
		end

		local success, errormessage = pcall(function()
			data = DataStore:GetAsync(player.UserId)
		end)

		if success then
			if data then
				levelval.Value = data[1] 
				requiredexp.Value = data[3]
				exp.Value = data[2]
				armorval.Value = data[4]
			else
				levelval.Value = 1
				requiredexp.Value = 100
				exp.Value = 0
			end
		else
			warn(errormessage)
		end

		local isLevelingUp = false
		exp.Changed:Connect(function()
			if isLevelingUp then return end
			if exp.Value >= requiredexp.Value then
				isLevelingUp = true
				while exp.Value >= requiredexp.Value do
					exp.Value = exp.Value - requiredexp.Value
					levelval.Value = levelval.Value + 1
					requiredexp.Value = calculaterequiredEXP(levelval.Value)
				end
				isLevelingUp = false
			end
		end)
	end
end)

local function save(player)
	local saveddata = {
		player.leaderstats.Level.Value,
		player.stats.EXP.Value,
		player.stats.RequiredEXP.Value,
		player.stats.Armor.Value
	}
	local success, errormessage = pcall(function()
		DataStore:SetAsync(player.UserId, saveddata)
	end)
	if not success then
		warn(errormessage)
	end
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
	save(player)
end)

game:BindToClose(function()
	for _, v in pairs(game.Players:GetPlayers()) do
		save(v)
	end
end)
