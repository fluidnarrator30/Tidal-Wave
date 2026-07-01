local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Lighting: Lighting = GetService("Lighting")
local Players: Players = GetService("Players")
local RunService: RunService = GetService("RunService")
local TeleportService: TeleportService = GetService("TeleportService")
local TextService: TextService = GetService("TextService")
local UIS: UserInputService = GetService("UserInputService")
local HttpService: HttpService = GetService("HttpService")
local CoreGui: CoreGui = GetService("CoreGui")
local MaterialService: MaterialService = GetService("MaterialService")
local ProximityPromptService: ProximityPromptService = GetService("ProximityPromptService")
local ContextActionService: ContextActionService = GetService("ContextActionService")

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local Modules = TidalWave.Modules
local CharacterLib = TidalWave.Libraries.CharacterLib
local Drawing = TidalWave.Libraries.Drawing

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other
local Animations = Categories.Animations
local Scripts = Categories.Scripts
local Server = Categories.Server

local IsStudio = RunService:IsStudio()

local setconstant = debug.setconstant or setconstant
local getconstants = debug.getconstants or getconstants
local newcclosure = newcclosure or function(f) return f end
local getnamecallmethod = getnamecallmethod or get_namecall_method
local getgc = getgc or get_gc_objects
local request = request or httprequest or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local setclipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
local fireproximityprompt = fireproximityprompt
local fireclickdetector = fireclickdetector
local firetouchinterest = firetouchinterest
local hookmetamethod = hookmetamethod
local mousemoverel = mousemoverel
local getconnections = getconnections or get_signal_cons or function() return shared.Connections end
local loadstring = IsStudio and require(script.Parent.Parent.Libraries.Loadstring) or loadstring
local setfpscap = setfpscap
local getfpscap = getfpscap

local Plr: Player = Players.LocalPlayer
local Mouse: Mouse = cloneref(Plr:GetMouse())
local Camera: Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")

local Keys = {
	["Unknown"] = Enum.KeyCode.Unknown,
	["A"] = Enum.KeyCode.A,
	["B"] = Enum.KeyCode.B,
	["C"] = Enum.KeyCode.C,
	["D"] = Enum.KeyCode.D,
	["E"] = Enum.KeyCode.E,
	["F"] = Enum.KeyCode.F,
	["G"] = Enum.KeyCode.G,
	["H"] = Enum.KeyCode.H,
	["I"] = Enum.KeyCode.I,
	["J"] = Enum.KeyCode.J,
	["K"] = Enum.KeyCode.K,
	["L"] = Enum.KeyCode.L,
	["M"] = Enum.KeyCode.M,
	["N"] = Enum.KeyCode.N,
	["O"] = Enum.KeyCode.O,
	["P"] = Enum.KeyCode.P,
	["Q"] = Enum.KeyCode.Q,
	["R"] = Enum.KeyCode.R,
	["S"] = Enum.KeyCode.S,
	["T"] = Enum.KeyCode.T,
	["U"] = Enum.KeyCode.U,
	["V"] = Enum.KeyCode.V,
	["W"] = Enum.KeyCode.W,
	["X"] = Enum.KeyCode.X,
	["Y"] = Enum.KeyCode.Y,
	["Z"] = Enum.KeyCode.Z,
	["F1"] = Enum.KeyCode.F1,
	["F2"] = Enum.KeyCode.F2,
	["F3"] = Enum.KeyCode.F3,
	["F4"] = Enum.KeyCode.F4,
	["F5"] = Enum.KeyCode.F5,
	["F6"] = Enum.KeyCode.F6,
	["F7"] = Enum.KeyCode.F7,
	["F8"] = Enum.KeyCode.F8,
	["F9"] = Enum.KeyCode.F9,
	["F10"] = Enum.KeyCode.F10,
	["F11"] = Enum.KeyCode.F11,
	["F12"] = Enum.KeyCode.F12,
	["Backspace"] = Enum.KeyCode.Backspace,
	["Tab"] = Enum.KeyCode.Tab,
	["Return"] = Enum.KeyCode.Return,
    ["Enter"] = Enum.KeyCode.Return,
	["Escape"] = Enum.KeyCode.Escape,
	["Space"] = Enum.KeyCode.Space,
	["Quote"] = Enum.KeyCode.Quote,
	["Comma"] = Enum.KeyCode.Comma,
	["Minus"] = Enum.KeyCode.Minus,
	["Period"] = Enum.KeyCode.Period,
	["Slash"] = Enum.KeyCode.Slash,
	["Zero"] = Enum.KeyCode.Zero,
	["One"] = Enum.KeyCode.One,
	["Two"] = Enum.KeyCode.Two,
	["Three"] = Enum.KeyCode.Three,
	["Four"] = Enum.KeyCode.Four,
	["Five"] = Enum.KeyCode.Five,
	["Six"] = Enum.KeyCode.Six,
	["Seven"] = Enum.KeyCode.Seven,
	["Eight"] = Enum.KeyCode.Eight,
	["Nine"] = Enum.KeyCode.Nine,
	["Semicolon"] = Enum.KeyCode.Semicolon,
	["Equals"] = Enum.KeyCode.Equals,
	["LeftBracket"] = Enum.KeyCode.LeftBracket,
	["BackSlash"] = Enum.KeyCode.BackSlash,
	["RightBracket"] = Enum.KeyCode.RightBracket,
	["Backquote"] = Enum.KeyCode.Backquote,
	["Delete"] = Enum.KeyCode.Delete,
	["KeypadZero"] = Enum.KeyCode.KeypadZero,
	["KeypadOne"] = Enum.KeyCode.KeypadOne,
	["KeypadTwo"] = Enum.KeyCode.KeypadTwo,
	["KeypadThree"] = Enum.KeyCode.KeypadThree,
	["KeypadFour"] = Enum.KeyCode.KeypadFour,
	["KeypadFive"] = Enum.KeyCode.KeypadFive,
	["KeypadSix"] = Enum.KeyCode.KeypadSix,
	["KeypadSeven"] = Enum.KeyCode.KeypadSeven,
	["KeypadEight"] = Enum.KeyCode.KeypadEight,
	["KeypadNine"] = Enum.KeyCode.KeypadNine,
	["KeypadPeriod"] = Enum.KeyCode.KeypadPeriod,
	["KeypadDivide"] = Enum.KeyCode.KeypadDivide,
	["KeypadMultiply"] = Enum.KeyCode.KeypadMultiply,
	["KeypadMinus"] = Enum.KeyCode.KeypadMinus,
	["KeypadPlus"] = Enum.KeyCode.KeypadPlus,
	["KeypadEnter"] = Enum.KeyCode.KeypadEnter,
	["KeypadEquals"] = Enum.KeyCode.KeypadEquals,
	["Up"] = Enum.KeyCode.Up,
	["Down"] = Enum.KeyCode.Down,
	["Right"] = Enum.KeyCode.Right,
	["Left"] = Enum.KeyCode.Left,
	["Insert"] = Enum.KeyCode.Insert,
	["Home"] = Enum.KeyCode.Home,
	["End"] = Enum.KeyCode.End,
	["PageUp"] = Enum.KeyCode.PageUp,
	["PageDown"] = Enum.KeyCode.PageDown,
	["NumLock"] = Enum.KeyCode.NumLock,
	["CapsLock"] = Enum.KeyCode.CapsLock,
	["ScrollLock"] = Enum.KeyCode.ScrollLock,
	["RightShift"] = Enum.KeyCode.RightShift,
	["LeftShift"] = Enum.KeyCode.LeftShift,
	["RightControl"] = Enum.KeyCode.RightControl,
	["LeftControl"] = Enum.KeyCode.LeftControl,
	["RightAlt"] = Enum.KeyCode.RightAlt,
	["LeftAlt"] = Enum.KeyCode.LeftAlt,
}

local White = Color3.new(1, 1, 1)
local Black = Color3.new()

TidalWave:Clean(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
end))

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

local function IsFriend(Player)
    return TidalWave:IsFriend(Player)
end

local function Run(f: (...any) -> (...any))
    f()
end

local function FindPlayer(Name: string)
    if typeof(Name) == "string" and Name:match("%w") then
        Name = Name:lower()
        for _, Player in Players:GetPlayers() do
            if Player == Plr then continue end
            if Player.Name:lower():sub(1, #Name) == Name then
                return Player
            elseif Player.DisplayName:lower():sub(1, #Name) == Name then
                return Player
            end
        end
    end
	return nil
end

local function IsKeybindPressed(Keybind)
    local KeyCode = Keys[Keybind.Keybind]
    return KeyCode and UIS:IsKeyDown(KeyCode)
end

local function IsKeyPressed(Key)
    return UIS:IsKeyDown(Key)
end

local function GetFocusedTextBox()
    return UIS:GetFocusedTextBox()
end

local function CanClick()
    if UIS:GetFocusedTextBox() then return false end
    if TidalWave.Gui.ScaledGui.Gui.Categories.Visible then return false end
    if TidalWave.Gui.ScaledGui.Gui.Done.Visible then return false end
    for _, v in TidalWave.Gui.ScaledGui.Gui.Menus:GetChildren() do
        if v.Visible then return false end
    end
    return true
end

Run(function() -- Combat
    Run(function() -- AimAssist
        local AimAssist, WallCheck, Part, Fov, Circle, CircleObject, OutlineObject, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Thickness

        local function CreateCircle()
            CircleObject = Drawing.new("Circle")
            CircleObject.Radius = Fov.Value
            CircleObject.FillTransparency = FillTransparency.Value
            CircleObject.OutlineTransparency = OutlineTransparency.Value
            CircleObject.FillColor = FillColor.Color
            CircleObject.OutlineColor = OutlineColor.Color
            CircleObject.Thickness = Thickness.Value
            CircleObject.Position = UIS:GetMouseLocation()
            CircleObject.Visible = AimAssist.Enabled
            CircleObject.Parent = TidalWave.Gui
        end

        local function RemoveCircle()
            if CircleObject then
                CircleObject:Destroy()
                CircleObject = nil
            end
        end

        AimAssist = Combat:CreateModule({
            Name = "AimAssist",
            Info = "Automatically moves your mouse towards the nearest player",
            Function = function(Enabled)
                if Enabled then
                    if not mousemoverel then NotifyPoopSploit("mousemoverel") return end
                    if Circle.Enabled and not CircleObject then
                        CreateCircle()
                    end
                    
                    AimAssist:Clean(RunService.RenderStepped:Connect(function()
                        if CircleObject then
                            CircleObject.Position = UIS:GetMouseLocation()
                        end
                        if not CharacterLib.Alive then return end
                        local Character, Vector = CharacterLib:GetCharacterWithinMouse({
                            Part = Part.Value,
                            Range = Fov.Value,
                            Origin = Camera.CFrame.Position,
                            WallCheck = WallCheck.Enabled,
                            NPCS = true,
                            Players = true
                        })

                        if Character then
                            local Delta = Vector2.new(Vector.X, Vector.Y) - UIS:GetMouseLocation()
                            mousemoverel(Delta.X, Delta.Y)
                        end
                    end))
                else
                    RemoveCircle()
                end
            end
        })

        WallCheck = AimAssist:CreateToggle({
            Name = "Wall Check",
            Default = true
        })

        Part = AimAssist:CreateDropdown({
            Name = "Part",
            List = {"Head", "Root"}
        })

        Circle = AimAssist:CreateToggle({
            Name = "Circle",
            Function = function(Enabled)
                if Enabled and AimAssist.Enabled then
                    CreateCircle()
                else
                    RemoveCircle()
                end
                for i, v in {Fov, Thickness, OutlineTransparency, FillTransparency, OutlineColor, FillColor} do
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

        Fov = AimAssist:CreateSlider({
            Name = "Fov",
            Default = 100,
            Min = 0,
            Max = 1000,
            Visible = false,
            Function = UpdateCircle
        })

        Thickness = AimAssist:CreateSlider({
            Name = "Thickness",
            Default = 1,
            Min = 1,
            Max = 10,
            Visible = false,
            Function = UpdateCircle
        })

        OutlineTransparency = AimAssist:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateCircle
        })

        FillTransparency = AimAssist:CreateSlider({
            Name = "Fill Transparency",
            Default = 1,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateCircle
        })

        OutlineColor = AimAssist:CreateColorPicker({
            Name = "Outline Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateCircle
        })

        FillColor = AimAssist:CreateColorPicker({
            Name = "Fill Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateCircle
        })
    end)

    Run(function() -- AutoClicker
        local AutoClicker, Interval, RandomizeInterval, IntervalMin, IntervalMax

        local Rand = Random.new()

        local function Wait()
            if RandomizeInterval.Enabled then
                task.wait(Rand:NextNumber(IntervalMin.Value, IntervalMax.Value))
            else
                task.wait(Interval.Value)
            end
        end

        AutoClicker = Combat:CreateModule({
            Name = "AutoClicker",
            Info = "Automatically triggers tools in your hand",
            Enabled = function()
                AutoClicker:Clean(UIS.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            if not CanClick() then task.wait(0.05) continue end
                            local Tool = CharacterLib.Alive and CharacterLib.Character:FindFirstChildOfClass("Tool")
                            if Tool then
                                Tool:Activate()
                                Wait()
                            else
                                task.wait(0.05)
                            end
                        end
                    end
                end))
            end
        })

        Interval = AutoClicker:CreateSlider({
            Name = "Interval",
            Default = 0.1,
            Min = 0,
            Max = 1,
        })

        RandomizeInterval = AutoClicker:CreateToggle({
            Name = "Randomize Interval",
        })

        IntervalMin = AutoClicker:CreateSlider({
            Name = "Interval Min",
            Default = 0.09,
            Min = 0,
            Max = 1,
        })

        IntervalMax = AutoClicker:CreateSlider({
            Name = "Interval Max",
            Default = 0.11,
            Min = 0,
            Max = 1,
        })
    end)
    
    Run(function() -- HitboxExpander
        local HitboxExpander, Target, Color, Transparency, X, Y, Z, Size

        local Parts = {}

        HitboxExpander = Combat:CreateModule({
            Name = "HitboxExpander",
            Info = "Expands the hitbox of other players",
            Enabled = function()
                HitboxExpander:Clean(RunService.Stepped:Connect(function()
                    for i, Player in CharacterLib.List do
                        if Player.Teammate then continue end
                        local Head = Player.Head
                        
                        if Target.Value == "Head" then
                            if not Head then return end
                            if not Parts[Head] then
                                Parts[Head] = {
                                    Size = Head.Size,
                                    Color = Head.Color
                                }
                            end
                            Head.Size = Size
                            Head.Color = Color.Color
                            Head.Transparency = Transparency.Value
                        elseif Target.Value == "RootPart" then
                            local Root = Player.Root
                            if not Root then return end
                            if not Parts[Root] then
                                Parts[Root] = {
                                    Size = Root.Size,
                                    Color = Root.Color
                                }
                            end
                            Root.Size = Size
                            Root.Color = Color.Color
                            Root.Transparency = Transparency.Value
                        elseif Target.Value == "All" then
                            for i2, v2 in Player.Character:QueryDescendants("BasePart") do
                                if not Parts[v2] then
                                    Parts[v2] = {
                                        Size = v2.Size,
                                        Color = v2.Color
                                    }
                                end
                                v2.Size = Size
                                v2.Color = Color.Color
                                v2.Transparency = Transparency.Value
                            end
                        end
                    end
                end))
                HitboxExpander:Clean(function()
                    for Part, v in Parts do
                        Part.Size = v.Size
                        Part.Color = v.Color
                    end
                end)
            end
        })

        local function UpdateSize()
            Size = Vector3.new(X.Value, Y.Value, Z.Value)
        end

        X = HitboxExpander:CreateSlider({
            Name = "X Size",
            Default = 5,
            Min = 1,
            Max = 20,
            Function = UpdateSize
        })

        Y = HitboxExpander:CreateSlider({
            Name = "Y Size",
            Default = 5,
            Min = 1,
            Max = 20,
            Function = UpdateSize
        })

        Z = HitboxExpander:CreateSlider({
            Name = "Z Size",
            Default = 5,
            Min = 1,
            Max = 20,
            Function = UpdateSize
        })

        UpdateSize()

        Target = HitboxExpander:CreateDropdown({
            Name = "Target",
            List = {"Head", "RootPart", "All"},
        })

        Transparency = HitboxExpander:CreateSlider({
            Name = "Transparency",
            Default = 1,
            Min = 0,
            Max = 1,
            Decimal = 100,
        })

        Color = HitboxExpander:CreateColorPicker({
            Name = "Color",
            Default = Color3.fromRGB(255, 0, 0),
        })
    end)
end)

Run(function() -- Player
    Run(function() -- Noclip
        local Noclip, Method, ResetCollisionOnDisabled, AntiNoclipBypass, BypassMethod, AntiNoclipPart
        local Connections = {}

        local Functions = {
            Character = function()
                if CharacterLib.Alive then
                    for _, Part in CharacterLib.Character:QueryDescendants("BasePart[CanCollide = true]") do
                        Part.CanCollide = false
                    end
                end
            end
        }

        local function DisableConnections(Part)
            if not Part then return end
            task.defer(function()
                for _, Connection in getconnections(Part:GetPropertyChangedSignal("CanCollide")) do
                    table.insert(Connections, Connection)
                    Connection:Disable()
                end
            end)
        end

        local function LocalAdded()
            table.clear(Connections)
            if AntiNoclipPart.Value == "All" then
                local function PartAdded(Part)
                    if Part:IsA("BasePart") then
                        DisableConnections(Part)
                    end
                end
                Noclip:Clean(CharacterLib.Character.ChildAdded:Connect(PartAdded))
                for _, Part in CharacterLib.Character:GetChildren() do
                    PartAdded(Part)
                end
            elseif AntiNoclipPart.Value == "Torso" then
                if CharacterLib.RigType == Enum.HumanoidRigType.R15 then
                    local LowerTorso, UpperTorso = CharacterLib.Character:FindFirstChild("LowerTorso"), CharacterLib.Character:FindFirstChild("UpperTorso")
                    DisableConnections(LowerTorso)
                    DisableConnections(UpperTorso)
                else
                    local Torso = CharacterLib.Character:FindFirstChild("Torso")
                    DisableConnections(Torso)
                end
            else
                local Part = CharacterLib[AntiNoclipPart.Value]
                DisableConnections(Part)
            end
        end

        local Bypasses = {
            GetPropertyChangedSignal = function()
                if CharacterLib.Alive then
                    LocalAdded()
                end
                Noclip:Clean(CharacterLib.Events.LocalAdded:Connect(LocalAdded))
                Noclip:Clean(CharacterLib.Events.LocalRemoved:Connect(function()
                    table.clear(Connections)
                end))
            end
        }

        Noclip = PlayerCategory:CreateModule({
            Name = "Noclip",
            Info = "Disables the collision of your character allowing you to walk through walls.",
            Function = function(Enabled)
                if Enabled then
                    Noclip:Clean(RunService.Stepped:Connect(Functions[Method.Value]))
                    if AntiNoclipBypass.Enabled then
                        Bypasses[BypassMethod.Value]()
                    end
                else
                    if ResetCollisionOnDisabled.Enabled and CharacterLib.Alive then
                        CharacterLib.Root.CanCollide = true
                    end
                    for _, Connection in Connections do
                        Connection:Enable()
                    end
                    table.clear(Connections)
                end
            end,
        })

        Method = Noclip:CreateDropdown({
            Name = "Method",
            List = {"Character", "Part"}
        })

        ResetCollisionOnDisabled = Noclip:CreateToggle({
            Name = "Reset Collision On Disabled",
            Info = "Turns the collision of your root back on after disabling noclip.",
            Default = true
        })

        local function Update()
            if Noclip.Enabled then
                Noclip:Toggle(true)
                Noclip:Toggle(true)
            end
        end

        AntiNoclipBypass = Noclip:CreateToggle({
            Name = "Anti Noclip Bypass",
            Info = "Attempts to bypass anti noclip using various methods.",
            Function = function(Enabled)
                Update()
                BypassMethod:SetVisible(Enabled)
                AntiNoclipPart:SetVisible(Enabled)
            end
        })

        BypassMethod = Noclip:CreateDropdown({
            Name = "Bypass Method",
            List = {"GetPropertyChangedSignal"},
            Function = Update,
            Visible = false
        })

        AntiNoclipPart = Noclip:CreateDropdown({
            Name = "Part",
            List = {"Root", "Head", "Torso", "All"},
            Function = Update,
            Visible = false
        })
    end)

    Run(function() -- AntiRagdoll
        local AntiRagdoll, PrevFallingDown, PrevRagdoll

        local FallingDownState = Enum.HumanoidStateType.FallingDown
        local RagdollState = Enum.HumanoidStateType.Ragdoll

        local function OnCharacterAdded()
            AntiRagdoll:Clean(CharacterLib.Humanoid.StateEnabledChanged:Connect(function(State, Enabled)
                if not Enabled then return end
                if State == FallingDownState or State == RagdollState then
                    CharacterLib.Humanoid:SetStateEnabled(State, false)
                end
            end))
            PrevFallingDown = CharacterLib.Humanoid:GetStateEnabled(FallingDownState)
            PrevRagdoll = CharacterLib.Humanoid:GetStateEnabled(RagdollState)
            CharacterLib.Humanoid:SetStateEnabled(FallingDownState, false)
            CharacterLib.Humanoid:SetStateEnabled(RagdollState, false)
        end

        AntiRagdoll = PlayerCategory:CreateModule({
            Name = "AntiRagdoll",
            Info = "Prevents your humanoid from going into the Ragdoll and FallingDown state",
            Function = function(Enabled)
                if Enabled then
                    AntiRagdoll:Clean(CharacterLib.Events.LocalAdded:Connect(OnCharacterAdded))
                    if CharacterLib.Alive then
                        OnCharacterAdded()
                    end
                else
                    if CharacterLib.Alive then
                        CharacterLib.Humanoid:SetStateEnabled(FallingDownState, PrevFallingDown)
                        CharacterLib.Humanoid:SetStateEnabled(RagdollState, PrevRagdoll)
                        PrevFallingDown = nil
                        PrevRagdoll = nil
                    end
                end
            end
        })
    end)

    Run(function() -- DropTools
        local DropTools

        DropTools = PlayerCategory:CreateButton({
            Name = "Drop Tools",
            Info = "Drops all the tools in your backpack\nMay cause lag depending on how many tools you have",
            Function = function()
                local Backpack = Plr:FindFirstChildOfClass("Backpack")
                if not (Backpack and CharacterLib.Alive) then return end
                for i, v in Backpack:GetChildren() do
                    if v.ClassName == "Tool" then
                        v.Parent = CharacterLib.Character
                    end
                end
                task.wait(0.2)
                if not CharacterLib.Alive then return end
                for i, v in CharacterLib.Character:GetChildren() do
                    if v.ClassName == "Tool" then
                        v.Parent = workspace
                    end
                end
            end,
        })
    end)

    Run(function() -- JumpPower
        local JumpPowerModule, JumpPower

        JumpPowerModule = PlayerCategory:CreateModule({
            Name = "JumpPower",
            Info = "Sets the jump power of your humanoid.",
            Enabled = function()
                if CharacterLib.Alive then
                    CharacterLib.Humanoid.JumpPower = JumpPower.Value
                    JumpPowerModule:Clean(CharacterLib.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                        CharacterLib.Humanoid.JumpPower = JumpPower.Value
                    end))
                end
                JumpPowerModule:Clean(CharacterLib.Events.LocalAdded:Connect(function(Char)
                    Char.Humanoid.JumpPower = JumpPower.Value
                    JumpPowerModule:Clean(Char.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                        Char.Humanoid.JumpPower = JumpPower.Value
                    end))
                end))
            end
        })

        JumpPower = JumpPowerModule:CreateSlider({
            Name = "Hip Height",
            Default = CharacterLib.Alive and CharacterLib.Humanoid.JumpPower or 50,
            Min = 0,
            Max = 500,
            Function = function(Val)
                if JumpPowerModule.Enabled and CharacterLib.Alive then
                    CharacterLib.Humanoid.JumpPower = Val
                end
            end
        })
    end)

    Run(function() -- HipHeight
        local HipHeightModule, HipHeight

        HipHeightModule = PlayerCategory:CreateModule({
            Name = "HipHeight",
            Info = "Sets the hip height of your humanoid.",
            Enabled = function()
                if CharacterLib.Alive then
                    CharacterLib.Humanoid.HipHeight = HipHeight.Value
                    HipHeightModule:Clean(CharacterLib.Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
                        CharacterLib.Humanoid.HipHeight = HipHeight.Value
                    end))
                end
                HipHeightModule:Clean(CharacterLib.Events.LocalAdded:Connect(function(Char)
                    Char.Humanoid.HipHeight = HipHeight.Value
                    HipHeightModule:Clean(Char.Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
                        Char.Humanoid.HipHeight = HipHeight.Value
                    end))
                end))
            end
        })

        HipHeight = HipHeightModule:CreateSlider({
            Name = "Hip Height",
            Default = CharacterLib.Alive and CharacterLib.Humanoid.HipHeight or 2,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Function = function(Val)
                if HipHeightModule.Enabled and CharacterLib.Alive then
                    CharacterLib.Humanoid.HipHeight = Val
                end
            end
        })
    end)
