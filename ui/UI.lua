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
    local SettingsButton = Instance.new("ImageButton")
    local Tabs = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local Content = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Size = UDim2.new(0, 500, 0, 300)

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
    }
    UIGradient.Rotation = 90
    UIGradient.Parent = Main

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
    Title.Size = UDim2.new(1, -80, 1, 0)
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

    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = TopBar
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Position = UDim2.new(1, -50, 0, 5)
    SettingsButton.Size = UDim2.new(0, 20, 0, 20)
    SettingsButton.Image = "rbxassetid://3926307971"
    SettingsButton.ImageRectOffset = Vector2.new(324, 124)
    SettingsButton.ImageRectSize = Vector2.new(36, 36)

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
    Window.Settings = {
        ToggleKey = Enum.KeyCode.RightShift,
        GradientEnabled = false,
        GradientColor1 = Color3.fromRGB(30, 30, 30),
        GradientColor2 = Color3.fromRGB(45, 45, 45)
    }

    function Window:UpdateGradient()
        if self.Settings.GradientEnabled then
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, self.Settings.GradientColor1),
                ColorSequenceKeypoint.new(1, self.Settings.GradientColor2)
            }
            UIGradient.Enabled = true
        else
            UIGradient.Enabled = false
        end
    end

    function Window:CreateSettingsMenu()
        local SettingsMenu = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local Title = Instance.new("TextLabel")
        local Content = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")

        SettingsMenu.Name = "SettingsMenu"
        SettingsMenu.Parent = Main
        SettingsMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        SettingsMenu.Position = UDim2.new(1, 10, 0, 30)
        SettingsMenu.Size = UDim2.new(0, 200, 0, 250)
        SettingsMenu.Visible = false

        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = SettingsMenu

        Title.Name = "Title"
        Title.Parent = SettingsMenu
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Font = Enum.Font.SourceSansBold
        Title.Text = "Настройки"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 18

        Content.Name = "Content"
        Content.Parent = SettingsMenu
        Content.BackgroundTransparency = 1
        Content.Position = UDim2.new(0, 0, 0, 30)
        Content.Size = UDim2.new(1, 0, 1, -30)
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.ScrollBarThickness = 4

        UIListLayout.Parent = Content
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        local function CreateSetting(name, settingType, default, callback)
            local Setting = Instance.new("Frame")
            Setting.Name = name
            Setting.Parent = Content
            Setting.BackgroundTransparency = 1
            Setting.Size = UDim2.new(1, 0, 0, 30)

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Parent = Setting
            Title.BackgroundTransparency = 1
            Title.Size = UDim2.new(0.5, 0, 1, 0)
            Title.Font = Enum.Font.SourceSans
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            if settingType == "Toggle" then
                local ToggleButton = self:CreateToggle(Setting, default, callback)
                ToggleButton.Position = UDim2.new(1, -40, 0, 5)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            elseif settingType == "Keybind" then
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "KeybindButton"
                KeybindButton.Parent = Setting
                KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                KeybindButton.Position = UDim2.new(1, -80, 0, 5)
                KeybindButton.Size = UDim2.new(0, 70, 0, 20)
                KeybindButton.Font = Enum.Font.SourceSans
                KeybindButton.Text = default.Name
                KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindButton.TextSize = 14

                local listening = false
                KeybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindButton.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        KeybindButton.Text = input.KeyCode.Name
                        callback(input.KeyCode)
                    end
                end)
            elseif settingType == "ColorPicker" then
                local ColorPickerButton = Instance.new("TextButton")
                ColorPickerButton.Name = "ColorPickerButton"
                ColorPickerButton.Parent = Setting
                ColorPickerButton.BackgroundColor3 = default
                ColorPickerButton.Position = UDim2.new(1, -30, 0, 5)
                ColorPickerButton.Size = UDim2.new(0, 20, 0, 20)
                ColorPickerButton.Text = ""

                ColorPickerButton.MouseButton1Click:Connect(function()
                    local ColorPicker = self:CreateColorPicker(default, callback)
                    ColorPicker.Position = UDim2.new(1, 10, 0, 30)
                    ColorPicker.Parent = SettingsMenu
                end)
            end
        end

        CreateSetting("Клавиша переключения", "Keybind", Enum.KeyCode.RightShift, function(key)
            self.Settings.ToggleKey = key
        end)

        CreateSetting("Включить градиент", "Toggle", self.Settings.GradientEnabled, function(enabled)
            self.Settings.GradientEnabled = enabled
            self:UpdateGradient()
        end)

        CreateSetting("Цвет градиента 1", "ColorPicker", self.Settings.GradientColor1, function(color)
            self.Settings.GradientColor1 = color
            self:UpdateGradient()
        end)

        CreateSetting("Цвет градиента 2", "ColorPicker", self.Settings.GradientColor2, function(color)
            self.Settings.GradientColor2 = color
            self:UpdateGradient()
        end)

        return SettingsMenu
    end

    local SettingsMenu = Window:CreateSettingsMenu()

    SettingsButton.MouseButton1Click:Connect(function()
        SettingsMenu.Visible = not SettingsMenu.Visible
    end)

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
            local ToggleButton = Window:CreateToggle(Toggle, default, callback)

            Toggle.Name = text
            Toggle.Parent = TabContent
            Toggle.BackgroundTransparency = 1
            Toggle.Size = UDim2.new(1, -10, 0, 30)

            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundTransparency = 1
            Title.Size = UDim2.new(1, -50, 1, 0)
            Title.Font = Enum.Font.SourceSans
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            ToggleButton.Position = UDim2.new(1, -40, 0, 5)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
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
            SliderBar.Position = UDim2.new(0, 0, 0.5, 0)
            SliderBar.Size = UDim2.new(1, 0, 0, 5)
            SliderBar.AnchorPoint = Vector2.new(0, 0.5)

            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderBar
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.Size = UDim2.new(0, 10, 0, 20)
            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.TextSize = 14
            SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)

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
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 0.5, 0)
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

        function Tab:ColorPicker(text, default, callback)
            local ColorPicker = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ColorButton = Instance.new("TextButton")
    
            ColorPicker.Name = text
            ColorPicker.Parent = TabContent
            ColorPicker.BackgroundTransparency = 1
            ColorPicker.Size = UDim2.new(1, -10, 0, 30)
    
            Title.Name = "Title"
            Title.Parent = ColorPicker
            Title.BackgroundTransparency = 1
            Title.Size = UDim2.new(1, -30, 1, 0)
            Title.Font = Enum.Font.SourceSans
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
    
            ColorButton.Name = "ColorButton"
            ColorButton.Parent = ColorPicker
            ColorButton.BackgroundColor3 = default
            ColorButton.Position = UDim2.new(1, -25, 0, 2.5)
            ColorButton.Size = UDim2.new(0, 25, 0, 25)
            ColorButton.Text = ""
    
            ColorButton.MouseButton1Click:Connect(function()
                local ColorPickerUI = Window:CreateColorPicker(default, callback)
                ColorPickerUI.Position = UDim2.new(1, 10, 0, ColorPicker.AbsolutePosition.Y - Main.AbsolutePosition.Y)
                ColorPickerUI.Parent = Main
            end)
    
            return ColorPicker
        end
    
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            Tab:Select()
        end
    
        return Tab
    end
    
    function Window:CreateToggle(parent, default, callback)
        local ToggleFrame = Instance.new("Frame")
        local ToggleButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
    
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Parent = parent
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
    
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.Size = UDim2.new(0, 18, 0, 18)
        ToggleButton.Position = default and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)
        ToggleButton.Text = ""
    
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = ToggleFrame
    
        local toggled = default
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)}):Play()
            callback(toggled)
        end)
    
        return ToggleFrame
    end
    
    function Window:CreateColorPicker(default, callback)
        local ColorPicker = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local Hue = Instance.new("ImageButton")
        local UICorner_2 = Instance.new("UICorner")
        local Picker = Instance.new("ImageButton")
        local UICorner_3 = Instance.new("UICorner")
        local Preview = Instance.new("Frame")
        local UICorner_4 = Instance.new("UICorner")
        local RGBInput = Instance.new("TextBox")
        local UICorner_5 = Instance.new("UICorner")
    
        ColorPicker.Name = "ColorPicker"
        ColorPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ColorPicker.Size = UDim2.new(0, 200, 0, 220)
    
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = ColorPicker
    
        Hue.Name = "Hue"
        Hue.Parent = ColorPicker
        Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Hue.Position = UDim2.new(0, 10, 0, 10)
        Hue.Size = UDim2.new(0, 180, 0, 20)
        Hue.Image = "rbxassetid://3641079629"
    
        UICorner_2.CornerRadius = UDim.new(0, 5)
        UICorner_2.Parent = Hue
    
        Picker.Name = "Picker"
        Picker.Parent = ColorPicker
        Picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Picker.Position = UDim2.new(0, 10, 0, 40)
        Picker.Size = UDim2.new(0, 180, 0, 130)
        Picker.Image = "rbxassetid://3887014957"
    
        UICorner_3.CornerRadius = UDim.new(0, 5)
        UICorner_3.Parent = Picker
    
        Preview.Name = "Preview"
        Preview.Parent = ColorPicker
        Preview.BackgroundColor3 = default
        Preview.Position = UDim2.new(0, 10, 0, 180)
        Preview.Size = UDim2.new(0, 80, 0, 30)
    
        UICorner_4.CornerRadius = UDim.new(0, 5)
        UICorner_4.Parent = Preview
    
        RGBInput.Name = "RGBInput"
        RGBInput.Parent = ColorPicker
        RGBInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        RGBInput.Position = UDim2.new(0, 100, 0, 180)
        RGBInput.Size = UDim2.new(0, 90, 0, 30)
        RGBInput.Font = Enum.Font.SourceSans
        RGBInput.PlaceholderText = "R, G, B"
        RGBInput.Text = string.format("%d, %d, %d", default.R * 255, default.G * 255, default.B * 255)
        RGBInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        RGBInput.TextSize = 14
    
        UICorner_5.CornerRadius = UDim.new(0, 5)
        UICorner_5.Parent = RGBInput
    
        local function updateColor(color)
            Preview.BackgroundColor3 = color
            RGBInput.Text = string.format("%d, %d, %d", color.R * 255, color.G * 255, color.B * 255)
            callback(color)
        end
    
        local function updateHue(input)
            local hue = 1 - ((input.Position.X - Hue.AbsolutePosition.X) / Hue.AbsoluteSize.X)
            local color = Color3.fromHSV(hue, 1, 1)
            Picker.ImageColor3 = color
            updateColor(color)
        end
    
        local function updatePicker(input)
            local sizeX = Picker.AbsoluteSize.X
            local sizeY = Picker.AbsoluteSize.Y
            local posX = math.clamp((input.Position.X - Picker.AbsolutePosition.X) / sizeX, 0, 1)
            local posY = math.clamp((input.Position.Y - Picker.AbsolutePosition.Y) / sizeY, 0, 1)
            local color = Color3.fromHSV(Picker.ImageColor3:ToHSV(), 1 - posX, 1 - posY)
            updateColor(color)
        end
    
        Hue.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateHue(input)
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateHue(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    
        Picker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updatePicker(input)
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        updatePicker(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    
        RGBInput.FocusLost:Connect(function()
            local r, g, b = RGBInput.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if r and g and b then
                local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                updateColor(color)
            else
                RGBInput.Text = string.format("%d, %d, %d", Preview.BackgroundColor3.R * 255, Preview.BackgroundColor3.G * 255, Preview.BackgroundColor3.B * 255)
            end
        end)
    
        return ColorPicker
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
    
    function Window:Notify(title, description, duration)
        local Notification = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local Title = Instance.new("TextLabel")
        local Description = Instance.new("TextLabel")
    
        Notification.Name = "Notification"
        Notification.Parent = ScreenGui
        Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Notification.Position = UDim2.new(1, -220, 1, 10)
        Notification.Size = UDim2.new(0, 200, 0, 80)
    
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Notification
    
        Title.Name = "Title"
        Title.Parent = Notification
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Font = Enum.Font.SourceSansBold
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.TextXAlignment = Enum.TextXAlignment.Left
    
        Description.Name = "Description"
        Description.Parent = Notification
        Description.BackgroundTransparency = 1
        Description.Position = UDim2.new(0, 10, 0, 30)
        Description.Size = UDim2.new(1, -20, 0, 40)
        Description.Font = Enum.Font.SourceSans
        Description.Text = description
        Description.TextColor3 = Color3.fromRGB(200, 200, 200)
        Description.TextSize = 14
        Description.TextWrapped = true
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Top
    
        Notification:TweenPosition(UDim2.new(1, -220, 1, -90), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
        task.delay(duration, function()
            Notification:TweenPosition(UDim2.new(1, -220, 1, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
            task.wait(0.5)
            Notification:Destroy()
        end)
    end
    
    return Window
    end
    
    return Library
