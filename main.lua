-- [[ VOIDHUB CUSTOM UI - ULTRA PREMIUM GLASSMORPHISM v3.0 ]] --
-- Created by Kio (Massive UI Overhaul & Fixed Egg ESP Tracker)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
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
-- FUNCTION: CUSTOM DRAGGABLE (SMOOTH TOUCH)
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
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0.08, 0, 0.22, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(220, 160, 255)
OpenBtn.TextSize = 20
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenGlow = Instance.new("UIStroke")
OpenGlow.Color = Color3.fromRGB(180, 100, 255)
OpenGlow.Transparency = 0.2
OpenGlow.Thickness = 2
OpenGlow.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. ULTRA PREMIUM LOADING SCREEN
-- ==========================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 260, 0, 110)
LoadingFrame.Position = UDim2.new(0.5, -130, 0.5, -55)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(12, 6, 20)
LoadingFrame.BackgroundTransparency = 0.05
LoadingFrame.Parent = VoidHubUI

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 20)
LoadCorner.Parent = LoadingFrame

local LoadGradient = Instance.new("UIGradient")
LoadGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 15, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 18))
}
LoadGradient.Rotation = 45
LoadGradient.Parent = LoadingFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(200, 120, 255)
LoadStroke.Transparency = 0.3
LoadStroke.Thickness = 1.8
LoadStroke.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0, 20)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "VOIDHUB <font color=\"#D480FF\">ENGINE</font>"
LoadTitle.RichText = true
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 18
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 22)
LoadStatus.Position = UDim2.new(0, 0, 0, 60)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Authenticating Secure Modules..."
LoadStatus.TextColor3 = Color3.fromRGB(180, 150, 220)
LoadStatus.TextSize = 12
LoadStatus.Font = Enum.Font.GothamMedium
LoadStatus.Parent = LoadingFrame

-- ==========================================
-- 3. MAIN WINDOW (ULTRA GLASSMORPHISM)
-- ==========================================
local TargetSize = UDim2.new(0, 480, 0, 300)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 16)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 18, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 8, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 3, 14))
}
GlassGradient.Rotation = 120
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(190, 110, 255)
GlassStroke.Transparency = 0.35
GlassStroke.Thickness = 1.8
GlassStroke.Parent = MainFrame

-- TOPBAR / HEADER
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 46)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ VOIDHUB <font color=\"#C080FF\">PRO</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(230, 190, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

local CBStroke = Instance.new("UIStroke")
CBStroke.Color = Color3.fromRGB(200, 130, 255)
CBStroke.Transparency = 0.5
CBStroke.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- ==========================================
-- SIDEBAR NAVIGATION (STYLISH GLASS)
-- ==========================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 135, 1, -56)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = MainFrame

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 8)
SBLayout.Parent = Sidebar

-- ==========================================
-- CONTAINER KONTEN KANAN (GLASS CARD)
-- ==========================================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -56)
ContentArea.Position = UDim2.new(0, 152, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 8, 24)
ContentArea.BackgroundTransparency = 0.45
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 14)
CACorner.Parent = ContentArea

local CAStroke = Instance.new("UIStroke")
CAStroke.Color = Color3.fromRGB(255, 255, 255)
CAStroke.Transparency = 0.85
CAStroke.Parent = ContentArea

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
    page.ScrollBarImageColor3 = Color3.fromRGB(160, 90, 255)
    page.Visible = false
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    
    return page
end

local MainTabPage = CreatePage("Main")
local WalkTabPage = CreatePage("Walk")
local MiscTabPage = CreatePage("Misc")
MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(115, 45, 215) or Color3.fromRGB(22, 12, 35)
    btn.BackgroundTransparency = defaultActive and 0.1 or 0.5
    btn.Text = "   " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 145, 215)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(200, 130, 255)
    stroke.Transparency = defaultActive and 0.4 or 0.9
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 12, 35), BackgroundTransparency = 0.5}):Play()
                b.TextColor3 = Color3.fromRGB(175, 145, 215)
                if b:FindFirstChild("UIStroke") then b.UIStroke.Transparency = 0.9 end
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(115, 45, 215), BackgroundTransparency = 0.1}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if btn:FindFirstChild("UIStroke") then btn.UIStroke.Transparency = 0.4 end
    end)
end

CreateTabButton("Steal an Egg", MainTabPage, true)
CreateTabButton("Walk", WalkTabPage, false)
CreateTabButton("Misc", MiscTabPage, false)

-- ==========================================
-- PREMIUM TOGGLE BUILDER
-- ==========================================
local function CreateToggle(parent, titleText, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
    frame.BackgroundTransparency = 0.35
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 10)
    fCorner.Parent = frame

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(255, 255, 255)
    fStroke.Transparency = 0.9
    fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(240, 230, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.Position = UDim2.new(1, -50, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(40, 22, 60)
    switch.Text = ""
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = Instance.new("Frame") and UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = switch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local active = false
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 70, 240)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 22, 60)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
        callback(active)
    end)
end

