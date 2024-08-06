local Library = {}

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

-- Loading Screen
function Library:CreateLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    createGradientBorder(frame)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Text = "Stead Hub"
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 30)
    status.Position = UDim2.new(0, 20, 1, -80)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextSize = 16
    status.Text = "Initializing..."
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Size = UDim2.new(1, -40, 0, 10)
    progressBarBg.Position = UDim2.new(0, 20, 1, -40)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    progressBarBg.BorderSizePixel = 0
    progressBarBg.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBg

    return {
        ScreenGui = screenGui,
        StatusLabel = status,
        ProgressBar = progressBar,
    }
end

-- Main Menu
function Library:CreateMainMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SteadHubMainMenu"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 600, 0, 400)
    frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    createGradientBorder(frame)

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0.3, 0, 1, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = frame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0.7, 0, 1, 0)
    contentFrame.Position = UDim2.new(0.3, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    -- Animation
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween(frame, {Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200)}, 0.5)

    local function createTab(name)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Position = UDim2.new(0, 0, 0, #tabsFrame:GetChildren() * 40)
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        button.BorderSizePixel = 0
        button.Font = Enum.Font.GothamSemibold
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 14
        button.Text = name
        button.Parent = tabsFrame

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -20, 1, -20)
        container.Position = UDim2.new(0, 10, 0, 10)
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
        frame.Size = UDim2.new(1, 0, 0, 60)
        frame.Position = UDim2.new(0, 0, 0, #container:GetChildren() * 70)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamSemibold
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Text = name
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -20, 0, 6)
        sliderBg.Position = UDim2.new(0, 10, 0, 35)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = frame

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -60, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamSemibold
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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

    local function createToggle(container, name, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, #container:GetChildren() * 50)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamSemibold
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Text = name
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.Parent = frame

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = toggleButton

        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 16, 0, 16)
        toggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = toggleCircle

        local toggled = default
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
            tween(toggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
        end)

        return function() return toggled end
    end

    return {
        CreateTab = createTab,
        CreateSlider = createSlider,
        CreateToggle = createToggle,
    }
end

return Library
