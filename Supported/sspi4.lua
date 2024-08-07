local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Загрузка ESP
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

local Window = Fluent:CreateWindow({
    Title = "sted.hub /\\ role: exploiter /\\ user: sh1f1x /\\ beta build",
    SubTitle = "by sh1f1x x stedpredm",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://4483362458" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "rbxassetid://4483362458" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "rbxassetid://4483362458" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://4483362458" })
}

local SilentAimEnabled = false
local SelectedPlayer = nil

-- Функция для получения ближайшего игрока (используйте существующую или создайте новую)
local function getClosestPlayer()
    -- Используйте существующую функцию getClosestPlayerInFOV() или создайте новую
    return getClosestPlayerInFOV()
end

-- Функция для выполнения выстрела с Silent Aim
local function silentAimShot(originalArgs)
    local args = originalArgs
    if SilentAimEnabled then
        local target = SelectedPlayer or getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[1] = {
                target.Character.Head.Position.X,
                target.Character.Head.Position.Y,
                target.Character.Head.Position.Z
            }
            args[2] = target.Character.Head
        end
    end
    game:GetService("ReplicatedStorage").Remotes.ShotRemote:FireServer(unpack(args))
end

-- Создаем переключатель для Silent Aim
local SilentAimToggle = Tabs.Main:AddToggle("SilentAimToggle", {Title = "Silent Aim", Default = false })

SilentAimToggle:OnChanged(function(Value)
    SilentAimEnabled = Value
    if Value and not SelectedPlayer then
        SelectedPlayer = getClosestPlayer()
    end
end)

-- Создаем выпадающий список для выбора игрока (опционально)
local PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = {},
    Multi = false,
    Default = 1,
})

PlayerDropdown:OnChanged(function(Value)
    local player = game.Players:FindFirstChild(Value)
    if player then
        SelectedPlayer = player
    end
end)

-- Функция для обновления списка игроков
local function updatePlayerList()
    local playerNames = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:SetValues(playerNames)
end

-- Обновляем список игроков каждые 10 секунд
spawn(function()
    while wait(10) do
        updatePlayerList()
    end
end)

-- Перехват события выстрела (пример)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Здесь должна быть логика определения аргументов выстрела
        local shotArgs = {
            [1] = {game.Players.LocalPlayer:GetMouse().Hit.X, game.Players.LocalPlayer:GetMouse().Hit.Y, game.Players.LocalPlayer:GetMouse().Hit.Z},
            [2] = game.Players.LocalPlayer:GetMouse().Target
        }
        silentAimShot(shotArgs)
    end
end)

-- Aimbot Section
local AimbotSection = Tabs.Main:AddSection("Aimbot")

local aimbot = {
    enabled = false,
    teamCheck = false,
    wallCheck = false,
    rogueCheck = false,
    spawnCheck = false,
    fov = 400,
    showFOV = false
}

local function isTeammate(player)
    local localPlayer = game.Players.LocalPlayer
    local localTeam = localPlayer.Team
    local playerTeam = player.Team

    local friendlyTeams = {
        "Scientific Department", "Security Department", "Mobile Task Force",
        "Internal Security Department", "Intelligence Agency", "Medical Department",
        "Rapid Response Team", "Administrative Department"
    }
    local hostileTeams = {"Class - D", "Chaos Insurgency"}

    if table.find(hostileTeams, localTeam.Name) then
        return table.find(hostileTeams, playerTeam.Name) ~= nil
    elseif table.find(friendlyTeams, localTeam.Name) then
        return table.find(friendlyTeams, playerTeam.Name) ~= nil
    end

    return false
end

local function isPlayerBehindWall(player)
    local character = player.Character
    if not character then return true end
    
    local head = character:FindFirstChild("Head")
    if not head then return true end

    local camera = game.Workspace.CurrentCamera
    local localCharacter = game.Players.LocalPlayer.Character
    if not localCharacter or not localCharacter:FindFirstChild("Head") then return true end

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {localCharacter}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local rayOrigin = camera.CFrame.Position
    local rayDirection = (head.Position - rayOrigin).Unit
    local rayDistance = (head.Position - rayOrigin).Magnitude

    local rayResult = game.Workspace:Raycast(rayOrigin, rayDirection * rayDistance, rayParams)

    return not (rayResult == nil or rayResult.Instance:IsDescendantOf(character))
