local ServerStorage = game:GetService("ServerStorage")
local Coins = workspace:WaitForChild("Coins")
local CoinTemplate = ServerStorage:WaitForChild("Coin")
local CoinSpawnArea = workspace.Map1.CoinSpawnArea

local initialCoins = 100
local minDistance = 15
local respawnTime = 5

local function isFarFromOtherCoins(pos)
	for _, coin in Coins:GetChildren() do
		if coin.PrimaryPart then
			local coinPos = coin.PrimaryPart.Position
			if (coinPos - pos).Magnitude < minDistance then
				return false
			end
		end
	end
	return true
end

for i = 1, initialCoins do
	local newCoin = CoinTemplate:Clone()
	newCoin.Parent = Coins
	
	local size = CoinSpawnArea.Size
	local pos = CoinSpawnArea.Position
	
	local sizeX = size.X
	local sizeZ = size.Z
	
	local x = pos.X + math.random() * sizeX - sizeX/2
	local y = pos.Y + 2.5 
	local z = pos.Z + math.random() * sizeZ - sizeZ/2
	newCoin:SetPrimaryPartCFrame(CFrame.new(x, y, z))
end

