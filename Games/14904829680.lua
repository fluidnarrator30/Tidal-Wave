const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
    return cloneref(game:GetService(Service))
end

const ContextActionService: ContextActionService = GetService('ContextActionService')
const HttpService: HttpService = GetService('HttpService')
const Players: Players = GetService('Players')
const ReplicatedStorage: ReplicatedStorage = GetService('ReplicatedStorage')
const RunService: RunService = GetService('RunService')
const UIS: UserInputService = GetService('UserInputService')

const Plr = Players.LocalPlayer
local Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local EntityLib = TidalWave.Libraries.EntityLib
local Modules = TidalWave.Modules
local ObjectFunctions = TidalWave.Libraries.ObjectFunctions

Modules.Speed.Options.Method:SetValue('CFrame')
Modules.Fly.Options.FlyMethod:SetValue('CFrame')

local Combat = Categories.Combat
local Movement = Categories.Movement
local World = Categories.World
local Visuals = Categories.Visuals
local PlayerCategory = Categories.Player
local Other = Categories.Other
local Animations = Categories.Animations

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

workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
	Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
end)

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

local function SafeRef(Obj, Path)
    return ObjectFunctions:SafeRef(Obj, Path)
end

local function GetKiller()
    for _, Player in Players:GetPlayers() do
        local Killer = SafeRef(Player, {'Backpack', 'Scripts', 'Killer'})
        if Killer and Killer.Value then
            return Player
        end
    end

    return nil
end

local function Run(f)
    f()
end

local dbr = {}
local Remotes = {}
local PlayerGui, Backpack, Scripts, PlayerValues, Values

Run(function()
	local GlobalSurvivor, SurvivorActions, RemoteEvents

	const InitSuccess = TidalWave:WaitForInit(function()
		PlayerValues = Plr:FindFirstChild('PlayerValues')
		PlayerGui = Plr:FindFirstChildOfClass('PlayerGui')
		Backpack = Plr:FindFirstChildOfClass('Backpack')
		Scripts = Backpack and Backpack:FindFirstChild('Scripts')
		Values = Scripts and Scripts:FindFirstChild('values')
		GlobalSurvivor = Scripts and Scripts:FindFirstChild('GlobalSurvivor')
		SurvivorActions = GlobalSurvivor and GlobalSurvivor:FindFirstChild('Action')
		RemoteEvents = ReplicatedStorage:FindFirstChild('RemoteEvents')
		return PlayerValues and PlayerGui and Backpack and Scripts and Values and GlobalSurvivor and SurvivorActions and RemoteEvents
	end)
	if not InitSuccess then return end

	const require = table.find({'Xeno', 'Solara'}, ({identifyexecutor()})[1]) == nil and require or nil
	
	Remotes.ServerEvent = RemoteEvents.Server_Event
	Remotes.HealEvent = RemoteEvents.ClientToServer.HealingEvent
	Remotes.PingEvent = RemoteEvents.PingTimes
	Remotes.PerkEvent = RemoteEvents.Perk_Event
	Remotes.HatchAction = RemoteEvents.HatchAction
	Remotes.ObjectAppUpdater = RemoteEvents.ObjectAppUpdater
	Remotes.NewProperty = RemoteEvents.NewPropertie

	dbr = {
		Values = Values,
		PlayerValues = PlayerValues,
		IsKiller = Scripts.Killer.Value,
		Survivor = {
			HealProgress = Values.HealProgress,
			HealthState = Values.HealthState,
			Held = Values.Holded,
			Hooked = Values.Hooked,
			MendProgress = Values.MendProgress,
			Recovering = Values.Recovering,
			Vaulting = Values.Vaulting,
			WiggleProgress = Values.WiggleProgress,
			Action = Values.Action,
			VaultWindow = require and require(SurvivorActions.VaultWindow) or nil,
			DropPallet = require and require(SurvivorActions.DropPallet) or nil
		},
		Killer = {
			Hillbilly = require and require(ReplicatedStorage.Game_Data.Killers.Hillbilly) or nil,
			Action = Values.KillerAction
		}
	}
end)

Run(function() -- Combat
	Run(function() -- KillAll
		Combat:CreateButton({
		    Name = 'Kill All',
		    Info = 'You must be killer for this to work',
		    Function = function()
				if dbr.IsKiller then
					for i, Entity in EntityLib.List do
						local Hook = workspace:FindFirstChild(`Hook{i}`)
						if not Hook then continue end

						task.spawn(function()
							for _ = 1, 3 do
								Remotes.ServerEvent:FireServer('Hook', 'Hook', Entity.Character, Hook)
								task.wait(0.5)
							end
						end)
					end
				else
					Notify({
						Title = 'Kill All',
						Text = 'You must be killer for this to work.',
						Type = 'Error',
						Duration = 5
					})
				end
		    end,
		})
	end)
end)

