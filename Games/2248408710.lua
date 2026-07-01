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

local Plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = cloneref(Plr:GetMouse())

local Combat = Categories.Combat
local World = Categories.World

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

Run(function()
    Run(function()
        local Boom, Interval

        local ExplodeRocket = ReplicatedStorage.Remotes.explodeRocket

        Boom = World:CreateModule({
            Name = "Boom",
            Info = "It go boom.",
            Enabled = function()
                while Boom.Enabled do
                    if CharacterLib.Alive and Mouse.Hit then
                        local Launcher = CharacterLib.Character:FindFirstChildOfClass("Tool")
                        if Launcher then
                            ExplodeRocket:FireServer(tick(), Launcher.Stats, Mouse.Hit.Position, Launcher.Assets.Rocket.Boom)
                            task.wait(Interval.Value)
                        else
                            task.wait()
                        end
                    else
                        task.wait()
                    end
                end
            end
        })

        Interval = Boom:CreateSlider({
            Name = "Interval",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
        })
    end)
end)