-- [[ VOIDHUB SUPREME v11.0 ]]
-- iOS PREMIUM UI / UX
-- UI Layer Rewrite
-- Functional callbacks can be connected to your existing feature functions.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- =========================================================
-- CLEANUP
-- =========================================================

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("VoidHub_iOS")
if old then
	old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidHub_iOS"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- =========================================================
-- THEME
-- =========================================================

local Theme = {
	Background = Color3.fromRGB(8, 8, 10),
	Surface = Color3.fromRGB(20, 20, 22),
	Surface2 = Color3.fromRGB(28, 28, 30),
	Surface3 = Color3.fromRGB(38, 38, 41),

	Text = Color3.fromRGB(248, 248, 250),
	Secondary = Color3.fromRGB(155, 155, 162),
	Muted = Color3.fromRGB(105, 105, 112),

	Blue = Color3.fromRGB(10, 132, 255),
	Green = Color3.fromRGB(48, 209, 88),
	Red = Color3.fromRGB(255, 69, 58),
	Orange = Color3.fromRGB(255, 159, 10),

	Border = Color3.fromRGB(70, 70, 75)
}

local TweenFast = TweenInfo.new(
	0.16,
	Enum.EasingStyle.Quart,
	Enum.EasingDirection.Out
)

local TweenSmooth = TweenInfo.new(
	0.28,
	Enum.EasingStyle.Quart,
	Enum.EasingDirection.Out
)

-- =========================================================
-- HELPERS
-- =========================================================

local function Corner(object, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = object
	return c
end

local function Stroke(object, transparency)
	local s = Instance.new("UIStroke")
	s.Color = Theme.Border
	s.Transparency = transparency or 0.7
	s.Thickness = 1
	s.Parent = object
	return s
end

local function Padding(object, value)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, value)
	p.PaddingBottom = UDim.new(0, value)
	p.PaddingLeft = UDim.new(0, value)
	p.PaddingRight = UDim.new(0, value)
	p.Parent = object
	return p
end

local function Label(parent, text, size, color, font)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = color or Theme.Text
	l.TextSize = size or 14
	l.Font = font or Enum.Font.Gotham
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = parent
	return l
end

local function Animate(object, properties, info)
	TweenService:Create(
		object,
		info or TweenSmooth,
		properties
	):Play()
end

-- =========================================================
-- MAIN WINDOW
-- =========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.new(0.9, 0, 0.82, 0)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Corner(Main, 30)
Stroke(Main, 0.65)

local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MinSize = Vector2.new(320, 420)
SizeConstraint.MaxSize = Vector2.new(760, 650)
SizeConstraint.Parent = Main

-- =========================================================
-- TOP HEADER
-- =========================================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 82)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Brand = Label(
	Header,
	"VoidHub",
	22,
	Theme.Text,
	Enum.Font.GothamBold
)

Brand.Position = UDim2.new(0, 24, 0, 16)
Brand.Size = UDim2.new(0, 250, 0, 28)

local Version = Label(
	Header,
	"SUPREME  •  v11.0",
	10,
	Theme.Secondary,
	Enum.Font.GothamMedium
)

Version.Position = UDim2.new(0, 25, 0, 46)
Version.Size = UDim2.new(0, 200, 0, 18)

-- status pill

local Status = Instance.new("Frame")
Status.Size = UDim2.new(0, 100, 0, 30)
Status.Position = UDim2.new(1, -116, 0, 25)
Status.BackgroundColor3 = Color3.fromRGB(27, 52, 34)
Status.Parent = Header

Corner(Status, 15)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.Position = UDim2.new(0, 12, 0.5, -3)
StatusDot.BackgroundColor3 = Theme.Green
StatusDot.Parent = Status

Corner(StatusDot, 10)

local StatusText = Label(
	Status,
	"ACTIVE",
	10,
	Theme.Green,
	Enum.Font.GothamBold
)

StatusText.Position = UDim2.new(0, 26, 0, 0)
StatusText.Size = UDim2.new(1, -30, 1, 0)

-- close

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -58, 0, 24)
Close.BackgroundColor3 = Theme.Surface3
Close.Text = "×"
Close.TextColor3 = Theme.Text
Close.TextSize = 20
Close.Font = Enum.Font.GothamMedium
Close.AutoButtonColor = false
Close.Parent = Header

Corner(Close, 16)

