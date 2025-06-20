-- @ScriptType: ModuleScript
local climbing = {}
local climbingMap = workspace:WaitForChild('climbingMap')

local services = {
	tweenService = game:GetService('TweenService'),
	runService = game:GetService('RunService')
}

local spikes = {
	climbingMap:WaitForChild('spikes'):WaitForChild('left'),
	climbingMap:WaitForChild('spikes'):WaitForChild('right')
}

local activeSpikes = {}



function climbing.spawnSpike()
	local ranInt = math.random(1,#spikes)
	local spike = spikes[ranInt]:Clone()
	spike.Parent = workspace
	
	table.insert(activeSpikes,spike)
	
	spike.Touched:Connect(function(otherPart)
		if otherPart.Name == 'placeholder' then
			climbing.endGame()
		end
	end)
end

function climbing.startGame()
	services.runService.RenderStepped:Connect(function()
		
	end)
end

function climbing.endGame()
	
end

return climbing