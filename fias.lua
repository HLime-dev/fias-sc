-- BETTER REMOTE SPY

local StarterGui = game:GetService("StarterGui")

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Remote Spy",
        Text = "Loaded",
        Duration = 5
    })
end)

local oldNamecall

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        if method == "FireServer" or method == "InvokeServer" then

            print("\n========== REMOTE ==========")
            print("Name:", self.Name)
            print("Path:", self:GetFullName())
            print("Method:", method)

            for i,v in ipairs(args) do
                print("Arg "..i..":", v)
            end

            print("============================")
        end
    end

    return oldNamecall(self, ...)
end))