-- =========================================================
-- CONTENT
-- =========================================================

local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, -32, 1, -150)
Body.Position = UDim2.new(0, 16, 0, 82)
Body.BackgroundTransparency = 1
Body.Parent = Main

-- =========================================================
-- PAGE SYSTEM
-- =========================================================

local Pages = {}

local function CreatePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 0
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new()
	page.Visible = false
	page.Parent = Body

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 14)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	Padding(page, 4)

	Pages[name] = page

	return page
end

local HomePage = CreatePage("Home")
local MovementPage = CreatePage("Movement")
local VisualPage = CreatePage("Visual")
local SystemPage = CreatePage("System")

HomePage.Visible = true

-- =========================================================
-- SECTION HEADER
-- =========================================================

local function SectionHeader(parent, title, subtitle)

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 48)
	holder.BackgroundTransparency = 1
	holder.Parent = parent

	local titleLabel = Label(
		holder,
		title,
		17,
		Theme.Text,
		Enum.Font.GothamBold
	)

	titleLabel.Position = UDim2.new(0, 4, 0, 0)
	titleLabel.Size = UDim2.new(1, -8, 0, 24)

	local sub = Label(
		holder,
		subtitle or "",
		11,
		Theme.Secondary,
		Enum.Font.Gotham
	)

	sub.Position = UDim2.new(0, 4, 0, 25)
	sub.Size = UDim2.new(1, -8, 0, 20)

	return holder
end

-- =========================================================
-- IOS CARD
-- =========================================================

local function Card(parent, height)

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, height)
	card.BackgroundColor3 = Theme.Surface
	card.BorderSizePixel = 0
	card.Parent = parent

	Corner(card, 20)
	Stroke(card, 0.82)

	return card
end

-- =========================================================
-- HOME
-- =========================================================

SectionHeader(
	HomePage,
	"Welcome back.",
	"Your VoidHub workspace is ready."
)

local Welcome = Card(HomePage, 125)

local WelcomeTitle = Label(
	Welcome,
	"VoidHub Supreme",
	19,
	Theme.Text,
	Enum.Font.GothamBold
)

WelcomeTitle.Position = UDim2.new(0, 18, 0, 17)
WelcomeTitle.Size = UDim2.new(1, -36, 0, 25)

local WelcomeDesc = Label(
	Welcome,
	"Premium iOS-inspired control center\nfor your Roblox experience.",
	12,
	Theme.Secondary,
	Enum.Font.Gotham
)

WelcomeDesc.Position = UDim2.new(0, 18, 0, 48)
WelcomeDesc.Size = UDim2.new(1, -36, 0, 42)
WelcomeDesc.TextWrapped = true

-- blue accent

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 4, 0, 72)
Accent.Position = UDim2.new(1, -14, 0.5, -36)
Accent.BackgroundColor3 = Theme.Blue
Accent.Parent = Welcome

Corner(Accent, 4)

-- =========================================================
-- QUICK STATUS
-- =========================================================

SectionHeader(
	HomePage,
	"Quick Status",
	"Current feature state"
)

local StatusCard = Card(HomePage, 82)

local function StatusItem(x, title, value)

	local item = Instance.new("Frame")
	item.Size = UDim2.new(0.31, 0, 1, 0)
	item.Position = UDim2.new(x, 0, 0, 0)
	item.BackgroundTransparency = 1
	item.Parent = StatusCard

	local t = Label(
		item,
		title,
		10,
		Theme.Secondary,
		Enum.Font.GothamMedium
	)

	t.Position = UDim2.new(0, 14, 0, 17)
	t.Size = UDim2.new(1, -14, 0, 18)

	local v = Label(
		item,
		value,
		13,
		Theme.Text,
		Enum.Font.GothamBold
	)

	v.Position = UDim2.new(0, 14, 0, 39)
	v.Size = UDim2.new(1, -14, 0, 20)
end

StatusItem(0, "PLAYER", LocalPlayer.DisplayName)
StatusItem(0.34, "BUILD", "v11.0")
StatusItem(0.68, "MODE", "iOS")

-- =========================================================
-- IOS TOGGLE
-- =========================================================

