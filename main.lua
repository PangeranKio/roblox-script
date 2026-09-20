-- [[ VOIDHUB CUSTOM UI - iOS GLASS EDITION v2.1 ]] --
-- Created by Kio (Anti-Cheat Bypass Fixed)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

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
OpenBtn.Size = UDim2.new(0, 46, 0, 46)
OpenBtn.Position = UDim2.new(0.08, 0, 0.25, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 42)
OpenBtn.BackgroundTransparency = 0.25
OpenBtn.Text = "VH"
OpenBtn.TextColor3 = Color3.fromRGB(235, 210, 255)
OpenBtn.TextSize = 16
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Transparency = 0.75
OpenStroke.Thickness = 1.2
OpenStroke.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- ==========================================
-- 2. LOADING SCREEN (iOS STYLE)
-- ==========================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 230, 0, 95)
LoadingFrame.Position = UDim2.new(0.5, -115, 0.5, -47)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(22, 14, 32)
LoadingFrame.BackgroundTransparency = 0.15
LoadingFrame.Parent = VoidHubUI

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 16)
LoadCorner.Parent = LoadingFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(255, 255, 255)
LoadStroke.Transparency = 0.8
LoadStroke.Thickness = 1.2
LoadStroke.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0, 15)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "VoidHub <font color=\"#B480FF\">by Kio</font>"
LoadTitle.RichText = true
LoadTitle.TextColor3 = Color3.fromRGB(245, 240, 255)
LoadTitle.TextSize = 18
LoadTitle.Font = Enum.Font.SourceSansBold
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 25)
LoadStatus.Position = UDim2.new(0, 0, 0, 50)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Initializing iOS Interface..."
LoadStatus.TextColor3 = Color3.fromRGB(170, 145, 205)
LoadStatus.TextSize = 13
LoadStatus.Font = Enum.Font.SourceSans
LoadStatus.Parent = LoadingFrame

-- ==========================================
-- 3. MAIN FRAME (WINDOW UTAMA SOLID & GRADIENT GLOW)
-- ==========================================
local TargetSize = UDim2.new(0, 380, 0, 260)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 26)
MainFrame.BackgroundTransparency = 0 -- Transparansi 0% (Solid tapi mewah)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Gradient Ungu-Hitam Premium Deep iOS
local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 20, 68)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 10, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 15))
}
GlassGradient.Rotation = 135
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(180, 120, 255)
GlassStroke.Transparency = 0.5
GlassStroke.Thickness = 1.5
GlassStroke.Parent = MainFrame

-- TOPBAR TITLE & DRAG AREA
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, -40, 0, 40)
Topbar.Position = UDim2.new(0, 0, 0, 0)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "VoidHub <font color=\"#B480FF\">by Kio</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(190, 160, 220)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.SourceSans
CloseBtn.Parent = MainFrame

-- ==========================================
-- TAB SYSTEM & CATEGories (KATEGORI MENU)
-- ==========================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -32, 0, 32)
TabBar.Position = UDim2.new(0, 16, 0, 44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = TabBar

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = MainFrame

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -32, 1, -92)
    page.Position = UDim2.new(0, 16, 0, 84)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    
    return page
end

local MainTabPage = CreatePage("Main")
local VisualTabPage = CreatePage("Visual")
MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(120, 60, 200) or Color3.fromRGB(30, 18, 45)
    btn.BackgroundTransparency = defaultActive and 0 or 0.4
    btn.Text = text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 145, 205)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = TabBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 18, 45), BackgroundTransparency = 0.4}):Play()
                b.TextColor3 = Color3.fromRGB(170, 145, 205)
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 60, 200), BackgroundTransparency = 0}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTabButton("Steal Farm", MainTabPage, true)
CreateTabButton("Misc & Walk", VisualTabPage, false)

-- ==========================================
-- FITUR 1: AUTO COLLECT EGGS (Tab Main - Steal an Egg)
-- ==========================================
local FarmToggleFrame = Instance.new("Frame")
FarmToggleFrame.Size = UDim2.new(1, 0, 0, 44)
FarmToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 18, 45)
FarmToggleFrame.BackgroundTransparency = 0.3
FarmToggleFrame.Parent = MainTabPage

local FTCorner = Instance.new("UICorner")
FTCorner.CornerRadius = UDim.new(0, 10)
FTCorner.Parent = FarmToggleFrame

local FTLabel = Instance.new("TextLabel")
FTLabel.Size = UDim2.new(1, -70, 1, 0)
FTLabel.Position = UDim2.new(0, 12, 0, 0)
FTLabel.BackgroundTransparency = 1
FTLabel.Text = "Auto Collect Nearby Eggs"
FTLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
FTLabel.TextSize = 13
FTLabel.Font = Enum.Font.SourceSansBold
FTLabel.TextXAlignment = Enum.TextXAlignment.Left
FTLabel.Parent = FarmToggleFrame

local FTSwitch = Instance.new("TextButton")
FTSwitch.Size = UDim2.new(0, 40, 0, 22)
FTSwitch.Position = UDim2.new(1, -50, 0.5, -11)
FTSwitch.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
FTSwitch.Text = ""
FTSwitch.Parent = FarmToggleFrame

local FTSCorner = Instance.new("UICorner")
FTSCorner.CornerRadius = UDim.new(1, 0)
FTSCorner.Parent = FTSwitch

local FTSCircle = Instance.new("Frame")
FTSCircle.Size = UDim2.new(0, 18, 0, 18)
FTSCircle.Position = UDim2.new(0, 2, 0.5, -9)
FTSCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FTSCircle.Parent = FTSwitch

