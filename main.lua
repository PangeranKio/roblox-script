-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Bikin Window Utama
local Window = Rayfield:CreateWindow({
   Name = "VoidHub",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Akio",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VoidHubConfig",
      FileName = "BigHub"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false -- Set true kalau mau pakai sistem key
})

-- Potongan kode untuk mengubah teks tombol minimize Rayfield
task.spawn(function()
    task.wait(1) -- Beri jeda sebentar agar UI ter-render sempurna
    local coreGui = game:GetService("CoreGui")
    local rayfieldGui = coreGui:FindFirstChild("Rayfield") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
    
    if rayfieldGui then
        for _, desc in pairs(rayfieldGui:GetDescendants()) do
            -- Mencari tombol toggle open/close
            if desc:IsA("TextButton") and (desc.Text == "Show Rayfield" or desc.Name == "Open" or desc.Name == "Close") then
                desc.Text = "VoidHub" -- Ganti sesuai keinginan (misal: "VH" atau "VoidHub")
            end
        end
    end
end)


-- Tambah Tab Utama
local MainTab = Window:CreateTab("Main Features", 4483362458) -- ID Icon Roblox

-- Section: Player Movement
MainTab:CreateSection("Player Settings")

-- 1. Toggle (Sakelar On/Off)
local SpeedToggle = MainTab:CreateToggle({
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

-- 2. Slider (Mengatur Nilai Angka)
local JumpSlider = MainTab:CreateSlider({
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

-- Section: Action Buttons
MainTab:CreateSection("Actions")

-- 3. Button (Tombol Sekali Klik)
local TeleportBtn = MainTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.Health = 0
   end,
})

-- 4. Textbox (Input Teks/Nilai)
local CustomSpeedInput = MainTab:CreateInput({
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

-- Notifikasi saat script berhasil di-load
Rayfield:Notify({
   Title = "Script Loaded!",
   Content = "GUI berhasil dimuat dan siap digunakan.",
   Duration = 5,
   Image = 4483362458,
})
