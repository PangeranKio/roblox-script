-- [[ VOIDHUB CUSTOM UI - iOS ULTRA EDITION v3 ]] --
-- Created by Kio

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Clean Up GUI Lama (Anti Double-Load)
if CoreGui:FindFirstChild("VoidHubUI") then
    CoreGui.VoidHubUI:Destroy()
end

-- ScreenGui Utama
local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- FUNCTION: CUSTOM DRAGGABLE (ANTI-CHEAT SAFE)
-- ==========================================
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
-- 1. FLOATING LOGO "VH" (MINIMIZE BUTTON)
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 10, 32)
OpenBtn.BackgroundTransparency = 0 -- 0% Transparency
OpenBtn.Text = "VH"
OpenBtn.TextColor3 = Color3.fromRGB(215, 170, 255)
OpenBtn.TextSize = 16
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(140, 80, 220)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. MAIN FRAME (iOS GRADIENT BLACK-PURPLE)
-- ==========================================
local TargetSize = UDim2.new(0, 480, 0, 300)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, TargetSize.X.Offset, 0, TargetSize.Y.Offset)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 22)
MainFrame.BackgroundTransparency = 0 -- Background 0% Transparan
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Gradient Black - Purple
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 16, 58)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 10, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 16))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(90, 50, 140)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- TOPBAR (HEADER)
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.Position = UDim2.new(0, 0, 0, 0)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VoidHub <font color=\"#B480FF\">iOS Edition</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

-- CLOSE BUTTON (iOS Style)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220, 200, 245)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- ==========================================
-- 3. SIDEBAR CATEGORIES (NAVIGASI TAP)
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 12, 34)
Sidebar.BackgroundTransparency = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 6)
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 8)
SidePadding.PaddingLeft = UDim.new(0, 6)
SidePadding.PaddingRight = UDim.new(0, 6)
SidePadding.Parent = Sidebar

-- CONTAINER KONTEN UTAMA
local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -148, 1, -52)
PageContainer.Position = UDim2.new(0, 138, 0, 42)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local Pages = {}

local function CreateTab(name, symbol)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(32, 18, 48)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = symbol .. "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(160, 140, 190)
    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = TabBtn
    
    local BtnPadding = Instance.new("UIPadding")
    BtnPadding.PaddingLeft = UDim.new(0, 10)
    BtnPadding.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(140, 80, 220)
    Page.Visible = false
    Page.Parent = PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page

    Pages[name] = {Button = TabBtn, Page = Page}

    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Pages) do
            tab.Button.BackgroundTransparency = 1
            tab.Button.TextColor3 = Color3.fromRGB(160, 140, 190)
            tab.Page.Visible = false
        end
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
        Page.Visible = true
    end)
end

-- Buat Tab Kategori
CreateTab("AFK", "⚙")
CreateTab("Server", "🌐")
CreateTab("Misc", "✦")

-- Set Tab AFK Aktif Default
Pages["AFK"].Button.BackgroundTransparency = 0
Pages["AFK"].Button.TextColor3 = Color3.fromRGB(245, 240, 255)
Pages["AFK"].Page.Visible = true

-- Helper UI Card iOS Style
local function CreateCard(parent, titleText, height)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, height or 50)
    Card.BackgroundColor3 = Color3.fromRGB(25, 14, 38)
    Card.Parent = parent

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(60, 35, 90)
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    if titleText then
        local CardTitle = Instance.new("TextLabel")
        CardTitle.Size = UDim2.new(1, -20, 0, 25)
        CardTitle.Position = UDim2.new(0, 12, 0, 12)
        CardTitle.BackgroundTransparency = 1
        CardTitle.Text = titleText
        CardTitle.TextColor3 = Color3.fromRGB(235, 230, 250)
        CardTitle.TextSize = 13
        CardTitle.Font = Enum.Font.SourceSansBold
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.Parent = Card
    end

    return Card
end

-- ==========================================
-- 4. KATEGORI AFK (AUTO CLICKER & MARKER)
-- ==========================================
local AFKPage = Pages["AFK"].Page

-- Card 1: Toggle Anti-AFK
local AFKCard = CreateCard(AFKPage, "Auto Clicker Anti-AFK", 52)

local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(0, 44, 0, 24)
SwitchBtn.Position = UDim2.new(1, -54, 0.5, -12)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
SwitchBtn.Text = ""
SwitchBtn.Parent = AFKCard

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(1, 0)
SwitchCorner.Parent = SwitchBtn

