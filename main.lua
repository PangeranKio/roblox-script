-- [[ VOIDHUB v1.0 ]] --
-- UI/UX: Ultra-Luxury Cyberpunk Glassmorphism Clean Overlay
-- Features: 100% Retained & Expanded Engine Core (1500+ Lines Expanded)

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

if CoreGui:FindFirstChild("VoidHubUI_v15") then
    CoreGui.VoidHubUI_v15:Destroy()
end
if CoreGui:FindFirstChild("VoidHubUI_v14") then
    CoreGui.VoidHubUI_v14:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v15"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- ==========================================
-- PALET WARNA CYBERPUNK GLASSMORPHISM
-- ==========================================
local C_BG = Color3.fromRGB(12, 14, 24)
local C_PANEL = Color3.fromRGB(18, 22, 36)
local C_ITEM = Color3.fromRGB(26, 32, 50)
local C_ACCENT_CYAN = Color3.fromRGB(0, 240, 255)
local C_ACCENT_PINK = Color3.fromRGB(255, 0, 128)
local C_ACCENT_PURPLE = Color3.fromRGB(140, 40, 255)
local C_ACCENT_GOLD = Color3.fromRGB(255, 200, 0)
local C_ACCENT_GREEN = Color3.fromRGB(0, 255, 136)
local C_TEXT = Color3.fromRGB(245, 248, 255)
local C_SUBTEXT = Color3.fromRGB(130, 145, 180)
local C_STROKE = Color3.fromRGB(0, 180, 220)

-- ==========================================
-- GLOBAL STATE MANAGER
-- ==========================================
local State = {
    -- Movement Features
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
    
    -- Mechanics Features
    InstantPrompt = false,
    AutoPrompt = false,
    FreezeBossGuard = false,
    BossDisableAttack = false,
    AutoRunToBaseWithEgg = false,
    BaseCFrame = nil,
    AutoEquipEgg = false,
    
    -- Utility & Automation
    AntiVoid = false,
    AntiAFK = true,
    AutoClicker = false,
    ClickerCPS = 10,
    AutoRejoinError = true,
    FPSCap = 60,
    
    -- Visuals & World
    PlayerESP = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPTracers = false,
    Fullbright = false,
    CustomFOV = false,
    FOVValue = 70,
    ClickTP = false,
    NoFog = false,
    
    -- System Log
    SystemLogs = {}
}

local FlyVel = nil
local FlyGyro = nil

-- ==========================================
-- LOGGING SYSTEM & NOTIFICATION ENGINE
-- ==========================================
local function AddLog(messageText)
    local timestamp = os.date("%H:%M:%S")
    local formattedLog = string.format("[%s] %s", timestamp, messageText)
    table.insert(State.SystemLogs, formattedLog)
    print("[VOIDHUB LOG]: " .. messageText)
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 260, 1, -20)
NotificationContainer.Position = UDim2.new(1, -270, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ZIndex = 200
NotificationContainer.Parent = VoidHubUI

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 6)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Parent = NotificationContainer

local function Notify(titleText, descText, durationTime)
    durationTime = durationTime or 3
    
    local notifyCard = Instance.new("Frame")
    notifyCard.Name = "NotifyCard"
    notifyCard.Size = UDim2.new(1, 0, 0, 56)
    notifyCard.BackgroundColor3 = C_PANEL
    notifyCard.BackgroundTransparency = 0.15
    notifyCard.ClipsDescendants = true
    notifyCard.ZIndex = 201
    notifyCard.Parent = NotificationContainer

    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 8)
    notifyCorner.Parent = notifyCard

    local notifyStroke = Instance.new("UIStroke")
    notifyStroke.Color = C_ACCENT_CYAN
    notifyStroke.Thickness = 1.5
    notifyStroke.Parent = notifyCard

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -16, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = C_ACCENT_CYAN
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 202
    titleLabel.Parent = notifyCard

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -16, 0, 24)
    descLabel.Position = UDim2.new(0, 10, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = descText
    descLabel.TextColor3 = C_TEXT
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 202
    descLabel.Parent = notifyCard

    AddLog("NOTIFY: " .. titleText .. " - " .. descText)

    task.delay(durationTime, function()
        if notifyCard and notifyCard.Parent then
            TweenService:Create(notifyCard, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(descLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.35)
            notifyCard:Destroy()
        end
    end)
end

-- ==========================================
-- ENGINE DRAGGABLE INTERAKSI
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
            TweenService:Create(targetFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = newPosition
            }):Play()
        end
    end))
end

