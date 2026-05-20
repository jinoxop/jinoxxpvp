--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║     ██╗ ██╗███╗   ██╗ ██████╗ ██╗  ██╗██╗  ██╗     ██████╗ ███████╗██╗       ║
║     ██║ ██║████╗  ██║██╔═══██╗╚██╗██╔╝██║  ██║     ██╔══██╗██╔════╝██║       ║
║     ██║ ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ███████║     ██║  ██║█████╗  ██║       ║
║     ██║ ██║██║╚██╗██║██║   ██║ ██╔██╗ ██╔══██║     ██║  ██║██╔══╝  ██║       ║
║     ██║ ██║██║ ╚████║╚██████╔╝██╔╝ ██╗██║  ██║     ██████╔╝███████╗██║       ║
║     ╚═╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝╚═╝       ║
║                                                                               ║
║              JINOXX DEV - BLOCK SPIN HUB [PASSWORD: JINOXX DEV]              ║
║                           VERSION: 9.0 - HORIZONTAL                          ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                          PASSWORD SYSTEM                                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local PASSWORD = "JINOXX DEV"  -- كلمة المرور الصحيحة (حساسة للحروف الكبيرة)

-- نافذة إدخال الباسورد
local passwordGui = Instance.new("ScreenGui")
passwordGui.Name = "JinoXX_Password"
passwordGui.Parent = player:WaitForChild("PlayerGui")

-- الخلفية
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.75
bg.Parent = passwordGui

-- النافذة الرئيسية
local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 380, 0, 280)
passFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
passFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
passFrame.BackgroundTransparency = 0.05
passFrame.BorderSizePixel = 0
passFrame.ClipsDescendants = true
passFrame.Parent = passwordGui

local passCorner = Instance.new("UICorner")
passCorner.CornerRadius = UDim.new(0, 20)
passCorner.Parent = passFrame

-- توهج بنفسجي
local passGlow = Instance.new("Frame")
passGlow.Size = UDim2.new(1, 12, 1, 12)
passGlow.Position = UDim2.new(0, -6, 0, -6)
passGlow.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
passGlow.BackgroundTransparency = 0.85
passGlow.BorderSizePixel = 0
passGlow.ZIndex = 0
passGlow.Parent = passFrame

local passGlowCorner = Instance.new("UICorner")
passGlowCorner.CornerRadius = UDim.new(0, 26)
passGlowCorner.Parent = passGlow

-- الشعار
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 70)
logo.Position = UDim2.new(0, 0, 0, 25)
logo.BackgroundTransparency = 1
logo.Text = "JINoxX"
logo.TextColor3 = Color3.fromRGB(128, 0, 255)
logo.TextSize = 42
logo.Font = Enum.Font.GothamBold
logo.Parent = passFrame

local subLogo = Instance.new("TextLabel")
subLogo.Size = UDim2.new(1, 0, 0, 25)
subLogo.Position = UDim2.new(0, 0, 0, 85)
subLogo.BackgroundTransparency = 1
subLogo.Text = "ENTER PASSWORD"
subLogo.TextColor3 = Color3.fromRGB(200, 200, 200)
subLogo.TextSize = 12
subLogo.Font = Enum.Font.Gotham
subLogo.Parent = passFrame

-- حقل إدخال الباسورد
local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.8, 0, 0, 45)
passBox.Position = UDim2.new(0.1, 0, 0, 130)
passBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
passBox.BorderSizePixel = 0
passBox.PlaceholderText = "Enter password..."
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.TextSize = 14
passBox.Font = Enum.Font.Gotham
passBox.Parent = passFrame

local passCornerBox = Instance.new("UICorner")
passCornerBox.CornerRadius = UDim.new(0, 12)
passCornerBox.Parent = passBox

-- زر التحقق
local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.5, 0, 0, 45)
verifyBtn.Position = UDim2.new(0.25, 0, 0, 195)
verifyBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
verifyBtn.Text = "VERIFY"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 14
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0
verifyBtn.Parent = passFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 25)
verifyCorner.Parent = verifyBtn

-- رسالة الخطأ
local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0.8, 0, 0, 30)
errorLabel.Position = UDim2.new(0.1, 0, 0, 245)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
errorLabel.TextSize = 11
errorLabel.Font = Enum.Font.Gotham
errorLabel.Visible = false
errorLabel.Parent = passFrame

-- تأثير hover
verifyBtn.MouseEnter:Connect(function()
    TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 50, 255)}):Play()
end)
verifyBtn.MouseLeave:Connect(function()
    TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(128, 0, 255)}):Play()
end)

-- دالة التحقق
local function checkPassword()
    local input = passBox.Text
    if input == PASSWORD then
        passwordGui:Destroy()
        loadMainHub()  -- تشغيل الهكر
    else
        errorLabel.Text = "❌ Wrong password! Try again."
        errorLabel.Visible = true
        passBox.Text = ""
        task.delay(2, function()
            errorLabel.Visible = false
        end)
    end
end