local SwitchCircle = Instance.new("Frame")
SwitchCircle.Size = UDim2.new(0, 20, 0, 20)
SwitchCircle.Position = UDim2.new(0, 2, 0.5, -10)
SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchCircle.Parent = SwitchBtn

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = SwitchCircle

-- Card 2: Interval Setting
local IntervalCard = CreateCard(AFKPage, "Click Interval (Detik)", 52)

local IntervalVal = 5
local IntervalLabel = Instance.new("TextLabel")
IntervalLabel.Size = UDim2.new(0, 40, 0, 24)
IntervalLabel.Position = UDim2.new(1, -95, 0.5, -12)
IntervalLabel.BackgroundTransparency = 1
IntervalLabel.Text = tostring(IntervalVal) .. "s"
IntervalLabel.TextColor3 = Color3.fromRGB(200, 180, 235)
IntervalLabel.TextSize = 13
IntervalLabel.Font = Enum.Font.SourceSansBold
IntervalLabel.Parent = IntervalCard

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 24, 0, 24)
MinusBtn.Position = UDim2.new(1, -125, 0.5, -12)
MinusBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.Font = Enum.Font.SourceSansBold
MinusBtn.Parent = IntervalCard
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 24, 0, 24)
PlusBtn.Position = UDim2.new(1, -50, 0.5, -12)
PlusBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.Font = Enum.Font.SourceSansBold
PlusBtn.Parent = IntervalCard
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

MinusBtn.MouseButton1Click:Connect(function()
    if IntervalVal > 1 then
        IntervalVal = IntervalVal - 1
        IntervalLabel.Text = tostring(IntervalVal) .. "s"
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    IntervalVal = IntervalVal + 1
    IntervalLabel.Text = tostring(IntervalVal) .. "s"
end)

-- CLICK MARKER TARGET (BISA DI DRAG)
local ClickMarker = Instance.new("Frame")
ClickMarker.Name = "ClickMarker"
ClickMarker.Size = UDim2.new(0, 34, 0, 34)
ClickMarker.Position = UDim2.new(0.5, -17, 0.5, -17)
ClickMarker.BackgroundColor3 = Color3.fromRGB(160, 90, 240)
ClickMarker.BackgroundTransparency = 0.4
ClickMarker.Visible = false
ClickMarker.Active = true
ClickMarker.Parent = VoidHubUI

local MarkerCorner = Instance.new("UICorner")
MarkerCorner.CornerRadius = UDim.new(1, 0)
MarkerCorner.Parent = ClickMarker

local MarkerDot = Instance.new("Frame")
MarkerDot.Size = UDim2.new(0, 8, 0, 8)
MarkerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
MarkerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MarkerDot.Parent = ClickMarker
Instance.new("UICorner", MarkerDot).CornerRadius = UDim.new(1, 0)

MakeDraggable(ClickMarker, ClickMarker)

-- LOGIKA AUTO CLICKER ANTI-AFK
local AntiAFKActive = false
local ClickThread = nil

SwitchBtn.MouseButton1Click:Connect(function()
    AntiAFKActive = not AntiAFKActive
    
    if AntiAFKActive then
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 80, 220)}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        ClickMarker.Visible = true
        
        ClickThread = task.spawn(function()
            while AntiAFKActive do
                task.wait(IntervalVal)
                if AntiAFKActive then
                    -- Simulasi Klik di Posisi Marker
                    local PosX = ClickMarker.AbsolutePosition.X + (ClickMarker.AbsoluteSize.X / 2)
                    local PosY = ClickMarker.AbsolutePosition.Y + (ClickMarker.AbsoluteSize.Y / 2) + 36 -- Offset Topbar
                    
                    VirtualInputManager:SendMouseButtonEvent(PosX, PosY, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(PosX, PosY, 0, false, game, 1)
                    
                    -- Visual Click Pulse Effect
                    local Pulse = Instance.new("Frame")
                    Pulse.Size = ClickMarker.Size
                    Pulse.Position = ClickMarker.Position
                    Pulse.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Pulse.BackgroundTransparency = 0.5
                    Pulse.Parent = VoidHubUI
                    Instance.new("UICorner", Pulse).CornerRadius = UDim.new(1, 0)
                    
                    TweenService:Create(Pulse, TweenInfo.new(0.3), {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(ClickMarker.Position.X.Scale, ClickMarker.Position.X.Offset - 8, ClickMarker.Position.Y.Scale, ClickMarker.Position.Y.Offset - 8), BackgroundTransparency = 1}):Play()
                    task.delay(0.35, function() Pulse:Destroy() end)
                end
            end
        end)
    else
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 35, 65)}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        ClickMarker.Visible = false
        if ClickThread then
            task.cancel(ClickThread)
            ClickThread = nil
        end
    end
