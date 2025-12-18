-- @ScriptType: Script
-- Custom Admin System Inspired by Adonis + HD Admin + Troll Commands + Global Announcement + cmds panel trigger + BTools + Trigger + Brazil
-- Place this script inside ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- === CONFIG ===

local Admins = {
	[1526462803] = true, -- Replace with your admin UserIds
	[87654321] = true,
}

local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50

-- RemoteEvents for UI and troll effects
local CmdsEvent = ReplicatedStorage:FindFirstChild("CmdsEvent")
if not CmdsEvent then
	CmdsEvent = Instance.new("RemoteEvent")
	CmdsEvent.Name = "CmdsEvent"
	CmdsEvent.Parent = ReplicatedStorage
end

local TriggerEvent = ReplicatedStorage:FindFirstChild("TriggerEvent")
if not TriggerEvent then
	TriggerEvent = Instance.new("RemoteEvent")
	TriggerEvent.Name = "TriggerEvent"
	TriggerEvent.Parent = ReplicatedStorage
end

local BrazilEvent = ReplicatedStorage:FindFirstChild("BrazilEvent")
if not BrazilEvent then
	BrazilEvent = Instance.new("RemoteEvent")
	BrazilEvent.Name = "BrazilEvent"
	BrazilEvent.Parent = ReplicatedStorage
end

-- === UTILS ===

local function isAdmin(player)
	return Admins[player.UserId] == true
end

local function findPlayerByName(name)
	name = name:lower()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #name) == name then
			return plr
		end
	end
	return nil
end

local function sendMessage(player, message)
	-- Replace with your own notification system if you want
	print("Message to "..player.Name..": "..message)
end

local function safeKick(player, reason)
	if player and player.Parent then
		player:Kick(reason or "You have been kicked by an admin.")
	end
end

-- === COMMANDS ===

local Commands = {}

-- Kick player
Commands.kick = function(admin, targetName, ...)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	local reason = table.concat({...}, " ")
	safeKick(target, reason ~= "" and reason or nil)
end

-- Ban player (simple implementation)
local bannedUserIds = {}

Commands.ban = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	bannedUserIds[target.UserId] = true
	safeKick(target, "You have been banned.")
end

Commands.unban = function(admin, userIdStr)
	local userId = tonumber(userIdStr)
	if not userId then
		sendMessage(admin, "Invalid UserId.")
		return
	end
	bannedUserIds[userId] = nil
	sendMessage(admin, "UserId "..userId.." unbanned.")
end

-- Mute player (simple)
local mutedUsers = {}

Commands.mute = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	mutedUsers[target.UserId] = true
	sendMessage(admin, target.Name.." muted.")
end

Commands.unmute = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	mutedUsers[target.UserId] = nil
	sendMessage(admin, target.Name.." unmuted.")
end

-- Bring player
Commands.bring = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		sendMessage(admin, "Player or character not found.")
		return
	end
	if not admin.Character or not admin.Character:FindFirstChild("HumanoidRootPart") then
		sendMessage(admin, "Your character not found.")
		return
	end
	target.Character.HumanoidRootPart.CFrame = admin.Character.HumanoidRootPart.CFrame
	sendMessage(admin, "Brought "..target.Name.." to you.")
end

-- Teleport admin to player
Commands.goto = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
		sendMessage(admin, "Player or character not found.")
		return
	end
	if not admin.Character or not admin.Character:FindFirstChild("HumanoidRootPart") then
		sendMessage(admin, "Your character not found.")
		return
	end
	admin.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
	sendMessage(admin, "Teleported to "..target.Name..".")
end

-- Freeze player
Commands.freeze = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.WalkSpeed = 0
		target.Character.Humanoid.JumpPower = 0
		sendMessage(admin, target.Name.." frozen.")
	else
		sendMessage(admin, "Player or character not found.")
	end
end

-- Unfreeze player
Commands.unfreeze = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.WalkSpeed = DEFAULT_WALKSPEED
		target.Character.Humanoid.JumpPower = DEFAULT_JUMPPOWER
		sendMessage(admin, target.Name.." unfrozen.")
	else
		sendMessage(admin, "Player or character not found.")
	end
end

-- Change WalkSpeed
Commands.speed = function(admin, targetName, speedStr)
	local speed = tonumber(speedStr)
	if not speed then
		sendMessage(admin, "Invalid speed.")
		return
	end
	local target = findPlayerByName(targetName)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.WalkSpeed = speed
		sendMessage(admin, target.Name.."'s speed set to "..speed)
	else
		sendMessage(admin, "Player or character not found.")
	end
end

-- Change JumpPower
Commands.jump = function(admin, targetName, jumpStr)
	local jump = tonumber(jumpStr)
	if not jump then
		sendMessage(admin, "Invalid jump power.")
		return
	end
	local target = findPlayerByName(targetName)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.JumpPower = jump
		sendMessage(admin, target.Name.."'s jump power set to "..jump)
	else
		sendMessage(admin, "Player or character not found.")
	end
end

-- Troll Commands --

-- Fake kick
Commands.fakekick = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if target then
		sendMessage(admin, target.Name.." was fake kicked.")
	else
		sendMessage(admin, "Player not found.")
	end
end

-- Spam messages
Commands.spam = function(admin, targetName, countStr)
	local count = tonumber(countStr) or 5
	local target = findPlayerByName(targetName)
	if target then
		for i=1,count do
			sendMessage(target, "Troll spam message!")
			wait(0.5)
		end
		sendMessage(admin, "Spam sent to "..target.Name)
	else
		sendMessage(admin, "Player not found.")
	end
