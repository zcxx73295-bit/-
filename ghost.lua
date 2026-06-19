-- НАЗВАНИЕ СКРИПТА: HITBOX + AIMBOT + SPINBOT + KILLAURA + PUSH PRO
-- ДЛЯ ТЕЛЕФОНА
-- МЕНЮ С РАЗДЕЛАМИ, ВСЕ ФУНКЦИИ НА МЕСТЕ

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")

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
local pushEnabled = false

local hitboxSize = 5
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
local pushPower = 100
local espColor = Color3.fromRGB(0, 255, 0)
local teammateEspColor = Color3.fromRGB(0, 150, 255)
local showLines = true

local originalWalkSpeed = 16
local originalJumpPower = 50

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HitboxAimbotCSS"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===== ЧЁРНАЯ ИКОНКА =====
local iconButton = Instance.new("ImageButton")
iconButton.Parent = screenGui
iconButton.Size = UDim2.new(0, 55, 0, 55)
iconButton.Position = UDim2.new(0.02, 0, 0.85, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
iconButton.BackgroundTransparency = 0.1
iconButton.BorderSizePixel = 2
iconButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
iconButton.Image = ""

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = iconButton

local letter = Instance.new("TextLabel")
letter.Parent = iconButton
letter.Size = UDim2.new(1, 0, 1, 0)
letter.BackgroundTransparency = 1
letter.Text = "H"
letter.TextColor3 = Color3.fromRGB(255, 255, 255)
letter.TextScaled = true
letter.Font = Enum.Font.GothamBold

local glowBorder = Instance.new("UIStroke")
glowBorder.Parent = iconButton
glowBorder.Thickness = 3
glowBorder.Transparency = 0.1
glowBorder.Color = Color3.fromRGB(255, 0, 0)
glowBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

spawn(function()
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(75,0,130), Color3.fromRGB(238,130,238)}
    local i = 1
    while iconButton and iconButton.Parent do
        glowBorder.Color = colors[i]
        i = i + 1
        if i > #colors then i = 1 end
        task.wait(0.15)
    end
end)

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

-- ПЕРЕТАСКИВАНИЕ ИКОНКИ
local avatarDragging = false
local avatarDragStart = nil
local avatarFrameStart = nil

iconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        avatarDragging = true
        avatarDragStart = input.Position
        avatarFrameStart = iconButton.Position
    end
end)

iconButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        avatarDragging = false
    end
end)

userInputService.TouchMoved:Connect(function(input)
    if avatarDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - avatarDragStart
        iconButton.Position = UDim2.new(
            avatarFrameStart.X.Scale,
            avatarFrameStart.X.Offset + delta.X,
            avatarFrameStart.Y.Scale,
            avatarFrameStart.Y.Offset + delta.Y
        )
    end
end)

-- ===== МЕНЮ С РАЗДЕЛАМИ =====
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, math.min(500, camera.ViewportSize.X - 20), 0, 380)
mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset / 2, 0.03, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Parent = mainFrame
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

-- БАННЕР
local banner = Instance.new("Frame")
banner.Parent = mainFrame
banner.Size = UDim2.new(1, 0, 0, 35)
banner.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
banner.BackgroundTransparency = 0.1
banner.BorderSizePixel = 0

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 16)
bannerCorner.Parent = banner

local title = Instance.new("TextLabel")
title.Parent = banner
title.Size = UDim2.new(1, -35, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "HITBOX PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = banner
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0.5, -14)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.9
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    closeMenu()
end)

-- ПЕРЕТАСКИВАНИЕ МЕНЮ
local menuDragging = false
local menuDragStart = nil
local menuFrameStart = nil

banner.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        menuDragging = true
        menuDragStart = input.Position
        menuFrameStart = mainFrame.Position
    end
end)

banner.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
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

