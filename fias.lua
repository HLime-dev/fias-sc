-- SIMPLE ACTIVITY LOGGER

local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui.ActivityLogger:Destroy()
end)

------------------------------------------------
-- GUI
------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "ActivityLogger"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,650,0,400)
frame.Position = UDim2.new(0.5,-325,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Text = "ACTIVITY LOGGER"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Code
title.TextSize = 22

local box = Instance.new("TextBox")
box.Parent = frame
box.Position = UDim2.new(0,5,0,40)
box.Size = UDim2.new(1,-10,1,-45)
box.BackgroundColor3 = Color3.fromRGB(15,15,15)
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
-- LOG FUNCTION
------------------------------------------------

local logs = ""
local maxLines = 120

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
-- REMOTE SPY
------------------------------------------------

pcall(function()

    local oldFire

    oldFire = hookfunction(
        Instance.new("RemoteEvent").FireServer,
        newcclosure(function(self,...)

            addLog(
                "[REMOTE EVENT]\n" ..
                self:GetFullName()
            )

            return oldFire(self,...)
        end)
    )

end)

pcall(function()

    local oldInvoke

    oldInvoke = hookfunction(
        Instance.new("RemoteFunction").InvokeServer,
        newcclosure(function(self,...)

            addLog(
                "[REMOTE FUNCTION]\n" ..
                self:GetFullName()
            )

            return oldInvoke(self,...)
        end)
    )

end)

------------------------------------------------
-- OBJECT WATCHER
------------------------------------------------

game.DescendantAdded:Connect(function(obj)

    if obj:IsA("Folder")
    or obj:IsA("Model")
    or obj:IsA("Tool")
    or obj:IsA("Part") then

        addLog(
            "[NEW OBJECT]\n" ..
            obj.ClassName ..
            "\n" ..
            obj:GetFullName()
        )

    end

end)

------------------------------------------------

addLog("LOGGER LOADED")
