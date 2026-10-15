local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

const Players: Players = GetService('Players')
const RunService: RunService = GetService('RunService')
const ReplicatedStorage: ReplicatedStorage = GetService('ReplicatedStorage')
const PathfindingService: PathfindingService = GetService('PathfindingService')
const TweenService: TweenService = GetService('TweenService')
const UIS: UserInputService = GetService('UserInputService')

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local Modules = TidalWave.Modules
local Libraries = TidalWave.Libraries
local EntityLib = Libraries.EntityLib
local ObjectFunctions = Libraries.ObjectFunctions
local Signal = Libraries.Signal
local Whitelist = Libraries.Whitelist

const Plr: Player = Players.LocalPlayer
local Camera: Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera')

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other

const vector = table.clone(vector)
vector.xAxis = vector.create(1, 0, 0)
vector.yAxis = vector.create(0, 1, 0)
vector.zAxis = vector.create(0, 0, 1)
vector.hort = vector.create(1, 0, 1)
vector.huge = vector.create(math.huge, math.huge, math.huge)
vector.hugeX = vector.create(math.huge, 0, 0)
vector.hugeY = vector.create(0, math.huge, 0)
vector.hugeZ = vector.create(0, 0, math.huge)
vector.hugeXZ = vector.create(math.huge, 0, math.huge)

const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)

TidalWave:Clean(workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
    Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera')
end))

local function Notify(Properties)
    TidalWave:Notify(Properties)
end

local function NotifyPoopSploit(Function)
    Notify({
        Title = 'Poop Sploit',
        Text = `Your executor doesn't support '{Function}'`,
        Type = 'Error',
        Duration = 5,
    })
end

local function Run(f)
    f()
end

local function SafeRef(Obj, Path)
    return ObjectFunctions:SafeRef(Obj, Path)
end

local function GetBeast(): Player?
    for _, Entity in EntityLib.List do
		if Entity.Beast then
			return Entity.Player
		end
	end

	return nil
end

local Events = setmetatable({}, {
    __index = function(self, i)
        self[i] = Signal.new()
        return self[i]
    end
})

TidalWave:Clean(function()
	for i, v in Events do
		v:DisconnectAll()
	end
	table.clear(Events)
end)

local Stats
local Map
local RemoteEvent

Run(function()
    Stats = Plr:FindFirstChild('TempPlayerStatsModule')
    RemoteEvent = ReplicatedStorage:FindFirstChild('RemoteEvent')

    if not (Stats and RemoteEvent) then
        repeat
            task.wait()
            Stats = Plr:FindFirstChild('TempPlayerStatsModule')
            RemoteEvent = ReplicatedStorage:FindFirstChild('RemoteEvent')
        until (Stats and RemoteEvent) or not shared.TidalWave

        if shared.TidalWave == nil then return end
    end

    local CurrentMap = ReplicatedStorage.CurrentMap

    TidalWave:Clean(CurrentMap:GetPropertyChangedSignal('Value'):Connect(function()
        if CurrentMap.Value then
            Map = CurrentMap.Value
            Events.MapAdded:Fire(Map)
        elseif Map then
            Events.MapRemoved:Fire(Map)
            Map = nil
        end
    end))

    if CurrentMap.Value then
        Map = CurrentMap.Value
    end
end)