-- ==========================================
-- HELPER UTILITIES FOR TELEPORTATION & SERVERS
-- ==========================================
local function RejoinServer()
    AddLog("Initiating Rejoin Server Sequence...")
    Notify("SYSTEM", "Rejoining current instance...", 2)
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
    AddLog("Initiating Server Hop Sequence...")
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
            Notify("SERVER HOP", "No alternative servers found. Teleporting to main place.", 3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

-- ==========================================
-- 1. CLEAN LOADING OVERLAY (NO BACKGROUND FULLSCREEN)
-- UPDATE TERBARU: Background hitam dihapus total, hanya card melayang
-- ==========================================
local LoadingCard = Instance.new("Frame")
LoadingCard.Name = "LoadingCard"
LoadingCard.Size = UDim2.new(0, 420, 0, 220)
LoadingCard.Position = UDim2.new(0.5, -210, 0.5, -110)
LoadingCard.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
LoadingCard.BackgroundTransparency = 0.15
LoadingCard.ZIndex = 101
LoadingCard.Parent = VoidHubUI

local LoadingCardCorner = Instance.new("UICorner")
LoadingCardCorner.CornerRadius = UDim.new(0, 16)
LoadingCardCorner.Parent = LoadingCard

local LoadingCardStroke = Instance.new("UIStroke")
LoadingCardStroke.Color = C_ACCENT_CYAN
LoadingCardStroke.Thickness = 2
LoadingCardStroke.Transparency = 0.2
LoadingCardStroke.Parent = LoadingCard

local LoadingHeader = Instance.new("TextLabel")
LoadingHeader.Name = "LoadingHeader"
LoadingHeader.Size = UDim2.new(1, 0, 0, 36)
LoadingHeader.Position = UDim2.new(0, 0, 0, 18)
LoadingHeader.BackgroundTransparency = 1
LoadingHeader.Text = "VoidHub v1.0"
LoadingHeader.RichText = true
LoadingHeader.TextColor3 = C_TEXT
LoadingHeader.TextSize = 22
LoadingHeader.Font = Enum.Font.GothamBold
LoadingHeader.ZIndex = 102
LoadingHeader.Parent = LoadingCard

local LoadingSubHeader = Instance.new("TextLabel")
LoadingSubHeader.Name = "LoadingSubHeader"
LoadingSubHeader.Size = UDim2.new(1, 0, 0, 20)
LoadingSubHeader.Position = UDim2.new(0, 0, 0, 54)
LoadingSubHeader.BackgroundTransparency = 1
LoadingSubHeader.Text = "Initializing"
LoadingSubHeader.TextColor3 = C_ACCENT_CYAN
LoadingSubHeader.TextSize = 10
LoadingSubHeader.Font = Enum.Font.Code
LoadingSubHeader.ZIndex = 102
LoadingSubHeader.Parent = LoadingCard

local LoadingProgressBackground = Instance.new("Frame")
LoadingProgressBackground.Name = "ProgressBarBackground"
LoadingProgressBackground.Size = UDim2.new(0.85, 0, 0, 8)
LoadingProgressBackground.Position = UDim2.new(0.075, 0, 0.52, 0)
LoadingProgressBackground.BackgroundColor3 = Color3.fromRGB(28, 34, 52)
LoadingProgressBackground.ZIndex = 102
LoadingProgressBackground.Parent = LoadingCard

local ProgressBgCorner = Instance.new("UICorner")
ProgressBgCorner.CornerRadius = UDim.new(1, 0)
ProgressBgCorner.Parent = LoadingProgressBackground

local LoadingProgressFill = Instance.new("Frame")
LoadingProgressFill.Name = "ProgressBarFill"
LoadingProgressFill.Size = UDim2.new(0, 0, 1, 0)
LoadingProgressFill.BackgroundColor3 = C_ACCENT_PINK
LoadingProgressFill.ZIndex = 103
LoadingProgressFill.Parent = LoadingProgressBackground

local ProgressFillCorner = Instance.new("UICorner")
ProgressFillCorner.CornerRadius = UDim.new(1, 0)
ProgressFillCorner.Parent = LoadingProgressFill

local ProgressGlow = Instance.new("UIGradient")
ProgressGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C_ACCENT_PINK),
    ColorSequenceKeypoint.new(1, C_ACCENT_PURPLE)
})
ProgressGlow.Parent = LoadingProgressFill

local LoadingStatusText = Instance.new("TextLabel")
LoadingStatusText.Name = "StatusTerminal"
LoadingStatusText.Size = UDim2.new(1, -30, 0, 40)
LoadingStatusText.Position = UDim2.new(0, 15, 0.68, 0)
LoadingStatusText.BackgroundTransparency = 1
LoadingStatusText.Text = "Connecting to VoidHub..."
LoadingStatusText.TextColor3 = C_SUBTEXT
LoadingStatusText.TextSize = 10
LoadingStatusText.Font = Enum.Font.Code
LoadingStatusText.TextWrapped = true
LoadingStatusText.ZIndex = 102
LoadingStatusText.Parent = LoadingCard

task.spawn(function()
    local loadingSequence = {
        {message = "[1/6] Injecting Boss Hitbox & Knockback Inhibitor...", duration = 0.18},
        {message = "[2/6] Hooking Character Inventory for Egg Detection...", duration = 0.20},
        {message = "[3/6] Calibrating Base Teleport Coordinate Engine...", duration = 0.18},
        {message = "[4/6] Constructing Clean Compact UI Navigation...", duration = 0.18},
        {message = "[5/6] Finalizing Anti-AFK & Server Scan Protocols...", duration = 0.15},
        {message = "[6/6] Verifying System Integrities & Module Registers...", duration = 0.15}
    }

    for index, taskData in ipairs(loadingSequence) do
        LoadingStatusText.Text = taskData.message
        local targetRatio = index / #loadingSequence
        TweenService:Create(LoadingProgressFill, TweenInfo.new(taskData.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(targetRatio, 0, 1, 0)
        }):Play()
        task.wait(taskData.duration)
    end

    LoadingStatusText.Text = "VoidHub Ready & Active"
    task.wait(0.15)

    TweenService:Create(LoadingCard, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()

    for _, childInstance in pairs(LoadingCard:GetChildren()) do
        if childInstance:IsA("TextLabel") or childInstance:IsA("Frame") then
            TweenService:Create(childInstance, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end

    task.wait(0.3)
    LoadingCard:Destroy()
    Notify("VoidHub", "Engine Loaded Successfully! Enjoy.", 4)
end)

-- ==========================================
-- FLOATING TOGGLE BUTTON BARU
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenToggleButton"
OpenBtn.Size = UDim2.new(0, 140, 0, 38)
OpenBtn.Position = UDim2.new(0.02, 0, 0.12, 0)
OpenBtn.BackgroundColor3 = C_BG
OpenBtn.Text = "VOIDHUB"
OpenBtn.TextColor3 = C_ACCENT_CYAN
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 99
OpenBtn.Parent = VoidHubUI

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(0, 8)
OpenBtnCorner.Parent = OpenBtn

local OpenBtnStroke = Instance.new("UIStroke")
OpenBtnStroke.Color = C_ACCENT_CYAN
OpenBtnStroke.Thickness = 1.5
OpenBtnStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN CYBERPUNK WINDOW (OPTIMIZED LAYOUT)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainCyberFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 460)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
MainFrame.BackgroundColor3 = C_BG
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 14)
MainFrameCorner.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Color = C_ACCENT_CYAN
MainFrameStroke.Thickness = 1.5
MainFrameStroke.Parent = MainFrame

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Name = "TopbarFrame"
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundColor3 = C_PANEL
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

MakeDraggable(Topbar, MainFrame)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VoidHub <font color=\"#bc00fc\">v1.0</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = C_TEXT
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseButton"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = C_ITEM
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_ACCENT_PINK
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- ==========================================
-- TOP CATEGORY NAVIGATION BAR (RESPONSIVE SCROLL)
-- FIX: Dibuat ScrollingFrame horizontal agar tidak menutupi isi Konten
-- ==========================================
local TopNavFrame = Instance.new("ScrollingFrame")
TopNavFrame.Name = "TopCategoryNav"
TopNavFrame.Size = UDim2.new(1, -20, 0, 36)
TopNavFrame.Position = UDim2.new(0, 10, 0, 46)
TopNavFrame.BackgroundColor3 = C_PANEL
TopNavFrame.BackgroundTransparency = 0.2
TopNavFrame.BorderSizePixel = 0
TopNavFrame.CanvasSize = UDim2.new(0, 1100, 0, 0)
TopNavFrame.ScrollBarThickness = 2
TopNavFrame.ScrollBarImageColor3 = C_ACCENT_CYAN
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

