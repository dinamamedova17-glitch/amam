--!nocheck
-- ============================================================
-- true am am v1.9 - FTAP (SolarisUI Edition)
-- ЧАСТЬ 1: Шапка + Окно + Key System + Defense + Grabs
-- ============================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/katnaa-debug/SolarisUI/refs/heads/main/Library1.lua"))()

local P   = game:GetService("Players")
local U   = game:GetService("UserInputService")
local R   = game:GetService("RunService")
local RS  = game:GetService("ReplicatedStorage")
local LP  = P.LocalPlayer
local Cam = workspace.CurrentCamera
local OrigFOV = Cam.FieldOfView

Library:KeySystem({
    Key = "Hsu67pocoyo8dt",
    Link = "https://discord.gg/trueamam",
    Title = "true am am | Key System",
    Theme = "Default"
})

if game.CoreGui:FindFirstChild("TrueAmAm") then
    game.CoreGui.TrueAmAm:Destroy()
end

local Window = Library:CreateWindow({
    Title = "true am am",
    Theme = "Default",
    ToggleKey = Enum.KeyCode.RightShift,
    ShowWatermark = {
        Enabled = true, Title = true, User = true,
        FPS = true, Time = true, Ping = true
    },
    CustomIcon = "rbxassetid://10884488899",
    BackgroundImage = "rbxassetid://92268118966062"
})

-- ============================================================
-- DEFENSE
-- ============================================================
local DefenseTab = Window:CreateTab("Defense", false, "rbxassetid://111612436681230")

local GrabEvents_Def      = RS:FindFirstChild("GrabEvents")
local SetNetOwner_Def     = GrabEvents_Def and GrabEvents_Def:FindFirstChild("SetNetworkOwner")
local DestroyGrabLine_Def = GrabEvents_Def and GrabEvents_Def:FindFirstChild("DestroyGrabLine")
local CreateGrabLine_Def  = GrabEvents_Def and GrabEvents_Def:FindFirstChild("CreateGrabLine")
local ExtendGrabLine_Def  = GrabEvents_Def and GrabEvents_Def:FindFirstChild("ExtendGrabLine")

local CharEvents_Def    = RS:FindFirstChild("CharacterEvents")
local Struggle_Def      = CharEvents_Def and CharEvents_Def:FindFirstChild("Struggle")
local RagdollRemote_Def = CharEvents_Def and CharEvents_Def:FindFirstChild("RagdollRemote")

local MenuToys_Def   = RS:FindFirstChild("MenuToys")
local SpawnToy_Def   = MenuToys_Def and MenuToys_Def:FindFirstChild("SpawnToyRemoteFunction")
local DestroyToy_Def = MenuToys_Def and MenuToys_Def:FindFirstChild("DestroyToy")

local PlayerEvents_Def    = RS:FindFirstChild("PlayerEvents")
local StickyPartEvent_Def = PlayerEvents_Def and PlayerEvents_Def:FindFirstChild("StickyPartEvent")

-- Anti Grab (Ags)
local antiGrabV1Active = false
local antiGrabV1Task   = nil

