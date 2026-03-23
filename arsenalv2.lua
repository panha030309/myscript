local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- playersService is no longer needed since we use game:GetService("Players") directly.

local targetGui
pcall(function() targetGui = CoreGui end)
if not targetGui then targetGui = LocalPlayer:WaitForChild("PlayerGui") end

if targetGui:FindFirstChild("SilentAimHub") then
	targetGui.SilentAimHub:Destroy()
end

-- Remove any leftover blur
if Lighting:FindFirstChild("CinematicBlur") then
	Lighting.CinematicBlur:Destroy()
end

-- Global toggles
_G.SilentAimEnabled = false
_G.LegitAimbot      = false
_G.AutoShoot        = false

-- ScreenGui root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentAimHub"
ScreenGui.Parent = targetGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

------------------------------------------------
-- CYBERPUNK LOADING / WELCOME SCREEN
------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name      = "MainFrame"
MainFrame.Size      = UDim2.new(0, 520, 0, 300)
MainFrame.Position  = UDim2.new(0.5, -260, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true

-- Dark-purple cyberpunk gradient
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(8,  0,  18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 0,  40)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(5,  0,  12))
}
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Neon purple glowing border
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color  = Color3.fromRGB(180, 0, 255)
MainStroke.Thickness = 2.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Transparency = 1

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(200,  0, 255)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255, 80, 255)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(120,  0, 200))
}
StrokeGradient.Rotation = -45
StrokeGradient.Parent = MainStroke

-- Drop shadow
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
DropShadow.Size = UDim2.new(1, 50, 1, 50)
DropShadow.BackgroundTransparency = 1
DropShadow.Image = ""
DropShadow.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
DropShadow.ZIndex = -1
DropShadow.Parent = MainFrame

-- Dragging
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		}):Play()
	end
end)

------------------------------------------------
-- LOADING SCREEN ELEMENTS  (Cyberpunk theme)
------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 18)
Title.Size = UDim2.new(1, 0, 0, 34)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡  ARSENAL  HUB  ⚡"
Title.TextColor3 = Color3.fromRGB(220, 80, 255)  -- neon purple
Title.TextSize = 26
Title.TextTransparency = 1

-- Neon purple glow on title
local TitleStroke = Instance.new("UIStroke")
TitleStroke.Parent = Title
TitleStroke.Color  = Color3.fromRGB(180, 0, 255)
TitleStroke.Thickness = 2
TitleStroke.Transparency = 1

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = MainFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0, 55)
SubTitle.Size = UDim2.new(1, 0, 0, 18)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "CYBERPUNK EDITION  |  v2.0"
SubTitle.TextColor3 = Color3.fromRGB(160, 0, 220)
SubTitle.TextSize = 13
SubTitle.TextTransparency = 1

-- Credits label (multi-credit)
local Credits = Instance.new("TextLabel")
Credits.Parent = MainFrame
Credits.BackgroundTransparency = 1
Credits.Position = UDim2.new(0, 0, 0, 75)
Credits.Size = UDim2.new(1, 0, 0, 18)
Credits.Font = Enum.Font.Gotham
Credits.Text = "Credits: _dooliee  |  Chy Sopheakpanha  |  ជី.សុភ:បញ្ញា"
Credits.TextColor3 = Color3.fromRGB(190, 100, 255)
Credits.TextSize = 12
Credits.TextTransparency = 1

-- Loading bar background
local BarBg = Instance.new("Frame")
BarBg.Parent = MainFrame
BarBg.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
BarBg.BackgroundTransparency = 1
BarBg.BorderSizePixel = 0
BarBg.Position = UDim2.new(0.08, 0, 0.78, 0)
BarBg.Size = UDim2.new(0.84, 0, 0, 8)

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

-- Neon purple fill
local BarFill = Instance.new("Frame")
BarFill.Parent = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
BarFill.BackgroundTransparency = 1
BarFill.BorderSizePixel = 0
BarFill.Size = UDim2.new(0, 0, 1, 0)

local BarFillGradient = Instance.new("UIGradient")
BarFillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(120, 0, 200)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(220, 80, 255)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(180, 0, 255))
}
BarFillGradient.Parent = BarFill

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

-- Neon border on bar bg
local BarStroke = Instance.new("UIStroke")
BarStroke.Parent = BarBg
BarStroke.Color = Color3.fromRGB(180, 0, 255)
BarStroke.Thickness = 1
BarStroke.Transparency = 1

