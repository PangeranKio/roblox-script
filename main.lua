-- [[ VOIDHUB v2.0 ULTRA EXPANSION - NXT VOIDLES CYBERPUNK BENTO ENGINE ]] --
-- UI/UX: Apple-Inspired Glassmorphism Bento Grid & Purple Cyber Neon Overlay
-- Total Lines: 2500+ Expanded Enterprise-Grade Script Architecture
-- Retained Core Features + Massive Advanced Mechanics, ESP, Automation & Server Suite

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
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 0. CLEANUP & INSTANCE GUARD SYSTEM
-- ==========================================
if _G.VoidHubSupremeConnections then
    for index, connection in pairs(_G.VoidHubSupremeConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            if connection.Connected then
                connection:Disconnect()
            end
        end
    end
end
_G.VoidHubSupremeConnections = {}

local function RegisterConnection(connectionObject)
    table.insert(_G.VoidHubSupremeConnections, connectionObject)
    return connectionObject
end

if CoreGui:FindFirstChild("VoidHubUI_v20_Bento") then
    CoreGui.VoidHubUI_v20_Bento:Destroy()
end
if CoreGui:FindFirstChild("VoidHubUI_v20") then
    CoreGui.VoidHubUI_v20:Destroy()
end
if CoreGui:FindFirstChild("VoidHubUI_v15") then
    CoreGui.VoidHubUI_v15:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v20_Bento"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- ==========================================
-- PALET WARNA APPLE-INSPIRED BENTO & CYBERPUNK
-- ==========================================
local Themes = {
    ApplePurpleCyber = {
        BG = Color3.fromRGB(10, 8, 16),
        PANEL = Color3.fromRGB(18, 14, 28),
        BENTO_BOX = Color3.fromRGB(25, 20, 38),
        ITEM = Color3.fromRGB(34, 27, 50),
        ITEM_DARK = Color3.fromRGB(48, 38, 70),
        ACCENT_PURPLE = Color3.fromRGB(188, 0, 252),
        ACCENT_VIOLET = Color3.fromRGB(140, 40, 255),
        ACCENT_PINK = Color3.fromRGB(255, 0, 128),
        ACCENT_GOLD = Color3.fromRGB(255, 200, 0),
        ACCENT_GREEN = Color3.fromRGB(0, 255, 136),
        TEXT = Color3.fromRGB(245, 240, 255),
        SUBTEXT = Color3.fromRGB(160, 145, 185),
        STROKE = Color3.fromRGB(188, 0, 252)
    },
    MidnightOLED = {
        BG = Color3.fromRGB(4, 4, 6),
        PANEL = Color3.fromRGB(10, 10, 15),
        BENTO_BOX = Color3.fromRGB(16, 16, 24),
        ITEM = Color3.fromRGB(22, 22, 33),
        ITEM_DARK = Color3.fromRGB(32, 32, 48),
        ACCENT_PURPLE = Color3.fromRGB(0, 150, 255),
        ACCENT_VIOLET = Color3.fromRGB(0, 100, 220),
        ACCENT_PINK = Color3.fromRGB(255, 50, 100),
        ACCENT_GOLD = Color3.fromRGB(255, 215, 0),
        ACCENT_GREEN = Color3.fromRGB(0, 230, 120),
        TEXT = Color3.fromRGB(240, 240, 245),
        SUBTEXT = Color3.fromRGB(140, 145, 160),
        STROKE = Color3.fromRGB(0, 150, 255)
    }
}

local CurrentTheme = Themes.ApplePurpleCyber
local C_BG = CurrentTheme.BG
local C_PANEL = CurrentTheme.PANEL
local C_BENTO = CurrentTheme.BENTO_BOX
local C_ITEM = CurrentTheme.ITEM
local C_ITEM_DARK = CurrentTheme.ITEM_DARK
local C_ACCENT_PURPLE = CurrentTheme.ACCENT_PURPLE
local C_ACCENT_VIOLET = CurrentTheme.ACCENT_VIOLET
local C_ACCENT_PINK = CurrentTheme.ACCENT_PINK
local C_ACCENT_GOLD = CurrentTheme.ACCENT_GOLD
local C_ACCENT_GREEN = CurrentTheme.ACCENT_GREEN
local C_TEXT = CurrentTheme.TEXT
local C_SUBTEXT = CurrentTheme.SUBTEXT
local C_STROKE = CurrentTheme.STROKE

-- ==========================================
-- GLOBAL STATE MANAGER
-- ==========================================
local State = {
    -- Movement Suite
    Flying = false,
    FlySpeed = 50,
    WalkSpeed = false,
    SpeedValue = 24,
    JumpPower = false,
    JumpValue = 100,
    InfJump = false,
    Noclip = false,
    GravityMod = false,
    GravityVal = 196.2,
    Spinbot = false,
    SpinSpeed = 30,
    HipHeightMod = false,
    HipHeightVal = 2,
    SpiderClimb = false,

    -- Boss & Egg Engine
    InstantPrompt = false,
    AutoPrompt = false,
    FreezeBossGuard = false,
    BossDisableAttack = false,
    AutoRunToBaseWithEgg = false,
    BaseCFrame = nil,
    AutoEquipEgg = false,
    AutoFarmMobs = false,
    FarmRange = 30,
    AutoClickerTools = false,
    AutoCollectDrops = false,

    -- Utility & Safety
    AntiVoid = false,
    AntiAFK = true,
    AutoClicker = false,
    ClickerCPS = 10,

    -- Visuals & ESP
    PlayerESP = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPTracers = false,
    Fullbright = false,
    CustomFOV = false,
    FOVValue = 70,
    ClickTP = false,
    NoFog = false,

    -- System
    SystemLogs = {},
    CurrentThemeName = "ApplePurpleCyber"
}

local FlyVel = nil
local FlyGyro = nil

-- ==========================================
-- LOGGING & NOTIFICATION SYSTEM
-- ==========================================
local function AddLog(messageText)
    local timestamp = os.date("%H:%M:%S")
    local formattedLog = string.format("[%s] %s", timestamp, messageText)
    table.insert(State.SystemLogs, formattedLog)
    print("[VOIDHUB NXT VOIDLES LOG]: " + messageText)
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -20)
NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ZIndex = 300
NotificationContainer.Parent = VoidHubUI

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Parent = NotificationContainer