Run(function() -- Player
	Run(function() -- InfiniteBlinks
		local InfiniteBlinks
		
		local PowerRemote
		
		local function LocalAdded()
		    PowerRemote = SafeRef(EntityLib.Character, {'Blink', 'PowerValues', 'PowerRemote'})
		    if not PowerRemote then
		        repeat
		            task.wait()
		            PowerRemote = SafeRef(EntityLib.Character, {'Blink', 'PowerValues', 'PowerRemote'})
		        until PowerRemote or not InfiniteBlinks.Enabled
		
		        if not InfiniteBlinks.Enabled then return end
		    end
		
		    PowerRemote:FireServer('SetValue', 'Blinks', 9e9)
		end
		
		InfiniteBlinks = PlayerCategory:CreateModule({
		    Name = 'InfiniteBlinks',
		    Function = function(Enabled)
		        if Enabled then
		            InfiniteBlinks:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		
		            if EntityLib.Alive then
		                LocalAdded()
		            end
		        else
		            if PowerRemote then
		                PowerRemote:FireServer('SetValue', 'Blinks', 2)
		                PowerRemote = nil
		            end
		        end
		    end,
		})
	end)

	Run(function() -- LungeDuration
		local LungeDuration, Value
		
		local Old, db
		
		LungeDuration = PlayerCategory:CreateModule({
		    Name = 'LungeDuration',
		    Info = 'Changes the duration of your lunge',
		    Function = function(Enabled)
		        if Enabled then
		            if not dbr.PlayerValues then
						repeat
							task.wait()
						until dbr.PlayerValues or not LungeDuration.Enabled
						if not LungeDuration.Enabled then return end
					end
		
		            Old = dbr.PlayerValues:GetAttribute('LungeDuration')
		            dbr.PlayerValues:SetAttribute('LungeDuration', Value.Value)
		
		            LungeDuration:Clean(dbr.PlayerValues:GetAttributeChangedSignal('Value'):Connect(function()
		                if db then return end
		                db = true
		                Old = dbr.PlayerValues:GetAttribute('LungeDuration')
		                dbr.PlayerValues:SetAttribute('LungeDuration', Value.Value)
		                db = false
		            end))
		        else
		            if dbr.PlayerValues and Old then
		                dbr.PlayerValues:SetAttribute('LungeDuration', Old)
		            end
		
		            Old = nil
		        end
		    end,
		})
		
		Value = LungeDuration:CreateSlider({
		    Name = 'Lunge Duration',
		    Default = 0.5,
		    Min = 0,
		    Max = 10,
		    Decimal = 100,
		    Function = function(Val)
		        if LungeDuration.Enabled and dbr.PlayerValues then
		            db = true
		            dbr.PlayerValues:SetAttribute('LungeDuration', Val)
		            db = false
		        end
		    end,
		})
	end)

	Run(function() -- LungeSpeed
		local LungeSpeed, Value
		
		local Old, db
		
		LungeSpeed = PlayerCategory:CreateModule({
		    Name = 'Lunge Speed',
		    Info = 'Changes the speed of your lunge',
		    Function = function(Enabled)
		        if Enabled then
		            if not dbr.PlayerValues then
		                repeat
		                    task.wait()
		                until dbr.PlayerValues or not LungeSpeed.Enabled
		                if not LungeSpeed.Enabled then return end
		            end
		
		            Old = dbr.PlayerValues:GetAttribute('LungeSpeed')
		            dbr.PlayerValues:SetAttribute('LungeSpeed', Value.Value)
		            LungeSpeed:Clean(dbr.PlayerValues:GetAttributeChangedSignal('LungeSpeed'):Connect(function()
		                if db then return end
		                db = true
		                Old = dbr.PlayerValues:GetAttribute('LungeSpeed')
		                dbr.PlayerValues:SetAttribute('LungeSpeed', Value.Value)
		                db = false
		            end))
		        else
		            if dbr.PlayerValues and Old then
		                dbr.PlayerValues:SetAttribute('LungeSpeed', Old)
		            end
		
		            Old = nil
		        end
		    end,
		})
		
		Value = LungeSpeed:CreateSlider({
		    Name = 'Lunge Speed',
		    Default = 30,
		    Min = 0,
		    Max = 300,
		    Function = function(Val)
		        if LungeSpeed.Enabled and dbr.PlayerValues then
		            db = true
		            dbr.PlayerValues:SetAttribute('LungeSpeed', Val)
		            db = false
		        end
		    end,
		})
	end)

	Run(function() -- MissCooldown
		local MissCooldown, Value
		
		local Old, db
		
		MissCooldown = PlayerCategory:CreateModule({
		    Name = 'Miss Cooldown',
		    Info = 'Changes the cooldown of missed hits\nDefault is 1.5',
		    Function = function(Enabled)
		        if Enabled then
		            if not dbr.PlayerValues then
		                repeat
		                    task.wait()
		                until dbr.PlayerValues or not MissCooldown.Enabled
		                if not MissCooldown.Enabled then return end
		            end
		
		            Old = dbr.PlayerValues:GetAttribute('MissCooldown')
		            dbr.PlayerValues:SetAttribute('MissCooldown', Value.Value)
		            MissCooldown:Clean(dbr.PlayerValues:GetAttributeChangedSignal('MissCooldown'):Connect(function()
		                if db then return end
		                db = true
		                Old = dbr.PlayerValues:GetAttribute('MissCooldown')
		                dbr.PlayerValues:SetAttribute('MissCooldown', Value.Value)
		                db = false
		            end))
		        else
		            if dbr.PlayerValues and Old then
		                dbr.PlayerValues:SetAttribute('MissCooldown', Old)
		            end
		
		            Old = nil
		        end
		    end,
		})
		
		Value = MissCooldown:CreateSlider({
		    Name = 'Miss Cooldown',
		    Default = 1.5,
		    Min = 0,
		    Max = 10,
		    Decimal = 100,
		    Function = function(Val)
		        if MissCooldown.Enabled and dbr.PlayerValues then
		            db = true
		            dbr.PlayerValues:SetAttribute('MissCooldown', Val)
		            db = false
		        end
		    end,
		})
	end)

	Run(function() -- NoDeadHardLimit
		local NoDeadHardLimit
		
		local function LocalAdded()
		    EntityLib.Character:SetAttribute('DodgeUses', 9e9)
		end
		
		NoDeadHardLimit = Other:CreateModule({
		    Name = 'NoDeadHardLimit',
		    Info = 'Removes the limit of using dead hard 3 times per match',
		    Function = function(Enabled)
		        if Enabled then
		            NoDeadHardLimit:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		            if EntityLib.Alive then
		                LocalAdded()
		            end
		        else
		            if EntityLib.Alive then
		                EntityLib.Character:SetAttribute('DodgeUses', 3)
		            end
		        end
		    end
		})
	end)

	Run(function() -- NoStagger
		local NoStagger
		
		local function LocalAdded()
		    EntityLib.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		    NoStagger:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('FloorMaterial'):Connect(function()
		        if EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
		            EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		        end
		    end))
		end
		
		NoStagger = Movement:CreateModule({
		    Name = 'NoStagger',
		    Info = 'Removes the stagger after falling from a height',
		    Function = function(Enabled)
		        if Enabled then
		            NoStagger:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		            if EntityLib.Alive then
		                LocalAdded(EntityLib)
		            end
		        else
		            if EntityLib.Alive then
		                EntityLib.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		            end
		        end
		    end
		})
	end)

	Run(function() -- VaultSpeed
		local VaultSpeed, Speed, Percentage, UsePercentage
		
		local function UpdateWindowVaultSpeed()
		    if dbr.PlayerValues and VaultSpeed.Enabled then
		        if UsePercentage.Enabled then
		            dbr.PlayerValues:SetAttribute('WindowVaultSpeed', math.max(dbr.PlayerValues:GetAttribute('WindowVaultSpeed'), 1) * (Percentage.Value / 100))
		        else
		            dbr.PlayerValues:SetAttribute('WindowVaultSpeed', math.max(dbr.PlayerValues:GetAttribute('WindowVaultSpeed'), Speed.Value))
		        end
		    end
		end
		
		VaultSpeed = Movement:CreateModule({
		    Name = 'Vault Speed',
		    Info = 'Changes the speed of window vaults.\nDoesn\'t effect pallet vault speed.',
		    Enabled = function()
		        if not dbr.PlayerValues then
		            repeat
		                task.wait()
		            until dbr.PlayerValues or not VaultSpeed.Enabled
		            if not VaultSpeed.Enabled then return end
		        end
		
		        UpdateWindowVaultSpeed()
		        VaultSpeed:Clean(dbr.PlayerValues:GetAttributeChangedSignal('WindowVaultSpeed'):Connect(UpdateWindowVaultSpeed))
		    end,
		})
		
		Speed = VaultSpeed:CreateSlider({
		    Name = 'Window Vault Speed',
		    Default = 1,
		    Min = 0,
			Max = 5,
			Function = UpdateWindowVaultSpeed
		})

		UsePercentage = VaultSpeed:CreateToggle({
			Name = 'Use Percentage',
			Function = UpdateWindowVaultSpeed
		})

		Percentage = UsePercentage:CreateSlider({
			Name = 'Percentage',
			Default = 110,
			Min = 0,
			Max = 200,
			Suffix = '%',
			Function = UpdateWindowVaultSpeed
		})
	end)

	Run(function() -- WipeSpeed
		local WipeSpeed, Value
		
		local Old, db
		
		WipeSpeed = PlayerCategory:CreateModule({
		    Name = 'Wipe Speed',
		    Info = 'Increase the speed at which you wipe your weapon.',
		    Function = function(Enabled)
		        if Enabled then
		            if not dbr.PlayerValues then
		                repeat
		                    task.wait()
		                until dbr.PlayerValues or not WipeSpeed.Enabled
		                if not WipeSpeed.Enabled then return end
		            end
		
		            Old = dbr.PlayerValues:GetAttribute('WipeSpeed')
		            dbr.PlayerValues:SetAttribute('WipeSpeed', Value.Value)
		            WipeSpeed:Clean(dbr.PlayerValues:GetAttributeChangedSignal('WipeSpeed'):Connect(function()
		                if db then return end
		                db = true
		                dbr.PlayerValues:SetAttribute('WipeSpeed', Value.Value)
		                db = false
		            end))
		        else
		            if dbr.PlayerValues and Old then
		                dbr.PlayerValues:SetAttribute('WipeSpeed', Old)
		            end

		            Old = nil
		        end
		    end,
		})
		
		Value = WipeSpeed:CreateSlider({
		    Name = 'Multi',
		    Default = 1,
		    Min = 0,
		    Max = 10,
		    Decimal = 10,
		    Function = function(Val)
		        if WipeSpeed.Enabled and dbr.PlayerValues then
		            db = true
		            dbr.PlayerValues:SetAttribute('WipeSpeed', Value.Value)
		            db = false
		        end
		    end,
		})
	end)
