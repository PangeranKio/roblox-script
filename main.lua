-- [[ VOIDHUB - iOS Dark Edition (Fixed Loader) ]] --
-- Created by: Kio

-- 1. Anti Double-Load Cleanup
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("Rayfield") then
    CoreGui.Rayfield:Destroy()
end
if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Rayfield") then
    LocalPlayer.PlayerGui.Rayfield:Destroy()
end

-- 2. Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 3. Registrasi Tema iOS Dark Purple
Rayfield:RegisterTheme("iOSDarkPurple", {
    TextColor = Color3.fromRGB(245, 240, 255),
    Background = Color3.fromRGB(18, 14, 26),
    Topbar = Color3.fromRGB(28, 20, 42),
    Shadow = Color3.fromRGB(8, 5, 12),
    NotificationBackground = Color3.fromRGB(32, 22, 48),
    NotificationActionsBackground = Color3.fromRGB(48, 30, 70),
    
    TabBackground = Color3.fromRGB(26, 18, 38),
    TabStroke = Color3.fromRGB(90, 55, 140),
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

-- 4. Inisialisasi Window
local Window = Rayfield:CreateWindow({
    Name = "VoidHub",
    LoadingTitle = "VoidHub iOS",
    LoadingSubtitle = "by Kio",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
    Theme = "iOSDarkPurple"
})

-- 5. Safe Customization untuk Tombol Minimizer Logo "VH" (Aman dari Crash)
task.spawn(function()
    task.wait(1.5)
    pcall(function()
        local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
        if rayfieldGui then
            for _, desc in pairs(rayfieldGui:GetDescendants()) do
                if desc:IsA("TextButton") and (desc.Name == "Open" or desc.Name == "Close" or desc.Name == "Minimize") then
                    desc.Text = "VH"
                    desc.Font = Enum.Font.SourceSansBold
                    desc.TextSize = 13
                    desc.TextColor3 = Color3.fromRGB(235, 215, 255)
                    desc.BackgroundColor3 = Color3.fromRGB(38, 24, 58)
                    
                    local stroke = desc:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
                    stroke.Color = Color3.fromRGB(130, 75, 200)
                    stroke.Thickness = 1
                    stroke.Parent = desc
                    
                    local corner = desc:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = desc
                end
            end
        end
    end)
end)

-- 6. Tab Navigation (iOS Icons)
local MainTab = Window:CreateTab("Main", "home")
local PlayerTab = Window:CreateTab("Player", "user")
local MiscTab = Window:CreateTab("Misc", "shield")
local SettingsTab = Window:CreateTab("Settings", "cog")

-- 7. Fitur Anti-AFK
MainTab:CreateSection("Sistem Anti-AFK")

local AntiAFKConnections = nil
local VirtualUser = game:GetService("VirtualUser")

MainTab:CreateToggle({
    Name = "Anti-AFK System",
    CurrentValue = false,
    Flag = "AntiAFKFlag",
    Callback = function(Value)
        if Value then
            AntiAFKConnections = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                Rayfield:Notify({
                    Title = "VoidHub Anti-AFK",
                    Content = "Deteksi AFK dicegah!",
                    Duration = 2,
                    Image = "shield"
                })
            end)
            
            Rayfield:Notify({
                Title = "VoidHub Anti-AFK",
                Content = "Status: Aktif",
                Duration = 2.5,
                Image = "check"
            })
        else
            if AntiAFKConnections then
                AntiAFKConnections:Disconnect()
                AntiAFKConnections = nil
            end
            Rayfield:Notify({
                Title = "VoidHub Anti-AFK",
                Content = "Status: Nonaktif",
                Duration = 2.5,
                Image = "x"
            })
        end
    end,
})

MainTab:CreateLabel("Mencegah akun terputus (kick 20 menit) saat AFK.")

-- Notifikasi Sukses
Rayfield:Notify({
    Title = "VoidHub iOS Loaded",
    Content = "Script by Kio siap digunakan!",
    Duration = 3.5,
    Image = "sparkles"
})
