-- UNIVERSAL GAME DEBUGGER / EXPLORER
-- Scan Remote, Module, UI, Values, New Objects
-- Executor: Solara / Fluxus / Synapse

local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

pcall(function()
    CoreGui:FindFirstChild("UniversalDebugger"):Destroy()
end)

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "UniversalDebugger"
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,850,0,500)
main.Position = UDim2.new(0.5,-425,0.5,-250)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true

local top = Instance.new("TextLabel")
top.Parent = main
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)
top.Text = "UNIVERSAL GAME DEBUGGER"
top.TextColor3 = Color3.new(1,1,1)
top.Font = Enum.Font.Code
top.TextSize = 22

local clear = Instance.new("TextButton")
clear.Parent = main
clear.Size = UDim2.new(0,100,0,28)
clear.Position = UDim2.new(1,-105,0,3)
clear.Text = "CLEAR"
clear.BackgroundColor3 = Color3.fromRGB(50,50,50)
clear.TextColor3 = Color3.new(1,1,1)

local scroll = Instance.new("ScrollingFrame")
scroll.Parent = main
scroll.Position = UDim2.new(0,5,0,40)
scroll.Size = UDim2.new(1,-10,1,-45)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundColor3 = Color3.fromRGB(15,15,15)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0,4)

-------------------------------------------------
-- LOG FUNCTION
-------------------------------------------------

local logs = ""

local function addLog(text)

    logs = logs .. "\n" .. text

    local label = Instance.new("TextLabel")
    label.Parent = scroll
    label.Size = UDim2.new(1,-5,0,120)
    label.BackgroundColor3 = Color3.fromRGB(35,35,35)
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Font = Enum.Font.Code
    label.TextSize = 15
    label.TextWrapped = false
    label.Text = text

    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)

    print(text)

    pcall(function()
        writefile("UniversalDebuggerLogs.txt", logs)
    end)
end

clear.MouseButton1Click:Connect(function()
    for _,v in pairs(scroll:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end)

-------------------------------------------------
-- REMOTE SPY
-------------------------------------------------

pcall(function()

    local oldFire

    oldFire = hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)

        local args = {...}

        local txt = "[REMOTE EVENT]\n"
        txt = txt .. "Name : "..self.Name.."\n"
        txt = txt .. "Path : "..self:GetFullName().."\n\n"

        for i,v in ipairs(args) do
            txt = txt .. "Arg "..i.." : "..tostring(v).."\n"
        end

        addLog(txt)

        return oldFire(self,...)
    end))

end)

pcall(function()

    local oldInvoke

    oldInvoke = hookfunction(Instance.new("RemoteFunction").InvokeServer,newcclosure(function(self,...)

        local args = {...}

        local txt = "[REMOTE FUNCTION]\n"
        txt = txt .. "Name : "..self.Name.."\n"
        txt = txt .. "Path : "..self:GetFullName().."\n\n"

        for i,v in ipairs(args) do
            txt = txt .. "Arg "..i.." : "..tostring(v).."\n"
        end

        addLog(txt)

        return oldInvoke(self,...)
    end))

end)

-------------------------------------------------
-- SCAN REMOTES
-------------------------------------------------

for _,v in pairs(game:GetDescendants()) do

    if v:IsA("RemoteEvent") then
        addLog("[REMOTE EVENT FOUND]\n"..v:GetFullName())
    end

    if v:IsA("RemoteFunction") then
        addLog("[REMOTE FUNCTION FOUND]\n"..v:GetFullName())
    end

end

-------------------------------------------------
-- SCAN MODULES
-------------------------------------------------

for _,v in pairs(game:GetDescendants()) do

    if v:IsA("ModuleScript") then
        addLog("[MODULE]\n"..v:GetFullName())
    end

end

-------------------------------------------------
-- SCAN LOCALSCRIPTS
-------------------------------------------------

for _,v in pairs(game:GetDescendants()) do

    if v:IsA("LocalScript") then
        addLog("[LOCALSCRIPT]\n"..v:GetFullName())
    end

end

-------------------------------------------------
-- SCAN BUTTONS
-------------------------------------------------

for _,v in pairs(game:GetDescendants()) do

    if v:IsA("TextButton") or v:IsA("ImageButton") then
        addLog("[BUTTON]\n"..v:GetFullName())
    end

end

-------------------------------------------------
-- SCAN VALUES
-------------------------------------------------

for _,v in pairs(game:GetDescendants()) do

    if v:IsA("ValueBase") then

        local txt = "[VALUE]\n"
        txt = txt .. v:GetFullName().."\n"
        txt = txt .. "Value : "..tostring(v.Value)

        addLog(txt)
    end

end

-------------------------------------------------
-- WATCH NEW OBJECTS
-------------------------------------------------

game.DescendantAdded:Connect(function(obj)

    local txt = "[NEW OBJECT]\n"
    txt = txt .. obj.ClassName.."\n"
    txt = txt .. obj:GetFullName()

    addLog(txt)

end)

-------------------------------------------------
-- GETGC SCAN
-------------------------------------------------

pcall(function()

    for _,v in pairs(getgc(true)) do

        if type(v) == "table" then

            local found = false

            for k,val in pairs(v) do

                if tostring(k):lower():find("remote") then
                    found = true
                end

                if tostring(k):lower():find("fire") then
                    found = true
                end

            end

            if found then
                addLog("[GETGC TABLE]\n"..tostring(v))
            end

        elseif type(v) == "function" then

            local info = debug.getinfo(v)

            if info.name and info.name ~= "" then
                addLog("[FUNCTION]\n"..info.name)
            end

        end

    end

end)

-------------------------------------------------

addLog("UNIVERSAL DEBUGGER LOADED")
