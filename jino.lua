-- JINOXX DEV - ULTIMATE SCRIPT (COMPACT HORIZONTAL ESP + MAGIC BULLET)
-- PASSWORD: JINOXX DEV

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = cloneref and cloneref(game:GetService("VirtualInputManager")) or game:GetService("VirtualInputManager")

-- ==================== PASSWORD CHECK ====================
local PASSWORD = "JINOXX DEV"
local passGui = Instance.new("ScreenGui")
passGui.Name = "JinoXX_Pass"
passGui.Parent = player.PlayerGui

local function createPasswordUI()
    local passFrame = Instance.new("Frame")
    passFrame.Size = UDim2.new(0, 350, 0, 240)
    passFrame.Position = UDim2.new(0.5, -175, 0.5, -120)
    passFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    passFrame.BackgroundTransparency = 0.05
    passFrame.BorderSizePixel = 0
    passFrame.Parent = passGui
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 16)
    frameCorner.Parent = passFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    title.Text = "JINoxX"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 30
    title.Font = Enum.Font.GothamBold
    title.Parent = passFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = title

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 50)
    sub.BackgroundTransparency = 1
    sub.Text = "ENTER PASSWORD"
    sub.TextColor3 = Color3.fromRGB(200, 200, 200)
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.Parent = passFrame

    local passBox = Instance.new("TextBox")
    passBox.Size = UDim2.new(0.8, 0, 0, 40)
    passBox.Position = UDim2.new(0.1, 0, 0, 80)
    passBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    passBox.PlaceholderText = "password"
    passBox.Text = ""
    passBox.TextColor3 = Color3.new(1, 1, 1)
    passBox.Font = Enum.Font.Gotham
    passBox.Parent = passFrame
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 12)
    boxCorner.Parent = passBox

    local loginBtn = Instance.new("TextButton")
    loginBtn.Size = UDim2.new(0.5, 0, 0, 40)
    loginBtn.Position = UDim2.new(0.25, 0, 0, 140)
    loginBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    loginBtn.Text = "VERIFY"
    loginBtn.TextColor3 = Color3.new(1, 1, 1)
    loginBtn.Font = Enum.Font.GothamBold
    loginBtn.BorderSizePixel = 0
    loginBtn.Parent = passFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 20)
    btnCorner.Parent = loginBtn

    local errLabel = Instance.new("TextLabel")
    errLabel.Size = UDim2.new(0.8, 0, 0, 25)
    errLabel.Position = UDim2.new(0.1, 0, 0, 195)
    errLabel.BackgroundTransparency = 1
    errLabel.Text = ""
    errLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
    errLabel.TextSize = 11
    errLabel.Visible = false
    errLabel.Parent = passFrame

    loginBtn.MouseButton1Click:Connect(function()
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
    end)
    passBox.FocusLost:Connect(function(enter)
        if enter and passBox.Text == PASSWORD then
            passGui:Destroy()
            CreateMainHub()
        end
    end)
end

createPasswordUI()

