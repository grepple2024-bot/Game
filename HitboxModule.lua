local hitbox = {}

hitbox.createHitbox = function(cframe, size, parent)
	local newHitbox = Instance.new("Part")
	newHitbox.CFrame = cframe
	newHitbox.Size = size
	newHitbox.BrickColor = BrickColor.new("Really red")
	newHitbox.Transparency = 0.8
	newHitbox.Material = Enum.Material.ForceField
	newHitbox.Anchored = true
	newHitbox.CanCollide = false
	newHitbox.Parent = parent

	return newHitbox
end

hitbox.Hitbox = function(cframe, size, character, duration, weldToHRP)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local newHitbox = hitbox.createHitbox(cframe, size, character)
	game.Debris:AddItem(newHitbox, duration)

	local weld = nil
	if weldToHRP and hrp then
		newHitbox.Anchored = false
		weld = Instance.new("WeldConstraint")
		weld.Part0 = hrp
		weld.Part1 = newHitbox
		weld.Parent = newHitbox
	end

	local playersInHitbox = {}

	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {character, newHitbox}

	local startTime = os.clock()

	while os.clock() - startTime < duration do
		local currentCFrame = weldToHRP and newHitbox.CFrame or cframe
		local hitContents = workspace:GetPartBoundsInBox(currentCFrame, size, overlapParams)

		for _, v in pairs(hitContents) do
			local model = v:FindFirstAncestorOfClass("Model")
			if model then
				local hum = model:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then
					if not table.find(playersInHitbox, model) then
						table.insert(playersInHitbox, model)
					end
				end
			end
		end

		task.wait(0.05)
	end

	return playersInHitbox, newHitbox
end

return hitbox
