repeat task.wait() until game:IsLoaded()

local cloneref = cloneref or function(x) return x end
local Services = {
    Players = cloneref(game:GetService("Players")),
    TweenService = cloneref(game:GetService("TweenService")),
    UserInputService = cloneref(game:GetService("UserInputService")),
    MarketplaceService = cloneref(game:GetService("MarketplaceService")),
    CoreGui = cloneref(game:GetService("CoreGui")),
}

-- CONFIG (hapus API & key)
local CONFIG = {
    SCRIPT_TO_LOAD = "https://your-script-url-here.lua", -- GANTI INI
}

-- Utils
local Utils = {}

function Utils.log(msg)
    print("[Loader]", msg)
end

-- Game Detector (tetap dipakai)
local GameDetector = {}

function GameDetector.isSupported()
    return true -- bebas, atau pakai logic lama kalau mau
end

-- UI SEDERHANA (biar tidak ribet, tapi fungsi sama)
local UI = {}

function UI.create()
    local gui = Instance.new("ScreenGui", Services.CoreGui)
    gui.Name = "NoKeyLoader"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "Loader (No Key)"
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1,0,0,30)
    status.Position = UDim2.new(0,0,0,50)
    status.Text = "Ready"
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(180,180,180)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1,-40,0,40)
    button.Position = UDim2.new(0,20,1,-60)
    button.Text = "Execute"
    button.BackgroundColor3 = Color3.fromRGB(0,150,255)
    button.TextColor3 = Color3.new(1,1,1)

    return {
        gui = gui,
        status = status,
        button = button
    }
end

-- Loader
local Loader = {}

function Loader.start()
    local ui = UI.create()

    ui.button.MouseButton1Click:Connect(function()
        if not GameDetector.isSupported() then
            ui.status.Text = "Game not supported"
            return
        end

        ui.status.Text = "Loading script..."

        task.spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(CONFIG.SCRIPT_TO_LOAD))()
            end)

            if ok then
                ui.status.Text = "Loaded!"
                task.wait(1)
                ui.gui:Destroy()
            else
                ui.status.Text = "Error loading"
                warn(err)
            end
        end)
    end)
end

Loader.start()
