-- [[ VOIDHUB SUPREME v13.0 - LUXURY OBSIDIAN & GOLD EDITION ]] --
-- Features: Stealth Anti-Detection Metatable Hook, Premium Glass UX, Responsive Scaling, Anti-AFK
-- Theme: Obsidian Dark, Warm Champagne Gold, Deep Charcoal Accent (No Emoji)

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
-- 0. STEALTH CONTAINER & ANTI-DETECTION
-- ==========================================
local RandomName = ""
for i = 1, 16 do RandomName = RandomName .. string.char(math.random(97, 122)) end

local ParentContainer = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui

if ParentContainer:FindFirstChild("VoidHubUI_Luxury") then
    ParentContainer.VoidHubUI_Luxury:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_Luxury"
VoidHubUI.Parent = ParentContainer
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

-- METATABLE HOOK FOR SPEED/JUMP BYPASS
local RawMeta = getrawmetatable and getrawmetatable(game)
if RawMeta and setreadonly then
    setreadonly(RawMeta, false)
    local OldIndex = RawMeta.__index
    local OldNewIndex = RawMeta.__newindex

    RawMeta.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" and State.WalkSpeed then return 16 end
            if key == "JumpPower" and State.JumpPower then return 50 end
        end
        return OldIndex(self, key)
    end)

    RawMeta.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" and State.WalkSpeed then return end
            if key == "JumpPower" and State.JumpPower then return end
        end
        return OldNewIndex(self, key, value)
    end)
    setreadonly(RawMeta, true)
end

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
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

task.spawn(function()
    while true do
        if State.AntiAFK and Camera then
            pcall(function()
                Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0.0001, 0)
                task.wait(0.1)
                Camera.CFrame = Camera.CFrame * CFrame.Angles(0, -0.0001, 0)
            end)
        end
        task.wait(60)
    end
end)

-- ==========================================
-- STEALTH FLY ENGINE
-- ==========================================
local FlyConnection
local function StartFlying()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if FlyConnection then FlyConnection:Disconnect() end

    FlyConnection = RunService.Heartbeat:Connect(function(delta)
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

        root.AssemblyLinearVelocity = moveDir * State.FlySpeed
    end)
end

local function StopFlying()
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    end
end

-- ==========================================
-- NOTIFICATION TOAST
-- ==========================================
local function ShowLuxuryNotification(msg)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 290, 0, 38)
    toast.Position = UDim2.new(0.5, -145, 0.04, 0)
    toast.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    toast.BorderSizePixel = 0
    toast.ZIndex = 200
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
    lbl.TextColor3 = Color3.fromRGB(235, 235, 240)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 201
    lbl.Parent = toast

    TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -145, 0.07, 0)}):Play()

    task.delay(2.5, function()
        local tw = TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -145, 0.02, 0), BackgroundTransparency = 1})
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
OpenBtn.Size = UDim2.new(0, 140, 0, 38)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
OpenBtn.Text = "VOIDHUB // OPEN"
OpenBtn.TextColor3 = Color3.fromRGB(212, 175, 55)
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
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
-- 2. MAIN WINDOW FRAME (RESPONSIVE LUXURY)
-- ==========================================
local ViewportSize = Camera.ViewportSize
local IsMobile = ViewportSize.X < 700

local FrameWidth = IsMobile and math.clamp(ViewportSize.X - 30, 320, 520) or 620
local FrameHeight = IsMobile and math.clamp(ViewportSize.Y - 60, 340, 430) or 420

local TargetSize = UDim2.new(0, FrameWidth, 0, FrameHeight)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -FrameWidth/2, 0.5, -FrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(212, 175, 55)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

-- TOP BAR HEADER
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 44)
Topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 12)
TopbarCorner.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 280, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#D4AF37\">LUXURY EDITION</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
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
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- STATS HUD BAR
local StatsHUD = Instance.new("Frame")
StatsHUD.Size = UDim2.new(1, -24, 0, 24)
StatsHUD.Position = UDim2.new(0, 12, 0, 48)
StatsHUD.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
StatsHUD.BorderSizePixel = 0
StatsHUD.ZIndex = 11
StatsHUD.Parent = MainFrame