end)

Run(function() -- Movement
    local SpeedBodyVelocity

    Run(function() -- Speed
        local SpeedModule, Method, UsePercentage, Speed, Percentage, MinSpeed

        local function GetVel()
            return UsePercentage.Enabled and math.max(CharacterLib.Humanoid.WalkSpeed * (Percentage.Value / 100), MinSpeed.Value) or Speed.Value
        end

        local function ModY(Vector, Y)
            return Vector3.new(Vector.X, Y, Vector.Z)
        end

        local Methods = {
            BodyVelocity = function()
                local Vel = GetVel()
                local MoveDirection = ModY(CharacterLib.Humanoid.MoveDirection * Vel, 0)

                if SpeedBodyVelocity and not SpeedBodyVelocity.Parent then
                    SpeedBodyVelocity:Destroy()
                    SpeedBodyVelocity = nil
                end

                if SpeedBodyVelocity then
                    SpeedBodyVelocity.Velocity = MoveDirection
                else
                    SpeedBodyVelocity = Instance.new("BodyVelocity")
                    SpeedBodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
                    SpeedBodyVelocity.Velocity = MoveDirection
                    SpeedBodyVelocity.Parent = CharacterLib.Root
                end
            end,
            Velocity = function()
                local Vel = GetVel()
                local MoveDirection = ModY(CharacterLib.Humanoid.MoveDirection * Vel, CharacterLib.Root.AssemblyLinearVelocity.Y)

                CharacterLib.Root.AssemblyLinearVelocity = MoveDirection
            end,
            CFrame = function(Delta)
                local Vel = GetVel() - CharacterLib.Humanoid.WalkSpeed
                local MoveDirection = ModY(CharacterLib.Humanoid.MoveDirection * Vel, 0)

                CharacterLib.Character:TranslateBy(MoveDirection * Delta)
            end
        }
        
        SpeedModule = Movement:CreateModule({
            Name = "Speed",
            Info = "Increases your speed using various detected methods.",
            Function = function(Enabled)
                if Enabled then
                    SpeedModule:Clean(RunService.Heartbeat:Connect(function(Delta)
                        if not CharacterLib.Alive then return end
                        if (Modules.Fly and Modules.Fly.Enabled) or (Modules.LongJump and Modules.LongJump.Enabled) then return end
                        if Methods[Method.Value] then
                            Methods[Method.Value](Delta)
                        end
                    end))
                elseif SpeedBodyVelocity then
                    SpeedBodyVelocity:Destroy()
                    SpeedBodyVelocity = nil
                end
            end,
        })

        Speed = SpeedModule:CreateSlider({
            Name = "Speed",
            Default = 16,
            Min = 0,
            Max = 250,
        })

        Method = SpeedModule:CreateDropdown({
            Name = "Method",
            List = {"Velocity", "BodyVelocity", "CFrame"},
            Info = "BodyVelocity - Adjusts the velocity of your root by using a body velocity object. Allows you to move in vehicles.\nVelocity - Adjusts the velocity of your root.\nCFrame - Directly adjusts the position of your root.",
            Function = function(Val)
                if Val ~= "BodyVelocity" and SpeedBodyVelocity then
                    SpeedBodyVelocity:Destroy()
                    SpeedBodyVelocity = nil
                end
            end
        })

        UsePercentage = SpeedModule:CreateToggle({
            Name = "Use Percentage",
            Info = "Uses speed based off of a percentage of your humanoid's walk speed rather than an absolute value",
            Function = function(Enabled)
                Percentage:SetVisible(Enabled)
                MinSpeed:SetVisible(Enabled)
            end,
        })

        Percentage = SpeedModule:CreateSlider({
            Name = "Speed Percentage",
            Min = 0,
            Default = 110,
            Max = 200,
            Suffix = "%",
            Visible = false
        })

        MinSpeed = SpeedModule:CreateSlider({
            Name = "Min Speed",
            Min = 0,
            Default = 0,
            Max = 80,
            Visible = false,
        })
    end)

    Run(function() -- HighJump
        local HighJump, Method, JumpPower, AutoDisable, Con

        local function Jump()
            if not CharacterLib.Alive then return end
            local State = CharacterLib.Humanoid:GetState()
            if State == Enum.HumanoidStateType.Running or State == Enum.HumanoidStateType.Landed then
                if Method.Value == "Velocity" then
                    CharacterLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(CharacterLib.Root.AssemblyLinearVelocity.X, JumpPower.Value, CharacterLib.Root.AssemblyLinearVelocity.Z)
                elseif Method.Value == "TranslateBy" then
                    if Con then
                        Con:Disconnect()
                        Con = nil
                    end
                    local EndAlpha = JumpPower.Value / workspace.Gravity
                    local Alpha = 0
                    Con = RunService.Stepped:Connect(function(_, Delta)
                        Alpha += Delta
                        CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(CharacterLib.Root.AssemblyLinearVelocity.X, 0, CharacterLib.Root.AssemblyLinearVelocity.Z)
                        CharacterLib.Character:TranslateBy(Vector3.new(0, JumpPower.Value * Delta, 0))
                        if Alpha >= EndAlpha then
                            Con:Disconnect()
                        end
                    end)
                end
            end
        end

        HighJump = Movement:CreateModule({
            Name = "HighJump",
            Info = "Makes you jump high",
            Enabled = function()
                Jump()
                if AutoDisable.Enabled then
                    HighJump:Toggle(true)
                else
                    HighJump:Clean(RunService.RenderStepped:Connect(function()
                        if UIS:IsKeyDown(Enum.KeyCode.Space) and not UIS:GetFocusedTextBox() then
                            Jump()
                        end
                    end))
                end
            end
        })

        Method = HighJump:CreateDropdown({
            Name = "Method",
            List = {"Velocity", "TranslateBy"}
        })

        JumpPower = HighJump:CreateSlider({
            Name = "Jump Power",
            Default = 50,
            Min = 1,
            Max = 500
        })

        AutoDisable = HighJump:CreateToggle({
            Name = "Auto Disable",
            Default = true
        })
    end)

    Run(function() -- LongJump
        local LongJump, Method, Speed, AutoDisable

        local Running = Enum.HumanoidStateType.Running
        local Landed = Enum.HumanoidStateType.Landed
        local Jumping = Enum.HumanoidStateType.Jumping
        local Freefall = Enum.HumanoidStateType.Freefall
        local Space = Enum.KeyCode.Space

        local Methods = {
            Velocity = function()
                local MoveDirection = CharacterLib.Humanoid.MoveDirection
                CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * Speed.Value, CharacterLib.Root.AssemblyLinearVelocity.Y, MoveDirection.Z * Speed.Value)
            end,
            TranslateBy = function(Delta)
                CharacterLib.Character:TranslateBy((CharacterLib.Humanoid.MoveDirection * Speed.Value) * Delta)
            end
        }

        local function Jump()
            if CharacterLib.Alive then
                local State = CharacterLib.Humanoid:GetState()
                if State == Running or State == Landed then
                    if SpeedBodyVelocity then
                        SpeedBodyVelocity:Destroy()
                        SpeedBodyVelocity = nil
                    end
                    CharacterLib.Humanoid:ChangeState(Jumping)

                    local TimeOut = os.clock() + 1
                    repeat
                        RunService.Heartbeat:Wait()
                        State = CharacterLib.Humanoid:GetState()
                    until State == Freefall or not LongJump.Enabled or os.clock() >= TimeOut

                    if not LongJump.Enabled then return end

                    repeat
                        local Delta = RunService.Heartbeat:Wait()
                        State = CharacterLib.Humanoid:GetState()
                        Methods[Method.Value](Delta)
                    until State == Running or State == Landed or not LongJump.Enabled
                end
            end

            if LongJump.Enabled and AutoDisable.Enabled then
                LongJump:Toggle(true)
            end
        end

        LongJump = Movement:CreateModule({
            Name = "LongJump",
            Info = "Makes your jump very much long.",
            Enabled = function()
                if AutoDisable.Enabled then
                    Jump()
                else
                    LongJump:Clean(RunService.RenderStepped:Connect(function()
                        if IsKeyPressed(Space) and not GetFocusedTextBox() then
                            Jump()
                        end
                    end))
                end
            end
        })

        Method = LongJump:CreateDropdown({
            Name = "Method",
            List = {"Velocity", "TranslateBy"}
        })

        Speed = LongJump:CreateSlider({
            Name = "Speed",
            Default = 50,
            Min = 1,
            Max = 500
        })

        AutoDisable = LongJump:CreateToggle({
            Name = "Auto Disable",
            Default = true,
            Function = function()
                if LongJump.Enabled then
                    LongJump:Toggle(true)
                    LongJump:Toggle(true)
                end
            end
        })
    end)

    Run(function() -- AirJump
        local AirJump, Hold, JumpInterval

        local Jumping = Enum.HumanoidStateType.Jumping

        AirJump = Movement:CreateModule({
            Name = "AirJump",
            Info = "Allows you to jump midair",
            Enabled = function()
                AirJump:Clean(UIS.InputBegan:Connect(function(Input)
                    if UIS:GetFocusedTextBox() or not CharacterLib.Alive then return end
                    if Input.KeyCode == Enum.KeyCode.Space then
                        CharacterLib.Humanoid:ChangeState(Jumping)
                        if Hold.Enabled then
                            while AirJump.Enabled and CharacterLib.Alive and UIS:IsKeyDown(Enum.KeyCode.Space) do
                                CharacterLib.Humanoid:ChangeState(Jumping)
                                task.wait(JumpInterval.Value)
                            end
                        end
                    end
                end))
            end
        })

        Hold = AirJump:CreateToggle({
            Name = "Hold",
            Info = "Allows you to hold jump instead of spamming it",
            Function = function(Enabled)
                JumpInterval:SetVisible(Enabled)
            end
        })

        JumpInterval = AirJump:CreateSlider({
            Name = "Jump Interval",
            Default = 0,
            Min = 0,
            Max = 1,
            Visible = false
        })
    end)

    Run(function() -- Fly
        local Fly, HorizontalSpeed, VerticalSpeed, FlyMethod, FloatMethod, AlignMethod, UseMoveDirection, Percentage, UsePercentage, UpKeybind, UpKeybind2, DownKeybind, DownKeybind2
        local BodyVelocity, FloatBodyVelocity, AlignOrientation, Attachment

        local function GetMoveDirection()
            local MoveDirection
            if UseMoveDirection.Enabled then
                MoveDirection = CharacterLib.Humanoid.MoveDirection
            else
                MoveDirection = Vector3.zero
                if IsKeyPressed(Keys.W) then
                    MoveDirection += Camera.CFrame.LookVector
                end
                if IsKeyPressed(Keys.A) then
                    MoveDirection -= Camera.CFrame.RightVector
                end
                if IsKeyPressed(Keys.S) then
                    MoveDirection -= Camera.CFrame.LookVector
                end
                if IsKeyPressed(Keys.D) then
                    MoveDirection += Camera.CFrame.RightVector
                end
            end

            if MoveDirection.Magnitude > 0 then
                MoveDirection = MoveDirection.Unit * (UsePercentage.Enabled and (Percentage.Value / 100) or HorizontalSpeed.Value)
            end

            if IsKeybindPressed(UpKeybind) or IsKeybindPressed(UpKeybind2) then
                MoveDirection += Vector3.new(0, 1 * VerticalSpeed.Value, 0)
            end
            if IsKeybindPressed(DownKeybind) or IsKeybindPressed(DownKeybind2) then
                MoveDirection += Vector3.new(0, -1 * VerticalSpeed.Value, 0)
            end

            return MoveDirection
        end

        local FlyMethods = {
            BodyVelocity = function()
                local Vel = GetMoveDirection()
                if BodyVelocity and not BodyVelocity.Parent then
                    BodyVelocity:Destroy()
                    BodyVelocity = nil
                end
                if BodyVelocity then
                    BodyVelocity.Velocity = Vel
                else
                    BodyVelocity = Instance.new("BodyVelocity")
                    BodyVelocity.MaxForce = Vector3.new(math.huge, FloatMethod.Value == "BodyVelocity" and math.huge or 0, math.huge)
                    BodyVelocity.Velocity = Vel
                    BodyVelocity.Name = "RootAttachment"
                    BodyVelocity.Parent = CharacterLib.Root
                end
            end,
            Velocity = function()
                local Vel = GetMoveDirection()
                CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(Vel.X, CharacterLib.Root.AssemblyLinearVelocity.Y, Vel.Z)
            end,
            TranslateBy = function(Delta)
                CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(0,  CharacterLib.Root.AssemblyLinearVelocity.Y, 0)
                local Vel = GetMoveDirection()
                CharacterLib.Character:TranslateBy(Vector3.new(Vel.X, 0, Vel.Z) * Delta)
            end
        }

        local FloatMethods = {
            BodyVelocity = function()
                if FlyMethod.Value == "BodyVelocity" then return end
                local Vel = Vector3.new(0, GetMoveDirection().Y, 0)
                if FloatBodyVelocity and not FloatBodyVelocity.Parent then
                    FloatBodyVelocity:Destroy()
                    FloatBodyVelocity = nil
                end
                if FloatBodyVelocity then
                    FloatBodyVelocity.Velocity = Vel
                else
                    FloatBodyVelocity = Instance.new("BodyVelocity")
                    FloatBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    FloatBodyVelocity.Velocity = Vel
                    FloatBodyVelocity.Name = "RootAttachment"
                    FloatBodyVelocity.Parent = CharacterLib.Root
                end
            end,
            Velocity = function()
                local Vel = GetMoveDirection()
                CharacterLib.Root.AssemblyLinearVelocity = Vector3.new(CharacterLib.Root.AssemblyLinearVelocity.X, Vel.Y, CharacterLib.Root.AssemblyLinearVelocity.Z)
            end
        }

        local AlignMethods = {
            AlignOrientation = function()
                if AlignOrientation and not AlignOrientation.Parent then
                    AlignOrientation:Destroy()
                    AlignOrientation = nil
                end
                if AlignOrientation then
                    if UseMoveDirection.Enabled then
                        if CharacterLib.Humanoid.MoveDirection.Magnitude > 0 then
                            AlignOrientation.CFrame = CFrame.lookAlong(CharacterLib.Root.Position, CharacterLib.Humanoid.MoveDirection)
                        end
                    else
                        AlignOrientation.CFrame = Camera.CFrame
                    end
                else
                    local RootAttachment = CharacterLib.Root:FindFirstChild("RootAttachment")
                    if RootAttachment then
                        Attachment = RootAttachment
                    else
                        Attachment = Instance.new("Attachment")
                        Attachment.Name = "RootAttachment"
                        Attachment.Parent = CharacterLib.Root
                    end
                    AlignOrientation = Instance.new("AlignOrientation")
                    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    AlignOrientation.Attachment0 = Attachment
                    AlignOrientation.RigidityEnabled = true
                    AlignOrientation.Name = "RootAttachment"
                    if UseMoveDirection.Enabled then
                        if CharacterLib.Humanoid.MoveDirection.Magnitude > 0 then
                            AlignOrientation.CFrame = CFrame.lookAlong(CharacterLib.Root.Position, CharacterLib.Humanoid.MoveDirection)
                        end
                    else
                        AlignOrientation.CFrame = Camera.CFrame
                    end
                    AlignOrientation.Parent = CharacterLib.Root
                end
            end,
            CFrame = function()
                CharacterLib.Root.CFrame = CFrame.lookAlong(CharacterLib.Root.CFrame.Position, Camera.CFrame.LookVector)
                CharacterLib.Root.AssemblyAngularVelocity = Vector3.zero
            end
        }

        Fly = Movement:CreateModule({
            Name = "Fly",
            Info = "Allows you to fly through the air with extra detected methods",
            Function = function(Enabled)
                if Enabled then
                    if Modules.Speed and Modules.Speed.Enabled and SpeedBodyVelocity then
                        SpeedBodyVelocity:Destroy()
                        SpeedBodyVelocity = nil
                    end

                    Fly:Clean(RunService.Heartbeat:Connect(function(Delta)
                        if not CharacterLib.Alive then return end

                        if UseMoveDirection.Enabled then
                            if AlignOrientation then
                                AlignOrientation:Destroy()
                                AlignOrientation = nil
                            end
                        else
                            if AlignMethod.Vaue ~= "None" then
                                AlignMethods[AlignMethod.Value]()
                            end
                        end

                        FlyMethods[FlyMethod.Value](Delta)
                        FloatMethods[FloatMethod.Value]()
                    end))
                else
                    if BodyVelocity then
                        BodyVelocity:Destroy()
                        BodyVelocity = nil
                    end
                    if FloatBodyVelocity then
                        FloatBodyVelocity:Destroy()
                        FloatBodyVelocity = nil
                    end
                    if AlignOrientation then
                        AlignOrientation:Destroy()
                        AlignOrientation = nil
                    end
                end
            end
        })

        UpKeybind = Fly:CreateKeybind({
            Name = "Up",
            Keybind = "E",
            Hold = false,
        })

        UpKeybind2 = Fly:CreateKeybind({
            Name = "Up2",
            Text = " Up Keybind 2",
            Hold = false,
        })

        DownKeybind = Fly:CreateKeybind({
            Name = "Down",
            Keybind = "Q",
            Hold = false,
        })

        DownKeybind2 = Fly:CreateKeybind({
            Name = "Down2",
            Text = " Down Keybind 2",
            Hold = false,
        })

        HorizontalSpeed = Fly:CreateSlider({
            Name = "Horizontal Speed",
            Default = 50,
            Min = 0,
            Max = 500,
        })

        VerticalSpeed = Fly:CreateSlider({
            Name = "Vertical Speed",
            Default = 50,
            Min = 0,
            Max = 500,
        })

        FlyMethod = Fly:CreateDropdown({
            Name = "Fly Method",
            Info = "BodyVelocity - Adjusts the velocity of your root by using a body velocity object. Allows you to fly in vehicles.\nVelocity - Adjusts the velocity of your root.\nCFrame - Directly adjusts the position of your root.",
            List = {"BodyVelocity", "Velocity", "TranslateBy"},
            Function = function(Val)
                if Val ~= "BodyVelocity" and BodyVelocity then
                    BodyVelocity:Destroy()
                    BodyVelocity = nil
                end
            end
        })

        FloatMethod = Fly:CreateDropdown({
            Name = "Float Method",
            List = {"BodyVelocity", "Velocity"},
            Function = function(Val)
                if BodyVelocity then
                    BodyVelocity.MaxForce = Vector3.new(math.huge, Val == "BodyVelocity" and math.huge or 0, math.huge)
                elseif FloatBodyVelocity and Val == "Velocity" then
                    FloatBodyVelocity:Destroy()
                    FloatBodyVelocity = nil
                end
            end
        })

        AlignMethod = Fly:CreateDropdown({
            Name = "Align Method",
            List = {"AlignOrientation", "CFrame", "None"},
            Function = function(Val)
                if Val ~= "AlignOrientation" and AlignOrientation then
                    AlignOrientation:Destroy()
                    AlignOrientation = nil
                end
            end
        })

        UseMoveDirection = Fly:CreateToggle({
            Name = "Use Move Direction",
            Info = "Uses your humanoid's move direction instead of your camera's look direction",
            Function = function()
                if Fly.Enabled then
                    Fly:Toggle(true)
                    Fly:Toggle(true)
                end
            end
        })

        UsePercentage = Fly:CreateToggle({
            Name = "Use Percentage",
            Info = "Uses speed based off of a percentage of your humanoid's walk speed rather than an absolute value",
            Function = function(Enabled)
                Percentage:SetVisible(Enabled)
            end
        })

        Percentage = Fly:CreateSlider({
            Name = "Percentage",
            Default = 110,
            Min = 0,
            Max = 200,
            Suffix = "%",
            Visible = false,
        })
    end)

    Run(function() -- Float
        local Float, Part, Color, Transparency, Offset, UpOffset, DownOffset, UpKeybind, UpKeybind2, DownKeybind, DownKeybind2

        local OffsetCFrame = CFrame.new(0, -(CharacterLib.Alive and CharacterLib.RigType == Enum.HumanoidRigType.R15 and 3.098 or 3.1), 0)

        Float = Movement:CreateModule({
            Name = "Float",
            Info = "Creates a part below you allowing you to float",
            Function = function(Enabled)
                if Enabled then
                    Float:Clean(RunService.Heartbeat:Connect(function()
                        if not CharacterLib.Alive then return end
                        if Part and Part.Parent then
                            local cf = OffsetCFrame
                            if IsKeybindPressed(UpKeybind) or IsKeybindPressed(UpKeybind2) then
                                cf += Vector3.new(0, UpOffset.Value, 0)
                            end
                            if IsKeybindPressed(DownKeybind) or IsKeybindPressed(DownKeybind2) then
                                cf -= Vector3.new(0, DownOffset.Value, 0)
                            end
                            Part.Color = Color.Color
                            Part.Transparency = Transparency.Value
                            Part.CFrame = CharacterLib.Root.CFrame * cf
                        else
                            if Part then
                                Part:Destroy()
                                Part = nil
                            end
                            if not Part then
                                Part = Instance.new("Part")
                                Part.Transparency = Transparency.Value
                                Part.Size = Vector3.new(2, 0.2, 2)
                                Part.Anchored = true
                                Part.CanTouch = false
                                Part.CanQuery = false
                                Part.CastShadow = false
                                Part.AudioCanCollide = false
                                Part.Parent = workspace
                            end
                        end
                    end))
                else
                    if Part then
                        Part:Destroy()
                        Part = nil
                    end
                end
            end
        })

        Offset = Float:CreateSlider({
            Name = "Offset",
            Default = OffsetCFrame.Y,
            Min = 0,
            Max = 4,
            Decimal = 100,
            Function = function(Val)
                OffsetCFrame = CFrame.new(0, -Val, 0)
            end
        })
        
        UpOffset = Float:CreateSlider({
            Name = "Up Offset",
            Default = 1,
            Min = 0.1,
            Max = 3,
            Decimal = 100,
        })

        DownOffset = Float:CreateSlider({
            Name = "Down Offset",
            Default = 1,
            Min = 0.1,
            Max = 2,
            Decimal = 100,
        })

        UpKeybind = Float:CreateKeybind({
            Name = "Up",
            Keybind = "E",
            Hold = false,
        })

        UpKeybind2 = Float:CreateKeybind({
            Name = "Up2",
            Text = " Up Keybind 2",
            Hold = false,
        })

        DownKeybind = Float:CreateKeybind({
            Name = "Down",
            Keybind = "Q",
            Hold = false,
        })

        DownKeybind2 = Float:CreateKeybind({
            Name = "Down2",
            Text = " Down Keybind 2",
            Hold = false,
        })

        Transparency = Float:CreateSlider({
            Name = "Transparency",
            Default = 1,
            Min = 0,
            Max = 1,
            Decimal = 100,
        })

        Color = Float:CreateColorPicker({
            Name = "Color",
            Default = Color3.fromRGB(163, 162, 165),
        })
    end)

    Run(function() -- WalkFling
        local WalkFling

        local Offset = Vector3.new(0, 10000, 0)

        WalkFling = Movement:CreateModule({
            Name = "WalkFling",
            Info = "Flings players without spinning",
            Enabled = function()
                if Modules.Noclip and not Modules.Noclip.Enabled then
                    Modules.Noclip:Toggle(true)
                end
                WalkFling:Clean(RunService.Heartbeat:Connect(function()
                    if not CharacterLib.Alive then return end
                    local Vel = CharacterLib.Root.AssemblyLinearVelocity
                    CharacterLib.Root.AssemblyLinearVelocity = (Vel * 10000) + Offset
                    RunService.RenderStepped:Wait()
                    if not CharacterLib.Alive then return end
                    CharacterLib.Root.AssemblyLinearVelocity = Vel
                end))
            end
        })
    end)

    Run(function() -- ClickTP
        local ClickTeleport, Keybind

        ClickTeleport = Movement:CreateModule({
            Name = "ClickTP",
            Info = "Teleports you to your mouse's location when you hold your keybind and click",
            Enabled = function()
                ClickTeleport:Clean(UIS.InputBegan:Connect(function(Input)
                    if UIS:GetFocusedTextBox() or not CharacterLib.Alive then return end
                    local Key = Enum.KeyCode:FromName(Keybind.Keybind)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and Key and UIS:IsKeyDown(Key) then
                        local RootPos = CharacterLib.Root.Position
                        local HitPos = Mouse.Hit.Position
                        local _, Y = CFrame.lookAt(RootPos, HitPos):ToOrientation()
                        local Pos = Vector3.new(HitPos.X, HitPos.Y + CharacterLib.HipHeight, HitPos.Z)
                        CharacterLib.Root.CFrame = CFrame.new(Pos) * CFrame.Angles(0, Y, 0)
                    end
                end))
            end
        })

        Keybind = ClickTeleport:CreateKeybind({
            Name = "Teleport",
            Keybind = "R",
            Hold = false
        })
    end)

    Run(function() -- CFrameFly
        local CFrameFly, UpKeybind, DownKeybind, UpKeybind2, DownKeybind2, CFrameFlySpeed, GoBackToOriginalPosition, ShowOriginalPosition, OriginalPosition, ScreenGui, Path2D, Color, Thickness, PositionPreset
        
        local UpVector = Vector3.new(0, 1, 0)

        local TracerPositions = {
            TopLeft = Path2DControlPoint.new(UDim2.fromScale(0, 0)),
            Top = Path2DControlPoint.new(UDim2.fromScale(0.5, 0)),
            TopRight = Path2DControlPoint.new(UDim2.fromScale(1, 0)),
            Left = Path2DControlPoint.new(UDim2.fromScale(0, 0.5)),
            Middle = Path2DControlPoint.new(UDim2.fromScale(0.5, 0.5)),
            Right = Path2DControlPoint.new(UDim2.fromScale(1, 0.5)),
            BottomLeft = Path2DControlPoint.new(UDim2.fromScale(0, 1)),
            Bottom = Path2DControlPoint.new(UDim2.fromScale(0.5, 1)),
            BottomRight = Path2DControlPoint.new(UDim2.fromScale(1, 1)),
        }

        local From = TracerPositions.Bottom

        local function GetFrom()
            local Preset = PositionPreset.Value
            if Preset == "Mouse" then
                local MouseLocation = UIS:GetMouseLocation()
                return Path2DControlPoint.new(UDim2.fromOffset(MouseLocation.X, MouseLocation.Y))
            else
                return From
            end
        end

        CFrameFly = Movement:CreateModule({
            Name = "CFrameFly",
            Info = "Works like normal fly except it doesn't update your position to other players.",
            Function = function(Enabled)
                if Enabled then
                    ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.Name = "CFrameFlyTracers"
                    ScreenGui.Parent = TidalWave.Gui

                    CFrameFly:Clean(RunService.RenderStepped:Connect(function()
                        if not CharacterLib.Alive then return end
                        if ShowOriginalPosition.Enabled then
                            if Path2D then
                                if OriginalPosition then
                                    local Vector, OnScreen = Camera:WorldToViewportPoint(OriginalPosition.Position)
                                    if OnScreen then
                                        Path2D.Color3 = Color.Color
                                        Path2D.Thickness = Thickness.Value
                                        Path2D:SetControlPoints({GetFrom(), Path2DControlPoint.new(UDim2.fromOffset(Vector.X, Vector.Y))})
                                        Path2D.Visible = true
                                    else
                                        Path2D.Visible = false
                                    end
                                else
                                    OriginalPosition = CharacterLib.Root.CFrame
                                end
                            else
                                Path2D = Instance.new("Path2D")
                                Path2D.Name = "CFrameFlyTracer"
                                Path2D.Color3 = Color.Color
                                Path2D.Thickness = Thickness.Value
                                Path2D.Visible = false
                                Path2D.Parent = ScreenGui
                            end
                        else
                            if Path2D then
                                Path2D:Destroy()
                                Path2D = nil
                            end
                        end

                        local Offset = Vector3.zero
                        if IsKeybindPressed(UpKeybind) or IsKeybindPressed(UpKeybind2) then
                            Offset += UpVector
                        end
                        if IsKeybindPressed(DownKeybind) or IsKeybindPressed(DownKeybind2) then
                            Offset -= UpVector
                        end

                        local Delta = RunService.Heartbeat:Wait()
                        if not CharacterLib.Alive then return end
                        CharacterLib.Root.Anchored = true
                        local CameraOffset = CharacterLib.Root.CFrame:ToObjectSpace(Camera.CFrame).Position
                        Camera.CFrame *= CFrame.new(-CameraOffset.X, -CameraOffset.Y, -CameraOffset.Z + 1)
                        local ModdedCameraPos = Vector3.new(CharacterLib.Root.CFrame.Position.X, Camera.CFrame.Position.Y, CharacterLib.Root.CFrame.Position.Z)
                        local ObjectSpaceVelocity = CFrame.lookAt(Camera.CFrame.Position, ModdedCameraPos)
                        local MoveDirection =  CharacterLib.Humanoid.MoveDirection + Offset
                        ObjectSpaceVelocity = ObjectSpaceVelocity:VectorToObjectSpace(MoveDirection * (CFrameFlySpeed.Value * Delta))
                        CharacterLib.Root.CFrame = CFrame.new(CharacterLib.Root.CFrame.Position) * (Camera.CFrame - Camera.CFrame.Position) * CFrame.new(ObjectSpaceVelocity)
                    end))
                else
                    if ScreenGui then
                        ScreenGui:Destroy()
                        ScreenGui = nil
                    end
                    if Path2D then
                        Path2D:Destroy()
                        Path2D = nil
                    end
                    OriginalPosition = nil

                    if CharacterLib.Alive then
                        if GoBackToOriginalPosition.Enabled and OriginalPosition then
                            CharacterLib.Root.CFrame = OriginalPosition
                        end
                        CharacterLib.Root.Anchored = false
                    end
                end
            end,
        })

        CFrameFlySpeed = CFrameFly:CreateSlider({
            Name = "CFrame Fly Speed",
            Default = 50,
            Min = 0,
            Max = 500,
        })

        GoBackToOriginalPosition = CFrameFly:CreateToggle({
            Name = "Go Back To Original Position",
            Info = "Brings you back to the position that you originally started at"
        })

        ShowOriginalPosition = CFrameFly:CreateToggle({
            Name = "Show Original Position",
            Info = "Creates a tracer pointing to your original position you started flying at",
        })

        Color = CFrameFly:CreateColorPicker({
            Name = "Tracer Color",
            Default = Color3.fromRGB(255, 255, 255)
        })

        Thickness = CFrameFly:CreateSlider({
            Name = "Tracer Thickness",
            Default = 1,
            Min = 1,
            Max = 5
        })

        PositionPreset = CFrameFly:CreateDropdown({
            Name = "Position",
            List = {"Bottom", "Bottom Left", "Bottom Right", "Top Left", "Top", "Top Right", "Left", "Middle", "Right", "Mouse"},
            Function = function(Val)
                From = TracerPositions[Val]
            end
        })

        UpKeybind = CFrameFly:CreateKeybind({
            Name = "Up",
            Keybind = "E",
            Hold = false
        })

        DownKeybind = CFrameFly:CreateKeybind({
            Name = "Down",
            Keybind = "Q",
            Hold = false
        })

        UpKeybind2 = CFrameFly:CreateKeybind({
            Name = "Up2",
            Text = " Up Keybind 2",
            Hold = false
        })

        DownKeybind2 = CFrameFly:CreateKeybind({
            Name = "Down2",
            Text = " Down Keybind 2",
            Hold = false
        })
    end)

    Run(function() -- Spin
        local Spin, Speed, AngularVelocity

        local HugeVector = Vector3.new(0, math.huge, 0)

        local function DestroyAngularVelocity()
            if AngularVelocity then
                AngularVelocity:Destroy()
                AngularVelocity = nil
            end
        end

        local function AddAngularVelocity(Player)
            DestroyAngularVelocity()
            AngularVelocity = Instance.new("BodyAngularVelocity")
            AngularVelocity.MaxTorque = HugeVector
            AngularVelocity.AngularVelocity = Vector3.new(0, Speed.Value, 0)
            AngularVelocity.Parent = Player.Root
        end

        Spin = Movement:CreateModule({
            Name = "Spin",
            Info = "Makes you spin",
            Function = function(Enabled)
                if Enabled then
                    Spin:Clean(CharacterLib.Events.LocalAdded:Connect(AddAngularVelocity))
                    if CharacterLib.Alive then
                        AddAngularVelocity(CharacterLib)
                    end
                else
                    DestroyAngularVelocity()
                end
            end
        })

        Speed = Spin:CreateSlider({
            Name = "Speed",
            Default = 45,
            Min = 0,
            Max = 360,
            Function = function(Val)
                if AngularVelocity then
                    AngularVelocity.AngularVelocity = Vector3.new(0, Speed.Value, 0)
                end
            end
        })
    end)
