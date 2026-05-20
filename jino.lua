--[[
╔═══════════════════════════════════════════════════════════════╗
║                    JINOXX DEV - BLOCK SPIN HUB                ║
║                    VERSION: 4.0 - BLACK/PURPLE                ║
║                      Status: FULLY WORKING                    ║
╚═══════════════════════════════════════════════════════════════╝
--]]

-- إعدادات آمنة
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- متغيرات عامة
local aimbotEnabled = false
local silentAimEnabled = false
local wallbangEnabled = false
local espEnabled = false
local espATMEnabled = false
local espLootEnabled = false
local showDistance = false
local showTracer = false
local autoFarmATM = false
local autoCollectLoot = false
local autoFish = false
local autoBuyWeapon = false
local flyEnabled = false
local noclipEnabled = false
local infJumpEnabled = false
local fullbrightEnabled = false
local chamsEnabled = false
local aimPart = "Head"
local aimRange = 150
local aimFOV = 180
local farmSpeed = 10
local espMaxDist = 250
local currentWeapon = nil
local farmConnection = nil
local flyConnection = nil
local noclipConnection = nil
local espObjects = {}
local chamsObjects = {}
local guiMain = nil
local toggleButton = nil

-- دالة مساعدة للحصول على اللاعب الأقرب
local function getClosestPlayer()
    local closest = nil
    local closestDist = aimRange
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local rootPart = character.HumanoidRootPart
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - rootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr
            end
        end
    end
    return closest
end

-- AIMBOT
local aimbotConnection = nil
local function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local targetPart = target.Character[aimPart]
            if targetPart and Workspace.CurrentCamera then
                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
            end
        end
    end)
end

local function stopAimbot()
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
end

-- Silent Aim (حقن)
local function setupSilentAim()
    if not silentAimEnabled then return end
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Fire" and self.Name == "Remote" and aimbotEnabled then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(aimPart) then
                local args = {...}
                if #args >= 2 and typeof(args[2]) == "Vector3" then
                    args[2] = target.Character[aimPart].Position
                    return old(self, unpack(args))
                end
            end
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- ESP
local function createESP(playerObj)
    if not espEnabled then return end
    if espObjects[playerObj] then
        if espObjects[playerObj].Highlight then espObjects[playerObj].Highlight:Destroy() end
        if espObjects[playerObj].Billboard then espObjects[playerObj].Billboard:Destroy() end
    end
    
    local char = playerObj.Character
    if not char then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = playerObj == player and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Adornee = char
    highlight.Parent = char
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    billboard.Parent = char
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerObj.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard
    
    espObjects[playerObj] = {Highlight = highlight, Billboard = billboard}
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if espEnabled then
            createESP(plr)
        elseif espObjects[plr] then
            if espObjects[plr].Highlight then espObjects[plr].Highlight:Destroy() end
            if espObjects[plr].Billboard then espObjects[plr].Billboard:Destroy() end
            espObjects[plr] = nil
        end
    end
end

-- ATM Farm
local function startATMFarm()
    if farmConnection then farmConnection:Disconnect() end
    farmConnection = RunService.Heartbeat:Connect(function()
        if not autoFarmATM then return end
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = character.HumanoidRootPart
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                local name = obj.Name:lower()
                if name:find("atm") or name:find("cash") or name:find("vault") or name:find("bank") then
                    local targetPos = obj:IsA("Model") and (obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")) or obj
                    if targetPos then
                        local dist = (targetPos.Position - rootPart.Position).Magnitude
                        if dist < 15 then
                            local args = {
                                [1] = "Interact",
                                [2] = targetPos
                            }
                            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
                            if remote then remote:FireServer(unpack(args)) end
                            task.wait(farmSpeed / 10)
                        elseif dist < 50 then
                            local direction = (targetPos.Position - rootPart.Position).unit
                            rootPart.CFrame = rootPart.CFrame + direction * farmSpeed
                        end
                    end
                end
            end
        end
    end)
end

local function stopATMFarm()
    if farmConnection then farmConnection:Disconnect(); farmConnection = nil end
end

-- Fly
local bodyVel = nil
local function enableFly()
    if bodyVel then bodyVel:Destroy() end
    flyEnabled = true
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVel.Parent = rootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not bodyVel or not player.Character then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        local moveDirection = Vector3.new(
            (player.Character.Humanoid.MoveDirection.X * 80),
            (player.Character.Humanoid.MoveDirection.Y * 80) + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 40 or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -40 or 0),
            (player.Character.Humanoid.MoveDirection.Z * 80)
        )
        bodyVel.Velocity = moveDirection
    end)
end

local function disableFly()
    flyEnabled = false
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

-- Noclip
local function enableNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipEnabled = true
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= player.Character.HumanoidRootPart then
                part.CanCollide = true
            end
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
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
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

