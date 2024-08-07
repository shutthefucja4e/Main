print("StedHub -> Script for your game loaded! (✅)")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "StedHub -> TITIDA",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by stedpredm",
})

local MainTab = Window:CreateTab("Main", 4483362458)
local AutoFarmTab = Window:CreateTab("AutoFarm", 4483362458)
local WavesTab = Window:CreateTab("Waves", 4483362458)
local UnitsTab = Window:CreateTab("Units", 4483362458)
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local WebhookTab = Window:CreateTab("Webhook", 4483362458)

-- Main Tab
MainTab:CreateToggle({
   Name = "Auto Accept Trades",
   CurrentValue = false,
   Flag = "AutoAcceptTradesToggle",
   Callback = function(Value)
      if Value then
         spawn(function()
            while Rayfield.Flags.AutoAcceptTradesToggle.Value do
               local player = game.Players.LocalPlayer
               local notificationFrame = player.PlayerGui.MainFrames.NotificationFrame.BigNotification.NotificationFrame
               local acceptButton = player.PlayerGui.MainFrames.NotificationFrame.BigNotification.Buttons.YesButton

               if notificationFrame.Visible and acceptButton.Visible then
                  firesignal(acceptButton.MouseButton1Click)
               end
               wait(0.1)
            end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Setting up all Units (Trade)",
   CurrentValue = false,
   Flag = "AutoSetupUnitsToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

MainTab:CreateToggle({
   Name = "Auto Scanning Players",
   CurrentValue = false,
   Flag = "AutoScanPlayersToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

-- AutoFarm Tab
AutoFarmTab:CreateToggle({
   Name = "AutoFarm LobbyUnit",
   CurrentValue = false,
   Flag = "AutoFarmLobbyToggle",
   Callback = function(Value)
      while Value do
         local beachBalls = {
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.BeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.BlueBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.CyanBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.DeepBlueBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.GreenBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.OrangeBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.PinkBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.PurpleBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.RedBeachBall.BeachBallClicker,
            game.Workspace.Worlds.Lobby.HiddenBeachBalls.YellowBeachBall.BeachBallClicker
         }
         
         for _, clicker in ipairs(beachBalls) do
            if clicker and clicker:IsA("ClickDetector") then
                fireclickdetector(clicker)
            end
         end
         wait(1)
      end
   end,
})

AutoFarmTab:CreateToggle({
   Name = "AutoFarm PlazaUnit",
   CurrentValue = false,
   Flag = "AutoFarmPlazaToggle",
   Callback = function(Value)
      while Value do
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
   end,
})

AutoFarmTab:CreateToggle({
   Name = "AutoBuy",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

AutoFarmTab:CreateToggle({
   Name = "AutoSell",
   CurrentValue = false,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

-- Waves Tab
WavesTab:CreateToggle({
   Name = "Auto Skip Wave",
   CurrentValue = false,
   Flag = "AutoSkipWaveToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

-- Units Tab
UnitsTab:CreateToggle({
   Name = "Auto Upgrade Units",
   CurrentValue = false,
   Flag = "AutoUpgradeUnitsToggle",
   Callback = function(Value)
      -- Functionality to be implemented
   end,
})

-- Teleports Tab
TeleportsTab:CreateButton({
   Name = "Teleport to Plaza",
   Callback = function()
      local plazaZone = game.Workspace.Zones.PlazaZone
      if plazaZone then
         game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(plazaZone.CFrame)
      else
         Rayfield:Notify({
            Title = "Ошибка",
            Content = "PlazaZone не найдена",
            Duration = 3,
         })
      end
   end,
})

-- Webhook Tab
WebhookTab:CreateInput({
   Name = "Webhook URL",
   PlaceholderText = "Enter Webhook URL here",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- Save or use the webhook URL
   end,
})

WebhookTab:CreateToggle({
   Name = "Enable Webhook",
   CurrentValue = false,
   Flag = "EnableWebhookToggle",
   Callback = function(Value)
      -- Enable or disable webhook functionality
   end,
})

-- Additional buttons from your original code
MainTab:CreateButton({
   Name = "Auto Reward",
   Callback = function()
      local args = {
         [1] = {
            [1] = {
               [1] = "SandWizardCameraman"
            },
            [2] = "pr"
         }
      }
      game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(unpack(args))
   end,
})

MainTab:CreateButton({
   Name = "Auto Server Plaza",
   Callback = function()
      local targetPlayer = game.Players:FindFirstChild("shutghrhq")
      if targetPlayer then
         game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, targetPlayer.PlayerGui:WaitForChild("Lobby").TradingPlazaFrame.PlazaJoinScript.PlaceId)
      else
         Rayfield:Notify({
            Title = "Ошибка",
            Content = "Игрок не найден",
            Duration = 3,
         })
      end
   end,
})

MainTab:CreateButton({
   Name = "Auto Trade",
   Callback = function()
      local args = {
         [1] = {
            [1] = {
               [1] = tostring(os.time() * 1000 + math.random(1, 999)),
               [2] = game:GetService("Players").shutghrhq
            },
            [2] = "Pd"
         }
      }
      game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(unpack(args))
   end,
})
