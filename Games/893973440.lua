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
local TweenService: TweenService = GetService("TweenService")

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

local function SafeRef(Obj, Ref)
    if not Obj then return nil end
    
    for _, v in Ref do
        local NewObj = if typeof(v) == "string" then Obj:FindFirstChild(v) else if v[2] then Obj:FindFirstChildWhichIsA(v[1]) else Obj:FindFirstChildOfClass(v[1])
        if NewObj then
            Obj = NewObj
        else
            return nil
        end
    end

    return Obj
end

Run(function()
    function CharacterLib:IsTeammate(Character)
        if TidalWave:IsFriend(Character.Player) then return true end
        return if CharacterLib.Alive and CharacterLib.Character:FindFirstChild("Hammer") == nil then Character.Character:FindFirstChild("Hammer") == nil else false
    end

    function CharacterLib:GetTeamColor(Character)
        local IsFriend, FriendColor = TidalWave:IsFriend(Character.Player)
        return IsFriend and FriendColor or CharacterLib:IsTeammate(Character) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end

    function CharacterLib:GetUpdateConnections(Char)
        return {
            Char.Humanoid:GetPropertyChangedSignal("Health"),
            Char.Humanoid:GetPropertyChangedSignal("MaxHealth")
        }
    end
    
    function CharacterLib:GetTeamUpdateConnections(Char)
        return {
            Char.Character.ChildAdded,
            Char.Character.ChildRemoved
        }
    end

    TidalWave:Clean(CharacterLib.Events.LocalAdded:Connect(function()
        CharacterLib:Refresh()
    end))

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
    end)
end)