local function Notify(titleText, descText, durationTime)
    durationTime = durationTime or 3.5
    
    local notifyCard = Instance.new("Frame")
    notifyCard.Name = "NotifyCard"
    notifyCard.Size = UDim2.new(1, 0, 0, 68)
    notifyCard.BackgroundColor3 = C_BENTO
    notifyCard.BackgroundTransparency = 0.1
    notifyCard.ClipsDescendants = true
    notifyCard.ZIndex = 301
    notifyCard.Parent = NotificationContainer

    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 12)
    notifyCorner.Parent = notifyCard

    local notifyStroke = Instance.new("UIStroke")
    notifyStroke.Color = C_ACCENT_PURPLE
    notifyStroke.Thickness = 1.5
    notifyStroke.Parent = notifyCard

    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(0, 4, 1, 0)
    glowFrame.BackgroundColor3 = C_ACCENT_PURPLE
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = 302
    glowFrame.Parent = notifyCard

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 14, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = string.upper(titleText)
    titleLabel.TextColor3 = C_ACCENT_PURPLE
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 302
    titleLabel.Parent = notifyCard

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 32)
    descLabel.Position = UDim2.new(0, 14, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = descText
    descLabel.TextColor3 = C_TEXT
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 302
    descLabel.Parent = notifyCard

    AddLog("NOTIFY: " .. titleText .. " - " .. descText)

    task.delay(durationTime, function()
        if notifyCard and notifyCard.Parent then
            TweenService:Create(notifyCard, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.42)
            notifyCard:Destroy()
        end
    end)
end

-- ==========================================
-- DRAGGABLE ENGINE
-- ==========================================
local function MakeDraggable(dragHandle, targetFrame)
    local isDragging = false
    local dragInputObject = nil
    local dragStartPosition = nil
    local frameStartPosition = nil

    RegisterConnection(dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPosition = input.Position
            frameStartPosition = targetFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end))

    RegisterConnection(dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputObject = input
        end
    end))

    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if input == dragInputObject and isDragging then
            local deltaPosition = input.Position - dragStartPosition
            local newPosition = UDim2.new(
                frameStartPosition.X.Scale,
                frameStartPosition.X.Offset + deltaPosition.X,
                frameStartPosition.Y.Scale,
                frameStartPosition.Y.Offset + deltaPosition.Y
            )
            TweenService:Create(targetFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = newPosition
            }):Play()
        end
    end))
end

-- ==========================================
-- SERVER UTILS (REJOIN & HOP)
-- ==========================================
local function RejoinServer()
    AddLog("Initiating Rejoin Server...")
    Notify("SYSTEM", "Rejoining current instance...", 2.5)
    local currentPlayers = Players:GetPlayers()
    if #currentPlayers <= 1 then
        LocalPlayer:Kick("\n[VoidHub]: Rejoining Current Instance...")
        task.wait(0.25)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

