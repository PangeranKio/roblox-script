-- [[ VOIDHUB PRESTIGE - RESPONSIVE PREMIUM EDITION ]] --
-- UI/UX: Top Navigation, Adaptive Scaling, Clean Dark Mode
-- Core: VirtualUser Anti-AFK, Live HUD, Player Isolation

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StatsService = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 0. ANTI DOUBLE RE-EXECUTE SYSTEM
-- ==========================================
if CoreGui:FindFirstChild("VoidHub_Prestige") then
    CoreGui.VoidHub_Prestige:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHub_Prestige"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local State = {
    PlayerESP = false,
    HidePlayers = false,
    WalkSpeed = false,
    JumpPower = false,
    InfJump = false,
    Noclip = false,
    Flying = false,
    FlySpeed = 50,
    SpeedValue = 24,
    JumpValue = 100,
    AntiAFK = true
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
-- REAL ANTI-AFK SYSTEM
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- LIVE PERFORMANCE HUD
-- ==========================================
local HUD = Instance.new("TextLabel")
HUD.Size = UDim2.new(0, 300, 0, 24)
HUD.Position = UDim2.new(0.5, -150, 0, 10)
HUD.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
HUD.BackgroundTransparency = 0.3
HUD.Text = "Loading Data..."
HUD.TextColor3 = Color3.fromRGB(240, 240, 240)
HUD.TextSize = 11
HUD.Font = Enum.Font.GothamMedium
HUD.ZIndex = 100
HUD.Parent = VoidHubUI

local HUDCorner = Instance.new("UICorner")
HUDCorner.CornerRadius = UDim.new(0, 12)
HUDCorner.Parent = HUD

local HUDStroke = Instance.new("UIStroke")
HUDStroke.Color = Color3.fromRGB(255, 255, 255)
HUDStroke.Transparency = 0.8
HUDStroke.Parent = HUD

RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    HUD.Text = string.format("VoidHub Prestige | %s | %d FPS | %d ms", LocalPlayer.Name, fps, ping)
end)

-- ==========================================
-- 1. RESPONSIVE MAIN WINDOW (TOP NAV)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.65, 0, 0.6, 0) -- Responsive Scale
MainFrame.Position = UDim2.new(0.175, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MinSize = Vector2.new(450, 300)
SizeConstraint.MaxSize = Vector2.new(700, 450)
SizeConstraint.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 200, 210)
MainStroke.Transparency = 0.85
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- TOP BAR (DRAGGABLE)
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame
MakeDraggable(Topbar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB PRESTIGE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
CloseBtn.TextSize = 10
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

-- FLOATING OPEN BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 100, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "VoidHub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 12
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255,255,255)
Instance.new("UIStroke", OpenBtn).Transparency = 0.8
MakeDraggable(OpenBtn, OpenBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- TOP NAVIGATION MENU
local NavContainer = Instance.new("Frame")
NavContainer.Size = UDim2.new(1, -40, 0, 36)
NavContainer.Position = UDim2.new(0, 20, 0, 40)
NavContainer.BackgroundTransparency = 1
NavContainer.ZIndex = 11
NavContainer.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 8)
NavLayout.Parent = NavContainer

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -40, 1, -100)
ContentArea.Position = UDim2.new(0, 20, 0, 84)
ContentArea.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
ContentArea.BackgroundTransparency = 0.3
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 12)
CACorner.Parent = ContentArea

local PagesFolder = Instance.new("Folder")
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 160)
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
local SystemTabPage = CreatePage("System")

MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(30, 30, 34)
    btn.BackgroundTransparency = defaultActive and 0.1 or 0.5
    btn.Text = text
    btn.TextColor3 = defaultActive and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(180, 180, 190)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 12
    btn.Parent = NavContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(NavContainer:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 34), BackgroundTransparency = 0.5}):Play()
                b.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 240, 240), BackgroundTransparency = 0.1}):Play()
        btn.TextColor3 = Color3.fromRGB(15, 15, 18)
    end)
end

CreateTabButton("Main", MainTabPage, true)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Visuals", VisualTabPage, false)
CreateTabButton("System", SystemTabPage, false)

-- ==========================================
-- PREMIUM COMPONENTS
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    frame.BackgroundTransparency = 0.5
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 22)
    switch.Position = UDim2.new(1, -52, 0.5, -11)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(60, 60, 65)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = defaultState and Color3.fromRGB(15, 15, 18) or Color3.fromRGB(200, 200, 200)
    circle.ZIndex = 15
    circle.Parent = switch
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 220, 225)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    btn.BackgroundTransparency = 0.3
    btn.Text = "  " .. titleText
    btn.TextColor3 = Color3.fromRGB(230, 230, 235)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        local origColor = btn.BackgroundColor3
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 200, 205), TextColor3 = Color3.fromRGB(15, 15, 18)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = origColor, TextColor3 = Color3.fromRGB(230, 230, 235)}):Play()
        callback()
    end)
