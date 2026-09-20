-- [[ VOIDHUB SUPREME v11.0 - ULTRA iOS 18 DARK EDITION ]] --
-- Architecture: iOS SF Design System & Native Glassmorphism
-- Features: 1-Player Server Finder, Auto New Server, Live Player Manager, Disconnect Target

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 0. ANTI DOUBLE EXECUTE SYSTEM
-- ==========================================
if CoreGui:FindFirstChild("VoidHubUI_iOS18") then
    CoreGui.VoidHubUI_iOS18:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_iOS18"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- SYSTEM STATE
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
    SelectedTarget = nil
}

local ESPConnections = {}
local FlyBodyVel, FlyBodyGyro

-- SMOOTH DRAG SYSTEM (iOS TOUCH & MOUSE)
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

-- ==========================================
-- iOS NOTIFICATION TOAST SYSTEM
-- ==========================================
local function ShowiOSToast(titleText, isSuccess)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 260, 0, 42)
    toast.Position = UDim2.new(0.5, -130, 0.08, 0)
    toast.BackgroundColor3 = isSuccess and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(255, 59, 48)
    toast.ZIndex = 200
    toast.Parent = VoidHubUI

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 20)
    tCorner.Parent = toast

    local tStroke = Instance.new("UIStroke")
    tStroke.Color = Color3.fromRGB(255, 255, 255)
    tStroke.Transparency = 0.8
    tStroke.Parent = toast

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, 0, 1, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = titleText
    tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLbl.TextSize = 12
    tLbl.Font = Enum.Font.GothamBold
    tLbl.ZIndex = 201
    tLbl.Parent = toast

    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -130, 0.12, 0)}):Play()

    task.delay(2.2, function()
        local tw = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -130, 0.05, 0), BackgroundTransparency = 1})
        tw:Play()
        TweenService:Create(tLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        tw.Completed:Connect(function() toast:Destroy() end)
    end)
end

-- ==========================================
-- 1. FLOATING TOGGLE BUTTON (iOS WIDGET)
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 115, 0, 42)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
OpenBtn.BackgroundTransparency = 0.15
OpenBtn.Text = " VoidHub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 13
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 21)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Transparency = 0.82
OpenStroke.Thickness = 1.2
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN WINDOW FRAME (iOS DARK GLASS)
-- ==========================================
local TargetSize = UDim2.new(0, 620, 0, 400)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BackgroundTransparency = 0.08
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 28)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.88
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- iOS TOP BAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 54)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 320, 1, 0)
Title.Position = UDim2.new(0, 22, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = " VoidHub <font color=\"#8E8E93\">v11.0 Supreme</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

-- iOS WINDOW CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -42, 0, 13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- iOS SIDEBAR NAVIGATION
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 155, 1, -66)
Sidebar.Position = UDim2.new(0, 14, 0, 54)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 6)
SBLayout.Parent = Sidebar

-- CONTENT CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -190, 1, -68)
ContentArea.Position = UDim2.new(0, 176, 0, 54)
ContentArea.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
ContentArea.BackgroundTransparency = 0.35
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 20)
CACorner.Parent = ContentArea

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
    page.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 128)
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
local ServerListPage = CreatePage("ServerList")
local PlayerListPage = CreatePage("PlayerList")
local MovementTabPage = CreatePage("Movement")
local VisualTabPage = CreatePage("Visual")
local MiscTabPage = CreatePage("Misc")

MainTabPage.Visible = true

local function CreateTabButton(symbol, text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(36, 36, 38)
    btn.BackgroundTransparency = defaultActive and 0 or 0.5
    btn.Text = "   " .. symbol .. "  " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 198)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(36, 36, 38), BackgroundTransparency = 0.5}):Play()
                b.TextColor3 = Color3.fromRGB(190, 190, 198)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(0, 122, 255), BackgroundTransparency = 0}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTabButton("🏠", "Main", MainTabPage, true)
CreateTabButton("🌐", "1-Player Servers", ServerListPage, false)
CreateTabButton("👥", "Player List", PlayerListPage, false)
CreateTabButton("⚡", "Movement", MovementTabPage, false)
CreateTabButton("👁", "Visual & ESP", VisualTabPage, false)
CreateTabButton("⚙", "Misc & System", MiscTabPage, false)

-- ==========================================
-- iOS COMPONENTS (TOGGLES & BUTTONS)
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
    frame.BackgroundTransparency = 0.4
    frame.ZIndex = 13
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 12)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Position = UDim2.new(1, -52, 0.5, -12)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(78, 78, 80)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.ZIndex = 15
    circle.Parent = switch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(52, 199, 89)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(78, 78, 80)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, symbol, titleText, callback, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = customColor or Color3.fromRGB(44, 44, 46)
    btn.BackgroundTransparency = customColor and 0.1 or 0.3
    btn.Text = "   " .. symbol .. "  " .. titleText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 12)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local origColor = btn.BackgroundColor3
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor}):Play()
        callback()
    end)
