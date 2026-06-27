local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
-- =============================================
-- Universal ESP made by Lore
-- Yes this was vibe coded :sob:
-- =============================================
local ESP = {
    Enabled = true,
    Boxes = true,
    Bones = true,
    Health = true,
    Names = true,
    Distance = true
}
local drawings = {}
local playerObjects = {}
local ScreenGui, MainFrame

local function createDrawing(type)
    local obj = Drawing.new(type)
    obj.Visible = false
    table.insert(drawings, obj)
    return obj
end

local function worldToViewport(pos)
    local vp, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), onScreen, vp.Z
end

--GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Text = "Universal ESP"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(190, 160, 255)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 50, 0, 50)
MinimizeBtn.Position = UDim2.new(1, -50, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 110, 110)
MinimizeBtn.TextSize = 30
MinimizeBtn.Parent = TitleBar

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 50)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.5, -6, 1, 0)
ESPBtn.Position = UDim2.new(0, 6, 0, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(130, 90, 240)
ESPBtn.Text = "ESP"
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.GothamSemibold
ESPBtn.TextSize = 18
ESPBtn.Parent = TabFrame

local ESPTabCorner = Instance.new("UICorner")
ESPTabCorner.CornerRadius = UDim.new(0, 16)
ESPTabCorner.Parent = ESPBtn

local CreditsBtn = Instance.new("TextButton")
CreditsBtn.Size = UDim2.new(0.5, -6, 1, 0)
CreditsBtn.Position = UDim2.new(0.5, 0, 0, 0)
CreditsBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 160)
CreditsBtn.Text = "Credits"
CreditsBtn.TextColor3 = Color3.new(1,1,1)
CreditsBtn.Font = Enum.Font.GothamSemibold
CreditsBtn.TextSize = 18
CreditsBtn.Parent = TabFrame

local CreditsTabCorner = Instance.new("UICorner")
CreditsTabCorner.CornerRadius = UDim.new(0, 16)
CreditsTabCorner.Parent = CreditsBtn

local ESPScroll = Instance.new("ScrollingFrame")
ESPScroll.Size = UDim2.new(1, -20, 1, -110)
ESPScroll.Position = UDim2.new(0, 10, 0, 105)
ESPScroll.BackgroundTransparency = 1
ESPScroll.ScrollBarThickness = 6
ESPScroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 12)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ESPScroll

local function createToggle(labelText, default, key)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 46)
    container.BackgroundTransparency = 1
    container.Parent = ESPScroll
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "  " .. labelText
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 17
    label.Parent = container
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.35, 0, 0.78, 0)
    toggleBtn.Position = UDim2.new(0.63, 0, 0.11, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(130, 90, 240) or Color3.fromRGB(70, 40, 120)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 15
    toggleBtn.Parent = container
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleBtn
    toggleBtn.MouseButton1Click:Connect(function()
        ESP[key] = not ESP[key]
        toggleBtn.BackgroundColor3 = ESP[key] and Color3.fromRGB(130, 90, 240) or Color3.fromRGB(70, 40, 120)
        toggleBtn.Text = ESP[key] and "ON" or "OFF"
    end)
end

createToggle("Master ESP", true, "Enabled")
createToggle("Boxes", true, "Boxes")
createToggle("Skeleton", true, "Bones")
createToggle("Health Bar", true, "Health")
createToggle("Names", true, "Names")
createToggle("Distance", true, "Distance")
ESPScroll.CanvasSize = UDim2.new(0,0,0, 400)

local CreditsFrame = Instance.new("Frame")
CreditsFrame.Size = UDim2.new(1, -20, 1, -110)
CreditsFrame.Position = UDim2.new(0, 10, 0, 105)
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.Visible = false
CreditsFrame.Parent = MainFrame

local CreditsText = Instance.new("TextLabel")
CreditsText.Size = UDim2.new(1, 0, 0.7, 0)
CreditsText.Position = UDim2.new(0, 0, 0.05, 0)
CreditsText.BackgroundTransparency = 1
CreditsText.Text = "Made by Lore\n\nThank you for using my ESP\n\n@digitallore on discord\n\nIf it wont run its your executor, this was made for potassium"
CreditsText.TextColor3 = Color3.fromRGB(190, 170, 255)
CreditsText.TextSize = 19
CreditsText.Font = Enum.Font.Gotham
CreditsText.TextWrapped = true
CreditsText.TextYAlignment = Enum.TextYAlignment.Top
CreditsText.Parent = CreditsFrame

-- Kill Switch Button with gradient
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0.9, 0, 0, 40)
KillBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
KillBtn.Text = "KILL SCRIPT"
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 18
KillBtn.Parent = CreditsFrame