local HUDCorner = Instance.new("UICorner")
HUDCorner.CornerRadius = UDim.new(0, 6)
HUDCorner.Parent = StatsHUD

local StatsHUDStroke = Instance.new("UIStroke")
StatsHUDStroke.Color = Color3.fromRGB(40, 40, 50)
StatsHUDStroke.Thickness = 1
StatsHUDStroke.Parent = StatsHUD

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -16, 1, 0)
StatsLabel.Position = UDim2.new(0, 8, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "USER: " .. LocalPlayer.Name .. " | FPS: -- | PING: --ms"
StatsLabel.TextColor3 = Color3.fromRGB(180, 185, 195)
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
CategoryBar.Size = UDim2.new(1, -24, 0, 34)
CategoryBar.Position = UDim2.new(0, 12, 0, 78)
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
CBLayout.Padding = UDim.new(0, 8)
CBLayout.Parent = CategoryBar

-- CONTENT CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -24, 1, -126)
ContentArea.Position = UDim2.new(0, 12, 0, 118)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(35, 35, 45)
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

local MainTabPage = CreatePage("Main")
local ServerListPage = CreatePage("ServerList")
local PlayerListPage = CreatePage("PlayerList")
local MovementTabPage = CreatePage("Movement")
local VisualTabPage = CreatePage("Visual")
local MiscTabPage = CreatePage("Misc")

MainTabPage.Visible = true

local function CreateTopTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(24, 24, 32)
    btn.BorderSizePixel = 0
    btn.Text = string.upper(text)
    btn.TextColor3 = defaultActive and Color3.fromRGB(14, 14, 18) or Color3.fromRGB(180, 185, 195)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 12
    btn.Parent = CategoryBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 58)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(CategoryBar:GetChildren()) do 
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
                b.TextColor3 = Color3.fromRGB(180, 185, 195)
            end
        end
        pageTarget.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        btn.TextColor3 = Color3.fromRGB(14, 14, 18)
    end)
end

CreateTopTabButton("MAIN", MainTabPage, true)
CreateTopTabButton("SERVERS", ServerListPage, false)
CreateTopTabButton("PLAYERS", PlayerListPage, false)
CreateTopTabButton("MOVEMENT", MovementTabPage, false)
CreateTopTabButton("VISUALS", VisualTabPage, false)
CreateTopTabButton("SYSTEM", MiscTabPage, false)

-- ==========================================
-- PREMIUM UI COMPONENTS
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.BorderSizePixel = 0
    frame.ZIndex = 13
    frame.Parent = parent

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(40, 40, 52)
    fStroke.Thickness = 1
    fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(titleText)
    label.TextColor3 = Color3.fromRGB(225, 225, 230)
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 44, 0, 22)
    switch.Position = UDim2.new(1, -52, 0.5, -11)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(40, 40, 52)
    switch.BorderSizePixel = 0
    switch.Text = defaultState and "ON" or "OFF"
    switch.TextColor3 = defaultState and Color3.fromRGB(14, 14, 18) or Color3.fromRGB(160, 165, 175)
    switch.TextSize = 9
    switch.Font = Enum.Font.GothamBold
    switch.ZIndex = 14
    switch.Parent = frame

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 5)
    sCorner.Parent = switch
    
    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            switch.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
            switch.TextColor3 = Color3.fromRGB(14, 14, 18)
            switch.Text = "ON"
        else
            switch.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
            switch.TextColor3 = Color3.fromRGB(160, 165, 175)
            switch.Text = "OFF"
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = customColor or Color3.fromRGB(28, 28, 38)
    btn.BorderSizePixel = 0
    btn.Text = "[ACTION] " .. string.upper(titleText)
    btn.TextColor3 = Color3.fromRGB(230, 230, 235)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    local bPad = Instance.new("UIPadding")
    bPad.PaddingLeft = UDim.new(0, 12)
    bPad.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(45, 45, 58)
    bStroke.Thickness = 1
    bStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local origColor = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        btn.TextColor3 = Color3.fromRGB(14, 14, 18)
        task.wait(0.12)
        btn.BackgroundColor3 = origColor
        btn.TextColor3 = Color3.fromRGB(230, 230, 235)
        callback()
    end)
