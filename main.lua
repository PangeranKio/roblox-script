-- [[ VOIDHUB SUPREME ULTRA v8.0 - CYBERPUNK LUXURY EDITION ]] --
-- Rebuilt & Redesigned by Kio

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup Previous Instances
if CoreGui:FindFirstChild("VoidHubUI_v8") then
    CoreGui.VoidHubUI_v8:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI_v8"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- SYSTEM STATE & CONFIG
local ConfigFileName = "VoidHub_v8_Config.json"
local State = {
    PlayerESP = false,
    WalkSpeed = false,
    JumpPower = false,
    InfJump = false,
    Noclip = false,
    AutoClicker = false,
    FPSBooster = false,
    AntiAFK = true,
    SpeedValue = 24,
    JumpValue = 100
}

local ESPConnections = {}

local function SaveSettings()
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(State)) end
    end)
end

local function LoadSettings()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(decoded) do State[k] = v end
        end
    end)
end
LoadSettings()

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
            TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ==========================================
-- 1. INTRO / LOADING SCREEN (ULTRA SMOOTH)
-- ==========================================
local LoadingGui = Instance.new("Frame")
LoadingGui.Size = UDim2.new(0, 440, 0, 250)
LoadingGui.Position = UDim2.new(0.5, -220, 0.5, -125)
LoadingGui.BackgroundColor3 = Color3.fromRGB(12, 6, 20)
LoadingGui.BackgroundTransparency = 0.05
LoadingGui.ZIndex = 100
LoadingGui.Parent = VoidHubUI

local LGCorner = Instance.new("UICorner")
LGCorner.CornerRadius = UDim.new(0, 28)
LGCorner.Parent = LoadingGui

local LGStroke = Instance.new("UIStroke")
LGStroke.Color = Color3.fromRGB(200, 90, 255)
LGStroke.Transparency = 0.15
LGStroke.Thickness = 2.5
LGStroke.Parent = LoadingGui

local LGLoadingGradient = Instance.new("UIGradient")
LGLoadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 20, 140)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 8, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 3, 14))
}
LGLoadingGradient.Rotation = 45
LGLoadingGradient.Parent = LoadingGui

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 45)
LTitle.Position = UDim2.new(0, 0, 0, 30)
LTitle.BackgroundTransparency = 1
LTitle.Text = "◈ VOIDHUB SUPREME ◈"
LTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LTitle.TextSize = 20
LTitle.Font = Enum.Font.GothamBold
LTitle.ZIndex = 101
LTitle.Parent = LoadingGui

local LSub = Instance.new("TextLabel")
LSub.Size = UDim2.new(1, 0, 0, 25)
LSub.Position = UDim2.new(0, 0, 0, 70)
LSub.BackgroundTransparency = 1
LSub.Text = "Cyberpunk Luxury Engine v8.0 [KIO]"
LSub.TextColor3 = Color3.fromRGB(190, 140, 255)
LSub.TextSize = 11
LSub.Font = Enum.Font.GothamMedium
LSub.ZIndex = 101
LSub.Parent = LoadingGui

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 350, 0, 8)
BarBg.Position = UDim2.new(0.5, -175, 0, 130)
BarBg.BackgroundColor3 = Color3.fromRGB(28, 12, 48)
BarBg.ZIndex = 101
BarBg.Parent = LoadingGui

local BBHCorner = Instance.new("UICorner")
BBHCorner.CornerRadius = UDim.new(1, 0)
BBHCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(220, 90, 255)
BarFill.ZIndex = 102
BarFill.Parent = BarBg

local BFHCorner = Instance.new("UICorner")
BFHCorner.CornerRadius = UDim.new(1, 0)
BFHCorner.Parent = BarFill

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 0, 30)
PercentText.Position = UDim2.new(0, 0, 0, 155)
PercentText.BackgroundTransparency = 1
PercentText.Text = "Initializing Modules... 0%"
PercentText.TextColor3 = Color3.fromRGB(230, 200, 255)
PercentText.TextSize = 11
PercentText.Font = Enum.Font.GothamBold
PercentText.ZIndex = 101
PercentText.Parent = LoadingGui

