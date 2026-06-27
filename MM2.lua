-- MM2 - lore
-- Open code to anyone so you can edit it however you want
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoreMM2UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,60)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0.7,0,1,0)
Title.Position = UDim2.new(0,20,0,0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 - lore"
Title.TextColor3 = Color3.fromRGB(200,140,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0,40,0,40)
MinimizeBtn.Position = UDim2.new(1,-50,0,10)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(200,140,255)
MinimizeBtn.TextScaled = true
MinimizeBtn.Font = Enum.Font.GothamBold

local minimized = false
local currentTab = "ESP"
local originalSize = MainFrame.Size
local TabFrame = Instance.new("Frame", MainFrame)

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local target = minimized and UDim2.new(0,380,0,60) or originalSize
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {Size = target}):Play()
    TabFrame.Visible = not minimized
    for _, page in pairs(Pages) do
        page.Visible = not minimized and (page.Name == currentTab)
    end
end)

-- Tabs
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1,0,0,50)
TabFrame.Position = UDim2.new(0,0,0,60)
TabFrame.BackgroundTransparency = 1

local TabsList = {"ESP", "Misc", "Credits"}
local TabButtons, Pages = {}, {}

for i, name in ipairs(TabsList) do
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(1/#TabsList, -6, 1, 0)
    btn.Position = UDim2.new((i-1)/#TabsList, 3, 0, 0)
    btn.BackgroundColor3 = (name == currentTab and Color3.fromRGB(100,60,180) or Color3.fromRGB(40,40,55))
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    TabButtons[name] = btn

    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Name = name
    page.Size = UDim2.new(1,-20,1,-130)
    page.Position = UDim2.new(0,10,0,120)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 0
    page.Visible = (name == currentTab)
    Instance.new("UIListLayout", page).Padding = UDim.new(0,12)
    Pages[name] = page
end

local function CreateSwitch(parent, text, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,50)
    f.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", f)
    label.Size = UDim2.new(0.65,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,240)
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sw = Instance.new("TextButton", f)
    sw.Size = UDim2.new(0,80,0,40)
    sw.Position = UDim2.new(1,-90,0.5,-20)
    sw.BackgroundColor3 = default and Color3.fromRGB(100,60,200) or Color3.fromRGB(60,60,70)
    sw.Text = ""
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", sw)
    knob.Size = UDim2.new(0,32,0,32)
    knob.Position = default and UDim2.new(1,-36,0.5,-16) or UDim2.new(0,4,0.5,-16)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = default
    sw.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.25), {BackgroundColor3 = state and Color3.fromRGB(100,60,200) or Color3.fromRGB(60,60,70)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.25), {Position = state and UDim2.new(1,-36,0.5,-16) or UDim2.new(0,4,0.5,-16)}):Play()
        callback(state)
    end)
end

-- ESP
local ESPEnabled = true
local SheriffESP = true
local MurdererESP = true
local GunESPEnabled = true
local ESPObjects = {}

local function CreateESP(obj, color, text)
    local bb = Instance.new("BillboardGui")
    bb.Adornee = obj
    bb.Size = UDim2.new(0,160,0,40)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.AlwaysOnTop = true
    bb.Parent = CoreGui
    local tl = Instance.new("TextLabel", bb)
    tl.Size = UDim2.new(1,0,1,0)
    tl.BackgroundTransparency = 1
    tl.Text = text
    tl.TextColor3 = color
    tl.TextScaled = true
    tl.Font = Enum.Font.GothamBold
    tl.TextStrokeTransparency = 0.7
    return bb
end