DefenseTab:CreateToggle({
    Name = "Anti Grab (Ags)",
    Flag = "AntiGrabV1",
    Default = false,
    Callback = function(Value)
        antiGrabV1Active = Value
        if Value then
            antiGrabV1Task = task.spawn(function()
                while antiGrabV1Active do
                    pcall(function()
                        local isHeld = LP:FindFirstChild("IsHeld")
                        if isHeld and isHeld.Value then
                            local char = LP.Character
                            if char then
                                local hum = char:FindFirstChild("Humanoid")
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hum and hrp then
                                    if Struggle_Def then Struggle_Def:FireServer(LP) end
                                    if RagdollRemote_Def then RagdollRemote_Def:FireServer(hrp, 0.00000000001) end
                                    if hum.Sit then hum.Sit = false end
                                end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        else
            if antiGrabV1Task then task.cancel(antiGrabV1Task) antiGrabV1Task = nil end
        end
    end
})

-- Anti Grab Best
local antiGrabV2Active = false
local antiGrabV2Task   = nil

DefenseTab:CreateToggle({
    Name = "Anti Grab Best (seatless gucci)",
    Flag = "AntiGrabV2",
    Default = false,
    Callback = function(Value)
        antiGrabV2Active = Value
        if Value then
            antiGrabV2Task = task.spawn(function()
                local hkAGSt, hkAGModel, hkPlot = nil, nil, nil
                while antiGrabV2Active do
                    pcall(function()
                        local plr = LP
                        local plotsFolder = workspace:FindFirstChild("Plots")
                        local plotItems   = workspace:FindFirstChild("PlotItems")
                        if plotsFolder then
                            for _, home in pairs(plotsFolder:GetChildren()) do
                                local sign = home:FindFirstChild("PlotSign")
                                if sign then
                                    local owners = sign:FindFirstChild("ThisPlotsOwners")
                                    if owners then
                                        for _, person in pairs(owners:GetChildren()) do
                                            if person.Value == plr.Name then hkPlot = home.Name end
                                        end
                                    end
                                end
                            end
                        end
                        local myFolder = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
                        hkAGModel = myFolder and myFolder:FindFirstChild("InstrumentWoodwindOcarina")
                        if not hkAGModel and hkPlot and plotItems then
                            local pf = plotItems:FindFirstChild(hkPlot)
                            if pf then hkAGModel = pf:FindFirstChild("InstrumentWoodwindOcarina") end
                        end
                        if hkAGModel then
                            if plr.Character then
                                for _, prt in pairs(plr.Character:GetChildren()) do
                                    local po = prt:FindFirstChild("PartOwner")
                                    if po and po.Value ~= "" then
                                        local holdPart = hkAGModel:FindFirstChild("HoldPart")
                                        local holdRemote = holdPart and holdPart:FindFirstChild("HoldItemRemoteFunction")
                                        if holdRemote then
                                            task.spawn(function()
                                                pcall(function() holdRemote:InvokeServer(hkAGModel, plr.Character) end)
                                            end)
                                            if DestroyToy_Def then DestroyToy_Def:FireServer(hkAGModel) end
                                            local hum = plr.Character:FindFirstChild("Humanoid")
                                            if hum then
                                                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                                                hum.AutoRotate = true
                                                if hum.Sit then hum.Sit = false end
                                            end
                                            po.Value = ""
                                        end
                                    end
                                end
                            end
                        else
                            local canSpawn = plr:FindFirstChild("CanSpawnToy")
                            if plr.Character and canSpawn and canSpawn.Value and not hkAGSt then
                                hkAGSt = tick()
                                task.spawn(function()
                                    if SpawnToy_Def then
                                        pcall(function()
                                            SpawnToy_Def:InvokeServer("InstrumentWoodwindOcarina", CFrame.new(1e5, 1e5, 1e5), Vector3.new(0, 0, 0))
                                        end)
                                    end
                                end)
                            elseif hkAGSt and tick() - hkAGSt > 1 and myFolder and not myFolder:FindFirstChild("InstrumentWoodwindOcarina") then
                                hkAGSt = nil
                            end
                            local grabbed = false
                            if plr.Character then
                                for _, prt in pairs(plr.Character:GetChildren()) do
                                    local po = prt:FindFirstChild("PartOwner")
                                    if po and po.Value ~= "" then grabbed = true end
                                end
                            end
                            if grabbed then
                                if Struggle_Def then Struggle_Def:FireServer(plr) end
                                if plr.Character then
                                    local hum = plr.Character:FindFirstChild("Humanoid")
                                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if hum and hrp and RagdollRemote_Def then
                                        RagdollRemote_Def:FireServer(hrp, 0.00000000001)
                                        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                                            if track.Animation.AnimationId == "rbxassetid://7047322890" then track:Stop() end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        else
            if antiGrabV2Task then task.cancel(antiGrabV2Task) antiGrabV2Task = nil end
        end
    end
})

-- Anti Ownership
local antiOwnershipActive = false
local antiOwnershipTask   = nil

DefenseTab:CreateToggle({
    Name = "Anti Ownership",
    Flag = "AntiOwnership",
    Default = false,
    Callback = function(Value)
        antiOwnershipActive = Value
        if Value then
            antiOwnershipTask = task.spawn(function()
                while antiOwnershipActive do
                    pcall(function()
                        local character = LP.Character
                        if character and character:FindFirstChild("Head") then
                            local head = character.Head
                            if head:FindFirstChild("PartOwner") then
                                if Struggle_Def then Struggle_Def:FireServer(LP) end
                                local isHeld = LP:FindFirstChild("IsHeld")
                                while isHeld and isHeld.Value and antiOwnershipActive do task.wait() end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            if antiOwnershipTask then task.cancel(antiOwnershipTask) antiOwnershipTask = nil end
        end
    end
})

-- Anti Ownership 2
local antiOwnership2Task = nil
DefenseTab:CreateToggle({
    Name = "Anti Ownership 2",
    Flag = "AntiOwnership2",
    Default = false,
    Callback = function(Value)
        if Value then
            local isHeld = LP:WaitForChild("IsHeld", 5)
            if not isHeld then return end
            antiOwnership2Task = task.spawn(function()
                while true do
                    isHeld.Changed:Wait()
                    if isHeld.Value then
                        while isHeld.Value do
                            if Struggle_Def then Struggle_Def:FireServer(LP) end
                            task.wait()
                        end
                    end
                end
            end)
        else
            if antiOwnership2Task then task.cancel(antiOwnership2Task) antiOwnership2Task = nil end
        end
    end
})

-- Anti Kick (Shuriken)
local antiKickActive = false
local antiKickTask   = nil

local function AK_GetPlayersInPlots()
    local pi = workspace:FindFirstChild("PlotItems")
    return pi and pi:FindFirstChild("PlayersInPlots")
end

local function AK_ClearKunai()
    local inv = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
    if inv and DestroyToy_Def then
        for _, v in pairs(inv:GetChildren()) do
            if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                pcall(function() DestroyToy_Def:FireServer(v) end)
            end
        end
    end
end

local function AK_GetHRP()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        return LP.Character.HumanoidRootPart
    else
        local character = LP.CharacterAdded:Wait()
        return character:WaitForChild("HumanoidRootPart")
    end
end

local function AK_CheckForHome()
    local playersInPlots = AK_GetPlayersInPlots()
    if not playersInPlots or not playersInPlots:FindFirstChild(LP.Name) then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, v in pairs(plots:GetChildren()) do
        local sign = v:FindFirstChild("PlotSign")
        local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
        if owners then
            for _, b in pairs(owners:GetChildren()) do
                if b.Value == LP.Name then
                    local pi = workspace:FindFirstChild("PlotItems")
                    local folder = pi and pi:FindFirstChild(v.Name)
                    if folder then return true, folder end
                end
            end
        end
    end
    return false
end

local function AK_StickKunai(kunai)
    if not kunai or not kunai:FindFirstChild("StickyPart") then return end
    local currentHRP = AK_GetHRP()
    if not currentHRP then return end
    local soundPart = kunai:FindFirstChild("SoundPart")
    if soundPart and SetNetOwner_Def then
        local po = soundPart:FindFirstChild("PartOwner")
        if not po or po.Value ~= LP.Name then
            SetNetOwner_Def:FireServer(soundPart, soundPart.CFrame)
        end
    end
    local firePart = currentHRP:FindFirstChild("FirePlayerPart") or currentHRP:WaitForChild("FirePlayerPart", 5)
    if firePart and StickyPartEvent_Def then
        StickyPartEvent_Def:FireServer(kunai.StickyPart, firePart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
    end
    for _, obj in pairs(kunai:GetChildren()) do
        if obj:IsA("BasePart") then
            obj.CanTouch, obj.CanCollide, obj.CanQuery = false, false, false
        end
    end
end

local function AK_SpawnToy(name)
    local canSpawn = LP:FindFirstChild("CanSpawnToy")
    if not canSpawn then return nil end
    local t = tick()
    while not canSpawn.Value do
        if not antiKickActive or tick() - t > 5 then return nil end
        task.wait(0.1)
    end
    local currentHRP = AK_GetHRP()
    if currentHRP and SpawnToy_Def then
        task.spawn(function()
            pcall(function()
                SpawnToy_Def:InvokeServer(name, currentHRP.CFrame * CFrame.new(0, 12, 20), Vector3.new(0, 0, 0))
            end)
        end)
    end
    local boolik, house = AK_CheckForHome()
    local inv = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
    local playersInPlots = AK_GetPlayersInPlots()
    if boolik and house then
        return house:WaitForChild(name, 2)
    elseif (not playersInPlots or not playersInPlots:FindFirstChild(LP.Name)) and inv then
        return inv:WaitForChild(name, 2)
    end
    return nil
end

local function AK_MainLoop()
    while antiKickActive do
        task.wait(0.005)
        if not LP.Character or not LP.Character:FindFirstChild("Humanoid") or LP.Character.Humanoid.Health <= 0 then continue end
        local inv = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
        local kunai = inv and inv:FindFirstChild("NinjaShuriken")
        local playersInPlots = AK_GetPlayersInPlots()
        if playersInPlots and playersInPlots:FindFirstChild(LP.Name) then
            local boolik, house = AK_CheckForHome()
            if boolik and house then
                local plots = workspace:FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(house.Name)
                local sign = plot and plot:FindFirstChild("PlotSign")
                if sign and sign.ThisPlotsOwners.Value.TimeRemainingNum.Value > 89 then
                    kunai = AK_SpawnToy("NinjaShuriken")
                    if kunai == nil then continue end
                    kunai.Name = "AntiKick"
                    AK_StickKunai(kunai)
                end
            end
        end
        if not kunai then
            if playersInPlots and playersInPlots:FindFirstChild(LP.Name) then continue end
            kunai = AK_SpawnToy("NinjaShuriken")
            if kunai == nil then continue end
            kunai.Name = "AntiKick"
        end
        repeat
            if kunai and kunai:FindFirstChild("StickyPart") and kunai.StickyPart.CanTouch == true then
                AK_StickKunai(kunai)
                kunai.Name = "AntiKick"
            end
            task.wait(0.3)
        until not kunai or not antiKickActive or not kunai:FindFirstChild("StickyPart") or kunai.StickyPart.CanTouch == false
            or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart")
            or (LP.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20
        if not kunai or not kunai:FindFirstChild("StickyPart") or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart")
            or (LP.Character.HumanoidRootPart.Position - kunai.StickyPart.Position).Magnitude >= 20 then
            AK_ClearKunai()
        end
        pcall(function()
            repeat task.wait(0.05)
            until not antiKickActive or not LP.Character or not LP.Character:FindFirstChild("Humanoid")
                or not kunai or not kunai:FindFirstChild("StickyPart") or not kunai.StickyPart:FindFirstChild("StickyWeld")
                or not kunai.StickyPart.StickyWeld.Part1
            if not kunai or not kunai:FindFirstChild("StickyPart")
                or (LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health <= 0)
                or not kunai["StickyPart"]:FindFirstChild("StickyWeld").Part1 then
                AK_ClearKunai()
            end
        end)
    end
    AK_ClearKunai()
end

DefenseTab:CreateToggle({
    Name = "Anti Kick (Shuriken)",
    Flag = "AntiKick",
    Default = false,
    Callback = function(Value)
        antiKickActive = Value
        if Value then
            antiKickTask = task.spawn(AK_MainLoop)
        else
            AK_ClearKunai()
            if antiKickTask then task.cancel(antiKickTask) antiKickTask = nil end
        end
    end
})

-- Anti Kick (Pencil)
local pencilAntiKickActive = false
local pencilAntiKickTask   = nil
local pencilRespawnConn    = nil

local function spawnPencil()
    local spawnFolder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
    if not spawnFolder then return end
    local pencil = spawnFolder:FindFirstChild("ToolPencil")
    if pencil then return pencil end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp and SpawnToy_Def then
        pcall(function()
            SpawnToy_Def:InvokeServer("ToolPencil", CFrame.new(hrp.CFrame.Position) + Vector3.new(0, 0, 15), Vector3.new(0, 0, 0))
        end)
    end
    return nil
end

local function fixPencil()
    pcall(function()
        local spawnFolder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
        if not spawnFolder then return end
        local pencil = spawnFolder:FindFirstChild("ToolPencil")
        if not pencil then
            pencil = spawnPencil()
            if not pencil then return end
        end
        local char = LP.Character
        if not char then return end
        local torso = char:FindFirstChild("Torso")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (torso and root) then return end
        local stickyPart = pencil:FindFirstChild("StickyPart")
        local soundPart = pencil:FindFirstChild("SoundPart")
        if stickyPart and stickyPart:FindFirstChild("StickyWeld") then
            local weld = stickyPart.StickyWeld
            if weld.Part1 ~= torso then
                local a = soundPart and soundPart.CFrame.Position or Vector3.zero
                local b = root.CFrame.Position
                if (a - b).Magnitude > 20 then
                    pcall(function() DestroyToy_Def:FireServer(pencil) end)
                else
                    if StickyPartEvent_Def then
                        pcall(function()
                            StickyPartEvent_Def:FireServer(stickyPart, torso, CFrame.new(0, -1, 0) * CFrame.Angles(0, math.pi, 0))
                        end)
                    end
                    for _, prt in pairs(pencil:GetChildren()) do
                        if prt:IsA("BasePart") then
                            prt.CanQuery, prt.CanCollide, prt.CanTouch = false, false, false
                        end
                    end
                end
            end
        end
    end)
end

DefenseTab:CreateToggle({
    Name = "Anti Kick (Pencil)",
    Flag = "AntiKickPencil",
    Default = false,
    Callback = function(Value)
        pencilAntiKickActive = Value
        if Value then
            if pencilRespawnConn then pencilRespawnConn:Disconnect() end
            pencilRespawnConn = LP.CharacterAdded:Connect(function()
                task.wait(1)
                if pencilAntiKickActive then fixPencil() end
            end)
            pencilAntiKickTask = task.spawn(function()
                while pencilAntiKickActive do
                    fixPencil()
                    task.wait(0.5)
                end
            end)
        else
            pencilAntiKickActive = false
            if pencilAntiKickTask then task.cancel(pencilAntiKickTask) pencilAntiKickTask = nil end
            if pencilRespawnConn then pencilRespawnConn:Disconnect() pencilRespawnConn = nil end
            local spawnFolder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
            if spawnFolder then
                local pencil = spawnFolder:FindFirstChild("ToolPencil")
                if pencil and DestroyToy_Def then pcall(function() DestroyToy_Def:FireServer(pencil) end) end
            end
        end
    end
})

-- Anti Explosion
local antiExplosionActive     = false
local antiExplosionConnection = nil

DefenseTab:CreateToggle({
    Name = "Anti Explosion",
    Flag = "AntiExplosion",
    Default = false,
    Callback = function(Value)
        antiExplosionActive = Value
        if antiExplosionConnection then
            antiExplosionConnection:Disconnect()
            antiExplosionConnection = nil
        end
        if not Value then return end
        antiExplosionConnection = workspace.ChildAdded:Connect(function(model)
            if not antiExplosionActive then return end
            if model.Name ~= "Part" then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local ok, pos = pcall(function() return model.Position end)
            if not ok then return end
            if (pos - hrp.Position).Magnitude <= 20 then
                local bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.P = 1e6
                bp.D = 5000
                bp.Position = hrp.Position
                bp.Name = "TrueAmAmExplodeFix"
                bp.Parent = hrp
                task.delay(0.25, function()
                    if bp and bp.Parent then bp:Destroy() end
                end)
            end
        end)
    end
})

-- Anti Fire
local antiFireActive = false
local antiFireConn   = nil

local function GetAnyPlotBarrier()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for i = 1, 5 do
        local p = plots:FindFirstChild("Plot" .. i)
        local b = p and p:FindFirstChild("Barrier")
        local pb = b and b:FindFirstChild("PlotBarrier")
        if pb and pb:IsA("BasePart") then return pb end
    end
    return nil
end

DefenseTab:CreateToggle({
    Name = "Anti Fire",
    Flag = "AntiFire",
    Default = false,
    Callback = function(Value)
        antiFireActive = Value
        if antiFireConn then antiFireConn:Disconnect() antiFireConn = nil end
        if not Value then return end
        local char = LP.Character
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        local fireDeb = hum:WaitForChild("FireDebounce", 5)
        if not fireDeb then return end
        antiFireConn = fireDeb.Changed:Connect(function(isBurning)
            if not antiFireActive or not isBurning then return end
            local char2 = LP.Character
            if not char2 then return end
            local hrp = char2:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            char2.PrimaryPart = hrp
            local oldCF = hrp.CFrame
            local pb = GetAnyPlotBarrier()
            if pb then
                pcall(function() char2:SetPrimaryPartCFrame(pb.CFrame * CFrame.new(0, 6, 0)) end)
                task.wait(0.3)
            end
            local firePart = char2:FindFirstChild("FirePlayerPart", true)
            if firePart then
                for _, obj in ipairs(firePart:GetChildren()) do
                    if obj:IsA("Sound") then pcall(function() obj:Stop() end) end
                    if obj:IsA("Light") or obj:IsA("ParticleEmitter") then pcall(function() obj.Enabled = false end) end
                end
                if firePart:FindFirstChild("CanBurn") then
                    pcall(function() firePart.CanBurn.Value = false end)
                end
            end
            if hum:FindFirstChild("FireDebounce") then
                pcall(function() hum.FireDebounce.Value = false end)
            end
            task.wait(0.5)
            if char2 and char2.PrimaryPart and antiFireActive then
                pcall(function() char2:SetPrimaryPartCFrame(oldCF) end)
            end
        end)
    end
})

-- Anti Paint
local antiPaintActive = false
local antiPaintHB     = nil
local paintBackup     = {}

local function RemovePaintParts()
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
                local clone = obj:Clone()
                clone.Archivable = true
                paintBackup[tostring(obj)] = { clone = clone, parent = obj.Parent }
                obj:Destroy()
            end
        end
    end)
end

DefenseTab:CreateToggle({
    Name = "Anti Paint",
    Flag = "AntiPaint",
    Default = false,
    Callback = function(Value)
        antiPaintActive = Value
        if antiPaintHB then antiPaintHB:Disconnect() antiPaintHB = nil end
        if Value then
            RemovePaintParts()
            antiPaintHB = R.Heartbeat:Connect(function()
                if not antiPaintActive then return end
                RemovePaintParts()
            end)
        else
            for _, data in pairs(paintBackup) do
                if data.clone and data.parent then
                    pcall(function() data.clone.Parent = data.parent end)
                end
            end
            paintBackup = {}
        end
    end
})

-- Anti Snowball
local antiSnowballActive = false
local antiSnowballConn   = nil

DefenseTab:CreateToggle({
    Name = "Anti Snowball",
    Flag = "AntiSnowball",
    Default = false,
    Callback = function(Value)
        antiSnowballActive = Value
        if antiSnowballConn then antiSnowballConn:Disconnect() antiSnowballConn = nil end
        if not Value then return end
        antiSnowballConn = workspace.DescendantAdded:Connect(function(obj)
            if not antiSnowballActive then return end
            if obj.Name ~= "BallSnowball" then return end
            task.wait(0.02)
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local p = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
            if not p then return end
            if (p.Position - hrp.Position).Magnitude <= 25 then
                if DestroyToy_Def then pcall(function() DestroyToy_Def:FireServer(obj) end) end
            end
        end)
    end
})

-- Anti Void
local antiVoidActive     = false
local antiVoidConnection = nil

DefenseTab:CreateToggle({
    Name = "Anti Void",
    Flag = "AntiVoidToggle",
    Default = false,
    Callback = function(Value)
        antiVoidActive = Value
        if Value then
            antiVoidConnection = R.Heartbeat:Connect(function()
                if not antiVoidActive then return end
                local char = LP.Character
                if char and char.PrimaryPart then
                    local pos = char.PrimaryPart.Position
                    if pos.Y < -50 then
                        local safePos = Vector3.new(pos.X, pos.Y + 100, pos.Z)
                        char:SetPrimaryPartCFrame(CFrame.new(safePos))
                        char.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end)
        else
            if antiVoidConnection then antiVoidConnection:Disconnect() antiVoidConnection = nil end
        end
    end
})

-- Anti Blob
local hkABlob = false

DefenseTab:CreateToggle({
    Name = "Anti-Blob",
    Flag = "AntiBlob",
    Default = false,
    Callback = function(Value)
        hkABlob = Value
        task.spawn(function()
            while hkABlob do
                if LP.Character then
                    if not LP.Character:FindFirstChild("TruePositionPart") then
                        local tp = Instance.new("Part")
                        tp.Parent   = LP.Character
                        tp.Name     = "TruePositionPart"
                        tp.Anchored = true
                        tp.CFrame   = CFrame.new(0, -100, 0)
                    end
                    for _, prt in pairs(LP.Character:GetChildren()) do
                        if prt:IsA("BasePart") and prt.Massless then prt.Massless = false end
                        if prt.Name == "HumanoidRootPart" and prt:FindFirstChild("RootAttachment") then
                            task.wait(0.1)
                            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                and LP.Character.HumanoidRootPart:FindFirstChild("RootAttachment")
                                and LP.Character:FindFirstChild("TruePositionPart") then
                                LP.Character.HumanoidRootPart.RootAttachment.Parent = LP.Character.TruePositionPart
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
        if not Value and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local tpp = LP.Character:FindFirstChild("TruePositionPart")
            if hrp and tpp and tpp:FindFirstChild("RootAttachment") then
                tpp.RootAttachment.Parent = hrp
            end
        end
    end
})

-- Anti Ragdoll on Blob
local AntiRagBlob = false
local AntiRagConn = nil

local function ApplyAntiRagdoll(char)
    if not char or not AntiRagBlob then return end
    local hum = char:WaitForChild("Humanoid", 5)
    local HRP = char:WaitForChild("HumanoidRootPart", 5)
    if not (hum and HRP) then return end
    if AntiRagConn then AntiRagConn:Disconnect() end
    AntiRagConn = hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
        if hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" then
            if RagdollRemote_Def then RagdollRemote_Def:FireServer(HRP, 3) end
        end
    end)
end

DefenseTab:CreateToggle({
    Name = "Anti Ragdoll (On Blob)",
    Flag = "AntiRagdoll",
    Default = false,
    Callback = function(Value)
        AntiRagBlob = Value
        if AntiRagConn then AntiRagConn:Disconnect() AntiRagConn = nil end
        if Value and LP.Character then pcall(ApplyAntiRagdoll, LP.Character) end
    end
})

LP.CharacterAdded:Connect(function(char)
    if AntiRagBlob then task.wait(1) pcall(ApplyAntiRagdoll, char) end
end)

-- Pos Lock
local posLockActive = false
local posLockConn   = nil
local posLockSaved  = nil

DefenseTab:CreateToggle({
    Name = "Pos Lock",
    Flag = "PosLock",
    Default = false,
    Callback = function(Value)
        posLockActive = Value
        if not Value then
            if posLockConn then posLockConn:Disconnect() posLockConn = nil end
            posLockSaved = nil
            return
        end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then posLockSaved = root.CFrame end
        posLockConn = R.RenderStepped:Connect(function()
            if not posLockActive or not posLockSaved then return end
            local c = LP.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r then
                local assembly = r.AssemblyRootPart or r
                assembly.AssemblyLinearVelocity = Vector3.zero
                assembly.AssemblyAngularVelocity = Vector3.zero
                local offset = assembly.CFrame:ToObjectSpace(r.CFrame)
                assembly.CFrame = posLockSaved * offset:Inverse()
            end
        end)
    end
})

-- Anti Blobman Kill
local antiBlobmanKillConn = nil
local antiBlobmanKillAng  = 0

DefenseTab:CreateToggle({
    Name = "Anti Blobman Kill",
    Flag = "AntiBlobmanKill",
    Default = false,
    Callback = function(Value)
        if Value then
            antiBlobmanKillConn = R.RenderStepped:Connect(function(dt)
                pcall(function()
                    local c = LP.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if root then
                        antiBlobmanKillAng = antiBlobmanKillAng + dt * 9999
                        local rad = math.rad(antiBlobmanKillAng)
                        root.CFrame = CFrame.new(math.cos(rad) * 50000, -100000, math.sin(rad) * 50000)
                    end
                end)
            end)
        else
            if antiBlobmanKillConn then antiBlobmanKillConn:Disconnect() antiBlobmanKillConn = nil end
            antiBlobmanKillAng = 0
        end
    end
})

-- Anti Loop Kill
local antiLoopKillConn = nil

DefenseTab:CreateToggle({
    Name = "Anti Loop Kill",
    Flag = "AntiLoopKill",
    Default = false,
    Callback = function(Value)
        if Value then
            antiLoopKillConn = R.RenderStepped:Connect(function()
                pcall(function()
                    local c = LP.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(280, -4, 465)
                    end
                end)
            end)
        else
            if antiLoopKillConn then antiLoopKillConn:Disconnect() antiLoopKillConn = nil end
        end
    end
})

-- Telekinesis Shield
local telekinesisShieldActive = false
local telekinesisShieldTask   = nil

DefenseTab:CreateToggle({
    Name = "Telekinesis Shield",
    Flag = "TelekinesisShield",
    Default = false,
    Callback = function(Value)
        telekinesisShieldActive = Value
        if not Value then
            if telekinesisShieldTask then task.cancel(telekinesisShieldTask) telekinesisShieldTask = nil end
            return
        end
        telekinesisShieldTask = task.spawn(function()
            while telekinesisShieldActive do
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and SetNetOwner_Def then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if not telekinesisShieldActive then break end
                        if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(char) then
                            if (v.Position - hrp.Position).Magnitude <= 60 then
                                local pushDir = (v.Position - hrp.Position).Unit
                                pcall(function()
                                    SetNetOwner_Def:FireServer(v, v.CFrame)
                                    v.AssemblyLinearVelocity = (pushDir + Vector3.new(0, 0.2, 0)).Unit * 100
                                    v.AssemblyAngularVelocity = Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10))
                                end)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

-- ============================================================
-- НОВЫЕ ФУНКЦИИ DEFENSE (из POLAR HUB / 9rr)
-- ============================================================

-- 1. Fling Aura (отталкивает всех рядом)
local flingAuraActive = false
local flingAuraTask   = nil

DefenseTab:CreateToggle({
    Name = "Fling Aura",
    Flag = "FlingAura",
    Default = false,
    Callback = function(Value)
        flingAuraActive = Value
        if not Value then
            if flingAuraTask then task.cancel(flingAuraTask) flingAuraTask = nil end
            return
        end
        flingAuraTask = task.spawn(function()
            while flingAuraActive do
                pcall(function()
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    for _, plr in ipairs(P:GetPlayers()) do
                        if plr ~= LP and plr.Character then
                            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                            local tHum = plr.Character:FindFirstChild("Humanoid")
                            if tRoot and tHum and tHum.Health > 0 then
                                if (tRoot.Position - hrp.Position).Magnitude <= 30 then
                                    pcall(function()
                                        if SetNetOwner_Def then
                                            SetNetOwner_Def:FireServer(tRoot, tRoot.CFrame)
                                        end
                                        if not tRoot:FindFirstChild("TrueAmAmFlingAura") then
                                            local bv = Instance.new("BodyVelocity")
                                            bv.Name = "TrueAmAmFlingAura"
                                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                            local dir = (tRoot.Position - hrp.Position).Unit
                                            bv.Velocity = Vector3.new(dir.X, 0.5, dir.Z) * 400
                                            bv.Parent = tRoot
                                            game:GetService("Debris"):AddItem(bv, 0.3)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- 2. Death Aura (убивает всех рядом)
local deathAuraActive = false
local deathAuraConn   = nil

DefenseTab:CreateToggle({
    Name = "Death Aura",
    Flag = "DeathAura",
    Default = false,
    Callback = function(Value)
        deathAuraActive = Value
        if deathAuraConn then deathAuraConn:Disconnect() deathAuraConn = nil end
        if not Value then return end
        deathAuraConn = R.Heartbeat:Connect(function()
            pcall(function()
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _, plr in ipairs(P:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        local tHead = plr.Character:FindFirstChild("Head")
                        local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if tRoot and tHead and tHum and tHum.Health > 0 then
                            if (tRoot.Position - hrp.Position).Magnitude <= 25 then
                                pcall(function()
                                    if SetNetOwner_Def then
                                        SetNetOwner_Def:FireServer(tRoot, tRoot.CFrame)
                                        task.wait(0.05)
                                    end
                                    if DestroyGrabLine_Def then
                                        DestroyGrabLine_Def:FireServer(tRoot)
                                    end
                                    if tHead:FindFirstChild("PartOwner") and tHead.PartOwner.Value == LP.Name then
                                        for _, part in pairs(tHum.Parent:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                part.CFrame = CFrame.new(-1e9, 1e9, -1e9)
                                            end
                                        end
                                        local bv = Instance.new("BodyVelocity")
                                        bv.Velocity = Vector3.new(0, -1e7, 0)
                                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                                        bv.P = 1e7
                                        bv.Parent = tRoot
                                        tHum.Sit = false
                                        tHum.Jump = true
                                        tHum.BreakJointsOnDeath = false
                                        tHum:ChangeState(Enum.HumanoidStateType.Dead)
                                        task.delay(2, function()
                                            if bv and bv.Parent then bv:Destroy() end
                                        end)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end)
    end
})

-- 3. Anti Grab Aura (для того, кого схватят)
local antiGrabAuraActive = false
local antiGrabAuraConn   = nil

DefenseTab:CreateToggle({
    Name = "Anti Grab Aura",
    Flag = "AntiGrabAura",
    Default = false,
    Callback = function(Value)
        antiGrabAuraActive = Value
        if antiGrabAuraConn then antiGrabAuraConn:Disconnect() antiGrabAuraConn = nil end
        if not Value then return end
        antiGrabAuraConn = R.Heartbeat:Connect(function()
            if not antiGrabAuraActive then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot and (tRoot.Position - hrp.Position).Magnitude <= 25 then
                        pcall(function()
                            if SetNetOwner_Def then
                                SetNetOwner_Def:FireServer(tRoot, hrp.CFrame)
                            end
                        end)
                    end
                end
            end
        end)
    end
})

-- 4. Anti Fling (нельзя флипнуть)
local antiFlingActive = false
local antiFlingConn   = nil

DefenseTab:CreateToggle({
    Name = "Anti Fling",
    Flag = "AntiFling",
    Default = false,
    Callback = function(Value)
        antiFlingActive = Value
        if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
        if not Value then return end
        antiFlingConn = R.RenderStepped:Connect(function()
            if not antiFlingActive then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local v = hrp.AssemblyLinearVelocity
            if v.Magnitude > 300 or hrp.AssemblyAngularVelocity.Magnitude > 50 then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X * 0.1, v.Y, v.Z * 0.1)
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
})

-- 5. Speed Aura (авто-замедление всех рядом)
local slowAuraActive = false
local slowAuraConn   = nil

DefenseTab:CreateToggle({
    Name = "Slow Aura",
    Flag = "SlowAura",
    Default = false,
    Callback = function(Value)
        slowAuraActive = Value
        if slowAuraConn then slowAuraConn:Disconnect() slowAuraConn = nil end
        if not Value then return end
        slowAuraConn = R.Heartbeat:Connect(function()
            if not slowAuraActive then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(P:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHum and tRoot then
                        if (tRoot.Position - hrp.Position).Magnitude <= 30 then
                            pcall(function() tHum.WalkSpeed = 8 end)
                        end
                    end
                end
            end
        end)
    end
})

-- 6. Anti Lock (если кто-то пытается lock'нуть)
local antiLockActive = false
local antiLockConn   = nil

DefenseTab:CreateToggle({
    Name = "Anti Lock",
    Flag = "AntiLock",
    Default = false,
    Callback = function(Value)
        antiLockActive = Value
        if antiLockConn then antiLockConn:Disconnect() antiLockConn = nil end
        if not Value then return end
        antiLockConn = R.Heartbeat:Connect(function()
            if not antiLockActive then return end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in pairs(hrp:GetChildren()) do
                if (v:IsA("BodyPosition") and v.Name ~= "TrueAmAmExplodeFix")
                or v:IsA("BodyVelocity")
                or v:IsA("BodyAngularVelocity")
                or v:IsA("BodyGyro")
                or v:IsA("AlignPosition")
                or v:IsA("AlignOrientation") then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
    end
})

-- Anti Lag
local ocnAntiLagOn = false

local function SetBeamScript(state)
    pcall(function()
        local ps = LP:FindFirstChild("PlayerScripts")
        if ps then
            local s = ps:FindFirstChild("CharacterAndBeamMove")
            if s then s.Disabled = state end
        end
    end)
end

DefenseTab:CreateToggle({
    Name = "Anti Lag",
    Flag = "AntiLag",
    Default = false,
    Callback = function(Value)
        ocnAntiLagOn = Value
        if Value then
            SetBeamScript(true)
            for _, plr in pairs(P:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("GrabParts") then
                    plr.Character.GrabParts:Destroy()
                end
            end
        else
            SetBeamScript(false)
        end
    end
})

local ocnAutoLagEnabled = false
local ocnFpsThreshold   = 30
local ocnFpsFrames      = 0
local ocnLastFpsCheck   = tick()
local ocnAutoLagStart   = tick()

DefenseTab:CreateToggle({
    Name = "Auto Anti Lag",
    Flag = "AutoAntiLag",
    Default = false,
    Callback = function(Value)
        ocnAutoLagEnabled = Value
        if Value then
            ocnLastFpsCheck = tick() ocnFpsFrames = 0 ocnAutoLagStart = tick()
        end
    end
})

DefenseTab:CreateSlider({
    Name = "Auto Anti Lag FPS Set",
    Flag = "AntiLagFPS",
    Min = 10, Max = 120, Default = 30,
    Suffix = " FPS",
    Callback = function(Value) ocnFpsThreshold = Value end
})

task.spawn(function()
    while task.wait() do
        if ocnAutoLagEnabled then
            if tick() - ocnAutoLagStart < 5 then task.wait()
            else
                ocnFpsFrames = ocnFpsFrames + 1
                local now = tick()
                if now - ocnLastFpsCheck >= 1 then
                    local fps = ocnFpsFrames / (now - ocnLastFpsCheck)
                    ocnFpsFrames = 0 ocnLastFpsCheck = now
                    if fps <= ocnFpsThreshold and not ocnAntiLagOn then
                        ocnAntiLagOn = true SetBeamScript(true)
                    elseif fps > ocnFpsThreshold and ocnAntiLagOn then
                        ocnAntiLagOn = false SetBeamScript(false)
                    end
                end
            end
        end
        task.wait()
    end
end)

-- ============================================================
-- GRABS
-- ============================================================
local GrabsTab = Window:CreateTab("Grabs", false, "rbxassetid://118245294195548")

local lineLagActive    = false
local lineLagTask      = nil
local lineLagIntensity = 150

GrabsTab:CreateToggle({
    Name = "Server Lag Line",
    Flag = "ServerLagLine",
    Default = false,
    Callback = function(Value)
        lineLagActive = Value
        if Value then
            if lineLagTask then task.cancel(lineLagTask) end
            lineLagTask = task.spawn(function()
                while lineLagActive do
                    local players = P:GetPlayers()
                    local createGrabLine = CreateGrabLine_Def
                    if createGrabLine then
                        for _ = 1, lineLagIntensity do
                            for _, player in pairs(players) do
                                if player.Character then
                                    local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                                    if torso then
                                        pcall(function()
                                            createGrabLine:FireServer(torso, torso.CFrame)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if lineLagTask then task.cancel(lineLagTask) lineLagTask = nil end
        end
    end
})

GrabsTab:CreateSlider({
    Name = "Line Lag Intensity",
    Flag = "LagLineIntensity",
    Min = 1, Max = 1000, Default = 150,
    Callback = function(Value) lineLagIntensity = Value end
})

local packetLagActive   = false
local packetLagTask     = nil
local packetLagStrength = 6250

GrabsTab:CreateButton({
    Name = "Send Packet Lag (Once)",
    Callback = function()
        if ExtendGrabLine_Def then
            pcall(function()
                ExtendGrabLine_Def:FireServer(string.rep("x", 100 * packetLagStrength))
            end)
            pcall(function()
                Library:Notify({Title = "true am am", Content = "Packet sent. Strength: " .. packetLagStrength})
            end)
        end
    end
})

GrabsTab:CreateToggle({
    Name = "Packet Lag (Loop)",
    Flag = "PacketLag",
    Default = false,
    Callback = function(Value)
        packetLagActive = Value
        if Value then
            if packetLagTask then task.cancel(packetLagTask) end
            packetLagTask = task.spawn(function()
                while packetLagActive do
                    task.wait(1)
                    if ExtendGrabLine_Def then
                        pcall(function()
                            ExtendGrabLine_Def:FireServer(string.rep("x", 100 * packetLagStrength))
                        end)
                    end
                end
            end)
        else
            if packetLagTask then task.cancel(packetLagTask) packetLagTask = nil end
        end
    end
})

GrabsTab:CreateSlider({
    Name = "Packet Lag Strength",
    Flag = "PacketLagStrength",
    Min = 100, Max = 6250, Default = 6250,
    Callback = function(Value) packetLagStrength = Value end
})

GrabsTab:CreateButton({
    Name = "Stop All Lag",
    Callback = function()
        if lineLagTask then task.cancel(lineLagTask) lineLagTask = nil end
        if packetLagTask then task.cancel(packetLagTask) packetLagTask = nil end
        lineLagActive = false
        packetLagActive = false
    end
})

-- ============================================================
-- ХЕЛПЕРЫ
-- ============================================================
function _G.TrueAmAm_PlayerList()
    local list = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then
            table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    table.sort(list)
    if #list == 0 then table.insert(list, "No players") end
    return list
end

function _G.TrueAmAm_ParseName(Value)
    if not Value then return nil end
    if type(Value) == "table" then
        for k, v in pairs(Value) do
            if v then return _G.TrueAmAm_ParseName(k) end
        end
        return nil
    end
    return Value:match("%(@(.+)%)") or Value
end

_G.TrueAmAm_SelectedTargets     = {}
_G.TrueAmAm_SelectedBlobTargets = {}

-- ============================================================
-- КОНСТРУКТОР Target функций
-- ============================================================
function _G.TrueAmAm_BuildGroupOfBlobMethods(ParentTab, isTarget)

    local DropdownFlag = isTarget and "TargetPlayer" or "BlobTarget"

    local function GetTargetNames()
        local arr = isTarget and _G.TrueAmAm_SelectedTargets or _G.TrueAmAm_SelectedBlobTargets
        if arr and #arr > 0 then return arr end
        local opt = Library.Options and Library.Options[DropdownFlag]
        if opt and opt.Value then
            local name = _G.TrueAmAm_ParseName(opt.Value)
            if name and name ~= "No players" then return { name } end
        end
        return {}
    end

    local function GetFirstTarget()
        for _, name in ipairs(GetTargetNames()) do
            local plr = P:FindFirstChild(name)
            if plr then return plr end
        end
        return nil
    end

    -- Lock Above Me
    local lockAboveActive = false
    local lockAboveTask   = nil

    ParentTab:CreateToggle({
        Name = "Lock Above Me",
        Flag = (isTarget and "TargetLockAbove" or "BlobLockAbove"),
        Default = false,
        Callback = function(Value)
            lockAboveActive = Value
            if not Value then
                if lockAboveTask then task.cancel(lockAboveTask) lockAboveTask = nil end
                for _, uname in ipairs(GetTargetNames()) do
                    local plr = P:FindFirstChild(uname)
                    if plr and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for _, v in pairs(hrp:GetChildren()) do
                                if v:IsA("BodyPosition") and v.Name == "TrueAmAmLockPos" then
                                    v:Destroy()
                                end
                            end
                        end
                    end
                end
                return
            end
            lockAboveTask = task.spawn(function()
                local bodyPositions = {}
                while lockAboveActive do
                    local myChar = LP.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        for _, uname in ipairs(GetTargetNames()) do
                            local target = P:FindFirstChild(uname)
                            if target and target.Character then
                                local tChar = target.Character
                                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                                local tHum  = tChar:FindFirstChild("Humanoid")
                                if tRoot and tHum and tHum.Health > 0 then
                                    local lockCF = myRoot.CFrame * CFrame.new(0, 15, 0)
                                    if SetNetOwner_Def then
                                        pcall(function() SetNetOwner_Def:FireServer(tRoot, lockCF) end)
                                    end
                                    tHum.PlatformStand = true
                                    if tHum.Sit then tHum.Sit = false end
                                    local bp = bodyPositions[tRoot]
                                    if not bp or not bp.Parent then
                                        bp = Instance.new("BodyPosition")
                                        bp.Name = "TrueAmAmLockPos"
                                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        bp.P = 1e6
                                        bp.D = 5000
                                        bp.Parent = tRoot
                                        bodyPositions[tRoot] = bp
                                    end
                                    bp.Position = lockCF.Position
                                    tRoot.AssemblyLinearVelocity = Vector3.zero
                                    tRoot.AssemblyAngularVelocity = Vector3.zero
                                end
                            end
                        end
                    end
                    task.wait(0.03)
                end
                for _, bp in pairs(bodyPositions) do
                    if bp and bp.Parent then bp:Destroy() end
                end
            end)
        end
    })

    -- Loop Kill
    local loopKillActive = false
    local loopKillHB     = nil

    ParentTab:CreateToggle({
        Name = "Loop Kill",
        Flag = (isTarget and "TargetLoopKill" or "BlobLoopKill"),
        Default = false,
        Callback = function(Value)
            loopKillActive = Value
            if loopKillHB then loopKillHB:Disconnect() loopKillHB = nil end
            if not Value then return end
            loopKillHB = R.Heartbeat:Connect(function()
                local target = GetFirstTarget()
                if not target or not target.Character then return end
                local tChar = target.Character
                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                local tHum  = tChar:FindFirstChild("Humanoid")
                local tHead = tChar:FindFirstChild("Head")
                if not (tRoot and tHum and tHead) then return end
                if tHum.Health <= 0 then return end
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                local savedPos = myRoot.CFrame
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                if SetNetOwner_Def then
                    for _ = 1, 3 do
                        pcall(function() SetNetOwner_Def:FireServer(tRoot, tRoot.CFrame) end)
                    end
                end
                task.wait(0.05)
                if DestroyGrabLine_Def then pcall(function() DestroyGrabLine_Def:FireServer(tRoot) end) end
                if tHead:FindFirstChild("PartOwner") and tHead.PartOwner.Value == LP.Name then
                    tHum.Sit = false
                    tHum:ChangeState(Enum.HumanoidStateType.Running)
                    tHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    tHum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    local plr = P:GetPlayerFromCharacter(tChar)
                    if plr and plr:FindFirstChild("IsHeld") then plr.IsHeld.Value = false end
                    local rag = tHum:FindFirstChild("Ragdolled")
                    if rag then rag.Value = false end
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e7, -1e7, 1e7)
                    bv.P = 1e6
                    bv.Velocity = Vector3.new(math.random(-500, 50), -50, math.random(-50, 50))
                    bv.Parent = tRoot
                    local bav = Instance.new("BodyAngularVelocity")
                    bav.MaxTorque = Vector3.new(-1e7, -1e7, -1e7)
                    bav.P = 1e6
                    bav.AngularVelocity = Vector3.new(math.random(-500, 300), math.random(-300, 300), math.random(-500, 500))
                    bav.Parent = tRoot
                    tHum.BreakJointsOnDeath = false
                    tHum:ChangeState(Enum.HumanoidStateType.Dead)
                    task.delay(2, function()
                        if bv.Parent then bv:Destroy() end
                        if bav.Parent then bav:Destroy() end
                    end)
                end
                myRoot.CFrame = savedPos
            end)
        end
    })

    -- Ownership Kick
    local ownershipKickEnabled = false
    local ownershipKickTask    = nil

    ParentTab:CreateToggle({
        Name = "Ownership Kick",
        Flag = (isTarget and "TargetOwnershipKick" or "BlobOwnershipKick"),
        Default = false,
        Callback = function(Value)
            ownershipKickEnabled = Value
            if not Value then
                if ownershipKickTask then task.cancel(ownershipKickTask) ownershipKickTask = nil end
                for _, uname in ipairs(GetTargetNames()) do
                    local plr = P:FindFirstChild(uname)
                    if plr and plr.Character then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot then
                            for _, v in pairs(tRoot:GetChildren()) do
                                if v.Name == "TrueAmAmOwnershipPos"
                                or v.Name == "TrueAmAmOwnershipGyro"
                                or v.Name == "TrueAmAmOwnershipAlign"
                                or v.Name == "TrueAmAmOwnershipAlignRot" then
                                    pcall(function() v:Destroy() end)
                                end
                            end
                        end
                    end
                end
                return
            end
            ownershipKickTask = task.spawn(function()
                local target = GetFirstTarget()
                if not target then return end
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                local savedPos = myRoot.CFrame
                local dragging = false
                local grabStartTime = 0
                local checkStartTime = 0

                local function createBodies(tRoot, lockCF)
                    for _, v in pairs(tRoot:GetChildren()) do
                        if v.Name == "TrueAmAmOwnershipPos"
                        or v.Name == "TrueAmAmOwnershipGyro"
                        or v.Name == "TrueAmAmOwnershipAlign"
                        or v.Name == "TrueAmAmOwnershipAlignRot" then
                            pcall(function() v:Destroy() end)
                        end
                    end
                    local bp = Instance.new("BodyPosition")
                    bp.Name = "TrueAmAmOwnershipPos"
                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bp.P = 1e6
                    bp.D = 5000
                    bp.Position = lockCF.Position
                    bp.Parent = tRoot
                    local bg = Instance.new("BodyGyro")
                    bg.Name = "TrueAmAmOwnershipGyro"
                    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bg.P = 1e6
                    bg.D = 5000
                    bg.CFrame = lockCF
                    bg.Parent = tRoot
                    local att = Instance.new("Attachment")
                    att.Name = "TrueAmAmOwnershipAtt"
                    att.Parent = tRoot
                    local ap = Instance.new("AlignPosition")
                    ap.Name = "TrueAmAmOwnershipAlign"
                    ap.Attachment0 = att
                    ap.Mode = Enum.PositionAlignmentMode.OneAttachment
                    ap.Position = lockCF.Position
                    ap.MaxForce = math.huge
                    ap.Responsiveness = 200
                    ap.Parent = tRoot
                    local ar = Instance.new("AlignOrientation")
                    ar.Name = "TrueAmAmOwnershipAlignRot"
                    ar.Attachment0 = att
                    ar.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    ar.CFrame = lockCF
                    ar.MaxTorque = math.huge
                    ar.Responsiveness = 200
                    ar.Parent = tRoot
                end

                local function cleanupBodies(tRoot)
                    if not tRoot then return end
                    for _, v in pairs(tRoot:GetChildren()) do
                        if v.Name == "TrueAmAmOwnershipPos"
                        or v.Name == "TrueAmAmOwnershipGyro"
                        or v.Name == "TrueAmAmOwnershipAlign"
                        or v.Name == "TrueAmAmOwnershipAlignRot"
                        or v.Name == "TrueAmAmOwnershipAtt" then
                            pcall(function() v:Destroy() end)
                        end
                    end
                end

                while ownershipKickEnabled do
                    local cur = GetFirstTarget()
                    if not cur or not cur.Character then break end
                    local tChar = cur.Character
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    local tHum  = tChar:FindFirstChild("Humanoid")
                    if not (tRoot and tHum and tHum.Health > 0) then
                        dragging = false grabStartTime = 0 checkStartTime = 0
                        cleanupBodies(tRoot)
                        R.Heartbeat:Wait() continue
                    end
                    if not dragging then
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                        cleanupBodies(tRoot)
                        checkStartTime = 0
                        tHum.PlatformStand = true
                        tHum.Sit = true
                        if SetNetOwner_Def then
                            for _ = 1, 3 do
                                pcall(function() SetNetOwner_Def:FireServer(tRoot, tRoot.CFrame) end)
                                pcall(function() SetNetOwner_Def:FireServer(tRoot, myRoot.CFrame) end)
                            end
                        end
                        if DestroyGrabLine_Def then pcall(function() DestroyGrabLine_Def:FireServer(tRoot) end) end
                        if grabStartTime == 0 then grabStartTime = tick() end
                        if tick() - grabStartTime > 0.35 then
                            dragging = true
                            grabStartTime = 0
                            checkStartTime = tick()
                            local lockCF = savedPos * CFrame.new(0, 25, 0)
                            createBodies(tRoot, lockCF)
                        end
                    else
                        myRoot.CFrame = savedPos
                        local lockCF = savedPos * CFrame.new(0, 25, 0)
                        if SetNetOwner_Def then
                            pcall(function() SetNetOwner_Def:FireServer(tRoot, lockCF) end)
                        end
                        if DestroyGrabLine_Def then pcall(function() DestroyGrabLine_Def:FireServer(tRoot) end) end
                        local bp = tRoot:FindFirstChild("TrueAmAmOwnershipPos")
                        if bp then bp.Position = lockCF.Position end
                        local bg = tRoot:FindFirstChild("TrueAmAmOwnershipGyro")
                        if bg then bg.CFrame = lockCF end
                        local ap = tRoot:FindFirstChild("TrueAmAmOwnershipAlign")
                        if ap then ap.Position = lockCF.Position end
                        local ar = tRoot:FindFirstChild("TrueAmAmOwnershipAlignRot")
                        if ar then ar.CFrame = lockCF end
                        tHum.PlatformStand = true
                        tHum.Sit = true
                        tRoot.AssemblyLinearVelocity = Vector3.zero
                        tRoot.AssemblyAngularVelocity = Vector3.zero
                        if checkStartTime > 0 and tick() - checkStartTime > 0.30 then
                            local currentDist = (tRoot.Position - lockCF.Position).Magnitude
                            if currentDist > 15 then
                                dragging = false
                                grabStartTime = 0
                                checkStartTime = 0
                                cleanupBodies(tRoot)
                                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
                            else
                                checkStartTime = tick()
                            end
                        end
                    end
                    R.Heartbeat:Wait()
                end
                for _, uname in ipairs(GetTargetNames()) do
                    local plr = P:FindFirstChild(uname)
                    if plr and plr.Character then                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot then cleanupBodies(tRoot) end
                    end
                end
                if myRoot then myRoot.CFrame = savedPos end
            end)
        end
    })

    -- Oats Kick
    local oatsKickActive = false
    local oatsKickTask   = nil

    ParentTab:CreateToggle({
        Name = "Oats Kick",
        Flag = (isTarget and "TargetOatsKick" or "BlobOatsKick"),
        Default = false,
        Callback = function(Value)
            oatsKickActive = Value
            if not Value then
                if oatsKickTask then task.cancel(oatsKickTask) oatsKickTask = nil end
                return
            end
            if oatsKickTask then task.cancel(oatsKickTask) end
            oatsKickTask = task.spawn(function()
                while oatsKickActive do
                    local myChar = LP.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        for _, uname in ipairs(GetTargetNames()) do
                            local target = P:FindFirstChild(uname)
                            if target and target.Character then
                                local tChar = target.Character
                                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                                local tHum  = tChar:FindFirstChild("Humanoid")
                                if tRoot and tHum and tHum.Health > 0 then
                                    local dist = (tRoot.Position - myRoot.Position).Magnitude
                                    if dist > 25 then
                                        myChar:PivotTo(tRoot.CFrame * CFrame.new(0, 2, 4))
                                    end
                                    if SetNetOwner_Def then
                                        pcall(function() SetNetOwner_Def:FireServer(tRoot, tRoot.CFrame) end)
                                        pcall(function() SetNetOwner_Def:FireServer(tRoot, myRoot.CFrame) end)
                                    end
                                    if DestroyGrabLine_Def then
                                        pcall(function() DestroyGrabLine_Def:FireServer(tRoot) end)
                                    end
                                    if not tRoot:FindFirstChild("TrueAmAmOatsVel") then
                                        local bv = Instance.new("BodyVelocity")
                                        bv.Name = "TrueAmAmOatsVel"
                                        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                                        bv.Velocity = Vector3.new(0, 150, 0)
                                        bv.P = 5000
                                        bv.Parent = tRoot
                                        task.delay(0.3, function()
                                            if bv.Parent then bv:Destroy() end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    })

    -- [AURA] Remove Target Anti Kick
    local removeTargetAntiKickActive = false
    local removeTargetAntiKickTask   = nil

    ParentTab:CreateToggle({
        Name = "[AURA] Remove Target Anti Kick",
        Flag = (isTarget and "TargetRemoveAntiKick" or "BlobRemoveAntiKick"),
        Default = false,
        Callback = function(Value)
            removeTargetAntiKickActive = Value
            if not Value then
                if removeTargetAntiKickTask then task.cancel(removeTargetAntiKickTask) removeTargetAntiKickTask = nil end
                return
            end
            removeTargetAntiKickTask = task.spawn(function()
                while removeTargetAntiKickActive do
                    for _, uname in ipairs(GetTargetNames()) do
                        local target = P:FindFirstChild(uname)
                        if target then
                            local spawned = workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                            if spawned then
                                local toys = {"NinjaKunai", "NinjaShuriken", "AntiKick", "ToolCleaver", "ToolPencil"}
                                for _, toyName in ipairs(toys) do
                                    local toy = spawned:FindFirstChild(toyName)
                                    if toy then
                                        local part = toy:FindFirstChild("SoundPart") or toy:FindFirstChild("StickyPart")
                                        if part and SetNetOwner_Def then
                                            pcall(function()
                                                SetNetOwner_Def:FireServer(part, part.CFrame)
                                                if part:FindFirstChild("PartOwner") and part.PartOwner.Value == LP.Name then
                                                    part.CFrame = CFrame.new(0, 1000, 0)
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    })

    -- [SIT] Remove Target Gucci
    local destroyTargetGucciActive = false
    local destroyTargetGucciTask   = nil

    ParentTab:CreateToggle({
        Name = "[SIT] Remove Target Gucci",
        Flag = (isTarget and "TargetRemoveGucci" or "BlobRemoveGucci"),
        Default = false,
        Callback = function(Value)
            destroyTargetGucciActive = Value
            if not Value then
                if destroyTargetGucciTask then task.cancel(destroyTargetGucciTask) destroyTargetGucciTask = nil end
                return
            end
            destroyTargetGucciTask = task.spawn(function()
                while destroyTargetGucciActive do
                    local target = GetFirstTarget()
                    if target then
                        local folderName = target.Name .. "SpawnedInToys"
                        local toysFolder = workspace:FindFirstChild(folderName)
                        local myChar = LP.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local myHum  = myChar and myChar:FindFirstChild("Humanoid")
                        if toysFolder and myRoot and myHum then
                            local safeSpot = myRoot.CFrame
                            for _, obj in ipairs(toysFolder:GetChildren()) do
                                if not destroyTargetGucciActive then break end
                                if obj.Name == "CreatureBlobman" then
                                    local seat = obj:FindFirstChildWhichIsA("VehicleSeat", true)
                                    if seat then
                                        local t = tick()
                                        repeat
                                            if myHum.SeatPart ~= seat then
                                                myRoot.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
                                                myRoot.Velocity = Vector3.zero
                                                seat:Sit(myHum)
                                            end
                                            R.Heartbeat:Wait()
                                        until myHum.SeatPart == seat or tick() - t > 1.5 or not destroyTargetGucciActive
                                        if myHum.SeatPart == seat then
                                            task.wait(0.3)
                                            myHum.Sit = false
                                            task.wait(0.1)
                                            myRoot.CFrame = safeSpot
                                            task.wait(0.3)
                                            if DestroyToy_Def then pcall(function() DestroyToy_Def:FireServer(obj) end) end
                                        else
                                            myRoot.CFrame = safeSpot
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    })

    -- Pallet Ragdoll
    local palletRagdollActive = false
    local palletCacheConn     = nil
    local palletAttackConn    = nil
    local currentPallet       = nil

    ParentTab:CreateToggle({
        Name = "Pallet Ragdoll (Invis)",
        Flag = (isTarget and "TargetPalletRagdoll" or "BlobPalletRagdoll"),
        Default = false,
        Callback = function(Value)
            palletRagdollActive = Value
            if palletAttackConn then palletAttackConn:Disconnect() palletAttackConn = nil end
            if palletCacheConn then palletCacheConn:Disconnect() palletCacheConn = nil end
            if not Value then
                if currentPallet and currentPallet.Parent and DestroyToy_Def then
                    pcall(function() DestroyToy_Def:FireServer(currentPallet) end)
                end
                currentPallet = nil
                return
            end
            local toysFolder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
            if not toysFolder then return end
            palletCacheConn = toysFolder.ChildAdded:Connect(function(child)
                if not palletRagdollActive then return end
                if child.Name ~= "PalletLightBrown" and child.Name ~= "PalletForRagdoll" then return end
                local soundPart = child:WaitForChild("SoundPart", 3)
                if not soundPart then return end
                if SetNetOwner_Def then pcall(function() SetNetOwner_Def:FireServer(soundPart, soundPart.CFrame) end) end
                if DestroyGrabLine_Def then pcall(function() DestroyGrabLine_Def:FireServer(soundPart) end) end
                local po = soundPart:WaitForChild("PartOwner", 1)
                if po and po.Value == LP.Name then
                    for _, v in pairs(child:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false v.CanQuery = false v.Transparency = 1
                        end
                    end
                    child.Name = "PalletForRagdoll"
                    currentPallet = child
                    local strikePhase = false
                    if palletAttackConn then palletAttackConn:Disconnect() end
                    palletAttackConn = R.Heartbeat:Connect(function()
                        if not palletRagdollActive or not child.Parent then
                            if palletAttackConn then palletAttackConn:Disconnect() palletAttackConn = nil end
                            return
                        end
                        local tgt = GetFirstTarget()
                        local tChar = tgt and tgt.Character
                        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        local tHum  = tChar and tChar:FindFirstChildOfClass("Humanoid")
                        if tRoot and tHum and soundPart.Parent and tHum.Health > 0 then
                            local rag = tHum:FindFirstChild("Ragdolled")
                            local isRag = rag and rag.Value or false
                            if not isRag then
                                strikePhase = not strikePhase
                                if strikePhase then
                                    soundPart.CFrame = tRoot.CFrame * CFrame.new(0, 2, 0)
                                    soundPart.AssemblyLinearVelocity = Vector3.new(0, -9e5, 0)
                                else
                                    soundPart.CFrame = tRoot.CFrame * CFrame.new(0, -1, 0)
                                    soundPart.AssemblyLinearVelocity = Vector3.new(0, 9e5, 0)
                                end
                            else
                                soundPart.CFrame = CFrame.new(0, 9e9, 0)
                                soundPart.AssemblyLinearVelocity = Vector3.zero
                            end
                        else
                            soundPart.CFrame = CFrame.new(0, 9e9, 0)
                            soundPart.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                    child.AncestryChanged:Connect(function()
                        if not child.Parent then
                            currentPallet = nil
                            if palletRagdollActive then
                                task.wait(0.05)
                                if palletRagdollActive and not (currentPallet and currentPallet.Parent) then
                                    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                    if myHRP and SpawnToy_Def then
                                        pcall(function()
                                            SpawnToy_Def:InvokeServer("PalletLightBrown", myHRP.CFrame * CFrame.new(0, 10, 20), Vector3.zero)
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                else
                    if DestroyToy_Def then pcall(function() DestroyToy_Def:FireServer(child) end) end
                end
            end)
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and SpawnToy_Def then
                pcall(function()
                    SpawnToy_Def:InvokeServer("PalletLightBrown", myHRP.CFrame * CFrame.new(0, 10, 20), Vector3.zero)
                end)
            end
        end
    })
end

print("[true am am] Defense + Grabs загружены.")
-- ============================================================
-- true am am v1.9 - ЧАСТЬ 2: Main + Visual + Player + Target + Blob + Keybinds
-- ============================================================

-- MAIN
local MainTab = Window:CreateTab("Main", false, "rbxassetid://13060262582")

MainTab:CreateSection("Информация")

local StartTime = tick()
local InfoLabel = MainTab:CreateLabel({Text = "Загрузка..."})

local function UpdateInfoLabel(text)
    if not InfoLabel then return end
    pcall(function() InfoLabel:SetText(text) end)
    pcall(function() InfoLabel:Set(text) end)
    pcall(function() InfoLabel.Text = text end)
end

task.spawn(function()
    while true do
        task.wait(1)
        local elapsed = math.floor(tick() - StartTime)
        local hrs  = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60
        local timeStr
        if hrs > 0 then timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
        else timeStr = string.format("%02d:%02d", mins, secs) end
        UpdateInfoLabel(string.format(
            "Игрок: %s (@%s)\nСессия: %s\nАккаунт: %d дней\nPlaceId: %d",
            LP.DisplayName, LP.Name, timeStr, LP.AccountAge, game.PlaceId
        ))
    end
end)

MainTab:CreateSection("Управление")

MainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
    end
})

MainTab:CreateButton({
    Name = "[ UNLOAD SCRIPT ]",
    Callback = function()
        if _G.TrueAmAmUnloaded then return end
        _G.TrueAmAmUnloaded = true
        pcall(function()
            if game.CoreGui:FindFirstChild("TrueAmAm") then
                game.CoreGui.TrueAmAm:Destroy()
            end
        end)
        pcall(function()
            for _, gui in ipairs(game.CoreGui:GetChildren()) do
                if gui.Name == "MainUI" or gui.Name == "TrueAmAmKey" or gui.Name == "TrueAmAmAvatarGui" then
                    gui:Destroy()
                end
            end
        end)
        local namesToKill = {
            ["TrueAmAmParticle"]=true,["TrueAmAmParticles"]=true,["TrueAmAmHL"]=true,
            ["TrueAmAmTrail"]=true,["TrueAmAmTrailA0"]=true,["TrueAmAmTrailA1"]=true,
            ["TrueAmAmSG"]=true,["TrueAmAmESP"]=true,["TrueAmAmStickyESP"]=true,
            ["TrueAmAmLockPos"]=true,["TrueAmAmOatsVel"]=true,
            ["TrueAmAmOwnershipPos"]=true,["TrueAmAmOwnershipGyro"]=true,
            ["TrueAmAmOwnershipAlign"]=true,["TrueAmAmOwnershipAlignRot"]=true,
            ["TrueAmAmOwnershipAtt"]=true,["TrueAmAmBlobKickPos"]=true,
            ["TrueAmAmExplodeFix"]=true,["TrueAmAmFlingAura"]=true,
            ["ChinaHat"]=true,["TruePositionPart"]=true,
        }
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if namesToKill[obj.Name] then pcall(function() obj:Destroy() end) end
            end
        end)
        pcall(function()
            for _, p in ipairs(P:GetPlayers()) do
                if p.Character then
                    for _, obj in ipairs(p.Character:GetDescendants()) do
                        if obj:IsA("Highlight") then obj:Destroy() end
                    end
                end
            end
        end)
        pcall(function()
            local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
            if sky then sky:Destroy() end
        end)
        task.wait(0.2)
        pcall(function()
            if Library and Library.Unload then Library:Unload() end
        end)
        task.wait(0.1)
        coroutine.yield()
    end
})

-- VISUAL
local VisualTab = Window:CreateTab("Visual", false, "rbxassetid://13321848342")

VisualTab:CreateSection("ESP")

local espEnabled     = false
local espColor       = Color3.fromRGB(255, 255, 255)
local espRainbow     = false
local espConnections = {}
local espObjects     = {}

local function CreateESP(player)
    if not player or not player.Character then return end
    if espObjects[player] then return end
    local h = Instance.new("Highlight")
    h.Name = "TrueAmAmESP"
    h.FillTransparency = 1
    h.OutlineColor = espColor
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = player.Character
    h.Parent = player.Character
    espObjects[player] = h
end

local function ClearESP()
    for _, h in pairs(espObjects) do pcall(function() h:Destroy() end) end
    espObjects = {}
    for _, c in ipairs(espConnections) do pcall(function() c:Disconnect() end) end
    espConnections = {}
end

local function UpdateESPAll()
    ClearESP()
    if not espEnabled then return end
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then CreateESP(p) end
    end
    table.insert(espConnections, P.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.3)
            if espEnabled then CreateESP(p) end
        end)
        task.wait(0.3)
        if espEnabled then CreateESP(p) end
    end))
    table.insert(espConnections, P.PlayerRemoving:Connect(function(p)
        if espObjects[p] then
            pcall(function() espObjects[p]:Destroy() end)
            espObjects[p] = nil
        end
    end))
end

VisualTab:CreateToggle({
    Name = "Enable ESP", Flag = "ESPEnabled", Default = false,
    Callback = function(v)
        espEnabled = v
        if v then UpdateESPAll() else ClearESP() end
    end
})

VisualTab:CreateColorPicker({
    Name = "ESP Color", Flag = "ESPColor", Default = espColor,
    Callback = function(c)
        espColor = c
        if not espRainbow then
            for _, h in pairs(espObjects) do pcall(function() h.OutlineColor = c end) end
        end
    end
})

VisualTab:CreateToggle({
    Name = "ESP Rainbow", Flag = "ESPRainbow", Default = false,
    Callback = function(v)
        espRainbow = v
        if not v then
            for _, h in pairs(espObjects) do pcall(function() h.OutlineColor = espColor end) end
        end
    end
})

local pcldEnabled = false
local pcldColor   = Color3.fromRGB(255, 60, 60)
local pcldRainbow = false
local pcldBoxes   = {}
local pcldConn    = nil

local function IsPCLD(obj)
    if not obj:IsA("BasePart") then return false end
    local n = string.lower(obj.Name)
    return n == "playercharacterlocationdetector" or n == "partesp"
end

local function AddPCLDBox(obj)
    if pcldBoxes[obj] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = obj box.AlwaysOnTop = true box.ZIndex = 5
    box.Color3 = pcldColor box.Transparency = 0.3 box.Size = obj.Size
    box.Parent = game.CoreGui
    pcldBoxes[obj] = box
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent and pcldBoxes[obj] then
            pcall(function() pcldBoxes[obj]:Destroy() end)
            pcldBoxes[obj] = nil
        end
    end)
end

local function ClearPCLD()
    for _, box in pairs(pcldBoxes) do pcall(function() box:Destroy() end) end
    pcldBoxes = {}
    if pcldConn then pcall(function() pcldConn:Disconnect() end) pcldConn = nil end
end

local function ScanPCLD()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if IsPCLD(obj) then AddPCLDBox(obj) end
    end
end

VisualTab:CreateToggle({
    Name = "Enable PCLD ESP", Flag = "PCLDEnabled", Default = false,
    Callback = function(v)
        pcldEnabled = v
        if v then
            ClearPCLD() ScanPCLD()
            pcldConn = workspace.DescendantAdded:Connect(function(obj)
                if pcldEnabled and IsPCLD(obj) then AddPCLDBox(obj) end
            end)
        else
            ClearPCLD()
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "PCLD ESP Color", Flag = "PCLDColor", Default = pcldColor,
    Callback = function(c)
        pcldColor = c
        if not pcldRainbow then
            for _, box in pairs(pcldBoxes) do pcall(function() box.Color3 = c end) end
        end
    end
})

VisualTab:CreateToggle({
    Name = "PCLD Rainbow", Flag = "PCLDRainbow", Default = false,
    Callback = function(v)
        pcldRainbow = v
        if not v then
            for _, box in pairs(pcldBoxes) do pcall(function() box.Color3 = pcldColor end) end
        end
    end
})

local stickyEspEnabled     = false
local stickyEspColor       = Color3.fromRGB(255, 60, 60)
local stickyEspRainbow     = false
local stickyEspHighlights  = {}
local stickyEspConns       = {}

local function IsStickyPart(obj)
    if not obj:IsA("BasePart") then return false end
    return string.find(string.lower(obj.Name), "sticky") ~= nil
end

local function AddStickyHighlight(part)
    if not part or not part.Parent then return end
    if stickyEspHighlights[part] then return end
    local h = Instance.new("Highlight")
    h.Name = "TrueAmAmStickyESP"
    h.FillColor = stickyEspColor h.FillTransparency = 0.5
    h.OutlineColor = stickyEspColor h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = part h.Parent = part
    stickyEspHighlights[part] = h
    part.AncestryChanged:Connect(function(_, parent)
        if not parent and stickyEspHighlights[part] then
            pcall(function() stickyEspHighlights[part]:Destroy() end)
            stickyEspHighlights[part] = nil
        end
    end)
end

local function ClearStickyHighlights()
    for part, h in pairs(stickyEspHighlights) do pcall(function() h:Destroy() end) end
    stickyEspHighlights = {}
    for _, conn in ipairs(stickyEspConns) do pcall(function() conn:Disconnect() end) end
    stickyEspConns = {}
end

local function ScanHRP(hrp)
    if not hrp then return end
    for _, obj in ipairs(hrp:GetDescendants()) do
        if IsStickyPart(obj) then AddStickyHighlight(obj) end
    end
end

local function HookPlayer(player)
    if player == LP then return end
    local function hookChar(char)
        task.wait(0.2)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        ScanHRP(hrp)
        table.insert(stickyEspConns, hrp.DescendantAdded:Connect(function(obj)
            if stickyEspEnabled and IsStickyPart(obj) then
                task.defer(function()
                    if obj and obj.Parent then AddStickyHighlight(obj) end
                end)
            end
        end))
    end
    if player.Character then hookChar(player.Character) end
    table.insert(stickyEspConns, player.CharacterAdded:Connect(function(c)
        if stickyEspEnabled then hookChar(c) end
    end))
end

VisualTab:CreateToggle({
    Name = "Sticky ESP", Flag = "StickyESP", Default = false,
    Callback = function(v)
        stickyEspEnabled = v
        if v then
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP then
                    local char = p.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then ScanHRP(hrp) end
                    end
                    HookPlayer(p)
                end
            end
            table.insert(stickyEspConns, P.PlayerAdded:Connect(function(p)
                if stickyEspEnabled then HookPlayer(p) end
            end))
            table.insert(stickyEspConns, P.PlayerRemoving:Connect(function(p)
                for part, h in pairs(stickyEspHighlights) do
                    if not part.Parent or (p.Character and part:IsDescendantOf(p.Character)) then
                        pcall(function() h:Destroy() end)
                        stickyEspHighlights[part] = nil
                    end
                end
            end))
        else
            ClearStickyHighlights()
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Sticky ESP Color", Flag = "StickyESPColor", Default = stickyEspColor,
    Callback = function(c)
        stickyEspColor = c
        if not stickyEspRainbow then
            for _, h in pairs(stickyEspHighlights) do
                pcall(function()
                    h.FillColor = c h.OutlineColor = c
                end)
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Sticky ESP Rainbow", Flag = "StickyESPRainbow", Default = false,
    Callback = function(v)
        stickyEspRainbow = v
        if not v then
            for _, h in pairs(stickyEspHighlights) do
                pcall(function()
                    h.FillColor = stickyEspColor h.OutlineColor = stickyEspColor
                end)
            end
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.05)
        local c = Color3.fromHSV(tick() % 1, 1, 1)
        if espRainbow and espEnabled then
            for _, h in pairs(espObjects) do pcall(function() h.OutlineColor = c end) end
        end
        if pcldRainbow and pcldEnabled then
            for _, box in pairs(pcldBoxes) do pcall(function() box.Color3 = c end) end
        end
        if stickyEspRainbow and stickyEspEnabled then
            for _, h in pairs(stickyEspHighlights) do
                pcall(function() h.FillColor = c h.OutlineColor = c end)
            end
        end
    end
end)

-- ПАЛЕТ
VisualTab:CreateSection("Палет")

local CH = Color3.fromRGB(255, 220, 60)
local palG = false
local pnt = {}
local paintBackup2 = {}
local lastCh = 0
local MY = LP.Name .. "SpawnedInToys"

local function isMine(o)
    return o and o.Name == "PalletLightBrown" and o:IsA("Model") and o.Parent and o.Parent.Name == MY
end

local function setColor(c)
    CH = c
    for d, _ in pairs(pnt) do if d and d.Parent then d.Color = c end end
    for _, o in ipairs(workspace:GetDescendants()) do
        if o.Name == "TrueAmAmTrail" and o:IsA("Trail") then o.Color = ColorSequence.new(c) end
    end
end

VisualTab:CreateColorPicker({
    Name = "Цвет палета и следа", Flag = "PalletColor", Default = CH,
    Callback = function(c) setColor(c) end
})

local function paintPart(d)
    if not paintBackup2[d] then paintBackup2[d] = { Color = d.Color, Material = d.Material } end
    d.Color = CH d.Material = Enum.Material.Neon
    for _, c in ipairs(d:GetDescendants()) do
        if c:IsA("SurfaceAppearance") then c:Destroy()
        elseif c:IsA("Decal") or c:IsA("Texture") then
            if c.Name ~= "TrueAmAmImage" then
                if c.Transparency ~= 1 then c:SetAttribute("TrueAmAmOrigTrans", c.Transparency) end
                c.Transparency = 1
            end
        elseif c:IsA("SurfaceGui") or c:IsA("BillboardGui") then
            if c.Name ~= "TrueAmAmSG" then
                if c.Enabled then c:SetAttribute("TrueAmAmOrigEnabled", true) end
                c.Enabled = false
            end
        end
    end
    pnt[d] = true
end

local function paintAll()
    for _, o in ipairs(workspace:GetDescendants()) do
        if isMine(o) then
            for _, d in ipairs(o:GetDescendants()) do
                if d:IsA("BasePart") then paintPart(d) end
            end
        end
    end
end

local function unpaint()
    for part, data in pairs(paintBackup2) do
        if part and part.Parent then
            pcall(function()
                part.Color = data.Color part.Material = data.Material
            end)
        end
    end
    for d, _ in pairs(pnt) do
        if d and d.Parent then
            for _, c in ipairs(d:GetDescendants()) do
                if c:IsA("Decal") or c:IsA("Texture") then
                    if c.Name ~= "TrueAmAmImage" then
                        local orig = c:GetAttribute("TrueAmAmOrigTrans")
                        c.Transparency = orig ~= nil and orig or 0
                        c:SetAttribute("TrueAmAmOrigTrans", nil)
                    end
                elseif c:IsA("SurfaceGui") or c:IsA("BillboardGui") then
                    if c.Name ~= "TrueAmAmSG" then
                        local orig = c:GetAttribute("TrueAmAmOrigEnabled")
                        c.Enabled = orig ~= nil and orig or true
                        c:SetAttribute("TrueAmAmOrigEnabled", nil)
                    end
                end
            end
        end
    end
    paintBackup2 = {}
    pnt = {}
end

VisualTab:CreateToggle({
    Name = "Покраска палета (только мой)", Flag = "PaintPallet", Default = false,
    Callback = function(v)
        palG = v
        if v then paintAll() else unpaint() end
    end
})

local trOn = false

local function attachTr(d)
    if not d:IsA("BasePart") or d:FindFirstChild("TrueAmAmTrail") then return end
    local a0 = Instance.new("Attachment") a0.Name = "TrueAmAmTrailA0" a0.Position = Vector3.new(-0.35, 0, 0) a0.Parent = d
    local a1 = Instance.new("Attachment") a1.Name = "TrueAmAmTrailA1" a1.Position = Vector3.new(0.35, 0, 0) a1.Parent = d
    local tr = Instance.new("Trail")
    tr.Name = "TrueAmAmTrail" tr.Attachment0 = a0 tr.Attachment1 = a1
    tr.Lifetime = 1.2 tr.MinLength = 0.1
    tr.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 0)})
    tr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)})
    tr.Color = ColorSequence.new(CH) tr.LightEmission = 1 tr.FaceCamera = true tr.Parent = d
end

local function addTrAll()
    for _, o in ipairs(workspace:GetDescendants()) do
        if isMine(o) then
            for _, d in ipairs(o:GetDescendants()) do
                if d:IsA("BasePart") then attachTr(d) end
            end
        end
    end
end

local function rmTrAll()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o.Name == "TrueAmAmTrail" or o.Name == "TrueAmAmTrailA0" or o.Name == "TrueAmAmTrailA1" then o:Destroy() end
    end
end

VisualTab:CreateToggle({
    Name = "След за палетом (только мой)", Flag = "TrailPallet", Default = false,
    Callback = function(v) trOn = v if v then addTrAll() else rmTrAll() end end
})

local TID = "rbxassetid://16354043139"
local trlOn = false

local function addTroll(d)
    if not d:IsA("BasePart") or d.Name ~= "SoundPart" or d:FindFirstChild("TrueAmAmSG") then return end
    local s = Instance.new("SurfaceGui")
    s.Name = "TrueAmAmSG" s.Face = Enum.NormalId.Top
    s.AlwaysOnTop = false s.LightInfluence = 1
    s.ZIndexBehavior = Enum.ZIndexBehavior.Sibling s.Parent = d
    local i = Instance.new("ImageLabel")
    i.Name = "TrueAmAmImage" i.Size = UDim2.new(1, 0, 1, 0)
    i.BackgroundTransparency = 1 i.Image = TID
    i.ScaleType = Enum.ScaleType.Fit i.ZIndex = 0 i.Parent = s
end

VisualTab:CreateToggle({
    Name = "Тролль на палет (только мой)", Flag = "TrollPallet", Default = false,
    Callback = function(v)
        trlOn = v
        if v then
            for _, o in ipairs(workspace:GetDescendants()) do
                if isMine(o) then
                    for _, d in ipairs(o:GetDescendants()) do
                        if d:IsA("BasePart") and d.Name == "SoundPart" then addTroll(d) end
                    end
                end
            end
        else
            for _, o in ipairs(workspace:GetDescendants()) do
                if o.Name == "TrueAmAmSG" then o:Destroy() end
            end
        end
    end
})

workspace.DescendantAdded:Connect(function(o)
    if isMine(o) then
        task.wait(0.15)
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then
                if palG then paintPart(d) end
                if trOn then attachTr(d) end
                if trlOn and d.Name == "SoundPart" then addTroll(d) end
            end
        end
    elseif o:IsA("BasePart") then
        local a = o.Parent
        while a and a ~= workspace do
            if isMine(a) then
                if palG then paintPart(o) end
                if trOn then attachTr(o) end
                if trlOn and o.Name == "SoundPart" then addTroll(o) end
                return
            end
            a = a.Parent
        end
    end
end)

R.Heartbeat:Connect(function()
    if not palG then return end
    local now = os.clock()
    if now - lastCh < 0.3 then return end
    lastCh = now
    paintAll()
end)

-- CUSTOM LINES
VisualTab:CreateSection("Custom Lines")

local CustomLineTextures = {
    ["Low Quality"]    = "",
    ["Non-Gamepass"]   = "rbxassetid://8933346550",
    ["Gamepass"]       = "rbxassetid://8933355899",
    ["Chain"]          = "rbxassetid://81358145120405",
    ["Chain 2"]        = "rbxassetid://132910145874066",
    ["Chain 3"]        = "rbxassetid://128466395060514",
    ["Chain 4"]        = "rbxassetid://73368670987191",
    ["Rope"]           = "rbxassetid://78999022056924",
    ["Spring"]         = "rbxassetid://18837732116",
    ["Circle"]         = "rbxassetid://5367817750",
    ["Circle-Outline"] = "rbxassetid://12201347372",
    ["Triangle"]       = "rbxassetid://4704920160",
    ["Triangle-Outline"]= "rbxassetid://94666748694025",
    ["Square"]         = "rbxassetid://15007588972",
    ["Square-Outline"] = "rbxassetid://15420927706",
    ["Heart"]          = "rbxassetid://89015294175898",
    ["Heart-Outline"]  = "rbxassetid://125373934805238",
    ["Moon"]           = "rbxassetid://9013498676",
    ["Dots"]           = "rbxassetid://9169659357",
    ["Bubble"]         = "rbxassetid://1249690853",
    ["Star"]           = "rbxassetid://5639840603",
    ["Robux"]          = "rbxassetid://11560341132",
    ["Roblox-Logo"]    = "rbxassetid://12348119032",
    ["Brick"]          = "rbxassetid://4430903072",
    ["Studs"]          = "rbxassetid://15539356451",
    ["Fire"]           = "rbxassetid://18654087326",
    ["Lazar"]          = "rbxassetid://8922958725",
    ["Spider-Web"]     = "rbxassetid://123815660139244",
    ["Smoke"]          = "rbxassetid://12900071392",
    ["Pulse"]          = "rbxassetid://82163767314193",
    ["Arrow"]          = "rbxassetid://9006027964",
    ["Arrow 2"]        = "rbxassetid://10249261576",
}

local CustomLineNames = {}
for name in pairs(CustomLineTextures) do table.insert(CustomLineNames, name) end
table.sort(CustomLineNames)

local CurrentLineTexture = "Low Quality"
local customLineEnabled  = false

local function ApplyLineTexture()
    local url = CustomLineTextures[CurrentLineTexture] or ""
    pcall(function()
        local grabParts = workspace:FindFirstChild("GrabParts")
        if grabParts then
            local beamPart = grabParts:FindFirstChild("BeamPart")
            if beamPart then
                local beam = beamPart:FindFirstChild("GrabBeam")
                if beam and beam:IsA("Beam") then beam.Texture = url end
            end
        end
    end)
end

VisualTab:CreateDropdown({
    Name = "Custom Line", Flag = "CustomLineTexture",
    Items = CustomLineNames, Default = "Low Quality",
    Callback = function(Value)
        CurrentLineTexture = Value
        if customLineEnabled then ApplyLineTexture() end
    end
})

VisualTab:CreateToggle({
    Name = "Enable Custom Line", Flag = "CustomLineToggle", Default = false,
    Callback = function(Value)
        customLineEnabled = Value
        if Value then
            ApplyLineTexture()
            task.spawn(function()
                while customLineEnabled do
                    ApplyLineTexture()
                    task.wait(0.5)
                end
            end)
        else
            ApplyLineTexture()
        end
    end
})

workspace.DescendantAdded:Connect(function(obj)
    if not customLineEnabled then return end
    if obj:IsA("Beam") and obj.Name == "GrabBeam" then
        task.defer(ApplyLineTexture)
    end
end)

-- CHINA HAT
VisualTab:CreateSection("China Hat")

local HatEnabled = false
local HatRainbow = false
local HatTransparency = 0.3
local HatColor = Color3.fromRGB(0, 255, 255)
local HatParts = {}

local function removeHat(char)
    local h = HatParts[char]
    if h then h:Destroy() HatParts[char] = nil end
end

local function addHat(char)
    task.wait(0.1)
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    removeHat(char)
    local hat = Instance.new("Part")
    hat.Name = "ChinaHat" hat.Transparency = HatTransparency
    hat.Color = HatColor hat.Material = Enum.Material.Neon
    hat.CanCollide = false hat.CanTouch = false hat.CanQuery = false hat.Massless = true
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://1033714" mesh.Scale = Vector3.new(2.4, 1.6, 2.4) mesh.Parent = hat
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head weld.Part1 = hat weld.Parent = hat
    hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
    hat.Parent = char
    HatParts[char] = hat
end

VisualTab:CreateToggle({
    Name = "China Hat", Flag = "ChinaHat", Default = false,
    Callback = function(v)
        HatEnabled = v
        local char = LP.Character
        if v and char then addHat(char) elseif char then removeHat(char) end
    end
})

VisualTab:CreateToggle({
    Name = "Rainbow Hat", Flag = "ChinaHatRainbow", Default = false,
    Callback = function(v) HatRainbow = v end
})

VisualTab:CreateSlider({
    Name = "Hat Transparency", Flag = "ChinaHatTrans",
    Min = 0, Max = 100, Default = 30,
    Callback = function(v) HatTransparency = v / 100 end
})

VisualTab:CreateColorPicker({
    Name = "Hat Color", Flag = "ChinaHatColor", Default = HatColor,
    Callback = function(c) HatColor = c end
})

R.Heartbeat:Connect(function()
    if not HatEnabled then return end
    for char, hat in pairs(HatParts) do
        if hat and hat.Parent then
            hat.Transparency = HatTransparency
            hat.Color = HatRainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or HatColor
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    if HatEnabled then task.wait(1) addHat(char) end
end)

-- CUSTOM SKYBOX
VisualTab:CreateSection("Custom Skybox")

local Lighting_SB = game:GetService("Lighting")
local DefaultSkySettings = {}
local defaultSky = Lighting_SB:FindFirstChildOfClass("Sky")
if defaultSky then
    DefaultSkySettings = {
        SkyboxBk = defaultSky.SkyboxBk, SkyboxDn = defaultSky.SkyboxDn,
        SkyboxFt = defaultSky.SkyboxFt, SkyboxLf = defaultSky.SkyboxLf,
        SkyboxRt = defaultSky.SkyboxRt, SkyboxUp = defaultSky.SkyboxUp,
    }
end

local SkyboxAssets = {
    ["Black Storm"] = {Bk="rbxassetid://15502511288",Dn="rbxassetid://15502508460",Ft="rbxassetid://15502510289",Lf="rbxassetid://15502507918",Rt="rbxassetid://15502509398",Up="rbxassetid://15502511911"},
    ["HD"] = {Bk="http://www.roblox.com/asset/?id=16553658937",Dn="http://www.roblox.com/asset/?id=16553660713",Ft="http://www.roblox.com/asset/?id=16553662144",Lf="http://www.roblox.com/asset/?id=16553664042",Rt="http://www.roblox.com/asset/?id=16553665766",Up="http://www.roblox.com/asset/?id=16553667750"},
    ["Snow"] = {Bk="http://www.roblox.com/asset/?id=155657655",Dn="http://www.roblox.com/asset/?id=155674246",Ft="http://www.roblox.com/asset/?id=155657609",Lf="http://www.roblox.com/asset/?id=155657671",Rt="http://www.roblox.com/asset/?id=155657619",Up="http://www.roblox.com/asset/?id=155674931"},
    ["Blue Space"] = {Bk="rbxassetid://15536110634",Dn="rbxassetid://15536112543",Ft="rbxassetid://15536116141",Lf="rbxassetid://15536114370",Rt="rbxassetid://15536118762",Up="rbxassetid://15536117282"},
    ["Realistic"] = {Bk="rbxassetid://653719502",Dn="rbxassetid://653718790",Ft="rbxassetid://653719067",Lf="rbxassetid://653719190",Rt="rbxassetid://653718931",Up="rbxassetid://653719321"},
    ["Pink"] = {Bk="rbxassetid://12216109205",Dn="rbxassetid://12216109875",Ft="rbxassetid://12216109489",Lf="rbxassetid://12216110170",Rt="rbxassetid://12216110471",Up="rbxassetid://12216108877"},
    ["Sunset"] = {Bk="rbxassetid://600830446",Dn="rbxassetid://600831635",Ft="rbxassetid://600832720",Lf="rbxassetid://600886090",Rt="rbxassetid://600833862",Up="rbxassetid://600835177"},
    ["Arctic"] = {Bk="http://www.roblox.com/asset/?id=225469390",Dn="http://www.roblox.com/asset/?id=225469395",Ft="http://www.roblox.com/asset/?id=225469403",Lf="http://www.roblox.com/asset/?id=225469450",Rt="http://www.roblox.com/asset/?id=225469471",Up="http://www.roblox.com/asset/?id=225469481"},
    ["Space"] = {Bk="http://www.roblox.com/asset/?id=166509999",Dn="http://www.roblox.com/asset/?id=166510057",Ft="http://www.roblox.com/asset/?id=166510116",Lf="http://www.roblox.com/asset/?id=166510092",Rt="http://www.roblox.com/asset/?id=166510131",Up="http://www.roblox.com/asset/?id=166510114"},
    ["Red Night"] = {Bk="http://www.roblox.com/asset/?id=401664839",Dn="http://www.roblox.com/asset/?id=401664862",Ft="http://www.roblox.com/asset/?id=401664960",Lf="http://www.roblox.com/asset/?id=401664881",Rt="http://www.roblox.com/asset/?id=401664901",Up="http://www.roblox.com/asset/?id=401664936"},
    ["Purple Sunset"] = {Bk="rbxassetid://264908339",Dn="rbxassetid://264907909",Ft="rbxassetid://264909420",Lf="rbxassetid://264909758",Rt="rbxassetid://264908886",Up="rbxassetid://264907379"},
    ["Blue Night"] = {Bk="http://www.roblox.com/asset/?id=12064107",Dn="http://www.roblox.com/asset/?id=12064152",Ft="http://www.roblox.com/asset/?id=12064121",Lf="http://www.roblox.com/asset/?id=12063984",Rt="http://www.roblox.com/asset/?id=12064115",Up="http://www.roblox.com/asset/?id=12064131"},
    ["Summer"] = {Bk="rbxassetid://16648590964",Dn="rbxassetid://16648617436",Ft="rbxassetid://16648595424",Lf="rbxassetid://16648566370",Rt="rbxassetid://16648577071",Up="rbxassetid://16648598180"},
    ["Galaxy"] = {Bk="rbxassetid://15983968922",Dn="rbxassetid://15983966825",Ft="rbxassetid://15983965025",Lf="rbxassetid://15983967420",Rt="rbxassetid://15983966246",Up="rbxassetid://15983964246"},
    ["Stylized"] = {Bk="rbxassetid://18351376859",Dn="rbxassetid://18351374919",Ft="rbxassetid://18351376800",Lf="rbxassetid://18351376469",Rt="rbxassetid://18351376457",Up="rbxassetid://18351377189"},
    ["Cloudy Rain"] = {Bk="http://www.roblox.com/asset/?id=4498828382",Dn="http://www.roblox.com/asset/?id=4498828812",Ft="http://www.roblox.com/asset/?id=4498829917",Lf="http://www.roblox.com/asset/?id=4498830911",Rt="http://www.roblox.com/asset/?id=4498830417",Up="http://www.roblox.com/asset/?id=4498831746"},
}

local function applySkybox(name)
    local s = SkyboxAssets[name]
    if not s then return end
    local sky = Lighting_SB:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting_SB)
    sky.Name = "Sky" sky.SkyboxBk = s.Bk sky.SkyboxDn = s.Dn
    sky.SkyboxFt = s.Ft sky.SkyboxLf = s.Lf sky.SkyboxRt = s.Rt sky.SkyboxUp = s.Up
end

local function restoreDefaultSky()
    local sky = Lighting_SB:FindFirstChildOfClass("Sky")
    if sky and DefaultSkySettings.SkyboxBk then
        sky.SkyboxBk = DefaultSkySettings.SkyboxBk
        sky.SkyboxDn = DefaultSkySettings.SkyboxDn
        sky.SkyboxFt = DefaultSkySettings.SkyboxFt
        sky.SkyboxLf = DefaultSkySettings.SkyboxLf
        sky.SkyboxRt = DefaultSkySettings.SkyboxRt
        sky.SkyboxUp = DefaultSkySettings.SkyboxUp
    elseif sky then sky:Destroy() end
end

local skyNames = {}
for name in pairs(SkyboxAssets) do table.insert(skyNames, name) end
table.sort(skyNames)

local CurrentSkybox = "HD"
local CustomSkyEnabled = false

VisualTab:CreateDropdown({
    Name = "Skybox", Flag = "VisualSkybox", Items = skyNames, Default = "HD",
    Callback = function(Value)
        CurrentSkybox = Value
        if CustomSkyEnabled then applySkybox(Value) end
    end
})

VisualTab:CreateToggle({
    Name = "Enable Custom Skybox", Flag = "VisualSkyboxToggle", Default = false,
    Callback = function(Value)
        CustomSkyEnabled = Value
        if Value then applySkybox(CurrentSkybox) else restoreDefaultSky() end
    end
})

-- PLAYER
local PlayerTab = Window:CreateTab("Player", false, "rbxassetid://118418504956281")

PlayerTab:CreateSection("Информация")

local PlayerInfoLabel = PlayerTab:CreateLabel({Text = "Загрузка..."})

local function UpdatePlayerInfo(text)
    if not PlayerInfoLabel then return end
    pcall(function() PlayerInfoLabel:SetText(text) end)
    pcall(function() PlayerInfoLabel:Set(text) end)
    pcall(function() PlayerInfoLabel.Text = text end)
end

task.spawn(function()
    while true do
        task.wait(1)
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local health = hum and math.floor(hum.Health) or 0
        local maxHealth = hum and math.floor(hum.MaxHealth) or 100
        local speed = hum and math.floor(hum.WalkSpeed) or 0
        local jumpPower = hum and math.floor(hum.JumpPower or 50) or 0
        local pos = hrp and string.format("%.0f, %.0f, %.0f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) or "N/A"
        UpdatePlayerInfo(string.format("Здоровье: %d / %d\nСкорость: %d\nПрыжок: %d\nПозиция: %s", health, maxHealth, speed, jumpPower, pos))
    end
end)

PlayerTab:CreateSection("Free Gamepasses")

local freeReachActive = false

PlayerTab:CreateToggle({
    Name = "Free Further Reach", Flag = "FreeFurtherReach", Default = false,
    Callback = function(Value)
        freeReachActive = Value
        if Value then
            local existing = LP:FindFirstChild("FartherReach")
            if existing then existing:Destroy() end
            local reach = Instance.new("BoolValue")
            reach.Name = "FartherReach"
            reach.Parent = LP
            reach.Value = true
            local gpEvents = RS:FindFirstChild("GamepassEvents")
            local notifier = gpEvents and gpEvents:FindFirstChild("FurtherReachBoughtNotifier")
            if notifier and typeof(getconnections) == "function" then
                pcall(function()
                    for _, c in ipairs(getconnections(notifier.OnClientEvent)) do
                        pcall(c.Function)
                    end
                end)
            end
        else
            local reach = LP:FindFirstChild("FartherReach")
            if reach then reach:Destroy() end
        end
    end
})

PlayerTab:CreateButton({
    Name = "Free Reach (FartherReach)",
    Callback = function()
        local existing = LP:FindFirstChild("FartherReach")
        if existing then existing:Destroy() end
        local reach = Instance.new("BoolValue")
        reach.Name = "FartherReach"
        reach.Parent = LP
        reach.Value = true
        pcall(function()
            Library:Notify({Title = "true am am", Content = "FartherReach activated"})
        end)
    end
})

PlayerTab:CreateButton({
    Name = "Free Grab Reach (Line Colors)",
    Callback = function()
        local DataEvents = RS:FindFirstChild("DataEvents")
        local updateLine = DataEvents and DataEvents:FindFirstChild("UpdateLineColorsEvent")
        if updateLine then
            pcall(function()
                updateLine:FireServer(ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 195)),
                }))
            end)
        end
    end
})

PlayerTab:CreateButton({
    Name = "Free Gamepass (Exploit Notifier)",
    Callback = function()
        local gpEvents = RS:FindFirstChild("GamepassEvents")
        if not gpEvents then return end
        local notifier = gpEvents:FindFirstChild("FurtherReachBoughtNotifier")
        if notifier and typeof(getconnections) == "function" then
            pcall(function()
                for _, c in ipairs(getconnections(notifier.OnClientEvent)) do
                    for i in debug.getupvalues(c.Function) do
                        debug.setupvalue(c.Function, i, 45)
                    end
                    pcall(c.Function)
                end
            end)
        end
    end
})

PlayerTab:CreateSection("Камера")

local FOVEnabled = false
local FOVValue = 70

PlayerTab:CreateToggle({
    Name = "FOV Changer", Flag = "PlayerFOVToggle", Default = false,
    Callback = function(v)
        FOVEnabled = v
        if not v then Cam.FieldOfView = OrigFOV else Cam.FieldOfView = FOVValue end
    end
})

PlayerTab:CreateSlider({
    Name = "FOV Value (70-120)", Flag = "PlayerFOVValue",
    Min = 70, Max = 120, Default = 70,
    Callback = function(v) FOVValue = v if FOVEnabled then Cam.FieldOfView = v end end
})

R.RenderStepped:Connect(function()
    if FOVEnabled and Cam.FieldOfView ~= FOVValue then Cam.FieldOfView = FOVValue end
end)

local ThirdPersonEnabled = false
local SavedCamMode, SavedCamMax, SavedCamMin = nil, nil, nil

PlayerTab:CreateToggle({
    Name = "Third Person", Flag = "PlayerThirdPerson", Default = false,
    Callback = function(v)
        ThirdPersonEnabled = v
        if v then
            SavedCamMode = LP.CameraMode
            SavedCamMax = LP.CameraMaxZoomDistance
            SavedCamMin = LP.CameraMinZoomDistance
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = 128
            LP.CameraMinZoomDistance = 0.5
        else
            if SavedCamMode then
                LP.CameraMode = SavedCamMode
                LP.CameraMaxZoomDistance = SavedCamMax
                LP.CameraMinZoomDistance = SavedCamMin
                SavedCamMode, SavedCamMax, SavedCamMin = nil, nil, nil
            end
        end
    end
})

local infJumpOn = false

PlayerTab:CreateToggle({
    Name = "Infinite Jump", Flag = "PlayerInfJump", Default = false,
    Callback = function(v) infJumpOn = v end
})

U.JumpRequest:Connect(function()
    if not infJumpOn then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

PlayerTab:CreateSection("Движение")

local speedEnabled = false
local speedValue = 16
local DEFAULT_WALK = 16
local jumpEnabled = false
local jumpValue = 50
local DEFAULT_JUMP = 50
local speedConn = nil
local jumpConn = nil

local function ApplySpeedNow()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if speedConn then speedConn:Disconnect() speedConn = nil end
    if speedEnabled then
        hum.WalkSpeed = speedValue
        speedConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedEnabled and hum.WalkSpeed ~= speedValue then
                hum.WalkSpeed = speedValue
            end
        end)
    else
        hum.WalkSpeed = DEFAULT_WALK
    end
end

local function ApplyJumpNow()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if jumpConn then jumpConn:Disconnect() jumpConn = nil end
    if jumpEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = jumpValue
        jumpConn = hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if jumpEnabled and hum.JumpPower ~= jumpValue then
                hum.JumpPower = jumpValue
            end
        end)
    else
        hum.UseJumpPower = true
        hum.JumpPower = DEFAULT_JUMP
    end
end

PlayerTab:CreateToggle({
    Name = "Custom Walkspeed", Flag = "PlayerWalkspeedToggle", Default = false,
    Callback = function(v)
        speedEnabled = v
        ApplySpeedNow()
        task.defer(ApplySpeedNow)
        task.delay(0.05, ApplySpeedNow)
        task.delay(0.2, ApplySpeedNow)
    end
})

PlayerTab:CreateSlider({
    Name = "Walkspeed Value (16-500)", Flag = "PlayerWalkspeedValue",
    Min = 16, Max = 500, Default = 16, Suffix = " studs",
    Callback = function(v) speedValue = v if speedEnabled then ApplySpeedNow() end end
})

PlayerTab:CreateToggle({
    Name = "Custom Jump Power", Flag = "PlayerJumpToggle", Default = false,
    Callback = function(v)
        jumpEnabled = v
        ApplyJumpNow()
        task.defer(ApplyJumpNow)
        task.delay(0.05, ApplyJumpNow)
        task.delay(0.2, ApplyJumpNow)
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power Value (50-500)", Flag = "PlayerJumpValue",
    Min = 50, Max = 500, Default = 50, Suffix = " studs",
    Callback = function(v) jumpValue = v if jumpEnabled then ApplyJumpNow() end end
})

LP.CharacterAdded:Connect(function()
    task.wait(0.1) ApplySpeedNow() ApplyJumpNow()
end)

R.Heartbeat:Connect(function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if speedEnabled and hum.WalkSpeed ~= speedValue then hum.WalkSpeed = speedValue end
    if jumpEnabled then
        if not hum.UseJumpPower then hum.UseJumpPower = true end
        if hum.JumpPower ~= jumpValue then hum.JumpPower = jumpValue end
    end
end)

local spinEnabled = false
local spinSpeed = 5
local spinConn = nil

PlayerTab:CreateToggle({
    Name = "Spin Character", Flag = "PlayerSpinToggle", Default = false,
    Callback = function(v)
        spinEnabled = v
        if v then
            if spinConn then spinConn:Disconnect() end
            spinConn = R.Heartbeat:Connect(function()
                if not spinEnabled then return end
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) end
            end)
        else
            if spinConn then spinConn:Disconnect() spinConn = nil end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Spin Speed (1-90)", Flag = "PlayerSpinSpeed",
    Min = 1, Max = 90, Default = 5,
    Callback = function(v) spinSpeed = v end
})

PlayerTab:CreateSection("Прочее")

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
})

PlayerTab:CreateButton({
    Name = "Refresh Character",
    Callback = function() pcall(function() LP.Character:BreakJoints() end) end
})

-- АВАТАР
local function GetAvatarImage(plr)
    if not plr then return nil end
    local ok, url = pcall(function()
        return P:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if ok and url then return url end
    return nil
end

local AvatarGui = Instance.new("ScreenGui")
AvatarGui.Name = "TrueAmAmAvatarGui"
AvatarGui.ResetOnSpawn = false
pcall(function() AvatarGui.Parent = game.CoreGui end)

local function MakeAvatarFrame(anchorY)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 150)
    frame.Position = UDim2.new(0, 20, anchorY, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = AvatarGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local img = Instance.new("ImageLabel")
    img.Name = "Avatar"
    img.Size = UDim2.new(1, -8, 1, -8)
    img.Position = UDim2.new(0, 4, 0, 4)
    img.BackgroundTransparency = 1
    img.Image = ""
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = frame
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 10)
    corner2.Parent = img
    return frame, img
end

local TargetAvatarFrame, TargetAvatarImg = MakeAvatarFrame(0.10)
local BlobAvatarFrame,   BlobAvatarImg   = MakeAvatarFrame(0.10)

local function UpdateAvatar(frame, img, plr)
    if not frame or not img then return end
    if not plr then
        frame.Visible = false
        img.Image = ""
        return
    end
    local url = GetAvatarImage(plr)
    if url then
        img.Image = url
        frame.Visible = true
    else
        frame.Visible = false
    end
end

-- TARGET
local function InstallTargetSelector()
    local Tab = Window:CreateTab("Target", false, "rbxassetid://12614416526")
    Tab:CreateSection("Target Selection")
    Tab:CreateLabel({Text = "⬆ Аватар цели ⬆"})

    _G.TrueAmAm_SelectedTargets = {}

    local dd = Tab:CreateDropdown({
        Name = "Select Target",
        Flag = "TargetPlayer",
        Items = _G.TrueAmAm_PlayerList(),
        Default = _G.TrueAmAm_PlayerList()[1],
        Callback = function(Value)
            local name = _G.TrueAmAm_ParseName(Value)
            _G.TrueAmAm_SelectedTargets = {}
            if name and name ~= "No players" then
                table.insert(_G.TrueAmAm_SelectedTargets, name)
            end
            UpdateAvatar(TargetAvatarFrame, TargetAvatarImg, name and P:FindFirstChild(name) or nil)
        end
    })

    task.defer(function()
        local first = _G.TrueAmAm_PlayerList()[1]
        if first and first ~= "No players" then
            pcall(function() dd:SetValue(first) end)
            pcall(function() dd:Set(first) end)
            local name = _G.TrueAmAm_ParseName(first)
            if name then
                _G.TrueAmAm_SelectedTargets = { name }
                UpdateAvatar(TargetAvatarFrame, TargetAvatarImg, P:FindFirstChild(name))
            end
        end
    end)

    Tab:CreateButton({
        Name = "Refresh List",
        Callback = function()
            local newList = _G.TrueAmAm_PlayerList()
            pcall(function() dd:Refresh(newList) end)
            pcall(function() dd:SetValues(newList) end)
        end
    })

    P.PlayerAdded:Connect(function()
        task.wait(1)
        pcall(function() dd:Refresh(_G.TrueAmAm_PlayerList()) end)
    end)
    P.PlayerRemoving:Connect(function()
        task.wait(0.3)
        pcall(function() dd:Refresh(_G.TrueAmAm_PlayerList()) end)
    end)

    Tab:CreateSection("No blobman methods")
    _G.TrueAmAm_BuildGroupOfBlobMethods(Tab, true)
end
InstallTargetSelector()

-- BLOB
local BlobTab = Window:CreateTab("Blob", false, "rbxassetid://85548491349506")

local BlobRS          = RS
local BlobMenuToys    = BlobRS:FindFirstChild("MenuToys")
local BlobSpawnToy    = BlobMenuToys and BlobMenuToys:FindFirstChild("SpawnToyRemoteFunction")
local BlobGrabEvents  = BlobRS:FindFirstChild("GrabEvents")
local BlobSetNetOwner = BlobGrabEvents and BlobGrabEvents:FindFirstChild("SetNetworkOwner")

BlobTab:CreateSection("Blob Target Selection")

BlobTab:CreateLabel({Text = "⬆ Аватар цели ⬆"})

_G.TrueAmAm_SelectedBlobTargets = {}

local BlobDropdown = BlobTab:CreateDropdown({
    Name = "Select Blob Target",
    Flag = "BlobTarget",
    Items = _G.TrueAmAm_PlayerList(),
    Default = _G.TrueAmAm_PlayerList()[1],
    Callback = function(Value)
        local name = _G.TrueAmAm_ParseName(Value)
        _G.TrueAmAm_SelectedBlobTargets = {}
        if name and name ~= "No players" then
            table.insert(_G.TrueAmAm_SelectedBlobTargets, name)
        end
        UpdateAvatar(BlobAvatarFrame, BlobAvatarImg,
                     name and P:FindFirstChild(name) or nil)
    end
})

task.defer(function()
    local first = _G.TrueAmAm_PlayerList()[1]
    if first and first ~= "No players" then
        pcall(function() BlobDropdown:SetValue(first) end)
        pcall(function() BlobDropdown:Set(first) end)
        local name = _G.TrueAmAm_ParseName(first)
        if name then
            _G.TrueAmAm_SelectedBlobTargets = { name }
            UpdateAvatar(BlobAvatarFrame, BlobAvatarImg, P:FindFirstChild(name))
        end
    end
end)

BlobTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        local newList = _G.TrueAmAm_PlayerList()
        pcall(function() BlobDropdown:Refresh(newList) end)
        pcall(function() BlobDropdown:SetValues(newList) end)
    end
})

P.PlayerAdded:Connect(function()
    task.wait(1)
    pcall(function() BlobDropdown:Refresh(_G.TrueAmAm_PlayerList()) end)
end)

P.PlayerRemoving:Connect(function()
    task.wait(0.3)
    pcall(function() BlobDropdown:Refresh(_G.TrueAmAm_PlayerList()) end)
end)

BlobTab:CreateSection("Blobman Functions")

local function BlobFWC(parent, name, t)
    return parent:FindFirstChild(name) or parent:WaitForChild(name, t or 3)
end

local AutoSitBlobActive = false
local AutoSitBlobTask   = nil

BlobTab:CreateToggle({
    Name = "Auto Sit Blobman", Flag = "BlobAutoSit", Default = false,
    Callback = function(Value)
        AutoSitBlobActive = Value
        if AutoSitBlobTask then task.cancel(AutoSitBlobTask) AutoSitBlobTask = nil end
        if not Value then return end
        AutoSitBlobTask = task.spawn(function()
            while AutoSitBlobActive do
                pcall(function()
                    local char = LP.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and root and not hum.SeatPart then
                        local folder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
                        local blob = folder and folder:FindFirstChild("CreatureBlobman")
                        if not blob then
                            if BlobSpawnToy then
                                pcall(function()
                                    BlobSpawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 5, 5), Vector3.zero)
                                end)
                            end
                            local t0 = tick()
                            repeat
                                R.Heartbeat:Wait()
                                folder = workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
                                blob = folder and folder:FindFirstChild("CreatureBlobman")
                            until blob or tick() - t0 > 5 or not AutoSitBlobActive
                        end
                        if blob then
                            local seat = blob:FindFirstChildWhichIsA("VehicleSeat")
                            if seat then
                                root.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
                                root.Velocity = Vector3.zero
                                pcall(function() seat:Sit(hum) end)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

local function BlobBring(targetName)
    local target = P:FindFirstChild(targetName)
    if not target then return end
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    local seat = hum.SeatPart
    if not seat or target == LP then return end
    local seatParent = seat.Parent
    local targetChar = target.Character or target.CharacterAdded:Wait()
    local targetRoot = targetChar:WaitForChild("HumanoidRootPart")
    local det = seatParent:WaitForChild("LeftDetector")
    local weld = det:WaitForChild("LeftWeld")
    local grab = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureGrab")
    local orig = root.CFrame
    local origTr = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            origTr[p] = p.Transparency
            p.Transparency = 1
        end
    end
    local cam = workspace.CurrentCamera
    local camType = cam.CameraType
    cam.CameraType = Enum.CameraType.Scriptable
    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2.5)
    task.wait(0.05)
    grab:FireServer(det, targetRoot, weld)
    task.wait(0.1)
    grab:FireServer(det, targetRoot, weld)
    task.delay(0.2, function()
        root.CFrame = orig
        for p, tr in pairs(origTr) do
            if p and p.Parent then p.Transparency = tr end
        end
        cam.CameraType = camType
        cam.CameraSubject = hum
    end)
end

local BlobKickActive = false
local BlobKickTask   = nil
local BlobKickMethod = "Auto"

BlobTab:CreateDropdown({
    Name = "Blob Kick Method", Flag = "BlobKickMethod",
    Items = {"Auto", "Loop Kick", "Bypass", "Hard Kill"},
    Default = "Auto",
    Callback = function(v) BlobKickMethod = v end
})

local function BlobKick_Full(targetName)
    local target = P:FindFirstChild(targetName)
    if not target or target == LP then return end
    local myChar = LP.Character or LP.CharacterAdded:Wait()
    local myHum  = myChar:WaitForChild("Humanoid")
    local myRoot = myChar:WaitForChild("HumanoidRootPart")
    local myBlob = nil
    local seatWait = tick() + 3
    while tick() < seatWait do
        if myHum.SeatPart then myBlob = myHum.SeatPart.Parent break end
        task.wait(0.05)
    end
    if not myBlob or myBlob.Name ~= "CreatureBlobman" then return end
    local tChar = target.Character
    if not tChar then return end
    local tHum  = tChar:FindFirstChild("Humanoid")
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not (tHum and tRoot) or tHum.Health <= 0 then return end
    local lDet  = myBlob:FindFirstChild("LeftDetector")
    local lWeld = lDet and lDet:FindFirstChild("LeftWeld")
    local rDet  = myBlob:FindFirstChild("RightDetector")
    local rWeld = rDet and rDet:FindFirstChild("RightWeld")
    local lockPos = myRoot.CFrame * CFrame.new(0, 25, 0)
    local bp = tRoot:FindFirstChild("TrueAmAmBlobKickPos")
    if not bp or not bp.Parent then
        bp = Instance.new("BodyPosition")
        bp.Name = "TrueAmAmBlobKickPos"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.P = 1e6
        bp.D = 5000
        bp.Parent = tRoot
    end
    bp.Position = lockPos.Position
    if BlobSetNetOwner then
        pcall(function() BlobSetNetOwner:FireServer(tRoot, lockPos) end)
        pcall(function() BlobSetNetOwner:FireServer(tRoot, tRoot.CFrame) end)
    end
    if RagdollRemote_Def then
        pcall(function() RagdollRemote_Def:FireServer(tRoot, 3) end)
    end
    tHum.PlatformStand = true
    tHum.Sit = true
    tRoot.AssemblyLinearVelocity = Vector3.zero
    tRoot.AssemblyAngularVelocity = Vector3.zero
    local scriptObj = myBlob:FindFirstChild("BlobmanSeatAndOwnerScript")
    local detGrab   = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
    local detDrop   = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
    local detRel    = scriptObj and scriptObj:FindFirstChild("CreatureRelease")
    if detGrab and lDet and lWeld and rDet and rWeld then
        pcall(function() detGrab:FireServer(lDet, tRoot, lWeld) end)
        pcall(function() detGrab:FireServer(rDet, tRoot, rWeld) end)
    end
    local method = BlobKickMethod
    if method == "Auto" then method = "Hard Kill" end
    if method == "Hard Kill" then
        for i = 1, 20 do
            if not BlobKickActive or tHum.Health <= 0 then break end
            if detRel and lWeld then pcall(function() detRel:FireServer(lWeld, tRoot) end) end
            if detRel and rWeld then pcall(function() detRel:FireServer(rWeld, tRoot) end) end
            task.wait(0.02)
            if detGrab and lDet and lWeld then pcall(function() detGrab:FireServer(lDet, tRoot, lWeld) end) end
            if detGrab and rDet and rWeld then pcall(function() detGrab:FireServer(rDet, tRoot, rWeld) end) end
            task.wait(0.02)
        end
        pcall(function() if tHum then tHum.Health = 0 end end)
    elseif method == "Loop Kick" then
        for i = 1, 40 do
            if not BlobKickActive or tHum.Health <= 0 then break end
            if detGrab and lDet and lWeld then pcall(function() detGrab:FireServer(lDet, tRoot, lWeld) end) end
            task.wait()
            if detDrop and lWeld then pcall(function() detDrop:FireServer(lWeld, tRoot) end) end
            task.wait()
            if detGrab and rDet and rWeld then pcall(function() detGrab:FireServer(rDet, tRoot, rWeld) end) end
            task.wait()
            if detDrop and rWeld then pcall(function() detDrop:FireServer(rWeld, tRoot) end) end
            task.wait()
        end
    elseif method == "Bypass" then
        for _ = 1, 30 do
            if not BlobKickActive or tHum.Health <= 0 then break end
            for _ = 1, 20 do
                if detGrab and lDet and lWeld then
                    pcall(function() detGrab:FireServer(lDet, tRoot, lWeld) end)
                end
            end
            if detDrop and lWeld then pcall(function() detDrop:FireServer(lWeld, tRoot) end) end
            task.wait(0.02)
        end
    end
    if bp and bp.Parent then bp:Destroy() end
end

BlobTab:CreateButton({
    Name = "Bring Target",
    Callback = function()
        for _, name in ipairs(_G.TrueAmAm_SelectedBlobTargets) do
            BlobBring(name)
        end
    end
})

BlobTab:CreateToggle({
    Name = "Blob Kick Target", Flag = "BlobKickFull", Default = false,
    Callback = function(Value)
        BlobKickActive = Value
        if not Value then
            if BlobKickTask then task.cancel(BlobKickTask) BlobKickTask = nil end
            for _, uname in ipairs(_G.TrueAmAm_SelectedBlobTargets) do
                local plr = P:FindFirstChild(uname)
                if plr and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot then
                        for _, v in pairs(tRoot:GetChildren()) do
                            if v.Name == "TrueAmAmBlobKickPos" then
                                pcall(function() v:Destroy() end)
                            end
                        end
                    end
                end
            end
            return
        end
        BlobKickTask = task.spawn(function()
            while BlobKickActive do
                for _, uname in ipairs(_G.TrueAmAm_SelectedBlobTargets) do
                    if not BlobKickActive then break end
                    pcall(BlobKick_Full, uname)
                end
                task.wait(0.2)
            end
        end)
    end
})

-- KEYBINDS
local KeybindsTab = Window:CreateTab("Keybinds", false, "rbxassetid://10709789233")

KeybindsTab:CreateSection("Animations")

local jerkOffActive   = false
local jerkOffTrack    = nil

local JERK_ANIM_ID = "rbxassetid://168268306"

local function GetAnimator(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then
        anim = Instance.new("Animator")
        anim.Parent = hum
    end
    return anim, hum
end

local function StartJerkOff()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local anim, hum = GetAnimator(char)
    if not anim then return end
    local animation = Instance.new("Animation")
    animation.AnimationId = JERK_ANIM_ID
    jerkOffTrack = anim:LoadAnimation(animation)
    jerkOffTrack.Priority = Enum.AnimationPriority.Action
    jerkOffTrack.Looped = true
    jerkOffTrack:Play()
    jerkOffActive = true
    task.spawn(function()
        while jerkOffActive do
            task.wait(0.1)
            if jerkOffTrack and jerkOffTrack.IsPlaying then
                jerkOffTrack.TimePosition = 0.3
            end
        end
    end)
end

local function StopJerkOff()
    jerkOffActive = false
    if jerkOffTrack then
        pcall(function() jerkOffTrack:Stop() end)
        jerkOffTrack = nil
    end
end

KeybindsTab:CreateToggle({
    Name = "Jerk Off", Flag = "JerkOffToggle", Default = false,
    Callback = function(v)
        if v then StartJerkOff() else StopJerkOff() end
    end
})

KeybindsTab:CreateKeybind({
    Name = "Jerk Off Key", Flag = "JerkOffKey", Default = "Q",
    Callback = function()
        local toggle = Library.Toggles and Library.Toggles.JerkOffToggle
        if toggle then
            toggle:SetValue(not toggle.Value)
        else
            if jerkOffActive then StopJerkOff() else StartJerkOff() end
        end
    end
})

KeybindsTab:CreateButton({
    Name = "Stop Jerk Off (Reset)",
    Callback = function()
        StopJerkOff()
        pcall(function()
            if Library.Toggles and Library.Toggles.JerkOffToggle then
                Library.Toggles.JerkOffToggle:SetValue(false)
            end
        end)
    end
})

LP.CharacterAdded:Connect(function()
    StopJerkOff()
    pcall(function()
        if Library.Toggles and Library.Toggles.JerkOffToggle then
            Library.Toggles.JerkOffToggle:SetValue(false)
        end
    end)
end)

print("[true am am] Загружено: Main + Defense + Visual + Player + Target + Blob + Grabs + Keybinds.")                                                   