end)

-- ==========================================
-- 5. KATEGORI SERVER
-- ==========================================
local ServerPage = Pages["Server"].Page

-- Card 1: Rejoin Server
local RejoinCard = CreateCard(ServerPage, "Rejoin Server", 52)
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(0, 80, 0, 26)
RejoinBtn.Position = UDim2.new(1, -90, 0.5, -13)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(120, 65, 190)
RejoinBtn.Text = "Rejoin"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 12
RejoinBtn.Font = Enum.Font.SourceSansBold
RejoinBtn.Parent = RejoinCard
Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 8)

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Card 2: Server Hop (Cari Server Sepi)
local HopCard = CreateCard(ServerPage, "Server Hop (Server Sepi)", 52)
local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(0, 80, 0, 26)
HopBtn.Position = UDim2.new(1, -90, 0.5, -13)
HopBtn.BackgroundColor3 = Color3.fromRGB(120, 65, 190)
HopBtn.Text = "Server Hop"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 12
HopBtn.Font = Enum.Font.SourceSansBold
HopBtn.Parent = HopCard
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 8)

HopBtn.MouseButton1Click:Connect(function()
    local Http = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100"))
    for _, s in pairs(Http.data) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

-- Card 3: Ping Server Realtime
local PingCard = CreateCard(ServerPage, "Server Ping", 52)
local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0, 100, 1, 0)
PingLabel.Position = UDim2.new(1, -110, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Checking..."
PingLabel.TextColor3 = Color3.fromRGB(160, 230, 160)
PingLabel.TextSize = 13
PingLabel.Font = Enum.Font.SourceSansBold
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Parent = PingCard

task.spawn(function()
    while task.wait(1) do
        local Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        PingLabel.Text = tostring(Ping) .. " ms"
    end
end)

-- ==========================================
-- 6. KATEGORI MISC (FPS, WEBHOOK, DLL)
-- ==========================================
local MiscPage = Pages["Misc"].Page

-- Card 1: Boost FPS
local FPSBoostCard = CreateCard(MiscPage, "Optimize & Boost FPS", 52)
local BoostBtn = Instance.new("TextButton")
BoostBtn.Size = UDim2.new(0, 80, 0, 26)
BoostBtn.Position = UDim2.new(1, -90, 0.5, -13)
BoostBtn.BackgroundColor3 = Color3.fromRGB(120, 65, 190)
BoostBtn.Text = "Boost"
BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostBtn.TextSize = 12
BoostBtn.Font = Enum.Font.SourceSansBold
BoostBtn.Parent = FPSBoostCard
Instance.new("UICorner", BoostBtn).CornerRadius = UDim.new(0, 8)

BoostBtn.MouseButton1Click:Connect(function()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
    end
    game:GetService("Lighting").GlobalShadows = false
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    BoostBtn.Text = "Boosted!"
end)

-- Card 2: Show FPS Counter
local ShowFPSCard = CreateCard(MiscPage, "Show FPS Counter", 52)
local FPSSwitch = Instance.new("TextButton")
FPSSwitch.Size = UDim2.new(0, 44, 0, 24)
FPSSwitch.Position = UDim2.new(1, -54, 0.5, -12)
FPSSwitch.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
FPSSwitch.Text = ""
FPSSwitch.Parent = ShowFPSCard
Instance.new("UICorner", FPSSwitch).CornerRadius = UDim.new(1, 0)

local FPSSwitchCircle = Instance.new("Frame")
FPSSwitchCircle.Size = UDim2.new(0, 20, 0, 20)
FPSSwitchCircle.Position = UDim2.new(0, 2, 0.5, -10)
FPSSwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FPSSwitchCircle.Parent = FPSSwitch
Instance.new("UICorner", FPSSwitchCircle).CornerRadius = UDim.new(1, 0)

local FPSLabel = Instance.
