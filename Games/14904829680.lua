local CloneRef = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return CloneRef(game:GetService(Service))
end

local Players: Players = GetService("Players")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local RunService: RunService = GetService("RunService")
local UIS: UserInputService = GetService("UserInputService")

local Plr = Players.LocalPlayer

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib
local Modules = TidalWave.Modules

Modules.Speed.Options.Method:SetValue("CFrame")
Modules.Fly.Options.FlyMethod:SetValue("CFrame")

local Combat = Categories.Combat
local Movement = Categories.Movement
local World = Categories.World
local Visuals = Categories.Visuals
local PlayerCategory = Categories.Player
local Other = Categories.Other
local Animations = Categories.Animations

local getsenv = getsenv
local hookfunction = hookfunction
local restorefunction = restorefunction
local setconstant = debug.setconstant or setconstant

local PoopSploit = table.find({"Xeno", "Solara"}, TidalWave.Executor)

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

local function SafeRef(Obj, Ref)
    if not Obj then return nil end
    for i, v in Ref do
        Obj = Obj and Obj:FindFirstChild(v) or nil
        if not Obj then return nil end
    end

    return Obj
end

local function GetKiller()
    for _, Player in Players:GetPlayers() do
        local Killer = SafeRef(Player, {"Backpack", "Scripts", "Killer"})
        if Killer and Killer.Value then
            return Player
        end
    end

    return nil
end

