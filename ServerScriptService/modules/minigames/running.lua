-- @ScriptType: ModuleScript
local running = {}

local startStud = workspace:WaitForChild('runningMap'):WaitForChild('startStud')
local endStud = workspace:WaitForChild('runningMap'):WaitForChild('finStud')
local obsFolder = game:GetService("ServerStorage"):WaitForChild('obstacles')
local placeholder = workspace:WaitForChild('runningMap'):WaitForChild('placeholder')

local speedy = 1
local startTime = os.time()
local isAlive = false
local runningTweens = {}
--local activeObstacles = {}
local obstacleId = 0

local obstacles = {
	obsFolder:WaitForChild('watermelon'),
	obsFolder:WaitForChild('arrow')
}

local services = {
	tweenService = game:GetService('TweenService')
}

function running.calculateTween(speed,part,start,fin)
	part.Position = start
	local waittime = speed
	local tweenInf = TweenInfo.new(
		waittime,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		0,
		false
	)

	local newTween = services.tweenService:Create(part, tweenInf, {
		Position = fin
	})
	
	return newTween
end

function running.spawnObstacle(speed: number)
	if not startStud or not endStud then return end
	if #obsFolder:GetChildren() == 0 then return end
	
	local base_speed_modifier = 10
	
	local newObstacle: MeshPart = obsFolder:GetChildren()[math.random(1,#obsFolder:GetChildren())]:Clone()
	newObstacle.Parent = workspace.active_obstacles
	newObstacle.Anchored = true
	--print(speed)
	
	task.spawn(function()
		while newObstacle ~= nil do
			task.wait()
			local params =  OverlapParams.new()
			
			params.FilterDescendantsInstances = {workspace.Current_pet}
			params.FilterType = Enum.RaycastFilterType.Include
			
			if #workspace:GetPartBoundsInBox(newObstacle.CFrame, newObstacle.Size, params) ~= 0 then
				--print(#workspace:GetPartBoundsInBox(pos, size, params))
				running.endGame()
			end
		end
	end)

	local newTween = running.calculateTween(speed*base_speed_modifier,newObstacle,startStud.Position,endStud.Position)
	
	obstacleId += 1
	
	--activeObstacles[obstacleId] = newObstacle
	runningTweens[obstacleId] = newTween
	
	task.delay(newTween.TweenInfo.Time, function()
		newTween:Destroy()
		newObstacle:Destroy()
	end)
	
	newTween:Play()
end

function running.startGame()
	startTime = os.clock()
	isAlive = true
	local starting_wait_time = 2
	local minimum_wait_time = 1.5
	
	while isAlive do
		local dampener = 0.3
		local wait_time = math.max(minimum_wait_time, starting_wait_time-(os.difftime(os.clock(), startTime)*dampener))
		--print(wait_time)
		task.wait(wait_time)
		running.spawnObstacle(.3)
		
	end
end

function running.setAlive(new: boolean)
	isAlive = new
end

function running.endGame()
	--if isAlive then game.ReplicatedStorage.Events.gameOver:FireAllClients() end
	isAlive = false
	
	for _,tween: Tween in runningTweens do
		tween:Destroy()
	end
	
	--camera return
	
	for _,obstacle in workspace.active_obstacles:GetChildren() do
		obstacle:Destroy()
	end
end

return running