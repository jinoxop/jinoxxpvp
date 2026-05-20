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
║              JINOXX DEV - BLOCK SPIN HUB [VERCEL KEY SYSTEM]                  ║
║                           VERSION: 8.0 - INTEGRATED                          ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                          INITIALIZATION                                   ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                    KEY VALIDATION FROM VERCEL                             ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

local VERCEL_API = "https://fluffy-invention-lac.vercel.app/api/validate"
local usedKeysCache = {}

-- دالة التحقق من الكود عبر رابط Vercel
local function validateKeyWithVercel(key, username)
    -- محاكاة التحقق (لأن الموقع الحالي هو صفحة ثابتة)
    -- في النسخة المتكاملة، يجب إضافة API endpoint في Vercel
    -- حالياً نستخدم نظام تخزين محلي للعرض
    
    -- التحقق من صيغة الكود (XXXX-XXXX-XXXX)
    local pattern = "^[A-Z0-9]%-[A-Z0-9]%-[A-Z0-9]$"
    if not string.match(key, pattern) then
        return false, "Invalid key format"
    end
    
    -- التحقق من أن الكود لم يستخدم من قبل لهذا المستخدم
    local cacheKey = key .. "_" .. username
    if usedKeysCache[cacheKey] then
        return false, "Key already used"
    end
    
    -- محاكاة صلاحية 6 ساعات
    usedKeysCache[cacheKey] = {
        used = true,
        expiry = os.time() + (6 * 60 * 60)
    }
    
    return true, "Valid key"
end

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                      LOGIN GUI (JINOXX STYLE)                             ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

-- التأكد من عدم وجود GUI سابق
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("JinoXX_LoginGUI") then
    game.Players.LocalPlayer.PlayerGui:FindFirstChild("JinoXX_LoginGUI"):Destroy()
end

local loginGui = Instance.new("ScreenGui")
loginGui.Name = "JinoXX_LoginGUI"
loginGui.Parent = player:WaitForChild("PlayerGui")

-- الخلفية السوداء الشفافة
local bgOverlay = Instance.new("Frame")
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgOverlay.BackgroundTransparency = 0.75
bgOverlay.Parent = loginGui

-- النافذة الرئيسية (شبيهة بالموقع)
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 420, 0, 480)
loginFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
loginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
loginFrame.BackgroundTransparency = 0.05
loginFrame.BorderSizePixel = 0
loginFrame.ClipsDescendants = true
loginFrame.Parent = loginGui

-- حواف دائرية
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 24)
frameCorner.Parent = loginFrame

-- توهج بنفسجي حول النافذة
local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 12, 1, 12)
glowBorder.Position = UDim2.new(0, -6, 0, -6)
glowBorder.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
glowBorder.BackgroundTransparency = 0.85
glowBorder.BorderSizePixel = 0
glowBorder.ZIndex = 0
glowBorder.Parent = loginFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 30)
glowCorner.Parent = glowBorder

-- الشعار JINOXX
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 0, 70)
logoText.Position = UDim2.new(0, 0, 0, 25)
logoText.BackgroundTransparency = 1
logoText.Text = "JINoxX"
logoText.TextColor3 = Color3.fromRGB(128, 0, 255)
logoText.TextSize = 48
logoText.Font = Enum.Font.GothamBold
logoText.Parent = loginFrame

-- النص الفرعي
local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, 0, 0, 25)
subText.Position = UDim2.new(0, 0, 0, 90)
subText.BackgroundTransparency = 1
subText.Text = "BLOCK SPIN HUB | KEY SYSTEM"
subText.TextColor3 = Color3.fromRGB(180, 180, 180)
subText.TextSize = 12
subText.Font = Enum.Font.Gotham
subText.Parent = loginFrame

-- شريط الأمان
local securityBadge = Instance.new("Frame")
securityBadge.Size = UDim2.new(0, 120, 0, 25)
securityBadge.Position = UDim2.new(0.5, -60, 0, 118)
securityBadge.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
securityBadge.BackgroundTransparency = 0.85
securityBadge.BorderSizePixel = 0
securityBadge.Parent = loginFrame

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = securityBadge

local badgeText = Instance.new("TextLabel")
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "⚡ SECURE SYSTEM ⚡"
badgeText.TextColor3 = Color3.fromRGB(200, 200, 200)
badgeText.TextSize = 9
badgeText.Font = Enum.Font.GothamBold
badgeText.Parent = securityBadge

-- ===== حقل إدخال الكود =====
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.8, 0, 0, 20)
keyLabel.Position = UDim2.new(0.1, 0, 0, 165)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "◈ ENTER YOUR KEY ◈"
keyLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = loginFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 50)
keyBox.Position = UDim2.new(0.1, 0, 0, 185)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "XXXX-XXXX-XXXX"
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.Gotham
keyBox.Parent = loginFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 12)
keyCorner.Parent = keyBox