-- CONTENT AREA (Disesuaikan agar muat sempurna)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentAreaFrame"
ContentArea.Size = UDim2.new(1, -20, 1, -92)
ContentArea.Position = UDim2.new(0, 10, 0, 86)
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
    pageScroll.ScrollBarImageColor3 = C_ACCENT_CYAN
    pageScroll.Visible = false
    pageScroll.ZIndex = 12
    pageScroll.Parent = PagesFolder

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = pageScroll

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingRight = UDim.new(0, 6)
    pagePadding.Parent = pageScroll

    return pageScroll
end

local MainTabPage = CreatePage("Main")
local MechanicsTabPage = CreatePage("Mechanics")
local MovementTabPage = CreatePage("Movement")
local UtilityTabPage = CreatePage("Utility")
local VisualTabPage = CreatePage("Visual")
local WorldTabPage = CreatePage("World")
local ServerTabPage = CreatePage("Server")
local PlayersTabPage = CreatePage("Players")
local SettingsTabPage = CreatePage("Settings")

MainTabPage.Visible = true

local function CreateTabButton(buttonText, pageTarget, defaultActive)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = buttonText .. "TabBtn"
    tabBtn.Size = UDim2.new(0, 125, 1, 0)
    tabBtn.BackgroundColor3 = defaultActive and C_ACCENT_CYAN or C_ITEM
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
        TweenService:Create(tabBtn, TweenInfo.new(0.18), {BackgroundColor3 = C_ACCENT_CYAN}):Play()
        tabBtn.TextColor3 = C_BG
    end)
end

CreateTabButton("Main", MainTabPage, true)
CreateTabButton("Farm", MechanicsTabPage, false)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Utility", UtilityTabPage, false)
CreateTabButton("Visual", VisualTabPage, false)
CreateTabButton("World", WorldTabPage, false)
CreateTabButton("Server", ServerTabPage, false)
CreateTabButton("Player", PlayersTabPage, false)
CreateTabButton("Config", SettingsTabPage, false)

-- ==========================================
-- COMPONENT BUILDERS ENGINE
-- ==========================================
local function CreateSectionLabel(parentContainer, sectionTitleText)
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionHeader_" .. sectionTitleText
    sectionLabel.Size = UDim2.new(1, -6, 0, 22)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "  //" .. string.upper(sectionTitleText)
    sectionLabel.TextColor3 = C_ACCENT_CYAN
    sectionLabel.TextSize = 10
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.ZIndex = 13
    sectionLabel.Parent = parentContainer
    return sectionLabel
end

local function CreateToggle(parentContainer, titleText, defaultState, toggleCallback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = titleText .. "_ToggleFrame"
    toggleFrame.Size = UDim2.new(1, -6, 0, 36)
    toggleFrame.BackgroundColor3 = C_ITEM
    toggleFrame.ZIndex = 13
    toggleFrame.Parent = parentContainer

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = toggleFrame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = C_STROKE
    frameStroke.Transparency = 0.85
    frameStroke.Parent = toggleFrame

    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(1, -55, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = titleText
    labelText.TextColor3 = C_TEXT
    labelText.TextSize = 10
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 14
    labelText.Parent = toggleFrame

    local switchButton = Instance.new("TextButton")
    switchButton.Name = "Switch"
    switchButton.Size = UDim2.new(0, 36, 0, 18)
    switchButton.Position = UDim2.new(1, -44, 0.5, -9)
    switchButton.BackgroundColor3 = defaultState and C_ACCENT_PINK or Color3.fromRGB(48, 36, 56)
    switchButton.Text = ""
    switchButton.ZIndex = 14
    switchButton.Parent = toggleFrame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchButton

    local circleIndicator = Instance.new("Frame")
    circleIndicator.Name = "Circle"
    circleIndicator.Size = UDim2.new(0, 12, 0, 12)
    circleIndicator.Position = defaultState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    circleIndicator.BackgroundColor3 = defaultState and C_BG or C_TEXT
    circleIndicator.ZIndex = 15
    circleIndicator.Parent = switchButton

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circleIndicator

    local isActive = defaultState
    switchButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT_PINK}):Play()
            TweenService:Create(circleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -15, 0.5, -6),
                BackgroundColor3 = C_BG
            }):Play()
        else
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(48, 36, 56)}):Play()
            TweenService:Create(circleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = C_TEXT
            }):Play()
        end
        toggleCallback(isActive)
    end)
end

local function CreateSlider(parentContainer, titleText, minimumValue, maximumValue, defaultValue, sliderCallback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = titleText .. "_SliderFrame"
    sliderFrame.Size = UDim2.new(1, -6, 0, 46)
    sliderFrame.BackgroundColor3 = C_ITEM
    sliderFrame.ZIndex = 13
    sliderFrame.Parent = parentContainer

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame

    local labelText = Instance.new("TextLabel")
    labelText.Name = "TitleLabel"
    labelText.Size = UDim2.new(1, -60, 0, 20)
    labelText.Position = UDim2.new(0, 12, 0, 4)
    labelText.BackgroundTransparency = 1
    labelText.Text = titleText
    labelText.TextColor3 = C_TEXT
    labelText.TextSize = 10
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 14
    labelText.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueDisplay"
    valueLabel.Size = UDim2.new(0, 45, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = C_ACCENT_CYAN
    valueLabel.TextSize = 10
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 14
    valueLabel.Parent = sliderFrame

    local trackBackground = Instance.new("Frame")
    trackBackground.Name = "TrackBg"
    trackBackground.Size = UDim2.new(1, -24, 0, 6)
    trackBackground.Position = UDim2.new(0, 12, 0, 30)
    trackBackground.BackgroundColor3 = Color3.fromRGB(48, 36, 56)
    trackBackground.ZIndex = 14
    trackBackground.Parent = sliderFrame

    local trackBgCorner = Instance.new("UICorner")
    trackBgCorner.CornerRadius = UDim.new(1, 0)
    trackBgCorner.Parent = trackBackground

    local trackFill = Instance.new("Frame")
    trackFill.Name = "TrackFill"
    trackFill.Size = UDim2.new((defaultValue - minimumValue) / (maximumValue - minimumValue), 0, 1, 0)
    trackFill.BackgroundColor3 = C_ACCENT_CYAN
    trackFill.ZIndex = 15
    trackFill.Parent = trackBackground

    local trackFillCorner = Instance.new("UICorner")
    trackFillCorner.CornerRadius = UDim.new(1, 0)
    trackFillCorner.Parent = trackFill

    local isDragging = false
    local function UpdateSliderValue(inputObject)
        local relativePosition = math.clamp((inputObject.Position.X - trackBackground.AbsolutePosition.X) / trackBackground.AbsoluteSize.X, 0, 1)
        local calculatedValue = math.floor(minimumValue + (maximumValue - minimumValue) * relativePosition)
        trackFill.Size = UDim2.new(relativePosition, 0, 1, 0)
        valueLabel.Text = tostring(calculatedValue)
        sliderCallback(calculatedValue)
    end

    RegisterConnection(trackBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateSliderValue(input)
        end
    end))

    RegisterConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end))

    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSliderValue(input)
        end
    end))