end)

Run(function() -- Movement
	Run(function() -- NoPalletSlowdown
		local NoPalletSlowdown
		
		NoPalletSlowdown = Movement:CreateModule({
		    Name = 'NoPalletSlowdown',
		    Info = 'Stops you from getting locked into place after dropping a pallet',
		    Enabled = function()
		        if dbr.Survivor.DropPallet then
		            local Con
		            local OldStart = dbr.Survivor.DropPallet.Start
		            dbr.Survivor.DropPallet.Start = function(self, ...)
						if Con then
							Con:Disconnect()
							Con = nil
						end
	
						Con = EntityLib.Alive and EntityLib.Root:GetPropertyChangedSignal('Anchored'):Once(function()
							EntityLib.Root.Anchored = false
							Con = nil
						end)
	
						local Result = OldStart(self, ...)
						if Con then
							Con:Disconnect()
							Con = nil
						end
	
						return Result
					end
	
					NoPalletSlowdown:Clean(function()
						dbr.Survivor.DropPallet.Start = OldStart
					end)
		        else
					Notify({
		                Text = 'Your executor doesn\'t support \'require\'\nThis module may or may not work',
		                Duration = 10,
		                Type = 'Warning'
		            })
		            
		            local Con
		            NoPalletSlowdown:Clean(dbr.Survivor.Action:GetPropertyChangedSignal('Value'):Connect(function()
						if dbr.Survivor.Action.Value == 'DroppingPallet' and EntityLib.Alive then
							if EntityLib.Root.Anchored then
								EntityLib.Root.Anchored = false
							else
								if Con then
									Con:Disconnect()
								end
								Con = EntityLib.Root:GetPropertyChangedSignal('Anchored'):Once(function()
									EntityLib.Root.Anchored = false
									Con = nil
								end)
							end
						end
					end))

					NoPalletSlowdown:Clean(function()
						if Con then
							Con:Disconnect()
							Con = nil
						end
					end)
		        end
		    end
		})
	end)
end)

Run(function() -- Visuals
	Run(function() -- GeneratorESP
		local GeneratorESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency
		        
		local Highlights = {}
		local Folder
		
		local function GeneratorAdded(Obj)
		    local Index = Obj.Name:match('Generator(%d+)')
		    if Index then
		        local Highlight = Instance.new('Highlight')
		        Highlight.Adornee = Obj
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		        Highlight.Name = `GeneratorESP_{Index}`
		        Highlight.Parent = Folder
		        table.insert(Highlights, Highlight)
		    end
		end
		
		GeneratorESP = Visuals:CreateModule({
		    Name = 'GeneratorESP',
		    Function = function(Enabled)
		        if Enabled then
		            Folder = Instance.new('Folder')
		            Folder.Name = 'GeneratorESP'
		            Folder.Parent = TidalWave.Gui
		
		            GeneratorESP:Clean(workspace.ChildAdded:Connect(GeneratorAdded))
		            for _, Obj in workspace:GetChildren() do
		                if Obj.Name:find('Generator') then
		                    GeneratorAdded(Obj)
		                end
		            end
		        else
		            Folder:Destroy()
		            Folder = nil
		            table.clear(Highlights)
		        end
		    end,
		})
		
		local function UpdateGeneratorESP()
		    if not GeneratorESP.Enabled then return end
		    for _, Highlight in Highlights do
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		    end
		end
		
		OutlineColor = GeneratorESP:CreateColorPicker({
		    Name = 'Outline Color',
		    Default = Color3.Red,
		    Function = UpdateGeneratorESP
		})
		
		FillColor = GeneratorESP:CreateColorPicker({
		    Name = 'Fill Color',
		    Default = Color3.Red,
		    Function = UpdateGeneratorESP
		})
		
		OutlineTransparency = GeneratorESP:CreateTransparencySlider({
		    Name = 'Outline Transparency',
		    Function = UpdateGeneratorESP
		})
		
		FillTransparency = GeneratorESP:CreateTransparencySlider({
		    Name = 'Fill Transparency',
		    Default = 0.5,
		    Function = UpdateGeneratorESP
		})
	end)

	Run(function() -- PalletESP
		local PalletESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency
		
		local Folder
		local Highlights = {}
		
		local function PalletAdded(Obj)
		    local Index = Obj.Name:match('Pallet(%d+)')
		    if Index then
		        local Highlight = Instance.new('Highlight')
		        Highlight.Adornee = Obj
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		        Highlight.Name = `PalletESP_{Index}`
		        Highlight.Parent = Folder
		        table.insert(Highlights, Highlight)
		    end
		end
		
		PalletESP = Visuals:CreateModule({
		    Name = 'PalletESP',
		    Function = function(Enabled)
		        if Enabled then
		            Folder = Instance.new('Folder')
		            Folder.Name = 'PalletESP'
		            Folder.Parent = TidalWave.Gui
		
		            PalletESP:Clean(workspace.ChildAdded:Connect(PalletAdded))
		            for _, Obj in workspace:GetChildren() do
		                if Obj.Name:find('Pallet') then
		                    PalletAdded(Obj)
		                end
		            end
		        else
		            Folder:Destroy()
		            Folder = nil
		            table.clear(Highlights)
		        end
		    end,
		})
		
		local function UpdatePalletESP()
		    if not PalletESP.Enabled then return end
		    for _, Highlight in Highlights do
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		    end
		end
		
		OutlineColor = PalletESP:CreateColorPicker({
		    Name = 'Outline Color',
		    Default = Color3.Yellow,
		    Function = UpdatePalletESP
		})
		
		FillColor = PalletESP:CreateColorPicker({
		    Name = 'Fill Color',
		    Default = Color3.Yellow,
		    Function = UpdatePalletESP
		})
		
		OutlineTransparency = PalletESP:CreateTransparencySlider({
		    Name = 'Outline Transparency',
		    Function = UpdatePalletESP
		})
		
		FillTransparency = PalletESP:CreateTransparencySlider({
		    Name = 'Fill Transparency',
		    Default = 0.5,
		    Function = UpdatePalletESP
		})
	end)

	Run(function() -- TrapESP
		local TrapESP, ArmedOutlineColor, ArmedFillColor, DisarmedOutlineColor, DisarmedFillColor, OutlineTransparency, FillTransparency
		
		local Folder
		local Highlights = {}
		
		local function SetColor(Highlight: Highlight, State: string)
		    Highlight.OutlineColor = State == 'Armed' and ArmedOutlineColor.Color or DisarmedOutlineColor.Color
		    Highlight.FillColor = State == 'Armed' and ArmedFillColor.Color or DisarmedFillColor.Color
		end
		
		local function TrapAdded(Trap: Model)
		    local Index = Trap.Name:match('Trap(%d+)')
		    if Index then
		        local Panel: Model = Trap:FindFirstChild('Panel')
		        local State: StringValue = Panel and Panel:FindFirstChild('State')
		
		        if not State then
		            const TimeOut = os.clock() + 5
		            repeat
		                task.wait()
		                Panel = Trap:FindFirstChild('Panel')
		                State = Panel and Panel:FindFirstChild('State')
		            until State or not TrapESP.Enabled or os.clock() >= TimeOut
		
		            if not (State and TrapESP.Enabled) then return end
		        end
		
		        local Highlight = Instance.new('Highlight')
		        Highlight.Adornee = Trap
		        Highlight.Name = `TrapESP_{Index}`
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		        SetColor(Highlight, State.Value)
		        Highlight.Parent = Folder
		        table.insert(Highlights, Highlight)
		
		        TrapESP:Clean(State:GetPropertyChangedSignal('Value'):Connect(function()
		            SetColor(Highlight, State.Value)
		        end))
		    end
		end
		
		TrapESP = Visuals:CreateModule({
		    Name = 'TrapESP',
		    Info = 'Highlights traps',
		    Function = function(Enabled)
		        if Enabled then
		            Folder = Instance.new('Folder')
		            Folder.Name = 'TrapESP'
		            Folder.Parent = TidalWave.Gui
		
		            for _, Obj in workspace:GetChildren() do
		                if Obj.Name:find('Trap') then
		                    task.spawn(TrapAdded, Obj)
		                end
		            end
		
		            TrapESP:Clean(workspace.ChildAdded:Connect(TrapAdded))
		            TrapESP:Clean(workspace.ChildRemoved:Connect(function(Obj)
		                if Obj.Name:find('Trap') then
		                    for i, Highlight in Highlights do
		                        if Highlight.Adornee == Obj then
		                            Highlight:Destroy()
		                            table.remove(Highlights, i)
		                            break
		                        end
		                    end
		                end
		            end))
		        else
		            Folder:Destroy()
		            Folder = nil
		            table.clear(Highlights)
		        end
		    end,
		})
		
		local function UpdateHighlights()
		    if not TrapESP.Enabled then return end
		    for _, Highlight in Highlights do
		        local Panel = Highlight.Adornee:FindFirstChild('Panel')
		        local State = Panel and Panel:FindFirstChild('State')
		        if State then
		            SetColor(Highlight, State.Value)
		        end
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		    end
		end
		
		ArmedOutlineColor = TrapESP:CreateColorPicker({
		    Name = 'Armed Outline Color',
		    Default = Color3.Red,
		    Function = UpdateHighlights
		})
		
		ArmedFillColor = TrapESP:CreateColorPicker({
		    Name = 'Armed Fill Color',
		    Default = Color3.Red,
		    Function = UpdateHighlights
		})
		
		DisarmedOutlineColor = TrapESP:CreateColorPicker({
		    Name = 'Disarmed Outline Color',
		    Default = Color3.Green,
		    Function = UpdateHighlights
		})
		
		DisarmedFillColor = TrapESP:CreateColorPicker({
		    Name = 'Disarmed Fill Color',
		    Default = Color3.Green,
		    Function = UpdateHighlights
		})
		
		OutlineTransparency = TrapESP:CreateTransparencySlider({
		    Name = 'Outline Transparency',
		    Function = UpdateHighlights
		})
		
		FillTransparency = TrapESP:CreateTransparencySlider({
		    Name = 'Fill Transparency',
		    Default = 0.5,
		    Function = UpdateHighlights
		})
	end)

	Run(function() -- WindowESP
		local WindowESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency
		
		local Highlights = {}
		local Folder
		
		local function WindowAdded(Obj)
		    local Index = Obj.Name:match('Window(%d+)')
		    if Index then
		        local Highlight = Instance.new('Highlight')
		        Highlight.Adornee = Obj
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		        Highlight.Name = `WindowESP_{Index}`
		        Highlight.Parent = Folder
		        table.insert(Highlights, Highlight)
		    end
		end
		
		WindowESP = Visuals:CreateModule({
		    Name = 'WindowESP',
		    Function = function(Enabled)
		        if Enabled then
		            Folder = Instance.new('Folder')
		            Folder.Name = 'WindowESP'
		            Folder.Parent = TidalWave.Gui
		
		            WindowESP:Clean(workspace.ChildAdded:Connect(WindowAdded))
		            for _, Obj in workspace:GetChildren() do
		                if Obj.Name:find('Window') then
		                    WindowAdded(Obj)
		                end
		            end
		        else
		            Folder:Destroy()
		            Folder = nil
		            table.clear(Highlights)
		        end
		    end,
		})
		
		local function UpdateWindowESP()
		    if not WindowESP.Enabled then return end
		    for _, Highlight in Highlights do
		        Highlight.OutlineColor = OutlineColor.Color
		        Highlight.FillColor = FillColor.Color
		        Highlight.OutlineTransparency = OutlineTransparency.Value
		        Highlight.FillTransparency = FillTransparency.Value
		    end
		end
		
		OutlineColor = WindowESP:CreateColorPicker({
		    Name = 'Outline Color',
		    Default = Color3.Yellow,
		    Function = UpdateWindowESP
		})
		
		FillColor = WindowESP:CreateColorPicker({
		    Name = 'Fill Color',
		    Default = Color3.Yellow,
		    Function = UpdateWindowESP
		})
		
		OutlineTransparency = WindowESP:CreateTransparencySlider({
		    Name = 'Outline Transparency',
		    Function = UpdateWindowESP
		})
		
		FillTransparency = WindowESP:CreateTransparencySlider({
		    Name = 'Fill Transparency',
		    Default = 0.5,
		    Function = UpdateWindowESP
		})
	end)
end)

