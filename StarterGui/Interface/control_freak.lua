-- @ScriptType: LocalScript
-- INITIALIZATION
script.Parent.Enabled = false
----> Lazy Loading
_G.pages = {}
_G.events = {}
_G.elements = {}

current_score, coins_collected = 0, 0

conversion = {
	["Running"] = "run",
	["Digging"] = "dig",
	["Flying"] = "fly",
	["Swimming"] = "swim",
	["Fishing"] = "fish",
	["Climbing"] = "climb",
	["Jumping"] = "jump"
}

task.spawn(function()
	while workspace.CurrentCamera.CameraType ~= Enum.CameraType.Scriptable do workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable; task.wait() end
	while  workspace.CurrentCamera.CFrame ~= workspace.titleScreen.camPos.CFrame do workspace.CurrentCamera.CFrame = workspace.titleScreen.camPos.CFrame; task.wait() end
end)

for i, v in script.Parent:GetChildren() do
	if v:IsA("Frame") then
		_G.pages[v.Name] = v
		for i, element in v:GetDescendants() do
			if element:IsA("GuiButton") or element:IsA('GuiLabel') then
				if not _G.elements[v.Name] then _G.elements[v.Name] = {} end
				_G.elements[v.Name][element.Name] = element
			end
		end
	end
	if i==#script.Parent:GetChildren() then break end
end

for i, v in game:GetService("ReplicatedStorage"):GetDescendants() do
	if v:IsA("RemoteEvent") or v:IsA("BindableEvent") or v:IsA("UnreliableRemoteEvent") then
		_G.events[v.Name] = v
	end
	if i==#game.ReplicatedStorage:GetDescendants() then break end
end

-- VARIABLES
local currentpage: Frame = _G.pages.menu_container
for i, page: Frame in _G.pages do page.Visible = (page==currentpage); if i==#_G.pages then break end end
local event_queued = false
local plr = game.Players.LocalPlayer
local dataFolder = plr:WaitForChild("Data")
local SaveNum = require(script.Shorten)
local rxn_time = .1

-- FUNCTIONS
function switchPage(newpage: Frame)
	currentpage.Visible = false
	for i, v in currentpage:GetDescendants() do if v:IsA("GuiButton") then v.Active = false end if i==#currentpage:GetDescendants() then break end end
	currentpage = newpage
	for i, v in currentpage:GetDescendants() do if v:IsA("GuiButton") then v.Active = true end if i==#currentpage:GetDescendants() then break end end
	currentpage.Visible = true
	event_queued = false
end

function convert(key: string): string | nil
	for i, v in conversion do
		if i == key then
			return v
		elseif v == key then
			return i
		end
	end

	return nil
end

function refreshUI()
	local save = dataFolder:GetAttribute("current_save") :: number
	local folder = dataFolder[save] :: Folder
	local coins = folder:GetAttribute("coins") :: number
	local compete_level = folder:GetAttribute("compete_level") :: number
	local current_pet_val = folder:GetAttribute("current_pet") :: string
	local pet_data = folder[current_pet_val] :: Configuration
	local billboard = workspace.mapBase.plate.SurfaceGui.container.Frame

	----> Refresh pet stats & home display (billboard)
	for attribute, value in pet_data:GetAttributes() do
		if attribute ~= "Energy" then _G.elements.pet_container[attribute]["xp"].Text = SaveNum.Short(value) end
		billboard[attribute].Text = attribute..": "..SaveNum.Short(value)
	end

	billboard.Parent.header.Text = current_pet_val.." Stats"

	_G.elements.pet_container["stat_header"].Text = current_pet_val

	----> Refresh coin count
	_G.elements.main_map_container["coins_amount"].Text = SaveNum.Short(coins)

	----> Refresh compete display
	for i, inst in _G.pages.compete_container["options_container"]:GetChildren() do
		if inst:IsA("GuiButton") then
			local btn = inst :: GuiButton

			if btn:GetAttribute("Level") <= compete_level then
				btn.Visible = true
			else
				btn.Visible = false
			end

			if btn:GetAttribute("Level") < compete_level then btn.BackgroundColor3 = Color3.fromHex("#4bb64f"); else btn.BackgroundColor3 = Color3.fromRGB(41,41,41); end
		end

		if i==#_G.pages.compete_container["options_container"]:GetChildren() then break end
	end

	----> Refresh save display
	_G.elements.menu_container["chooser1"].Text = "II"
	_G.elements.menu_container["chooser2"].Text = "II"
	_G.elements.menu_container["chooser3"].Text = "II"
	_G.elements.menu_container["chooser"..save].Text = "#"	
end

task.defer(refreshUI)

function gameOver()
	-- calculate XP earned
	local xp_earned = current_score * 4

	-- Display game results on info_card
	_G.elements.game_over_container["info_card"].Text = "Score: "..SaveNum.Short(current_score).."\n"..current_game.." XP: "..SaveNum.Short(xp_earned).."\n Coins: "..SaveNum.Short(coins_collected)

	switchPage(_G.pages.game_over_container)

	local option = -1

	local quitCn: RBXScriptConnection = _G.elements.game_over_container["quitbtn"].InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			option = 0
		end
	end)

	local retryCn: RBXScriptConnection = _G.elements.game_over_container["retrybtn"].InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			option = 1
		end
	end)

	while option < 0 do task.wait() end
	task.delay(rxn_time, refreshUI)
	_G.events["gameOver"]:FireServer(xp_earned, coins_collected, current_game)

	quitCn:Disconnect(); retryCn:Disconnect()

	event_queued = true

	if option == 0 then
		workspace.CurrentCamera.CFrame = workspace.mapBase.camPos.CFrame
		switchPage(_G.pages.main_map_container)
		_G.events.selectPet:FireServer(plr.Data[plr.Data:GetAttribute("current_save")]:GetAttribute("current_pet"))
	else
		task.delay(0.27, function() switchPage(_G.pages[convert(current_game).."_container"]); end)
		current_score = 0
		coins_collected = 0
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end