Run(function()
	function EntityLib:GetEntityComponents(Entity)
		const Stats = Entity.Player:WaitForChild('TempPlayerStatsModule', 10)
		const IsBeast = Stats and Stats:WaitForChild('IsBeast', 10)

		if Stats and IsBeast then
			return {
				Stats = Stats,
				Beast = IsBeast.Value
			}
		end

		return nil
	end

    function EntityLib:IsTeammate(Entity)
        if TidalWave:IsFriend(Entity.Player) then return true end
    	if not select(2, Whitelist:Get(Entity.Player)) then return true end

        return Entity.Beast == Stats.IsBeast.Value
    end

    function EntityLib:GetEntityColor(Entity)
        if TidalWave.Menus.Friends.Options.UseFriends.Enabled then
            local FriendColor = TidalWave:GetFriendColor(Entity.Player)
            if FriendColor then
                return FriendColor
            end
        end

        return Entity.Teammate and Color3.Green or Color3.Red
    end

    function EntityLib:GetUpdateConnections(Entity)
        return {
            Entity.Stats.Health:GetPropertyChangedSignal('Value'),
			Entity.Stats.IsBeast:GetPropertyChangedSignal('Value')
        }
    end

	function EntityLib:GetTeamUpdateConnections(Entity)
		return {
			Entity.Stats.IsBeast:GetPropertyChangedSignal('Value')
		}
	end

    function EntityLib:GetEntityProperties(Entity)
        return {
            Health = Entity.Beast and 100 or Entity.Stats.Health.Value,
            MaxHealth = 100
        }
    end

    EntityLib:Restart()
end)

Run(function() -- Combat
	Run(function() -- KillAura
		local KillAura, Range, WallCheck
		
		KillAura = Combat:CreateModule({
		    Name = 'KillAura',
		    Info = 'Automatically attacks players around you',
		    Enabled = function()
		        repeat
		            if EntityLib.Alive and Stats.IsBeast.Value then
		                local Entity = EntityLib:GetClosestEntity({
		                    Range = Range.Value,
		                    WallCheck = WallCheck.Enabled,
		                    Players = true,
		                    NPCs = false
		                })
		
		                if Entity then
		                    local Hammer = EntityLib:FindFirstChild('Hammer')
		                    local HammerEvent = Hammer and Hammer:FindFirstChild('HammerEvent')
		                    if HammerEvent then
		                        HammerEvent:FireServer('HammerHit', Entity.Root)
		                    end
		                end
		            end
		            
		            task.wait(0.05)
		        until not KillAura.Enabled
		    end,
		})
		
		Range = KillAura:CreateSlider({
		    Name = 'Range',
		    Default = 5,
		    Min = 1,
		    Max = 10
		})
		
		WallCheck = KillAura:CreateToggle({
		    Name = 'Wall Check',
		    Default = true
		})
	end)
end)

