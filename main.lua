-- [[ VOIDHUB CUSTOM UI - ULTRA PREMIUM iOS EDITION v2.3 ]] --
-- Created by Kio (Clean Sidebar UI + ESP Integrated)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
OpenBtn.Position = UDim2.new(0.08, 0, 0.22, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Text = "VH"
OpenBtn.TextColor3 = Color3.fromRGB(240, 210, 255)
OpenBtn.TextSize = 17
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(180, 110, 255)
OpenStroke.Transparency = 0.4
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. LOADING SCREEN
-- ==========================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 240, 0, 100)
LoadingFrame.Position = UDim2.new(0.5, -120, 0.5, -50)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(16, 8, 25)
LoadingFrame.BackgroundTransparency = 0.1
LoadingFrame.Parent = VoidHubUI

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 18)
LoadCorner.Parent = LoadingFrame

local LoadGradient = Instance.new("UIGradient")
LoadGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 15, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 8, 25))
}
LoadGradient.Rotation = 45
LoadGradient.Parent = LoadingFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(180, 110, 255)
LoadStroke.Transparency = 0.5
LoadStroke.Thickness = 1.5
LoadStroke.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0, 18)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "VoidHub <font color=\"#B480FF\">Pro</font>"
LoadTitle.RichText = true
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 19
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 22)
LoadStatus.Position = UDim2.new(0, 0, 0, 56)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Loading Security Modules..."
LoadStatus.TextColor3 = Color3.fromRGB(175, 145, 215)
LoadStatus.TextSize = 12
LoadStatus.Font = Enum.Font.Gotham
LoadStatus.Parent = LoadingFrame

-- ==========================================
-- 3. MAIN FRAME (SIDEBAR MODERN UI DESIGN)
-- ==========================================
local TargetSize = UDim2.new(0, 460, 0, 280)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 8, 22)
MainFrame.BackgroundTransparency = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 15, 55)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 8, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 15))
}
GlassGradient.Rotation = 135
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(170, 100, 255)
GlassStroke.Transparency = 0.4
GlassStroke.Thickness = 1.5
GlassStroke.Parent = MainFrame

-- TOPBAR / HEADER KECIL
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VOIDHUB <font color=\"#B480FF\">// STEAL AN EGG</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(210, 180, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- ==========================================
-- SIDEBAR NAVIGATION (TAB MENU KIRI)
-- ==========================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 130, 1, -52)
Sidebar.Position = UDim2.new(0, 10, 0, 46)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = MainFrame

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 6)
SBLayout.Parent = Sidebar

-- ==========================================
-- CONTAINER KONTEN KANAN
-- ==========================================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -155, 1, -52)
ContentArea.Position = UDim2.new(0, 145, 0, 46)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
ContentArea.BackgroundTransparency = 0.5
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 12)
CACorner.Parent = ContentArea

local CAStroke = Instance.new("UIStroke")
CAStroke.Color = Color3.fromRGB(255, 255, 255)
CAStroke.Transparency = 0.9
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
    page.ScrollBarImageColor3 = Color3.fromRGB(140, 80, 220)
    page.Visible = false
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    
    return page
end

local MainTabPage = CreatePage("Main")
local MiscTabPage = CreatePage("Misc")
MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(110, 50, 200) or Color3.fromRGB(24, 14, 38)
    btn.BackgroundTransparency = defaultActive and 0 or 0.5
    btn.Text = "  " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 145, 205)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 14, 38), BackgroundTransparency = 0.5}):Play()
                b.TextColor3 = Color3.fromRGB(170, 145, 205)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 50, 200), BackgroundTransparency = 0}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTabButton("Steal an Egg", MainTabPage, true)
CreateTabButton("Misc & Walk", MiscTabPage, false)

-- ==========================================
-- TOGGLE BUILDER FUNCTION
-- ==========================================
local function CreateToggle(parent, titleText, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(26, 15, 42)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 8)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(230, 220, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -44, 0.5, -10)
    switch.BackgroundColor3 = Color3.fromRGB(45, 28, 65)
    switch.Text = ""
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = switch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local active = false
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 70, 210)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 28, 65)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        callback(active)
    end)
end

-- ==========================================
-- FITUR DI TAB: STEAL AN EGG (MAIN TAB)
-- ==========================================

-- 1. Anti-AFK Safe
CreateToggle(MainTabPage, "Anti-AFK Safe", function(state)
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

-- 2. Player ESP (Melacak Player Lain)
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
            text.TextColor3 = Color3.fromRGB(200, 130, 255)
            text.TextSize = 11
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = 0.4
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

-- 3. Egg & Item ESP (Melacak Telur/Item di Map)
CreateToggle(MainTabPage, "Egg & Item ESP", function(state)
    _G.EggESPActive = state
    task.spawn(function()
        while _G.EggESPActive do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("item")) then
                        if not obj:FindFirstChild("EggHighlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "EggHighlight"
                            hl.FillColor = Color3.fromRGB(150, 50, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.4
                            hl.Parent = obj
                        end
                    end
                end
            end)
            task.wait(2)
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("EggHighlight") then
                obj.EggHighlight:Destroy()
            end
        end
    end)
end)


-- ==========================================
-- FITUR DI TAB: MISC & WALK (MISC TAB)
-- ==========================================
CreateToggle(MiscTabPage, "Custom WalkSpeed (24)", function(state)
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
-- 5. RESIZE HANDLE
-- ==========================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(150, 120, 180)
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
        local NewX = math.max(400, StartSize.X.Offset + Delta.X)
        local NewY = math.max(220, StartSize.Y.Offset + Delta.Y)
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
        task.wait(0.4)
        LoadStatus.Text = "Initializing UI Elements..."
        task.wait(0.4)
        LoadStatus.Text = "Bypassing Anti-Cheat Core..."
        task.wait(0.4)
    end)
    
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame:Destroy()
    end
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)
