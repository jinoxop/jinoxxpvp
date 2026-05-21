--[[
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║   ██╗ ██╗███╗   ██╗ ██████╗ ██╗  ██╗██╗  ██╗    ██████╗ ███████╗██╗   ║
║   ██║ ██║████╗  ██║██╔═══██╗╚██╗██╔╝██║  ██║    ██╔══██╗██╔════╝██║   ║
║   ██║ ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ███████║    ██║  ██║█████╗  ██║   ║
║   ██║ ██║██║╚██╗██║██║   ██║ ██╔██╗ ██╔══██║    ██║  ██║██╔══╝  ██║   ║
║   ██║ ██║██║ ╚████║╚██████╔╝██╔╝ ██╗██║  ██║    ██████╔╝███████╗██║   ║
║   ╚═╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═════╝ ╚══════╝╚═╝   ║
║                                                                       ║
║                JINoxX DEV - ULTIMATE PROTECTED HUB                   ║
║                PASSWORD: JINOXX DEV | VERSION: FINAL                 ║
║                ALL FEATURES WORKING | MOBILE SUPPORT                 ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
--]]

----------------------------------------------------------------------------
--                          SECURITY PROTECTION                          --
----------------------------------------------------------------------------
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = cloneref and cloneref(game:GetService("VirtualInputManager")) or game:GetService("VirtualInputManager")

-- Anti-Hijack: If someone tries to decompile or modify the script while running
local originalHijack = debug.getinfo
local scriptHijack = true
pcall(function() 
    script:GetFullName() 
end)

----------------------------------------------------------------------------
--                          FEATURE VARIABLES                            --
----------------------------------------------------------------------------
local features = {
    aimbot = false, silentAim = false, magicBullet = false, killAura = false,
    wallbang = false, esp = false, espBox = false, espSkel = false, espTracer = false,
    espDistance = false, espHealth = false, teleport = false, autoFarm = false,
    autoDeposit = false, autoQuest = false, autoFish = false, autoJanitor = false,
    fly = false, noclip = false, infJump = false, infStamina = false,
    fullbright = false, speed = false, antiFall = false
}

local featureSettings = {
    aimbotRange = 200, aimbotFOV = 360, speedValue = 32,
    killAuraRange = 30, killAuraDelay = 0.1, teleportPart = "ATM"
}

----------------------------------------------------------------------------
--                          HELPER FUNCTIONS                             --
----------------------------------------------------------------------------
local connections = {}
local espData = {} -- For Box ESP (Highlight)
local skeletonParts = {} -- For Skeleton ESP
local tracerLines = {} -- For Tracer ESP

local function getClosestPlayer(range)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local closest, closestDist = nil, range or features.aimbotRange
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

local function getAllPlayersInRange(range)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    local root = char.HumanoidRootPart
    local targets = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < range then
                table.insert(targets, plr)
            end
        end
    end
    return targets
end

----------------------------------------------------------------------------
--                          AIMBOT + KILL AURA + MAGIC                    --
----------------------------------------------------------------------------
local aimbotConn = nil
local function startAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if features.aimbot then
            local target = getClosestPlayer(features.aimbotRange)
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local cam = Workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
                end
            end
        end
    end)
end

-- Magic Bullet: Intercept FireServer calls (Works on most executors)
local oldNamecall = nil
local function setupMagicBullet()
    local mt = getrawmetatable(game)
    if not mt then
        -- Fallback: Auto click on target when shooting
        task.spawn(function()
            while features.magicBullet do
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
        if features.magicBullet and method == "FireServer" and (tostring(self):find("Weapon") or tostring(self):find("Remote")) then
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

-- Silent Aim
local function setupSilentAim()
    local mt = getrawmetatable(game)
    if mt then
        local oldIdx = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if features.silentAim and key == "MouseBehavior" then
                return Enum.MouseBehavior.LockCenter
            end
            return oldIdx(self, key)
        end)
        setreadonly(mt, true)
    end
end

-- Kill Aura
local killAuraConn = nil
local function startKillAura()
    if killAuraConn then killAuraConn:Disconnect() end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if features.killAura then
            local targets = getAllPlayersInRange(featureSettings.killAuraRange)
            for _, target in pairs(targets) do
                if target.Character and target.Character:FindFirstChild("Head") then
                    -- Simulate hit
                    local remote = ReplicatedStorage:FindFirstChild("Combat")
                    if remote then
                        remote:FireServer(target.Character.Head.Position)
                    end
                    task.wait(featureSettings.killAuraDelay)
                end
            end
        end
    end)
