-- [[ VOIDHUB SUPREME ULTRA v7.0 - CYBERPUNK LUXURY EDITION ]] --
-- Fixed Loading & Menu Toggle Sequence by Kio

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("VoidHubUI") then
    CoreGui.VoidHubUI:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- CONFIG SYSTEM
local ConfigFileName = "VoidHub_Config_Kio_v7.json"
local SavedConfig = {
    PlayerESPActive = false,
    EggESPActive = false,
    AutoTreadmill = false,
    WalkSpeedActive = false
}

local function SaveSettings()
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(SavedConfig)) end
    end)
end

local function LoadSettings()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(decoded) do SavedConfig[k] = v end
        end
    end)
end
LoadSettings()

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
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- 1. INITIAL LOADING SCREEN
-- ==========================================
local LoadingGui = Instance.new("Frame")
LoadingGui.Size = UDim2.new(0, 420, 0, 240)
LoadingGui.Position = UDim2.new(0.5, -210, 0.5, -120)
LoadingGui.BackgroundColor3 = Color3.fromRGB(10, 4, 18)
LoadingGui.BackgroundTransparency = 0.05
LoadingGui.ZIndex = 50
LoadingGui.Parent = VoidHubUI

local LGCorner = Instance.new("UICorner")
LGCorner.CornerRadius = UDim.new(0, 24)
LGCorner.Parent = LoadingGui

local LGStroke = Instance.new("UIStroke")
LGStroke.Color = Color3.fromRGB(220, 100, 255)
LGStroke.Transparency = 0.2
LGStroke.Thickness = 2.5
LGStroke.Parent = LoadingGui

local LGLoadingGradient = Instance.new("UIGradient")
LGLoadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 25, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 6, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 2, 10))
}
LGLoadingGradient.Rotation = 45
LGLoadingGradient.Parent = LoadingGui

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 45)
LTitle.Position = UDim2.new(0, 0, 0, 25)
LTitle.BackgroundTransparency = 1
LTitle.Text = "⚡ VOIDHUB SUPREME ⚡"
LTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LTitle.TextSize = 18
LTitle.Font = Enum.Font.GothamBold
LTitle.ZIndex = 51
LTitle.Parent = LoadingGui

local LSub = Instance.new("TextLabel")
LSub.Size = UDim2.new(1, 0, 0, 25)
LSub.Position = UDim2.new(0, 0, 0, 65)
LSub.BackgroundTransparency = 1
LSub.Text = "Initializing Secure Core System [KIO]..."
LSub.TextColor3 = Color3.fromRGB(200, 150, 255)
LSub.TextSize = 11
LSub.Font = Enum.Font.GothamMedium
LSub.ZIndex = 51
LSub.Parent = LoadingGui

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 340, 0, 10)
BarBg.Position = UDim2.new(0.5, -170, 0, 120)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
BarBg.ZIndex = 51
BarBg.Parent = LoadingGui

local BBHCorner = Instance.new("UICorner")
BBHCorner.CornerRadius = UDim.new(1, 0)
BBHCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(210, 80, 255)
BarFill.ZIndex = 52
BarFill.Parent = BarBg

local BFHCorner = Instance.new("UICorner")
BFHCorner.CornerRadius = UDim.new(1, 0)
BFHCorner.Parent = BarFill

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 0, 30)
PercentText.Position = UDim2.new(0, 0, 0, 145)
PercentText.BackgroundTransparency = 1
PercentText.Text = "Loading Assets: 0%"
PercentText.TextColor3 = Color3.fromRGB(240, 210, 255)
PercentText.TextSize = 11
PercentText.Font = Enum.Font.GothamBold
PercentText.ZIndex = 51
PercentText.Parent = LoadingGui