local FTSCCorner = Instance.new("UICorner")
FTSCCorner.CornerRadius = UDim.new(1, 0)
FTSCCorner.Parent = FTSCircle

local AutoFarmActive = false
FTSwitch.MouseButton1Click:Connect(function()
    AutoFarmActive = not AutoFarmActive
    if AutoFarmActive then
        TweenService:Create(FTSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 80, 220)}):Play()
        TweenService:Create(FTSCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        
        task.spawn(function()
            while AutoFarmActive do
                pcall(function()
                    local char = Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("collect")) then
                                if (obj.Position - char.HumanoidRootPart.Position).Magnitude < 40 then
                                    firetouchinterest(char.HumanoidRootPart, obj, 0)
                                    firetouchinterest(char.HumanoidRootPart, obj, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        TweenService:Create(FTSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 35, 65)}):Play()
        TweenService:Create(FTSCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
    end
end)

-- ==========================================
-- FITUR 2: ANTI-AFK SAFE BYPASS (Tab Main)
-- ==========================================
local AFKToggleFrame = Instance.new("Frame")
AFKToggleFrame.Size = UDim2.new(1, 0, 0, 44)
AFKToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 18, 45)
AFKToggleFrame.BackgroundTransparency = 0.3
AFKToggleFrame.Parent = MainTabPage

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = AFKToggleFrame

local AFKLabel = Instance.new("TextLabel")
AFKLabel.Size = UDim2.new(1, -70, 1, 0)
AFKLabel.Position = UDim2.new(0, 12, 0, 0)
AFKLabel.BackgroundTransparency = 1
AFKLabel.Text = "Anti-AFK Safe"
AFKLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
AFKLabel.TextSize = 13
AFKLabel.Font = Enum.Font.SourceSansBold
AFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AFKLabel.Parent = AFKToggleFrame

local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(0, 40, 0, 22)
SwitchBtn.Position = UDim2.new(1, -50, 0.5, -11)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
SwitchBtn.Text = ""
SwitchBtn.Parent = AFKToggleFrame

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(1, 0)
SwitchCorner.Parent = SwitchBtn

local SwitchCircle = Instance.new("Frame")
SwitchCircle.Size = UDim2.new(0, 18, 0, 18)
SwitchCircle.Position = UDim2.new(0, 2, 0.5, -9)
SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchCircle.Parent = SwitchBtn

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = SwitchCircle

local AntiAFKActive = false
local AFKConnection = nil

SwitchBtn.MouseButton1Click:Connect(function()
    AntiAFKActive = not AntiAFKActive
    
    if AntiAFKActive then
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 80, 220)}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        
        local lastMove = tick()
        AFKConnection = RunService.RenderStepped:Connect(function()
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
        end)
    else
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 35, 65)}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end)

-- ==========================================
-- FITUR 3: CUSTOM WALKSPEED (Tab Misc)
-- ==========================================
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 44)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 18, 45)
SpeedFrame.BackgroundTransparency = 0.3
SpeedFrame.Parent = VisualTabPage

local SFCorner = Instance.new("UICorner")
SFCorner.CornerRadius = UDim.new(0, 10)
SFCorner.Parent = SpeedFrame

local SFLabel = Instance.new("TextLabel")
SFLabel.Size = UDim2.new(1, -70, 1, 0)
SFLabel.Position = UDim2.new(0, 12, 0, 0)
SFLabel.BackgroundTransparency = 1
SFLabel.Text = "Custom WalkSpeed (24)"
SFLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
SFLabel.TextSize = 13
SFLabel.Font = Enum.Font.SourceSansBold
SFLabel.TextXAlignment = Enum.TextXAlignment.Left
SFLabel.Parent = SpeedFrame

local SFSwitch = Instance.new("TextButton")
SFSwitch.Size = UDim2.new(0, 40, 0, 22)
SFSwitch.Position = UDim2.new(1, -50, 0.5, -11)
SFSwitch.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
SFSwitch.Text = ""
SFSwitch.Parent = SpeedFrame

local SFSCorner = Instance.new("UICorner")
SFSCorner.CornerRadius = UDim.new(1, 0)
SFSCorner.Parent = SFSwitch

local SFSCircle = Instance.new("Frame")
SFSCircle.Size = UDim2.new(0, 18, 0, 18)
SFSCircle.Position = UDim2.new(0, 2, 0.5, -9)
SFSCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SFSCircle.Parent = SFSwitch

local SFSCCorner = Instance.new("UICorner")
SFSCCorner.CornerRadius = UDim.new(1, 0)
SFSCCorner.Parent = SFSCircle

local SpeedActive = false
SFSwitch.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        TweenService:Create(SFSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 80, 220)}):Play()
        TweenService:Create(SFSCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        
        task.spawn(function()
            while SpeedActive do
                pcall(function()
                    local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = 24
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        TweenService:Create(SFSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 35, 65)}):Play()
        TweenService:Create(SFSCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        pcall(function()
            local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)

-- ==========================================
-- 5. RESIZE HANDLE (GEDEIN / KECILIN UI)
-- ==========================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(160, 130, 190)
ResizeHandle.TextSize = 12
ResizeHandle.Font = Enum.Font.SourceSansBold
ResizeHandle.Parent = MainFrame

local Resizing = false
local StartSize, StartInputPos

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
        local NewX = math.max(260, StartSize.X.Offset + Delta.X)
        local NewY = math.max(160, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- ==========================================
-- 6. ANIMASI SMOOTH OPEN / CLOSE TWEEN
-- =
