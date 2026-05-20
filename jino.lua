-- JINOXX DEV | FULL HORIZONTAL HUB + MAGIC + INFINITE STAMINA | PASSWORD: JINOXX DEV
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = cloneref and cloneref(game:GetService("VirtualInputManager")) or game:GetService("VirtualInputManager")

-- ==================== الميزات ====================
local features = {
    aimbot = false,
    magic = false,
    espBox = false,
    espSkel = false,
    espLine = false,
    autoFarm = false,
    fly = false,
    noclip = false,
    infJump = false,
    fullbright = false,
    infStamina = false,
}

local connections = {}
local bodyVel = nil
local espHighlights = {}   -- للـ Box
local skeletonParts = {}   -- للهيكل العظمي
local tracerLines = {}     -- للخطوط
local playerStamina = nil  -- لمؤشر Stamina

-- ==================== دوال مساعدة ====================
local function getClosestPlayer(range)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local closest, closestDist = nil, range or 150
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr
            end
        end
    end
    return closest
end

-- ==================== Aimbot ====================
local aimbotConn = nil
local function startAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if features.aimbot then
            local target = getClosestPlayer(150)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end)
end

-- ==================== Magic Bullet (اعتراض FireServer) ====================
local oldNamecall
local function setupMagic()
    local mt = getrawmetatable(game)
    if not mt then
        -- fallback: محاكاة نقر سريع
        task.spawn(function()
            while features.magic do
                local target = getClosestPlayer(300)
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local pos = Workspace.CurrentCamera:WorldToScreenPoint(target.Character.Head.Position)
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                    task.wait()
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
                end
                task.wait(0.05)
            end
        end)
        return
    end
    oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if features.magic and method == "FireServer" and (tostring(self):find("Weapon") or tostring(self):find("Remote")) then
            local target = getClosestPlayer(500)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                for i = 1, #args do
                    if typeof(args[i]) == "Vector3" then
                        args[i] = target.Character.Head.Position
                        break
                    end
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)
    setreadonly(mt, true)
end

-- ==================== ESP Box (حجم مناسب للاعب) ====================
local function updateESPBox()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and features.espBox then
                if not espHighlights[plr] then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.6
                    highlight.Adornee = char
                    highlight.Parent = char
                    espHighlights[plr] = highlight
                end
            elseif espHighlights[plr] then
                espHighlights[plr]:Destroy()
                espHighlights[plr] = nil
            end
        end
    end
end

