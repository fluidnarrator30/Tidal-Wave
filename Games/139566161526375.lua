local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib

local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Players: Players = GetService("Players")
local RunService: RunService = GetService("RunService")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local PathfindingService: PathfindingService = GetService("PathfindingService")

local Plr = Players.LocalPlayer

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other

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

local function Run(f)
    f()
end

Run(function() -- Combat
    Run(function() -- KillAura
        local KillAura, Range, MaxTargets

        local SwordClient = require(ReplicatedStorage.Client.Components.All.Tools.SwordClient)

        KillAura = Combat:CreateModule({
            Name = "KillAura",
            Info = "Automatically attacks players around you",
            Enabled = function()
                local EntityModule = debug.getupvalue(SwordClient.Start, 4)
                local ClientModule = debug.getupvalue(SwordClient.Start, 5)
                local ToolService = debug.getupvalue(SwordClient.Start, 6)

                while KillAura.Enabled do
                    if not CharacterLib.Alive then task.wait() continue end
                    local Tool = CharacterLib.Character:FindFirstChildOfClass("Tool")
                    if not Tool then task.wait() continue end

                    local ClosestPlayers = CharacterLib:GetClosestCharacters({
                        Origin = CharacterLib.Root.Position,
                        Range = Range.Value,
                        Limit = MaxTargets.Value,
                        Part = "Root",
                        Players = true,
                    })

                    if #ClosestPlayers > 0 then
                        for _, Char in ClosestPlayers do
                            local Entity = EntityModule.FindByCharacter(Char.Character)
                            if Entity then
                                local Args = {
                                    target_entity_id = Entity.Id,
                                    is_crit = CharacterLib.Root.AssemblyLinearVelocity.Y < 0,
                                    weapon_name = Tool.Name,
                                    extra = {
                                        rizz = "Bro.",
                                        owo = "h-hi sevengwanddad",
                                        those = workspace.Name == "Okay"
                                    }
                                }
                                ClientModule.item_action.attack_entity.fire(Args)
                                ToolService:AttackPlayerWithSword(Char.Character, CharacterLib.Root.AssemblyLinearVelocity.Y < 0, Tool.Name, "\226\128\139")
                                task.wait(0.4)
                            else
                                task.wait(0.05)
                            end
                        end
                    else
                        task.wait(0.05)
                    end
                end
            end
        })

        Range = KillAura:CreateSlider({
            Name = "Range",
            Default = 11,
            Min = 1,
            Max = 11,
            Decimal = 10,
            Suffix = function(Val)
                return Val > 1 and "studs" or "stud"
            end
        })

        MaxTargets = KillAura:CreateSlider({
            Name = "Max Targets",
            Default = 1,
            Min = 1,
            Max = 3
        })
    end)
end)