-- Status text under bar
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.88, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 16)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "> INITIALIZING SYSTEMS..."
StatusLabel.TextColor3 = Color3.fromRGB(160, 0, 220)
StatusLabel.TextSize = 12
StatusLabel.TextTransparency = 1

------------------------------------------------
-- FADE-IN ANIMATIONS
------------------------------------------------
local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

TweenService:Create(MainFrame,   fadeInfo, {BackgroundTransparency = 0.08}):Play()
TweenService:Create(MainStroke,  fadeInfo, {Transparency = 0}):Play()
TweenService:Create(TitleStroke, fadeInfo, {Transparency = 0}):Play()
TweenService:Create(Title,       fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(SubTitle,    fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(Credits,     fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(BarBg,       fadeInfo, {BackgroundTransparency = 0.4}):Play()
TweenService:Create(BarStroke,   fadeInfo, {Transparency = 0}):Play()
TweenService:Create(BarFill,     fadeInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(StatusLabel, fadeInfo, {TextTransparency = 0}):Play()

task.wait(1)
StatusLabel.Text = "> LOADING MODULES..."
TweenService:Create(BarFill, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
task.wait(1.5)
StatusLabel.Text = "> INJECTING AIMBOT ENGINE..."
TweenService:Create(BarFill, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0.75, 0, 1, 0)}):Play()
task.wait(2)
StatusLabel.Text = "> FINALIZING..."
TweenService:Create(BarFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(1)

Title.Text = "⚡  ARSENAL  HUB  READY  ⚡"
StatusLabel.Text = "> Press [Right Shift] to toggle menu"
task.wait(1)

-- Fade out loading elements
TweenService:Create(BarBg,     TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(BarStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
TweenService:Create(BarFill,   TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
task.wait(0.5)
BarBg:Destroy()

------------------------------------------------
-- TAB BAR  (Home | Hacks)
------------------------------------------------
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.Size = UDim2.new(1, 0, 0, 36)

local function makeTab(label, xScale)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 1, 0)
    btn.Position = UDim2.new(xScale, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 0, 45)
    btn.BackgroundTransparency = 0.3
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(220, 80, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = TabBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(180, 0, 255)
    s.Thickness = 1.5
    s.Parent = btn

    return btn
end

local HomeTab  = makeTab("🏠 HOME",  0.01)
local HacksTab = makeTab("⚡ HACKS", 0.51)

------------------------------------------------
-- HOME PAGE PANEL
------------------------------------------------
local HomePanel = Instance.new("Frame")
HomePanel.Name = "HomePanel"
HomePanel.Parent = MainFrame
HomePanel.BackgroundTransparency = 1
HomePanel.Position = UDim2.new(0, 0, 0, 92)
HomePanel.Size = UDim2.new(1, 0, 1, -92)

-- Profile card
local ProfileCard = Instance.new("Frame")
ProfileCard.Parent = HomePanel
ProfileCard.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
ProfileCard.BackgroundTransparency = 0.1
ProfileCard.BorderSizePixel = 0
ProfileCard.Position = UDim2.new(0.04, 0, 0.04, 0)
ProfileCard.Size = UDim2.new(0.92, 0, 0.92, 0)

local PC = Instance.new("UICorner")
PC.CornerRadius = UDim.new(0, 10)
PC.Parent = ProfileCard

local PS = Instance.new("UIStroke")
PS.Color = Color3.fromRGB(200, 0, 255)
PS.Thickness = 1.5
PS.Parent = ProfileCard

-- Neon gold player name
local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Parent = ProfileCard
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Position = UDim2.new(0, 10, 0, 10)
PlayerNameLabel.Size = UDim2.new(1, -20, 0, 32)
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.Text = "⭐ " .. LocalPlayer.Name .. " ⭐"
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)   -- neon gold
PlayerNameLabel.TextSize = 22
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Center

local NameGlow = Instance.new("UIStroke")
NameGlow.Color = Color3.fromRGB(255, 180, 0)
NameGlow.Thickness = 2
NameGlow.Parent = PlayerNameLabel

-- Display name line
local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Parent = ProfileCard
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Position = UDim2.new(0, 10, 0, 44)
DisplayNameLabel.Size = UDim2.new(1, -20, 0, 20)
DisplayNameLabel.Font = Enum.Font.Gotham
DisplayNameLabel.Text = "@" .. LocalPlayer.Name
DisplayNameLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
DisplayNameLabel.TextSize = 13
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Divider line
local Divider = Instance.new("Frame")
Divider.Parent = ProfileCard
Divider.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0.05, 0, 0, 70)
Divider.Size = UDim2.new(0.9, 0, 0, 1)

-- Stats section
local function makeStatRow(labelText, yOff)
    local row = Instance.new("Frame")
    row.Parent = ProfileCard
    row.BackgroundTransparency = 1
    row.Position = UDim2.new(0.05, 0, 0, yOff)
    row.Size = UDim2.new(0.9, 0, 0, 22)

    local key = Instance.new("TextLabel")
    key.Parent = row
    key.BackgroundTransparency = 1
    key.Position = UDim2.new(0, 0, 0, 0)
    key.Size = UDim2.new(0.55, 0, 1, 0)
    key.Font = Enum.Font.Gotham
    key.Text = labelText
    key.TextColor3 = Color3.fromRGB(180, 100, 255)
    key.TextSize = 13
    key.TextXAlignment = Enum.TextXAlignment.Left

    local val = Instance.new("TextLabel")
    val.Name = "Value"
    val.Parent = row
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(0.55, 0, 0, 0)
    val.Size = UDim2.new(0.45, 0, 1, 0)
    val.Font = Enum.Font.GothamBold
    val.Text = "..."
    val.TextColor3 = Color3.fromRGB(255, 215, 0)  -- neon gold values
    val.TextSize = 13
    val.TextXAlignment = Enum.TextXAlignment.Right

    return val
end

local valHealth  = makeStatRow("❤  Health",    80)
local valTeam    = makeStatRow("🏴  Team",     106)
local valKills   = makeStatRow("💀  Kills",    132)
local valDeaths  = makeStatRow("🪦  Deaths",   158)

-- Refresh stat values every second
coroutine.resume(coroutine.create(function()
    while task.wait(1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChild("Humanoid")
            valHealth.Text = hum and math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth) or "N/A"
            valTeam.Text   = tostring(LocalPlayer.Team and LocalPlayer.Team.Name or "None")

            -- Try to grab leaderstat kills/deaths
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            if ls then
                local k = ls:FindFirstChild("Kills") or ls:FindFirstChild("KOs")
                local d = ls:FindFirstChild("Deaths") or ls:FindFirstChild("WOs") or ls:FindFirstChild("Falls")
                valKills.Text  = k and tostring(k.Value) or "N/A"
                valDeaths.Text = d and tostring(d.Value) or "N/A"
            else
                valKills.Text  = "N/A"
                valDeaths.Text = "N/A"
            end
        end)
    end
end))

-- Credits footer
local CreditsHome = Instance.new("TextLabel")
CreditsHome.Parent = ProfileCard
CreditsHome.BackgroundTransparency = 1
CreditsHome.Position = UDim2.new(0, 0, 1, -22)
CreditsHome.Size = UDim2.new(1, 0, 0, 18)
CreditsHome.Font = Enum.Font.Gotham
CreditsHome.Text = "Credits: _dooliee  |  Chy Sopheakpanha  |  ជី.សុភ:បញ្ញា"
CreditsHome.TextColor3 = Color3.fromRGB(150, 0, 200)
CreditsHome.TextSize = 11
CreditsHome.TextXAlignment = Enum.TextXAlignment.Center

------------------------------------------------
-- HACKS PANEL
------------------------------------------------
local HacksPanel = Instance.new("Frame")
HacksPanel.Name = "HacksPanel"
HacksPanel.Parent = MainFrame
HacksPanel.BackgroundTransparency = 1
HacksPanel.Position = UDim2.new(0, 0, 0, 92)
HacksPanel.Size = UDim2.new(1, 0, 1, -92)
HacksPanel.Visible = false  -- start hidden; Home is default

------------------------------------------------
-- TAB SWITCHING
------------------------------------------------
HomeTab.MouseButton1Click:Connect(function()
    HomePanel.Visible  = true
    HacksPanel.Visible = false
    HomeTab.BackgroundTransparency  = 0.1
    HacksTab.BackgroundTransparency = 0.5
end)

HacksTab.MouseButton1Click:Connect(function()
    HacksPanel.Visible = true
    HomePanel.Visible  = false
    HacksTab.BackgroundTransparency = 0.1
    HomeTab.BackgroundTransparency  = 0.5
end)

-- Default: Home visible
HomePanel.Visible  = true
HacksPanel.Visible = false

------------------------------------------------
-- HACK BUTTONS (inside HacksPanel)
------------------------------------------------
local function createPremiumButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 46)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(18, 0, 35)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 80, 120)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
    btn.BackgroundTransparency = 0.15
    btn.Parent = HacksPanel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 80, 120)
    btnStroke.Thickness = 2
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn

    return btn, btnStroke
end

local SilentBtn,    SilentStroke    = createPremiumButton("Hitbox Expander", 10)
local LegitBtn,     LegitStroke     = createPremiumButton("Legit Aimbot",    68)
local AutoShootBtn, AutoShootStroke = createPremiumButton("Auto Shoot",      126)

-- Hacks panel credits footer
local HacksCredits = Instance.new("TextLabel")
HacksCredits.Parent = HacksPanel
HacksCredits.BackgroundTransparency = 1
HacksCredits.Position = UDim2.new(0, 0, 1, -22)
HacksCredits.Size = UDim2.new(1, 0, 0, 18)
HacksCredits.Font = Enum.Font.Gotham
HacksCredits.Text = "Credits: _dooliee  |  Chy Sopheakpanha  |  ជី.សុភ:បញ្ញា"
HacksCredits.TextColor3 = Color3.fromRGB(150, 0, 200)
HacksCredits.TextSize = 11
HacksCredits.TextXAlignment = Enum.TextXAlignment.Center

------------------------------------------------
-- BUTTON TOGGLE VISUALS
------------------------------------------------
local function toggleVisuals(enabled, button, stroke, baseName, yPos)
    if enabled then
        button.TextColor3 = Color3.fromRGB(80, 255, 120)
        button.Text = baseName .. ": ON"
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(80, 255, 120)}):Play()
    else
        button.TextColor3 = Color3.fromRGB(255, 80, 120)
        button.Text = baseName .. ": OFF"
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 80, 120)}):Play()
    end
    TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0.76, 0, 0, 42), Position = UDim2.new(0.12, 0, 0, yPos+2)}):Play()
    task.wait(0.1)
    TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Bounce), {Size = UDim2.new(0.8, 0, 0, 46), Position = UDim2.new(0.1, 0, 0, yPos)}):Play()