-- FLOATING OPEN BUTTON
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 95, 0, 42)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 6, 26)
OpenBtn.BackgroundTransparency = 0.15
OpenBtn.Text = "💎 VOID v7"
OpenBtn.TextColor3 = Color3.fromRGB(245, 180, 255)
OpenBtn.TextSize = 13
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.ZIndex = 100
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenGlow = Instance.new("UIStroke")
OpenGlow.Color = Color3.fromRGB(220, 110, 255)
OpenGlow.Transparency = 0.2
OpenGlow.Thickness = 2.5
OpenGlow.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN WINDOW
-- ==========================================
local TargetSize = UDim2.new(0, 580, 0, 380)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 2, 14)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 24)
MainCorner.Parent = MainFrame

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 15, 125)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(14, 4, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 1, 8))
}
GlassGradient.Rotation = 140
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(230, 120, 255)
GlassStroke.Transparency = 0.2
GlassStroke.Thickness = 2.2
GlassStroke.Parent = MainFrame

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 55)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 11
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 360, 1, 0)
Title.Position = UDim2.new(0, 22, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 VoidHub <font color=\"#D880FF\">Supreme v7.0 [KIO]</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -45, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 12, 75)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 200, 255)
CloseBtn.TextSize = 13
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

-- SIDEBAR MENU
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 155, 1, -70)
Sidebar.Position = UDim2.new(0, 14, 0, 60)
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

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -185, 1, -70)
ContentArea.Position = UDim2.new(0, 175, 0, 60)
ContentArea.BackgroundColor3 = Color3.fromRGB(12, 5, 22)
ContentArea.BackgroundTransparency = 0.35
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 18)
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
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(200, 100, 255)
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    return page
end

local AnnounceTabPage = CreatePage("Announce")
local MainTabPage = CreatePage("Main")
local WalkTabPage = CreatePage("Walk")
local MiscTabPage = CreatePage("Misc")
local ConfigTabPage = CreatePage("Config")
AnnounceTabPage.Visible = true

local function CreateTabButton(iconSymbol, text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(150, 60, 250) or Color3.fromRGB(22, 10, 36)
    btn.BackgroundTransparency = defaultActive and 0.05 or 0.45
    btn.Text = "   " .. iconSymbol .. "  " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 160, 230)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
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
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 10, 36), BackgroundTransparency = 0.45}):Play()
                b.TextColor3 = Color3.fromRGB(190, 160, 230)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 60, 250), BackgroundTransparency = 0.05}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTabButton("📢", "Announcement", AnnounceTabPage, true)
CreateTabButton("🥚", "Visual & ESP", MainTabPage, false)
CreateTabButton("⚡", "Walk & Speed", WalkTabPage, false)
CreateTabButton("⚙️", "Misc Tools", MiscTabPage, false)
CreateTabButton("💾", "Settings", ConfigTabPage, false)

local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(22, 10, 36)
    frame.BackgroundTransparency = 0.25
    frame.ZIndex = 13
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 14)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(250, 240, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 14
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 48, 0, 26)
    switch.Position = UDim2.new(1, -56, 0.5, -13)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(160, 70, 255) or Color3.fromRGB(35, 18, 55)
    switch.Text = ""
    switch.ZIndex = 14
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = defaultState and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
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
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 70, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 18, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, iconSymbol, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
    btn.BackgroundTransparency = 0.2
    btn.Text = "   " .. iconSymbol .. "  " .. titleText
    btn.TextColor3 = Color3.fromRGB(255, 240, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 13
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 14)
    bCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 3. KATEGORI PENGUMUMAN
-- ==========================================
local AnnounceCard = Instance.new("Frame")
AnnounceCard.Size = UDim2.new(1, 0, 0, 230)
AnnounceCard.BackgroundColor3 = Color3.fromRGB(22, 10, 38)
AnnounceCard.BackgroundTransparency = 0.2
AnnounceCard.ZIndex = 13
AnnounceCard.Parent = AnnounceTabPage

local ACCorner = Instance.new("UICorner")
ACCorner.CornerRadius = UDim.new(0, 16)
ACCorner.Parent = AnnounceCard

local ACTitle = Instance.new("TextLabel")
ACTitle.Size = UDim2.new(1, -24, 0, 40)
ACTitle.Position = UDim2.new(0, 12, 0, 8)
ACTitle.BackgroundTransparency = 1
ACTitle.Text = "🛡️ PENGUMUMAN RESMI [KIO]"
ACTitle.TextColor3 = Color3.fromRGB(255, 210, 130)
ACTitle.TextSize = 13
ACTitle.Font = Enum.Font.GothamBold
ACTitle.TextXAlignment = Enum.TextXAlignment.Left
ACTitle.ZIndex = 14
ACTitle.Parent = AnnounceCard

