--[[
    VoidHub - iOS Inspired Custom Script Hub
    Created by: Kio
    Design: Apple iOS Dark Glassmorphic Theme with Smooth Spring Animations
--]]

-- 1. Anti-Double Load Protection
if game.CoreGui:FindFirstChild("VoidHub") then
    game.CoreGui.VoidHub:Destroy()
end
if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("VoidHub") then
    game.Players.LocalPlayer.PlayerGui.VoidHub:Destroy()
end

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 2. Master ScreenGui Container
local VoidHub = Instance.new("ScreenGui")
VoidHub.Name = "VoidHub"
VoidHub.ResetOnSpawn = false

pcall(function()
    VoidHub.Parent = game:GetService("CoreGui")
end)
if not VoidHub.Parent then
    VoidHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 3. Main iOS Card Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = VoidHub

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20) -- iOS Roundness
MainCorner.Parent = MainFrame

-- Premium iOS Dark Purple Gradient Background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 22, 58)),    -- Soft Royal Velvet Purple
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(22, 14, 34)), -- Deep Midnight Plum
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 20))      -- iOS Dark Backdrop
}
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

-- Glassmorphic iOS Border Accent
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(168, 115, 245)
MainStroke.Transparency = 0.65
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- 4. Top Header Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "VoidHub <font color=\"#d8b4fe\"><size=\"12\">by Kio</size></font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(250, 245, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- iOS Control Pill (Minimize & Close)
local ControlPill = Instance.new("Frame")
ControlPill.Name = "ControlPill"
ControlPill.Size = UDim2.new(0, 68, 0, 30)
ControlPill.Position = UDim2.new(1, -84, 0.5, -15)
ControlPill.BackgroundColor3 = Color3.fromRGB(48, 30, 72)
ControlPill.BackgroundTransparency = 0.4
ControlPill.Parent = TopBar

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(1, 0)
PillCorner.Parent = ControlPill

local PillStroke = Instance.new("UIStroke")
PillStroke.Color = Color3.fromRGB(168, 115, 245)
PillStroke.Transparency = 0.8
PillStroke.Thickness = 1
PillStroke.Parent = ControlPill

-- Minimize Button (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0.5, 0, 1, 0)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = ControlPill

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0.5, 0, 1, 0)
CloseBtn.Position = UDim2.new(0.5, 0, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(252, 165, 165)
CloseBtn.TextSize = 12
CloseBtn.Parent = ControlPill

-- Header Separator
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 48)
Divider.BackgroundColor3 = Color3.fromRGB(168, 115, 245)
Divider.BackgroundTransparency = 0.85
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- 5. Floating iOS Logo Widget (Shows on Minimize)
local OpenLogoBtn = Instance.new("TextButton")
OpenLogoBtn.Name = "OpenLogoBtn"
OpenLogoBtn.Size = UDim2.new(0, 52, 0, 52)
OpenLogoBtn.Position = UDim2.new(0.06, 0, 0.22, 0)
OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 52)
OpenLogoBtn.BorderSizePixel = 0
OpenLogoBtn.Font = Enum.Font.GothamBold
OpenLogoBtn.Text = "VH"
OpenLogoBtn.TextColor3 = Color3.fromRGB(216, 180, 254)
OpenLogoBtn.TextSize = 17
OpenLogoBtn.Visible = false
OpenLogoBtn.Parent = VoidHub

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 16)
LogoCorner.Parent = OpenLogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(192, 132, 252)
LogoStroke.Thickness = 1.5
LogoStroke.Parent = OpenLogoBtn

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 32, 86)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 12, 32))
}
LogoGradient.Rotation = 135
LogoGradient.Parent = OpenLogoBtn

-- 6. iOS Segmented Sidebar & Content Views
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 125, 1, -64)
Sidebar.Position = UDim2.new(0, 18, 0, 56)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -165, 1, -64)
ContentArea.Position = UDim2.new(0, 148, 0, 56)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
ContentArea.BackgroundTransparency = 0.45
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 14)
ContentCorner.Parent = ContentArea

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(168, 115, 245)
ContentStroke.Transparency = 0.88
ContentStroke.Thickness = 1
ContentStroke.Parent = ContentArea

