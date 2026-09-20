-- [[ VOIDHUB SUPREME v16.0 - NEON APEX EDITION ]] --
-- UI/UX: Ultra-Premium Acrylic Glassmorphism, Animated Transitions, Ripple Effects
-- Core Engine: Optimized, Bug-Free, Modular Object-Oriented Framework

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 0. GARBAGE COLLECTION & ANTI-DUPLICATION
-- ==========================================
if _G.VoidHubApex then
    for _, connection in pairs(_G.VoidHubApex.Connections) do
        if connection.Connected then connection:Disconnect() end
    end
    if _G.VoidHubApex.UI then _G.VoidHubApex.UI:Destroy() end
end

_G.VoidHubApex = {
    Connections = {},
    UI = nil,
    Flags = {},
    BaseCoord = nil
}

local function Bind(connection)
    table.insert(_G.VoidHubApex.Connections, connection)
    return connection
end

-- ==========================================
-- 1. PREMIUM THEME & ASSET MANAGER
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(10, 12, 18),
    Panel = Color3.fromRGB(16, 20, 28),
    Item = Color3.fromRGB(22, 28, 40),
    Accent1 = Color3.fromRGB(0, 255, 170), -- Neon Green/Cyan
    Accent2 = Color3.fromRGB(255, 0, 100), -- Neon Pink
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 160, 180),
    Outline = Color3.fromRGB(30, 40, 55)
}

local FontPrimary = Enum.Font.GothamBold
local FontSecondary = Enum.Font.GothamMedium