end)

Run(function() -- Visuals
    Run(function() -- FullBright
        local FullBright, Ambient, Brightness, ColorShiftBottom, ColorShiftTop, EnvironmentDiffuseScale, EnvironmentSpecularScale, Shadows, OutdoorAmbient, TimeOfDay, ExposureCompensation, FogColor, FogEnd, FogStart, Bloom

		local function AddAtmosphere(Atmosphere)
			local Debounce = false
            local function UpdateAtmosphere()
                if Debounce then return end
                Debounce = true
                Atmosphere.Density = 0
                Atmosphere.Offset = 0
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
                Debounce = false
            end

            UpdateAtmosphere()
            FullBright:Clean(Atmosphere.Changed:Connect(UpdateAtmosphere))
		end

        local function AddEffect(Effect)
            local Enabled = Effect == Bloom
            Effect.Enabled = Enabled
            FullBright:Clean(Effect:GetPropertyChangedSignal("Enabled"):Connect(function()
                Effect.Enabled = Enabled
            end))
        end

        local function UpdateLightingSettings()
            if not FullBright.Enabled then return end
            Lighting.Ambient = Ambient.Color
            Lighting.Brightness = Brightness.Value
            Lighting.ColorShift_Bottom = ColorShiftBottom.Color
            Lighting.ColorShift_Top = ColorShiftTop.Color
            Lighting.EnvironmentDiffuseScale = EnvironmentDiffuseScale.Value
            Lighting.EnvironmentSpecularScale = EnvironmentSpecularScale.Value
            Lighting.GlobalShadows = Shadows.Enabled
            Lighting.OutdoorAmbient = OutdoorAmbient.Color
            Lighting.ClockTime = TimeOfDay.Value < 0 and Lighting.ClockTime or TimeOfDay.Value
            Lighting.ExposureCompensation = ExposureCompensation.Value
            Lighting.FogColor = FogColor.Color
            Lighting.FogStart = FogStart.Value
            Lighting.FogEnd = FogEnd.Value
        end

        local Effects = {
            DepthOfFieldEffect = true,
            BloomEffect = true,
            BlurEffect = true,
            ColorCorrectionEffect = true,
            SunRaysEffect = true,
            ColorGradingEffect = true
        }

        FullBright = Visuals:CreateModule({
            Name = "FullBright",
            Info = "Increases the brightness of lighting and removes visual effects that can make it harder to see.",
            Function = function(Enabled)
                if Enabled then
                    Bloom = Instance.new("BloomEffect")
                    Bloom.Intensity = 0
                    Bloom.Size = 0
                    Bloom.Threshold = 0
                    Bloom.Parent = Lighting

                    local Debounce = false

                    UpdateLightingSettings()

                    FullBright:Clean(Lighting.Changed:Connect(function()
                        if Debounce then return end
                        Debounce = true
                        UpdateLightingSettings()
                        Debounce = false
                    end))

                    FullBright:Clean(Lighting.DescendantAdded:Connect(function(Child)
                        if Child.ClassName == "Atmosphere" then
                            AddAtmosphere(Child)
                        elseif Effects[Child.ClassName] then
                            AddEffect(Child)
                        end
                    end))

                    for _, Effect in Lighting:QueryDescendants("Atmosphere, DepthOfFieldEffect, BloomEffect, BlurEffect, ColorCorrectionEffect, SunRaysEffect, ColorGradingEffect") do
                        if Effect.ClassName == "Atmosphere" then
                            AddAtmosphere(Effect)
                        elseif Effects[Effect.ClassName] then
                            AddEffect(Effect)
                        end
                    end
                    for _, Effect in Camera:QueryDescendants("DepthOfFieldEffect, BloomEffect, BlurEffect, ColorCorrectionEffect, SunRaysEffect, ColorGradingEffect") do
                        if Effects[Effect.ClassName] then
                            AddEffect(Effect)
                        end
                    end
                else
                    if Bloom then
                        Bloom:Destroy()
                        Bloom = nil
                    end
                end
            end
        })

        ExposureCompensation = FullBright:CreateSlider({
            Name = "Exposure",
            Default = 0,
            Min = -3,
            Max = 3,
            Decimal = 100,
            Function = UpdateLightingSettings
        })

        Brightness = FullBright:CreateSlider({
            Name = "Brightness",
            Default = 3,
            Min = 0,
            Max = 10,
            Decimal = 10,
            Function = UpdateLightingSettings
        })

        Ambient = FullBright:CreateColorPicker({
            Name = "Ambient",
            Default = White,
            Function = UpdateLightingSettings
        })

        OutdoorAmbient = FullBright:CreateColorPicker({
            Name = "Outdoor Ambient",
            Default = White,
            Function = UpdateLightingSettings
        })

        ColorShiftBottom = FullBright:CreateColorPicker({
            Name = "Color Shift Bottom",
            Default = White,
            Function = UpdateLightingSettings
        })

        ColorShiftTop = FullBright:CreateColorPicker({
            Name = "Color Shift Top",
            Default = White,
            Function = UpdateLightingSettings,
        })

        Shadows = FullBright:CreateToggle({
            Name = "Shadows",
            Function = UpdateLightingSettings
        })

        EnvironmentDiffuseScale = FullBright:CreateSlider({
            Name = "Diffuse Scale",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateLightingSettings
        })

        EnvironmentSpecularScale = FullBright:CreateSlider({
            Name = "Specular Scale",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateLightingSettings
        })

        TimeOfDay = FullBright:CreateSlider({
            Name = "Time Of Day",
            Default = 12,
            Min = 0,
            Max = 24,
            Decimal = 10,
            Function = UpdateLightingSettings
        })

        FogStart = FullBright:CreateSlider({
            Name = "Fog Start",
            Default = Lighting.FogStart,
            Min = 0,
            Max = 100,
            Function = UpdateLightingSettings
        })

        FogEnd = FullBright:CreateSlider({
            Name = "Fog End",
            Default = 100000,
            Min = 0,
            Max = 100000,
            Function = UpdateLightingSettings
        })

        FogColor = FullBright:CreateColorPicker({
            Name = "Fog Color",
            Default = White,
            Function = UpdateLightingSettings
        })
    end)

    Run(function() -- Water Settings
        local WaterSettings, WaterColor, WaterTransparency, WaterReflectance, WaterWaveSize, WaterWaveSpeed

        local Terrain = workspace.Terrain
        
        local function UpdateWaterSettings()
            if not WaterSettings.Enabled then return end
            Terrain.WaterColor = WaterColor.Color
            Terrain.WaterTransparency = WaterTransparency.Value
            Terrain.WaterReflectance = WaterReflectance.Value
            Terrain.WaterWaveSize = WaterWaveSize.Value
            Terrain.WaterWaveSpeed = WaterWaveSpeed.Value
        end

        WaterSettings = Visuals:CreateModule({
            Name = "WaterModifier",
            Info = "Allows you to modify different properties of terrain water",
            Enabled = function()
                WaterSettings:Clean(Terrain.Changed:Connect(UpdateWaterSettings))
                UpdateWaterSettings()
            end
        })

        WaterColor = WaterSettings:CreateColorPicker({
            Name = "Water Color",
            Default = Terrain.WaterColor,
            Function = UpdateWaterSettings
        })
        WaterTransparency = WaterSettings:CreateSlider({
            Name = "Water Transparency",
            Default = Terrain.WaterTransparency,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateWaterSettings
        })
        WaterReflectance = WaterSettings:CreateSlider({
            Name = "Water Reflectance",
            Default = Terrain.WaterReflectance,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateWaterSettings
        })
        WaterWaveSize = WaterSettings:CreateSlider({
            Name = "Water Wave Size",
            Default = Terrain.WaterWaveSize,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateWaterSettings
        })
        WaterWaveSpeed = WaterSettings:CreateSlider({
            Name = "Water Wave Speed",
            Default = Terrain.WaterWaveSpeed,
            Min = 0,
            Max = 100,
            Function = UpdateWaterSettings
        })
    end)

    Run(function() -- Chams
        local Chams, OutlineColor, FillColor, OutlineTransparency, FillTransparency, TeamCheck, NpcOutlineColor, NpcFillColor, NpcOutlineTransparency, NpcFillTransparency, ShowPlayers, ShowNpcs, UseTeamColor, Folder

        local Highlights = {}

        local function OnCharacterAdded(Char)
            if TeamCheck.Enabled and Char.Teammate then return end
            if not ShowPlayers.Enabled and Char.Player then return end
            if not ShowNpcs.Enabled and Char.NPC then return end

            local TeamColor = UseTeamColor.Enabled and Char and CharacterLib:GetTeamColor(Char) or nil

            local Highlight = Instance.new("Highlight")
            Highlight.Name = `{Char.Player and Char.Player.Name or Char.Character.Name}_Chams`
            Highlight.Adornee = Char.Character
            Highlight.OutlineColor = TeamColor or (Char.Player and OutlineColor.Color or NpcOutlineColor.Color)
            Highlight.FillColor = TeamColor or (Char.Player and FillColor.Color or NpcFillColor.Color)
            Highlight.OutlineTransparency = (Char.Player and OutlineTransparency.Value or NpcOutlineTransparency.Value)
            Highlight.FillTransparency = (Char.Player and FillTransparency.Value or NpcFillTransparency.Value)
            Highlight.Parent = Folder

            Highlights[Char.Character] = {
                Highlight = Highlight,
                Player = Char.Player,
                Character = Char
            }
        end

        local function OnCharacterRemoved(Char)
            local Character = Highlights[Char.Character]
            if Character then
                Character.Highlight:Destroy()
                Highlights[Char.Character] = nil
            end
        end

        local function OnTeamChanged(Char)
            local Highlight = Highlights[Char.Character]
            if Highlight then
                if TeamCheck.Enabled and Char.Teammate then
                    OnCharacterRemoved(Char)
                elseif UseTeamColor.Enabled then
                    local TeamColor = UseTeamColor.Enabled and Char and CharacterLib:GetTeamColor(Char) or nil
                    Highlight.Highlight.OutlineColor = TeamColor or (Char.Player and OutlineColor.Color or NpcOutlineColor.Color)
                    Highlight.Highlight.FillColor = TeamColor or (Char.Player and FillColor.Color or NpcFillColor.Color)
                end
            end
        end
        
        Chams = Visuals:CreateModule({
            Name = "Chams",
            Info = "Renders players through walls.",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "Chams"
                    Folder.Parent = TidalWave.Gui

                    Chams:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                    Chams:Clean(CharacterLib.Events.CharacterRemoved:Connect(OnCharacterRemoved))
                    Chams:Clean(CharacterLib.Events.TeamChanged:Connect(OnTeamChanged))
                    for _, Character in CharacterLib.List do
                        OnCharacterAdded(Character)
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                end
            end
        })

        local function UpdateHighlights()
            for Char, Highlight in Highlights do
                Char = CharacterLib:FindCharacter(Char)
                local TeamColor = UseTeamColor.Enabled and Char and CharacterLib:GetTeamColor(Char) or nil
                Highlight.Highlight.OutlineColor = TeamColor or (Char.Player and OutlineColor.Color or NpcOutlineColor.Color)
                Highlight.Highlight.FillColor = TeamColor or (Char.Player and FillColor.Color or NpcFillColor.Color)
                Highlight.Highlight.OutlineTransparency = (Char.Player and OutlineTransparency.Value or NpcOutlineTransparency.Value)
                Highlight.Highlight.FillTransparency = (Char.Player and FillTransparency.Value or NpcFillTransparency.Value)
            end
        end

        TeamCheck = Chams:CreateToggle({
            Name = "Team Check",
            Info = "Hides teammates",
            Function = function()
                if Chams.Enabled then
                    Chams:Toggle(true)
                    Chams:Toggle(true)
                end
            end
        })

        ShowPlayers = Chams:CreateToggle({
            Name = "Players",
            Info = "Whether or not to show players.",
            Default = true,
            Function = function(Enabled)
                if Chams.Enabled then
                    Chams:Toggle(true)
                    Chams:Toggle(true)
                end
                for _, v in {OutlineTransparency, FillTransparency, OutlineColor, FillColor} do
                    v:SetVisible(Enabled)
                end
            end,
        })

        OutlineTransparency = Chams:CreateSlider({
            Name = "Player Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateHighlights
        })

        FillTransparency = Chams:CreateSlider({
            Name = "Player Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateHighlights
        })

        OutlineColor = Chams:CreateColorPicker({
            Name = "Player Outline Color",
            Default = Color3.fromRGB(255, 255, 255),
            Function = UpdateHighlights
        })

        FillColor = Chams:CreateColorPicker({
            Name = "Player Fill Color",
            Default = Color3.fromRGB(255, 255, 255),
            Function = UpdateHighlights
        })

        ShowNpcs = Chams:CreateToggle({
            Name = "NPCs",
            Info = "Whether or not to show NPCs.",
            Function = function(Enabled)
                if Chams.Enabled then
                    Chams:Toggle(true)
                    Chams:Toggle(true)
                end
                for _, v in {NpcOutlineTransparency, NpcFillTransparency, NpcOutlineColor, NpcFillColor} do
                    v:SetVisible(Enabled)
                end
            end,
        })

        NpcOutlineTransparency = Chams:CreateSlider({
            Name = "NPC Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateHighlights
        })

        NpcFillTransparency = Chams:CreateSlider({
            Name = "NPC Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Visible = false,
            Function = UpdateHighlights
        })

        NpcOutlineColor = Chams:CreateColorPicker({
            Name = "NPC Outline Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateHighlights
        })

        NpcFillColor = Chams:CreateColorPicker({
            Name = "NPC Fill Color",
            Default = Color3.fromRGB(255, 255, 255),
            Visible = false,
            Function = UpdateHighlights
        })

        UseTeamColor = Chams:CreateToggle({
            Name = "Use Team Color",
            Function = UpdateHighlights
        })
    end)

    Run(function() -- Tracers
        local Tracers, Thickness, Color, TeamCheck, XBoxConnect, HideMainTracer, ScreenGui, UseTeamColor

        local PresetPositons = {
            TopLeft = Path2DControlPoint.new(UDim2.fromScale(0, 0)),
            Top = Path2DControlPoint.new(UDim2.fromScale(0.5, 0)),
            TopRight = Path2DControlPoint.new(UDim2.fromScale(1, 0)),
            Left = Path2DControlPoint.new(UDim2.fromScale(0, 0.5)),
            Middle = Path2DControlPoint.new(UDim2.fromScale(0.5, 0.5)),
            Right = Path2DControlPoint.new(UDim2.fromScale(1, 0.5)),
            BottomLeft = Path2DControlPoint.new(UDim2.fromScale(0, 1)),
            Bottom = Path2DControlPoint.new(UDim2.fromScale(0.5, 1)),
            BottomRight = Path2DControlPoint.new(UDim2.fromScale(1, 1)),
        }

        local TracerPath = {
            R15 = {
                LeftFoot = {
                    {"LowerTorso", {{}}},
                    {"LeftUpperLeg", {{}}},
                    {"LeftLowerLeg", {{}}},
                    {"LeftFoot", {{}}}
                },
                RightFoot = {
                    {"LowerTorso", {{}}},
                    {"RightUpperLeg", {{}}},
                    {"RightLowerLeg", {{}}},
                    {"RightFoot", {{}}}
                },
                LeftHand = {
                    {"LowerTorso", {{}}},
                    {"UpperTorso", {{Y = 0.25}}},
                    {"LeftUpperArm", {{}}},
                    {"LeftLowerArm", {{}}},
                    {"LeftHand", {{}}}
                },
                RightHand = {
                    {"UpperTorso", {{Y = 0.25}}},
                    {"RightUpperArm", {{}}},
                    {"RightLowerArm", {{}}},
                    {"RightHand", {{}}}
                },
                Head = {
                    {"UpperTorso", {{Y = 0.25}}},
                    {"Head", {{}}}
                }
            },
            R6 = {
                LeftFoot = {
                    {"Torso", {{Y = 0.25}, {Y = -0.25}}},
                    {"Left Leg", {{Y = 0.25}, {Y = -0.25}}}
                },
                RightFoot = {
                    {"Torso", {{Y = -0.25}}},
                    {"Right Leg", {{Y = 0.25}, {Y = -0.25}}}
                },
                LeftHand = {
                    {"Torso", {{Y = 0.25}}},
                    {"Left Arm", {{Y = 0.25}, {Y = -0.25}}}
                },
                RightHand = {
                    {"Torso", {{Y = 0.25}}},
                    {"Right Arm", {{Y = 0.25}, {Y = -0.25}}}
                },
                Head = {
                    {"Torso", {{Y = 0.25}}},
                    {"Head", {{}}}
                }
            }
        }

        local TracerObjects = {}

        local TracerControlPoints = {
            [1] = PresetPositons.Bottom
        }

        local function RenderTracers()
            for Char, Tracer in TracerObjects do
                local Player = CharacterLib:FindCharacter(Char)
                local Hide = not Player or TeamCheck.Enabled and Player.Teammate
                if Hide or HideMainTracer.Enabled then
                    Tracer.Tracers.Tracer.Visible = false
                else
                    local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Root.Position)
                    if OnScreen then
                        TracerControlPoints[2] = Path2DControlPoint.new(UDim2.fromOffset(Vector.X, Vector.Y))
                        Tracer.Tracers.Tracer:SetControlPoints(TracerControlPoints)
                        Tracer.Tracers.Tracer.Visible = true
                    else
                        Tracer.Tracers.Tracer.Visible = false
                    end
                end
                if XBoxConnect.Enabled then
                    for i, v in TracerPath[Player.RigType.Name] do
                        local CurrentPath2D = Tracer.Tracers[i]
                        if Hide then
                            CurrentPath2D.Visible = false
                        else
                            local NewControlPoints = {}
                            for i2, v2 in v do
                                local LimbName = v2[1]
                                local Limb = Player.Character:FindFirstChild(LimbName)
                                if not Limb then break end
                                local Positions = v2[2]
                                for i3, v3 in Positions do
                                    local Any = v3.X or v3.Y or v3.Z
                                    local Position = not Any and Limb.Position or Limb.CFrame:ToWorldSpace(CFrame.new(v3.X and Limb.Size.X * v3.X or 0, v3.Y and Limb.Size.Y * v3.Y or 0, v3.Z and Limb.Size.Z * v3.Z or 0)).Position
                                    local LimbPosition, LimbOnScreen = Camera:WorldToViewportPoint(Position)
                                    if not LimbOnScreen then break end
                                    table.insert(NewControlPoints, Path2DControlPoint.new(UDim2.fromOffset(LimbPosition.X, LimbPosition.Y)))
                                end
                            end
                            if #NewControlPoints == 0 then
                                CurrentPath2D.Visible = false
                            else
                                CurrentPath2D.Visible = true
                                CurrentPath2D:SetControlPoints(NewControlPoints)
                            end
                        end
                    end
                end
            end
        end

        local function CreateTracer(Char, LimbName)
            local Tracer = Instance.new("Path2D")
            Tracer.Name = `{Char.Player and Char.Player.Name or Char.Character.Name}_{LimbName and LimbName .. "_" or ""}Tracer`
            Tracer.Thickness = Thickness.Value
            Tracer.Color3 = UseTeamColor.Enabled and Char.Player and Char.Player.Team and Char.Player.Team.TeamColor.Color or Color.Color
            Tracer.Parent = ScreenGui

            return Tracer
        end

        local function OnCharacterRemoved(Char)
            local Player = TracerObjects[Char.Character]
            if Player then
                for i, v in Player.Tracers do
                    v:Destroy()
                end
                TracerObjects[Char.Character] = nil
            end
        end

        local function OnCharacterAdded(Char)
            OnCharacterRemoved(Char)
            local Tab = {
                Player = Char.Player,
                Tracers = {
                    Tracer = CreateTracer(Char),
                }
            }
            for Limb, _ in TracerPath.R15 do
                Tab.Tracers[Limb] = CreateTracer(Char, Limb)
            end
            TracerObjects[Char.Character] = Tab
        end

        local function OnTeamChanged(Char)
            local Player = TracerObjects[Char.Character]
            if Player then
                for _, Tracer in Player.Tracers do
                    if TeamCheck.Enabled and Char.Teammate then continue end
                    Tracer.Color3 = UseTeamColor.Enabled and Char.Player and Char.Player.Team and Char.Player.Team.TeamColor.Color or Color.Color
                    Tracer.Thickness = Thickness.Value
                end
            end
        end

        Tracers = Visuals:CreateModule({
            Name = "Tracers",
            Info = "Creates tracers",
            Function = function(Enabled)
                if Enabled then
                    ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.Name = "Tracers"
                    ScreenGui.Parent = TidalWave.Gui
                    Tracers:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                    Tracers:Clean(CharacterLib.Events.CharacterRemoved:Connect(OnCharacterRemoved))
                    Tracers:Clean(CharacterLib.Events.TeamChanged:Connect(OnTeamChanged))
                    for i, Player in CharacterLib.List do
                        OnCharacterAdded(Player)
                    end
                    Tracers:Clean(RunService.RenderStepped:Connect(RenderTracers))
                else
                    if ScreenGui then
                        ScreenGui:Destroy()
                        ScreenGui = nil
                    end
                    table.clear(TracerObjects)
                end
            end
        })

        local function UpdateTracers()
            if not Tracers.Enabled then return end
            for _, Char in TracerObjects do
                for _, Tracer in Char.Tracers do
                    if TeamCheck.Enabled and Char.Teammate then continue end
                    Tracer.Color3 = UseTeamColor.Enabled and Char.Player and Char.Player.Team and Char.Player.Team.TeamColor.Color or Color.Color
                    Tracer.Thickness = Thickness.Value
                end
            end
        end

        Thickness = Tracers:CreateSlider({
            Name = "Thickness",
            Default = 1,
            Min = 1,
            Max = 5,
            Function = UpdateTracers
        })

        Color = Tracers:CreateColorPicker({
            Name = "Color",
            Default = Color3.fromRGB(255, 255, 255),
            Function = UpdateTracers
        })

        TeamCheck = Tracers:CreateToggle({
            Name = "Team Check",
            Function = UpdateTracers
        })

        UseTeamColor = Tracers:CreateToggle({
            Name = "Use Team Color",
            Function = UpdateTracers
        })

        HideMainTracer = Tracers:CreateToggle({
            Name = "Hide Main Tracer",
            Info = "Hides the main tracer for if you want to only see xbox connect"
        })

        XBoxConnect = Tracers:CreateToggle({
            Name = "Xbox Connect",
            Info = "It connects the xbox",
            Function = function(Enabled)
                if not Enabled then
                    for i, v in TracerObjects do
                        for i2, v2 in v.Tracers do
                            if i2 ~= "Tracer" then
                                v2.Visible = false
                            end
                        end
                    end
                end
            end
        })

        Tracers:CreateDropdown({
            Name = "Position",
            List = {"Bottom", "Bottom Left", "Bottom Right", "Top Left", "Top", "Top Right", "Left", "Middle", "Right", "Mouse"},
            Function = function(Val)
                TracerControlPoints[1] = PresetPositons[Val:gsub(" ", "")]
            end
        })
    end)

    Run(function() -- NameTags
        local NameTags, UsePlayers, UseNpcs, TextColor, BackgroundColor, BackgroundTransparency, TextSize, Font, TeamCheck, Folder, ShowName, ShowHealth, ShowDistance, UseDisplayName, UseTeamColor, Offset

        local NameTagObjects = {}

        local function OnCharacterRemoved(Char)
            local Player = NameTagObjects[Char.Character]
            if Player then
                Player.NameTag:Destroy()
                NameTagObjects[Char.Character] = nil
            end
        end

        local function OnCharacterAdded(Char)
            OnCharacterRemoved(Char)
            if Char.Player and not UsePlayers.Enabled then return end
            if Char.NPC and not UseNpcs.Enabled then return end

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Active = false
            TextLabel.Interactable = false
            TextLabel.Name = `{Char.Player and Char.Player.Name or Char.Character.Name}_NameTag`
            TextLabel.BorderSizePixel = 0
            TextLabel.BackgroundColor3 = BackgroundColor.Color
            TextLabel.BackgroundTransparency = BackgroundTransparency.Value
            TextLabel.TextColor3 = TextColor.Color
            TextLabel.TextSize = TextSize.Value
            TextLabel.Font = Enum.Font[Font.Value]
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.RichText = true
            TextLabel.ZIndex = 0
            TextLabel.Parent = Folder

            NameTagObjects[Char.Character] = {NameTag = TextLabel, Player = Char.Player}

            return TextLabel
        end

        local function RenderNameTags()
            for Char, NameTag in NameTagObjects do
                local Character = CharacterLib:FindCharacter(Char)
                local Hide = not Character or TeamCheck.Enabled and Character.Teammate or false
                if Hide then
                    NameTag.NameTag.Visible = false
                else
                    local HeadPos, HeadOnScreen = Camera:WorldToViewportPoint(Character.Head.Position + Vector3.new(0, Offset.Value, 0))
                    if HeadOnScreen then
                        local Color = UseTeamColor.Enabled and Character.Player and Character.Player.Team and Character.Player.Team.TeamColor.Color or TextColor.Color
                        local Text = {}
                        if ShowDistance.Enabled and CharacterLib.Alive then
                            Text[#Text + 1] = `[{math.floor(vector.magnitude(CharacterLib.Root.Position - Character.Root.Position))}]`
                        end
                        if ShowName.Enabled and Character.Player then
                            Text[#Text + 1] =  `<font color = '#{Color:ToHex()}'>{UseDisplayName.Enabled and Character.Player.DisplayName or Character.Player.Name}</font>`
                        end
                        if ShowHealth.Enabled then
                            local HealthColor = Color3.fromHSV(0.333333 * (Character.Health / Character.MaxHealth or 0), 1, 1) or Color3.fromHSV(0, 1, 1)
                            Text[#Text + 1] = `<font color = '#{HealthColor:ToHex()}'>{math.floor(Character.Health) or 0}</font>`
                        end
                        NameTag.NameTag.Text = table.concat(Text, " ")
                        local Size = TextService:GetTextSize(NameTag.NameTag.ContentText, NameTag.NameTag.TextSize, NameTag.NameTag.Font, Camera.ViewportSize)
                        NameTag.NameTag.Size = UDim2.fromOffset(Size.X + 8, Size.Y + 8)
                        NameTag.NameTag.Position = UDim2.fromOffset(HeadPos.X, HeadPos.Y)
                        NameTag.NameTag.TextColor3 = Color
                        NameTag.NameTag.Visible = true
                    else
                        NameTag.NameTag.Visible = false
                    end
                end
            end
        end

        NameTags = Visuals:CreateModule({
            Name = "NameTags",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "NameTags"
                    Folder.Parent = TidalWave.Gui

                    NameTags:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                    NameTags:Clean(CharacterLib.Events.CharacterRemoved:Connect(OnCharacterRemoved))
                    for _, Char in CharacterLib.List do
                        OnCharacterAdded(Char)
                    end
                    NameTags:Clean(RunService.RenderStepped:Connect(RenderNameTags))
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                    table.clear(NameTagObjects)
                end
            end
        })

        local function Update()
            if not NameTags.Enabled then return end
            for i, v in NameTagObjects do
                v.NameTag.BackgroundTransparency = BackgroundTransparency.Value
                v.NameTag.BackgroundColor3 = BackgroundColor.Color
                v.NameTag.TextSize = TextSize.Value
                v.NameTag.Font = Enum.Font[Font.Value]
            end
        end

        TextSize = NameTags:CreateSlider({
            Name = "Text Size",
            Default = 16,
            Min = 8,
            Max = 32,
            Function = Update
        })

        local Fonts = {"Gotham"}

        for _, v in Enum.Font:GetEnumItems() do
            if v.Name == "Gotham" then continue end
            table.insert(Fonts, v.Name)
        end

        Font = NameTags:CreateDropdown({
            Name = "Font",
            List = Fonts,
            Function = Update
        })

        UsePlayers = NameTags:CreateToggle({
            Name = "Players",
            Info = "Whether or not to show players.",
            Default = true,
            Function = function()
                if NameTags.Enabled then
                    NameTags:Toggle(true)
                    NameTags:Toggle(true)
                end
            end
        })

        UseNpcs = NameTags:CreateToggle({
            Name = "NPCs",
            Info = "Whether or not to show npcs.",
            Function = function()
                if NameTags.Enabled then
                    NameTags:Toggle(true)
                    NameTags:Toggle(true)
                end
            end
        })

        TextColor = NameTags:CreateColorPicker({
            Name = "Text Color",
            Default = Color3.fromRGB(255, 255, 255)
        })

        BackgroundColor = NameTags:CreateColorPicker({
            Name = "Background Color",
            Default = Color3.fromRGB(0, 0, 0),
            Function = Update
        })

        BackgroundTransparency = NameTags:CreateSlider({
            Name = "Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = Update
        })

        Offset = NameTags:CreateSlider({
            Name = "Offset",
            Default = 2.5,
            Min = 0,
            Max = 10,
            Decimal = 100,
        })

        UseDisplayName = NameTags:CreateToggle({
            Name = "Use Display Name",
        })

        TeamCheck = NameTags:CreateToggle({
            Name = "Team Check",
            Info = "Hides teammates"
        })

        ShowName = NameTags:CreateToggle({
            Name = "Name",
            Default = true
        })

        ShowHealth = NameTags:CreateToggle({
            Name = "Health",
            Default = true
        })

        ShowDistance = NameTags:CreateToggle({
            Name = "Distance",
            Default = false
        })

        UseTeamColor = NameTags:CreateToggle({
            Name = "Use Team Color",
        })
    end)

    Run(function() -- ESP
        local ESP, Color, Thickness, TeamCheck, UseTeamColor, Folder, SizeX, SizeY

        local Frames = {}

        local function OnCharacterRemoved(Char)
            local Box = Frames[Char.Character]
            if Box then
                Box.Frame:Destroy()
                Frames[Char.Character] = nil
            end
        end

        local function OnCharacterAdded(Char)
            OnCharacterRemoved(Char)
            local Box = Instance.new("Frame")
            Box.BackgroundTransparency = 1
            Box.Active = false
            Box.Interactable = false
            Box.Name = `{Char.Player and Char.Player.Name or Char.Character.Name}_BoxESP`
            Box.AnchorPoint = Vector2.new(0.5, 0.5)
            Box.ZIndex = 0
            Box.Parent = Folder
            
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Thickness = Thickness.Value
            UIStroke.Color = Color.Color
            UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
            UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            UIStroke.Parent = Box

            Frames[Char.Character] = {Frame = Box, Player = Char.Player}
        end

        ESP = Visuals:CreateModule({
            Name = "ESP",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "ESP"
                    Folder.Parent = TidalWave.Gui

                    ESP:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                    ESP:Clean(CharacterLib.Events.CharacterRemoved:Connect(OnCharacterRemoved))
                    for i, Char in CharacterLib.List do
                        OnCharacterAdded(Char)
                    end

                    ESP:Clean(RunService.RenderStepped:Connect(function()
                        for Char, Frame in Frames do
                            local Character = CharacterLib:FindCharacter(Char)
                            if not Character or TeamCheck.Enabled and Character.Teammate then
                                Frame.Frame.UIStroke.Enabled = false
                            else
                                local RootPos, RootOnScreen = Camera:WorldToViewportPoint(Character.Root.Position)
                                if RootOnScreen then
                                    Frame.Frame.Size = UDim2.fromOffset((1920 * SizeX.Value) / RootPos.Z, (1920 * SizeY.Value) / RootPos.Z)
                                    Frame.Frame.Position = UDim2.fromOffset(RootPos.X, RootPos.Y)
                                    Frame.Frame.UIStroke.Color = UseTeamColor.Enabled and Character.Player.Team and Character.Player.Team.TeamColor.Color or Color.Color
                                    Frame.Frame.UIStroke.Thickness = Thickness.Value
                                    Frame.Frame.UIStroke.Enabled = true
                                else
                                    Frame.Frame.UIStroke.Enabled = false
                                end
                            end
                        end
                    end))
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                    table.clear(Frames)
                end
            end
        })

        Thickness = ESP:CreateSlider({
            Name = "Box Thickness",
            Default = 1,
            Min = 1,
            Max = 5,
        })

        Color = ESP:CreateColorPicker({
            Name = "Box Color",
            Default = Color3.fromRGB(255, 255, 255)
        })

        UseTeamColor = ESP:CreateToggle({
            Name = "Use Team Color",
        })

        TeamCheck = ESP:CreateToggle({
            Name = "Team Check",
            Info = "Hides teammates",
        })

        SizeX = ESP:CreateSlider({
            Name = "X Size",
            Default = 0.75,
            Min = 0,
            Max = 3,
            Decimal = 100,
        })

        SizeY = ESP:CreateSlider({
            Name = "Y Size",
            Default = 1,
            Min = 0,
            Max = 3,
            Decimal = 100,
        })
    end)

    Run(function() -- PartESP
        local PartESP, Method, HighlightType, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Shading, DepthMode, Path, PathTextBox, Names, Folder

		local function HighlightPart(Part)
			if HighlightType.Value == "Highlight" then
				local Highlight = Instance.new("Highlight")
				Highlight.Name = `{Part.Name}_ESP`
				Highlight.OutlineColor = OutlineColor.Color
				Highlight.FillColor = FillColor.Color
				Highlight.OutlineTransparency = OutlineColor.Transparency
				Highlight.FillTransparency = FillColor.Transparency
				Highlight.DepthMode = Enum.HighlightDepthMode[DepthMode.Value]
				Highlight.Adornee = Part
				Highlight.Parent = Folder
			else
				local Box = Instance.new("BoxHandleAdornment")
				Box.Shading = Enum.AdornShading[Shading.Value]
				Box.Size = Part.Size
				Box.Name = `{Part.Name}_ESP`
				Box.Color3 = FillColor.Color
				Box.Transparency = FillColor.Transparency
				Box.Adornee = Part
				Box.ZIndex = 1
				Box.Parent = Folder
			end
		end

		local function OnChildAdded(Child)
			if HighlightType.Value == "Highlight" then
				if Child:IsA("BasePart") or Child:IsA("Model") then
					HighlightPart(Child)
				end
			else
				if Child:IsA("BasePart") then
					HighlightPart(Child)
				end
			end
		end

		local function NameCheck(Child)
			local Name = Child.Name:lower()
			for i, v in Names.Enabled do
				local ListName = v:lower()
				if (Method.Value == "Exact Name" and ListName == Name) or (Method.Value == "Contains String" and Name:match(ListName)) then
					return true
				end
			end
		end

		local function OnDescendantAdded(Descendant)
			if NameCheck(Descendant) then
				OnChildAdded(Descendant)
			end
		end

		local function Highlight()
			if Method.Value == "Folder" and Path then
				PartESP:Clean(Path.ChildAdded:Connect(OnChildAdded))
				local function Loop(Obj)
					for i, v in Obj:GetChildren() do
						if v:IsA("Folder") then
							Loop(v)
						else
							OnChildAdded(v)
						end
					end
				end
				Loop(Path)
			elseif Method.Value == "Exact Name" or Method.Value == "Contains String" then
				PartESP:Clean(workspace.DescendantAdded:Connect(OnDescendantAdded))
				for i, v in workspace:GetDescendants() do
					OnDescendantAdded(v)
				end
			end
		end

		PartESP = Visuals:CreateModule({
			Name = "PartESP",
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new("Folder")
					Folder.Name = "PartESP"
					Folder.Parent = TidalWave.Gui

					Highlight()
				else
					if Folder then
						Folder:Destroy()
						Folder = nil
					end
				end
			end
		})

		local function Update()
			if PartESP.Enabled then
				PartESP:Toggle(true)
				PartESP:Toggle(true)
			end
		end

		local function UpdateColors()
			if not PartESP.Enabled then return end
			for i, v in Folder:GetChildren() do
				if v:IsA("Highlight") then
					v.OutlineColor = OutlineColor.Color
					v.FillColor = FillColor.Color
					v.OutlineTransparency = OutlineColor.Transparency
					v.FillTransparency = FillColor.Transparency
				elseif v:IsA("BoxHandleAdornment") then
					v.Color3 = FillColor.Color
					v.Transparency = FillColor.Transparency
				end
			end
		end

		Method = PartESP:CreateDropdown({
			Name = "Method",
			List = {"Folder", "Exact Name", "Contains String"},
			Function = function(Val)
				PathTextBox:SetVisible(Val == "Folder")
			end
		})

		HighlightType = PartESP:CreateDropdown({
			Name = "Highlight Type",
			List = {"Highlight", "BoxHandle"},
			Function = function(Val)
				local Equal = Val == "Highlight"
				DepthMode:SetVisible(Equal)
				Shading:SetVisible(not Equal)
				OutlineColor:SetVisible(Equal)
				FillColor:SetVisible(Equal)
				Update()
			end
		})

		Shading = PartESP:CreateDropdown({
			Name = "Shading",
			List = {"AlwaysOnTop", "Default", "Shaded", "XRay", "XRayShaded"},
			Visible = false,
			Function = Update,
		})

		DepthMode = PartESP:CreateDropdown({
			Name = "Depth Mode",
			List = {"AlwaysOnTop", "Occluded"},
			Function = Update,
		})
		
		OutlineColor = PartESP:CreateColorPicker({
			Name = "Outline Color",
			Default = Color3.fromRGB(255, 255, 255),
			Function = UpdateColors
		})
		
		FillColor = PartESP:CreateColorPicker({
			Name = "Fill Color",
			Default = Color3.fromRGB(255, 255, 255),
			Transparency = 0.2,
			Function = UpdateColors
		})

		PathTextBox = PartESP:CreateTextBox({
			Name = "Folder Path",
			PlaceholderText = "Enter path",
			Visible = false,
			Function = function(Text)
				local Obj = loadstring(`return {Text}`)
				if typeof(Obj) == "function" then
					Path = Obj()
				else
					Notify({
						Text = Obj,
						Duration = 5,
					})
				end
			end
		})

		Names = PartESP:CreateTextList({
			Name = "Names",
			Function = Update
		})
    end)

    Run(function() -- Fov
        local Fov, FieldOfView

        Fov = Visuals:CreateModule({
            Name = "Fov",
            Info = "Sets your field of view to the specified value",
            Enabled = function()
                Camera.FieldOfView = FieldOfView.Value
                Fov:Clean(Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                    Camera.FieldOfView = FieldOfView.Value
                end))
            end
        })

        FieldOfView = Fov:CreateSlider({
            Name = "Field Of View",
            Default = Camera.FieldOfView,
            Min = 1,
            Max = 120,
            Function = function(Val)
                if Fov.Enabled then
                    Camera.FieldOfView = Val
                end
            end
        })
    end)

    Run(function() -- Viewport Chams
        local ViewportChams, ViewportFrame, ViewportModel, Color, TeamCheck, ShowPlayers, ShowNPCs

        local Models = {}
        local Parts = {}
        local OtherObjects = {}

        local Blacklist = {
            Status = true,
            LocalScript = true,
            Script = true,
            ModuleScript = true,
            TouchTransmitter = true,
            Sound = true,
        }

        local function CharacterAdded(Char)
            if TeamCheck.Enabled and Char.Teammate then return end
            if not ShowPlayers.Enabled and Char.Player then return end
            if not ShowNPCs.Enabled and Char.NPC then return end

            local function Recursive(Obj, Parent)
                for _, v in Obj:GetChildren() do
                    if Blacklist[v.ClassName] then continue end
                    local Clone = Instance.fromExisting(v)
                    if Clone:IsA("BasePart") then
                        Parts[v] = Clone
                    else
                        OtherObjects[v] = Clone
                    end
                    Clone.Parent = Parent
                    Recursive(v, Clone)
                end
            end

            local Model = Instance.new("Model")
            Model.Name = (Char.Player and Char.Player.Name or Char.Character.Name) .. '_Chams'
            Model.Parent = ViewportModel

            Recursive(Char.Character, Model)

            ViewportChams:Clean(Char.Character.DescendantAdded:Connect(function(Child)
                if Blacklist[Child.ClassName] then return end
                task.defer(function()
                    local Clone = Instance.fromExisting(Child)
                    if Child:IsA("BasePart") then
                        Parts[Child] = Clone
                    else
                        OtherObjects[Child] = Clone
                    end
                    local Parent
                    for _, Tab in {Parts, OtherObjects} do
                        local Success
                        for Original, Clone in Tab do
                            if Original == Child.Parent then
                                Parent = Clone
                                Success = true
                                break
                            end
                        end
                        if Success then break end
                    end
                    
                    Clone.Parent = Parent or Model
                end)
            end))

            ViewportChams:Clean(Char.Character.DescendantRemoving:Connect(function(Child)
                if Parts[Child] then
                    Parts[Child]:Destroy()
                    Parts[Child] = nil
                end
            end))

            Models[Char.Character] = Model
        end

        local function CharacterRemoved(Char)
            if Models[Char.Character] then
                Models[Char.Character]:Destroy()
                Models[Char.Character] = nil
            end
        end
        
        ViewportChams = Visuals:CreateModule({
            Name = "Viewport Chams",
            Info = "Renders players through walls using viewport frames.",
            Function = function(Enabled)
                if Enabled then
                    ViewportFrame = Instance.new("ViewportFrame")
                    ViewportFrame.Name = 'ChamsViewportFrame'
                    ViewportFrame.Size = UDim2.fromScale(1, 1)
                    ViewportFrame.BackgroundTransparency = 1
                    ViewportFrame.CurrentCamera = Camera
                    ViewportFrame.Ambient = White
                    ViewportFrame.LightColor = White
                    ViewportFrame.ImageColor3 = Color.Color
                    ViewportFrame.ImageTransparency = Color.Transparency
                    ViewportFrame.LightDirection = Vector3.zero
                    ViewportFrame.ZIndex = 0
                    ViewportFrame.Parent = TidalWave.Gui

                    ViewportModel = Instance.new("WorldModel")
                    ViewportModel.Name = 'ChamsWorldModel'
                    ViewportModel.Parent = ViewportFrame

                    ViewportChams:Clean(CharacterLib.Events.CharacterAdded:Connect(CharacterAdded))
                    ViewportChams:Clean(CharacterLib.Events.CharacterRemoved:Connect(CharacterRemoved))
                    for _, Character in CharacterLib.List do
                        CharacterAdded(Character)
                    end

                    ViewportChams:Clean(RunService.RenderStepped:Connect(function()
                        for Part, Clone in Parts do
                            Clone.CFrame = Part.CFrame
                        end
                    end))
                else
                    ViewportFrame:Destroy()
                    ViewportFrame = nil
                    table.clear(Parts)
                    table.clear(OtherObjects)
                    table.clear(Models)
                end
            end,
        })

        Color = ViewportChams:CreateColorPicker({
            Name = 'Color',
            Default = White,
            FunctionEnabled = function(Color, Transparency)
                if ViewportFrame then
                    ViewportFrame.ImageColor3 = Color
                    ViewportFrame.ImageTransparency = Transparency
                end
            end
        })

        local function Update()
            if ViewportChams.Enabled then
                ViewportChams:Toggle(true)
                ViewportChams:Toggle(true)
            end
        end

        ShowPlayers = ViewportChams:CreateToggle({
            Name = 'Players',
            Info = 'Whether or not to show players.',
            Default = true,
            Function = Update
        })

        ShowNPCs = ViewportChams:CreateToggle({
            Name = 'NPCs',
            Info = 'Whether or not to show NPCs.',
            Function = Update
        })

        TeamCheck = ViewportChams:CreateToggle({
            Name = 'Team Check',
            Info = 'Hides teammates.',
            Function = Update
        })
    end)

    Run(function() -- CameraZoom
        local CameraZoom, MinZoom, MaxZoom

        CameraZoom = Visuals:CreateModule({
            Name = "CameraZoom",
            Info = "Loop Sets Camera Min Zoom And Max Zoom",
            Enabled = function()
                Plr.CameraMaxZoomDistance = MaxZoom.Value
                Plr.CameraMinZoomDistance = MinZoom.Value
                CameraZoom:Clean(Plr:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
                    Plr.CameraMaxZoomDistance = MaxZoom.Value
                end))
                CameraZoom:Clean(Plr:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
                    Plr.CameraMinZoomDistance = MinZoom.Value
                end))
            end,
        })

        MinZoom = CameraZoom:CreateSlider({
            Name = "Min Zoom",
            Default = math.floor(Plr.CameraMinZoomDistance * 10) / 10,
            Min = 0.5,
            Max = 100,
            Decimal = 10,
            Function = function(Val)
                if CameraZoom.Enabled then
                    Plr.CameraMinZoomDistance = Val
                end
            end
        })

        MaxZoom = CameraZoom:CreateSlider({
            Name = "Max Zoom",
            Default = Plr.CameraMaxZoomDistance,
            Min = 1,
            Max = 1000,
            Function = function(Val)
                if CameraZoom.Enabled then
                    Plr.CameraMaxZoomDistance = Val
                end
            end
        })
    end)

    Run(function() -- CameraMode
        local CameraMode, Mode

        local function Update()
            if not CameraMode.Enabled then return end
            Plr.CameraMode = Mode.Value == "First Person" and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
        end

        CameraMode = Visuals:CreateModule({
            Name = "CameraMode",
            Info = "Sets your camera to third/first person",
            Enabled = function()
                Update()
                CameraMode:Clean(Plr:GetPropertyChangedSignal("CameraMode"):Connect(Update))
            end
        })

        Mode = CameraMode:CreateDropdown({
            Name = "Camera Mode",
            List = {"Third Person", "First Person"},
            Function = Update
        })
    end)

    Run(function() -- AntiLag
        local AntiLag

        local Plastic = Enum.Material.Plastic
        local Range = NumberRange.new(0, 0)
        local Objects = {}
        
        local function SparklesFunction(Obj)
            task.defer(function()
                if Obj.Enabled then
                    Objects[Obj] = {Enabled = true}
                    Obj.Enabled = false
                end
            end)
        end

        local function BasePartFunction(Obj)
            Objects[Obj] = {Material = Obj.Material, Reflectance = Obj.Reflectance, CastShadow = Obj.CastShadow}
            Obj.Material = Plastic
            Obj.Reflectance = 0
            Obj.CastShadow = false
        end

        local Functions = {
            Part = BasePartFunction,
            MeshPart = BasePartFunction,
            TrussPart = BasePartFunction,
            SpawnLocation = BasePartFunction,
            Seat = BasePartFunction,
            VehicleSeat = BasePartFunction,
            UnionOperation = BasePartFunction,
            NegateOperation = BasePartFunction,
            IntersectOperation = BasePartFunction,
            Terrain = BasePartFunction,
            Decal = function(Obj)
                Objects[Obj] = {Transparency = Obj.Transparency}
                Obj.Transparency = 1
            end,
            ParticleEmitter = function(Obj)
                Objects[Obj] = {LifeTime = Obj.LifeTime}
                Obj.LifeTime = Range
            end,
            Trail = function(Obj)
                Objects[Obj] = {LifeTime = Obj.LifeTime}
                Obj.LifeTime = 0
            end,
            Explosion = function(Obj)
                Objects[Obj] = {BlastPressure = Obj.BlastPressure, BlastRadius = Obj.BlastRadius}
                Obj.BlastPressure = 0
                Obj.BlastRadius = 0
            end,
            Sparkles = SparklesFunction,
            Smoke = SparklesFunction,
            Fire = SparklesFunction,
            ForceField = SparklesFunction
        }

        local function GetFunction(Obj)
            for i, v in Functions do
                if Obj:IsA(i) then
                    return v
                end
            end
            return nil
        end

        AntiLag = Visuals:CreateModule({
            Name = "AntiLag",
            Info = "Remotes lots of diffent details to increase FPS",
            Function = function(Enabled)
                if Enabled then
                    Lighting.GlobalShadows = false
                    
                    for i, v in workspace:QueryDescendants("BasePart, Decal, ParticleEmitter, Trail, Explosion, Sparkles, Smoke, Fire, ForceField") do
                        Functions[v.ClassName](v)
                    end

                    AntiLag:Clean(workspace.DescendantAdded:Connect(function(Child)
                        local f = GetFunction(Child)
                        if f then
                            f(Child)
                        end
                    end))
                else
                    for i, v in Objects do
                        if i.Parent then
                            for i2, v2 in v do
                                i[i2] = v2
                            end
                        end
                    end
                    table.clear(Objects)
                end
            end
        })
    end)

    Run(function() -- NoPurchasePrompts
        Visuals:CreateModule({
            Name = "NoPurchasePrompts",
            Info = "Hides Robux purchase prompts",
            Function = function(Enabled)
                local FoundationOverlay = CoreGui and CoreGui:FindFirstChild("FoundationOverlay")
                if FoundationOverlay then
                    FoundationOverlay.Enabled = not Enabled
                end
            end
        })
    end)

    Run(function() -- Use2022Materials
        Visuals:CreateModule({
            Name = "Use2022Materials",
            Function = function(Enabled)
                MaterialService.Use2022Materials = Enabled
            end,
        })
    end)

    Run(function() -- NoRender
        Visuals:CreateModule({
            Name = "NoRender",
            Info = "Disables 3D Rendering",
            Function = function(Enabled)
                RunService:Set3dRenderingEnabled(not Enabled)
            end
        })
    end)
