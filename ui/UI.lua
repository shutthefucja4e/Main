local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library.new(title)
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local Tabs = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local Content = Instance.new("Frame")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    UICorner_2.CornerRadius = UDim.new(0, 10)
    UICorner_2.Parent = TopBar

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14

    Tabs.Name = "Tabs"
    Tabs.Parent = Main
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0, 10, 0, 40)
    Tabs.Size = UDim2.new(0, 120, 1, -50)

    UIListLayout.Parent = Tabs
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 140, 0, 40)
    Content.Size = UDim2.new(1, -150, 1, -50)

    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil

    function Window:Tab(name)
        local TabButton = Instance.new("TextButton")
        local TabContent = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")

        TabButton.Name = name
        TabButton.Parent = Tabs
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14

        TabContent.Name = name
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false

        UIListLayout.Parent = TabContent
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        local Tab = {}
        Tab.Content = TabContent

        function Tab:Select()
            if Window.ActiveTab then
                Window.ActiveTab.Content.Visible = false
            end
            TabContent.Visible = true
            Window.ActiveTab = Tab
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        function Tab:Button(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Parent = TabContent
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Font = Enum.Font.SourceSans
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14

            Button.MouseButton1Click:Connect(callback)
            return Button
        end

        function Tab:Toggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")

            Toggle.Name = text
            Toggle.Parent = TabContent
            Toggle.BackgroundTransparency = 1
            Toggle.Size = UDim2.new(1, -10, 0, 30)

            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Size = UDim2.new(1, -30, 1, 0)
            Title.Font = Enum.Font.SourceSans
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Toggle
            ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            ToggleButton.Position = UDim2.new(1, 0, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 20, 0, 20)
            ToggleButton.Font = Enum.Font.SourceSans
            ToggleButton.Text = ""
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.TextSize = 14

            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                callback(toggled)
            end)

            return Toggle
        end

        function Tab:Slider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local SliderButton = Instance.new("TextButton")
            local Value = Instance.new("TextLabel")

            Slider.Name = text
            Slider.Parent = TabContent
            Slider.BackgroundTransparency = 1
            Slider.Size = UDim2.new(1, -10, 0, 50)

            Title.Name = "Title"
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Size = UDim2.new(1, 0, 0, 20)
            Title.Font = Enum.Font.SourceSans
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBar.Position = UDim2.new(0, 0, 0, 25)
            SliderBar.Size = UDim2.new(1, 0, 0, 5)

            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderBar
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.Size = UDim2.new(0, 10, 0, 20)
            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.TextSize = 14

            Value.Name = "Value"
            Value.Parent = Slider
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(0, 0, 0, 30)
            Value.Size = UDim2.new(1, 0, 0, 20)
            Value.Font = Enum.Font.SourceSans
            Value.Text = tostring(default)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14
            Value.TextXAlignment = Enum.TextXAlignment.Right

            local function updateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 0, 0)
                SliderButton.Position = pos
                local value = math.floor(min + (max - min) * pos.X.Scale)
                Value.Text = tostring(value)
                callback(value)
            end

            SliderButton.MouseButton1Down:Connect(function()
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
            end)

            return Slider
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            Tab:Select()
        end

        return Tab
    end

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return Window
end

return Library
