const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
	return cloneref(game:GetService(Service))
end

const Lighting: Lighting = GetService('Lighting')
const Players: Players = GetService('Players')
const RunService: RunService = GetService('RunService')
const UIS: UserInputService = GetService('UserInputService')
const TweenService: TweenService = GetService('TweenService')
const ReplicatedStorage: ReplicatedStorage = GetService('ReplicatedStorage')

const TidalWave = shared.TidalWave
const Categories = TidalWave.Categories
const Modules = TidalWave.Modules
const Libraries = TidalWave.Libraries
const EntityLib = Libraries.EntityLib
const Drawing = Libraries.Drawing
const ObjectFunctions = Libraries.ObjectFunctions
const Signal = Libraries.Signal
const Color3 = Libraries.Color3
const table = Libraries.table
const vector = Libraries.vector

const Combat = Categories.Combat
const PlayerCategory = Categories.Player
const Movement = Categories.Movement
const Visuals = Categories.Visuals
const World = Categories.World
const Other = Categories.Other

const Plr: Player = Players.LocalPlayer
local Camera: Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
const rng = Random.new()

TidalWave:Clean(workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
	Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
end))

const function RollChance(Chance: number): boolean
	if Chance == 100 then return true end
	return rng.NextInteger(rng, 1, 100) <= Chance
end

const function Notify(Properties)
	TidalWave:Notify(Properties)
end

const function Run(f)
	return f()
end

const function SafeRef(Obj, Path): Instance?
	return ObjectFunctions:SafeRef(Obj, Path)
end

const function NotifyPoopSploit(FunctionName: string)
	Notify({
		Title = 'Poop Sploit',
		Text = `Your executor doesn't support '{FunctionName}'`,
		Type = 'Error',
		Duration = 5,
	})
end

const function GetMouseLocation(): Vector2
	if UIS.TouchEnabled then
		return Camera.ViewportSize / 2
	end

	return UIS.GetMouseLocation(UIS)
end

local fs, Zombies

do
	local PlayerScripts, GuiManager, MainGui, CharGui

	const InitSuccess = TidalWave:WaitForInit(function()
		Zombies = workspace:FindFirstChild('Zombies')
		PlayerScripts = Plr:FindFirstChildOfClass('PlayerScripts')
		GuiManager = PlayerScripts and PlayerScripts:FindFirstChild('GuiManager')
		MainGui = GuiManager and GuiManager:FindFirstChild('MainGui')
		CharGui = MainGui and MainGui:FindFirstChild('CharGui')
		return PlayerScripts and Zombies and GuiManager and MainGui and CharGui
	end)
	if not InitSuccess then return end

	fs = {
		CharGui = require(CharGui),
	}
end

Run(function() -- EntityLib
	function EntityLib:IsTeammate(Entity)
		return Entity.Player ~= nil
	end

	function EntityLib:GetEntityColor(Entity)
		return Entity.Player and Color3.Green or Color3.Red
	end

	TidalWave:Clean(Zombies.ChildAdded:Connect(function(Zombie)
		EntityLib:AddEntity(Zombie)
	end))

	TidalWave:Clean(Zombies.ChildRemoved:Connect(function(Zombie)
		EntityLib:RemoveEntity(Zombie)
	end))

	for _, Zombie in Zombies:GetChildren() do
		EntityLib:AddEntity(Zombie)
	end
end)

for _, v in {'SilentAim', 'TriggerBot', 'Reach', 'KillAura', 'AutoClicker', 'HitboxExpander'} do
	TidalWave:RemoveModule(v)
end