--[[ MENU CONTAINER ]]--
----> Play button
_G.elements.menu_container.playbtn.InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.main_map_container); workspace.CurrentCamera.CFrame = workspace.mapBase.camPos.CFrame; end)
	end
end)


----> Save buttons
for i = 1, 3 do
	_G.elements.menu_container["chooser"..i].InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
			event_queued = true
			task.delay(rxn_time, refreshUI)
			_G.events.updateSave:FireServer(i)
			event_queued = false
		end
	end)
end

--[[ MAIN MAP CONTAINER ]]--
----> Compete button
_G.elements.main_map_container["competebtn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		-- Display compete UI
		task.delay(0.27, function() switchPage(_G.pages.compete_container); workspace.CurrentCamera.CFrame = workspace.titleScreen.camPos.CFrame; end)
	end
end)

----> Train button
_G.elements.main_map_container["trainbtn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		-- Display training UI
		task.delay(0.27, function() switchPage(_G.pages.train_container); workspace.CurrentCamera.CFrame = workspace.titleScreen.camPos.CFrame; end)
	end
end)

----> Pets button
_G.elements.main_map_container["petsbtn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		-- Display pets UI
		task.delay(0.27, function() switchPage(_G.pages.pet_container); workspace.CurrentCamera.CFrame = workspace.titleScreen.camPos.CFrame; end)
	end
end)

----> Menu button
_G.elements.main_map_container["menubtn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		-- Return to menu
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.menu_container); workspace.CurrentCamera.CFrame = workspace.titleScreen.camPos.CFrame; end)
	end
end)

----> Feed button
_G.elements.main_map_container["feedbtn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		--[[
		TODO___Feed-System
			1. check balance
			2. reject or talk to server
			3. server takes money & talks to wizard
			4. wizard drops food
		]]--

		local money = plr.Data[plr.Data:GetAttribute("current_save")]:GetAttribute("coins")

		if money >= 10 then
			_G.events.feedPet:FireServer()
			task.delay(0.75, function() script.Upgrade:Play(); end)
			script.Purchase:Play()

		else
			script.Deny:Play()
		end

		event_queued = false
	end
end)

--[[ TRAINING CONTAINER ]]--
_G.elements.train_container["main_map_container_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.main_map_container); workspace.CurrentCamera.CFrame = workspace.mapBase.camPos.CFrame; end)
	end
end)

_G.elements.train_container["run_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.run_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Running"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["jump_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.jump_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Jumping"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["fish_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.fish_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Fishing"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["swim_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.swim_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Swimming"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["fly_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.fly_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Flying"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["climb_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.climb_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Climbing"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

_G.elements.train_container["dig_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.dig_container); end)
		current_score = 0
		coins_collected = 0
		current_game = "Digging"
		task.wait(.27)
		workspace.CurrentCamera.CFrame = workspace[string.lower(current_game).."Map"].camPos.CFrame
		_G.events.initiateGame:FireServer(current_game)
	end
end)

--[[ PET CONTAINER ]]--
_G.elements.pet_container["main_map_container_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.main_map_container); workspace.CurrentCamera.CFrame = workspace.mapBase.camPos.CFrame; end)
	end
end)
--print("a")
_G.events.selectPet:FireServer(plr.Data[plr.Data:GetAttribute("current_save")]:GetAttribute("current_pet"))
-- eeeeeeeee
for i, v in _G.pages.pet_container["options_container"]:GetChildren() do
	if not v:IsA("GuiButton") then return end
	pet_btn = v :: GuiButton
	--print(v)
	pet_btn.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			task.delay(rxn_time, refreshUI)
			_G.events.selectPet:FireServer(v.Name)
			script.Upgrade:Play()
		end
	end)

	if i==7 then break end
end
--print("b")
--[[ COMPETE CONTAINER ]]--
_G.elements.compete_container["main_map_container_btn"].InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not event_queued then
		event_queued = true
		task.delay(0.27, function() switchPage(_G.pages.main_map_container); workspace.CurrentCamera.CFrame = workspace.mapBase.camPos.CFrame; end)
	end
end)



--print("c")
--[[ MINIGAMES ]]--
for i, page in _G.elements do
	if page["end_game"] ~= nil then
		--print(page)
		page["end_game"].InputBegan:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				gameOver()
			end
		end)
	end
	--print(i)
	if _G.pages[i] ~= nil then
		if _G.pages[i]:FindFirstChild("action_frame") then
			for i, v in _G.pages[i]:FindFirstChild("action_frame"):GetChildren() do
				if v:IsA("GuiButton") then
					v.InputBegan:Connect(function(input: InputObject)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							_G.events.doAction:FireServer(v.Name)
						end
					end)
				end
			end
		else
			--print("not found")
		end
	end
	--if i==#_G.elements then break end
end
--print("d")
--[[ MISCELLANEOUS ]]--
_G.events["gameOver"].OnClientEvent:Connect(gameOver)
for i, item in dataFolder:GetDescendants() do item.Changed:Connect(refreshUI) end
dataFolder.Changed:Connect(refreshUI)