local ACDesc = Instance.new("TextLabel")
ACDesc.Size = UDim2.new(1, -24, 0, 130)
ACDesc.Position = UDim2.new(0, 12, 0, 48)
ACDesc.BackgroundTransparency = 1
ACDesc.Text = "Selamat datang di VoidHub Supreme v7.0!\n\n• Fitur Auto Steal & Prediksi Telur telah dihapus total.\n• Penambahan fitur Player ESP baru untuk memindai pemain lain.\n• UI dirombak total menjadi super mewah bergaya Apple Glassmorphic dengan simbol ikonik.\n• Seluruh tombol kini menggunakan desain melengkung elegan."
ACDesc.TextColor3 = Color3.fromRGB(220, 200, 245)
ACDesc.TextSize = 11
ACDesc.Font = Enum.Font.GothamMedium
ACDesc.TextWrapped = true
ACDesc.TextXAlignment = Enum.TextXAlignment.Left
ACDesc.TextYAlignment = Enum.TextYAlignment.Top
ACDesc.ZIndex = 14
ACDesc.Parent = AnnounceCard

-- ==========================================
-- 4. VISUAL & ESP TAB
-- ==========================================
local function IsValidEgg(name)
    local l = name:lower()
    if l:find("fusion") or l:find("machine") or l:find("shop") or l:find("treadmill") or l:find("gym") then return false end
    return l:find("egg") or l:find("telur")
end

CreateToggle(MainTabPage, "🥚 Egg ESP & Sorted Tracker", SavedConfig.EggESPActive, function(state)
    _G.EggESPActive = state
    SavedConfig.EggESPActive = state
    task.spawn(function()
        while _G.EggESPActive do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if IsValidEgg(obj.Name) then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part and not part:FindFirstChild("VoidEggHL") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "VoidEggHL"
                            hl.FillColor = Color3.fromRGB(180, 80, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.3
                            hl.Parent = part
                        end
                    end
                end
            end)
            task.wait(2)
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("VoidEggHL") then
                obj.VoidEggHL:Destroy()
            end
        end
    end)
end)

CreateToggle(MainTabPage, "👤 Player ESP (Box & Highlight)", SavedConfig.PlayerESPActive, function(state)
    _G.PlayerESPActive = state
    SavedConfig.PlayerESPActive = state
    task.spawn(function()
        while _G.PlayerESPActive do
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local char = p.Character
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root and not root:FindFirstChild("VoidPlayerHL") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "VoidPlayerHL"
                            hl.FillColor = Color3.fromRGB(80, 200, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.4
                            hl.Parent = char
                        end
                    end
                end
            end)
            task.wait(1.5)
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root and root:FindFirstChild("VoidPlayerHL") then
                    root.VoidPlayerHL:Destroy()
                end
            end
        end
    end)
end)

-- ==========================================
-- 5. WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "⚡ Custom WalkSpeed (24)", SavedConfig.WalkSpeedActive, function(state)
    _G.SpeedActive = state
    SavedConfig.WalkSpeedActive = state
    task.spawn(function()
        while _G.SpeedActive do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 24 end
            end)
            task.wait(0.2)
        end
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end)
end)

-- ==========================================
-- 6. MISC TAB
-- ==========================================
CreateToggle(MiscTabPage, "🛡️ Anti-AFK Safe Mode", true, function(state)
    _G.AntiAFKActive = state
    task.spawn(function()
        local lastMove = tick()
        while _G.AntiAFKActive do
            if tick() - lastMove >= 30 then
                lastMove = tick()
                pcall(function()
                    local currentCam = workspace.CurrentCamera
                    if currentCam then
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, 0.001, 0)
                        task.wait(0.05)
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, -0.001, 0)
                    end
                end)
            end
            task.wait(1)
        end
    end)
end)

CreateButton(MiscTabPage, "🔄", "Rejoin Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

CreateButton(MiscTabPage, "🌐", "Server Hop (Cari Server Sepi)", function()
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

-- ==========================================
-- 7. CONFIG TAB
-- ==========================================
CreateButton(ConfigTabPage, "💾", "Save Current Settings", function()
    SaveSettings()
end)

CreateButton(ConfigTabPage, "📂", "Load Config Settings", function()
    LoadSettings()
end)

-- OPEN BUTTON CALLBACK
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- ANIMATE LOADING SEQUENCE (ANIMASI DIBERSIHKAN DAN DIPERBAIKI)
task.spawn(function()
    for i = 1, 100 do
        BarFill.Size = UDim2.new(i/100, 0, 1, 0)
        PercentText.Text = "Loading Assets: " .. i .. "%"
        task.wait(0.01)
    end
    task.wait(0.2)
    
    -- Fade out Loading Screen
    local fadeTween = TweenService:Create(LoadingGui, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    fadeTween:Play()
    
    task.wait(0.4)
    LoadingGui:Destroy()
    
    -- Munculkan Main Window & Open Button
    MainFrame.Visible = true
    OpenBtn.Visible = false
    
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = TargetSize})
    openTween:Play()
end)