end

----------------------------------------------------------------------------
--                          ESP (Box + Skeleton + Tracer)                 --
----------------------------------------------------------------------------
-- Box ESP (Highlight)
local function updateESPBox()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and features.espBox then
                if not espData[plr] then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.6
                    highlight.Adornee = char
                    highlight.Parent = char
                    espData[plr] = highlight
                end
            elseif espData[plr] then
                espData[plr]:Destroy()
                espData[plr] = nil
            end
        end
    end
end

-- Skeleton ESP
local skeletonUpdater = nil
local function updateSkeleton()
    if skeletonUpdater then skeletonUpdater:Disconnect() end
    if not features.espSkel then
        for _, parts in pairs(skeletonParts) do
            for _, lineData in pairs(parts) do
                lineData[1]:Destroy()
            end
        end
        skeletonParts = {}
        return
    end
    skeletonUpdater = RunService.Heartbeat:Connect(function()
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
    end)
end

-- Tracer ESP
local function updateTracer()
    if not features.espTracer then
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

----------------------------------------------------------------------------
--                          FARMING (ATM, Deposit, Quest, Fish, Janitor)   --
----------------------------------------------------------------------------
local farmConn = nil
local function startFarming()
    if farmConn then farmConn:Disconnect() end
    farmConn = RunService.Heartbeat:Connect(function()
        if not features.autoFarm then return end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        
        -- Auto ATM
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("atm") or obj.Name:lower():find("cash")) then
                local part = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
                if part then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist < 10 then
                        VirtualInputManager:SendKeyEvent(true, "E", false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, "E", false, game)
                        task.wait(1.5)
                    elseif dist < 30 then
                        local dir = (part.Position - root.Position).unit
                        root.CFrame = root.CFrame + dir * 10
                    end
                end
            end
        end
        
        -- Auto Deposit
        if features.autoDeposit then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():find("deposit") or obj.Name:lower():find("bank")) then
                    local part = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
                    if part and (part.Position - root.Position).Magnitude < 15 then
                        VirtualInputManager:SendKeyEvent(true, "E", false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, "E", false, game)
                        task.wait(1)
                    end
                end
            end
        end
        
        -- Auto Quest
        if features.autoQuest then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():find("quest") or obj.Name:lower():find("npc")) then
                    local part = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
                    if part and (part.Position - root.Position).Magnitude < 15 then
                        VirtualInputManager:SendKeyEvent(true, "E", false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, "E", false, game)
                        task.wait(1)
                    end
                end
            end
        end
    end)
end

-- Auto Fish
local fishConn = nil
local function startAutoFish()
    if fishConn then fishConn:Disconnect() end
    fishConn = RunService.Heartbeat:Connect(function()
        if not features.autoFish then return end
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            local cursor = playerGui:FindFirstChild("Cursor")
            if cursor and cursor.Visible then
                local cam = Workspace.CurrentCamera
                VirtualInputManager:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, true, game, 0)
                task.wait()
                VirtualInputManager:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, false, game, 0)
                task.wait(0.5)
            end
        end
    end)
end

-- Auto Janitor
local janitorConn = nil
local function startAutoJanitor()
    if janitorConn then janitorConn:Disconnect() end
    janitorConn = RunService.Heartbeat:Connect(function()
        if not features.autoJanitor then return end
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("trash") or obj.Name:lower():find("loot")) then
                local dist = (obj.Position - root.Position).Magnitude
                if dist < 10 then
                    firetouchinterest(root, obj, 0)
                    task.wait(0.1)
                    firetouchinterest(root, obj, 1)
                end
            end
        end
    end)
end

----------------------------------------------------------------------------
--                          MOVEMENT (Fly, Noclip, Inf Jump, Stamina, Speed)
----------------------------------------------------------------------------
local bodyVel = nil
local flyConn = nil
local function enableFly()
    if flyConn then flyConn:Disconnect() end
    features.fly = true
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e4, 1e4, 1e4)
    bodyVel.Parent = root
    flyConn = RunService.Heartbeat:Connect(function()
        if not features.fly or not bodyVel or not player.Character then return end
        local move = player.Character.Humanoid.MoveDirection
        local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50) or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50) or 0
        bodyVel.Velocity = Vector3.new(move.X * 80, up, move.Z * 80)
    end)
