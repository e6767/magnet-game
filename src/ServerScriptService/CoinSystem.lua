local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Coins = workspace:WaitForChild("Coins")
local CoinTemplate = ServerStorage:FindFirstChild("Coin")
local CoinSpawnArea = workspace.Map1:FindFirstChild("CoinSpawnArea")

local initialCoins = 100
local minDistance = 15
local respawnTime = 1

function test()
	print("testing")
end

local function isFarFromOtherCoins(pos)
	for _, coin in Coins:GetChildren() do
		local part = coin.PrimaryPart or coin:FindFirstChildWhichIsA("BasePart")
		if part then
			local coinPos = part.Position
			if (coinPos - pos).Magnitude < minDistance then
				return false
			end
		end
	end
	return true
end

local function getRandomPosition()
	if not CoinSpawnArea then
		return Vector3.new(0, 4, 0)
	end	
	local size = CoinSpawnArea.Size
	local areaPos = CoinSpawnArea.Position
	local pos
	repeat
		local x = areaPos.X + math.random(-size.X/2, size.X/2)
		local y = 4
		local z = areaPos.Z + math.random(-size.Z/2, size.Z/2)
		pos = Vector3.new(x, y, z)
	until isFarFromOtherCoins(pos)
	return pos
end

local function getNearbyPosition(originPos)
	local radius = 5
	local pos
	local attempts = 0
	repeat
		local angle = math.random() * 2 * math.pi
		local dist = math.random(2, radius)
		local x = originPos.X + math.cos(angle) * dist
		local y = originPos.Y
		local z = originPos.Z + math.sin(angle) * dist
		pos = Vector3.new(x, y, z)
		attempts = attempts + 1
		if attempts > 10 then
			pos = getRandomPosition()
			break
		end
	until isFarFromOtherCoins(pos)
	return pos
end

local function connectTouched(part, coin)
	part.Touched:Connect(function(hit)
		print("Coin touched event fired for part:", part.Name)
		print("Hit object:", hit and hit.Name or "nil")
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player and character then
			print("Player found:", player.Name)
			-- Only allow collection if Magnet tool is equipped in character
			local hasMagnet = false
			for _, tool in character:GetChildren() do
				if tool:IsA("Tool") then
					print("Tool found:", tool.Name)
				end
				if tool:IsA("Tool") and tool.Name == "Magnet" then
					hasMagnet = true
					print("Magnet tool equipped!")
					break
				end
			end
			print("Has Magnet:", hasMagnet)
			if hasMagnet then
				local leaderstats = player:FindFirstChild("leaderstats")
				if leaderstats then
					local coinsStat = leaderstats:FindFirstChild("Coins")
					if coinsStat then
						coinsStat.Value = coinsStat.Value + 1
						print ("test 1")
					else
						print("Coins stat not found for player:", player.Name)
					end
				else
					print("Leaderstats not found for player:", player.Name)
				end
				local coinPos = part.Position
				print("Destroying coin at position:", coinPos)
				test()
				coin:Destroy()
				task.delay(respawnTime, function()
					print("delay")
					test()
					print("New Coin")
					spawnCoin(coinPos)
				end)
			else
				print("Player does not have Magnet tool, coin not collected.")
			end
		else
			print("No valid player or character found for hit:", hit.Parent and hit.Parent.Name or tostring(hit))
		end
	end)
end

-- Added missing respawnCoin function
function respawnCoin(lastPos)
	print("Respawning coin near:", lastPos)
	spawnCoin(lastPos)
end

function spawnCoin(pos)
	if not CoinTemplate then
		print("CoinTemplate not found in ServerStorage")
		return
	end
	local coin = CoinTemplate:Clone()
	coin.Parent = Coins
	local coinpos
	if pos then
		coinpos = getNearbyPosition(pos)
		print("Coin Pos (nearby):", coinpos)
	else
		coinpos = getRandomPosition()
		print("Coin Pos (random):", coinpos)
	end

	
	local parts = {}
	if coin:IsA("BasePart") then
		table.insert(parts, coin)
	elseif coin:IsA("Model") then
		for _, child in coin:GetChildren() do
			if child:IsA("BasePart") then
				table.insert(parts, child)
			end
		end
	end
	coin.AncestryChanged:Connect(function(_, parent)
		if not parent then
			-- Coin destroyed, respawn after delay
			task.delay(respawnTime, function()
				respawnCoin(coinpos)
			end)
		end
	end)
	for _, part in parts do
		part.CFrame = CFrame.new(coinpos)
		print("Connecting touched event for part:", part.Name)
		connectTouched(part, coin)
	end
end

print("Spawning initial coins...")
for i = 1, initialCoins do
	spawnCoin()	
end
print("CoinSystem script loaded.")