end

-- ==========================================
-- POPULATING TABS
-- ==========================================

-- MAIN TAB
local AnnounceCard = Instance.new("TextLabel")
AnnounceCard.Size = UDim2.new(1, 0, 0, 110)
AnnounceCard.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
AnnounceCard.BackgroundTransparency = 0.5
AnnounceCard.Text = "Welcome to VoidHub Prestige.\n\nCode refactored for responsive design, live network monitoring, and virtual-level Anti-AFK. Join the Discord for priority updates."
AnnounceCard.TextColor3 = Color3.fromRGB(200, 200, 210)
AnnounceCard.TextSize = 12
AnnounceCard.Font = Enum.Font.Gotham
AnnounceCard.TextXAlignment = Enum.TextXAlignment.Left
AnnounceCard.TextYAlignment = Enum.TextYAlignment.Top
AnnounceCard.TextWrapped = true
AnnounceCard.ZIndex = 13
AnnounceCard.Parent = MainTabPage
local ACardPadding = Instance.new("UIPadding", AnnounceCard)
ACardPadding.PaddingTop = UDim.new(0, 16)
ACardPadding.PaddingLeft = UDim.new(0, 16)
ACardPadding.PaddingRight = UDim.new(0, 16)
Instance.new("UICorner", AnnounceCard).CornerRadius = UDim.new(0, 12)

CreateButton(MainTabPage, "Copy Discord Invitation", function()
    if setclipboard then setclipboard("https://discord.gg/voidhub") end
end)

-- MOVEMENT TAB
CreateToggle(MovementTabPage, "Kinetic Flight Mode", State.Flying, function(active)
    State.Flying = active
    if active then 
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            FlyBodyVel = Instance.new("BodyVelocity")  
            FlyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)  
            FlyBodyVel.Velocity = Vector3.zero  
            FlyBodyVel.Parent = root  
            FlyBodyGyro = Instance.new("BodyGyro")  
            FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)  
            FlyBodyGyro.CFrame = root.CFrame  
            FlyBodyGyro.Parent = root  
            task.spawn(function()  
                while State.Flying and root and root:FindFirstChild("BodyVelocity") do  
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
    else
        if FlyBodyVel then FlyBodyVel:Destroy() FlyBodyVel = nil end
        if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
    end
end)

CreateToggle(MovementTabPage, "WalkSpeed Override (24)", State.WalkSpeed, function(active)
    State.WalkSpeed = active
    task.spawn(function()
        while State.WalkSpeed do
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = State.SpeedValue end)
            task.wait(0.2)
        end
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end)
end)

CreateToggle(MovementTabPage, "JumpPower Override (100)", State.JumpPower, function(active)
    State.JumpPower = active
    task.spawn(function()
        while State.JumpPower do
            pcall(function() 
                LocalPlayer.Character.Humanoid.UseJumpPower = true 
                LocalPlayer.Character.Humanoid.JumpPower = State.JumpValue 
            end)
            task.wait(0.2)
        end
        pcall(function() LocalPlayer.Character.Humanoid.JumpPower = 50 end)
    end)
end)

CreateToggle(MovementTabPage, "Infinite Jump Request", State.InfJump, function(active)
    State.InfJump = active
end)
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- VISUALS TAB
CreateToggle(VisualTabPage, "Player Highlight ESP", State.PlayerESP, function(active)
    State.PlayerESP = active
    local function applyEsp(p)
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("VoidHubESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "VoidHubESP"
            hl.FillColor = Color3.fromRGB(240, 240, 240)
            hl.OutlineColor = Color3.fromRGB(15, 15, 15)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0.2
            hl.Parent = p.Character
        end
    end
    if active then
        for _, p in pairs(Players:GetPlayers()) do applyEsp(p) end
        ESPConnections["Loop"] = RunService.Heartbeat:Connect(function()
            if State.PlayerESP then
                for _, p in pairs(Players:GetPlayers()) do applyEsp(p) end
            end
        end)
    else
        if ESPConnections["Loop"] then ESPConnections["Loop"]:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VoidHubESP") then
                p.Character.VoidHubESP:Destroy()
            end
        end
    end
end)

-- HIDE PLAYERS INSTEAD OF DISCONNECT
CreateToggle(VisualTabPage, "Hide All Players (Visual Isolation)", State.HidePlayers, function(active)
    State.HidePlayers = active
    task.spawn(function()
        while State.HidePlayers do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Decal") then
                            part.Transparency = 1
                        end
                    end
                end
            end
            task.wait(0.5)
        end
        -- Restore visibility
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    elseif part:IsA("Decal") then
                        part.Transparency = 0
                    end
                end
            end
        end
    end)
end)

-- SYSTEM TAB
CreateToggle(SystemTabPage, "Virtual Controller Anti-AFK", State.AntiAFK, function(active)
    State.AntiAFK = active
end)

CreateButton(SystemTabPage, "Rejoin Current Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