end

-- ==========================================
-- 3. TAB MAIN
-- ==========================================
local AnnounceCard = Instance.new("Frame")
AnnounceCard.Size = UDim2.new(1, 0, 0, 110)
AnnounceCard.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
AnnounceCard.BorderSizePixel = 0
AnnounceCard.ZIndex = 13
AnnounceCard.Parent = MainTabPage

local ACCorner = Instance.new("UICorner")
ACCorner.CornerRadius = UDim.new(0, 8)
ACCorner.Parent = AnnounceCard

local ACCornerStroke = Instance.new("UIStroke")
ACCornerStroke.Color = Color3.fromRGB(45, 45, 58)
ACCornerStroke.Thickness = 1
ACCornerStroke.Parent = AnnounceCard

local AnnounceTitle = Instance.new("TextLabel")
AnnounceTitle.Size = UDim2.new(1, -24, 0, 20)
AnnounceTitle.Position = UDim2.new(0, 12, 0, 8)
AnnounceTitle.BackgroundTransparency = 1
AnnounceTitle.Text = "LUXURY ENGINE BULLETIN // v13.0"
AnnounceTitle.TextColor3 = Color3.fromRGB(212, 175, 55)
AnnounceTitle.TextSize = 11
AnnounceTitle.Font = Enum.Font.GothamBold
AnnounceTitle.TextXAlignment = Enum.TextXAlignment.Left
AnnounceTitle.ZIndex = 14
AnnounceTitle.Parent = AnnounceCard

local AnnounceBody = Instance.new("TextLabel")
AnnounceBody.Size = UDim2.new(1, -24, 0, 70)
AnnounceBody.Position = UDim2.new(0, 12, 0, 30)
AnnounceBody.BackgroundTransparency = 1
AnnounceBody.Text = "- METATABLE HOOK BYPASS ACTIVE\n- OBSIDIAN & GOLD GLASS ENGINE LOADED\n- PHYSICAL ANTI-AFK ENGINE ENGAGED\n- HIDE PLAYER & SERVER SCANNER ACTIVE"
AnnounceBody.TextColor3 = Color3.fromRGB(175, 180, 190)
AnnounceBody.TextSize = 10
AnnounceBody.Font = Enum.Font.Gotham
AnnounceBody.TextXAlignment = Enum.TextXAlignment.Left
AnnounceBody.TextYAlignment = Enum.TextYAlignment.Top
AnnounceBody.TextWrapped = true
AnnounceBody.ZIndex = 14
AnnounceBody.Parent = AnnounceCard

