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

Modules.Speed.Options.Method:SetValue('CFrame')
Modules.Fly.Options.FlyMethod:SetValue('CFrame')

local function Run(f)
    f()
end

local function Notify(Properties)
    TidalWave:Notify(Properties)
end

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
                            if Target.Root.Position.Y <= -6 then return end
                            local Direction = ((Target.Root.Position + (Target.Humanoid.MoveDirection * 3)) - CharacterLib.Root.Position).Unit
                            CharacterLib.Character:TranslateBy(Direction * CharacterLib.Humanoid.WalkSpeed * HeatSeekerSpeed.Value * Delta)
                            if Direction.Y > 0 then
                                CharacterLib.Root.AssemblyLinearVelocity = vector.create(CharacterLib.Root.AssemblyLinearVelocity.X, 0, CharacterLib.Root.AssemblyLinearVelocity.Z)
                                RunService.PostSimulation:Wait()
                                CharacterLib.Root.AssemblyLinearVelocity = vector.create(CharacterLib.Root.AssemblyLinearVelocity.X, 0, CharacterLib.Root.AssemblyLinearVelocity.Z)
                            end
                        end
                    end))
                end
                local Attack = ReplicatedStorage.Remotes.Attack
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

                        if Character and Character.Root.Position.Y < 135 then
                            Target = Character
                            if HeatSeeker.Enabled and (CharacterLib.Root.Position - Character.Root.Position).Magnitude > Range.Value then task.wait(0.05) continue end
                            local cf = CFrame.lookAt(CharacterLib.Root.Position, Character.Root.Position)
                            local Hitbox = Character.Character:FindFirstChild('Hitbox')
                            Attack:FireServer(vector.create(cf.LookVector.X, 0, cf.LookVector.Z), Hitbox)
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
            Max = 7,
        })

        WallCheck = KillAura:CreateToggle({
            Name = 'WallCheck',
            Info = 'Ignores players behind walls.'
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
        local Velocity, Horizontal, Vertical, Chance

        local Rand = Random.new()
        local Notified = false
        
        Velocity = Movement:CreateModule({
            Name = 'Velocity',
            Info = 'Modifies your knockback velocity.',
            Enabled = function()
                if getconnections and hookfunction then
                    local Connection
                    repeat
                        Connection = getconnections(ReplicatedStorage.Remotes.Knockback.OnClientEvent)[1]
                        task.wait()
                    until Connection or not Velocity.Enabled

                    if not Velocity.Enabled then return end

                    local Old; Old = hookfunction(Connection.Function, function(Parent, Vel)
                        if Rand:NextNumber(0, 100) <= Chance.Value then
                            local Hort = Horizontal.Value / 100
                            local Vert = Vertical.Value / 100
                            if Hort == 0 or Vert == 0 then return end
                            return Old(Parent, vector.create(Vel.X * Hort, Vel.Y * Vert, Vel.Z * Hort))
                        end
                        return Old(Parent, Vel)
                    end)

                    Velocity:Clean(function()
                        if restorefunction then
                            restorefunction(Connection.Function)
                        else
                            hookfunction(Connection.Function, Old)
                        end
                    end)
                else
                    if not Notified then
                        Notified = true
                        Notify({Text = 'Your executor doesn\'t support \'getconnections\'\nModifiying your velocity will not be supported, it will only remove it.', Duration = 10, Type = 'Error'})
                    end
                    ReplicatedStorage.KnockbackVelocity.Archivable = false
                    Velocity:Clean(function()
                        ReplicatedStorage.KnockbackVelocity.Archivable = true
                    end)
                end
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
                    Part.Position = vector.create(0, -8, 0)
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
            List = {'Velocity', 'Collide'},
            Function = function(Val)
                if Part then
                    Part.CanCollide = Val == 'Collide'
                end
            end,
            Info = 'Velocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
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
            Info = 'Prevents you from dying to lava.',
            Function = function(Enabled)
                workspace.Map.Lava.CanTouch = not Enabled
            end
        })
    end)
end)