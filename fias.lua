-- ACTION LOGGER
-- Hanya log saat kamu melakukan aksi
-- Tidak spam ketika idle

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

pcall(function()
    CoreGui:FindFirstChild("ActionLogger"):Destroy()
end)

------------------------------------------------
-- GUI
------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "ActionLogger"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,700,0,420)
frame.Position = UDim2.new(0.5,-350,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Text = "ACTION LOGGER"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Code
title.TextSize = 22

local box = Instance.new("TextBox")
box.Parent = frame
box.Position = UDim2.new(0,5,0,40)
box.Size = UDim2.new(1,-10,1,-45)
box.BackgroundColor3 = Color3.fromRGB(10,10,10)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.MultiLine = true
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextWrapped = false
box.ClearTextOnFocus = false
box.TextEditable = false

------------------------------------------------
-- LOG SYSTEM
------------------------------------------------

local logs = ""
local maxLines = 80

local function addLog(text)

    logs = logs .. "\n" .. text

    local lines = {}

    for line in logs:gmatch("[^\n]+") do
        table.insert(lines,line)
    end

    while #lines > maxLines do
        table.remove(lines,1)
    end

    logs = table.concat(lines,"\n")

    box.Text = logs

    print(text)
end

------------------------------------------------
-- ACTION DETECTION
------------------------------------------------

local actionWindow = false

local function startAction()

    actionWindow = true

    task.delay(3,function()
        actionWindow = false
    end)

end

------------------------------------------------
-- DETECT PLAYER ACTION
------------------------------------------------

UIS.InputBegan:Connect(function(input,gp)

    if gp then
        return
    end

    startAction()

    addLog("[PLAYER ACTION]\n"..input.UserInputType.Name)

end)

------------------------------------------------
-- REMOTE LOGGER
------------------------------------------------

pcall(function()

    local oldFire

    oldFire = hookfunction(
        Instance.new("RemoteEvent").FireServer,
        newcclosure(function(self,...)

            if actionWindow then

                local txt =
                    "[REMOTE EVENT]\n"..
                    self:GetFullName()

                addLog(txt)

            end

            return oldFire(self,...)
        end)
    )

end)

pcall(function()

    local oldInvoke

    oldInvoke = hookfunction(
        Instance.new("RemoteFunction").InvokeServer,
        newcclosure(function(self,...)

            if actionWindow then

                local txt =
                    "[REMOTE FUNCTION]\n"..
                    self:GetFullName()

                addLog(txt)

            end

            return oldInvoke(self,...)
        end)
    )

end)

------------------------------------------------
-- OBJECT LOGGER
------------------------------------------------

game.DescendantAdded:Connect(function(obj)

    if not actionWindow then
        return
    end

    if obj:IsA("Tool")
    or obj:IsA("Folder")
    or obj:IsA("Model") then

        local txt =
            "[NEW OBJECT]\n"..
            obj:GetFullName()

        addLog(txt)

    end

end)

------------------------------------------------

addLog("ACTION LOGGER LOADED")
