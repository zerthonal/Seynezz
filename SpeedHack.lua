-- Speed Control GUI (без Rayfield)
-- Ключ: SeynezzPidor

local player = game.Players.LocalPlayer
local keyInput = nil
local correctKey = "SeynezzPidor"

-- Функция проверки ключа
local function checkKey()
    local key = string.lower(keyInput)
    if key == string.lower(correctKey) then
        return true
    else
        return false
    end
end

-- Запрашиваем ключ
keyInput = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
-- Простой способ запроса ключа через диалог
local dialog = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local textBox = Instance.new("TextBox")
local submitBtn = Instance.new("TextButton")

dialog.Name = "KeyDialog"
dialog.Parent = player:WaitForChild("PlayerGui")

frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Parent = dialog

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Введите ключ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
title.Parent = frame

textBox.Size = UDim2.new(0, 200, 0, 30)
textBox.Position = UDim2.new(0.5, -100, 0, 50)
textBox.PlaceholderText = "Ключ"
textBox.Parent = frame

submitBtn.Size = UDim2.new(0, 100, 0, 30)
submitBtn.Position = UDim2.new(0.5, -50, 0, 90)
submitBtn.Text = "Войти"
submitBtn.Parent = frame

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local defaultSpeed = humanoid.WalkSpeed

local function createGUI()
    dialog:Destroy() -- Удаляем диалог ввода ключа
    
    -- СОЗДАНИЕ GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpeedGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- ГЛАВНОЕ ОКНО
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 150)
    frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- ЗАГОЛОВОК
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    title.Text = "⚡ SPEED CONTROL ⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame
    
    -- ТЕКУЩАЯ СКОРОСТЬ
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0, 30)
    speedLabel.Position = UDim2.new(0, 0, 0, 35)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Скорость: " .. math.floor(humanoid.WalkSpeed)
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    speedLabel.TextSize = 14
    speedLabel.Parent = frame
    
    -- ПОЛЗУНОК
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 200, 0, 5)
    sliderBg.Position = UDim2.new(0.5, -100, 0, 70)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local dragging = false
    local function updateSpeed(x)
        local width = sliderBg.AbsoluteSize.X
        local percent = math.clamp((x - sliderBg.AbsolutePosition.X) / width, 0, 1)
        local newSpeed = 16 + percent * (350 - 16)
        newSpeed = math.floor(newSpeed)
        humanoid.WalkSpeed = newSpeed
        speedLabel.Text = "Скорость: " .. newSpeed
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSpeed(input.Position.X)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSpeed(input.Position.X)
        end
    end)
    
    -- КНОПКА СБРОСА
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 100, 0, 30)
    resetBtn.Position = UDim2.new(0.5, -50, 0, 100)
    resetBtn.Text = "СБРОС"
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.Parent = frame
    
    resetBtn.MouseButton1Click:Connect(function()
        humanoid.WalkSpeed = defaultSpeed
        speedLabel.Text = "Скорость: " .. defaultSpeed
        local percent = (defaultSpeed - 16) / (350 - 16)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end)
    
    -- ПЕРЕХВАТ ПЕРСОНАЖА
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = defaultSpeed
        speedLabel.Text = "Скорость: " .. defaultSpeed
        sliderFill.Size = UDim2.new((defaultSpeed - 16) / (350 - 16), 0, 1, 0)
    end)
    
    -- КНОПКА ЗАКРЫТИЯ
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Parent = frame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- ПЕРЕТАСКИВАНИЕ ОКНА
    local draggingFrame = false
    local dragStartPos
    local frameStartPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < 30 then
            draggingFrame = true
            dragStartPos = input.Position
            frameStartPos = frame.Position
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingFrame and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingFrame = false
        end
    end)
end

submitBtn.MouseButton1Click:Connect(function()
    keyInput = textBox.Text
    if checkKey() then
        createGUI()
    else
        textBox.Text = ""
        textBox.PlaceholderText = "Неверный ключ"
        wait(1)
        textBox.PlaceholderText = "Ключ"
    end
end)
