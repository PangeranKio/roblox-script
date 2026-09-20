rt:FindFirstChild("VoidEggHighlight") then
                item.Part.VoidEggHighlight:Destroy()
            end
        end
        
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(32, 14, 52)
        row.BackgroundTransparency = 0.25
        row.Parent = EggTrackerContainer
        
        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = row
        
        local rLabel = Instance.new("TextLabel")
        rLabel.Size = UDim2.new(1, -10, 1, 0)
        rLabel.Position = UDim2.new(0, 10, 0, 0)
        rLabel.BackgroundTransparency = 1
        rLabel.TextColor3 = Color3.fromRGB(255, 220, 130)
        rLabel.TextSize = 11
        rLabel.Font = Enum.Font.GothamBold
        rLabel.TextXAlignment = Enum.TextXAlignment.Left
        rLabel.Text = "🥚 " .. item.Name
        rLabel.Parent = row
    end
end

CreateToggle(MainTabPage, "Egg ESP & Sorted UI Tracker", SavedConfig.EggESPUI, function(state)
    _G.EggESPUIActive = state
    SavedConfig.EggESPUI = state
    task.spawn(function()
        while _G.EggESPUIActive do
            pcall(RefreshEggTracker)
            task.wait(1.5)
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("VoidEggHighlight") then
                obj.VoidEggHighlight:Destroy()
            end
        end
    end)
end)

CreateButton(MainTabPage, "🔄 Refresh Egg List Now", function()
    pcall(RefreshEggTracker)
end)


-- ==========================================
-- TAB 2: AUTO STEAL & SELECTED EGG MENU & WORKING TREADMILL
-- ==========================================

-- Dropdown / Selector Menu Telur Target
local SelectedEggLabel = Instance.new("TextLabel")
SelectedEggLabel.Size = UDim2.new(1, 0, 0, 24)
SelectedEggLabel.BackgroundTransparency = 1
SelectedEggLabel.Text = "Target Selected Egg: [ " .. SavedConfig.SelectedEggTarget .. " ]"
SelectedEggLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
SelectedEggLabel.TextSize = 12
SelectedEggLabel.Font = Enum.Font.GothamBold
SelectedEggLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedEggLabel.Parent = AutoTabPage

CreateButton(AutoTabPage, "🔄 Cycle Selected Egg Target", function()
    if SavedConfig.SelectedEggTarget == "All Eggs" then
        SavedConfig.SelectedEggTarget = "Rare / Epic"
    elseif SavedConfig.SelectedEggTarget == "Rare / Epic" then
        SavedConfig.SelectedEggTarget = "Legendary / Mythic"
    elseif SavedConfig.SelectedEggTarget == "Legendary / Mythic" then
        SavedConfig.SelectedEggTarget = "Divine"
    else
        SavedConfig.SelectedEggTarget = "All Eggs"
    end
    SelectedEggLabel.Text = "Target Selected Egg: [ " .. SavedConfig.SelectedEggTarget .. " ]"
end)

CreateToggle(AutoTabPage, "Auto Steal (Walking / Pathfinding)", SavedConfig.AutoStealActive, function(state)
    _G.AutoStealActive = state
    SavedConfig.AutoStealActive = state
    
    task.spawn(function()
        while _G.AutoStealActive do
            pcall(function()
                local targetFound = false
                local targetPart = nil
                
                -- Cari telur di map dengan filter aman (menghindari mesin fusi)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if IsValidEgg(obj.Name, obj) then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            targetPart = part
                            targetFound = true
                            break
                        end
                    end
                end
                
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if targetFound and targetPart and hum and hrp then
                    -- Berjalan/Lari menuju telur (bukan teleport instan)
                    hum:MoveTo(targetPart.Position)
                elseif SavedConfig.AutoTreadmill and hum and hrp then
                    -- Jika telur tidak ada, berjalan otomatis ke mesin Treadmill / Gym
                    local treadmill = workspace:FindFirstChild("Treadmill", true) or workspace:FindFirstChild("Gym", true)
                    if treadmill then
                        local tPart = treadmill:IsA("BasePart") and treadmill or treadmill:FindFirstChildWhichIsA("BasePart")
                        if tPart then
                            hum:MoveTo(tPart.Position)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

CreateToggle(AutoTabPage, "Auto Treadmill (If No Egg Found)", SavedConfig.AutoTreadmill, function(state)
    SavedConfig.AutoTreadmill = state
end)


-- ==========================================
-- TAB 3: WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "Custom WalkSpeed (24)", false, function(state)
    _G.SpeedActive = state
    task.spawn(function()
        while _G.SpeedActive do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 24 end
            end)
            task.wait(0.2)
        end
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end)
end)


-- ==========================================
-- TAB 4: MISC TAB
-- ==========================================
CreateToggle(MiscTabPage, "Anti-AFK Safe", true, function(state)
    _G.AntiAFKActive = state
    task.spawn(function()
        local lastMove = tick()
        while _G.AntiAFKActive do
            if tick() - lastMove >= 30 then
                lastMove = tick()
                pcall(function()
                    local currentCam = workspace.CurrentCamera
                    if currentCam then
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, 0.001, 0)
                        task.wait(0.05)
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, -0.001, 0)
                    end
                end)
            end
            task.run(RunService.RenderStepped)
        end
    end)
end)

CreateButton(MiscTabPage, "🔄 Rejoin Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

CreateButton(MiscTabPage, "🌐 Server Hop (Cari Server Sepi)", function()
    pcall(function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(req.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
end)


-- ==========================================
-- TAB 5: CONFIG TAB
-- ==========================================
CreateButton(ConfigTabPage, "💾 Save Current Settings", function()
    SaveSettings()
    LoadStatus.Text = "Config Successfully Saved!"
    task.wait(1.5)
end)

CreateButton(ConfigTabPage, "📂 Load Config Settings", function()
    LoadSettings()
    LoadStatus.Text = "Config Successfully Loaded!"
    task.wait(1.5)
end)


-- RESIZE HANDLE
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(180, 140, 220)
ResizeHandle.TextSize = 10
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Parent = MainFrame

local Resizing, StartSize, StartInputPos = false, nil, nil
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        StartSize = MainFrame.Size
        StartInputPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - StartInputPos
        local NewX = math.max(480, StartSize.X.Offset + Delta.X)
        local NewY = math.max(280, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- ANIMATION & EXECUTION
local TweenBack = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)

task.spawn(function()
    p
