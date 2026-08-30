local player = game:GetService("Players").LocalPlayer
local ui = script.Parent
local holder = ui:WaitForChild("Holder")
local bar = holder:WaitForChild("Bar")
local leveldisplay = holder:WaitForChild("LevelDisplay")	

local EXP = player:WaitForChild("stats").EXP
local RequiredEXP = player:WaitForChild("stats").RequiredEXP
local Level = player:WaitForChild("leaderstats").Level

leveldisplay.Text = "Level "..Level.Value.." ("..EXP.Value.."/"..RequiredEXP.Value..")"

EXP.Changed:Connect(function()
	local goal = {}
	goal.Size = UDim2.new(EXP.Value/RequiredEXP.Value, 0, 1, 0)
	
	local tI = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
	
	game:GetService("TweenService"):Create(bar, tI, goal):Play()
	
	leveldisplay.Text = "Level "..Level.Value.." ("..EXP.Value.."/"..RequiredEXP.Value..")"
end)

Level.Changed:Connect(function()
	leveldisplay.Text = "Level "..Level.Value.." ("..EXP.Value.."/"..RequiredEXP.Value..")"
end)

task.spawn(function()
	local goal = {}
	goal.Size = UDim2.new(EXP.Value/RequiredEXP.Value, 0, 1, 0)

	local tI = TweenInfo.new(0.25, Enum.EasingStyle.Quint)

	game:GetService("TweenService"):Create(bar, tI, goal):Play()

	leveldisplay.Text = "Level "..Level.Value.." ("..EXP.Value.."/"..RequiredEXP.Value..")"
end)
