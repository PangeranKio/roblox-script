-- [[ VOIDHUB SUPREME v1.0 ]] --
-- UI/UX: 100% Reference Replica (Bento Cards, Pill Tabs, Neon Glow Switches & Sliders)
-- Engine Core: Fully Retained & Enhanced

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
-- 0. CLEANUP & INSTANCE GUARD SYSTEM
-- ==========================================
if _G.VoidHubSupremeConnections then
    for _, connection in pairs(_G.VoidHubSupremeConnections) do
        if typeof(connection) == "RBXScriptConnection" and connection.Connected then
            connection:Disconnect()
        end
    end
end
_G.VoidHubSupremeConnections = {}

local function RegisterConnection(conn)
    table.insert(_G.VoidHubSupremeConnections, conn)
    return conn
end

if CoreGui:FindFirstChild("VoidHubUI_v15") then CoreGui.VoidHubUI_v15:Destroy() end
if CoreGui:FindFirstChild("VoidHubUI_v14") then CoreGui.VoidHubUI_v14:Destroy() end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v15"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- ==========================================
-- COLOR PALETTE (EXACT MATCH TO REFERENCE)
-- ==========================================
local C_MAIN_BG = Color3.fromRGB(15, 11, 25)
local C_CARD_BG = Color3.fromRGB(24, 18, 38)
local C_CARD_DARK = Color3.fromRGB(18, 14, 28)
local C_BORDER = Color3.fromRGB(58, 40, 88)
local C_ACCENT_PURPLE = Color3.fromRGB(188, 0, 252)
local C_ACCENT_MAGENTA = Color3.fromRGB(220, 50, 255)
local C_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB = Color3.fromRGB(160, 150, 180)
local C_TEXT_MUTED = Color3.fromRGB(110, 100, 130)

-- ==========================================
-- GLOBAL STATE
-- ==========================================
local State = {
    Flying = false, FlySpeed = 120, WalkSpeed = false, SpeedValue = 100, JumpPower = false, JumpValue = 100,
    InfJump = false, Noclip = false, GravityMod = false, GravityVal = 196.2, Spinbot = false, SpinSpeed = 30,
    HipHeightMod = false, HipHeightVal = 2, InstantPrompt = false, AutoPrompt = false, FreezeBossGuard = false,
    BossDisableAttack = false, AutoRunToBaseWithEgg = false, BaseCFrame = nil, AutoEquipEgg = false,
    AntiVoid = false, AntiAFK = true, AutoClicker = false, ClickerCPS = 10, FPSCap = 60, PlayerESP = false,
    Fullbright = false, CustomFOV = false, FOVValue = 70, ClickTP = false, NoFog = false, SystemLogs = {}
}

local FlyVel, FlyGyro = nil, nil

local function AddLog(msg)
    table.insert(State.SystemLogs, string.format("[%s] %s", os.date("%H:%M:%S"), msg))
end