-- ==========================================
-- 2. ANIMATION & UTILITY ENGINE
-- ==========================================
local function Tween(instance, properties, duration, style, direction)
    duration = duration or 0.25
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function CreateRipple(parent, x, y)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.ZIndex = parent.ZIndex + 1
    ripple.Position = UDim2.new(0, x - parent.AbsolutePosition.X, 0, y - parent.AbsolutePosition.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    ripple.Parent = parent
    
    Tween(ripple, {Size = UDim2.new(0, 200, 0, 200), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() ripple:Destroy() end)
end

-- ==========================================
-- 3. PREMIUM UI LIBRARY
-- ==========================================
local UIHub = Instance.new("ScreenGui")
UIHub.Name = "VoidHubApex"
UIHub.Parent = CoreGui
UIHub.ResetOnSpawn = false
_G.VoidHubApex.UI = UIHub

local NotificationLayer = Instance.new("Frame")
NotificationLayer.Size = UDim2.new(0, 300, 1, -20)
NotificationLayer.Position = UDim2.new(1, -320, 0, 10)
NotificationLayer.BackgroundTransparency = 1
NotificationLayer.ZIndex = 999
NotificationLayer.Parent = UIHub

local NotifList = Instance.new("UIListLayout")
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.Padding = UDim.new(0, 10)
NotifList.Parent = NotificationLayer

local function Notify(title, desc, duration)
    duration = duration or 4
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 50, 0, 60)
    card.BackgroundColor3 = Theme.Panel
    card.BackgroundTransparency = 0.1
    card.ClipsDescendants = true
    card.Parent = NotificationLayer

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Theme.Accent1
    stroke.Thickness = 1.5

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -20, 0, 20)
    lblTitle.Position = UDim2.new(0, 10, 0, 5)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = title
    lblTitle.TextColor3 = Theme.Accent1
    lblTitle.Font = FontPrimary
    lblTitle.TextSize = 12
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -20, 0, 30)
    lblDesc.Position = UDim2.new(0, 10, 0, 25)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = desc
    lblDesc.TextColor3 = Theme.Text
    lblDesc.Font = FontSecondary
    lblDesc.TextSize = 11
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left

    Tween(card, {Size = UDim2.new(1, 0, 0, 60)}, 0.4, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        Tween(card, {Size = UDim2.new(0, 0, 0, 60), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        card:Destroy()
    end)
end

local Library = {}

function Library:CreateWindow(titleText)
    local Window = {}
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 750, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = UIHub
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Theme.Outline
    MainStroke.Thickness = 2
    
    -- Draggable Logic
    local dragToggle, dragStart, startPos
    Bind(MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end))
    Bind(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                local delta = input.Position - dragStart
                Tween(MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
            end
        end
    end))
    Bind(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end))

    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Panel
    Sidebar.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.RichText = true
    Title.TextColor3 = Theme.Text
    Title.Font = FontPrimary
    Title.TextSize = 16
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Content Area
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -200, 1, 0)
    ContentArea.Position = UDim2.new(0, 200, 0, 0)
    ContentArea.BackgroundTransparency = 1
    
    local CurrentTab = nil
    
    function Window:CreateTab(tabName, icon)
        local Tab = {}
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
        TabBtn.BackgroundColor3 = Theme.Item
        TabBtn.Text = "  " .. (icon or "") .. " " .. tabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = FontSecondary
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.ClipsDescendants = true
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        
        local PageScroll = Instance.new("ScrollingFrame", ContentArea)
        PageScroll.Size = UDim2.new(1, -20, 1, -20)
        PageScroll.Position = UDim2.new(0, 10, 0, 10)
        PageScroll.BackgroundTransparency = 1
        PageScroll.ScrollBarThickness = 3
        PageScroll.ScrollBarImageColor3 = Theme.Accent1
        PageScroll.Visible = false
        
        local PageList = Instance.new("UIListLayout", PageScroll)
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        
        Bind(PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageScroll.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end))

        if not CurrentTab then
            CurrentTab = PageScroll
            PageScroll.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent1
            TabBtn.TextColor3 = Theme.Background
        end
        
        Bind(TabBtn.MouseButton1Click:Connect(function()
            CreateRipple(TabBtn, Mouse.X, Mouse.Y)
            if CurrentTab == PageScroll then return end
            
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Theme.Item, TextColor3 = Theme.SubText}, 0.2)
                end
            end
            
            CurrentTab = PageScroll
            PageScroll.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent1, TextColor3 = Theme.Background}, 0.2)
        end))
        
        function Tab:CreateSection(sectionName)
            local lbl = Instance.new("TextLabel", PageScroll)
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text = " ■ " .. string.upper(sectionName)
            lbl.TextColor3 = Theme.Accent2
            lbl.Font = FontPrimary
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Tab:CreateToggle(title, flag, default, callback)
            _G.VoidHubApex.Flags[flag] = default
            
            local TglFrame = Instance.new("Frame", PageScroll)
            TglFrame.Size = UDim2.new(1, -10, 0, 45)
            TglFrame.BackgroundColor3 = Theme.Panel
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", TglFrame).Color = Theme.Outline
            
            local Lbl = Instance.new("TextLabel", TglFrame)
            Lbl.Size = UDim2.new(1, -60, 1, 0)
            Lbl.Position = UDim2.new(0, 15, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = title
            Lbl.TextColor3 = Theme.Text
            Lbl.Font = FontSecondary
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local Switch = Instance.new("TextButton", TglFrame)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -55, 0.5, -10)
            Switch.BackgroundColor3 = default and Theme.Accent1 or Theme.Item
            Switch.Text = ""
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            
            local Circle = Instance.new("Frame", Switch)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Circle.BackgroundColor3 = default and Theme.Background or Theme.SubText
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            
            Bind(Switch.MouseButton1Click:Connect(function()
                _G.VoidHubApex.Flags[flag] = not _G.VoidHubApex.Flags[flag]
                local state = _G.VoidHubApex.Flags[flag]
                
                Tween(Switch, {BackgroundColor3 = state and Theme.Accent1 or Theme.Item}, 0.2)
                Tween(Circle, {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = state and Theme.Background or Theme.SubText
                }, 0.2)
                
                if callback then callback(state) end
            end))
        end

        function Tab:CreateSlider(title, flag, min, max, default, callback)
            _G.VoidHubApex.Flags[flag] = default
            
            local SldFrame = Instance.new("Frame", PageScroll)
            SldFrame.Size = UDim2.new(1, -10, 0, 55)
            SldFrame.BackgroundColor3 = Theme.Panel
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 8)
            
            local Lbl = Instance.new("TextLabel", SldFrame)
            Lbl.Size = UDim2.new(1, -60, 0, 25)
            Lbl.Position = UDim2.new(0, 15, 0, 5)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = title
            Lbl.TextColor3 = Theme.Text
            Lbl.Font = FontSecondary
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValLbl = Instance.new("TextLabel", SldFrame)
            ValLbl.Size = UDim2.new(0, 40, 0, 25)
            ValLbl.Position = UDim2.new(1, -55, 0, 5)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Text = tostring(default)
            ValLbl.TextColor3 = Theme.Accent1
            ValLbl.Font = FontPrimary
            ValLbl.TextSize = 12
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            
            local Track = Instance.new("Frame", SldFrame)
            Track.Size = UDim2.new(1, -30, 0, 6)
            Track.Position = UDim2.new(0, 15, 0, 35)
            Track.BackgroundColor3 = Theme.Item
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent1
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * pos))
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                ValLbl.Text = tostring(value)
                _G.VoidHubApex.Flags[flag] = value
                if callback then callback(value) end
            end
            
            Bind(Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; update(input)
                end
            end))
            Bind(UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end))
            Bind(UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end))
        end

        function Tab:CreateButton(title, callback)
            local Btn = Instance.new("TextButton", PageScroll)
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Theme.Panel
            Btn.Text = title
            Btn.TextColor3 = Theme.Text
            Btn.Font = FontSecondary
            Btn.TextSize = 12
            Btn.ClipsDescendants = true
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", Btn)
            stroke.Color = Theme.Outline
            
            Bind(Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Item}, 0.2) end))
            Bind(Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Panel}, 0.2) end))
            Bind(Btn.MouseButton1Click:Connect(function()
                CreateRipple(Btn, Mouse.X, Mouse.Y)
                if callback then callback() end
            end))
        end

        return Tab
    end
    return Window
