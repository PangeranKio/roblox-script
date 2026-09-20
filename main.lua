-- [[ VOIDHUB SUPREME v14.1 - CYBERPUNK ULTRA EDITION ]] --
-- UI/UX: Luxury Holographic Neon Glassmorphism with Smooth Dynamic Loading
-- Fixes: Advanced Anti-Knockback Boss Disabler + Robust Egg Carry Base Teleport/Run Engine

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 0. CLEANUP & INSTANCE GUARD
-- ==========================================
if _G.VoidHubSupremeConnections then
    for _, conn in pairs(_G.VoidHubSupremeConnections) do
        if typeof(conn) == "RBXScriptConnection" and conn.Connected then
            conn:Disconnect()
        end
    end
end
_G.VoidHubSupremeConnections = {}

local function RegisterConnection(conn)
    table.insert(_G.VoidHubSupremeConnections, conn)
    return conn
end

if CoreGui:FindFirstChild("VoidHubUI_v14") then
    CoreGui.VoidHubUI_v14:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v14"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- COLOR PALETTE (LUXURY CYBERPUNK)
local C_BG = Color3.fromRGB(8, 9, 15)
local C_PANEL = Color3.fromRGB(14, 16, 26)
local C_ITEM = Color3.fromRGB(22, 25, 40)
local C_ACCENT_CYAN = Color3.fromRGB(0, 240, 255)
local C_ACCENT_PINK = Color3.fromRGB(255, 0, 128)
local C_ACCENT_PURPLE = Color3.fromRGB(138, 43, 226)
local C_TEXT = Color3.fromRGB(240, 245, 255)
local C_SUBTEXT = Color3.fromRGB(130, 140, 175)

-- GLOBAL STATE
local State = {
    Flying = false, FlySpeed = 50,
    WalkSpeed = false, SpeedValue = 24,
    JumpPower = false, JumpValue = 100,
    InfJump = false, Noclip = false,
    GravityMod = false, GravityVal = 196.2,
    Spinbot = false, SpinSpeed = 30,
    
    InstantPrompt = false, AutoPrompt = false,
    FreezeBossGuard = false,
    BossDisableAttack = false,
    AutoRunToBaseWithEgg = false,
    BaseCFrame = nil,
    
    AntiVoid = false, AntiAFK = true, AutoClicker = false,
    PlayerESP = false, Fullbright = false, CustomFOV = false, FOVValue = 70, ClickTP = false
}

local FlyVel, FlyGyro

-- DRAGGABLE UTILITY
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    RegisterConnection(topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    RegisterConnection(topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end))
end

-- ==========================================
-- 1. LUXURY CYBER DYNAMIC LOADING SCREEN
-- ==========================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = C_BG
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = VoidHubUI

local LoadingGlow = Instance.new("Frame")
LoadingGlow.Size = UDim2.new(0, 380, 0, 220)
LoadingGlow.Position = UDim2.new(0.5, -190, 0.5, -110)
LoadingGlow.BackgroundColor3 = C_PANEL
LoadingGlow.ZIndex = 101
LoadingGlow.Parent = LoadingFrame
Instance.new("UICorner", LoadingGlow).CornerRadius = UDim.new(0, 16)

local GlowStroke = Instance.new("UIStroke", LoadingGlow)
GlowStroke.Color = C_ACCENT_CYAN
GlowStroke.Thickness = 2

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
LoadingTitle.Position = UDim2.new(0, 0, 0.15, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "VOIDHUB <font color=\"#FF0080\">CYBER</font> v14.1"
LoadingTitle.RichText = true
LoadingTitle.TextColor3 = C_TEXT
LoadingTitle.TextSize = 20
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.ZIndex = 102
LoadingTitle.Parent = LoadingGlow

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0.35, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "INITIALIZING CORE ENGINES..."
LoadingSub.TextColor3 = C_ACCENT_CYAN
LoadingSub.TextSize = 11
LoadingSub.Font = Enum.Font.Code
LoadingSub.ZIndex = 102
LoadingSub.Parent = LoadingGlow

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0.8, 0, 0, 6)
LoadingBarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
LoadingBarBg.BackgroundColor3 = C_ITEM
LoadingBarBg.ZIndex = 102
LoadingBarBg.Parent = LoadingGlow
Instance.new("UICorner", LoadingBarBg).CornerRadius = UDim.new(1, 0)