-- ==================== MAIN FUNCTIONS ====================
local function getClosestPlayer(range)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local root = character.HumanoidRootPart
    local closest, closestDist = nil, range or 150
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") and other.Character.Humanoid.Health > 0 then
            local dist = (other.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = other
            end
        end
    end
    return closest
end

local function getClosestPart(character, partName)
    return character and character:FindFirstChild(partName)
end

-- Magic Bullet: Intercepts FireServer calls to redirect bullets
local function setupMagicBullet()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if magicEnabled and method == "FireServer" and (string.find(tostring(self), "Weapon") or string.find(tostring(self), "Remote")) then
            local target = getClosestPlayer(500)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetPos = target.Character.Head.Position
                for i = 1, #args do
                    if typeof(args[i]) == "Vector3" then
                        args[i] = targetPos
                        break
                    end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

-- ESP: Box, Skeleton, Tracer Line
local espData = {}
local Camera = Workspace.CurrentCamera

local function getWorldToScreen(point)
    local vector, onScreen = Camera:WorldToViewportPoint(point)
    return Vector2.new(vector.X, vector.Y), onScreen
end

local function createSkeleton(character, color)
    local lines = {}
    local joints = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"},
        {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"}
    }
    for _, joint in pairs(joints) do
        local partA, partB = character:FindFirstChild(joint[1]), character:FindFirstChild(joint[2])
        if partA and partB then
            local line = Drawing.new("Line")
            line.Thickness = 1.5
            line.Color = color
            line.Visible = true
            lines[#lines+1] = {line, partA, partB}
        end
    end
    return lines
end

local function updateESP()
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player then
            local character = other.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    if not espData[other] then
                        local data = {}
                        if boxEnabled then
                            local box = Drawing.new("Square")
                            box.Thickness = 1.5
                            box.Color = Color3.fromRGB(255, 0, 0)
                            box.Transparency = 1
                            box.Filled = false
                            data.box = box
                        end
                        if skeletonEnabled then
                            data.skeleton = createSkeleton(character, Color3.fromRGB(255, 255, 0))
                        end
                        if tracerEnabled then
                            local tracer = Drawing.new("Line")
                            tracer.Thickness = 1
                            tracer.Color = Color3.fromRGB(0, 255, 0)
                            data.tracer = tracer
                        end
                        espData[other] = data
                    end
                    local data = espData[other]
                    if data.box then
                        local size = 200 / pos.Z
                        data.box.Size = Vector2.new(100 * size, 120 * size)
                        data.box.Position = Vector2.new(pos.X - data.box.Size.X/2, pos.Y - data.box.Size.Y/2)
                    end
                    if data.tracer then
                        data.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        data.tracer.To = Vector2.new(pos.X, pos.Y)
                    end
                    if data.skeleton then
                        for _, lineData in pairs(data.skeleton) do
                            local line, partA, partB = unpack(lineData)
                            local posA, onA = getWorldToScreen(partA.Position)
                            local posB, onB = getWorldToScreen(partB.Position)
                            if onA and onB then
                                line.From = posA
                                line.To = posB
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        end
                    end
                else
                    if espData[other] then
                        if espData[other].box then espData[other].box.Visible = false end
                        if espData[other].tracer then espData[other].tracer.Visible = false end
                        if espData[other].skeleton then
                            for _, lineData in pairs(espData[other].skeleton) do
                                lineData[1].Visible = false
                            end
                        end
                    end
                end
            elseif espData[other] then
                if espData[other].box then espData[other].box:Remove() end
                if espData[other].tracer then espData[other].tracer:Remove() end
                if espData[other].skeleton then
                    for _, lineData in pairs(espData[other].skeleton) do
                        lineData[1]:Remove()
                    end
                end
                espData[other] = nil
            end
        end
    end
end

-- Aimbot (optional)
local aimbotConnection = nil
local function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local target = getClosestPlayer(150)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local cam = Workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
                end
            end
        end
    end)
end

local function stopAimbot()
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
end

-- Auto ATM Farm
local farmConnection = nil
local function startFarm()
    if farmConnection then farmConnection:Disconnect() end
    farmConnection = RunService.Heartbeat:Connect(function()
        if autoFarm then
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            local root = character.HumanoidRootPart
            for _, obj in pairs(Workspace:GetDescendants()) do
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
        end
    end)
end

local function stopFarm()
    if farmConnection then farmConnection:Disconnect(); farmConnection = nil end
end

-- Fly
local flyConnection = nil
local bodyVel = nil
local function enableFly()
    if flyConnection then flyConnection:Disconnect() end
    flyEnabled = true
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVel.Parent = root
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not bodyVel or not player.Character then return end
        local move = player.Character.Humanoid.MoveDirection
        local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50) or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50) or 0
        bodyVel.Velocity = Vector3.new(move.X * 80, up, move.Z * 80)
    end)
end

local function disableFly()
    flyEnabled = false
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