-- FLOATING TOGGLE BUTTON (PILL SHAPE)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 110, 0, 44)
OpenBtn.Position = UDim2.new(0.03, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(18, 8, 30)
OpenBtn.BackgroundTransparency = 0.15
OpenBtn.Text = "◈ VOID v8"
OpenBtn.TextColor3 = Color3.fromRGB(245, 180, 255)
OpenBtn.TextSize = 13
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.ZIndex = 90
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenGlow = Instance.new("UIStroke")
OpenGlow.Color = Color3.fromRGB(210, 100, 255)
OpenGlow.Transparency = 0.2
OpenGlow.Thickness = 2.5
OpenGlow.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN WINDOW FRAME
-- ==========================================
local TargetSize = UDim2.new(0, 620, 0, 400)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 4, 16)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 28)
MainCorner.Parent = MainFrame

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 20, 140)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(16, 6, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 2, 10))
}
GlassGradient.Rotation = 135
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(220, 110, 255)
GlassStroke.Transparency = 0.25
GlassStroke.Thickness = 2
GlassStroke.Parent = MainFrame

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 58)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Position = UDim2.new(0, 24, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "◈ VoidHub <font color=\"#E080FF\">Supreme v8.0</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -48, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 70)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 200, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 160, 1, -70)
Sidebar.Position = UDim2.new(0, 16, 0, 62)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 8)
SBLayout.Parent = Sidebar

-- CONTENT CONTAINER
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -196, 1, -72)
ContentArea.Position = UDim2.new(0, 182, 0, 60)
ContentArea.BackgroundColor3 = Color3.fromRGB(14, 6, 24)
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
    page.ScrollBarImageColor3 = Color3.fromRGB(210, 100, 255)
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    return page
end

local InfoTabPage = CreatePage("Info")
local VisualTabPage = CreatePage("Visual")
local MovementTabPage = CreatePage("Movement")
local FarmTabPage = CreatePage("Farm")
local TeleportTabPage = CreatePage("Teleport")
local MiscTabPage = CreatePage("Misc")

InfoTabPage.Visible = true

local function CreateTabButton(symbol, text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(160, 60, 255) or Color3.fromRGB(24, 10, 40)
    btn.BackgroundTransparency = defaultActive and 0.1 or 0.4
    btn.Text = "   " .. symbol .. "  " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 150, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 12
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- FULL BULAT / PILL SHAPE
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(24, 10, 40), BackgroundTransparency = 0.4}):Play()
                b.TextColor3 = Color3.fromRGB(180, 150, 220)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(160, 60, 255), BackgroundTransparency = 0.1}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTabButton("◆", "Overview", InfoTabPage, true)
CreateTabButton("👁", "Player ESP", VisualTabPage, false)
CreateTabButton("⚡", "Movement", MovementTabPage, false)
CreateTabButton("⬢", "Auto Helpers", FarmTabPage, false)
CreateTabButton("▲", "Teleports", TeleportTabPage, false)
CreateTabButton("⚙", "System Tools", MiscTabPage, false)

-- ==========================================
-- UI COMPONENT CREATORS (BULAT & PREMIUM)
-- ==========================================
local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(24, 10, 40)
    frame.BackgroundTransparency = 0.3
    frame.ZIndex = 13
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0) -- FULL BULAT
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(245, 235, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 50, 0, 26)
    switch.Position = UDim2.new(1, -60, 0.5, -13)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(170, 70, 255) or Color3.fromRGB(38, 16, 60)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = defaultState and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
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
            TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(170, 70, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(38, 16, 60)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, symbol, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(38, 16, 62)
    btn.BackgroundTransparency = 0.25
    btn.Text = "   " .. symbol .. "  " .. titleText
    btn.TextColor3 = Color3.fromRGB(255, 240, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0) -- FULL BULAT
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local origColor = btn.BackgroundColor3
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(180, 80, 255)}):Play()
        task.wait(0.12)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = origColor}):Play()
        callback()
    end)
end

-- ==========================================
-- 3. OVERVIEW TAB
-- ==========================================
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, 0, 0, 220)
Card.BackgroundColor3 = Color3.fromRGB(24, 10, 40)
Card.BackgroundTransparency = 0.3
Card.ZIndex = 13
Card.Parent = InfoTabPage

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 20)
CCorner.Parent = Card

local CTitle = Instance.new("TextLabel")
CTitle.Size = UDim2.new(1, -24, 0, 36)
CTitle.Position = UDim2.new(0, 16, 0, 10)
CTitle.BackgroundTransparency = 1
CTitle.Text = "◈ SYSTEM CHANGELOG & INFORMATION"
CTitle.TextColor3 = Color3.fromRGB(255, 210, 130)
CTitle.TextSize = 13
CTitle.Font = Enum.Font.GothamBold
CTitle.TextXAlignment = Enum.TextXAlignment.Left
CTitle.ZIndex = 14
CTitle.Parent = Card

