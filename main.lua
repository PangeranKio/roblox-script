-- [[ VOIDHUB - iOS Style Edition ]] --
-- Created by: Kio

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Registrasi Tema iOS Dark Purple (Sleek, Soft, Non-Neon)
Rayfield:RegisterTheme("iOSDarkPurple", {
    TextColor = Color3.fromRGB(245, 240, 255),
    Background = Color3.fromRGB(18, 14, 26),             -- iOS Dark Surface
    Topbar = Color3.fromRGB(28, 20, 42),                 -- iOS Header
    Shadow = Color3.fromRGB(8, 5, 12),
    NotificationBackground = Color3.fromRGB(32, 22, 48),
    NotificationActionsBackground = Color3.fromRGB(48, 30, 70),
    
    TabBackground = Color3.fromRGB(26, 18, 38),
    TabStroke = Color3.fromRGB(90, 55, 140),            -- Soft Accent Border
    TabBackgroundSelected = Color3.fromRGB(110, 60, 180),
    TabTextColor = Color3.fromRGB(180, 155, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    
    ElementBackground = Color3.fromRGB(26, 18, 38),
    ElementBackgroundHover = Color3.fromRGB(38, 26, 56),
    ElementStroke = Color3.fromRGB(75, 45, 115),
    SecondaryElementBackground = Color3.fromRGB(20, 14, 30),
    SecondaryElementBackgroundHover = Color3.fromRGB(30, 20, 44),
    SecondaryElementStroke = Color3.fromRGB(65, 40, 100),
    
    SliderBackground = Color3.fromRGB(34, 22, 50),
    SliderProgress = Color3.fromRGB(130, 75, 200),
    SliderStroke = Color3.fromRGB(150, 85, 220),
    
    ToggleBackground = Color3.fromRGB(34, 22, 50),
    ToggleEnabled = Color3.fromRGB(130, 75, 200),
    ToggleDisabled = Color3.fromRGB(22, 14, 32),
    ToggleStroke = Color3.fromRGB(140, 80, 210),
    
    DropdownBackground = Color3.fromRGB(26, 18, 38),
    DropdownText = Color3.fromRGB(245, 240, 255),
    DropdownStroke = Color3.fromRGB(75, 45, 115),
    
    InputBackground = Color3.fromRGB(20, 14, 30),
    InputStroke = Color3.fromRGB(75, 45, 115),
    PlaceholderColor = Color3.fromRGB(120, 95, 155)
})

-- Inisialisasi Window Utama VoidHub
local Window = Rayfield:CreateWindow({
    Name = "VoidHub",
    LoadingTitle = "VoidHub iOS",
    LoadingSubtitle = "by Kio",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoidHubConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
    Theme = "iOSDarkPurple"
})

-- Safe Customization untuk Minimizer Logo "VH" (iOS Pill Badge Style)
task.spawn(function()
    task.wait(1)
    local coreGui = game:GetService("CoreGui")
    local rayfieldGui = coreGui:FindFirstChild("Rayfield") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Rayfield")
    
    if rayfieldGui then
        for _, desc in pairs(rayfieldGui:GetDescendants()) do
            if desc:IsA("TextButton") and (desc.Name == "Open" or desc.Name == "Close" or desc.Name == "Minimize") then
                desc.Text = "VH"
                desc.Font = Enum.Font.SourceSansBold
                desc.TextSize = 14
                desc.TextColor3 = Color3.fromRGB(235, 215, 255)
                desc.BackgroundColor3 = Color3.fromRGB(38, 24, 58)
                
                local stroke = desc:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(130, 75, 200)
                stroke.Thickness = 1
                stroke.Parent = desc
                
                local corner = desc:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0) -- Membuat pill membulat khas iOS
                corner.Parent = desc
            end
        end
    end
end)

-- ==========================================
-- TAB MENU (iOS STYLED)
-- ==========================================

local MainTab = Window:CreateTab("Main", "home")
local PlayerTab = Window:CreateTab("Player", "user")
local MiscTab = Window:CreateTab("Misc", "shield")
local SettingsTab = Window:CreateTab("Settings", "cog")

-- ==========================================
-- FITUR ANTI-AFK
-- ==========================================

MainTab:CreateSection("Sistem Anti-AFK")

local AntiAFKConnections = nil
local AntiAFKEnabled = false

local AntiAFKToggle = MainTab:CreateToggle({
    Name = "Anti-AFK System",
    CurrentValue = false,
    Flag = "AntiAFKFlag",
    Callback = function(Value)
        AntiAFKEnabled = Value
        if AntiAFKEnabled then
            -- Mencegah Kick 20 Menit Roblox
            local VirtualUser = game:GetService("VirtualUser")
            AntiAFKConnections = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                Rayfield:Notify({
                    Title = "VoidHub Anti-AFK",
                    Content = "Deteksi AFK dicegah otomatis!",
                    Duration = 3,
                    Image = "shield"
                })
            end)
            
            Rayfield:Notify({
                Title = "VoidHub Anti-AFK",
                Content = "Anti-AFK berhasil Diaktifkan",
                Duration = 3,
                Image = "check"
            })
        else
            if AntiAFKConnections then
                AntiAFKConnections:Disconnect()
                AntiAFKConnections = nil
            end
            Rayfield:Notify({
                Title = "VoidHub Anti-AFK",
                Content = "Anti-AFK Dimatikan",
                Duration = 3,
                Image = "x"
            })
        end
    end,
})

MainTab:CreateLabel("Status Anti-AFK aktif menjaga koneksi game.")

-- Notifikasi Berhasil Execute
Rayfield:Notify({
    Title = "VoidHub Loaded",
    Content = "Selamat datang! Script by Kio siap digunakan.",
    Duration = 4,
    Image = "sparkles"
})

print("[VoidHub] iOS Edition successfully loaded!")
