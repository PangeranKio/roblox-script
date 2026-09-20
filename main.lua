-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Bikin Window Utama
local Window = Rayfield:CreateWindow({
   Name = "VoidHub",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Kio",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Tambah Tab Utama (Gunakan icon string 'home' agar aman di Mobile)
local MainTab = Window:CreateTab("Main Features", "home")

-- Section: Anti-AFK System
MainTab:CreateSection("Anti-AFK System")

local AntiAFKConnection = nil
local VirtualUser = game:GetService("VirtualUser")

-- Toggle Anti-AFK
local AntiAFKToggle = MainTab:CreateToggle({
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

-- Label Keterangan
MainTab:CreateLabel("Mencegah terkena kick 20 menit saat AFK.")

-- Notifikasi saat script berhasil di-load
Rayfield:Notify({
   Title = "VoidHub Loaded!",
   Content = "GUI berhasil dimuat dan siap digunakan.",
   Duration = 5,
   Image = "shield"
})
