-- @ScriptType: LocalScript
local buttons = {} 

for i, v in script:FindFirstAncestorOfClass("ScreenGui"):GetDescendants() do
	if v:IsA("GuiButton") and not(v:FindFirstAncestor("save_table")) then
		local data = {}

		data.Object = v
		data.defaultX = v.Size.X.Scale
		data.defaultY = v.Size.Y.Scale

		buttons[i] = data
	end
end





local size = 0.04
local speed = 0.1 



for i, v in buttons do

	if not game:GetService("UserInputService").TouchEnabled then
		v.Object.MouseEnter:Connect(function ()

			v.Object:TweenSize(UDim2.fromScale(v.defaultX + size, v.defaultY + size), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
			script.Hover:Play()

		end)

		v.Object.MouseLeave:Connect(function ()

			v.Object:TweenSize(UDim2.fromScale(v.defaultX, v.defaultY), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1, true)


		end)

		v.Object.MouseButton1Click:Connect(function ()
			task.delay(.1, function()
				v.Object:TweenSize(UDim2.fromScale(v.defaultX, v.defaultY), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
			end)
			v.Object:TweenSize(UDim2.fromScale(v.defaultX-size, v.defaultY-size), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1, true)
			script.Click:Play()
		end)
	else
		v.Object.TouchTap:Connect(function ()
			task.delay(.1, function()
				v.Object:TweenSize(UDim2.fromScale(v.defaultX, v.defaultY), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
			end)
			v.Object:TweenSize(UDim2.fromScale(v.defaultX-size, v.defaultY-size), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1, true)
			script.Click:Play()
		end)
	end
end
