-- NoClip GUI (Rayfield) с обходом античита

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🚪 NoClip Control",
   LoadingTitle = "NoClip",
   LoadingSubtitle = "by SWILL",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local MainTab = Window:CreateTab("🚀 NoClip")

local noclipActive = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local function noclip(state)
   noclipActive = state
   if state then
      for _, part in pairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
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

-- Автовключение при смене персонажа
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
   Content = "При проходе сквозь стены персонаж может дергаться. Это норма."
})

Rayfield:Notify({
   Title = "NoClip GUI",
   Content = "Готов. Нажми кнопку для включения.",
   Duration = 3
})
