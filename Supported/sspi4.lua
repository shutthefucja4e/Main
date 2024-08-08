local Fluent = loadstring(game:HttpGet("https://github.com/shutthefucja4e/Main/releases/download/Fluent/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/InterfaceManager.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/esp/ESP.lua"))()

local Window = Fluent:CreateWindow({
    Title = "StedHub -> SCP",
    SubTitle = "Free Version (Executor Supported)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local MainTab = Window:AddTab({ Title = "Main", Icon = "rbxassetid://10723424505" })

local AimBotSection = MainTab:AddSection("AimBot")

local AimBotEnabled = AimBotSection:AddToggle("AimBotEnabled", {Title = "Enable AimBot", Default = false })
local FOVValue = AimBotSection:AddSlider("FOV", {Title = "FOV", Default = 100, Min = 0, Max = 360, Rounding = 0, Callback = function(Value) end})
local ShowFOV = AimBotSection:AddToggle("ShowFOV", {Title = "Show FOV", Default = false})
local FOVColor = AimBotSection:AddColorPicker("FOVColor", {Title = "FOV Color", Default = Color3.fromRGB(255,255,255)})
local TeamCheck = AimBotSection:AddToggle("TeamCheck", {Title = "Team Check", Default = false})
local RogueCheck = AimBotSection:AddToggle("RogueCheck", {Title = "Rogue Check", Default = false})

local SilentAimSection = MainTab:AddSection("Silent Aim")

local SilentAimEnabled = SilentAimSection:AddToggle("SilentAimEnabled", {Title = "Enable Silent Aim", Default = false })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local function hasGun(character)
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Laser") then
            return true
        end
    end
    return false
end

local function isAgainst(otherPlayer)
    local playerTeamName = localPlayer.Team.Name
    local otherTeamName = otherPlayer.Team.Name
    local character = otherPlayer.Character

    if playerTeamName == "Class - D" or playerTeamName == "Chaos Insurgency" then
        if otherTeamName ~= "Class - D" and otherTeamName ~= "Chaos Insurgency" then
            if character.Head:FindFirstChild("Rogue") then
                return false
            else
                return true
            end
        else
            if character.HumanoidRootPart.BrickColor == BrickColor.new("Olivine") or character.LeftUpperArm:FindFirstChild("Crystal") then
                return true
            end
        end
    else
        if otherTeamName == "Class - D" then
            if hasGun(character) or character.HumanoidRootPart.BrickColor == BrickColor.new("Olivine") or character.LeftUpperArm:FindFirstChild("Crystal") then
                return true
            end
        elseif otherTeamName == "Chaos Insurgency" then
            return true
        elseif character.HumanoidRootPart.BrickColor == BrickColor.new("Olivine") or character.LeftUpperArm:FindFirstChild("Crystal") then
            return true
        end
    end
    return false
end

local function findNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = 300
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Team ~= localPlayer.Team and player.Character:FindFirstChild("Humanoid").Health ~= 0 then
            if isAgainst(player) then
                local distance = (player.Character.Head.Position - localPlayer.Character.Head.Position).Magnitude
                if distance < shortestDistance then
                    nearestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return nearestPlayer
end

local function shootNearestPlayer()
    local nearestPlayer = findNearestPlayer()

    if nearestPlayer and isAgainst(nearestPlayer) and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("Head") and nearestPlayer.Character:FindFirstChild("Humanoid") and nearestPlayer.Character.Humanoid.Health > 0 then
        local args = {
            [1] = {
                [1] = 0,
                [2] = 0,
                [3] = 0
            },
            [2] = nearestPlayer.Character.Head
        }
        ReplicatedStorage.Remotes.ShotRemote:FireServer(unpack(args))
    end
end

local function freezeAmmo()
    local glock = localPlayer.Backpack:WaitForChild("Glock 17")
    local currentAmmo = glock:WaitForChild("CurrentAmmo")
    local originalValue = currentAmmo.Value

    currentAmmo:GetPropertyChangedSignal("Value"):Connect(function()
        currentAmmo.Value = originalValue
    end)
end

local function equipGlock17()
    if not localPlayer.Character:FindFirstChild("Glock 17") then
        ReplicatedStorage.Remotes.Jerry:FireServer("Glock 17")
        local glock = localPlayer.Backpack:WaitForChild("Glock 17")
        glock.Parent = localPlayer.Character
        freezeAmmo()
    end
end

local function implementSilentAim()
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if SilentAimEnabled.Value then
                equipGlock17()
                shootNearestPlayer()
            end
        end)
    end)
