-- @ScriptType: ModuleScript
local clouds = {}
local cloudsDirectory = workspace:WaitForChild('weather'):WaitForChild('clouds')

local heldClouds = {}

local services = {
	tweenService = game:GetService('TweenService')
}

function clouds.resetClouds()
	heldClouds = {}
	for _,cloud in cloudsDirectory:GetChildren() do
		if cloud.Name == 'bgCloud' then continue end
		local cloudChildren = cloud:GetChildren()
		
		--for each cloud here
		if cloudChildren ~= 2 then continue end
		if cloudChildren[1].Name ~= 'cloudNode' or cloudChildren[2].Name ~= 'cloudNode' then continue end
		
		table.insert(heldClouds,cloud)
	end
end

function clouds.createCloud(cloudData, speed)
	if #cloudData ~= 2 then return end
	local nodes = cloudData:GetChildren()
	local cloudModel = cloudsDirectory:WaitForChild('bgCloud'):Clone()
	local time = (nodes[1].Position-nodes[2].Position).Magnitude/(speed or 5)
	
	cloudModel:PivotTo(CFrame.new(nodes[1].Position))
	
	local cloudTween = TweenInfo.new(
		time,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0
	)
	
	local newAnim = services.tweenService:Create(cloudModel.PrimaryPart, cloudTween, {
		Position = nodes[2].Position
	}):Play()
	
	coroutine.wrap(function()
		task.wait(time)
		cloudModel:Destroy()
	end)()
	
end

function clouds.nextStep()
	if #heldClouds == 0 then return end
	local newCloud = heldClouds[math.random(1,#heldClouds)]
	
	clouds.createCloud(newCloud)
end

return clouds