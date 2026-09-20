-- [[ VOIDHUB SUPREME v12.0 - CYBERPUNK TACTICAL EDITION ]] --
-- Architecture: Top Bar Navigation, Viewport Auto-Scaling, Non-Neon Industrial Cyberpunk
-- Features: FPS/Ping HUD, Physical Anti-AFK, Hide Player Module, 1-Player Server Finder

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- 0. ANTI DOUBLE EXECUTE & CLEANUP
-- ==========================================
if CoreGui:FindFirstChild("VoidHubUI_Cyberpunk") then
    CoreGui.VoidHubUI_Cyberpunk:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_Cyberpunk"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- STATE MANAGEMENT
local State = {
    PlayerESP = false,
    WalkSpeed = false,
    JumpPower = false,
    InfJump = false,
    Noclip = false,
    Flying = false,
    FlySpeed = 50,
    SpeedValue = 24,
    JumpValue = 100,
    AntiAFK = true,
    SelectedTarget = nil,
    HiddenPlayers = {}
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
-- REAL ANTI-AFK SYSTEM (VIRTUAL USER INPUT)
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

task.spawn(function()
    while true do
        if State.AntiAFK then
            pcall(function()
                if Camera then
                    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0.0001, 0)
                    task.wait(0.1)
                    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, -0.0001, 0)
                end
            end)
        end
        task.wait(60)
    end
end)

-- ==========================================
-- FLY SYSTEM
-- ==========================================
local function StartFlying()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    FlyBodyVel = Instance.new("BodyVelocity")
    FlyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVel.Velocity = Vector3.zero
    FlyBodyVel.Parent = root

    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = root.CFrame
    FlyBodyGyro.Parent = root

    task.spawn(function()
        while State.Flying and char and root and root:FindFirstChild("BodyVelocity") do
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            FlyBodyVel.Velocity = moveDir * State.FlySpeed
            FlyBodyGyro.CFrame = Camera.CFrame
            task.wait()
        end
    end)
end

local function StopFlying()
    if FlyBodyVel then FlyBodyVel:Destroy() FlyBodyVel = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
end

-- ==========================================
-- NOTIFICATION TOAST
-- ==========================================
local function ShowCyberNotification(msg)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 280, 0, 36)
    toast.Position = UDim2.new(0.5, -140, 0.05, 0)
    toast.BackgroundColor3 = Color3.fromRGB(24, 28, 34)
    toast.BorderSizePixel = 0
    toast.ZIndex = 200
    toast.Parent = VoidHubUI

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(212, 140, 20)
    stroke.Thickness = 1
    stroke.Parent = toast

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "[SYS.MSG] " .. string.upper(msg)
    lbl.TextColor3 = Color3.fromRGB(230, 235, 240)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 201
    lbl.Parent = toast

    TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0.08, 0)}):Play()

    task.delay(2.5, function()
        local tw = TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 0.02, 0), BackgroundTransparency = 1})
        tw:Play()
        TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        tw.Completed:Connect(function() toast:Destroy() end)
    end)
end

-- ==========================================
-- 1. FLOATING TOGGLE BUTTON
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 130, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
OpenBtn.Text = "VOIDHUB // OPEN"
OpenBtn.TextColor3 = Color3.fromRGB(212, 140, 20)
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.Code
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(212, 140, 20)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN WINDOW FRAME (RESPONSIVE CYBERPUNK)
-- ==========================================
local ViewportSize = Camera.ViewportSize
local IsMobile = ViewportSize.X < 700

local FrameWidth = IsMobile and math.clamp(ViewportSize.X - 30, 320, 520) or 640
local FrameHeight = IsMobile and math.clamp(ViewportSize.Y - 60, 340, 420) or 410

local TargetSize = UDim2.new(0, FrameWidth, 0, FrameHeight)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -FrameWidth/2, 0.5, -FrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 68, 78)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- TOP BAR HEADER
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = Color3.fromRGB(22, 26, 32)
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#D48C14\">// CYBERPUNK v12.0</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(220, 225, 230)
Title.TextSize = 13
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 48)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(212, 140, 20)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.Code
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- STATS HUD (FPS, PING, PLAYER)
local StatsHUD = Instance.new("Frame")
StatsHUD.Size = UDim2.new(1, -20, 0, 24)
StatsHUD.Position = UDim2.new(0, 10, 0, 46)
StatsHUD.BackgroundColor3 = Color3.fromRGB(20, 24, 30)
StatsHUD.BorderSizePixel = 0
StatsHUD.ZIndex = 11
StatsHUD.Parent = MainFrame

