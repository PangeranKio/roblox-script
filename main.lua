-- [[ VOIDHUB SUPREME v13.0 - LUXURY EXECUTIVE EDITION ]] --
-- UI/UX Redesign: Bento Obsidian Glassmorphism with Liquid Gold Accents
-- Features: Announcement Board, Solo Server Finder, Mechanics, Utilities, & Camera Options

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

-- CLEANUP PREVIOUS INSTANCES
if CoreGui:FindFirstChild("VoidHubUI_v13") then
    CoreGui.VoidHubUI_v13:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v13"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- COLOR PALETTE (EXECUTIVE LUXURY)
local C_BG = Color3.fromRGB(8, 9, 12)
local C_PANEL = Color3.fromRGB(15, 17, 22)
local C_ACCENT = Color3.fromRGB(235, 185, 95)
local C_ACCENT_DARK = Color3.fromRGB(170, 125, 50)
local C_TEXT = Color3.fromRGB(245, 247, 250)
local C_SUBTEXT = Color3.fromRGB(135, 140, 155)
local C_ITEM = Color3.fromRGB(22, 25, 33)
local C_STROKE = Color3.fromRGB(40, 45, 58)

-- GLOBAL STATE MANAGER
local State = {
    Flying = false, FlySpeed = 50,
    WalkSpeed = false, SpeedValue = 24,
    JumpPower = false, JumpValue = 100,
    InfJump = false, Noclip = false,
    GravityMod = false, GravityVal = 196.2,
    Spinbot = false, SpinSpeed = 30,
    
    InstantPrompt = false, AutoPrompt = false, ReachMod = false,
    
    AntiVoid = false, AntiAFK = true, AutoClicker = false,
    AntiRagdoll = false, AutoRejoin = false,
    
    PlayerESP = false, HidePlayers = false,
    Fullbright = false, LowGraphics = false,
    CustomFOV = false, FOVValue = 70, ShiftLock = false,
    ClickTP = false
}

local ESPConnections = {}
local FlyVel, FlyGyro

-- DRAGGABLE ENGINE
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
            TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ==========================================
-- FLOATING TOGGLE BUTTON
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 125, 0, 36)
OpenBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenBtn.BackgroundColor3 = C_BG
OpenBtn.Text = "✧ VOIDHUB"
OpenBtn.TextColor3 = C_ACCENT
OpenBtn.TextSize = 12
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.ZIndex = 99
OpenBtn.Parent = VoidHubUI
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = C_ACCENT
OpenStroke.Thickness = 1
MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- MAIN EXECUTIVE WINDOW
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 470)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -235)
MainFrame.BackgroundColor3 = C_BG
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = C_STROKE

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 48)
Topbar.BackgroundColor3 = C_PANEL
Topbar.ZIndex = 11
Topbar.Parent = MainFrame
MakeDraggable(Topbar, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#EBB95F\">SUPREME v13.0</font>"
Title.RichText = true
Title.TextColor3 = C_TEXT
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundColor3 = C_ITEM
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C_SUBTEXT
CloseBtn.TextSize = 11
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

-- SIDEBAR NAV
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 165, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = C_PANEL
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout", Sidebar)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 5)

local NavPadding = Instance.new("UIPadding", Sidebar)
NavPadding.PaddingTop = UDim.new(0, 10)
NavPadding.PaddingLeft = UDim.new(0, 8)
NavPadding.PaddingRight = UDim.new(0, 8)

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -177, 1, -58)
ContentArea.Position = UDim2.new(0, 172, 0, 52)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local PagesFolder = Instance.new("Folder", ContentArea)

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -10, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = C_ACCENT
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
local ServerTabPage = CreatePage("Server")
local PlayersTabPage = CreatePage("Players")

MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = defaultActive and C_ACCENT or C_ITEM
    btn.Text = "  " .. text
    btn.TextColor3 = defaultActive and C_BG or C_SUBTEXT
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM}):Play()
                b.TextColor3 = C_SUBTEXT
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play()
        btn.TextColor3 = C_BG
    end)
end