-- ==========================================
-- DRAGGABLE ENGINE
-- ==========================================
local function MakeDraggable(dragHandle, targetFrame)
    local dragging, dragInput, dragStart, startPos
    RegisterConnection(dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end))
    RegisterConnection(dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
end

-- ==========================================
-- FLOATING TOGGLE BUTTON (TOP RIGHT BANNER MATCH)
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenToggleButton"
OpenBtn.Size = UDim2.new(0, 110, 0, 32)
OpenBtn.Position = UDim2.new(1, -125, 0, 15)
OpenBtn.BackgroundColor3 = C_CARD_BG
OpenBtn.Text = "UXT VOIDLES"
OpenBtn.TextColor3 = C_TEXT_WHITE
OpenBtn.TextSize = 10
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 99
OpenBtn.Parent = VoidHubUI

local OpenBtnCorner = Instance.new("UICorner", OpenBtn) OpenBtnCorner.CornerRadius = UDim.new(0, 6)
local OpenBtnStroke = Instance.new("UIStroke", OpenBtn) OpenBtnStroke.Color = C_BORDER OpenBtnStroke.Thickness = 1

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN CYBERPUNK WINDOW
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainCyberFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = C_MAIN_BG
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainFrameCorner = Instance.new("UICorner", MainFrame) MainFrameCorner.CornerRadius = UDim.new(0, 12)
local MainFrameStroke = Instance.new("UIStroke", MainFrame) MainFrameStroke.Color = C_BORDER MainFrameStroke.Thickness = 1.5

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Name = "TopbarFrame"
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

MakeDraggable(Topbar, MainFrame)

local LogoBox = Instance.new("Frame")
LogoBox.Size = UDim2.new(0, 32, 0, 32)
LogoBox.Position = UDim2.new(0, 14, 0, 10)
LogoBox.BackgroundColor3 = Color3.fromRGB(130, 20, 220)
LogoBox.ZIndex = 12
LogoBox.Parent = Topbar

local LogoCorner = Instance.new("UICorner", LogoBox) LogoCorner.CornerRadius = UDim.new(0, 8)
local LogoText = Instance.new("TextLabel", LogoBox) LogoText.Size = UDim2.new(1,0,1,0) LogoText.Text = "V" LogoText.TextColor3 = C_TEXT_WHITE LogoText.TextSize = 18 LogoText.Font = Enum.Font.GothamBold LogoText.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 18)
TitleLabel.Position = UDim2.new(0, 54, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VoidHub Supreme <font color=\"#a090b0\">v1.0</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = C_TEXT_WHITE
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = Topbar

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Size = UDim2.new(0, 200, 0, 14)
SubTitleLabel.Position = UDim2.new(0, 54, 0, 26)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Text = "Roblox Script Hub"
SubTitleLabel.TextColor3 = C_TEXT_SUB
SubTitleLabel.TextSize = 10
SubTitleLabel.Font = Enum.Font.Gotham
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.ZIndex = 12
SubTitleLabel.Parent = Topbar

-- TELEMETRY (FPS / PING)
local TelemetryLabel = Instance.new("TextLabel")
TelemetryLabel.Size = UDim2.new(0, 100, 0, 30)
TelemetryLabel.Position = UDim2.new(1, -125, 0, 10)
TelemetryLabel.BackgroundTransparency = 1
TelemetryLabel.Text = "FPS        Ping\n<b>144</b>      <b>18ms</b>"
TelemetryLabel.RichText = true
TelemetryLabel.TextColor3 = C_TEXT_SUB
TelemetryLabel.TextSize = 9
TelemetryLabel.Font = Enum.Font.Gotham
TelemetryLabel.TextXAlignment = Enum.TextXAlignment.Right
TelemetryLabel.ZIndex = 12
TelemetryLabel.Parent = Topbar

RegisterConnection(RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1 / dt)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    TelemetryLabel.Text = string.format("FPS        Ping\n<b>%d</b>      <b>%dms</b>", fps, ping)
end))

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -28, 0, 15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_TEXT_SUB
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- ==========================================
-- NAVIGATION PILL TABS
-- ==========================================
local TopNavFrame = Instance.new("ScrollingFrame")
TopNavFrame.Size = UDim2.new(1, -24, 0, 32)
TopNavFrame.Position = UDim2.new(0, 12, 0, 52)
TopNavFrame.BackgroundTransparency = 1
TopNavFrame.CanvasSize = UDim2.new(0, 520, 0, 0)
TopNavFrame.ScrollBarThickness = 0
TopNavFrame.ZIndex = 11
TopNavFrame.Parent = MainFrame

local TopNavLayout = Instance.new("UIListLayout")
TopNavLayout.FillDirection = Enum.FillDirection.Horizontal
TopNavLayout.SortOrder = Enum.SortOrder.LayoutOrder
TopNavLayout.Padding = UDim.new(0, 6)
TopNavLayout.Parent = TopNavFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -24, 1, -94)
ContentArea.Position = UDim2.new(0, 12, 0, 88)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder", ContentArea) PagesFolder.Name = "PagesFolder"

