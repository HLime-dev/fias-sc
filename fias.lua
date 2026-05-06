local data = ""

for _, v in pairs(game:GetDescendants()) do
    data = data .. v:GetFullName() .. "\n"
end

writefile("game_dump.txt", data)
print("Selesai! Disimpan ke game_dump.txt")
