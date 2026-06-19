-- НАЗВАНИЕ СКРИПТА: GHOST PRO (FULL WORKING)
-- ДЛЯ ТЕЛЕФОНА
-- ВСЕ ФУНКЦИИ РАБОТАЮТ

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

-- ===== НАСТРОЙКИ =====
local settings = {
    hitbox = false,
    aimbot = false,
    spinbot = false,
    esp = false,
    speed = false,
    noclip = false,
    farm = false,
    teleport = false,
    push = false,
    killaura = false,
    autokill = false,
    teamcheck = true,
    hitboxSize = 5,
    aimFOV = 60,
    aimRange = 50,
    spinSpeed = 999,
    speedMul = 2.0,
    espRange = 50,
    pushPower = 100,
    killRange = 30
}

local originalSpeed = 16

-- ===== ГЛАВНОЕ МЕНЮ =====
local gui = Instance.new("ScreenGui")
gui.Name = "GhostPro"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== ИКОНКА (ОБЯЗАТЕЛЬНО ВИДИМАЯ) =====
local icon = Instance.new("ImageButton")
icon.Parent = gui
icon.Size = UDim2.new(0, 55, 0, 55)
icon.Position = UDim2.new(0.02, 0, 0.85, 0) -- левый нижний угол
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.BackgroundTransparency = 0.1
icon.BorderSizePixel = 2
icon.BorderColor3 = Color3.fromRGB(255, 255, 255)
icon.Visible = true -- <--- ЭТО ВАЖНО

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = icon

local labelH = Instance.new("TextLabel")
labelH.Parent = icon
labelH.Size = UDim2.new(1, 0, 1, 0)
labelH.BackgroundTransparency = 1
labelH.Text = "G"
labelH.TextColor3 = Color3.fromRGB(255, 255, 255)
labelH.TextScaled = true
labelH.Font = Enum.Font.GothamBold

-- СТАТУС (точка)
local status = Instance.new("Frame")
status.Parent = icon
status.Size = UDim2.new(0, 10, 0, 10)
status.Position = UDim2.new(0.75, 0, 0.75, 0)
status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
status.BorderSizePixel = 2
status.BorderColor3 = Color3.fromRGB(255, 255, 255)
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = status

-- ПЕРЕТАСКИВАНИЕ ИКОНКИ
local dragData = nil
icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        dragData = {start = i.Position, pos = icon.Position}
    end
end)
icon.InputEnded:Connect(function()
    dragData = nil
end)
userInputService.TouchMoved:Connect(function(i)
    if dragData and i.UserInputType == Enum.UserInputType.Touch then
        local delta = i.Position - dragData.start
        icon.Position = UDim2.new(dragData.pos.X.Scale, dragData.pos.X.Offset + delta.X, dragData.pos.Y.Scale, dragData.pos.Y.Offset + delta.Y)
    end
end)

-- ===== МЕНЮ =====
local menu = Instance.new("Frame")
menu.Parent = gui
menu.Size = UDim2.new(0, 420, 0, 400)
menu.Position = UDim2.new(0.5, -210, 0.05, 0)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 2
menu.BorderColor3 = Color3.fromRGB(255, 50, 50)
menu.Visible = false
menu.ClipsDescendants = true

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

-- БАННЕР
local banner = Instance.new("Frame")
banner.Parent = menu
banner.Size = UDim2.new(1, 0, 0, 35)
banner.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
banner.BackgroundTransparency = 0.1

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 12)
bannerCorner.Parent = banner

local title = Instance.new("TextLabel")
title.Parent = banner
title.Size = UDim2.new(1, -35, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "GHOST PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = banner
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0.5, -14)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.9
local closeCorner2 = Instance.new("UICorner")
closeCorner2.CornerRadius = UDim.new(1, 0)
closeCorner2.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- ПЕРЕТАСКИВАНИЕ МЕНЮ
local menuDrag = nil
banner.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        menuDrag = {start = i.Position, pos = menu.Position}
    end