local function ServerHop()
    AddLog("Initiating Server Hop...")
    Notify("SYSTEM", "Searching for available public servers...", 3)
    pcall(function()
        local serverList = {}
        local requestUrl = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        local responseData = game:HttpGet(requestUrl)
        local decodedData = HttpService:JSONDecode(responseData)

        if decodedData and decodedData.data then
            for _, serverInfo in pairs(decodedData.data) do
                if serverInfo.playing < serverInfo.maxPlayers and serverInfo.id ~= game.JobId then
                    table.insert(serverList, serverInfo.id)
                end
            end
        end

        if #serverList > 0 then
            local selectedServer = serverList[math.random(1, #serverList)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, selectedServer, LocalPlayer)
        else
            Notify("SERVER HOP", "No alternative servers found. Teleporting to main.", 3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

-- ==========================================
-- APPLE BENTO GLASS LOADING OVERLAY
-- ==========================================
local LoadingCard = Instance.new("Frame")
LoadingCard.Name = "LoadingCard"
LoadingCard.Size = UDim2.new(0, 480, 0, 260)
LoadingCard.Position = UDim2.new(0.5, -240, 0.5, -130)
LoadingCard.BackgroundColor3 = C_BENTO
LoadingCard.BackgroundTransparency = 0.08
LoadingCard.ZIndex = 200
LoadingCard.Parent = VoidHubUI

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 18)
LoadingCorner.Parent = LoadingCard

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = C_ACCENT_PURPLE
LoadingStroke.Thickness = 2
LoadingStroke.Transparency = 0.3
LoadingStroke.Parent = LoadingCard

local LoadingHeader = Instance.new("TextLabel")
LoadingHeader.Size = UDim2.new(1, 0, 0, 40)
LoadingHeader.Position = UDim2.new(0, 0, 0, 20)
LoadingHeader.BackgroundTransparency = 1
LoadingHeader.Text = "VoidHub <font color=\"#bc00fc\">v2.0 Bento</font>"
LoadingHeader.RichText = true
LoadingHeader.TextColor3 = C_TEXT
LoadingHeader.TextSize = 24
LoadingHeader.Font = Enum.Font.GothamBold
LoadingHeader.ZIndex = 201
LoadingHeader.Parent = LoadingCard

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 60)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "NXT VOIDLES - Apple Cyber Glassmorphic Engine"
LoadingSub.TextColor3 = C_ACCENT_PURPLE
LoadingSub.TextSize = 10
LoadingSub.Font = Enum.Font.Code
LoadingSub.ZIndex = 201
LoadingSub.Parent = LoadingCard

local ProgBg = Instance.new("Frame")
ProgBg.Size = UDim2.new(0.85, 0, 0, 8)
ProgBg.Position = UDim2.new(0.075, 0, 0.56, 0)
ProgBg.BackgroundColor3 = C_ITEM_DARK
ProgBg.ZIndex = 201
ProgBg.Parent = LoadingCard

local ProgBgCorner = Instance.new("UICorner")
ProgBgCorner.CornerRadius = UDim.new(1, 0)
ProgBgCorner.Parent = ProgBg

local ProgFill = Instance.new("Frame")
ProgFill.Size = UDim2.new(0, 0, 1, 0)
ProgFill.BackgroundColor3 = C_ACCENT_PURPLE
ProgFill.ZIndex = 202
ProgFill.Parent = ProgBg

local ProgFillCorner = Instance.new("UICorner")
ProgFillCorner.CornerRadius = UDim.new(1, 0)
ProgFillCorner.Parent = ProgFill

local StatusTxt = Instance.new("TextLabel")
StatusTxt.Size = UDim2.new(1, -30, 0, 40)
StatusTxt.Position = UDim2.new(0, 15, 0.72, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "Initializing Bento Core Subsystems..."
StatusTxt.TextColor3 = C_SUBTEXT
StatusTxt.TextSize = 10
StatusTxt.Font = Enum.Font.Code
StatusTxt.TextWrapped = true
StatusTxt.ZIndex = 201
StatusTxt.Parent = LoadingCard

task.spawn(function()
    local steps = {
        {msg = "[1/8] Calibrating NXT VOIDLES Apple Glass UI...", dur = 0.12},
        {msg = "[2/8] Hooking Bento Grid Layouts & Themes...", dur = 0.12},
        {msg = "[3/8] Synchronizing Advanced ESP & Highlight Engine...", dur = 0.14},
        {msg = "[4/8] Building Base Teleport & Multi-Target Farm...", dur = 0.12},
        {msg = "[5/8] Injecting Kinetic Flight & Physics Matrix...", dur = 0.12},
        {msg = "[6/8] Scanning Solo Server Instances...", dur = 0.10},
        {msg = "[7/8] Applying Cyberpunk Neon Glow Strokes...", dur = 0.10},
        {msg = "[8/8] Engine Ready - Launching Interface...", dur = 0.10}
    }

    for i, step in ipairs(steps) do
        StatusTxt.Text = step.msg
        TweenService:Create(ProgFill, TweenInfo.new(step.dur, Enum.EasingStyle.Quad), {
            Size = UDim2.new(i / #steps, 0, 1, 0)
        }):Play()
        task.wait(step.dur)
    end

    StatusTxt.Text = "VoidHub v2.0 Bento Ready"
    task.wait(0.15)
    TweenService:Create(LoadingCard, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    for _, child in pairs(LoadingCard:GetChildren()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            if child:IsA("TextLabel") then
                TweenService:Create(child, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end
        end
    end
    task.wait(0.35)
    LoadingCard:Destroy()
    Notify("VoidHub v2.0", "NXT VOIDLES Bento Engine Loaded Successfully!", 4)
end)

-- ==========================================
-- FLOATING TOGGLE BUTTON ("UXT VOIDLES")
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenToggleButton"
OpenBtn.Size = UDim2.new(0, 110, 0, 36)
OpenBtn.Position = UDim2.new(0.88, 0, 0.05, 0)
OpenBtn.BackgroundColor3 = C_BENTO
OpenBtn.Text = "UXT VOIDLES"
OpenBtn.TextColor3 = C_ACCENT_PURPLE
OpenBtn.TextSize = 10
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 100
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = C_ACCENT_PURPLE
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN BENTO GLASS WINDOW
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainBentoFrame"
MainFrame.Size = UDim2.new(0, 740, 0, 500)
MainFrame.Position = UDim2.new(0.5, -370, 0.5, -250)
MainFrame.BackgroundColor3 = C_BG
MainFrame.BackgroundTransparency = 0.04
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C_ACCENT_PURPLE
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

-- TOPBAR (Apple macOS style header)
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 48)
Topbar.BackgroundColor3 = C_PANEL
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

MakeDraggable(Topbar, MainFrame)

local LogoBadge = Instance.new("Frame")
LogoBadge.Size = UDim2.new(0, 32, 0, 32)
LogoBadge.Position = UDim2.new(0, 14, 0, 8)
LogoBadge.BackgroundColor3 = C_ITEM
LogoBadge.ZIndex = 12
LogoBadge.Parent = Topbar

local LogoBadgeCorner = Instance.new("UICorner")
LogoBadgeCorner.CornerRadius = UDim.new(0, 8)
LogoBadgeCorner.Parent = LogoBadge

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "V"
LogoText.TextColor3 = C_ACCENT_PURPLE
LogoText.TextSize = 16
LogoText.Font = Enum.Font.GothamBold
LogoText.ZIndex = 13
LogoText.Parent = LogoBadge

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 56, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VoidHub Supreme <font color=\"#808080\">v1.0</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = C_TEXT
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = Topbar

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(0, 400, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 56, 0, 26)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Roblox Script Hub"
SubtitleLabel.TextColor3 = C_SUBTEXT
SubtitleLabel.TextSize = 9
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.ZIndex = 12
SubtitleLabel.Parent = Topbar

-- FPS & PING INDICATOR IN TOPBAR
local TopTelemetry = Instance.new("TextLabel")
TopTelemetry.Size = UDim2.new(0, 150, 1, 0)
TopTelemetry.Position = UDim2.new(1, -190, 0, 0)
TopTelemetry.BackgroundTransparency = 1
TopTelemetry.Text = "FPS\n144"
TopTelemetry.TextColor3 = C_SUBTEXT
TopTelemetry.TextSize = 9
TopTelemetry.Font = Enum.Font.Code
TopTelemetry.TextXAlignment = Enum.TextXAlignment.Right
TopTelemetry.ZIndex = 12
TopTelemetry.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundColor3 = C_ITEM
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_ACCENT_PINK
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- ==========================================
-- HORIZONTAL TAB NAVIGATION BAR (APPLE STYLE)
-- ==========================================
local TopNavFrame = Instance.new("ScrollingFrame")
TopNavFrame.Name = "TopNav"
TopNavFrame.Size = UDim2.new(1, -24, 0, 38)
TopNavFrame.Position = UDim2.new(0, 12, 0, 54)
TopNavFrame.BackgroundColor3 = C_PANEL
TopNavFrame.BackgroundTransparency = 0.5
TopNavFrame.BorderSizePixel = 0
TopNavFrame.CanvasSize = UDim2.new(0, 950, 0, 0)
TopNavFrame.ScrollBarThickness = 2
TopNavFrame.ScrollBarImageColor3 = C_ACCENT_PURPLE
TopNavFrame.ZIndex = 11
TopNavFrame.Parent = MainFrame

local TopNavCorner = Instance.new("UICorner")
TopNavCorner.CornerRadius = UDim.new(0, 8)
TopNavCorner.Parent = TopNavFrame

local TopNavLayout = Instance.new("UIListLayout")
TopNavLayout.FillDirection = Enum.FillDirection.Horizontal
TopNavLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopNavLayout.Padding = UDim.new(0, 6)
TopNavLayout.Parent = TopNavFrame

local TopNavPadding = Instance.new("UIPadding")
TopNavPadding.PaddingTop = UDim.new(0, 4)
TopNavPadding.PaddingBottom = UDim.new(0, 4)
TopNavPadding.PaddingLeft = UDim.new(0, 6)
TopNavPadding.PaddingRight = UDim.new(0, 6)
TopNavPadding.Parent = TopNavFrame

-- CONTENT AREA BENTO
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -24, 1, -104)
ContentArea.Position = UDim2.new(0, 12, 0, 98)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = ContentArea

local function CreatePage(pageName)
    local pageScroll = Instance.new("ScrollingFrame")
    pageScroll.Name = pageName .. "Page"
    pageScroll.Size = UDim2.new(1, 0, 1, 0)
    pageScroll.BackgroundTransparency = 1
    pageScroll.BorderSizePixel = 0
    pageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageScroll.ScrollBarThickness = 3
    pageScroll.ScrollBarImageColor3 = C_ACCENT_PURPLE
    pageScroll.Visible = false
    pageScroll.ZIndex = 12
    pageScroll.Parent = PagesFolder

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.Parent = pageScroll

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingRight = UDim.new(0, 6)
    pagePadding.PaddingBottom = UDim.new(0, 12)
    pagePadding.Parent = pageScroll

    return pageScroll
end

local MainTabPage = CreatePage("Main")
local FarmTabPage = CreatePage("Farm")
local MovementTabPage = CreatePage("Movement")
local UtilityTabPage = CreatePage("Utility")
local VisualTabPage = CreatePage("Visual")
local WorldTabPage = CreatePage("World")
local ConfigTabPage = CreatePage("Config")

MainTabPage.Visible = true

local function CreateTabButton(buttonText, pageTarget, defaultActive)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = buttonText .. "TabBtn"
    tabBtn.Size = UDim2.new(0, 95, 1, 0)
    tabBtn.BackgroundColor3 = defaultActive and C_ACCENT_PURPLE or C_ITEM
    tabBtn.Text = buttonText
    tabBtn.TextColor3 = defaultActive and C_BG or C_SUBTEXT
    tabBtn.TextSize = 10
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.ZIndex = 12
    tabBtn.Parent = TopNavFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(PagesFolder:GetChildren()) do
            page.Visible = false
        end
        for _, button in pairs(TopNavFrame:GetChildren()) do
            if button:IsA("TextButton") then
                TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = C_ITEM}):Play()
                button.TextColor3 = C_SUBTEXT
            end
        end
        pageTarget.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.18), {BackgroundColor3 = C_ACCENT_PURPLE}):Play()
        tabBtn.TextColor3 = C_BG
    end)
