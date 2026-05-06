local important = {
    game.Workspace,
    game.ReplicatedStorage,
    game.Players,
    game.StarterPlayer,
    game.StarterGui,
    game.Lighting
}

local data = {}

for _, folder in ipairs(important) do
    for _, v in pairs(folder:GetDescendants()) do
        local ok, result = pcall(function()
            return v.ClassName .. " | " .. v:GetFullName()
        end)

        if ok then
            table.insert(data, result)
        end
    end
end

writefile("important_dump.txt", table.concat(data, "\n"))
print("Done dump folder penting")