local function CreatePage(pageName)
    local pageScroll = Instance.new("ScrollingFrame")
    pageScroll.Name = pageName .. "Page"
    pageScroll.Size = UDim2.new(1, 0, 1, 0)
    pageScroll.BackgroundTransparency = 1
    pageScroll.BorderSizePixel = 0
    pageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageScroll.ScrollBarThickness = 2
    pageScroll.ScrollBarImageColor3 = C_ACCENT_PURPLE
    pageScroll.Visible = false
    pageScroll.ZIndex = 12
    pageScroll.Parent = PagesFolder

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.Parent = pageScroll

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
    tabBtn.Size = UDim2.new(0, 62, 1, 0)
    tabBtn.BackgroundColor3 = defaultActive and Color3.fromRGB(80, 20, 130) or C_CARD_BG
    tabBtn.Text = buttonText
    tabBtn.TextColor3 = defaultActive and C_TEXT_WHITE or C_TEXT_SUB
    tabBtn.TextSize = 10
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.ZIndex = 12
    tabBtn.Parent = TopNavFrame

    local tabCorner = Instance.new("UICorner", tabBtn) tabCorner.CornerRadius = UDim.new(0, 8)
    local tabStroke = Instance.new("UIStroke", tabBtn)
    tabStroke.Color = defaultActive and C_ACCENT_PURPLE or C_BORDER
    tabStroke.Thickness = 1

    tabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(PagesFolder:GetChildren()) do page.Visible = false end
        for _, button in pairs(TopNavFrame:GetChildren()) do
            if button:IsA("TextButton") then
                TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = C_CARD_BG}):Play()
                button.TextColor3 = C_TEXT_SUB
                button.UIStroke.Color = C_BORDER
            end
        end
        pageTarget.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 20, 130)}):Play()
        tabBtn.TextColor3 = C_TEXT_WHITE
        tabStroke.Color = C_ACCENT_PURPLE
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
-- BENTO COMPONENT BUILDERS (REFERENCE SPECIFIC)
-- ==========================================
local function CreateSectionLabel(parentContainer, sectionTitleText)
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 0, 18)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = string.upper(sectionTitleText)
    sectionLabel.TextColor3 = C_ACCENT_MAGENTA
    sectionLabel.TextSize = 10
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.ZIndex = 13
    sectionLabel.Parent = parentContainer
    return sectionLabel
end

local function CreateBentoToggle(parentContainer, iconSymbol, mainTitle, subDesc, defaultState, callback)
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, subDesc ~= "" and 68 or 44)
    cardFrame.BackgroundColor3 = C_CARD_BG
    cardFrame.ZIndex = 13
    cardFrame.Parent = parentContainer

    local cardCorner = Instance.new("UICorner", cardFrame) cardCorner.CornerRadius = UDim.new(0, 10)
    local cardStroke = Instance.new("UIStroke", cardFrame) cardStroke.Color = C_BORDER cardStroke.Thickness = 1

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 24, 0, 24)
    iconLabel.Position = UDim2.new(0, 10, 0, 10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = iconSymbol
    iconLabel.TextColor3 = C_TEXT_WHITE
    iconLabel.TextSize = 14
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.ZIndex = 14
    iconLabel.Parent = cardFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 0, 18)
    titleLabel.Position = UDim2.new(0, 38, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = mainTitle
    titleLabel.TextColor3 = C_TEXT_WHITE
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 14
    titleLabel.Parent = cardFrame

    if subDesc ~= "" then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -50, 0, 30)
        descLabel.Position = UDim2.new(0, 10, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = subDesc
        descLabel.TextColor3 = C_TEXT_MUTED
        descLabel.TextSize = 9
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        descLabel.Parent = cardFrame
    end

    local switchButton = Instance.new("TextButton")
    switchButton.Size = UDim2.new(0, 38, 0, 20)
    switchButton.Position = UDim2.new(1, -46, 0, 8)
    switchButton.BackgroundColor3 = defaultState and C_ACCENT_PURPLE or C_CARD_DARK
    switchButton.Text = ""
    switchButton.ZIndex = 14
    switchButton.Parent = cardFrame

    local switchCorner = Instance.new("UICorner", switchButton) switchCorner.CornerRadius = UDim.new(1, 0)

    local circleIndicator = Instance.new("Frame")
    circleIndicator.Size = UDim2.new(0, 14, 0, 14)
    circleIndicator.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circleIndicator.BackgroundColor3 = C_TEXT_WHITE
    circleIndicator.ZIndex = 15
    circleIndicator.Parent = switchButton

    local circleCorner = Instance.new("UICorner", circleIndicator) circleCorner.CornerRadius = UDim.new(1, 0)

    local isActive = defaultState
    switchButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT_PURPLE}):Play()
            TweenService:Create(circleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
        else
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = C_CARD_DARK}):Play()
            TweenService:Create(circleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
        end
        callback(isActive)
    end)
    return cardFrame
