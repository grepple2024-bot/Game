local DamageModule = {}

function DamageModule.DealDamage(attacker, victim, damage)
	local humanoid = victim:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	for _, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end

	humanoid.Health -= damage

	local creator = Instance.new("ObjectValue")
	creator.Name = "creator"
	creator.Value = attacker
	creator.Parent = humanoid
	game:GetService("Debris"):AddItem(creator, 1.5)
end

return DamageModule
