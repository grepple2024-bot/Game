local AreaSounds = Instance.new("Sound", script)
AreaSounds.Looped = true
local plr = script.Parent
local Presser = plr:WaitForChild("HumanoidRootPart")
local DifferentAreas = workspace:WaitForChild("Areas")
local CurrentArea = nil

game:GetService("RunService").Heartbeat:Connect(function()
	local raycast = Ray.new(Presser.Position, Presser.CFrame.UpVector * -1000)
	local part = workspace:FindPartOnRayWithWhitelist(raycast, {DifferentAreas})
	if part and part.Parent == DifferentAreas then
		if part ~= CurrentArea then
			CurrentArea = part
			AreaSounds.SoundId = CurrentArea.Sound.SoundId
			AreaSounds:Play()
		end 
	else
		CurrentArea = nil
		AreaSounds:Stop()
	end
end) 
--made by caleb
