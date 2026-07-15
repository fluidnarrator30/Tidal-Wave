local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Players: Players = GetService("Players")
local RunService: RunService = GetService("RunService")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local PathfindingService: PathfindingService = GetService("PathfindingService")
local TweenService: TweenService = GetService("TweenService")

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib
local CustomLocalMethods = TidalWave.Libraries.CustomLocalMethods
local Modules = TidalWave.Modules

local Plr = Players.LocalPlayer

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other

local getcustomasset = getcustomasset
local fireclickdetector = fireclickdetector
local isfile = isfile

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

local function GetMap()
    if ReplicatedStorage.CurrentMap:GetAttribute("MapLoaded") and ReplicatedStorage.CurrentMap.Value and ReplicatedStorage.CurrentMap.Value.Parent then
        return ReplicatedStorage.CurrentMap.Value
    end
    return nil
end

local function Run(f)
    f()
end

local function SafeRef(Obj, Path)
    return CustomLocalMethods:SafeRef(Obj, Path)
end

local function IsBeast(Player)
    local IsBeast = SafeRef(Player or Plr, {"TempPlayerStatsModule", "IsBeast"})
    return IsBeast and IsBeast.Value or false
end

local function GetBeast()
    for _, Player in Players:GetPlayers() do
        if IsBeast(Player) then
            return Player
        end
    end
    return nil
end

local function GetFullName(Obj)
    return CustomLocalMethods:GetFullName(Obj)
end