end

SilentBtn.MouseButton1Click:Connect(function()
    _G.SilentAimEnabled = not _G.SilentAimEnabled
    toggleVisuals(_G.SilentAimEnabled, SilentBtn, SilentStroke, "Hitbox Expander", 10)
    if not _G.SilentAimEnabled then
        pcall(function()
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character then
                    local function resetPart(name, size)
                        local p = v.Character:FindFirstChild(name)
                        if p then
                            p.Size = size
                            p.Transparency = 0
                            p.CanCollide = true
                        end
                    end
                    resetPart("RightUpperLeg", Vector3.new(1, 2, 1))
                    resetPart("LeftUpperLeg", Vector3.new(1, 2, 1))
                    resetPart("HeadHB", Vector3.new(2, 1, 1))
                    resetPart("HumanoidRootPart", Vector3.new(2, 2, 1))
                end
            end
        end)
    end
end)

LegitBtn.MouseButton1Click:Connect(function()
    _G.LegitAimbot = not _G.LegitAimbot
    toggleVisuals(_G.LegitAimbot, LegitBtn, LegitStroke, "Legit Aimbot", 68)
end)

AutoShootBtn.MouseButton1Click:Connect(function()
    _G.AutoShoot = not _G.AutoShoot
    toggleVisuals(_G.AutoShoot, AutoShootBtn, AutoShootStroke, "Auto Shoot", 126)
end)