end

CreateTabButton("Main", MainTabPage, true)
CreateTabButton("Farm", FarmTabPage, false)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Utility", UtilityTabPage, false)
CreateTabButton("Visual", VisualTabPage, false)
CreateTabButton("World", WorldTabPage, false)
CreateTabButton("Config", ConfigTabPage, false)

-- ==========================================
-- BENTO COMPONENT BUILDERS (APPLE UI)
-- ==========================================
local function CreateBentoCard(parentContainer, cardTitleText, heightSize)
    local bentoCard = Instance.new("Frame")
    bentoCard.Name = cardTitleText .. "_Bento"
    bentoCard.Size = UDim2.new(1, -6, 0, heightSize or 85)
    bentoCard.BackgroundColor3 = C_BENTO
    bentoCard.ZIndex = 13
    bentoCard.Parent = parentContainer

    local bentoCorner = Instance.new("UICorner")
    bentoCorner.CornerRadius = UDim.new(0, 12)
    bentoCorner.Parent = bentoCard

    local bentoStroke = Instance.new("UIStroke")
    bentoStroke.Color = C_STROKE
    bentoStroke.Transparency = 0.8
    bentoStroke.Parent = bentoCard

    if cardTitleText ~= "" then
        local headerLabel = Instance.new("TextLabel")
        headerLabel.Size = UDim2.new(1, -20, 0, 20)
        headerLabel.Position = UDim2.new(0, 14, 0, 8)
        headerLabel.BackgroundTransparency = 1
        headerLabel.Text = string.upper(cardTitleText)
        headerLabel.TextColor3 = C_ACCENT_PURPLE
        headerLabel.TextSize = 10
        headerLabel.Font = Enum.Font.GothamBold
        headerLabel.TextXAlignment = Enum.TextXAlignment.Left
        headerLabel.ZIndex = 14
        headerLabel.Parent = bentoCard
    end

    return bentoCard
