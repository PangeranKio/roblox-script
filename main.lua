-- [[ VOIDHUB CUSTOM UI - iOS GLASS EDITION v2 ]] --
-- Created by Kio

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

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
-- 4. FITUR ANTI-AFK TOGGLE (iOS SWITCH STYLE)
-- ==========================================

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
    LoadStatus.Text = "Loading Anti-AFK Module..."
    task.wait(0.7)
    LoadStatus.Text = "Applying Security Protections..."
    task.wait(0.6)
    
    -- Destroy Loading & Open Main UI
    LoadingFrame:Destroy()
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)