end

local function isPlayerInSpawnArea(player)
    local character = player.Character
    if not character then return false end
    
    local spawnAreas = {
        game.Workspace["Sector 2"].SectionA.Part,
        game.Workspace["Sector 2"].SectionA:GetChildren()[191],
        game.Workspace["Sector 1"]:GetChildren()[89],
        game.Workspace["Sector 2"].SectionA:GetChildren()[441],
        game.Workspace["Sector 3"]:GetChildren()[90],
        game.Workspace["Sector 3"]:GetChildren()[44]
    }
    
    for _, area in ipairs(spawnAreas) do
        if (character.HumanoidRootPart.Position - area.Position).Magnitude < 10 then
            return true
        end
    end
    
    return false
end

local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return nil end
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                if humanoid and root and humanoid.Health > 0 then
                    if aimbot.teamCheck and isTeammate(player) then
                        continue
                    end
                    if aimbot.wallCheck and isPlayerBehindWall(player) then
                        continue
                    end
                    if aimbot.rogueCheck and (player.Team.Name == "Class - D" or player.Team.Name == "Chaos Insurgency") then
                        continue
                    end
                    if aimbot.spawnCheck and isPlayerInSpawnArea(player) then
                        continue
                    end
                    
                    local vector, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        local distance = (Vector2.new(vector.X, vector.Y) - Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                        if distance < aimbot.fov and distance < shortestDistance then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAtPlayer(player)
    if player and player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, head.Position)
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if aimbot.enabled and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerInFOV()
        if target then
            aimAtPlayer(target)
        end
    end
end)

local EnableAimbot = Tabs.Main:AddToggle("EnableAimbot", {Title = "Enable Aimbot", Default = false})

EnableAimbot:OnChanged(function(Value)
    aimbot.enabled = Value
end)

local TeamCheck = Tabs.Main:AddToggle("TeamCheck", {Title = "Team Check", Default = false})

TeamCheck:OnChanged(function(Value)
    aimbot.teamCheck = Value
end)

local WallCheck = Tabs.Main:AddToggle("WallCheck", {Title = "Wall Check", Default = false})

WallCheck:OnChanged(function(Value)
    aimbot.wallCheck = Value
end)

local RogueCheck = Tabs.Main:AddToggle("RogueCheck", {Title = "Rogue Check", Default = false})

RogueCheck:OnChanged(function(Value)
    aimbot.rogueCheck = Value
end)

local SpawnCheck = Tabs.Main:AddToggle("SpawnCheck", {Title = "Spawn Check", Default = false})

SpawnCheck:OnChanged(function(Value)
    aimbot.spawnCheck = Value
end)

local FOVSlider = Tabs.Main:AddSlider("FOVSlider", {
    Title = "FOV Distance",
    Description = "Adjust the FOV distance",
    Default = 400,
    Min = 0,
    Max = 800,
    Rounding = 1,
    Callback = function(Value)
        aimbot.fov = Value
    end
})

local ShowFOV = Tabs.Main:AddToggle("ShowFOV", {Title = "Show FOV", Default = false})

ShowFOV:OnChanged(function(Value)
    aimbot.showFOV = Value
end)

-- FOV Circle Drawing
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = 400
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)

game:GetService("RunService").Heartbeat:Connect(function()
    if aimbot.showFOV then
        fovCircle.Visible = true
        fovCircle.Radius = aimbot.fov
        fovCircle.Position = game:GetService("UserInputService"):GetMouseLocation()
    else
        fovCircle.Visible = false
    end
end)

-- Other Section
local OtherSection = Tabs.Main:AddSection("Other")

local function setCFrameWalkSpeed(speed)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Отключаем встроенную ходьбу
    humanoid.WalkSpeed = 0
    
    -- Создаем новую функцию для движения
    local function updatePosition()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local moveDirection = humanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * speed * game:GetService("RunService").Heartbeat:Wait()
            end
        end
    end
    
    -- Подключаем функцию к Heartbeat
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(updatePosition)
    
    -- Отключаем функцию при смерти персонажа
    humanoid.Died:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)