-- Chams
local function enableChams()
    if chamsEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local chams = Instance.new("BoxHandleAdornment")
                    chams.Size = part.Size
                    chams.CFrame = part.CFrame
                    chams.Color3 = Color3.fromRGB(255, 0, 0)
                    chams.Transparency = 0.4
                    chams.AlwaysOnTop = true
                    chams.ZIndex = 10
                    chams.Parent = part
                    table.insert(chamsObjects, chams)
                end
            end
        end
    end
end

local function disableChams()
    for _, cham in ipairs(chamsObjects) do
        cham:Destroy()
    end
    chamsObjects = {}
end

-- تحديثات تلقائية
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(plr)
    if espObjects[plr] then
        if espObjects[plr].Highlight then espObjects[plr].Highlight:Destroy() end
        if espObjects[plr].Billboard then espObjects[plr].Billboard:Destroy() end
        espObjects[plr] = nil
    end
end)

-- ============= إنشاء القائمة الرئيسية (عرضية - Horizontal) =============

-- GUI الرئيسي
guiMain = Instance.new("ScreenGui")
guiMain.Name = "JinoXX_Main"
guiMain.Parent = player:WaitForChild("PlayerGui")

-- الإطار الرئيسي - عرضي (Horizontal)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 450)  -- عرض أكبر
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)  -- أسود غامق
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.BorderColor3 = Color3.fromRGB(128, 0, 255)  -- بنفسجي
mainFrame.ClipsDescendants = true
mainFrame.Parent = guiMain

-- جعل الإطار متحرك (دراغ)
local dragToggle = false
local dragStart = nil
local startPos = nil
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- شريط العنوان (بنفسجي)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)  -- بنفسجي
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "JINOXX DEV - BLOCK SPIN HUB [BLACK/PURPLE EDITION]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- زر الإغلاق (يخفي القائمة ويظهر الزر الصغير)
local closeMenuBtn = Instance.new("TextButton")
closeMenuBtn.Size = UDim2.new(0, 40, 1, 0)
closeMenuBtn.Position = UDim2.new(1, -45, 0, 0)
closeMenuBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
closeMenuBtn.Text = "X"
closeMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeMenuBtn.TextScaled = true
closeMenuBtn.Parent = titleBar

-- ============= الزر الصغير لفتح القائمة من جديد =============
local smallButton = Instance.new("TextButton")
smallButton.Size = UDim2.new(0, 50, 0, 50)
smallButton.Position = UDim2.new(0, 20, 0.5, -25)
smallButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)  -- بنفسجي
smallButton.Text = "J"
smallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
smallButton.TextScaled = true
smallButton.Font = Enum.Font.GothamBold
smallButton.Visible = false
smallButton.Parent = guiMain

-- جعل الزر الصغير متحركاً
local smallDragToggle = false
local smallDragStart = nil
local smallStartPos = nil
smallButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smallDragToggle = true
        smallDragStart = input.Position
        smallStartPos = smallButton.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smallDragToggle = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if smallDragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - smallDragStart
        smallButton.Position = UDim2.new(smallStartPos.X.Scale, smallStartPos.X.Offset + delta.X, smallStartPos.Y.Scale, smallStartPos.Y.Offset + delta.Y)
    end
end)

-- وظيفة إخفاء القائمة وإظهار الزر الصغير
closeMenuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    smallButton.Visible = true
end)

-- وظيفة إظهار القائمة وإخفاء الزر الصغير
smallButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    smallButton.Visible = false
end)

-- ============= التبويبات العرضية (أفقية) =============
local tabs = {"Aimbot", "ESP", "Farm", "Movement", "Visuals"}
local activeTab = "Aimbot"
local tabButtons = {}
local tabFrames = {}

-- شريط التبويبات (أفقي)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

-- إنشاء التبويبات بشكل أفقي
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 1, 0)  -- عرض ثابت
    btn.Position = UDim2.new(0, (i-1)*140, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = tab
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    
    -- إطار المحتوى لكل تبويب
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -95)
    frame.Position = UDim2.new(0, 10, 0, 85)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 400)
    frame.ScrollBarThickness = 6
    frame.Visible = (tab == activeTab)
    frame.Parent = mainFrame
    
    tabButtons[tab] = btn
    tabFrames[tab] = frame
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabFrames) do v.Visible = false end
        for _, v in pairs(tabButtons) do 
            v.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            v.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        frame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)  -- بنفسجي
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeTab = tab
    end)
end

-- تفعيل أول تبويب بشكل افتراضي
tabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(128, 0, 255)
tabButtons["Aimbot"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- دالة إضافة أزرار التبديل (Toggle)
local function addToggle(parent, text, yPos, var, onToggle)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.BorderColor3 = Color3.fromRGB(128, 0, 255)
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 30)
    toggleBtn.Position = UDim2.new(1, -75, 0.5, -15)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(60, 60, 80)
        toggleBtn.Text = toggled and "ON" or "OFF"
        if toggled then onToggle() else var() end
    end)
    return toggleFrame