local function FindPlayer(Name: string)
    if typeof(Name) ~= "string" then return end
    Name = Name:lower()
    for _, Player in Players:GetPlayers() do
        if Player == Plr then continue end
        if Player.Name:lower():sub(1, #Name) == Name then
            return Player
        elseif Player.DisplayName:lower():sub(1, #Name) == Name then
            return Player
        end
    end
	return nil
end

local function Run(f)
    f()
end

Run(function() -- Combat
    Run(function() -- KillSurvivors
        Combat:CreateButton({
            Name = "Sacrifice All Survivors",
            Function = function()
                for i, Player in CharacterLib.List do
                    task.spawn(function()
                        local Hook = workspace:FindFirstChild(`Hook{i}`)
                        if not Hook then return end
                        for _ = 1, 3 do
                            ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Hook", "Hook", Player.Character, Hook)
                            task.wait(0.5)
                        end
                    end)
                end
            end,
        })
    end)
end)

Run(function() -- Movement
    Run(function() -- ChainsawModifier
        local HillbillyStats, SprintLimitX, SprintLimitY, SprintSensitivityX, SprintSensitivityY, FlickLimitX, FlickLimitY, FlickSensitivityX, FlickSensitivityY, FlickDuration, ChainsawMovementSpeed, ChargeMovementSpeed, StaggerMovementSpeed, HitRadius, HitRange, CrashRadius, CrashRange, CrashDuration, MissDuration, HitDuration

        local StatsModule

        local PrevStats = {}

        local function GrabStatsModule()
            if not PoopSploit and not StatsModule then
                local GameData = ReplicatedStorage:FindFirstChild("Game_Data")
                local Killers = GameData and GameData:FindFirstChild("Killers")
                local Hillbilly = Killers and Killers:FindFirstChild("Hillbilly")
                if Hillbilly then
                    StatsModule = require(Hillbilly)
                end
                for i, v in pairs(StatsModule) do
                    if typeof(v) == "table" then
                        PrevStats[i] = table.clone(v)
                    else
                        PrevStats[i] = v
                    end
                end
            end
            return StatsModule
        end

        local function UpdateStats()
            if GrabStatsModule() then
                if HillbillyStats.Enabled then
                    StatsModule.Camera.Sprint.Limits = Vector2.new(SprintLimitX.Value, SprintLimitY.Value)
                    StatsModule.Camera.Sprint.Sensitivity = Vector2.new(SprintSensitivityX.Value, SprintSensitivityY.Value)
                    StatsModule.Camera.Flick.Limits = Vector2.new(FlickLimitX.Value, FlickLimitY.Value)
                    StatsModule.Camera.Flick.Sensitivity = Vector2.new(FlickSensitivityX.Value, FlickSensitivityY.Value)
                    StatsModule.Chainsaw_Settings.Flick = FlickDuration.Value
                    StatsModule.Speeds.Sprinting = ChainsawMovementSpeed.Value
                    StatsModule.Speeds.Charging = ChargeMovementSpeed.Value
                    StatsModule.Speeds.Stagger = StaggerMovementSpeed.Value
                    StatsModule.Hitbox.Hit.Radius = HitRadius.Value
                    StatsModule.Hitbox.Hit.Range = HitRange.Value
                    StatsModule.Hitbox.Crash.Radius = CrashRadius.Value
                    StatsModule.Hitbox.Crash.Range = CrashRange.Value
                    StatsModule.Animation_Timing.Crash = CrashDuration.Value
                    StatsModule.Animation_Timing.None = MissDuration.Value
                    StatsModule.Animation_Timing.Hit = HitDuration.Value
                else
                    for i, v in pairs(PrevStats) do
                        StatsModule[i] = v
                    end
                end
            end
        end

        HillbillyStats = Movement:CreateModule({
            Name = "ChainsawModifier",
            Info = "Allows you to change different hillbilly stats like camera turn rate",
            Function = UpdateStats
        })

        SprintLimitX = HillbillyStats:CreateSlider({
            Name = "Sprint Limit X",
            Default = 65,
            Min = 0,
            Max = 650,
            Function = UpdateStats
        })

        SprintLimitY = HillbillyStats:CreateSlider({
            Name = "Sprint Limit Y",
            Default = 35,
            Min = 0,
            Max = 350,
            Function = UpdateStats
        })

        SprintSensitivityX = HillbillyStats:CreateSlider({
            Name = "Sprint Sensitivity X",
            Default = 0.5,
            Min = 0,
            Max = 5,
            Decimal = 100,
            Function = UpdateStats
        })

        SprintSensitivityY = HillbillyStats:CreateSlider({
            Name = "Sprint Sensitivity Y",
            Default = 0.125,
            Min = 0,
            Max = 1.25,
            Decimal = 100,
            Function = UpdateStats
        })

        FlickLimitX = HillbillyStats:CreateSlider({
            Name = "Flick Limit X",
            Default = 65,
            Min = 0,
            Max = 650,
            Function = UpdateStats
        })

        FlickLimitY = HillbillyStats:CreateSlider({
            Name = "Flick Limit Y",
            Default = 35,
            Min = 0,
            Max = 350,
            Function = UpdateStats
        })

        FlickSensitivityX = HillbillyStats:CreateSlider({
            Name = "Flick Sensitivity X",
            Default = 0.5,
            Min = 0,
            Max = 2,
            Decimal = 100,
            Function = UpdateStats
        })

        FlickSensitivityY = HillbillyStats:CreateSlider({
            Name = "Flick Sensitivity Y",
            Default = 0.125,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateStats
        })

        FlickDuration = HillbillyStats:CreateSlider({
            Name = "Flick Duration",
            Default = 0.65,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        ChainsawMovementSpeed = HillbillyStats:CreateSlider({
            Name = "Chainsaw Movement Speed",
            Default = 35,
            Min = 0,
            Max = 100,
            Function = UpdateStats
        })

        ChargeMovementSpeed = HillbillyStats:CreateSlider({
            Name = "Charge Movement Speed",
            Default = 12,
            Min = 0,
            Max = 60,
            Function = UpdateStats
        })

        StaggerMovementSpeed = HillbillyStats:CreateSlider({
            Name = "Stagger Movement Speed",
            Default = 0,
            Min = 0,
            Max = 10,
            Function = UpdateStats
        })

        HitRadius = HillbillyStats:CreateSlider({
            Name = "Hit Radius",
            Default = 0.75,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        HitRange = HillbillyStats:CreateSlider({
            Name = "Hit Range",
            Default = 1,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        CrashRadius = HillbillyStats:CreateSlider({
            Name = "Crash Radius",
            Default = 0.75,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        CrashRange = HillbillyStats:CreateSlider({
            Name = "Crash Range",
            Default = 1,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        CrashDuration = HillbillyStats:CreateSlider({
            Name = "Crash Duration",
            Default = 4,
            Min = 0,
            Max = 8,
            Decimal = 100,
            Function = UpdateStats
        })

        HitDuration = HillbillyStats:CreateSlider({
            Name = "Hit Duration",
            Default = 2,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })

        MissDuration = HillbillyStats:CreateSlider({
            Name = "Miss Duration",
            Default = 1.5,
            Min = 0,
            Max = 3,
            Decimal = 100,
            Function = UpdateStats
        })
    end)

    Run(function() -- FastVaultModifier
        local FastVaultModifier, AllowAnyAngle, SpoofMoveDirection, NoDelay, WindowModule, Old

        local One = Vector3.new(1, 0, 0)

        local function ModVector(Vector)
            return Vector3.new(Vector.X, CharacterLib.Root.Position.Y, Vector.Z)
        end

        local function VaultWindowHook(self, ...)
            if CharacterLib.Alive then
                if AllowAnyAngle.Enabled then
                    local Far = WindowModule.ActionInfo.Ports.Far
                    local Close = WindowModule.ActionInfo.Ports.Close
                    if Far and Close then
                        local Start = ModVector(Close.Position)
                        local Target = ModVector(Far.Position)
                        CharacterLib.Root.CFrame = CFrame.lookAt(Start, Target)
                    end
                end

                if SpoofMoveDirection.Enabled then
                    CharacterLib.Humanoid:Move(One)
                end
            end

            return Old(self, ...)
        end

        FastVaultModifier = Movement:CreateModule({
            Name = "FastVaultModifier",
            Info = "Modifies fast vaults",
            Enabled = function()
                if PoopSploit then NotifyPoopSploit("require") return end
                local Scripts = SafeRef(Plr, {"Backpack", "Scripts"})
                local VaultWindow = Scripts and SafeRef(Scripts, {"GlobalSurvivor", "Action", "VaultWindow"})
                WindowModule = VaultWindow and require(VaultWindow)
                if WindowModule then
                    Old = WindowModule.Start
                    if NoDelay.Enabled then
                        setconstant(Old, 5, 0)
                    end

                    WindowModule.Start = VaultWindowHook

                    FastVaultModifier:Clean(function()
                        if Old then
                            setconstant(Old, 5, 1.5)
                        end
                        WindowModule.Start = Old
                        Old = nil
                    end)
                else
                    Notify({Text = "Failed to find Window Module.\nWindow Modifiers will not work.", Duration = 5, Type = "Error"})
                end

                local Action = SafeRef(Scripts, {"values", "Action"})
                if Action then
                    FastVaultModifier:Clean(Action:GetPropertyChangedSignal("Value"):Connect(function()
                        if not NoDelay.Enabled then return end
                        if Action.Value == "SlidingPallet" then
                            Action.Value = "Nothing"
                        end
                    end))
                else
                    Notify({Text = "Failed to find Action State.\nPallet no delay will not work.", Duration = 5, Type = "Error"})
                end
            end
        })

        AllowAnyAngle = FastVaultModifier:CreateToggle({
            Name = "Allow Any Angle",
            Info = "Allows you to get a fast fault from any angle.",
            Default = true
        })

        SpoofMoveDirection = FastVaultModifier:CreateToggle({
            Name = "Spoof Move Direction",
            Info = "Allows you to get a fast vault while standing still.",
            Default = true
        })

        NoDelay = FastVaultModifier:CreateToggle({
            Name = "No Delay",
            Info = "Removes the 1.5 second cooldown between vaulting windows.",
            Default = true,
            Function = function(Enabled)
                if Old then
                    setconstant(Old, 5, Enabled and 0 or 1.5)
                end
            end
        })
    end)

    Run(function() -- NoPalletSlow
        local NoPalletSlow

        NoPalletSlow = Movement:CreateModule({
            Name = "NoPalletSlow",
            Info = "Stops you from getting locked into place after dropping a pallet",
            Enabled = function()
                local Scripts = SafeRef(Plr, {"Backpack", "Scripts"})
                if PoopSploit then
                    Notify({Text = "Your executor doesn't support 'require'\nThis module may or may not work."})
                    local Values = Scripts and Scripts:FindFirstChild("values")
                    local Action = Values and Values:FindFirstChild("Action")
                    local Con
                    if Action then
                        NoPalletSlow:Clean(Action:GetPropertyChangedSignal("Value"):Connect(function()
                            if Con then
                                Con:Disconnect()
                                Con = nil
                            end
                            if Action.Value == "DroppingPallet" and CharacterLib.Alive and CharacterLib.Root then
                                if CharacterLib.Root.Anchored then
                                    CharacterLib.Root.Anchored = false
                                else
                                    Con = CharacterLib.Root:GetPropertyChangedSignal("Anchored"):Once(function()
                                        CharacterLib.Root.Anchored = false
                                        Con = nil
                                    end)
                                end
                            end
                        end))
                    end
                else
                    local DropPallet = SafeRef(Scripts, {"GlobalSurvivor", "Action", "DropPallet"})
                    local Module = DropPallet and require(DropPallet)
                    local Con
                    if Module then
                        local OldStart = Module.Start
                        Module.Start = function(self, ...)
                            if Con then
                                Con:Disconnect()
                                Con = nil
                            end
                            Con = CharacterLib.Alive and CharacterLib.Root:GetPropertyChangedSignal("Anchored"):Once(function()
                                CharacterLib.Root.Anchored = false
                                Con = nil
                            end)
                            local Result = OldStart(self, ...)
                            if Con then
                                Con:Disconnect()
                                Con = nil
                            end
                            return Result
                        end
                        NoPalletSlow:Clean(function()
                            Module.Start = OldStart
                        end)
                    end
                end
            end
        })
    end)

    Run(function() -- NoStagger
        local NoStagger, Old

        local function CharacterAdded(Char)
            Char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            NoStagger:Clean(Char.Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
                if Char.Humanoid.FloorMaterial ~= Enum.Material.Air then
                    Char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end))
        end

        NoStagger = Movement:CreateModule({
            Name = "NoStagger",
            Info = "Removes the stagger after falling from a height",
            Enabled = function()
                NoStagger:Clean(CharacterLib.Events.LocalAdded:Connect(CharacterAdded))
                if CharacterLib.Alive then
                    CharacterAdded(CharacterLib)
                end
            end
        })
    end)

    Run(function() -- VaultSpeed
        local VaultSpeed, Speed, Percentage, UsePercentage

        local function UpdateWindowVaultSpeed()
            local PlayerValues = Plr:FindFirstChild("PlayerValues")
            if PlayerValues and VaultSpeed.Enabled then
                if UsePercentage.Enabled then
                    PlayerValues:SetAttribute("WindowVaultSpeed", math.max(PlayerValues:GetAttribute("WindowVaultSpeed"), 1) * (Percentage.Value / 100))
                else
                    PlayerValues:SetAttribute("WindowVaultSpeed", Speed.Value)
                end
            end
        end

        VaultSpeed = Movement:CreateModule({
            Name = "Vault Speed",
            Info = "The speed at which you vault windows. Doesn't effect pallet vault speed.",
            Enabled = function()
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if not PlayerValues then return end
                UpdateWindowVaultSpeed()
                VaultSpeed:Clean(PlayerValues:GetAttributeChangedSignal("WindowVaultSpeed"):Connect(UpdateWindowVaultSpeed))
            end,
        })

        Speed = VaultSpeed:CreateSlider({
            Name = "Window Vault Speed",
            Default = 1,
            Min = 0,
            Max = 5,
            Function = UpdateWindowVaultSpeed
        })

        VaultSpeed:CreateToggle({
            Name = "Use Percentage",
            Function = function(Enabled)
                Percentage:SetVisible(Enabled)
                UpdateWindowVaultSpeed()
            end
        })

        Percentage = VaultSpeed:CreateSlider({
            Name = "Percentage",
            Default = 110,
            Min = 0,
            Max = 200,
            Suffix = "%",
            Function = UpdateWindowVaultSpeed
        })
    end)
end)

Run(function() -- World
    Run(function() -- RepairGenerators
        World:CreateModule({
            Name = "RepairGenerators",
            Info = "Starts repairing all generators at once",
            Function = function(Enabled)
                local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local NewProperty = RemoteEvents:FindFirstChild("NewPropertie")
                if not NewProperty then Notify({Text = "Failed to find event"}) return end
                for i, Generator in workspace:GetChildren() do
                    if Generator.Name:find("Generator") then
                        for _, Workspot in Generator.Workspots:GetChildren() do
                            local Arg = {C21 = Workspot.Ocuped, C20 = Enabled, C22 = "B101"}
                            local Args = {D9v8 = Arg, Bbh1O = Arg, Dvh1O = Arg, Dbh1O = Arg, Dhv8 = Arg}
                            local Arg2 = {C21 = Workspot.Ocupant, C20 = Enabled and Plr.Name or "Nobody", C22 = "S101"}
                            local Args2 = {D9v8 = Arg2, Bbh1O = Arg2, Dvh1O = Arg2, Dbh1O = Arg2, Dhv8 = Arg2}
                            NewProperty:FireServer(Args)
                            NewProperty:FireServer(Args2)
                        end
                    end
                end
            end
        })
    end)

    Run(function() -- AntiTrap
        local AntiTrap

        local function EnableTrap(Trap, Bool)
            if not AntiTrap.Enabled then return end
            if Trap.Name:sub(1, 4) == "Trap" then
                local Hitbox = Trap:FindFirstChild("Hitbox")
                if Hitbox and Hitbox:IsA("BasePart") then
                    Hitbox.CanTouch = Bool
                    if not Bool then
                        AntiTrap:Clean(Hitbox:GetPropertyChangedSignal("CanTouch"):Connect(function()
                            Hitbox.CanTouch = false
                        end))
                    end
                end
            end
        end

        AntiTrap = World:CreateModule({
            Name = "AntiTrap",
            Info = "Disables the collision of traps",
            Function = function(Enabled)
                if Enabled then
                    for i, v in workspace:GetChildren() do
                        EnableTrap(v, false)
                    end
                    AntiTrap:Clean(workspace.ChildAdded:Connect(function(Child)
                        if Child.Name:sub(1, 4) == "Trap" then
                            if Child:WaitForChild("Hitbox", 5) then
                                EnableTrap(Child, false)
                            end
                        end
                    end))
                else
                    for i, v in workspace:GetChildren() do
                        EnableTrap(v, true)
                    end
                end
            end,
        })
    end)

    Run(function() -- Play All Sounds
        World:CreateButton({
            Name = "Play All Sounds",
            Info = "Plays every sound in workspace.",
            Function = function()
                local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local ObjectAppUpdater = RemoteEvents and RemoteEvents:FindFirstChild("ObjectAppUpdater")
                if not ObjectAppUpdater then return end
                for _, v in workspace:QueryDescendants("Sound") do
                    ObjectAppUpdater:FireServer(v, "Playing", true)
                end
            end
        })
    end)

    Run(function() -- DestroyPallets
        World:CreateButton({
            Name = "Destroy Pallets",
            Function = function()
                for _, v in workspace:GetChildren() do
                    if v.Name:find("Pallet") then
                        ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Pallet", "Killer_Kick", v)
                    end
                end
            end,
        })
    end)

    Run(function() -- DestroyWalls
        World:CreateButton({
            Name = "Destroy Walls",
            Function = function()
                for _, v in workspace:GetChildren() do
                    if v.Name:find("BreakableWall") then
                        ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Wall", "Killer_Kick", v)
                    end
                end
            end,
        })
    end)

    Run(function() -- KickGenerators
        World:CreateButton({
            Name = "Kick Generators",
            Function = function()
                for _, v in workspace:GetChildren() do
                    if v.Name:find("Generator") then
                        ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Generator", "Killer_Kick", v, v.Workspots.Front)
                    end
                end
            end,
        })
    end)

    Run(function() -- Unlock Hatch
        World:CreateButton({
            Name = "Unlock Hatch",
            Function = function()
                ReplicatedStorage.RemoteEvents.HatchAction:FireServer("Unlock")
            end,
        })
    end)

    Run(function() -- Escape From Hatch
        World:CreateButton({
            Name = "Escape From Hatch",
            Function = function()
                ReplicatedStorage.RemoteEvents.HatchAction:FireServer("Use")
            end,
        })
    end)

    Run(function() -- Close Hatch
        World:CreateButton({
            Name = "Close Hatch",
            Function = function()
                ReplicatedStorage.RemoteEvents.HatchAction:FireServer("Start_Close")
                task.wait(1)
                ReplicatedStorage.RemoteEvents.HatchAction:FireServer("Close")
            end,
        })
    end)

    Run(function() -- Open Gates
        World:CreateButton({
            Name = "Open Gates",
            Function = function()
                local Gate1 = workspace:FindFirstChild("ExitGate1")
                local Gate1Panel = Gate1 and Gate1:FindFirstChild("Panel")
                local Gate1Remote = Gate1Panel and Gate1Panel:FindFirstChild("Exit_Gate")
                local Gate2 = workspace:FindFirstChild("ExitGate2")
                local Gate2Panel = Gate2 and Gate2:FindFirstChild("Panel")
                local Gate2Remote = Gate2Panel and Gate2Panel:FindFirstChild("Exit_Gate")
                if Gate1Remote then
                    Gate1Remote:FireServer("KillerOpen")
                end
                if Gate2Remote then
                    Gate2Remote:FireServer("KillerOpen")
                end
            end
        })
    end)
end)

Run(function() -- Visuals
    Run(function() -- GeneratorESP
        local GeneratorESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Folder

        GeneratorESP = Visuals:CreateModule({
            Name = "GeneratorESP",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "GeneratorESP"
                    Folder.Parent = TidalWave.Gui

                    for i, v in workspace:GetChildren() do
                        if v.Name:find("Generator") then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Adornee = v
                            Highlight.OutlineColor = OutlineColor.Color
                            Highlight.FillColor = FillColor.Color
                            Highlight.OutlineTransparency = OutlineTransparency.Value
                            Highlight.FillTransparency = FillTransparency.Value
                            Highlight.Name = `GeneratorESP_{v.Name:match("%d") or i}`
                            Highlight.Parent = Folder
                        end
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                end
            end,
        })

        local function UpdateGeneratorESP()
            if not GeneratorESP.Enabled then return end
            for i, v in Folder:GetChildren() do
                v.OutlineColor = OutlineColor.Color
                v.FillColor = FillColor.Color
                v.OutlineTransparency = OutlineTransparency.Value
                v.FillTransparency = FillTransparency.Value
            end
        end

        OutlineColor = GeneratorESP:CreateColorPicker({
            Name = "Outline Color",
            Default = Color3.fromRGB(255, 0, 0),
            Function = UpdateGeneratorESP
        })

        FillColor = GeneratorESP:CreateColorPicker({
            Name = "Fill Color",
            Default = Color3.fromRGB(255, 0, 0),
            Function = UpdateGeneratorESP
        })

        OutlineTransparency = GeneratorESP:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateGeneratorESP
        })

        FillTransparency = GeneratorESP:CreateSlider({
            Name = "Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateGeneratorESP
        })
    end)

    Run(function() -- WindowESP
        local WindowESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Folder

        WindowESP = Visuals:CreateModule({
            Name = "WindowESP",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "WindowESP"
                    Folder.Parent = TidalWave.Gui

                    for i, v in workspace:GetChildren() do
                        if v.Name:find("Window") then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Adornee = v
                            Highlight.OutlineColor = OutlineColor.Color
                            Highlight.FillColor = FillColor.Color
                            Highlight.OutlineTransparency = OutlineTransparency.Value
                            Highlight.FillTransparency = FillTransparency.Value
                            Highlight.Name = `WindowESP_{v.Name:match("%d") or i}`
                            Highlight.Parent = Folder
                        end
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                end
            end,
        })

        local function UpdateWindowESP()
            if not WindowESP.Enabled then return end
            for i, v in Folder:GetChildren() do
                v.OutlineColor = OutlineColor.Color
                v.FillColor = FillColor.Color
                v.OutlineTransparency = OutlineTransparency.Value
                v.FillTransparency = FillTransparency.Value
            end
        end

        OutlineColor = WindowESP:CreateColorPicker({
            Name = "Outline Color",
            Default = Color3.fromRGB(255, 255, 0),
            Function = UpdateWindowESP
        })

        FillColor = WindowESP:CreateColorPicker({
            Name = "Fill Color",
            Default = Color3.fromRGB(255, 255, 0),
            Function = UpdateWindowESP
        })

        OutlineTransparency = WindowESP:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateWindowESP,
        })

        FillTransparency = WindowESP:CreateSlider({
            Name = "Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateWindowESP,
        })
    end)

    Run(function() -- PalletESP
        local PalletESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Folder

        PalletESP = Visuals:CreateModule({
            Name = "PalletESP",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "PalletESP"
                    Folder.Parent = TidalWave.Gui
                    for i, v in workspace:GetChildren() do
                        if v.Name:find("Pallet") then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Adornee = v
                            Highlight.OutlineColor = OutlineColor.Color
                            Highlight.FillColor = FillColor.Color
                            Highlight.OutlineTransparency = OutlineTransparency.Value
                            Highlight.FillTransparency = FillTransparency.Value
                            Highlight.Name = `PalletESP_{v.Name:match("%d") or i}`
                            Highlight.Parent = Folder
                        end
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                end
            end,
        })

        local function UpdatePalletESP()
            if not PalletESP.Enabled then return end
            for i, v in Folder:GetChildren() do
                v.OutlineColor = OutlineColor.Color
                v.FillColor = FillColor.Color
                v.OutlineTransparency = OutlineTransparency.Value
                v.FillTransparency = FillTransparency.Value
            end
        end

        OutlineColor = PalletESP:CreateColorPicker({
            Name = "Outline Color",
            Default = Color3.fromRGB(255, 255, 0),
            Function = UpdatePalletESP
        })

        FillColor = PalletESP:CreateColorPicker({
            Name = "Fill Color",
            Default = Color3.fromRGB(255, 255, 0),
            Function = UpdatePalletESP
        })

        OutlineTransparency = PalletESP:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdatePalletESP
        })

        FillTransparency = PalletESP:CreateSlider({
            Name = "Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdatePalletESP
        })
    end)

    Run(function() -- TrapESP
        local TrapESP, ArmedOutlineColor, ArmedFillColor, DisarmedOutlineColor, DisarmedFillColor, OutlineTransparency, FillTransparency, Folder

        local function EspTrap(Trap)
            local Panel = Trap:WaitForChild("Panel", 5)
            local State = Panel and Panel:WaitForChild("State", 5)
            local Highlight = Instance.new("Highlight")
            Highlight.Adornee = Trap
            Highlight.Name = `TrapESP_{Trap.Name:match("%d")}`
            Highlight.OutlineTransparency = OutlineTransparency.Value
            Highlight.FillTransparency = FillTransparency.Value
            if State and State.Value == "Armed" then
                Highlight.OutlineColor = ArmedOutlineColor.Color
                Highlight.FillColor = ArmedFillColor.Color
            else
                Highlight.OutlineColor = DisarmedOutlineColor.Color
                Highlight.FillColor = DisarmedFillColor.Color
            end
            Highlight.Parent = Folder
            TrapESP:Clean(State:GetPropertyChangedSignal("Value"):Connect(function()
                if State.Value == "Armed" then
                    Highlight.OutlineColor = ArmedOutlineColor.Color
                    Highlight.FillColor = ArmedFillColor.Color
                else
                    Highlight.OutlineColor = DisarmedOutlineColor
                    Highlight.FillColor = DisarmedFillColor
                end
            end))
        end

        TrapESP = Visuals:CreateModule({
            Name = "Trap ESP",
            Info = "Highlights traps.",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "TrapESP"
                    Folder.Parent = TidalWave.Gui

                    for _, v in workspace:GetChildren() do
                        if v.Name:sub(1, 4) == "Trap" then
                            task.spawn(EspTrap, v)
                        end
                    end
                    TrapESP:Clean(workspace.ChildAdded:Connect(function(Child)
                        if Child.Name:sub(1, 4) == "Trap" then
                            EspTrap(Child)
                        end
                    end))
                    TrapESP:Clean(workspace.ChildRemoved:Connect(function(Child)
                        if Child.Name:sub(1, 4) == "Trap" then
                            local Highlight = Folder:FindFirstChild(Child.Name)
                            if Highlight then
                                Highlight:Destroy()
                            end
                        end
                    end))
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                end
            end,
        })

        local function UpdateTrapEspColors()
            if not TrapESP.Enabled then return end
            for i, v in Folder:GetChildren() do
                if v.Adornee then
                    local Panel = v.Adornee:FindFirstChild("Panel")
                    local State = Panel and Panel:FindFirstChild("State")
                    if State and State.Value == "Armed" then
                        v.OutlineColor = ArmedOutlineColor.Color
                        v.FillColor = ArmedFillColor.Color
                    else
                        v.OutlineColor = DisarmedOutlineColor.Color
                        v.FillColor = DisarmedFillColor.Color
                    end
                    v.OutlineTransparency = OutlineTransparency.Value
                    v.FillTransparency = FillTransparency.Value
                end
            end
        end

        ArmedOutlineColor = TrapESP:CreateColorPicker({
            Name = "Armed Outline Color",
            Default = Color3.fromRGB(255, 0, 0),
            Function = UpdateTrapEspColors
        })

        ArmedFillColor = TrapESP:CreateColorPicker({
            Name = "Armed Fill Color",
            Default = Color3.fromRGB(255, 0, 0),
            Function = UpdateTrapEspColors
        })

        DisarmedOutlineColor = TrapESP:CreateColorPicker({
            Name = "Disarmed Outline Color",
            Default = Color3.fromRGB(0, 255, 0),
            Function = UpdateTrapEspColors
        })

        DisarmedFillColor = TrapESP:CreateColorPicker({
            Name = "Disarmed Fill Color",
            Default = Color3.fromRGB(0, 255, 0),
            Function = UpdateTrapEspColors
        })

        OutlineTransparency = TrapESP:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateTrapEspColors
        })

        FillTransparency = TrapESP:CreateSlider({
            Name = "Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = UpdateTrapEspColors
        })
    end)
end)

Run(function() -- Player
    Run(function() -- InfiniteDecisiveStrike
        local InfiniteDecisiveStrike

        local function OnHeld(Held)
            if Held and Held.Value then
                Notify({Text = "Decisive Strike has been activated"})
                local Killer = GetKiller()
                repeat
                    for _ = 1, 10 do
                        ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Wiggle", Killer)
                    end
                    task.wait()
                until not Held.Value or not InfiniteDecisiveStrike.Enabled
            end
        end
        
        InfiniteDecisiveStrike = PlayerCategory:CreateModule({
            Name = "InfiniteDecisiveStrike",
            Info = "Instantly escapes the killer grasp when picked up",
            Enabled = function()
                local Held = SafeRef(Plr, {"Backpack", "Scripts", "values", "Holded"})
                if not Held then
                    local TimeOut = os.clock() + 5
                    repeat
                        Held = SafeRef(Plr, {"Backpack", "Scripts", "values", "Holded"})
                    until Held or os.clock() >= TimeOut or not InfiniteDecisiveStrike.Enabled
                end
                if Held and InfiniteDecisiveStrike.Enabled then
                    InfiniteDecisiveStrike:Clean(Held:GetPropertyChangedSignal("Value"):Connect(function()
                        OnHeld(Held)
                    end))
                    OnHeld(Held)
                end
            end,
        })
    end)

    Run(function() -- AutoDeadHard
        local AutoDeadHard, UseWhenDowned, DeadHardConnection

        AutoDeadHard = PlayerCategory:CreateModule({
            Name = "Auto Dead Hard",
            Info = "Automatically uses dead hard after you get hit",
            Enabled = function()
                if UseWhenDowned.Enabled and CharacterLib.Alive then
                    AutoDeadHard:Clean(CharacterLib.Root:GetAttributeChangedSignal("Blood"):Connect(function()
                        ReplicatedStorage.RemoteEvents.Perk_Event:FireServer("Dodge")
                    end))
                else
                    local Backpack = Plr:FindFirstChildOfClass("Backpack")
                    local Scripts = Backpack and Backpack:FindFirstChild("Scripts")
                    local Values = Scripts and Scripts:FindFirstChild("values")
                    local HealthState = Values and Values:FindFirstChild("HealthState")
                    AutoDeadHard:Clean(HealthState:GetPropertyChangedSignal("Value"):Connect(function()
                        ReplicatedStorage.RemoteEvents.Perk_Event:FireServer("Dodge")
                    end))
                end
            end
        })

        UseWhenDowned = AutoDeadHard:CreateToggle({
            Name = "Use While Downed",
            Info = "Allows dead hard to be used while downed. When used while downed you instantly recover from the dying state.",
            Function = function()
                if AutoDeadHard.Enabled then
                    AutoDeadHard:Toggle(true)
                    AutoDeadHard:Toggle(true)
                end
            end
        })
    end)

    Run(function() -- InfiniteUnbreakable
        local InfiniteUnbreakable

        InfiniteUnbreakable = PlayerCategory:CreateModule({
            Name = "Infinite Unbreakable",
            Info = "Allows you to fully recover from the dying state",
            Function = function(Enabled)
                if Enabled then
                    local Backpack = Plr:FindFirstChildOfClass("Backpack")
                    local Scripts = Backpack and Backpack:FindFirstChild("Scripts")
                    local Values = Scripts and Scripts:FindFirstChild("values")
                    local Recovering = Values and Values:FindFirstChild("Recovering")
                    if Recovering then
                        InfiniteUnbreakable:Clean(Recovering:GetPropertyChangedSignal("Value"):Connect(function()
                            local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                            local ClientToServer = RemoteEvents and RemoteEvents:FindFirstChild("ClientToServer")
                            local HealingEvent = ClientToServer and ClientToServer:FindFirstChild("HealingEvent")
                            if HealingEvent then
                                HealingEvent:FireServer(Plr.Name,  "Start", {
                                    IsMending = false,
                                    SelfHealing = true,
                                    RestrictValues = false,
                                    SumKeys = {
                                        "SelfCare",
                                    },
                                })
                                local HealProgress = Values and Values:FindFirstChild("HealProgress")
                                local PlayerGui = Plr:FindFirstChildOfClass("PlayerGui")
                                local Hud = PlayerGui and PlayerGui:FindFirstChild("HUD")
                                local ControlsDisplay = Hud and Hud:FindFirstChild("Controls_Display")
                                local ProgressInfo = ControlsDisplay and ControlsDisplay:FindFirstChild("Progress_Info")
                                local ProgressHolder = ProgressInfo and ProgressInfo:FindFirstChild("Progress_Holder")
                                local ProgressBackground = ProgressHolder and ProgressHolder:FindFirstChild("Progress")
                                local ProgressBar = ProgressBackground and ProgressBackground:FindFirstChild("Bar")
                                local ActionText = ProgressInfo and ProgressInfo:FindFirstChild("ActionText")

                                while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                    if InfiniteUnbreakable.Disabled then break end
                                    RunService.RenderStepped:Wait()
                                    if ProgressInfo and ActionText and ProgressBar then
                                        ProgressInfo.Visible = true
                                        ActionText.Text = "Recovering"
                                        ProgressBar.Size = UDim2.fromScale(HealProgress.Value / 1000, 1)
                                    end
                                end

                                ProgressInfo.Visible = false
                                HealingEvent:FireServer(Plr.Name, "Stop")
                            end
                        end))
                    end
                else
                    local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    local ClientToServer = RemoteEvents and RemoteEvents:FindFirstChild("ClientToServer")
                    local HealingEvent = ClientToServer and ClientToServer:FindFirstChild("HealingEvent")
                    if HealingEvent then
                        HealingEvent:FireServer(Plr.Name, "Stop")
                    end
                end
            end,
        })
    end)

    Run(function() -- SelfCare
        local SelfCare, BypassHealRestrictions

        SelfCare = PlayerCategory:CreateModule({
            Name = "SelfCare",
            Info = "Allows you to heal yourself\nClick while holding LeftControl to heal",
            Function = function(Enabled)
                if Enabled then
                    SelfCare:Clean(UIS.InputBegan:Connect(function(Input)
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if not CharacterLib.Alive then return end
                            local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                            local ClientToServer = RemoteEvents and RemoteEvents:FindFirstChild("ClientToServer")
                            local HealingEvent = ClientToServer and ClientToServer:FindFirstChild("HealingEvent")
                            if HealingEvent then
                                HealingEvent:FireServer(Plr.Name, "Start", {
                                    IsMending = false,
                                    SelfHealing = true,
                                    RestrictValues = BypassHealRestrictions.Disabled,
                                    SumKeys = {
                                        "SelfCare",
                                    },
                                })
                                local Backpack = Plr:FindFirstChildOfClass("Backpack")
                                local PlayerGui = Plr:FindFirstChildOfClass("PlayerGui")
                                local Scripts = Backpack and Backpack:FindFirstChild("Scripts")
                                local Values = Scripts and Scripts:FindFirstChild("values")
                                local HealProgress = Values and Values:FindFirstChild("HealProgress")
                                local Hud = PlayerGui and PlayerGui:FindFirstChild("HUD")
                                local ControlsDisplay = Hud and Hud:FindFirstChild("Controls_Display")
                                local ProgressInfo = ControlsDisplay and ControlsDisplay:FindFirstChild("Progress_Info")
                                local ProgressHolder = ProgressInfo and ProgressInfo:FindFirstChild("Progress_Holder")
                                local ProgressBackground = ProgressHolder and ProgressHolder:FindFirstChild("Progress")
                                local ProgressBar = ProgressBackground and ProgressBackground:FindFirstChild("Bar")
                                local ActionText = ProgressInfo and ProgressInfo:FindFirstChild("ActionText")
                                local Animator: Animator = CharacterLib.Humanoid:FindFirstChildOfClass("Animator") or CharacterLib.Humanoid

                                local Animation = Instance.new("Animation")
                                Animation.AnimationId = "rbxassetid://102741425499863"

                                local Track = Animator:LoadAnimation(Animation)
                                Track.Priority =  Enum.AnimationPriority.Action4
                                Track.Looped = true
                                Track:Play()

                                while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                    if SelfCare.Disabled then break end
                                    RunService.RenderStepped:Wait()
                                    if ProgressInfo and ActionText and ProgressBar then
                                        ProgressInfo.Visible = true
                                        ActionText.Text = "Healing"
                                        ProgressBar.Size = UDim2.fromScale(HealProgress.Value / 1000, 1)
                                    end
                                end

                                Track:Stop()

                                ProgressInfo.Visible = false

                                HealingEvent:FireServer(Plr.Name, "Stop")
                            end
                        end
                    end))
                else
                    local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    local ClientToServer = RemoteEvents and RemoteEvents:FindFirstChild("ClientToServer")
                    local HealingEvent = ClientToServer and ClientToServer:FindFirstChild("HealingEvent")
                    if HealingEvent then
                        HealingEvent:FireServer(Plr.Name, "Stop")
                    end
                end
            end
        })

        BypassHealRestrictions = SelfCare:CreateToggle({
            Name = "Bypass Heal Restrictions",
            Info = "Bypasses the self care 70% heal speed cap",
            Default = true
        })
    end)
    
    Run(function() -- InfiniteBlinks
        PlayerCategory:CreateModule({
            Name = "InfiniteBlinks",
            Function = function(Enabled)
                if not CharacterLib.Alive then return end
                local Blink = CharacterLib.Character:FindFirstChild("Blink")
                local PowerValues = Blink and Blink:FindFirstChild("PowerValues")
                local PowerRemote = PowerValues and PowerValues:FindFirstChild("PowerRemote")
                if PowerRemote then
                    PowerRemote:FireServer("SetValue", "Blinks", Enabled and 69420 or 2)
                else
                    Notify({
                        Text = "Failed to set blinks"
                    })
                end
            end,
        })
    end)

    Run(function() -- LungeDuration
        local ToggleLungeDuration, LungeDuration

        local function UpdateLungeDuration()
            local PlayerValues = Plr:FindFirstChild("PlayerValues")
            if PlayerValues and ToggleLungeDuration.Enabled then
                PlayerValues:SetAttribute("LungeDuration", LungeDuration.Value)
            end
        end

        ToggleLungeDuration = PlayerCategory:CreateModule({
            Name = "LungeDuration",
            Info = "Changes the duration of your lunge\nDefault is 0.5",
            Enabled = function()
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if PlayerValues then
                    UpdateLungeDuration()
                    ToggleLungeDuration:Clean(PlayerValues:GetAttributeChangedSignal("LungeDuration"):Connect(UpdateLungeDuration))
                end
            end,
        })

        LungeDuration = ToggleLungeDuration:CreateSlider({
            Name = "Lunge Duration",
            Default = 0.5,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Function = UpdateLungeDuration,
        })
    end)

    Run(function() -- LungeSpeed
        local ToggleLungeSpeed, LungeSpeed

        local function UpdateLungeSpeed()
            local PlayerValues = Plr:FindFirstChild("PlayerValues")
            if PlayerValues and ToggleLungeSpeed.Enabled then
                PlayerValues:SetAttribute("LungeSpeed", LungeSpeed.Value)
            end
        end

        ToggleLungeSpeed = PlayerCategory:CreateModule({
            Name = "Lunge Speed",
            Info = "Changes the speed of your lunge\nDefault is 30",
            Enabled = function()
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if PlayerValues then
                    UpdateLungeSpeed()
                    ToggleLungeSpeed:Clean(PlayerValues:GetAttributeChangedSignal("LungeSpeed"):Connect(UpdateLungeSpeed))
                end
            end,
        })

        LungeSpeed = ToggleLungeSpeed:CreateSlider({
            Name = "Lunge Speed",
            Default = 30,
            Min = 0,
            Max = 300,
            Function = UpdateLungeSpeed
        })
    end)

    Run(function() -- MissCooldown
        local ToggleMissCooldown, MissCooldown

        local function UpdateMissCooldown()
            local PlayerValues = Plr:FindFirstChild("PlayerValues")
            if PlayerValues and ToggleMissCooldown.Enabled then
                PlayerValues:SetAttribute("MissCooldown", MissCooldown.Value)
            end
        end

        ToggleMissCooldown = PlayerCategory:CreateModule({
            Name = "Miss Cooldown",
            Info = "Changes the cooldown of missed hits\nDefault is 1.5",
            Enabled = function()
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if PlayerValues then
                    UpdateMissCooldown()
                    ToggleMissCooldown:Clean(PlayerValues:GetAttributeChangedSignal("MissCooldown"):Connect(UpdateMissCooldown))
                end
            end,
        })

        MissCooldown = ToggleMissCooldown:CreateSlider({
            Name = "Miss Cooldown",
            Default = 1.5,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Function = UpdateMissCooldown
        })
    end)

    Run(function() -- WipeSpeed
        local ToggleWipeSpeed, WipeSpeed

        local function UpdateWipeSpeed()
            if ToggleWipeSpeed.Enabled then
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if not PlayerValues then return end
                PlayerValues:SetAttribute("WipeSpeed", WipeSpeed.Value)
            end
        end

        ToggleWipeSpeed = PlayerCategory:CreateModule({
            Name = "Wipe Speed",
            Info = "Multiplies the speed that you wipe your weapon after hitting someone",
            Enabled = function()
                local PlayerValues = Plr:FindFirstChild("PlayerValues")
                if PlayerValues then
                    UpdateWipeSpeed()
                    ToggleWipeSpeed:Clean(PlayerValues:GetAttributeChangedSignal("WipeSpeed"):Connect(UpdateWipeSpeed))
                end
            end,
        })

        WipeSpeed = ToggleWipeSpeed:CreateSlider({
            Name = "Wipe Speed",
            Default = 1,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Suffix = "x",
            Function = UpdateWipeSpeed,
        })
    end)
end)

Run(function() -- Other
    Run(function() -- AutoSkillCheck
        local AutoSkillCheck, Old

        AutoSkillCheck = Other:CreateModule({
            Name = "AutoSkillCheck",
            Info = "Automatically hits great skill checks.",
            Enabled = function()
                local SkillCheck = require(ReplicatedStorage.Modules.SkillCheck)
                Old = SkillCheck.Hit
                SkillCheck.Hit = function(self)
                    local Sound = Instance.new("Sound")
                    Sound.SoundId = "rbxassetid://1479888663"
                    Sound.Volume = 1
                    Sound.PlayOnRemove = true
                    Sound.Parent = workspace
                    Sound:Destroy()
                    self.Run = false
                    return "Great"
                end
                AutoSkillCheck:Clean(function()
                    if Old then
                        SkillCheck.Hit = Old
                        Old = nil
                    end
                end)
            end,
        })
    end)
    Run(function() -- NoDeadHardLimit
        local NoDeadHardLimit

        NoDeadHardLimit = Other:CreateModule({
            Name = "NoDeadHardLimit",
            Info = "Removes the limit of using dead hard 3 times per match",
            Function = function(Enabled)
                if CharacterLib.Alive then
                    CharacterLib.Character:SetAttribute("DodgeUses", Enabled and 69420 or 3)
                else
                    Notify({Text = "Failed to set"})
                end
            end
        })
    end)

    Run(function() -- AntiBlink
        Combat:CreateModule({
            Name = "AntiBlink",
            Info = "Removes the ability for the nurse to blink",
            Function = function(Enabled)
                local Killer = GetKiller()
                local Character = Killer and Killer.Character
                local Blink = Character and Character.Character:FindFirstChild("Blink")
                local PowerValues = Blink and Blink:FindFirstChild("PowerValues")
                local PowerRemote = PowerValues and PowerValues:FindFirstChild("PowerRemote")
                if PowerRemote then
                    PowerRemote:FireServer("SetValue", "Blinks", Enabled and -69420 or 2)
                    if Enabled then
                        Notify({Text = "Set blinks to -69420\n(they probably won't be blinking anytime soon)"})
                    end
                end
            end
        })
    end)

    Run(function() -- GiveTrap
        local GiveTrap, Con

        GiveTrap = Other:CreateModule({
            Name = "GiveTraps",
            Info = "Gives you traps until disabled",
            Function = function(Enabled)
                if Con then
                    Con:Disconnect()
                    Con = nil
                end
                local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local ServerEvent = RemoteEvents and RemoteEvents:FindFirstChild("Server_Event")
                while GiveTrap.Enabled do
                    ServerEvent:FireServer("Trap", "Grab")
                    task.wait(0.75)
                end
                ServerEvent:FireServer("Trap", "Place", true, CFrame.new(0, 0, 0))
                Con = workspace.ChildAdded:Connect(function(Child)
                    if Child.Name:sub(1, 4) == "Trap" then
                        ServerEvent:FireServer("Trap", "Grab", Child)
                        Con:Disconnect()
                        Con = nil
                    end
                end)
                task.wait(5)
                if Con then
                    Con:Disconnect()
                    Con = nil
                end
            end
        })
    end)

    Run(function() -- ServerSideDestroy
        local Object, ServerSideDestroy
        
        ServerSideDestroy = Other:CreateButton({
            Name = "ServerSideDestroy",
            Info = "Allows you to destroy any instance you want\nYou must be playing as trapper for this to work",
            Function = function()
                if Object and Object.Parent then
                    local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    local ServerEvent = RemoteEvents and RemoteEvents:FindFirstChild("Server_Event")
                    if ServerEvent then
                        ServerEvent:FireServer("Trap", "Grab", Object)
                        Notify({Text = `Destroyed Object: {Object:GetFullName()}`})
                    else
                        Notify({Text = "Failed to find event"})
                    end
                else
                    Notify({Text = "Select an instance first"})
                end
            end
        })

        local ObjectPathTextBox; ObjectPathTextBox = ServerSideDestroy:CreateTextBox({
            Name = "Object",
            PlaceholderText = "[Object Path]"
        })
        ObjectPathTextBox.Object.TextBox.FocusLost:Connect(function()
            local f = loadstring(`return {ObjectPathTextBox.Object.TextBox.Text}`)
            if typeof(f) == "function" then
                Object = f()
                Notify({Text = `Set instance path to {Object:GetFullName()}`})
            else
                Notify({Text = f})
            end
        end)
    end)

    Run(function() -- PingSpoofer
        local Ping, PingSpoofer, Old

        PingSpoofer = Other:CreateModule({
            Name = "PingSpoofer",
            Info = "Spoofs your ping in the dead by roblox's tab",
            Function = function()
                local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                local PingRemote = RemoteEvents and RemoteEvents:FindFirstChild("PingTimes")
                if PingRemote then
                    Old = PingRemote.OnClientInvoke
                    PingRemote.OnClientInvoke = function()
                        return Ping.Value / 2000
                    end
                end
                PingSpoofer:Clean(function()
                    PingRemote.OnClientInvoke = Old
                    Old = nil
                end)
            end
        })

        Ping = PingSpoofer:CreateSlider({
            Name = "Ping",
            Default = 50,
            Min = 0,
            Max = 200,
        })
    end)

    Run(function() -- SetNurseBlinks
        local SetNurseBlinks, Blinks

        local function UpdateBlinks()
            local Killer = GetKiller()
            local PowerRemote = Killer and SafeRef(Killer.Character, {"Blink", "PowerValues", "PowerRemote"})
            if PowerRemote then
                PowerRemote:FireServer("SetValue", "Blinks", math.floor(Blinks.Value))
            elseif Killer then
                Notify({Text = "The killer isn't currently playing nurse.", Duration = 5, Type = "Warning"})
            end
        end

        SetNurseBlinks = Other:CreateModule({
            Name = "NurseBlinks",
            Info = "Sets the blinks of the nurse. Doesn't matter if you're the killer or not.",
            Enabled = function()
                repeat
                    UpdateBlinks()
                    task.wait(0.2)
                until not SetNurseBlinks.Enabled
            end
        })

        Blinks = SetNurseBlinks:CreateSlider({
            Name = "Blinks",
            Default = 2,
            Min = 0,
            Max = 10,
            Function = UpdateBlinks
        })
    end)
    
    Run(function() -- AntiBamboozle
        local AntiBamboozle

        local function WindowAdded(Window)
            local Panel = Window:WaitForChild("Panel", 5)
            local Blocked = Panel and Panel:WaitForChild("shadowvault", 5)
            if AntiBamboozle.Enabled and Blocked then
                Blocked.Value = false
                AntiBamboozle:Clean(Blocked:GetPropertyChangedSignal("Value"):Connect(function()
                    Blocked.Value = false
                end))
            end
        end

        AntiBamboozle = Other:CreateModule({
            Name = "AntiBamboozle",
            Info = "Prevents windows from getting blocked by bamboozle.",
            Enabled = function()
                for i, v in workspace:GetChildren() do
                    if v.Name:find("Window") then
                        task.spawn(WindowAdded, v)
                    end
                end
                AntiBamboozle:Clean(workspace.ChildAdded:Connect(function(Child)
                    if Child.Name:find("Window") then
                        WindowAdded(Child)
                    end
                end))
            end,
        })
    end)

    Run(function() -- AntiBlock
        local AntiBlock

        local function WindowAdded(Window)
            local Panel = Window:WaitForChild("Panel", 5)
            local Blocked = Panel and Panel:WaitForChild("Blocked", 5)
            if AntiBlock.Enabled and Blocked then
                Blocked.Value = false
                AntiBlock:Clean(Blocked:GetPropertyChangedSignal("Value"):Connect(function()
                    Blocked.Value = false
                end))
            end
        end

        AntiBlock = Other:CreateModule({
            Name = "AntiBlock",
            Info = "Prevents windows from getting blocked after the third vault.",
            Enabled = function()
                for i, v in workspace:GetChildren() do
                    if v.Name:find("Window") then
                        task.spawn(WindowAdded, v)
                    end
                end
                AntiBlock:Clean(workspace.ChildAdded:Connect(function(Child)
                    if Child.Name:find("Window") then
                        WindowAdded(Child)
                    end
                end))
            end
        })
    end)

    Run(function() -- Pick Up Player
        local PickUpPlayer, TextBox, Player

        PickUpPlayer = Other:CreateButton({
            Name = "Pick Up Player",
            Info = "Picks up the specified player",
            Function = function()
                if Player then
                    ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Carry", "Pickup_Default", Player)
                end
            end
        })

        TextBox = PickUpPlayer:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {Player.DisplayName} (@{Player.Name})`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Duration = 5, Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- Drop Player
        local DropPlayer, TextBox, Player

        DropPlayer = Other:CreateButton({
            Name = "Drop Player",
            Info = "Drops the specified player",
            Function = function()
                if Player then
                    ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Carry", "Drop_Default", nil)
                end
            end
        })

        TextBox = DropPlayer:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {Player.DisplayName} (@{Player.Name})`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Duration = 5, Type = "Error"})
                end
            end
        })
    end)

    Run(function() -- Bring Player
        local BringPlayer, TextBox, Player

        BringPlayer = Other:CreateButton({
            Name = "Bring Player",
            Info = "Brings the specified player",
            Function = function()
                if Player then
                    ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Carry", "Pickup_Default", Player)
                    task.wait(1)
                    ReplicatedStorage.RemoteEvents.Server_Event:FireServer("Carry", "Drop_Default", nil)
                end
            end
        })

        TextBox = BringPlayer:CreateTextBox({
            Name = "Player",
            PlaceholderText = "[Player Name]",
            Function = function(Text)
                local FoundPlayer = FindPlayer(Text)
                if FoundPlayer then
                    Player = FoundPlayer
                    Notify({Text = `Set player to {Player.DisplayName} (@{Player.Name})`, Duration = 5})
                else
                    Notify({Text = "Failed to find player", Duration = 5, Type = "Error"})
                end
            end
        })
    end)
