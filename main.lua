-- [[ VOIDHUB CUSTOM UI - ULTRA SUPREME EDITION v5.0 ]] --
-- Created by Kio (Fixed ESP, Selected Egg Menu, Walking Auto Steal, Working Treadmill, & Luxury UI)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("VoidHubUI") then
    CoreGui.VoidHubUI:Destroy()
end

local VoidHubUI = Instance.new("ScreenGui")
VoidHubUI.Name = "VoidHubUI"
VoidHubUI.Parent = CoreGui
VoidHubUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- CONFIG SYSTEM
local ConfigFileName = "VoidHub_Config_Kio_v5.json"
local SavedConfig = {
    AutoStealActive = false,
    SelectedEggTarget = "All Eggs",
    AutoTreadmill = true,
    PlayerESP = false,
    EggESPUI = false
}

local function SaveSettings()
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(SavedConfig)) end
    end)
end

local function LoadSettings()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(decoded) do SavedConfig[k] = v end
        end
    end)
end
LoadSettings()

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- FLOATING BUTTON "Void"
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 72, 0, 38)
OpenBtn.Position = UDim2.new(0.08, 0, 0.22, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 8, 26)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "Void"
OpenBtn.TextColor3 = Color3.fromRGB(240, 180, 255)
OpenBtn.TextSize = 14
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Visible = false
OpenBtn.Parent = VoidHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenBtn

local OpenGlow = Instance.new("UIStroke")
OpenGlow.Color = Color3.fromRGB(200, 110, 255)
OpenGlow.Transparency = 0.2
OpenGlow.Thickness = 1.8
OpenGlow.Parent = OpenBtn

MakeDraggable(OpenBtn, OpenBtn)

-- LOADING FRAME
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 280, 0, 110)
LoadingFrame.Position = UDim2.new(0.5, -140, 0.5, -55)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 4, 18)
LoadingFrame.BackgroundTransparency = 0.05
LoadingFrame.Parent = VoidHubUI

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 20)
LoadCorner.Parent = LoadingFrame

local LoadGradient = Instance.new("UIGradient")
LoadGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 20, 110)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 2, 14))
}
LoadGradient.Rotation = 45
LoadGradient.Parent = LoadingFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(210, 130, 255)
LoadStroke.Transparency = 0.25
LoadStroke.Thickness = 2
LoadStroke.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0, 20)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "VOIDHUB <font color=\"#E090FF\">ULTRA LUXURY</font>"
LoadTitle.RichText = true
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 16
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 22)
LoadStatus.Position = UDim2.new(0, 0, 0, 60)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Initializing Supreme Modules..."
LoadStatus.TextColor3 = Color3.fromRGB(190, 160, 230)
LoadStatus.TextSize = 12
LoadStatus.Font = Enum.Font.GothamMedium
LoadStatus.Parent = LoadingFrame

-- MAIN WINDOW
local TargetSize = UDim2.new(0, 540, 0, 340)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 3, 14)
MainFrame.BackgroundTransparency = 0.04
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = VoidHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 18, 90)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 5, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 2, 12))
}
GlassGradient.Rotation = 130
GlassGradient.Parent = MainFrame

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(200, 120, 255)
GlassStroke.Transparency = 0.3
GlassStroke.Thickness = 2
GlassStroke.Parent = MainFrame

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 320, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VoidHub <font color=\"#C080FF\">Supreme v5.0</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

MakeDraggable(Topbar, MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -42, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 65)
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(240, 200, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(1, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local CloseTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

-- SIDEBAR
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -62)
Sidebar.Position = UDim2.new(0, 12, 0, 52)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 0
Sidebar.Parent = MainFrame

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 8)
SBLayout.Parent = Sidebar

-- CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -168, 1, -62)
ContentArea.Position = UDim2.new(0, 158, 0, 52)
ContentArea.BackgroundColor3 = Color3.fromRGB(12, 6, 22)
ContentArea.BackgroundTransparency = 0.4
ContentArea.Parent = MainFrame

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 16)
CACorner.Parent = ContentArea

