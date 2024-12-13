-- Create ESP function
local function createESP(player)
	local espBox = Drawing.new("Square")
	espBox.Visible = false
	espBox.Thickness = 2
	espBox.Color = Color3.fromRGB(255, 0, 0)
	espBox.Filled = false

	local nameTag = Drawing.new("Text")
	nameTag.Visible = false
	nameTag.Color = Color3.fromRGB(255, 255, 255)
	nameTag.Size = 20
	nameTag.Center = true
	nameTag.Outline = true

	local healthTag = Drawing.new("Text")
	healthTag.Visible = false
	healthTag.Color = Color3.fromRGB(0, 255, 0)
	healthTag.Size = 18
	healthTag.Center = true
	healthTag.Outline = true

	-- Update ESP box and tags position and size
	local function update()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			local rootPart = player.Character.HumanoidRootPart
			local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
			if onScreen then
				espBox.Size = Vector2.new(2000 / screenPos.Z, 4000 / screenPos.Z)
				espBox.Position = Vector2.new(screenPos.X - espBox.Size.X / 2, screenPos.Y - espBox.Size.Y / 2)
				espBox.Visible = true

				nameTag.Text = player.Name
				nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - espBox.Size.Y / 2 - 20)
				nameTag.Visible = true

				healthTag.Text = math.floor(player.Character.Humanoid.Health) .. " / " .. math.floor(player.Character.Humanoid.MaxHealth)
				healthTag.Position = Vector2.new(screenPos.X, screenPos.Y + espBox.Size.Y / 2 + 5)
				healthTag.Visible = true
			else
				espBox.Visible = false
				nameTag.Visible = false
				healthTag.Visible = false
			end
		else
			espBox.Visible = false
			nameTag.Visible = false
			healthTag.Visible = false
		end
	end

	-- Connect render step to update ESP
	game:GetService("RunService").RenderStepped:Connect(update)

	-- Remove ESP when player leaves
	player.AncestryChanged:Connect(function()
		if not player:IsDescendantOf(game) then
			espBox:Remove()
			nameTag:Remove()
			healthTag:Remove()
		end
	end)
end

-- Apply ESP to all players
for _, player in ipairs(game.Players:GetPlayers()) do
	if player ~= game.Players.LocalPlayer then
		createESP(player)
	end
end

-- Apply ESP to new players
game.Players.PlayerAdded:Connect(function(player)
	if player ~= game.Players.LocalPlayer then
		createESP(player)
	end
end)