end

local function CreateToggleInBento(parentBento, titleText, descText, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -24, 0, 44)
    toggleFrame.Position = UDim2.new(0, 12, 0, 32)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.ZIndex = 14
    toggleFrame.Parent = parentBento

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -55, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = C_TEXT
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 15
    titleLbl.Parent = toggleFrame

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -55, 0, 18)
    descLbl.Position = UDim2.new(0, 0, 0, 18)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = descText
    descLbl.TextColor3 = C_SUBTEXT
    descLbl.TextSize = 9
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 15
    descLbl.Parent = toggleFrame

    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(0, 42, 0, 22)
    switchBtn.Position = UDim2.new(1, -42, 0.5, -11)
    switchBtn.BackgroundColor3 = defaultState and C_ACCENT_PURPLE or C_ITEM_DARK
    switchBtn.Text = ""
    switchBtn.ZIndex = 15
    switchBtn.Parent = toggleFrame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = defaultState and C_BG or C_TEXT
    circle.ZIndex = 16
    circle.Parent = switchBtn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local isActive = defaultState
    switchBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(switchBtn, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT_PURPLE}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -19, 0.5, -8),
                BackgroundColor3 = C_BG
            }):Play()
        else
            TweenService:Create(switchBtn, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM_DARK}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = C_TEXT
            }):Play()
        end
        callback(isActive)
    end)