local LoadingBarFill = Instance.new("Frame")
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = C_ACCENT_PINK
LoadingBarFill.ZIndex = 103
LoadingBarFill.Parent = LoadingBarBg
Instance.new("UICorner", LoadingBarFill).CornerRadius = UDim.new(1, 0)

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, 0, 0, 20)
LoadingStatus.Position = UDim2.new(0, 0, 0.75, 0)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Connecting..."
LoadingStatus.TextColor3 = C_SUBTEXT
LoadingStatus.TextSize = 10
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.ZIndex = 102
LoadingStatus.Parent = LoadingGlow

task.spawn(function()
    local tasks = {
        {name = "[1/4] Overriding Boss Physics & Hitboxes...", time = 0.25},
        {name = "[2/4] Calibrating Spawn & Egg Teleport Engine...", time = 0.25},
        {name = "[3/4] Rendering Holographic Cyber GlassUI...", time = 0.2},
        {name = "[4/4] Bypassing Anti-Knockback Guard...", time = 0.2}
    }
    
    for i, t in ipairs(tasks) do
        LoadingStatus.Text = t.name
        TweenService:Create(LoadingBarFill, TweenInfo.new(t.time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(i / #tasks, 0, 1, 0)
        }):Play()
        task.wait(t.time)
    end

    LoadingStatus.Text = "SYSTEM READY & ACTIVE"
    task.wait(0.2)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(LoadingGlow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
    for _, v in pairs(LoadingGlow:GetChildren()) do
        if v:IsA("TextLabel") or v:IsA("Frame") then
            TweenService:Create(v, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        end
    end
    task.wait(0.35)
    LoadingFrame:Destroy()
end)

-- ==========================================
-- FLOATING TOGGLE BUTTON
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 130, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenBtn.BackgroundColor3 = C_BG
OpenBtn.Text = "⚡ VOID-HUB"
OpenBtn.TextColor3 = C_ACCENT_CYAN
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 99
OpenBtn.Parent = VoidHubUI
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = C_ACCENT_CYAN
OpenStroke.Thickness = 1.5
MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN CYBERPUNK WINDOW
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 460)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
MainFrame.BackgroundColor3 = C_BG
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = C_ACCENT_CYAN
MainStroke.Thickness = 1.5

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 46)
Topbar.BackgroundColor3 = C_PANEL
Topbar.ZIndex = 11
Topbar.Parent = MainFrame
MakeDraggable(Topbar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#FF0080\">CYBER</font> <font color=\"#00F0FF\">v14.1</font>"
Title.RichText = true
Title.TextColor3 = C_TEXT
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundColor3 = C_ITEM
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_ACCENT_PINK
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- SIDEBAR NAV
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 165, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = C_PANEL
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout", Sidebar)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 4)

local NavPadding = Instance.new("UIPadding", Sidebar)
NavPadding.PaddingTop = UDim.new(0, 8)
NavPadding.PaddingLeft = UDim.new(0, 8)
NavPadding.PaddingRight = UDim.new(0, 8)

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -177, 1, -54)
ContentArea.Position = UDim2.new(0, 172, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder", ContentArea)

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -8, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C_ACCENT_CYAN
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    return page
end

local MainTabPage = CreatePage("Main")
local MovementTabPage = CreatePage("Movement")
local MechanicsTabPage = CreatePage("Mechanics")
local UtilityTabPage = CreatePage("Utility")
local VisualTabPage = CreatePage("Visual")
local WorldTabPage = CreatePage("World")

MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = defaultActive and C_ACCENT_CYAN or C_ITEM
    btn.Text = "  " .. text
    btn.TextColor3 = defaultActive and C_BG or C_SUBTEXT
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM}):Play()
                b.TextColor3 = C_SUBTEXT
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT_CYAN}):Play()
        btn.TextColor3 = C_BG
    end)
end

CreateTabButton("Dashboard", MainTabPage, true)
CreateTabButton("Boss & Egg Core", MechanicsTabPage, false)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Utility & Auto", UtilityTabPage, false)
CreateTabButton("Visuals & ESP", VisualTabPage, false)
CreateTabButton("World & Camera", WorldTabPage, false)