local KillCorner = Instance.new("UICorner")
KillCorner.CornerRadius = UDim.new(0, 12)
KillCorner.Parent = KillBtn

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 180))
}
UIGradient.Rotation = 0
UIGradient.Parent = KillBtn

KillBtn.MouseButton1Click:Connect(function()
    ESP.Enabled = false
    for _, objs in pairs(playerObjects) do
        for _, obj in pairs(objs) do
            if obj then obj.Visible = false end
        end
        if objs.Bones then
            for _, line in pairs(objs.Bones) do
                if line then line.Visible = false end
            end
        end
    end
    if ScreenGui then ScreenGui:Destroy() end
    print("Lore's ESP - Script Killed")
end)

ESPBtn.MouseButton1Click:Connect(function()
    ESPScroll.Visible = true
    CreditsFrame.Visible = false
    ESPBtn.BackgroundColor3 = Color3.fromRGB(130, 90, 240)
    CreditsBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 160)
end)

CreditsBtn.MouseButton1Click:Connect(function()
    ESPScroll.Visible = false
    CreditsFrame.Visible = true
    ESPBtn.BackgroundColor3 = Color3.fromRGB(80, 55, 160)
    CreditsBtn.BackgroundColor3 = Color3.fromRGB(130, 90, 240)
end)

local minimized = false
local function updateMinimize()
    local visible = not minimized
    TabFrame.Visible = visible
    ESPScroll.Visible = visible and ESPScroll.Visible
    CreditsFrame.Visible = visible and CreditsFrame.Visible
    MainFrame.Size = minimized and UDim2.new(0, 300, 0, 50) or UDim2.new(0, 300, 0, 480)
end

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    updateMinimize()
end)

UserInputService.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        updateMinimize()
    end
end)

-- Cleanup when player leaves
Players.PlayerRemoving:Connect(function(plr)
    if playerObjects[plr] then
        local objs = playerObjects[plr]
        for _, obj in pairs(objs) do
            if obj then obj.Visible = false end
        end
        if objs.Bones then
            for _, line in pairs(objs.Bones) do
                if line then line.Visible = false end
            end
        end
        playerObjects[plr] = nil
    end
end)