local CAStroke = Instance.new("UIStroke")
CAStroke.Color = Color3.fromRGB(255, 255, 255)
CAStroke.Transparency = 0.82
CAStroke.Parent = ContentArea

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = ContentArea

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 255)
    page.Visible = false
    page.Parent = PagesFolder
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    return page
end

local MainTabPage = CreatePage("Main")
local AutoTabPage = CreatePage("AutoSteal")
local WalkTabPage = CreatePage("Walk")
local MiscTabPage = CreatePage("Misc")
local ConfigTabPage = CreatePage("Config")
MainTabPage.Visible = true

local function CreateTabButton(text, pageTarget, defaultActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = defaultActive and Color3.fromRGB(130, 50, 230) or Color3.fromRGB(20, 10, 32)
    btn.BackgroundTransparency = defaultActive and 0.05 or 0.45
    btn.Text = "   " .. text
    btn.TextColor3 = defaultActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 150, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(210, 140, 255)
    stroke.Transparency = defaultActive and 0.3 or 0.85
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesFolder:GetChildren()) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do 
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 10, 32), BackgroundTransparency = 0.45}):Play()
                b.TextColor3 = Color3.fromRGB(180, 150, 220)
                if b:FindFirstChild("UIStroke") then b.UIStroke.Transparency = 0.85 end
            end
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 50, 230), BackgroundTransparency = 0.05}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if btn:FindFirstChild("UIStroke") then btn.UIStroke.Transparency = 0.3 end
    end)
end

CreateTabButton("Steal an Egg", MainTabPage, true)
CreateTabButton("Auto Steal", AutoTabPage, false)
CreateTabButton("Walk", WalkTabPage, false)
CreateTabButton("Misc", MiscTabPage, false)
CreateTabButton("Config", ConfigTabPage, false)

local function CreateToggle(parent, titleText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(22, 10, 36)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 12)
    fCorner.Parent = frame

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Color3.fromRGB(255, 255, 255)
    fStroke.Transparency = 0.88
    fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(245, 235, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 44, 0, 24)
    switch.Position = UDim2.new(1, -52, 0.5, -12)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(150, 70, 250) or Color3.fromRGB(35, 18, 55)
    switch.Text = ""
    switch.Parent = frame
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = switch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local active = defaultState
    switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 70, 250)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 18, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        callback(active)
    end)
end