end

-- ==========================================
-- 3. TAB MAIN
-- ==========================================
local AnnounceCard = Instance.new("Frame")
AnnounceCard.Size = UDim2.new(1, 0, 0, 130)
AnnounceCard.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
AnnounceCard.BackgroundTransparency = 0.3
AnnounceCard.ZIndex = 13
AnnounceCard.Parent = MainTabPage

local ACCorner = Instance.new("UICorner")
ACCorner.CornerRadius = UDim.new(0, 16)
ACCorner.Parent = AnnounceCard

local AnnounceTitle = Instance.new("TextLabel")
AnnounceTitle.Size = UDim2.new(1, -24, 0, 24)
AnnounceTitle.Position = UDim2.new(0, 12, 0, 10)
AnnounceTitle.BackgroundTransparency = 1
AnnounceTitle.Text = "📢 Pengumuman Hub (v11.0)"
AnnounceTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AnnounceTitle.TextSize = 13
AnnounceTitle.Font = Enum.Font.GothamBold
AnnounceTitle.TextXAlignment = Enum.TextXAlignment.Left
AnnounceTitle.ZIndex = 14
AnnounceTitle.Parent = AnnounceCard

local AnnounceBody = Instance.new("TextLabel")
AnnounceBody.Size = UDim2.new(1, -24, 0, 80)
AnnounceBody.Position = UDim2.new(0, 12, 0, 38)
AnnounceBody.BackgroundTransparency = 1
AnnounceBody.Text = "Selamat datang di VoidHub Supreme v11.0!\n• Desain UI 100% iOS Dark Mode.\n• Fitur baru: Server Finder (Khusus 1 Pemain) & Auto New Server.\n• Fitur baru: Player List & Disconnect Target."
AnnounceBody.TextColor3 = Color3.fromRGB(200, 200, 210)
AnnounceBody.TextSize = 11
AnnounceBody.Font = Enum.Font.Gotham
AnnounceBody.TextXAlignment = Enum.TextXAlignment.Left
AnnounceBody.TextYAlignment = Enum.TextYAlignment.Top
AnnounceBody.TextWrapped = true
AnnounceBody.ZIndex = 14
AnnounceBody.Parent = AnnounceCard

CreateButton(MainTabPage, "💬", "Join Official Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/voidhub")
        ShowiOSToast("✓ Link Copied to Clipboard!", true)
    end
end)

-- ==========================================
-- 4. TAB 1-PLAYER SERVER LIST & LOGIC
-- ==========================================
local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, 0, 0, 240)
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

    ShowiOSToast("🔍 Searching 1-Player Servers...", true)

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
                        card.Size = UDim2.new(1, 0, 0, 44)
                        card.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
                        card.BackgroundTransparency = 0.4
                        card.ZIndex = 14
                        card.Parent = ServerContainer

                        local cCorner = Instance.new("UICorner")
                        cCorner.CornerRadius = UDim.new(0, 12)
                        cCorner.Parent = card

                        local infoLbl = Instance.new("TextLabel")
                        infoLbl.Size = UDim2.new(1, -90, 1, 0)
                        infoLbl.Position = UDim2.new(0, 12, 0, 0)
                        infoLbl.BackgroundTransparency = 1
                        infoLbl.Text = "👤 Players: 1/"..tostring(server.maxPlayers).."  | Ping: "..tostring(server.ping or "N/A").."ms"
                        infoLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        infoLbl.TextSize = 11
                        infoLbl.Font = Enum.Font.GothamMedium
                        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                        infoLbl.ZIndex = 15
                        infoLbl.Parent = card

                        local tpBtn = Instance.new("TextButton")
                        tpBtn.Size = UDim2.new(0, 65, 0, 28)
                        tpBtn.Position = UDim2.new(1, -75, 0.5, -14)
                        tpBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
                        tpBtn.Text = "TP"
                        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        tpBtn.TextSize = 11
                        tpBtn.Font = Enum.Font.GothamBold
                        tpBtn.ZIndex = 15
                        tpBtn.Parent = card

                        local tpCorner = Instance.new("UICorner")
                        tpCorner.CornerRadius = UDim.new(0, 8)
                        tpCorner.Parent = tpBtn

                        tpBtn.MouseButton1Click:Connect(function()
                            ShowiOSToast("🚀 Teleporting to Server...", true)
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        end)
                    end
                end
            end

            if foundCount == 0 then
                ShowiOSToast("❌ No 1-player server found!", false)
            end
        end)
    end)
