local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Players: Players = GetService("Players")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local RunService: RunService = GetService("RunService")
local UIS: UserInputService = GetService('UserInputService')

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib
local Modules = TidalWave.Modules
local ObjectFunctions = TidalWave.Libraries.ObjectFunctions

local Plr = Players.LocalPlayer

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other

local function Run(f)
    f()
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

local function SafeRef(Obj, Path)
    return ObjectFunctions:SafeRef(Obj, Path)
end

Run(function() -- CharacterLib
    function CharacterLib:CanAttack(Character)
        local LocalSafeZone = Plr:FindFirstChild('SafeZone')
        local SafeZone = Character.Player:FindFirstChild('SafeZone')
        return Character.Health > 0 and (SafeZone and not SafeZone.Value) and (LocalSafeZone and not LocalSafeZone.Value)
    end
end)

Run(function() -- Combat
    Run(function() -- KillAura
        local KillAura, Range, WallCheck, Priority, HeatSeeker, HeatSeekerSpeed, HeatSeekerRange, Target

        KillAura = Combat:CreateModule({
            Name = 'KillAura',
            Info = 'Automatically attacks the closest player.',
            Enabled = function()
                if HeatSeeker.Enabled then
                    KillAura:Clean(RunService.PreSimulation:Connect(function(Delta)
                        if CharacterLib.Alive and Target then
                            if Target.Root.Position.Y <= 18 then return end
                            local Direction = ((Target.Root.Position + (Target.Humanoid.MoveDirection * 3)) - CharacterLib.Root.Position).Unit
                            CharacterLib.Character:TranslateBy(Direction * CharacterLib.Humanoid.WalkSpeed * HeatSeekerSpeed.Value * Delta)
                        end
                    end))
                end
                local Attack = ReplicatedStorage.Remotes.Hit
                while KillAura.Enabled do
                    if CharacterLib.Alive then
                        local Character = CharacterLib:GetClosestCharacter({
                            Range = HeatSeeker.Enabled and HeatSeekerRange.Value or Range.Value,
                            WallCheck = WallCheck.Enabled,
                            Players = true,
                            Sort = Priority.Value == 'Closest' and nil or function(a, b)
                                return a.Character.Health < b.Character.Health
                            end
                        })

                        if Character then
                            Target = Character
                            if HeatSeeker.Enabled and (CharacterLib.Root.Position - Character.Root.Position).Magnitude > Range.Value then task.wait(0.05) continue end
                            Attack:FireServer({
                                [Character.Player.Name] = {
                                    Victim = Character.Player,
                                    Vector = CFrame.lookAt(CharacterLib.Root.Position, Character.Root.Position).LookVector
                                }
                            })
                            task.wait(0.1)
                        else
                            Target = nil
                        end
                    end

                    task.wait(0.05)
                end
            end
        })

        Range = KillAura:CreateSlider({
            Name = 'Range',
            Default = 7,
            Min = 1,
            Max = 7
        })

        WallCheck = KillAura:CreateToggle({
            Name = 'Wall Check',
            Info = 'Ignores players behind walls.',
        })

        Priority = KillAura:CreateDropdown({
            Name = 'Priority',
            List = {'Closest', 'Weakest'},
            Info = 'Closest - Targets the closest players.\nWeakest - Targets players with the lowest health.'
        })

        HeatSeeker = KillAura:CreateToggle({
            Name = 'Heat Seeker',
            Info = 'Guides your character towards the current target.',
            Function = function(Enabled)
                if KillAura.Enabled then
                    KillAura:Toggle(true)
                    KillAura:Toggle(true)
                end
                HeatSeekerSpeed:SetVisible(Enabled)
                HeatSeekerRange:SetVisible(Enabled)
            end
        })

        HeatSeekerSpeed = KillAura:CreateSlider({
            Name = 'Heat Seeker Speed',
            Default = 1,
            Min = 0.5,
            Max = 2,
            Decimal = 100,
            Visible = false
        })

        HeatSeekerRange = KillAura:CreateSlider({
            Name = 'Heat Seeker Range',
            Default = 7,
            Min = 1,
            Max = 14,
            Visible = false
        })
    end)
end)