Run(function() -- World
	Run(function() -- CloseHatch
		World:CreateButton({
		    Name = 'Close Hatch',
		    Function = function()
		        Remotes.HatchAction:FireServer('Start_Close')
		        task.wait(1)
		        Remotes.HatchAction:FireServer('Close')
		    end,
		})
	end)

	Run(function() -- DestroyPallets
		World:CreateButton({
		    Name = 'Destroy Pallets',
		    Function = function()
		        for _, Obj in workspace:GetChildren() do
		            if Obj.Name:find('Pallet') then
		                Remotes.ServerEvent:FireServer('Pallet', 'Killer_Kick', Obj)
		            end
		        end
		    end,
		})
	end)

	Run(function() -- DestroyWalls
		World:CreateButton({
		    Name = 'Destroy Walls',
		    Function = function()
		        for _, Obj in workspace:GetChildren() do
		            if Obj.Name:find('BreakableWall') then
		                Remotes.ServerEvent:FireServer('Wall', 'Killer_Kick', Obj)
		            end
		        end
		    end,
		})
	end)

	Run(function() -- HatchEscape
		World:CreateButton({
		    Name = 'Hatch Escape',
		    Function = function()
		        Remotes.HatchAction:FireServer('Use')
		    end,
		})
	end)

	Run(function() -- KickGenerators
		World:CreateButton({
		    Name = 'Kick Generators',
		    Function = function()
		        for _, Obj in workspace:GetChildren() do
		            if Obj.Name:find('Generator') then
		                Remotes.ServerEvent:FireServer('Generator', 'Killer_Kick', Obj, Obj.Workspots.Front)
		            end
		        end
		    end,
		})
	end)

	Run(function() -- OpenGates
		World:CreateButton({
		    Name = 'Open Gates',
		    Function = function()
		        local Gate1Remote = SafeRef(workspace, {'ExitGate1', 'Panel', 'Exit_Gate'})
		        local Gate2Remote = SafeRef(workspace, {'ExitGate2', 'Panep', 'Exit_Gate'})
		
		        if Gate1Remote then
		            Gate1Remote:FireServer('KillerOpen')
		        end
		        if Gate2Remote then
		            Gate2Remote:FireServer('KillerOpen')
		        end
		    end
		})
	end)

	Run(function() -- RepairAllGenerators
		local RepairAllGenerators
		
		RepairAllGenerators = World:CreateModule({
		    Name = 'RepairAllGenerators',
		    Info = 'Starts repairing all generators at once',
		    Function = function(Enabled)
		        for _, Generator in workspace:GetChildren() do
		            if Generator.Name:find('Generator') then
		                for _, Workspot in Generator.Workspots:GetChildren() do
		                    do
		                        local Val = {C21 = Workspot.Ocuped, C20 = Enabled, C22 = 'B101'}
		                        local Args = {D9v8 = Val, Bbh1O = Val, Dvh1O = Val, Dbh1O = Val, Dhv8 = Val}
		                        Remotes.NewProperty:FireServer(Args)
		                    end
		
		                    do
		                        local Val = {C21 = Workspot.Ocupant, C20 = Enabled and Plr.Name or 'Nobody', C22 = 'S101'}
		                        local Args = {D9v8 = Val, Bbh1O = Val, Dvh1O = Val, Dbh1O = Val, Dhv8 = Val}
		                        Remotes.NewProperty:FireServer(Args)
		                    end
		                end
		            end
		        end
		    end
		})
	end)

	Run(function() -- SoundSpammer
		local SoundSpammer, Interval
		
		SoundSpammer = World:CreateModule({
		    Name = 'Sound Spammer',
		    Info = 'Spam plays every sound in workspace',
		    Function = function()
		        local Sounds = workspace:QueryDescendants('Sound')
		        SoundSpammer:Clean(workspace.DescendantAdded:Connect(function(Obj)
		            if Obj:IsA('Sound') then
		                table.insert(Sounds, Obj)
		            end
		        end))

				repeat
					for _, Sound in Sounds do
						Remotes.ObjectAppUpdater:FireServer(Sound, 'Playing', true)
					end
		
					task.wait(Interval.Value)
				until not SoundSpammer.Enabled
		    end
		})
		
		Interval = SoundSpammer:CreateSlider({
		    Name = 'Interval',
		    Default = 0.1,
		    Min = 0,
		    Max = 1
		})
	end)

	Run(function() -- TrapDisabler
		local TrapDisabler
		
		local Modified = {}
		
		local function DisableTrap(Obj)
		    if Obj.Name:find('Trap') then
		        local Hitbox = Obj:FindFirstChild('Hitbox')
		
		        if not Hitbox then
		            const TimeOut = os.clock() + 5
		            repeat
		                task.wait()
		                Hitbox = Obj:FindFirstChild('Hitbox')
		            until Hitbox or not TrapDisabler.Enabled or os.clock() >= TimeOut
		
		            if not (Hitbox and TrapDisabler.Enabled) then return end
		        end
		
		        if Hitbox and Hitbox:IsA('BasePart') then
		            Hitbox.CanTouch = false
		            Modified[Hitbox] = true
		            TrapDisabler:Clean(Hitbox:GetPropertyChangedSignal('CanTouch'):Connect(function()
		                Hitbox.CanTouch = false
		            end))
		        end
		    end
		end
		
		TrapDisabler = World:CreateModule({
		    Name = 'TrapDisabler',
		    Info = 'Disables the collision of traps',
		    Function = function(Enabled)
		        if Enabled then
		            for _, Obj in workspace:GetChildren() do
		                if Obj.Name:find('Trap') then
		                    DisableTrap(Obj)
		                end
		            end
		
		            TrapDisabler:Clean(workspace.ChildAdded:Connect(DisableTrap))
		        else
		            for Trap in Modified do
		                Trap.CanTouch = true
		            end
		            table.clear(Modified)
		        end
		    end,
		})
	end)

	Run(function() -- UnlockHatch
		World:CreateButton({
		    Name = 'Unlock Hatch',
		    Function = function()
		        Remotes.HatchAction:FireServer('Unlock')
		    end,
		})
	end)
end)

