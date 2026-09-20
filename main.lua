-- [[ VOIDHUB SUPREME v12.0 - LUXURY EXECUTIVE EDITION ]] --
-- Theme: Dark Obsidian & Ice Gold Glassmorphism
-- Features: Solo Server Scanner, Dynamic Player Tracker, Mouse Click TP, Fullbright

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
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 0. ANTI DOUBLE RE-EXECUTE & CLEANUP
-- ==========================================
if CoreGui:FindFirstChild("VoidHubUI_Supreme") then
    CoreGui.VoidHubUI_Supreme:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_Supreme"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- COLOR PALETTE (LUXURY EXECUTIVE)
local C_BG = Color3.fromRGB(10, 11, 14)
local C_PANEL = Color3.fromRGB(18, 20, 26)
local C_ACCENT = Color3.fromRGB(235, 185, 95) -- Liquid Gold
local C_ACCENT_GLOW = Color3.fromRGB(255, 210, 120)
local C_TEXT = Color3.fromRGB(240, 242, 248)
local C_SUBTEXT = Color3.fromRGB(140, 145, 160)
local C_ITEM = Color3.fromRGB(25, 28, 36)
local C_STROKE = Color3.fromRGB(45, 50, 65)

-- SYSTEM STATE
local State = {
    PlayerESP = false,
    HidePlayers = false,
    WalkSpeed = false,
    JumpPower = false,
    InfJump = false,
    Noclip = false,
    Flying = false,
    ClickTP = false,
    Fullbright = false,
    FlySpeed = 50,
    SpeedValue = 24,
    JumpValue = 100,
    AntiAFK = true
}

local FlyBodyVel, FlyBodyGyro
local ESPConnections = {}
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

-- SMOOTH DRAGGING
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
            TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ==========================================
-- 1. FLOATING TOGGLE BUTTON (MINIMALIST LOGO)
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 120, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = C_BG
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "✧ VOIDHUB"
OpenBtn.TextColor3 = C_ACCENT
OpenBtn.TextSize = 12
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI

Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = C_ACCENT
OpenStroke.Transparency = 0.5
OpenStroke.Thickness = 1
MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN EXECUTIVE WINDOW
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundColor3 = C_BG
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C_STROKE
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundColor3 = C_PANEL
Topbar.BackgroundTransparency = 0.5
Topbar.ZIndex = 11
Topbar.Parent = MainFrame
MakeDraggable(Topbar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#EBB95F\">SUPREME</font>"
Title.RichText = true
Title.TextColor3 = C_TEXT
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 11)
CloseBtn.BackgroundColor3 = C_ITEM
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_SUBTEXT
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- SIDE NAVIGATION BAR (LEFT SIDEBAR)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = C_PANEL
Sidebar.BackgroundTransparency = 0.4
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 6)
NavLayout.Parent = Sidebar

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingTop = UDim.new(0, 12)
NavPadding.PaddingLeft = UDim.new(0, 10)
NavPadding.PaddingRight = UDim.new(0, 10)
NavPadding.Parent = Sidebar

-- CONTENT CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -175, 1, -65)
ContentArea.Position = UDim2.new(0, 168, 0, 58)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder")
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = C_ACCENT
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    return page
end

local MainTabPage = CreatePage("Main")
local MovementTabPage = CreatePage("Movement")
local VisualTabPage = CreatePage("Visual")
local ServerTabPage = CreatePage("Server")
local PlayersTabPage = CreatePage("Players")
local MiscTabPage = CreatePage("Misc")

MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = defaultActive and C_ACCENT or C_ITEM
    btn.BackgroundTransparency = defaultActive and 0 or 0.6
    btn.Text = "  " .. text
    btn.TextColor3 = defaultActive and C_BG or C_SUBTEXT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM, BackgroundTransparency = 0.6}):Play()
                b.TextColor3 = C_SUBTEXT
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT, BackgroundTransparency = 0}):Play()
        btn.TextColor3 = C_BG
    end)
end

