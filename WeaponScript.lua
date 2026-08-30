local RS = game:GetService("ReplicatedStorage")
local Modules = RS.Modules
local HitboxModule = require(Modules:WaitForChild("HitboxModule"))
local DamageModule = require(Modules:WaitForChild("DamageModule"))

local Tool = script.Parent
local Damage = Tool:WaitForChild("Damage")
local Cooldown = Tool:WaitForChild("Cooldown")
local Assets = Tool:WaitForChild("Assets")
local AttackAnim1 = Assets:WaitForChild("Attack1")
local AttackAnim2 = Assets:WaitForChild("Attack2")

local db = false

local combo = 1

Tool.Activated:Connect(function()
	if db then return end
	db = true

	local character = Tool.Parent
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not humanoid then 
		db = false
		return 
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	if combo == 1 then
		local animTrack = animator:LoadAnimation(AttackAnim1)
		animTrack:Play()
		combo += 1
	elseif combo == 2 then
		local animTrack = animator:LoadAnimation(AttackAnim2)
		animTrack:Play()
		combo = 1
	end

	local cframe = hrp.CFrame * CFrame.new(0, 0, -4)
	local size = Vector3.new(5, 5, 5)
	local duration = 0.5
	local weldToHRP = true

	task.spawn(function()
		local hitCharacters, visualPart = HitboxModule.Hitbox(cframe, size, character, duration, weldToHRP)

		for _, hitModel in pairs(hitCharacters) do
			local targetHum = hitModel:FindFirstChildOfClass("Humanoid")
			if targetHum then
				DamageModule.DealDamage(character, hitModel, math.random(math.round(Damage.Value - (Damage.Value * 0.5)), math.round(Damage.Value + (Damage.Value * 0.5))))
				local velocity = Instance.new("BodyVelocity")
				velocity.Velocity = hrp.CFrame.LookVector * 150
				velocity.MaxForce = Vector3.new(10000, 10000, 10000)
				velocity.Parent = targetHum.RootPart
				game:GetService("Debris"):AddItem(velocity, 0.15)
			end
		end
	end)

	task.wait(Cooldown.Value)
	db = false
end)
