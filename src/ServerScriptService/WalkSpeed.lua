local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.WalkSpeed = 32 
	end)
end)

