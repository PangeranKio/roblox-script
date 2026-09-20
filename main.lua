-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Bikin Window Utama VoidHub
local Window = Rayfield:CreateWindow({
   Name = "VoidHub",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Kio",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VoidHubConfig",
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- ==========================================
-- SNIPPET KUSTOMISASI UI (Gradient & Minimize)
-- ==========================================
task.spawn(function()
    task.wait(2) -- Jeda agar UI ter-render sempurna di CoreGui
    
    local coreGui = game:GetService("CoreGui")
    local localPlayer = game:GetService("Players").LocalPlayer
    local rayfieldGui = coreGui:FindFirstChild("Rayfield") or (localPlayer and localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("Rayfield"))
    
    if rayfieldGui then
        -- 1. UBAH TEKS TOMBOL MINIMIZE MENJADI "VoidHub"
        for _, desc in pairs(rayfieldGui:GetDescendants()) do
            if desc:IsA("TextButton") then
                if desc.Text:find("Rayfield") or desc.Name == "Open" or desc.Name == "Close" or desc.Name == "Toggle" then
                    desc.Text = "VoidHub"
                    desc:GetPropertyChangedSignal("Text"):Connect(function()
                        if desc.Text ~= "VoidHub" then
                            desc.Text = "VoidHub"
                        end
                    end)
                end
            end
        end

        -- 2. PASANG EFEK GRADIENT UNGU-HITAM
        for _, desc in pairs(rayfieldGui:GetDescendants()) do
            if desc:IsA("Frame") and (desc.Name == "Main" or desc.Name == "Background" or desc.Name == "MainFrame") then
                local oldGrad = desc:FindFirstChildOfClass("UIGradient")
                if oldGrad then oldGrad:Destroy() end
                
                local gradient = Instance.new("UIGradient")
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 22, 62)),   -- Ungu Soft
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(22, 12, 32)), -- Ungu Gelap
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 18))     -- Hitam Soft
                }
                gradient.Rotation = 135
                gradient.Parent = desc
            end
        end
    end
end)

-- ==========================================
-- TAB NAVIGATION & FITUR
-- ==========================================

-- Tab Utama
local MainTab = Window:CreateTab("Main Features", "home")

-- Section: Anti-AFK System
MainTab:CreateSection("Anti-AFK System")

local AntiAFKConnection = nil
local VirtualUser = game:GetService("VirtualUser")

MainTab:CreateToggle({
   Name = "Enable Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFKFlag",
   Callback = function(Value)
      if Value then
         AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            Rayfield:Notify({
               Title = "VoidHub Anti-AFK",
               Content = "Berhasil mencegah idle disconnect!",
               Duration = 2,
               Image = "shield"
            })
         end)
         
         Rayfield:Notify({
            Title = "Anti-AFK Status",
            Content = "Anti-AFK Berhasil Diaktifkan",
            Duration = 3,
            Image = "shield"
         })
      else
         if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
         end
         
         Rayfield:Notify({
            Title = "Anti-AFK Status",
            Content = "Anti-AFK Dimatikan",
            Duration = 3,
            Image = "shield"
         })
      end
   end,
})

MainTab:CreateLabel("Mencegah terkena kick 20 menit saat AFK.")

-- Section: Player Movement
MainTab:CreateSection("Player Settings")

MainTab:CreateToggle({
   Name = "Enable WalkSpeed",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      if Value then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
      else
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
   end,
})

MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

MainTab:CreateInput({
   Name = "Custom WalkSpeed",
   PlaceholderText = "Masukkan angka (misal: 50)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
      end
   end,
})

-- Section: Action Buttons
MainTab:CreateSection("Actions")

MainTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.Health = 0
   end,
})

-- Notifikasi saat script berhasil di-load
Rayfield:Notify({
   Title = "VoidHub Loaded!",
   Content = "GUI berhasil dimuat dan siap digunakan.",
   Duration = 5,
   Image = "shield",
})
