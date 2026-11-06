const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)

Color3.fromRGBT = function(R, G, B, T)
	const self = {}
	self.R = R or 255
	self.G = G or 255
	self.B = B or 255
	self.T = T or 0
	self.Transparency = self.T
	self.Color = Color3.fromRGB(self.R, self.G, self.B)

	return self
end

return Color3