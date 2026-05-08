-- Simple Remote Spy GUI
-- Executor: Synapse / Fluxus / Solara compatible

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui.RemoteSpyGUI:Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteSpyGUI"
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 700, 0, 400)
Main.Position = UDim2.new(0.5, -350, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Top = Instance.new("TextLabel")
Top.Parent = Main
Top.Size = UDim2.new(1,0,0,35)
Top.BackgroundColor3 = Color3.fromRGB(30,30,30)
Top.Text = "REMOTE SPY"
Top.TextColor3 = Color3.new(1,1,1)
Top.Font = Enum.Font.SourceSansBold
Top.TextSize = 24

local Clear = Instance.new("TextButton")
Clear.Parent = Main
Clear.Size = UDim2.new(0,100,0,30)
Clear.Position = UDim2.new(1,-110,0,2)
Clear.Text = "CLEAR"
Clear.BackgroundColor3 = Color3.fromRGB(50,50,50)
Clear.TextColor3 = Color3.new(1,1,1)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Position = UDim2.new(0,5,0,40)
Scroll.Size = UDim2.new(1,-10,1,-45)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.BackgroundColor3 = Color3.fromRGB(15,15,15)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0,4)

local function addLog(text)
    local Label = Instance.new("TextLabel")
    Label.Parent = Scroll
    Label.Size = UDim2.new(1,-5,0,120)
    Label.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Top
    Label.Font = Enum.Font.Code
    Label.TextSize = 16
    Label.TextWrapped = false
    Label.Text = text

    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end

Clear.MouseButton1Click:Connect(function()
    for _,v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall

setreadonly(mt,false)

mt.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" or method == "InvokeServer" then

        local txt = ""
        txt = txt .. "Remote : "..self.Name.."\n"
        txt = txt .. "Path   : "..self:GetFullName().."\n"
        txt = txt .. "Method : "..method.."\n\n"

        for i,v in pairs(args) do
            txt = txt .. "Arg "..i.." : "..tostring(v).."\n"
        end

        addLog(txt)

        print(txt)
    end

    return old(self,...)
end)

setreadonly(mt,true)

addLog("Remote Spy Loaded...")
