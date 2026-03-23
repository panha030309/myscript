--[[
    ⚡ QUOTAS HUB - ARSENAL EDITION ⚡
    Improved & Fixed v2.0
    Contributors: _dooliee | Chy Sopheakpanha | ជី.សុភ:បញ្ញា
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Global Configuration
_G.QuotasConfig = {
    Aimbot = false,
    AimbotPart = "Head",
    Sensitivity = 0.05,
    FovRadius = 150,
    FovVisible = true,
    FovColor = Color3.fromRGB(255, 255, 255),
    TeamCheck = true,
    EspEnabled = false,
    InfJump = false,
    WalkSpeed = 16,
    FlySpeed = 50,
    Flying = false,
    Noclip = false,
    SilentAim = false,
    NoRecoil = false,
    InfAmmo = false,
    FireRate = false
}

-- Utility Functions
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- UI Creation
local Main = Instance.new("ScreenGui")
Main.Name = "QuotasHub"
Main.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
Main.ResetOnSpawn = false

-- Loading Screen
local Loader = Instance.new("Frame")
Loader.Name = "Loader"
Loader.Size = UDim2.new(0, 0, 0, 80)
Loader.Position = UDim2.new(0.5, 0, 0.5, 0)
Loader.AnchorPoint = Vector2.new(0.5, 0.5)
Loader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Loader.BackgroundTransparency = 0.1
Loader.Parent = Main

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 10)
LoaderCorner.Parent = Loader

local LoaderStroke = Instance.new("UIStroke")
LoaderStroke.Color = Color3.fromRGB(80, 80, 255)
LoaderStroke.Thickness = 2
LoaderStroke.Parent = Loader

local LoaderTitle = Instance.new("TextLabel")
LoaderTitle.Size = UDim2.new(1, 0, 0.6, 0)
LoaderTitle.BackgroundTransparency = 1
LoaderTitle.Text = "\"quotas hub\""
LoaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoaderTitle.Font = Enum.Font.JosefinSans
LoaderTitle.TextSize = 24
LoaderTitle.TextTransparency = 1
LoaderTitle.Parent = Loader

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBar.Position = UDim2.new(0.1, 0, 0.75, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ProgressBar.BorderSizePixel = 0
ProgressBar.BackgroundTransparency = 1
ProgressBar.Parent = Loader

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = ProgressFill

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = ProgressBar

-- Loader Animation
task.spawn(function()
    TweenService:Create(Loader, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 80)}):Play()
    task.wait(1)
    TweenService:Create(LoaderTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    ProgressBar.BackgroundTransparency = 0
    task.wait(0.5)
    TweenService:Create(ProgressFill, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.2)
    TweenService:Create(Loader, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoaderTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoaderStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    task.wait(0.5)
    Loader.Visible = false
end)

-- Main Menu
local Basic = Instance.new("Frame")
Basic.Name = "MainFrame"
Basic.Size = UDim2.new(0, 350, 0, 400)
Basic.Position = UDim2.new(0.5, -175, 0.5, -200)
Basic.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Basic.BackgroundTransparency = 0.2
Basic.Visible = false
Basic.Parent = Main
MakeDraggable(Basic)

local BasicCorner = Instance.new("UICorner")
BasicCorner.CornerRadius = UDim.new(0, 12)
BasicCorner.Parent = Basic

local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 35)
TitleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleFrame.BackgroundTransparency = 0.5
TitleFrame.Parent = Basic

local TFCorner = Instance.new("UICorner")
TFCorner.CornerRadius = UDim.new(0, 12)
TFCorner.Parent = TitleFrame

local QuotasName = Instance.new("TextLabel")
QuotasName.Size = UDim2.new(1, 0, 1, 0)
QuotasName.BackgroundTransparency = 1
QuotasName.Text = "\"Quotas Hub v2.0\""
QuotasName.TextColor3 = Color3.fromRGB(255, 255, 255)
QuotasName.Font = Enum.Font.JosefinSans
QuotasName.TextSize = 18
QuotasName.Parent = TitleFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TitleFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 2, 0)
Content.ScrollBarThickness = 2
Content.Parent = Basic

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Content

