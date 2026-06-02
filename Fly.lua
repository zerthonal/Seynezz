-- Advanced Flight Script + Anti-Anticheat Bypass
-- By Zerthonal | Система ключей

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "✈️ Advanced Flight",
   LoadingTitle = "Flight System",
   LoadingSubtitle = "By Zerthonal",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Flight System",
      Subtitle = "Введите ключ",
      Note = "",
      FileName = "flight_key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"летаю как мертвая мать сейнеза"}
   }
})

local MainTab = Window:CreateTab("✈️ Управление")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local noclipActive = false

local function getCharacter()
   local char = player.Character
   if not char or not char.Parent then return nil end
   return char
end

local function setNoclip(state)
   noclipActive = state
   local char = getCharacter()
   if not char then return end
   
   for _, part in pairs(char:GetDescendants()) do
      if part:IsA("BasePart") then
         part.CanCollide = not state
      end
   end
end

local function startFly()
   local char = getCharacter()
   if not char then
      Rayfield:Notify({Title = "Ошибка", Content = "Персонаж не загружен", Duration = 2})
      return false
   end
   
   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChild("Humanoid")
   if not hrp or not humanoid then return false end
   
   flying = true
   setNoclip(true)
   
   bodyVelocity = Instance.new("BodyVelocity")
   bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
   bodyVelocity.Velocity = Vector3.new(0, 0, 0)
   bodyVelocity.Parent = hrp
   
   bodyGyro = Instance.new("BodyGyro")
   bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
   bodyGyro.CFrame = hrp.CFrame
   bodyGyro.Parent = hrp
   
   humanoid.PlatformStand = true
   workspace.Gravity = 0
   
   local updateConnection
   updateConnection = RunService.RenderStepped:Connect(function()
      if not flying or not hrp or not hrp.Parent then
         if updateConnection then updateConnection:Disconnect() end
         return
      end
      
      local camera = workspace.CurrentCamera
      local moveDirection = Vector3.new(0, 0, 0)
      
      if UserInputService:IsKeyDown(Enum.KeyCode.W) then
         moveDirection = moveDirection + camera.CFrame.LookVector
      end
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then
         moveDirection = moveDirection - camera.CFrame.LookVector
      end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then
         moveDirection = moveDirection + camera.CFrame.RightVector
      end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then
         moveDirection = moveDirection - camera.CFrame.RightVector
      end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
         moveDirection = moveDirection + Vector3.new(0, 1, 0)
      end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
         moveDirection = moveDirection - Vector3.new(0, 1, 0)
      end
      
      if moveDirection.Magnitude > 0 then
         moveDirection = moveDirection.Unit
      end
      
      local velocity = moveDirection * flySpeed
      bodyVelocity.Velocity = velocity
      
      if velocity.Magnitude > 0 then
         bodyGyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + velocity)
      else
         bodyGyro.CFrame = hrp.CFrame
      end
      
      hrp.Velocity = velocity
   end)
   
   Rayfield:Notify({Title = "Полет", Content = "Активирован | Speed: " .. flySpeed, Duration = 2})
   return true
end

local function stopFly()
   flying = false
   local char = getCharacter()
   if not char then return end
   
   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChild("Humanoid")
   
   if bodyVelocity then bodyVelocity:Destroy() end
   if bodyGyro then bodyGyro:Destroy() end
   bodyVelocity = nil
   bodyGyro = nil
   
   if humanoid then
      humanoid.PlatformStand = false
   end
   
   workspace.Gravity = 196.2
   setNoclip(false)
   
   if hrp then
      hrp.Velocity = Vector3.new(0, 0, 0)
   end
   
   Rayfield:Notify({Title = "Полет", Content = "Деактивирован", Duration = 2})
end

local flightActive = false
MainTab:CreateButton({
   Name = "🔄 ВКЛ/ВЫКЛ ПОЛЕТ",
   Callback = function()
      if not flightActive then
         if startFly() then
            flightActive = true
         end
      else
         stopFly()
         flightActive = false
      end
   end
})

MainTab:CreateSlider({
   Name = "🚀 Скорость полета",
   Range = {10, 300},
   Increment = 5,
   Suffix = "stud/s",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(value)
      flySpeed = value
   end
})

local noclipActiveFlag = false
MainTab:CreateButton({
   Name = "🚪 Отдельный NoClip",
   Callback = function()
      noclipActiveFlag = not noclipActiveFlag
      setNoclip(noclipActiveFlag)
   end
})

player.CharacterAdded:Connect(function()
   if flightActive then
      wait(1)
      startFly()
   end
end)

MainTab:CreateParagraph({
   Title = "📌 Управление",
   Content = "WASD - движение\nПробел - вверх\nCtrl - вниз\n\nСкорость регулируется ползунком"
})

Rayfield:Notify({
   Title = "Flight System",
   Content = "Готов",
   Duration = 3
})
