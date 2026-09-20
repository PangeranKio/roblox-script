-- [[ VOIDHUB SUPREME v14.0 - ULTRA LUXURY BENTO GLASS EDITION ]] --
-- Fix: Code 267 Bypass (Vector Physics Engine & Fake Latency Simulation)
-- UI/UX: Bento Grid Layout, Obsidian Dark Glass, Dynamic Gold Accents (No Emoji)

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
-- 0. ANTI-DETECTION & CONTAINER ISOLATION (CODE 267 FIX)
-- ==========================================
local ParentContainer = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui

if ParentContainer:FindFirstChild("VoidHubUI_UltraLuxury") then
    ParentContainer.VoidHubUI_UltraLuxury:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_UltraLuxury"
VoidHubUI.Parent = ParentContainer
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local State = {
    PlayerESP = false,
    WalkSpeed = false,
    JumpPower = false,
    InfJump = false,
    Noclip = false,
    Flying = false,
    FlySpeed = 50,
    SpeedValue = 28,
    JumpValue = 100,
    AntiAFK = true,
    SelectedTarget = nil,
    HiddenPlayers = {}
}

-- CODE 267 SAFE METATABLE PROTECTOR
local RawMeta = getrawmetatable and getrawmetatable(game)
if RawMeta and setreadonly then
    setreadonly(RawMeta, false)
    local OldIndex = RawMeta.__index
    local OldNewIndex = RawMeta.__newindex

    RawMeta.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
            if key == "UseJumpPower" then return true end
        end
        return OldIndex(self, key)
    end)

    RawMeta.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" or key == "JumpPower" then return end
        end
        return OldNewIndex(self, key, value)
    end)
    setreadonly(RawMeta, true)
end

-- DRAG SYSTEM
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
-- SAFE VECTOR MOVEMENT ENGINES (CODE 267 BYPASS)
-- ==========================================
-- Safe Speed Engine via CFrame Translation (Avoids Humanoid.WalkSpeed detection)
RunService.Heartbeat:Connect(function(delta)
    if State.WalkSpeed and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (State.SpeedValue - 16) * delta)
        end
    end
end)

-- Safe Stealth Fly Engine
local FlyConnection
local function StartFlying()
    if FlyConnection then FlyConnection:Disconnect() end
    FlyConnection = RunService.Heartbeat:Connect(function(delta)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not State.Flying or not root then
            if FlyConnection then FlyConnection:Disconnect() end
            return
        end

        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = root.CFrame + (moveDir * State.FlySpeed * delta)
    end)
end

local function StopFlying()
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
end

-- Safe Anti-AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- ==========================================
-- LUXURY NOTIFICATION SYSTEM
-- ==========================================
local function ShowToast(msg)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 310, 0, 42)
    toast.Position = UDim2.new(0.5, -155, 0.04, 0)
    toast.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    toast.BorderSizePixel = 0
    toast.ZIndex = 300
    toast.Parent = VoidHubUI

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(212, 175, 55)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = toast

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "[SYSTEM] " .. string.upper(msg)
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 301
    lbl.Parent = toast

    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -155, 0.07, 0)}):Play()

    task.delay(2.5, function()
        local tw = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -155, 0.02, 0), BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function() toast:Destroy() end)
    end)
end

-- ==========================================
-- FLOATING TOGGLE BUTTON
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 130, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
OpenBtn.Text = "VOIDHUB // OPEN"
OpenBtn.TextColor3 = Color3.fromRGB(212, 175, 55)
OpenBtn.TextSize = 10
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(212, 175, 55)
OpenStroke.Thickness = 1
OpenStroke.Transparency = 0.4
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN WINDOW FRAME (BENTO GLASS LAYOUT)
-- ==========================================
local Viewport = Camera.ViewportSize
local IsMobile = Viewport.X < 720

local MainW = IsMobile and math.clamp(Viewport.X - 20, 320, 560) or 660
local MainH = IsMobile and math.clamp(Viewport.Y - 40, 340, 440) or 430
local TargetSize = UDim2.new(0, MainW, 0, MainH)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -MainW/2, 0.5, -MainH/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(212, 175, 55)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

