-- [[ VOIDHUB PRESTIGE v12.0 - APPLE GLASSMORPHISM EDITION ]] --
-- Rebuilt & Redesigned: Premium Dark Theme, Server Hunter, Live HUD

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 0. ANTI DOUBLE RE-EXECUTE & INIT
-- ==========================================
if CoreGui:FindFirstChild("VoidHubUI_Premium") then
    CoreGui.VoidHubUI_Premium:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_Premium"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

local State = {
    PlayerESP = false, HidePlayers = false, FullBright = false,
    WalkSpeed = false, JumpPower = false, InfJump = false,
    Noclip = false, Flying = false, FlySpeed = 50,
    SpeedValue = 24, JumpValue = 100, AntiAFK = true
}

local ESPConnections = {}
local FlyBodyVel, FlyBodyGyro

-- SMOOTH DRAG SYSTEM
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ==========================================
-- LIVE PERFORMANCE HUD
-- ==========================================
local HUDFrame = Instance.new("Frame")
HUDFrame.Size = UDim2.new(0, 340, 0, 32)
HUDFrame.Position = UDim2.new(0.5, -170, 0, 15)
HUDFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
HUDFrame.BackgroundTransparency = 0.35 -- Glassmorphism effect
HUDFrame.ZIndex = 100
HUDFrame.Parent = VoidHubUI
Instance.new("UICorner", HUDFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", HUDFrame).Color = Color3.fromRGB(255, 255, 255)
Instance.new("UIStroke", HUDFrame).Transparency = 0.85

local HUDText = Instance.new("TextLabel")
HUDText.Size = UDim2.new(1, 0, 1, 0)
HUDText.BackgroundTransparency = 1
HUDText.Text = "Syncing Data..."
HUDText.TextColor3 = Color3.fromRGB(245, 245, 250)
HUDText.TextSize = 12
HUDText.Font = Enum.Font.GothamMedium
HUDText.ZIndex = 101
HUDText.Parent = HUDFrame

RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    HUDText.Text = string.format("User: %s  |  FPS: %d  |  Ping: %d ms", LocalPlayer.Name, fps, ping)
end)

-- ==========================================
-- MAIN WINDOW FRAME (APPLE DARK UI)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BackgroundTransparency = 0.25 -- Sleek transparency
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.88
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame
MakeDraggable(Topbar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 24, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NXT VOIDLES PRESTIGE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
OpenBtn.BackgroundTransparency = 0.25
OpenBtn.Text = "V"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(OpenBtn, OpenBtn)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- TOP NAVIGATION
local NavContainer = Instance.new("Frame")
NavContainer.Size = UDim2.new(1, -48, 0, 36)
NavContainer.Position = UDim2.new(0, 24, 0, 50)
NavContainer.BackgroundTransparency = 1
NavContainer.Parent = MainFrame
local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.Padding = UDim.new(0, 8)
NavLayout.Parent = NavContainer

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -48, 1, -115)
ContentArea.Position = UDim2.new(0, 24, 0, 95)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder")
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = PagesFolder
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    return page
end

local Tabs = {
    Main = CreatePage("Main"),
    Players = CreatePage("Players"),
    Servers = CreatePage("Servers"),
    Visuals = CreatePage("Visuals"),
    Misc = CreatePage("Misc")
}
Tabs.Main.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = defaultActive and 0.1 or 0.6
    btn.Text = text
    btn.TextColor3 = defaultActive and Color3.fromRGB(10, 10, 12) or Color3.fromRGB(180, 180, 190)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Parent = NavContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(NavContainer:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35), BackgroundTransparency = 0.6}):Play()
                b.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.1}):Play()
        btn.TextColor3 = Color3.fromRGB(10, 10, 12)
    end)
end

CreateTabButton("Main", Tabs.Main, true)
CreateTabButton("Players", Tabs.Players, false)
CreateTabButton("Servers", Tabs.Servers, false)
CreateTabButton("Visuals", Tabs.Visuals, false)
CreateTabButton("System", Tabs.Misc, false)

-- ==========================================
-- UI COMPONENTS (PREMIUM DESIGN)
-- ==========================================
local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    btn.BackgroundTransparency = 0.4
    btn.Text = "   " .. titleText
    btn.TextColor3 = Color3.fromRGB(240, 240, 245)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(255,255,255)
    Instance.new("UIStroke", btn).Transparency = 0.92

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 200, 205), TextColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 34), TextColor3 = Color3.fromRGB(240, 240, 245)}):Play()
        callback()
    end)
    return btn
end

local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(255,255,255)
    Instance.new("UIStroke", frame).Transparency = 0.92

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(240, 240, 245)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.Position = UDim2.new(1, -54, 0.5, -11)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 55)
    switch.Text = ""
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = defaultState and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(200, 200, 200)
    circle.Parent = switch
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        callback(active)
    end)
end

-- ==========================================
-- 1. MAIN TAB
-- ==========================================
CreateButton(Tabs.Main, "Copy Community Invite", function()
    if setclipboard then setclipboard("https://discord.gg/voidles") end
end)

-- ==========================================
-- 2. PLAYERS TAB (NEW)
-- ==========================================
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -10, 0, 300)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.Parent = Tabs.Players
local PLayout = Instance.new("UIListLayout")
PLayout.Padding = UDim.new(0, 5)
PLayout.Parent = PlayerListFrame