local CDesc = Instance.new("TextLabel")
CDesc.Size = UDim2.new(1, -32, 0, 160)
CDesc.Position = UDim2.new(0, 16, 0, 48)
CDesc.BackgroundTransparency = 1
CDesc.Text = "Selamat datang di VoidHub Supreme v8.0 Luxury Edition!\n\n• Hapus total Egg ESP & Prediksi.\n• Perbaikan Player ESP agar dapat dinyalakan/dimatikan secara instan.\n• Pembaruan UI total dengan tema Cyberpunk Glassmorphic dan Tombol Bulat Presisi.\n• Penambahan fitur Auto Clicker, Movement Modifiers & Teleportation Suite."
CDesc.TextColor3 = Color3.fromRGB(220, 200, 245)
CDesc.TextSize = 11
CDesc.Font = Enum.Font.GothamMedium
CDesc.TextWrapped = true
CDesc.TextXAlignment = Enum.TextXAlignment.Left
CDesc.TextYAlignment = Enum.TextYAlignment.Top
CDesc.ZIndex = 14
CDesc.Parent = Card

-- ==========================================
-- 4. VISUAL TAB (FIXED PLAYER ESP)
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
        hl.FillColor = Color3.fromRGB(150, 70, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.35
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
-- 5. MOVEMENT TAB
-- ==========================================
CreateToggle(MovementTabPage, "⚡ Speed Boost (24)", State.WalkSpeed, function(active)
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

CreateToggle(MovementTabPage, "▲ Super Jump Power (100)", State.JumpPower, function(active)
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
-- 6. FARM & HELPERS TAB (STEAL ANEGG INSPIRED)
-- ==========================================
CreateToggle(FarmTabPage, "⬢ Auto Clicker / Tap Simulator", State.AutoClicker, function(active)
    State.AutoClicker = active
    task.spawn(function()
        while State.AutoClicker do
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            task.wait(0.05)
        end
    end)
end)

CreateButton(FarmTabPage, "⚡", "Instant Hatch / Interaction Helper", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
            end
        end
    end)
end)

-- ==========================================
-- 7. TELEPORT TAB
-- ==========================================
local function TeleportTo(cframe)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end)
end

CreateButton(TeleportTabPage, "▲", "Teleport to Spawn", function()
    TeleportTo(CFrame.new(0, 10, 0))
end)

CreateButton(TeleportTabPage, "🛍", "Teleport to Shop Zone", function()
    local shop = workspace:FindFirstChild("Shop") or workspace:FindFirstChild("Store")
    if shop then
        TeleportTo(shop:GetPivot())
    else
        TeleportTo(CFrame.new(50, 10, 50))
    end
end)

CreateButton(TeleportTabPage, "👑", "Teleport to VIP / Upgrade Area", function()
    local vip = workspace:FindFirstChild("VIP") or workspace:FindFirstChild("Upgrades")
    if vip then
        TeleportTo(vip:GetPivot())
    else
        TeleportTo(CFrame.new(-50, 10, -50))
    end
end)

-- ==========================================
-- 8. SYSTEM TOOLS TAB
-- ==========================================
CreateToggle(MiscTabPage, "🛡 Safe Anti-AFK", State.AntiAFK, function(active)
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

CreateToggle(MiscTabPage, "⚡ FPS Booster (Lower Graphics)", State.FPSBooster, function(active)
    State.FPSBooster = active
    if active then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)
    end
end)

CreateButton(MiscTabPage, "🔄", "Rejoin Current Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

CreateButton(MiscTabPage, "🌐", "Server Hop (Low Player Server)", function()
    pcall(function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(req.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
end)

CreateButton(MiscTabPage, "📋", "Copy JobID to Clipboard", function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

-- OPEN BUTTON EVENT
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- INITIAL ANIMATED LOADING SEQUENCE
task.spawn(function()
    for i = 1, 100 do
        BarFill.Size = UDim2.new(i/100, 0, 1, 0)
        PercentText.Text = "Loading Cyberpunk Core... " .. i .. "%"
        task.wait(0.008)
    end
    task.wait(0.15)
    
    local fadeTween = TweenService:Create(LoadingGui, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    fadeTween:Play()
    
    task.wait(0.35)
    LoadingGui:Destroy()
    
    MainFrame.Visible = true
    OpenBtn.Visible = false
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)