CreateTabButton("Dashboard", MainTabPage, true)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Game Mechanics", MechanicsTabPage, false)
CreateTabButton("Utility & Auto", UtilityTabPage, false)
CreateTabButton("Visuals & ESP", VisualTabPage, false)
CreateTabButton("Camera & World", WorldTabPage, false)
CreateTabButton("Server Finder", ServerTabPage, false)
CreateTabButton("Player List", PlayersTabPage, false)

-- ==========================================
-- UI BUILDERS (TOGGLES, SLIDERS, BUTTONS)
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 38)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = C_STROKE
    stroke.Transparency = 0.8

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = C_TEXT
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -44, 0.5, -9)
    switch.BackgroundColor3 = defaultState and C_ACCENT or Color3.fromRGB(40, 45, 55)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = defaultState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    circle.BackgroundColor3 = defaultState and C_BG or C_TEXT
    circle.ZIndex = 15
    circle.Parent = switch
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = C_ACCENT}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -15, 0.5, -6), BackgroundColor3 = C_BG}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 45, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = C_TEXT}):Play()
        end
        callback(active)
    end)
end

local function CreateSlider(parent, titleText, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 50)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = C_TEXT
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 45, 0, 22)
    valLabel.Position = UDim2.new(1, -55, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(defaultVal)
    valLabel.TextColor3 = C_ACCENT
    valLabel.TextSize = 11
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.ZIndex = 14
    valLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 6)
    sliderBg.Position = UDim2.new(0, 12, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    sliderBg.ZIndex = 14
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = C_ACCENT
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

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
end

local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 36)
    btn.BackgroundColor3 = C_ITEM
    btn.Text = titleText
    btn.TextColor3 = C_TEXT
    btn.TextSize = 11
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
-- 1. DASHBOARD TAB
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -6, 0, 70)
ProfileCard.BackgroundColor3 = C_ITEM
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 50, 0, 50)
AvatarImg.Position = UDim2.new(0, 10, 0, 10)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
AvatarImg.ZIndex = 14
AvatarImg.Parent = ProfileCard
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -75, 0, 20)
WelcomeText.Position = UDim2.new(0, 70, 0, 14)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome back, <font color=\"#EBB95F\">" .. LocalPlayer.DisplayName .. "</font>"
WelcomeText.RichText = true
WelcomeText.TextColor3 = C_TEXT
WelcomeText.TextSize = 13
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.ZIndex = 14
WelcomeText.Parent = ProfileCard

local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, -75, 0, 18)
StatsText.Position = UDim2.new(0, 70, 0, 36)
StatsText.BackgroundTransparency = 1
StatsText.Text = "Tier: Executive  |  FPS: 60  |  Ping: 0 ms"
StatsText.TextColor3 = C_SUBTEXT
StatsText.TextSize = 10
StatsText.Font = Enum.Font.Gotham
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.ZIndex = 14
StatsText.Parent = ProfileCard

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1 / dt)
    local ping = 0
    pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    StatsText.Text = string.format("Tier: Executive  |  FPS: %d  |  Ping: %d ms", fps, ping)
end)

-- ANNOUNCEMENT BOARD (NEW REQUIREMENT)
local NoticeCard = Instance.new("Frame")
NoticeCard.Size = UDim2.new(1, -6, 0, 100)
NoticeCard.BackgroundColor3 = C_ITEM
NoticeCard.ZIndex = 13
NoticeCard.Parent = MainTabPage
Instance.new("UICorner", NoticeCard).CornerRadius = UDim.new(0, 10)
local NoticeStroke = Instance.new("UIStroke", NoticeCard)
NoticeStroke.Color = C_ACCENT
NoticeStroke.Transparency = 0.7

local NoticeTitle = Instance.new("TextLabel")
NoticeTitle.Size = UDim2.new(1, -20, 0, 22)
NoticeTitle.Position = UDim2.new(0, 12, 0, 8)
NoticeTitle.BackgroundTransparency = 1
NoticeTitle.Text = "📢 OFFICIAL ANNOUNCEMENT"
NoticeTitle.TextColor3 = C_ACCENT
NoticeTitle.TextSize = 11
NoticeTitle.Font = Enum.Font.GothamBold
NoticeTitle.TextXAlignment = Enum.TextXAlignment.Left
NoticeTitle.ZIndex = 14
NoticeTitle.Parent = NoticeCard