local StatsHUDStroke = Instance.new("UIStroke")
StatsHUDStroke.Color = Color3.fromRGB(40, 46, 54)
StatsHUDStroke.Thickness = 1
StatsHUDStroke.Parent = StatsHUD

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -16, 1, 0)
StatsLabel.Position = UDim2.new(0, 8, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "USER: " .. LocalPlayer.Name .. " | FPS: -- | PING: --ms"
StatsLabel.TextColor3 = Color3.fromRGB(160, 170, 185)
StatsLabel.TextSize = 10
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.ZIndex = 12
StatsLabel.Parent = StatsHUD

-- FPS & PING MONITOR LOOP
local FrameCounter = 0
local LastStatUpdate = tick()

RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    local now = tick()
    if now - LastStatUpdate >= 1 then
        local fps = math.floor(FrameCounter / (now - LastStatUpdate))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        StatsLabel.Text = "USER: " .. LocalPlayer.Name .. " | FPS: " .. tostring(fps) .. " | PING: " .. tostring(ping) .. "ms"
        FrameCounter = 0
        LastStatUpdate = now
    end
end)

-- TOP CATEGORY NAVIGATION BAR
local CategoryBar = Instance.new("ScrollingFrame")
CategoryBar.Size = UDim2.new(1, -20, 0, 32)
CategoryBar.Position = UDim2.new(0, 10, 0, 74)
CategoryBar.BackgroundTransparency = 1
CategoryBar.BorderSizePixel = 0
CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoryBar.AutomaticCanvasSize = Enum.AutomaticSize.X
CategoryBar.ScrollBarThickness = 0
CategoryBar.ZIndex = 11
CategoryBar.Parent = MainFrame

local CBLayout = Instance.new("UIListLayout")
CBLayout.FillDirection = Enum.FillDirection.Horizontal
CBLayout.SortOrder = Enum.SortOrder.LayoutOrder
CBLayout.Padding = UDim.new(0, 6)
CBLayout.Parent = CategoryBar

-- CONTENT CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -118)
ContentArea.Position = UDim2.new(0, 10, 0, 110)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(35, 42, 50)
ContentStroke.Thickness = 1
ContentStroke.Parent = ContentArea

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -12, 1, -12)
    page.Position = UDim2.new(0, 6, 0, 6)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(212, 140, 20)
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    return page
end

local MainTabPage = CreatePage("Main")
local ServerListPage = CreatePage("ServerList")
local PlayerListPage = CreatePage("PlayerList")
local MovementTabPage = CreatePage("Movement")
local VisualTabPage = CreatePage("Visual")
local MiscTabPage = CreatePage("Misc")

MainTabPage.Visible = true

local function CreateTopTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(212, 140, 20) or Color3.fromRGB(25, 30, 38)
    btn.BorderSizePixel = 0
    btn.Text = string.upper(text)
    btn.TextColor3 = defaultActive and Color3.fromRGB(15, 18, 22) or Color3.fromRGB(180, 190, 200)
    btn.TextSize = 10
    btn.Font = Enum.Font.Code
    btn.ZIndex = 12
    btn.Parent = CategoryBar
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 52, 62)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(CategoryBar:GetChildren()) do 
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(25, 30, 38)
                b.TextColor3 = Color3.fromRGB(180, 190, 200)
            end
        end
        pageTarget.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(212, 140, 20)
        btn.TextColor3 = Color3.fromRGB(15, 18, 22)
    end)
end

CreateTopTabButton("MAIN", MainTabPage, true)
CreateTopTabButton("SERVERS", ServerListPage, false)
CreateTopTabButton("PLAYERS", PlayerListPage, false)
CreateTopTabButton("MOVEMENT", MovementTabPage, false)
CreateTopTabButton("VISUALS", VisualTabPage, false)
CreateTopTabButton("SYSTEM", MiscTabPage, false)