-- ==========================================
-- PREMIUM BUTTON BUILDER
-- ==========================================
local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 18, 55)
    btn.BackgroundTransparency = 0.25
    btn.Text = titleText
    btn.TextColor3 = Color3.fromRGB(245, 230, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(190, 110, 255)
    bStroke.Transparency = 0.5
    bStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- FITUR: MAIN TAB (FIXED EGG & ITEM ESP)
-- ==========================================

-- Player ESP
local function CreatePlayerESP(plr)
    if plr == LocalPlayer then return end
    local function addBox(char)
        if char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("VoidESP_Box") then
            local bill = Instance.new("BillboardGui")
            bill.Name = "VoidESP_Box"
            bill.Size = UDim2.new(0, 50, 0, 50)
            bill.AlwaysOnTop = true
            bill.StudsOffset = Vector3.new(0, 2.5, 0)
            bill.Parent = char.Head
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = plr.Name
            text.TextColor3 = Color3.fromRGB(210, 140, 255)
            text.TextSize = 11
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = 0.3
            text.Parent = bill
        end
    end
    plr.CharacterAdded:Connect(addBox)
    if plr.Character then addBox(plr.Character) end
end

CreateToggle(MainTabPage, "Player ESP", function(state)
    _G.PlayerESPActive = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do CreatePlayerESP(p) end
        Players.PlayerAdded:Connect(CreatePlayerESP)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local esp = p.Character.Head:FindFirstChild("VoidESP_Box")
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- Enhanced Egg ESP (Fix Pencarian Menyeluruh ke Model, Folder, & Part Telur)
local function RefreshEggs()
    for _, obj in pairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        -- Cek apakah objek mengandung kata kunci telur/egg/item atau berada di dalam folder telur
        if nameLower:find("egg") or nameLower:find("telur") or nameLower:find("item") then
            local targetPart = nil
            if obj:IsA("BasePart") then
                targetPart = obj
            elseif obj:IsA("Model") and obj.PrimaryPart then
                targetPart = obj.PrimaryPart
            elseif obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") then
                targetPart = obj:FindFirstChildWhichIsA("BasePart")
            end
            
            if targetPart and targetPart.Transparency < 0.95 then
                -- Highlight Bersinar
                if not targetPart:FindFirstChild("EggHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "EggHighlight"
                    hl.FillColor = Color3.fromRGB(160, 60, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.35
                    hl.Parent = targetPart
                end
                
                -- Tag Informasi Isi & Berat Telur
                if not targetPart:FindFirstChild("EggInfoTag") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "EggInfoTag"
                    bill.Size = UDim2.new(0, 120, 0, 45)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 2.5, 0)
                    bill.Parent = targetPart
                    
                    local txt = Instance.new("TextLabel")
                    txt.Name = "InfoText"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 220, 120)
                    txt.TextSize = 11
                    txt.Font = Enum.Font.GothamBold
                    txt.TextStrokeTransparency = 0.2
                    txt.Text = obj.Name
                    txt.Parent = bill
                else
                    -- Update Teks Nilai / Berat Telur secara dinamis
                    local txt = targetPart.EggInfoTag:FindFirstChild("InfoText")
                    if txt then
                        local displayText = obj.Name
                        -- Ambil info dari nilai anak (Value / Attribute) jika ada
                        for _, child in pairs(obj:GetChildren()) do
                            if child:IsA("StringValue") or child:IsA("NumberValue") or child:IsA("IntValue") then
                                displayText = obj.Name .. "\n[" .. tostring(child.Value) .. "]"
                            end
                        end
                        txt.Text = displayText
                    end
                end
            end
        end
    end
end

CreateToggle(MainTabPage, "Egg ESP (Auto Scan & Info)", function(state)
    _G.EggESPActive = state
    task.spawn(function()
        while _G.EggESPActive do
            pcall(RefreshEggs)
            task.wait(1.2)
        end
        -- Bersihkan semua ESP telur ketika dimatikan
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj:FindFirstChild("EggHighlight") then obj.EggHighlight:Destroy() end
                if obj:FindFirstChild("EggInfoTag") then obj.EggInfoTag:Destroy() end
            end
        end
    end)
end)

CreateButton(MainTabPage, "🔄 Refresh Egg ESP Now", function()
    pcall(RefreshEggs)
end)


-- ==========================================
-- FITUR: WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "Custom WalkSpeed (24)", function(state)
    if state then
        _G.SpeedActive = true
        task.spawn(function()
            while _G.SpeedActive do
                pcall(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 24 end
                end)
                task.wait(0.2)
            end
        end)
    else
        _G.SpeedActive = false
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)


-- ==========================================
-- FITUR: MISC TAB (SERVER HOPE, REJOIN, ANTI-AFK)
-- ==========================================
CreateToggle(MiscTabPage, "Anti-AFK Safe", function(state)
    if state then
        _G.AntiAFKActive = true
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
                task.run(RunService.RenderStepped)
            end
        end)
    else
        _G.AntiAFKActive = false
    end
end)

-- Tombol Rejoin Server
CreateButton(MiscTabPage, "🔄 Rejoin Server", function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

-- Tombol Server Hop (Mencari Server Sepi)
CreateButton(MiscTabPage, "🌐 Server Hope (Cari Server Sepi)", function()
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
        else
            warn("Server sepi tidak ditemukan, silakan coba lagi.")
        end
    end)
end)

-- ==========================================
-- 5. RESIZE HANDLE (SMOOTH CORNER DRAG)
-- ==========================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(170, 130, 200)
ResizeHandle.TextSize = 10
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Parent = MainFrame

local Resizing, StartSize, StartInputPos = false, nil, nil
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        StartSize = MainFrame.Size
        StartInputPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - StartInputPos
        local NewX = math.max(420, StartSize.X.Offset + Delta.X)
        local NewY = math.max(240, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- ==========================================
-- 6. ANIMASI PEMBUKAAN WINDOW
-- ==========================================
local TweenBack = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)

-- ==========================================
-- 7. EXECUTION LOADING PROCESS
-- ==========================================
task.spawn(function()
    pcall(function()
        task.wait(0.35)
        LoadStatus.Text = "Rendering Glassmorphism UI..."
        task.wait(0.35)
        LoadStatus.Text = "Injecting Advanced ESP Modules..."
        task.wait(0.35)
    end)
    
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame:Destroy()
    end
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)