Run(function() -- Combat
	Run(function() -- SilentAim
		local SilentAim, WallCheck, Mode, Range, HitChance, HeadshotChance, AutoFire, AutoFireKeybind, MaxDistance
		local Circle, OutlineColor, FillColor, OutlineTransparency, FillTransparency, Thickness

		local OldNamecall, CircleObject
		local Pressed = false

		const IGNORED_SCRIPTS = {
			Invisicam = true,
			CameraModule = true,
			Popper = true,
			ClickToMoveController = true,
			ClickToMoveDisplay = true,
			PathDisplay = true
		}
		
		const function RemoveCircle()
			if CircleObject then
				CircleObject:Destroy()
				CircleObject = nil
			end
		end

		const function CreateCircle()
			RemoveCircle()
			CircleObject = Drawing.new('Circle')
			CircleObject.Radius = Range.Value
			CircleObject.FillTransparency = FillTransparency.Value
			CircleObject.OutlineTransparency = OutlineTransparency.Value
			CircleObject.FillColor = FillColor.Color
			CircleObject.OutlineColor = OutlineColor.Color
			CircleObject.Thickness = Thickness.Value
			CircleObject.Position = GetMouseLocation()
			CircleObject.Visible = true
			CircleObject.Parent = TidalWave.Gui
		end
		
		const function UpdateCircle()
			if CircleObject then
				CircleObject.Radius = Range.Value
				CircleObject.FillTransparency = FillTransparency.Value
				CircleObject.OutlineTransparency = OutlineTransparency.Value
				CircleObject.FillColor = FillColor.Color
				CircleObject.OutlineColor = OutlineColor.Color
				CircleObject.Thickness = Thickness.Value
			end
		end

		const function Sort(a, b)
			const aChar, bChar = a.Entity.Character, b.Entity.Character
			const aIsGuardian, bIsGuardian = aChar.Name == 'GuardianZombie', bChar.Name == 'GuardianZombie'
			if aIsGuardian and bIsGuardian then
				return a.Magnitude < b.Magnitude
			elseif bIsGuardian then
				return false
			end

			return aIsGuardian or a.Magnitude < b.Magnitude
		end

		const function GetTarget(Origin, IgnoreList)
			if RollChance(HitChance.Value) then
				const TargetPart = RollChance(HeadshotChance.Value) and 'Head' or 'Root'
				const EntityFunction = Mode.Value == 'Mouse' and EntityLib.GetClosestEntityWithinMouse or EntityLib.GetClosestEntity
				const Entity = EntityFunction(EntityLib, {
					Range = Range.Value,
					Part = TargetPart,
					Origin = Origin,
					IgnoreList = IgnoreList,
					WallCheck = WallCheck.Enabled,
					Players = false,
					NPCs = true,
					Sort = Sort
				})

				return Entity, Entity and Entity[TargetPart] or nil, Origin
			end

			return nil
		end

		SilentAim = Combat:CreateModule({
			Name = 'SilentAim',
			Tooltip = 'Silently adjusts your aim towards the closest zombie.',
			ExtraText = 'FinalStand',
			Function = function(Enabled)
				if Enabled then
					OldNamecall = hookmetamethod(game, '__namecall', function(self, ...)
						if getnamecallmethod() ~= 'FindPartOnRayWithIgnoreList' or checkcaller() then return OldNamecall(self, ...) end

						const Caller = getcallingscript()
						if Caller and IGNORED_SCRIPTS[Caller.Name] then return OldNamecall(self, ...) end

						const Args = {...}
						if typeof(Args[1]) == 'Ray' then
							const Entity, TargetPart, Origin = GetTarget(Args[1].Origin, {Args[2]})
							if Entity then
								const Direction = vector.normalize(TargetPart.Position - Origin)
								Args[1] = Ray.new(Origin, Direction * vector.magnitude(Args[1].Direction :: vector))
							end
						end

						return OldNamecall(self, table.unpack(Args))
					end)

					if Circle.Enabled and Mode.Value ~= 'Position' then
						CreateCircle()
					end

					local Button = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'TouchControls', 'RightSide', 'AttackButton'})
					Pressed = false

					SilentAim:Clean(RunService.PreRender:Connect(function()
						if CircleObject then
							CircleObject.Position = GetMouseLocation()
						end

						if AutoFire.Enabled then
							if Button then
								const TargetPart = RollChance(HeadshotChance.Value) and 'Head' or 'Root'
								const EntityFunction = Mode.Value == 'Mouse' and EntityLib.GetClosestEntityWithinMouse or EntityLib.GetClosestEntity
								const Entity = EntityFunction(EntityLib, {
									Range = Mode.Value == 'Mouse' and Range.Value or MaxDistance.Value,
									Part = TargetPart,
									WallCheck = WallCheck.Enabled,
									Players = false,
									NPCs = true,
									Sort = Sort
								})

								if Entity and not Pressed then
									Pressed = true
									firesignal(Button.MouseButton1Down)
								elseif Pressed then
									Pressed = false
									firesignal(Button.InputEnded)
								end
							else
								Button = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'TouchControls', 'RightSide', 'AttackButton'})
							end
						end
					end))
				else
					RemoveCircle()

					if OldNamecall then
						hookmetamethod(game, '__namecall', OldNamecall)
						OldNamecall = nil
					end
				end
			end,
		})

		WallCheck = SilentAim:CreateToggle({
			Name = 'Wall Check',
			Default = true
		})
		
		Mode = SilentAim:CreateDropdown({
			Name = 'Mode',
			List = {'Mouse', 'Position'},
			Tooltip = 'Mouse - Checks for entities near the mouse\'s position\nPosition - Checks for entities near the local character',
			Function = function(Val)
				if Val == 'Mouse' and SilentAim.Enabled and Circle.Enabled then
					CreateCircle()
				else
					RemoveCircle()
				end
			end,
		})

		Range = SilentAim:CreateSlider({
			Name = 'Range',
			Default = 100,
			Min = 1,
			Max = 1000,
			Suffix = 'px',
			Function = UpdateCircle,
		})
		
		HitChance = SilentAim:CreateSlider({
			Name = 'Hit Chance',
			Default = 100,
			Min = 0,
			Max = 100,
			Suffix = '%'
		})

		HeadshotChance = SilentAim:CreateSlider({
			Name = 'Headshot Chance',
			Default = 65,
			Min = 0,
			Max = 100,
			Suffix = '%'
		})

		AutoFire = SilentAim:CreateToggle({
			Name = 'Auto Fire',
			Tooltip = 'Automatically fires when certain conditions are met.',
			Function = function(Enabled)
				if Pressed and not Enabled then
					Pressed = false
					const Button = SafeRef(Plr, {'PlayerGui', 'ScreenGui', 'TouchControls', 'RightSide', 'AttackButton'})
					if Button then
						firesignal(Button.InputEnded)
					end
				end
			end
		})

		AutoFireKeybind = AutoFire:CreateKeybind({
			Name = 'Auto Fire',
		})

		AutoFireKeybind.Triggered:Connect(function(Pressed, Held)
			if Pressed or (Held and AutoFire.Enabled ~= Held) then
				AutoFire:Toggle()
			end
		end)

		MaxDistance = AutoFire:CreateSlider({
			Name = 'Max Distance',
			Default = 1000,
			Min = 0,
			Max = 1000
		})

		Circle = Mode:BindToggleTo('Mouse', {
			Name = 'Range Circle',
			Function = function(Enabled)
				if Enabled and SilentAim.Enabled then
					CreateCircle()
				else
					RemoveCircle()
				end
			end
		})

		OutlineColor = Circle:CreateColorPicker({
			Name = 'Outline Color',
			Function = UpdateCircle
		})

		FillColor = Circle:CreateColorPicker({
			Name = 'Fill Color',
			Transparency = 1,
			Function = UpdateCircle
		})

		OutlineTransparency = Circle:CreateTransparencySlider({
			Name = 'Outline Transparency',
			Function = UpdateCircle
		})

		FillTransparency = Circle:CreateTransparencySlider({
			Name = 'Fill Transparency',
			Default = 1,
			Function = UpdateCircle,
		})

		Thickness = Circle:CreateSlider({
			Name = 'Thickness',
			Default = 1,
			Min = 1,
			Max = 10,
			Function = UpdateCircle
		})
	end)