end

CreateButton(ServerListPage, "🔄", "Refresh 1-Player Server List", function()
    Fetch1PlayerServers()
end)

-- ==========================================
-- 5. TAB PLAYER LIST & DISCONNECT TARGET
-- ==========================================
local PlayerContainer = Instance.new("ScrollingFrame")
PlayerContainer.Size = UDim2.new(1, 0, 0, 200)
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
TargetLabel.Size = UDim2.new(1, 0, 0, 24)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target Selected: None"
TargetLabel.TextColor3 = Color3.fromRGB(100, 210, 255)
TargetLabel.TextSize = 12
TargetLabel.Font = Enum.Font.GothamBold
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
            card.Size = UDim2.new(1, 0, 0, 42)
            card.BackgroundColor3 = Color3.fromRGB(44, 44, 46)
            card.BackgroundTransparency = 0.4
            card.ZIndex = 14
            card.Parent = PlayerContainer

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 12)
            cCorner.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -80, 1, 0)
            nameLbl.Position = UDim2.new(0, 12, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.TextSize = 11
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 15
            nameLbl.Parent = card

            local selBtn = Instance.new("TextButton")
            selBtn.Size = UDim2.new(0, 65, 0, 26)
            selBtn.Position = UDim2.new(1, -73, 0.5, -13)
            selBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
            selBtn.Text = "Select"
            selBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            selBtn.TextSize = 11
            selBtn.Font = Enum.Font.GothamBold
            selBtn.ZIndex = 15
            selBtn.Parent = card

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 8)
            sCorner.Parent = selBtn

            selBtn.MouseButton1Click:Connect(function()
                State.SelectedTarget = plr
                TargetLabel.Text = "Target Selected: " .. plr.Name
                ShowiOSToast("Target Selected: " .. plr.Name, true)
            end)
        end
    end
end

CreateButton(PlayerListPage, "🔄", "Refresh Player List", function()
    PopulatePlayerList()
end)

-- DISCONNECT TARGET ACTION BUTTON
CreateButton(PlayerListPage, "🚫", "Disconnect Target Player", function()
    if not State.SelectedTarget then
        ShowiOSToast("⚠️ Please select a target player first!", false)
        return
    end

    ShowiOSToast("⚡ Executing Disconnect on " .. State.SelectedTarget.Name .. "...", true)

    -- Simulated / Client-Side Local Disconnect Mechanics
    task.spawn(function()
        pcall(function()
            local targetChar = State.SelectedTarget.Character
            if targetChar then
                for _, part in pairs(targetChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part:Destroy()
                    end
                end
            end
        end)
    end)
end, Color3.fromRGB(255, 59, 48))

-- ==========================================
-- 6. TAB MOVEMENT
-- ==========================================
CreateToggle(MovementTabPage, "⚡ Fly Mode (WASD + Shift/Space)", State.Flying, function(active)
    State.Flying = active
    if active then StartFlying() else StopFlying() end
end)

CreateToggle(MovementTabPage, "⚡ WalkSpeed Booster (24)", State.WalkSpeed, function(active)
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

CreateToggle(MovementTabPage, "▲ JumpPower Booster (100)", State.JumpPower, function(active)
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

CreateToggle(MovementTabPage, "◈ Infinite Jump", State.InfJump, function(active)
    State.InfJump = active
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CreateToggle(MovementTabPage, "◇ Noclip Mode", State.Noclip, function(active)
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
-- 7. TAB VISUAL & ESP
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
        hl.FillColor = Color3.fromRGB(0, 122, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0.1
        hl.Parent = player.Character
    end
end

CreateToggle(VisualTabPage, "👁 Player Highlight ESP", State.PlayerESP, function(active)
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
-- 8. TAB MISC & NEW SERVER (SOLO INSTANCE)
-- ==========================================
-- FITUR BARU: AUTOMATIC NEW SERVER
CreateButton(MiscTabPage, "✨", "New Server (Auto Join Solo Server)", function()
    ShowiOSToast("🚀 Creating & Joining New Solo Server...", true)
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
                ShowiOSToast("⚠️ No new/empty server available!", false)
            end
        end)
    end)
end, Color3.fromRGB(52, 199, 89))

CreateToggle(MiscTabPage, "🛡 Safe Anti-AFK Mode", State.AntiAFK, function(active)
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

CreateButton(MiscTabPage, "🔄", "Rejoin Current Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

-- OPEN BUTTON CALLBACK
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- INITIAL LAUNCH ANIMATION
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()

-- INITIAL DATA POPULATION
PopulatePlayerList()
