local Fluent = loadstring(game:HttpGet("https://github.com/shutthefucja4e/Main/releases/download/Fluent/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/shutthefucja4e/Main/main/ui/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "StedHub",
    SubTitle = "by stedpredm",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "repeat" }),
    Waves = Window:AddTab({ Title = "Waves", Icon = "waves" }),
    Units = Window:AddTab({ Title = "Units", Icon = "users" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "webhook" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local isAutoAcceptEnabled = false

Tabs.Main:AddToggle("AutoAcceptTrades", {
    Title = "Auto Accept Trades",
    Default = false,
    Callback = function(Value)
        isAutoAcceptEnabled = Value
        if Value then
            spawn(function()
                while isAutoAcceptEnabled do
                    local args = {
                        [1] = {
                            [1] = {
                                [1] = tostring(os.time() * 1000 + math.random(1, 999)),
                                [2] = true
                            },
                            [2] = "Iw"
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
            end)
        end
    end
})

Tabs.Main:AddToggle("AutoSetupUnits", { Title = "Auto Setting up all Units (Trade)", Default = false })
Tabs.Main:AddToggle("AutoScanPlayers", { Title = "Auto Scanning Players", Default = false })

local UserInputService = game:GetService("UserInputService")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Tabs.AutoFarm:AddToggle("AutoFarmLobby", {
    Title = "AutoFarm Lobby Unit",
    Default = true,
    Callback = function(Value)
        local function findBeachBalls()
            local beachBalls = {}
            local addedFolders = {}
            
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name:match("Beachball LVL3%-4%.001") then
                    local folder = v.Parent
                    if not addedFolders[folder] then
                        table.insert(beachBalls, v)
                        addedFolders[folder] = true
                    end
                end
            end
            
            return beachBalls
        end
        
        local beachBalls = findBeachBalls()
        local currentIndex = 1
        local isEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local freezeConnection

        local function freezeCharacter()
            if freezeConnection then freezeConnection:Disconnect() end
            
            local lastPosition = humanoidRootPart.CFrame
            freezeConnection = RunService.Heartbeat:Connect(function()
                humanoidRootPart.CFrame = lastPosition
            end)
        end
        
        local function unfreezeCharacter()
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end
        end
        
        local function teleportToPlaza()
            local plazaZone = game.Workspace.Zones.PlazaZone
            if plazaZone then
                unfreezeCharacter()
                player.Character:SetPrimaryPartCFrame(plazaZone.CFrame)
            end
        end
        
        local function teleportToNextObject()
            if currentIndex <= #beachBalls and isEnabled then
                local beachBall = beachBalls[currentIndex]
                if beachBall then
                    unfreezeCharacter()
                    humanoidRootPart.CFrame = beachBall.CFrame + Vector3.new(0, 3, 0)
                    freezeCharacter()
                    currentIndex = currentIndex + 1
                end
            else
                -- Если все объекты пройдены, телепортируемся в плазу
                teleportToPlaza()
                isEnabled = false  -- Отключаем функцию после телепортации в плазу
            end
        end
        
        local connection
        if Value then
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
                    teleportToNextObject()
                end
            end)
        else
            if connection then connection:Disconnect() end
            unfreezeCharacter()
        end
    end
})

Tabs.AutoFarm:AddToggle("AutoFarmPlaza", {
    Title = "AutoFarm Plaza Unit",
    Default = true,
    Callback = function(Value)
        local function findBeachBalls()
            local beachBalls = {}
            local addedFolders = {}
            
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name:match("Beachball LVL3%-4%.001") then
                    local folder = v.Parent
                    if not addedFolders[folder] then
                        table.insert(beachBalls, v)
                        addedFolders[folder] = true
                    end
                end
            end
            
            return beachBalls
        end
        
        local beachBalls = findBeachBalls()
        local currentIndex = 1
        local isEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local freezeConnection

        local function freezeCharacter()
            if freezeConnection then freezeConnection:Disconnect() end
            
            local lastPosition = humanoidRootPart.CFrame
            freezeConnection = RunService.Heartbeat:Connect(function()
                humanoidRootPart.CFrame = lastPosition
            end)
        end
        
        local function unfreezeCharacter()
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end
        end
        
        local function teleportToPlaza()
            local plazaZone = game.Workspace.Zones.PlazaZone
            if plazaZone then
                unfreezeCharacter()
                player.Character:SetPrimaryPartCFrame(plazaZone.CFrame)
            end
        end
        
        local function teleportToNextObject()
            if currentIndex <= #beachBalls and isEnabled then
                local beachBall = beachBalls[currentIndex]
                if beachBall then
                    unfreezeCharacter()
                    humanoidRootPart.CFrame = beachBall.CFrame + Vector3.new(0, 3, 0)
                    freezeCharacter()
                    currentIndex = currentIndex + 1
                end
            else
                -- Если все объекты пройдены, телепортируемся в плазу
                isEnabled = false  -- Отключаем функцию после телепортации в плазу
            end
        end
        
        local connection
        if Value then
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
                    teleportToNextObject()
                end
            end)
        else
            if connection then connection:Disconnect() end
            unfreezeCharacter()
        end
    end
})

local isAutoTradeEnabled = false
local targetPlayer = "shutghrhq"

Tabs.AutoFarm:AddToggle("Auto Trade", {
    Title = "Auto Trade",
    Default = true,
    Callback = function(Value)
        isAutoTradeEnabled = Value
        if Value then
            spawn(function()
                while isAutoTradeEnabled do
                    local targetPlayerObject = game:GetService("Players"):FindFirstChild(targetPlayer)
                    if targetPlayerObject then
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "0",
                                    [2] = targetPlayerObject
                                },
                                [2] = "40"
                            }
                        }
                        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(unpack(args))
                    end
                    wait(0.1)
                end
            end)
        end
    end
})


Tabs.AutoFarm:AddToggle("AutoBuy", { Title = "AutoBuy", Default = false })
Tabs.AutoFarm:AddToggle("AutoSell", { Title = "AutoSell", Default = false })

Tabs.Waves:AddToggle("AutoSkipWave", { Title = "Auto Skip Wave", Default = false })

Tabs.Units:AddToggle("AutoUpgradeUnits", { Title = "Auto Upgrade Units", Default = false })

Tabs.Teleports:AddButton({
    Title = "Teleport to Plaza",
    Callback = function()
        local plazaZone = game.Workspace.Zones.PlazaZone
        if plazaZone then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(plazaZone.CFrame)
        end
    end
})

Tabs.Webhook:AddInput("WebhookURL", { Title = "Webhook URL", Default = "" })
Tabs.Webhook:AddToggle("EnableWebhook", { Title = "Enable Webhook", Default = false })

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("StedHub")
SaveManager:SetFolder("StedHub/ttd")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
