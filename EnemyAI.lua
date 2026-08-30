Figure = script.Parent
Humanoid = Figure:WaitForChild("Humanoid")
Torso = Figure:FindFirstChild("Torso")

Creator = Figure:FindFirstChild("Creator")

local canAttack = true

Players = game:GetService("Players")
Debris = game:GetService("Debris")
InsertService = game:GetService("InsertService")

local PunchAnim = Figure.Assets:WaitForChild("Attack")

WalkRadius = 10
MaxFollowDistance = 80

local HIT_COOLDOWN = 0.8

local Name = script.Parent.Name

Humanoid.Health = Humanoid.MaxHealth

local levelingmodule = require(game.ServerScriptService:WaitForChild("ServerModules"):WaitForChild("LevelingModule"))

function RayCast(Position, Direction, MaxDistance, IgnoreList)
	return game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(Position, Direction.unit * (MaxDistance or 999.999)), IgnoreList) 
end

function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end

function Wander()
	Humanoid:MoveTo(Vector3.new(Torso.Position.X + math.random(-WalkRadius, WalkRadius), Torso.Position.Y, Torso.Position.Z + math.random(-WalkRadius, WalkRadius)))
end

function FollowTarget(TargetHumanoid, TargetTorso)
	if not TargetHumanoid or not TargetHumanoid.Parent or TargetHumanoid.Health == 0 or not TargetTorso or not TargetTorso.Parent then
		return
	end
	Humanoid:MoveTo(Vector3.new(TargetTorso.Position.X, Torso.Position.Y, TargetTorso.Position.Z))
end

function FindTarget()
	local ClosestCharacter
	local ClosestHumanoid = nil
	local ClosestTorso = nil
	local ClosestTorsoDistance = MaxFollowDistance
	for i, v in pairs(Players:GetChildren()) do
		if v:IsA("Player") and (not Creator or (Creator and v ~= Creator.Value)) and v.Character then
			local character = v.Character
			local humanoid = character:FindFirstChild("Humanoid")
			local torso = character:FindFirstChild("Torso")
			local TorsoDistance = (torso.Position - Torso.Position).magnitude
			if humanoid and humanoid.Health > 0 and torso and TorsoDistance <= ClosestTorsoDistance then
				ClosestCharacter = character
				ClosestHumanoid = humanoid
				ClosestTorso = torso
				ClosestTorsoDistance = TorsoDistance
			end
		end
	end
	return ClosestCharacter, ClosestHumanoid, ClosestTorso
end

local LastHit

for _, v in pairs(Figure:GetChildren()) do
	if v:IsA("BasePart") then
		v.Touched:Connect(function(Hit)
			if not canAttack or Humanoid.Health <= 0 then return end

			if Hit and Hit.Parent and Hit.Parent ~= Figure and Hit.Parent.Name ~= Figure.Name then
				local targetHumanoid = Hit.Parent:FindFirstChild("Humanoid")
				local hitPlayer = Players:GetPlayerFromCharacter(Hit.Parent)

				if targetHumanoid and targetHumanoid.Health > 0 and (not hitPlayer or (hitPlayer and (not Creator or hitPlayer ~= Creator.Value))) then
					-- Activate global attack debounce immediately
					canAttack = false
					
					local track = Humanoid:LoadAnimation(PunchAnim)
					track.Looped = false
					track:Play()

					TagHumanoid(targetHumanoid, (Creator and Creator.Value) or nil)

					local damageValue = script.Parent:FindFirstChild("Damage") and script.Parent.Damage.Value or 10
					targetHumanoid:TakeDamage(damageValue)

					task.wait(HIT_COOLDOWN)
					canAttack = true
				end
			end
		end)
	end
end

Humanoid.Died:Connect(function()
	if Humanoid:WaitForChild("creator") and Humanoid.creator.Value then
		levelingmodule.GiveExp(Players:GetPlayerFromCharacter(Humanoid.creator.Value), math.random(50, 100))
	end
end)

while true do
	local character, humanoid, torso = FindTarget()
	if character and character.Parent and humanoid and humanoid.Parent and torso and torso.Parent then
		if character.Name ~= Name then
			FollowTarget(humanoid, torso)
		end
	else
		Wander()
	end
	local Hit, EndPosition = RayCast(Torso.Position, Torso.CFrame.lookVector, (Torso.Size.Z * 2.5), {Figure})
	if Hit and Hit.Parent and Hit.Parent ~= character then
		Humanoid.Jump = true
	end
	wait(0.1)
end