-- Hide / Show Menu via Right Shift
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

------------------------------------------------
-- HACK LOOPS
------------------------------------------------

-- ① Hitbox Expander
coroutine.resume(coroutine.create(function()
	while task.wait(1) do
		if _G.SilentAimEnabled then
			pcall(function()
				for _,v in pairs(Players:GetPlayers()) do
					if v.Name ~= LocalPlayer.Name and v.Character then
						if v.Character:FindFirstChild("RightUpperLeg") then
							v.Character.RightUpperLeg.CanCollide = false
							v.Character.RightUpperLeg.Transparency = 1
							v.Character.RightUpperLeg.Size = Vector3.new(13, 13, 13)
						end
						if v.Character:FindFirstChild("LeftUpperLeg") then
							v.Character.LeftUpperLeg.CanCollide = false
							v.Character.LeftUpperLeg.Transparency = 1
							v.Character.LeftUpperLeg.Size = Vector3.new(13, 13, 13)
						end
						if v.Character:FindFirstChild("HeadHB") then
							v.Character.HeadHB.CanCollide = false
							v.Character.HeadHB.Transparency = 1
							v.Character.HeadHB.Size = Vector3.new(13, 13, 13)
						end
						if v.Character:FindFirstChild("HumanoidRootPart") then
							v.Character.HumanoidRootPart.CanCollide = false
							v.Character.HumanoidRootPart.Transparency = 1
							v.Character.HumanoidRootPart.Size = Vector3.new(13, 13, 13)
						end
					end
				end
			end)
		end
	end
end))

