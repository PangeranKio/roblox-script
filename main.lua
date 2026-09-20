--[[
    VoidHub - Custom Script Hub UI
    Created by: Kio
    Theme: Smooth Dark Purple & Black Gradient
--]]

-- 1. Anti-Double Load (Menutup GUI lama jika script di-load ulang)
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

-- Create Main ScreenGui
local VoidHub = Instance.new("ScreenGui")
VoidHub.Name = "VoidHub"
VoidHub.ResetOnSpawn = false

-- Fallback parent (CoreGui or PlayerGui)
pcall(function()
    VoidHub.Parent = game:GetService("CoreGui")
end)
if not VoidHub.Parent then
    VoidHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = VoidHub

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Dark Purple Gradient Background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 20, 52)),   -- Soft Dark Purple
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 10, 24))    -- Deep Velvet Black/Purple
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

-- Subtle Purple Stroke/Border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 92, 210)
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- 3. Top Navigation Bar (Header)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "VoidHub <font color=\"#c4b5fd\"><size=\"12\">by Kio</size></font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button (In TopBar)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 75)
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(220, 200, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(90, 25, 45)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 180, 200)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- TopBar Divider Line
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -30, 0, 1)
Divider.Position = UDim2.new(0, 15, 0, 42)
Divider.BackgroundColor3 = Color3.fromRGB(138, 92, 210)
Divider.BackgroundTransparency = 0.7
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- 4. Floating Logo Button (Shows when Minimized)
local OpenLogoBtn = Instance.new("TextButton")
OpenLogoBtn.Name = "OpenLogoBtn"
OpenLogoBtn.Size = UDim2.new(0, 50, 0, 50)
OpenLogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 45)
OpenLogoBtn.BorderSizePixel = 0
OpenLogoBtn.Font = Enum.Font.GothamBold
OpenLogoBtn.Text = "VH"
OpenLogoBtn.TextColor3 = Color3.fromRGB(192, 132, 252)
OpenLogoBtn.TextSize = 18
OpenLogoBtn.Visible = false
OpenLogoBtn.Parent = VoidHub

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = OpenLogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(168, 85, 247)
LogoStroke.Thickness = 1.5
LogoStroke.Parent = OpenLogoBtn

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 12, 32))
}
LogoGradient.Rotation = 45
LogoGradient.Parent = OpenLogoBtn

-- 5. Sidebar & Content Area Container
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(0, 15, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -170, 1, -55)
ContentArea.Position = UDim2.new(0, 155, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 12, 30)
ContentArea.BackgroundTransparency = 0.4
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

-- 6. Draggable Logic for MainFrame & OpenLogoBtn
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

-- 7. Minimize & Toggle Functionality
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

-- 8. Tab Navigation System Structure
local tabs = {}
local activeTab = nil

function createTab(tabName)
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 24, 60)
    TabButton.BackgroundTransparency = 0.5
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 160, 210)
    TabButton.TextSize = 13
    TabButton.Parent = Sidebar

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton

    -- Tab Page Container inside ContentArea
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, -20, 1, -20)
    TabPage.Position = UDim2.new(0, 10, 0, 10)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(138, 92, 210)
    TabPage.Visible = false
    TabPage.Parent = ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = TabPage

    -- Tab Click Switch Handler
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.Page.Visible = false
            TweenService:Create(tab.Btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 24, 60),
                TextColor3 = Color3.fromRGB(180, 160, 210),
                BackgroundTransparency = 0.5
            }):Play()
        end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(138, 92, 210),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.1
        }):Play()
    end)

    table.insert(tabs, {Btn = TabButton, Page = TabPage})

    -- Auto select first tab
    if #tabs == 1 then
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(138, 92, 210)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.1
    end

    return TabPage
end

-- Create Placeholder Tabs (Kosong untuk diisi fitur nanti)
local MainTab = createTab("Main")
local PlayerTab = createTab("Player")
local MiscTab = createTab("Misc")
local SettingsTab = createTab("Settings")