local function RefreshPlayers()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local pFrame = Instance.new("Frame")
        pFrame.Size = UDim2.new(1, 0, 0, 35)
        pFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        pFrame.BackgroundTransparency = 0.5
        pFrame.Parent = PlayerListFrame
        Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 8)
        
        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(1, -20, 1, 0)
        pLabel.Position = UDim2.new(0, 10, 0, 0)
        pLabel.BackgroundTransparency = 1
        pLabel.Text = "👤 " .. p.DisplayName .. " (@" .. p.Name .. ")"
        pLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        pLabel.Font = Enum.Font.Gotham
        pLabel.TextSize = 12
        pLabel.TextXAlignment = Enum.TextXAlignment.Left
        pLabel.Parent = pFrame
    end
end
CreateButton(Tabs.Players, "🔄 Refresh Player List", RefreshPlayers)
RefreshPlayers()

-- ==========================================
-- 3. SERVERS TAB (NEW)
-- ==========================================
local ServerListFrame = Instance.new("Frame")
ServerListFrame.Size = UDim2.new(1, -10, 0, 200)
ServerListFrame.BackgroundTransparency = 1
ServerListFrame.Parent = Tabs.Servers
local SLayout = Instance.new("UIListLayout")
SLayout.Padding = UDim.new(0, 5)
SLayout.Parent = ServerListFrame

local function FetchServers(targetPlayers)
    for _, child in pairs(ServerListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local loading = Instance.new("TextLabel")
    loading.Size = UDim2.new(1, 0, 0, 30)
    loading.BackgroundTransparency = 1
    loading.Text = "Mencari server... (Harap tunggu)"
    loading.TextColor3 = Color3.fromRGB(200, 200, 200)
    loading.Font = Enum.Font.Gotham
    loading.TextSize = 12
    loading.Parent = ServerListFrame
    
    task.spawn(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        loading:Destroy()
        
        if success and result and result.data then
            local found = 0
            for _, v in pairs(result.data) do
                if v.playing == targetPlayers and v.id ~= game.JobId then
                    found = found + 1
                    local sFrame = Instance.new("Frame")
                    sFrame.Size = UDim2.new(1, 0, 0, 40)
                    sFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                    sFrame.BackgroundTransparency = 0.5
                    sFrame.Parent = ServerListFrame
                    Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 8)
                    
                    local sLabel = Instance.new("TextLabel")
                    sLabel.Size = UDim2.new(0.7, 0, 1, 0)
                    sLabel.Position = UDim2.new(0, 10, 0, 0)
                    sLabel.BackgroundTransparency = 1
                    sLabel.Text = "🌐 Server [Pemain: " .. v.playing .. " / " .. v.maxPlayers .. "]"
                    sLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
                    sLabel.Font = Enum.Font.Gotham
                    sLabel.TextSize = 12
                    sLabel.TextXAlignment = Enum.TextXAlignment.Left
                    sLabel.Parent = sFrame
                    
                    local tpBtn = Instance.new("TextButton")
                    tpBtn.Size = UDim2.new(0, 80, 0, 28)
                    tpBtn.Position = UDim2.new(1, -90, 0.5, -14)
                    tpBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
                    tpBtn.Text = "Teleport"
                    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tpBtn.Font = Enum.Font.GothamBold
                    tpBtn.TextSize = 11
                    tpBtn.Parent = sFrame
                    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
                    
                    tpBtn.MouseButton1Click:Connect(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    end)
                end
            end
            if found == 0 then
                local none = Instance.new("TextLabel")
                none.Size = UDim2.new(1, 0, 0, 30)
                none.BackgroundTransparency = 1
                none.Text = "Tidak ada server yang cocok ditemukan."
                none.TextColor3 = Color3.fromRGB(255, 100, 100)
                none.Font = Enum.Font.Gotham
                none.TextSize = 12
                none.Parent = ServerListFrame
            end
        end
    end)
end

CreateButton(Tabs.Servers, "🔍 Load Server 1 Orang (Solo Target)", function() FetchServers(1) end)
CreateButton(Tabs.Servers, "🚀 Buat/Cari New Server Kosong (Auto TP)", function()
    -- Langsung mencari server kosong dan TP otomatis
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    task.spawn(function()
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success and result and result.data then
            for _, v in pairs(result.data) do
                if (v.playing == 0 or v.playing == 1) and v.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    return
                end
            end
        end
    end)
end)

-- ==========================================
-- 4. VISUALS & UTILITY
-- ==========================================
CreateToggle(Tabs.Visuals, "Player Highlight ESP", State.PlayerESP, function(active)
    State.PlayerESP = active
    if not active then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VoidPlayerHL") then
                p.Character.VoidPlayerHL:Destroy()
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("VoidPlayerHL") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "VoidPlayerHL"
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
            end
        end
    end
end)

CreateToggle(Tabs.Visuals, "Fullbright (Terang Tanpa Bayangan)", State.FullBright, function(active)
    State.FullBright = active
    if active then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(127, 127, 127) -- Standar
        Lighting.GlobalShadows = true
    end
end)

-- ==========================================
-- 5. SYSTEM / MISC
-- ==========================================
CreateToggle(Tabs.Misc, "Anti-AFK (Virtual Controller)", State.AntiAFK, function(active)
    State.AntiAFK = active
end)

CreateButton(Tabs.Misc, "Rejoin Server Ini", function()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)
