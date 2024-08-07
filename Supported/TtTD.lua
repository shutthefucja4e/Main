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
    MinimizeKey = Enum.KeyCode.LeftControl
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

Tabs.AutoFarm:AddToggle("AutoFarmLobby", {
    Title = "AutoFarm Lobby Unit",
    Default = false,
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
        
        local function teleportToNextObject()
            if currentIndex <= #beachBalls and isEnabled then
                local beachBall = beachBalls[currentIndex]
                if beachBall then
                    unfreezeCharacter()
                    wait(0.1)  -- Небольшая задержка перед телепортацией
                    
                    humanoidRootPart.CFrame = beachBall.CFrame + Vector3.new(0, 3, 0)  -- Телепортация чуть выше объекта
                    
                    wait(0.2)  -- Задержка после телепортации
                    freezeCharacter()
                end
                currentIndex = currentIndex + 1
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
    Default = false,
    Callback = function(Value)
        if Value then
            local plazaBalls = {
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.BeachBallMan.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.BigBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.CheeseBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.Egg.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.EvilBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.GlitchedBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.GrassBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.RustyBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.ToxicBeachBall.BeachBallClicker,
                game.Workspace.Worlds.TradingPlaza.HiddenBeachBalls.WideBeachBall.BeachBallClicker
            }
            
            for _, clicker in ipairs(plazaBalls) do
                if clicker and clicker:IsA("ClickDetector") then
                    fireclickdetector(clicker)
                end
            end
            wait(1)
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