end)

Run(function() -- Other
	Run(function() -- NoRecoil
		local NoRecoil

		NoRecoil = Other:CreateModule({
			Name = 'NoRecoil',
			Tooltip = 'Removes gun recoil.',
			Enabled = function()
				const Old = fs.CharGui.AddRecoil
				fs.CharGui.AddRecoil = function() end
				NoRecoil:Clean(function()
					fs.CharGui.AddRecoil = Old
				end)
			end
		})
	end)

	Run(function() -- AutoReload
		local AutoReload

		local CachedEnvs = {}
		local LastTool
		local Reload
		local Con

		const function ChildAdded(Obj)
			if Obj:IsA('Tool') and not Con then
				LastTool = Obj
				const Script = Obj:FindFirstChildOfClass('LocalScript')
				const CurrentValues = Obj:FindFirstChild('CurrentValues')
				const Clip = CurrentValues and CurrentValues:FindFirstChild('Clip')
				if Script and CurrentValues and Clip then
					const Env = CachedEnvs[Script] or getsenv(Script)
					Reload = Env.reload
					if not CachedEnvs[Script] then
						CachedEnvs[Script] = Env
					end

					Con = AutoReload:Clean(Clip:GetPropertyChangedSignal('Value'):Connect(function()
						if Clip.Value <= 0 and Reload then
							task.delay(0.25, Reload)
						end
					end))
				end
			end
		end

		const function ChildRemoved(Obj)
			if Obj == LastTool then
				LastTool = nil
				Reload = nil

				if Con then
					Con:Disconnect()
					Con = nil
				end
			end
		end

		const function LocalAdded()
			AutoReload:Clean(EntityLib.Character.ChildAdded:Connect(ChildAdded))
			AutoReload:Clean(EntityLib.Character.ChildRemoved:Connect(ChildRemoved))

			const Tool = EntityLib.Character:FindFirstChildOfClass('Tool')
			if Tool then
				ChildAdded(Tool)
			end
		end

		const function LocalRemoved()
			table.clear(CachedEnvs)
		end

		AutoReload = Other:CreateModule({
			Name = 'AutoReload',
			Tooltip = 'Automatically reloads your gun.',
			Function = function(Enabled)
				if Enabled then
					AutoReload:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					AutoReload:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					table.clear(CachedEnvs)
					LastTool = nil
					Reload = nil
					Con = nil
				end
			end
		})
	end)

	Run(function() -- AutoSkip
		local AutoSkip

		AutoSkip = Other:CreateModule({
			Name = 'AutoSkip',
			Tooltip = 'Automatically skips day.',
			Enabled = function()
				const VoteSkip = ReplicatedStorage.RemoteFunctions.VoteSkip
				const CanVote = ReplicatedStorage.Values.Vote

				AutoSkip:Clean(CanVote:GetPropertyChangedSignal('Value'):Connect(function()
					VoteSkip:InvokeServer()
				end))

				if CanVote.Value then
					VoteSkip:InvokeServer()
				end
			end
		})
	end)
end)