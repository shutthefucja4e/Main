local SteadHub = {}

-- Utility functions
local function createGradientBorder(frame)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
    }
    uiGradient.Parent = frame
end

local function tween(object, properties, duration)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Loading Menu
local function createLoadingMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingMenu"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 250)
    frame.Position = UDim2.new(0.5, -100, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Text = "Stead Hub"
    title.Parent = frame

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0, 100, 0, 100)
    image.Position = UDim2.new(0.5, -50, 0, 50)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://0" -- Replace with your image ID
    image.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 1, -50)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextSize = 14
    status.Text = "UI Initialization"
    status.Parent = frame

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Size = UDim2.new(0.9, 0, 0, 10)
    progressBarBg.Position = UDim2.new(0.05, 0, 1, -20)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    progressBarBg.BorderSizePixel = 0
    progressBarBg.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBg

    createGradientBorder(frame)

    return {
        ScreenGui = screenGui,
        StatusLabel = status,
        ProgressBar = progressBar,
    }
end

-- Notification
local function createNotification(text)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Notification"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(1, -220, 1, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Text = text
    label.TextWrapped = true
    label.Parent = frame

    createGradientBorder(frame)

    tween(frame, {Position = UDim2.new(1, -220, 1, -70)}, 0.5)
    wait(3)
    tween(frame, {Position = UDim2.new(1, 20, 1, -70)}, 0.5).Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Main Menu
local function createMainMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SteadHubMainMenu"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0.3, 0, 1, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = frame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0.7, 0, 1, 0)
    contentFrame.Position = UDim2.new(0.3, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = frame

    createGradientBorder(frame)

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    -- Animation
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween(frame, {Size = UDim2.new(0, 400, 0, 300), Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.5)

    local function createTab(name)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.Position = UDim2.new(0, 0, 0, #tabsFrame:GetChildren() * 30)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderSizePixel = 0
        button.Font = Enum.Font.Gotham
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Text = name
        button.Parent = tabsFrame

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.BorderSizePixel = 0
        container.ScrollBarThickness = 4
        container.Visible = false
        container.Parent = contentFrame

        button.MouseButton1Click:Connect(function()
            for _, child in pairs(contentFrame:GetChildren()) do
                child.Visible = false
            end
            container.Visible = true
        end)

        return container
    end

    local function createSlider(container, name, min, max, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.Position = UDim2.new(0, 10, 0, #container:GetChildren() * 60)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Text = name
        label.Parent = frame

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 10)
        sliderBg.Position = UDim2.new(0, 0, 0, 30)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = frame

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -50, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 14
        valueLabel.Text = tostring(default)
        valueLabel.Parent = frame

        local value = default
        local dragging = false

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativePos = mousePos - sliderBg.AbsolutePosition
                local percentage = math.clamp(relativePos.X / sliderBg.AbsoluteSize.X, 0, 1)
                value = min + (max - min) * percentage
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                valueLabel.Text = string.format("%.2f", value)
            end
        end)

        return function() return value end
    end

    local function createDropdown(container, name, options)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.Position = UDim2.new(0, 10, 0, #container:GetChildren() * 60)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Text = name
        label.Parent = frame

        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 30)
        dropdownButton.Position = UDim2.new(0, 0, 0, 20)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        dropdownButton.BorderSizePixel = 0
        dropdownButton.Font = Enum.Font.Gotham
        dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdownButton.TextSize = 14
        dropdownButton.Text = options[1]
        dropdownButton.Parent = frame

        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        dropdownFrame.Position = UDim2.new(0, 0, 1, 0)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.Visible = false
        dropdownFrame.ZIndex = 10
        dropdownFrame.Parent = dropdownButton

        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            optionButton.BorderSizePixel = 0
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 14
            optionButton.Text = option
            optionButton.ZIndex = 11
            optionButton.Parent = dropdownFrame

            optionButton.MouseButton1Click:Connect(function()
                dropdownButton.Text = option
                dropdownFrame.Visible = false
            end)
        end

        dropdownButton.MouseButton1Click:Connect(function()
            dropdownFrame.Visible = not dropdownFrame.Visible
        end)

        return function() return dropdownButton.Text end
    end

    local function createToggle(container, name, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 30)
        frame.Position = UDim2.new(0, 10, 0, #container:GetChildren() * 40)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Text = name
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.Parent = frame

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = toggleButton

        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = default and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = toggleCircle

        local toggled = default
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            tween(toggleCircle, {Position = toggled and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)}, 0.2)
        end)

        return function() return toggled end
    end

    return {
        CreateTab = createTab,
        CreateSlider = createSlider,
        CreateDropdown = createDropdown,
        CreateToggle = createToggle,
    }
end

function SteadHub.init()
    local loadingMenu = createLoadingMenu()
    
    for i = 1, 100 do
        wait(0.05)
        loadingMenu.StatusLabel.Text = "UI Initialization [Downloading " .. i .. "%]"
        loadingMenu.ProgressBar.Size = UDim2.new(i/100, 0, 1, 0)
    end
    
    loadingMenu.ScreenGui:Destroy()
    
    createNotification("Stead Hub: Successfully loaded!")
    
    local mainMenu = createMainMenu()
    
    -- Example usage:
    local generalTab = mainMenu.CreateTab("General")
    local visualsTab = mainMenu.CreateTab("Visuals")
    
    mainMenu.CreateSlider(generalTab, "Walk Speed", 16, 100, 16)
    mainMenu.CreateDropdown(generalTab, "Team", {"Red", "Blue", "Green"})
    mainMenu.CreateToggle(generalTab, "Infinite Jump", false)
    
    mainMenu.CreateSlider(visualsTab, "FOV", 70, 120, 90)
    mainMenu.CreateToggle(visualsTab, "ESP", false)
    
    return mainMenu
end

return SteadHub
