-- JINOXX DEV - Delta Optimized (Password: JINOXX DEV)
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = cloneref and cloneref(game:GetService("VirtualInputManager")) or game:GetService("VirtualInputManager")

-- ------------------- PASSWORD CHECK -------------------
local PASSWORD = "JINOXX DEV"

local passGui = Instance.new("ScreenGui")
passGui.Name = "JinoXX_Password"
passGui.Parent = player.PlayerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BackgroundTransparency = 0.7
bg.Parent = passGui

local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 380, 0, 260)
passFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
passFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
passFrame.BorderSizePixel = 0
passFrame.Parent = passGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = passFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "JINoxX"
title.TextColor3 = Color3.fromRGB(128, 0, 255)
title.TextSize = 42
title.Font = Enum.Font.GothamBold
title.Parent = passFrame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 25)
sub.Position = UDim2.new(0, 0, 0, 85)
sub.BackgroundTransparency = 1
sub.Text = "ENTER PASSWORD"
sub.TextColor3 = Color3.fromRGB(200, 200, 200)
sub.TextSize = 12
sub.Parent = passFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.8, 0, 0, 45)
passBox.Position = UDim2.new(0.1, 0, 0, 130)
passBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
passBox.BorderSizePixel = 0
passBox.PlaceholderText = "password"
passBox.Text = ""
passBox.TextColor3 = Color3.new(1, 1, 1)
passBox.Font = Enum.Font.Gotham
passBox.Parent = passFrame

local passCorner = Instance.new("UICorner")
passCorner.CornerRadius = UDim.new(0, 12)
passCorner.Parent = passBox

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(0.5, 0, 0, 45)
verify.Position = UDim2.new(0.25, 0, 0, 195)
verify.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
verify.Text = "VERIFY"
verify.TextColor3 = Color3.new(1, 1, 1)
verify.TextSize = 14
verify.Font = Enum.Font.GothamBold
verify.BorderSizePixel = 0
verify.Parent = passFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 25)
verifyCorner.Parent = verify

local errLabel = Instance.new("TextLabel")
errLabel.Size = UDim2.new(0.8, 0, 0, 30)
errLabel.Position = UDim2.new(0.1, 0, 0, 245)
errLabel.BackgroundTransparency = 1
errLabel.Text = ""
errLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
errLabel.TextSize = 11
errLabel.Visible = false
errLabel.Parent = passFrame

local function onVerify()
    if passBox.Text == PASSWORD then
        passGui:Destroy()
        CreateMainHub()
    else
        errLabel.Text = "❌ Wrong password!"
        errLabel.Visible = true
        task.wait(1.5)
        errLabel.Visible = false
        passBox.Text = ""
    end
end
verify.MouseButton1Click:Connect(onVerify)
passBox.FocusLost:Connect(function(ep) if ep then onVerify() end end)