local NoticeBody = Instance.new("TextLabel")
NoticeBody.Size = UDim2.new(1, -24, 0, 60)
NoticeBody.Position = UDim2.new(0, 12, 0, 30)
NoticeBody.BackgroundTransparency = 1
NoticeBody.Text = "Selamat datang di VOIDHUB Supreme v13.0! Seluruh fitur & pemindai Solo Server telah diperbarui. Gunakan fitur Game Mechanics untuk otomatisasi game."
NoticeBody.TextColor3 = C_TEXT
NoticeBody.TextSize = 10
NoticeBody.Font = Enum.Font.Gotham
NoticeBody.TextWrapped = true
NoticeBody.TextYAlignment = Enum.TextYAlignment.Top
NoticeBody.TextXAlignment = Enum.TextXAlignment.Left
NoticeBody.ZIndex = 14
NoticeBody.Parent = NoticeCard

CreateButton(MainTabPage, "Copy Official Discord Server Link", function()
    if setclipboard then setclipboard("https://discord.gg/voidhub") end
end)

-- ==========================================
-- 2. MOVEMENT TAB
-- ==========================================
local function StartFlying()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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

CreateToggle(MovementTabPage, "Kinetic Flight Mode", State.Flying, function(a)
    State.Flying = a
    if a then StartFlying() else if FlyVel then FlyVel:Destroy() end if FlyGyro then FlyGyro:Destroy() end end
end)
CreateSlider(MovementTabPage, "Flight Speed Rate", 20, 200, 50, function(v) State.FlySpeed = v end)

CreateToggle(MovementTabPage, "Speed Modifier Engine", State.WalkSpeed, function(a)
    State.WalkSpeed = a
    task.spawn(function()
        while State.WalkSpeed do
            pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = State.SpeedValue end end)
            task.wait(0.2)
        end
        pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end)
    end)
end)
CreateSlider(MovementTabPage, "Custom WalkSpeed", 16, 250, 24, function(v) State.SpeedValue = v end)

CreateToggle(MovementTabPage, "Jump Power Multiplier", State.JumpPower, function(a)
    State.JumpPower = a
    task.spawn(function()
        while State.JumpPower do
            pcall(function()
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then h.UseJumpPower = true h.JumpPower = State.JumpValue end
            end)
            task.wait(0.2)
        end
    end)
end)
CreateSlider(MovementTabPage, "Custom Jump Value", 50, 300, 100, function(v) State.JumpValue = v end)

CreateToggle(MovementTabPage, "Infinite Air Jump", State.InfJump, function(a) State.InfJump = a end)
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(MovementTabPage, "Ghost Noclip", State.Noclip, function(a)
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

CreateToggle(MovementTabPage, "Gravity Alteration", State.GravityMod, function(a)
    State.GravityMod = a
    if not a then workspace.Gravity = 196.2 end
    task.spawn(function()
        while State.GravityMod do
            workspace.Gravity = State.GravityVal
            task.wait(0.3)
        end
    end)
end)
CreateSlider(MovementTabPage, "World Gravity Value", 0, 196, 50, function(v) State.GravityVal = v end)

CreateToggle(MovementTabPage, "Spinbot Mock Mode", State.Spinbot, function(a)
    State.Spinbot = a
    task.spawn(function()
        while State.Spinbot do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0)
                end
            end)
            task.wait(0.03)
        end
    end)
end)

-- ==========================================
-- 3. GAME MECHANICS TAB (NEW CATEGORY)
-- ==========================================
CreateToggle(MechanicsTabPage, "Instant Proximity Prompt (No Hold)", State.InstantPrompt, function(a)
    State.InstantPrompt = a
end)
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if State.InstantPrompt then
        fireproximityprompt(prompt)
    end
end)

CreateToggle(MechanicsTabPage, "Auto Click Proximity Prompts", State.AutoPrompt, function(a)
    State.AutoPrompt = a
    task.spawn(function()
        while State.AutoPrompt do
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") then
                    fireproximityprompt(p)
                end
            end
            task.wait(0.5)
        end
    end)
end)

