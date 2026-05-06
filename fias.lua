local filename = "game_dump.txt"

if isfile and isfile(filename) then
    delfile(filename)
end

local data = ""

for _, v in pairs(game:GetDescendants()) do
    data = data .. v:GetFullName() .. "\n"
end

writefile(filename, data)
print("Saved to:", filename)