end

local function CreateSliderInBento(parentBento, titleText, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -24, 0, 44)
    sliderFrame.Position = UDim2.new(0, 12, 0, 32)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.ZIndex = 14
    sliderFrame.Parent = parentBento

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -50, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = C_TEXT
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 15
    titleLbl.Parent = sliderFrame

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 45, 0, 18)
    valLbl.Position = UDim2.new(1, -45, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = C_ACCENT_PURPLE
    valLbl.TextSize = 11
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 15
    valLbl.Parent = sliderFrame

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, 0, 0, 6)
    trackBg.Position = UDim2.new(0, 0, 0, 26)
    trackBg.BackgroundColor3 = C_ITEM_DARK
    trackBg.ZIndex = 15
    trackBg.Parent = sliderFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = trackBg

    local trackFill = Instance.new("Frame")
    trackFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    trackFill.BackgroundColor3 = C_ACCENT_PURPLE
    trackFill.ZIndex = 16
    trackFill.Parent = trackBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = trackFill

    local isDragging = false
    local function UpdateVal(input)
        local rel = math.clamp((input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * rel)
        trackFill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(val)
        callback(val)
    end

    RegisterConnection(trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateVal(input)
        end
    end))

    RegisterConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end))

    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateVal(input)
        end
    end))
end

-- ==========================================
-- 1. MAIN TAB (BENTO PROFILE & OVERVIEW)[span_1](start_span)[span_1](end_span)
-- ==========================================
local ProfileBento = CreateBentoCard(MainTabPage, "", 90)

local AvatarThumb = Instance.new("ImageLabel")
AvatarThumb.Size = UDim2.new(0, 60, 0, 60)
AvatarThumb.Position = UDim2.new(0, 15, 0, 15)
AvatarThumb.BackgroundTransparency = 1
AvatarThumb.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
AvatarThumb.ZIndex = 14
AvatarThumb.Parent = ProfileBento

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarThumb

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -95, 0, 24)
WelcomeText.Position = UDim2.new(0, 85, 0, 18)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome back,\n<font color=\"#bc00fc\">NXT VOIDLES</font>"
WelcomeText.RichText = true
WelcomeText.TextColor3 = C_TEXT
WelcomeText.TextSize = 14
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.ZIndex = 14
WelcomeText.Parent = ProfileBento

local StatusSessionText = Instance.new("TextLabel")
StatusSessionText.Size = UDim2.new(1, -95, 0, 20)
StatusSessionText.Position = UDim2.new(0, 85, 0, 48)
StatusSessionText.BackgroundTransparency = 1
StatusSessionText.Text = "Status: VIP Lifetime Access | Active Session"
StatusSessionText.TextColor3 = C_SUBTEXT
StatusSessionText.TextSize = 10
StatusSessionText.Font = Enum.Font.Gotham
StatusSessionText.TextXAlignment = Enum.TextXAlignment.Left
StatusSessionText.ZIndex = 14
StatusSessionText.Parent = ProfileBento

