local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentFrame = Instance.new("ScrollingFrame")
local SettingsFrame = Instance.new("Frame")
local NotificationFrame = Instance.new("Frame")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "StedHub 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ContentFrame.ScrollBarThickness = 8

-- Добавляем функции для создания элементов UI

local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.Size = UDim2.new(1, -20, 0, 30)
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = text
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 14
    
    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = text .. (enabled and " ✅" or " ❌")
        callback(enabled)
    end)
    
    return Toggle
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    
    local SliderText = Instance.new("TextLabel")
    SliderText.Parent = SliderFrame
    SliderText.BackgroundTransparency = 1
    SliderText.Size = UDim2.new(1, 0, 0, 20)
    SliderText.Font = Enum.Font.SourceSans
    SliderText.Text = text .. ": " .. default
    SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderText.TextSize = 14
    
    local SliderBar = Instance.new("TextButton")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.Size = UDim2.new(1, 0, 0, 5)
    SliderBar.Text = ""
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local function updateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
        SliderFill.Size = pos
        local value = math.floor(min + ((max - min) * pos.X.Scale))
        SliderText.Text = text .. ": " .. value
        callback(value)
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    return SliderFrame
end

local function CreateColorPicker(parent, text, default, callback)
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Parent = parent
    ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ColorPickerFrame.Size = UDim2.new(1, -20, 0, 50)
    
    local ColorPickerText = Instance.new("TextLabel")
    ColorPickerText.Parent = ColorPickerFrame
    ColorPickerText.BackgroundTransparency = 1
    ColorPickerText.Size = UDim2.new(1, -60, 1, 0)
    ColorPickerText.Font = Enum.Font.SourceSans
    ColorPickerText.Text = text
    ColorPickerText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorPickerText.TextSize = 14
    
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Parent = ColorPickerFrame
    ColorDisplay.BackgroundColor3 = default
    ColorDisplay.Position = UDim2.new(1, -50, 0, 5)
    ColorDisplay.Size = UDim2.new(0, 40, 1, -10)
    ColorDisplay.Text = ""
    
    ColorDisplay.MouseButton1Click:Connect(function()
        -- Здесь должен быть код для открытия цветового пикера
        -- Для простоты, мы просто будем менять цвет на случайный при клике
        local newColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        ColorDisplay.BackgroundColor3 = newColor
        callback(newColor)
    end)
    
    return ColorPickerFrame
end

-- Создаем элементы UI
local outlineColor = CreateColorPicker(ContentFrame, "Outline Color", Color3.fromRGB(0, 170, 255), function(color)
    -- Обновляем цвет обводки меню
end)
outlineColor.Position = UDim2.new(0, 10, 0, 10)

local notificationColor = CreateColorPicker(ContentFrame, "Notification Color", Color3.fromRGB(255, 255, 0), function(color)
    -- Обновляем цвет обводки уведомления
end)
notificationColor.Position = UDim2.new(0, 10, 0, 70)

local discordLink = Instance.new("TextButton")
discordLink.Parent = ContentFrame
discordLink.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
discordLink.Position = UDim2.new(0, 10, 0, 130)
discordLink.Size = UDim2.new(1, -20, 0, 30)
discordLink.Font = Enum.Font.SourceSans
discordLink.Text = "Discord: Click to join"
discordLink.TextColor3 = Color3.fromRGB(0, 170, 255)
discordLink.TextSize = 14

discordLink.MouseButton1Click:Connect(function()
    -- Открываем Discord в браузере
    game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/yourdiscordlink")
end)

local toggleKey = CreateToggle(ContentFrame, "Toggle Key: RShift", function(enabled)
    -- Обновляем клавишу для открытия/закрытия меню
end)
toggleKey.Position = UDim2.new(0, 10, 0, 170)

local terminateButton = Instance.new("TextButton")
terminateButton.Parent = ContentFrame
terminateButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
terminateButton.Position = UDim2.new(0, 10, 0, 210)
terminateButton.Size = UDim2.new(1, -20, 0, 30)
terminateButton.Font = Enum.Font.SourceSansBold
terminateButton.Text = "TERMINATE"
terminateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
terminateButton.TextSize = 16

terminateButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    -- Здесь нужно добавить код для отключения всех функций скрипта
end)

-- Анимация появления меню
MainFrame.Position = UDim2.new(0.5, -250, 1.5, 0)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce)
local tween = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, -250, 0.5, -200)})
tween:Play()

-- Создаем уведомление
local Notification = Instance.new("Frame")
Notification.Name = "Notification"
Notification.Parent = ScreenGui
Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Notification.Position = UDim2.new(1, -220, 1, -80)
Notification.Size = UDim2.new(0, 200, 0, 60)

local NotificationTitle = Instance.new("TextLabel")
NotificationTitle.Parent = Notification
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Size = UDim2.new(1, 0, 0, 30)
NotificationTitle.Font = Enum.Font.SourceSansBold
NotificationTitle.Text = "StedHub"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationTitle.TextSize = 18

local NotificationText = Instance.new("TextLabel")
NotificationText.Parent = Notification
NotificationText.BackgroundTransparency = 1
NotificationText.Position = UDim2.new(0, 0, 0, 30)
NotificationText.Size = UDim2.new(1, 0, 0, 30)
NotificationText.Font = Enum.Font.SourceSans
NotificationText.Text = "Loaded!"
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 14

-- Добавляем обводку для уведомления
local NotificationOutline = Instance.new("UIStroke")
NotificationOutline.Parent = Notification
NotificationOutline.Color = Color3.fromRGB(255, 255, 0)
NotificationOutline.Thickness = 2

-- Добавляем обводку для главного меню
local MainFrameOutline = Instance.new("UIStroke")
MainFrameOutline.Parent = MainFrame
MainFrameOutline.Color = Color3.fromRGB(0, 170, 255)
MainFrameOutline.Thickness = 2

-- Config System
local function SaveConfig()
    local config = {
        -- Сохраняем настройки
    }
    writefile("StedHubConfig.json", HttpService:JSONEncode(config))
end

local function LoadConfig()
    if isfile("StedHubConfig.json") then
        local config = HttpService:JSONDecode(readfile("StedHubConfig.json"))
        -- Загружаем настройки
    end
end

LoadConfig()

-- Открытие и закрытие меню
local menuOpen = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
    end
end)
