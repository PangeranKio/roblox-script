
        rLabel.TextColor3 = Color3.fromRGB(255, 220, 120)
        rLabel.TextSize = 11
        rLabel.Font = Enum.Font.GothamBold
        rLabel.TextXAlignment = Enum.TextXAlignment.Left
        rLabel.Text = "🥚 " .. item.Name .. " | Rarity Rank: " .. item.Weight .. " | Size: " .. math.floor(item.Size)
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

CreateButton(MainTabPage, "🔄 Refresh Egg Tracker List Now", function()
    pcall(RefreshEggTracker)
end)

-- Player ESP Toggle
local function CreatePlayerESP(plr)
    if plr == LocalPlayer then return end
    local function addBox(char)
        if char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("VoidESP_Box") then
            local bill = Instance.new("BillboardGui")
            bill.Name = "VoidESP_Box"
            bill.Size = UDim2.new(0, 50, 0, 50)
            bill.AlwaysOnTop = true
            bill.StudsOffset = Vector3.new(0, 2.5, 0)
            bill.Parent = char.Head
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = plr.Name
            text.TextColor3 = Color3.fromRGB(210, 140, 255)
            text.TextSize = 11
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = 0.3
            text.Parent = bill
        end
    end
    plr.CharacterAdded:Connect(addBox)
    if plr.Character then addBox(plr.Character) end
end

CreateToggle(MainTabPage, "Player ESP", SavedConfig.PlayerESP, function(state)
    _G.PlayerESPActive = state
    SavedConfig.PlayerESP = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do CreatePlayerESP(p) end
        Players.PlayerAdded:Connect(CreatePlayerESP)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local esp = p.Character.Head:FindFirstChild("VoidESP_Box")
                if esp then esp:Destroy() end
            end
        end
    end
end)


-- ==========================================
-- TAB 2: AUTO STEAL & AUTO TREADMILL
-- ==========================================
CreateToggle(AutoTabPage, "Auto Steal (Rarity & Location)", SavedConfig.AutoStealActive, function(state)
    _G.AutoStealActive = state
    SavedConfig.AutoStealActive = state
    
    task.spawn(function()
        while _G.AutoStealActive do
            pcall(function()
                local targetFound = false
                for _, obj in pairs(workspace:GetDescendants()) do
                    local nameLower = obj.Name:lower()
                    if nameLower:find("egg") or nameLower:find("telur") then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleport ke lokasi telur sesuai target
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            targetFound = true
                            task.wait(0.5)
                            break
                        end
                    end
                end
                
                -- Logika Auto Treadmill jika telur tidak ditemukan di map
                if not targetFound and SavedConfig.AutoTreadmill then
                    local treadmillPart = workspace:FindFirstChild("Treadmill", true) or workspace:FindFirstChild("Gym", true)
                    if treadmillPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = treadmillPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

CreateToggle(AutoTabPage, "Auto Treadmill (If No Egg Found)", SavedConfig.AutoTreadmill, function(state)
    SavedConfig.AutoTreadmill = state
end)


-- ==========================================
-- TAB 3: WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "Custom WalkSpeed (24)", SavedConfig.WalkSpeedVal == 24, function(state)
    _G.SpeedActive = state
    SavedConfig.WalkSpeedVal = state and 24 or 16
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
-- TAB 4: MISC TAB (SERVER HOPE, REJOIN, ANTI-AFK)
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
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

CreateButton(MiscTabPage, "🌐 Server Hope (Cari Server Sepi)", function()
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
        else
            warn("Server sepi tidak ditemukan.")
        end
    end)
end)


-- ==========================================
-- TAB 5: CONFIG TAB (SAVE & LOAD)
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


-- ==========================================
-- RESIZE HANDLE
-- ==========================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(170, 130, 200)
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
        local NewX = math.max(460, StartSize.X.Offset + Delta.X)
        local NewY = math.max(260, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)