local function CreateToggle(parent, title, subtitle, default, callback)

	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 68)
	row.BackgroundColor3 = Theme.Surface
	row.BorderSizePixel = 0
	row.Parent = parent

	Corner(row, 18)
	Stroke(row, 0.84)

	local titleLabel = Label(
		row,
		title,
		13,
		Theme.Text,
		Enum.Font.GothamMedium
	)

	titleLabel.Position = UDim2.new(0, 18, 0, 13)
	titleLabel.Size = UDim2.new(1, -90, 0, 20)

	local subLabel = Label(
		row,
		subtitle or "",
		10,
		Theme.Secondary,
		Enum.Font.Gotham
	)

	subLabel.Position = UDim2.new(0, 18, 0, 35)
	subLabel.Size = UDim2.new(1, -90, 0, 18)

	-- switch

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 51, 0, 31)
	switch.Position = UDim2.new(1, -67, 0.5, -15)
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = row

	Corner(switch, 20)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 27, 0, 27)
	knob.Parent = switch

	Corner(knob, 20)

	local active = default

	local function Update(animated)

		if active then

			Animate(
				switch,
				{
					BackgroundColor3 = Theme.Green
				},
				animated and TweenFast or TweenInfo.new()
			)

			Animate(
				knob,
				{
					Position = UDim2.new(1, -29, 0.5, -13),
					BackgroundColor3 = Color3.fromRGB(255,255,255)
				},
				animated and TweenFast or TweenInfo.new()
			)

		else

			Animate(
				switch,
				{
					BackgroundColor3 = Theme.Surface3
				},
				animated and TweenFast or TweenInfo.new()
			)

			Animate(
				knob,
				{
					Position = UDim2.new(0, 2, 0.5, -13),
					BackgroundColor3 = Color3.fromRGB(225,225,228)
				},
				animated and TweenFast or TweenInfo.new()
			)

		end
	end

	Update(false)

	switch.MouseButton1Click:Connect(function()

		active = not active

		Update(true)

		if callback then
			callback(active)
		end
	end)

	return row
end

-- =========================================================
-- IOS BUTTON
-- =========================================================

local function CreateButton(parent, title, subtitle, callback)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 62)
	button.BackgroundColor3 = Theme.Surface
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = parent

	Corner(button, 18)
	Stroke(button, 0.84)

	local titleLabel = Label(
		button,
		title,
		13,
		Theme.Text,
		Enum.Font.GothamMedium
	)

	titleLabel.Position = UDim2.new(0, 18, 0, 10)
	titleLabel.Size = UDim2.new(1, -65, 0, 20)

	local subLabel = Label(
		button,
		subtitle or "",
		10,
		Theme.Secondary,
		Enum.Font.Gotham
	)

	subLabel.Position = UDim2.new(0, 18, 0, 32)
	subLabel.Size = UDim2.new(1, -65, 0, 18)

	local arrow = Label(
		button,
		"›",
		25,
		Theme.Muted,
		Enum.Font.Gotham
	)

	arrow.TextXAlignment = Enum.TextXAlignment.Center
	arrow.Position = UDim2.new(1, -42, 0.5, -15)
	arrow.Size = UDim2.new(0, 25, 0, 30)

	button.MouseButton1Click:Connect(function()

		Animate(
			button,
			{
				BackgroundColor3 = Theme.Surface3
			},
			TweenFast
		)

		task.delay(0.1, function()

			Animate(
				button,
				{
					BackgroundColor3 = Theme.Surface
				},
				TweenFast
			)

		end)

		if callback then
			callback()
		end
	end)

	return button
end

-- =========================================================
-- MOVEMENT PAGE
-- =========================================================

SectionHeader(
	MovementPage,
	"Movement",
	"Control how your character moves."
)

CreateToggle(
	MovementPage,
	"Fly Mode",
	"WASD / mobile control",
	false,
	function(active)
		-- Connect your existing Fly start/stop functions here.
	end
)

CreateToggle(
	MovementPage,
	"WalkSpeed",
	"Custom movement speed",
	false,
	function(active)
		-- Connect your existing WalkSpeed logic here.
	end
)

CreateToggle(
	MovementPage,
	"Jump Power",
	"Custom jump strength",
	false,
	function(active)
		-- Connect your existing JumpPower logic here.
	end
)

CreateToggle(
	MovementPage,
	"Infinite Jump",
	"Jump repeatedly while enabled",
	false,
	function(active)
		-- Connect existing Infinite Jump logic.
	end
)