end)

Run(function() -- Animations
    Run(function() -- EmotePlayer
        local EmotePlayer, PointKeybind, FollowKeybind, CaliforniaGirlsKeybind, GetEmKeybind, ThinkKeybind, BowShotKeybind, Track
        local AnimationIds = {
            Point = {AnimationId = "rbxassetid://16520476888"},
            Follow = {AnimationId = "rbxassetid://16520472961", Keybind = FollowKeybind},
            CaliforniaGirls = {AnimationId = "rbxassetid://10258272240", Loop = true, Keybind = CaliforniaGirlsKeybind},
            GetEm = {AnimationId = "rbxassetid://15919624781", Loop = true, Keybind = GetEmKeybind},
            Think = {AnimationId = "rbxassetid://121839807114786", Keybind = ThinkKeybind},
            BowShot = {AnimationId = "rbxassetid://131833227843012", Keybind = BowShotKeybind},
        }

        local Playing = {}

        local function PlayAnimation(Emote)
            if AnimationIds[Emote].Loop and Playing[Emote] then
                Playing[Emote]:Stop()
                Playing[Emote] = nil
            else
                if Playing[Emote] then
                    Playing[Emote]:Stop()
                    Playing[Emote] = nil
                end
                local Animation = Instance.new("Animation")
                Animation.AnimationId = AnimationIds[Emote].AnimationId
                local Animator = CharacterLib.Humanoid:FindFirstChildOfClass("Animator") or CharacterLib.Humanoid
                Track = Animator:LoadAnimation(Animation)
                Track.Priority = Enum.AnimationPriority.Action4
                Track.Looped = AnimationIds[Emote].Loop
                Track:Play()
                Playing[Emote] = Track
            end
        end

        EmotePlayer = Animations:CreateModule({
            Name = "Emote Player",
            Info = "Allows you to bind all dead by roblox emotes to whatever keybind you want",
            Function = function(Enabled)
                if Enabled then
                    EmotePlayer:Clean(UIS.InputBegan:Connect(function(Input)
                        if UIS:GetFocusedTextBox() then return end
                        for i, v in AnimationIds do
                            if Input.KeyCode.Name == v.Keybind.Keybind then
                                PlayAnimation(i)
                            end
                        end
                    end))
                else
                    for i, v in Playing do
                        v:Stop()
                    end
                    table.clear(Playing)
                end
            end
        })

        PointKeybind = EmotePlayer:CreateKeybind({
            Name = "Point",
            Keybind = "One",
            Hold = false,
        })

        FollowKeybind = EmotePlayer:CreateKeybind({
            Name = "Follow",
            Keybind = "Two",
            Hold = false,
        })

        CaliforniaGirlsKeybind = EmotePlayer:CreateKeybind({
            Name = "California Girls",
            Keybind = "Three",
            Hold = false,
        })

        GetEmKeybind = EmotePlayer:CreateKeybind({
            Name = "Get Em",
            Keybind = "Four",
            Hold = false,
        })

        ThinkKeybind = EmotePlayer:CreateKeybind({
            Name = "Think",
            Keybind = "Five",
            Hold = false,
        })

        BowShotKeybind = EmotePlayer:CreateKeybind({
            Name = "Bow Shot",
            Keybind = "Six",
            Hold = false,
        })

        AnimationIds.Point.Keybind = PointKeybind
        AnimationIds.Follow.Keybind = FollowKeybind
        AnimationIds.CaliforniaGirls.Keybind = CaliforniaGirlsKeybind
        AnimationIds.GetEm.Keybind = GetEmKeybind
        AnimationIds.Think.Keybind = ThinkKeybind
        AnimationIds.BowShot.Keybind = BowShotKeybind
    end)
end)

