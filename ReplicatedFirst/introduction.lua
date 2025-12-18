-- @ScriptType: LocalScript
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
task.spawn(function() 
	pcall(function() 
		repeat task.wait(0.1) 
		until StarterGui:GetCore("ResetButtonCallback") == false or not StarterGui:SetCore("ResetButtonCallback", false)
	end) 
end)

----> Load game
local UI = script:WaitForChild("LoadingScreen")
local total = game.Workspace:GetDescendants()
local total2 = StarterGui:GetDescendants()
local total3 = game.ReplicatedStorage:GetDescendants()
local num_tot, num_tot2, num_tot3 = #total, #total2, #total3

script["Acoustic finger picking guitar buildup soundtrack"]:Play()

UI.Parent = Players.LocalPlayer.PlayerGui

local icon_anim = coroutine.create(function()
	local container = UI:WaitForChild("icon_container")

	while task.wait() do
		for i=1, 3 do
			local square: Frame = container:FindFirstChild(tostring(i))

			if square then
				task.delay(0.2, function()
					pcall(function()
						square:TweenPosition(UDim2.fromScale(0.25*i, 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.2, true)
						TweenService:Create(square, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency=0.5}):Play()
					end)
				end)

				square:TweenPosition(UDim2.fromScale(0.25*i, 0.25), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.2, true)
				TweenService:Create(square, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency=0}):Play()
			end
			task.wait(0.39)
		end
		task.wait(0.5)
	end
end)

function initialize()
	task.delay(1.2, function() 
		if UI and UI.Parent and UI.Parent:IsA("PlayerGui") and UI.Parent:FindFirstChild("Interface") then
			local playBtn = UI.Parent.Interface:FindFirstChild("menu_container") and UI.Parent.Interface.menu_container:FindFirstChild("options_container") and UI.Parent.Interface.menu_container.options_container:FindFirstChild("playbtn")
			if playBtn then
				playBtn.Active = true
				playBtn.Interactable = true
			end
		end
		if UI then UI:Destroy() end
	end)

	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local interface = playerGui:WaitForChild("Interface")
	local menuContainer = interface:WaitForChild("menu_container")
	menuContainer.Visible = true

	TweenService:Create(script["Acoustic finger picking guitar buildup soundtrack"], TweenInfo.new(0.4),{Volume=0}):Play()
	
	script["Guitar Chord"]:Play()
	
	script["Ant Farm (b)"]:Play()
	TweenService:Create(script["Ant Farm (b)"], TweenInfo.new(0.3),{Volume=1}):Play()
	
	task.wait(0.4) -- Wait for fade out before stopping
	script["Acoustic finger picking guitar buildup soundtrack"]:Stop()
	
	interface.Enabled = true
	if UI then -- Check if UI still exists before iterating
		for i, v in UI:GetDescendants() do
			if v:IsA("GuiObject") then
				TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency=1}):Play()
			end
		end
	end
end

local layoutOrder = 0
coroutine.resume(icon_anim)

for i, v in total do
	task.wait(0.01) -- Small wait to prevent exhaustion
	ContentProvider:PreloadAsync({v})
	local new = UI.loaded_assets_list.template_item:Clone()
	new.Text = "("..i.."/"..num_tot..") "..v.Name
	new.Parent = UI.loaded_assets_list
	new.LayoutOrder = layoutOrder
	layoutOrder += 1
	new.Visible = true
	UI.load_bar_container.progress_indication.Size = UDim2.fromScale(i/num_tot + 0.02,1.1)
	Debris:AddItem(new, 3)
end
for i, v in total2 do
	task.wait(0.01)
	ContentProvider:PreloadAsync({v})
	local new = UI.loaded_assets_list.template_item:Clone()
	new.Text = "("..i.."/"..num_tot2..") "..v.Name
	new.Parent = UI.loaded_assets_list
	new.LayoutOrder = layoutOrder
	layoutOrder += 1
	new.Visible = true
	UI.load_bar_container.progress_indication.Size = UDim2.fromScale(i/num_tot2 + 0.02,1.1)
	Debris:AddItem(new, 3)
end
-- The original script had 'total' here again, assuming it was a typo and meant 'total3'
for i, v in total3 do 
	task.wait(0.01)
	ContentProvider:PreloadAsync({v})
	local new = UI.loaded_assets_list.template_item:Clone()
	new.Text = "("..i.."/"..num_tot3..") "..v.Name
	new.Parent = UI.loaded_assets_list
	new.LayoutOrder = layoutOrder
	layoutOrder += 1
	new.Visible = true
	UI.load_bar_container.progress_indication.Size = UDim2.fromScale(i/num_tot3 + 0.02,1.1)
	Debris:AddItem(new, 3)
end

if UI and UI:FindFirstChild("loaded_assets_list") then UI.loaded_assets_list:Destroy() end
if UI and UI:FindFirstChild("load_bar_container") then UI.load_bar_container:Destroy() end
task.wait(1)
coroutine.close(icon_anim) -- This might error if icon_anim already completed or errored.
initialize()