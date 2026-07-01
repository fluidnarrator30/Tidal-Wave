local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib

local Players: Players = GetService("Players")
local TweenService: TweenService = GetService("TweenService")
local RunService: RunService = GetService("RunService")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local UIS: UserInputService = GetService("UserInputService")
local GuiService: GuiService = GetService("GuiService")

local Plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Combat = Categories.Combat

TidalWave:Clean(workspace.Zombies.ChildAdded:Connect(function(Child)
    CharacterLib:AddCharacter(Child)
end))

TidalWave:Clean(workspace.Zombies.ChildRemoved:Connect(function(Child)
    CharacterLib:RemoveCharacter(Child)
end))

TidalWave:Clean(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
end))

for i, v in workspace.Zombies:GetChildren() do
    CharacterLib:AddCharacter(v)
end

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
        local SilentAimbot, WallCheck, Part, Fov, Circle, CircleObject, OutlineObject, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Thickness, Old, Old2

        local NetworkManager = require(Plr.PlayerScripts.LocalManager.NetworkManager)

        local function UpdateCirclePosition()
            if CircleObject then
                local MouseLocation = UIS:GetMouseLocation()
                CircleObject.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
            end
        end

        local function CreateCircle()
            CircleObject = Instance.new("Frame")
            CircleObject.Name = "AimAssistCircle"
            CircleObject.Size = UDim2.fromOffset(Fov.Value * 2, Fov.Value * 2)
            CircleObject.BackgroundTransparency = FillTransparency.Value
            CircleObject.BackgroundColor3 = FillColor.Color
            UpdateCirclePosition()
            CircleObject.AnchorPoint = Vector2.new(0.5, 0.5)
            CircleObject.Visible = SilentAimbot.Enabled
            CircleObject.Parent = TidalWave.Gui

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = CircleObject

            OutlineObject = Instance.new("UIStroke")
            OutlineObject.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            OutlineObject.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            OutlineObject.Transparency = OutlineTransparency.Value
            OutlineObject.Color = OutlineColor.Color
            OutlineObject.Thickness = Thickness.Value
            OutlineObject.Parent = CircleObject
        end

        local function RemoveCircle()
            if CircleObject then
                CircleObject:Destroy()
                CircleObject = nil
            end
        end

        SilentAimbot = Combat:CreateModule({
            Name = "SilentAimbot",
            Info = "Silently adjusts your aim towards the nearest zombie",
            Enabled = function()
                if not hookfunction then NotifyPoopSploit("hookfunction") return end
                if not getcallingscript then NotifyPoopSploit("getcallingscript") return end

                if Circle.Enabled and not CircleObject then
                    CreateCircle()
                end

                SilentAimbot:Clean(RunService.RenderStepped:Connect(UpdateCirclePosition))

                Old = NetworkManager.Heartbeat
                NetworkManager.Heartbeat = function(...)
                    local Character, Vector = CharacterLib:GetCharacterWithinMouse({
                        Part = Part.Value,
                        Range = Fov.Value,
                        WallCheck = WallCheck.Enabled,
                        Origin = CharacterLib.Head.Position,
                        NPCS = true,
                        Players = false
                    })

                    if Character then
                        local MouseRaycast = Camera:ViewportPointToRay(Vector.X, Vector.Y)
                        local Raycast = workspace:Raycast(MouseRaycast.Origin, MouseRaycast.Direction * 999)
                        if Raycast then
                            NetworkManager:PassData("LookPos", Raycast.Position)
                        else
                            NetworkManager:PassData("LookPos", MouseRaycast.Direction * 999)
                        end
                    end
                    return Old(...)
                end

                Old2 = hookfunction(Ray.new, function(Origin, Direction)
                    local CallingScript = getcallingscript()
                    if CallingScript and CallingScript.Name ~= "GunScript" and CallingScript.Name ~= "LookPosManager" or not CallingScript then return Old2(Origin, Direction) end

                    local Character, Vector = CharacterLib:GetCharacterWithinMouse({
                        Part = Part.Value,
                        Range = Fov.Value,
                        WallCheck = WallCheck.Enabled,
                        Origin = Origin,
                        NPCS = true,
                        Players = false
                    })

                    if Character then
                        local CoolerRay = Camera:ViewportPointToRay(Vector.X, Vector.Y)
                        return Old2(Origin, CoolerRay.Direction * 500)
                    end

                    return Old2(Origin, Direction)
                end)

                SilentAimbot:Clean(function()
                    RemoveCircle()
                    NetworkManager.Heartbeat = Old
                    if restorefunction then
                        restorefunction(Ray.new)
                    else
                        hookfunction(Ray.new, Old2)
                    end
                    Old = nil
                    Old2 = nil
                end)
            end
        })

        WallCheck = SilentAimbot:CreateToggle({
            Name = "WallCheck",
            Info = "Ignores zombies behind walls"
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
            end
        })

        local function UpdateCircle()
            if CircleObject then
                CircleObject.Size = UDim2.fromOffset(Fov.Value * 2, Fov.Value * 2)
                CircleObject.BackgroundTransparency = FillTransparency.Value
                CircleObject.BackgroundColor3 = FillColor.Color
                if OutlineObject then
                    OutlineObject.Transparency = OutlineTransparency.Value
                    OutlineObject.Color = OutlineColor.Color
                    OutlineObject.Thickness = Thickness.Value
                end
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