end

local function CreateButton(parentContainer, buttonText, clickCallback)
    local actionButton = Instance.new("TextButton")
    actionButton.Name = buttonText .. "_ActionButton"
    actionButton.Size = UDim2.new(1, -6, 0, 34)
    actionButton.BackgroundColor3 = C_ITEM
    actionButton.Text = buttonText
    actionButton.TextColor3 = C_TEXT
    actionButton.TextSize = 10
    actionButton.Font = Enum.Font.GothamMedium
    actionButton.ZIndex = 13
    actionButton.Parent = parentContainer

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = actionButton

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = C_STROKE
    buttonStroke.Transparency = 0.85
    buttonStroke.Parent = actionButton

    actionButton.MouseButton1Click:Connect(function()
        TweenService:Create(actionButton, TweenInfo.new(0.08), {
            BackgroundColor3 = C_ACCENT_CYAN,
            TextColor3 = C_BG
        }):Play()
        task.wait(0.1)
        TweenService:Create(actionButton, TweenInfo.new(0.2), {
            BackgroundColor3 = C_ITEM,
            TextColor3 = C_TEXT
        }):Play()
        clickCallback()
    end)
end

-- ==========================================
-- 1. MAIN DASHBOARD PAGE
-- PERBAIKAN: local BannerText untuk mencegah error script
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "UserProfileCard"
ProfileCard.Size = UDim2.new(1, -6, 0, 60)
ProfileCard.BackgroundColor3 = C_ITEM
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage

local ProfileCardCorner = Instance.new("UICorner")
ProfileCardCorner.CornerRadius = UDim.new(0, 8)
ProfileCardCorner.Parent = ProfileCard

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarThumbnail"
AvatarImage.Size = UDim2.new(0, 44, 0, 44)
AvatarImage.Position = UDim2.new(0, 8, 0, 8)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
AvatarImage.ZIndex = 14
AvatarImage.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local UserWelcomeLabel = Instance.new("TextLabel")
UserWelcomeLabel.Name = "UserWelcomeText"
UserWelcomeLabel.Size = UDim2.new(1, -66, 0, 18)
UserWelcomeLabel.Position = UDim2.new(0, 60, 0, 10)
UserWelcomeLabel.BackgroundTransparency = 1
UserWelcomeLabel.Text = "Welcome, <font color=\"#bc00fc\">" .. LocalPlayer.DisplayName .. "</font>"
UserWelcomeLabel.RichText = true
UserWelcomeLabel.TextColor3 = C_TEXT
UserWelcomeLabel.TextSize = 11
UserWelcomeLabel.Font = Enum.Font.GothamBold
UserWelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
UserWelcomeLabel.ZIndex = 14
UserWelcomeLabel.Parent = ProfileCard

local TelemetryLabel = Instance.new("TextLabel")
TelemetryLabel.Name = "NetworkTelemetry"
TelemetryLabel.Size = UDim2.new(1, -66, 0, 18)
TelemetryLabel.Position = UDim2.new(0, 60, 0, 30)
TelemetryLabel.BackgroundTransparency = 1
TelemetryLabel.Text = "FPS: 60  |  PING: 0 ms"
TelemetryLabel.TextColor3 = C_SUBTEXT
TelemetryLabel.TextSize = 10
TelemetryLabel.Font = Enum.Font.Code
TelemetryLabel.TextXAlignment = Enum.TextXAlignment.Left
TelemetryLabel.ZIndex = 14
TelemetryLabel.Parent = ProfileCard

RegisterConnection(RunService.RenderStepped:Connect(function(deltaTime)
    local currentFps = math.floor(1 / deltaTime)
    local currentPing = 0
    pcall(function()
        currentPing = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    TelemetryLabel.Text = string.format("FPS: %d  |  PING: %d ms", currentFps, currentPing)
end))

local BannerNotice = Instance.new("Frame")
BannerNotice.Name = "AnnouncementBanner"
BannerNotice.Size = UDim2.new(1, -6, 0, 72)
BannerNotice.BackgroundColor3 = C_ITEM
BannerNotice.ZIndex = 13
BannerNotice.Parent = MainTabPage

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 8)
BannerCorner.Parent = BannerNotice

local BannerStroke = Instance.new("UIStroke")
BannerStroke.Color = C_ACCENT_CYAN
BannerStroke.Transparency = 0.7
BannerStroke.Parent = BannerNotice

local BannerHeader = Instance.new("TextLabel")
BannerHeader.Name = "BannerHeader"
BannerHeader.Size = UDim2.new(1, -20, 0, 18)
BannerHeader.Position = UDim2.new(0, 10, 0, 6)
BannerHeader.BackgroundTransparency = 1
BannerHeader.Text = "VoidHub v1.0"
BannerHeader.TextColor3 = C_ACCENT_CYAN
BannerHeader.TextSize = 10
BannerHeader.Font = Enum.Font.GothamBold
BannerHeader.TextXAlignment = Enum.TextXAlignment.Left
BannerHeader.ZIndex = 14
BannerHeader.Parent = BannerNotice