-- ==========================================
-- CYBERPUNK UI COMPONENTS
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
    frame.BorderSizePixel = 0
    frame.ZIndex = 13
    frame.Parent = parent

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(40, 48, 58)
    fStroke.Thickness = 1
    fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(titleText)
    label.TextColor3 = Color3.fromRGB(220, 225, 230)
    label.TextSize = 10
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(212, 140, 20) or Color3.fromRGB(40, 46, 56)
    switch.BorderSizePixel = 0
    switch.Text = defaultState and "ON" or "OFF"
    switch.TextColor3 = defaultState and Color3.fromRGB(15, 18, 22) or Color3.fromRGB(160, 170, 180)
    switch.TextSize = 9
    switch.Font = Enum.Font.Code
    switch.ZIndex = 14
    switch.Parent = frame
    
    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            switch.BackgroundColor3 = Color3.fromRGB(212, 140, 20)
            switch.TextColor3 = Color3.fromRGB(15, 18, 22)
            switch.Text = "ON"
        else
            switch.BackgroundColor3 = Color3.fromRGB(40, 46, 56)
            switch.TextColor3 = Color3.fromRGB(160, 170, 180)
            switch.Text = "OFF"
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = customColor or Color3.fromRGB(28, 34, 44)
    btn.BorderSizePixel = 0
    btn.Text = "[ACTION] " .. string.upper(titleText)
    btn.TextColor3 = Color3.fromRGB(230, 235, 240)
    btn.TextSize = 10
    btn.Font = Enum.Font.Code
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent

    local bPad = Instance.new("UIPadding")
    bPad.PaddingLeft = UDim.new(0, 12)
    bPad.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(45, 54, 66)
    bStroke.Thickness = 1
    bStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local origColor = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(212, 140, 20)
        btn.TextColor3 = Color3.fromRGB(15, 18, 22)
        task.wait(0.1)
        btn.BackgroundColor3 = origColor
        btn.TextColor3 = Color3.fromRGB(230, 235, 240)
        callback()
    end)
end

-- ==========================================
-- 3. TAB MAIN
-- ==========================================
local AnnounceCard = Instance.new("Frame")
AnnounceCard.Size = UDim2.new(1, 0, 0, 110)
AnnounceCard.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
AnnounceCard.BorderSizePixel = 0
AnnounceCard.ZIndex = 13
AnnounceCard.Parent = MainTabPage

local ACCornerStroke = Instance.new("UIStroke")
ACCornerStroke.Color = Color3.fromRGB(40, 48, 58)
ACCornerStroke.Thickness = 1
ACCornerStroke.Parent = AnnounceCard

local AnnounceTitle = Instance.new("TextLabel")
AnnounceTitle.Size = UDim2.new(1, -24, 0, 20)
AnnounceTitle.Position = UDim2.new(0, 12, 0, 8)
AnnounceTitle.BackgroundTransparency = 1
AnnounceTitle.Text = "SYSTEM BULLETIN // v12.0"
AnnounceTitle.TextColor3 = Color3.fromRGB(212, 140, 20)
AnnounceTitle.TextSize = 11
AnnounceTitle.Font = Enum.Font.Code
AnnounceTitle.TextXAlignment = Enum.TextXAlignment.Left
AnnounceTitle.ZIndex = 14
AnnounceTitle.Parent = AnnounceCard

local AnnounceBody = Instance.new("TextLabel")
AnnounceBody.Size = UDim2.new(1, -24, 0, 70)
AnnounceBody.Position = UDim2.new(0, 12, 0, 30)
AnnounceBody.BackgroundTransparency = 1
AnnounceBody.Text = "- CYBERPUNK TACTICAL INTERFACE LOADED\n- REAL ANTI-AFK SIMULATION ACTIVE\n- HIDE PLAYER MODULE ENGAGED\n- TOP CATEGORY AUTO-SCALING ENABLED"
AnnounceBody.TextColor3 = Color3.fromRGB(170, 180, 195)
AnnounceBody.TextSize = 10
AnnounceBody.Font = Enum.Font.Code
AnnounceBody.TextXAlignment = Enum.TextXAlignment.Left
AnnounceBody.TextYAlignment = Enum.TextYAlignment.Top
AnnounceBody.TextWrapped = true
AnnounceBody.ZIndex = 14
AnnounceBody.Parent = AnnounceCard

CreateButton(MainTabPage, "Copy Official Discord Link", function()
    if setclipboard then
        setclipboard("https://discord.gg/voidhub")
        ShowCyberNotification("Discord link copied to clipboard")
    end
end)

-- ==========================================
-- 4. TAB 1-PLAYER SERVERS
-- ==========================================
local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, 0, 0, 200)
ServerContainer.BackgroundTransparency = 1
ServerContainer.BorderSizePixel = 0
ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ServerContainer.ScrollBarThickness = 2
ServerContainer.ZIndex = 13
ServerContainer.Parent = ServerListPage

local SCLayout = Instance.new("UIListLayout")
SCLayout.SortOrder = Enum.SortOrder.LayoutOrder
SCLayout.Padding = UDim.new(0, 6)
SCLayout.Parent = ServerContainer