end

SilentAimEnabled:OnChanged(function()
    if SilentAimEnabled.Value then
        implementSilentAim()
    end
end)

local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "rbxassetid://10723346959" })

local ESPSection = VisualsTab:AddSection("ESP")

local ESPEnabled = ESPSection:AddToggle("ESPEnabled", {Title = "Enable ESP", Default = false })
local ShowBox = ESPSection:AddToggle("ShowBox", {Title = "Show Box", Default = false})
local ShowNames = ESPSection:AddToggle("ShowNames", {Title = "Show Names", Default = false})
local ShowTracers = ESPSection:AddToggle("ShowTracers", {Title = "Show Tracers", Default = false})
local SCPESP = ESPSection:AddToggle("SCPESP", {Title = "SCP ESP", Default = false})

ESP:Toggle(false)
ESP.Boxes = false
ESP.Names = false
ESP.Tracers = false

ESPEnabled:OnChanged(function()
    ESP:Toggle(ESPEnabled.Value)
end)

ShowBox:OnChanged(function()
    ESP.Boxes = ShowBox.Value
end)

ShowNames:OnChanged(function()
    ESP.Names = ShowNames.Value
end)

ShowTracers:OnChanged(function()
    ESP.Tracers = ShowTracers.Value
end)

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

SCPESP:OnChanged(function()
    ESP.SCPESP = SCPESP.Value
end)

local OtherTab = Window:AddTab({ Title = "Other", Icon = "rbxassetid://10734949856" })

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

OtherTab:AddButton({
    Title = "Destroy Everything",
    Callback = function()
        DestroyEverything()
    end
})

local function InfiniteAmmo()
    while true do
        for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if item:FindFirstChild("CurrentAmmo") then
                item.CurrentAmmo.Value = 9999
            end
        end
        wait(0.1)
    end
end

OtherTab:AddButton({
    Title = "Infinity Ammo",
    Callback = function()
        InfiniteAmmo()
    end
})

OtherTab:AddButton({
    Title = "Fly (Press E)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/Supported/fl.lua", true))()
    end
})

local WalkSpeedSection = OtherTab:AddSection("WalkSpeed")

local WalkSpeedEnabled = WalkSpeedSection:AddToggle("WalkSpeedEnabled", {Title = "Enable WalkSpeed", Default = false })
local WalkSpeedValue = WalkSpeedSection:AddSlider("WalkSpeed", {Title = "Speed", Default = 1, Min = 0, Max = 10, Rounding = 1, Callback = function(Value) end})

getgenv().WalkSpeed = false

WalkSpeedEnabled:OnChanged(function()
    getgenv().WalkSpeed = WalkSpeedEnabled.Value
    if WalkSpeedEnabled.Value then
        spawn(function()
            while getgenv().WalkSpeed do
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * WalkSpeedValue.Value
                wait()
            end
        end)
    end
end)

WalkSpeedValue:OnChanged(function()
    -- automatically
end)

OtherTab:AddButton({
    Title = "Staff Detector",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/Supported/smaodod.lua"))()
    end
})

local ChatSpySection = OtherTab:AddSection("Chat Spy")

local FarmTab = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://10734950020" })

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
            wait(2)
            teleportToHelipad()
        end
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    
    if player.Character then
        teleportToHelipad()
    end
end

FarmTab:AddToggle("FarmEscapesToggle", {
    Title = "Farm Escapes",
    Default = false,
    Callback = function(Value)
        farmingEscapes = Value
        if Value then
            FarmEscapes()
        end
    end
})

local TeleportsTab = Window:AddTab({ Title = "Teleports", Icon = "rbxassetid://10734953373" })

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

for _, teleport in ipairs(teleports) do
    TeleportsTab:AddButton({
        Title = teleport[1],
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            local destination = type(teleport[2]) == "function" and teleport[2]() or teleport[2]
            if typeof(destination) == "Instance" then
                humanoidRootPart.CFrame = destination.CFrame
            else
                humanoidRootPart.CFrame = CFrame.new(destination)
            end
        end
    })
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("stedhub")
SaveManager:SetFolder("stedhub/scp")
InterfaceManager:BuildInterfaceSection(Window.Tabs.Settings)
SaveManager:BuildConfigSection(Window.Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "stedhub.vip",
    Content = "Your executor supported!",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()