CreateToggle(MechanicsTabPage, "Extended Touch/Melee Reach", State.ReachMod, function(a)
    State.ReachMod = a
    task.spawn(function()
        while State.ReachMod do
            pcall(function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(15, 15, 15)
                    tool.Handle.Transparency = 0.8
                end
            end)
            task.wait(0.5)
        end
    end)
end)

CreateButton(MechanicsTabPage, "Fire All TouchInterests in Radius", function()
    pcall(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent then
                    firetouchinterest(root, v.Parent, 0)
                    task.wait(0.01)
                    firetouchinterest(root, v.Parent, 1)
                end
            end
        end
    end)
end)

-- ==========================================
-- 4. UTILITY & AUTOMATION TAB (NEW CATEGORY)
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

CreateToggle(UtilityTabPage, "Fast Mouse Auto-Clicker", State.AutoClicker, function(a)
    State.AutoClicker = a
    task.spawn(function()
        while State.AutoClicker do
            mouse1click()
            task.wait(0.05)
        end
    end)
end)

CreateToggle(UtilityTabPage, "Anti-Ragdoll / Anti-Stun Guard", State.AntiRagdoll, function(a)
    State.AntiRagdoll = a
    task.spawn(function()
        while State.AntiRagdoll do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end)
            task.wait(0.5)
        end
    end)
end)

CreateToggle(UtilityTabPage, "Anti-AFK Disconnect Guard", State.AntiAFK, function(a)
    State.AntiAFK = a
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

CreateToggle(UtilityTabPage, "Auto Rejoin on Disconnect", State.AutoRejoin, function(a)
    State.AutoRejoin = a
end)
CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if State.AutoRejoin and child.Name == "ErrorPrompt" then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

-- ==========================================
-- 5. VISUALS & ESP TAB
-- ==========================================
local function ApplyESP(p)
    if p == LocalPlayer or not p.Character then return end
    if not p.Character:FindFirstChild("VoidHL") then
        local hl = Instance.new("Highlight")
        hl.Name = "VoidHL"
        hl.FillColor = C_ACCENT
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.Parent = p.Character
    end
end

CreateToggle(VisualTabPage, "Player Highlight ESP", State.PlayerESP, function(a)
    State.PlayerESP = a
    if a then
        for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
        ESPConnections["Loop"] = RunService.Heartbeat:Connect(function()
            if State.PlayerESP then for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end end
        end)
    else
        if ESPConnections["Loop"] then ESPConnections["Loop"]:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("VoidHL") then p.Character.VoidHL:Destroy() end
        end
    end
end)

CreateToggle(VisualTabPage, "Ghost Invisibility Mode", State.HidePlayers, function(a)
    pcall(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = a and 1 or 0
                end
            end
        end
    end)
end)

-- ==========================================
-- 6. CAMERA & WORLD TAB (NEW CATEGORY)
-- ==========================================
CreateToggle(WorldTabPage, "Fullbright Vision Ambient", State.Fullbright, function(a)
    State.Fullbright = a
    if a then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

CreateToggle(WorldTabPage, "Override Camera Field of View (FOV)", State.CustomFOV, function(a)
    State.CustomFOV = a
    if not a then workspace.CurrentCamera.FieldOfView = 70 end
    task.spawn(function()
        while State.CustomFOV do
            workspace.CurrentCamera.FieldOfView = State.FOVValue
            task.wait(0.2)
        end
    end)
end)
CreateSlider(WorldTabPage, "Camera FOV Slider", 30, 120, 70, function(v) State.FOVValue = v end)

CreateButton(WorldTabPage, "Potato Mode (FPS Booster)", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end)
end)

CreateButton(WorldTabPage, "Enable Shift Lock Switch", function()
    LocalPlayer.DevEnableMouseLock = true
end)

-- ==========================================
-- 7. SERVER FINDER TAB (SOLO SERVER SCANNER)
-- ==========================================
local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Size = UDim2.new(1, -6, 1, -45)
ServerListFrame.BackgroundTransparency = 1
ServerListFrame.ScrollBarThickness = 2
ServerListFrame.ScrollBarImageColor3 = C_ACCENT
ServerListFrame.ZIndex = 13
ServerListFrame.Parent = ServerTabPage

local ServerListLayout = Instance.new("UIListLayout", ServerListFrame)
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ServerListLayout.Padding = UDim.new(0, 6)

local function ScanSoloServers()
    for _, child in pairs(ServerListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.BackgroundTransparency = 1
    status.Text = "Scanning active 1-player servers..."
    status.TextColor3 = C_SUBTEXT
    status.TextSize = 11
    status.Font = Enum.Font.Gotham
    status.Parent = ServerListFrame

    task.spawn(function()
        local count = 0
        pcall(function()
            local raw = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local data = HttpService:JSONDecode(raw)
            status:Destroy()

            for _, s in pairs(data.data) do
                if s.playing == 1 and s.id ~= game.JobId then
                    count = count + 1
                    local card = Instance.new("Frame")
                    card.Size = UDim2.new(1, 0, 0, 40)
                    card.BackgroundColor3 = C_ITEM
                    card.ZIndex = 14
                    card.Parent = ServerListFrame
                    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

                    local info = Instance.new("TextLabel")
                    info.Size = UDim2.new(1, -100, 1, 0)
                    info.Position = UDim2.new(0, 10, 0, 0)
                    info.BackgroundTransparency = 1
                    info.Text = "Server ID: " .. string.sub(s.id, 1, 14) .. "... [1 Player]"
                    info.TextColor3 = C_TEXT
                    info.TextSize = 11
                    info.Font = Enum.Font.GothamMedium
                    info.TextXAlignment = Enum.TextXAlignment.Left
                    info.ZIndex = 15
                    info.Parent = card

                    local tp = Instance.new("TextButton")
                    tp.Size = UDim2.new(0, 75, 0, 24)
                    tp.Position = UDim2.new(1, -82, 0.5, -12)
                    tp.BackgroundColor3 = C_ACCENT
                    tp.Text = "TP SOLO"
                    tp.TextColor3 = C_BG
                    tp.TextSize = 10
                    tp.Font = Enum.Font.GothamBold
                    tp.ZIndex = 15
                    tp.Parent = card
                    Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 5)

                    tp.MouseButton1Click:Connect(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    end)
                end
            end
        end)
    end)
end

CreateButton(ServerTabPage, "🔍 Scan 1-Player Solo Servers", function() ScanSoloServers() end)

-- ==========================================
-- 8. PLAYER LIST TAB
-- ==========================================
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, -6, 1, -45)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.ScrollBarThickness = 2
PlayerListFrame.ScrollBarImageColor3 = C_ACCENT
PlayerListFrame.ZIndex = 13
PlayerListFrame.Parent = PlayersTabPage