end

-- ==========================================
-- 4. ENGINE INITIALIZATION & GUI BUILD
-- ==========================================
local Window = Library:CreateWindow("VOIDHUB <font color='#00FFAA'>APEX</font>")

-- TABS
local TabMain = Window:CreateTab("Dashboard", "🏠")
local TabCombat = Window:CreateTab("Combat & Boss", "⚔️")
local TabPlayer = Window:CreateTab("Movement", "🏃")
local TabVisual = Window:CreateTab("Visual & ESP", "👁️")
local TabUtility = Window:CreateTab("Automation", "⚙️")

-- ==================== DASHBOARD ====================
TabMain:CreateSection("USER IDENTITY")
TabMain:CreateButton("Load Profile Data", function()
    Notify("SYSTEM", "Welcome back, " .. LocalPlayer.Name, 3)
end)

TabMain:CreateSection("SERVER ACTIONS")
TabMain:CreateButton("Rejoin Current Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
TabMain:CreateButton("Server Hop (Find Empty)", function()
    Notify("SERVER", "Scanning for low population servers...", 3)
    -- Optimized Hop Logic
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
end)

-- ==================== COMBAT & BOSS ====================
TabCombat:CreateSection("BOSS MANIPULATION")
TabCombat:CreateToggle("Disable Boss Hitboxes (Safe Mode)", "NoBossDamage", false, function(state)
    if state then
        Bind(RunService.Stepped:Connect(function()
            if not _G.VoidHubApex.Flags["NoBossDamage"] then return end
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        for _, part in pairs(obj:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanTouch = false
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end))
        Notify("COMBAT", "Boss attack hitboxes disabled.", 2)
    end
end)

TabCombat:CreateToggle("Freeze All Mobs", "FreezeMobs", false, function(state)
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                local root = obj:FindFirstChild("HumanoidRootPart")
                if root then root.Anchored = state end
            end
        end
    end)
end)

-- ==================== MOVEMENT ====================
TabPlayer:CreateSection("TRAVERSAL")
TabPlayer:CreateSlider("WalkSpeed Override", "WalkSpeed", 16, 300, 16, function(val)
    Bind(RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.VoidHubApex.Flags["WalkSpeed"]
        end
    end))
end)