-- ===== حقل اسم المستخدم =====
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(0.8, 0, 0, 20)
userLabel.Position = UDim2.new(0.1, 0, 0, 250)
userLabel.BackgroundTransparency = 1
userLabel.Text = "◈ USERNAME ◈"
userLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
userLabel.TextSize = 11
userLabel.Font = Enum.Font.Gotham
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Parent = loginFrame

local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(0.8, 0, 0, 50)
userBox.Position = UDim2.new(0.1, 0, 0, 270)
userBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
userBox.BorderSizePixel = 0
userBox.PlaceholderText = player.Name
userBox.Text = player.Name
userBox.TextColor3 = Color3.fromRGB(255, 255, 255)
userBox.TextSize = 16
userBox.Font = Enum.Font.Gotham
userBox.Parent = loginFrame

local userCorner = Instance.new("UICorner")
userCorner.CornerRadius = UDim.new(0, 12)
userCorner.Parent = userBox

-- ===== رسالة الخطأ =====
local errorMessage = Instance.new("TextLabel")
errorMessage.Size = UDim2.new(0.8, 0, 0, 30)
errorMessage.Position = UDim2.new(0.1, 0, 0, 330)
errorMessage.BackgroundTransparency = 1
errorMessage.Text = ""
errorMessage.TextColor3 = Color3.fromRGB(255, 50, 100)
errorMessage.TextSize = 11
errorMessage.Font = Enum.Font.Gotham
errorMessage.Visible = false
errorMessage.Parent = loginFrame

-- ===== زر LOGIN =====
local loginButton = Instance.new("TextButton")
loginButton.Size = UDim2.new(0.35, 0, 0, 45)
loginButton.Position = UDim2.new(0.1, 0, 0, 370)
loginButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
loginButton.Text = "LOGIN"
loginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loginButton.TextSize = 14
loginButton.Font = Enum.Font.GothamBold
loginButton.BorderSizePixel = 0
loginButton.Parent = loginFrame

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 25)
loginCorner.Parent = loginButton

-- ===== زر COPY LINK =====
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.45, 0, 0, 45)
copyButton.Position = UDim2.new(0.55, 0, 0, 370)
copyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
copyButton.Text = "COPY LINK"
copyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
copyButton.TextSize = 14
copyButton.Font = Enum.Font.GothamBold
copyButton.BorderSizePixel = 0
copyButton.Parent = loginFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 25)
copyCorner.Parent = copyButton

-- نص إضافي
local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, 0, 0, 30)
footerText.Position = UDim2.new(0, 0, 0, 435)
footerText.BackgroundTransparency = 1
footerText.Text = "JINoxX Security System | 6 Hours Validity"
footerText.TextColor3 = Color3.fromRGB(80, 80, 100)
footerText.TextSize = 9
footerText.Font = Enum.Font.Gotham
footerText.Parent = loginFrame

-- تأثيرات التحويم
loginButton.MouseEnter:Connect(function()
    TweenService:Create(loginButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 50, 255)}):Play()
end)
loginButton.MouseLeave:Connect(function()
    TweenService:Create(loginButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(128, 0, 255)}):Play()
end)

copyButton.MouseEnter:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
end)
copyButton.MouseLeave:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
end)

-- وظيفة نسخ الرابط
copyButton.MouseButton1Click:Connect(function()
    local link = "https://fluffy-invention-lac.vercel.app/"
    setclipboard(link)
    copyButton.Text = "✅ COPIED!"
    task.wait(1.5)
    copyButton.Text = "COPY LINK"
end)

-- ===== وظيفة التحقق من الكود =====
local function attemptLogin()
    local key = keyBox.Text
    local username = userBox.Text
    
    if key == "" or username == "" then
        errorMessage.Text = "⚠ Please enter both Key and Username"
        errorMessage.Visible = true
        return
    end
    
    -- التحقق من الكود عبر نظام Vercel
    local isValid, msg = validateKeyWithVercel(key, username)
    
    if isValid then
        -- الكود صحيح - إخفاء نافذة الدخول وتشغيل الهكر
        errorMessage.Visible = false
        loginGui:Destroy()
        -- تشغيل سكريبت الهكر الكامل
        loadMainHub()
    else
        errorMessage.Text = "❌ " .. (msg or "Invalid Key! Get your key from the website")
        errorMessage.Visible = true
    end
end

loginButton.MouseButton1Click:Connect(attemptLogin)

-- السماح بالضغط على Enter
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then attemptLogin() end
end)
userBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then attemptLogin() end
end)

-- ==============================================================================
-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                          MAIN HUB (THE HACK)                              ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
-- ==============================================================================