Run(function() -- Player
    Run(function() -- BeastCrouch
        local BeastCrouch

        local function OnCharacterAdded(Char)
            local CrawlScript = Char.Character:WaitForChild("CrawlScript", 10)
            if CrawlScript and BeastCrouch.Enabled then
                CrawlScript.Enabled = true
                BeastCrouch:Clean(CrawlScript:GetPropertyChangedSignal("Enabled"):Connect(function()
                    CrawlScript.Enabled = true
                end))
            end
        end

        BeastCrouch = PlayerCategory:CreateModule({
            Name = "BeastCrouch",
            Info = "Allows you to crouch as the beast",
            Function = function(Enabled)
                if Enabled then
                    if CharacterLib.Alive then
                        OnCharacterAdded(CharacterLib)
                    end
                    BeastCrouch:Clean(CharacterLib.Events.LocalAdded:Connect(OnCharacterAdded))
                else
                    local CrawlScript = CharacterLib.Alive and CharacterLib.Character:FindFirstChild("CrawlScript")
                    if CrawlScript then
                        CrawlScript.Enabled = CharacterLib.Character:FindFirstChild("Hammer") == nil
                    end
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
                    task.wait(0.1)
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
            
        end

        local function Disconnect()
            if ChildAdded then
                ChildAdded:Disconnect()
                ChildAdded = nil
            end
            if ChildRemoved then
                ChildRemoved = nil
                ChildRemoved:Disconnect()
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

                    ComputerESP:Clean(workspace.DescendantAdded:Connect(DescendantAdded))
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
                        task.spawn(DescendantAdded, v)
                    end
                else
                    Folder:Destroy()
                    Folder = nil
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
        local CustomBeastMusic, Volume, MusicId, SoundObject, RollOffMinDistance, RollOffMaxDistance

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

            if not Music then
                local TimeOut = os.clock() + 5
                repeat
                    Music = SafeRef(Character.Character, {"Hammer", "Handle", "SoundChaseMusic"})
                    task.wait()
                until Music or not CustomBeastMusic.Enabled or os.clock() >= TimeOut
            end

            if Music and CustomBeastMusic.Enabled then
                SoundObject = Music
                SoundObject.Volume = Volume.Value
                SetId()
            end
        end

        CustomBeastMusic = Other:CreateModule({
            Name = "CustomBeastMusic",
            Info = "Allows you to change the beast music volume and set a custom ID.\nDefault beast music id is 1846863084.",
            Function = function(Enabled)
                if Enabled then
                    if TidalWave.Modules.ChaseMusic.Enabled then
                        TidalWave.Modules.ChaseMusic:Toggle(true)
                    end
                    for _, Character in CharacterLib.List do
                        task.spawn(OnCharacterAdded, Character)
                    end
                    CustomBeastMusic:Clean(CharacterLib.Events.CharacterAdded:Connect(OnCharacterAdded))
                else
                    SetId("rbxassetid://1846863084")
                    SoundObject = nil
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
            Costs = {
                Door = 0,
            },
        })
        local CapturedPlayers, PathfindingModifiers = {}, {}
        
        local function AddFreezePod(FreezePod)
            if FreezePod.Name == "FreezePod" then
                local PodTrigger = FreezePod:WaitForChild("PodTrigger", 5)
                if not Bot.Enabled then return end
                local CapturedTorso = PodTrigger and PodTrigger:WaitForChild("CapturedTorso", 5)
                local CapturedPlayer

                local function Changed()
                    if CapturedTorso.Value then
                        local Player = Players:GetPlayerFromCharacter(CapturedTorso.Value.Parent)
                        if Player then
                            CapturedPlayer = Player
                            table.insert(CapturedPlayers, Player)
                        end
                    elseif CapturedPlayer then
                        local Index = table.find(CapturedPlayers, CapturedPlayer)
                        if Index then
                            table.remove(CapturedPlayers, Index)
                        end
                    end
                end

                if PodTrigger and Bot.Enabled then
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
                    table.insert(PathfindingModifiers, PathfindingModifier)
                end
            end
        end

        local function Add(Obj)
            AddFreezePod(Obj)
            AddDoor(Obj)
        end

        local function IdentifyTask()
            if #CapturedPlayers > 0 then
                return "Save"
            elseif ReplicatedStorage.GameStatus.Value == "FIND AN EXIT" then
                return "Exit"
            elseif ReplicatedStorage.ComputersLeft.Value > 0 then
                return "Computer"
            end
            return "None"
        end

        local function IsGameActive()
            return ReplicatedStorage.GameStatus.Value == "15 SEC HEAD START" or ReplicatedStorage.IsGameActive.Value
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

        local function MoveTo(Goal)
            local Tab = {Completed = false}

            local Con; Con = Bot:Clean(RunService.Heartbeat:Connect(function(Delta)
                local ModdedRootPos = Vector3.new(CharacterLib.Root.Position.X, 0, CharacterLib.Root.Position.Z)
                local ModdedGoal = Vector3.new(Goal.X, 0, Goal.Z)
                local Direction = ModdedGoal - ModdedRootPos
                
                if Direction.Magnitude <= 0.5 then
                    Con:Remove()
                    Tab.Completed = true
                    return
                end

                CharacterLib.Root.CFrame = CFrame.lookAt(CharacterLib.Root.Position, Vector3.new(Goal.X, CharacterLib.Root.Position.Y, Goal.Z))
                CharacterLib.Character:TranslateBy((Direction.Unit * CharacterLib.Humanoid.WalkSpeed) * Delta)
                StatusLabel.Text = `Status: Moving {(Direction.Unit * CharacterLib.Humanoid.WalkSpeed) * Delta}`
            end))

            return Tab
        end

        local Tasks = {
            Save = function()
                
            end,
            Exit = function()
                
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
                        for _, Player in Players:GetPlayers() do
                            local Character = CharacterLib:FindCharacter(Player)
                            if Character and (Character.Root.Position - v[`ComputerTrigger{i}`].Position).Magnitude > 3 then
                                Trigger = v[`ComputerTrigger{i}`]
                                Found = true
                                break
                            end
                        end
                        if Found then break end
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
                            Part.Size = Vector3.new(1, 1, 1)
                            Part.Position = Waypoint.Position + Vector3.new(0, 0.5, 0)
                            Part.Shape = Enum.PartType.Ball
                            Part.Parent = workspace

                            StatusLabel.Text = `Status: Moving to: {Waypoint.Position}`

                            local MoveStatus = MoveTo(Waypoint.Position)
                            if Waypoint.Action == Enum.PathWaypointAction.Jump then
                                CharacterLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end

                            while CharacterLib.Alive and #CapturedPlayers == 0 and Bot.Enabled and not MoveStatus.Completed do
                                StatusLabel.Text = "Status: Waiting for move to finish..."
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
                                    Moved = true
                                    StatusLabel.Text = "Status: Player walked away from computer"
                                end
                            end))

                            while not Moved and #CapturedPlayers == 0 do
                                task.wait()
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
            Info = "Attemps to play the game for you. (Experimental)",
            Enabled = function()
                StatusLabel = Instance.new("TextLabel")
                StatusLabel.BackgroundTransparency = 1
                StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                StatusLabel.TextSize = 18
                StatusLabel.Position = UDim2.new(0.5, 0, 0, 100)
                StatusLabel.Text = "Status: None"
                StatusLabel.FontFace = TidalWave.Fonts.SemiBold.Font
                StatusLabel.Parent = TidalWave.Gui

                Bot:Clean(StatusLabel)
                Bot:Clean(function()
                    table.clear(CapturedPlayers)
                    for i, v in PathfindingModifiers do
                        v:Destroy()
                    end
                    table.clear(PathfindingModifiers)
                end)

                while Bot.Enabled do
                    table.clear(CapturedPlayers)
                    for i, v in PathfindingModifiers do
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

                    for i, v in Map:GetChildren() do
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
            end
        })
    end)
end)