--[[ random dead by roblox remotes
    ---------- Pick Up Player (Works With Survivor) ----------

    local args = {
        "Carry",
        "Pickup_Default",
        Player,
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Server_Event"):FireServer(unpack(args))

    ---------- Codes Module

    game:GetService("ReplicatedStorage").Modules.Data.Codes

    ---------- Hook Sabotage Stuff
    
    local Hook = workspace.Hook5
    
    local args = {
        {
            D9v8 = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Sabotaging",
                C22 = "S101"
            },
            Bbh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Sabotaging",
                C22 = "S101"
            },
            Dvh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Sabotaging",
                C22 = "S101"
            },
            Dbh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Sabotaging",
                C22 = "S101"
            },
            Dhv8 = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Sabotaging",
                C22 = "S101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))

    local args = {
        {
            D9v8 = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C20 = game:GetService("Players").LocalPlayer,
                C22 = "O101"
            },
            Bbh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C20 = game:GetService("Players").LocalPlayer,
                C22 = "O101"
            },
            Dvh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C20 = game:GetService("Players").LocalPlayer,
                C22 = "O101"
            },
            Dbh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C20 = game:GetService("Players").LocalPlayer,
                C22 = "O101"
            },
            Dhv8 = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C20 = game:GetService("Players").LocalPlayer,
                C22 = "O101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))

    local args = {
        {
            D9v8 = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = true,
                C22 = "B101"
            },
            Bbh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = true,
                C22 = "B101"
            },
            Dvh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = true,
                C22 = "B101"
            },
            Dbh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = true,
                C22 = "B101"
            },
            Dhv8 = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = true,
                C22 = "B101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))

    task.wait(3)

    local args = {
        {
            D9v8 = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Nothing",
                C22 = "S101"
            },
            Bbh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Nothing",
                C22 = "S101"
            },
            Dvh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Nothing",
                C22 = "S101"
            },
            Dbh1O = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Nothing",
                C22 = "S101"
            },
            Dhv8 = {
                C21 = game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):WaitForChild("Scripts"):WaitForChild("values"):WaitForChild("Action"),
                C20 = "Nothing",
                C22 = "S101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))

    local args = {
        {
            D9v8 = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = false,
                C22 = "B101"
            },
            Bbh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = false,
                C22 = "B101"
            },
            Dvh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = false,
                C22 = "B101"
            },
            Dbh1O = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = false,
                C22 = "B101"
            },
            Dhv8 = {
                C21 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Gold_Toolbox"):WaitForChild("Using"),
                C20 = false,
                C22 = "B101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))

    local args = {
        {
            D9v8 = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C22 = "O101"
            },
            Bbh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C22 = "O101"
            },
            Dvh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C22 = "O101"
            },
            Dbh1O = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C22 = "O101"
            },
            Dhv8 = {
                C21 = Hook:WaitForChild("Panel"):WaitForChild("Sabotaging"),
                C22 = "O101"
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("NewPropertie"):FireServer(unpack(args))
]]