end)

Run(function() -- World
    Run(function() -- Gravity
        local Gravity, GravityVal, ResetGravityOnDisabled

        Gravity = World:CreateModule({
            Name = "Gravity",
            Info = "Sets the gravity of workspace",
            Function = function(Enabled)
                if Enabled then
                    Gravity:Clean(workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
                        workspace.Gravity = GravityVal.Value
                    end))
                    workspace.Gravity = GravityVal.Value
                else
                    if ResetGravityOnDisabled.Enabled then
                        workspace.Gravity = 196.2
                    end
                end
            end
        })

        GravityVal = Gravity:CreateSlider({
            Name = "Gravity",
            Default = 196.2,
            Min = 0,
            Max = 1000,
            Decimal = 10,
            Function = function(Val)
                if Gravity.Enabled then
                    workspace.Gravity = Val
                end
            end
        })

        ResetGravityOnDisabled = Gravity:CreateToggle({
            Name = "Reset Gravity On Disabled",
            Default = true
        })
    end)

    Run(function() -- InstantProximityPrompts
        local ToggleInstantProximityPrompts
        
        ToggleInstantProximityPrompts = World:CreateModule({
            Name = "InstantProximityPrompts",
            Info = "Instantly triggers ProximityPrompts you interact with",
            Enabled = function()
                if not fireproximityprompt then NotifyPoopSploit("fireproximityprompt") return end
                ToggleInstantProximityPrompts:Clean(ProximityPromptService.PromptButtonHoldBegan:Connect(fireproximityprompt))
            end,
        })
    end)

    Run(function() -- TP-Unanchored Parts
        local Tpua, NameTextBox, Fling, Player

        local Limbs = {
            "Head",
            "Torso",
            "LowerTorso",
            "UpperRightArm",
            "Right Arm",
            "LowerRightArm",
            "UpperLeftArm",
            "LowerLeftArm",
            "Left Arm",
            "UpperRightLeg",
            "LowerRightLeg",
            "Right Leg",
            "UpperLeftLeg",
            "LowerLeftLeg",
            "Left Leg",
            "HumanoidRootPart",
        }

        local BodyPositions = {}
        
        Tpua = World:CreateModule({
            Name = "TP Un-anchored Parts",
            Info = "Teleports un-anchored parts to the specified player\nYou must have network ownership of the parts for it to work",
            Function = function(Enabled)
                if Enabled then
                    local Character = CharacterLib:FindCharacter(Player)
                    local Target = Character and Character.Root or CharacterLib.Alive and CharacterLib.Root
                    if not Target then return end
                    for _, Part in workspace:QueryDescendants("BasePart[Anchored = false]") do
                        if Part:IsDescendantOf(CharacterLib.Character) or table.find(Limbs, Part.Name) then continue end
                        local BodyPosition = Instance.new("BodyPosition")
                        BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        BodyPosition.Position = Target.Position
                        BodyPosition.D = Fling.Enabled and 0 or 1250
                        BodyPosition.Parent = Part
                        table.insert(BodyPositions, BodyPosition)
                    end
                else
                    for _, v in BodyPositions do
                        v:Destroy()
                    end
                    table.clear(BodyPositions)
                end
            end
        })

        NameTextBox = Tpua:CreateTextBox({
            Name = "Name",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {Player.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })

        Fling = Tpua:CreateToggle({
            Name = "Fling",
            Info = "Fling people that touch the parts",
            Function = function(Enabled)
                for _, v in BodyPositions do
                    v.D = Enabled and 0 or 1250
                end
            end
        })
    end)

    Run(function() -- FireClickDetectors
        World:CreateButton({
            Name = "Fire ClickDetectors",
            Info = "Fires all click detectors",
            Function = function()
                if not fireclickdetector then NotifyPoopSploit("fireclickdetector") return end
                for _, ClickDetector in workspace:QueryDescendants("ClickDetector") do
                    fireclickdetector(ClickDetector)
                end
            end,
        })
    end)

    Run(function() -- FireProximityPrompts
        World:CreateButton({
            Name = "Fire ProximityPrompts",
            Info = "Fires all proximity prompts",
            Function = function()
                if not fireproximityprompt then NotifyPoopSploit("fireproximityprompt") return end
                for _, ProximityPrompt in workspace:QueryDescendants("ProximityPrompt") do
                    fireproximityprompt(ProximityPrompt)
                end
            end,
        })
    end)

    Run(function() -- FireTouchInterests
        World:CreateButton({
            Name = "Fire TouchInterests",
            Info = "Fires all touch interests",
            Function = function()
                if not firetouchinterest then NotifyPoopSploit("firetouchinterest"); return end
                if not CharacterLib.Alive then return end
                for _, Part in workspace:QueryDescendants("BasePart") do
                    firetouchinterest(Part, CharacterLib.Root, true)
                    firetouchinterest(Part, CharacterLib.Root, false)
                    task.wait()
                end
            end,
        })
    end)
end)