Run(function()
    function CharacterLib:IsTeammate(Character)
        if TidalWave:IsFriend(Character.Player) then return true end
        local LocalIsBeast = SafeRef(Plr, {"TempPlayerStatsModule", "IsBeast"})
        if LocalIsBeast and LocalIsBeast.Value then
            return false
        elseif LocalIsBeast and not LocalIsBeast.Value then
            local IsBeast = SafeRef(Character.Player, {"TempPlayerStatsModule", "IsBeast"})
            return IsBeast and not IsBeast.Value
        end
    end

    function CharacterLib:GetTeamColor(Character)
        local IsFriend, FriendColor = TidalWave:IsFriend(Character.Player)
        return (IsFriend and FriendColor) or (CharacterLib:IsTeammate(Character) and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
    end

    function CharacterLib:GetUpdateConnections(Char)
        local Health = SafeRef(Char.Player, {"TempPlayerStatsModule", "Health"})
        return {
            Health and Health:GetPropertyChangedSignal("Value") or nil
        }
    end
    
    function CharacterLib:GetTeamUpdateConnections(Char)
        local IsBeast = SafeRef(Char.Player, {"TempPlayerStatsModule", "Health"})
        return {
            IsBeast and IsBeast:GetPropertyChangedSignal("Value") or nil
        }
    end

    function CharacterLib:GetCharacterProperties(Char)
        local Health = SafeRef(Char.Player, {"TempPlayerStatsModule", "Health"})
        local IsBeast = SafeRef(Char.Player, {"TempPlayerStatsModule", "Health"})
        return {
            Health = (IsBeast and IsBeast.Value and 100) or (Health and Health.Value) or 100,
            MaxHealth = 100
        }
    end

    CharacterLib:Restart()
end)

Run(function() -- Combat
    Run(function() -- KillAura
        local KillAura, Range, WallCheck

        KillAura = Combat:CreateModule({
            Name = "KillAura",
            Enabled = function()
                repeat
                    local Character = CharacterLib:GetClosestCharacter({
                        Range = Range.Value,
                        WallCheck = WallCheck.Enabled
                    })
                    if Character then
                        local Hammer = CharacterLib.Alive and CharacterLib:FindFirstChild("Hammer")
                        local HammerEvent = Hammer and Hammer:FindFirstChild("HammerEvent")
                        if HammerEvent then
                            HammerEvent:FireServer("HammerHit", Character.Root)
                        end
                    end
                    task.wait(0.05)
                until not KillAura.Enabled
            end,
        })

        Range = KillAura:CreateSlider({
            Name = "Range",
            Default = 5,
            Min = 1,
            Max = 10
        })

        WallCheck = KillAura:CreateToggle({
            Name = "Wall Check",
            Default = true
        })
    end)

    Run(function() -- KillAuraOthers
        local KillAuraOthers, Range, WallCheck

        KillAuraOthers = Combat:CreateModule({
            Name = "KillAuraOthers",
            Enabled = function()
                repeat
                    local Beast = GetBeast()
                    local BeastChar = Beast and CharacterLib:FindCharacter(Beast)
                    if BeastChar then
                        local Character = CharacterLib:GetClosestCharacter({
                            Origin = BeastChar.Root.Position,
                            Range = Range.Value,
                            WallCheck = WallCheck.Enabled
                        })
                        if Character then
                            local Hammer = BeastChar.Character:FindFirstChild("Hammer")
                            local HammerEvent = Hammer and Hammer:FindFirstChild("HammerEvent")
                            if HammerEvent then
                                HammerEvent:FireServer("HammerHit", Character.Root)
                            end
                        end
                    end
                    task.wait(0.05)
                until not KillAuraOthers.Enabled
            end,
        })

        Range = KillAuraOthers:CreateSlider({
            Name = "Range",
            Default = 5,
            Min = 1,
            Max = 10
        })

        WallCheck = KillAuraOthers:CreateToggle({
            Name = "Wall Check",
            Default = true
        })
    end)
end)

Run(function() -- Player
    Run(function() -- BeastCrawl
        local BeastCrawl, DisableCrawl

        local ModifiedParts = {}

        BeastCrawl = PlayerCategory:CreateModule({
            Name = "BeastCrouch",
            Info = "Allows you to crouch as the beast",
            Function = function(Enabled)
                if Enabled then
                    repeat
                        DisableCrawl = SafeRef(Plr, {"TempPlayerStatsModule", "DisableCrawl"})
                        task.wait(0.05)
                    until DisableCrawl or not BeastCrawl.Enabled

                    DisableCrawl.Value = false
                    DisableCrawl:GetPropertyChangedSignal("Value"):Connect(function()
                        DisableCrawl.Value = false
                    end)

                    BeastCrawl:Clean(workspace.DescendantAdded:Connect(function(Child)
                        if Child:IsA("BasePart") and Child.CollisionGroup == 'VENT' then
                            Child.CanCollide = false
                        end
                    end))

                    for _, Part in workspace:QueryDescendants("BasePart") do
                        if Part.CollisionGroup == 'VENT' and Part.CanCollide then
                            Part.CanCollide = false
                            ModifiedParts[Part] = true
                        end
                    end
                else
                    if DisableCrawl then
                        local IsBeast = SafeRef(Plr, {"TempPlayerStatsModule", "IsBeast"})
                        DisableCrawl.Value = IsBeast and IsBeast.Value
                    end
                    for Part in ModifiedParts do
                        Part.CanCollide = true
                    end
                    table.clear(ModifiedParts)
                end
            end,
        })
    end)
end)

Run(function() -- Movement
    Run(function() -- BeastSlow
        local BeastSlow

        BeastSlow = Movement:CreateModule({
            Name = "BeastSlow",
            Info = "Makes the beast very slow",
            Enabled = function()
                local Cache
                while BeastSlow.Enabled do
                    if Cache and Cache.Parent then
                        Cache:FireServer("Jumped")
                    else
                        for _, v in CharacterLib.List do
                            local PowersEvent = SafeRef(v.Character, {"BeastPowers", "PowersEvent"})
                            if PowersEvent then
                                PowersEvent:FireServer("Jumped")
                                Cache = PowersEvent
                                break
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end
        })
    end)
end)

Run(function() -- Visuals
    Run(function() -- ComputerESP
        local ComputerESP, OutlineTransparency, FillTransparency, Folder, ChildAdded, ChildRemoved
        local Highlights = {}

        local Red = BrickColor.Red()
        local ScreenColor = Color3.fromRGB(13, 105, 172)

        local function OnChildAdded(Child)
            if Child.Name ~= 'ComputerTable' then return end
            local TimeOut = os.clock() + 5
            local Screen
            local BillboardGui
            repeat
                Screen = Child:FindFirstChild("Screen")
                BillboardGui = Screen and Screen:FindFirstChild("BillboardGui")
                task.wait()
            until Screen and BillboardGui or not ComputerESP.Enabled or os.clock() >= TimeOut

            if Screen and BillboardGui and ComputerESP.Enabled then
                local Highlight = Instance.new("Highlight")
                Highlight.OutlineColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
                Highlight.FillColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
                Highlight.OutlineTransparency = OutlineTransparency.Value
                Highlight.FillTransparency = FillTransparency.Value
                Highlight.Adornee = Child
                Highlight.Parent = Folder
                
                Highlights[Child] = {
                    Connection = ComputerESP:Clean(Screen:GetPropertyChangedSignal("Color"):Connect(function()
                        Highlight.OutlineColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
                        Highlight.FillColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
                    end)),
                    Highlight = Highlight
                }
            end
        end

        local function OnChildRemoved(Child)
            if Highlights[Child] then
                Highlights[Child]:Destroy()
                Highlights[Child] = nil
            end
        end

        local function Disconnect()
            if ChildAdded then
                ChildAdded:Disconnect()
                ChildAdded = nil
            end
            if ChildRemoved then
                ChildRemoved:Disconnect()
                ChildRemoved = nil
            end
        end

        ComputerESP = Visuals:CreateModule({
            Name = "ComputerESP",
            Info = "Renders computers through walls.",
            Function = function(Enabled)
                if Enabled then
                    Folder = Instance.new("Folder")
                    Folder.Name = "ComputerChams"
                    Folder.Parent = TidalWave.Gui

                    ComputerESP:Clean(ReplicatedStorage.CurrentMap:GetPropertyChangedSignal("Value"):Connect(function()
                        Disconnect()
                        if ReplicatedStorage.CurrentMap.Value then
                            ChildAdded = ReplicatedStorage.CurrentMap.Value.ChildAdded:Connect(OnChildAdded)
                            ChildRemoved = ReplicatedStorage.CurrentMap.Value.ChildRemoved:Connect(OnChildRemoved)
                        end
                    end))

                    ComputerESP:Clean(workspace.DescendantAdded:Connect(OnChildAdded))
                    ComputerESP:Clean(workspace.DescendantRemoving:Connect(function(Child)
                        if Child.Name == 'ComputerTable' then
                            for i, v in Highlights do
                                if i == Child then
                                    v.Connection:Disconnect()
                                    v.Highlight:Destroy()
                                    Highlights[i] = nil
                                    break
                                end
                            end
                        end
                    end))
                    for _, v in workspace:QueryDescendants("Model#ComputerTable") do
                        task.spawn(OnChildAdded, v)
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
                    table.clear(Highlights)
                end
            end
        })

        OutlineTransparency = ComputerESP:CreateSlider({
            Name = "Outline Transparency",
            Default = 0,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = function(Val)
                if not ComputerESP.Enabled then return end
                for _, v in Folder:GetChildren() do
                    v.OutlineTransparency = Val
                end
            end
        })

        FillTransparency = ComputerESP:CreateSlider({
            Name = "Fill Transparency",
            Default = 0.5,
            Min = 0,
            Max = 1,
            Decimal = 100,
            Function = function(Val)
                if not ComputerESP.Enabled then return end
                for _, v in Folder:GetChildren() do
                    v.FillTransparency = Val
                end
            end
        })
    end)
end)

Run(function() -- World
    Run(function() -- Click Ice Button
        World:CreateButton({
            Name = "Click Ice Button",
            Info = "Fires the ice button on abandoned facility maximus",
            Function = function()
                if not fireclickdetector then NotifyPoopSploit("fireclickdetector") return end
                local Map = GetMap()
                local Button = Map and Map:FindFirstChild("Button")
                local ClickDetector = Button and Button:FindFirstChildOfClass("ClickDetector")
                if ClickDetector then
                    fireclickdetector(ClickDetector)
                end
            end,
        })
    end)

    Run(function() -- InfiniteButtonRange
        World:CreateModule({
            Name = "InfiniteButtonRange",
            Info = "You can click ice button from very far away :D",
            Function = function(Enabled)
                local Map = GetMap()
                local Button = Map and Map:FindFirstChild("Button")
                local ClickDetector = Button and Button:FindFirstChildOfClass("ClickDetector")
                if ClickDetector then
                    ClickDetector.MaxActivationDistance = if Enabled then math.huge else 20
                end
            end,
        })
    end)
end)

Run(function() -- Other
    Run(function() -- CustomBeastMusic
        local CustomBeastMusic, Volume, MusicId, SoundObject, HeartbeatObject, RollOffMinDistance, RollOffMaxDistance, HeartbeatVolume

        local function SetId(Custom)
            if not SoundObject then return end
            if Custom then SoundObject.SoundId = Custom return end
            local Id
            if MusicId.Object.TextBox.Text:match("%.") then
                Id = getcustomasset(MusicId.Object.TextBox.Text)
            else
                local Match = MusicId.Object.TextBox.Text:match("%d+")
                if Match then
                    Id = "rbxassetid://" .. Match
                end
            end
            if Id then
                SoundObject.SoundId = Id
                SoundObject.RollOffMinDistance = RollOffMinDistance.Value
                SoundObject.RollOffMaxDistance = RollOffMaxDistance.Value
            end
        end

        local function OnCharacterAdded(Character)
            local Music = SafeRef(Character.Character, {"Hammer", "Handle", "SoundChaseMusic"})
            local Heartbeat = SafeRef(Character.Character, {"Hammer", "Handle", "HeartBeat"})

            if not Music then
                local TimeOut = os.clock() + 5
                repeat
                    Music = SafeRef(Character.Character, {"Hammer", "Handle", "SoundChaseMusic"})
                    task.wait()
                until Music or not CustomBeastMusic.Enabled or os.clock() >= TimeOut
            end

            if not Heartbeat then
                local TimeOut = os.clock() + 5
                repeat
                    Heartbeat = SafeRef(Character.Character, {"Hammer", "Handle", "SoundChaseMusic"})
                    task.wait()
                until Heartbeat or not CustomBeastMusic.Enabled or os.clock() >= TimeOut
            end

            if Music and CustomBeastMusic.Enabled then
                Music = Music
                Music.Volume = Volume.Value
                SoundObject = Music
                SetId()
            end
            if Heartbeat and CustomBeastMusic.Enabled then
                Heartbeat.Volume = HeartbeatVolume
                HeartbeatObject = Heartbeat
            end
        end

        CustomBeastMusic = Other:CreateModule({
            Name = "CustomBeastMusic",
            Info = "Allows you to change the beast music volume and set a custom ID.\nDefault beast music id is 1846863084.",
            Function = function(Enabled)
                if Enabled then
                    if Modules.TerrorRadius.Enabled then
                        Modules.TerrorRadius:Toggle(true)
                    end
                    for _, Character in CharacterLib.List do
                        task.spawn(OnCharacterAdded, Character)
                    end
                    CustomBeastMusic:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                else
                    SetId("rbxassetid://1846863084")
                    SoundObject = nil
                    if HeartbeatObject then
                        HeartbeatObject.Volume = 1.9
                        HeartbeatObject = nil
                    end
                end
            end,
        })

        MusicId = CustomBeastMusic:CreateTextBox({
            Text = "rbxassetid://1846863084",
            Name = "Music Id",
            PlaceholderText = "[rbxassetid://1846863084]",
            Function = function()
                SetId()
            end
        })

        Volume = CustomBeastMusic:CreateSlider({
            Name = "Volume",
            Default = 0.4,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Function = function(Val)
                if SoundObject then
                    SoundObject.Volume = Val
                end
            end
        })

        RollOffMinDistance = CustomBeastMusic:CreateSlider({
            Name = "Roll Off Min Distance",
            Default = 10,
            Min = 0,
            Max = 50,
            Function = function(Val)
                if SoundObject then
                    SoundObject.RollOffMinDistance = Val
                end
            end
        })

        RollOffMaxDistance = CustomBeastMusic:CreateSlider({
            Name = "Roll Off Max Distance",
            Default = 30,
            Min = 0,
            Max = 100,
            Function = function(Val)
                if SoundObject then
                    SoundObject.RollOffMaxDistance = Val
                end
            end
        })

        HeartbeatVolume = CustomBeastMusic:CreateSlider({
            Name = "Heartbeat Volume",
            Default = 1.9,
            Min = 0,
            Max = 10
        })
    end)

    Run(function() -- TerrorRadius
        local TerrorRadius, Volume, Layer1Distance, Layer2Distance, Layer3Distance, ChaseDistance, Music, CurrentlyPlaying

        local Layer1, Layer2, Layer3, Chase
        local LookAwayThread, WalkAwayThread, StartChaseThread

        local SupportedFileTypes = {"mp3", "ogg", "wav", "flac"}
        local RequiredFiles = {"Layer 1", "Layer 2", "Layer 3", "Chase"}

        local function GetBeast()
            for _, Char in CharacterLib.List do
                if Char.Character:FindFirstChild("Hammer") then
                    return Char.Player
                end
            end

            return nil
        end

        local function GetAssets()
            local Tab = {}

            for i, v in RequiredFiles do
                local Any = false
                for _, v2 in SupportedFileTypes do
                    if isfile(`{v}.{v2}`) then
                        Tab[i] = getcustomasset(`{v}.{v2}`)
                        Any = true
                        break
                    end
                end
                if not Any then
                    Notify({Text = `Missing file`, Duration = 5, Type = "Error"})
                    return nil
                end
            end

            if #Tab < 4 then
                local Missing = {}
                for i = 1, 4 do
                    if Tab[i] == nil then
                        table.insert(Missing, RequiredFiles[i] .. ".mp3")
                    end
                end
                Notify({Text = `Failed to get assets.\nMissing files: {table.concat(Missing, ", ")}`})
                return nil
            end

            return unpack(Tab)
        end
        
        local Tweens = {}
        local LookVectorMod = vector.create(1, 0, 1)

        local function Tween(Object, Info, Goal)
            if Tweens[Object] then
                Tweens[Object]:Cancel()
                Tweens[Object] = nil
            end

            local NewTween = TweenService:Create(Object, Info, Goal)
            NewTween:Play()
            Tweens[Object] = NewTween
            NewTween.Completed:Once(function(Status)
                if Status == Enum.PlaybackState.Completed then
                    Tweens[Object] = nil
                end
            end)

            return NewTween
        end

        local function CancelLookAwayThread()
            if LookAwayThread then
                task.cancel(LookAwayThread)
                LookAwayThread = nil
            end
        end

        local function CancelWalkAwayThread()
            if WalkAwayThread then
                task.cancel(WalkAwayThread)
                WalkAwayThread = nil
            end
        end

        local function CancelStartChaseThread()
            if StartChaseThread then
                task.cancel(StartChaseThread)
                StartChaseThread = nil
            end
        end

        local function CancelAllThreads()
            CancelLookAwayThread()
            CancelWalkAwayThread()
            CancelStartChaseThread()
        end

        TerrorRadius = Other:CreateModule({
            Name = "TerrorRadius",
            Info = "Allows you to have a custom terror radius.\nYou must have 4 sound files in your workspace folder for this to work: \"Layer 1.mp3\", \"Layer 2.mp3\", \"Layer 3.mp3\", \"Chase.mp3\"\nSupports mp3, ogg, wav and flac files.",
            Function = function(Enabled)
                if Enabled then
                    if not getcustomasset then NotifyPoopSploit("getcustomasset") return end
                    local Layer1Asset, Layer2Asset, Layer3Asset, ChaseAsset = GetAssets()

                    if not Layer1Asset then return end
                    Layer1, Layer2, Layer3, Chase = Instance.new("Sound"), Instance.new("Sound"), Instance.new("Sound"), Instance.new("Sound")

                    Layer1.SoundId, Layer2.SoundId, Layer3.SoundId, Chase.SoundId = Layer1Asset, Layer2Asset, Layer3Asset, ChaseAsset

                    Layer1.Volume, Layer2.Volume, Layer3.Volume, Chase.Volume = Volume.Value, Volume.Value, Volume.Value, Volume.Value
                    Layer1.Looped, Layer2.Looped, Layer3.Looped, Chase.Looped = true, true, true, true
                    Layer1.Parent, Layer2.Parent, Layer3.Parent, Chase.Parent = workspace, workspace, workspace, workspace

                    if TidalWave.Modules.CustomBeastMusic.Enabled then
                        TidalWave.Modules.CustomBeastMusic:Toggle(true)
                    end

                    local function PlaySound(Sound, FadeTime)
                        if Sound.Playing then return end
                        local Info = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
                        if CurrentlyPlaying then
                            local Tween = Tween(CurrentlyPlaying, Info, {Volume = 0})
                            local Copy = CurrentlyPlaying
                            Tween.Completed:Once(function(State)
                                if State == Enum.PlaybackState.Completed then
                                    Copy:Stop()
                                end
                            end)
                        end
                        CurrentlyPlaying = Sound
                        Sound:Play()
                        Tween(Sound, Info, {Volume = Volume.Value})
                    end

                    local function StopCurrentSound(FadeTime)
                        if CurrentlyPlaying then
                            local Info = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
                            local Tween = Tween(CurrentlyPlaying, Info, {Volume = 0})
                            local Copy = CurrentlyPlaying
                            Tween.Completed:Once(function(State)
                                if State == Enum.PlaybackState.Completed then
                                    Copy:Stop()
                                end
                            end)
                            CurrentlyPlaying = nil
                        end
                    end

                    local Chasing = false

                    while TerrorRadius.Enabled do
                        if not CharacterLib.Alive then task.wait(0.05) continue end
                        local Beast = GetBeast()
                        
                        if Beast then
                            local Char = CharacterLib:FindCharacter(Beast)
                            if Char then
                                Music = SafeRef(Char.Character, {"Hammer", "Handle", "SoundChaseMusic"})
                                if Music then
                                    Music.Volume = 0
                                end

                                local Magnitude = (Char.Root.Position - CharacterLib.Root.Position).Magnitude
                                local BeastLookDirection = Char.Head.CFrame.LookVector * LookVectorMod
                                local Direction = (CharacterLib.Head.Position - Char.Head.Position) * LookVectorMod
                                local Angle = math.deg(math.acos(BeastLookDirection:Dot(Direction.Unit))) * 2
                                local StartChase = Char.Root.AssemblyLinearVelocity.Magnitude > 0 and CharacterLib.Root.AssemblyLinearVelocity.Magnitude > 0 and Angle <= 90 and not CharacterLib:WallCheck(CharacterLib.Head.Position, Char.Head.Position) or nil
                                
                                if StartChase then
                                    if StartChaseThread then task.wait(0.05) continue end
                                    StartChaseThread = task.delay(0.5, function()
                                        Magnitude = (Char.Root.Position - CharacterLib.Root.Position).Magnitude
                                        BeastLookDirection = Char.Head.CFrame.LookVector * LookVectorMod
                                        Direction = (CharacterLib.Head.Position - Char.Head.Position) * LookVectorMod
                                        Angle = math.deg(math.acos(BeastLookDirection:Dot(Direction.Unit))) * 2
                                        StartChase = Magnitude <= ChaseDistance.Value and Char.Root.AssemblyLinearVelocity.Magnitude > 0 and CharacterLib.Root.AssemblyLinearVelocity.Magnitude > 0 and Angle <= 90 and not CharacterLib:WallCheck(CharacterLib.Head.Position, Char.Head.Position) or nil
                                        StartChaseThread = nil

                                        if StartChase then
                                            Chasing = true
                                            CancelAllThreads()
                                            PlaySound(Chase, 0.5)
                                        end
                                    end)
                                elseif Chasing then
                                    if Magnitude <= ChaseDistance.Value then
                                        CancelWalkAwayThread()
                                        if LookAwayThread then task.wait(0.05) continue end
                                        LookAwayThread = task.delay(10, function()
                                            LookAwayThread = nil
                                            Chasing = false
                                            CancelAllThreads()
                                            PlaySound(Layer3, 0.5)
                                        end)
                                    else
                                        if WalkAwayThread then task.wait(0.05) continue end
                                        WalkAwayThread = task.delay(3, function()
                                            WalkAwayThread = nil
                                            Chasing = false
                                            CancelAllThreads()
                                            PlaySound(Layer3, 0.5)
                                        end)
                                    end
                                else
                                    CancelAllThreads()
                                    Chasing = false
                                    if Magnitude <= Layer3Distance.Value then
                                        PlaySound(Layer3, 0.5)
                                    elseif Magnitude <= Layer2Distance.Value then
                                        PlaySound(Layer2, 0.5)
                                    elseif Magnitude <= Layer1Distance.Value then
                                        PlaySound(Layer1, 0.5)
                                    else
                                        StopCurrentSound(0.5)
                                    end
                                end
                            else
                                StopCurrentSound(0.5)
                                CancelAllThreads()
                            end
                        else
                            StopCurrentSound(0.5)
                            CancelAllThreads()
                        end
                        task.wait(0.05)
                    end
                else
                    CancelAllThreads()
                    if Music then
                        Music.Volume = 0.4
                        Music = nil
                    end
                    for _, v in {Layer1, Layer2, Layer3, Chase} do
                        v:Stop()
                        v:Destroy()
                    end
                    Layer1, Layer2, Layer3, Chase, CurrentlyPlaying = nil, nil, nil, nil, nil
                end
            end,
        })

        Volume = TerrorRadius:CreateSlider({
            Name = 'Volume',
            Default = 0.4,
            Min = 0,
            Max = 10,
            Decimal = 100,
            Function = function(Val)
                if CurrentlyPlaying then
                    CurrentlyPlaying.Volume = Val
                end
            end
        })

        Layer1Distance = TerrorRadius:CreateSlider({
            Name = 'Layer 1 Distance',
            Default = 40,
            Min = 20,
            Max = 60,
            Decimal = 10,
        })

        Layer2Distance = TerrorRadius:CreateSlider({
            Name = 'Layer 2 Distance',
            Default = 30,
            Min = 15,
            Max = 50,
            Decimal = 10,
        })

        Layer3Distance = TerrorRadius:CreateSlider({
            Name = 'Layer 3 Distance',
            Default = 20,
            Min = 10,
            Max = 40,
            Decimal = 10,
        })

        ChaseDistance = TerrorRadius:CreateSlider({
            Name = 'Chase Distance',
            Default = 10,
            Min = 0,
            Max = 20,
            Decimal = 10,
        })
    end)

    Run(function() -- Bot
        local Bot, StatusLabel
        local Path = PathfindingService:CreatePath({
            AgentCanClimb = true,
            AgentRadius = 2.5,
            Costs = {
                Door = 0,
            },
        })
        local CapturedPlayers, PathfindingModifiers = {}, {}

        local function AddFreezePod(FreezePod)
            if FreezePod.Name:find("FreezePod") then
                local PodTrigger = FreezePod:WaitForChild("PodTrigger", 5)
                if not Bot.Enabled then return end
                local CapturedTorso = PodTrigger and PodTrigger:WaitForChild("CapturedTorso", 5)
                local CapturedPlayer

                local function Changed()
                    if CapturedTorso.Value then
                        local Player = Players:GetPlayerFromCharacter(CapturedTorso.Value.Parent)
                        if Player then
                            CapturedPlayer = Player
                            CapturedPlayers[#CapturedPlayers + 1] = {
                                Player = Player,
                                FreezePod = FreezePod,
                                Trigger = PodTrigger
                            }
                        end
                    elseif CapturedPlayer then
                        for i, v in CapturedPlayers do
                            if v.Player == CapturedPlayer then
                                table.remove(CapturedPlayers, i)
                                break
                            end
                        end
                    end
                end

                if CapturedTorso and Bot.Enabled then
                    CapturedTorso:GetPropertyChangedSignal("Value"):Connect(Changed)
                    Changed()
                end
            end
        end

        local function AddDoor(Door)
            if Door.Name:find("Door") then
                local DoorTrigger = Door:WaitForChild("DoorTrigger", 5)
                if DoorTrigger and Bot.Enabled then
                    local PathfindingModifier = Instance.new("PathfindingModifier")
                    PathfindingModifier.PassThrough = true
                    PathfindingModifier.Label = "Door"
                    PathfindingModifier.Parent = Door
                    PathfindingModifiers[#PathfindingModifiers + 1] = PathfindingModifier
                end
            end
        end

        local function Add(Obj)
            AddFreezePod(Obj)
            AddDoor(Obj)
        end

        local function IdentifyTask()
            if IsBeast() then
                
            else
                if #CapturedPlayers > 0 then
                    return "Save"
                elseif ReplicatedStorage.GameStatus.Value == "FIND AN EXIT" then
                    return "Exit"
                elseif ReplicatedStorage.ComputersLeft.Value > 0 then
                    return "Computer"
                end
            end
            return "None"
        end

        local function IsGameActive()
            return if IsBeast() then ReplicatedStorage.IsGameActive.Value else ReplicatedStorage.GameStatus.Value == "15 SEC HEAD START" or ReplicatedStorage.IsGameActive.Value
        end

        local function GetClosestComputers(Map)
            local Tab = {}
            for i, v in Map:GetChildren() do
                if v.Name == "ComputerTable" then
                    if v.PrimaryPart then
                        table.insert(Tab, {
                            Computer = v,
                            Magnitude = (CharacterLib.Root.Position - v.PrimaryPart.Position).Magnitude
                        })
                    else
                        warn(`Failed to find primary part for computer: "{v:GetFullName()}"`)
                    end
                end
            end

            table.sort(Tab, function(a, b)
                return a.Magnitude < b.Magnitude
            end)

            local NewTab = {}
            for i, v in Tab do
                NewTab[i] = v.Computer
            end

            return NewTab
        end

        local function GetClosestExits(Map)
            local Tab = {}
            for i, v in Map:GetChildren() do
                if v.Name == "ExitDoor" then
                    local Trigger = v:FindFirstChild("ExitDoorTrigger")
                    if Trigger then
                        table.insert(Tab, {
                            Exit = v,
                            Magnitude = (CharacterLib.Root.Position - Trigger.Position).Magnitude
                        })
                    else
                        warn(`Failed to find trigger for exit door: "{GetFullName(v)}"`)
                    end
                end
            end

            table.sort(Tab, function(a, b)
                return a.Magnitude < b.Magnitude
            end)

            local NewTab = {}
            for i, v in Tab do
                NewTab[i] = v.Exit
            end

            return NewTab
        end

        local function AnyAlive()
            local AnyAlive = false

            for _, Player in Players:GetPlayers() do
                if Player == Plr then continue end
                local Health = SafeRef(Player, {"TempPlayerStatsModule", "Health"})
                if Health and Health.Value > 0 then
                    AnyAlive = true
                    break
                end
            end

            return AnyAlive
        end

        local Tasks = {
            Save = function()
                StatusLabel.Text = `Status: Creating path to go save @{CapturedPlayers[1].Player.Name}`

                local Beast = GetBeast()
                local Char = CharacterLib:FindCharacter(Beast)

                if Char and (CapturedPlayers[1].Trigger.Position - Char.Root.Position).Magnitude > 50 then
                    Path:ComputeAsync(CharacterLib.Root.Position, CapturedPlayers[1].Trigger.Position)

                    if Path.Status == Enum.PathStatus.Success then
                        StatusLabel.Text = `Status: Successfully created path to @{CapturedPlayers[1].Player.Name}`

                        local Waypoints = Path:GetWaypoints()

                        local Success = true
                        local BeastCameBack = false

                        for i, Waypoint in Waypoints do
                            local Part = Instance.new("Part")
                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.CanQuery = false
                            Part.Material = Enum.Material.Neon
                            Part.Size = vector.create(1, 1, 1)
                            Part.Position = Waypoint.Position + vector.create(0, 0.5, 0)
                            Part.Shape = Enum.PartType.Ball
                            Part.Parent = workspace

                            StatusLabel.Text = `Status: Moving to: {Waypoint.Position}`

                            if Waypoint.Action == Enum.PathWaypointAction.Jump then
                                CharacterLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end

                            while CharacterLib.Alive and #CapturedPlayers == 0 and Bot.Enabled and (CharacterLib.Root.Position - Waypoint.Position).Magnitude > 4 do
                                if (CapturedPlayers[1].Trigger.Position - Char.Root.Position).Magnitude <= 50 then
                                    BeastCameBack = true
                                    break
                                else
                                    CharacterLib.Humanoid:MoveTo(Waypoint.Position)
                                    StatusLabel.Text = "Status: Waiting for Move to finish..."
                                end
                                task.wait()
                            end

                            Part:Destroy()

                            if BeastCameBack then
                                StatusLabel.Text = "Status: Beast went back to the freeze pod waiting for them to leave..."
                                Success = false
                                break
                            else
                                StatusLabel.Text = "Status: Move finished"

                                if i == #Waypoints then
                                    while not (Plr.PlayerGui.ScreenGui.ActionBox.Visible and Plr.PlayerGui.ScreenGui.ActionBox.Text == "Free") and #CapturedPlayers == 0 and Bot.Enabled do
                                        StatusLabel.Text = "Status: Waiting for freeze pod prompt..."
                                        task.wait()
                                    end
                                    StatusLabel.Text = "Status: Found freeze pod prompt waiting 0.25 seconds..."
                                    task.wait(0.25)
                                end
                                
                                if not Bot.Enabled or #CapturedPlayers > 0 then
                                    Success = false
                                    break
                                end
                            end
                        end

                        if Success then
                            StatusLabel.Text = `Status: Saved @{CapturedPlayers[1].Player.Name}`
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", true)
                            task.wait(0.1)
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", false)
                        end
                    end
                else
                    StatusLabel.Text = `Status: Waiting for beast to leave...`
                end
            end,
            Exit = function(Map)
                local ClosestExits = GetClosestExits(Map)

                if #ClosestExits > 0 then
                    StatusLabel.Text = `Status: Creating path to exit...`
                    Path:ComputeAsync(CharacterLib.Root.Position, ClosestExits[1].ExitDoorTrigger.Position)

                    if Path.Status == Enum.PathStatus.Success then
                        local Waypoints = Path:GetWaypoints()

                        local Success = true

                        for i, Waypoint in Waypoints do
                            local Part = Instance.new("Part")
                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.CanQuery = false
                            Part.Material = Enum.Material.Neon
                            Part.Size = vector.create(1, 1, 1)
                            Part.Position = Waypoint.Position + vector.create(0, 0.5, 0)
                            Part.Shape = Enum.PartType.Ball
                            Part.Parent = workspace

                            StatusLabel.Text = `Status: Moving to: {Waypoint.Position}`

                            if Waypoint.Action == Enum.PathWaypointAction.Jump then
                                CharacterLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end

                            while CharacterLib.Alive and #CapturedPlayers == 0 and Bot.Enabled and (CharacterLib.Root.Position - Waypoint.Position).Magnitude > 4 do
                                CharacterLib.Humanoid:MoveTo(Waypoint.Position)
                                StatusLabel.Text = "Status: Waiting for Move to finish..."
                                task.wait()
                            end

                            Part:Destroy()

                            StatusLabel.Text = "Status: Move finished"

                            if i == #Waypoints then
                                while not (Plr.PlayerGui.ScreenGui.ActionBox.Visible and Plr.PlayerGui.ScreenGui.ActionBox.Text == "Free") and #CapturedPlayers == 0 and Bot.Enabled do
                                    StatusLabel.Text = "Status: Waiting for exit door prompt..."
                                    task.wait()
                                end
                                StatusLabel.Text = "Status: Found exit door prompt waiting 0.25 seconds..."
                                task.wait(0.25)
                            end
                            
                            if not Bot.Enabled or #CapturedPlayers > 0 then
                                Success = false
                                break
                            end
                        end

                        local AnyPlayersAlive = AnyAlive()

                        if Success then
                            StatusLabel.Text = `Status: Opening exit door...`
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", true)
                            task.wait(0.1)
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", false)

                            if AnyPlayersAlive then
                                StatusLabel.Text = `Status: Waiting for everyone to leave...`
                                repeat
                                    AnyPlayersAlive = AnyAlive()
                                    task.wait(0.05)
                                until not AnyPlayersAlive

                                StatusLabel.Text = `Status: Leaving...`
                                CharacterLib.Humanoid:MoveTo(ClosestExits[1].ExitArea.Position)
                            else
                                StatusLabel.Text = `Status: Leaving...`
                                CharacterLib.Humanoid:MoveTo(ClosestExits[1].ExitArea.Position)
                            end
                        end
                    end
                end
            end,
            Computer = function(Map)
                StatusLabel.Text = "Status: Finding closest computers..."
                local ClosestComputers = GetClosestComputers(Map)

                local Trigger
                local Found = false

                for _, v in ClosestComputers do
                    local Screen = v:FindFirstChild("Screen")
                    if Screen and Screen.Color == Color3.fromRGB(40, 127, 71) or not Screen then continue end
                    for i = 1, 3 do
                        local Taken = false
                        for _, Char in CharacterLib.List do
                            if (Char.Root.Position - v[`ComputerTrigger{i}`].Position).Magnitude < 3 then
                                Taken = true
                            end
                        end
                        if not Taken then
                            Trigger = v[`ComputerTrigger{i}`]
                            Found = true
                            break
                        end
                    end
                    if Found then break end
                end

                if Trigger and (CharacterLib.Root.Position - Trigger.Position).Magnitude > 0.5 then
                    StatusLabel.Text = `Status: Creating path to  closest computer...`
                    Path:ComputeAsync(CharacterLib.Root.Position, Trigger.Position)

                    if Path.Status == Enum.PathStatus.Success then
                        StatusLabel.Text = "Status: Successfully created path"
                        local Success = true
                        local Waypoints = Path:GetWaypoints()
                        for i, Waypoint in Waypoints do
                            local Part = Instance.new("Part")
                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.CanQuery = false
                            Part.Material = Enum.Material.Neon
                            Part.Size = vector.create(1, 1, 1)
                            Part.Position = Waypoint.Position + vector.create(0, 0.5, 0)
                            Part.Shape = Enum.PartType.Ball
                            Part.Parent = workspace

                            StatusLabel.Text = `Status: Moving to: {Waypoint.Position}`

                            if Waypoint.Action == Enum.PathWaypointAction.Jump then
                                CharacterLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end

                            while CharacterLib.Alive and #CapturedPlayers == 0 and Bot.Enabled and (CharacterLib.Root.Position - Waypoint.Position).Magnitude > 4 do
                                StatusLabel.Text = "Status: Waiting for Move to finish..."
                                CharacterLib.Humanoid:MoveTo(Waypoint.Position)
                                task.wait()
                            end

                            StatusLabel.Text = "Status: Move finished"

                            Part:Destroy()

                            if i == #Waypoints then
                                while not (Plr.PlayerGui.ScreenGui.ActionBox.Visible and Plr.PlayerGui.ScreenGui.ActionBox.Text == "Hack") and #CapturedPlayers == 0 and Bot.Enabled do
                                    StatusLabel.Text = "Status: Waiting for computer prompt..."
                                    task.wait()
                                end
                                StatusLabel.Text = "Status: Found computer prompt waiting 0.25 seconds..."
                                task.wait(0.25)
                            end
                            
                            if not Bot.Enabled or #CapturedPlayers > 0 then
                                Success = false
                                break
                            end
                        end

                        if Success then
                            StatusLabel.Text = "Status: Hacking computer"
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", true)
                            task.wait(0.1)
                            ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", false)

                            local Moved = false

                            local Con = Bot:Clean(Plr.PlayerGui.ScreenGui.TimingCircle:GetPropertyChangedSignal("Visible"):Connect(function()
                                if Plr.PlayerGui.ScreenGui.TimingCircle.Visible then
                                    local TimeOut = os.clock() + 3
                                    repeat
                                        StatusLabel.Text = `Status: Waiting for skill check to rotate: {math.floor(Plr.PlayerGui.ScreenGui.TimingCircle.TimingPin.Rotation)} / {math.floor(Plr.PlayerGui.ScreenGui.TimingCircle.TimingBase.Rotation + 10)}`
                                        task.wait()
                                    until Plr.PlayerGui.ScreenGui.TimingCircle.TimingPin.Rotation > Plr.PlayerGui.ScreenGui.TimingCircle.TimingBase.Rotation + 10 or os.clock() > TimeOut
                                    Plr.TempPlayerStatsModule.ActionInput.Value = true
                                    StatusLabel.Text = "Status: Hit skill check"
                                    task.wait(0.1)
                                    Plr.TempPlayerStatsModule.ActionInput.Value = false
                                end
                            end))
                            
                            local Con2; Con2 = Bot:Clean(Plr.PlayerGui.ScreenGui.ProgressBox:GetPropertyChangedSignal("Visible"):Connect(function()
                                if not Plr.PlayerGui.ScreenGui.ProgressBox.Visible then
                                    Con:Disconnect()
                                    Con2:Disconnect()
                                    Con, Con2 = nil, nil
                                    Moved = true
                                    StatusLabel.Text = "Status: Player walked away from computer"
                                end
                            end))

                            while not Moved and #CapturedPlayers == 0 do
                                task.wait()
                            end

                            if #CapturedPlayers > 0 then
                                if Con then
                                    Con:Disconnect()
                                    Con = nil
                                end
                                if Con2 then
                                    Con2:Disconnect()
                                    Con2 = nil
                                end
                            end
                        end
                    else
                        StatusLabel.Text = "Status: Failed to create path"
                    end
                else
                    StatusLabel.Text = "Status: Failed to find computer"
                end
            end,
        }

        Bot = Other:CreateModule({
            Name = "Bot",
            Info = "Attemps to play the game for you. Currently only works for survivor. (Experimental)",
            Enabled = function()
                StatusLabel = Instance.new("TextLabel")
                StatusLabel.BackgroundTransparency = 1
                StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                StatusLabel.TextSize = 18
                StatusLabel.Position = UDim2.new(0.5, 0, 0, 100)
                StatusLabel.Text = "Status: None"
                StatusLabel.FontFace = TidalWave.Fonts.SemiBold.Font
                StatusLabel.Parent = TidalWave.Gui

                while Bot.Enabled do
                    table.clear(CapturedPlayers)
                    for _, v in PathfindingModifiers do
                        v:Destroy()
                    end
                    table.clear(PathfindingModifiers)
                    while not CharacterLib.Alive do
                        task.wait()
                    end

                    local Map
                    repeat
                        Map = GetMap()
                        StatusLabel.Text = "Status: Waiting for map..."
                        task.wait(0.1)
                    until Map or not Bot.Enabled

                    StatusLabel.Text = "Status: Found map"

                    if not Bot.Enabled then break end

                    while not IsGameActive() do
                        StatusLabel.Text = "Status: Waiting for game to start..."
                        task.wait(0.1)
                    end

                    if not Bot.Enabled then break end

                    for _, v in Map:GetChildren() do
                        task.spawn(Add, v)
                    end
                    Bot:Clean(Map.ChildAdded:Connect(Add))

                    while IsGameActive() and Bot.Enabled do
                        if not CharacterLib.Alive then task.wait() continue end
                        StatusLabel.Text = "Status: Identifiying task..."
                        local Task = IdentifyTask()
                        StatusLabel.Text = `Status: Identified task: {Task}`
                        if Tasks[Task] then
                            StatusLabel.Text = `Status: Running task: {Task}`
                            Tasks[Task](Map)
                        end
                        task.wait()
                    end
                end

                for _, v in PathfindingModifiers do
                    v:Destroy()
                end
                table.clear(PathfindingModifiers)
                table.clear(CapturedPlayers)

                StatusLabel:Destroy()
                StatusLabel = nil
            end
        })
    end)
end)