-- Toggle Helper
local function CreateToggle(name, description, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BackgroundTransparency = 0.3
    Frame.Parent = Content
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 0.6, 0)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.Parent = Frame

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(0.7, 0, 0.4, 0)
    Desc.Position = UDim2.new(0, 10, 0.6, -5)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 10
    Desc.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -70, 0.5, -12)
    ToggleBtn.BackgroundColor3 = _G.QuotasConfig[configKey] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 80, 80)
    ToggleBtn.Text = _G.QuotasConfig[configKey] and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = Frame
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 5)

    ToggleBtn.MouseButton1Click:Connect(function()
        _G.QuotasConfig[configKey] = not _G.QuotasConfig[configKey]
        ToggleBtn.Text = _G.QuotasConfig[configKey] and "ON" or "OFF"
        ToggleBtn.BackgroundColor3 = _G.QuotasConfig[configKey] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 80, 80)
        if callback then callback(_G.QuotasConfig[configKey]) end
    end)
end

-- Slider Helper
local function CreateSlider(name, min, max, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 55)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BackgroundTransparency = 0.3
    Frame.Parent = Content
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = name .. ": " .. _G.QuotasConfig[configKey]
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.Parent = Frame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -20, 0, 6)
    SliderBG.Position = UDim2.new(0, 10, 0, 35)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBG.Parent = Frame
    Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((_G.QuotasConfig[configKey] - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
    SliderFill.Parent = SliderBG
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        _G.QuotasConfig[configKey] = val
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Title.Text = name .. ": " .. val
        if callback then callback(val) end
    end

    local dragging = false
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    SliderBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
end

-- Initialize Controls
CreateToggle("Aimbot", "Smoothly aims at the closest player", "Aimbot")
CreateSlider("Aimbot Field-of-View", 10, 500, "FovRadius")
CreateToggle("Draw FOV", "Shows the aimbot target radius", "FovVisible")
CreateToggle("Team Check", "If enabled, aimbot ignores teammates", "TeamCheck")
CreateToggle("Player ESP", "Shows boxes and names on players", "EspEnabled")
CreateToggle("Hitbox Expander", "Makes enemy hitboxes larger (OP)", "SilentAim")
CreateToggle("Infinite Jump", "Allows jumping in mid-air", "InfJump")
CreateSlider("WalkSpeed", 16, 250, "WalkSpeed", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v
    end
end)
CreateToggle("Fly Mode", "Allows you to fly (WASD + Space/Ctrl)", "Flying")
CreateToggle("Noclip", "Walk through walls", "Noclip")
CreateToggle("No Recoil", "Removes weapon recoil & spread", "NoRecoil")
CreateToggle("Infinite Ammo", "Gives you 999 ammo", "InfAmmo")
CreateToggle("Rapid Fire", "Insane fire rate", "FireRate")

-- Menu Toggle Loop
task.wait(4)
Basic.Visible = true
local MenuToggled = true

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        MenuToggled = not MenuToggled
        Basic.Visible = MenuToggled
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main:Destroy()
end)

-- FEATURES IMPLEMENTATION

-- ESP Logic
local function CreateEsp(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 255, 255)
    Box.Thickness = 1
    Box.Filled = false

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 255, 255)
    Tracer.Thickness = 1

    local function Update()
        local c = RunService.RenderStepped:Connect(function()
            if _G.QuotasConfig.EspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player ~= LocalPlayer then
                if _G.QuotasConfig.TeamCheck and player.Team == LocalPlayer.Team then
                    Box.Visible = false
                    Name.Visible = false
                    Tracer.Visible = false
                    return
                end

                local Vector, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local Size = Vector3.new(2, 3, 0) * (Camera.ViewportSize.Y / (Vector.Z * 2 * math.tan(math.rad(Camera.FieldOfView / 2))))
                    Box.Size = Vector2.new(Size.X, Size.Y)
                    Box.Position = Vector2.new(Vector.X - Size.X / 2, Vector.Y - Size.Y / 2)
                    Box.Visible = true
                    Box.Color = player.TeamColor.Color

                    Name.Text = player.Name .. " [" .. math.floor(player.Character.Humanoid.Health) .. "]"
                    Name.Position = Vector2.new(Vector.X, Vector.Y - Size.Y / 2 - 15)
                    Name.Visible = true
                    Name.Color = Color3.fromRGB(255, 255, 255)

                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y + Size.Y / 2)
                    Tracer.Visible = true
                    Tracer.Color = player.TeamColor.Color
                else
                    Box.Visible = false
                    Name.Visible = false
                    Tracer.Visible = false
                end
            else
                Box.Visible = false
                Name.Visible = false
                Tracer.Visible = false
                if not player.Parent then
                    Box:Remove()
                    Name:Remove()
                    Tracer:Remove()
                end
            end
        end)
    end
    task.spawn(Update)
