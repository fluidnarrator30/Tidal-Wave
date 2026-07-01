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

local getcustomasset = getcustomasset
local fireclickdetector = fireclickdetector

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
    
    for i, v in Ref do
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
        local ComputerESP, OutlineTransparency, FillTransparency, Folder

        local function DescendantAdded(Child)
            if Child.Name == "ComputerTable" then
                local Screen = Child:WaitForChild("Screen", 5)
                if not ComputerESP.Enabled then return end
                local BillboardGui = Child:WaitForChild("BillboardGui", 5)
                if BillboardGui and ComputerESP.Enabled then
                    local Highlight = Instance.new("Highlight")
                    Highlight.OutlineColor = Screen.BrickColor ~= BrickColor.Red() and Screen.Color or Color3.fromRGB(13, 105, 172)
                    Highlight.FillColor = Screen.BrickColor ~= BrickColor.Red() and Screen.Color or Color3.fromRGB(13, 105, 172)
                    Highlight.OutlineTransparency = OutlineTransparency.Value
                    Highlight.FillTransparency = FillTransparency.Value
                    Highlight.Adornee = Child
                    Highlight.Parent = Folder
                end
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

                    ComputerESP:Clean(workspace.DescendantAdded:Connect(DescendantAdded))
                    for _, v in workspace:QueryDescendants("Model#ComputerTable") do
                        DescendantAdded(v)
                    end
                else
                    if Folder then
                        Folder:Destroy()
                        Folder = nil
                    end
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

        RollOffMinDistance = CustomBeastMusic:CreateSlider({
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