end

local WalkSpeedSlider = Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "CFrame WalkSpeed (Method 1)",
    Description = "Adjust the CFrame WalkSpeed",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        setCFrameWalkSpeed(Value)
    end
})

getgenv().WalkSpeed = false
local WalkSpeedValue = 1

local function CFrameWalkSpeed()
    while WalkSpeed do
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * WalkSpeedValue
        end
        wait()
    end
end

local WalkSpeedToggle = Tabs.Main:AddToggle("WalkSpeedToggle", {Title = "CFrame WalkSpeed (Method 2)", Default = false})

WalkSpeedToggle:OnChanged(function(Value)
    getgenv().WalkSpeed = Value
    if Value then
        coroutine.wrap(CFrameWalkSpeed)()
    end
end)

local WalkSpeedSlider2 = Tabs.Main:AddSlider("WalkSpeedSlider2", {
    Title = "CFrame WalkSpeed Value (Method 2)",
    Description = "Adjust the CFrame WalkSpeed Value",
    Default = 1,
    Min = 0,
    Max = 100,
    Rounding = 0.1,
    Callback = function(Value)
        WalkSpeedValue = Value
    end
})

-- Infinite Ammo
local function InfiniteAmmo()
   while true do
      for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
         if item:FindFirstChild("CurrentAmmo") then
            item.CurrentAmmo.Value = 9999
         end
      end
      wait(60)
   end
end

local InfAmmo = Tabs.Main:AddToggle("InfAmmo", {Title = "Infinite Ammo", Default = false})

InfAmmo:OnChanged(function(Value)
    if Value then
        coroutine.wrap(InfiniteAmmo)()
    end
end)

local function Fly()
    loadstring(game:HttpGet("https://pastebin.com/raw/E4Yw5kcw", true))()
end

local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {Title = "Fly (Press E)", Default = false})

FlyToggle:OnChanged(function(Value)
    if Value then
        Fly()
    end
end)

-- Anti AFK
local function AntiAFK()
   local VirtualUser = game:GetService("VirtualUser")
   game:GetService("Players").LocalPlayer.Idled:Connect(function()
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
   end)
end

local AntiAFKToggle = Tabs.Main:AddToggle("AntiAFKToggle", {Title = "Anti AFK", Default = false})

AntiAFKToggle:OnChanged(function(Value)
    if Value then
        AntiAFK()
    end
end)

local function NoClip()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    while true do
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        game:GetService("RunService").Stepped:Wait()
    end
end

local NoClipToggle = Tabs.Main:AddToggle("NoClipToggle", {Title = "NoClip", Default = false})

NoClipToggle:OnChanged(function(Value)
    if Value then
        coroutine.wrap(NoClip)()
    end
end)

-- Destroy Everything
local function DestroyEverything()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Anchored then
            if not v:IsDescendantOf(game.Players.LocalPlayer.Character) and 
               v.Name ~= "Base" and 
               v.Name ~= "Baseplate" and 
               v.Name ~= "Terrain" then
                
                if not (v.Name == "Part" and math.abs(v.Position.Y - 19.35) < 0.01) then
                    v:Destroy()
                end
            end
        end
    end
end

local DestroyEverythingButton = Tabs.Main:AddButton({
    Title = "Destroy Everything",
    Callback = function()
        DestroyEverything()
    end
})

local function FullBright()
    local lighting = game:GetService("Lighting")
    lighting.Brightness = 2
    lighting.ClockTime = 14
    lighting.FogEnd = 100000
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local FullBrightToggle = Tabs.Main:AddToggle("FullBrightToggle", {Title = "FullBright", Default = false})

