-- [[ VOIDHUB SUPREME v13.0 - LUXURY EXECUTIVE EDITION ]] --
-- UI/UX: Bento Obsidian Glassmorphism with Liquid Gold Accents
-- Integrated Features: Movement, Protections, Player Tools & Steal An Egg Mechanics

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
-- 0. ANTI DOUBLE RE-EXECUTE & CLEANUP GUARD
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
    
    InstantPrompt = false, AutoPrompt = false,
    
    -- STEAL AN EGG FEATURES
    AutoSteal = false,
    AutoFarmEgg = false,
    InstantBaseTP = false,
    
    AntiVoid = false, AntiAFK = true,
    PlayerESP = false, Fullbright = false, ClickTP = false
}

local FlyVel, FlyGyro

-- DRAGGABLE ENGINE
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
            TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end))
end

-- HELPER FUNCTIONS (REJOIN & SERVER HOP)
local function RejoinServer()
    if #Players:GetPlayers() <= 1 then
        LocalPlayer:Kick("\n[VOIDHUB]: Rejoining Server...")
        task.wait(0.2)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

local function ServerHop()
    pcall(function()
        local servers = {}
        local raw = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(raw)
        for _, s in pairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(servers, s.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

-- FLOATING TOGGLE BUTTON
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

-- MAIN EXECUTIVE WINDOW
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
local EggTabPage = CreatePage("Egg")
local MovementTabPage = CreatePage("Movement")
local MechanicsTabPage = CreatePage("Mechanics")
local UtilityTabPage = CreatePage("Utility")
local VisualTabPage = CreatePage("Visual")
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
CreateTabButton("🥚 Egg Mechanics", EggTabPage, false)
CreateTabButton("Movement", MovementTabPage, false)
CreateTabButton("Game Mechanics", MechanicsTabPage, false)
CreateTabButton("Utility & Auto", UtilityTabPage, false)
CreateTabButton("Visuals & ESP", VisualTabPage, false)
CreateTabButton("Server Finder", ServerTabPage, false)
CreateTabButton("Player List", PlayersTabPage, false)

-- UI BUILDERS
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 38)
    frame.BackgroundColor3 = C_ITEM
    frame.ZIndex = 13
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

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

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C_ACCENT, TextColor3 = C_BG}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_ITEM, TextColor3 = C_TEXT}):Play()
        callback()
    end)
end

-- ==========================================
-- DASHBOARD TAB
-- ==========================================
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -6, 0, 70)
ProfileCard.BackgroundColor3 = C_ITEM
ProfileCard.ZIndex = 13
ProfileCard.Parent = MainTabPage
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -20, 0, 20)
WelcomeText.Position = UDim2.new(0, 15, 0, 15)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome back, <font color=\"#EBB95F\">" .. LocalPlayer.DisplayName .. "</font>"
WelcomeText.RichText = true
WelcomeText.TextColor3 = C_TEXT
WelcomeText.TextSize = 13
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.ZIndex = 14
WelcomeText.Parent = ProfileCard

CreateButton(MainTabPage, "⚡ Instant Rejoin Server", function() RejoinServer() end)
CreateButton(MainTabPage, "🌐 Random Server Hop", function() ServerHop() end)

-- ==========================================
-- EGG MECHANICS TAB (STEAL AN EGG FEATURES)
-- ==========================================
local function StealEggLogic()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and (v.Parent.Name:lower():find("egg") or v.ObjectText:lower():find("egg") or v.ActionText:lower():find("steal")) then
                if v.Parent:IsA("BasePart") then
                    root.CFrame = v.Parent.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.1)
                    fireproximityprompt(v)
                end
            end
        end
    end)
end

CreateToggle(EggTabPage, "Auto Steal Egg (Auto Teleport & Grab)", State.AutoSteal, function(a)
    State.AutoSteal = a
    task.spawn(function()
        while State.AutoSteal do
            StealEggLogic()
            task.wait(0.3)
        end
    end)
end)

CreateToggle(EggTabPage, "Auto Farm Nearby Eggs", State.AutoFarmEgg, function(a)
    State.AutoFarmEgg = a
    task.spawn(function()
        while State.AutoFarmEgg do
            pcall(function()
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        fireproximityprompt(prompt)
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)

CreateButton(EggTabPage, "🚀 Instant Teleport to Own Base", function()
    pcall(function()
        local myBase = workspace:FindFirstChild("Bases") and workspace.Bases:FindFirstChild(LocalPlayer.Name)
        if myBase and myBase:FindFirstChild("Spawn") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = myBase.Spawn.CFrame * CFrame.new(0, 3, 0)
        end
    end)
end)

CreateButton(EggTabPage, "🔄 Refresh Workspace Prompt Objects", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.RequiresLineOfSight = false
                v.HoldDuration = 0
            end
        end
    end)
end)

-- ==========================================
-- MOVEMENT TAB
-- ==========================================
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

-- ==========================================
-- GAME MECHANICS TAB
-- ==========================================
CreateToggle(MechanicsTabPage, "Instant Proximity Prompt (No Hold)", State.InstantPrompt, function(a) State.InstantPrompt = a end)
RegisterConnection(ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if State.InstantPrompt then fireproximityprompt(prompt) end
end))

-- ==========================================
-- UTILITY TAB
-- ==========================================
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

-- ==========================================
-- VISUALS & SERVER TABS
-- ==========================================
CreateButton(ServerTabPage, "⚡ Rejoin Current Server", function() RejoinServer() end)
CreateButton(ServerTabPage, "🌐 Random Server Hop", function() ServerHop() end)