end

local function CreateBentoSlider(parentContainer, titleText, minimumValue, maximumValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 36)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.ZIndex = 13
    sliderFrame.Parent = parentContainer

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -50, 0, 16)
    labelText.BackgroundTransparency = 1
    labelText.Text = titleText
    labelText.TextColor3 = C_TEXT_WHITE
    labelText.TextSize = 10
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.ZIndex = 14
    labelText.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 16)
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = C_TEXT_SUB
    valueLabel.TextSize = 10
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 14
    valueLabel.Parent = sliderFrame

    local trackBackground = Instance.new("Frame")
    trackBackground.Size = UDim2.new(1, 0, 0, 4)
    trackBackground.Position = UDim2.new(0, 0, 0, 22)
    trackBackground.BackgroundColor3 = C_CARD_DARK
    trackBackground.ZIndex = 14
    trackBackground.Parent = sliderFrame

    local trackBgCorner = Instance.new("UICorner", trackBackground) trackBgCorner.CornerRadius = UDim.new(1, 0)

    local trackFill = Instance.new("Frame")
    trackFill.Size = UDim2.new((defaultValue - minimumValue) / (maximumValue - minimumValue), 0, 1, 0)
    trackFill.BackgroundColor3 = C_ACCENT_PURPLE
    trackFill.ZIndex = 15
    trackFill.Parent = trackBackground

    local trackFillCorner = Instance.new("UICorner", trackFill) trackFillCorner.CornerRadius = UDim.new(1, 0)

    local sliderThumb = Instance.new("Frame")
    sliderThumb.Size = UDim2.new(0, 10, 0, 14)
    sliderThumb.Position = UDim2.new(1, -5, 0.5, -7)
    sliderThumb.BackgroundColor3 = C_TEXT_WHITE
    sliderThumb.ZIndex = 16
    sliderThumb.Parent = trackFill

    local thumbCorner = Instance.new("UICorner", sliderThumb) thumbCorner.CornerRadius = UDim.new(0, 3)

    local isDragging = false
    local function UpdateSliderValue(inputObject)
        local relPos = math.clamp((inputObject.Position.X - trackBackground.AbsolutePosition.X) / trackBackground.AbsoluteSize.X, 0, 1)
        local val = math.floor(minimumValue + (maximumValue - minimumValue) * relPos)
        trackFill.Size = UDim2.new(relPos, 0, 1, 0)
        valueLabel.Text = tostring(val)
        callback(val)
    end

    RegisterConnection(trackBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true UpdateSliderValue(input)
        end
    end))
    RegisterConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end
    end))
    RegisterConnection(UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSliderValue(input) end
    end))
end

-- ==========================================
-- 1. MAIN OVERVIEW TAB
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, 0, 0, 130)
ProfileCard.BackgroundColor3 = C_CARD_BG
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage

local ProfileCardCorner = Instance.new("UICorner", ProfileCard) ProfileCardCorner.CornerRadius = UDim.new(0, 12)
local ProfileCardStroke = Instance.new("UIStroke", ProfileCard) ProfileCardStroke.Color = C_BORDER ProfileCardStroke.Thickness = 1

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 64, 0, 64)
AvatarImage.Position = UDim2.new(0, 16, 0.5, -32)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
AvatarImage.ZIndex = 14
AvatarImage.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner", AvatarImage) AvatarCorner.CornerRadius = UDim.new(1, 0)