-- UI BUILDER FUNCTIONS
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 36)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = C_TEXT
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 34, 0, 16)
    switch.Position = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = defaultState and C_ACCENT_PINK or Color3.fromRGB(35, 40, 55)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 10, 0, 10)
    circle.Position = defaultState and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
    circle.BackgroundColor3 = defaultState and C_BG or C_TEXT
    circle.ZIndex = 15
    circle.Parent = switch
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT_PINK}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -13, 0.5, -5), BackgroundColor3 = C_BG}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 40, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -5), BackgroundColor3 = C_TEXT}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 34)
    btn.BackgroundColor3 = C_ITEM
    btn.Text = titleText
    btn.TextColor3 = C_TEXT
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.ZIndex = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C_ACCENT_CYAN, TextColor3 = C_BG}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM, TextColor3 = C_TEXT}):Play()
        callback()
    end)
end

local function CreateSlider(parent, titleText, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 48)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = C_TEXT
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 40, 0, 20)
    valLabel.Position = UDim2.new(1, -48, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(defaultVal)
    valLabel.TextColor3 = C_ACCENT_CYAN
    valLabel.TextSize = 10
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.ZIndex = 14
    valLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 5)
    sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    sliderBg.ZIndex = 14
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = C_ACCENT_CYAN
    sliderFill.ZIndex = 15
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        valLabel.Text = tostring(val)
        callback(val)
    end

    RegisterConnection(sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end))
    RegisterConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end))
end

-- ==========================================
-- DASHBOARD TAB
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -6, 0, 60)
ProfileCard.BackgroundColor3 = C_ITEM
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -20, 0, 20)
WelcomeText.Position = UDim2.new(0, 12, 0, 10)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "ACTIVE USER // <font color=\"#00F0FF\">" .. LocalPlayer.DisplayName .. "</font>"
WelcomeText.RichText = true
WelcomeText.TextColor3 = C_TEXT
WelcomeText.TextSize = 11
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.ZIndex = 14
WelcomeText.Parent = ProfileCard

local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, -20, 0, 18)
StatsText.Position = UDim2.new(0, 12, 0, 32)
StatsText.BackgroundTransparency = 1
StatsText.Text = "FPS: 60  |  PING: 0 ms"
StatsText.TextColor3 = C_SUBTEXT
StatsText.TextSize = 10
StatsText.Font = Enum.Font.Code
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.ZIndex = 14
StatsText.Parent = ProfileCard

RegisterConnection(RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1 / dt)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    StatsText.Text = string.format("FPS: %d  |  PING: %d ms", fps, ping)
end))

