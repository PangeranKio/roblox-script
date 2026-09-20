-- [[ VOIDHUB APEX - AURA GLASS EDITION ]] --
-- Bypass Code 267: Zero-Footprint ESP & Kinetic Velocity Movement
-- UI/UX: Platinum/Obsidian Glassmorphism, Spring Animations, Fluent Layout

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- 0. ANTI-DETECTION SECURE CONTAINER
-- ==========================================
local SecureContainer = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
local HubID = "VOIDHUB_APEX_" .. HttpService:GenerateGUID(false)

if SecureContainer:FindFirstChild("VOIDHUB_APEX_UI") then
    SecureContainer["VOIDHUB_APEX_UI"]:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VOIDHUB_APEX_UI"
VoidHubUI.Parent = SecureContainer
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VoidHubUI.ResetOnSpawn = false

-- Safe Folder for Visuals (Prevents Character ChildAdded detection)
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = HubID .. "_Visuals"
ESPFolder.Parent = VoidHubUI

local State = {
    PlayerESP = false,
    WalkSpeed = false,
    InfJump = false,
    Flying = false,
    SpeedValue = 35,
    FlySpeed = 50,
    AntiAFK = true,
    Target = nil,
    ActiveHighlights = {}
}

-- ==========================================
-- SAFE PHYSICS MOVEMENT (CODE 267 BYPASS)
-- ==========================================
-- Kinetic Velocity (Does not touch Humanoid.WalkSpeed or CFrame directly)
RunService.RenderStepped:Connect(function()
    if State.WalkSpeed and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            local targetVel = hum.MoveDirection * State.SpeedValue
            root.AssemblyLinearVelocity = Vector3.new(targetVel.X, root.AssemblyLinearVelocity.Y, targetVel.Z)
        end
    end
end)

-- Safe Stealth Fly
local FlyVelocity
local FlyGyro
local function StartFlying()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.P = 9e4
    FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.CFrame = root.CFrame
    FlyGyro.Parent = root

    State.Flying = true
    task.spawn(function()
        while State.Flying and root and FlyVelocity and FlyGyro do
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            FlyVelocity.Velocity = moveDir * State.FlySpeed
            FlyGyro.CFrame = Camera.CFrame
            RunService.RenderStepped:Wait()
        end
    end)
end

local function StopFlying()
    State.Flying = false
    if FlyVelocity then FlyVelocity:Destroy() FlyVelocity = nil end
    if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
end

-- Safe Anti-AFK (Using VirtualInputManager instead of VirtualUser)
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- Safe Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 50, root.AssemblyLinearVelocity.Z)
        end
    end
end)

-- ==========================================
-- PREMIUM UI FRAMEWORK (AURA GLASS)
-- ==========================================
local function CreateSpringTween(obj, props)
    return TweenService:Create(obj, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

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
            CreateSpringTween(object, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

-- MAIN CANVAS
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 460)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 220, 230)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.85
MainStroke.Parent = MainFrame

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1
Header.ZIndex = 11
Header.Parent = MainFrame
MakeDraggable(Header, MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 24, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#E2E2E6\">APEX</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(140, 140, 150)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

-- SIDEBAR NAV
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -80)
Sidebar.Position = UDim2.new(0, 20, 0, 60)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 10)
NavLayout.Parent = Sidebar

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -210, 1, -80)
ContentArea.Position = UDim2.new(0, 190, 0, 60)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ContentArea.BackgroundTransparency = 0.5
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 11
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentArea

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(255, 255, 255)
ContentStroke.Thickness = 1
ContentStroke.Transparency = 0.92
ContentStroke.Parent = ContentArea

local PagesFolder = Instance.new("Folder")
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -30, 1, -30)
    page.Position = UDim2.new(0, 15, 0, 15)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 1
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    page.ScrollBarImageTransparency = 0.8
    page.Visible = false
    page.ZIndex = 12
    page.Parent = PagesFolder

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = page
    return page
end

local MvmtPage = CreatePage("Movement")
local VisualPage = CreatePage("Visuals")
local UtilityPage = CreatePage("Utility")

MvmtPage.Visible = true

local function CreateNavButton(label, targetPage, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(20, 20, 24)
    btn.BackgroundTransparency = isDefault and 0.1 or 1
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = isDefault and Color3.fromRGB(10, 10, 12) or Color3.fromRGB(130, 130, 140)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.ZIndex = 12
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do
            if p.Visible then
                CreateSpringTween(p, {Position = UDim2.new(0, 30, 0, 15), CanvasPosition = Vector2.new(0,0)}):Play()
                task.wait(0.1)
                p.Visible = false
            end
        end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                CreateSpringTween(b, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(130, 130, 140)}):Play()
            end
        end
        
        targetPage.Position = UDim2.new(0, 5, 0, 15)
        targetPage.Visible = true
        CreateSpringTween(targetPage, {Position = UDim2.new(0, 15, 0, 15)}):Play()
        CreateSpringTween(btn, {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(10, 10, 12)}):Play()
    end)