Run(function() -- Other
	Run(function() -- AntiBamboozle
		local AntiBamboozle
		
		local function WindowAdded(Window)
		    if Window.Name:find('Window') then
		        local Panel = Window:FindFirstChild('Panel')
		        local Blocked = Panel and Panel:FindFirstChild('shadowvault')
		
		        if not Blocked then
		            const TimeOut = os.clock() + 5
		            repeat
		                task.wait()
		                Panel = Window:FindFirstChild('Panel')
		                Blocked = Panel and Panel:FindFirstChild('shadowvault')
		            until Blocked or not AntiBamboozle.Enabled or os.clock() >= TimeOut
		
		            if not (Blocked and AntiBamboozle.Enabled) then return end
		        end
		
		        Blocked.Value = false
		        AntiBamboozle:Clean(Blocked:GetPropertyChangedSignal('Value'):Connect(function()
		            Blocked.Value = false
		        end))
		    end
		end
		
		AntiBamboozle = Other:CreateModule({
		    Name = 'AntiBamboozle',
		    Info = 'Prevents windows from getting blocked by bamboozle',
		    Enabled = function()
		        for _, Obj in workspace:GetChildren() do
		            if Obj.Name:find('Window') then
		                task.spawn(WindowAdded, Obj)
		            end
		        end
		
		        AntiBamboozle:Clean(workspace.ChildAdded:Connect(WindowAdded))
		    end,
		})
	end)

	Run(function() -- AntiBlink
		local AntiBlink
		        
		local PowerRemote
		
		local function EntityAdded(Entity)
		    if PowerRemote then return end
		
		    local Blink = Entity.Character:FindFirstChild('Blink')
		    local PowerValues = Blink and Blink:FindFirstChild('PowerValues')
		    PowerRemote = PowerValues and PowerValues:FindFirstChild('PowerRemote')
		
		    if not PowerRemote then
		        const TimeOut = os.clock() + 5
		        repeat
		            task.wait()
		            Blink = Entity.Character:FindFirstChild('Blink')
		            PowerValues = Blink and Blink:FindFirstChild('PowerValues')
		            PowerRemote = PowerValues and PowerValues:FindFirstChild('PowerRemote')
		        until PowerRemote or not AntiBlink.Enabled or os.clock() >= TimeOut
		
		        if not (PowerRemote and AntiBlink.Enabled) then return end
		    end
		
		    PowerRemote:FireServer('SetValue', 'Blinks', -9e9)
		end
		
		AntiBlink = Other:CreateModule({
		    Name = 'AntiBlink',
		    Info = 'Removes the ability for the nurse to blink (Gives them -9,000,000,000 blinks)',
		    Function = function(Enabled)
		        if Enabled then
		            for _, Entity in EntityLib.List do
		                EntityAdded(Entity)
		            end
		
		            AntiBlink:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
		        else
		            if PowerRemote then
		                PowerRemote:FireServer('SetValue', 'Blinks', 2)
		            end
		
		            PowerRemote = nil
		        end
		    end
		})
	end)

	Run(function() -- AntiBlock
		local AntiBlock
		
		local function WindowAdded(Window)
		    if Window.Name:find('Window') then
		        local Panel = Window:FindFirstChild('Panel')
		        local Blocked = Panel and Panel:FindFirstChild('Blocked')
		
		        if not Blocked then
		            const TimeOut = os.clock() + 5
		            repeat
		                task.wait()
		                Panel = Window:FindFirstChild('Panel')
		                Blocked = Panel and Panel:FindFirstChild('Blocked')
		            until Blocked or not AntiBlock.Enabled or os.clock() >= TimeOut
		
		            if not (Blocked and AntiBlock.Enabled) then return end
		        end
		
		        Blocked.Value = false
		        AntiBlock:Clean(Blocked:GetPropertyChangedSignal('Value'):Connect(function()
		            Blocked.Value = false
		        end))
		    end
		end
		
		AntiBlock = Other:CreateModule({
		    Name = 'AntiBlock',
		    Info = 'Prevents windows from getting blocked after the third vault',
		    Enabled = function()
		        for _, Obj in workspace:GetChildren() do
		            if Obj.Name:find('Window') then
		                task.spawn(WindowAdded, Obj)
		            end
		        end
		
		        AntiBlock:Clean(workspace.ChildAdded:Connect(WindowAdded))
		    end
		})
	end)

	Run(function() -- AutoDeadHard
		local AutoDeadHard, UseWhileDowned

		local function LocalAdded()
			AutoDeadHard:Clean(EntityLib.Character:GetAttributeChangedSignal('Blood'):Connect(function()
				Remotes.PerkEvent:FireServer('Dodge')
			end))
		end
		
		AutoDeadHard = PlayerCategory:CreateModule({
		    Name = 'AutoDeadHard',
		    Info = 'Automatically uses dead hard after you get hit',
		    Enabled = function()
				if UseWhileDowned.Enabled then
					AutoDeadHard:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					AutoDeadHard:Clean(dbr.Survivor.HealthState:GetPropertyChangedSignal('Value'):Connect(function()
						if dbr.Survivor.HealthState.Value == 0 then
							Remotes.PerkEvent:FireServer('Dodge')
						end
					end))
				end
		    end
		})
		
		UseWhileDowned = AutoDeadHard:CreateToggle({
		    Name = 'Use While Downed',
		    Info = 'Allows dead hard to be used while downed. When used while downed you instantly recover from the dying state.',
		})
	end)

	Run(function() -- BringPlayer
		local BringPlayer, Player
		
		BringPlayer = Other:CreateButton({
		    Name = 'Bring Player',
		    Info = 'Brings the specified player',
		    Function = function()
		        if Player and Player.Parent then
		            Remotes.ServerEvent:FireServer('Carry', 'Pickup_Default', Player)
		            task.wait(1)
		            Remotes.ServerEvent:FireServer('Carry', 'Drop_Default', nil)
		        else
		            Notify({
		                Text = 'Select a player first',
		                Duration = 5,
		                Type = 'Error'
		            })
		        end
		    end
		})
		
		BringPlayer:CreatePlayerTextBox({
		    Name = 'Player',
		    PlaceholderText = '[Player Name]',
		    Function = function(NewPlayer)
		        Player = NewPlayer
		    end
		})
	end)

	Run(function() -- ChainsawModifier
		local ChainsawModifier, SprintLimitX, SprintLimitY, SprintSensitivityX, SprintSensitivityY, FlickLimitX, FlickLimitY, FlickSensitivityX, FlickSensitivityY, FlickDuration, ChainsawMovementSpeed, ChargeMovementSpeed, StaggerMovementSpeed, HitRadius, HitRange, CrashRadius, CrashRange, CrashDuration, MissDuration, HitDuration
		
		ChainsawModifier = Movement:CreateModule({
		    Name = 'ChainsawModifier',
		    Info = 'Modifies Hillbilly\'s Chainsaw.',
		    Enabled = function()
				const Hillbilly = dbr.Killer.Hillbilly
		        const OldCamera, OldChainsawSettings, OldSpeeds, OldHitbox, OldAnimationTiming = table.clone(Hillbilly.Camera), table.clone(Hillbilly.Chainsaw_Settings), table.clone(Hillbilly.Speeds), table.clone(Hillbilly.Hitbox), table.clone(Hillbilly.Animation_Timing)

				ChainsawModifier:Clean(function()
					Hillbilly.Camera = OldCamera
					Hillbilly.Chainsaw_Settings = OldChainsawSettings
					Hillbilly.Speeds = OldSpeeds
					Hillbilly.Hitbox = OldHitbox
					Hillbilly.Animation_Timing = OldAnimationTiming
				end)

				Hillbilly.Camera.Sprint.Limits = Vector2.new(SprintLimitX.Value, SprintLimitY.Value)
				Hillbilly.Camera.Sprint.Sensitivity = Vector2.new(SprintSensitivityX.Value, SprintSensitivityY.Value)
				Hillbilly.Camera.Flick.Limits = Vector2.new(FlickLimitX.Value, FlickLimitY.Value)
				Hillbilly.Camera.Flick.Sensitivity = Vector2.new(FlickSensitivityX.Value, FlickSensitivityY.Value)
				Hillbilly.Chainsaw_Settings.Flick = FlickDuration.Value
				Hillbilly.Speeds.Sprinting = ChainsawMovementSpeed.Value
				Hillbilly.Speeds.Charging = ChargeMovementSpeed.Value
				Hillbilly.Speeds.Stagger = StaggerMovementSpeed.Value
				Hillbilly.Hitbox.Hit.Radius = HitRadius.Value
				Hillbilly.Hitbox.Hit.Range = HitRange.Value
				Hillbilly.Hitbox.Crash.Radius = CrashRadius.Value
				Hillbilly.Hitbox.Crash.Range = CrashRange.Value
				Hillbilly.Animation_Timing.Crash = CrashDuration.Value
				Hillbilly.Animation_Timing.None = MissDuration.Value
				Hillbilly.Animation_Timing.Hit = HitDuration.Value
		    end
		})
		
		SprintLimitX = ChainsawModifier:CreateSlider({
		    Name = 'Sprint Limit X',
		    Default = 65,
		    Min = 0,
		    Max = 650,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Sprint.Limits = Vector2.new(SprintLimitX.Value, SprintLimitY.Value)
		        end
		    end
		})
		
		SprintLimitY = ChainsawModifier:CreateSlider({
		    Name = 'Sprint Limit Y',
		    Default = 35,
		    Min = 0,
		    Max = 350,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Sprint.Limits = Vector2.new(SprintLimitX.Value, SprintLimitY.Value)
		        end
		    end
		})
		
		SprintSensitivityX = ChainsawModifier:CreateSlider({
		    Name = 'Sprint Sensitivity X',
		    Default = 0.5,
		    Min = 0,
		    Max = 5,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Sprint.Sensitivity = Vector2.new(SprintSensitivityX.Value, SprintSensitivityY.Value)
		        end
		    end
		})
		
		SprintSensitivityY = ChainsawModifier:CreateSlider({
		    Name = 'Sprint Sensitivity Y',
		    Default = 0.125,
		    Min = 0,
		    Max = 1.25,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Sprint.Sensitivity = Vector2.new(SprintSensitivityX.Value, SprintSensitivityY.Value)
		        end
		    end
		})
		
		FlickLimitX = ChainsawModifier:CreateSlider({
		    Name = 'Flick Limit X',
		    Default = 65,
		    Min = 0,
		    Max = 650,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Flick.Limits = Vector2.new(FlickLimitX.Value, FlickLimitY.Value)
		        end
		    end
		})
		
		FlickLimitY = ChainsawModifier:CreateSlider({
		    Name = 'Flick Limit Y',
		    Default = 35,
		    Min = 0,
		    Max = 350,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Flick.Limits = Vector2.new(FlickLimitX.Value, FlickLimitY.Value)
		        end
		    end
		})
		
		FlickSensitivityX = ChainsawModifier:CreateSlider({
		    Name = 'Flick Sensitivity X',
		    Default = 0.5,
		    Min = 0,
		    Max = 2,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Flick.Sensitivity = Vector2.new(FlickSensitivityX.Value, FlickSensitivityY.Value)
		        end
		    end
		})
		
		FlickSensitivityY = ChainsawModifier:CreateSlider({
		    Name = 'Flick Sensitivity Y',
		    Default = 0.125,
		    Min = 0,
		    Max = 1,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Camera.Flick.Sensitivity = Vector2.new(FlickSensitivityX.Value, FlickSensitivityY.Value)
		        end
		    end
		})
		
		FlickDuration = ChainsawModifier:CreateSlider({
		    Name = 'Flick Duration',
		    Default = 0.65,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Chainsaw_Settings.Flick = FlickDuration.Value
		        end
		    end
		})
		
		ChainsawMovementSpeed = ChainsawModifier:CreateSlider({
		    Name = 'Chainsaw Movement Speed',
		    Default = 35,
		    Min = 0,
		    Max = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Speeds.Sprinting = ChainsawMovementSpeed.Value
		        end
		    end
		})
		
		ChargeMovementSpeed = ChainsawModifier:CreateSlider({
		    Name = 'Charge Movement Speed',
		    Default = 12,
		    Min = 0,
		    Max = 60,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Speeds.Charging = ChargeMovementSpeed.Value
		        end
		    end
		})
		
		StaggerMovementSpeed = ChainsawModifier:CreateSlider({
		    Name = 'Stagger Movement Speed',
		    Default = 0,
		    Min = 0,
		    Max = 10,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Speeds.Stagger = StaggerMovementSpeed.Value
		        end
		    end
		})
		
		HitRadius = ChainsawModifier:CreateSlider({
		    Name = 'Hit Radius',
		    Default = 0.75,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Hitbox.Hit.Radius = HitRadius.Value
		        end
		    end
		})
		
		HitRange = ChainsawModifier:CreateSlider({
		    Name = 'Hit Range',
		    Default = 1,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Hitbox.Hit.Range = HitRange.Value
		        end
		    end
		})
		
		CrashRadius = ChainsawModifier:CreateSlider({
		    Name = 'Crash Radius',
		    Default = 0.75,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Hitbox.Crash.Radius = CrashRadius.Value
		        end
		    end
		})
		
		CrashRange = ChainsawModifier:CreateSlider({
		    Name = 'Crash Range',
		    Default = 1,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Hitbox.Crash.Range = CrashRange.Value
		        end
		    end
		})
		
		CrashDuration = ChainsawModifier:CreateSlider({
		    Name = 'Crash Duration',
		    Default = 4,
		    Min = 0,
		    Max = 8,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Animation_Timing.Crash = CrashDuration.Value
		        end
		    end
		})
		
		HitDuration = ChainsawModifier:CreateSlider({
		    Name = 'Hit Duration',
		    Default = 2,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Animation_Timing.None = MissDuration.Value
		        end
		    end
		})
		
		MissDuration = ChainsawModifier:CreateSlider({
		    Name = 'Miss Duration',
		    Default = 1.5,
		    Min = 0,
		    Max = 3,
		    Decimal = 100,
		    Function = function()
		        if ChainsawModifier.Enabled then
		            dbr.Killer.Hillbilly.Animation_Timing.Hit = HitDuration.Value
		        end
		    end
		})
	end)

	Run(function() -- DropPlayer
		local DropPlayer, Player
		
		DropPlayer = Other:CreateButton({
		    Name = 'Drop Player',
		    Info = 'Drops the specified player',
		    Function = function()
		        if Player and Player.Parent then
		            Remotes.ServerEvent:FireServer('Carry', 'Drop_Default', nil)
		        else
		            Notify({
		                Text = 'Select a player first',
		                Duration = 5,
		                Type = 'Error'
		            })
		        end
		    end
		})
		
		DropPlayer:CreatePlayerTextBox({
		    Name = 'Player',
		    PlaceholderText = '[Player Name]',
		    Function = function(NewPlayer)
		        Player = NewPlayer
		    end
		})
	end)

	Run(function() -- FastVaultModifier
		local FastVaultModifier, AllowAnyAngle, SpoofMoveDirection, NoDelay, Old
		
		FastVaultModifier = Movement:CreateModule({
		    Name = 'FastVaultModifier',
		    Info = 'Modifies fast vaults',
		    Enabled = function()
				if dbr.Survivor.VaultWindow then
					Old = dbr.Survivor.VaultWindow.Start
		
					dbr.Survivor.VaultWindow.Start = function(self, ...)
						if NoDelay.Enabled then
							dbr.Survivor.VaultWindow.Debounces.InputEnter = 0
							dbr.Survivor.VaultWindow.Debounces.InProgress = false
						end
						if AllowAnyAngle.Enabled and EntityLib.Alive then
							local Far = dbr.Survivor.VaultWindow.ActionInfo.Ports.Far
							local Close = dbr.Survivor.VaultWindow.ActionInfo.Ports.Close
							if Far and Close then
								local Start = vector.create(Close.Position.X, EntityLib.Root.Position.Y, Close.Position.Z)
								local Target = vector.create(Far.Position.X, EntityLib.Root.Position.Y, Far.Position.Z)
								EntityLib.Root.CFrame = CFrame.lookAt(Start, Target)
							end
			
							if SpoofMoveDirection.Enabled then
								EntityLib.Humanoid:Move(vector.xAxis)
							end
						end
			
						return Old(self, ...)
					end

					FastVaultModifier:Clean(dbr.Survivor.Action:GetPropertyChangedSignal('Value'):Connect(function()
						if NoDelay.Enabled and dbr.Survivor.Action.Value == 'SlidingPallet' then
							dbr.Survivor.Action.Value = 'Nothing'
						end
					end))
			
					FastVaultModifier:Clean(function()
						dbr.Survivor.VaultWindow.Start = Old
						Old = nil
					end)
				else
					Notify({
						Title = 'FastVaultModifier',
						Text = 'Your executor doesn\t support "require" this Module will not work.'
					})
				end
		    end
		})
		
		AllowAnyAngle = FastVaultModifier:CreateToggle({
		    Name = 'Allow Any Angle',
		    Info = 'Allows you to get a fast fault from any angle',
		    Default = true
		})
		
		SpoofMoveDirection = FastVaultModifier:CreateToggle({
		    Name = 'Spoof Move Direction',
		    Info = 'Allows you to get a fast vault while standing still',
		    Default = true
		})
		
		NoDelay = FastVaultModifier:CreateToggle({
		    Name = 'No Delay',
		    Info = 'Removes the 1 second cooldown between vaulting windows',
		    Default = true
		})
	end)

	Run(function() -- InfiniteDecisiveStrike
		local InfiniteDecisiveStrike
		
		local function OnHeld()
		    if dbr.Survivor.Held.Value then
		        Notify({
		            Title = 'InfiniteDecisiveStrike',
		            Text = 'Decisive Strike has been activated!',
		            Duration = 3
		        })
		
		        repeat
		            for _ = 1, 10 do
		                Remotes.ServerEvent:FireServer('Wiggle', 'Great')
		            end
		            task.wait()
		        until not dbr.Survivor.Held.Value or not InfiniteDecisiveStrike.Enabled
		    end
		end
		
		InfiniteDecisiveStrike = PlayerCategory:CreateModule({
		    Name = 'InfiniteDecisiveStrike',
		    Info = 'Instantly escapes the killer grasp when picked up',
		    Function = function(Enabled)
		        if Enabled then
		            InfiniteDecisiveStrike:Clean(dbr.Survivor.Held:GetPropertyChangedSignal('Value'):Connect(OnHeld))
		            OnHeld()
		        end
		    end,
		})
	end)

	Run(function() -- PickUpPlayer
		local PickUpPlayer
		
		local Player
		
		PickUpPlayer = Other:CreateButton({
		    Name = 'Pick Up Player',
		    Info = 'Picks up the specified player',
		    Function = function()
		        if Player and Player.Parent then
		            Remotes.ServerEvent:FireServer('Carry', 'Pickup_Default', Player)
		        else
		            Notify({
		                Text = 'Select a player first',
		                Duration = 5,
		                Type = 'Error'
		            })
		        end
		    end
		})
		
		PickUpPlayer:CreatePlayerTextBox({
		    Name = 'Player',
		    PlaceholderText = '[Player Name]',
		    Function = function(NewPlayer)
		        Player = NewPlayer
		    end
		})
	end)

	Run(function() -- PingSpoofer
		local Ping, PingSpoofer
		
		PingSpoofer = Other:CreateModule({
		    Name = 'PingSpoofer',
		    Info = 'Spoofs your ping in the dead by roblox tab',
		    Function = function(Enabled)
		        if Enabled then
		            Remotes.PingEvent.OnClientInvoke = function()
		                return Ping.Value / 2000
		            end
		        else
		            Remotes.PingEvent.OnClientInvoke = function()
		                return Plr:GetNetworkPing()
		            end
		        end
		    end
		})
		
		Ping = PingSpoofer:CreateSlider({
		    Name = 'Ping',
		    Default = 50,
		    Min = 0,
		    Max = 200,
		})
	end)

	Run(function() -- ServerSideDestroy
		local ServerSideDestroy
		
		local Object
		
		ServerSideDestroy = Other:CreateButton({
		    Name = 'ServerSideDestroy',
		    Info = 'Allows you to destroy any instance you want.\nYou must be playing as trapper for this to work.',
		    Function = function()
		        if Object and Object.Parent then
		            Remotes.ServerEvent:FireServer('Trap', 'Grab', Object)
		            Notify({
		                Text = `Destroyed Object: {ObjectFunctions:GetFullName(Object)}`
		            })
		        else
		            Notify({
		                Text = 'Select an instance first',
		                Duration = 5,
		                Type = 'Error'
		            })
		        end
		    end
		})
		
		ServerSideDestroy:CreateTextBox({
		    Name = 'Object',
		    PlaceholderText = '[Object Path]',
		    Function = function(Text, Loaded)
		        if Text:match('%w+') then
		            local Function = loadstring(`return {Text}`)
		            if typeof(Function) == 'function' then
		                local Obj = Function()
		                if typeof(Obj) == 'Instance' then
		                    Object = Obj
		                else
		                    if Loaded then return end
		
		                    Notify({
		                        Text = `Invalid type '{typeof(Obj)}'`,
		                        Duration = 5,
		                        Type = 'Error'
		                    })
		                end
		
		                if Loaded then return end
		                
		                Notify({
		                    Text = `Set instance path to {ObjectFunctions:GetFullName(Object)}`,
		                    Duration = 3
		                })
		            elseif not Loaded then
		                Notify({
		                    Text = Function,
		                    Duration = 5,
		                    Type = 'Error'
		                })
		            end
		        else
		            Object = nil
		        end
		    end
		})
	end)

	Run(function() -- TrapGiver
		local TrapGiver
		
		TrapGiver = Other:CreateModule({
		    Name = 'TrapGiver',
		    Info = 'Gives you traps until disabled',
		    Function = function(Enabled)
		        if Enabled then
		            TrapGiver:Clean(task.spawn(function()
		                repeat
		                    Remotes.ServerEvent:FireServer('Trap', 'Grab')
		                    task.wait(0.75)
		                until not TrapGiver.Enabled
		            end))
		        else
		            Remotes.ServerEvent:FireServer('Trap', 'Place', true, CFrame.identity)
		
		            TrapGiver:Clean(workspace.ChildAdded:Once(function(Child)
		                if Child.Name:find('Trap') then
		                    Remotes.ServerEvent:FireServer('Trap', 'Grab', Child)
		                end
		            end))
		        end
		    end
		})
	end)
end)