end

for _, v in pairs(Players:GetPlayers()) do CreateEsp(v) end
Players.PlayerAdded:Connect(CreateEsp)

-- Aimbot Logic
local FovCircle = Drawing.new("Circle")
FovCircle.Color = Color3.fromRGB(255, 255, 255)
FovCircle.Thickness = 1
FovCircle.NumSides = 64
FovCircle.Filled = false

local function GetClosest()
    local target = nil
    local dist = _G.QuotasConfig.FovRadius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(_G.QuotasConfig.AimbotPart) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if _G.QuotasConfig.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local pos, screen = Camera:WorldToViewportPoint(v.Character[_G.QuotasConfig.AimbotPart].Position)
            if screen then
                local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mDist < dist then
                    dist = mDist
                    target = v
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FovCircle.Visible = _G.QuotasConfig.FovVisible
    FovCircle.Radius = _G.QuotasConfig.FovRadius
    FovCircle.Position = UserInputService:GetMouseLocation()

    if _G.QuotasConfig.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosest()
        if target then
            local goal = CFrame.new(Camera.CFrame.Position, target.Character[_G.QuotasConfig.AimbotPart].Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, _G.QuotasConfig.Sensitivity)
        end
    end
end)

-- Hitbox Expander (Silent Aim)
task.spawn(function()
    while task.wait(0.5) do
        if _G.QuotasConfig.SilentAim then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character then
                    for _, part in pairs(v.Character:GetChildren()) do
                        if part:IsA("BasePart") and (part.Name:find("Leg") or part.Name:find("Arm") or part.Name == "Head" or part.Name == "HumanoidRootPart") then
                            part.Size = Vector3.new(10, 10, 10)
                            part.Transparency = 0.7
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

-- Weapon Mods Loop (ONE LOOP ONLY)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            if _G.QuotasConfig.NoRecoil or _G.QuotasConfig.FireRate then
                for _, v in pairs(rs:GetDescendants()) do
                    if _G.QuotasConfig.NoRecoil then
                        if v.Name == "RecoilControl" or v.Name == "MaxSpread" or v.Name == "MinSpread" then v.Value = 0 end
                    end
                    if _G.QuotasConfig.FireRate then
                        if v.Name == "FireRate" then v.Value = 0.02 end
                        if v.Name == "Auto" then v.Value = true end
                    end
                end
            end
            if _G.QuotasConfig.InfAmmo then
                local gui = LocalPlayer.PlayerGui:FindFirstChild("GUI")
                if gui and gui:FindFirstChild("Client") and gui.Client:FindFirstChild("Variables") then
                    if gui.Client.Variables:FindFirstChild("ammocount") then gui.Client.Variables.ammocount.Value = 999 end
                    if gui.Client.Variables:FindFirstChild("ammocount2") then gui.Client.Variables.ammocount2.Value = 999 end
                end
            end
        end)
    end
end)

-- Character Loops (Fly, Noclip, Speed, Jump)
local function OnChar(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if _G.QuotasConfig.WalkSpeed ~= 16 then hum.WalkSpeed = _G.QuotasConfig.WalkSpeed end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if _G.QuotasConfig.InfJump then hum:ChangeState("Jumping") end
    end)
end

if LocalPlayer.Character then OnChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(OnChar)

RunService.Stepped:Connect(function()
    if _G.QuotasConfig.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Flying Logic
local bv, bg
RunService.RenderStepped:Connect(function()
    if _G.QuotasConfig.Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if not bv then
            bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(1,1,1) * 10^6
            bg.MaxTorque = Vector3.new(1,1,1) * 10^6
        end
        bg.CFrame = Camera.CFrame
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        bv.Velocity = dir * _G.QuotasConfig.FlySpeed
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end)

print("⚡ Quotas Hub Loaded Successfully! ⚡")