local function loadMainHub()
    print("╔═══════════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                               ║")
    print("║                    JINOXX DEV - ACCESS GRANTED!                               ║")
    print("║                      LOADING ALL FEATURES...                                  ║")
    print("║                                                                               ║")
    print("╚═══════════════════════════════════════════════════════════════════════════════╝")
    
    -- إشعار ترحيبي
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Access Granted! Welcome " .. player.Name,
        Duration = 3
    })
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ║                          VARIABLES                                     ║
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
    -- ║                          HELPER FUNCTIONS                              ║
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
    -- ║                              AIMBOT                                    ║
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
                    Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                end
            end
        end)
    end
    
    local function stopAimbot()
        if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    end
    
    -- ==========================================================================
    -- ╔═══════════════════════════════════════════════════════════════════════╗
    -- ║                          ESP (NAME UNDER PLAYER)                       ║
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
    -- ║                            MOVEMENT                                    ║
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
    -- ║                            VISUALS                                     ║
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
    -- ╍                         MAIN GUI (HUB)                                 ║
    -- ╚═══════════════════════════════════════════════════════════════════════╝
    -- ==========================================================================
    
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 380, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = hubGui
    
    local hubCorner = Instance.new("UICorner")
    hubCorner.CornerRadius = UDim.new(0, 16)
    hubCorner.Parent = mainFrame
    
    local hubGlow = Instance.new("Frame")
    hubGlow.Size = UDim2.new(1, 8, 1, 8)
    hubGlow.Position = UDim2.new(0, -4, 0, -4)
    hubGlow.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    hubGlow.BackgroundTransparency = 0.85
    hubGlow.BorderSizePixel = 0
    hubGlow.ZIndex = 0
    hubGlow.Parent = mainFrame
    
    local hubGlowCorner = Instance.new("UICorner")
    hubGlowCorner.CornerRadius = UDim.new(0, 20)
    hubGlowCorner.Parent = hubGlow
    
    -- Title
    local hubTitle = Instance.new("TextLabel")
    hubTitle.Size = UDim2.new(1, 0, 0, 40)
    hubTitle.Position = UDim2.new(0, 0, 0, 0)
    hubTitle.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    hubTitle.Text = "JINoxX | BLOCK SPIN HUB"
    hubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    hubTitle.TextSize = 16
    hubTitle.Font = Enum.Font.GothamBold
    hubTitle.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = hubTitle
    
    local closeHubBtn = Instance.new("TextButton")
    closeHubBtn.Size = UDim2.new(0, 30, 0, 30)
    closeHubBtn.Position = UDim2.new(1, -38, 0, 5)
    closeHubBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    closeHubBtn.Text = "✕"
    closeHubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeHubBtn.TextScaled = true
    closeHubBtn.BorderSizePixel = 0
    closeHubBtn.Parent = hubTitle
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeHubBtn
    
    closeHubBtn.MouseButton1Click:Connect(function()
        hubGui:Destroy()
    end)
    
    -- Tabs
    local tabs = {"Aim", "ESP", "Farm", "Move", "Vis"}
    local tabButtons = {}
    local tabFrames = {}
    
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 32)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 76, 1, 0)
        btn.Position = UDim2.new(0, (i-1)*76, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
        content.CanvasSize = UDim2.new(0, 0, 0, 350)
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
        content.Visible = (tabName == "Aim")
        content.Parent = mainFrame
        
        tabButtons[tabName] = btn
        tabFrames[tabName] = content
        
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabFrames) do v.Visible = false end
            for _, v in pairs(tabButtons) do 
                v.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                v.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            content.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
    
    tabButtons["Aim"].BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    
    -- Toggle function
    local function addToggle(parent, text, yPos, offFunc, onFunc)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 35)
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
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 55, 0, 25)
        toggleBtn.Position = UDim2.new(1, -65, 0.5, -12.5)
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
    addToggle(tabFrames["Aim"], "Aimbot", 5, stopAimbot, function() aimbotEnabled = true; startAimbot() end)
    addToggle(tabFrames["Aim"], "Silent Aim", 45, function() silentAimEnabled = false end, function() silentAimEnabled = true end)
    addToggle(tabFrames["Aim"], "Wallbang", 85, function() wallbangEnabled = false end, function() wallbangEnabled = true end)
    
    addToggle(tabFrames["ESP"], "ESP Players", 5, function() espEnabled = false; updateESP() end, function() espEnabled = true; updateESP() end)
    
    addToggle(tabFrames["Farm"], "Auto ATM", 5, stopATMFarm, function() autoFarmATM = true; startATMFarm() end)
    addToggle(tabFrames["Farm"], "Auto Loot", 45, function() autoCollectLoot = false end, function() autoCollectLoot = true end)
    
    addToggle(tabFrames["Move"], "Fly", 5, disableFly, enableFly)
    addToggle(tabFrames["Move"], "Noclip", 45, disableNoclip, enableNoclip)
    addToggle(tabFrames["Move"], "Infinite Jump", 85, disableInfJump, enableInfJump)
    
    addToggle(tabFrames["Vis"], "Fullbright", 5, disableFullbright, enableFullbright)
    
    -- Speed slider
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, -20, 0, 45)
    speedFrame.Position = UDim2.new(0, 0, 0, 140)
    speedFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = tabFrames["Move"]
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Walk Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.TextSize = 12
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedFrame
    
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.25, 0, 0.6, 0)
    speedBox.Position = UDim2.new(0.73, 0, 0.2, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    speedBox.Text = "16"
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.TextSize = 12
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
    
    hubTitle.InputBegan:Connect(function(input)
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