Run(function() -- Other
    Run(function() -- Freecam
        local Freecam, Speed, ShiftMultiplier, Part, RandomName

        local Keyboard = {
            W = 0,
            A = 0,
            S = 0,
            D = 0,
            E = 0,
            Q = 0,
            LeftShift = 0
        }

        local function KeyPress(_, State, Input)
            Keyboard[Input.KeyCode.Name] = State == Enum.UserInputState.Begin and 1 or 0
        end

        local function StepCamera(Delta)
            local Direction = Vector3.new(Keyboard.D - Keyboard.A, 0, Keyboard.S - Keyboard.W)
            if Direction.Magnitude > 0 then
                Direction = Direction.Unit
            end

            Direction = (Direction + Vector3.new(0, Keyboard.E - Keyboard.Q, 0)) * Speed.Value
            if Keyboard.LeftShift == 1 then
                Direction *= ShiftMultiplier.Value
            end

            Part.CFrame = CFrame.lookAlong(Part.Position, Camera.CFrame.LookVector) * CFrame.new(Direction * 50 * Delta)
        end
        
        local function RandomString()
            local Array = {}
            for i = 1, 10 do
                Array[i] = string.char(math.random(32, 126))
            end
            return table.concat(Array)
        end

        Freecam = Other:CreateModule({
            Name = "Freecam",
            Function = function(Enabled)
                if Enabled then
                    Part = Instance.new("Part")
                    Part.Transparency = 1
                    Part.Size = Vector3.zero
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanTouch = false
                    Part.CanQuery = false
                    Part.AudioCanCollide = false
                    Part.CFrame = CharacterLib.Alive and CharacterLib.Head.CFrame or Camera.CFrame
                    Part.Parent = workspace

                    RandomName = RandomString()

                    Freecam:Clean(Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                        Camera.CameraSubject = Part
                    end))
                    Freecam:Clean(RunService.RenderStepped:Connect(StepCamera))
			        ContextActionService:BindActionAtPriority(`FreecamKeyboard{RandomName}`, KeyPress, false, 69420, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.LeftShift)
                    Camera.CameraSubject = Part
                else
                    ContextActionService:UnbindAction(`FreecamKeyboard{RandomName}`)
                    RandomName = nil
                    if Part then
                        Part:Destroy()
                        Part = nil
                    end
                    local TimeOut = os.clock() + 10
                    while not CharacterLib.Alive do
                        if os.clock() >= TimeOut then break end
                        task.wait()
                    end
                    if CharacterLib.Alive then
                        Camera.CameraSubject = CharacterLib.Humanoid
                    end
                end
            end
        })

        Speed = Freecam:CreateSlider({
            Name = "Speed",
            Default = 1,
            Min = 0,
            Max = 10,
        })
        ShiftMultiplier = Freecam:CreateSlider({
            Name = "Shift Multiplier",
            Default = 2,
            Min = 0,
            Max = 10,
        })
    end)

    Run(function() -- View
        local View, TextBox, Player

        View = Other:CreateModule({
            Name = "View",
            Info = "Views the specified player",
            Function = function(Enabled)
                if Enabled then
                    if Player then
                        View:Clean(Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                            local Character = CharacterLib:FindCharacter(Player)
                            if Character then
                                Camera.CameraSubject = Character.Humanoid
                            end
                        end))
                        local Character = CharacterLib:FindCharacter(Player)
                        if Character then
                            Camera.CameraSubject = Character.Humanoid
                        end
                    else
                        Notify({Text = "Select a player first", Duration = 4})
                    end
                    View:Clean(CharacterLib.Events.CharacterAdded:Connect(function(Char)
                        if Char.Player and Char.Player == Player then
                            Camera.CameraSubject = Char.Humanoid
                        end
                    end))
                    View:Clean(CharacterLib.Events.CharacterRemoved:Connect(function(Char)
                        if Char.Player and Char.Player == Player and CharacterLib.Alive then
                            Camera.CameraSubject = CharacterLib.Humanoid
                        end
                    end))
                    View:Clean(Players.PlayerRemoving:Connect(function(PlayerRemoving)
                        if PlayerRemoving == Player then
                            Camera.CameraSubject = CharacterLib.Humanoid
                            Player = nil
                            Notify({Text = "View has been disabled because the player left"})
                        end
                    end))
                else
                    if CharacterLib.Alive then
                        Camera.CameraSubject = CharacterLib.Humanoid
                    end
                end
            end
        })

        TextBox = View:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                    if View.Enabled then
                        local Character = CharacterLib:FindCharacter(Player)
                        if Character then
                            Camera.CameraSubject = Character.Humanoid
                        end
                    end
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- AntiKick
        local AntiKick, OldIndex, OldNamecall

        AntiKick = Other:CreateModule({
            Name = "AntiKick",
            Info = "Prevents you from getting kicked by local scripts",
            Enabled = function()
                if not hookmetamethod then NotifyPoopSploit("hookmetamethod") return end
                if not getnamecallmethod then NotifyPoopSploit("getnamecallmethod") return end
                OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Key)
                    if self == Plr and Key:lower() == "kick" then
                        return error("Expected ':' not '.' calling member function Kick", 2)
                    end
                    return OldIndex(self, Key)
                end))
                OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                    if self == Plr and getnamecallmethod():lower() == "kick" then
                        return
                    end
                    return OldNamecall(self, ...)
                end))
                AntiKick:Clean(function()
                    hookmetamethod(game, "__index", OldIndex)
                    hookmetamethod(game, "__namecall", OldNamecall)
                end)
            end,
        })
    end)

    Run(function() -- AntiTeleport
        local AntiTeleport, OldIndex, OldNamecall

        AntiTeleport = Other:CreateModule({
            Name = "AntiTeleport",
            Info = "Prevents you from getting teleported by local scripts",
            Enabled = function()
                if not hookmetamethod then NotifyPoopSploit("hookmetamethod") return end
                if not getnamecallmethod then NotifyPoopSploit("getnamecallmethod") return end
                OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Key)
                    if self == TeleportService then
                        if Key:lower() == "teleport" then
                            return error("Expected ':' not '.' calling member function Kick", 2)
                        elseif Key == "TeleportToPlaceInstance" then
                            return error("Expected ':' not '.' calling member function TeleportToPlaceInstance", 2)
                        end
                    end
                    return OldIndex(self, Key)
                end))
                OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                    if self == TeleportService then
                        local Method = getnamecallmethod()
                        if Method:lower() == "teleport" or Method == "TeleportToPlaceInstance" then
                            return
                        end
                    end
                    return OldNamecall(self, ...)
                end))
                AntiTeleport:Clean(function()
                    hookmetamethod(game, "__index", OldIndex)
                    hookmetamethod(game, "__namecall", OldNamecall)
                end)
            end,
        })
    end)

    Run(function() -- AntiFling
        local AntiFling

        AntiFling = Other:CreateModule({
            Name = "AntiFling",
            Info = "Prevents you from getting flung by other players",
            Enabled = function()
                AntiFling:Clean(RunService.Stepped:Connect(function()
                    for _, Player in CharacterLib.List do
                        for _, Part in Player.Character:QueryDescendants("BasePart[CanCollide = true]") do
                            Part.CanCollide = false
                        end
                    end
                end))
            end
        })
    end)

    Run(function() -- CameraNoclip
        local CameraNoclip

        CameraNoclip = Other:CreateModule({
            Name = "CameraNoclip",
            Info = "Allows your camera to move through walls",
            Enabled = function()
                if not setconstant then NotifyPoopSploit("setconstant") return end
                if not getconstants then NotifyPoopSploit("getconstants") return end
                if not getgc then NotifyPoopSploit("getgc") return end

                for _, Function in getgc() do
                    if typeof(Function) == "function" then
                        local Source, Name = debug.info(Function, "sn")
                        if Source:find("ZoomController.Popper") and Name == "queryPoint" then
                            for ConstantIndex, Constant in getconstants(Function) do
                                if Constant == 0.25 then
                                    setconstant(Function, ConstantIndex, 0)
                                    CameraNoclip:Clean(setconstant, Function, ConstantIndex, 0.25)
                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end
        })
    end)

    Run(function() -- Fix Camera
        Other:CreateButton({
            Name = "Fix Camera",
            Info = "Attempts to fix you camera",
            Function = function()
                if Modules.Freecam and Modules.Freecam.Enabled then
                    Modules.Freecam:Toggle(true)
                end
                if Modules.View and Modules.View.Enabled then
                    Modules.View:Toggle(true)
                end
                Camera.CameraSubject = CharacterLib.Humanoid
            end
        })
    end)

    Run(function()
        local FPSCap, FPS

        FPSCap = Other:CreateModule({
            Name = "FPSCap",
            Info = "Sets your fps cap.",
            Enabled = function()
                if setfpscap then
                    local OldCap = getfpscap and getfpscap() or 240
                    setfpscap(FPS.Value)
                    FPSCap:Clean(setfpscap, OldCap)
                else
                    FPSCap:Clean(task.spawn(function()
                        local LastFrame
                        while true do
                            local Clock = os.clock()
                            if Clock >= LastFrame + 1 / FPS.Value then
                                LastFrame = Clock
                                RunService.RenderStepped:Wait()
                            end
                        end
                    end))
                end
            end,
        })

        FPS = FPSCap:CreateSlider({
            Name = "FPS",
            Default = 60,
            Min = 1,
            Max = 500,
            Function = function(Val)
                if FPSCap.Enabled and setfpscap then
                    setfpscap(Val)
                end
            end
        })
    end)