local function Fetch1PlayerServers()
    for _, child in pairs(ServerContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    ShowCyberNotification("Scanning 1-player server instances...")

    task.spawn(function()
        pcall(function()
            local rawData = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local parsed = HttpService:JSONDecode(rawData)
            local foundCount = 0

            if parsed and parsed.data then
                for _, server in pairs(parsed.data) do
                    if server.playing == 1 and server.id ~= game.JobId then
                        foundCount = foundCount + 1
                        
                        local card = Instance.new("Frame")
                        card.Size = UDim2.new(1, 0, 0, 36)
                        card.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
                        card.BorderSizePixel = 0
                        card.ZIndex = 14
                        card.Parent = ServerContainer

                        local cStroke = Instance.new("UIStroke")
                        cStroke.Color = Color3.fromRGB(40, 48, 58)
                        cStroke.Thickness = 1
                        cStroke.Parent = card

                        local infoLbl = Instance.new("TextLabel")
                        infoLbl.Size = UDim2.new(1, -80, 1, 0)
                        infoLbl.Position = UDim2.new(0, 10, 0, 0)
                        infoLbl.BackgroundTransparency = 1
                        infoLbl.Text = "SERVER ID: " .. string.sub(server.id, 1, 12) .. "... | PLAYERS: 1/" .. tostring(server.maxPlayers)
                        infoLbl.TextColor3 = Color3.fromRGB(200, 210, 220)
                        infoLbl.TextSize = 10
                        infoLbl.Font = Enum.Font.Code
                        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                        infoLbl.ZIndex = 15
                        infoLbl.Parent = card

                        local tpBtn = Instance.new("TextButton")
                        tpBtn.Size = UDim2.new(0, 60, 0, 24)
                        tpBtn.Position = UDim2.new(1, -68, 0.5, -12)
                        tpBtn.BackgroundColor3 = Color3.fromRGB(212, 140, 20)
                        tpBtn.BorderSizePixel = 0
                        tpBtn.Text = "TP"
                        tpBtn.TextColor3 = Color3.fromRGB(15, 18, 22)
                        tpBtn.TextSize = 10
                        tpBtn.Font = Enum.Font.Code
                        tpBtn.ZIndex = 15
                        tpBtn.Parent = card

                        tpBtn.MouseButton1Click:Connect(function()
                            ShowCyberNotification("Teleporting to instance...")
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        end)
                    end
                end
            end

            if foundCount == 0 then
                ShowCyberNotification("No 1-player server instances found")
            end
        end)
    end)
end

CreateButton(ServerListPage, "Fetch 1-Player Server List", function()
    Fetch1PlayerServers()
end)

-- ==========================================
-- 5. TAB PLAYER LIST & HIDE PLAYER
-- ==========================================
local PlayerContainer = Instance.new("ScrollingFrame")
PlayerContainer.Size = UDim2.new(1, 0, 0, 160)
PlayerContainer.BackgroundTransparency = 1
PlayerContainer.BorderSizePixel = 0
PlayerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerContainer.ScrollBarThickness = 2
PlayerContainer.ZIndex = 13
PlayerContainer.Parent = PlayerListPage

local PCLayout = Instance.new("UIListLayout")
PCLayout.SortOrder = Enum.SortOrder.LayoutOrder
PCLayout.Padding = UDim.new(0, 6)
PCLayout.Parent = PlayerContainer

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "TARGET SELECTED: NONE"
TargetLabel.TextColor3 = Color3.fromRGB(212, 140, 20)
TargetLabel.TextSize = 10
TargetLabel.Font = Enum.Font.Code
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.ZIndex = 13
TargetLabel.Parent = PlayerListPage

local function PopulatePlayerList()
    for _, child in pairs(PlayerContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 36)
            card.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
            card.BorderSizePixel = 0
            card.ZIndex = 14
            card.Parent = PlayerContainer

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = Color3.fromRGB(40, 48, 58)
            cStroke.Thickness = 1
            cStroke.Parent = card

            local isHidden = State.HiddenPlayers[plr.UserId] == true

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -80, 1, 0)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = string.upper(plr.Name) .. " [" .. (isHidden and "HIDDEN" or "VISIBLE") .. "]"
            nameLbl.TextColor3 = isHidden and Color3.fromRGB(140, 150, 160) or Color3.fromRGB(220, 225, 230)
            nameLbl.TextSize = 10
            nameLbl.Font = Enum.Font.Code
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 15
            nameLbl.Parent = card

            local selBtn = Instance.new("TextButton")
            selBtn.Size = UDim2.new(0, 60, 0, 24)
            selBtn.Position = UDim2.new(1, -68, 0.5, -12)
            selBtn.BackgroundColor3 = Color3.fromRGB(38, 46, 56)
            selBtn.BorderSizePixel = 0
            selBtn.Text = "SELECT"
            selBtn.TextColor3 = Color3.fromRGB(212, 140, 20)
            selBtn.TextSize = 9
            selBtn.Font = Enum.Font.Code
            selBtn.ZIndex = 15
            selBtn.Parent = card

            selBtn.MouseButton1Click:Connect(function()
                State.SelectedTarget = plr
                TargetLabel.Text = "TARGET SELECTED: " .. string.upper(plr.Name)
                ShowCyberNotification("Target locked: " .. plr.Name)
            end)
        end
    end
