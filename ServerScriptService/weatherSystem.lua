-- @ScriptType: Script
local serverScriptService = game:GetService('ServerScriptService')
local clouds = require(serverScriptService:WaitForChild('modules'):WaitForChild('weather'):WaitForChild('cloudModule'))

clouds.resetClouds()
clouds.nextStep()