end)

Run(function() -- Animations
    Run(function() -- Spasm
        local Spasm, Speed, Track

        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://33796059"

        Spasm = Animations:CreateModule({
            Name = "Spasm",
            Enabled = function()
                while Spasm.Enabled do
                    if CharacterLib.Alive then
                        if CharacterLib.RigType == Enum.HumanoidRigType.R15 then Notify({Text = "Spasm only works in R6", Duration = 4}) Spasm:Toggle(true) break end
                        if Track and not Track.IsPlaying then
                            Track:Stop()
                            Track:Destroy()
                            Track = nil
                        end
                        if not Track then
                            local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                            Track = Animator:LoadAnimation(Animation)
                            Track.Priority = Enum.AnimationPriority.Action4
                            Track.Looped = true
                            Track:Play(0, 1, Speed.Value)
                        end
                    end
                    task.wait(0.2)
                end

                if Track then
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                end
            end,
        })

        Speed = Spasm:CreateSlider({
            Name = "Speed",
            Default = 100,
            Min = 0,
            Max = 100,
            Function = function(Val)
                if Track then
                    Track:AdjustSpeed(Val)
                end
            end,
        })
    end)

    Run(function() -- HeadThrow
        local HeadThrow, Speed, Track

        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://35154961"

        HeadThrow = Animations:CreateModule({
            Name = "HeadThrow",
            Function = function(Enabled)
                if Enabled then
                    while HeadThrow.Enabled do
                        if CharacterLib.Alive then
                            if CharacterLib.Humanoid.RigType == Enum.HumanoidRigType.R15 then Notify({Text = "Head Throw only works with R6"}) HeadThrow:Toggle(true) break end
                            if Track and not Track.IsPlaying then
                                Track:Destroy()
                                Track = nil
                            end
                            if not Track then
                                local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                                Track = Animator:LoadAnimation(Animation)
                                Track.Priority = Enum.AnimationPriority.Action4
                                Track.Looped = true
                                Track:Play(0, 1, Speed.Value)
                            end
                        end
                        task.wait(0.2)
                    end
                else
                    if Track then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end
                end
            end
        })

        Speed = HeadThrow:CreateSlider({
            Name = 'Speed',
            Default = 1,
            Min = 0,
            Max = 10,
            Function = function(Val)
                if Track then
                    Track:AdjustSpeed(Val)
                end
            end
        })
    end)

    Run(function() -- FreezeAnimations
        local FreezeAnimations, Speed, UseMulti, Multi

        local AnimationTracks = {}

        FreezeAnimations = Animations:CreateModule({
            Name = "AnimationSpeed",
            Info = "Sets the speed of all your currently playing animations",
            Enabled = function()
                FreezeAnimations:Clean(RunService.PreAnimation:Connect(function()
                    if not CharacterLib.Alive then return end
                    local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                    for i, v: AnimationTrack in Animator:GetPlayingAnimationTracks() do
                        if not AnimationTracks[v] then
                            AnimationTracks[v] = v.Speed
                        end
                        local CalculatedSpeed = UseMulti.Enabled and (AnimationTracks[v] * Multi.Value) or Speed.Value
                        if v.Speed ~= CalculatedSpeed then
                            v:AdjustSpeed(CalculatedSpeed)
                        end
                    end
                end))
                FreezeAnimations:Clean(function()
                    for i: AnimationTrack, v in AnimationTracks do
                        i:AdjustSpeed(v)
                    end
                    table.clear(AnimationTracks)
                end)
            end,
        })

        Speed = FreezeAnimations:CreateSlider({
            Name = "Speed",
            Default = 1,
            Min = 0,
            Max = 3,
            Decimal = 10,
        })

        UseMulti = FreezeAnimations:CreateToggle({
            Name = "Use Multi",
            Info = "Multiplies the speed of all your animations rather than just setting it",
            Function = function(Enabled)
                Multi:SetVisible(Enabled)
            end
        })

        Multi = FreezeAnimations:CreateSlider({
            Name = "Multi",
            Default = 1,
            Min = 0,
            Max = 3,
            Visible = false,
            Decimal = 10,
        })
    end)

    Run(function() -- Jerk
        local Jerk, Speed, Track

        local Animation = Instance.new("Animation")

        Jerk = Animations:CreateModule({
            Name = "Jerk",
            Info = "Makes you absolutely jork it",
            Enabled = function()
                while Jerk.Enabled do
                    if not CharacterLib.Alive then task.wait() continue end
                    Animation.AnimationId = CharacterLib.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://698251653" or "rbxassetid://72042024"
                    local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                    Track = Animator:LoadAnimation(Animation)
                    Track.Priority = Enum.AnimationPriority.Action4
                    Track:Play(0, 1, 0.7 * Speed.Value)
                    Track.TimePosition = 0.6
                    task.wait(0.1 / Speed.Value)
                    if not Track then continue end
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                end
                if Track then
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                end
            end,
        })

        Speed = Jerk:CreateSlider({
            Name = "Jerk Speed",
            Default = 1,
            Min = 0,
            Max = 10,
            Decimal = 10
        })
    end)

    Run(function() -- Bang
        local Bang, TextBox, Player, Speed, Track

        local Offset = CFrame.new(0, 0, 1.1)
        local Animation = Instance.new("Animation")

        Bang = Animations:CreateModule({
            Name = "Bang",
            Info = "Bangs the specified player",
            Enabled = function()
                Bang:Clean(Players.PlayerRemoving:Connect(function(PlayerRemoving)
                    if PlayerRemoving == Player then
                        Bang:Toggle(true)
                        Notify({Text = "Bang has been disabled because the player left"})
                        Player = nil
                    end
                end))
                while Bang.Enabled do
                    if not CharacterLib.Alive then task.wait() continue end
                    if Track and not Track.IsPlaying then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end
                    if not Track then
                        Animation.AnimationId = CharacterLib.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://5918726674" or "rbxassetid://148840371"
                        local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                        Track = Animator:LoadAnimation(Animation)
                        Track.Looped = true
                        Track.Priority = Enum.AnimationPriority.Action4
                        Track:Play(0, 1, Speed.Value * 3)
                    end
                    if not Player then task.wait() continue end
                    local Character = CharacterLib:FindCharacter(Player)
                    if not Character then task.wait() continue end
                    CharacterLib.Root.CFrame = Character.Root.CFrame * Offset
                    CharacterLib.Root.AssemblyLinearVelocity = Vector3.zero
                    RunService.Heartbeat:Wait()
                end
                if Track then
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                end
            end
        })

        TextBox = Bang:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })

        Speed = Bang:CreateSlider({
            Name = "Speed",
            Default = 1,
            Min = 0,
            Max = 3,
            Function = function(Val)
                if Track then
                    Track:AdjustSpeed(Val * 3)
                end
            end
        })
    end)

    Run(function() -- Carpet
        local Carpet, TextBox, Player

        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://282574440"

        Carpet = Animations:CreateModule({
            Name = "Carpet",
            Info = "You become the specifed player's carpet",
            Enabled = function()
                Carpet:Clean(Players.PlayerRemoving:Connect(function(PlayerRemoving)
                    if PlayerRemoving == Player then
                        Carpet:Toggle(true)
                        Notify({Text = "Carpet has been disabled because the player left"})
                        Player = nil
                    end
                end))
                local Track
                while Carpet.Enabled do
                    if not CharacterLib.Alive then task.wait() continue end
                    if CharacterLib.Alive and CharacterLib.Humanoid.RigType == Enum.HumanoidRigType.R15 then Notify({Text = "Carpet only works with R6"}) Carpet:Toggle(true) continue end
                    local Character = CharacterLib:FindCharacter(Player)
                    if not Character then
                        if Track then
                            Track:Stop()
                            Track:Destroy()
                            Track = nil
                        end
                        task.wait()
                        continue
                    end
                    if Track and not Track.IsPlaying then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end

                    if not Track then
                        local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                        Track = Animator:LoadAnimation(Animation)
                        Track.Priority = Enum.AnimationPriority.Action4
                        Track.Looped = true
                        Track:Play(0, 1, 1)
                    end
                    CharacterLib.Root.CFrame = Character.Root.CFrame
                    CharacterLib.Root.AssemblyLinearVelocity = Vector3.zero
                    RunService.Heartbeat:Wait()
                end
                if Track then
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                end
            end
        })

        TextBox = Carpet:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- Carpet 2
        local Carpet, TextBox, Player

        local Angle = CFrame.Angles(math.rad(-90), 0, 0)

        Carpet = Animations:CreateModule({
            Name = "Carpet 2",
            Info = "You become the specifed player's carpet",
            Enabled = function()
                Carpet:Clean(Players.PlayerRemoving:Connect(function(PlayerRemoving)
                    if PlayerRemoving == Player then
                        Carpet:Toggle(true)
                        Notify({Text = "Carpet has been disabled because the player left"})
                        Player = nil
                    end
                end))
                local Track
                while Carpet.Enabled do
                    if not CharacterLib.Alive then task.wait() continue end
                    local Character = CharacterLib:FindCharacter(Player)
                    if not Character then task.wait() continue end

                    CharacterLib.Root.CFrame = Character.Root.CFrame:ToWorldSpace(CFrame.new(0, -Character.HipHeight, 0) * Angle)
                    CharacterLib.Root.AssemblyLinearVelocity = vector.zero
                    CharacterLib.Root.AssemblyAngularVelocity = vector.zero
                    RunService.Heartbeat:Wait()
                end
            end
        })

        TextBox = Carpet:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- HeadSit
        local HeadSit, TextBox, Player

        local Offset = CFrame.new(0, 1.6, 0.4)

        HeadSit = Animations:CreateModule({
            Name = "HeadSit",
            Info = "Sits on the specified player's head",
            Function = function(Enabled)
                if Enabled then
                    local Sat
                    HeadSit:Clean(RunService.Heartbeat:Connect(function()
                        if not CharacterLib.Alive then return end
                        local Character = CharacterLib:FindCharacter(Player)
                        if Character then
                            if Sat then
                                if not CharacterLib.Humanoid.Sit then
                                    HeadSit:Toggle(true)
                                end
                            else
                                Sat = true
                                CharacterLib.Humanoid.Sit = true
                            end
                            CharacterLib.Root.AssemblyLinearVelocity = Vector3.zero
                            CharacterLib.Root.CFrame = Character.Root.CFrame:ToWorldSpace(Offset)
                        else
                            CharacterLib.Humanoid.Sit = false
                        end
                    end))
                else
                    if CharacterLib.Alive then
                        CharacterLib.Humanoid.Sit = false
                    end
                end
            end
        })

        TextBox = HeadSit:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- BendOver
        local BendOver, Track

        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://10214311282"

        BendOver = Animations:CreateModule({
            Name = 'BendOver',
            Info = 'It makes you bend over',
            Function = function(Enabled)
                if Enabled then
                    while BendOver.Enabled do
                        if CharacterLib.Alive then
                            if CharacterLib.RigType == Enum.HumanoidRigType.R6 then Notify({Text = "Bend Over only works with R15"}) BendOver:Toggle(true) break end
                            if Track and not Track.IsPlaying then
                                Track:Destroy()
                                Track = nil
                            end
                            if not Track then
                                local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                                Track = Animator:LoadAnimation(Animation)
                                Track.Priority = Enum.AnimationPriority.Action4
                                Track:Play(0.1, 1, 1)
                                Track.TimePosition = 4
                                Track:AdjustSpeed(0)
                            end
                        end
                        task.wait(0.2)
                    end
                else
                    if Track then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end
                end
            end,
        })
    end)

    Run(function() -- Orbit
        local Orbit, Speed, Distance, TextBox, Player

        Orbit = Animations:CreateModule({
            Name = "Orbit",
            Info = "Orbits the specified player.",
            Enabled = function()
                local Rot = 0

                Orbit:Clean(RunService.Heartbeat:Connect(function(Delta)
                    if not CharacterLib.Alive then return end
                    local Character = CharacterLib:FindCharacter(Player)
                    if Character then
                        Rot += (Speed.Value * math.pi) * Delta
                        CharacterLib.Root.AssemblyLinearVelocity = Vector3.zero
                        CharacterLib.Root.CFrame = (CFrame.new(Character.Root.Position) * CFrame.Angles(0, math.rad(Rot), 0) * CFrame.new(Distance.Value, 0, 0)) * CFrame.lookAt(CharacterLib.Root.Position, Character.Root.Position)
                    end
                end))
            end
        })

        Speed = Orbit:CreateSlider({
            Name = "Speed",
            Default = 1,
            Min = 0,
            Max = 5,
        })

        Distance = Orbit:CreateSlider({
            Name = "Distance",
            Default = 5,
            Min = 0,
            Max = 20,
            Decimal = 10,
        })

        TextBox = Orbit:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- StareAt
        local StareAt, TextBox, Player

        StareAt = Animations:CreateModule({
            Name = "StareAt",
            Info = "Stares at the specified player.",
            Enabled = function()
                StareAt:Clean(RunService.RenderStepped:Connect(function()
                    if not CharacterLib.Alive then return end
                    local Character = CharacterLib:FindCharacter(Player)
                    if Character then
                        CharacterLib.Root.CFrame = CFrame.lookAt(CharacterLib.Root.Position, Vector3.new(Character.Root.Position.X, CharacterLib.Root.Position.Y, Character.Root.Position.Z))
                    end
                end))
            end
        })

        TextBox = StareAt:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {FoundPlayer.DisplayName} @{Player.Name}`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- Dance
        local Dance, Track, R15Dance, R6Dance

        local R6Dances = {
            ["Dance"] = "rbxassetid://27789359",
            ["Moonwalk"] = "rbxassetid://30196114",
            ["Dance Like There's no Tomorrow"] = "rbxassetid://248263260",
            ["Disco"] = "rbxassetid://45834924",
            ["Party"] = "rbxassetid://33796059",
            ["Goal"] = "rbxassetid://28488254",
            ["Flute Dance"] = "rbxassetid://52155728"
        }

        local R15Dances = {
            ["River Dance"] = "rbxassetid://3333432454",
            ["Keeping Time"] = "rbxassetid://4555808220",
            ["Line Dance"] = "rbxassetid://4049037604",
            ["Air Dance"] = "rbxassetid://4555782893",
            ["Break Dance"] = "rbxassetid://10214311282",
            ["Reflex"] = "rbxassetid://10714010337",
            ["Around Town"] = "rbxassetid://10713981723",
            ["Idol Face"] = "rbxassetid://10714372526",
            ["Fancy Feet"] = "rbxassetid://10714076981",
            ["Robot"] = "rbxassetid://10714392151",
            ["Still Standing"] = "rbxassetid://11444443576"
        }

        local Animation = Instance.new("Animation")

        Dance = Animations:CreateModule({
            Name = "Dance",
            Info = "It makes you dance.",
            Function = function(Enabled)
                if Enabled then
                    while Dance.Enabled do
                        if CharacterLib.Alive then
                            if Track and not Track.IsPlaying then
                                Track:Stop()
                                Track:Destroy()
                                Track = nil
                            end
                            if not Track then
                                Animation.AnimationId = CharacterLib.RigType == Enum.HumanoidRigType.R15 and R15Dances[R15Dance.Value] or R6Dances[R6Dance.Value]
                                local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                                Track = Animator:LoadAnimation(Animation)
                                Track.Priority = Enum.AnimationPriority.Action4
                                Track.Looped = true
                                Track:Play(0, 1, 1)
                            end
                        end
                        task.wait(0.2)
                    end
                else
                    if Track then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end
                end
            end,
        })

        R6Dance = Dance:CreateDropdown({
            Name = "R6 Dances",
            List = {"Dance", "Moonwalk", "Dance Like There's no Tomorrow", "Disco", "Party", "Goal", "Flute Dance"},
            Function = function(Val)
                if Dance.Enabled and CharacterLib.Alive and CharacterLib.RigType == Enum.HumanoidRigType.R6 then
                    Track:Stop()
                    Track:Destroy()
                    Track = nil
                    Animation.AnimationId = R6Dances[R6Dance.Value]
                    local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                    Track = Animator:LoadAnimation(Animation)
                    Track.Priority = Enum.AnimationPriority.Action4
                    Track.Looped = true
                    Track:Play(0, 1, 1)
                end
            end
        })

        R15Dance = Dance:CreateDropdown({
            Name = "R15 Dances",
            List = {"River Dance", "Keeping Time", "Line Dance", "Air Dance", "Break Dance", "Reflex", "Around Town", "Idol Face", "Fancy Feet", "Robot", "Still Standing"},
            Function = function(Val)
                if Dance.Enabled and CharacterLib.Alive and CharacterLib.RigType == Enum.HumanoidRigType.R15 then
                    if Track then
                        Track:Stop()
                        Track:Destroy()
                        Track = nil
                    end
                    Animation.AnimationId = R15Dances[Val]
                    local Animator: Animator = CharacterLib.Animator or CharacterLib.Humanoid
                    Track = Animator:LoadAnimation(Animation)
                    Track.Priority = Enum.AnimationPriority.Action4
                    Track.Looped = true
                    Track:Play(0, 1, 1)
                end
            end
        })
    end)

    Run(function() -- Refresh Animations
        Animations:CreateButton({
            Name = "Refresh Animations",
            Info = "Refreshes all your currently playing animations",
            Function = function()
                if CharacterLib.Alive then
                    local Animate = CharacterLib.Character:FindFirstChild("Animate")
                    if Animate then
                        Animate.Enabled = false
                    end
                    for i, v in (CharacterLib.Animator or CharacterLib.Humanoid):GetPlayingAnimationTracks() do
                        v:Stop()
                    end
                    if Animate then
                        Animate.Enabled = true
                    end
                end
            end
        })
    end)
end)

Run(function() -- Scripts
    Run(function()
        Scripts:CreateButton({
            Name = "Infinite Yield",
            Info = "Runs Infinite Yield admin script",
            Function = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end
        })
    end)

    Run(function()
        Scripts:CreateButton({
            Name = "Dex",
            Info = "Runs Dex Explorer",
            Function = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
            end
        })
    end)

    Run(function()
        Scripts:CreateButton({
            Name = "Simple Spy v3",
            Function = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))
            end
        })
    end)

    Run(function()
        Scripts:CreateButton({
            Name = "Cobalt",
            Info = "Runs Cobalt remote spy which is better than Simple Spy v3",
            Function = function()
                loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
            end
        })
    end)

    Run(function()
        Scripts:CreateButton({
            Name = "Audio Logger",
            Function = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua", true))
            end
        })
    end)

    Run(function()
        Scripts:CreateButton({
            Name = "Save Instance",
            Info = "Runs Synapse Save Instance which will save the game to your workspace folder",
            Function = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.lua", true), "saveinstance")({})
            end
        })
    end)
end)

Run(function() -- Server
    Run(function() -- Server Hop
        local ServerHop, PrioritizeLowPingServers
    
        ServerHop = Server:CreateButton({
            Name = "Server Hop",
            Function = function()
                if not request then NotifyPoopSploit("request"); return end
                local Body = HttpService:JSONDecode(request({Url = `https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true`}).Body)

                local Servers = {}

                if Body and Body.data then
                    for i, v in Body.data do
                        if typeof(v) == "table" and typeof(v.playing) == "number" and typeof(v.maxPlayers) == "number" and v.playing < v.maxPlayers and v.id ~= game.JobId then
                            table.insert(Servers, {JobId = v.id, Ping = v.ping, Players = v.playing})
                        end
                    end
                end

                if PrioritizeLowPingServers.Enabled then
                    table.sort(Servers, function(a, b)
                        return a.Ping < b.Ping
                    end)
                else
                    table.sort(Servers, function(a, b)
                        return a.Players < b.Players
                    end)
                end

                if #Servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, Servers[1].JobId, Plr)
                else
                    Notify({Text = "Couldn't find a server", Duration = 3})
                end
            end
        })

        PrioritizeLowPingServers = ServerHop:CreateToggle({
            Name = "Prioritize Low Ping Servers",
        })
    end)

    Run(function()
        Server:CreateButton({
            Name = "Rejoin",
            Function = function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Plr)
            end
        })
    end)

    Run(function()
        Server:CreateButton({
            Name = "Copy GameId",
            Function = function()
                if not setclipboard then NotifyPoopSploit("setclipboard") return end
                setclipboard(tostring(game.GameId))
                Notify({Text = "Set GameId to clipboard", Duration = 3})
            end
        })
    end)

    Run(function()
        Server:CreateButton({
            Name = "Copy PlaceId",
            Function = function()
                if not setclipboard then NotifyPoopSploit("setclipboard") return end
                setclipboard(tostring(game.PlaceId))
                Notify({Text = "Set PlaceId to clipboard", Duration = 3})
            end
        })
    end)

    Run(function()
        Server:CreateButton({
            Name = "Copy JobId",
            Function = function()
                if not setclipboard then NotifyPoopSploit("setclipboard") return end
                setclipboard(tostring(game.JobId))
                Notify({Text = "Set JobId to clipboard", Duration = 3})
            end
        })
    end)

    Run(function()
        Server:CreateButton({
            Name = "Copy Root Position",
            Function = function()
                if not setclipboard then NotifyPoopSploit("setclipboard") return end
                if not CharacterLib.Alive then return end
                setclipboard(tostring(CharacterLib.Root.Position))
            end
        })
    end)
end)

return nil