-- ② Smooth Legit Aimbot + Auto Shoot core
local Camera = workspace.CurrentCamera

-- ── Wall check ──
local function isVisible(targetPart)
    local rayOrigin    = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin)
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    return workspace:Raycast(rayOrigin, rayDirection, rp) == nil
end

-- ── Closest enemy finder ──
local function getClosestEnemy()
    local center  = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local maxDist = 150
    local target  = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
           and player.Character
           and player.Character:FindFirstChild("Head")
           and player.Character:FindFirstChild("Humanoid")
           and player.Character.Humanoid.Health > 0
        then
            if player.Team ~= LocalPlayer.Team then
                local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local dist = (center - Vector2.new(headPos.X, headPos.Y)).Magnitude
                    if dist < maxDist and isVisible(player.Character.Head) then
                        maxDist = dist
                        target  = player.Character.Head
                    end
                end
            end
        end
    end
    return target, maxDist  -- also return distance so AutoShoot can use it
end

------------------------------------------------
-- 213ms reaction-time variables
------------------------------------------------
-- "Alpha" controls how smoothly the aimbot blends toward the target each frame.
-- We simulate a ~213 ms reaction by starting the aim slowly then accelerating.
local REACTION_TIME  = 0.210   -- seconds of initial "human lag"
local BASE_LERP      = 0.06    -- very gentle initial curve
local PEAK_LERP      = 0.18    -- max speed after reaction delay has passed
local aimbotTimer    = 0       -- time since last target acquisition
local lastTarget     = nil

-- Tiny FOV for auto-shoot: if crosshair is THIS close to enemy head center
local AUTOSHOOT_FOV  = 40      -- pixels from screen center
local autoShootTimer = 0       -- anti-spam timer for auto-fire

RunService.RenderStepped:Connect(function(dt)
    ----------------------------------------------------
    -- Smooth Legit Aimbot with 213ms reaction lag
    ----------------------------------------------------
    if _G.LegitAimbot then
        local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                      or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL2)

        if isAiming then
            local targetHead, dist = getClosestEnemy()
            if targetHead then
                -- Reset timer when swapping targets (human-like re-flick)
                if targetHead ~= lastTarget then
                    aimbotTimer = 0
                    lastTarget  = targetHead
                end

                aimbotTimer = aimbotTimer + dt

                -- Lerp alpha ramps up after reaction time has elapsed
                local progress = math.clamp(aimbotTimer / REACTION_TIME, 0, 1)
                local alpha    = BASE_LERP + (PEAK_LERP - BASE_LERP) * (progress * progress)

                local goal = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
            else
                lastTarget  = nil
                aimbotTimer = 0
            end
        else
            lastTarget  = nil
            aimbotTimer = 0
        end
    end

    ----------------------------------------------------
    -- Auto Shoot  (fires when crosshair overlaps enemy)
    ----------------------------------------------------
    if _G.AutoShoot then
        autoShootTimer = autoShootTimer - dt
        if autoShootTimer <= 0 then
            local targetHead, dist = getClosestEnemy()
            if targetHead and dist < AUTOSHOOT_FOV then
                -- Simulate LMB click to fire the weapon
                pcall(function()
                    local VIM = game:GetService("VirtualInputManager")
                    VIM:SendMouseButtonEvent(0, 0, 1, true,  game, 0) -- Fire
                    task.wait(0.015) -- Tiny click duration
                    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0) -- Release
                end)
                autoShootTimer = 0.03 -- Very fast firing delay
            end
        end
    end
end)

------------------------------------------------
-- Startup Notification
------------------------------------------------
pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "⚡ Arsenal Hub v2.0",
		Text  = "Cyberpunk Edition loaded! [Right Shift] to open.",
		Duration = 8
	})
end)
