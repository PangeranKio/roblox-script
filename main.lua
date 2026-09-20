-- [[ VOIDHUB - iOS Mobile Edition ]] --
-- Created by: Kio

-- Anti Double-Load
if game:GetService("CoreGui"):FindFirstChild("VoidHub") then
    game:GetService("CoreGui").VoidHub:Destroy()
end
local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("VoidHub") then
    game:GetService("Players").LocalPlayer.PlayerGui.VoidHub:Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Master ScreenGui
local VoidHub = Instance.new("ScreenGui")
VoidHub.Name = "VoidHub"
VoidHub.ResetOnSpawn = false

-- Fallback Parent Detection
local success, _ = pcall(function()
    VoidHub.Parent = game:GetService("CoreGui")
end)
if not success or not VoidHub.Parent then
    VoidHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 250)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = VoidHub

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Gradasi Ungu iOS Dark
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 20, 52)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(20, 12, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 18))
}
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

-- Border Halus
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(150, 95, 225)
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Top Bar Header
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VoidHub"
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Subtitle Credit
local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 80, 1, 0)
SubTitle.Position = UDim2.new(0, 95, 0, 1)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Text = "by Kio"
SubTitle.TextColor3 = Color3.fromRGB(190, 150, 245)
SubTitle.TextSize = 13
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- iOS Control Pill
local ControlPill = Instance.new("Frame")
ControlPill.Name = "ControlPill"
ControlPill.Size = UDim2.new(0, 56, 0, 24)
ControlPill.Position = UDim2.new(1, -68, 0.5, -12)
ControlPill.BackgroundColor3 = Color3.fromRGB(48, 28, 70)
ControlPill.BackgroundTransparency = 0.3
ControlPill.Parent = TopBar

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(1, 0)
PillCorner.Parent = ControlPill

local PillStroke = Instance.new("UIStroke")
PillStroke.Color = Color3.fromRGB(150, 95, 225)
PillStroke.Transparency = 0.7
PillStroke.Thickness = 1
PillStroke.Parent = ControlPill

-- Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0.5, 0, 1, 0)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(215, 180, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = ControlPill

-- Close (x)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0.5, 0, 1, 0)
CloseBtn.Position = UDim2.new(0.5, 0, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.fromRGB(255, 160, 175)
CloseBtn.TextSize = 14
CloseBtn.Parent = ControlPill

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -30, 0, 1)
Divider.Position = UDim2.new(0, 15, 0, 36)
Divider.BackgroundColor3 = Color3.fromRGB(150, 95, 225)
Divider.BackgroundTransparency = 0.85
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Floating Logo Widget (Muncul saat Minimize)
local OpenLogoBtn = Instance.new("TextButton")
OpenLogoBtn.Name = "OpenLogoBtn"
OpenLogoBtn.Size = UDim2.new(0, 44, 0, 44)
OpenLogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(32, 18, 48)
OpenLogoBtn.BorderSizePixel = 0
OpenLogoBtn.Font = Enum.Font.SourceSansBold
OpenLogoBtn.Text = "VH"
OpenLogoBtn.TextColor3 = Color3.fromRGB(215, 180, 255)
OpenLogoBtn.TextSize = 16
OpenLogoBtn.Visible = false
OpenLogoBtn.Parent = VoidHub

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = OpenLogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(170, 110, 240)
LogoStroke.Thickness = 1.2
LogoStroke.Parent = OpenLogoBtn

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 28, 75)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 10, 28))
}
LogoGradient.Rotation = 135
LogoGradient.Parent = OpenLogoBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 100, 1, -48)
Sidebar.Position = UDim2.new(0, 12, 0, 42)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Sidebar

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -132, 1, -48)
ContentArea.Position = UDim2.new(0, 120, 0, 42)
ContentArea.BackgroundColor3 = Color3.fromRGB(16, 10, 25)
ContentArea.BackgroundTransparency = 0.4
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentArea

-- Dragging Logic
local function enableDrag(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

enableDrag(MainFrame, TopBar)
enableDrag(OpenLogoBtn, OpenLogoBtn)

-- Minimize & Restore Events
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenLogoBtn.Visible = true
end)

OpenLogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenLogoBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    VoidHub:Destroy()
end)

-- Tab Manager
local tabs = {}

function createTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 28)
    TabButton.BackgroundColor3 = Color3.fromRGB(42, 25, 60)
    TabButton.BackgroundTransparency = 0.6
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 155, 215)
    TabButton.TextSize = 14
    TabButton.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, -12, 1, -12)
    TabPage.Position = UDim2.new(0, 6, 0, 6)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(170, 110, 240)
    TabPage.Visible = false
    TabPage.Parent = ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.Parent = TabPage

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Page.Visible = false
            tab.Btn.BackgroundColor3 = Color3.fromRGB(42, 25, 60)
            tab.Btn.TextColor3 = Color3.fromRGB(180, 155, 215)
            tab.Btn.BackgroundTransparency = 0.6
        end
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(140, 80, 220)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.2
    end)

    table.insert(tabs, {Btn = TabButton, Page = TabPage})

    if #tabs == 1 then
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(140, 80, 220)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.2
    end

    return TabPage
end

-- Initialize Tabs
local MainTab = createTab("Main")
local PlayerTab = createTab("Player")
local MiscTab = createTab("Misc")
local SettingsTab = createTab("Settings")

print("[VoidHub] Loaded successfully!")
