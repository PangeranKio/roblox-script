-- [[ VOIDHUB CUSTOM UI - iOS GLASS EDITION v2 ]] --
-- Created by Kio

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

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
-- 3. MAIN FRAME (WINDOW UTAMA GLASS)
-- ==========================================
local TargetSize = UDim2.new(0, 340, 0, 220)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 15, 34)
MainFrame.BackgroundTransparency = 0.25
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

-- Gradient Kaca Ungu-Hitam
local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 30, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(26, 14, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 8, 22))
}
GlassGradient.Rotation = 45
GlassGradient.Parent = MainFrame

-- Border Kaca Transparan iOS
local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(255, 255, 255)
GlassStroke.Transparency = 0.82
GlassStroke.Thickness = 1.2
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

-- CONTENT AREA (CONTAINER FITUR)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -24, 1, -52)
ContentContainer.Position = UDim2.new(0, 12, 0, 42)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ==========================================
-- 4. FITUR AUTO CLICKER (UPDATED SAFE METHOD)
-- ==========================================
-- CLICK MARKER TARGET (BISA DI-DRAG KE MANA SAJA)
local ClickMarker = Instance.new("TextButton")
ClickMarker.Name = "ClickMarker"
ClickMarker.Size = UDim2.new(0, 36, 0, 36)
ClickMarker.Position = UDim2.new(0.5, -18, 0.5, -18)
ClickMarker.BackgroundColor3 = Color3.fromRGB(160, 90, 240)
ClickMarker.BackgroundTransparency = 0.4
ClickMarker.Text = ""
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

-- UI CARD AUTO CLICKER
local AFKToggleFrame = Instance.new("Frame")
AFKToggleFrame.Size = UDim2.new(1, 0, 0, 48)
AFKToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 18, 42)
AFKToggleFrame.BackgroundTransparency = 0.35
AFKToggleFrame.Parent = ContentContainer

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = AFKToggleFrame

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Transparency = 0.9
ToggleStroke.Parent = AFKToggleFrame

local AFKLabel = Instance.new("TextLabel")
AFKLabel.Size = UDim2.new(1, -70, 1, 0)
AFKLabel.Position = UDim2.new(0, 14, 0, 0)
AFKLabel.BackgroundTransparency = 1
AFKLabel.Text = "Auto Clicker"
AFKLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
AFKLabel.TextSize = 14
AFKLabel.Font = Enum.Font.SourceSansBold
AFKLabel.TextXAlignment = Enum.TextXAlignment.Left
AFKLabel.Parent = AFKToggleFrame

-- Switch Sakelar iOS
local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(0, 44, 0, 24)
SwitchBtn.Position = UDim2.new(1, -54, 0.5, -12)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 65)
SwitchBtn.Text = ""
SwitchBtn.Parent = AFKToggleFrame

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

-- LOGIKA AUTO CLICKER (SAFE & ALL EXECUTOR COMPATIBLE)
local AntiAFKActive = false
local ClickThread = nil

SwitchBtn.MouseButton1Click:Connect(function()
    AntiAFKActive = not AntiAFKActive
    
    if AntiAFKActive then
        -- Animasi ON
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 80, 220)}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        ClickMarker.Visible = true
        
        ClickThread = task.spawn(function()
            while AntiAFKActive do
                task.wait(3) -- Interval klik 3 detik
                if AntiAFKActive then
                    pcall(function()
                        local guiObjects = CoreGui:GetGuiObjectsAtPosition(ClickMarker.AbsolutePosition.X + 18, ClickMarker.AbsolutePosition.Y + 18)
                        for _, obj in pairs(guiObjects) do
                            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj ~= ClickMarker then
                                obj.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1})
                            end
                        end
                    end)
                    
                    -- Efek Pulse Visual Saat Klik
                    local Pulse = Instance.new("Frame")
                    Pulse.Size = ClickMarker.Size
                    Pulse.Position = ClickMarker.Position
                    Pulse.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Pulse.BackgroundTransparency = 0.5
                    Pulse.Parent = VoidHubUI
                    Instance.new("UICorner", Pulse).CornerRadius = UDim.new(1, 0)
                    
                    TweenService:Create(Pulse, TweenInfo.new(0.3), {
                        Size = UDim2.new(0, 52, 0, 52), 
                        Position = UDim2.new(ClickMarker.Position.X.Scale, ClickMarker.Position.X.Offset - 8, ClickMarker.Position.Y.Scale, ClickMarker.Position.Y.Offset - 8), 
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.delay(0.35, function() Pulse:Destroy() end)
                end
            end
        end)
    else
        -- Animasi OFF
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
-- ==========================================
local TweenBack = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TweenIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Open Window
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)

-- Close Window
CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenIn, {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- ==========================================
-- 7. EXECUTION PROCESS (LOADING)
-- ==========================================
task.spawn(function()
    task.wait(0.7)
    LoadStatus.Text = "Loading Auto Clicker Module..."
    task.wait(0.7)
    LoadStatus.Text = "Applying Security Protections..."
    task.wait(0.6)
    
    -- Destroy Loading & Open Main UI
    LoadingFrame:Destroy()
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)