local function UpdateESPForPlayer(plr)
    if plr == LocalPlayer then return end
    if ESPObjects[plr] then
        for _, esp in pairs(ESPObjects[plr]) do esp:Destroy() end
        ESPObjects[plr] = nil
    end

    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local root = plr.Character.HumanoidRootPart
        local isMurder = plr.Character:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife"))
        local isSheriff = plr.Character:FindFirstChild("Gun") or (plr.Backpack and plr.Backpack:FindFirstChild("Gun"))

        local role = "Innocent"
        local col = Color3.fromRGB(100,255,140)
        if isMurder and MurdererESP then
            role = "MURDERER"
            col = Color3.fromRGB(255,60,60)
        elseif isSheriff and SheriffESP then
            role = "SHERIFF"
            col = Color3.fromRGB(80,180,255)
        end

        if not ESPObjects[plr] then ESPObjects[plr] = {} end
        ESPObjects[plr].Main = CreateESP(root, col, plr.Name.."\n"..role)
    end
end

local function UpdateESP()
    RunService.RenderStepped:Connect(function()
        if not ESPEnabled then
            for _, objs in pairs(ESPObjects) do for _,o in pairs(objs) do o:Destroy() end end
            ESPObjects = {}
            return
        end

        for _, plr in pairs(Players:GetPlayers()) do
            UpdateESPForPlayer(plr)
        end
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.5) UpdateESPForPlayer(plr) end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, esp in pairs(ESPObjects[plr]) do esp:Destroy() end
        ESPObjects[plr] = nil
    end
end)

-- ESP Tab
local espPage = Pages["ESP"]
CreateSwitch(espPage, "ESP Enabled", true, function(v) ESPEnabled = v end)
CreateSwitch(espPage, "Murderer ESP", true, function(v) MurdererESP = v end)
CreateSwitch(espPage, "Sheriff ESP", true, function(v) SheriffESP = v end)
CreateSwitch(espPage, "Dropped Gun ESP", true, function(v) GunESPEnabled = v end)

-- Misc Tab
local miscPage = Pages["Misc"]

local skyboxTextures = {
Original = {Back = "", Down = "", Front = "", Left = "", Right = "", Up = "", Ambient = Color3.fromRGB(128, 128, 128), Brightness = 2, ClockTime = 14},
Sunset = {Back = "rbxassetid://10991226910", Down = "rbxassetid://10991230390", Front = "rbxassetid://10991230403", Left = "rbxassetid://10991230412", Right = "rbxassetid://10991230422", Up = "rbxassetid://10991230431", Ambient = Color3.fromRGB(180, 100, 60), Brightness = 1.5, ClockTime = 18},
Galaxy = {Back = "rbxassetid://10991230441", Down = "rbxassetid://10991230450", Front = "rbxassetid://10991230459", Left = "rbxassetid://10991230468", Right = "rbxassetid://10991230477", Up = "rbxassetid://10991230486", Ambient = Color3.fromRGB(50, 30, 80), Brightness = 1, ClockTime = 2},
Night = {Back = "rbxassetid://8721536396", Down = "rbxassetid://8721536396", Front = "rbxassetid://8721536396", Left = "rbxassetid://8721536396", Right = "rbxassetid://8721536396", Up = "rbxassetid://8721536396", Ambient = Color3.fromRGB(20, 20, 40), Brightness = 0.5, ClockTime = 0},
NorthernLights = {Back = "rbxassetid://12487933162", Down = "rbxassetid://12487934086", Front = "rbxassetid://12487933510", Left = "rbxassetid://12487933721", Right = "rbxassetid://12487933834", Up = "rbxassetid://12487933995", Ambient = Color3.fromRGB(0, 200, 150), Brightness = 1.2, ClockTime = 22},
Storm = {Back = "rbxassetid://12487934367", Down = "rbxassetid://12487934552", Front = "rbxassetid://12487934625", Left = "rbxassetid://12487934736", Right = "rbxassetid://12487934827", Up = "rbxassetid://12487934918", Ambient = Color3.fromRGB(30, 30, 40), Brightness = 0.4, ClockTime = 3},
Dawn = {Back = "rbxassetid://10991226910", Down = "rbxassetid://10991230390", Front = "rbxassetid://10991230403", Left = "rbxassetid://10991230412", Right = "rbxassetid://10991230422", Up = "rbxassetid://10991230431", Ambient = Color3.fromRGB(200, 150, 100), Brightness = 1.8, ClockTime = 5}
}

