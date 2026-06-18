-- НАЗВАНИЕ СКРИПТА: HITBOX + AIMBOT + SPINBOT + KILLAURA PRO
-- ДЛЯ ТЕЛЕФОНА
-- ФУНКЦИИ: Хитбоксы прозрачные, ESP с именем/дистанцией, SpinBot быстрый, KillAura, AutoKill, FOV круг, SpeedHack, Teleport, Noclip, AutoFarm

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")

-- ===== НАСТРОЙКИ =====
local hitboxEnabled = false
local aimbotEnabled = false
local spinbotEnabled = false
local espEnabled = false
local speedHackEnabled = false
local noclipEnabled = false
local autoFarmEnabled = false
local teleportEnabled = false
local antiBanEnabled = false
local killAuraEnabled = false
local autoKillEnabled = false

local hitboxSize = 5
local hitboxTransparency = 0.5
local aimbotRange = 50
local aimbotFOV = 60
local aimbotPart = "Head"
local checkTeammates = true
local spinSpeed = 999
local speedMultiplier = 2.0
local espRange = 50
local teleportRange = 50
local farmDelay = 0.5
local killAuraRange = 30
local killAuraDelay = 0.1
local espColor = Color3.fromRGB(255, 0, 0)
local teammateEspColor = Color3.fromRGB(0, 255, 0)

local originalWalkSpeed = 16
local originalJumpPower = 50

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxAimbotCSS"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ИКОНКА
local iconButton = Instance.new("ImageButton")
iconButton.Parent = screenGui
iconButton.Size = UDim2.new(0, 50, 0, 50)
iconButton.Position = UDim2.new(0.02, 0, 0.85, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
iconButton.BackgroundTransparency = 0.15
iconButton.BorderSizePixel = 2
iconButton.BorderColor3 = Color3.fromRGB(255, 50, 50)
iconButton.Image = "rbxassetid://6031090977"
iconButton.ImageTransparency = 0.1

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = iconButton

local statusIndicator = Instance.new("Frame")
statusIndicator.Parent = iconButton
statusIndicator.Size = UDim2.new(0, 10, 0, 10)
statusIndicator.Position = UDim2.new(0.75, 0, 0.75, 0)
statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
statusIndicator.BorderSizePixel = 2
statusIndicator.BorderColor3 = Color3.fromRGB(255, 255, 255)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusIndicator

-- ГЛАВНОЕ МЕНЮ
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 340, 0, 500)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Parent = mainFrame
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- БАННЕР
local banner = Instance.new("Frame")
banner.Parent = mainFrame
banner.Size = UDim2.new(1, 0, 0, 50)
banner.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
banner.BackgroundTransparency = 0.1
banner.BorderSizePixel = 0

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 12)
bannerCorner.Parent = banner

local title = Instance.new("TextLabel")
title.Parent = banner
title.Size = UDim2.new(1, -45, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "HITBOX PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold

local subTitle = Instance.new("TextLabel")
subTitle.Parent = banner
subTitle.Size = UDim2.new(1, -45, 0.3, 0)
subTitle.Position = UDim2.new(0, 8, 0.65, 0)
subTitle.BackgroundTransparency = 1
subTitle.Text = "All Functions"
subTitle.TextColor3 = Color3.fromRGB(255, 200, 200)
subTitle.TextSize = 10
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.Font = Enum.Font.Gotham

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = banner
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.9
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ПЕРЕТАСКИВАНИЕ
local menuDragging = false
local menuDragStart = nil
local menuFrameStart = nil

banner.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDragging = true
        menuDragStart = input.Position
        menuFrameStart = mainFrame.Position
    end
end)

banner.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDragging = false
    end
end)

userInputService.TouchMoved:Connect(function(input)
    if menuDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - menuDragStart
        mainFrame.Position = UDim2.new(
            menuFrameStart.X.Scale,
            menuFrameStart.X.Offset + delta.X,
            menuFrameStart.Y.Scale,
            menuFrameStart.Y.Offset + delta.Y
        )
    end
end)

-- СКРОЛЛ
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -16, 1, -70)
contentFrame.Position = UDim2.new(0, 8, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 3
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 950)

-- ===== УТИЛИТЫ =====
local function round(num)
    return math.floor(num * 100 + 0.5) / 100
end