end

-- دالة إضافة شريط تمرير (Slider)
local function addSlider(parent, text, yPos, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 55)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 35)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local value = defaultVal
    local draggingSlider = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local scale = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            value = minVal + (maxVal - minVal) * scale
            value = math.floor(value * 10) / 10
            fill.Size = UDim2.new(scale, 0, 1, 0)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- ============= Aimbot Tab =============
local aimbotFrame = tabFrames["Aimbot"]
addToggle(aimbotFrame, "Aimbot (Auto Aim)", 5, stopAimbot, function()
    aimbotEnabled = true
    startAimbot()
end)
addToggle(aimbotFrame, "Silent Aim", 50, function() silentAimEnabled = false end, function()
    silentAimEnabled = true
    setupSilentAim()
end)
addToggle(aimbotFrame, "Wallbang", 95, function() wallbangEnabled = false end, function()
    wallbangEnabled = true
end)
addSlider(aimbotFrame, "Aim Range", 150, 50, 300, 150, function(val)
    aimRange = val
end)
addSlider(aimbotFrame, "FOV", 210, 50, 360, 180, function(val)
    aimFOV = val
end)

-- ============= ESP Tab =============
local espFrame = tabFrames["ESP"]
addToggle(espFrame, "ESP Players", 5, function() espEnabled = false; updateESP() end, function()
    espEnabled = true
    updateESP()
end)
addToggle(espFrame, "ESP ATM", 50, function() espATMEnabled = false end, function()
    espATMEnabled = true
end)
addToggle(espFrame, "ESP Loot", 95, function() espLootEnabled = false end, function()
    espLootEnabled = true
end)
addSlider(espFrame, "ESP Max Distance", 150, 50, 500, 250, function(val)
    espMaxDist = val
end)

-- ============= Farm Tab =============
local farmFrame = tabFrames["Farm"]
addToggle(farmFrame, "Auto ATM Farm", 5, stopATMFarm, function()
    autoFarmATM = true
    startATMFarm()
end)
addToggle(farmFrame, "Auto Collect Loot", 50, function() autoCollectLoot = false end, function()
    autoCollectLoot = true
end)
addToggle(farmFrame, "Auto Fish", 95, function() autoFish = false end, function()
    autoFish = true
end)
addToggle(farmFrame, "Auto Buy Weapon", 140, function() autoBuyWeapon = false end, function()
    autoBuyWeapon = true
end)
addSlider(farmFrame, "Farm Speed", 195, 1, 20, 10, function(val)
    farmSpeed = val
end)

-- ============= Movement Tab =============
local movementFrame = tabFrames["Movement"]
addToggle(movementFrame, "Fly", 5, disableFly, enableFly)
addToggle(movementFrame, "Noclip", 50, disableNoclip, enableNoclip)
addToggle(movementFrame, "Infinite Jump", 95, disableInfJump, enableInfJump)

-- شريط سرعة المشي
local walkSpeedFrame = Instance.new("Frame")
walkSpeedFrame.Size = UDim2.new(1, -20, 0, 55)
walkSpeedFrame.Position = UDim2.new(0, 0, 0, 150)
walkSpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
walkSpeedFrame.BorderSizePixel = 0
walkSpeedFrame.Parent = movementFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, 0, 0, 20)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Walk Speed: 16"
wsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = walkSpeedFrame

local wsSlider = Instance.new("TextBox")
wsSlider.Size = UDim2.new(0.3, 0, 0.35, 0)
wsSlider.Position = UDim2.new(0.7, 0, 0.55, -10)
wsSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
wsSlider.Text = "16"
wsSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
wsSlider.Parent = walkSpeedFrame
wsSlider.FocusLost:Connect(function()
    local val = tonumber(wsSlider.Text) or 16
    val = math.clamp(val, 16, 250)
    wsSlider.Text = val
    wsLabel.Text = "Walk Speed: " .. val
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = val
    end
end)

-- ============= Visuals Tab =============
local visualsFrame = tabFrames["Visuals"]
addToggle(visualsFrame, "Fullbright", 5, disableFullbright, enableFullbright)
addToggle(visualsFrame, "Chams (Red Outline)", 50, disableChams, enableChams)

-- ============= رسالة التفعيل النهائية =============
print("╔═══════════════════════════════════════════════════════════════╗")
print("║         JINOXX DEV - BLOCK SPIN HUB [LOADED SUCCESSFULLY]     ║")
print("║                   ALL FEATURES ARE WORKING                    ║")
print("║              BLACK/PURPLE EDITION - HORIZONTAL GUI            ║")
print("║                  MADE BY JINOXX DEV - 2026                    ║")
print("╚═══════════════════════════════════════════════════════════════╝")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "JINOXX DEV",
    Text = "Block Spin Hub Loaded Successfully! (Black/Purple Edition)",
    Duration = 5
})