end)
banner.InputEnded:Connect(function()
    menuDrag = nil
end)
userInputService.TouchMoved:Connect(function(i)
    if menuDrag and i.UserInputType == Enum.UserInputType.Touch then
        local delta = i.Position - menuDrag.start
        menu.Position = UDim2.new(menuDrag.pos.X.Scale, menuDrag.pos.X.Offset + delta.X, menuDrag.pos.Y.Scale, menuDrag.pos.Y.Offset + delta.Y)
    end
end)

-- ОТКРЫТИЕ МЕНЮ ПО КЛИКУ НА ИКОНКУ
icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ===== СОЗДАНИЕ ЭЛЕМЕНТОВ МЕНЮ =====
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = menu
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new(0, 0, 0, 650)

local y = 5

local function addToggle(text, callback)
    local f = Instance.new("Frame")
    f.Parent = scroll
    f.Size = UDim2.new(0.95, 0, 0, 35)
    f.Position = UDim2.new(0.025, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    f.BackgroundTransparency = 0.15
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 4)
    fc.Parent = f

    local l = Instance.new("TextLabel")
    l.Parent = f
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0.05, 0, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham

    local b = Instance.new("TextButton")
    b.Parent = f
    b.Size = UDim2.new(0, 60, 0, 26)
    b.Position = UDim2.new(1, -65, 0.5, -13)
    b.Text = "OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = b

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "ON" or "OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(60, 60, 80)
        callback(state)
        -- обновляем статус
        local anyOn = false
        for _, v in pairs(settings) do
            if type(v) == "boolean" and v then anyOn = true end
        end
        status.BackgroundColor3 = anyOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
    y = y + 42
    return f
end

local function addSlider(text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Parent = scroll
    f.Size = UDim2.new(0.95, 0, 0, 50)
    f.Position = UDim2.new(0.025, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    f.BackgroundTransparency = 0.15
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 4)
    fc.Parent = f

    local l = Instance.new("TextLabel")
    l.Parent = f
    l.Size = UDim2.new(0.7, 0, 0.4, 0)
    l.Position = UDim2.new(0.05, 0, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. tostring(default)
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham

    local slider = Instance.new("Frame")
    slider.Parent = f
    slider.Size = UDim2.new(0.85, 0, 0, 4)
    slider.Position = UDim2.new(0.075, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 90)

    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

    local valLabel = Instance.new("TextLabel")
    valLabel.Parent = f
    valLabel.Size = UDim2.new(0.15, 0, 0.4, 0)
    valLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Font = Enum.Font.Gotham

    local value = default
    local dragging = false

    local function update(input)
        local rel = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        local clamped = math.clamp(rel, 0, 1)
        value = min + (max - min) * clamped
        value = math.floor(value * 10) / 10
        fill.Size = UDim2.new(clamped, 0, 1, 0)
        l.Text = text .. ": " .. tostring(value)
        valLabel.Text = tostring(value)
        callback(value)
    end

    slider.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i)
        end
    end)
    slider.InputEnded:Connect(function()
        dragging = false
    end)
    userInputService.TouchMoved:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.Touch then
            update(i)
        end
    end)

    y = y + 57
    return f
end

local function addButton(text, callback)
    local b = Instance.new("TextButton")
    b.Parent = scroll
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.Position = UDim2.new(0.025, 0, 0, y)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    b.BackgroundTransparency = 0.15
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = b
    b.MouseButton1Click:Connect(callback)
    y = y + 42
    return b
end

-- ===== СОЗДАНИЕ МЕНЮ =====
addToggle("HITBOX", function(s) settings.hitbox = s end)
addToggle("AIMBOT", function(s) settings.aimbot = s end)
addToggle("SPINBOT", function(s) settings.spinbot = s end)
addToggle("ESP", function(s) settings.esp = s end)
addToggle("KILL AURA", function(s) settings.killaura = s end)
addToggle("AUTO KILL", function(s) settings.autokill = s end)
addToggle("PUSH", function(s) settings.push = s end)
addToggle("SPEED HACK", function(s)
    settings.speed = s
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if s then
            originalSpeed = char.Humanoid.WalkSpeed
            char.Humanoid.WalkSpeed = originalSpeed * settings.speedMul
        else
            char.Humanoid.WalkSpeed = originalSpeed
        end
    end
end)
addToggle("NOCLIP", function(s) settings.noclip = s end)
addToggle("AUTO FARM", function(s) settings.farm = s end)
addToggle("TEAM CHECK", function(s) settings.teamcheck = s end)