local function updateStatusDot()
    if hitboxEnabled or aimbotEnabled or spinbotEnabled or espEnabled or speedHackEnabled or noclipEnabled or autoFarmEnabled or teleportEnabled or killAuraEnabled or autoKillEnabled then
        statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local function isTeammateCheck(targetPlayer)
    if player.Team and targetPlayer.Team == player.Team then return true end
    if player:FindFirstChild("Team") and targetPlayer:FindFirstChild("Team") then
        if player.Team.Name == targetPlayer.Team.Name then return true end
    end
    return false
end

-- ===== СОЗДАНИЕ TOGGLE =====
function createToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = contentFrame
    frame.Size = UDim2.new(0.95, 0, 0, 38)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.15
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. " OFF"
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(1, -68, 0.5, -13)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(60, 60, 80)
        label.Text = text .. (state and " ON" or " OFF")
        callback(state)
        updateStatusDot()
    end)
    
    return frame
end

-- ===== СОЗДАНИЕ СЛАЙДЕРА =====
function createSlider(text, yPos, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = contentFrame
    frame.Size = UDim2.new(0.95, 0, 0, 55)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.15
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 0.35, 0)
    label.Position = UDim2.new(0.05, 0, 0.05, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(round(defaultVal))
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.Size = UDim2.new(0.85, 0, 0, 5)
    slider.Position = UDim2.new(0.075, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    local fCorner2 = Instance.new("UICorner")
    fCorner2.CornerRadius = UDim.new(1, 0)
    fCorner2.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.15, 0, 0.35, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0.05, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(round(defaultVal))
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    
    local value = defaultVal
    local dragging = false
    
    local function updateSlider(input)
        local relative = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        local clamped = math.clamp(relative, 0, 1)
        value = minVal + (maxVal - minVal) * clamped
        value = round(value)
        fill.Size = UDim2.new(clamped, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
        valueLabel.Text = tostring(value)
        callback(value)
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    slider.InputEnded:Connect(function()
        dragging = false
    end)
    
    userInputService.TouchMoved:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return frame
end

-- ===== СОЗДАНИЕ КНОПКИ =====
function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = contentFrame
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.15
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== РАСПОЛОЖЕНИЕ =====
local yPos = 5

createToggle("HITBOX", yPos, function(state) hitboxEnabled = state end)
yPos = yPos + 45

createToggle("AIMBOT", yPos, function(state) aimbotEnabled = state end)
yPos = yPos + 45

createToggle("SPINBOT", yPos, function(state) spinbotEnabled = state end)
yPos = yPos + 45

createToggle("ESP", yPos, function(state) espEnabled = state end)
yPos = yPos + 45

createToggle("KILL AURA", yPos, function(state) killAuraEnabled = state end)
yPos = yPos + 45

createToggle("AUTO KILL", yPos, function(state) autoKillEnabled = state end)
yPos = yPos + 45

createToggle("SPEED HACK", yPos, function(state)
    speedHackEnabled = state
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            originalWalkSpeed = char.Humanoid.WalkSpeed
            char.Humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        else
            char.Humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end)
yPos = yPos + 45

createToggle("NOCLIP", yPos, function(state) noclipEnabled = state end)
yPos = yPos + 45

createToggle("AUTO FARM", yPos, function(state) autoFarmEnabled = state end)
yPos = yPos + 45

createToggle("TELEPORT", yPos, function(state) teleportEnabled = state end)
yPos = yPos + 45

createToggle("TEAM CHECK", yPos, function(state) checkTeammates = state end)
yPos = yPos + 45

createToggle("ANTI BAN", yPos, function(state) antiBanEnabled = state end)
yPos = yPos + 45

-- СЛАЙДЕРЫ
createSlider("HITBOX SIZE", yPos, 1, 500, 5, function(val) hitboxSize = val end)
yPos = yPos + 65

createSlider("SPIN SPEED", yPos, 100, 999, 999, function(val) spinSpeed = val end)
yPos = yPos + 65

createSlider("AIM RANGE", yPos, 20, 150, 50, function(val) aimbotRange = val end)
yPos = yPos + 65

createSlider("AIM FOV", yPos, 15, 180, 60, function(val) aimbotFOV = val end)
yPos = yPos + 65

createSlider("ESP RANGE", yPos, 20, 100, 50, function(val) espRange = val end)
yPos = yPos + 65

createSlider("KILL AURA RANGE", yPos, 10, 80, 30, function(val) killAuraRange = val end)
yPos = yPos + 65

createSlider("SPEED MULTIPLIER", yPos, 1.0, 5.0, 2.0, function(val)
    speedMultiplier = val
    if speedHackEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        end
    end
end)
yPos = yPos + 65

-- КНОПКИ
createButton("TELEPORT TO PLAYER", yPos, Color3.fromRGB(0, 150, 255), function()
    teleportToPlayer()
end)
yPos = yPos + 45

createButton("RESET ALL", yPos, Color3.fromRGB(255, 165, 0), function()
    hitboxEnabled = false
    aimbotEnabled = false
    spinbotEnabled = false
    espEnabled = false
    speedHackEnabled = false
    noclipEnabled = false
    autoFarmEnabled = false
    teleportEnabled = false
    antiBanEnabled = false
    killAuraEnabled = false
    autoKillEnabled = false
    hitboxSize = 5
    spinSpeed = 999
    aimbotRange = 50
    aimbotFOV = 60
    espRange = 50
    killAuraRange = 30
    speedMultiplier = 2.0
    clearHitboxes()
    clearESP()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
    updateStatusDot()
    print("[RESET] Все функции сброшены")
end)

-- ===== ОТКРЫТИЕ МЕНЮ =====
iconButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ===== HITBOX (ПРОЗРАЧНЫЙ) =====
local hitboxes = {}

function clearHitboxes()
    for _, box in pairs(hitboxes) do
        pcall(function() box:Destroy() end)
    end
    hitboxes = {}
end

function createHitbox(character, color)
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = #hitboxes, 1, -1 do
        if hitboxes[i] and hitboxes[i].Parent == character then
            pcall(function() hitboxes[i]:Destroy() end)
            table.remove(hitboxes, i)
        end
    end
    
    local box = Instance.new("Part")
    box.Size = Vector3.new(hitboxSize, hitboxSize * 0.8, hitboxSize * 0.5)
    box.Position = hrp.Position
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.5
    box.BrickColor = BrickColor.new(color)
    box.Parent = character
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = box
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.3
    highlight.Parent = box
    
    table.insert(hitboxes, box)
    return box
end

function updateHitboxes()
    if not hitboxEnabled then clearHitboxes() return end
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character then
            local isTeammate = checkTeammates and isTeammateCheck(plr)
            local color = isTeammate and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            createHitbox(plr.Character, color)
        end
    end
end

-- ===== ESP С ИМЕНЕМ И ДИСТАНЦИЕЙ =====
local espObjects = {}
local espLabels = {}

function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    for _, obj in pairs(espLabels) do
        pcall(function() obj:Destroy() end)
    end
    espLabels = {}
end

function updateESP()
    clearESP()
    if not espEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist <= espRange then
                    local isTeammate = checkTeammates and isTeammateCheck(plr)
                    local color = isTeammate and teammateEspColor or espColor
                    
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = plr.Character
                    highlight.FillColor = color
                    highlight.FillTransparency = 0.4
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0.2
                    highlight.Parent = plr.Character
                    table.insert(espObjects, highlight)
                    
                    -- Квадрат вокруг игрока
                    local box = Instance.new("BoxHandleAdornment")
                    box.Parent = plr.Character
                    box.Size = Vector3.new(4, 5, 2)
                    box.Adornee = targetHrp
                    box.ZIndex = 0
                    box.AlwaysOnTop = true
                    box.Color3 = color
                    box.Transparency = 0.6
                    table.insert(espObjects, box)
                    
                    -- Текст с именем и дистанцией
                    local billboard = Instance.new("BillboardGui")
                    billboard.Parent = targetHrp
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.Adornee = targetHrp
                    billboard.AlwaysOnTop = true
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = billboard
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = plr.Name .. " | " .. math.floor(dist) .. "м"
                    label.TextColor3 = color
                    label.TextSize = 14
                    label.Font = Enum.Font.GothamBold
                    label.TextStrokeTransparency = 0.3
                    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    table.insert(espLabels, billboard)
                end
            end
        end
    end
end

-- ===== AIMBOT + FOV КРУГ =====
local fovCircle = nil

function createFOVCircle()
    if fovCircle then
        pcall(function() fovCircle:Destroy() end)
        fovCircle = nil
    end
    if not aimbotEnabled then return end
    
    fovCircle = Instance.new("CircleHandleAdornment")
    fovCircle.Parent = camera
    fovCircle.Radius = aimbotFOV / 2
    fovCircle.ZIndex = 0
    fovCircle.Color3 = Color3.fromRGB(255, 0, 0)
    fovCircle.Transparency = 0.6
    fovCircle.AlwaysOnTop = true
    fovCircle.Visible = true
end

function getClosestTarget()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local center = camera.ViewportSize / 2
    local closestDist = aimbotFOV
    local closestTarget = nil
    
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character then
            if checkTeammates and isTeammateCheck(plr) then continue end
            local targetPart = plr.Character:FindFirstChild(aimbotPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(vector.X, vector.Y) - center).Magnitude
                    local worldDist = (hrp.Position - targetPart.Position).Magnitude
                    if dist < closestDist and worldDist <= aimbotRange then
                        closestDist = dist
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ===== KILL AURA =====
function killAura()
    if not killAuraEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character then
            if checkTeammates and isTeammateCheck(plr) then continue end
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist <= killAuraRange then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        humanoid.Health = humanoid.Health - 10
                        if humanoid.Health <= 0 then
                            humanoid.Health = 0
                            humanoid:BreakJoints()
                        end
                        task.wait(killAuraDelay)
                    end
                end
            end
        end
    end
end

-- ===== AUTO KILL =====
function autoKill()
    if not autoKillEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character then
            if checkTeammates and isTeammateCheck(plr) then continue end
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist <= aimbotRange then
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

-- ===== TELEPORT =====
function teleportToPlayer()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = nil
    local minDist = teleportRange
    
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
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
        print("[TELEPORT] Телепорт выполнен")
    else
        print("[TELEPORT] Игрок не найден")
    end
end

-- ===== AUTO FARM =====
function autoFarm()
    if not autoFarmEnabled then return end
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
                            task.wait(farmDelay)
                        end
                    end
                end
            end
        end
    end
end

-- ===== ОСНОВНЫЕ ЦИКЛЫ =====
runService.RenderStepped:Connect(function()
    if hitboxEnabled then updateHitboxes() else clearHitboxes() end
    if espEnabled then updateESP() else clearESP() end
    
    -- FOV круг
    if aimbotEnabled then
        if not fovCircle then createFOVCircle() end
        if fovCircle then
            fovCircle.Radius = aimbotFOV / 2
            fovCircle.Visible = true
        end
    else
        if fovCircle then
            pcall(function() fovCircle:Destroy() end)
            fovCircle = nil
        end
    end
    
    -- Aimbot
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            if hitboxEnabled then
                local character = target.Parent
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.Health = character.Humanoid.Health - 5
                    if character.Humanoid.Health <= 0 then
                        character.Humanoid.Health = 0
                        character.Humanoid:BreakJoints()
                    end
                end
            end
        end
    end
    
    -- SpinBot (быстрый, даже при ходьбе)
    if spinbotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed / 30), 0)
    end
    
    -- Kill Aura
    if killAuraEnabled then
        killAura()
    end
    
    -- Auto Kill
    if autoKillEnabled then
        autoKill()
    end
end)

runService.Stepped:Connect(function()
    if noclipEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = false
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = true
    end
    
    if autoFarmEnabled then
        autoFarm()
    end
    
    if teleportEnabled then
        teleportToPlayer()
        task.wait(3)
    end
end)

-- ===== ГОРЯЧИЕ КЛАВИШИ =====
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then mainFrame.Visible = not mainFrame.Visible end
    if input.KeyCode == Enum.KeyCode.F2 then hitboxEnabled = not hitboxEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F3 then aimbotEnabled = not aimbotEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F4 then spinbotEnabled = not spinbotEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F5 then espEnabled = not espEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F6 then speedHackEnabled = not speedHackEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F7 then noclipEnabled = not noclipEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F8 then killAuraEnabled = not killAuraEnabled updateStatusDot() end
end)

-- ===== ОБРАБОТЧИК =====
player.CharacterRemoving:Connect(function()
    hitboxEnabled = false
    aimbotEnabled = false
    spinbotEnabled = false
    espEnabled = false
    speedHackEnabled = false
    noclipEnabled = false
    autoFarmEnabled = false
    teleportEnabled = false
    killAuraEnabled = false
    autoKillEnabled = false
    clearHitboxes()
    clearESP()
    if fovCircle then
        pcall(function() fovCircle:Destroy() end)
        fovCircle = nil
    end
    updateStatusDot()
end)

-- ===== ПРИВЕТСТВИЕ =====
print("HITBOX + AIMBOT + SPINBOT + KILLAURA PRO LOADED")
print("F1 - MENU | F2 - HITBOX | F3 - AIMBOT | F4 - SPINBOT")
print("F5 - ESP | F6 - SPEED | F7 - NOCLIP | F8 - KILLAURA")
updateStatusDot()
