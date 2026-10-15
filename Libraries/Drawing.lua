const Drawing = {}

const TidalWave = shared.TidalWave

const DrawingGui = Instance.new('ScreenGui')
DrawingGui.Name = 'Drawing'
DrawingGui.DisplayOrder = 0
DrawingGui.IgnoreGuiInset = true
DrawingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DrawingGui.Parent = TidalWave.Gui

const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)

const DrawingTypes = {
    Base = {
        Visible = true,
        ZIndex = 1
    },
    Circle = {
        Properties = {
            Radius = 0,
            Thickness = 1,
            OutlineTransparency = 0,
            FillTransparency = 1,
            OutlineColor = Color3.White,
            FillColor = Color3.White,
            Center = true,
            Position = Vector2.zero
        },
        Create = function(self, Properties)
            const Circle = Instance.new('Frame')
            Circle.Name = 'Circle'
            Circle.Size = UDim2.fromOffset(Properties.Radius * 2, Properties.Radius * 2)
            Circle.BackgroundTransparency = Properties.FillTransparency
            Circle.BackgroundColor3 = Properties.FillColor
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            Circle.Visible = Properties.Visible
            Circle.ZIndex = Properties.ZIndex
            Circle.Active = false
            Circle.Parent = DrawingGui

            const Corner = Instance.new('UICorner')
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = Circle

            const Outline = Instance.new('UIStroke')
            Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            Outline.Transparency = Properties.OutlineTransparency
            Outline.Color = Properties.OutlineColor
            Outline.Thickness = Properties.Thickness
            Outline.Parent = Circle

            self.Object = Circle
            self.Outline = Outline
            self.Corner = Corner

            return Circle
        end,
        UpdateFunctions = {
            Radius = function(self)
                self.Object.Size = UDim2.fromOffset(self.Radius * 2, self.Radius * 2)
            end,
            FillTransparency = function(self)
                self.Object.BackgroundTransparency = self.FillTransparency
            end,
            FillColor = function(self)
                self.Object.BackgroundColor3 = self.FillColor
            end,
            OutlineTransparency = function(self)
                self.Outline.Transparency = self.OutlineTransparency
            end,
            OutlineColor = function(self)
                self.Outline.Color = self.OutlineColor
            end,
            Thickness = function(self)
                self.Outline.Thickness = self.Thickness
            end,
            Position = function(self)
                self.Object.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            end,
            Visible = function(self)
                self.Object.Visible = self.Visible
                self.Outline.Enabled = self.Visible
            end,
            Center = function(self)
                self.Object.AnchorPoint = self.Center and Vector2.new(0.5, 0.5) or Vector2.zero
            end,
            ZIndex = function(self)
                self.Object.ZIndex = self.ZIndex
                self.Corner.ZIndex = self.ZIndex
            end
        },
    },
    Line = {
        Properties = {
            From = Vector2.zero,
            To = Vector2.zero,
            Thickness = 1,
            Color = Color3.White
        },
        Create = function(self, Properties, Parent)
			const Canvas = Instance.new('CanvasGroup') -- me when Path2D doesn't have Transparency
			Canvas.Name = 'LineCanvas'
			Canvas.BackgroundTransparency = 1
			Canvas.Active = false
			Canvas.Interactable = false
			Canvas.Size = UDim2.fromScale(1, 1)
			Canvas.Visible = Properties.Visible
			Canvas.Parent = DrawingGui

            const Line = Instance.new('Path2D')
            Line.Name = 'Line'
            Line.ZIndex = Properties.ZIndex
            Line.Color3 = Properties.Color
            Line.Parent = Canvas

            self.Object = Line
			self.Canvas = Canvas

            self.ControlPoints = {
                [1] = Path2DControlPoint.new(),
                [2] = Path2DControlPoint.new()
            }

            return Canvas
        end,
        UpdateFunctions = {
            From = function(self)
                self.ControlPoints[1].Position = UDim2.fromOffset(self.From.X, self.From.Y)
                self.Object:SetControlPoints(self.ControlPoints)
            end,
            To = function(self)
                self.ControlPoints[2].Position = UDim2.fromOffset(self.To.X, self.To.Y)
                self.Object:SetControlPoints(self.ControlPoints)
            end,
            Thickness = function(self)
                self.Object.Thickness = self.Thickness
            end,
            Color = function(self)
                self.Object.Color3 = self.Color
            end,
			Transparency = function(self)
				self.Canvas.GroupTransparency = self.Transparency
			end,
            Visible = function(self)
                self.Object.Visible = self.Visible
            end,
            ZIndex = function(self)
                self.Object.ZIndex = self.ZIndex
            end
        },
    },
    Square = {
        Properties = {
            Size = Vector2.zero,
            Position = Vector2.zero,
            Center = true,
            Thickness = 1,
            OutlineTransparency = 0,
            FillTransparency = 1,
            OutlineColor = Color3.White,
            FillColor = Color3.White
        },
        Create = function(self, Properties, Parent)
            const Square = Instance.new('Frame')
            Square.Name = 'Square'
            Square.AnchorPoint = Vector2.new(0.5, 0.5)
            Square.BackgroundTransparency = 1
            Square.BackgroundColor3 = Properties.FillColor
            Square.ZIndex = Properties.ZIndex
            Square.Active = false
            Square.Parent = DrawingGui
            
            const Outline = Instance.new("UIStroke")
            Outline.Thickness = Properties.Thickness.Value
            Outline.Color = Properties.OutlineColor
            Outline.LineJoinMode = Enum.LineJoinMode.Miter
            Outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            Outline.Parent = Square

            self.Object = Square
            self.Outline = Outline

            return Outline
        end,
        UpdateFunctions = {
            Size = function(self)
                self.Object.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
            end,
            Position = function(self)
                self.Object.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            end,
            Center = function(self)
                self.Object.AnchorPoint = self.Center and Vector2.new(0.5, 0.5) or Vector2.zero
            end,
            Thickness = function(self)
                self.Outline.Thickness = self.Thickness
            end,
            OutlineTransparency = function(self)
                self.Outline.Transparency = self.OutlineTransparency
            end,
            FillTransparency = function(self)
                self.Object.BackgroundTransparency = self.FillTransparency
            end,
            OutlineColor = function(self)
                self.Outline.Color = self.OutlineColor
            end,
            FillColor = function(self)
                self.Object.BackgroundColor3 = self.FillColor
            end,
            Visible = function(self)
                self.Object.Visible = self.Visible
            end,
            ZIndex = function(self)
                self.Object.ZIndex = self.ZIndex
                self.Outline.ZIndex = self.ZIndex
            end
        }
    }
}

function Drawing.new(DrawingType)
    const NewDrawing = DrawingType ~= 'Base' and DrawingTypes[DrawingType] or nil
    assert(NewDrawing, 'Invalid Drawing type')

    const StoredProperties = table.clone(DrawingTypes.Base)
    for Property, Value in NewDrawing.Properties do
        StoredProperties[Property] = Value
    end

    const self = {}
    local Obj = NewDrawing.Create(self, StoredProperties)

    function self:Destroy()
        Obj:Destroy()
		Obj = nil
    end

	self.Remove = self.Destroy

    return setmetatable(self, {
        __index = function(_, i)
            if StoredProperties[i] ~= nil then
                return StoredProperties[i]
            end
            
            return Drawing[i]
        end,
        __newindex = function(_, i, v)
            if NewDrawing.UpdateFunctions[i] then
                StoredProperties[i] = v
                NewDrawing.UpdateFunctions[i](self)
            end
        end,
    })
end

return Drawing