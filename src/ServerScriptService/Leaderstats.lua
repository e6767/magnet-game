local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(plr)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local magnetRadius = Instance.new("IntValue")
	magnetRadius.Name = "MagnetRadius"
	magnetRadius.Value = 20
	magnetRadius.Parent = plr

	
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats
	
	local gems = Instance.new("IntValue")
	gems.Name = "Gems"
	gems.Value = 0
	gems.Parent = leaderstats
	
	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = 0
	rebirths.Parent = leaderstats
	
end)