end

CreateNavButton("Movement Core", MvmtPage, true)
CreateNavButton("Visual Engine", VisualPage, false)
CreateNavButton("System Utility", UtilityPage, false)

-- ==========================================
-- PREMIUM COMPONENT BUILDERS
-- ==========================================
local function CreateToggle(parent, titleText, descText, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    card.BackgroundTransparency = 0.4
    card.BorderSizePixel = 0
    card.ZIndex = 13
    card.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 0, 20)
    lbl.Position = UDim2.new(0, 16, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14
    lbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -70, 0, 16)
    subLbl.Position = UDim2.new(0, 16, 0, 30)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = descText
    subLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 14
    subLbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 24)
    track.Position = UDim2.new(1, -58, 0.5, -12)
    track.BackgroundColor3 = defaultState and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(40, 40, 46)
    track.BorderSizePixel = 0
    track.ZIndex = 14
    track.Parent = card

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = defaultState and Color3.fromRGB(10, 10, 12) or Color3.fromRGB(180, 180, 190)
    knob.BorderSizePixel = 0
    knob.ZIndex = 15
    knob.Parent = track

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 16
    btn.Parent = card

    local active = defaultState
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            CreateSpringTween(track, {BackgroundColor3 = Color3.fromRGB(235, 235, 245)}):Play()
            CreateSpringTween(knob, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(10, 10, 12)}):Play()
        else
            CreateSpringTween(track, {BackgroundColor3 = Color3.fromRGB(40, 40, 46)}):Play()
            CreateSpringTween(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(180, 180, 190)}):Play()
        end
        callback(active)
    end)
end

local function CreateAction(parent, titleText, descText, callback)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    card.BackgroundTransparency = 0.4
    card.BorderSizePixel = 0
    card.Text = ""
    card.ZIndex = 13
    card.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -30, 0, 20)
    lbl.Position = UDim2.new(0, 16, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 14
    lbl.Parent = card

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -30, 0, 16)
    subLbl.Position = UDim2.new(0, 16, 0, 30)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = descText
    subLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 14
    subLbl.Parent = card

    card.MouseButton1Click:Connect(function()
        local tw1 = CreateSpringTween(card, {BackgroundColor3 = Color3.fromRGB(235, 235, 245)})
        tw1:Play()
        lbl.TextColor3 = Color3.fromRGB(10, 10, 12)
        subLbl.TextColor3 = Color3.fromRGB(60, 60, 70)
        
        task.wait(0.15)
        
        local tw2 = CreateSpringTween(card, {BackgroundColor3 = Color3.fromRGB(22, 22, 26)})
        tw2:Play()
        lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        subLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
        callback()
    end)
end

-- ==========================================
-- POPULATING PAGES
-- ==========================================
CreateToggle(MvmtPage, "Kinetic Velocity Speed", "Safe physical movement bypass", State.WalkSpeed, function(act)
    State.WalkSpeed = act
end)

CreateToggle(MvmtPage, "Anti-Gravity Jump", "Airborne velocity manipulation", State.InfJump, function(act)
    State.InfJump = act
end)

CreateToggle(MvmtPage, "Stealth Flight Engine", "Directional body force flight", State.Flying, function(act)
    if act then StartFlying() else StopFlying() end
end)

-- ZERO-FOOTPRINT ESP (Safe Code 267)
CreateToggle(VisualPage, "Zero-Footprint ESP", "Renders outside character hierarchy", State.PlayerESP, function(act)
    State.PlayerESP = act
    if act then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = Instance.new("Highlight")
                hl.Name = p.Name
                hl.Adornee = p.Character
                hl.FillColor = Color3.fromRGB(235, 235, 245)
                hl.OutlineColor = Color3.fromRGB(15, 15, 20)
                hl.FillTransparency = 0.6
                hl.Parent = ESPFolder
                State.ActiveHighlights[p.Name] = hl
            end
        end
    else
        ESPFolder:ClearAllChildren()
        State.ActiveHighlights = {}
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if State.PlayerESP and p ~= LocalPlayer then
            task.wait(1)
            local hl = Instance.new("Highlight")
            hl.Name = p.Name
            hl.Adornee = char
            hl.FillColor = Color3.fromRGB(235, 235, 245)
            hl.OutlineColor = Color3.fromRGB(15, 15, 20)
            hl.FillTransparency = 0.6
            hl.Parent = ESPFolder
            State.ActiveHighlights[p.Name] = hl
        end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if State.ActiveHighlights[p.Name] then
        State.ActiveHighlights[p.Name]:Destroy()
        State.ActiveHighlights[p.Name] = nil
    end
end)

CreateAction(UtilityPage, "Re-Instance Server", "Teleport to a new session", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateToggle(UtilityPage, "Virtual Input Anti-AFK", "Simulates organic keystrokes", State.AntiAFK, function(act)
    State.AntiAFK = act
end)