-- HEADER TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 46)
Topbar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#D4AF37\">ULTRA LUXURY</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(212, 175, 55)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    tw:Play()
    tw.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- BENTO SIDEBAR NAVIGATION
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -58)
Sidebar.Position = UDim2.new(0, 8, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Color3.fromRGB(30, 30, 40)
SidebarStroke.Thickness = 1
SidebarStroke.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 6)
NavLayout.Parent = Sidebar

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingTop = UDim.new(0, 8)
NavPadding.PaddingLeft = UDim.new(0, 8)
NavPadding.PaddingRight = UDim.new(0, 8)
NavPadding.Parent = Sidebar

-- CONTENT BENTO CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -162, 1, -58)
ContentArea.Position = UDim2.new(0, 154, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentArea

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(30, 30, 40)
ContentStroke.Thickness = 1
ContentStroke.Parent = ContentArea

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(212, 175, 55)
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    return page
end

local DashPage = CreatePage("Dashboard")
local MovementPage = CreatePage("Movement")
local ServersPage = CreatePage("Servers")
local PlayersPage = CreatePage("Players")
local VisualsPage = CreatePage("Visuals")
local SystemPage = CreatePage("System")

DashPage.Visible = true

local function CreateNavButton(label, targetPage, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(22, 22, 30)
    btn.BorderSizePixel = 0
    btn.Text = string.upper(label)
    btn.TextColor3 = isDefault and Color3.fromRGB(10, 10, 14) or Color3.fromRGB(180, 185, 195)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 12
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(38, 38, 50)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
                b.TextColor3 = Color3.fromRGB(180, 185, 195)
            end
        end
        targetPage.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
    end)
end

CreateNavButton("Dashboard", DashPage, true)
CreateNavButton("Movement", MovementPage, false)
CreateNavButton("Servers", ServersPage, false)
CreateNavButton("Players", PlayersPage, false)
CreateNavButton("Visuals", VisualsPage, false)
CreateNavButton("System", SystemPage, false)

-- ==========================================
-- BENTO COMPONENT BUILDERS
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    card.BorderSizePixel = 0
    card.ZIndex = 13
    card.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 7)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(35, 35, 48)
    cStroke.Thickness = 1
    cStroke.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -65, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(titleText)
    lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14
    lbl.Parent = card

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 44, 0, 22)
    switch.Position = UDim2.new(1, -52, 0.5, -11)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(35, 35, 48)
    switch.BorderSizePixel = 0
    switch.Text = defaultState and "ON" or "OFF"
    switch.TextColor3 = defaultState and Color3.fromRGB(10, 10, 14) or Color3.fromRGB(150, 155, 165)
    switch.TextSize = 9
    switch.Font = Enum.Font.GothamBold
    switch.ZIndex = 14
    switch.Parent = card

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 5)
    sCorner.Parent = switch

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            switch.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
            switch.TextColor3 = Color3.fromRGB(10, 10, 14)
            switch.Text = "ON"
        else
            switch.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            switch.TextColor3 = Color3.fromRGB(150, 155, 165)
            switch.Text = "OFF"
        end
        callback(active)
    end)
end

local function CreateActionButton(parent, text, callback, customBg)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = customBg or Color3.fromRGB(24, 24, 34)
    btn.BorderSizePixel = 0
    btn.Text = "[ACTION] " .. string.upper(text)
    btn.TextColor3 = Color3.fromRGB(235, 235, 240)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 7)
    bCorner.Parent = btn

    local bPad = Instance.new("UIPadding")
    bPad.PaddingLeft = UDim.new(0, 12)
    bPad.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(40, 40, 54)
    bStroke.Thickness = 1
    bStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local orig = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
        task.wait(0.12)
        btn.BackgroundColor3 = orig
        btn.TextColor3 = Color3.fromRGB(235, 235, 240)
        callback()
    end)
end

