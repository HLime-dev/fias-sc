local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local TextBox = Instance.new("TextBox", ScreenGui)
TextBox.Size = UDim2.new(0,400,0,300)
TextBox.Position = UDim2.new(0,10,0,10)
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.Text = ""

for _, v in pairs(game:GetDescendants()) do
    TextBox.Text = TextBox.Text .. v:GetFullName() .. "\n"
end
