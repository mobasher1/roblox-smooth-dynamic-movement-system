local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
if not character then return end

local humanoid = character:WaitForChild("Humanoid") :: Humanoid
if not humanoid then return end

local START_DELAY = 3

local POSITIVE_RATE = 1
local NEGATIVE_RATE = -1

local FULL_RUNSPEED = 18
local FULL_WALKSPEED = 5

local targetKey = Enum.KeyCode.LeftControl
local isHoldingKey = false

local function applyWalkSpeed(humanoid: Humanoid)
	task.wait(START_DELAY)


	while humanoid.WalkSpeed < FULL_WALKSPEED do
		humanoid.WalkSpeed += POSITIVE_RATE
		task.wait(.1)
	end

	humanoid.WalkSpeed = FULL_WALKSPEED
end

local function applyRunSpeed(humanoid: Humanoid)
	if character and humanoid then
		while humanoid.WalkSpeed < FULL_RUNSPEED and isHoldingKey == true do
			humanoid.WalkSpeed += POSITIVE_RATE
			task.wait(.05)
		end
	end
end

local function deAcceleration(humanoid: Humanoid)
	while humanoid.WalkSpeed > FULL_WALKSPEED do
		humanoid.WalkSpeed += NEGATIVE_RATE
		task.wait(.1)
	end
end


local function onCharacterAdded(character: Model)
	local humanoid = character:WaitForChild("Humanoid")
	task.spawn(function()
		applyWalkSpeed(humanoid)
	end)
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
	onCharacterAdded(player.Character)
end


local function onInputBegan(input, gameProcessedEvent: Player)
	local character = player.Character
	local humanoid = character.Humanoid

	if gameProcessedEvent then return end

	if character and humanoid then
		if input.KeyCode == targetKey then
			isHoldingKey = true


			task.spawn(function()
				applyRunSpeed(humanoid)
			end)
		end
	end

end

local function onInputEnded(inputEnded, gameProcessedEvent: Player)
	local character = player.Character
	local humanoid = character.Humanoid

	if gameProcessedEvent then return end

	if character and humanoid then
		if inputEnded.KeyCode == targetKey then
			isHoldingKey = false

			task.spawn(function()
				deAcceleration(humanoid)
			end)
		end
	end
end

UIS.InputBegan:Connect(onInputBegan)
UIS.InputEnded:Connect(onInputEnded)