-- АНИМАЦИЯ
local function openMenu()
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.03, 0)
    mainFrame.BackgroundTransparency = 1
    local targetSize = UDim2.new(0, math.min(500, camera.ViewportSize.X - 20), 0, 380)
    tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
        Position = UDim2.new(0.5, -targetSize.X.Offset / 2, 0.03, 0),
        BackgroundTransparency = 0.08
    }):Play()
end

local function closeMenu()
    tweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.2)
    mainFrame.Visible = false
end

iconButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then closeMenu() else openMenu() end
end)

-- ===== КОНТЕНТ С РАЗДЕЛАМИ =====
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = mainFrame
scrollFrame.Size = UDim2.new(1, -10, 1, -45)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 750)

local function createSection(titleText, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = scrollFrame
    frame.Size = UDim2.new(1, 0, 0, 130)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(255, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return frame, label
end

local function createToggleInSection(parent, text, xPos, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0, 90, 0, 30)
    frame.Position = UDim2.new(0, xPos, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.15
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Font = Enum.Font.GothamBold
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 40, 0, 16)
    btn.Position = UDim2.new(0.5, -20, 0.55, 0)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
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
        callback(state)
        updateStatusDot()
    end)
    
    return frame
end

local function createSliderInSection(parent, text, xPos, yPos, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0, 110, 0, 45)
    frame.Position = UDim2.new(0, xPos, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.15
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0.3, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(round(defaultVal))
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Font = Enum.Font.GothamBold
    
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.Size = UDim2.new(0.85, 0, 0, 4)
    slider.Position = UDim2.new(0.075, 0, 0.4, 0)
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
    valueLabel.Size = UDim2.new(1, 0, 0.25, 0)
    valueLabel.Position = UDim2.new(0, 0, 0.75, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(round(defaultVal))
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 9
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
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
        if input.UserInputType == Enum.UserInputType.Touch then
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
    
    return frame
end

local function round(num)
    return math.floor(num * 100 + 0.5) / 100
end

-- ===== РАЗДЕЛ 1: БОЕВЫЕ =====
local section1, _ = createSection("⚔️ БОЕВЫЕ ФУНКЦИИ", 5)
local s1y = 25
createToggleInSection(section1, "HITBOX", 5, s1y, function(s) hitboxEnabled = s end)
createToggleInSection(section1, "AIMBOT", 100, s1y, function(s) aimbotEnabled = s end)
createToggleInSection(section1, "SPINBOT", 195, s1y, function(s) spinbotEnabled = s end)
createToggleInSection(section1, "KILL AURA", 290, s1y, function(s) killAuraEnabled = s end)
s1y = s1y + 35
createToggleInSection(section1, "AUTO KILL", 5, s1y, function(s) autoKillEnabled = s end)
createToggleInSection(section1, "PUSH", 100, s1y, function(s) pushEnabled = s end)
createToggleInSection(section1, "TEAM CHECK", 195, s1y, function(s) checkTeammates = s end)

-- ===== РАЗДЕЛ 2: ДВИЖЕНИЕ =====
local section2, _ = createSection("🏃 ДВИЖЕНИЕ", 145)
local s2y = 25
createToggleInSection(section2, "SPEED", 5, s2y, function(s)
    speedHackEnabled = s
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if s then
            originalWalkSpeed = char.Humanoid.WalkSpeed
            char.Humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        else
            char.Humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end)
createToggleInSection(section2, "NOCLIP", 100, s2y, function(s) noclipEnabled = s end)
createToggleInSection(section2, "FARM", 195, s2y, function(s) autoFarmEnabled = s end)
createToggleInSection(section2, "TELEPORT", 290, s2y, function(s) teleportEnabled = s end)

-- ===== РАЗДЕЛ 3: ESP =====
local section3, _ = createSection("👁️ ESP", 285)
local s3y = 25
createToggleInSection(section3, "ESP", 5, s3y, function(s) espEnabled = s end)
s3y = s3y + 35
createSliderInSection(section3, "ESP RNG", 5, s3y, 20, 100, 50, function(v) espRange = v end)
createSliderInSection(section3, "HIT SIZE", 120, s3y, 1, 500, 5, function(v) hitboxSize = v end)

-- ===== РАЗДЕЛ 4: НАСТРОЙКИ =====
local section4, _ = createSection("⚙️ НАСТРОЙКИ", 430)
local s4y = 25
createSliderInSection(section4, "SPIN SPD", 5, s4y, 100, 999, 999, function(v) spinSpeed = v end)
createSliderInSection(section4, "AIM RNG", 120, s4y, 20, 150, 50, function(v) aimbotRange = v end)
createSliderInSection(section4, "AIM FOV", 235, s4y, 15, 180, 60, function(v) aimbotFOV = v end)
s4y = s4y + 50
createSliderInSection(section4, "KILL RNG", 5, s4y, 10, 80, 30, function(v) killAuraRange = v end)
createSliderInSection(section4, "PUSH PWR", 120, s4y, 50, 500, 100, function(v) pushPower = v end)

-- ===== РАЗДЕЛ 5: КНОПКИ =====
local section5, _ = createSection("📌 КНОПКИ", 580)
local s5y = 25

local function createActionButton(parent, text, xPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0, 100, 0, 28)
    btn.Position = UDim2.new(0, xPos, 0, s5y)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.15
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createActionButton(section5, "TELEPORT", 5, Color3.fromRGB(0, 150, 255), teleportToPlayer)
createActionButton(section5, "PUSH NOW", 110, Color3.fromRGB(200, 100, 255), pushPlayer)
createActionButton(section5, "RESET", 215, Color3.fromRGB(255, 165, 0), function()
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
    pushEnabled = false
    hitboxSize = 5
    spinSpeed = 999
    aimbotRange = 50
    aimbotFOV = 60
    espRange = 50
    killAuraRange = 30
    pushPower = 100
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
createActionButton(section5, "ANTI BAN", 320, Color3.fromRGB(255, 50, 50), function()
    antiBanEnabled = not antiBanEnabled
    print("[ANTI BAN] " .. (antiBanEnabled and "ВКЛЮЧЁН" or "ВЫКЛЮЧЁН"))
end)

-- ===== ФУНКЦИИ =====
local function updateStatusDot()
    if hitboxEnabled or aimbotEnabled or spinbotEnabled or espEnabled or speedHackEnabled or noclipEnabled or autoFarmEnabled or teleportEnabled or killAuraEnabled or autoKillEnabled or pushEnabled then
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

-- ===== PUSH =====
function pushPlayer()
    if not pushEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < 10 then
                    local direction = (targetHrp.Position - hrp.Position).Unit
                    targetHrp.Velocity = direction * pushPower + Vector3.new(0, pushPower * 0.5, 0)
                end
            end
        end
    end
end

userInputService.TouchBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not pushEnabled then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < 5 then
                    local direction = (targetHrp.Position - hrp.Position).Unit
                    targetHrp.Velocity = direction * pushPower + Vector3.new(0, pushPower * 0.5, 0)
                end
            end
        end
    end
end)

-- ===== HITBOX =====
local hitboxes = {}

function clearHitboxes()
    for _, box in pairs(hitboxes) do pcall(function() box:Destroy() end) end
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
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local isTeammate = checkTeammates and isTeammateCheck(plr)
            local color = isTeammate and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
            createHitbox(plr.Character, color)
        end
    end
end

-- ===== ESP =====
local espObjects = {}
local espLabels = {}
local espLines = {}
local espRainbowOutlines = {}

function clearESP()
    for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
    for _, obj in pairs(espLabels) do pcall(function() obj:Destroy() end) end
    espLabels = {}
    for _, obj in pairs(espLines) do pcall(function() obj:Destroy() end) end
    espLines = {}
    for _, obj in pairs(espRainbowOutlines) do pcall(function() obj:Destroy() end) end
    espRainbowOutlines = {}
end

function updateESP()
    clearESP()
    if not espEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(players:GetPlayers()) do
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
                    local box = Instance.new("BoxHandleAdornment")
                    box.Parent = plr.Character
                    box.Size = Vector3.new(4, 5, 2)
                    box.Adornee = targetHrp
                    box.ZIndex = 0
                    box.AlwaysOnTop = true
                    box.Color3 = color
                    box.Transparency = 0.5
                    table.insert(espObjects, box)
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
                    if showLines then
                        local linePart = Instance.new("Part")
                        linePart.Parent = workspace
                        linePart.Size = Vector3.new(0.1, 0.1, (hrp.Position - targetHrp.Position).Magnitude)
                        linePart.CFrame = CFrame.lookAt(hrp.Position, targetHrp.Position) * CFrame.new(0, 0, -linePart.Size.Z / 2)
                        linePart.Anchored = true
                        linePart.CanCollide = false
                        linePart.Transparency = 0.4
                        linePart.BrickColor = BrickColor.new(color)
                        table.insert(espLines, linePart)
                    end
                    if not isTeammate then
                        local rainbowStroke = Instance.new("UIStroke")
                        rainbowStroke.Parent = plr.Character
                        rainbowStroke.Thickness = 2
                        rainbowStroke.Transparency = 0.1
                        rainbowStroke.Color = Color3.fromRGB(255, 0, 0)
                        rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        table.insert(espRainbowOutlines, rainbowStroke)
                        spawn(function()
                            local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(75,0,130), Color3.fromRGB(238,130,238)}
                            local i = 1
                            while rainbowStroke and rainbowStroke.Parent do
                                rainbowStroke.Color = colors[i]
                                i = i + 1
                                if i > #colors then i = 1 end
                                task.wait(0.15)
                            end
                        end)
                    end
                end
            end
        end
    end
end

-- ===== AIMBOT + FOV =====
local fovCircle = nil

function createFOVCircle()
    if fovCircle then pcall(function() fovCircle:Destroy() end) fovCircle = nil end
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
    for _, plr in pairs(players:GetPlayers()) do
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
    for _, plr in pairs(players:GetPlayers()) do
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
    for _, plr in pairs(players:GetPlayers()) do
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
    if aimbotEnabled then
        if not fovCircle then createFOVCircle() end
        if fovCircle then
            fovCircle.Radius = aimbotFOV / 2
            fovCircle.Visible = true
        end
    else
        if fovCircle then pcall(function() fovCircle:Destroy() end) fovCircle = nil end
    end
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
    if spinbotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed / 30), 0)
    end
    if killAuraEnabled then killAura() end
    if autoKillEnabled then autoKill() end
    if pushEnabled then pushPlayer() end
end)

runService.Stepped:Connect(function()
    if noclipEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = false
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CanCollide = true
    end
    if autoFarmEnabled then autoFarm() end
    if teleportEnabled then
        teleportToPlayer()
        task.wait(3)
    end
end)

-- ===== ГОРЯЧИЕ КЛАВИШИ =====
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        if mainFrame.Visible then closeMenu() else openMenu() end
    end
    if input.KeyCode == Enum.KeyCode.F2 then hitboxEnabled = not hitboxEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F3 then aimbotEnabled = not aimbotEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F4 then spinbotEnabled = not spinbotEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F5 then espEnabled = not espEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F6 then speedHackEnabled = not speedHackEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F7 then noclipEnabled = not noclipEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F8 then killAuraEnabled = not killAuraEnabled updateStatusDot() end
    if input.KeyCode == Enum.KeyCode.F9 then pushEnabled = not pushEnabled updateStatusDot() end
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
    pushEnabled = false
    clearHitboxes()
    clearESP()
    if fovCircle then pcall(function() fovCircle:Destroy() end) fovCircle = nil end
    updateStatusDot()
end)

print("HITBOX PRO LOADED (ALL FUNCTIONS)")
print("Нажми на чёрную иконку H для открытия меню")
updateStatusDot()