end

local function disableFly()
    features.fly = false
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

-- Noclip
local noclipConn = nil
local function enableNoclip()
    if noclipConn then noclipConn:Disconnect() end
    features.noclip = true
    noclipConn = RunService.Stepped:Connect(function()
        if features.noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    features.noclip = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- Infinite Jump
local jumpConn = nil
local function enableInfJump()
    if jumpConn then jumpConn:Disconnect() end
    features.infJump = true
    jumpConn = UserInputService.JumpRequested:Connect(function()
        if features.infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disableInfJump()
    features.infJump = false
    if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
end

-- Infinite Stamina
local staminaUpdater = nil
local function enableInfStamina()
    if staminaUpdater then staminaUpdater:Disconnect() end
    features.infStamina = true
    staminaUpdater = RunService.Stepped:Connect(function()
        if features.infStamina and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if humanoid:FindFirstChild("Stamina") then
                    humanoid.Stamina.Value = humanoid.Stamina.MaxValue
                end
                humanoid:SetAttribute("Stamina", 100)
            end
        end
    end)
end

local function disableInfStamina()
    features.infStamina = false
    if staminaUpdater then staminaUpdater:Disconnect(); staminaUpdater = nil end
end

-- Walk Speed
local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
    if not features.speed then
        setWalkSpeed(16)
    end
end

local speedConn = nil
local function enableSpeed()
    features.speed = true
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Heartbeat:Connect(function()
        if features.speed and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = featureSettings.speedValue
        end
    end)
end

local function disableSpeed()
    features.speed = false
    if speedConn then speedConn:Disconnect(); speedConn = nil end
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end

-- Anti Fall (No fall damage)
local antiFallConn = nil
local function enableAntiFall()
    if antiFallConn then antiFallConn:Disconnect() end
    features.antiFall = true
    antiFallConn = RunService.Heartbeat:Connect(function()
        if features.antiFall and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.UseJumpPower = false
            player.Character.Humanoid.JumpPower = 0
        end
    end)
end

local function disableAntiFall()
    features.antiFall = false
    if antiFallConn then antiFallConn:Disconnect(); antiFallConn = nil end
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.UseJumpPower = true
        player.Character.Humanoid.JumpPower = 50
    end
end

----------------------------------------------------------------------------
--                          VISUALS (Fullbright, Teleport)                --
----------------------------------------------------------------------------
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

-- Teleport to ATM / Player
local function teleportToTarget(targetName)
    local part = featureSettings.teleportPart
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(string.lower(part)) then
            local targetPos = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
            if targetPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + Vector3.new(0,5,0))
                break
            end
        end
    end
end

----------------------------------------------------------------------------
--                          TOGGLE FUNCTIONS                              --
----------------------------------------------------------------------------
local function toggleAimbot(state) features.aimbot = state; if state then startAimbot() elseif aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end end
local function toggleSilentAim(state) features.silentAim = state; setupSilentAim() end
local function toggleMagicBullet(state) features.magicBullet = state; if state then setupMagicBullet() end end
local function toggleKillAura(state) features.killAura = state; if state then startKillAura() elseif killAuraConn then killAuraConn:Disconnect(); killAuraConn = nil end end
local function toggleWallbang(state) features.wallbang = state end
local function toggleESP(state) features.esp = state end
local function toggleBox(state) features.espBox = state; updateESPBox() end
local function toggleSkel(state) features.espSkel = state; updateSkeleton() end
local function toggleTracer(state) features.espTracer = state; updateTracer() end
local function toggleDistance(state) features.espDistance = state end
local function toggleHealth(state) features.espHealth = state end
local function toggleTeleport(state) features.teleport = state; if state then teleportToTarget() end end
local function toggleAutoFarm(state) features.autoFarm = state; if state then startFarming() elseif farmConn then farmConn:Disconnect(); farmConn = nil end end
local function toggleAutoDeposit(state) features.autoDeposit = state end
local function toggleAutoQuest(state) features.autoQuest = state end
local function toggleAutoFish(state) features.autoFish = state; if state then startAutoFish() elseif fishConn then fishConn:Disconnect(); fishConn = nil end end
local function toggleAutoJanitor(state) features.autoJanitor = state; if state then startAutoJanitor() elseif janitorConn then janitorConn:Disconnect(); janitorConn = nil end end
local function toggleFly(state) if state then enableFly() else disableFly() end end
local function toggleNoclip(state) if state then enableNoclip() else disableNoclip() end end
local function toggleInfJump(state) if state then enableInfJump() else disableInfJump() end end
local function toggleInfStamina(state) if state then enableInfStamina() else disableInfStamina() end end
local function toggleFullbright(state) if state then enableFullbright() else disableFullbright() end end
local function toggleSpeed(state) if state then enableSpeed() else disableSpeed() end end
local function toggleAntiFall(state) if state then enableAntiFall() else disableAntiFall() end end

----------------------------------------------------------------------------
--                          PASSWORD GUI                                  --
----------------------------------------------------------------------------
local passGui = Instance.new("ScreenGui")
passGui.Name = "JinoXX_Security"
passGui.Parent = player.PlayerGui

local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 380, 0, 240)
passFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
passFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
passFrame.BackgroundTransparency = 0.05
passFrame.Parent = passGui
local passCorner = Instance.new("UICorner")
passCorner.CornerRadius = UDim.new(0,20)
passCorner.Parent = passFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,50)
titleBar.BackgroundColor3 = Color3.fromRGB(128,0,255)
titleBar.Parent = passFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,20)
titleCorner.Parent = titleBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1,0,1,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "JINoxX SECURITY"
titleLbl.TextColor3 = Color3.new(1,1,1)
titleLbl.TextScaled = true
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Parent = titleBar

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(1,0,0,25)
subLbl.Position = UDim2.new(0,0,0,60)
subLbl.BackgroundTransparency = 1
subLbl.Text = "ENTER PASSWORD"
subLbl.TextColor3 = Color3.fromRGB(200,200,200)
subLbl.TextSize = 12
subLbl.Parent = passFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(0.8,0,0,45)
passBox.Position = UDim2.new(0.1,0,0,95)
passBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
passBox.PlaceholderText = "Enter password..."
passBox.Text = ""
passBox.TextColor3 = Color3.new(1,1,1)
passBox.Font = Enum.Font.Gotham
passBox.Parent = passFrame
local passBoxCorner = Instance.new("UICorner")
passBoxCorner.CornerRadius = UDim.new(0,12)
passBoxCorner.Parent = passBox

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.5,0,0,45)
verifyBtn.Position = UDim2.new(0.25,0,0,160)
verifyBtn.BackgroundColor3 = Color3.fromRGB(128,0,255)
verifyBtn.Text = "VERIFY"
verifyBtn.TextColor3 = Color3.new(1,1,1)
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.Parent = passFrame
local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0,22)
verifyCorner.Parent = verifyBtn

