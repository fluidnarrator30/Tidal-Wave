local Drawing = {}

local function UpdateLinePosition(Line, From, To)
    local Delta = To - From
    local Offset = (From + To) * 0.5
    Line.Position = UDim2.fromOffset(Offset.X, Offset.Y)
    Line.Size = UDim2.fromOffset(Delta.Magnitude, Line.Size.Y.Offset)
    Line.Rotation = math.deg(math.atan2(Delta.Y, Delta.X))
end

local DrawingTypes = {
    Base = {
        Visible = true,
        ZIndex = 1,
    },
    Circle = {
        Properties = {
            Radius = 0,
            Thickness = 1,
            OutlineTransparency = 0,
            FillTransparency = 1,
            OutlineColor = Color3.fromRGB(255, 255, 255),
            FillColor = Color3.fromRGB(255, 255, 255),
            Position = Vector2.zero
        },
        Create = function(self, Properties, Parent)
            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Size = UDim2.fromOffset(Properties.Radius * 2, Properties.Radius * 2)
            Circle.BackgroundTransparency = Properties.FillTransparency
            Circle.BackgroundColor3 = Properties.FillColor
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            Circle.Visible = Properties.Visible
            Circle.ZIndex = Properties.ZIndex
            Circle.Parent = Parent

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle

            local Outline = Instance.new("UIStroke")
            Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            Outline.Transparency = Properties.OutlineTransparency
            Outline.Color = Properties.OutlineColor
            Outline.Thickness = Properties.Thickness
            Outline.Parent = Circle

            rawset(self, "Object", Circle)
            rawset(self, "Object2", Outline)
            rawset(self, "Object3", UICorner)
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
                self.Object2.Transparency = self.OutlineTransparency
            end,
            OutlineColor = function(self)
                self.Object2.Color = self.OutlineColor
            end,
            Thickness = function(self)
                self.Object2.Thickness = self.Thickness
            end,
            Position = function(self)
                self.Object.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            end,
            Visible = function(self)
                self.Object.Visible = self.Visible
                self.Object2.Enabled = self.Visible
            end,
            Parent = function(self)
                self.Object.Parent = self.Parent
                self.Object2.Parent = self.Object
                self.Object3.Parent = self.Object
            end
        },
    },
    Line = {
        Properties = {
            From = Vector2.zero,
            To = Vector2.zero,
            Thickness = 1,
            Transparency = 0,
            Color = Color3.fromRGB(255, 255, 255)
        },
        Create = function(self, Properties, Parent)
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.BorderSizePixel = 0
            Line.Size = UDim2.fromOffset(0, Properties.Thickness)
            Line.AnchorPoint = Vector2.new(0.5, 0.5)
            Line.Visible = Properties.Visible
            Line.ZIndex = Properties.ZIndex
            Line.BackgroundColor3 = Properties.Color
            Line.BackgroundTransparency = Properties.Transparency
            Line.Parent = Parent

            rawset(self, "Object", Line)
        end,
        UpdateFunctions = {
            From = function(self)
                UpdateLinePosition(self.Object, self.From, self.To)
            end,
            To = function(self)
                UpdateLinePosition(self.Object, self.From, self.To)
            end,
            Thickness = function(self)
                self.Object.Size = UDim2.fromOffset(self.Object.Size.X.Offset, self.Thickness)
            end,
            Transparency = function(self)
                self.Object.BackgroundTransparency = self.Transparency
            end,
            Color = function(self)
                self.Object.BackgroundColor3 = self.Color
            end,
            Visible = function(self)
                self.Object.Visible = self.Visible
            end,
            Parent = function(self)
                self.Object.Parent = self.Parent
            end
        },
    },
    PathLine = {
        Properties = {
            Positions = {},
            Thickness = 1,
            Color = Color3.fromRGB(255, 255, 255),
        },
        Create = function(self, Properties, Parent)
            local Path = Instance.new("Path2D")
            Path.Name = "PathLine"
            Path.Visible = Properties.Visible
            Path.ZIndex = Properties.ZIndex
            Path.Color3 = Properties.Color
            Path.Parent = Parent

            rawset(self, "Object", Path)
        end,
        UpdateFunctions = {
            Positions = function(self)
                local ControlPoints = {}
                for i, v in self.Positions do
                    if typeof(v) == "Vector2" then
                        table.insert(ControlPoints, Path2DControlPoint.new(UDim2.fromOffset(v.X, v.Y)))
                    end
                end
                self.Object:SetControlPoints(ControlPoints)
            end,
            Thickness = function(self)
                self.Object.Thickness = self.Thickness
            end,
            Color = function(self)
                self.Object.Color3 = self.Color
            end,
            Visible = function(self)
                self.Object.Visible = self.Visible
            end,
            Parent = function(self)
                self.Object.Parent = self.Parent
            end
        }
    }
}

function Drawing.new(DrawingType: "Circle" | "Line", Parent: GuiObject?)
    local NewDrawing = DrawingType ~= "Base" and DrawingTypes[DrawingType] or nil
    assert(NewDrawing ~= nil, "Invalid Drawing type.")

    local StoredProperties = table.clone(DrawingTypes.Base)
    for i, v in NewDrawing.Properties do
        StoredProperties[i] = v
    end

    local self = {}
    NewDrawing.Create(self, StoredProperties, Parent)

    local Metatable = {
        __index = function(_, i)
            if StoredProperties[i] then
                return StoredProperties[i]
            end
            return Drawing[i]
        end,
        __newindex = function(_, i, v)
            if NewDrawing.UpdateFunctions[i] then
                StoredProperties[i] = v
                NewDrawing.UpdateFunctions[i](self)
            end
        end
    }

    setmetatable(self, Metatable)

    return self
end

function Drawing:Destroy()
    for i, v in {"Object", "Object2", "Object3"} do
        if rawget(self, v) then
            self[v]:Destroy()
            rawset(self, v, nil)
        end
    end
end

return Drawing