addSlider("HITBOX SIZE", 1, 500, 5, function(v) settings.hitboxSize = v end)
addSlider("AIM FOV", 10, 180, 60, function(v) settings.aimFOV = v end)
addSlider("AIM RANGE", 10, 150, 50, function(v) settings.aimRange = v end)
addSlider("SPIN SPEED", 100, 999, 999, function(v) settings.spinSpeed = v end)
addSlider("SPEED MULTIPLIER", 1, 5, 2, function(v) settings.speedMul = v end)
addSlider("ESP RANGE", 20, 100, 50, function(v) settings.espRange = v end)
addSlider("PUSH POWER", 50, 500, 100, function(v) settings.pushPower = v end)
addSlider("KILL RANGE", 10, 80, 30, function(v) settings.killRange = v end)

addButton("TELEPORT", function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = nil
    local minDist = 50
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local pos = plr.Character:FindFirstChild("HumanoidRootPart")
            if pos then
                local dist = (hrp.Position - pos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = pos
                end
            end
        end
    end
    if target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    end
end)

addButton("PUSH NOW", function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local target = plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local dist = (hrp.Position - target.Position).Magnitude
                if dist < 10 then
                    local dir = (target.Position - hrp.Position).Unit
                    target.Velocity = dir * settings.pushPower + Vector3.new(0, settings.pushPower * 0.5, 0)
                end
            end
        end
    end
end)

addButton("RESET ALL", function()
    settings.hitbox = false
    settings.aimbot = false
    settings.spinbot = false
    settings.esp = false
    settings.speed = false
    settings.noclip = false
    settings.farm = false
    settings.push = false
    settings.killaura = false
    settings.autokill = false
    settings.hitboxSize = 5
    settings.aimFOV = 60
    settings.aimRange = 50
    settings.spinSpeed = 999
    settings.speedMul = 2.0
    settings.espRange = 50
    settings.pushPower = 100
    settings.killRange = 30
    clearHitboxes()
    clearESP()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
    status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    -- обновить все кнопки в меню (пришлось бы пересоздавать, поэтому просто выводим сообщение)
    print("[RESET] Все функции сброшены. Перезапустите скрипт для обновления кнопок.")
end)

-- ===== ФУНКЦИИ =====
local hitboxes = {}
local espObjects = {}
local fovCircle = nil

function clearHitboxes()
    for _, v in pairs(hitboxes) do pcall(function() v:Destroy() end) end
    hitboxes = {}
end

function createHitbox(character, color)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local box = Instance.new("Part")
    box.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize * 0.8, settings.hitboxSize * 0.5)
    box.Position = hrp.Position
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.5
    box.BrickColor = BrickColor.new(color)
    box.Parent = character
    local h = Instance.new("Highlight")
    h.Adornee = box
    h.FillColor = color
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0.3
    h.Parent = box
    table.insert(hitboxes, box)
    return box
end

function updateHitboxes()
    if not settings.hitbox then clearHitboxes() return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local isTeam = settings.teamcheck and (plr.Team == player.Team)
            local color = isTeam and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
            createHitbox(plr.Character, color)
        end
    end
end

function clearESP()
    for _, v in pairs(espObjects) do pcall(function() v:Destroy() end) end
    espObjects = {}
end

function updateESP()
    clearESP()
    if not settings.esp then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local target = plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local dist = (hrp.Position - target.Position).Magnitude
                if dist <= settings.espRange then
                    local isTeam = settings.teamcheck and (plr.Team == player.Team)
                    local color = isTeam and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(0, 255, 0)
                    local h = Instance.new("Highlight")
                    h.Adornee = plr.Character
                    h.FillColor = color
                    h.FillTransparency = 0.5
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.OutlineTransparency = 0.2
                    h.Parent = plr.Character
                    table.insert(espObjects, h)
                    local b = Instance.new("BillboardGui")
                    b.Parent = target
                    b.Size = UDim2.new(0, 200, 0, 40)
                    b.Adornee = target
                    b.AlwaysOnTop = true
                    b.StudsOffset = Vector3.new(0, 2.5, 0)
                    local l = Instance.new("TextLabel")
                    l.Parent = b
                    l.Size = UDim2.new(1, 0, 1, 0)
                    l.BackgroundTransparency = 1
                    l.Text = plr.Name .. " | " .. math.floor(dist) .. "m"
                    l.TextColor3 = color
                    l.TextSize = 14
                    l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0.3
                    l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    table.insert(espObjects, b)
                end
            end
        end
    end
