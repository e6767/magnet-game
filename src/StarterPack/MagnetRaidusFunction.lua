local tool = script.Parent

tool.Equipped:Connect(function()
	local char = tool.Parent
	local player = game.Players:GetPlayerFromCharacter(char)

	while tool.Parent == char do
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local player = game.Players:GetPlayerFromCharacter(char)
			local radius = player:WaitForChild("MagnetRadius").Value

			for _, coin in pairs(workspace.Coins:GetChildren()) do
				if coin:IsA("Model") and coin.PrimaryPart then
					local distance = (coin.PrimaryPart.Position - root.Position).Magnitude
					if distance < radius then
						player.leaderstats.Coins.Value += 1
						coin:Destroy()
					end
				end
			end
		end
		task.wait(0.25)
	end
end)