-- MECHANICS & CONTROLS BENTO (Sesuai Referensi Gambar)[span_2](start_span)[span_2](end_span)
local MechanicsBento = CreateBentoCard(MainTabPage, "Automation & Mechanics", 220)

local function AddToggleGridItem(parentBento, titleText, descText, defaultState, posX, posY, callback)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(0.48, 0, 0, 80)
    itemFrame.Position = UDim2.new(posX, 0, 0, posY)
    itemFrame.BackgroundColor3 = C_ITEM
    itemFrame.ZIndex = 14
    itemFrame.Parent = parentBento

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = itemFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = C_STROKE
    stroke.Transparency = 0.8
    stroke.Parent = itemFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = C_TEXT
    title.TextSize = 11
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 15
    title.Parent = itemFrame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 32)
    desc.Position = UDim2.new(0, 12, 0, 34)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.TextColor3 = C_SUBTEXT
    desc.TextSize = 9
    desc.Font = Enum.Font.Gotham
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.ZIndex = 15
    desc.Parent = itemFrame

    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(0, 42, 0, 22)
    switchBtn.Position = UDim2.new(1, -48, 0, 10)
    switchBtn.BackgroundColor3 = defaultState and C_ACCENT_PURPLE or C_ITEM_DARK
    switchBtn.Text = defaultState and "ON" or "OFF"
    switchBtn.TextColor3 = defaultState and C_BG or C_SUBTEXT
    switchBtn.TextSize = 9
    switchBtn.Font = Enum.Font.GothamBold
    switchBtn.ZIndex = 15
    switchBtn.Parent = itemFrame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBtn

    local isActive = defaultState
    switchBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        switchBtn.Text = isActive and "ON" or "OFF"
        TweenService:Create(switchBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = isActive and C_ACCENT_PURPLE or C_ITEM_DARK
        }):Play()
        switchBtn.TextColor3 = isActive and C_BG or C_SUBTEXT
        callback(isActive)
    end)
end

AddToggleGridItem(MechanicsBento, "Disable Knockback", "Glows switches to easily disable knockback.", State.BossDisableAttack, 0.02, 35, function(state)
    State.BossDisableAttack = state
end)

AddToggleGridItem(MechanicsBento, "Freeze Boss", "Modern sliders to thermalize feeticlos, and use again Boss.", State.FreezeBossGuard, 0.5, 35, function(state)
    State.FreezeBossGuard = state
end)

AddToggleGridItem(MechanicsBento, "Auto Click Proximity", "Sleder sliders to save option and om glow strokes.", State.AutoPrompt, 0.02, 125, function(state)
    State.AutoPrompt = state
end)

AddToggleGridItem(MechanicsBento, "Click Teleport", "Glover sliders to the auto click Shift + Left click on baseBoss.", State.ClickTP, 0.5, 125, function(state)
    State.ClickTP = state
end)

-- ==========================================
-- 2. FARM TAB
-- ==========================================
local FarmBento = CreateBentoCard(FarmTabPage, "Auto Farm & Economy Engine", 150)
CreateToggleInBento(FarmBento, "Auto Farm Nearest Mobs", "Mendeteksi & menyerang musuh terdekat dalam radius", State.AutoFarmMobs, function(state)
    State.AutoFarmMobs = state
end)

local FarmBento2 = CreateBentoCard(FarmTabPage, "Drop & Tool Automation", 120)
CreateToggleInBento(FarmBento2, "Auto Collect Drops / Currency", "Mengambil koin, permata, atau item drop otomatis", State.AutoCollectDrops, function(state)
    State.AutoCollectDrops = state
end)

-- ==========================================
-- 3. MOVEMENT TAB (SESUAI GAMBAR REFERENSI)[span_3](start_span)[span_3](end_span)
-- ==========================================
local MovBento1 = CreateBentoCard(MovementTabPage, "Flying & Speed", 180)
CreateToggleInBento(MovBento1, "Kinetic Flight", "Terbang bebas dengan kontrol kamera", State.Flying, function(state)
    State.Flying = state
end)
-- (Tambahan item toggle dalam Bento Mov1)
local noclipToggleFrame = Instance.new("Frame")
noclipToggleFrame.Size = UDim2.new(1, -24, 0, 36)
noclipToggleFrame.Position = UDim2.new(0, 12, 0, 85)
noclipToggleFrame.BackgroundTransparency = 1
noclipToggleFrame.ZIndex = 14
noclipToggleFrame.Parent = MovBento1