local PlayerListLayout = Instance.new("UIListLayout", PlayerListFrame)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)

local function RenderPlayerList()
    for _, c in pairs(PlayerListFrame:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 44)
            card.BackgroundColor3 = C_ITEM
            card.ZIndex = 14
            card.Parent = PlayerListFrame
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 32, 0, 32)
            img.Position = UDim2.new(0, 6, 0.5, -16)
            img.BackgroundTransparency = 1
            img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            img.ZIndex = 15
            img.Parent = card
            Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

            local pName = Instance.new("TextLabel")
            pName.Size = UDim2.new(1, -140, 1, 0)
            pName.Position = UDim2.new(0, 44, 0, 0)
            pName.BackgroundTransparency = 1
            pName.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pName.TextColor3 = C_TEXT
            pName.TextSize = 10
            pName.Font = Enum.Font.GothamMedium
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.ZIndex = 15
            pName.Parent = card

            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 85, 0, 24)
            tpBtn.Position = UDim2.new(1, -92, 0.5, -12)
            tpBtn.BackgroundColor3 = C_ACCENT
            tpBtn.Text = "TP TO PLAYER"
            tpBtn.TextColor3 = C_BG
            tpBtn.TextSize = 9
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.ZIndex = 15
            tpBtn.Parent = card
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)

            tpBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end)
        end
    end
end

CreateToggle(PlayersTabPage, "Click Teleport (Shift + Left Click)", State.ClickTP, function(a) State.ClickTP = a end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and State.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

Players.PlayerAdded:Connect(RenderPlayerList)
Players.PlayerRemoving:Connect(RenderPlayerList)
RenderPlayerList()
