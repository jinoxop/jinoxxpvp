-- JINOXX DEV - ULTIMATE ESP + SKELETON + MOBILE DRAG (PASSWORD: JINOXX DEV)
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

-- ------------------- MAIN HUB (HORIZONTAL + MOBILE DRAG + MINIMIZE BUTTON) -------------------
function CreateMainHub()
    -- المتغيرات العامة للميزات
    local aimbot = false
    local espEnabled = false
    local espBox = false
    local espName = false
    local espDistance = false
    local espSkeleton = false
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
    local espData = {} -- لكل لاعب: {highlight, boxAdornments, skeletonParts, nameBillboard}
    local origLight = {Brightness = Lighting.Brightness, Ambient = Lighting.Ambient, Outdoor = Lighting.OutdoorAmbient}

    -- Helper: الحصول على أقرب لاعب
    local function getClosestPlayer()
        local pl = player.Character
        if not pl or not pl:FindFirstChild("HumanoidRootPart") then return end
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

    -- Aimbot
    local function startAimbot()
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(function()
            if not aimbot then return end
            local target = getClosestPlayer()
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

    -- Auto ATM Farm
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

    -- Fly
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

    -- Noclip
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

    -- Infinite Jump
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

    -- Fullbright
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

    -- ======================== ESP (ADVANCED: BOX, NAME UNDER, DISTANCE, SKELETON) ========================
    local function getCharacterParts(character)
        local parts = {}
        if character:FindFirstChild("Head") then table.insert(parts, character.Head) end
        if character:FindFirstChild("UpperTorso") then table.insert(parts, character.UpperTorso)
        elseif character:FindFirstChild("Torso") then table.insert(parts, character.Torso) end
        if character:FindFirstChild("HumanoidRootPart") then table.insert(parts, character.HumanoidRootPart) end
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") and not table.find(parts, v) then
                table.insert(parts, v)
            end
        end
        return parts
    end

    -- إنشاء صندوق (Box ESP) باستخدام BoxHandleAdornment على HumanoidRootPart
    local function createBox(character, color)
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(4, 5, 2) -- حجم تقريبي للشخص
        box.CFrame = root.CFrame
        box.Color3 = color
        box.Transparency = 0.6
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = root
        return box
    end

    local function updateBox(box, root)
        if box and root then
            box.CFrame = root.CFrame
        end
    end

    -- إنشاء Name Billboard أسفل اللاعب (صغير)
    local function createNameBillboard(character, playerName, distance)
        local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        if not root then return nil end
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 200, 0, 40)
        bill.StudsOffset = Vector3.new(0, -3, 0)
        bill.Adornee = root
        bill.AlwaysOnTop = true
        bill.Parent = root
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BackgroundTransparency = 0.4
        frame.Parent = bill
        
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, 0, 0.6, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = playerName
        nameLbl.TextColor3 = Color3.new(1, 1, 1)
        nameLbl.TextSize = 11
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.Parent = frame
        
        local distLbl = Instance.new("TextLabel")
        distLbl.Size = UDim2.new(1, 0, 0.4, 0)
        distLbl.Position = UDim2.new(0, 0, 0.6, 0)
        distLbl.BackgroundTransparency = 1
        distLbl.Text = math.floor(distance) .. " studs"
        distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLbl.TextSize = 9
        distLbl.Font = Enum.Font.Gotham
        distLbl.Parent = frame
        
        return {billboard = bill, nameLabel = nameLbl, distLabel = distLbl}
    end

    -- Skeleton: رسم خطوط بين المفاصل باستخدام أجزاء رفيعة (Parts)
    local skeletonLines = {} -- لتخزين الأجزاء لكل لاعب
    local function createSkeleton(character)
        local parts = {}
        local getPart = function(name)
            return character:FindFirstChild(name)
        end
        
        local head = getPart("Head")
        local torso = getPart("UpperTorso") or getPart("Torso")
        local root = getPart("HumanoidRootPart")
        local leftArm = getPart("LeftArm") or (character:FindFirstChild("LeftUpperArm"))
        local rightArm = getPart("RightArm") or (character:FindFirstChild("RightUpperArm"))
        local leftLeg = getPart("LeftLeg") or (character:FindFirstChild("LeftLowerLeg"))
        local rightLeg = getPart("RightLeg") or (character:FindFirstChild("RightLowerLeg"))
        
        -- نقاط المفاصل
        local joints = {
            {head, torso}, {torso, root},
            {torso, leftArm}, {torso, rightArm},
            {torso, leftLeg}, {torso, rightLeg}
        }
        
        for _, joint in pairs(joints) do
            local a, b = joint[1], joint[2]
            if a and b then
                local line = Instance.new("Part")
                line.Size = Vector3.new(0.2, 0.2, (a.Position - b.Position).Magnitude)
                line.CFrame = CFrame.new(a.Position, b.Position) * CFrame.new(0, 0, -line.Size.Z/2)
                line.Anchored = true
                line.CanCollide = false
                line.BrickColor = BrickColor.new("Bright red")
                line.Material = Enum.Material.Neon
                line.Parent = character
                table.insert(parts, line)
            end
        end
        return parts
    end
    
    local function updateSkeleton(skeletonParts, character)
        local function getPos(partName)
            local p = character:FindFirstChild(partName)
            return p and p.Position
        end
        local head = getPos("Head")
        local torso = getPos("UpperTorso") or getPos("Torso")
        local root = getPos("HumanoidRootPart")
        local leftArm = getPos("LeftArm") or getPos("LeftUpperArm")
        local rightArm = getPos("RightArm") or getPos("RightUpperArm")
        local leftLeg = getPos("LeftLeg") or getPos("LeftLowerLeg")
        local rightLeg = getPos("RightLeg") or getPos("RightLowerLeg")
        
        local points = {head, torso, root, leftArm, rightArm, leftLeg, rightLeg}
        local expected = 7
        if #points ~= expected then return end
        
        local connections = {
            {1,2}, {2,3}, {2,4}, {2,5}, {2,6}, {2,7}
        }
        for idx, conn in pairs(connections) do
            local a = points[conn[1]]
            local b = points[conn[2]]
            if a and b and skeletonParts[idx] then
                local dist = (a - b).Magnitude
                local mid = (a + b)/2
                skeletonParts[idx].Size = Vector3.new(0.2, 0.2, dist)
                skeletonParts[idx].CFrame = CFrame.new(mid, b) * CFrame.new(0, 0, -dist/2)
            end
        end
    end

    -- تحديث ESP لجميع اللاعبين
    local function updateAllESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == player then continue end
            local char = plr.Character
            if not char then
                if espData[plr] then
                    for _, v in pairs(espData[plr]) do if v then v:Destroy() end end
                    espData[plr] = nil
                end
                continue
            end
            
            if not espEnabled then
                if espData[plr] then
                    for _, v in pairs(espData[plr]) do if v then v:Destroy() end end
                    espData[plr] = nil
                end
                continue
            end
            
            if not espData[plr] then espData[plr] = {} end
            local data = espData[plr]
            
            -- Box
            if espBox and not data.box then
                data.box = createBox(char, Color3.fromRGB(255, 0, 0))
            elseif not espBox and data.box then
                data.box:Destroy(); data.box = nil
            end
            
            -- Name + Distance Billboard
            if espName or espDistance then
                if not data.billboard then
                    local rootPos = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or char:FindFirstChild("Head").Position
                    local dist = (rootPos - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude
                    data.billboard = createNameBillboard(char, plr.Name, dist)
                else
                    -- تحديث المسافة
                    local rootPos = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or (char:FindFirstChild("Head") and char.Head.Position)
                    if rootPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (rootPos - player.Character.HumanoidRootPart.Position).Magnitude
                        if data.billboard.distLabel then
                            data.billboard.distLabel.Text = math.floor(dist) .. " studs"
                        end
                    end
                    -- إظهار/إخفاء الاسم والمسافة حسب الخيارات
                    if data.billboard.nameLabel then
                        data.billboard.nameLabel.Visible = espName
                    end
                    if data.billboard.distLabel then
                        data.billboard.distLabel.Visible = espDistance
                    end
                end
            else
                if data.billboard then
                    data.billboard.billboard:Destroy()
                    data.billboard = nil
                end
            end
            
            -- Skeleton
            if espSkeleton then
                if not data.skeleton then
                    data.skeleton = createSkeleton(char)
                else
                    updateSkeleton(data.skeleton, char)
                end
            else
                if data.skeleton then
                    for _, line in pairs(data.skeleton) do line:Destroy() end
                    data.skeleton = nil
                end
            end
            
            -- تحديث موقع الصندوق
            if data.box and char:FindFirstChild("HumanoidRootPart") then
                updateBox(data.box, char.HumanoidRootPart)
            end
        end
    end

    -- تشغيل حلقة تحديث ESP
    local espLoop
    local function startEspLoop()
        if espLoop then espLoop:Disconnect() end
        espLoop = RunService.Heartbeat:Connect(function()
            if espEnabled then
                updateAllESP()
            end
        end)
    end
    startEspLoop()

    -- عند إضافة لاعب جديد
    Players.PlayerAdded:Connect(function(plr)
        task.wait(0.5)
        updateAllESP()
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if espData[plr] then
            for _, v in pairs(espData[plr]) do if v then v:Destroy() end end
            espData[plr] = nil
        end
    end)

    -- ------------------- GUI (HORIZONTAL + MOBILE DRAG + MINIMIZE) -------------------
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Hub"
    hubGui.Parent = player.PlayerGui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 480) -- ارتفاع أكبر لاستيعاب خيارات ESP
    main.Position = UDim2.new(0.5, -210, 0.5, -240)
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
    titleLbl.Size = UDim2.new(1, -100, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "JINOXX DEV | BLOCK SPIN HUB"
    titleLbl.TextColor3 = Color3.new(1, 1, 1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar
    
    -- زر الإغلاق (يخفي القائمة ويظهر زر صغير)
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -80, 0, 2.5)
    close.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.TextScaled = true
    close.BorderSizePixel = 0
    close.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close
    
    -- زر تصغير (Minimize) - يخفي القائمة ويظهر زر صغير لاسترجاعها
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -42, 0, 2.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.TextScaled = true
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minimizeBtn
    
    -- الزر الصغير لاستعادة القائمة
    local restoreButton = Instance.new("TextButton")
    restoreButton.Size = UDim2.new(0, 50, 0, 50)
    restoreButton.Position = UDim2.new(0, 20, 0.5, -25)
    restoreButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    restoreButton.Text = "JX"
    restoreButton.TextColor3 = Color3.new(1, 1, 1)
    restoreButton.TextScaled = true
    restoreButton.Font = Enum.Font.GothamBold
    restoreButton.Visible = false
    restoreButton.Parent = hubGui
    local restoreCorner = Instance.new("UICorner")
    restoreCorner.CornerRadius = UDim.new(0, 12)
    restoreCorner.Parent = restoreButton
    
    -- وظائف الإخفاء والإظهار
    minimizeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        restoreButton.Visible = true
    end)
    restoreButton.MouseButton1Click:Connect(function()
        main.Visible = true
        restoreButton.Visible = false
    end)
    close.MouseButton1Click:Connect(function()
        hubGui:Destroy()
    end)
    
    -- جعل القائمة قابلة للسحب (تعمل بالماوس واللمس)
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end
    
    local function onInputChanged(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    titleBar.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
    UserInputService.InputChanged:Connect(onInputChanged)
    
    -- التبويبات الأفقية
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
        btn.Position = UDim2.new(0, (i-1)*84, 0, 0)
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
        content.CanvasSize = UDim2.new(0, 0, 0, 450)
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
    
    -- دالة إضافة Toggle
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
        return f
    end
    
    -- تعبئة التبويبات
    addToggle(tabFrames["Aim"], "Aimbot", 5, stopAimbot, function() aimbot = true; startAimbot() end)
    
    -- تبويب ESP يحتوي على خيارات متعددة تحت بعضها
    local espParent = tabFrames["ESP"]
    addToggle(espParent, "Master ESP", 5, function() espEnabled = false; updateAllESP() end, function() espEnabled = true; updateAllESP() end)
    addToggle(espParent, "Box ESP", 50, function() espBox = false; updateAllESP() end, function() espBox = true; updateAllESP() end)
    addToggle(espParent, "Name Under", 95, function() espName = false; updateAllESP() end, function() espName = true; updateAllESP() end)
    addToggle(espParent, "Distance", 140, function() espDistance = false; updateAllESP() end, function() espDistance = true; updateAllESP() end)
    addToggle(espParent, "Skeleton", 185, function() espSkeleton = false; updateAllESP() end, function() espSkeleton = true; updateAllESP() end)
    
    addToggle(tabFrames["Farm"], "Auto ATM", 5, stopFarm, function() autoATM = true; startFarm() end)
    addToggle(tabFrames["Move"], "Fly", 5, disableFly, enableFly)
    addToggle(tabFrames["Move"], "Noclip", 50, disableNoclip, enableNoclip)
    addToggle(tabFrames["Move"], "Inf Jump", 95, disableInfJump, enableInfJump)
    addToggle(tabFrames["Vis"], "Fullbright", 5, disableFullbright, enableFullbright)
    
    -- شريط تعديل سرعة المشي
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
    
    -- إشعار التفعيل
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JINoxX",
        Text = "Ultimate Hub Loaded! ESP + Skeleton + Mobile Drag",
        Duration = 4
    })
    print("JINOXX DEV ULTIMATE ESP + SKELETON ACTIVATED")
end