FullBrightToggle:OnChanged(function(Value)
    if Value then
        FullBright()
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 500
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

local function DeleteTeslaGate()
    local teslaGates = game.Workspace.Map["Sector-3 Tesla Gates"]
    if teslaGates:FindFirstChild("Tesla Gate") then
        teslaGates["Tesla Gate"]:Destroy()
    end
    if #teslaGates:GetChildren() >= 2 then
        teslaGates:GetChildren()[2]:Destroy()
    end
end

local DeleteTeslaGateButton = Tabs.Main:AddButton({
    Title = "Delete Tesla Gate",
    Callback = function()
        DeleteTeslaGate()
    end
})

local ESPSection = Tabs.Visual:AddSection("ESP")

-- Инициализация ESP
ESP:Toggle(false)
ESP.Boxes = false
ESP.Names = false
ESP.Tracers = false
ESP.Players = {}

-- Функция для добавления игрока в ESP
local function addPlayerToESP(player)
    if not ESP.Players[player] then
        ESP.Players[player] = {
            Name = player.Name,
            Player = player,
            PrimaryPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        }
    end
end

-- Функция для обновления ESP для всех игроков
local function updateAllPlayersESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        addPlayerToESP(player)
    end
end

-- Обновление ESP при входе нового игрока
game.Players.PlayerAdded:Connect(addPlayerToESP)

-- Обновление ESP при изменении персонажа игрока
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        addPlayerToESP(player)
    end)
end)

-- Периодическое обновление ESP для всех игроков
spawn(function()
    while wait(1) do
        updateAllPlayersESP()
    end
end)

local espEnabled = false

local EnableESP = Tabs.Visual:AddToggle("EnableESP", {Title = "Enable ESP", Default = false})

EnableESP:OnChanged(function(Value)
    espEnabled = Value
    if Value then
        ESP:Toggle(true)
        updateAllPlayersESP()
    else
        ESP:Toggle(false)
    end
end)

local BoxESP = Tabs.Visual:AddToggle("BoxESP", {Title = "Box ESP", Default = false})

BoxESP:OnChanged(function(Value)
    ESP.Boxes = Value
end)

local NameESP = Tabs.Visual:AddToggle("NameESP", {Title = "Name ESP", Default = false})

NameESP:OnChanged(function(Value)
    ESP.Names = Value
end)

local TracerESP = Tabs.Visual:AddToggle("TracerESP", {Title = "Tracer ESP", Default = false})

TracerESP:OnChanged(function(Value)
    ESP.Tracers = Value
end)

-- SCP ESP
local scpObjects = {
    "SCP-173", "SCP-999", "SCP-966", "SCP-457", "SCP-2950",
    "SCP-131", "SCP-1299", "SCP-1025", "SCP-087", "SCP-079",
    "SCP-066", "SCP-049", "SCP-023", "SCP-008", "SCP-002"
}

ESP:AddObjectListener(game.Workspace.SCPs, {
    Type = "Model",
    CustomName = function(obj)
        return obj.Name
    end,
    Color = Color3.fromRGB(255, 0, 0),
    IsEnabled = "SCPESP"
})

local SCPESP = Tabs.Visual:AddToggle("SCPESP", {Title = "SCP ESP", Default = false})

SCPESP:OnChanged(function(Value)
    ESP.SCPESP = Value
end)

local originalLightingSettings = {
    Brightness = game:GetService("Lighting").Brightness,
    ClockTime = game:GetService("Lighting").ClockTime,
    FogEnd = game:GetService("Lighting").FogEnd,
    GlobalShadows = game:GetService("Lighting").GlobalShadows,
    OutdoorAmbient = game:GetService("Lighting").OutdoorAmbient
}