--skeleton esp
local function drawSkeleton(objs, char, color)
    if not objs.Bones then objs.Bones = {} end
    local boneConnections = {}

    if char:FindFirstChild("UpperTorso") then
        boneConnections = {
            {char.Head, char.UpperTorso},{char.UpperTorso, char.LowerTorso},
            {char.UpperTorso, char.LeftUpperArm},{char.UpperTorso, char.RightUpperArm},
            {char.LeftUpperArm, char.LeftLowerArm},{char.RightUpperArm, char.RightLowerArm},
            {char.LeftLowerArm, char.LeftHand},{char.RightLowerArm, char.RightHand},
            {char.LowerTorso, char.LeftUpperLeg},{char.LowerTorso, char.RightUpperLeg},
            {char.LeftUpperLeg, char.LeftLowerLeg},{char.RightUpperLeg, char.RightLowerLeg},
            {char.LeftLowerLeg, char.LeftFoot},{char.RightLowerLeg, char.RightFoot},
        }
    else
        boneConnections = {
            {char.Head, char.Torso},
            {char.Torso, char["Left Arm"]},{char.Torso, char["Right Arm"]},
            {char.Torso, char["Left Leg"]},{char.Torso, char["Right Leg"]},
        }
    end

    for i, pair in ipairs(boneConnections) do
        local p1, p2 = pair[1], pair[2]
        if p1 and p2 then
            if not objs.Bones[i] then objs.Bones[i] = createDrawing("Line") end
            local line = objs.Bones[i]
            local pos1, on1 = worldToViewport(p1.Position)
            local pos2, on2 = worldToViewport(p2.Position)
            line.From = pos1
            line.To = pos2
            line.Color = color
            line.Thickness = 2
            line.Visible = on1 and on2
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not ESP.Enabled then
        for _, objs in pairs(playerObjects) do
            for _, obj in pairs(objs) do
                if obj then obj.Visible = false end
            end
            if objs.Bones then
                for _, line in pairs(objs.Bones) do
                    if line then line.Visible = false end
                end
            end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then
            if playerObjects[plr] then
                local objs = playerObjects[plr]
                for _, obj in pairs(objs) do if obj then obj.Visible = false end end
                if objs.Bones then
                    for _, line in pairs(objs.Bones) do if line then line.Visible = false end end
                end
            end
            continue
        end

        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if not (root and head and hum) then continue end

        local rootPos, onScreen, dist = worldToViewport(root.Position)

        if not onScreen or dist > 1200 then
            if playerObjects[plr] then
                local objs = playerObjects[plr]
                for _, obj in pairs(objs) do
                    if obj then obj.Visible = false end
                end
                if objs.Bones then
                    for _, line in pairs(objs.Bones) do
                        if line then line.Visible = false end
                    end
                end
            end
            continue
        end

        if not playerObjects[plr] then playerObjects[plr] = {} end
        local objs = playerObjects[plr]
        local color = Color3.fromRGB(130, 220, 255)

        if ESP.Boxes then
            if not objs.Box then objs.Box = createDrawing("Square") end
            local top = worldToViewport(head.Position + Vector3.new(0, 3, 0))
            local bottom = worldToViewport(root.Position - Vector3.new(0, 3.5, 0))
            local h = math.abs(top.Y - bottom.Y)
            local w = h * 0.6
            objs.Box.Size = Vector2.new(w, h)
            objs.Box.Position = Vector2.new(rootPos.X - w/2, top.Y)
            objs.Box.Color = color
            objs.Box.Thickness = 2.2
            objs.Box.Visible = true
        elseif objs.Box then objs.Box.Visible = false end

        if ESP.Health then
            if not objs.HealthBG then objs.HealthBG = createDrawing("Square") end
            if not objs.Health then objs.Health = createDrawing("Square") end
            local topY = worldToViewport(head.Position + Vector3.new(0,3,0)).Y
            local bottomY = worldToViewport(root.Position - Vector3.new(0,3.5,0)).Y
            local fullH = math.abs(topY - bottomY)

            objs.HealthBG.Size = Vector2.new(5, fullH)
            objs.HealthBG.Position = Vector2.new(rootPos.X - (fullH*0.6)/2 - 12, topY)
            objs.HealthBG.Color = Color3.fromRGB(30,30,30)
            objs.HealthBG.Visible = true

            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local fillH = fullH * hpPct
            objs.Health.Size = Vector2.new(5, fillH)
            objs.Health.Position = Vector2.new(rootPos.X - (fullH*0.6)/2 - 12, bottomY - fillH)
            objs.Health.Color = Color3.fromRGB(255 * (1 - hpPct), 255 * hpPct, 50)
            objs.Health.Visible = true
        elseif objs.Health then
            objs.Health.Visible = false
            if objs.HealthBG then objs.HealthBG.Visible = false end
        end

        if ESP.Names or ESP.Distance then
            if not objs.Text then objs.Text = createDrawing("Text") end
            local str = (ESP.Names and plr.Name or "") .. (ESP.Distance and (" ["..math.floor(dist).."]") or "")
            objs.Text.Text = str
            objs.Text.Position = Vector2.new(rootPos.X, worldToViewport(head.Position).Y - 25)
            objs.Text.Color = color
            objs.Text.Size = 16
            objs.Text.Center = true
            objs.Text.Outline = true
            objs.Text.Visible = true
        elseif objs.Text then objs.Text.Visible = false end

        if ESP.Bones then
            drawSkeleton(objs, char, color)
        elseif objs.Bones then
            for _, line in pairs(objs.Bones) do
                if line then line.Visible = false end
            end
        end
    end
end)

print("Lore's ESP")
print([[
........
: :
: :'': :
: :..: :...
: : :
''''': :'''
     : :
... : :
: : : :
: : : :
: : : :
: : : :
: : : : .
: : : : :'.
: :..: :..:.:..
: : : '.
''''': :'':':'''''
.....:.:..:.:........
: '. Lore
: :'':':'':':'''''''''''
: :..: : : :...............
: : : :
'''''''' ''''''''''''''''''
]])