local function applySkybox(skyType)
    pcall(function()
        if Lighting:FindFirstChild("Sky") then Lighting.Sky:Destroy() end
        local data = skyboxTextures[skyType]
        if not data then return end

        Lighting.Ambient = data.Ambient
        Lighting.Brightness = data.Brightness
        Lighting.ClockTime = data.ClockTime

        if skyType == "Original" then return end

        local sky = Instance.new("Sky")
        sky.Parent = Lighting
        sky.SkyboxBk = data.Back
        sky.SkyboxDn = data.Down
        sky.SkyboxFt = data.Front
        sky.SkyboxLf = data.Left
        sky.SkyboxRt = data.Right
        sky.SkyboxUp = data.Up
    end)
end

local skyDropdown = Instance.new("TextButton", miscPage)
skyDropdown.Size = UDim2.new(1,0,0,50)
skyDropdown.BackgroundColor3 = Color3.fromRGB(70, 40, 130)
skyDropdown.Text = "Skybox: Original"
skyDropdown.TextColor3 = Color3.new(1,1,1)
skyDropdown.TextScaled = true
skyDropdown.Font = Enum.Font.GothamBold
Instance.new("UICorner", skyDropdown).CornerRadius = UDim.new(0,12)

local skyOptions = {"Original", "Sunset", "Galaxy", "Night", "NorthernLights", "Storm", "Dawn"}
local currentSky = 1
skyDropdown.MouseButton1Click:Connect(function()
    currentSky = (currentSky % #skyOptions) + 1
    local skyType = skyOptions[currentSky]
    skyDropdown.Text = "Skybox: " .. skyType
    applySkybox(skyType)
end)

-- Credits
local credPage = Pages["Credits"]
local credLabel = Instance.new("TextLabel", credPage)
credLabel.Size = UDim2.new(1,0,0,160)
credLabel.Position = UDim2.new(0,0,0,20)
credLabel.BackgroundTransparency = 1
credLabel.Text = "Made by Lore\nThank you for using my Script\n@digitallore on discord"
credLabel.TextColor3 = Color3.fromRGB(200,150,255)
credLabel.TextScaled = true
credLabel.Font = Enum.Font.GothamMedium

local killSwitch = Instance.new("TextButton", credPage)
killSwitch.Size = UDim2.new(0.85, 0, 0, 58)
killSwitch.Position = UDim2.new(0.075, 0, 0.5, -29)
killSwitch.BackgroundColor3 = Color3.fromRGB(120, 60, 200)
killSwitch.Text = "KILL SWITCH"
killSwitch.TextColor3 = Color3.new(1,1,1)
killSwitch.TextScaled = true
killSwitch.Font = Enum.Font.GothamBold
Instance.new("UICorner", killSwitch).CornerRadius = UDim.new(0,14)

local grad = Instance.new("UIGradient", killSwitch)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 30, 140))
}

killSwitch.MouseButton1Click:Connect(function()
    -- Full cleanup
    ScreenGui:Destroy()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "LoreMM2UI" then v:Destroy() end
    end
    -- Aggressive ESP cleanup
    for _, objs in pairs(ESPObjects) do
        for _, o in pairs(objs) do
            if o and o.Destroy then o:Destroy() end
        end
    end
    ESPObjects = {}
    ESPEnabled = false
    print("MM2 - lore: Fully killed (ESP removed)")
end)

-- Tab Switching
for name, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for n, p in pairs(Pages) do p.Visible = (n == name) end
        for _, b in pairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = (b == btn and Color3.fromRGB(100,60,180) or Color3.fromRGB(40,40,55))}):Play()
        end
    end)
end

-- Draggable
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local ds = input.Position
        local sp = MainFrame.Position
        local conn = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - ds
                MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
            end
        end)
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end end)
    end
end)

UpdateESP()
print("MM2 - lore")
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