-- ==================== ESP Skeleton (هيكل عظمي) ====================
local function updateSkeleton()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and features.espSkel then
                if not skeletonParts[plr] then
                    local parts = {}
                    local joints = {
                        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
                        {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"},
                        {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"}
                    }
                    for _, joint in pairs(joints) do
                        local a = char:FindFirstChild(joint[1])
                        local b = char:FindFirstChild(joint[2])
                        if a and b then
                            local line = Instance.new("Part")
                            line.Size = Vector3.new(0.2, 0.2, (a.Position - b.Position).Magnitude)
                            line.CFrame = CFrame.new(a.Position, b.Position) * CFrame.new(0, 0, -line.Size.Z/2)
                            line.Anchored = true
                            line.CanCollide = false
                            line.BrickColor = BrickColor.new("Bright yellow")
                            line.Material = Enum.Material.Neon
                            line.Parent = char
                            table.insert(parts, {line, a, b})
                        end
                    end
                    skeletonParts[plr] = parts
                else
                    for _, lineData in pairs(skeletonParts[plr]) do
                        local line, a, b = unpack(lineData)
                        if a and b then
                            local dist = (a.Position - b.Position).Magnitude
                            line.Size = Vector3.new(0.2, 0.2, dist)
                            line.CFrame = CFrame.new(a.Position, b.Position) * CFrame.new(0, 0, -dist/2)
                        end
                    end
                end
            elseif skeletonParts[plr] then
                for _, lineData in pairs(skeletonParts[plr]) do
                    lineData[1]:Destroy()
                end
                skeletonParts[plr] = nil
            end
        end
    end
end

-- ==================== ESP Tracer (خط من أسفل الشاشة) ====================
local function updateTracer()
    if not features.espLine then
        for _, line in pairs(tracerLines) do
            if line then line:Remove() end
        end
        tracerLines = {}
        return
    end
    local cam = Workspace.CurrentCamera
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = cam:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    if not tracerLines[plr] then
                        local line = Drawing.new("Line")
                        line.Thickness = 1.5
                        line.Color = Color3.fromRGB(0, 255, 0)
                        tracerLines[plr] = line
                    end
                    tracerLines[plr].From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                    tracerLines[plr].To = Vector2.new(pos.X, pos.Y)
                    tracerLines[plr].Visible = true
                elseif tracerLines[plr] then
                    tracerLines[plr].Visible = false
                end
            elseif tracerLines[plr] then
                tracerLines[plr]:Remove()
                tracerLines[plr] = nil
            end
        end
    end
end

-- ==================== Auto Farm (ATM) ====================
local farmConn = nil
local function startFarm()
    if farmConn then farmConn:Disconnect() end
    farmConn = RunService.Heartbeat:Connect(function()
        if not features.autoFarm then return end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("atm") or obj.Name:lower():find("cash")) then
                local part = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
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

-- ==================== Fly ====================
local function enableFly()
    if connections.fly then connections.fly:Disconnect() end
    features.fly = true
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e4, 1e4, 1e4)
    bodyVel.Parent = root
    connections.fly = RunService.Heartbeat:Connect(function()
        if not features.fly or not bodyVel or not player.Character then return end
        local move = player.Character.Humanoid.MoveDirection
        local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50) or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50) or 0
        bodyVel.Velocity = Vector3.new(move.X * 80, up, move.Z * 80)
    end)
end

local function disableFly()
    features.fly = false
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
end