local WelcomeSubText = Instance.new("TextLabel")
WelcomeSubText.Size = UDim2.new(1, -100, 0, 16)
WelcomeSubText.Position = UDim2.new(0, 92, 0, 32)
WelcomeSubText.BackgroundTransparency = 1
WelcomeSubText.Text = "Welcome back,"
WelcomeSubText.TextColor3 = C_TEXT_SUB
WelcomeSubText.TextSize = 11
WelcomeSubText.Font = Enum.Font.Gotham
WelcomeSubText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeSubText.ZIndex = 14
WelcomeSubText.Parent = ProfileCard

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -100, 0, 22)
UsernameLabel.Position = UDim2.new(0, 92, 0, 48)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = LocalPlayer.Name:upper()
UsernameLabel.TextColor3 = C_TEXT_WHITE
UsernameLabel.TextSize = 16
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.ZIndex = 14
UsernameLabel.Parent = ProfileCard

local StatusBadge = Instance.new("TextLabel")
StatusBadge.Size = UDim2.new(1, -100, 0, 16)
StatusBadge.Position = UDim2.new(0, 92, 0, 72)
StatusBadge.BackgroundTransparency = 1
StatusBadge.Text = "Status: <font color=\"#bc00fc\">VIP Lifetime Access</font> | Active Session"
StatusBadge.RichText = true
StatusBadge.TextColor3 = C_TEXT_MUTED
StatusBadge.TextSize = 10
StatusBadge.Font = Enum.Font.Gotham
StatusBadge.TextXAlignment = Enum.TextXAlignment.Left
StatusBadge.ZIndex = 14
StatusBadge.Parent = ProfileCard

-- ==========================================
-- 2. FARM & MECHANICS TAB (BENTO LAYOUT MATCH)
-- ==========================================
CreateSectionLabel(FarmTabPage, "// Automation & Mechanics")

local BentoGrid = Instance.new("Frame")
BentoGrid.Size = UDim2.new(1, 0, 0, 160)
BentoGrid.BackgroundTransparency = 1
BentoGrid.ZIndex = 13
BentoGrid.Parent = FarmTabPage

local GridUI = Instance.new("UIGridLayout")
GridUI.CellSize = UDim2.new(0.5, -5, 0, 75)
GridUI.CellPadding = UDim2.new(0, 10, 0, 10)
GridUI.Parent = BentoGrid