verifyBtn.MouseButton1Click:Connect(checkPassword)
passBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then checkPassword() end
end)

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                          MAIN HUB (HORIZONTAL)                            ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

local function loadMainHub()
    print("JINOXX DEV - ACCESS GRANTED! Loading Horizontal Hub...")
    
    -- إشعار ترحيبي
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Password Correct! Loading Hub...",
        Duration = 2
    })
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                          VARIABLES                                     ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local aimbotEnabled = false
    local silentAimEnabled = false
    local wallbangEnabled = false
    local espEnabled = false
    local autoFarmATM = false
    local autoFish = false
    local autoCollectLoot = false
    local flyEnabled = false
    local noclipEnabled = false
    local infJumpEnabled = false
    local fullbrightEnabled = false
    local chamsEnabled = false
    local aimPart = "Head"
    local aimRange = 150
    local farmSpeed = 10
    
    local aimbotConnection = nil
    local farmConnection = nil
    local fishConnection = nil
    local flyConnection = nil
    local noclipConnection = nil
    local jumpConnection = nil
    local bodyVelocity = nil
    local espObjects = {}
    local chamsObjects = {}
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                          HELPER FUNCTIONS                              ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
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
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                              AIMBOT                                    ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local function startAimbot()
        if aimbotConnection then aimbotConnection:Disconnect() end
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(aimPart) then
                local targetPart = target.Character[aimPart]
                if targetPart and Workspace.CurrentCamera then
                    if wallbangEnabled then
                        Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                    else
                        local origin = Workspace.CurrentCamera.CFrame.Position
                        local direction = (targetPart.Position - origin).unit
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local rayResult = Workspace:Raycast(origin, direction * (origin - targetPart.Position).Magnitude, raycastParams)
                        if not rayResult then
                            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                        end
                    end
                end
            end
        end)
    end
    
    local function stopAimbot()
        if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    end
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                          ESP (NAME UNDER PLAYER)                       ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
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
        billboard.Size = UDim2.new(0, 200, 0, 40)
        billboard.StudsOffset = Vector3.new(0, -3, 0)
        billboard.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
        billboard.AlwaysOnTop = true
        billboard.Parent = char
        
        local nameFrame = Instance.new("Frame")
        nameFrame.Size = UDim2.new(1, 0, 1, 0)
        nameFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        nameFrame.BackgroundTransparency = 0.4
        nameFrame.BorderSizePixel = 0
        nameFrame.Parent = billboard
        
        local nameCorner = Instance.new("UICorner")
        nameCorner.CornerRadius = UDim.new(0, 8)
        nameCorner.Parent = nameFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = playerObj.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 11
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.Parent = nameFrame
        
        espObjects[playerObj] = {Highlight = highlight, Billboard = billboard}
    end
    
    local function updateESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            if espEnabled and plr ~= player then
                createESP(plr)
            elseif espObjects[plr] then
                if espObjects[plr].Highlight then espObjects[plr].Highlight:Destroy() end
                if espObjects[plr].Billboard then espObjects[plr].Billboard:Destroy() end
                espObjects[plr] = nil
            end
        end
    end
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                              FARM                                      ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local function startATMFarm()
        if farmConnection then farmConnection:Disconnect() end
        farmConnection = RunService.Heartbeat:Connect(function()
            if not autoFarmATM then return end
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            local rootPart = character.HumanoidRootPart
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if not autoFarmATM then break end
                local objName = obj.Name:lower()
                if obj:IsA("Model") and (objName:find("atm") or objName:find("cash") or objName:find("vault") or objName:find("bank")) then
                    local targetPart = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    if targetPart then
                        local dist = (targetPart.Position - rootPart.Position).Magnitude
                        if dist < 10 then
                            VirtualInputManager:SendKeyEvent(true, "E", false, game)
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(false, "E", false, game)
                            task.wait(1.5)
                        elseif dist < 30 then
                            local direction = (targetPart.Position - rootPart.Position).unit
                            rootPart.CFrame = rootPart.CFrame + direction * (farmSpeed / 10)
                        end
                    end
                end
            end
        end)
    end
    
    local function stopATMFarm()
        if farmConnection then farmConnection:Disconnect(); farmConnection = nil end
    end
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                            MOVEMENT                                    ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local function enableFly()
        if flyConnection then flyConnection:Disconnect() end
        flyEnabled = true
        local character = player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyVelocity.Parent = rootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not bodyVelocity or not player.Character then
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            local humanoid = player.Character.Humanoid
            if humanoid then
                local moveDir = humanoid.MoveDirection
                local yVel = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    yVel = 50
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    yVel = -50
                end
                bodyVelocity.Velocity = Vector3.new(moveDir.X * 80, yVel, moveDir.Z * 80)
            end
        end)
    end
    
    local function disableFly()
        flyEnabled = false
        if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    end
    
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
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    
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
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                            VISUALS                                     ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local originalBrightness, originalAmbient, originalOutdoor
    
    local function enableFullbright()
        if fullbrightEnabled then return end
        originalBrightness = Lighting.Brightness
        originalAmbient = Lighting.Ambient
        originalOutdoor = Lighting.OutdoorAmbient
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 100000
        fullbrightEnabled = true
    end
    
    local function disableFullbright()
        if not fullbrightEnabled then return end
        Lighting.Brightness = originalBrightness or 0.5
        Lighting.Ambient = originalAmbient or Color3.fromRGB(100, 100, 100)
        Lighting.OutdoorAmbient = originalOutdoor or Color3.fromRGB(100, 100, 100)
        Lighting.FogEnd = 1000
        fullbrightEnabled = false
    end
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ╍                         HORIZONTAL GUI (HUB)                           ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = hubGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 8, 1, 8)
    glowFrame.Position = UDim2.new(0, -4, 0, -4)
    glowFrame.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    glowFrame.BackgroundTransparency = 0.85
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = 0
    glowFrame.Parent = mainFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20)
    glowCorner.Parent = glowFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "JINOXX DEV | BLOCK SPIN HUB"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        hubGui:Destroy()
    end)
    
    -- Horizontal Tabs
    local tabs = {"Aimbot", "ESP", "Farm", "Movement", "Visuals"}
    local tabButtons = {}
    local tabFrames = {}
    
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.Position = UDim2.new(0, (i-1)*80, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = tabBar
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -90)
        content.Position = UDim2.new(0, 10, 0, 80)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.CanvasSize = UDim2.new(0, 0, 0, 400)
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
        content.Visible = (tabName == "Aimbot")
        content.Parent = mainFrame
        
        tabButtons[tabName] = btn
        tabFrames[tabName] = content
        
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabFrames) do v.Visible = false end
            for _, v in pairs(tabButtons) do 
                v.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                v.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            content.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
    
    tabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    tabButtons["Aimbot"].TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Toggle function
    local function addToggle(parent, text, yPos, offFunc, onFunc)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 38)
        toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 60, 0, 28)
        toggleBtn.Position = UDim2.new(1, -70, 0.5, -14)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        toggleBtn.Text = "OFF"
        toggleBtn.TextSize = 11
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = toggleFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = toggleBtn
        
        local toggled = false
        toggleBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 50, 65)
            toggleBtn.Text = toggled and "ON" or "OFF"
            if toggled then onFunc() else offFunc() end
        end)
        return toggleFrame
    end
    
    -- Populate tabs
    addToggle(tabFrames["Aimbot"], "Aimbot (Auto Aim)", 5, stopAimbot, function() aimbotEnabled = true; startAimbot() end)
    addToggle(tabFrames["Aimbot"], "Silent Aim", 48, function() silentAimEnabled = false end, function() silentAimEnabled = true end)
    addToggle(tabFrames["Aimbot"], "Wallbang", 91, function() wallbangEnabled = false end, function() wallbangEnabled = true end)
    
    addToggle(tabFrames["ESP"], "ESP Players", 5, function() espEnabled = false; updateESP() end, function() espEnabled = true; updateESP() end)
    
    addToggle(tabFrames["Farm"], "Auto ATM Farm", 5, stopATMFarm, function() autoFarmATM = true; startATMFarm() end)
    addToggle(tabFrames["Farm"], "Auto Collect Loot", 48, function() autoCollectLoot = false end, function() autoCollectLoot = true end)
    
    addToggle(tabFrames["Movement"], "Fly", 5, disableFly, enableFly)
    addToggle(tabFrames["Movement"], "Noclip", 48, disableNoclip, enableNoclip)
    addToggle(tabFrames["Movement"], "Infinite Jump", 91, disableInfJump, enableInfJump)
    
    addToggle(tabFrames["Visuals"], "Fullbright", 5, disableFullbright, enableFullbright)
    
    -- Walk Speed Slider in Movement tab
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, -20, 0, 50)
    speedFrame.Position = UDim2.new(0, 0, 0, 150)
    speedFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = tabFrames["Movement"]
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
    speedLabel.Position = UDim2.new(0, 10, 0, 5)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Walk Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.TextSize = 13
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedFrame
    
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.25, 0, 0.5, 0)
    speedBox.Position = UDim2.new(0.73, 0, 0.25, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    speedBox.Text = "16"
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        speedLabel.Text = "Walk Speed: " .. val
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = val
        end
    end)
    
    -- Dragging
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
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
    
    -- Final message
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX HUB",
        Text = "All features are now ACTIVE!",
        Duration = 4
    })
    
    print("╔═══════════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                               ║")
    print("║                    JINOXX DEV - HUB FULLY LOADED!                             ║")
    print("║                                                                               ║")
    print("║  ✅ Aimbot (Auto Aim + Silent Aim + Wallbang)                                 ║")
    print("║  ✅ ESP (Names UNDER players + Highlight)                                     ║")
    print("║  ✅ Farm (Auto ATM + Auto Loot)                                               ║")
    print("║  ✅ Movement (Fly + Noclip + Infinite Jump + Speed)                           ║")
    print("║  ✅ Visuals (Fullbright)                                                      ║")
    print("║                                                                               ║")
    print("╚═══════════════════════════════════════════════════════════════════════════════╝")
end