local BannerText = Instance.new("TextLabel")
BannerText.Name = "BannerBody"
BannerText.Size = UDim2.new(1, -20, 0, 42)
BannerText.Position = UDim2.new(0, 10, 0, 24)
BannerText.BackgroundTransparency = 1
BannerText.Text = "Script Ini Masih Dalam Pengembangan Dan Masih Dalam Tahap Percobaan (BETA)"
BannerText.TextColor3 = C_TEXT
BannerText.TextSize = 10
BannerText.Font = Enum.Font.Gotham
BannerText.TextWrapped = true
BannerText.TextXAlignment = Enum.TextXAlignment.Left
BannerText.TextYAlignment = Enum.TextYAlignment.Top
BannerText.ZIndex = 14
BannerText.Parent = BannerNotice

CreateSectionLabel(MainTabPage, "Quick Server Control")
CreateButton(MainTabPage, "Rejoin Server", function() RejoinServer() end)
CreateButton(MainTabPage, "Server Hop", function() ServerHop() end)

-- ==========================================
-- 2. BOSS & EGG MECHANICS TAB
-- ==========================================
CreateSectionLabel(MechanicsTabPage, "Base")
CreateButton(MechanicsTabPage, "Simpan Koordinat Posisi Saat Ini Sebagai Base", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        State.BaseCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        Notify("BASE SAVED", "Koordinat posisi berhasil disimpan sebagai lokasi Base!", 3)
    end
end)

CreateSectionLabel(MechanicsTabPage, "Boss")
CreateToggle(MechanicsTabPage, "Disable Knockback", State.BossDisableAttack, function(activeState)
    State.BossDisableAttack = activeState
    Notify("BOSS ENGINE", activeState and "Boss Attack Hitbox Disabler Aktif!" or "Boss Attack Normal.", 2)
end)

-- ENGINE HITBOX & ANTI-KNOCKBACK BOSS (OPTIMIZED LOOP)
RegisterConnection(RunService.Stepped:Connect(function()
    if State.BossDisableAttack then
        pcall(function()
            for _, workspaceObject in pairs(workspace:GetDescendants()) do
                if workspaceObject:IsA("Model") and not Players:GetPlayerFromCharacter(workspaceObject) then
                    local humanoid = workspaceObject:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, childPart in pairs(workspaceObject:GetDescendants()) do
                            if childPart:IsA("TouchTransmitter") then
                                childPart:Destroy()
                            elseif childPart:IsA("BasePart") then
                                childPart.CanTouch = false
                                childPart.CanCollide = false
                            end
                        end
                    end
                end
            end

            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                for _, childVelocity in pairs(rootPart:GetChildren()) do
                    if childVelocity:IsA("BodyVelocity") or childVelocity:IsA("BodyForce") or childVelocity:IsA("BodyThrust") then
                        childVelocity:Destroy()
                    end
                end
            end
        end)
    end
end))

CreateToggle(MechanicsTabPage, "Freeze Boss", State.FreezeBossGuard, function(activeState)
    State.FreezeBossGuard = activeState
    Notify("BOSS ENGINE", activeState and "Freeze Boss Active!" or "Boss Normal Unfrozen.", 2)
    task.spawn(function()
        while State.FreezeBossGuard do
            pcall(function()
                for _, npcModel in pairs(workspace:GetDescendants()) do
                    if npcModel:IsA("Model") and not Players:GetPlayerFromCharacter(npcModel) then
                        local npcHumanoid = npcModel:FindFirstChildOfClass("Humanoid")
                        local npcRoot = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChild("PrimaryPart")
                        if npcHumanoid and npcRoot then
                            npcHumanoid.WalkSpeed = 0
                            npcRoot.Velocity = Vector3.zero
                            if not npcRoot.Anchored then
                                npcRoot.Anchored = true
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)
        end

        pcall(function()
            for _, npcModel in pairs(workspace:GetDescendants()) do
                if npcModel:IsA("Model") and not Players:GetPlayerFromCharacter(npcModel) then
                    local npcHumanoid = npcModel:FindFirstChildOfClass("Humanoid")
                    local npcRoot = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChild("PrimaryPart")
                    if npcHumanoid and npcRoot then
                        npcHumanoid.WalkSpeed = 16
                        npcRoot.Anchored = false
                    end
                end
            end
        end)
    end)
end)

CreateSectionLabel(MechanicsTabPage, "Egg Automation")
CreateToggle(MechanicsTabPage, "Auto Run", State.AutoRunToBaseWithEgg, function(activeState)
    State.AutoRunToBaseWithEgg = activeState
    Notify("EGG ENGINE", activeState and "Auto TP Base saat memegang Telur Aktif!" or "Auto TP Nonaktif.", 2)
end)

CreateToggle(MechanicsTabPage, "Auto Equip Telur", State.AutoEquipEgg, function(activeState)
    State.AutoEquipEgg = activeState
end)

