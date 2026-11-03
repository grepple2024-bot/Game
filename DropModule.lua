local DropModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Items = ReplicatedStorage:WaitForChild("Items")

DropModule.EnemyDrops = {
	["Tribe Member"] = {
		["Wooden Club"] = 30,
		["Tribal Hat"] = 20,
	},
}

function DropModule.GrantExpAndLevelCheck(player, expAmount)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return 1 end

	local levelVal = leaderstats:FindFirstChild("Level")
	local expVal = leaderstats:FindFirstChild("EXP")

	if expVal and levelVal then
		expVal.Value += expAmount
		local expNeeded = levelVal.Value * 100
		if expVal.Value >= expNeeded then
			expVal.Value -= expNeeded
			levelVal.Value += 1
		end
	end

	return levelVal and levelVal.Value or 1
end

function DropModule.Decide(Enemy, Player, ExpReward)
	local drops = DropModule.EnemyDrops[Enemy]
	if not drops or not Player:FindFirstChild("Backpack") then return end

	local currentLevel = DropModule.GrantExpAndLevelCheck(Player, ExpReward or 0)

	for itemName, chance in pairs(drops) do
		local roll = math.random(1, 100)
		if roll <= chance then
			local itemTemplate = Items:FindFirstChild(itemName, true)
			if itemTemplate then
				local itemClone = itemTemplate:Clone()

				local levelVal = itemClone:FindFirstChild("Level")
				if not levelVal then
					levelVal = Instance.new("IntValue")
					levelVal.Name = "Level"
					levelVal.Parent = itemClone
				end
				levelVal.Value = currentLevel

				itemClone.Parent = Player.Backpack
			end
		end
	end
end

return DropModule

--made by tyrone
