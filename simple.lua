-- Instances
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local SideFrame1 = Instance.new("Frame")
local SideFrame2 = Instance.new("Frame")
local SideFrame3 = Instance.new("Frame")
local SideFrame4 = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local UIGradient = Instance.new("UIGradient")

-- Properties
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
-- basically simple mainframe idiotical starters can do
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Base color (black)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 0.5

-- Adding the UIGradient for black to green fade or... (it didnt work)
UIGradient.Parent = MainFrame
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))})
UIGradient.Offset = Vector2.new(0, 0)

local function createRoundedEdge(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = parent
end

createRoundedEdge(MainFrame)

local sideSize = UDim2.new(0, 50, 1, 0)

SideFrame1.Size = sideSize
SideFrame1.Position = UDim2.new(0, -50, 0, 0)
SideFrame1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideFrame1.Parent = ScreenGui
createRoundedEdge(SideFrame1)

SideFrame2.Size = sideSize
SideFrame2.Position = UDim2.new(1, 0, 0, 0)
SideFrame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideFrame2.Parent = ScreenGui
createRoundedEdge(SideFrame2)

SideFrame3.Size = UDim2.new(1, 0, 0, 50)
SideFrame3.Position = UDim2.new(0, 0, 0, -50)
SideFrame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideFrame3.Parent = ScreenGui
createRoundedEdge(SideFrame3)

SideFrame4.Size = UDim2.new(1, 0, 0, 50)
SideFrame4.Position = UDim2.new(0, 0, 1, 0)
SideFrame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideFrame4.Parent = ScreenGui
createRoundedEdge(SideFrame4)

CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10) -- Positioning at the top right corner
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Neon green color for visibility
CloseButton.BackgroundTransparency = 1
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false -- Hide the main frame instead of destroying it
end)

local function createLabel(text, parent, position)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = position
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 255, 0) -- Neon green text
    label.BackgroundTransparency = 1
    label.Parent = parent
end

local function displayDebugInfo() --// Debugger (skid this lua script and never come back.)
    local debugInfo = {
        executor = identifyexecutor(),
        exploitVersion = "Unknown",
        robloxVersion = version(),
        screenResolution = workspace.CurrentCamera.ViewportSize,
        fps = 0
    }

    if syn then
        debugInfo.exploitVersion = syn.version()
    elseif getexecutorname then
        debugInfo.exploitVersion = getexecutorname()
    end

    local lastIteration = tick()
    local frameCount = 0
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastIteration >= 1 then
            debugInfo.fps = frameCount
            frameCount = 0
            lastIteration = tick()
            --≥ The Nice labels for checking.
            createLabel(string.format("Executor: %s", debugInfo.executor), MainFrame, UDim2.new(0, 0, 0, 10))
            createLabel(string.format("Exploit Version: %s", debugInfo.exploitVersion), MainFrame, UDim2.new(0, 0, 0, 40))
            createLabel(string.format("Roblox Version: %s", debugInfo.robloxVersion), MainFrame, UDim2.new(0, 0, 0, 70))
            createLabel(string.format("Resolution: %d x %d", debugInfo.screenResolution.X, debugInfo.screenResolution.Y), MainFrame, UDim2.new(0, 0, 0, 100))
            createLabel(string.format("FPS: %d", debugInfo.fps), MainFrame, UDim2.new(0, 0, 0, 130))
            
            connection:Disconnect()
        end
    end)
end

displayDebugInfo()

function CheckExploitFeatures() -- this is a checker! (very idk)
    local features = {
        {"gethui", gethui},
        {"syn.request", syn and syn.request},
        {"hookfunction", hookfunction},
        {"getgenv", getgenv},
        {"setreadonly", setreadonly},
        {"isnetworkowner", isnetworkowner},
        {"firesignal", firesignal},
        {"getconnections", getconnections},
        {"getcallingscript", getcallingscript},
        {"getloadedmodules", getloadedmodules},
    }

    local availableFeatures = {}
    local unavailableFeatures = {}

    for _, feature in ipairs(features) do
        if feature[2] then
            table.insert(availableFeatures, feature[1])
        else
            table.insert(unavailableFeatures, feature[1])
        end
    end
end

local dragging
local dragInput
local dragStart
local startPos -- very useless dragging mechanism.

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = true
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