end

-- Crash player (simulated)
Commands.crash = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if target then
		sendMessage(target, "You are being crashed (not really).")
		sendMessage(admin, "Crash simulated on "..target.Name)
	else
		sendMessage(admin, "Player not found.")
	end
end

-- Nuke command: destroys the target player's character parts with explosion effects
Commands.nuke = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target or not target.Character then
		sendMessage(admin, "Player or character not found.")
		return
	end

	local char = target.Character

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part:BreakJoints()
			part.CanCollide = false
			part.Anchored = false

			local bv = Instance.new("BodyVelocity")
			bv.Velocity = Vector3.new(
				math.random(-100, 100),
				math.random(50, 150),
				math.random(-100, 100)
			)
			bv.P = 10000
			bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bv.Parent = part

			Debris:AddItem(bv, 0.5)
		end
	end

	sendMessage(admin, "Nuked "..target.Name.."'s character.")
end

-- Broadcast message to all players (HD Admin style :m command)
Commands.m = function(admin, ...)
	local msg = table.concat({...}, " ")
	if msg == "" then
		sendMessage(admin, "Usage: :m <message>")
		return
	end
	for _, plr in pairs(Players:GetPlayers()) do
		sendMessage(plr, "[Admin Broadcast] "..msg)
	end
	sendMessage(admin, "Broadcast sent.")
end

-- Help command (Adonis style :h command)
Commands.h = function(admin)
	local cmdList = {}
	for cmdName in pairs(Commands) do
		table.insert(cmdList, ":"..cmdName)
	end
	table.sort(cmdList)
	local helpMessage = "Available commands: "..table.concat(cmdList, ", ")
	sendMessage(admin, helpMessage)
end

-- Global Announcement command (server-wide)
Commands.globalannouncement = function(admin, ...)
	local announcement = table.concat({...}, " ")
	if announcement == "" then
		sendMessage(admin, "Usage: :globalannouncement <message>")
		return
	end
	local success, err = pcall(function()
		MessagingService:PublishAsync("GlobalAnnouncement", announcement)
	end)
	if success then
		sendMessage(admin, "Global announcement sent.")
	else
		sendMessage(admin, "Failed to send global announcement: "..err)
	end
end

-- :cmds command to show commands panel UI
Commands.cmds = function(admin)
	CmdsEvent:FireClient(admin)
	sendMessage(admin, "Commands panel opened.")
end

-- BTools command: gives Hammer, Clone, and Grabber tools
Commands.btools = function(admin)
	local tools = {"Hammer", "Clone", "Grabber"}
	local backpack = admin:FindFirstChildOfClass("Backpack")
	if not backpack then
		sendMessage(admin, "Backpack not found.")
		return
	end

	for _, toolName in pairs(tools) do
		if not backpack:FindFirstChild(toolName) and not admin.Character:FindFirstChild(toolName) then
			local tool = game:GetService("StarterPack"):FindFirstChild(toolName)
			if tool then
				tool:Clone().Parent = backpack
			else
				sendMessage(admin, toolName.." tool not found in StarterPack.")
			end
		end
	end
	sendMessage(admin, "BTools given.")
end

-- New commands --

-- Adonis Trigger Command (fires client event to do screen shake etc)
Commands.trigger = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	TriggerEvent:FireClient(target)
	sendMessage(admin, "Triggered "..target.Name)
end

-- Brazil Command (fires client event to spam Brazil sound)
Commands.brazil = function(admin, targetName)
	local target = findPlayerByName(targetName)
	if not target then
		sendMessage(admin, "Player not found.")
		return
	end
	BrazilEvent:FireClient(target)
	sendMessage(admin, "Brazil command activated on "..target.Name)
end

-- === CHAT EVENT LISTENER ===

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if not isAdmin(player) then return end
		if msg:sub(1,1) ~= ":" then return end

		local args = {}
		for word in msg:gmatch("%S+") do
			table.insert(args, word)
		end

		local cmd = args[1]:sub(2):lower()
		table.remove(args, 1)

		local func = Commands[cmd]
		if func then
			local success, err = pcall(function()
				func(player, table.unpack(args))
			end)
			if not success then
				sendMessage(player, "Command error: "..err)
			end
		else
			sendMessage(player, "Command not found: "..cmd)
		end
	end)
end)

-- === SIMPLE CHAT MUTE SYSTEM ===

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if mutedUsers[player.UserId] then
			sendMessage(player, "You are muted and cannot chat.")
		end
	end)
end)

-- === BAN CHECK ON JOIN ===
Players.PlayerAdded:Connect(function(player)
	if bannedUserIds[player.UserId] then
		safeKick(player, "You are banned from this server.")
	end
end)

-- Listen to global announcements from other servers
local function onGlobalAnnouncementReceived(message)
	for _, plr in pairs(Players:GetPlayers()) do
		sendMessage(plr, "[Global Announcement] "..message.Data)
	end
end

local success, err = pcall(function()
	MessagingService:SubscribeAsync("GlobalAnnouncement", onGlobalAnnouncementReceived)
end)

if not success then
	warn("Failed to subscribe to GlobalAnnouncement:", err)
end

print("Custom Admin System loaded with extended commands, global announcements, BTools, Trigger, and Brazil commands.")