Run(function() -- Movement
    Run(function() -- Velocity
        local Velocity, Horizontal, Vertical, Chance, Connection, Old

        local Rand = Random.new()

        local function ScriptAdded()
            repeat
                for _, v in getconnections(ReplicatedStorage.Remotes.ApplyImpulse.OnClientEvent) do
                    if v.Function and debug.info(v.Function, 's'):match('LocalInputHandling') then
                        Connection = v
                        break
                    end
                end
                task.wait()
            until Connection or not Velocity.Enabled
            if not (Velocity.Enabled and Connection and Connection.Function) then return end

            Old = hookfunction(Connection.Function, function(Vel, Attacker)
                if Rand:NextNumber(0, 100) <= Chance.Value then
                    local Hort = Horizontal.Value / 100
                    local Vert = Vertical.Value / 100
                    if Hort == 0 or Vert == 0 then return end
                    return Old(vector.create(Vel.X * Hort, Vel.Y * Vert, Vel.Z * Hort), Attacker)
                end
                return Old(Vel, Attacker)
            end)
        end
        
        Velocity = Movement:CreateModule({
            Name = 'Velocity',
            Info = 'Modifies your knockback velocity.',
            Enabled = function()
                if not (getconnections and hookfunction) then NotifyPoopSploit(not getconnections and 'getconnections' or not hookfunction and 'hookfunction') return end
                
                Velocity:Clean(Plr.PlayerGui.ChildAdded:Connect(function(Child)
                    if Child.Name == 'MobileButtons' then
                        local New = Child:WaitForChild('New', 5)
                        local LocalInputHandling = New and New:WaitForChild('LocalInputHandling', 5)
                        if LocalInputHandling then
                            ScriptAdded()
                        end
                    end
                end))

                local LocalInputHandling = SafeRef(Plr.PlayerGui, {'New', 'LocalInputHandling'})
                if LocalInputHandling then
                    ScriptAdded()
                end

                Velocity:Clean(function()
                    if Connection and Connection.Function then
                       if restorefunction then
                            restorefunction(Connection.Function)
                        elseif Old then
                            hookfunction(Connection.Function, Old)
                        end
                    end
                end)
            end,
        })

        Horizontal = Velocity:CreateSlider({
            Name = 'Horizontal',
            Default = 0,
            Min = 0,
            Max = 100,
            Suffix = '%'
        })

        Vertical = Velocity:CreateSlider({
            Name = 'Vertical',
            Default = 0,
            Min = 0,
            Max = 100,
            Suffix = '%'
        })

        Chance = Velocity:CreateSlider({
            Name = 'Chance',
            Default = 100,
            Min = 0,
            Max = 100,
            Suffix = '%'
        })
    end)
end)

Run(function() -- World
    Run(function() -- AntiFall
        local AntiFall, Method, Material, Color, Part

        AntiFall = World:CreateModule({
            Name = 'AntiFall',
            Info = 'Prevents you from falling into the water.',
            Function = function(Enabled)
                if Enabled then
                    Part = Instance.new('Part')
                    Part.Size = vector.create(2048, 1, 2048)
                    Part.Transparency = Color.Transparency
                    Part.Material = Enum.Material[Material.Value]
                    Part.Color = Color.Color
                    Part.CanCollide = Method.Value == 'Collide'
                    Part.Anchored = true
                    Part.CanQuery = false
                    Part.Parent = workspace
                    local db = os.clock()
                    AntiFall:Clean(Part.Touched:Connect(function(Touch)
                        if Touch.Parent == CharacterLib.Character and CharacterLib.Alive and db < os.clock() then
                            db = os.clock() + 0.1
                            if Method.Value == 'Velocity' then
                                CharacterLib.Root.Velocity = vector.create(CharacterLib.Root.Velocity.X, 30, CharacterLib.Root.Velocity.Z)
                            end
                        end
                    end))
                    while AntiFall.Enabled do
                        if CharacterLib.Alive then
                            Part.Position = vector.create(CharacterLib.Root.Position.X, 15, 8)
                        end
                        task.wait(0.4)
                    end
                else
                    if Part then
                        Part:Destroy()
                        Part = nil
                    end
                end
            end
        })

        Method = AntiFall:CreateDropdown({
            Name = 'Method',
            List = {'Velocity', 'Collide', 'CanTouch'},
            Info = 'Velocity - Launches you upward after touching\nCollide - Allows you to walk on the part\nCanTouch - Prevents the water from killing you',
            Function = function(Val)
                if Part then
                    Part.CanCollide = Val == 'Collide'
                end
            end,
        })
        
        local Materials = {'ForceField'}
        for _, v in Enum.Material:GetEnumItems() do
            if v.Name ~= 'ForceField' then
                Materials[#Materials + 1] = v.Name
            end
        end

        Material = AntiFall:CreateDropdown({
            Name = 'Material',
            List = Materials,
            Function = function(Val)
                if Part then
                    Part.Material = Enum.Material[Val]
                end
            end
        })

        Color = AntiFall:CreateColorPicker({
            Name = 'Color',
            Default = Color3.fromRGB(255, 255, 255),
            Transparency = 0.5,
            Function = function(Color, Transparency)
                if Part then
                    Part.Color = Color
                    Part.Transparency = Transparency
                end
            end
        })
    end)

    Run(function() -- AntiLava
        local AntiLava

        AntiLava = World:CreateModule({
            Name = 'AntiLava',
            Info = 'Prevents lava from killing you.',
            Function = function(Enabled)
                workspace.Interactives["Water4.5"].CanTouch = not Enabled
            end
        })
    end)
end)