CreateToggle(
	MovementPage,
	"Noclip",
	"Disable character collisions",
	false,
	function(active)
		-- Connect existing Noclip logic.
	end
)

-- =========================================================
-- VISUAL PAGE
-- =========================================================

SectionHeader(
	VisualPage,
	"Visual",
	"Customize your visual experience."
)

CreateToggle(
	VisualPage,
	"Player Highlight",
	"Highlight other players",
	false,
	function(active)
		-- Connect your Highlight / ESP logic.
	end
)

CreateToggle(
	VisualPage,
	"UI Animations",
	"Enable interface transitions",
	true,
	function(active)
	end
)

-- =========================================================
-- SYSTEM PAGE
-- =========================================================

SectionHeader(
	SystemPage,
	"System",
	"Session and interface controls."
)

CreateToggle(
	SystemPage,
	"Anti-AFK",
	"Keep your session active",
	true,
	function(active)
		-- Connect your own game's AFK system here.
	end
)

CreateButton(
	SystemPage,
	"Rejoin Server",
	"Reconnect to the current experience",
	function()
		-- Connect your existing teleport logic.
	end
)

CreateButton(
	SystemPage,
	"Server Hop",
	"Find another available server",
	function()
		-- Connect your server selection logic.
	end
)

-- =========================================================
-- BOTTOM TAB BAR
-- =========================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -32, 0, 58)
TabBar.Position = UDim2.new(0, 16, 1, -74)
TabBar.BackgroundColor3 = Theme.Surface
TabBar.Parent = Main

Corner(TabBar, 20)
Stroke(TabBar, 0.78)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabBar

local TabButtons = {}

local function SelectPage(name)

	for pageName, page in pairs(Pages) do
		page.Visible = pageName == name
	end

	for pageName, button in pairs(TabButtons) do

		local selected = pageName == name

		Animate(
			button,
			{
				BackgroundColor3 = selected
					and Theme.Blue
					or Theme.Surface2
			},
			TweenFast
		)

		button.TextColor3 =
			selected
			and Theme.Text
			or Theme.Secondary
	end
end

local function CreateTab(name, icon)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 92, 0, 42)
	button.BackgroundColor3 = name == "Home"
		and Theme.Blue
		or Theme.Surface2

	button.Text = icon .. "  " .. name
	button.TextColor3 = Theme.Text
	button.TextSize = 11
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = false
	button.Parent = TabBar

	Corner(button, 14)

	TabButtons[name] = button

	button.MouseButton1Click:Connect(function()
		SelectPage(name)
	end)

	return button
end

CreateTab("Home", "⌂")
CreateTab("Move", "↕")
CreateTab("Visual", "◉")
CreateTab("System", "⚙")

-- map Move -> actual page
TabButtons.Move.MouseButton1Click:Connect(function()
	SelectPage("Movement")
end)

-- =========================================================
-- FLOATING MINI BUTTON
-- =========================================================

local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 54, 0, 54)
Mini.Position = UDim2.new(0, 20, 0.5, -27)
Mini.BackgroundColor3 = Theme.Surface
Mini.Text = "V"
Mini.TextColor3 = Theme.Text
Mini.TextSize = 18
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.Parent = ScreenGui

Corner(Mini, 27)
Stroke(Mini, 0.6)

-- =========================================================
-- OPEN / CLOSE
-- =========================================================

local function OpenUI()

	Main.Visible = true
	Mini.Visible = false

	Main.Size = UDim2.new(0.01, 0, 0.01, 0)

	Animate(
		Main,
		{
			Size = UDim2.new(0.9, 0, 0.82, 0)
		},
		TweenSmooth
	)
end

local function CloseUI()

	Animate(
		Main,
		{
			Size = UDim2.new(0.01, 0, 0.01, 0)
		},
		TweenSmooth
	)

	task.delay(0.28, function()

		Main.Visible = false
		Mini.Visible = true

	end)
end

Close.MouseButton1Click:Connect(CloseUI)
Mini.MouseButton1Click:Connect(OpenUI)

-- =========================================================
-- DRAG SUPPORT
-- =========================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end
end)

Header.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end
end)

-- =========================================================
-- STARTUP
-- =========================================================

Main.Size = UDim2.new(0.01, 0, 0.01, 0)

task.defer(function()

	Animate(
		Main,
		{
			Size = UDim2.new(0.9, 0, 0.82, 0)
		},
		TweenSmooth
	)

end)
