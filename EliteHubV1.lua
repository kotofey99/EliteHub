
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()

-- [НАСТРОЙКИ]
local Settings = {
    -- Combat
    AimbotEnabled = false,
    AimbotRadius = 150,
    AimbotPart = "Head",
    WallCheck = true,
    IsAiming = false,
    SpinbotEnabled = false,
    SpinbotSpeed = 25,
    SpinbotOffset = 0,
    DesyncPredict = false, -- Новое: Предикт десинка
    
    -- Hitbox (Новое)
    HitboxEnabled = false,
    HitboxSize = 2,
    
    -- Movement
    BhopEnabled = false,
    BhopSpeed = 50,
    StrafeEnabled = false,
    StrafePower = 25,
    StrafeSpeed = 0.15,
    StrafeBoost = 25
}

local strafeAngle = 0

-- [ОКНО]
local Window = Rayfield:CreateWindow({
   Name = "Sniper Arena | Elite Hub",
   LoadingTitle = "Elite Hub",
   LoadingSubtitle = "by Kotofey",
   ToggleUIKeybind = Enum.KeyCode.RightShift,
   ConfigurationSaving = { Enabled = false }
})

-- [ВКЛАДКИ]
local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabMovement = Window:CreateTab("Movement", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)

-- [COMBAT TAB]
TabCombat:CreateSection("Aimbot & Anti-Aim")
TabCombat:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value) Settings.AimbotEnabled = Value end,
})

TabCombat:CreateToggle({
   Name = "Rage Spinbot (Anti-Aim)",
   CurrentValue = false,
   Callback = function(Value) Settings.SpinbotEnabled = Value end,
})

TabCombat:CreateToggle({
   Name = "Desync Predict (Fake Lag)",
   CurrentValue = false,
   Callback = function(Value) Settings.DesyncPredict = Value end,
})

TabCombat:CreateSlider({
   Name = "Desync Intensity (Сила)",
   Range = {0, 10},
   Increment = 0.1,
   CurrentValue = 0,
   Callback = function(Value) Settings.SpinbotOffset = Value end,
})

TabCombat:CreateKeybind({
   Name = "Aimbot Keybind",
   CurrentKeybind = "E",
   HoldToInteract = true,
   Callback = function(State) Settings.IsAiming = State end,
})

TabCombat:CreateSlider({
   Name = "Aimbot FOV",
   Range = {50, 600},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) Settings.AimbotRadius = Value end,
})

TabCombat:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   Callback = function(Option) Settings.AimbotPart = Option[1] end,
})

TabCombat:CreateSection("Hitbox Expander")
TabCombat:CreateToggle({
   Name = "Enable Big Hitboxes",
   CurrentValue = false,
   Callback = function(Value) Settings.HitboxEnabled = Value end,
})

TabCombat:CreateSlider({
   Name = "Hitbox Size",
   Range = {2, 15},
   Increment = 0.5,
   CurrentValue = 2,
   Callback = function(Value) Settings.HitboxSize = Value end,
})

-- [MOVEMENT TAB]
TabMovement:CreateSection("Bhop (Power Mode)")

TabMovement:CreateToggle({
   Name = "Bhop (Speed Overwrite)",
   CurrentValue = false,
   Callback = function(Value) Settings.BhopEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Bhop Speed",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) Settings.BhopSpeed = Value end,
})

TabMovement:CreateSection("Strafe Settings")

TabMovement:CreateToggle({
   Name = "Air Strafe (Auto)",
   CurrentValue = false,
   Callback = function(Value) Settings.StrafeEnabled = Value end,
})

TabMovement:CreateSlider({
   Name = "Strafe Fly Speed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 25,
   Callback = function(Value) Settings.StrafeBoost = Value end,
})

TabMovement:CreateSlider({
   Name = "Strafe Power",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 25,
   Callback = function(Value) Settings.StrafePower = Value end,
})

TabMovement:CreateSlider({
   Name = "Strafe Frequency",
   Range = {0.01, 0.5},
   Increment = 0.01,
   CurrentValue = 0.15,
   Callback = function(Value) Settings.StrafeSpeed = Value end,
})

-- [VISUALS TAB]
TabVisuals:CreateToggle({
   Name = "Chams (Подсветка тел)",
   CurrentValue = false,
   Callback = function(Value) Sense.teamSettings.enemy.chams = Value end,
})

TabVisuals:CreateToggle({
   Name = "ESP Boxes",
   CurrentValue = false,
   Callback = function(Value) Sense.teamSettings.enemy.box = Value end,
})

TabVisuals:CreateToggle({
   Name = "Show Health",
   CurrentValue = false,
   Callback = function(Value) Sense.teamSettings.enemy.healthBar = Value end,
})

TabVisuals:CreateToggle({
   Name = "Show Names & Distance",
   CurrentValue = false,
   Callback = function(Value) 
      Sense.teamSettings.enemy.names = Value 
      Sense.teamSettings.enemy.distance = Value
   end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) 
        Sense.teamSettings.enemy.boxColor[1] = Value 
        Sense.teamSettings.enemy.chamsFillColor[1] = Value
    end
})

-- [MAIN LOOP]
task.spawn(function()
    while task.wait(0.5) do
        if Settings.HitboxEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild(Settings.AimbotPart) then
                    local part = v.Character[Settings.AimbotPart]
                    part.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    part.Transparency = 0.7
                    part.CanCollide = false
                end
            end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local hum = char.Humanoid
    local cam = workspace.CurrentCamera

    -- 1. Исправленный Rage Spinbot (Anti-Aim) + Предикт
    if Settings.SpinbotEnabled then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinbotSpeed), 0)
        
        if Settings.SpinbotOffset > 0 then
            local predictFactor = Settings.DesyncPredict and (hum.MoveDirection * 8) or Vector3.new(0,0,0)
            local desyncVec = Vector3.new(math.sin(tick() * 20), 0, math.cos(tick() * 20)) * Settings.SpinbotOffset
            hrp.Velocity = hrp.Velocity + desyncVec + predictFactor
        end
    end

    -- 2. Bhop + Strafe
    local isMoving = hum.MoveDirection.Magnitude > 0
    
    if Settings.BhopEnabled and isMoving then
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        local moveDir = hum.MoveDirection
        hrp.Velocity = Vector3.new(moveDir.X * Settings.BhopSpeed, hrp.Velocity.Y, moveDir.Z * Settings.BhopSpeed)
    end

    if Settings.StrafeEnabled and hum.FloorMaterial == Enum.Material.Air and isMoving then
        strafeAngle = (strafeAngle + Settings.StrafeSpeed) % (math.pi * 2)
        local side = cam.CFrame.RightVector * math.sin(strafeAngle) * Settings.StrafePower
        local forward = cam.CFrame.LookVector * Settings.StrafeBoost
        hrp.Velocity = Vector3.new(forward.X + side.X, hrp.Velocity.Y, forward.Z + side.Z)
    end

    -- 3. Aimbot
    if Settings.AimbotEnabled and Settings.IsAiming then
        local target = nil
        local dist = Settings.AimbotRadius
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild(Settings.AimbotPart) then
                local part = v.Character[Settings.AimbotPart]
                local pos, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(lp:GetMouse().X, lp:GetMouse().Y)).Magnitude
                    if mag < dist then target = v; dist = mag end
                end
            end
        end

        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character[Settings.AimbotPart].Position)
        end
    end
end)

Sense.teamSettings.enemy.enabled = true
Sense.Load()