CreateTabButton("Dashboard", MainTabPage, true)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Visuals", VisualTabPage, false)
CreateTabButton("Server Finder", ServerTabPage, false)
CreateTabButton("Player List", PlayersTabPage, false)
CreateTabButton("System / Misc", MiscTabPage, false)

-- ==========================================
-- UI COMPONENT BUILDERS (PREMIUM CARDS)
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 42)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = C_STROKE
    stroke.Transparency = 0.8

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = C_TEXT
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 38, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = defaultState and C_ACCENT or Color3.fromRGB(45, 50, 60)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = defaultState and C_BG or C_TEXT
    circle.ZIndex = 15
    circle.Parent = switch
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = C_BG}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 50, 60)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = C_TEXT}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 38)
    btn.BackgroundColor3 = C_ITEM
    btn.Text = titleText
    btn.TextColor3 = C_TEXT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.ZIndex = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = C_STROKE
    stroke.Transparency = 0.8

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C_ACCENT, TextColor3 = C_BG}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM, TextColor3 = C_TEXT}):Play()
        callback()
    end)
end

-- ==========================================
-- 3. DASHBOARD TAB
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -6, 0, 75)
ProfileCard.BackgroundColor3 = C_ITEM
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 55, 0, 55)
AvatarImg.Position = UDim2.new(0, 10, 0, 10)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
AvatarImg.ZIndex = 14
AvatarImg.Parent = ProfileCard
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -80, 0, 20)
WelcomeText.Position = UDim2.new(0, 75, 0, 16)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome, <font color=\"#EBB95F\">" .. LocalPlayer.DisplayName .. "</font>"
WelcomeText.RichText = true
WelcomeText.TextColor3 = C_TEXT
WelcomeText.TextSize = 14
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.ZIndex = 14
WelcomeText.Parent = ProfileCard

local UserSubText = Instance.new("TextLabel")
UserSubText.Size = UDim2.new(1, -80, 0, 18)
UserSubText.Position = UDim2.new(0, 75, 0, 38)
UserSubText.BackgroundTransparency = 1
UserSubText.Text = "Status: Executive Tier  |  Ping: 0ms  |  FPS: 60"
UserSubText.TextColor3 = C_SUBTEXT
UserSubText.TextSize = 11
UserSubText.Font = Enum.Font.Gotham
UserSubText.TextXAlignment = Enum.TextXAlignment.Left
UserSubText.ZIndex = 14
UserSubText.Parent = ProfileCard

RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    UserSubText.Text = string.format("Status: Executive Tier  |  FPS: %d  |  Ping: %d ms", fps, ping)
end)

CreateButton(MainTabPage, "Copy Official Discord Link", function()
    if setclipboard then setclipboard("https://discord.gg/voidhub") end
end)

-- ==========================================
-- 4. MOVEMENT TAB
-- ==========================================
local function StartFlying()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    FlyBodyVel = Instance.new("BodyVelocity", root)
    FlyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVel.Velocity = Vector3.zero

    FlyBodyGyro = Instance.new("BodyGyro", root)
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = root.CFrame

    task.spawn(function()
        while State.Flying and char and root:FindFirstChild("BodyVelocity") do
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            FlyBodyVel.Velocity = moveDir * State.FlySpeed
            FlyBodyGyro.CFrame = cam.CFrame
            task.wait()
        end
    end)
end

local function StopFlying()
    if FlyBodyVel then FlyBodyVel:Destroy() FlyBodyVel = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
end

CreateToggle(MovementTabPage, "Kinetic Flight Mode", State.Flying, function(active)
    State.Flying = active
    if active then StartFlying() else StopFlying() end
end)

CreateToggle(MovementTabPage, "Speed Modifier (24 WalkSpeed)", State.WalkSpeed, function(active)
    State.WalkSpeed = active
    task.spawn(function()
        while State.WalkSpeed do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = State.SpeedValue
                end
            end)
            task.wait(0.2)
        end
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end)
    end)
end)

CreateToggle(MovementTabPage, "Jump Power Boost (100 Jump)", State.JumpPower, function(active)
    State.JumpPower = active
    task.spawn(function()
        while State.JumpPower do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = State.JumpValue
                end
            end)
            task.wait(0.2)
        end
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 50 end
        end)
    end)