-- ==================== Noclip ====================
local function enableNoclip()
    if connections.noclip then connections.noclip:Disconnect() end
    features.noclip = true
    connections.noclip = RunService.Stepped:Connect(function()
        if features.noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    features.noclip = false
    if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ==================== Infinite Jump ====================
local function enableInfJump()
    if connections.infJump then connections.infJump:Disconnect() end
    features.infJump = true
    connections.infJump = UserInputService.JumpRequested:Connect(function()
        if features.infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disableInfJump()
    features.infJump = false
    if connections.infJump then connections.infJump:Disconnect(); connections.infJump = nil end
end

-- ==================== Fullbright ====================
local origBrightness, origAmbient, origOutdoor
local function enableFullbright()
    if features.fullbright then return end
    origBrightness = Lighting.Brightness
    origAmbient = Lighting.Ambient
    origOutdoor = Lighting.OutdoorAmbient
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1,1,1)
    Lighting.OutdoorAmbient = Color3.new(1,1,1)
    Lighting.FogEnd = 100000
    features.fullbright = true
end

local function disableFullbright()
    if not features.fullbright then return end
    Lighting.Brightness = origBrightness or 0.5
    Lighting.Ambient = origAmbient or Color3.fromRGB(100,100,100)
    Lighting.OutdoorAmbient = origOutdoor or Color3.fromRGB(100,100,100)
    Lighting.FogEnd = 1000
    features.fullbright = false
end

-- ==================== Infinite Stamina ====================
local function enableInfStamina()
    if connections.stamina then return end
    features.infStamina = true
    -- البحث عن مؤشر Stamina (غالباً في player.Character.Humanoid)
    connections.stamina = RunService.Stepped:Connect(function()
        if features.infStamina and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- محاولة ضبط stamina مباشرة (في بعض الألعاب تكون في humanoid)
                if humanoid:FindFirstChild("Stamina") then
                    humanoid.Stamina.Value = humanoid.Stamina.MaxValue
                end
                -- طريقة عامة: منع استهلاك الطاقة عبر ضبط سرعة الجري إذا لزم
                humanoid:SetAttribute("Stamina", 100)
            end
        end
    end)
end

local function disableInfStamina()
    features.infStamina = false
    if connections.stamina then connections.stamina:Disconnect(); connections.stamina = nil end
end

-- ==================== دوال التبديل ====================
local function toggleAimbot(state) features.aimbot = state; if state then startAimbot() elseif aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end end
local function toggleMagic(state) features.magic = state; if state then setupMagic() end end
local function toggleBox(state) features.espBox = state; updateESPBox() end
local function toggleSkel(state) features.espSkel = state; updateSkeleton() end
local function toggleLine(state) features.espLine = state; updateTracer() end
local function toggleFarm(state) features.autoFarm = state; if state then startFarm() elseif farmConn then farmConn:Disconnect(); farmConn = nil end end
local function toggleFly(state) if state then enableFly() else disableFly() end end
local function toggleNoclip(state) if state then enableNoclip() else disableNoclip() end end
local function toggleInfJump(state) if state then enableInfJump() else disableInfJump() end end
local function toggleFullbright(state) if state then enableFullbright() else disableFullbright() end end
local function toggleInfStamina(state) if state then enableInfStamina() else disableInfStamina() end end

-- ==================== واجهة الباسورد ====================
local passGui = Instance.new("ScreenGui")
passGui.Name = "JinoXX_Pass"
passGui.Parent = player.PlayerGui

local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 350, 0, 220)
passFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
passFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
passFrame.Parent = passGui
Instance.new("UICorner").CornerRadius = UDim.new(0,16); Instance.new("UICorner").Parent = passFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(128,0,255)
title.Text = "JINoxX"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.Parent = passFrame
Instance.new("UICorner").CornerRadius = UDim.new(0,16); Instance.new("UICorner").Parent = title

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,0,0,20)
sub.Position = UDim2.new(0,0,0,45)
sub.BackgroundTransparency = 1
sub.Text = "ENTER PASSWORD"
sub.TextColor3 = Color3.fromRGB(200,200,200)
sub.TextSize = 11
sub.Parent = passFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.8,0,0,40)
passBox.Position = UDim2.new(0.1,0,0,75)
passBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
passBox.PlaceholderText = "password"
passBox.Text = ""
passBox.TextColor3 = Color3.new(1,1,1)
passBox.Font = Enum.Font.Gotham
passBox.Parent = passFrame
Instance.new("UICorner").CornerRadius = UDim.new(0,12); Instance.new("UICorner").Parent = passBox

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.5,0,0,40)
btn.Position = UDim2.new(0.25,0,0,130)
btn.BackgroundColor3 = Color3.fromRGB(128,0,255)
btn.Text = "VERIFY"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.Parent = passFrame
Instance.new("UICorner").CornerRadius = UDim.new(0,20); Instance.new("UICorner").Parent = btn

local err = Instance.new("TextLabel")
err.Size = UDim2.new(0.8,0,0,25)
err.Position = UDim2.new(0.1,0,0,180)
err.BackgroundTransparency = 1
err.Text = ""
err.TextColor3 = Color3.fromRGB(255,50,100)
err.TextSize = 11
err.Visible = false
err.Parent = passFrame

local function verify()
    if passBox.Text == "JINOXX DEV" then
        passGui:Destroy()
        CreateMainHub()
    else
        err.Text = "❌ Wrong password!"
        err.Visible = true
        task.wait(1.5)
        err.Visible = false
        passBox.Text = ""
    end
end
btn.MouseButton1Click:Connect(verify)
passBox.FocusLost:Connect(function(enter) if enter then verify() end end)

