local Fluent = loadstring(game:HttpGet("https://github.com/shutthefucja4e/Main/releases/download/Fluent/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/InterfaceManager.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/esp/ESP.lua"))()

warn("StedHub -> Loaded! (✅)")

local Window = Fluent:CreateWindow({
    Title = "SCP RolePlay",
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

local function implementSilentAim()
    
end

SilentAimEnabled:OnChanged(function()
    if SilentAimEnabled.Value then
        implementSilentAim()
    else
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

SCPESP:OnChanged(function()

end)

local OtherTab = Window:AddTab({ Title = "Other", Icon = "rbxassetid://10734949856" })

OtherTab:AddButton({
    Title = "Destroy Everything",
    Callback = function()
        DestroyEverything()
    end
})

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
local WalkSpeedValue = WalkSpeedSection:AddSlider("WalkSpeed", {Title = "Speed", Default = 16, Min = 16, Max = 100, Rounding = 0, Callback = function(Value) end})

WalkSpeedEnabled:OnChanged(function()
    if WalkSpeedEnabled.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue.Value
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

WalkSpeedValue:OnChanged(function()
    if WalkSpeedEnabled.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue.Value
    end
end)

OtherTab:AddButton({
    Title = "Staff Detector",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/Supported/smaodod.lua"))()
    end
})

local ChatSpySection = OtherTab:AddSection("Chat Spy")


local FarmTab = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://10734950020" })

FarmTab:AddButton({
    Title = "Farm Escapes",
    Callback = function()
        FarmEscapes()
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
