-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--modules
local DialogModule = require(ReplicatedStorage.DialogModule)

local GiverModule = require(ReplicatedStorage.Modules:WaitForChild("GiverModule"))

--references
local player = game.Players.LocalPlayer
local npc = script.Parent -- Reference to the NPC model
local npcGui = npc:WaitForChild("Head"):WaitForChild("gui")
local prompt = npc:WaitForChild("ProximityPrompt")

local dialogObject = DialogModule.new("Tribe Merchant", npc, prompt)
dialogObject:addDialog("Hello do you have any items to sell to me", {"Yes","No"})
dialogObject:addDialog("What wares do you want to sell to me", {"These (All items)","This (Held item)","None"})
----


-- what happens when triggered
prompt.Triggered:Connect(function(player)
	dialogObject:triggerDialog(player, 1)
end)

-- logic to go through dialogs
dialogObject.responded:Connect(function(responseNum, dialogNum)
	if dialogNum == 1 then
		if responseNum == 1 then
			dialogObject:triggerDialog(player, 2)
		end
		if responseNum == 2 then
			dialogObject:hideGui("Thank you for your business!")
		end
	end
	if dialogNum == 2 then
		if responseNum == 1 then
			dialogObject:hideGui("Thank you for your business!", true)
			task.wait(1)
			if player.Backpack:FindFirstChildOfClass("Tool") then
			end
		end
	end
end)

--done by caleb