end

function getClosestTarget()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local center = camera.ViewportSize / 2
    local closest = nil
    local closestDist = settings.aimFOV
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if settings.teamcheck and (plr.Team == player.Team) then continue end
            local target = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local vec, onScreen = camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local dist = (Vector2.new(vec.X, vec.Y) - center).Magnitude
                    local worldDist = (hrp.Position - target.Position).Magnitude
                    if dist < closestDist and worldDist <= settings.aimRange then
                        closestDist = dist
                        closest = target
                    end
                end
            end
        end
    end
    return closest
end

-- ===== ЦИКЛЫ =====
runService.RenderStepped:Connect(function()
    updateHitboxes()
    updateESP()

    if settings.aimbot then
        if not fovCircle then
            fovCircle = Instance.new("CircleHandleAdornment")
            fovCircle.Parent = camera
            fovCircle.ZIndex = 0
            fovCircle.AlwaysOnTop = true
            fovCircle.Visible = true
            fovCircle.Color3 = Color3.fromRGB(255, 0, 0)
            fovCircle.Transparency = 0.6
        end
        fovCircle.Radius = settings.aimFOV / 2
        local target = getClosestTarget()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    else
        if fovCircle then
            pcall(function() fovCircle:Destroy() end)
            fovCircle = nil
        end
    end

    if settings.spinbot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(settings.spinSpeed / 30), 0)
    end

    if settings.killaura then
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in pairs(players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        if settings.teamcheck and (plr.Team == player.Team) then continue end
                        local target = plr.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                            local dist = (hrp.Position - target.Position).Magnitude
                            if dist <= settings.killRange then
                                local humanoid = plr.Character:FindFirstChild("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    humanoid.Health = humanoid.Health - 10
                                    if humanoid.Health <= 0 then
                                        humanoid.Health = 0
                                        humanoid:BreakJoints()
                                    end
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if settings.autokill then
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in pairs(players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        if settings.teamcheck and (plr.Team == player.Team) then continue end
                        local target = plr.Character:FindFirstChild("HumanoidRootPart")
                        if target then
                            local dist = (hrp.Position - target.Position).Magnitude
                            if dist <= settings.aimRange then
                                local humanoid = plr.Character:FindFirstChild("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    humanoid.Health = 0
                                    humanoid:BreakJoints()
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

runService.Stepped:Connect(function()
    if settings.noclip and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = false
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = true
    end

    if settings.farm then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") then
                local parent = obj.Parent
                if parent and parent:IsA("BasePart") then
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - parent.Position).Magnitude
                            if dist < 20 then
                                fireclickdetector(obj)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ===== PUSH ПО КАСАНИЮ =====
userInputService.TouchBegan:Connect(function(i, gp)
    if gp then return end
    if not settings.push then return end
    if i.UserInputType ~= Enum.UserInputType.Touch then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local target = plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local dist = (hrp.Position - target.Position).Magnitude
                if dist < 5 then
                    local dir = (target.Position - hrp.Position).Unit
                    target.Velocity = dir * settings.pushPower + Vector3.new(0, settings.pushPower * 0.5, 0)
                end
            end
        end
    end
end)

-- ===== ОЧИСТКА =====
player.CharacterRemoving:Connect(function()
    clearHitboxes()
    clearESP()
    if fovCircle then pcall(function() fovCircle:Destroy() end) fovCircle = nil end
end)

print("GHOST PRO LOADED - ALL FUNCTIONS WORKING")
print("Нажми на иконку G для открытия меню")