end

CreateButton(PlayerListPage, "Refresh Player List", function()
    PopulatePlayerList()
end)

-- HIDE TARGET PLAYER ACTION
CreateButton(PlayerListPage, "Hide Selected Target Player", function()
    if not State.SelectedTarget then
        ShowCyberNotification("No target selected")
        return
    end

    local target = State.SelectedTarget
    if target.Character then
        for _, part in pairs(target.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                part.Enabled = false
            end
        end
        State.HiddenPlayers[target.UserId] = true
        ShowCyberNotification("Target hidden: " .. target.Name)
        PopulatePlayerList()
    end
end, Color3.fromRGB(40, 30, 25))

-- UNHIDE ALL PLAYERS ACTION
CreateButton(PlayerListPage, "Unhide All Players", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                    part.Enabled = true
                end
            end
        end
    end
    State.HiddenPlayers = {}
    ShowCyberNotification("All players unhidden")
    PopulatePlayerList()
end)

-- ==========================================
-- 6. TAB MOVEMENT
-- ==========================================
CreateToggle(MovementTabPage, "Fly Mode (WASD + Shift/Space)", State.Flying, function(active)
    State.Flying = active
    if active then StartFlying() else StopFlying() end
end)

CreateToggle(MovementTabPage, "WalkSpeed Booster (24)", State.WalkSpeed, function(active)
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

CreateToggle(MovementTabPage, "JumpPower Booster (100)", State.JumpPower, function(active)
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

CreateToggle(MovementTabPage, "Infinite Jump Mode", State.InfJump, function(active)
    State.InfJump = active
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(MovementTabPage, "Noclip Mode", State.Noclip, function(active)
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
-- 7. TAB VISUALS & ESP
-- ==========================================
local function ClearPlayerESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("VoidPlayerHL")
            if hl then hl:Destroy() end
        end
    end
end

local function ApplyPlayerESP(player)
    if player == LocalPlayer or not player.Character then return end
    if not player.Character:FindFirstChild("VoidPlayerHL") then
        local hl = Instance.new("Highlight")
        hl.Name = "VoidPlayerHL"
        hl.FillColor = Color3.fromRGB(212, 140, 20)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.1
        hl.Parent = player.Character
    end
end

CreateToggle(VisualTabPage, "Player Highlight ESP", State.PlayerESP, function(active)
    State.PlayerESP = active
    if active then
        for _, p in pairs(Players:GetPlayers()) do ApplyPlayerESP(p) end
        ESPConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if State.PlayerESP then task.wait(0.5); ApplyPlayerESP(p) end
            end)
        end)
        ESPConnections["Loop"] = RunService.Heartbeat:Connect(function()
            if State.PlayerESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("VoidPlayerHL") then
                        ApplyPlayerESP(p)
                    end
                end
            end
        end)
    else
        for _, conn in pairs(ESPConnections) do conn:Disconnect() end
        ESPConnections = {}
        ClearPlayerESP()
    end
end)

-- ==========================================
-- 8. TAB SYSTEM & MISC
-- ==========================================
CreateButton(MiscTabPage, "New Server (Auto Join Solo Instance)", function()
    ShowCyberNotification("Searching for solo server instance...")
    task.spawn(function()
        pcall(function()
            local rawData = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local parsed = HttpService:JSONDecode(rawData)
            local targetServerId = nil

            if parsed and parsed.data then
                for _, server in pairs(parsed.data) do
                    if server.playing <= 1 and server.id ~= game.JobId then
                        targetServerId = server.id
                        break
                    end
                end
            end

            if targetServerId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, LocalPlayer)
            else
                ShowCyberNotification("No solo server instances available")
            end
        end)
    end)
end)

CreateToggle(MiscTabPage, "Physical Anti-AFK Simulation", State.AntiAFK, function(active)
    State.AntiAFK = active
    ShowCyberNotification("Anti-AFK state set to: " .. (active and "ACTIVE" or "DISABLED"))
end)

CreateButton(MiscTabPage, "Rejoin Current Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

-- OPEN BUTTON CALLBACK
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- INITIAL LAUNCH ANIMATION
TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()

-- INITIAL DATA POPULATION
PopulatePlayerList()