CreateButton(MainTabPage, "Copy Official Discord Link", function()
    if setclipboard then
        setclipboard("https://discord.gg/voidhub")
        ShowLuxuryNotification("Discord link copied to clipboard")
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

    ShowLuxuryNotification("Scanning 1-player server instances...")

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
                        card.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
                        card.BorderSizePixel = 0
                        card.ZIndex = 14
                        card.Parent = ServerContainer

                        local cCorner = Instance.new("UICorner")
                        cCorner.CornerRadius = UDim.new(0, 6)
                        cCorner.Parent = card

                        local cStroke = Instance.new("UIStroke")
                        cStroke.Color = Color3.fromRGB(40, 40, 52)
                        cStroke.Thickness = 1
                        cStroke.Parent = card

                        local infoLbl = Instance.new("TextLabel")
                        infoLbl.Size = UDim2.new(1, -80, 1, 0)
                        infoLbl.Position = UDim2.new(0, 10, 0, 0)
                        infoLbl.BackgroundTransparency = 1
                        infoLbl.Text = "SERVER: " .. string.sub(server.id, 1, 10) .. "... | PLAYERS: 1/" .. tostring(server.maxPlayers)
                        infoLbl.TextColor3 = Color3.fromRGB(200, 205, 215)
                        infoLbl.TextSize = 10
                        infoLbl.Font = Enum.Font.Code
                        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                        infoLbl.ZIndex = 15
                        infoLbl.Parent = card

                        local tpBtn = Instance.new("TextButton")
                        tpBtn.Size = UDim2.new(0, 60, 0, 24)
                        tpBtn.Position = UDim2.new(1, -68, 0.5, -12)
                        tpBtn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
                        tpBtn.BorderSizePixel = 0
                        tpBtn.Text = "JOIN"
                        tpBtn.TextColor3 = Color3.fromRGB(14, 14, 18)
                        tpBtn.TextSize = 10
                        tpBtn.Font = Enum.Font.GothamBold
                        tpBtn.ZIndex = 15
                        tpBtn.Parent = card

                        local tpCorner = Instance.new("UICorner")
                        tpCorner.CornerRadius = UDim.new(0, 5)
                        tpCorner.Parent = tpBtn

                        tpBtn.MouseButton1Click:Connect(function()
                            ShowLuxuryNotification("Teleporting to instance...")
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        end)
                    end
                end
            end

            if foundCount == 0 then
                ShowLuxuryNotification("No 1-player server instances found")
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
TargetLabel.TextColor3 = Color3.fromRGB(212, 175, 55)
TargetLabel.TextSize = 10
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
            card.Size = UDim2.new(1, 0, 0, 36)
            card.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            card.BorderSizePixel = 0
            card.ZIndex = 14
            card.Parent = PlayerContainer

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 6)
            cCorner.Parent = card

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = Color3.fromRGB(40, 40, 52)
            cStroke.Thickness = 1
            cStroke.Parent = card

            local isHidden = State.HiddenPlayers[plr.UserId] == true

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -80, 1, 0)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = string.upper(plr.Name) .. " [" .. (isHidden and "HIDDEN" or "VISIBLE") .. "]"
            nameLbl.TextColor3 = isHidden and Color3.fromRGB(130, 135, 145) or Color3.fromRGB(220, 225, 230)
            nameLbl.TextSize = 10
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 15
            nameLbl.Parent = card

            local selBtn = Instance.new("TextButton")
            selBtn.Size = UDim2.new(0, 60, 0, 24)
            selBtn.Position = UDim2.new(1, -68, 0.5, -12)
            selBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
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
                TargetLabel.Text = "TARGET SELECTED: " .. string.upper(plr.Name)
                ShowLuxuryNotification("Target locked: " .. plr.Name)
            end)
        end
    end
end

CreateButton(PlayerListPage, "Refresh Player List", function()
    PopulatePlayerList()
end)

CreateButton(PlayerListPage, "Hide Selected Target Player", function()
    if not State.SelectedTarget then
        ShowLuxuryNotification("No target selected")
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
        ShowLuxuryNotification("Target hidden: " .. target.Name)
        PopulatePlayerList()
    end
end, Color3.fromRGB(45, 30, 25))

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
    ShowLuxuryNotification("All players unhidden")
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
-- 7. TAB VISUALS
-- ==========================================
local ESPConnections = {}

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
        hl.FillColor = Color3.fromRGB(212, 175, 55)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.2
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
    ShowLuxuryNotification("Searching for solo server instance...")
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
                ShowLuxuryNotification("No solo server instances available")
            end
        end)
    end)
end)

CreateToggle(MiscTabPage, "Physical Anti-AFK Simulation", State.AntiAFK, function(active)
    State.AntiAFK = active
    ShowLuxuryNotification("Anti-AFK state set to: " .. (active and "ACTIVE" or "DISABLED"))
end)

CreateButton(MiscTabPage, "Rejoin Current Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

-- OPEN BUTTON CALLBACK
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- INITIAL LAUNCH ANIMATION
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()

-- INITIAL DATA POPULATION
PopulatePlayerList()