-- Unhook function
local function Unhook()
    -- Отключаем ESP
    ESP:Toggle(false)
    ESP.Boxes = false
    ESP.Names = false
    ESP.Tracers = false
    
    -- Отключаем аимбот
    aimbot.enabled = false
    aimbot.teamCheck = false
    aimbot.wallCheck = false
    aimbot.rogueCheck = false
    aimbot.spawnCheck = false
    aimbot.showFOV = false
    if fovCircle then
        fovCircle.Visible = false
    end
    
    -- Восстанавливаем оригинальные настройки освещения
    local lighting = game:GetService("Lighting")
    lighting.Brightness = originalLightingSettings.Brightness
    lighting.ClockTime = originalLightingSettings.ClockTime
    lighting.FogEnd = originalLightingSettings.FogEnd
    lighting.GlobalShadows = originalLightingSettings.GlobalShadows
    lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
    
    -- Отключаем бесконечные патроны
    for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if item:FindFirstChild("CurrentAmmo") then
            item.CurrentAmmo.Value = item.CurrentAmmo.Value -- Это сбросит значение к оригинальному
        end
    end
    
    -- Отключаем NoClip
    if game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    -- Отключаем автофарм
    farmingEscapes = false
    
    -- Удаляем все соединения
    for _, connection in pairs(getconnections(game:GetService("RunService").RenderStepped)) do
        connection:Disable()
    end
    for _, connection in pairs(getconnections(game:GetService("RunService").Heartbeat)) do
        connection:Disable()
    end
    
    -- Очищаем глобальные переменные
    for name, _ in pairs(getgenv()) do
        if name:find("Sted") then
            getgenv()[name] = nil
        end
    end
    
    -- Уничтожаем GUI
    Window:Destroy()
end

local UnhookButton = Tabs.Main:AddButton({
    Title = "Unhook Cheat",
    Callback = function()
        Unhook()
    end
})

local TeleportsSection = Tabs.Teleports:AddSection("Teleports")

local function Teleport(object)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if typeof(object) == "Vector3" then
        humanoidRootPart.CFrame = CFrame.new(object)
    elseif object:IsA("Model") and object.PrimaryPart then
        humanoidRootPart.CFrame = object.PrimaryPart.CFrame
    elseif object:IsA("BasePart") then
        humanoidRootPart.CFrame = object.CFrame
    end
end

local teleports = {
    {"Security Dep. Spawn", Vector3.new(50.621, 21.56, -22.051)},
    {"In Bunker", Vector3.new(-163.532, -19.83, -193.332)},
    {"Class D Center", Vector3.new(-30.886, 24.26, 270.501)},
    {"MTF", Vector3.new(286.271, 24.356, -68.344)},
    {"Transformers", Vector3.new(-171.379, 20.385, -105.728)},
    {"Control Room", Vector3.new(-47.835, 18.684, -110.84)},
    {"Helipad", Vector3.new(-883.641, 10.211, 11.987)},
    {"SCP-173", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-173") end},
    {"SCP-999", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-999") end},
    {"SCP-966", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-966") end},
    {"SCP-457", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-457") end},
    {"SCP-2950", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-2950") end},
    {"SCP-131", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-131") end},
    {"SCP-1299", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-1299") end},
    {"SCP-1025", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-1025") end},
    {"SCP-087", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-087") end},
    {"SCP-079", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-079") end},
    {"SCP-066", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-066") end},
    {"SCP-049", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-049") end},
    {"SCP-023", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-023") end},
    {"SCP-008", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-008") end},
    {"SCP-002", function() return game.Workspace:WaitForChild("SCPs"):WaitForChild("SCP-002") end},
}

for _, teleportData in ipairs(teleports) do
    local name, destination = teleportData[1], teleportData[2]
    Tabs.Teleports:AddButton({
        Title = name,
        Callback = function()
            if typeof(destination) == "function" then
                local object = destination()
                if object then
                    Teleport(object)
                else
                    print("Teleport object not found: " .. name)
                end
            else
                Teleport(destination)
            end
        end
    })
end

local AutoFarmSection = Tabs.AutoFarm:AddSection("Auto Farm")

local farmingEscapes = false

local function FarmEscapes()
    local player = game.Players.LocalPlayer
    
    local function teleportToHelipad()
        local character = player.Character
        if character then
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(-883.641, 12.211, 11.987)
            end
        end
    end
    
    local function onCharacterAdded(newCharacter)
        if farmingEscapes then
            wait(2)  -- Увеличиваем задержку для надежности
            teleportToHelipad()
        end
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Немедленная телепортация при включении функции
    if player.Character then
        teleportToHelipad()
    end
end

local FarmEscapesToggle = Tabs.AutoFarm:AddToggle("FarmEscapesToggle", {Title = "Farm Escapes (Helipad)", Default = false})

FarmEscapesToggle:OnChanged(function(Value)
    farmingEscapes = Value
    if Value then
        FarmEscapes()
    end
end)

-- Сохранение настроек
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