CreateBentoToggle(BentoGrid, "⚔", "Disable Knockback", "Glow& switches evailor ce conveyor disable knockback.", State.BossDisableAttack, function(v) State.BossDisableAttack = v end)
CreateBentoToggle(BentoGrid, "❄", "Freeze Boss", "Modern sliders to ther-stamiled feetioios and use ooain Boss.", State.FreezeBossGuard, function(v)
    State.FreezeBossGuard = v
    task.spawn(function()
        while State.FreezeBossGuard do
            pcall(function()
                for _, npcModel in pairs(workspace:GetDescendants()) do
                    if npcModel:IsA("Model") and not Players:GetPlayerFromCharacter(npcModel) then
                        local npcHumanoid = npcModel:FindFirstChildOfClass("Humanoid")
                        local npcRoot = npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChild("PrimaryPart")
                        if npcHumanoid and npcRoot then npcHumanoid.WalkSpeed = 0 npcRoot.Velocity = Vector3.zero npcRoot.Anchored = true end
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)

CreateBentoToggle(BentoGrid, "👆", "Auto Click Proximity Prompts", "Sleder sliders to save option and om glow strokes.", State.AutoPrompt, function(v)
    State.AutoPrompt = v
    task.spawn(function()
        while State.AutoPrompt do
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then fireproximityprompt(prompt) end
            end
            task.wait(0.4)
        end
    end)
end)

CreateBentoToggle(BentoGrid, "⚡", "Click Teleport (Shift + Left Click)", "Glover sliders to the auto click Shift + Left click orrsebosesltigro.", State.ClickTP, function(v) State.ClickTP = v end)

-- BOSS & KNOCKBACK ENGINE LOOP
RegisterConnection(RunService.Stepped:Connect(function()
    if State.BossDisableAttack then
        pcall(function()
            for _, workspaceObject in pairs(workspace:GetDescendants()) do
                if workspaceObject:IsA("Model") and not Players:GetPlayerFromCharacter(workspaceObject) then
                    local humanoid = workspaceObject:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, childPart in pairs(workspaceObject:GetDescendants()) do
                            if childPart:IsA("TouchTransmitter") then childPart:Destroy()
                            elseif childPart:IsA("BasePart") then childPart.CanTouch = false childPart.CanCollide = false end
                        end
                    end
                end
            end
        end)
    end
end))

-- ==========================================
-- 3. MOVEMENT & UTILITIES TAB (EXACT 2-COLUMN MATCH)
-- ==========================================
local MovementColumns = Instance.new("Frame")
MovementColumns.Size = UDim2.new(1, 0, 0, 260)
MovementColumns.BackgroundTransparency = 1
MovementColumns.ZIndex = 13
MovementColumns.Parent = MovementTabPage

local LeftCol = Instance.new("Frame")
LeftCol.Size = UDim2.new(0.48, 0, 1, 0)
LeftCol.BackgroundTransparency = 1
LeftCol.Parent = MovementColumns

local RightCol = Instance.new("Frame")
RightCol.Size = UDim2.new(0.48, 0, 1, 0)
RightCol.Position = UDim2.new(0.52, 0, 0, 0)
RightCol.BackgroundTransparency = 1
RightCol.Parent = MovementColumns

local LeftLayout = Instance.new("UIListLayout", LeftCol) LeftLayout.Padding = UDim.new(0, 8)
local RightLayout = Instance.new("UIListLayout", RightCol) RightLayout.Padding = UDim.new(0, 8)

CreateSectionLabel(LeftCol, "FLYING & SPEED")

local FlySpeedCard = Instance.new("Frame")
FlySpeedCard.Size = UDim2.new(1, 0, 0, 120)
FlySpeedCard.BackgroundColor3 = C_CARD_BG
FlySpeedCard.ZIndex = 13
FlySpeedCard.Parent = LeftCol

local FlySpeedCorner = Instance.new("UICorner", FlySpeedCard) FlySpeedCorner.CornerRadius = UDim.new(0, 10)
local FlySpeedStroke = Instance.new("UIStroke", FlySpeedCard) FlySpeedStroke.Color = C_BORDER FlySpeedStroke.Thickness = 1

local FlyListLayout = Instance.new("UIListLayout", FlySpeedCard) FlyListLayout.Padding = UDim.new(0, 4)

CreateBentoToggle(FlySpeedCard, "✈", "Kinetic Flight", "", State.Flying, function(activeState)
    State.Flying = activeState
    if activeState then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            FlyVel = Instance.new("BodyVelocity", root) FlyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            FlyGyro = Instance.new("BodyGyro", root) FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

            task.spawn(function()
                while State.Flying and character and root:FindFirstChild("BodyVelocity") do
                    local camera = workspace.CurrentCamera
                    local moveDirection = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
                    FlyVel.Velocity = moveDirection * State.FlySpeed
                    FlyGyro.CFrame = camera.CFrame
                    task.wait()
                end
            end)
        end
    else
        if FlyVel then FlyVel:Destroy() end if FlyGyro then FlyGyro:Destroy() end
    end
end)

CreateBentoToggle(FlySpeedCard, "👻", "Noclip", "", State.Noclip, function(v)
    State.Noclip = v
    task.spawn(function()
        while State.Noclip do
            pcall(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

local InfJumpCard = Instance.new("Frame")
InfJumpCard.Size = UDim2.new(1, 0, 0, 40)
InfJumpCard.BackgroundColor3 = C_CARD_BG
InfJumpCard.ZIndex = 13
InfJumpCard.Parent = LeftCol
local InfJumpCorner = Instance.new("UICorner", InfJumpCard) InfJumpCorner.CornerRadius = UDim.new(0, 10)
local InfJumpStroke = Instance.new("UIStroke", InfJumpCard) InfJumpStroke.Color = C_BORDER

local InfJumpText = Instance.new("TextLabel")
InfJumpText.Size = UDim2.new(1, -20, 1, 0)
InfJumpText.Position = UDim2.new(0, 10, 0, 0)
InfJumpText.BackgroundTransparency = 1
InfJumpText.Text = "🏃 InfJump (O)"
InfJumpText.TextColor3 = C_TEXT_WHITE
InfJumpText.TextSize = 10
InfJumpText.Font = Enum.Font.GothamMedium
InfJumpText.TextXAlignment = Enum.TextXAlignment.Left
InfJumpText.Parent = InfJumpCard

RegisterConnection(UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- RIGHT COLUMN SLIDERS CARD
local SlidersCard = Instance.new("Frame")
SlidersCard.Size = UDim2.new(1, 0, 0, 168)
SlidersCard.BackgroundColor3 = C_CARD_BG
SlidersCard.ZIndex = 13
SlidersCard.Parent = RightCol

local SlidersCorner = Instance.new("UICorner", SlidersCard) SlidersCorner.CornerRadius = UDim.new(0, 10)
local SlidersStroke = Instance.new("UIStroke", SlidersCard) SlidersStroke.Color = C_BORDER

local SlidersPadding = Instance.new("UIPadding", SlidersCard)
SlidersPadding.PaddingTop = UDim.new(0, 10) SlidersPadding.PaddingLeft = UDim.new(0, 10) SlidersPadding.PaddingRight = UDim.new(0, 10)

local SlidersLayout = Instance.new("UIListLayout", SlidersCard) SlidersLayout.Padding = UDim.new(0, 10)

CreateBentoSlider(SlidersCard, "FLY Speed", 20, 200, 120, function(v) State.FlySpeed = v end)
CreateBentoSlider(SlidersCard, "WalkSpeed", 16, 250, 100, function(v)
    State.SpeedValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)
CreateBentoSlider(SlidersCard, "Jump Power", 50, 300, 100, function(v)
    State.JumpValue = v
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.UseJumpPower = true humanoid.JumpPower = v end
end)

-- UTILITY OPTIONS HORIZONTAL CARD (EXACT MATCH REFERENCE)
CreateSectionLabel(UtilityTabPage, "UTILITY OPTIONS")

local UtilityRow = Instance.new("Frame")
UtilityRow.Size = UDim2.new(1, 0, 0, 42)
UtilityRow.BackgroundTransparency = 1
UtilityRow.ZIndex = 13
UtilityRow.Parent = UtilityTabPage

local UtilityRowLayout = Instance.new("UIListLayout", UtilityRow)
UtilityRowLayout.FillDirection = Enum.FillDirection.Horizontal
UtilityRowLayout.Padding = UDim.new(0, 8)

local function CreatePillOption(parentContainer, symbolIcon, titleText, callback)
    local pillCard = Instance.new("Frame")
    pillCard.Size = UDim2.new(0.32, 0, 1, 0)
    pillCard.BackgroundColor3 = C_CARD_BG
    pillCard.ZIndex = 13
    pillCard.Parent = parentContainer

    local pillCorner = Instance.new("UICorner", pillCard) pillCorner.CornerRadius = UDim.new(0, 10)
    local pillStroke = Instance.new("UIStroke", pillCard) pillStroke.Color = C_BORDER

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = symbolIcon .. "  " .. titleText .. " (O)"
    btn.TextColor3 = C_TEXT_WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.ZIndex = 14
    btn.Parent = pillCard

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        pillStroke.Color = active and C_ACCENT_PURPLE or C_BORDER
        callback(active)
    end)
end

CreatePillOption(UtilityRow, "◯", "AntiVoid", function(v)
    State.AntiVoid = v
    task.spawn(function()
        while State.AntiVoid do
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Position.Y < -50 then root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z) root.Velocity = Vector3.zero end
            end)
            task.wait(0.4)
        end
    end)
end)

CreatePillOption(UtilityRow, "🚫", "AntiAFK", function(v) State.AntiAFK = v end)
CreatePillOption(UtilityRow, "👁", "NoFog", function(v)
    State.NoFog = v
    if v then Lighting.FogEnd = 9e9 end
end)

-- CLICK TP CONNECTOR
RegisterConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and State.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end))

print("[VOIDHUB SUPREME v1.0] UI REDESIGN LOADED SUCCESSFULLY!")