-- ------------------- MAIN HUB (HORIZONTAL) -------------------
function CreateMainHub()
    local aimbot = false
    local esp = false
    local autoATM = false
    local fly = false
    local noclip = false
    local infJump = false
    local fullbright = false
    local aimConn = nil
    local farmConn = nil
    local flyConn = nil
    local noclipConn = nil
    local jumpConn = nil
    local bodyVel = nil
    local espObjs = {}
    local origLight = {Brightness = Lighting.Brightness, Ambient = Lighting.Ambient, Outdoor = Lighting.OutdoorAmbient}

    local function getClosest()
        local pl = player.Character
        if not pl or not pl:FindFirstChild("HumanoidRootPart") then
            return
        end
        local root = pl.HumanoidRootPart
        local closest, dist = nil, 150
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local d = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
        return closest
    end

    local function startAimbot()
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(function()
            if not aimbot then return end
            local target = getClosest()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local cam = Workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
                end
            end
        end)
    end

    local function stopAimbot()
        if aimConn then aimConn:Disconnect(); aimConn = nil end
    end

    local function updateESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if esp and plr ~= player and plr.Character then
                if not espObjs[plr] then
                    local char = plr.Character
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.5
                    hl.Adornee = char
                    hl.Parent = char
                    local bill = Instance.new("BillboardGui")
                    bill.Size = UDim2.new(0, 200, 0, 40)
                    bill.StudsOffset = Vector3.new(0, -3, 0)
                    bill.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                    bill.AlwaysOnTop = true
                    bill.Parent = char
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.new(0, 0, 0)
                    frame.BackgroundTransparency = 0.4
                    frame.Parent = bill
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = plr.Name
                    lbl.TextColor3 = Color3.new(1, 1, 1)
                    lbl.TextSize = 11
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.Parent = frame
                    espObjs[plr] = {Highlight = hl, Billboard = bill}
                end
            elseif espObjs[plr] then
                espObjs[plr].Highlight:Destroy()
                espObjs[plr].Billboard:Destroy()
                espObjs[plr] = nil
            end
        end
    end

    local function startFarm()
        if farmConn then farmConn:Disconnect() end
        farmConn = RunService.Heartbeat:Connect(function()
            if not autoATM then return end
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart
            for _, obj in pairs(Workspace:GetDescendants()) do
                if not autoATM then break end
                if obj:IsA("Model") and (obj.Name:lower():find("atm") or obj.Name:lower():find("cash")) then
                    local part = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    if part then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist < 10 then
                            VirtualInputManager:SendKeyEvent(true, "E", false, game)
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(false, "E", false, game)
                            task.wait(1)
                        elseif dist < 30 then
                            local dir = (part.Position - root.Position).unit
                            root.CFrame = root.CFrame + dir * 8
                        end
                    end
                end
            end
        end)
    end

    local function stopFarm()
        if farmConn then farmConn:Disconnect(); farmConn = nil end
    end

    local function enableFly()
        if flyConn then flyConn:Disconnect() end
        fly = true
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e4, 1e4, 1e4)
        bodyVel.Parent = root
        flyConn = RunService.Heartbeat:Connect(function()
            if not fly or not bodyVel or not player.Character then
                if flyConn then flyConn:Disconnect() end
                return
            end
            local move = player.Character.Humanoid.MoveDirection
            local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50) or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50) or 0
            bodyVel.Velocity = Vector3.new(move.X * 80, up, move.Z * 80)
        end)
    end

    local function disableFly()
        fly = false
        if bodyVel then bodyVel:Destroy(); bodyVel = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
    end

    local function enableNoclip()
        if noclipConn then noclipConn:Disconnect() end
        noclip = true
        noclipConn = RunService.Stepped:Connect(function()
            if noclip and player.Character then
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end

    local function disableNoclip()
        noclip = false
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if player.Character then
            for _, p in pairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end

    local function enableInfJump()
        if jumpConn then jumpConn:Disconnect() end
        infJump = true
        jumpConn = UserInputService.JumpRequested:Connect(function()
            if infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end

    local function disableInfJump()
        infJump = false
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
    end

    local function enableFullbright()
        if fullbright then return end
        origLight.Brightness = Lighting.Brightness
        origLight.Ambient = Lighting.Ambient
        origLight.Outdoor = Lighting.OutdoorAmbient
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogEnd = 100000
        fullbright = true
    end

    local function disableFullbright()
        if not fullbright then return end
        Lighting.Brightness = origLight.Brightness
        Lighting.Ambient = origLight.Ambient
        Lighting.OutdoorAmbient = origLight.Outdoor
        Lighting.FogEnd = 1000
        fullbright = false
    end

    -- ------------------- GUI (HORIZONTAL) -------------------
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 400)
    main.Position = UDim2.new(0.5, -210, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = hubGui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = main

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "JINOXX DEV | BLOCK SPIN HUB"
    titleLbl.TextColor3 = Color3.new(1, 1, 1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -42, 0, 2.5)
    close.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.TextScaled = true
    close.BorderSizePixel = 0
    close.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close
    close.MouseButton1Click:Connect(function() hubGui:Destroy() end)

    local tabs = {"Aim", "ESP", "Farm", "Move", "Vis"}
    local tabBtns = {}
    local tabFrames = {}
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 84, 1, 0)
        btn.Position = UDim2.new(0, (i - 1) * 84, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = tabBar

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -90)
        content.Position = UDim2.new(0, 10, 0, 80)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.CanvasSize = UDim2.new(0, 0, 0, 350)
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
        content.Visible = (name == "Aim")
        content.Parent = main

        tabBtns[name] = btn
        tabFrames[name] = content
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabFrames) do v.Visible = false end
            for _, v in pairs(tabBtns) do v.BackgroundColor3 = Color3.fromRGB(25, 25, 35); v.TextColor3 = Color3.fromRGB(200, 200, 200) end
            content.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
            btn.TextColor3 = Color3.new(1, 1, 1)
        end)
    end
    tabBtns["Aim"].BackgroundColor3 = Color3.fromRGB(128, 0, 255)

    local function addToggle(parent, text, y, off, on)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 38)
        f.Position = UDim2.new(0, 0, 0, y)
        f.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        f.BorderSizePixel = 0
        f.Parent = parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = f
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = f
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 28)
        btn.Position = UDim2.new(1, -70, 0.5, -14)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        btn.Text = "OFF"
        btn.TextSize = 11
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = f
        local btnc = Instance.new("UICorner")
        btnc.CornerRadius = UDim.new(0, 6)
        btnc.Parent = btn
        local toggled = false
        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            btn.BackgroundColor3 = toggled and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 50, 65)
            btn.Text = toggled and "ON" or "OFF"
            if toggled then on() else off() end
        end)
    end

    addToggle(tabFrames["Aim"], "Aimbot", 5, stopAimbot, function() aimbot = true; startAimbot() end)
    addToggle(tabFrames["ESP"], "ESP Players", 5, function() esp = false; updateESP() end, function() esp = true; updateESP() end)
    addToggle(tabFrames["Farm"], "Auto ATM", 5, stopFarm, function() autoATM = true; startFarm() end)
    addToggle(tabFrames["Move"], "Fly", 5, disableFly, enableFly)
    addToggle(tabFrames["Move"], "Noclip", 48, disableNoclip, enableNoclip)
    addToggle(tabFrames["Move"], "Inf Jump", 91, disableInfJump, enableInfJump)
    addToggle(tabFrames["Vis"], "Fullbright", 5, disableFullbright, enableFullbright)

    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, -20, 0, 50)
    speedFrame.Position = UDim2.new(0, 0, 0, 150)
    speedFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    speedFrame.Parent = tabFrames["Move"]
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(0.6, 0, 0.4, 0)
    speedLbl.Position = UDim2.new(0, 10, 0, 5)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Walk Speed: 16"
    speedLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLbl.TextSize = 13
    speedLbl.Font = Enum.Font.Gotham
    speedLbl.TextXAlignment = Enum.TextXAlignment.Left
    speedLbl.Parent = speedFrame
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.25, 0, 0.5, 0)
    speedBox.Position = UDim2.new(0.73, 0, 0.25, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    speedBox.Text = "16"
    speedBox.TextColor3 = Color3.new(1, 1, 1)
    speedBox.TextSize = 13
    speedBox.Font = Enum.Font.Gotham
    speedBox.BorderSizePixel = 0
    speedBox.Parent = speedFrame
    local speedBoxCorner = Instance.new("UICorner")
    speedBoxCorner.CornerRadius = UDim.new(0, 6)
    speedBoxCorner.Parent = speedBox
    speedBox.FocusLost:Connect(function()
        local val = tonumber(speedBox.Text) or 16
        val = math.clamp(val, 16, 250)
        speedBox.Text = val
        speedLbl.Text = "Walk Speed: " .. val
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = val
        end
    end)

    local drag, dragStart, startPos = false
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Hub Loaded Successfully!",
        Duration = 3
    })
    print("JINOXX DEV HUB ACTIVATED - HORIZONTAL GUI")
end