print("[VoidHub] Loaded successfully by Kio!")
```eof

Tampilan GUI **VoidHub** dasar sudah selesai dibuat sesuai dengan semua spesifikasi:

1. **Desain Warna**: Kombinasi warna *Dark Purple* & *Velvet Black* dengan *UIGradient* dan *UIStroke* halus (enak dipandang, tidak terlalu gelap/neon).
2. **Fitur Anti-Double Load**: Secara otomatis menghapus instance GUI lama saat script di-execute ulang agar tidak membuat game lag.
3. **Minimize Logo Sistem**: Saat tombol `-` diklik, jendela utama akan tersembunyi dan memunculkan tombol floating logo **"VH"** yang bisa digeser (drag).
4. **Struktur Tab**: Sudah disiapkan tab kosong (*Main*, *Player*, *Misc*, *Settings*) yang siap kamu isi dengan berbagai fitur ke depannya.
5. **Credit & Nama**: Berjudul **VoidHub** dengan subtitle **by Kio**.

Silakan update isi file `main.lua` kamu di GitHub dengan kode baru ini! Jika ada fitur pertama yang ingin dimasukkan (seperti WalkSpeed slider, Fly, Teleport, dll.), beri tahu aku ya.Berikut draf dasar script UI **VoidHub** menggunakan library Rayfield yang sudah disesuaikan dengan semua permintaanmu (kombinasi warna ungu-hitam elegan, sistem anti double-tab, minimize logo, credit, dan menu yang masih kosong).

```lua
-- [[ VOIDHUB - BASE UI ]] --
-- Credit / Pembuat: Kio

-- 1. Anti Double-Tab / Clean-up Tab Sebelumnya
if _G.VoidHubLoaded then
    if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
        game:GetService("CoreGui"):FindFirstChild("Rayfield"):Destroy()
    end
end
_G.VoidHubLoaded = true

-- 2. Load UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 3. Inisialisasi Window VoidHub
local Window = Rayfield:CreateWindow({
   Name = "VoidHub",
   LoadingTitle = "VoidHub Loading...",
   LoadingSubtitle = "by Kio",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "VoidHubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = false
   },
   KeySystem = false,
   
   -- Modifikasi Tema (Ungu & Hitam Gradient/Soft)
   Theme = {
      TextColor = Color3.fromRGB(240, 240, 240),
      Background = Color3.fromRGB(18, 16, 22),       -- Hitam keunguan soft
      Topbar = Color3.fromRGB(28, 22, 38),           -- Ungu gelap halus
      Accent = Color3.fromRGB(138, 79, 255),         -- Ungu sedang (non-neon)
      OutlineColor = Color3.fromRGB(55, 38, 85),     -- Border ungu gelap
      TileColor = Color3.fromRGB(32, 26, 44),        -- Element background
      LoadingColor = Color3.fromRGB(138, 79, 255)
   }
})

-- 4. Pengaturan Minimize (Ganti jadi Icon Logo)
-- Catatan: Rayfield secara default menyediakan tombol floating icon di pojok kanan atas saat di-minimize.
Rayfield:SetFolder("VoidHub_Settings")

-- 5. Tab Kosong (Siap Diisi Fitur)
local MainTab = Window:CreateTab("Main", 4483362458) -- Icon ID default

-- Sub-Header Credit
local CreditSection = MainTab:CreateSection("Script Info")
MainTab:CreateLabel("Created by Kio")
MainTab:CreateLabel("Status: Active")

local FeatureSection = MainTab:CreateSection("Features")
-- [ Fitur-fitur kamu nanti dimasukkan di sini ]

-- Notifikasi saat berhasil di-load
Rayfield:Notify({
   Title = "VoidHub Loaded",
   Content = "Selamat datang! Script dibuat oleh Kio.",
   Duration = 4,
   Image = 4483362458,
})
