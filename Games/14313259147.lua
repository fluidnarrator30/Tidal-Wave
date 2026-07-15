local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib
local Drawing = TidalWave.Libraries.Drawing

local Players: Players = GetService("Players")
local RunService: RunService = GetService("RunService")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local UIS: UserInputService = GetService("UserInputService")

local Plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Combat = Categories.Combat

local function Notify(Properties)
    TidalWave:Notify(Properties)
end

local function NotifyPoopSploit(Function)
    Notify({
        Title = "Poop Sploit",
        Text = `{TidalWave.Executor or "Your Executor"} doesn't support "{Function}"`,
        Type = "Error",
        Duration = 4,
    })
end

do
    do
        local SilentAimbot, WallCheck, Part, Fov, Circle, CircleObject, OutlineObject, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Thickness, Old

        local function UpdateCirclePosition()
            if CircleObject then
                CircleObject.Position = UIS:GetMouseLocation()
            end
        end

        local function CreateCircle()
            CircleObject = Drawing.new("Circle")
            CircleObject.Radius = Fov.Value
            CircleObject.FillTransparency = FillTransparency.Value
            CircleObject.OutlineTransparency = OutlineTransparency.Value
            CircleObject.FillColor = FillColor.Color
            CircleObject.OutlineColor = OutlineColor.Color
            CircleObject.Thickness = Thickness.Value
            CircleObject.Position = UIS:GetMouseLocation()
            CircleObject.Visible = SilentAimbot.Enabled
            CircleObject.Parent = TidalWave.Gui
        end

        local function RemoveCircle()
            if CircleObject then
                CircleObject:Destroy()
                CircleObject = nil
            end
        end

        SilentAimbot = Combat:CreateModule({
            Name = "SilentAimbot",
            Info = "Silently Adjusts your aim towards the nearest player",
            Enabled = function()
                if Circle.Enabled and not CircleObject then
                    CreateCircle()
                end

                SilentAimbot:Clean(RunService.PreRender:Connect(UpdateCirclePosition))

                local BaseWeapon = require(ReplicatedStorage.WeaponsSystem.Libraries.BaseWeapon)

                Old = BaseWeapon.fire

                BaseWeapon.fire = function(Tab, Origin, Direction, a)
                    local Character = CharacterLib:GetCharacterWithinMouse({
                        Part = Part.Value,
                        Range = Fov.Value,
                        WallCheck = WallCheck.Enabled,
                        Origin = Origin,
                        Players = true
                    })

                    if Character then
                        return Old(Tab, Origin, (Character[Part.Value].Position - Origin).Unit, a)
                    end
                    
                    return Old(Tab, Origin, Direction, a)
                end

                SilentAimbot:Clean(function()
                    RemoveCircle()
                    if Old then
                        BaseWeapon.fire = Old
                        Old = nil
                    end
                end)
            end
        })

        WallCheck = SilentAimbot:CreateToggle({
            Name = "WallCheck",
            Info = "Ignores players behind walls",
        })

        Part = SilentAimbot:CreateDropdown({
            Name = "Part",
            List = {"Head", "Root"}
        })

        Circle = SilentAimbot:CreateToggle({
            Name = "Circle",
            Function = function(Enabled)
                if Enabled and SilentAimbot.Enabled then
                    CreateCircle()
                else
                    RemoveCircle()
                end
                for _, v in {Fov, Thickness, OutlineTransparency, FillTransparency, OutlineColor, FillColor} do
                    v:SetVisible(Enabled)
                end
            end
        })

        local function UpdateCircle()
            if CircleObject then
                CircleObject.Radius = Fov.Value
                CircleObject.FillTransparency = FillTransparency.Value
                CircleObject.OutlineTransparency = OutlineTransparency.Value
                CircleObject.FillColor = FillColor.Color
                CircleObject.OutlineColor = OutlineColor.Color
                CircleObject.Thickness = Thickness.Value
            end
        end

        Fov = SilentAimbot:CreateSlider({
            Name = "Fov",
            Default = 100,
            Min = 0,
            Max = 1000,
            Visible = false,
            Function = UpdateCircle
        })

        Thickness = SilentAimbot:CreateSlider({
            Name = "Thickness",
            Default = 1,
            Min = 1,
            Max = 10,
            Visible = false,
            Function = UpdateCircle
        })

        OutlineTransparency = SilentAimbot:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateCircle
        })

        FillTransparency = SilentAimbot:CreateSlider({
            Name = "Fill Transparency",
            Default = 1,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateCircle
        })

        OutlineColor = SilentAimbot:CreateColorPicker({
            Name = "Outline Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateCircle
        })

        FillColor = SilentAimbot:CreateColorPicker({
            Name = "Fill Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateCircle
        })
    end
end