Run(function() -- Animations
	Run(function() -- EmotePlayer
		local EmotePlayer, PointKeybind, FollowKeybind, CaliforniaGirlsKeybind, GetEmKeybind, ThinkKeybind, BowShotKeybind, Track, OverwriteOtherKeys
		
		local Anims = {
		    Point = {ID = 'rbxassetid://16520476888'},
		    Follow = {ID = 'rbxassetid://16520472961'},
		    CaliforniaGirls = {ID = 'rbxassetid://10258272240', Loop = true},
		    GetEm = {ID = 'rbxassetid://15919624781', Loop = true},
		    Think = {ID = 'rbxassetid://121839807114786'},
		    BowShot = {ID = 'rbxassetid://131833227843012'},
		}
		
		local ActionName
		
		local Playing = {}
		
		local function PlayAnimation(Emote)
			local PlayingEmote = Playing[Emote]
		    if PlayingEmote then
		        PlayingEmote:Stop()
		        Playing[Emote] = nil
				if Anims[Emote].Loop then return end
		    end

			local Animation = Instance.new('Animation')
			Animation.AnimationId = Anims[Emote].ID
	
			Track = EntityLib.Animator:LoadAnimation(Animation)
			Track.Priority = Enum.AnimationPriority.Action4
			Track.Looped = Anims[Emote].Loop or false
			Track:Play()
	
			Playing[Emote] = Track
		end
		
		local function KeyPress(_, State, Input)
		    if State == Enum.UserInputState.End or UIS:GetFocusedTextBox() then return end
		    for Name, Anim in Anims do
		        if Anim.Keybind:Check(Input) then
		            PlayAnimation(Name)
					break
		        end
		    end
		end
		
		local function GetKeyCode(Keybind)
		    return Keybind ~= 'None' and Enum.KeyCode[Keybind] or nil
		end
		
		local function UpdateAction()
		    if not EmotePlayer.Enabled then return end
		
		    local BindedKeys = {
		        GetKeyCode(PointKeybind.Keybind),
		        GetKeyCode(FollowKeybind.Keybind),
		        GetKeyCode(CaliforniaGirlsKeybind.Keybind),
		        GetKeyCode(GetEmKeybind.Keybind),
		        GetKeyCode(ThinkKeybind.Keybind),
		        GetKeyCode(BowShotKeybind.Keybind)
		    }
		    
		    ContextActionService:BindActionAtPriority(`EmotePlayer{ActionName}`, KeyPress, false, 69420, table.unpack(BindedKeys))
		end
		
		EmotePlayer = Animations:CreateModule({
		    Name = 'EmotePlayer',
		    Info = 'Allows you to bind dead by roblox emotes to different keys.',
		    Function = function(Enabled)
		        if Enabled then
		            if OverwriteOtherKeys.Enabled then
		                ActionName = HttpService:GenerateGUID(false)
		                UpdateAction()
		            else
		                EmotePlayer:Clean(UIS.InputBegan:Connect(function(Input)
		                    KeyPress(nil, Enum.UserInputState.Begin, Input)
		                end))
		            end
		        else
		            for _, v in Playing do
		                v:Stop()
		            end
		            table.clear(Playing)
		
		            if ActionName then
		                ContextActionService:UnbindAction(ActionName)
		                ActionName = nil
		            end
		        end
		    end
		})
		
		OverwriteOtherKeys = EmotePlayer:CreateToggle({
		    Name = 'Overwrite Other Keys',
		    Function = function()
		        EmotePlayer:Restart()
		    end
		})
		
		PointKeybind = EmotePlayer:CreateKeybind({
		    Name = 'Point',
		    Keybind = 'One',
		    Function = UpdateAction
		})
		
		FollowKeybind = EmotePlayer:CreateKeybind({
		    Name = 'Follow',
		    Keybind = 'Two',
		    Function = UpdateAction
		})
		
		CaliforniaGirlsKeybind = EmotePlayer:CreateKeybind({
		    Name = 'California Girls',
		    Keybind = 'Three',
		    Function = UpdateAction
		})
		
		GetEmKeybind = EmotePlayer:CreateKeybind({
		    Name = 'Get Em',
		    Keybind = 'Four',
		    Function = UpdateAction
		})
		
		ThinkKeybind = EmotePlayer:CreateKeybind({
		    Name = 'Think',
		    Keybind = 'Five',
		    Function = UpdateAction
		})
		
		BowShotKeybind = EmotePlayer:CreateKeybind({
		    Name = 'Bow Shot',
		    Keybind = 'Six',
		    Function = UpdateAction
		})
		
		Anims.Point.Keybind = PointKeybind
		Anims.Follow.Keybind = FollowKeybind
		Anims.CaliforniaGirls.Keybind = CaliforniaGirlsKeybind
		Anims.GetEm.Keybind = GetEmKeybind
		Anims.Think.Keybind = ThinkKeybind
		Anims.BowShot.Keybind = BowShotKeybind
	end)
end)