-- Noclip
local noclipConnection = nil
local function enableNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipEnabled = true
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- Infinite Jump
local jumpConnection = nil
local function enableInfJump()
    if jumpConnection then jumpConnection:Disconnect() end
    infJumpEnabled = true
    jumpConnection = UserInputService.JumpRequested:Connect(function()
        if infJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disableInfJump()
    infJumpEnabled = false
    if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
end

-- Fullbright
local origBrightness, origAmbient, origOutdoor
local function enableFullbright()
    if fullbrightEnabled then return end
    origBrightness = Lighting.Brightness
    origAmbient = Lighting.Ambient
    origOutdoor = Lighting.OutdoorAmbient
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    fullbrightEnabled = true
end

local function disableFullbright()
    if not fullbrightEnabled then return end
    Lighting.Brightness = origBrightness or 0.5
    Lighting.Ambient = origAmbient or Color3.fromRGB(100, 100, 100)
    Lighting.OutdoorAmbient = origOutdoor or Color3.fromRGB(100, 100, 100)
    Lighting.FogEnd = 1000
    fullbrightEnabled = false
end

-- Toggle functions with proper state management
local function toggleAimbot(state)
    aimbotEnabled = state
    if state then startAimbot() else stopAimbot() end
end

local function toggleESP(state)
    espEnabled = state
    if not state then
        for _, data in pairs(espData) do
            if data.box then data.box:Remove() end
            if data.tracer then data.tracer:Remove() end
            if data.skeleton then
                for _, lineData in pairs(data.skeleton) do
                    lineData[1]:Remove()
                end
            end
        end
        espData = {}
    end
end

local function toggleMagic(state)
    magicEnabled = state
    if state then setupMagicBullet() end
end

local function toggleFarm(state)
    autoFarm = state
    if state then startFarm() else stopFarm() end
end

local function toggleFly(state)
    flyEnabled = state
    if state then enableFly() else disableFly() end
end

local function toggleNoclip(state)
    noclipEnabled = state
    if state then enableNoclip() else disableNoclip() end
end

local function toggleInfJump(state)
    infJumpEnabled = state
    if state then enableInfJump() else disableInfJump() end
end

local function toggleFullbright(state)
    fullbrightEnabled = state
    if state then enableFullbright() else disableFullbright() end
end

local function toggleBox(state)
    boxEnabled = state
end

local function toggleSkeleton(state)
    skeletonEnabled = state
end

local function toggleTracer(state)
    tracerEnabled = state
end

-- ==================== MAIN GUI (COMPACT + HORIZONTAL) ====================
local function CreateMainHub()
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 60)
    mainFrame.Position = UDim2.new(0.5, -210, 0.8, -30)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = hubGui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 10, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "JINoxX HUB"
    titleLbl.TextColor3 = Color3.new(1, 1, 1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() hubGui:Destroy() end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -35)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 600, 0, 0)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
    scrollFrame.Parent = mainFrame

    local function addToggle(text, xPos, var, toggleFunc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 85, 0, 25)
        btn.Position = UDim2.new(0, xPos, 0.5, -12.5)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(35, 35, 45)
            btn.TextColor3 = active and Color3.new(1, 1, 1) or Color3.fromRGB(220, 220, 220)
            toggleFunc(active)
        end)
        return btn
    end

    -- Horizontal buttons
    addToggle("Aimbot", 5, aimbotEnabled, toggleAimbot)
    addToggle("Magic", 95, magicEnabled, toggleMagic)
    addToggle("Box", 185, boxEnabled, toggleBox)
    addToggle("Skeleton", 275, skeletonEnabled, toggleSkeleton)
    addToggle("Tracer", 365, tracerEnabled, toggleTracer)
    addToggle("Farm", 455, autoFarm, toggleFarm)
    addToggle("Fly", 545, flyEnabled, toggleFly)
    addToggle("Noclip", 635, noclipEnabled, toggleNoclip)
    addToggle("Inf Jump", 725, infJumpEnabled, toggleInfJump)
    addToggle("Fullbright", 815, fullbrightEnabled, toggleFullbright)

    scrollFrame.CanvasSize = UDim2.new(0, 910, 0, 0)

    -- Drag functionality
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- ESP Update Loop
    RunService.RenderStepped:Connect(function()
        if espEnabled then updateESP() end
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Ultimate Hub Loaded! | Horizontal GUI + Magic Bullet",
        Duration = 3
    })
end