Run(function() -- Player
	Run(function() -- BeastCrawl
		local BeastCrawl
		
		local ModifiedParts = {}
		
		BeastCrawl = PlayerCategory:CreateModule({
		    Name = 'BeastCrawl',
		    Info = 'Allows you to crawl as the beast',
		    Function = function(Enabled)
		        if Enabled then
		            Stats.DisableCrawl.Value = false
		            Stats.DisableCrawl:GetPropertyChangedSignal('Value'):Connect(function()
		                Stats.DisableCrawl.Value = false
		            end)
		
		            BeastCrawl:Clean(workspace.DescendantAdded:Connect(function(Child)
		                if Child:IsA('BasePart') and Child.CollisionGroup == 'VENT' and Child.CanCollide then
		                    Child.CanCollide = false
		                    ModifiedParts[Child] = true
		                end
		            end))
		
		            for _, Part in workspace:QueryDescendants('BasePart[CollisionGroup = VENT][CanCollide = true]') do
		                Part.CanCollide = false
		                ModifiedParts[Part] = true
		            end
		        else
		            Stats.DisableCrawl.Value = Stats.IsBeast.Value
		
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
	Run(function() -- NoSlowdown
		local NoSlowdown
		
		local Connection
		
		local function LocalAdded()
		    const TimeOut = os.clock() + 5
		    repeat
		        for _, Con in getconnections(UIS.JumpRequest) do
		            if Con.Function and debug.info(Con.Function, 's'):find('PowersLocalScript') then
		                Connection = Con
		                Connection:Disable()
		                break
		            end
		        end
		
		        task.wait()
		    until Connection or not NoSlowdown.Enabled or os.clock() >= TimeOut
		end
		
		NoSlowdown = Movement:CreateModule({
		    Name = 'NoSlowdown',
		    Info = 'Prevents you from slowing down after jumping',
		    Function = function(Enabled)
		        if Enabled then
		            if not getconnections then NotifyPoopSploit('getconnections'); return end
		
		            NoSlowdown:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		
		            if EntityLib.Alive then
		                LocalAdded()
		            end
		        else
		            if Connection then
		                Connection:Enable()
		                Connection = nil
		            end
		        end
		    end
		})
	end)
end)

Run(function() -- Visuals
	Run(function() -- ComputerESP
		local ComputerESP, OutlineTransparency, FillTransparency
		
		local Folder
		local Highlights = {}
		
		const Red = BrickColor.Red()
		const ScreenColor = Color3.fromRGB(13, 105, 172)
		
		local function ComputerAdded(Computer)
		    local TimeOut = os.clock() + 5
		    local Screen
		    local BillboardGui
		
		    repeat
		        Screen = Computer:FindFirstChild('Screen')
		        BillboardGui = Screen and Screen:FindFirstChild('BillboardGui')
		        task.wait()
		    until (Screen and BillboardGui) or not ComputerESP.Enabled or os.clock() >= TimeOut
		
		    if Screen and BillboardGui and ComputerESP.Enabled then
		        local Highlight = Instance.new('Highlight')
		        Highlight.OutlineColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
		        Highlight.FillColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		        Highlight.Adornee = Computer
		        Highlight.Parent = Folder
		        
		        Highlights[Computer] = {
		            Connection = ComputerESP:Clean(Screen:GetPropertyChangedSignal('Color'):Connect(function()
		                Highlight.OutlineColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
		                Highlight.FillColor = Screen.BrickColor ~= Red and Screen.Color or ScreenColor
		            end)),
		            Highlight = Highlight
		        }
		    end
		end

		local function MapAdded()
			ComputerESP:Clean(Map.ChildAdded:Connect(function(Obj)
				if Obj.Name == 'ComputerTable' then
					ComputerAdded(Obj)
				end
			end))

			for _, Obj in Map:GetChildren() do
				if Obj.Name == 'ComputerTable' then
					ComputerAdded(Obj)
				end
			end
		end

		local function MapRemoved()
			ComputerESP:CleanUp()
			Folder:ClearAllChildren()
			table.clear(Highlights)
		end

		local function UpdateHighlights()
			for _, Tab in Highlights do
				Tab.Highlight.OutlineTransparency = OutlineTransparency.Value
				Tab.Highlight.FillTransparency = FillTransparency.Value
			end
		end
		
		ComputerESP = Visuals:CreateModule({
		    Name = 'ComputerESP',
		    Info = 'Renders computers through walls',
		    Function = function(Enabled)
		        if Enabled then
		            Folder = Instance.new('Folder')
		            Folder.Name = 'Computer_ESP'
		            Folder.Parent = TidalWave.Gui

					if Map then
						MapAdded()
					end
		
		            ComputerESP:Clean(Events.MapAdded:Connect(MapAdded))
					ComputerESP:Clean(Events.MapRemoved:Connect(MapRemoved))
		            ComputerESP:Clean(workspace.DescendantRemoving:Connect(function(Obj)
		                if Obj.Name == 'ComputerTable' then
		                    for i, v in Highlights do
		                        if i == Obj then
		                            v.Connection:Disconnect()
		                            v.Highlight:Destroy()
		                            Highlights[i] = nil
		                            
		                            break
		                        end
		                    end
		                end
		            end))
		
		            for _, Computer in workspace:QueryDescendants('Model#ComputerTable') do
		                task.spawn(ComputerAdded, Computer)
		            end
		        else
		            Folder:Destroy()
		            Folder = nil
		            table.clear(Highlights)
		        end
		    end
		})
		
		OutlineTransparency = ComputerESP:CreateSlider({
		    Name = 'Outline Transparency',
		    Default = 0,
		    Min = 0,
		    Max = 1,
		    Decimal = 100,
		    Function = UpdateHighlights
		})
		
		FillTransparency = ComputerESP:CreateSlider({
		    Name = 'Fill Transparency',
		    Default = 0.5,
		    Min = 0,
		    Max = 1,
		    Decimal = 100,
		    Function = UpdateHighlights
		})
	end)
end)

Run(function() -- World
	Run(function() -- ClickIceButton
		World:CreateButton({
		    Name = 'Click Ice Button',
		    Info = 'Clicks the ice button on abandoned facility maximus',
		    Function = function()
		        if not fireclickdetector then NotifyPoopSploit('fireclickdetector'); return end
		
		        local Button = Map and Map:FindFirstChild('Button')
		        local ClickDetector = Button and Button:FindFirstChildOfClass('ClickDetector')
		        if ClickDetector then
		            fireclickdetector(ClickDetector)
		        end
		    end,
		})
	end)

	Run(function() -- InfiniteIceButtonRange
		local InfiniteIceButtonRange
		
		local ClickDetector
		
		local function MapAdded()
		    local Button = Map:FindFirstChild('Button')
		    ClickDetector = Button and Button:FindFirstChildOfClass('ClickDetector') or nil
		    if ClickDetector then
		        ClickDetector.MaxActivationDistance = math.huge
		    end
		end
		
		InfiniteIceButtonRange = World:CreateModule({
		    Name = 'InfiniteIceButtonRange',
		    Info = 'You can click ice button from very far away :D',
		    Function = function(Enabled)
		        if Enabled then
		            InfiniteIceButtonRange:Clean(Events.MapAdded:Connect(MapAdded))
		
		            if Map then
		                MapAdded()
		            end
		        else
		            if ClickDetector then
		                ClickDetector.MaxActivationDistance = 20
		                ClickDetector = nil
		            end
		        end
		    end,
		})
	end)
end)

Run(function() -- Other
	Run(function() -- AutoBlock
		local AutoBlock
		        
		local LastTouched
		
		local function Touched(Part, AlreadyTouched)
		    local TriggerEvent = Part:FindFirstChild('Event')
		    if TriggerEvent then
		        LastTouched = Part
		
		        if not AlreadyTouched then
		            local ActionBox = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'ActionBox'})
		            if ActionBox then
		                ActionBox:GetPropertyChangedSignal('Visible'):Wait()
		                task.wait(0.05)
		            else
		                task.wait(0.35)
		            end
		        end
		                    
		        repeat
		            RemoteEvent:FireServer('Input', 'Action', true)
		
		            task.wait(1)
		
		            if not LastTouched or not AutoBlock.Enabled then break end
		
		            RemoteEvent:FireServer('Input', 'Trigger', false, TriggerEvent)
		
		            local ActionBox = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'ActionBox'})
		            if ActionBox then
		                ActionBox:GetPropertyChangedSignal('Visible'):Wait()
		            else
		                task.wait(0.3)
		            end
		
		            if not LastTouched or not AutoBlock.Enabled then break end
		
		            RemoteEvent:FireServer('Input', 'Trigger', true, TriggerEvent)
		        until not LastTouched or not AutoBlock.Enabled
		    end
		end
		
		local function TouchEnded(Part)
		    if Part == LastTouched then
		        LastTouched = nil
		    end
		end
		
		local function LocalAdded()
		    AutoBlock:Clean(EntityLib.Root.Touched:Connect(Touched))
		    AutoBlock:Clean(EntityLib.Root.TouchEnded:Connect(TouchEnded))
		end
		
		local function LocalRemoved()
		    AutoBlock:CleanUp()
		end
		
		AutoBlock = Other:CreateModule({
		    Name = 'AutoBlock',
		    Info = 'Automatically blocks the closest door',
		    Function = function(Enabled)
		        if Enabled then
		            AutoBlock:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		            AutoBlock:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
		
		            if EntityLib.Alive then
		                LocalAdded()
		
		                local TouchingParts = EntityLib.Root:GetTouchingParts()
		                for _, Part in TouchingParts do
		                    if Part.Name == 'DoorTrigger' then
		                        Touched(Part, true)
		                        break
		                    end
		                end
		            end
		        else
		            LastTouched = nil
		        end
		    end
		})
	end)

	Run(function() -- AutoSkillCheck
		local AutoSkillCheck
		
		AutoSkillCheck = Other:CreateModule({
		    Name = 'AutoSkillCheck',
		    Info = 'Automatically hits computer skill checks for you',
		    Function = function(Enabled)
		        if Enabled then
		            local TimingCircle = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'TimingCircle'})
		            local ProgressBox = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'ProgressBox'})
		
		            if not (TimingCircle and ProgressBox) then
		                repeat
		                    task.wait()
		                    TimingCircle = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'TimingCircle'})
		                    ProgressBox = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'ProgressBox'})
		                until (TimingCircle and ProgressBox) or not AutoSkillCheck.Enabled
		
		                if not (AutoSkillCheck.Enabled and TimingCircle and ProgressBox) then return end
		            end
		
		            AutoSkillCheck:Clean(TimingCircle:GetPropertyChangedSignal('Visible'):Connect(function()
		                if TimingCircle.Visible then
		                    local TimeOut = os.clock() + 3
		                    repeat
		                        task.wait()
		                    until TimingCircle.TimingPin.Rotation > TimingCircle.TimingBase.Rotation + 10 or os.clock() > TimeOut or not AutoSkillCheck.Enabled
		
		                    Stats.ActionInput.Value = true
		                    task.wait(0.1)
		                    Stats.ActionInput.Value = false
		                end
		            end))
		        end
		    end
		})
	end)

	Run(function() -- BeastMusicModifier
		local BeastMusicModifier, Volume, SoundId, RollOffMinDistance, RollOffMaxDistance, HeartbeatVolume
		
		local SoundObject, HeartbeatObject
		
		local function EntityAdded(Entity)
		    if Entity.Beast then
		        SoundObject = SafeRef(Entity.Character, {'Hammer', 'Handle', 'SoundChaseMusic'})
		        HeartbeatObject = SafeRef(Entity.Character, {'Hammer', 'Handle', 'SoundHeartBeat'})
		
		        if not (SoundObject and HeartbeatObject) then
		            local TimeOut = os.clock() + 5
		            repeat
		                SoundObject = SafeRef(Entity.Character, {'Hammer', 'Handle', 'SoundChaseMusic'})
		                HeartbeatObject = SafeRef(Entity.Character, {'Hammer', 'Handle', 'SoundHeartBeat'})
		                task.wait()
		            until (SoundObject and HeartbeatObject) or not BeastMusicModifier.Enabled or os.clock() >= TimeOut
		
		            if not (BeastMusicModifier.Enabled and SoundObject and HeartbeatObject) then return end
		        end
		
		        if not Modules.TerrorRadius.Enabled then
		            SoundObject.Volume = Volume.Value
		            SoundObject.SoundId = SoundId.Value
		            SoundObject.RollOffMinDistance = RollOffMinDistance.Value
		            SoundObject.RollOffMaxDistance = RollOffMaxDistance.Value
		        end
		
		        HeartbeatObject.Volume = HeartbeatVolume.Value
		    end
		end
		
		BeastMusicModifier = Other:CreateModule({
		    Name = 'BeastMusicModifier',
		    Info = 'Allows you to change the beast music sound id',
		    Function = function(Enabled)
		        if Enabled then
		            BeastMusicModifier:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
		
		            local Beast = GetBeast()
		            local Entity = Beast and EntityLib:FindEntity(Beast) or nil
		
		            if Entity then
		                EntityAdded(Entity)
		            end
		        else
		            if SoundObject then
		                SoundObject.SoundId = 'rbxassetid://1846863084'
		                SoundObject.RollOffMinDistance = 10
		                SoundObject.RollOffMaxDistance = 30
		                SoundObject = nil
		            end
		
		            if HeartbeatObject then
		                HeartbeatObject.Volume = 1.9
		                HeartbeatObject = nil
		            end
		        end
		    end,
		})
		
		SoundId = BeastMusicModifier:CreateAssetTextBox({
		    Name = 'Sound Id',
		    Default = 'rbxassetid://1846863084',
		    Placeholder = '[rbxassetid://1234567890]',
		    Function = function(Asset)
		        if Modules.TerrorRadius.Enabled then return end
		        SoundObject.SoundId = Asset
		    end
		})
		
		Volume = BeastMusicModifier:CreateSlider({
		    Name = 'Volume',
		    Default = 0.4,
		    Min = 0,
		    Max = 10,
		    Decimal = 100,
		    Function = function(Val)
		        if SoundObject and not Modules.TerrorRadius.Enabled then
		            SoundObject.Volume = Val
		        end
		    end
		})
		
		RollOffMinDistance = BeastMusicModifier:CreateSlider({
		    Name = 'Roll Off Min Distance',
		    Default = 10,
		    Min = 0,
		    Max = 50,
		    Function = function(Val)
		        if SoundObject and not Modules.TerrorRadius.Enabled then
		            SoundObject.RollOffMinDistance = Val
		        end
		    end
		})
		
		RollOffMaxDistance = BeastMusicModifier:CreateSlider({
		    Name = 'Roll Off Max Distance',
		    Default = 30,
		    Min = 0,
		    Max = 100,
		    Function = function(Val)
		        if SoundObject and not Modules.TerrorRadius.Enabled then
		            SoundObject.RollOffMaxDistance = Val
		        end
		    end
		})
		
		HeartbeatVolume = BeastMusicModifier:CreateSlider({
		    Name = 'Heartbeat Volume',
		    Default = 1.9,
		    Min = 0,
		    Max = 10,
		    Decimal = 100,
		    Function = function(Val)
		        if HeartbeatObject then
		            HeartbeatObject.Volume = Val
		        end
		    end
		})
	end)

	Run(function() -- RestrainBeast
		local RestrainBeast
		
		RestrainBeast = Other:CreateModule({
		    Name = 'RestrainBeast',
		    Info = 'Force the beast to be unable to hook onto survivors',
		    Function = function(callback)
		        if callback then
		            repeat
		                for _, Entity in EntityLib.List do
		                    local Remote = Entity.Beast and Entity.Character:FindFirstChild('HammerEvent', true)
		                    if Remote and Remote:IsA('RemoteEvent') then
		                        Remote:FireServer('HammerClick', true)
		                        break
		                    end
		                end
		
		                task.wait(0.1)
		            until not RestrainBeast.Enabled
		        end
		    end,
		})
	end)

	Run(function() -- SlowBeast
		local SlowBeast
		
		SlowBeast = Other:CreateModule({
		    Name = 'SlowBeast',
		    Info = 'Makes the beast very slow',
		    Enabled = function()
		        repeat
		            for _, Entity in EntityLib.List do
		                local PowersEvent = Entity.Beast and Entity.Character:FindFirstChild('PowersEvent', true) or nil
						if PowersEvent then
							PowersEvent:FireServer('Jumped')
							break
						end
		            end
		
		            task.wait(0.1)
		        until not SlowBeast.Enabled
		    end
		})
	end)

	Run(function() -- SpamBeast
		local SpamBeast
		
		SpamBeast = Other:CreateModule({
			Name = 'SpamBeast',
			Tooltip = 'Forces the beast to use their power repeatedly',
			Enabled = function()
				repeat
					for _, Entity in EntityLib.List do
						local Remote = Entity.Beast and Entity.Character:FindFirstChild('PowersEvent', true) or nil
						if Remote and Remote:IsA('RemoteEvent') then
							Remote:FireServer('Input')
						end
					end
		
					task.wait(0.1)
				until not SpamBeast.Enabled
			end,
		})
	end)

	
	Run(function() -- FreezePodExploit
		local FreezePodExploit

		local FreezePods = {}

		const function FreezePodAdded(FreezePod)
			local Trigger: Part? = FreezePod:FindFirstChild('PodTrigger')
			local CapturedTorso: ObjectValue? = Trigger and Trigger:FindFirstChild('CapturedTorso')

			if not (Trigger and CapturedTorso) then
				const TimeOut = os.clock() + 3

				repeat
					task.wait()
					Trigger = FreezePod:FindFirstChild('PodTrigger')
					CapturedTorso = Trigger and Trigger:FindFirstChild('CapturedTorso')
				until (Trigger and CapturedTorso) or not FreezePodExploit.Enabled or os.clock() >= TimeOut
				if not (Trigger and CapturedTorso and FreezePodExploit.Enabled) then return end
			end

			FreezePodExploit:Clean(CapturedTorso:GetPropertyChangedSignal('Value'):Connect(function()
				if CapturedTorso.Value ~= nil and EntityLib.Alive and CapturedTorso.Value == EntityLib.Torso then
					EntityLib.Humanoid.Health = 0
					EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
					
					Notify({
						Title = 'Cat In The Had',
						Text = 'You had the cat!'
					})
				end
			end))
		end

		const function MapAdded()
			FreezePodExploit:Clean(Map.ChildAdded:Connect(function(Obj)
				if Obj.Name == 'FreezePod' then
					FreezePodAdded(Obj)
				end
			end))

			for _, Obj in Map:GetChildren() do
				if Obj.Name == 'FreezePod' then
					task.spawn(FreezePodAdded, Obj)
				end
			end
		end

		FreezePodExploit = Other:CreateModule({
			Name = 'Cat In The Had Exploit',
			Tooltip = 'He had the cat',
			Function = function(Enabled)
				if Enabled then
					FreezePodExploit:Clean(Events.MapAdded:Connect(MapAdded))
					if Map then
						MapAdded()
					end
				else
					table.clear(FreezePods)
				end
			end
		})
	end)

	Run(function() -- TerrorRadius
		local TerrorRadius, Volume, Layer1Distance, Layer2Distance, Layer3Distance, ChaseDistance, Music, CurrentlyPlaying
		
		local Layer1, Layer2, Layer3, Chase
		local LookAwayThread, WalkAwayThread, StartChaseThread, Chasing
		
		local SupportedFileTypes = {'mp3', 'ogg', 'wav', 'flac'}
		local RequiredFiles = {'Layer 1', 'Layer 2', 'Layer 3', 'Chase'}
		
		local function GetAssets()
		    local Assets = {}
		
		    for _, Asset in RequiredFiles do
		        for _, FileType in SupportedFileTypes do
		            if isfile(`TidalWave/Assets/{Asset}.{FileType}`) then
						table.insert(Assets, getcustomasset(`TidalWave/Assets/{Asset}.{FileType}`))
		                break
		            end
		        end
		    end
		
		    if #Assets ~= 4 then
		        local Missing = {}
				for i, v in RequiredFiles do
					if Assets[i] == nil then
						table.insert(Missing, v .. '.mp3')
					end
				end
		
		        Notify({
					Title = 'TerrorRadius',
		            Text = `Failed to load sounds: Missing files: {table.concat(Missing, ', ')}`,
		            Duration = 10,
		            Type = 'Error'
		        })
		
		        return nil
		    end
		
		    return table.unpack(Assets)
		end
		
		local Tweens = {}
		
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

		local function DoChaseChecks(Entity)
			const MoveCheck = Entity.Humanoid.MoveDirection ~= vector.zero and EntityLib.Humanoid.MoveDirection ~= vector.zero
			if not MoveCheck then
				return false
			end

			const OutOfRange = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position) > ChaseDistance.Value
			if OutOfRange then
				return false
			end

			const Occluded = EntityLib:WallCheck(EntityLib.Head.Position, Entity.Head.Position)
			if Occluded then
				return false
			end
			
			const ChaseDirection = vector.normalize((EntityLib.Root.Position - Entity.Root.Position) * vector.hort)
			const Dot = vector.dot(Entity.Root.CFrame.LookVector * vector.hort, ChaseDirection)

			if Dot >= 0.5 then
				return true
			end

			return false
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

		local function StartLookAwayThread()
			LookAwayThread = task.delay(10, function()
				LookAwayThread = nil
				Chasing = false
				CancelAllThreads()
				PlaySound(Layer3, 0.5)
			end)
		end

		local function StartWalkAwayThread()
			WalkAwayThread = task.delay(3, function()
				WalkAwayThread = nil
				Chasing = false
				CancelAllThreads()
				PlaySound(Layer3, 0.5)
			end)
		end

		local function CreateStartChaseThread(Entity)
			StartChaseThread = task.delay(0.5, function()
				StartChaseThread = nil

				if DoChaseChecks(Entity) then
					Chasing = true
					CancelAllThreads()
					PlaySound(Chase, 0.5)
				end
			end)
		end
		
		TerrorRadius = Other:CreateModule({
		    Name = 'TerrorRadius',
		    Info = 'Allows you to have a custom terror radius.\nYou must have 4 sound files in the TidalWave/Assets folder for this to work: "Layer 1.mp3", "Layer 2.mp3", "Layer 3.mp3", "Chase.mp3"\nSupports mp3, ogg, wav and flac files.',
		    Function = function(Enabled)
		        if Enabled then
		            if not getcustomasset then NotifyPoopSploit('getcustomasset'); return end
		            local Layer1Asset, Layer2Asset, Layer3Asset, ChaseAsset = GetAssets()
		            if not Layer1Asset then return end
		
		            Layer1, Layer2, Layer3, Chase = Instance.new('Sound'), Instance.new('Sound'), Instance.new('Sound'), Instance.new('Sound')
		            Layer1.SoundId, Layer2.SoundId, Layer3.SoundId, Chase.SoundId = Layer1Asset, Layer2Asset, Layer3Asset, ChaseAsset
		            Layer1.Volume, Layer2.Volume, Layer3.Volume, Chase.Volume = Volume.Value, Volume.Value, Volume.Value, Volume.Value
		            Layer1.Looped, Layer2.Looped, Layer3.Looped, Chase.Looped = true, true, true, true
		            Layer1.Parent, Layer2.Parent, Layer3.Parent, Chase.Parent = workspace, workspace, workspace, workspace
		
					Modules.BeastMusicModifier:Restart()
		
		            Chasing = false
		
		            while TerrorRadius.Enabled do
						if EntityLib.Alive then
							const Beast = GetBeast()
							const Entity = Beast and EntityLib:FindEntity(Beast) or nil
							if Entity then
								Music = SafeRef(Entity.Character, {'Hammer', 'Handle', 'SoundChaseMusic'})
								if Music then
									Music.Volume = 0
								end

								if Chasing then
									const Magnitude = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position)
									if Magnitude <= ChaseDistance.Value then
										CancelWalkAwayThread()
										if not LookAwayThread then
											StartLookAwayThread()
										end
									elseif not WalkAwayThread then
										StartWalkAwayThread()
									end
								elseif DoChaseChecks(Entity) then
									if not StartChaseThread then
										CreateStartChaseThread(Entity)
									end
								else
									CancelAllThreads()
									Chasing = false

									const Magnitude = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position)
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
						end
		
		                task.wait()
		            end
		        else
		            Modules.BeastMusicModifier:Restart()
		
		            CancelAllThreads()
		
		            if Music then
		                Music.Volume = 0.4
		                Music = nil
		            end
		
		            for _, v in {Layer1, Layer2, Layer3, Chase} do
		                v:Stop()
		                v:Destroy()
		            end
		
		            Layer1, Layer2, Layer3, Chase, CurrentlyPlaying, Chasing = nil, nil, nil, nil, nil, nil
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
end)