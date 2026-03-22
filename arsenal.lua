local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getplrsname()
	for i,v in pairs(game:GetChildren()) do
		if v.ClassName == "Players" then return v.Name end
	end
end
local playersService = getplrsname() or "Players"

local targetGui
pcall(function() targetGui = CoreGui end)
if not targetGui then targetGui = LocalPlayer:WaitForChild("PlayerGui") end

if targetGui:FindFirstChild("SilentAimHub") then
	targetGui.SilentAimHub:Destroy()
end

-- Removed Full-Screen Blur permanently. We will rely purely on a transparent frosted glass background for the menu so your game stays crystal clear.
if Lighting:FindFirstChild("CinematicBlur") then
	Lighting.CinematicBlur:Destroy()
end

-- Premium UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentAimHub"
ScreenGui.Parent = targetGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

------------------------------------------------
-- MAIN MENU (Fancy Dark Gradient Window)
------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 260) -- Shrunk slightly to fit two buttons perfectly
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true

-- Metallic Dark Gradient Background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

-- Floating Drop Shadow Engine
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
DropShadow.Size = UDim2.new(1, 40, 1, 40)
DropShadow.BackgroundTransparency = 1
DropShadow.Image = "" 
DropShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ZIndex = -1
DropShadow.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Glowing Gold Sheen Border
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 255, 255) 
MainStroke.Thickness = 2.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Transparency = 1

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
}
StrokeGradient.Rotation = -45
StrokeGradient.Parent = MainStroke

-- Supremely Smooth Dragging Logic
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
-- LOADING SCREEN ELEMENTS
------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Loading Arsenal Hub..."
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 22
Title.TextTransparency = 1

local Credits = Instance.new("TextLabel")
Credits.Parent = MainFrame
Credits.BackgroundTransparency = 1
Credits.Position = UDim2.new(0, 0, 0, 48)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Font = Enum.Font.Gotham
Credits.Text = "Premium Edition | Credit: _dooliee"
Credits.TextColor3 = Color3.fromRGB(220, 220, 220)
Credits.TextSize = 13
Credits.TextTransparency = 1

local BarBg = Instance.new("Frame")
BarBg.Parent = MainFrame
BarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBg.BackgroundTransparency = 1
BarBg.BorderSizePixel = 0
BarBg.Position = UDim2.new(0.1, 0, 0.75, 0)
BarBg.Size = UDim2.new(0.8, 0, 0, 8)

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Parent = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BackgroundTransparency = 1
BarFill.BorderSizePixel = 0
BarFill.Size = UDim2.new(0, 0, 1, 0)

local BarFillGradient = Instance.new("UIGradient")
BarFillGradient.Color = StrokeGradient.Color
BarFillGradient.Parent = BarFill

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

-- Animations!
local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- Fade In Screen! 
-- MainFrame transparent at 0.15 makes a glassy dark window WITHOUT blurring the game worldview whatsoever!
TweenService:Create(MainFrame, fadeInfo, {BackgroundTransparency = 0.15}):Play()
TweenService:Create(MainStroke, fadeInfo, {Transparency = 0}):Play()
TweenService:Create(Title, fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(Credits, fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(BarBg, fadeInfo, {BackgroundTransparency = 0.5}):Play()
TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 0}):Play()

task.wait(1)

-- Loading Bar Animation
TweenService:Create(BarFill, TweenInfo.new(4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(4.5)

Title.Text = "Press [Right Shift] to toggle menu!"
task.wait(0.8)

-- Destroy Bar
TweenService:Create(BarBg, fadeInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
task.wait(0.5)
BarBg:Destroy()

------------------------------------------------
-- HACK BUTTONS
------------------------------------------------
_G.SilentAimEnabled = false
_G.LegitAimbot = false

local function createPremiumButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100) 
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundTransparency = 1
    btn.TextTransparency = 1
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 100, 100)
    btnStroke.Thickness = 2.5
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Transparency = 1
    btnStroke.Parent = btn

    TweenService:Create(btn, fadeInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(btnStroke, fadeInfo, {Transparency = 0}):Play()
    
    return btn, btnStroke
end

local SilentBtn, SilentStroke = createPremiumButton("Hitbox Expander", 85)
local LegitBtn, LegitStroke = createPremiumButton("Legit Aimbot", 155)


-- Setup visual bounces for buttons
local function toggleVisuals(enabled, button, stroke, baseName, yPos)
    if enabled then
        button.TextColor3 = Color3.fromRGB(100, 255, 100) 
        button.Text = baseName .. ": ON"
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 255, 100)}):Play()
    else
        button.TextColor3 = Color3.fromRGB(255, 100, 100)
        button.Text = baseName .. ": OFF"
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 100, 100)}):Play()
    end

    TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0.75, 0, 0, 45), Position = UDim2.new(0.125, 0, 0, yPos+2)}):Play()
    task.wait(0.1)
    TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Bounce), {Size = UDim2.new(0.8, 0, 0, 50), Position = UDim2.new(0.1, 0, 0, yPos)}):Play()