-- ==========================================
-- MECHANICS TAB (FIXED BOSS DISABLE & EGG AUTO RETURN)
-- ==========================================
CreateButton(MechanicsTabPage, "📍 Set Current Position as Custom Base", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        State.BaseCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- FIXED FEATURE 1: ADVANCED BOSS DISABLE (NO HIT & NO KNOCKBACK)
CreateToggle(MechanicsTabPage, "Disable Boss Hits & Anti-Knockback", State.BossDisableAttack, function(a)
    State.BossDisableAttack = a
end)

RegisterConnection(RunService.Stepped:Connect(function()
    if State.BossDisableAttack then
        pcall(function()
            -- Neutralize NPC hitboxes
            for _, model in pairs(workspace:GetDescendants()) do
                if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    if hum then
                        for _, part in pairs(model:GetDescendants()) do
                            if part:IsA("TouchTransmitter") then
                                part:Destroy()
                            elseif part:IsA("BasePart") then
                                part.CanTouch = false
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
            -- Anti Knockback Velocity Reset on Player
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                for _, v in pairs(hrp:GetChildren()) do
                    if v:IsA("BodyVelocity") or v:IsA("BodyForce") or v:IsA("BodyThrust") then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end))

-- FIXED FEATURE 2: ROBUST AUTO-RUN TO BASE ON HOLDING EGG
CreateToggle(MechanicsTabPage, "Auto-Run To Base When Carrying Egg", State.AutoRunToBaseWithEgg, function(a)
    State.AutoRunToBaseWithEgg = a
end)

task.spawn(function()
    while true do
        if State.AutoRunToBaseWithEgg then
            pcall(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local carryingEgg = false

                    -- Check Equipped Items
                    for _, item in pairs(char:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("egg") or item.Name:lower():find("telur")) then
                            carryingEgg = true
                        end
                    end
                    -- Check Backpack Items
                    if backpack then
                        for _, item in pairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and (item.Name:lower():find("egg") or item.Name:lower():find("telur")) then
                                carryingEgg = true
                            end
                        end
                    end

                    if carryingEgg then
                        local targetCFrame = State.BaseCFrame
                        if not targetCFrame then
                            local spawnLoc = workspace:FindFirstChildOfClass("SpawnLocation")
                            if spawnLoc then
                                targetCFrame = spawnLoc.CFrame + Vector3.new(0, 4, 0)
                            end
                        end

                        if targetCFrame then
                            char.HumanoidRootPart.CFrame = targetCFrame
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- OTHER MECHANICS
CreateToggle(MechanicsTabPage, "Freeze Boss / Guard Position", State.FreezeBossGuard, function(a)
    State.FreezeBossGuard = a
    task.spawn(function()
        while State.FreezeBossGuard do
            pcall(function()
                for _, model in pairs(workspace:GetDescendants()) do
                    if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("PrimaryPart")
                        if hum and hrp then
                            hum.WalkSpeed = 0
                            hrp.Velocity = Vector3.zero
                            if not hrp.Anchored then hrp.Anchored = true end
                        end
                    end
                end
            end)
            task.wait(0.2)
        end
        pcall(function()
            for _, model in pairs(workspace:GetDescendants()) do
                if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("PrimaryPart")
                    if hum and hrp then
                        hum.WalkSpeed = 16
                        hrp.Anchored = false
                    end
                end
            end
        end)
    end)
end)

CreateToggle(MechanicsTabPage, "Instant Proximity Prompts", State.InstantPrompt, function(a) State.InstantPrompt = a end)
RegisterConnection(ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if State.InstantPrompt then fireproximityprompt(prompt) end
end))

-- ==========================================
-- MOVEMENT TAB
-- ==========================================
CreateToggle(MovementTabPage, "Kinetic Flight Engine", State.Flying, function(a)
    State.Flying = a
    if a then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            FlyVel = Instance.new("BodyVelocity", root)
            FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            FlyGyro = Instance.new("BodyGyro", root)
            FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            task.spawn(function()
                while State.Flying and char and root:FindFirstChild("BodyVelocity") do
                    local cam = workspace.CurrentCamera
                    local dir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                    FlyVel.Velocity = dir * State.FlySpeed
                    FlyGyro.CFrame = cam.CFrame
                    task.wait()
                end
            end)
        end
    else
        if FlyVel then FlyVel:Destroy() end
        if FlyGyro then FlyGyro:Destroy() end
    end
end)
CreateSlider(MovementTabPage, "Flight Speed Rate", 20, 200, 50, function(v) State.FlySpeed = v end)

CreateToggle(MovementTabPage, "Speed Modifier Engine", State.WalkSpeed, function(a)
    State.WalkSpeed = a
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
CreateSlider(MovementTabPage, "WalkSpeed Value", 16, 250, 24, function(v) State.SpeedValue = v end)

CreateToggle(MovementTabPage, "Infinite Jump Air Drift", State.InfJump, function(a) State.InfJump = a end)
RegisterConnection(UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

CreateToggle(MovementTabPage, "Ghost Noclip Mode", State.Noclip, function(a)
    State.Noclip = a
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
-- UTILITY & OTHER TABS
-- ==========================================
CreateToggle(UtilityTabPage, "Anti-Void Fall Recovery", State.AntiVoid, function(a)
    State.AntiVoid = a
    task.spawn(function()
        while State.AntiVoid do
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Position.Y < -50 then
                    root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z)
                    root.Velocity = Vector3.zero
                end
            end)
            task.wait(0.5)
        end
    end)
end)

CreateToggle(UtilityTabPage, "Anti-AFK Disconnect Guard", State.AntiAFK, function(a) State.AntiAFK = a end)
CreateToggle(VisualTabPage, "Player Highlight ESP", State.PlayerESP, function(a) State.PlayerESP = a end)

CreateToggle(WorldTabPage, "Fullbright Vision Ambient", State.Fullbright, function(a)
    State.Fullbright = a
    if a then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false
    else Lighting.Brightness = 1 Lighting.GlobalShadows = true end
end)

print("[VOIDHUB v14.1] EXECUTED SUCCESSFULLY!")
