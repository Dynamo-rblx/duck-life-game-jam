-- @ScriptType: Script
--[[
TODO
We need to store:
--> Coins - x
--> Pets - x
----> Pets stats - x
--> Custom character
--> Owned clothes
--> Current pet - x
--> Current save - x
--> Compete progress - x
]]

_G.events = {}
_G.modules = {}

local actions = {
	jump = function()
		local pet: Model = workspace.Current_pet:GetChildren()[1]

		game.TweenService:Create(pet.PrimaryPart, TweenInfo.new(.5), {Position=pet.PrimaryPart.Position+Vector3.yAxis*7}):Play()
		task.wait(.55)

		local finish = game.TweenService:Create(pet.PrimaryPart, TweenInfo.new(.5), {Position=pet.PrimaryPart.Position-Vector3.yAxis*7})
		finish:Play()
		finish.Completed:Wait()
		return true
	end,
}

local action_debounces = {}
for i, v in actions do action_debounces[i] = false end

for i, v in game:GetService("ReplicatedStorage"):GetDescendants() do
	if v:IsA("RemoteEvent") or v:IsA("BindableEvent") or v:IsA("UnreliableRemoteEvent") then
		_G.events[v.Name] = v
	end
end

for i, v in game:GetService("ServerScriptService"):GetDescendants() do
	if v:IsA("ModuleScript") then
		if pcall(function()
				_G.modules[v.Name] = require(v)
			end) then
			print(v.Name, "loaded")
		else
			print(v.Name, "experienced an error while loading")
		end
	end
end

_G.events.updateSave.OnServerEvent:Connect(function(plr: Player, save: number)
	plr.Data:SetAttribute("current_save", save)

	for i, v in game:GetService("CollectionService"):GetTagged("Current_Pet") do
		v:Destroy()
	end

	local new: Model = game.ReplicatedStorage.Pet_Models[plr.Data[save]:GetAttribute("current_pet")]:Clone()
	game.CollectionService:AddTag(new, "Current_Pet")
	new.Parent = workspace.Current_pet
	new:MoveTo(workspace.mapBase.placeholder.Position)
end)

_G.events.selectPet.OnServerEvent:Connect(function(plr: Player, pet: string)
	plr.Data[tostring(plr.Data:GetAttribute("current_save"))]:SetAttribute("current_pet", pet)

	for i, v in game:GetService("CollectionService"):GetTagged("Current_Pet") do
		v:Destroy()
	end

	local new: Model = game.ReplicatedStorage.Pet_Models[pet]:Clone()
	game.CollectionService:AddTag(new, "Current_Pet")
	new.Parent = workspace.Current_pet
	new:MoveTo(workspace.mapBase.placeholder.Position)
end)

_G.events.initiateGame.OnServerEvent:Connect(function(plr: Player, current_game: string)
	local pet: Model = game:GetService("CollectionService"):GetTagged("Current_Pet")[1]
	print(current_game)
	pet:MoveTo(workspace[string.lower(current_game).."Map"].placeholder.Position)

	--local PrimCFrame = pet:GetPivot()
	--local Rotation = CFrame.Angles(0,math.rad(90),0)
	--local RotatedCFrame = PrimCFrame * Rotation

	--pet:PivotTo(RotatedCFrame)

	if pcall(function() _G.modules[string.lower(current_game)].startGame() end) then
		print("Loaded minigame:", current_game)
	else
		print("Missing minigame:", current_game)
	end
end)

_G.events.gameOver.OnServerEvent:Connect(function(plr: Player, xp_earned: number, coins_earned: number, current_game: string)
	pcall(function() _G.modules[string.lower(current_game)].setAlive(false); _G.modules[string.lower(current_game)].endGame(); end)
	if xp_earned == nil then return end
	if coins_earned == nil then return end

	local save = plr.Data[tostring(plr.Data:GetAttribute("current_save"))]
	local pet = save[tostring(save:GetAttribute("current_pet"))]

	pet:SetAttribute(current_game, pet:GetAttribute(current_game) + xp_earned )
	pet:SetAttribute("Energy", pet:GetAttribute("Energy") + xp_earned + coins_earned%2 )

	save:SetAttribute("coins", save:GetAttribute("coins") + coins_earned )
end)

_G.events.feedPet.OnServerEvent:Connect(function(plr: Player)
	local save = plr.Data[tostring(plr.Data:GetAttribute("current_save"))]
	save:SetAttribute("coins", save:GetAttribute("coins") - 10)

	local pet = save[tostring(save:GetAttribute("current_pet"))]
	pet:SetAttribute("Energy", pet:GetAttribute("Energy") + 5)
end)

_G.events.doAction.OnServerEvent:Connect(function(plr: Player, action: string)
	if actions[action] ~= nil then
		if action_debounces[action] == false then
			action_debounces[action] = true
			local fxn = actions[action]()

			while not fxn do task.wait() end
			action_debounces[action] = false
		else
			print("Action", action, "is on cooldown")
		end
	else
		print("Action", action, "does not exist")
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	local data_clone = script:WaitForChild("Data"):Clone()
	data_clone.Parent = plr
end)