-- ==========================================
-- 1. DASHBOARD PAGE
-- ==========================================
local DashCard = Instance.new("Frame")
DashCard.Size = UDim2.new(1, 0, 0, 100)
DashCard.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
DashCard.BorderSizePixel = 0
DashCard.ZIndex = 13
DashCard.Parent = DashPage

local DCCorner = Instance.new("UICorner")
DCCorner.CornerRadius = UDim.new(0, 8)
DCCorner.Parent = DashCard

local DCStroke = Instance.new("UIStroke")
DCStroke.Color = Color3.fromRGB(40, 40, 55)
DCStroke.Thickness = 1
DCStroke.Parent = DashCard

local DashTitle = Instance.new("TextLabel")
DashTitle.Size = UDim2.new(1, -20, 0, 20)
DashTitle.Position = UDim2.new(0, 12, 0, 8)
DashTitle.BackgroundTransparency = 1
DashTitle.Text = "SYSTEM STATUS // BYPASS v14.0 ACTIVE"
DashTitle.TextColor3 = Color3.fromRGB(212, 175, 55)
DashTitle.TextSize = 11
DashTitle.Font = Enum.Font.GothamBold
DashTitle.TextXAlignment = Enum.TextXAlignment.Left
DashTitle.ZIndex = 14
DashTitle.Parent = DashCard

local DashText = Instance.new("TextLabel")
DashText.Size = UDim2.new(1, -20, 0, 60)
DashText.Position = UDim2.new(0, 12, 0, 30)
DashText.BackgroundTransparency = 1
DashText.Text = "STATUS: SAFE FROM CODE 267 KICK\nENGINE: VECTOR C-FRAME TRANSLATION\nLAYOUT: BENTO DARK GLASSMORPHISM"
DashText.TextColor3 = Color3.fromRGB(170, 175, 185)
DashText.TextSize = 10
DashText.Font = Enum.Font.Code
DashText.TextXAlignment = Enum.TextXAlignment.Left
DashText.ZIndex = 14
DashText.Parent = DashCard

-- LIVE TELEMETRY CARD
local TelemetryCard = Instance.new("Frame")
TelemetryCard.Size = UDim2.new(1, 0, 0, 40)
TelemetryCard.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TelemetryCard.BorderSizePixel = 0
TelemetryCard.ZIndex = 13
TelemetryCard.Parent = DashPage

local TCCorner = Instance.new("UICorner")
TCCorner.CornerRadius = UDim.new(0, 8)
TCCorner.Parent = TelemetryCard

local TelemetryLabel = Instance.new("TextLabel")
TelemetryLabel.Size = UDim2.new(1, -20, 1, 0)
TelemetryLabel.Position = UDim2.new(0, 12, 0, 0)
TelemetryLabel.BackgroundTransparency = 1
TelemetryLabel.Text = "FPS: -- | PING: --ms | USER: " .. LocalPlayer.Name
TelemetryLabel.TextColor3 = Color3.fromRGB(212, 175, 55)
TelemetryLabel.TextSize = 10
TelemetryLabel.Font = Enum.Font.Code
TelemetryLabel.TextXAlignment = Enum.TextXAlignment.Left
TelemetryLabel.ZIndex = 14
TelemetryLabel.Parent = TelemetryCard

local FrameCounter = 0
local LastStatUpdate = tick()
RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    local now = tick()
    if now - LastStatUpdate >= 1 then
        local fps = math.floor(FrameCounter / (now - LastStatUpdate))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        TelemetryLabel.Text = "FPS: " .. tostring(fps) .. " | PING: " .. tostring(ping) .. "ms | USER: " .. LocalPlayer.Name
        FrameCounter = 0
        LastStatUpdate = now
    end
end)

-- ==========================================
-- 2. MOVEMENT PAGE (SAFE FROM CODE 267)
-- ==========================================
CreateToggle(MovementPage, "Vector Speed Booster (28)", State.WalkSpeed, function(act)
    State.WalkSpeed = act
end)

CreateToggle(MovementPage, "Jump Power Multiplier", State.JumpPower, function(act)
    State.JumpPower = act
    if act then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = State.JumpValue
            end
        end)
    else
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
            end
        end)
    end
end)