-- EGG DETECTOR & AUTO BASE RETURN LOOP
task.spawn(function()
    while true do
        if State.AutoRunToBaseWithEgg or State.AutoEquipEgg then
            pcall(function()
                local character = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local isHoldingEgg = false
                    local eggToolInstance = nil

                    for _, toolItem in pairs(character:GetChildren()) do
                        if toolItem:IsA("Tool") and (toolItem.Name:lower():find("egg") or toolItem.Name:lower():find("telur")) then
                            isHoldingEgg = true
                            eggToolInstance = toolItem
                        end
                    end

                    if backpack then
                        for _, toolItem in pairs(backpack:GetChildren()) do
                            if toolItem:IsA("Tool") and (toolItem.Name:lower():find("egg") or toolItem.Name:lower():find("telur")) then
                                eggToolInstance = toolItem
                                if State.AutoEquipEgg then
                                    toolItem.Parent = character
                                    isHoldingEgg = true
                                else
                                    isHoldingEgg = true
                                end
                            end
                        end
                    end

                    if isHoldingEgg and State.AutoRunToBaseWithEgg then
                        local destinationCFrame = State.BaseCFrame
                        if not destinationCFrame then
                            local mapSpawn = workspace:FindFirstChildOfClass("SpawnLocation")
                            if mapSpawn then
                                destinationCFrame = mapSpawn.CFrame + Vector3.new(0, 4, 0)
                            end
                        end

                        if destinationCFrame then
                            character.HumanoidRootPart.CFrame = destinationCFrame
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

CreateSectionLabel(MechanicsTabPage, Automation")
CreateToggle(MechanicsTabPage, "Tanpa Hold Delay", State.InstantPrompt, function(activeState)
    State.InstantPrompt = activeState
end)

RegisterConnection(ProximityPromptService.PromptButtonHoldBegan:Connect(function(promptInstance)
    if State.InstantPrompt then
        fireproximityprompt(promptInstance)
    end
end))

CreateToggle(MechanicsTabPage, "Auto Click Proximity Prompts", State.AutoPrompt, function(activeState)
    State.AutoPrompt = activeState
    task.spawn(function()
        while State.AutoPrompt do
            for _, promptInstance in pairs(workspace:GetDescendants()) do
                if promptInstance:IsA("ProximityPrompt") then
                    fireproximityprompt(promptInstance)
                end
            end
            task.wait(0.4)
        end
    end)
end)

-- ==========================================
-- 3. MOVEMENT TAB
-- ==========================================
CreateSectionLabel(MovementTabPage, "Flight")
CreateToggle(MovementTabPage, "Kinetic Flight", State.Flying, function(activeState)
    State.Flying = activeState
    if activeState then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            FlyVel = Instance.new("BodyVelocity")
            FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            FlyVel.Parent = root

            FlyGyro = Instance.new("BodyGyro")
            FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            FlyGyro.Parent = root

            task.spawn(function()
                while State.Flying and character and root:FindFirstChild("BodyVelocity") do
                    local camera = workspace.CurrentCamera
                    local moveDirection = Vector3.zero

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end

                    FlyVel.Velocity = moveDirection * State.FlySpeed
                    FlyGyro.CFrame = camera.CFrame
                    task.wait()
                end
            end)
        end
    else
        if FlyVel then FlyVel:Destroy() end
        if FlyGyro then FlyGyro:Destroy() end
    end
end)

CreateSlider(MovementTabPage, "Flight Speed", 20, 200, 50, function(value)
    State.FlySpeed = value
end)

CreateSectionLabel(MovementTabPage, "Speed & Jump")
CreateToggle(MovementTabPage, "WalkSpeed", State.WalkSpeed, function(activeState)
    State.WalkSpeed = activeState
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

CreateSlider(MovementTabPage, "Custom WalkSpeed", 16, 250, 24, function(value)
    State.SpeedValue = value
end)

CreateToggle(MovementTabPage, "Jump Power", State.JumpPower, function(activeState)
    State.JumpPower = activeState
    task.spawn(function()
        while State.JumpPower do
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = State.JumpValue
                end
            end)
            task.wait(0.2)
        end
    end)
end)

CreateSlider(MovementTabPage, "Jump Value", 50, 300, 100, function(value)
    State.JumpValue = value
end)

CreateToggle(MovementTabPage, "Infinite Jump", State.InfJump, function(activeState)
    State.InfJump = activeState
end)

RegisterConnection(UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

CreateSectionLabel(MovementTabPage, "Physics & Noclip")
CreateToggle(MovementTabPage, "Noclip", State.Noclip, function(activeState)
    State.Noclip = activeState
    task.spawn(function()
        while State.Noclip do
            pcall(function()
                if LocalPlayer.Character then
                    for _, childPart in pairs(LocalPlayer.Character:GetDescendants()) do
                        if childPart:IsA("BasePart") then
                            childPart.CanCollide = false
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

CreateToggle(MovementTabPage, "Gravity", State.GravityMod, function(activeState)
    State.GravityMod = activeState
    if not activeState then
        workspace.Gravity = 196.2
    end
    task.spawn(function()
        while State.GravityMod do
            workspace.Gravity = State.GravityVal
            task.wait(0.2)
        end
    end)
end)

CreateSlider(MovementTabPage, "Gravity Power", 0, 196, 196, function(value)
    State.GravityVal = value
end)

CreateToggle(MovementTabPage, "Spinbot", State.Spinbot, function(activeState)
    State.Spinbot = activeState
    task.spawn(function()
        while State.Spinbot do
            pcall(function()
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0)
                end
            end)
            task.wait()
        end
    end)
end)

CreateSlider(MovementTabPage, "Spinbot Speed", 10, 100, 30, function(value)
    State.SpinSpeed = value
end)

CreateToggle(MovementTabPage, "HipHeight", State.HipHeightMod, function(activeState)
    State.HipHeightMod = activeState
    task.spawn(function()
        while State.HipHeightMod do
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.HipHeight = State.HipHeightVal
                end
            end)
            task.wait(0.2)
        end
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HipHeight = 2
            end
        end)
    end)
end)

CreateSlider(MovementTabPage, "HipHeight Value", 0, 30, 2, function(value)
    State.HipHeightVal = value
end)

-- ==========================================
-- 4. UTILITY & AUTOMATION TAB
-- ==========================================
CreateSectionLabel(UtilityTabPage, "Protection")
CreateToggle(UtilityTabPage, "Anti Void", State.AntiVoid, function(activeState)
    State.AntiVoid = activeState
    task.spawn(function()
        while State.AntiVoid do
            pcall(function()
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart and rootPart.Position.Y < -50 then
                    rootPart.CFrame = CFrame.new(rootPart.Position.X, 50, rootPart.Position.Z)
                    rootPart.Velocity = Vector3.zero
                    Notify("ANTI-VOID", "Mencegah jatuh ke Void! Teleported safe.", 2)
                end
            end)
            task.wait(0.4)
        end
    end)
end)

CreateToggle(UtilityTabPage, "Anti AFK", State.AntiAFK, function(activeState)
    State.AntiAFK = activeState
    task.spawn(function()
        while State.AntiAFK do
            pcall(function()
                local camera = workspace.CurrentCamera
                if camera then
                    camera.CFrame = camera.CFrame * CFrame.Angles(0, 0.001, 0)
                    task.wait(0.05)
                    camera.CFrame = camera.CFrame * CFrame.Angles(0, -0.001, 0)
                end
            end)
            task.wait(30)
        end
    end)
end)

CreateSectionLabel(UtilityTabPage, "Clicker")
CreateToggle(UtilityTabPage, "Auto Clicker", State.AutoClicker, function(activeState)
    State.AutoClicker = activeState
    task.spawn(function()
        while State.AutoClicker do
            pcall(function()
                mouse1click()
            end)
            task.wait(1 / State.ClickerCPS)
        end
    end)
end)

CreateSlider(UtilityTabPage, "Clicker Speed", 1, 30, 10, function(value)
    State.ClickerCPS = value
end)

-- ==========================================
-- 5. VISUALS & ESP TAB
-- ==========================================
CreateSectionLabel(VisualTabPage, "ESP")

local function ApplyPlayerESP(targetPlayer)
    if targetPlayer == LocalPlayer or not targetPlayer.Character then return end
    
    if State.PlayerESP and not targetPlayer.Character:FindFirstChild("VoidHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "VoidHighlight"
        highlight.FillColor = C_ACCENT_CYAN
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = targetPlayer.Character
    end
end

CreateToggle(VisualTabPage, "Player ESP", State.PlayerESP, function(activeState)
    State.PlayerESP = activeState
    if activeState then
        for _, playerInstance in pairs(Players:GetPlayers()) do
            ApplyPlayerESP(playerInstance)
        end
        RegisterConnection(RunService.Heartbeat:Connect(function()
            if State.PlayerESP then
                for _, playerInstance in pairs(Players:GetPlayers()) do
                    ApplyPlayerESP(playerInstance)
                end
            end
        end))
    else
        for _, playerInstance in pairs(Players:GetPlayers()) do
            if playerInstance.Character and playerInstance.Character:FindFirstChild("VoidHighlight") then
                playerInstance.Character.VoidHighlight:Destroy()
            end
        end
    end
end)

-- ==========================================
-- 6. CAMERA & WORLD TAB
-- ==========================================
CreateSectionLabel(WorldTabPage, "World")
CreateToggle(WorldTabPage, "Fullbright", State.Fullbright, function(activeState)
    State.Fullbright = activeState
    if activeState then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(WorldTabPage, "Fog & Atmosphere", State.NoFog, function(activeState)
    State.NoFog = activeState
    if activeState then
        Lighting.FogEnd = 9e9
        for _, atmosphere in pairs(Lighting:GetChildren()) do
            if atmosphere:IsA("Atmosphere") then
                atmosphere.Density = 0
            end
        end
    end
end)

CreateSectionLabel(WorldTabPage, "Camera")
CreateToggle(WorldTabPage, "Field Of View", State.CustomFOV, function(activeState)
    State.CustomFOV = activeState
    if not activeState then
        workspace.CurrentCamera.FieldOfView = 70
    end
    task.spawn(function()
        while State.CustomFOV do
            workspace.CurrentCamera.FieldOfView = State.FOVValue
            task.wait(0.2)
        end
    end)
end)

CreateSlider(WorldTabPage, "FOV Angle Range", 50, 120, 70, function(value)
    State.FOVValue = value
end)

-- ==========================================
-- 7. SERVER FINDER TAB
-- ==========================================
CreateSectionLabel(ServerTabPage, "Server")
CreateButton(ServerTabPage, "Rejoin", function() RejoinServer() end)
CreateButton(ServerTabPage, "Server Hop", function() ServerHop() end)

CreateSectionLabel(ServerTabPage, "Server 1 Player")

local ServerListScroll = Instance.new("ScrollingFrame")
ServerListScroll.Name = "ServerListScroll"
ServerListScroll.Size = UDim2.new(1, -6, 0, 220)
ServerListScroll.BackgroundTransparency = 1
ServerListScroll.ScrollBarThickness = 3
ServerListScroll.ScrollBarImageColor3 = C_ACCENT_CYAN
ServerListScroll.ZIndex = 13
ServerListScroll.Parent = ServerTabPage

local ServerListLayout = Instance.new("UIListLayout")
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ServerListLayout.Padding = UDim.new(0, 6)
ServerListLayout.Parent = ServerListScroll

local function ScanSoloServers()
    for _, childFrame in pairs(ServerListScroll:GetChildren()) do
        if childFrame:IsA("Frame") or childFrame:IsA("TextLabel") then
            childFrame:Destroy()
        end
    end

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Scanning public servers with exactly 1 player..."
    statusLabel.TextColor3 = C_SUBTEXT
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = ServerListScroll

    task.spawn(function()
        pcall(function()
            local requestUrl = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            local responseData = game:HttpGet(requestUrl)
            local decodedData = HttpService:JSONDecode(responseData)
            statusLabel:Destroy()

            local foundServerCount = 0
            if decodedData and decodedData.data then
                for _, serverData in pairs(decodedData.data) do
                    if serverData.playing == 1 and serverData.id ~= game.JobId then
                        foundServerCount = foundServerCount + 1

                        local serverCard = Instance.new("Frame")
                        serverCard.Size = UDim2.new(1, 0, 0, 40)
                        serverCard.BackgroundColor3 = C_ITEM
                        serverCard.ZIndex = 14
                        serverCard.Parent = ServerListScroll

                        local serverCardCorner = Instance.new("UICorner")
                        serverCardCorner.CornerRadius = UDim.new(0, 6)
                        serverCardCorner.Parent = serverCard

                        local serverInfoText = Instance.new("TextLabel")
                        serverInfoText.Size = UDim2.new(1, -110, 1, 0)
                        serverInfoText.Position = UDim2.new(0, 10, 0, 0)
                        serverInfoText.BackgroundTransparency = 1
                        serverInfoText.Text = "Server: " .. string.sub(serverData.id, 1, 12) .. "... [" .. serverData.playing .. "/" .. serverData.maxPlayers .. " Player]"
                        serverInfoText.TextColor3 = C_TEXT
                        serverInfoText.TextSize = 10
                        serverInfoText.Font = Enum.Font.GothamMedium
                        serverInfoText.TextXAlignment = Enum.TextXAlignment.Left
                        serverInfoText.ZIndex = 15
                        serverInfoText.Parent = serverCard

                        local joinButton = Instance.new("TextButton")
                        joinButton.Size = UDim2.new(0, 85, 0, 24)
                        joinButton.Position = UDim2.new(1, -92, 0.5, -12)
                        joinButton.BackgroundColor3 = C_ACCENT_CYAN
                        joinButton.Text = "JOIN SERVER"
                        joinButton.TextColor3 = C_BG
                        joinButton.TextSize = 9
                        joinButton.Font = Enum.Font.GothamBold
                        joinButton.ZIndex = 15
                        joinButton.Parent = serverCard

                        local joinBtnCorner = Instance.new("UICorner")
                        joinBtnCorner.CornerRadius = UDim.new(0, 5)
                        joinBtnCorner.Parent = joinButton

                        joinButton.MouseButton1Click:Connect(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.id, LocalPlayer)
                        end)
                    end
                end
            end

            if foundServerCount == 0 then
                local emptyLabel = Instance.new("TextLabel")
                emptyLabel.Size = UDim2.new(1, 0, 0, 25)
                emptyLabel.BackgroundTransparency = 1
                emptyLabel.Text = "Tidak ditemukan server publik dengan 1 player. Coba lagi!"
                emptyLabel.TextColor3 = C_SUBTEXT
                emptyLabel.TextSize = 10
                emptyLabel.Font = Enum.Font.Gotham
                emptyLabel.Parent = ServerListScroll
            end
        end)
    end)
end

CreateButton(ServerTabPage, "Scan Server 1 Player", function() ScanSoloServers() end)

-- ==========================================
-- 8. PLAYER LIST TAB
-- ==========================================
CreateSectionLabel(PlayersTabPage, "Active Players In Server")

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Name = "PlayerListScroll"
PlayerListScroll.Size = UDim2.new(1, -6, 0, 220)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = C_ACCENT_CYAN
PlayerListScroll.ZIndex = 13
PlayerListScroll.Parent = PlayersTabPage

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.Parent = PlayerListScroll

local function RenderPlayerList()
    for _, childFrame in pairs(PlayerListScroll:GetChildren()) do
        if childFrame:IsA("Frame") then
            childFrame:Destroy()
        end
    end

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer then
            local playerCard = Instance.new("Frame")
            playerCard.Size = UDim2.new(1, 0, 0, 42)
            playerCard.BackgroundColor3 = C_ITEM
            playerCard.ZIndex = 14
            playerCard.Parent = PlayerListScroll

            local cardCorner = Instance.new("UICorner")
            cardCorner.CornerRadius = UDim.new(0, 6)
            cardCorner.Parent = playerCard

            local avatarImage = Instance.new("ImageLabel")
            avatarImage.Size = UDim2.new(0, 30, 0, 30)
            avatarImage.Position = UDim2.new(0, 6, 0.5, -15)
            avatarImage.BackgroundTransparency = 1
            avatarImage.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            avatarImage.ZIndex = 15
            avatarImage.Parent = playerCard

            local avatarCorner = Instance.new("UICorner")
            avatarCorner.CornerRadius = UDim.new(1, 0)
            avatarCorner.Parent = avatarImage

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -140, 1, 0)
            nameLabel.Position = UDim2.new(0, 42, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")"
            nameLabel.TextColor3 = C_TEXT
            nameLabel.TextSize = 10
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 15
            nameLabel.Parent = playerCard

            local tpButton = Instance.new("TextButton")
            tpButton.Size = UDim2.new(0, 85, 0, 24)
            tpButton.Position = UDim2.new(1, -92, 0.5, -12)
            tpButton.BackgroundColor3 = C_ACCENT_CYAN
            tpButton.Text = "TP TO PLAYER"
            tpButton.TextColor3 = C_BG
            tpButton.TextSize = 9
            tpButton.Font = Enum.Font.GothamBold
            tpButton.ZIndex = 15
            tpButton.Parent = playerCard

            local tpBtnCorner = Instance.new("UICorner")
            tpBtnCorner.CornerRadius = UDim.new(0, 5)
            tpBtnCorner.Parent = tpButton

            tpButton.MouseButton1Click:Connect(function()
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    Notify("TELEPORT", "Teleported to " .. targetPlayer.DisplayName, 2)
                end
            end)
        end
    end
end

CreateSectionLabel(PlayersTabPage, "Click TeleporT")
CreateToggle(PlayersTabPage, "Teleport (Shift + Left Click)", State.ClickTP, function(activeState)
    State.ClickTP = activeState
end)

RegisterConnection(UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
    if not gameProcessed and State.ClickTP and inputObject.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end))

RegisterConnection(Players.PlayerAdded:Connect(RenderPlayerList))
RegisterConnection(Players.PlayerRemoving:Connect(RenderPlayerList))
RenderPlayerList()

-- ==========================================
-- 9. SETTINGS & LOGS TAB
-- ==========================================
CreateSectionLabel(SettingsTabPage, "System Console")

local LogDisplayFrame = Instance.new("ScrollingFrame")
LogDisplayFrame.Name = "LogDisplayFrame"
LogDisplayFrame.Size = UDim2.new(1, -6, 0, 180)
LogDisplayFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
LogDisplayFrame.BorderSizePixel = 0
LogDisplayFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogDisplayFrame.ScrollBarThickness = 3
LogDisplayFrame.ScrollBarImageColor3 = C_ACCENT_CYAN
LogDisplayFrame.ZIndex = 13
LogDisplayFrame.Parent = SettingsTabPage

local LogDisplayCorner = Instance.new("UICorner")
LogDisplayCorner.CornerRadius = UDim.new(0, 6)
LogDisplayCorner.Parent = LogDisplayFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 4)
LogLayout.Parent = LogDisplayFrame

local LogPadding = Instance.new("UIPadding")
LogPadding.PaddingTop = UDim.new(0, 6)
LogPadding.PaddingLeft = UDim.new(0, 8)
LogPadding.PaddingRight = UDim.new(0, 8)
LogPadding.Parent = LogDisplayFrame

local function RefreshLogsDisplay()
    for _, child in pairs(LogDisplayFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, logText in ipairs(State.SystemLogs) do
        local logLabel = Instance.new("TextLabel")
        logLabel.Size = UDim2.new(1, 0, 0, 16)
        logLabel.BackgroundTransparency = 1
        logLabel.Text = logText
        logLabel.TextColor3 = C_ACCENT_GREEN
        logLabel.TextSize = 9
        logLabel.Font = Enum.Font.Code
        logLabel.TextXAlignment = Enum.TextXAlignment.Left
        logLabel.ZIndex = 14
        logLabel.Parent = LogDisplayFrame
    end
end

CreateButton(SettingsTabPage, "Refresh Logs", function() RefreshLogsDisplay() end)
CreateButton(SettingsTabPage, "Clear Logs", function()
    State.SystemLogs = {}
    RefreshLogsDisplay()
    Notify("LOGS", "History Logs dibersihkan.", 2)
end)

CreateSectionLabel(SettingsTabPage, "Script Unload")
CreateButton(SettingsTabPage, "Unload VoidHub", function()
    if _G.VoidHubSupremeConnections then
        for _, conn in pairs(_G.VoidHubSupremeConnections) do
            if conn.Connected then conn:Disconnect() end
        end
    end
    VoidHubUI:Destroy()
    print("[VOIDHUB]: Unloaded successfully.")
end)

AddLog("VoidHub Supreme Engine initialized.")
print("[VOIDHUB v1.0] LOADED SUCCESSFULLY!")