TabPlayer:CreateSlider("JumpPower Override", "JumpPower", 50, 500, 50, function(val)
    Bind(RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = _G.VoidHubApex.Flags["JumpPower"]
        end
    end))
end)

TabPlayer:CreateToggle("Noclip (Walk Through Walls)", "Noclip", false, function(state)
    Bind(RunService.Stepped:Connect(function()
        if _G.VoidHubApex.Flags["Noclip"] and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end))
end)

TabPlayer:CreateToggle("Omnidirectional Flight", "Fly", false, function(state)
    if state then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "ApexFly"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = Instance.new("BodyGyro", root)
            bg.Name = "ApexGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 9e4
            
            Bind(RunService.RenderStepped:Connect(function()
                if not _G.VoidHubApex.Flags["Fly"] then return end
                local cam = Workspace.CurrentCamera
                local speed = 50
                local vec = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then vec = vec + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then vec = vec - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then vec = vec - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then vec = vec + cam.CFrame.RightVector end
                
                bv.Velocity = vec * speed
                bg.CFrame = cam.CFrame
            end))
        end
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            if root:FindFirstChild("ApexFly") then root.ApexFly:Destroy() end
            if root:FindFirstChild("ApexGyro") then root.ApexGyro:Destroy() end
        end
    end
end)

-- ==================== VISUAL & ESP ====================
TabVisual:CreateSection("PLAYER SENSORY")
local espObjects = {}

TabVisual:CreateToggle("Premium Highlight ESP", "ESP", false, function(state)
    if state then
        Bind(RunService.RenderStepped:Connect(function()
            if not _G.VoidHubApex.Flags["ESP"] then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("ApexESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ApexESP"
                        hl.FillColor = Theme.Accent1
                        hl.OutlineColor = Theme.Accent2
                        hl.FillTransparency = 0.5
                        hl.Parent = player.Character
                        table.insert(espObjects, hl)
                    end
                end
            end
        end))
    else
        for _, obj in pairs(espObjects) do
            if obj and obj.Parent then obj:Destroy() end
        end
        espObjects = {}
    end
end)

TabVisual:CreateToggle("Fullbright Ambient", "Fullbright", false, function(state)
    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- ==================== AUTOMATION ====================
TabUtility:CreateSection("AUTO-FARM LOGIC")
TabUtility:CreateButton("Set Base Coordinate", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        _G.VoidHubApex.BaseCoord = LocalPlayer.Character.HumanoidRootPart.CFrame
        Notify("BASE SAVED", "Target coordinate registered.", 3)
    end
end)

TabUtility:CreateToggle("Auto Return to Base (When holding Egg/Target)", "AutoBase", false, function(state)
    Bind(RunService.Stepped:Connect(function()
        if _G.VoidHubApex.Flags["AutoBase"] and _G.VoidHubApex.BaseCoord then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("egg") or tool.Name:lower():find("telur")) then
                            char.HumanoidRootPart.CFrame = _G.VoidHubApex.BaseCoord
                        end
                    end
                end
            end)
        end
    end))
end)

TabUtility:CreateToggle("Instant Proximity Prompts", "InstaPrompt", false, function(state)
    if state then
        Bind(game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
            if _G.VoidHubApex.Flags["InstaPrompt"] then
                prompt.HoldDuration = 0
            end
        end))
    end
end)

TabUtility:CreateSection("PROTECTION")
TabUtility:CreateToggle("Anti-Void Fall Damage", "AntiVoid", false, function(state)
    Bind(RunService.Stepped:Connect(function()
        if _G.VoidHubApex.Flags["AntiVoid"] then
            pcall(function()
                local root = LocalPlayer.Character.HumanoidRootPart
                if root.Position.Y < -40 then
                    root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z)
                    root.Velocity = Vector3.zero
                end
            end)
        end
    end))
end)

Notify("VOIDHUB APEX LOADED", "Premium Engine Initialized Successfully.", 5)