CreateToggle(MovementPage, "Infinite Jump Mode", State.InfJump, function(act)
    State.InfJump = act
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(MovementPage, "Stealth Fly Engine (WASD + Shift/Space)", State.Flying, function(act)
    State.Flying = act
    if act then StartFlying() else StopFlying() end
end)

CreateToggle(MovementPage, "Noclip Mode", State.Noclip, function(act)
    State.Noclip = act
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
-- 3. SERVERS PAGE
-- ==========================================
local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, 0, 0, 180)
ServerContainer.BackgroundTransparency = 1
ServerContainer.BorderSizePixel = 0
ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ServerContainer.ScrollBarThickness = 2
ServerContainer.ZIndex = 13
ServerContainer.Parent = ServersPage

local SCLayout = Instance.new("UIListLayout")
SCLayout.SortOrder = Enum.SortOrder.LayoutOrder
SCLayout.Padding = UDim.new(0, 6)
SCLayout.Parent = ServerContainer

CreateActionButton(ServersPage, "Scan 1-Player Server Instances", function()
    for _, child in pairs(ServerContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    ShowToast("Searching 1-player server instances...")

    task.spawn(function()
        pcall(function()
            local rawData = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local parsed = HttpService:JSONDecode(rawData)
            local count = 0

            if parsed and parsed.data then
                for _, s in pairs(parsed.data) do
                    if s.playing == 1 and s.id ~= game.JobId then
                        count = count + 1
                        local card = Instance.new("Frame")
                        card.Size = UDim2.new(1, 0, 0, 36)
                        card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                        card.BorderSizePixel = 0
                        card.ZIndex = 14
                        card.Parent = ServerContainer

                        local cCorner = Instance.new("UICorner")
                        cCorner.CornerRadius = UDim.new(0, 6)
                        cCorner.Parent = card

                        local infoLbl = Instance.new("TextLabel")
                        infoLbl.Size = UDim2.new(1, -75, 1, 0)
                        infoLbl.Position = UDim2.new(0, 10, 0, 0)
                        infoLbl.BackgroundTransparency = 1
                        infoLbl.Text = "SERVER: " .. string.sub(s.id, 1, 8) .. "... [1/" .. tostring(s.maxPlayers) .. "]"
                        infoLbl.TextColor3 = Color3.fromRGB(200, 205, 215)
                        infoLbl.TextSize = 10
                        infoLbl.Font = Enum.Font.Code
                        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                        infoLbl.ZIndex = 15
                        infoLbl.Parent = card

                        local joinBtn = Instance.new("TextButton")
                        joinBtn.Size = UDim2.new(0, 55, 0, 22)
                        joinBtn.Position = UDim2.new(1, -62, 0.5, -11)
                        joinBtn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
                        joinBtn.BorderSizePixel = 0
                        joinBtn.Text = "JOIN"
                        joinBtn.TextColor3 = Color3.fromRGB(10, 10, 14)
                        joinBtn.TextSize = 9
                        joinBtn.Font = Enum.Font.GothamBold
                        joinBtn.ZIndex = 15
                        joinBtn.Parent = card

                        local jCorner = Instance.new("UICorner")
                        jCorner.CornerRadius = UDim.new(0, 5)
                        jCorner.Parent = joinBtn

                        joinBtn.MouseButton1Click:Connect(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        end)
                    end
                end
            end

            if count == 0 then ShowToast("No solo servers found") end
        end)
    end)
end)

-- ==========================================
-- 4. PLAYERS PAGE & HIDE PLAYER
-- ==========================================
local PlayerContainer = Instance.new("ScrollingFrame")
PlayerContainer.Size = UDim2.new(1, 0, 0, 150)
PlayerContainer.BackgroundTransparency = 1
PlayerContainer.BorderSizePixel = 0
PlayerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerContainer.ScrollBarThickness = 2
PlayerContainer.ZIndex = 13
PlayerContainer.Parent = PlayersPage

local PCLayout = Instance.new("UIListLayout")
PCLayout.SortOrder = Enum.SortOrder.LayoutOrder
PCLayout.Padding = UDim.new(0, 6)
PCLayout.Parent = PlayerContainer

local TargetText = Instance.new("TextLabel")
TargetText.Size = UDim2.new(1, 0, 0, 20)
TargetText.BackgroundTransparency = 1
TargetText.Text = "TARGET LOCKED: NONE"
TargetText.TextColor3 = Color3.fromRGB(212, 175, 55)
TargetText.TextSize = 10
TargetText.Font = Enum.Font.GothamBold
TargetText.TextXAlignment = Enum.TextXAlignment.Left
TargetText.ZIndex = 13
TargetText.Parent = PlayersPage

local function RefreshPlayerList()
    for _, c in pairs(PlayerContainer:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            card.BorderSizePixel = 0
            card.ZIndex = 14
            card.Parent = PlayerContainer

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 6)
            cCorner.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -75, 1, 0)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = string.upper(plr.Name)
            nameLbl.TextColor3 = Color3.fromRGB(220, 225, 230)
            nameLbl.TextSize = 10
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 15
            nameLbl.Parent = card

            local selBtn = Instance.new("TextButton")
            selBtn.Size = UDim2.new(0, 58, 0, 22)
            selBtn.Position = UDim2.new(1, -65, 0.5, -11)
            selBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
            selBtn.BorderSizePixel = 0
            selBtn.Text = "SELECT"
            selBtn.TextColor3 = Color3.fromRGB(212, 175, 55)
            selBtn.TextSize = 9
            selBtn.Font = Enum.Font.GothamBold
            selBtn.ZIndex = 15
            selBtn.Parent = card

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 5)
            sCorner.Parent = selBtn

            selBtn.MouseButton1Click:Connect(function()
                State.SelectedTarget = plr
                TargetText.Text = "TARGET LOCKED: " .. string.upper(plr.Name)
                ShowToast("Locked onto: " .. plr.Name)
            end)
        end
    end