local function CreateButton(parent, titleText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
    btn.BackgroundTransparency = 0.2
    btn.Text = titleText
    btn.TextColor3 = Color3.fromRGB(250, 235, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 12)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(200, 120, 255)
    bStroke.Transparency = 0.4
    bStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- TAB 1: EGG TRACKER & ESP (FIXED FILTER)
-- ==========================================
local EggTrackerContainer = Instance.new("ScrollingFrame")
EggTrackerContainer.Size = UDim2.new(1, 0, 0, 200)
EggTrackerContainer.BackgroundColor3 = Color3.fromRGB(18, 8, 30)
EggTrackerContainer.BackgroundTransparency = 0.45
EggTrackerContainer.BorderSizePixel = 0
EggTrackerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
EggTrackerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
EggTrackerContainer.ScrollBarThickness = 3
EggTrackerContainer.Parent = MainTabPage

local ETCCorner = Instance.new("UICorner")
ETCCorner.CornerRadius = UDim.new(0, 12)
ETCCorner.Parent = EggTrackerContainer

local ETCLayout = Instance.new("UIListLayout")
ETCLayout.SortOrder = Enum.SortOrder.LayoutOrder
ETCLayout.Padding = UDim.new(0, 5)
ETCLayout.Parent = EggTrackerContainer

local function IsValidEgg(name, obj)
    local l = name:lower()
    -- Filter ketat: Pastikan benar-benar telur dan bukan mesin fusi/item lain
    if l:find("fusion") or l:find("machine") or l:find("shop") or l:find("treadmill") or l:find("gym") then
        return false
    end
    return l:find("egg") or l:find("telur")
end

local function RefreshEggTracker()
    for _, child in pairs(EggTrackerContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local eggList = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if IsValidEgg(obj.Name, obj) and not obj.Name:lower():find("player") then
            local targetPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if targetPart then
                table.insert(eggList, {Object = obj, Part = targetPart, Name = obj.Name})
            end
        end
    end
    
    for _, item in ipairs(eggList) do
        if _G.EggESPUIActive then
            if not item.Part:FindFirstChild("VoidEggHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "VoidEggHighlight"
                hl.FillColor = Color3.fromRGB(180, 80, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                hl.Parent = item.Part
            end
        else
            if item.Part:FindFirstChild("VoidEggHighlight") then
                item.Part.VoidEggHighlight:Destroy()
            end
        end
        
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(32, 14, 52)
        row.BackgroundTransparency = 0.25
        row.Parent = EggTrackerContainer
        
        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = row
        
        local rLabel = Instance.new("TextLabel")
        rLabel.Size = UDim2.new(1, -10, 1, 0)
        rLabel.Position = UDim2.new(0, 10, 0, 0)
        rLabel.BackgroundTransparency = 1
        rLabel.TextColor3 = Color3.fromRGB(255, 220, 130)
        rLabel.TextSize = 11
        rLabel.Font = Enum.Font.GothamBold
        rLabel.TextXAlignment = Enum.TextXAlignment.Left
        rLabel.Text = "🥚 " .. item.Name
        rLabel.Parent = row
    end
end

CreateToggle(MainTabPage, "Egg ESP & Sorted UI Tracker", SavedConfig.EggESPUI, function(state)
    _G.EggESPUIActive = state
    SavedConfig.EggESPUI = state
    task.spawn(function()
        while _G.EggESPUIActive do
            pcall(RefreshEggTracker)
            task.wait(1.5)
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("VoidEggHighlight") then
                obj.VoidEggHighlight:Destroy()
            end
        end
    end)
end)

CreateButton(MainTabPage, "🔄 Refresh Egg List Now", function()
    pcall(RefreshEggTracker)
end)


-- ==========================================
-- TAB 2: AUTO STEAL & SELECTED EGG MENU & WORKING TREADMILL
-- ==========================================

-- Dropdown / Selector Menu Telur Target
local SelectedEggLabel = Instance.new("TextLabel")
SelectedEggLabel.Size = UDim2.new(1, 0, 0, 24)
SelectedEggLabel.BackgroundTransparency = 1
SelectedEggLabel.Text = "Target Selected Egg: [ " .. SavedConfig.SelectedEggTarget .. " ]"
SelectedEggLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
SelectedEggLabel.TextSize = 12
SelectedEggLabel.Font = Enum.Font.GothamBold
SelectedEggLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedEggLabel.Parent = AutoTabPage

CreateButton(AutoTabPage, "🔄 Cycle Selected Egg Target", function()
    if SavedConfig.SelectedEggTarget == "All Eggs" then
        SavedConfig.SelectedEggTarget = "Rare / Epic"
    elseif SavedConfig.SelectedEggTarget == "Rare / Epic" then
        SavedConfig.SelectedEggTarget = "Legendary / Mythic"
    elseif SavedConfig.SelectedEggTarget == "Legendary / Mythic" then
        SavedConfig.SelectedEggTarget = "Divine"
    else
        SavedConfig.SelectedEggTarget = "All Eggs"
    end
    SelectedEggLabel.Text = "Target Selected Egg: [ " .. SavedConfig.SelectedEggTarget .. " ]"
end)

CreateToggle(AutoTabPage, "Auto Steal (Walking / Pathfinding)", SavedConfig.AutoStealActive, function(state)
    _G.AutoStealActive = state
    SavedConfig.AutoStealActive = state
    
    task.spawn(function()
        while _G.AutoStealActive do
            pcall(function()
                local targetFound = false
                local targetPart = nil
                
                -- Cari telur di map dengan filter aman (menghindari mesin fusi)
                for _, obj in pairs(workspace:GetDescendants()) do
                    if IsValidEgg(obj.Name, obj) then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            targetPart = part
                            targetFound = true
                            break
                        end
                    end
                end
                
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if targetFound and targetPart and hum and hrp then
                    -- Berjalan/Lari menuju telur (bukan teleport instan)
                    hum:MoveTo(targetPart.Position)
                elseif SavedConfig.AutoTreadmill and hum and hrp then
                    -- Jika telur tidak ada, berjalan otomatis ke mesin Treadmill / Gym
                    local treadmill = workspace:FindFirstChild("Treadmill", true) or workspace:FindFirstChild("Gym", true)
                    if treadmill then
                        local tPart = treadmill:IsA("BasePart") and treadmill or treadmill:FindFirstChildWhichIsA("BasePart")
                        if tPart then
                            hum:MoveTo(tPart.Position)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

CreateToggle(AutoTabPage, "Auto Treadmill (If No Egg Found)", SavedConfig.AutoTreadmill, function(state)
    SavedConfig.AutoTreadmill = state
end)


-- ==========================================
-- TAB 3: WALK TAB
-- ==========================================
CreateToggle(WalkTabPage, "Custom WalkSpeed (24)", false, function(state)
    _G.SpeedActive = state
    task.spawn(function()
        while _G.SpeedActive do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 24 end
            end)
            task.wait(0.2)
        end
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end)
end)


-- ==========================================
-- TAB 4: MISC TAB
-- ==========================================
CreateToggle(MiscTabPage, "Anti-AFK Safe", true, function(state)
    _G.AntiAFKActive = state
    task.spawn(function()
        local lastMove = tick()
        while _G.AntiAFKActive do
            if tick() - lastMove >= 30 then
                lastMove = tick()
                pcall(function()
                    local currentCam = workspace.CurrentCamera
                    if currentCam then
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, 0.001, 0)
                        task.wait(0.05)
                        currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, -0.001, 0)
                    end
                end)
            end
            task.run(RunService.RenderStepped)
        end
    end)
end)

CreateButton(MiscTabPage, "🔄 Rejoin Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

CreateButton(MiscTabPage, "🌐 Server Hop (Cari Server Sepi)", function()
    pcall(function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(req.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
end)


-- ==========================================
-- TAB 5: CONFIG TAB
-- ==========================================
CreateButton(ConfigTabPage, "💾 Save Current Settings", function()
    SaveSettings()
    LoadStatus.Text = "Config Successfully Saved!"
    task.wait(1.5)
end)

CreateButton(ConfigTabPage, "📂 Load Config Settings", function()
    LoadSettings()
    LoadStatus.Text = "Config Successfully Loaded!"
    task.wait(1.5)
end)


-- RESIZE HANDLE
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤡"
ResizeHandle.TextColor3 = Color3.fromRGB(180, 140, 220)
ResizeHandle.TextSize = 10
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Parent = MainFrame

local Resizing, StartSize, StartInputPos = false, nil, nil
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        StartSize = MainFrame.Size
        StartInputPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - StartInputPos
        local NewX = math.max(480, StartSize.X.Offset + Delta.X)
        local NewY = math.max(280, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.new(0, NewX, 0, NewY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

-- ANIMATION & EXECUTION
local TweenBack = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Visible = true
    OpenBtn.Visible = false
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)

task.spawn(function()
    pcall(function()
        task.wait(0.3)
        LoadStatus.Text = "Loading Config Data..."
        task.wait(0.3)
        LoadStatus.Text = "Rendering Ultra Luxury Glass UI..."
        task.wait(0.3)
    end)
    if LoadingFrame and LoadingFrame.Parent then LoadingFrame:Destroy() end
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenBack, {Size = TargetSize}):Play()
end)