-- ==================== القائمة الرئيسية (عرضية كبيرة مع زر تصغير) ====================
function CreateMainHub()
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player.PlayerGui

    -- الإطار الرئيسي (عرضي كبير)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 660, 0, 80)
    mainFrame.Position = UDim2.new(0.5, -330, 0.8, -40)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = hubGui
    Instance.new("UICorner").CornerRadius = UDim.new(0,12); Instance.new("UICorner").Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1,0,0,32)
    titleBar.BackgroundColor3 = Color3.fromRGB(128,0,255)
    titleBar.Parent = mainFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0,12); Instance.new("UICorner").Parent = titleBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1,-120,1,0)
    titleLbl.Position = UDim2.new(0,10,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "JINoxX HUB"
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar

    -- زر التصغير (Minimize) – يخفي القائمة ويظهر زر صغير
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,35,1,0)
    minBtn.Position = UDim2.new(1,-70,0,0)
    minBtn.BackgroundColor3 = Color3.fromRGB(80,0,160)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.TextScaled = true
    minBtn.BorderSizePixel = 0
    minBtn.Parent = titleBar
    Instance.new("UICorner").CornerRadius = UDim.new(0,8); Instance.new("UICorner").Parent = minBtn

    -- زر الإغلاق الكامل
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,35,1,0)
    closeBtn.Position = UDim2.new(1,-35,0,0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80,0,160)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    Instance.new("UICorner").CornerRadius = UDim.new(0,8); Instance.new("UICorner").Parent = closeBtn

    -- الزر الصغير لاستعادة القائمة (يظهر عند التصغير)
    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(0,50,0,50)
    restoreBtn.Position = UDim2.new(0,20,0.8,0)
    restoreBtn.BackgroundColor3 = Color3.fromRGB(128,0,255)
    restoreBtn.Text = "JX"
    restoreBtn.TextColor3 = Color3.new(1,1,1)
    restoreBtn.TextScaled = true
    restoreBtn.Font = Enum.Font.GothamBold
    restoreBtn.Visible = false
    restoreBtn.Parent = hubGui
    Instance.new("UICorner").CornerRadius = UDim.new(0,12); Instance.new("UICorner").Parent = restoreBtn

    -- وظيفة التصغير والاستعادة
    minBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        restoreBtn.Visible = true
    end)
    restoreBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        restoreBtn.Visible = false
    end)
    closeBtn.MouseButton1Click:Connect(function()
        hubGui:Destroy()
    end)

    -- منطقة الأزرار (قابلة للتمرير)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-10,1,-36)
    scroll.Position = UDim2.new(0,5,0,36)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(128,0,255)
    scroll.Parent = mainFrame

    -- قائمة الأزرار (الاسم، الموضع X، الدالة)
    local buttons = {
        {"Aim", 5, toggleAimbot}, {"Magic", 85, toggleMagic}, {"Box", 165, toggleBox},
        {"Skel", 245, toggleSkel}, {"Trace", 325, toggleLine}, {"Farm", 405, toggleFarm},
        {"Fly", 485, toggleFly}, {"Noclip", 565, toggleNoclip}, {"InfJ", 645, toggleInfJump},
        {"Light", 725, toggleFullbright}, {"Stam", 805, toggleInfStamina}
    }
    local maxX = 0
    for _, b in pairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 70, 0, 32)
        btn.Position = UDim2.new(0, b[2], 0.5, -16)
        btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
        btn.Text = b[1]
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = scroll
        Instance.new("UICorner").CornerRadius = UDim.new(0,6); Instance.new("UICorner").Parent = btn
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(128,0,255) or Color3.fromRGB(35,35,45)
            btn.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(220,220,220)
            b[3](active)
        end)
        maxX = b[2] + 80
    end
    scroll.CanvasSize = UDim2.new(0, maxX + 20, 0, 0)

    -- سحب القائمة (بالماوس أو اللمس)
    local dragging = false
    local dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            -- تحديث موضع زر الاستعادة إذا كان ظاهراً
            if restoreBtn.Visible then
                restoreBtn.Position = UDim2.new(0,20,0.8,0) -- يظل ثابتاً نسبياً، يمكن تعديله
            end
        end
    end)

    -- حلقات تحديث الميزات البصرية
    RunService.RenderStepped:Connect(function()
        if features.espBox then updateESPBox() end
        if features.espSkel then updateSkeleton() end
        if features.espLine then updateTracer() end
    end)

    game.StarterGui:SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Full Horizontal Hub + Infinite Stamina | Ready",
        Duration = 3
    })
end
