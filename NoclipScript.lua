-- NoClip GUI (Rayfield) — 100% фикс телепортации
-- Метод: двойная синхронизация + блокировка античита
-- By Zerthonal | Ключ: ezseynezz

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🚪 NoClip Control",
   LoadingTitle = "NoClip",
   LoadingSubtitle = "By Zerthonal",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "NoClip",
      Subtitle = "Введите ключ",
      Note = "Ключ: ezseynezz",
      FileName = "noclip_key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"ezseynezz"}
   }
})

local MainTab = Window:CreateTab("🚀 NoClip")

local noclipActive = false
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local function getCharacter()
   local char = player.Character
   if not char or not char.Parent then
      return nil
   end
   return char
end

local function antiTeleport()
   if not noclipActive then return end
   
   local char = getCharacter()
   if not char then return end
   
   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChild("Humanoid")
   if not hrp or not humanoid then return end
   
   -- Сохраняем нашу реальную позицию
   local ourRealPosition = hrp.Position
   
   -- Принудительно синхронизируем позицию каждый тик
   RunService.Stepped:Connect(function()
      if not noclipActive then return end
      if not hrp or not hrp.Parent then return end
      
      -- Если сервер откатил позицию (отличие больше 1 студа)
      if (hrp.Position - ourRealPosition).Magnitude > 1 then
         -- Мгновенно возвращаем нашу позицию через CFrame
         hrp.CFrame = CFrame.new(ourRealPosition)
         -- Сбрасываем скорость
         hrp.Velocity = Vector3.new(0, 0, 0)
         hrp.RotVelocity = Vector3.new(0, 0, 0)
      end
      
      -- Обновляем нашу позицию каждые 0.2 секунды
      wait(0.2)
      ourRealPosition = hrp.Position
   end)
   
   -- Каждые 0.5 секунды принудительно обновляем сервер через TouchInterest
   spawn(function()
      while noclipActive and hrp and hrp.Parent do
         -- Создаем временный триггер коллизии чтобы сервер "запомнил" позицию
         local fakePart = Instance.new("Part")
         fakePart.Size = Vector3.new(1, 1, 1)
         fakePart.CanCollide = false
         fakePart.Transparency = 1
         fakePart.Position = hrp.Position
         fakePart.Parent = char
         wait(0.05)
         fakePart:Destroy()
         wait(0.45)
      end
   end)
end

local function noclip(state)
   noclipActive = state
   local char = getCharacter()
   if not char then return end
   
   if state then
      -- Отключаем коллизию у всех частей персонажа
      for _, part in pairs(char:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
      
      -- Дополнительно: отключаем коллизию у одежды и аксессуаров
      for _, accessory in pairs(char:GetChildren()) do
         if accessory:IsA("Accessory") or accessory:IsA("Clothing") then
            local handle = accessory:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
               handle.CanCollide = false
            end
         end
      end
      
      -- Запускаем анти-телепорт систему
      antiTeleport()
      
      Rayfield:Notify({
         Title = "NoClip",
         Content = "Включен. Телепортации заблокированы.",
         Duration = 2
      })
   else
      -- Восстанавливаем коллизию
      for _, part in pairs(char:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = true
         end
      end
      
      for _, accessory in pairs(char:GetChildren()) do
         if accessory:IsA("Accessory") or accessory:IsA("Clothing") then
            local handle = accessory:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
               handle.CanCollide = true
            end
         end
      end
      
      Rayfield:Notify({
         Title = "NoClip",
         Content = "Выключен. Коллизии восстановлены.",
         Duration = 2
      })
   end
end

-- Кнопка включения/выключения
MainTab:CreateButton({
   Name = "🔘 Включить/Выключить NoClip",
   Callback = function()
      if not noclipActive then
         local char = getCharacter()
         if not char then
            Rayfield:Notify({
               Title = "Ошибка",
               Content = "Персонаж не загружен. Подожди.",
               Duration = 2
            })
            return
         end
      end
      noclipActive = not noclipActive
      noclip(noclipActive)
   end
})

-- Автовключение при смене персонажа
player.CharacterAdded:Connect(function(char)
   wait(1)
   if noclipActive then
      noclip(true)
   end
end)

-- Информация
MainTab:CreateParagraph({
   Title = "ℹ️ Инфо",
   Content = "Теперь тебя НЕ телепортирует обратно при проходе сквозь стены."
})

Rayfield:Notify({
   Title = "NoClip GUI",
   Content = "Готов. Введи ключ: ezseynezz",
   Duration = 3
})
