-- NoClip GUI (Rayfield) с обходом античита и фиксом телепортации
-- By Zerthonal

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
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local lastPosition = hrp.Position
local lastCFrame = hrp.CFrame

-- Функция для принудительного обновления позиции на сервере
local function updatePosition()
   if not character or not hrp then return end
   -- Устанавливаем позицию через CFrame, чтобы сервер "запомнил" новое местоположение
   hrp.CFrame = hrp.CFrame
   -- Дополнительная синхронизация через корневую часть
   if character:FindFirstChild("HumanoidRootPart") then
      character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
   end
end

local function noclip(state)
   noclipActive = state
   if state then
      -- Запоминаем позицию перед включением ноклипа
      lastPosition = hrp.Position
      lastCFrame = hrp.CFrame
      
      for _, part in pairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
      
      -- Запускаем цикл для постоянного обновления позиции
      spawn(function()
         while noclipActive and character and hrp do
            -- Если позиция сильно изменилась (проход сквозь стену), обновляем сервер
            if (hrp.Position - lastPosition).Magnitude > 5 then
               updatePosition()
               lastPosition = hrp.Position
               lastCFrame = hrp.CFrame
            end
            wait(0.1)
         end
      end)
      
      Rayfield:Notify({
         Title = "NoClip",
         Content = "Включен. Проходи сквозь стены.",
         Duration = 2
      })
   else
      for _, part in pairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = true
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
      noclipActive = not noclipActive
      noclip(noclipActive)
   end
})

-- Автовключение при смене персонажа с сохранением состояния
player.CharacterAdded:Connect(function(newChar)
   character = newChar
   hrp = character:WaitForChild("HumanoidRootPart")
   humanoid = character:WaitForChild("Humanoid")
   if noclipActive then
      wait(0.5)
      noclip(true)
   end
end)

-- Информация
MainTab:CreateParagraph({
   Title = "ℹ️ Инфо",
   Content = "При проходе сквозь стены персонаж больше не телепортирует назад."
})

Rayfield:Notify({
   Title = "NoClip GUI",
   Content = "Готов. Введи ключ: ezseynezz",
   Duration = 3
})