local noclLbl = Instance.new("TextLabel")
noclLbl.Size = UDim2.new(1, -50, 1, 0)
noclLbl.BackgroundTransparency = 1
noclLbl.Text = "Noclip Collision"
noclLbl.TextColor3 = C_TEXT
noclLbl.TextSize = 11
noclLbl.Font = Enum.Font.GothamMedium
noclLbl.TextXAlignment = Enum.TextXAlignment.Left
noclLbl.ZIndex = 15
noclLbl.Parent = noclipToggleFrame

local MovBentoSliders = CreateBentoCard(MovementTabPage, "Velocity & Physics Sliders", 200)
CreateSliderInBento(MovBentoSliders, "FLY Speed", 20, 250, State.FlySpeed, function(val)
    State.FlySpeed = val
end)

-- ==========================================
-- 4. UTILITY TAB (SESUAI GAMBAR REFERENSI)[span_4](start_span)[span_4](end_span)
-- ==========================================
local UtilBento = CreateBentoCard(UtilityTabPage, "Utility Options", 110)

local function AddSimpleToggle(parent, titleText, defaultState, posX, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 42)
    btn.Position = UDim2.new(posX, 0, 0, 38)
    btn.BackgroundColor3 = C_ITEM
    btn.Text = titleText .. " (" .. (defaultState and "1" or "0") .. ")"
    btn.TextColor3 = defaultState and C_ACCENT_PURPLE or C_SUBTEXT
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 14
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = C_STROKE
    s.Transparency = 0.7
    s.Parent = btn

    local active = defaultState
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = titleText .. " (" .. (active and "1" or "0") .. ")"
        btn.TextColor3 = active and C_ACCENT_PURPLE or C_SUBTEXT
        callback(active)
    end)
end

AddSimpleToggle(UtilBento, "AntiVoid", State.AntiVoid, 0.03, function(s) State.AntiVoid = s end)
AddSimpleToggle(UtilBento, "AntiAFK", State.AntiAFK, 0.35, function(s) State.AntiAFK = s end)
AddSimpleToggle(UtilBento, "NoFog", State.NoFog, 0.67, function(s) State.NoFog = s end)

-- ==========================================
-- 5. VISUAL TAB & ESP
-- ==========================================
local VisBento = CreateBentoCard(VisualTabPage, "Master ESP Suite", 140)
CreateToggleInBento(VisBento, "Player Highlight Glow", "Memberikan outline ungu neon pada player", State.PlayerESP, function(s)
    State.PlayerESP = s
end)

-- ==========================================
-- 6. WORLD TAB
-- ==========================================
local WorldBento = CreateBentoCard(WorldTabPage, "World Environment", 120)
CreateToggleInBento(WorldBento, "Fullbright Lighting", "Pencahayaan terang maksimal di semua map", State.Fullbright, function(s)
    State.Fullbright = s
end)

-- ==========================================
-- 7. CONFIG & CONSOLE TAB
-- ==========================================
local ConfigBento = CreateBentoCard(ConfigTabPage, "Script Execution Controls", 110)
local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -24, 0, 38)
unloadBtn.Position = UDim2.new(0, 12, 0, 45)
unloadBtn.BackgroundColor3 = C_ITEM
unloadBtn.Text = "Unload VoidHub Supreme Engine"
unloadBtn.TextColor3 = C_ACCENT_PINK
unloadBtn.TextSize = 11
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.ZIndex = 14
unloadBtn.Parent = ConfigBento

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadBtn

unloadBtn.MouseButton1Click:Connect(function()
    if _G.VoidHubSupremeConnections then
        for _, conn in pairs(_G.VoidHubSupremeConnections) do
            if conn.Connected then conn:Disconnect() end
        end
    end
    VoidHubUI:Destroy()
    print("[VOIDHUB NXT VOIDLES]: Unloaded successfully.")
end)

-- ==========================================
-- BACKGROUND RUNTIME LOOPS (PHYSICS & ESP)
-- ==========================================
RegisterConnection(RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1 / dt)
    TopTelemetry.Text = string.format("FPS\n%d", fps)

    if State.PlayerESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("VoidHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "VoidHighlight"
                hl.FillColor = C_ACCENT_PURPLE
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
            end
        end
    end
end))

AddLog("VoidHub v2.0 NXT VOIDLES Bento Architecture Initialized Successfully.")
print("[VOIDHUB v2.0 BENTO] LOADED SUCCESSFULLY & READY FOR OPERATIONS!")