end)

CreateToggle(MovementTabPage, "Infinite Jump in Air", State.InfJump, function(active)
    State.InfJump = active
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(MovementTabPage, "Ghost Noclip (Walk Through Walls)", State.Noclip, function(active)
    State.Noclip = active
    task.spawn(function()
        while State.Noclip do
            pcall(function()
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- ==========================================
-- 5. VISUALS TAB
-- ==========================================
local function ApplyPlayerESP(player)
    if player == LocalPlayer or not player.Character then return end
    if not player.Character:FindFirstChild("VoidPlayerHL") then
        local hl = Instance.new("Highlight")
        hl.Name = "VoidPlayerHL"
        hl.FillColor = C_ACCENT
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.2
        hl.Parent = player.Character
    end
end

CreateToggle(VisualTabPage, "Player Highlight ESP", State.PlayerESP, function(active)
    State.PlayerESP = active
    if active then
        for _, p in pairs(Players:GetPlayers()) do ApplyPlayerESP(p) end
        ESPConnections["Loop"] = RunService.Heartbeat:Connect(function()
            if State.PlayerESP then
                for _, p in pairs(Players:GetPlayers()) do ApplyPlayerESP(p) end
            end
        end)
    else
        if ESPConnections["Loop"] then ESPConnections["Loop"]:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VoidPlayerHL") then
                p.Character.VoidPlayerHL:Destroy()
            end
        end
    end
end)

CreateToggle(VisualTabPage, "Hide All Player Models", State.HidePlayers, function(active)
    State.HidePlayers = active
    task.spawn(function()
        while State.HidePlayers do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
                    end
                end
            end
            task.wait(0.5)
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0
                    elseif part:IsA("Decal") then part.Transparency = 0 end
                end
            end
        end
    end)
end)

CreateToggle(VisualTabPage, "Fullbright (Vision Ambient)", State.Fullbright, function(active)
    State.Fullbright = active
    if active then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end)

-- ==========================================
-- 6. SERVER FINDER TAB (SOLO SERVER SCANNER)
-- ==========================================
local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Size = UDim2.new(1, -6, 1, -50)
ServerListFrame.BackgroundTransparency = 1
ServerListFrame.ScrollBarThickness = 2
ServerListFrame.ScrollBarImageColor3 = C_ACCENT
ServerListFrame.ZIndex = 13
ServerListFrame.Parent = ServerTabPage

local ServerListLayout = Instance.new("UIListLayout")
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ServerListLayout.Padding = UDim.new(0, 6)
ServerListLayout.Parent = ServerListFrame

local function RefreshSoloServers()
    for _, child in pairs(ServerListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Scanning for 1-Player Servers..."
    statusLabel.TextColor3 = C_SUBTEXT
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = ServerListFrame

    task.spawn(function()
        local found = 0
        pcall(function()
            local raw = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local data = HttpService:JSONDecode(raw)

            statusLabel:Destroy()

            for _, server in pairs(data.data) do
                if server.playing == 1 and server.id ~= game.JobId then
                    found = found + 1
                    local card = Instance.new("Frame")
                    card.Size = UDim2.new(1, 0, 0, 42)
                    card.BackgroundColor3 = C_ITEM
                    card.ZIndex = 14
                    card.Parent = ServerListFrame
                    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

                    local info = Instance.new("TextLabel")
                    info.Size = UDim2.new(1, -110, 1, 0)
                    info.Position = UDim2.new(0, 12, 0, 0)
                    info.BackgroundTransparency = 1
                    info.Text = string.format("Server ID: %s... | Players: 1", string.sub(server.id, 1, 12))
                    info.TextColor3 = C_TEXT
                    info.TextSize = 11
                    info.Font = Enum.Font.GothamMedium
                    info.TextXAlignment = Enum.TextXAlignment.Left
                    info.ZIndex = 15
                    info.Parent = card

                    local tpBtn = Instance.new("TextButton")
                    tpBtn.Size = UDim2.new(0, 80, 0, 26)
                    tpBtn.Position = UDim2.new(1, -90, 0.5, -13)
                    tpBtn.BackgroundColor3 = C_ACCENT
                    tpBtn.Text = "TP SERVER"
                    tpBtn.TextColor3 = C_BG
                    tpBtn.TextSize = 10
                    tpBtn.Font = Enum.Font.GothamBold
                    tpBtn.ZIndex = 15
                    tpBtn.Parent = card
                    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

                    tpBtn.MouseButton1Click:Connect(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    end)
                end
            end
        end)

        if found == 0 then
            local noneLabel = Instance.new("TextLabel")
            noneLabel.Size = UDim2.new(1, 0, 0, 30)
            noneLabel.BackgroundTransparency = 1
            noneLabel.Text = "No 1-player servers found right now. Try again later."
            noneLabel.TextColor3 = C_SUBTEXT
            noneLabel.TextSize = 11
            noneLabel.Font = Enum.Font.Gotham
            noneLabel.Parent = ServerListFrame
        end
    end)
end

CreateButton(ServerTabPage, "🔍 Scan 1-Player Servers", function()
    RefreshSoloServers()
end)

-- ==========================================
-- 7. PLAYER LIST TAB (LIVE PLAYER TRACKER)
-- ==========================================
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, -6, 1, -10)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.ScrollBarThickness = 2
PlayerListFrame.ScrollBarImageColor3 = C_ACCENT
PlayerListFrame.ZIndex = 13
PlayerListFrame.Parent = PlayersTabPage

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.Parent = PlayerListFrame

local function RefreshPlayerList()
    for _, c in pairs(PlayerListFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 48)
            card.BackgroundColor3 = C_ITEM
            card.ZIndex = 14
            card.Parent = PlayerListFrame
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

            local pImg = Instance.new("ImageLabel")
            pImg.Size = UDim2.new(0, 36, 0, 36)
            pImg.Position = UDim2.new(0, 8, 0.5, -18)
            pImg.BackgroundTransparency = 1
            pImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            pImg.ZIndex = 15
            pImg.Parent = card
            Instance.new("UICorner", pImg).CornerRadius = UDim.new(1, 0)

            local pName = Instance.new("TextLabel")
            pName.Size = UDim2.new(1, -160, 1, 0)
            pName.Position = UDim2.new(0, 52, 0, 0)
            pName.BackgroundTransparency = 1
            pName.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pName.TextColor3 = C_TEXT
            pName.TextSize = 11
            pName.Font = Enum.Font.GothamMedium
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.ZIndex = 15
            pName.Parent = card

            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 90, 0, 26)
            tpBtn.Position = UDim2.new(1, -100, 0.5, -13)
            tpBtn.BackgroundColor3 = C_ACCENT
            tpBtn.Text = "TP TO PLAYER"
            tpBtn.TextColor3 = C_BG
            tpBtn.TextSize = 10
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.ZIndex = 15
            tpBtn.Parent = card
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

            tpBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

-- ==========================================
-- 8. SYSTEM / MISC TAB
-- ==========================================
CreateButton(MiscTabPage, "✨ Create / Jump to New Server (Solo Only)", function()
    pcall(function()
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(req.data) do
            if server.playing == 0 or server.playing == 1 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                return
            end
        end
    end)
end)

CreateToggle(MiscTabPage, "Click Teleport (Shift + Left Click)", State.ClickTP, function(active)
    State.ClickTP = active
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and State.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

CreateToggle(MiscTabPage, "Anti-AFK Disconnect Guard", State.AntiAFK, function(active)
    State.AntiAFK = active
    task.spawn(function()
        while State.AntiAFK do
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = cam.CFrame * CFrame.Angles(0, 0.001, 0)
                    task.wait(0.05)
                    cam.CFrame = cam.CFrame * CFrame.Angles(0, -0.001, 0)
                end
            end)
            task.wait(30)
        end
    end)
end)

CreateButton(MiscTabPage, "Rejoin Current Server Instantly", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

CreateButton(MiscTabPage, "Server Hop (Random Low Player)", function()
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