-- 7. Smooth Physics-Based Dragging Function
local function makeDraggable(frame, handle)
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
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

makeDraggable(MainFrame, TopBar)
makeDraggable(OpenLogoBtn, OpenLogoBtn)

-- 8. Smooth Minimize & Restore Animations
MinimizeBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 260, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 170)
    })
    shrink:Play()
    shrink.Completed:Connect(function()
        MainFrame.Visible = false
        OpenLogoBtn.Visible = true
        OpenLogoBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(OpenLogoBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 52, 0, 52)
        }):Play()
    end)
end)

OpenLogoBtn.MouseButton1Click:Connect(function()
    OpenLogoBtn.Visible = false
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Visible = true

    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 340),
        Position = UDim2.new(0.5, -260, 0.5, -170)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        VoidHub:Destroy()
    end)
end)

-- 9. iOS Tab Builder Function
local tabs = {}

function createTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(48, 30, 72)
    TabButton.BackgroundTransparency = 0.7
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(192, 168, 225)
    TabButton.TextSize = 13
    TabButton.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, -20, 1, -20)
    TabPage.Position = UDim2.new(0, 10, 0, 10)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(192, 132, 252)
    TabPage.Visible = false
    TabPage.Parent = ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = TabPage

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Page.Visible = false
            TweenService:Create(tab.Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(48, 30, 72),
                TextColor3 = Color3.fromRGB(192, 168, 225),
                BackgroundTransparency = 0.7
            }):Play()
        end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(147, 51, 234),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.2
        }):Play()
    end)

    table.insert(tabs, {Btn = TabButton, Page = TabPage})

    if #tabs == 1 then
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.2
    end

    return TabPage
end

-- Create Placeholder Tabs (Ready for future features)
local MainTab = createTab("Main")
local PlayerTab = createTab("Player")
local MiscTab = createTab("Misc")
local SettingsTab = createTab("Settings")

print("[VoidHub] iOS Edition Loaded Successfully!")
```eof

### Detail Peningkatan GUI iOS **VoidHub**:

1. **iOS Glassmorphism & Color Palette**:
   - Gradasi menggunakan perpaduan **Soft Royal Velvet Purple** ke **Deep Midnight Plum** hingga **iOS Dark Backdrop** (nyaman dipandang, tidak terlalu hitam pekat dan tidak terlalu terang/neon).
   - Memiliki sudut melengkung khas iOS (*Corner Radius 20*) serta border tipis aksen ungu melayang (*UIStroke Glass*).
2. **iOS Control Pill**:
   - Tombol *Minimize* (`−`) dan *Close* (`✕`) disatukan ke dalam satu kapsul transparan melayang khas iOS di pojok kanan atas.
3. **Floating Logo Minimizer**:
   - Saat di-minimize, jendela utama menyusut dengan animasi *physics-spring* dan memunculkan widget floating icon melingkar **"VH"** di layar. Saat diklik kembali, jendela akan mekar (*pop-out*) kembali ke ukuran semula.
4. **Anti-Double Load**:
   - Secara otomatis menghapus instance GUI lama sebelum membuat yang baru agar Delta tidak lag/terduplikasi.
5. **Responsif & Smooth Dragging**:
   - Memakai `TweenService` untuk pergerakan GUI saat digeser di layar HP maupun PC, memberikan impresi gerakan yang sangat halus.

---

### Cara Memasang di GitHub & Delta:

1. Copy seluruh kode di atas.
2. Buka repository kamu di GitHub (`main.lua`), klik ikon **Edit** (pensil), **hapus seluruh isi lama**, dan *paste* kode baru di atas.
3. Klik **Commit changes...**.
4. Jalankan `loadstring` kamu di Delta:
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/PangeranKio/roblox-script/refs/heads/main/main.lua"))()
