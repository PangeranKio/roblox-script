-- [[ VOIDHUB - Rayfield Custom Edition ]] --
-- Created by: Kio

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Registrasi Tema Custom: Ungu - Hitam Soft (Gradient Style)
Rayfield:RegisterTheme("VoidHubDarkPurple", {
    TextColor = Color3.fromRGB(240, 235, 255),
    Background = Color3.fromRGB(20, 14, 28),             -- Hitam Soft Keunguan
    Topbar = Color3.fromRGB(34, 20, 48),                 -- Ungu Gelap
    Shadow = Color3.fromRGB(10, 6, 16),
    NotificationBackground = Color3.fromRGB(28, 18, 40),
    NotificationActionsBackground = Color3.fromRGB(45, 28, 65),
    
    TabBackground = Color3.fromRGB(30, 20, 42),
    TabStroke = Color3.fromRGB(120, 75, 180),            -- Ungu Muted
    TabBackgroundSelected = Color3.fromRGB(95, 50, 150),
    TabTextColor = Color3.fromRGB(180, 155, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    
    ElementBackground = Color3.fromRGB(28, 18, 40),
    ElementBackgroundHover = Color3.fromRGB(42, 26, 60),
    ElementStroke = Color3.fromRGB(100, 60, 150),
    SecondaryElementBackground = Color3.fromRGB(22, 14, 32),
    SecondaryElementBackgroundHover = Color3.fromRGB(32, 20, 46),
    SecondaryElementStroke = Color3.fromRGB(80, 48, 120),
    
    SliderBackground = Color3.fromRGB(40, 25, 58),
    SliderProgress = Color3.fromRGB(140, 85, 210),
    SliderStroke = Color3.fromRGB(160, 100, 230),
    
    ToggleBackground = Color3.fromRGB(40, 25, 58),
    ToggleEnabled = Color3.fromRGB(140, 85, 210),
    ToggleDisabled = Color3.fromRGB(25, 15, 38),
    ToggleStroke = Color3.fromRGB(150, 90, 220),
    
    DropdownBackground = Color3.fromRGB(28, 18, 40),
    DropdownText = Color3.fromRGB(240, 235, 255),
    DropdownStroke = Color3.fromRGB(100, 60, 150),
    
    InputBackground = Color3.fromRGB(22, 14, 32),
    InputStroke = Color3.fromRGB(100, 60, 150),
    PlaceholderColor = Color3.fromRGB(130, 105, 165)
})

-- Inisialisasi Window Utama
local Window = Rayfield:CreateWindow({
    Name = "VoidHub",
    LoadingTitle = "VoidHub Executing...",
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
    Theme = "VoidHubDarkPurple"
})

-- Kustomisasi Minimizer (Ubah Tombol Minimize Jadi Logo / Icon Floating)
task.spawn(function()
    local coreGui = game:GetService("CoreGui")
    local rayfieldGui = coreGui:WaitForChild("Rayfield", 5)
    if rayfieldGui then
        -- Mencari tombol minimize bawaan untuk diubah menjadi gaya Logo VoidHub
        for _, desc in pairs(rayfieldGui:GetDescendants()) do
            if desc:IsA("TextButton") and (desc.Name == "Open" or desc.Name == "Close") then
                desc.Text = "VH" -- Logo Singkatan VoidHub
                desc.Font = Enum.Font.SourceSansBold
                desc.TextSize = 16
                desc.TextColor3 = Color3.fromRGB(220, 190, 255)
                desc.BackgroundColor3 = Color3.fromRGB(34, 20, 48)
                
                -- Menambahkan sudut membulat untuk logo
                local corner = desc:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 10)
                corner.Parent = desc
            end
        end
    end
end)

-- ==========================================
-- TAB KOSONG (SIAP DIISI FITUR)
-- ==========================================

local MainTab = Window:CreateTab("Main", "home")
local PlayerTab = Window:CreateTab("Player", "user")
local MiscTab = Window:CreateTab("Misc", "sliders")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- Contoh Label Kosong di Tab Main
MainTab:CreateSection("Fitur Utama")
MainTab:CreateLabel("Belum ada fitur diset. Siap ditambahkan!")

print("[VoidHub] Loaded successfully with Custom Dark Purple Theme!")