end

SilentBtn.MouseButton1Click:Connect(function()
    _G.SilentAimEnabled = not _G.SilentAimEnabled
    toggleVisuals(_G.SilentAimEnabled, SilentBtn, SilentStroke, "Hitbox Expander", 85)
    
    if not _G.SilentAimEnabled then
        pcall(function()
            for _,v in pairs(game[playersService]:GetPlayers()) do
                if v.Name ~= LocalPlayer.Name and v.Character then
                    if v.Character:FindFirstChild("RightUpperLeg") then v.Character.RightUpperLeg.Size = Vector3.new(1, 2, 1) end
                    if v.Character:FindFirstChild("LeftUpperLeg") then v.Character.LeftUpperLeg.Size = Vector3.new(1, 2, 1) end
                    if v.Character:FindFirstChild("HeadHB") then v.Character.HeadHB.Size = Vector3.new(2, 1, 1) end
                    if v.Character:FindFirstChild("HumanoidRootPart") then v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) end
                end
            end
        end)
    end
end)

LegitBtn.MouseButton1Click:Connect(function()
    _G.LegitAimbot = not _G.LegitAimbot
    toggleVisuals(_G.LegitAimbot, LegitBtn, LegitStroke, "Legit Aimbot", 155)
end)

-- Hide / Show Menu Logic via Right Shift
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

------------------------------------------------
-- HACK LOOPS
------------------------------------------------

-- Hitbox Expander (Loop 1) (Quota Hub Original)
coroutine.resume(coroutine.create(function()
	while task.wait(1) do
		if _G.SilentAimEnabled then
			pcall(function()
				for _,v in pairs(game[playersService]:GetPlayers()) do
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

-- Legit Smooth Aimbot (Loop 2)
local Camera = workspace.CurrentCamera

-- Wall Check (Raycasting to ensure clear line of sight)
local function isVisible(targetPart)
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin)
    local raycastParams = RaycastParams.new()
    -- Ignore our own character and the target's character to prevent false blocking
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    -- If it hits nothing, the path is crystal clear!
    return raycastResult == nil
end

local function getClosestEnemy()
    -- Use the screen's center point instead of the mouse to support Controller aiming!
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local maxDist = 150 -- Tight FOV: Only aims when the crosshair is very close to them
    local target = nil

    for _, player in pairs(game[playersService]:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if player.Team ~= LocalPlayer.Team then
                local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    -- Calculate distance from Screen Center to Player's Head
                    local dist = (center - Vector2.new(headPos.X, headPos.Y)).Magnitude
                    if dist < maxDist then
                        -- Check if they are hiding behind a wall
                        if isVisible(player.Character.Head) then
                            maxDist = dist
                            target = player.Character.Head
                        end
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- 2. Smooth Legit Aimbot Logic
    if _G.LegitAimbot then
        -- Supports PC Right-Click and Controller Left Trigger (L2)
        local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or 
                         UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL2)

        if isAiming then
            local targetHead = getClosestEnemy()
            if targetHead then
                local goal = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                -- 0.12 Lerp provides incredibly human-like drag speed. Aim-viewers will think you are just really good.
                Camera.CFrame = Camera.CFrame:Lerp(goal, 0.12)
            end
        end
    end
end)

-- Startup Notification
pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Arsenal Hub Updated",
		Text = "Press [Right Shift] to toggle. Menu is draggable!",
		Duration = 8
	})
end)