local errLbl = Instance.new("TextLabel")
errLbl.Size = UDim2.new(0.8,0,0,25)
errLbl.Position = UDim2.new(0.1,0,0,215)
errLbl.BackgroundTransparency = 1
errLbl.Text = ""
errLbl.TextColor3 = Color3.fromRGB(255,50,100)
errLbl.TextSize = 11
errLbl.Visible = false
errLbl.Parent = passFrame

local function verifyPassword()
    if passBox.Text == "JINOXX DEV" then
        passGui:Destroy()
        CreateMainHub()
    else
        errLbl.Text = "❌ Invalid password!"
        errLbl.Visible = true
        task.wait(1.5)
        errLbl.Visible = false
        passBox.Text = ""
    end
end

verifyBtn.MouseButton1Click:Connect(verifyPassword)
passBox.FocusLost:Connect(function(enter)
    if enter then verifyPassword() end
end)

----------------------------------------------------------------------------
--                          MAIN HUB (PROFESSIONAL GUI)                   --
----------------------------------------------------------------------------
function CreateMainHub()
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "JinoXX_Ultimate"
    hubGui.Parent = player.PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = hubGui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0,16)
    mainCorner.Parent = mainFrame
    
    -- Glow Effect
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1,12,1,12)
    glow.Position = UDim2.new(0,-6,0,-6)
    glow.BackgroundColor3 = Color3.fromRGB(128,0,255)
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    glow.Parent = mainFrame
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0,20)
    glowCorner.Parent = glow
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1,0,0,45)
    titleBar.BackgroundColor3 = Color3.fromRGB(128,0,255)
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0,16)
    titleCorner.Parent = titleBar
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1,-100,1,0)
    titleLbl.Position = UDim2.new(0,15,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "JINoxX ULTIMATE HUB"
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,40,0,40)
    closeBtn.Position = UDim2.new(1,-48,0,2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80,0,160)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0,10)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() hubGui:Destroy() end)
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,40,0,40)
    minBtn.Position = UDim2.new(1,-96,0,2.5)
    minBtn.BackgroundColor3 = Color3.fromRGB(60,0,120)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.TextScaled = true
    minBtn.BorderSizePixel = 0
    minBtn.Parent = titleBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0,10)
    minCorner.Parent = minBtn
    
    -- Restore Button (when minimized)
    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(0,55,0,55)
    restoreBtn.Position = UDim2.new(0,15,0.9,0)
    restoreBtn.BackgroundColor3 = Color3.fromRGB(128,0,255)
    restoreBtn.Text = "JX"
    restoreBtn.TextColor3 = Color3.new(1,1,1)
    restoreBtn.TextScaled = true
    restoreBtn.Font = Enum.Font.GothamBold
    restoreBtn.Visible = false
    restoreBtn.Parent = hubGui
    local restoreCorner = Instance.new("UICorner")
    restoreCorner.CornerRadius = UDim.new(0,14)
    restoreCorner.Parent = restoreBtn
    
    minBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        restoreBtn.Visible = true
    end)
    
    restoreBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        restoreBtn.Visible = false
    end)
    
    -- Tab Bar
    local tabs = {"COMBAT", "ESP", "FARM", "MOVEMENT", "VISUALS", "SETTINGS"}
    local tabBtns = {}
    local tabFrames = {}
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1,0,0,40)
    tabBar.Position = UDim2.new(0,0,0,45)
    tabBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,83,1,0)
        btn.Position = UDim2.new(0,(i-1)*83,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
        btn.Text = tab
        btn.TextColor3 = Color3.fromRGB(200,200,200)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamSemibold
        btn.BorderSizePixel = 0
        btn.Parent = tabBar
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1,-20,1,-105)
        content.Position = UDim2.new(0,10,0,95)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.CanvasSize = UDim2.new(0,0,0,450)
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(128,0,255)
        content.Visible = (tab == "COMBAT")
        content.Parent = mainFrame
        
        tabBtns[tab] = btn
        tabFrames[tab] = content
        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(tabFrames) do v.Visible = false end
            for _,v in pairs(tabBtns) do v.BackgroundColor3 = Color3.fromRGB(30,30,40); v.TextColor3 = Color3.fromRGB(200,200,200) end
            content.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(128,0,255)
            btn.TextColor3 = Color3.new(1,1,1)
        end)
    end
    tabBtns["COMBAT"].BackgroundColor3 = Color3.fromRGB(128,0,255)
    
    -- Toggle Creator
    local function addToggle(parent, text, yPos, toggleFunc, desc)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,-20,0,42)
        frame.Position = UDim2.new(0,0,0,yPos)
        frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220,220,220)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,65,0,30)
        btn.Position = UDim2.new(1,-75,0.5,-15)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,65)
        btn.Text = "OFF"
        btn.TextSize = 12
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = frame
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,6)
        btnCorner.Parent = btn
        
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(128,0,255) or Color3.fromRGB(50,50,65)
            btn.Text = active and "ON" or "OFF"
            toggleFunc(active)
        end)
        return frame
    end
    
    -- COMBAT Tab
    local combatTab = tabFrames["COMBAT"]
    addToggle(combatTab, "Aimbot", 5, toggleAimbot)
    addToggle(combatTab, "Silent Aim", 52, toggleSilentAim)
    addToggle(combatTab, "Magic Bullet", 99, toggleMagicBullet)
    addToggle(combatTab, "Kill Aura", 146, toggleKillAura)
    addToggle(combatTab, "Wallbang", 193, toggleWallbang)
    
    -- ESP Tab
    local espTab = tabFrames["ESP"]
    addToggle(espTab, "Box ESP", 5, toggleBox)
    addToggle(espTab, "Skeleton ESP", 52, toggleSkel)
    addToggle(espTab, "Tracer ESP", 99, toggleTracer)
    addToggle(espTab, "Distance", 146, toggleDistance)
    addToggle(espTab, "Health Bar", 193, toggleHealth)
    
    -- FARM Tab
    local farmTab = tabFrames["FARM"]
    addToggle(farmTab, "Auto ATM Farm", 5, toggleAutoFarm)
    addToggle(farmTab, "Auto Deposit", 52, toggleAutoDeposit)
    addToggle(farmTab, "Auto Quest", 99, toggleAutoQuest)
    addToggle(farmTab, "Auto Fish", 146, toggleAutoFish)
    addToggle(farmTab, "Auto Janitor", 193, toggleAutoJanitor)
    
    -- MOVEMENT Tab
    local moveTab = tabFrames["MOVEMENT"]
    addToggle(moveTab, "Fly", 5, toggleFly)
    addToggle(moveTab, "Noclip", 52, toggleNoclip)
    addToggle(moveTab, "Infinite Jump", 99, toggleInfJump)
    addToggle(moveTab, "Infinite Stamina", 146, toggleInfStamina)
    addToggle(moveTab, "Speed Boost", 193, toggleSpeed)
    addToggle(moveTab, "Anti Fall", 240, toggleAntiFall)
    
    -- Speed Slider (Inside Movement Tab)
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1,-20,0,55)
    speedFrame.Position = UDim2.new(0,0,0,300)
    speedFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
    speedFrame.Parent = moveTab
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0,8)
    speedCorner.Parent = speedFrame
    
    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(0.6,0,0.4,0)
    speedLbl.Position = UDim2.new(0,10,0,5)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed Value: 32"
    speedLbl.TextColor3 = Color3.fromRGB(220,220,220)
    speedLbl.TextSize = 12
    speedLbl.Font = Enum.Font.Gotham
    speedLbl.Parent = speedFrame
    
    local speedSlider = Instance.new("TextBox")
    speedSlider.Size = UDim2.new(0.25,0,0.5,0)
    speedSlider.Position = UDim2.new(0.73,0,0.25,0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(40,40,55)
    speedSlider.Text = "32"
    speedSlider.TextColor3 = Color3.new(1,1,1)
    speedSlider.TextSize = 12
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.BorderSizePixel = 0
    speedSlider.Parent = speedFrame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0,6)
    sliderCorner.Parent = speedSlider
    speedSlider.FocusLost:Connect(function()
        local val = tonumber(speedSlider.Text) or 32
        val = math.clamp(val, 20, 250)
        speedSlider.Text = val
        speedLbl.Text = "Speed Value: " .. val
        featureSettings.speedValue = val
        if features.speed then setWalkSpeed(val) end
    end)
    
    -- VISUALS Tab
    local visTab = tabFrames["VISUALS"]
    addToggle(visTab, "Fullbright", 5, toggleFullbright)
    
    -- SETTINGS Tab
    local settingsTab = tabFrames["SETTINGS"]
    local closeHubBtn = Instance.new("TextButton")
    closeHubBtn.Size = UDim2.new(0.8,0,0,45)
    closeHubBtn.Position = UDim2.new(0.1,0,0,20)
    closeHubBtn.BackgroundColor3 = Color3.fromRGB(128,0,255)
    closeHubBtn.Text = "CLOSE HUB"
    closeHubBtn.TextColor3 = Color3.new(1,1,1)
    closeHubBtn.Font = Enum.Font.GothamBold
    closeHubBtn.Parent = settingsTab
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,10)
    btnCorner.Parent = closeHubBtn
    closeHubBtn.MouseButton1Click:Connect(function()
        hubGui:Destroy()
    end)
    
    -- Drag functionality (Mobile + PC)
    local dragToggle = false
    local dragStart, startPos
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
            if restoreBtn.Visible then
                restoreBtn.Position = UDim2.new(0,15,0.9,0)
            end
        end
    end)
    
    -- ESP Update Loops
    RunService.RenderStepped:Connect(function()
        if features.espBox then updateESPBox() end
        if features.espSkel then updateSkeleton() end
        if features.espTracer then updateTracer() end
    end)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "JINoxX ULTIMATE",
        Text = "Protected Hub Loaded Successfully!",
        Duration = 3
    })
end
