-- [[ VOIDHUB - FULL CUSTOM GUI ]] --
-- Created by: Kio

-- 1. Anti Double-Tab (Hapus GUI lama jika di-load ulang)
if game.CoreGui:FindFirstChild("VoidHub") then
    game.CoreGui.VoidHub:Destroy()
end
if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("VoidHub") then
    game.Players.LocalPlayer.PlayerGui.VoidHub:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 2. ScreenGui Utama
local VoidHub = Instance.new("ScreenGui")
VoidHub.Name = "VoidHub"
VoidHub.ResetOnSpawn = false

pcall(function()
    VoidHub.Parent = game:GetService("CoreGui")
end)
if not VoidHub.Parent then
    VoidHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 3. Window Utama (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = VoidHub

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Gradient Ungu Soft ke Hitam
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 18, 48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 10, 20))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(130, 80, 200)
MainStroke.Transparency = 0.5
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- 4. Header TopBar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "VoidHub <font color=\"#b892ff\"><size=\"11\">by Kio</size></font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(240, 235, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 65)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 180, 240)
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 170, 190)
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- 5. Floating Logo saat Minimize
local OpenLogoBtn = Instance.new("TextButton")
OpenLogoBtn.Name = "OpenLogoBtn"
OpenLogoBtn.Size = UDim2.new(0, 46, 0, 46)
OpenLogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 42)
OpenLogoBtn.BorderSizePixel = 0
OpenLogoBtn.Font = Enum.Font.GothamBold
OpenLogoBtn.Text = "VH"
OpenLogoBtn.TextColor3 = Color3.fromRGB(184, 146, 255)
OpenLogoBtn.TextSize = 15
OpenLogoBtn.Visible = false
OpenLogoBtn.Parent = VoidHub

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = OpenLogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(140, 90, 210)
LogoStroke.Thickness = 1.2
LogoStroke.Parent = OpenLogoBtn

-- 6. Fungsi Dragging (Supaya Bisa Digeser)
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

-- Event Tombol
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

print("[VoidHub] Loaded successfully!")
