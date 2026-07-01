local CloneRef = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return CloneRef(game:GetService(Service))
end

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib

local Combat = Categories.Combat

local Players = GetService("Players")
local ReplicatedStorage = GetService("ReplicatedStorage")
local RunService = GetService("RunService")

local Plr = Players.LocalPlayer
local Backpack = Plr:FindFirstChildOfClass("Backpack")

do
    local ProjectileAura, HitCooldown, AutoEquipGun, MaxDistance, Bullets, CachedGun

    local ZombiesLocal = workspace:WaitForChild("Zombies_Local", 9999)
    local GunHit = ReplicatedStorage:WaitForChild("GunRemotes", 9999):WaitForChild("GunHit", 9999)

    local Zombies = {}

    local function GetZombieId(Zombie)
        return tonumber(Zombie.Name:match("%d+"))
    end

    local function GetClosestZombie()
        local ClosestZombie, ClosestZombieRoot
        local ClosestZombieDistance = MaxDistance.Value
        for _, Zombie in Zombies do
            local Root = Zombie:FindFirstChild("HumanoidRootPart")
            if not Root then continue end
            local Head = Zombie:FindFirstChild("Head")
            if Head and Head.Transparency > 0 then continue end
            local Distance = (Root.Position - CharacterLib.Root.Position).Magnitude
            if Distance < ClosestZombieDistance then
                ClosestZombie = Zombie
                ClosestZombieRoot = Root
                ClosestZombieDistance = Distance
            end
        end
        return ClosestZombie, ClosestZombieRoot
    end

    ProjectileAura = Combat:CreateModule({
        Name = "Projectile Aura",
        Function = function(Enabled)
            if Enabled then
                for _, Zombie in ZombiesLocal:GetChildren() do
                    table.insert(Zombies, Zombie)
                end

                ProjectileAura:Clean(ZombiesLocal.ChildAdded:Connect(function(Zombie)
                    table.insert(Zombies, Zombie)
                end))
                ProjectileAura:Clean(ZombiesLocal.ChildRemoved:Connect(function(Zombie)
                    local Index = table.find(Zombies, Zombie)
                    if Index then
                        table.remove(Zombies, Index)
                    end
                end))

                repeat
                    if not CharacterLib.Alive then task.wait() continue end
                    local Gun = (CachedGun ~= nil and CachedGun.Parent ~= nil and CachedGun) or CharacterLib.Character:FindFirstChildOfClass("Tool")
                    if not Gun and AutoEquipGun.Enabled then
                        local BackpackedGun = Backpack:FindFirstChildOfClass("Tool")
                        if BackpackedGun then
                            CharacterLib.Humanoid:EquipTool(BackpackedGun)
                        end
                    end

                    if not Gun then task.wait() continue end

                    if not CachedGun or CachedGun.Parent == nil then
                        CachedGun = Gun
                    end

                    local ClosestZombie, ClosestZombieRoot = GetClosestZombie()

                    if not (ClosestZombie and ClosestZombieRoot) then task.wait() continue end

                    for _ = 1, Bullets.Value do
                        GunHit:FireServer(Gun.Name, GetZombieId(ClosestZombie), ClosestZombieRoot.Position)
                    end

                    task.wait(HitCooldown.Value)
                until not ProjectileAura.Enabled
            else
                table.clear(Zombies)
            end
        end
    })

    HitCooldown = ProjectileAura:CreateSlider({
        Name = "Hit Cooldown",
        Default = 0.2,
        Min = 0,
        Max = 1,
        Decimal = 100,
        Function = function(Val)
            HitCooldown.Value = math.clamp(Val, 0, 1)
        end
    })

    AutoEquipGun = ProjectileAura:CreateToggle({
        Name = "Auto Equip Gun",
        Info = "Automatically equips your gun when enabling projectile aura",
        Default = true
    })

    MaxDistance = ProjectileAura:CreateSlider({
        Name = "Max Distance",
        Default = 250,
        Min = 1,
        Max = 250
    })

    Bullets = ProjectileAura:CreateSlider({
        Name = "Bullets",
        Default = 1,
        Min = 1,
        Max = 7
    })
end