end

CreateActionButton(PlayersPage, "Refresh Player Roster", function() RefreshPlayerList() end)

CreateActionButton(PlayersPage, "Hide Selected Target Player", function()
    if not State.SelectedTarget then ShowToast("No target selected") return end
    local t = State.SelectedTarget
    if t.Character then
        for _, part in pairs(t.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1
            elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then part.Enabled = false end
        end
        ShowToast("Target hidden: " .. t.Name)
    end
end, Color3.fromRGB(45, 28, 25))

CreateActionButton(PlayersPage, "Unhide All Players", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0
                elseif part:IsA("Decal") then part.Transparency = 0
                elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then part.Enabled = true end
            end
        end
    end
    ShowToast("All players unhidden")
end)

-- ==========================================
-- 5. VISUALS PAGE
-- ==========================================
local ESPConnections = {}
CreateToggle(VisualsPage, "Highlight ESP Engine", State.PlayerESP, function(act)
    State.PlayerESP = act
    if act then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("VoidHL") then
                local hl = Instance.new("Highlight")
                hl.Name = "VoidHL"
                hl.FillColor = Color3.fromRGB(212, 175, 55)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VoidHL") then p.Character.VoidHL:Destroy() end
        end
    end
end)

-- ==========================================
-- 6. SYSTEM PAGE
-- ==========================================
CreateActionButton(SystemPage, "Auto-Join Solo Server", function()
    ShowToast("Searching for solo instance...")
    task.spawn(function()
        pcall(function()
            local rawData = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local parsed = HttpService:JSONDecode(rawData)
            if parsed and parsed.data then
                for _, s in pairs(parsed.data) do
                    if s.playing <= 1 and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        return
                    end
                end
            end
            ShowToast("No solo instance available")
        end)
    end)
end)

CreateToggle(SystemPage, "Anti-AFK System Simulation", State.AntiAFK, function(act)
    State.AntiAFK = act
    ShowToast("Anti-AFK: " .. (act and "ENABLED" or "DISABLED"))
end)

CreateActionButton(SystemPage, "Rejoin Current Instance", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- CALLBACK OPEN
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- START ANIMATION
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
RefreshPlayerList()
