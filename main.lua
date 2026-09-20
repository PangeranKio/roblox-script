ckgroundTransparency = 1
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

CreateToggle(MainTabPage, "Player ESP", function(state)
    _G.PlayerESPActive = state
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

-- Enhanced Egg ESP (Fix Pencarian Menyeluruh ke Model, Folder, & Part Telur)
local function RefreshEggs()
    for _, obj in pairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        -- Cek apakah objek mengandung kata kunci telur/egg/item atau berada di dalam folder telur
        if nameLower:find("egg") or nameLower:find("telur") or nameLower:find("item") then
            local targetPart = nil
            if obj:IsA("BasePart") then
                targetPart = obj
            elseif obj:IsA("Model") and obj.PrimaryPart then
                targetPart = obj.PrimaryPart
            elseif obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") then
                targetPart = obj:FindFirstChildWhichIsA("BasePart")
            end
            
            if targetPart and targetPart.Transparency < 0.95 then
                -- Highlight Bersinar
                if not targetPart:FindFirstChild("EggHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "EggHighlight"
                    hl.FillColor = Color3.fromRGB(160, 60, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.35
                    hl.Parent = targetPart
                end
                
                -- Tag Informasi Isi & Berat Telur
                if not targetPart:FindFirstChild("EggInfoTag") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "EggInfoTag"
                    bill.Size = UDim2.new(0, 120, 0, 45)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 2.5, 0)
                    bill.Parent = targetPart
                    
                    local txt = Instance.new("TextLabel")
                    txt.Name = "InfoText"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 220, 120)
                    txt.TextSize = 11
                    txt.Font = Enum.Font.GothamBold
                    txt.TextStrokeTransparency = 0.2
                    txt.Text = obj.Name
                    txt.Parent = bill
                else
                    -- Update Teks Nilai / Berat Telur secara dinamis
                    local txt = targetPart.EggInfoTag:FindFirstChild("InfoText")
                    if txt then
                        local displayText = obj.Name
                        -- Ambil info dari nilai anak (Value / Attribute) jika ada
                        for _, child in pairs(obj:GetChildren()) do
                            if child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") then
                                displayText = obj.Name .. "\n[" .. tostring(child.Value) .. "]"
                            end
                        end
                        txt.Text = displayText
                    end
                end
            end
        end
    end
end

CreateToggle(MainTabPage, "Egg ESP (Auto Scan & Info)", function(state)
    _G.EggESPActive = state
    task.spawn(function()
        while _G.EggESPActive do
            pcall(RefreshEggs)
            task.wait(1.2)
        end
        -- Bersihkan semua ESP telur ketika dimatikan
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj:FindFirstChild("EggHighlight") then obj.EggHighlight:Destroy() end
                if obj:FindFirstChild("EggInfoTag") then obj.EggInfoTag:Destroy() end
            end
        end
    end)
end)

CreateButton(MainTabPage, "🔄 Refresh Egg ESP Now", function()
    pcall(RefreshEggs)
end)


-- ==========================================
-- FITUR: WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "Custom WalkSpeed (24)", function(state)
    if state then
        _G.SpeedActive = true
        task.spawn(function()
            while _G.SpeedActive do
                pcall(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 24 end
                end)
                task.wait(0.2)
            end
        end)
    else
        _G.SpeedActive = false
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)


-- ==========================================
-- FITUR: MISC TAB (SERVER HOPE, REJOIN, ANTI-AFK)
-- ==========================================
CreateToggle(MiscTabPage, "Anti-AFK Safe", function(state)
    if state then
        _G.AntiAFKActive = true
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
    else
        _G.AntiAFKActive = false
    end
end)

-- Tombol Rejoin Server
CreateButton(MiscTabPage, "🔄 Rejoin Server", function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

-- Tombol Server Hop (Mencari Server Sepi)
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
            warn("Server sepi tidak ditemukan, silakan coba lagi.")
        end
    end)
end)

-- ==========================================
-- 5. RESIZE HANDLE (SMOOTH CORNER DRAG)
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
        local NewX = math.max(420, StartSize.X.Offset + Delta.X)
        local NewY = math.max(240, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- ==========================================
-- 6. ANIMASI PEMBUKAAN WINDOW
-- ==========================================
local TweenBack = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)

-- ==========================================
-- 7. EXECUTION LOADING PROCESS
-- ==========================================
task.spawn(function()
    pcall(function()
        task.wait(0.35)
        LoadStatus.Text = "Rendering Glassmorphism UI..."
        task.wait(0.35)
        LoadStatus.Text = "Injecting Advanced ESP Modules..."
        task.wait(0.35)
    end)
    
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame:Destroy()
    end
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSiz
