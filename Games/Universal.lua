const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
	return cloneref(game:GetService(Service))
end

const Lighting: Lighting = GetService('Lighting')
const Players: Players = GetService('Players')
const RunService: RunService = GetService('RunService')
const TeleportService: TeleportService = GetService('TeleportService')
const TextService: TextService = GetService('TextService')
const UIS: UserInputService = GetService('UserInputService')
const HttpService: HttpService = GetService('HttpService')
const ProximityPromptService: ProximityPromptService = GetService('ProximityPromptService')
const ContextActionService: ContextActionService = GetService('ContextActionService')
const GuiService: GuiService = GetService('GuiService')
const TweenService: TweenService = GetService('TweenService')
const Stats: Stats = GetService('Stats')
const TextChatService: TextChatService = GetService('TextChatService')
const UserGameSettings = UserSettings():GetService('UserGameSettings')

const TidalWave = shared.TidalWave
const Categories = TidalWave.Categories
const Modules = TidalWave.Modules
const Libraries = TidalWave.Libraries
const EntityLib = Libraries.EntityLib
const Drawing = Libraries.Drawing
const ObjectFunctions = Libraries.ObjectFunctions
const Signal = Libraries.Signal
const AuraAnimations = Libraries.AuraAnimations
const Prediction = Libraries.Prediction

const Combat = Categories.Combat
const PlayerCategory = Categories.Player
const Movement = Categories.Movement
const Visuals = Categories.Visuals
const World = Categories.World
const Other = Categories.Other
const Animations = Categories.Animations
const Hud = TidalWave.Menus.HUD

const IsStudio = RunService:IsStudio()
const Plr: Player = Players.LocalPlayer
local Camera: Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))

const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)

const table = table.clone(table)
table.len = function(Tab)
	local Len = 0
	for _ in Tab do
		Len += 1
	end
	
	return Len
end

const UDim2 = table.clone(UDim2)
UDim2.zero = UDim2.new()

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

const newcclosure = newcclosure or function(f) return f end
const getnamecallmethod = getnamecallmethod or get_namecall_method
const iswindowactive = iswindowactive or isrbxactive 
const require = (IsStudio or (not table.find({'Solara', 'Xeno'}, identifyexecutor and ({identifyexecutor()})[1] or 'Solara'))) and require or nil
const loadstring = IsStudio and require(script.Parent.Parent.Libraries.Loadstring) or loadstring

const GetTextBoundsParams = Instance.new('GetTextBoundsParams')
const TopBar = TidalWave.Gui.ScaledGui.Gui.TopBar
local ViewmodelTool
local ViewmodelMotor
local TargetStrafeVector
const rng = Random.new()

TidalWave:Clean(workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
	Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
end))

--#region Functions

const function Notify(Properties)
	TidalWave:Notify(Properties)
end

const function Run(f)
	f()
end

const function SafeRef(Obj, Path): Instance?
	return ObjectFunctions:SafeRef(Obj, Path)
end

const function RollChance(Chance: number): boolean
	if Chance == 100 then return true end
	return rng.NextInteger(rng, 1, 100) <= Chance
end

const function NotifyPoopSploit(FunctionName: string)
	Notify({
		Title = 'Poop Sploit',
		Text = `Your executor doesn't support '{FunctionName}'`,
		Type = 'Error',
		Duration = 5,
	})
end

const function GetTextBounds(Text, TextSize, Font, Width)
	GetTextBoundsParams.Text = Text
	GetTextBoundsParams.Font = Font
	GetTextBoundsParams.Size = TextSize
	GetTextBoundsParams.Width = Width or 9e9
	GetTextBoundsParams.RichText = Text:match('<[^<>]->') ~= nil

	return TextService:GetTextBoundsAsync(GetTextBoundsParams)
end

const function IsFriend(Player): boolean
	return TidalWave:IsFriend(Player)
end

const function GetFullPlayerName(Player): string
	return Player.DisplayName == Player.Name and Player.Name or `{Player.DisplayName} (@{Player.Name})`
end

const function GetFullName(Object): string?
	return ObjectFunctions:GetFullName(Object)
end

const function CanClick(): boolean
	if TopBar.Visible then return false end
	if UIS:GetFocusedTextBox() then return false end
	if iswindowactive and not iswindowactive() then return false end

	return true
end

const function GetMouseLocation(): Vector2
	if UIS.TouchEnabled then
		return Camera.ViewportSize / 2
	end

	return UIS:GetMouseLocation()
end

const function IsThirdPerson(): boolean
	return vector.magnitude(Camera.CFrame.Position - Camera.Focus.Position :: vector) > 0.6
end

const function IsFirstPerson(): boolean
	return not IsThirdPerson()
end

const FrictionTable = {}
const OldPhysicalProperties = {}

local FrictionAddedConnection
local FrictionRemovedConnection

const function FrictionChildAdded(Obj)
	if Obj:IsA('BasePart') and Obj ~= EntityLib.Root and not OldPhysicalProperties[Obj] then
		OldPhysicalProperties[Obj] = Obj.CustomPhysicalProperties or 'None'
		Obj.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.2, 0.5, 1, 1)
	end
end

const function DisconnectFrictionConnections()
	if FrictionAddedConnection then
		FrictionAddedConnection:Disconnect()
		FrictionAddedConnection = nil
	end
	if FrictionRemovedConnection then
		FrictionRemovedConnection:Disconnect()
		FrictionRemovedConnection = nil
	end
end

const function UpdateFriction()
	if table.len(FrictionTable) > 0 then
		if EntityLib.Alive then
			for _, Obj in EntityLib.Character:GetChildren() do
				FrictionChildAdded(Obj)
			end

			DisconnectFrictionConnections()

			FrictionAddedConnection = EntityLib.Character.ChildAdded:Connect(FrictionChildAdded)
			FrictionRemovedConnection = EntityLib.Character.ChildRemoved:Connect(function(Obj)
				OldPhysicalProperties[Obj] = nil
			end)
		end
	else
		DisconnectFrictionConnections()
		
		for Part, Old in OldPhysicalProperties do
			Part.CustomPhysicalProperties = Old ~= 'None' and Old or nil
		end
		table.clear(OldPhysicalProperties)
	end
end

TidalWave:Clean(EntityLib.Events.LocalAdded:Connect(UpdateFriction))
TidalWave:Clean(EntityLib.Events.LocalRemoved:Connect(DisconnectFrictionConnections))
TidalWave:Clean(DisconnectFrictionConnections)

--#endregion Functions

Run(function() -- Combat
	Run(function() -- Aimbot
		local Aimbot, Method, WallCheck, Part, Range, Speed
		local Circle, OutlineColor, FillColor, Thickness
		
		local CircleObject
		
		const function CreateCircle()
			CircleObject = Drawing.new('Circle')
			CircleObject.Radius = Range.Value
			CircleObject.FillTransparency = FillColor.Transparency
			CircleObject.OutlineTransparency = OutlineColor.Transparency
			CircleObject.FillColor = FillColor.Color
			CircleObject.OutlineColor = OutlineColor.Color
			CircleObject.Thickness = Thickness.Value
			CircleObject.Position = GetMouseLocation()
			CircleObject.Visible = Aimbot.Enabled
			CircleObject.Parent = TidalWave.Gui
		end
		
		const function RemoveCircle()
			if CircleObject then
				CircleObject:Destroy()
				CircleObject = nil
			end
		end
		
		const function UpdateCircle()
			if CircleObject then
				CircleObject.Radius = Range.Value
				CircleObject.FillTransparency = FillColor.Transparency
				CircleObject.OutlineTransparency = OutlineColor.Transparency
				CircleObject.FillColor = FillColor.Color
				CircleObject.OutlineColor = OutlineColor.Color
				CircleObject.Thickness = Thickness.Value
			end
		end
		
		Aimbot = Combat:CreateModule({
			Name = 'Aimbot',
			Info = 'Automatically moves your mouse towards the closest player',
			Function = function(Enabled)
				if Enabled then
					if Circle.Enabled and not CircleObject then
						CreateCircle()
					end
					
					Aimbot:Clean(RunService.PreRender:Connect(function(Delta)
						if CircleObject then
							CircleObject.Position = GetMouseLocation()
						end
		
						if EntityLib.Alive and CanClick() then
							const Entity, ScreenPoint = EntityLib:GetClosestEntityWithinMouse({
								Part = Part.Value,
								Range = Range.Value,
								Origin = Camera.CFrame.Position,
								WallCheck = WallCheck.Enabled,
								NPCs = true,
								Players = true
							})
		
							if Entity then
								if Method.Value == 'Camera' then
									Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Entity[Part.Value].Position)
								else
									const MouseLocation = GetMouseLocation()
									local MouseDelta = Vector2.new(ScreenPoint.X - MouseLocation.X, ScreenPoint.Y - MouseLocation.Y) / UserGameSettings.MouseSensitivity
									if MouseDelta.Magnitude > 1 then
										MouseDelta *= math.min(Speed.Value * Delta, 1)
										mousemoverel(MouseDelta.X, MouseDelta.Y)
									end
								end
							end
						end
					end))
				else
					RemoveCircle()
				end
			end
		})
		
		Method = Aimbot:CreateDropdown({
			Name = 'Method',
			List = {'Mouse', 'Camera'}
		})
		
		WallCheck = Aimbot:CreateToggle({
			Name = 'Wall Check',
			Default = true
		})
		
		Part = Aimbot:CreateDropdown({
			Name = 'Part',
			List = {'Head', 'Root', 'Closest'}
		})
		
		Range = Aimbot:CreateSlider({
			Name = 'Range',
			Default = 100,
			Min = 0,
			Max = 1000,
			Function = UpdateCircle
		})
		
		Speed = Aimbot:CreateSlider({
			Name = 'Speed',
			Default = 10,
			Min = 1,
			Max = 30,
			Decimal = 10
		})
		
		Circle = Aimbot:CreateToggle({
			Name = 'Range Circle',
			Function = function(Enabled)
				if Enabled and Aimbot.Enabled then
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
		
		Thickness = Circle:CreateSlider({
			Name = 'Thickness',
			Default = 1,
			Min = 1,
			Max = 10,
			Function = UpdateCircle
		})
	end)

	Run(function() -- AutoClicker
		local AutoClicker, CPS
		
		local Tool

		const function MousePressed()
			repeat
				Tool:Activate()
				task.wait(1 / CPS.Value)
			until not Tool or not (AutoClicker.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and CanClick())
		end

		const function ChildAdded(Obj)
			if Obj:IsA('Tool') then
				Tool = Obj
				
				if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and CanClick() then
					MousePressed()
				end
			end
		end
		
		const function LocalAdded()
			const CurrentTool = EntityLib.Character:FindFirstChildOfClass('Tool')
			if CurrentTool then
				ChildAdded(CurrentTool)
			end

			AutoClicker:Clean(EntityLib.Character.ChildAdded:Connect(ChildAdded))
			AutoClicker:Clean(EntityLib.Character.ChildRemoved:Connect(function(Obj)
				if Obj == Tool then
					Tool = nil
				end
			end))
		end

		const function LocalRemoved()
			AutoClicker:CleanUp()
			Tool = nil
		end

		AutoClicker = Combat:CreateModule({
			Name = 'AutoClicker',
			Info = 'Automatically clicks for you',
			Function = function(Enabled)
				if Enabled then
					if EntityLib.Alive then
						LocalAdded()
					end

					AutoClicker:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					AutoClicker:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					AutoClicker:Clean(UIS.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 and Tool and CanClick() then
							MousePressed()
						end
					end))
				else
					Tool = nil
				end
			end
		})

		CPS = AutoClicker:CreateSlider({
			Name = 'Clicks per second',
			Default = 5,
			Min = 1,
			Max = 20
		})
	end)

	Run(function() -- HitboxExpander
		local HitboxExpander, Target, Color, X, Y, Z, Collision
		
		const Parts = {}
		const db = {}
		
		const function AddPart(Part)
			const Tab = {
				Size = Part.Size,
				Color = Part.Color,
				Transparency = Part.Transparency,
				CanCollide = Part.CanCollide
			}
		
			Part.Size = vector.create(X.Value, Y.Value, Z.Value)
			Part.Color = Color.Color
			Part.Transparency = Color.Transparency
			Part.CanCollide = Collision.Enabled
			
			HitboxExpander:Clean(Part.Changed:Connect(function(Property)
				if Tab[Property] then
					if db[Part] then return end
					db[Part] = true
		
					if Property == 'CanCollide' then
						Part.CanCollide = Collision.Enabled
					end
		
					Tab[Property] = Part[Property]
					db[Part] = nil
				end
			end))
		
			Parts[Part] = Tab
		end
		
		HitboxExpander = Combat:CreateModule({
			Name = 'HitboxExpander',
			Info = 'Expands the hitbox of enemies',
			Function = function(Enabled)
				if Enabled then
					HitboxExpander:Clean(RunService.PreSimulation:Connect(function()
						for _, Entity in EntityLib.List do
							if Entity.Teammate then continue end
							if Target.Value == 'Head' then
								if Entity.Head and not Parts[Entity.Head] then
									AddPart(Entity.Head)
								end
							elseif Target.Value == 'Root' then
								if Entity.Root and not Parts[Entity.Root] then
									AddPart(Entity.Root)
								end
							elseif Target.Value == 'All' then
								for _, Part in Entity.Character:QueryDescendants('BasePart') do
									if Parts[Part] then continue end
									AddPart(Part)
								end
							end
						end
					end))
				else
					for Part, Properties in Parts do
						for Property, Value in Properties do
							Part[Property] = Value
						end
					end
					table.clear(Parts)
					table.clear(db)
				end
			end
		})
		
		const function UpdateSize()
			if not HitboxExpander.Enabled then return end
			for Part in Parts do
				db[Part] = true
				Part.Size = vector.create(X.Value, Y.Value, Z.Value)
			end
			table.clear(db)
		end
		
		X = HitboxExpander:CreateSlider({
			Name = 'X Size',
			Default = 5,
			Min = 1,
			Max = 20,
			Function = UpdateSize
		})
		
		Y = HitboxExpander:CreateSlider({
			Name = 'Y Size',
			Default = 5,
			Min = 1,
			Max = 20,
			Function = UpdateSize
		})
		
		Z = HitboxExpander:CreateSlider({
			Name = 'Z Size',
			Default = 5,
			Min = 1,
			Max = 20,
			Function = UpdateSize
		})
		
		Target = HitboxExpander:CreateDropdown({
			Name = 'Target',
			List = {'Head', 'Root', 'All'},
			Function = function()
				HitboxExpander:Restart()
			end
		})
		
		Color = HitboxExpander:CreateColorPicker({
			Name = 'Color',
			Default = Color3.fromRGB(163, 162, 165),
			Function = function(Color, Transparency)
				for Part in Parts do
					db[Part] = true
					Part.Color = Color
					Part.Transparency = Transparency
				end
				table.clear(db)
			end
		})
		
		Collision = HitboxExpander:CreateToggle({
			Name = 'Collision',
			Info = 'Toggles the collision of modified parts',
			Function = function(Enabled)
				for Part in Parts do
					db[Part] = true
					Part.CanCollide = Enabled
				end
				table.clear(db)
			end
		})
	end)

	Run(function() -- KillAura
		local KillAura, UsePlayers, UseNPCs, WallCheck, MaxTargets, CPS, SwingRange, AttackRange, AngleSlider, RequireMouseDown, Lunge
		local BoxSwingColor, BoxAttackColor, ParticleTexture, ParticleSize, ParticleColor1, ParticleColor2, Face
		local AnimationEnabled, Animation, AnimationSpeed, UpdateRate
		
		local OldC0, Tween, StopTween, Attacking
		local Tool, TouchInterest
		local AttackDelay = 0
		local First = false
		
		const Particles = {}
		const Boxes = {}
		const Bounds = vector.create(4, 4, 4)
		
		const Params = OverlapParams.new()
		Params.FilterType = Enum.RaycastFilterType.Include
		
		const function MouseCheck()
			if RequireMouseDown.Enabled and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				return false
			end
		
			return true
		end
		
		const function LocalAdded()
			Tool = EntityLib.Character:FindFirstChildWhichIsA('Tool', true)
			TouchInterest = Tool and Tool:FindFirstChildWhichIsA('TouchTransmitter', true) or nil
		
			KillAura:Clean(EntityLib.Character.ChildAdded:Connect(function(Child)
				if Child:IsA('Tool') then
					Tool = Child
					TouchInterest = Tool:FindFirstChildWhichIsA('TouchTransmitter', true)
				end
			end))
		
			KillAura:Clean(EntityLib.Character.ChildRemoved:Connect(function(Child)
				if Child == Tool then
					Tool = nil
					TouchInterest = nil
				end
			end))
		end
		
		const function LocalRemoved()
			KillAura:CleanUp()
			Tool = nil
			TouchInterest = nil
		end

		const function EndTween()
			First = true
			Tween:Cancel()
			Tween = nil

			StopTween = TweenService:Create(ViewmodelMotor, TweenInfo.new(0.3 / AnimationSpeed.Value, Enum.EasingStyle.Exponential), {C0 = OldC0})
			StopTween:Play()
			StopTween.Completed:Once(function(State)
				if State == Enum.PlaybackState.Completed then
					StopTween = nil
				end
			end)
		end

		const function StartAnimLoop()
			KillAura:Clean(task.spawn(function()
				while KillAura.Enabled do
					if not OldC0 and ViewmodelMotor then
						OldC0 = ViewmodelMotor.C0
					end

					if ViewmodelMotor and OldC0 then
						if Attacking then
							if StopTween then
								StopTween:Cancel()
								StopTween = nil
							end

							for _, Keyframe in AuraAnimations[Animation.Value] do
								const Duration = (First and 0.1 or Keyframe.Duration) / AnimationSpeed.Value
								const EasingStyle = Keyframe.EasingStyle or Enum.EasingStyle.Linear
								const EasingDirection = Keyframe.EasingDirection or Enum.EasingDirection.Out
								const Info = TweenInfo.new(Duration, EasingStyle, EasingDirection)
								const Goal = {C0 = OldC0 * Keyframe.CFrame}

								Tween = TweenService:Create(ViewmodelMotor, Info, Goal)
								First = nil
								Tween:Play()
								Tween.Completed:Wait()

								if not (Attacking and ViewmodelMotor) then break end
							end
						elseif Tween and not Attacking then
							EndTween()
						end
					end

					task.wait(1 / UpdateRate.Value)
				end
			end))
		end

		const function AttackEntities(Entities)
			local Faced = false
			const Attacked = {}
			const LocalPosition = EntityLib.Root.Position
			const LookVector = EntityLib.Root.CFrame.LookVector * vector.hort
			const MaxAngle = math.rad(AngleSlider.Value) / 2
			const Now = os.clock()

			for _, Entity in Entities do
				const Position = Entity.Root.Position
				const Diff = vector.create(Position.X - LocalPosition.X, 0, Position.Z - LocalPosition.Z)
				const Direction = vector.normalize(Diff)
				const Dot = vector.dot(LookVector, Direction)

				if math.acos(Dot) > MaxAngle then continue end

				const PastAttackRange = vector.magnitude(Diff) > AttackRange.Value

				table.insert(Attacked, {
					Entity = Entity,
					Color = PastAttackRange and BoxSwingColor.Color or BoxAttackColor.Color,
					Transparency = PastAttackRange and BoxSwingColor.Transparency or BoxAttackColor.Transparency
				})

				Attacking = true

				if Face.Enabled and not Faced then
					Faced = true
					EntityLib.Root.CFrame = CFrame.lookAlong(LocalPosition, Direction)
				end

				if AttackDelay < Now then
					AttackDelay = Now + (1 / CPS.Value)
					Tool:Activate()
				end

				if firetouchinterest and not PastAttackRange then
					Params.FilterDescendantsInstances = {Entity.Character}
					for _, Part in workspace:GetPartBoundsInBox(Entity.Root.CFrame, Bounds, Params) do
						firetouchinterest(TouchInterest.Parent, Part, true)
						firetouchinterest(TouchInterest.Parent, Part, false)
					end
				end
			end

			return Attacked
		end

		const function PlayVisuals(Attacked)
			for i, Box in Boxes do
				const Tab = Attacked[i]
				if Tab then
					Box.Adornee = Tab.Entity.Root
					Box.Color3 = Tab.Color
					Box.Transparency = Tab.Transparency
				else
					Box.Adornee = nil
				end
			end

			for i, Particle in Particles do
				const Tab = Attacked[i]
				if Tab then
					Particle.Position = Tab.Entity.Root.Position
					Particle.Parent = Camera
				else
					Particle.Parent = nil
				end
			end
		end

		const function ClearVisuals()
			for i, Box in Boxes do
				Box.Adornee = nil
			end

			for i, Particle in Particles do
				Particle.Parent = nil
			end
		end
		
		KillAura = Combat:CreateModule({
			Name = 'KillAura',
			Info = 'Automatically attacks players around you',
			Function = function(Enabled)
				if Enabled then
					KillAura:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					KillAura:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					
					if EntityLib.Alive then
						LocalAdded()
					end
		
					if AnimationEnabled.Enabled then
						StartAnimLoop()
					end
					
					while KillAura.Enabled do
						if Tool and TouchInterest and MouseCheck() then
							if Lunge.Enabled and Tool.GripUp.X == 0 then return end
							Attacking = false

							const Entities = EntityLib:GetClosestEntities({
								Range = SwingRange.Value,
								WallCheck = WallCheck.Enabled,
								Players = UsePlayers.Enabled,
								NPCs = UseNPCs.Enabled,
								Limit = MaxTargets.Value,
								Part = 'Root',
							})

							if #Entities > 0 then
								const Attacked = AttackEntities(Entities)
								PlayVisuals(Attacked)
							end
						else
							ClearVisuals()
						end

						if not Attacking and Tween then
							EndTween()
						end

						task.wait()
					end
				else
					if Tween then
						EndTween()
					end

					ClearVisuals()

					Tool = nil
					TouchInterest = nil
					Attacking = false
				end
			end,
		})
		
		UsePlayers = KillAura:CreateToggle({
			Name = 'Players',
			Default = true
		})
		
		UseNPCs = KillAura:CreateToggle({
			Name = 'NPCs',
		})
		
		WallCheck = KillAura:CreateToggle({
			Name = 'Wall Check',
		})
		
		CPS = KillAura:CreateSlider({
			Name = 'Attacks Per Second',
			Default = 10,
			Min = 1,
			Max = 20
		})
		
		SwingRange = KillAura:CreateSlider({
			Name = 'Swing Range',
			Min = 1,
			Max = 30,
			Default = 13
		})
		
		AttackRange = KillAura:CreateSlider({
			Name = 'Attack Range',
			Min = 1,
			Max = 30,
			Default = 13
		})
		
		AngleSlider = KillAura:CreateSlider({
			Name = 'Max Angle',
			Min = 1,
			Max = 360,
			Default = 90
		})
		
		MaxTargets = KillAura:CreateSlider({
			Name = 'Max Targets',
			Min = 1,
			Max = 10,
			Default = 10
		})
		
		RequireMouseDown = KillAura:CreateToggle({
			Name = 'Require Mouse Down'
		})
		
		Lunge = KillAura:CreateToggle({
			Name = 'Sword Lunge Only'
		})
		
		Face = KillAura:CreateToggle({
			Name = 'Face target'
		})
		
		local ShowTarget
		ShowTarget = KillAura:CreateToggle({
			Name = 'Show target',
			Function = function(Enabled)
				if Enabled then
					local KillAuraTargets = Instance.new('Folder')
					KillAuraTargets.Name = 'KillAuraTargets'
					KillAuraTargets.Parent = TidalWave.Gui

					ShowTarget:Clean(KillAuraTargets)
		
					for i = 1, 10 do
						local Box = Instance.new('BoxHandleAdornment')
						Box.Adornee = nil
						Box.AlwaysOnTop = true
						Box.Size = vector.create(3, 5, 3)
						Box.CFrame = CFrame.new(0, -0.5, 0)
						Box.ZIndex = 0
						Box.Parent = KillAuraTargets
						Boxes[i] = Box
					end
				else
					table.clear(Boxes)
				end
			end
		})
		
		BoxSwingColor = ShowTarget:CreateColorPicker({
			Name = 'Target Color',
			Color = Color3.fromRGB(0, 100, 255),
			Transparency = 0.5
		})
		
		BoxAttackColor = ShowTarget:CreateColorPicker({
			Name = 'Attack Color',
			Color = Color3.fromRGB(255, 0, 0),
			Transparency = 0.5
		})
		
		local TargetParticles = KillAura:CreateToggle({
			Name = 'Target Particles',
			Function = function(Enabled)
				if Enabled then
					for i = 1, 10 do
						local Part = Instance.new('Part')
						Part.Size = vector.create(2, 4, 2)
						Part.Anchored = true
						Part.CanCollide = false
						Part.CanTouch = false
						Part.CanQuery = false
						Part.AudioCanCollide = false
						Part.Transparency = 1
						Part.Parent = KillAura.Enabled and Camera or nil
						
						local Particle = Instance.new('ParticleEmitter')
						Particle.Brightness = 1.5
						Particle.Size = NumberSequence.new(ParticleSize.Value)
						Particle.Shape = Enum.ParticleEmitterShape.Sphere
						Particle.Texture = ParticleTexture.Value
						Particle.Transparency = NumberSequence.new(0)
						Particle.Lifetime = NumberRange.new(0.4)
						Particle.Speed = NumberRange.new(16)
						Particle.Rate = 128
						Particle.Drag = 16
						Particle.ShapePartial = 1
						Particle.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, ParticleColor1.Color),
							ColorSequenceKeypoint.new(1, ParticleColor2.Color)
						})
		
						Particle.Parent = Part
						Particles[i] = Part
					end
				else
					for _, Particle in Particles do
						Particle:Destroy()
					end
					table.clear(Particles)
				end
			end
		})
		
		ParticleTexture = TargetParticles:CreateAssetTextBox({
			Name = 'Texture',
			Default = 'rbxassetid://14736249347',
			Placeholder = '[rbxassetid://1234567890]',
			Function = function(Asset)
				for _, v in Particles do
					v.ParticleEmitter.Texture = Asset
				end
			end,
		})
		
		ParticleColor1 = TargetParticles:CreateColorPicker({
			Name = 'Color Begin',
			Function = function(Color)
				for _, Particle in Particles do
					Particle.ParticleEmitter.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color),
						ColorSequenceKeypoint.new(1, Color)
					})
				end
			end,
		})
		
		ParticleColor2 = TargetParticles:CreateColorPicker({
			Name = 'Color End',
			Function = function(Color)
				for _, Particle in Particles do
					Particle.ParticleEmitter.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color),
						ColorSequenceKeypoint.new(1, Color)
					})
				end
			end,
		})
		
		ParticleSize = TargetParticles:CreateSlider({
			Name = 'Size',
			Min = 0,
			Max = 1,
			Default = 0.2,
			Decimal = 100,
			Function = function(Val)
				for _, Particle in Particles do
					Particle.ParticleEmitter.Size = NumberSequence.new(Val)
				end
			end,
		})
		
		AnimationEnabled = KillAura:CreateToggle({
			Name = 'Custom Animation',
			Info = 'Plays a custom Viewmodel animation',
			Function = function(Enabled)
				if Enabled and not Modules.Viewmodel.Enabled then
					Modules.Viewmodel:Toggle(true)
				end

				KillAura:Restart()
			end
		})
		
		local List = {}
		for Name in AuraAnimations do
			table.insert(List, Name)
		end
		
		Animation = AnimationEnabled:CreateDropdown({
			Name = 'Aura Animation',
			List = List
		})
		
		AnimationSpeed = AnimationEnabled:CreateSlider({
			Name = 'Animation Speed',
			Default = 1,
			Min = 0,
			Max = 2,
			Decimal = 100
		})
		
		UpdateRate = AnimationEnabled:CreateSlider({
			Name = 'Update Rate',
			Default = 60,
			Min = 10,
			Max = 240
		})
	end)

	Run(function() -- Reach
		local Reach, UsePlayers, UseNPCs, Mode, Value, Chance
				
		local Tool, TouchInterest
		
		const Params = OverlapParams.new()
		Params.FilterType = Enum.RaycastFilterType.Include

		const Modified = {}
		
		const function LocalAdded()
			Tool = EntityLib.Character:FindFirstChildWhichIsA('Tool', true)
			TouchInterest = Tool and Tool:FindFirstChildWhichIsA('TouchTransmitter', true) or nil
		
			Reach:Clean(EntityLib.Character.ChildAdded:Connect(function(Child)
				if Child:IsA('Tool') then
					Tool = Child
					TouchInterest = Tool:FindFirstChildWhichIsA('TouchTransmitter', true)
				end
			end))
		
			Reach:Clean(EntityLib.Character.ChildRemoved:Connect(function(Child)
				if Child == Tool then
					Tool = nil
					TouchInterest = nil
				end
			end))
		end
		
		const function LocalRemoved()
			Reach:CleanUp()
			Tool = nil
			TouchInterest = nil
		end
		
		Reach = Combat:CreateModule({
			Name = 'Reach',
			Info = 'Extends tool attack reach',
			Function = function(Enabled)
				if Enabled then
					if EntityLib.Alive then
						LocalAdded()
					end
		
					Reach:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Reach:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
		
					repeat
						if Tool and TouchInterest then
							if Mode.Value == 'TouchInterest' and firetouchinterest then
								local Entities = {}
								for _, Entity in EntityLib.List do
									if Entity.Player and not UsePlayers.Enabled then continue end
									if Entity.NPC and not UseNPCs.Enabled then continue end
									if Entity.Teammate then continue end
									if EntityLib:CanAttack(Entity) then
										table.insert(Entities, Entity.Character)
									end
								end
		
								Params.FilterDescendantsInstances = Entities
								local Parts = workspace:GetPartBoundsInBox(TouchInterest.Parent.CFrame * CFrame.new(0, 0, Value.Value / 2), TouchInterest.Parent.Size + vector.create(0, 0, Value.Value), Params)
		
								for _, Part in Parts do
									if RollChance(Chance.Value) then
										firetouchinterest(TouchInterest.Parent, Part, true)
										firetouchinterest(TouchInterest.Parent, Part, false)
									else
										task.wait(0.2)
										break
									end
								end
							else
								if not Modified[TouchInterest.Parent] then
									Modified[TouchInterest.Parent] = {
										Size = TouchInterest.Parent.Size,
										Massless = TouchInterest.Parent.Massless
									}
								end
		
								TouchInterest.Parent.Size = Modified[TouchInterest.Parent].Size + vector.create(0, 0, Value.Value)
								TouchInterest.Parent.Massless = true
							end
						end
		
						task.wait()
					until not Reach.Enabled
				else
					Tool = nil
					TouchInterest = nil
		
					for Part, Properties in Modified do
						for Property, Value in Properties do
							Part[Property] = Value
						end
					end
					table.clear(Modified)
				end
			end,
		})
		
		UsePlayers = Reach:CreateToggle({
			Name = 'Players',
			Default = true
		})
		
		UseNPCs = Reach:CreateToggle({
			Name = 'NPCs',
		})
		
		Mode = Reach:CreateDropdown({
			Name = 'Mode',
			List = {'TouchInterest', 'Resize'},
			Info = 'TouchInterest - Reports fake collision events to the server\n Resize - Physically modifies the tools size',
		})
		
		Value = Reach:CreateSlider({
			Name = 'Range',
			Default = 2,
			Min = 0,
			Max = 2,
			Decimal = 10
		})
		
		Chance = Mode:BindSliderTo('TouchInterest', {
			Name = 'Chance',
			Default = 100,
			Min = 1,
			Max = 100,
			Suffix = '%'
		})
	end)

	Run(function() -- SilentAim
		local SilentAim, UsePlayers, UseNPCs, WallCheck, Mode, Method, RayMethod, IgnoredScripts, Range, HitChance, HeadshotChance
		local AutoFire, AutoFireShootDelay, AutoFireMode, Wallbang, FunctionHook, OthHook
		local OutlineColor, FillColor, Thickness
		local Projectile, ProjectileSpeed, ProjectileGravity

		const RaycastWhitelist, ProjectileRaycast = RaycastParams.new(), RaycastParams.new()
		RaycastWhitelist.FilterType = Enum.RaycastFilterType.Include
		ProjectileRaycast.RespectCanCollide = true

		local OldNamecall, OldHook, Hookmethod, CircleObject
		local FireOffset = CFrame.identity
		local DidOth = false
		local MouseClicked = false
		local ClickDelay = 0
		
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
			CircleObject.FillTransparency = FillColor.Transparency
			CircleObject.OutlineTransparency = OutlineColor.Transparency
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
				CircleObject.FillTransparency = FillColor.Transparency
				CircleObject.OutlineTransparency = OutlineColor.Transparency
				CircleObject.FillColor = FillColor.Color
				CircleObject.OutlineColor = OutlineColor.Color
				CircleObject.Thickness = Thickness.Value
			end
		end

		const function GetTarget(Origin, IgnoreList)
			if RollChance(AutoFire.Enabled and 100 or HitChance.Value) then
				const TargetPart = RollChance(AutoFire.Enabled and 100 or HeadshotChance.Value) and 'Head' or 'Root'
				const EntityFunction = Mode.Value == 'Mouse' and EntityLib.GetClosestEntityWithinMouse or EntityLib.GetClosestEntity
				const Entity = EntityFunction(EntityLib, {
					Range = Range.Value,
					Part = TargetPart,
					Origin = Origin,
					IgnoreList = IgnoreList,
					WallCheck = WallCheck.Enabled,
					Players = UsePlayers.Enabled,
					NPCs = UseNPCs.Enabled
				})

				if Entity and Projectile.Enabled then
					ProjectileRaycast.FilterDescendantsInstances = {Entity.Character}
					ProjectileRaycast.CollisionGroup = Entity[TargetPart].CollisionGroup
				end

				return Entity, Entity and Entity[TargetPart] or nil, Origin
			end

			return nil
		end
		
		local Hooks = {
			FindPartOnRayWithIgnoreList = {
				Hook = workspace.FindPartOnRayWithIgnoreList,
				Function = function(Args)
					if typeof(Args[1]) ~= 'Ray' then return end
					local Entity, TargetPart, Origin = GetTarget(Args[1].Origin, {Args[2]})
					if not Entity then return end

					if Wallbang.Enabled then
						return {
							TargetPart,
							TargetPart.Position,
							TargetPart:GetClosestPointOnSurface(Origin),
							TargetPart.Material
						}
					end

					const Direction = vector.normalize(TargetPart.Position - Origin)

					Args[1] = Ray.new(Origin, Direction * vector.magnitude(Args[1].Direction :: vector))

					return nil
				end
			},
			Raycast = {
				Hook = workspace.Raycast,
				Function = function(Args)
					if typeof(Args[1]) ~= 'Vector3' or typeof(Args[2]) ~= 'Vector3' or (Args[3] and typeof(Args[3]) ~= 'RaycastParams') then return end
					if RayMethod.Value ~= 'All' and Args[3] and Args[3].FilterType ~= Enum.RaycastFilterType[RayMethod.Value] then return end

					local Entity, TargetPart, Origin = GetTarget(Args[1])
					if not Entity then return end

					const Direction = vector.normalize(TargetPart.Position - Origin)

					Args[2] = Direction * vector.magnitude(Args[2] :: vector)

					if Wallbang.Enabled then
						RaycastWhitelist.FilterDescendantsInstances = {TargetPart}
						Args[3] = RaycastWhitelist
					end
				end
			},
			ScreenPointToRay = {
				Hook = Instance.new('Camera').ScreenPointToRay,
				Function = function(Args)
					if typeof(Args[1]) ~= 'number' or typeof(Args[2]) ~= 'number' or (Args[3] and typeof(Args[3]) ~= 'number') then return end

					local Entity, TargetPart, Origin = GetTarget(Camera.CFrame.Position)
					if not Entity then return end

					local Direction = vector.normalize(TargetPart.Position - Origin)
					if Projectile.Enabled then
						local PredictedPosition = Prediction.SolveTrajectory(Origin, ProjectileSpeed.Value, ProjectileGravity.Value, TargetPart.Position, TargetPart.AssemblyLinearVelocity, workspace.Gravity, Entity.HipHeight, nil, ProjectileRaycast)
						if PredictedPosition then
							Direction = vector.normalize(PredictedPosition - Origin)
						end
					end

					return {
						Ray.new(Origin + (Args[3] and Direction * Args[3] or vector.zero), Direction)
					}
				end
			},
			Ray = {
				Hook = Ray.new,
				Function = function(Args)
					if typeof(Args[1]) ~= 'Vector3' or typeof(Args[2]) ~= 'Vector3' then return end

					local Entity, TargetPart, Origin = GetTarget(Args[1])
					if not Entity then return end

					local Direction = vector.normalize(TargetPart.Position - Origin)

					if Projectile.Enabled then
						local PredictedPosition = Prediction.SolveTrajectory(Origin, ProjectileSpeed.Value, ProjectileGravity.Value, TargetPart.Position, TargetPart.AssemblyLinearVelocity, workspace.Gravity, Entity.HipHeight, nil, ProjectileRaycast)
						if PredictedPosition then
							Direction = vector.normalize(PredictedPosition - Origin)
						end
					end

					Args[2] = Direction * vector.magnitude(Args[2])
				end,
				NoNamecall = true
			}
		}

		for _, Method in {'FindPartOnRayWithWhitelist', 'FindPartOnRay'} do
			Hooks[Method] = table.clone(Hooks.FindPartOnRayWithIgnoreList)
			Hooks[Method].Hook = workspace[Method]
		end
		
		Hooks.ViewportPointToRay = table.clone(Hooks.ScreenPointToRay)
		Hooks.ViewportPointToRay.Hook = Instance.new('Camera').ViewportPointToRay
		
		const function NamecallHook(...)
			if getnamecallmethod() ~= Method.Value or checkcaller() then return OldNamecall(...) end

			const Caller = getcallingscript()
			if Caller and table.find(IgnoredScripts.Enabled, tostring(Caller)) then return OldNamecall(...) end

			const self, Args = ..., {select(2, ...)}
			const Data = Hookmethod.Function(Args)
			if Data then
				return table.unpack(Data)
			end

			return OldNamecall(self, table.unpack(Args))
		end

		const function IndexHook(...)
			if checkcaller() then return OldHook(...) end

			const Caller = getcallingscript()
			if Caller and table.find(IgnoredScripts.Enabled, tostring(Caller)) then return OldNamecall(...) end

			if Hookmethod.NoNamecall then
				const Args = {...}
				const Data = Hookmethod.Function(Args)
				if Data then
					return table.unpack(Data)
				end

				return OldHook(table.unpack(Args))
			else
				const self, Args = ..., {select(2, ...)}
				const Data = Hookmethod.Function(Args)
				if Data then
					return table.unpack(Data)
				end

				return OldHook(self, table.unpack(Args))
			end
		end

		SilentAim = Combat:CreateModule({
			Name = 'SilentAim',
			Tooltip = 'Silently adjusts your aim towards the enemy',
			Function = function(Enabled)
				if Enabled then
					Hookmethod = Hooks[Method.Value]
					DidOth = OthHook.Enabled
					
					if FunctionHook.Enabled or Hookmethod.NoNamecall then
						OldHook = (OthHook.Enabled and oth.hook or hookfunction)(Hookmethod.Hook, IndexHook)
					end

					if not Hookmethod.NoNamecall then
						OldNamecall = OthHook.Enabled and oth.hook(getrawmetatable(game).__namecall, NamecallHook) or hookmetamethod(game, '__namecall', NamecallHook)
					end

					CreateCircle()

					SilentAim:Clean(RunService.PreRender:Connect(function()
						CircleObject.Position = GetMouseLocation()

						if AutoFire.Enabled and mouse1press and mouse1release then
							const Origin = AutoFireMode.Value == 'Camera' and Camera.CFrame or EntityLib.Alive and EntityLib.Root.CFrame or CFrame.identity
							const EntityFunction = Mode.Value == 'Mouse' and EntityLib.GetClosestEntityWithinMouse or EntityLib.GetClosestEntity
							const Entity = EntityFunction(EntityLib, {
								Range = Range.Value,
								WallCheck = WallCheck.Enabled,
								Part = 'Head',
								Origin = (Origin * FireOffset).Position,
								Players = UsePlayers.Enabled,
								NPCs = UseNPCs.Enabled
							})
							
							if Entity and CanClick() then
								const Now = os.clock()
								if ClickDelay < Now then
									if MouseClicked then
										mouse1release()
										ClickDelay = Now + AutoFireShootDelay.Value
									else
										mouse1press()
									end

									MouseClicked = not MouseClicked
								end
							else
								if MouseClicked then
									mouse1release()
								end

								MouseClicked = false
							end
						end
					end))
				else
					RemoveCircle()

					const RestoreFunction = DidOth and oth.unhook or restorefunction

					if OldHook then
						RestoreFunction(Hookmethod.Hook)
						OldHook = nil
					end

					if OldNamecall then
						RestoreFunction(getrawmetatable(game).__namecall)
						OldNamecall = nil
					end
				end
			end,
			ExtraText = function()
				return Method.Value ~= 'FindPartOnRay' and Method.Value:gsub('FindPartOnRay', '') or Method.Value
			end,
		})

		UsePlayers = SilentAim:CreateToggle({
			Name = 'Players',
			Default = true
		})

		UseNPCs = SilentAim:CreateToggle({
			Name = 'NPCs'
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
				if Val == 'Mouse' and SilentAim.Enabled then
					CreateCircle()
				else
					RemoveCircle()
				end
			end,
		})

		Method = SilentAim:CreateDropdown({
			Name = 'Method',
			List = {'FindPartOnRay', 'FindPartOnRayWithIgnoreList', 'FindPartOnRayWithWhitelist', 'ScreenPointToRay', 'ViewportPointToRay', 'Raycast', 'Ray'},
			Tooltip = 'FindPartOnRay* - Deprecated methods of raycasting used in old games\nRaycast - The modern raycast method\n*PointToRay - Method to generate a ray from a screen position\nRay - Used in old games',
			Restart = true
		})

		RayMethod = Method:BindDropdownTo('Raycast', {
			Name = 'Raycast Type',
			List = {'All', 'Exclude', 'Include'}
		})

		IgnoredScripts = SilentAim:CreateTextList({
			Name = 'Ignored Scripts',
			Default = {'CameraModule', 'Invisicam', 'Popper', 'ClickToMoveController', 'ClickToMoveDisplay', 'PathDisplay'}
		})

		Range = SilentAim:CreateSlider({
			Name = 'Range',
			Default = 100,
			Min = 1,
			Max = 1000,
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
			Name = 'AutoFire',
		})

		AutoFireShootDelay = AutoFire:CreateSlider({
			Name = 'Next Shot Delay',
			Default = 0.1,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Suffix = 's'
		})

		AutoFireMode = AutoFire:CreateDropdown({
			Name = 'Origin',
			List = {'RootPart', 'Camera'},
			Tooltip = 'Determines the position to check for before shooting'
		})

		AutoFire:CreateTextBox({
			Name = 'Offset',
			Default = '0, 0, 0',
			Function = function(Text)
				local X, Y, Z = table.unpack(Text:split(','))
				X, Y, Z = tonumber(X), tonumber(Y), tonumber(Z)
				if X and Y and Z then
					FireOffset = CFrame.new(X, Y, Z)
				end
			end,
		})

		Wallbang = SilentAim:CreateToggle({
			Name = 'Wallbang',
		})

		FunctionHook = SilentAim:CreateToggle({
			Name = 'Function hook',
			Tooltip = 'Hook the function used for index calling (used on some games)',
			Restart = true
		})
		
		OthHook = SilentAim:CreateToggle({
			Name = 'Oth hook',
			Tooltip = 'Hook the function using a less detected method (useful on some games)',
			Restart = true
		})

		const Circle = Mode:BindToggleTo('Mouse', {
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

		Thickness = Circle:CreateSlider({
			Name = 'Thickness',
			Default = 1,
			Min = 1,
			Max = 10
		})

		Projectile = SilentAim:CreateToggle({
			Name = 'Projectile',
		})

		ProjectileSpeed = Projectile:CreateSlider({
			Name = 'Speed',
			Default = 1000,
			Min = 1,
			Max = 1000
		})

		ProjectileGravity = Projectile:CreateSlider({
			Name = 'Gravity',
			Default = 196.2,
			Min = 0,
			Max = 500
		})
	end)

	Run(function() -- TriggerBot
		local TriggerBot, UsePlayers, UseNPCs, Mode, Interval, MaxDistance
		
		local Params = RaycastParams.new()
		Params.RespectCanCollide = true

		local ClickDelay = 0
		local MouseClicked = false

		const function GetTriggerBotTarget()
			local MouseLocation = GetMouseLocation()
			local MouseRaycast = Camera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
			local Raycast = workspace:Raycast(MouseRaycast.Origin, MouseRaycast.Direction * MaxDistance.Value, Params)
			local Hit = Raycast and Raycast.Instance or nil

			if Hit then
				for _, Entity in EntityLib.List do
					if Entity.Player and not UsePlayers.Enabled then continue end
					if Entity.NPC and not UseNPCs.Enabled then continue end
					if Entity.Teammate then continue end

					if EntityLib:CanAttack(Entity) and Hit:IsDescendantOf(Entity.Character) then
						return Entity
					end
				end
			end

			return nil
		end
		
		TriggerBot = Combat:CreateModule({
			Name = 'TriggerBot',
			Info = 'Automatically clicks when hovering over another player',
			Function = function(Enabled)
				if Enabled then
					TriggerBot:Clean(RunService.PreRender:Connect(function()
						local Entity = EntityLib.Alive and CanClick() and GetTriggerBotTarget() or nil

						if Entity then
							if Mode.Value == 'Hold' then
								if not MouseClicked then
									mouse1press()
									MouseClicked = true
								end
							else
								const Now = os.clock()
								if ClickDelay < Now then
									if MouseClicked then
										mouse1release()
										ClickDelay = Now + Interval.Value
									else
										mouse1press()
									end
		
									MouseClicked = not MouseClicked
								end
							end
						elseif MouseClicked then
							mouse1release()
							MouseClicked = false
						end
					end))

					const Exclusions = {}
		
					const function RefreshExclusions()
						table.clear(Exclusions)
						if EntityLib.Alive then
							table.insert(Exclusions, EntityLib.Character)
						end

						for _, Entity in EntityLib.List do
							if Entity.Teammate then
								table.insert(Exclusions, Entity.Character)
							end
						end

						Params.FilterDescendantsInstances = Exclusions
					end
			
					RefreshExclusions()

					TriggerBot:Clean(EntityLib.Events.EntityAdded:Connect(RefreshExclusions))
					TriggerBot:Clean(EntityLib.Events.EntityRemoved:Connect(RefreshExclusions))
					TriggerBot:Clean(EntityLib.Events.LocalAdded:Connect(RefreshExclusions))
					TriggerBot:Clean(EntityLib.Events.LocalRemoved:Connect(RefreshExclusions))
				end
			end,
		})

		UsePlayers = TriggerBot:CreateToggle({
			Name = 'Players',
			Default = true
		})

		UseNPCs = TriggerBot:CreateToggle({
			Name = 'NPCs'
		})
		
		Mode = TriggerBot:CreateDropdown({
			Name = 'Mode',
			List = {'Click', 'Hold'},
		})

		Interval = Mode:BindSliderTo('Click', {
			Name = 'Interval',
			Default = 0.1,
			Min = 0,
			Max = 1,
			Decimal = 100
		})
		
		MaxDistance = TriggerBot:CreateSlider({
			Name = 'Max Distance',
			Default = 1000,
			Min = 0,
			Max = 1000
		})
	end)
end)

Run(function() -- Player
	Run(function() -- AntiRagdoll
		local AntiRagdoll
		
		local OldFallingDown = true
		
		const function LocalAdded()
			local db = false

			OldFallingDown = EntityLib.Humanoid:GetStateEnabled(Enum.HumanoidStateType.FallingDown)
			EntityLib.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

			if EntityLib.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
				EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end

			AntiRagdoll:Clean(EntityLib.Humanoid.StateEnabledChanged:Connect(function(State, Enabled)
				if db then
					db = false
					return
				end

				if State == Enum.HumanoidStateType.FallingDown then
					OldFallingDown = Enabled
					if Enabled then
						db = true
						EntityLib.Humanoid:SetStateEnabled(State, false)
					end
				end
			end))
		end
		
		AntiRagdoll = PlayerCategory:CreateModule({
			Name = 'AntiRagdoll',
			Info = 'Prevents your character from falling over',
			Function = function(Enabled)
				if Enabled then
					AntiRagdoll:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					if EntityLib.Alive then
						EntityLib.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, OldFallingDown)
					end
				end
			end
		})
	end)

	Run(function() -- DropTools
		local DropTools
		
		const function Parent(Obj, Parent)
			Obj.Parent = Parent
			local TimeOut = os.clock() + 5
			repeat task.wait() until Obj.Parent == Parent or not DropTools.Enabled or os.clock() >= TimeOut
			Obj.Parent = workspace
		end
		
		const function ToolAdded(Tool)
			if EntityLib.Alive and Tool:IsA('Tool') then
				task.defer(Parent, Tool, EntityLib.Character)
			end
		end
		
		const function BackpackAdded(Backpack)
			if Backpack:IsA('Backpack') then
				DropTools:Clean(Backpack.ChildAdded:Connect(ToolAdded))
				
				for _, Obj in Backpack:GetChildren() do
					if Obj:IsA('Tool') then
						ToolAdded(Obj)
					end
				end
			end
		end
		
		const function LocalAdded()
			DropTools:Clean(EntityLib.Character.ChildAdded:Connect(ToolAdded))
		
			const Tool = EntityLib.Character:FindFirstChildOfClass('Tool')
			if Tool then
				ToolAdded(Tool)
			end
		end
		
		DropTools = PlayerCategory:CreateModule({
			Name = 'Drop Tools',
			Info = 'Drops all the tools in your backpack',
			Function = function(Enabled)
				DropTools:Clean(Plr.ChildAdded:Connect(BackpackAdded))
				DropTools:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		
				if EntityLib.Alive then
					LocalAdded()
				end
		
				const Backpack = Plr:FindFirstChildOfClass('Backpack')
				if Backpack then
					BackpackAdded(Backpack)
				end
			end,
		})
	end)

	Run(function() -- EmoteClip
		local Thread
		local Con

		PlayerCategory:CreateButton({
			Name = 'EmoteClip',
			Info = 'Clips through walls using /e dance2',
			Function = function()
				if Thread then
					task.cancel(Thread)
					Thread = nil
				end
				if Con then
					Con:Disconnect()
					Con = nil
				end

				local TargetTextChannel = TextChatService.ChatInputBarConfiguration.TargetTextChannel
				task.spawn(TargetTextChannel.SendAsync, TargetTextChannel, '/e dance2')

				Thread = task.delay(0.75, function()
					local Components = {Camera.CFrame:GetComponents()}

					Camera.CFrame *= CFrame.Angles(0, math.rad(90), 0)

					task.wait(1 / 60)

					Camera.CFrame = CFrame.new(Camera.CFrame.X, Camera.CFrame.Y, Camera.CFrame.Z, table.unpack(Components, 4, 12))

					Thread = nil
					if Con then
						Con:Disconnect()
						Con = nil
					end
				end)

				Con = RunService.PostSimulation:Connect(function()
					if Thread and EntityLib.Alive and EntityLib.Humanoid.MoveDirection ~= vector.zero then
						task.cancel(Thread)
						Thread = nil
						Con:Disconnect()
						Con = nil
					end
				end)
			end
		})
	end)

	Run(function() -- Fling
		local Fling, Method, Range
		
		const RegularOffset = vector.create(0, 10000, 0)
		
		const function GetPingSeconds()
			return (Stats.PerformanceStats.Ping:GetValue() / 1000) + 0.5
		end

		local FlungEntities = {}

		local Params = RaycastParams.new()
		Params.RespectCanCollide = true
		
		local Methods = {
			Regular = {
				Function = function()
					local OldVel = EntityLib.Root.AssemblyLinearVelocity
		
					EntityLib.Root.AssemblyLinearVelocity = OldVel * 10000 + RegularOffset
		
					RunService.PreRender:Wait()
		
					if EntityLib.Alive then
						EntityLib.Root.AssemblyLinearVelocity = OldVel
					end
				end
			},
			HeatSeeker = {
				Function = function()
					const Entities = EntityLib:GetClosestEntities({
						Range = Range.Value,
						Players = true,
						NPCs = false
					})
		
					if #Entities > 0 then
						for _, Entity in Entities do
							const Now = os.clock()

							local LastFlung = FlungEntities[Entity.Character]
							if LastFlung and Now >= LastFlung.TimeOut then continue end

							const OldVel = EntityLib.Root.AssemblyLinearVelocity
							const EntityVel = Entity.Root.AssemblyLinearVelocity
							const OldCFrame = EntityLib.Root.CFrame
							const Ping = GetPingSeconds()
							local PredictedPosition = Entity.Root.Position + ((EntityVel * vector.hort) * Ping) + EntityVel * vector.yAxis
							const Direction = PredictedPosition - OldCFrame.Position
							const UnitDirection = vector.normalize(Direction)
							const IsZero = EntityVel == vector.zero

							if LastFlung then
								if LastFlung.WasZero ~= IsZero then
									LastFlung.TimeOut = Now + (IsZero and 1.5 or 4)
									LastFlung.WasZero = IsZero
								end
							else
								FlungEntities[Entity.Character] = {
									TimeOut = Now + (IsZero and 1.5 or 4),
									WasZero = IsZero
								}
							end

							if Direction.Y < 0 then
								local IgnoreList = {EntityLib.Character}
								for _, Entity in EntityLib.List do
									table.insert(IgnoreList, Entity.Character)
								end
								Params.FilterDescendantsInstances = IgnoreList

								local Raycast = workspace:Raycast(OldCFrame.Position, Direction, Params)
								if Raycast then
									PredictedPosition = vector.create(PredictedPosition.X, Raycast.Position.Y + EntityLib.HipHeight, PredictedPosition.Z)
								end
							end

							EntityLib.Root.CFrame = CFrame.new(PredictedPosition)
							EntityLib.Root.AssemblyLinearVelocity = UnitDirection * 10000 + RegularOffset
			
							RunService.PreRender:Wait()
			
							EntityLib.Root.AssemblyLinearVelocity = OldVel
							break
						end
					else
						table.clear(FlungEntities)
					end
				end
			}
		}
		
		Fling = PlayerCategory:CreateModule({
			Name = 'Fling',
			Info = 'Flings players when you touch them',
			Function = function(Enabled)
				if Enabled then
					if Modules.Phase and not Modules.Phase.Enabled then
						Modules.Phase:Toggle(true)
					end
			
					local Init = Methods[Method.Value].Init
					if Init then
						Init()
					end
			
					Fling:Clean(RunService.PostSimulation:Connect(function()
						if EntityLib.Alive then
							Methods[Method.Value].Function()
						end
					end))
				else
					table.clear(FlungEntities)
				end
			end
		})
		
		Method = Fling:CreateDropdown({
			Name = 'Method',
			List = {'Regular', 'HeatSeeker'},
			Info = 'Regular - Just regular fling.\nHeatSeeker - Automatically directs your velocity towards the closest player.',
			Restart = true
		})
		
		Range = Method:BindSliderTo('HeatSeeker', {
			Name = 'Range',
			Default = 10,
			Min = 1,
			Max = 30
		})
	end)

	Run(function() -- HipHeight
		local HipHeight, Value
		local Old, db
		
		const function LocalAdded()
			Old = EntityLib.Humanoid.HipHeight
			EntityLib.Humanoid.HipHeight = Value.Value
			EntityLib.HipHeight = Value.Value + (EntityLib.Root.Size.Y / 2) + (EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or 0)
			HipHeight:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('HipHeight'):Connect(function()
				if db then return end
				db = true
				Old = EntityLib.Humanoid.HipHeight
				EntityLib.Humanoid.HipHeight = Value.Value
				EntityLib.HipHeight = Value.Value + (EntityLib.Root.Size.Y / 2) + (EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or 0)
				db = nil
			end))
		end
		
		HipHeight = PlayerCategory:CreateModule({
			Name = 'HipHeight',
			Info = 'Sets the hip height of your humanoid',
			Function = function(Enabled)
				if Enabled then
					HipHeight:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					if EntityLib.Alive then
						EntityLib.Humanoid.HipHeight = Old
						EntityLib.HipHeight = Old
					end
					Old, db = nil, nil
				end
			end
		})
		
		Value = HipHeight:CreateSlider({
			Name = 'Hip Height',
			Default = EntityLib.Alive and math.floor(EntityLib.Humanoid.HipHeight * 100) / 100 or 2,
			Min = 0,
			Max = 10,
			Decimal = 100,
			Function = function(Val)
				if HipHeight.Enabled and EntityLib.Alive then
					db = true
					EntityLib.Humanoid.HipHeight = Val
					db = nil
				end
			end
		})
	end)

	Run(function() -- JumpPower
		local JumpPower, Value
		local db, db2, OldJumpPower, OldUseJumpPower
		
		const function LocalAdded()
			OldJumpPower, OldUseJumpPower = EntityLib.Humanoid.JumpPower, EntityLib.Humanoid.UseJumpPower
			EntityLib.Humanoid.JumpPower = Value.Value
			EntityLib.Humanoid.UseJumpPower = true
		
			JumpPower:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('JumpPower'):Connect(function()
				if db then return end
				db = true
				OldJumpPower = EntityLib.Humanoid.JumpPower
				EntityLib.Humanoid.JumpPower = Value.Value
				db = nil
			end))
		
			JumpPower:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('UseJumpPower'):Connect(function()
				if db2 then return end
				db2 = true
				OldUseJumpPower = EntityLib.Humanoid.UseJumpPower
				EntityLib.Humanoid.UseJumpPower = true
				db2 = nil
			end))
		end
		
		JumpPower = PlayerCategory:CreateModule({
			Name = 'JumpPower',
			Info = 'Sets the jump power of your humanoid',
			Function = function(Enabled)
				if Enabled then
					if EntityLib.Alive then
						LocalAdded()
					end
					
					JumpPower:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
				else
					if EntityLib.Alive then
						if OldJumpPower then
							EntityLib.Humanoid.JumpPower = OldJumpPower
						end
						if OldUseJumpPower then
							EntityLib.Humanoid.UseJumpPower = OldUseJumpPower
						end
					end
				end
			end
		})
		
		Value = JumpPower:CreateSlider({
			Name = 'Jump Power',
			Default = 50,
			Min = 0,
			Max = 500,
			Function = function()
				if JumpPower.Enabled and EntityLib.Alive then
					db, db2 = true, true
					EntityLib.Humanoid.JumpPower = Value.Value
					EntityLib.Humanoid.UseJumpPower = true
					db, db2 = nil, nil
				end
			end
		})
	end)

	Run(function() -- MaxSlopeAngle
		local MaxSlopeAngle, Value
		local Old, db
		
		const function LocalAdded()
			Old = EntityLib.Humanoid.MaxSlopeAngle
			EntityLib.Humanoid.MaxSlopeAngle = Value.Value
			MaxSlopeAngle:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('MaxSlopeAngle'):Connect(function()
				if db then return end
				db = true
				Old = EntityLib.Humanoid.MaxSlopeAngle
				EntityLib.Humanoid.MaxSlopeAngle = Value.Value
				db = nil
			end))
		end
		
		MaxSlopeAngle = PlayerCategory:CreateModule({
			Name = 'MaxSlopeAngle',
			Info = 'Sets the max angle you can climb up slopes',
			Function = function(Enabled)
				if Enabled then
					if EntityLib.Alive then
						LocalAdded()
					end
					MaxSlopeAngle:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
				else
					if EntityLib.Alive then
						EntityLib.Humanoid.MaxSlopeAngle = Old
					end
					Old, db = nil, nil
				end
			end
		})
		
		Value = MaxSlopeAngle:CreateSlider({
			Name = 'Angle',
			Default = 90,
			Min = 0,
			Max = 90,
			Decimal = 10,
			Function = function(Val)
				if MaxSlopeAngle.Enabled and EntityLib.Alive then
					db = true
					EntityLib.Humanoid.MaxSlopeAngle = Val
					db = nil
				end
			end
		})
	end)

	Run(function() -- Phase
		local Phase, Method
		
		const Modified = {}
		
		const Params = OverlapParams.new()
		Params.MaxParts = 9e9
		
		const Functions = {
			Character = function()
				for _, Part in EntityLib.Character:QueryDescendants('BasePart[CanCollide = true]') do
					Modified[Part] = true
					Part.CanCollide = false
				end
			end,
			Part = function()
				local IgnoreList = {EntityLib.Character}
				for _, Entity in EntityLib.List do
					table.insert(IgnoreList, Entity.Character)
				end
				Params.FilterDescendantsInstances = IgnoreList
		
				local TouchingParts = workspace:GetPartBoundsInBox(EntityLib.Root.CFrame, vector.create(7, EntityLib.HipHeight, 7), Params)
				for Part in Modified do
					if not table.find(TouchingParts, Part) then
						Part.CanCollide = true
						Modified[Part] = nil
					end
				end
				for _, Part in TouchingParts do
					if Part.CanCollide then
						Modified[Part] = true
						Part.CanCollide = false
					end
				end
			end
		}
		
		Phase = PlayerCategory:CreateModule({
			Name = 'Phase',
			Info = 'Allows you to phase through walls',
			Function = function(Enabled)
				if Enabled then
					Phase:Clean(RunService.PreSimulation:Connect(function()
						if EntityLib.Alive then
							Functions[Method.Value]()
						end
					end))
				else
					for Part in Modified do
						Part.CanCollide = true
					end
					table.clear(Modified)
				end
			end,
		})
		
		Method = Phase:CreateDropdown({
			Name = 'Method',
			List = {'Character', 'Part'},
			Info = 'Character - Disables the collision of your character.\nPart - Disables the collision of parts around you',
			Restart = true
		})
	end)

	Run(function() -- StateSpoofer
		local StateSpoofer, State, SpoofJump, JumpValue
		
		StateSpoofer = PlayerCategory:CreateModule({
			Name = 'StateSpoofer',
			Info = 'Spoofs humanoid states on the server',
			Enabled = function()
				if not sethiddenproperty then NotifyPoopSploit('sethiddenproperty'); return end

				StateSpoofer:Clean(RunService.PostSimulation:Connect(function()
					if EntityLib.Alive then
						if State.Value ~= 'None' then
							sethiddenproperty(EntityLib.Humanoid, 'NetworkHumanoidState', Enum.HumanoidStateType[State.Value].Value)
						end

						if SpoofJump.Enabled then
							sethiddenproperty(EntityLib.Humanoid, 'JumpReplicate', JumpValue.Enabled)
						end
					end
				end))
			end,
		})
		
		const List = {'None'}
		for _, StateType in Enum.HumanoidStateType:GetEnumItems() do
			if StateType.Name ~= 'None' then
				table.insert(List, StateType.Name)
			end
		end
		
		State = StateSpoofer:CreateDropdown({
			Name = 'Humanoid State',
			List = List
		})

		SpoofJump = StateSpoofer:CreateToggle({
			Name = 'Spoof Jump',
			Info = 'Spoofs your Humanoid.Jump property',
		})

		JumpValue = SpoofJump:CreateToggle({
			Name = 'Jump Value',
			Info = 'Value to spoof Humanoid.Jump to'
		})
	end)
end)

Run(function() -- Movement
	Run(function() -- AirJump
		local AirJump, Hold, JumpInterval, CustomJump, JumpPower
		
		const function Jump()
			if CustomJump.Enabled then
				EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, JumpPower.Value, EntityLib.Root.AssemblyLinearVelocity.Z)
			else
				EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
		
		AirJump = Movement:CreateModule({
			Name = 'AirJump',
			Info = 'Allows you to jump midair',
			Enabled = function()
				AirJump:Clean(UIS.InputBegan:Connect(function(Input)
					if Input.KeyCode == Enum.KeyCode.Space and EntityLib.Alive and not UIS:GetFocusedTextBox() then
						if Hold.Enabled then
							repeat
								if EntityLib.Humanoid.FloorMaterial == Enum.Material.Air then
									Jump()
									task.wait(JumpInterval.Value)
								else
									RunService.PostSimulation:Wait()
								end
							until not AirJump.Enabled or not Hold.Enabled or not EntityLib.Alive or not UIS:IsKeyDown(Enum.KeyCode.Space)
						elseif EntityLib.Humanoid.FloorMaterial == Enum.Material.Air then
							Jump()
						end
					end
				end))
			end
		})
		
		Hold = AirJump:CreateToggle({
			Name = 'Hold',
			Info = 'Allows you to hold jump instead of spamming it',
		})
		
		JumpInterval = Hold:CreateSlider({
			Name = 'Jump Interval',
			Default = 0.1,
			Min = 0,
			Max = 1,
			Decimal = 100
		})
		
		CustomJump = AirJump:CreateToggle({
			Name = 'Custom Jump',
			Info = 'Allows you to have a custom air jump',
		})
		
		JumpPower = CustomJump:CreateSlider({
			Name = 'Jump Power',
			Default = 35,
			Min = 5,
			Max = 70
		})
	end)

	Run(function() -- ClickTP
		local ClickTP, Keybind
		
		local Params = RaycastParams.new()
		Params.RespectCanCollide = true
		
		ClickTP = Movement:CreateModule({
			Name = 'ClickTP',
			Info = 'Teleports you to your mouse\'s location when you click while holding your keybind',
			Enabled = function()
				ClickTP:Clean(UIS.InputBegan:Connect(function(Input)
					if UIS:GetFocusedTextBox() or not EntityLib.Alive then return end
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind:IsPressed() then
						Params.FilterDescendantsInstances = {EntityLib.Character}
		
						local MouseLocation = GetMouseLocation()
						local MouseRaycast = Camera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
						local Raycast = workspace:Raycast(MouseRaycast.Origin, MouseRaycast.Direction * 9e9, Params)
		
						if Raycast then
							local HitPos = Raycast.Position + vector.create(0, EntityLib.HipHeight, 0)
							local _, Y = CFrame.lookAt(EntityLib.Root.Position, HitPos):ToOrientation()
							EntityLib.Root.CFrame = CFrame.new(HitPos) * CFrame.Angles(0, Y, 0)
						end
					end
				end))
			end
		})
		
		Keybind = ClickTP:CreateKeybind({
			Name = 'Teleport',
			Keybind = 'R'
		})
	end)

	Run(function() -- ClientFly
		local ClientFly, HortSpeed, VertSpeed, TPBack, UpKeybind, DownKeybind
		local OriginTracer, TracerColor, TracerThickness, Preset
		
		const Presets = {
			TopLeft = Path2DControlPoint.new(UDim2.fromScale(0, 0)),
			Top = Path2DControlPoint.new(UDim2.fromScale(0.5, 0)),
			TopRight = Path2DControlPoint.new(UDim2.fromScale(1, 0)),
			Left = Path2DControlPoint.new(UDim2.fromScale(0, 0.5)),
			Middle = Path2DControlPoint.new(UDim2.fromScale(0.5, 0.5)),
			Right = Path2DControlPoint.new(UDim2.fromScale(1, 0.5)),
			BottomLeft = Path2DControlPoint.new(UDim2.fromScale(0, 1)),
			Bottom = Path2DControlPoint.new(UDim2.fromScale(0.5, 1)),
			BottomRight = Path2DControlPoint.new(UDim2.fromScale(1, 1)),
		}
		
		const ControlPoints = {
			[1] = Presets.Bottom,
			[2] = Path2DControlPoint.new()
		}
		
		local OldCFrame
		
		ClientFly = Movement:CreateModule({
			Name = 'ClientFly',
			Info = 'Works like normal fly except it only updates your position client-sided',
			Function = function(Enabled)
				if Enabled then
					local ScreenGui = ClientFly:CreateInstance('ScreenGui', 'ScreenGui', {
						IgnoreGuiInset = true,
						Name = 'ClientFly_Tracers',
						Parent = TidalWave.Gui
					})
		
					local Tracer = ClientFly:CreateInstance('Path2D', 'Tracer', {
						Name = 'OriginalLocation',
						Color3 = TracerColor.Color,
						Thickness = TracerThickness.Value,
						Visible = false,
						Parent = ScreenGui
					})
		
					local E, Q = UpKeybind:IsPressed() and 1 or 0, DownKeybind:IsPressed() and 1 or 0
		
					ClientFly:Clean(RunService.PreRender:Connect(function()
						if EntityLib.Alive then
							if not OldCFrame then
								OldCFrame = EntityLib.Root.CFrame
							end
							
							if OriginTracer.Enabled then
								local ScreenPoint, Visible = Camera:WorldToViewportPoint(OldCFrame.Position)
								if Visible then
									if Preset.Value == 'Mouse' then
										local MouseLocation = GetMouseLocation()
										ControlPoints[1].Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
									end
		
									ControlPoints[2].Position = UDim2.fromOffset(ScreenPoint.X, ScreenPoint.Y)
		
									Tracer:SetControlPoints(ControlPoints)
								end
		
								Tracer.Visible = Visible
							else
								Tracer.Visible = false
							end
						else
							OldCFrame = nil
						end
					end))
		
					ClientFly:Clean(RunService.PostSimulation:Connect(function(Delta)
						if not EntityLib.Alive then return end
						EntityLib.Root.Anchored = true

						const RootPosition = EntityLib.Root.Position
						const CameraPosition = Camera.CFrame.Position
						const HortVel = EntityLib.Humanoid.MoveDirection * HortSpeed.Value
						const VertVel = vector.create(0, (E - Q) * VertSpeed.Value, 0)

						const CameraOffset = EntityLib.Root.CFrame:ToObjectSpace(Camera.CFrame).Position
						Camera.CFrame *= CFrame.new(-CameraOffset.X, -CameraOffset.Y, -CameraOffset.Z + 1)
						
						const RootHortPos = vector.create(RootPosition.X, CameraPosition.Y, RootPosition.Z)
						const ObjectSpaceVelocity = CFrame.lookAt(CameraPosition, RootHortPos):VectorToObjectSpace((HortVel + VertVel) * Delta)
						EntityLib.Root.CFrame = CFrame.new(RootPosition) * (Camera.CFrame - CameraPosition) * CFrame.new(ObjectSpaceVelocity)
					end))
		
					for i = 1, 0, -1 do
						local Signal = i == 1 and UIS.InputBegan or UIS.InputEnded
						ClientFly:Clean(Signal:Connect(function(Input)
							if i == 1 and UIS:GetFocusedTextBox() then return end
							if UpKeybind:Check(Input) then
								E = i
							elseif DownKeybind:Check(Input) then
								Q = i
							end
						end))
					end
				else
					if EntityLib.Alive then
						if TPBack.Enabled then
							EntityLib.Root.CFrame = OldCFrame
						end
						EntityLib.Root.Anchored = false
					end
		
					OldCFrame = nil
				end
			end,
		})
		
		const function UpdateTracer()
			local Tracer = ClientFly:GetInstance('Tracer')
			if Tracer then
				Tracer.Color3 = TracerColor.Color
				Tracer.Thickness = TracerThickness.Value
			end
		end
		
		HortSpeed = ClientFly:CreateSlider({
			Name = 'Horizontal Speed',
			Default = 50,
			Min = 0,
			Max = 500,
		})

		VertSpeed = ClientFly:CreateSlider({
			Name = 'Vertical Speed',
			Default = 50,
			Min = 0,
			Max = 500
		})
		
		TPBack = ClientFly:CreateToggle({
			Name = 'TP Back',
			Info = 'Teleports you to the original location you started flying at'
		})
		
		OriginTracer = ClientFly:CreateToggle({
			Name = 'Origin Tracer',
			Info = 'Creates a tracer pointing to the location you started flying at',
		})
		
		TracerColor = OriginTracer:CreateColorPicker({
			Name = 'Tracer Color',
			Function = UpdateTracer
		})
		
		TracerThickness = OriginTracer:CreateSlider({
			Name = 'Tracer Thickness',
			Default = 1,
			Min = 1,
			Max = 5,
			Function = UpdateTracer
		})
		
		Preset = OriginTracer:CreateDropdown({
			Name = 'Position',
			List = {'Bottom', 'Bottom Left', 'Bottom Right', 'Top Left', 'Top', 'Top Right', 'Left', 'Middle', 'Right', 'Mouse'},
			Function = function(Val)
				if Val ~= 'Mouse' then
					ControlPoints[1].Position = Presets[Val]
				end
			end
		})
		
		UpKeybind = ClientFly:CreateKeybind({
			Name = 'Up',
			Keybind = 'E',
			Secondary = true
		})
		
		DownKeybind = ClientFly:CreateKeybind({
			Name = 'Down',
			Keybind = 'Q',
			Secondary = true
		})
	end)

	Run(function() -- FastClimb
		local FastClimb, Speed, Method, ResetVel
		
		local Modified
		
		local Functions = {
			Velocity = function()
				if math.abs(EntityLib.Root.AssemblyLinearVelocity.Y) >= (Modified and Speed.Value or EntityLib.Humanoid.WalkSpeed) / 10 then
					Modified = true
					local CurrentVel = EntityLib.Root.AssemblyLinearVelocity
					local Direction = math.sign(EntityLib.Root.AssemblyLinearVelocity.Y)
					local Vel = vector.create(CurrentVel.X, Direction * Speed.Value, CurrentVel.Z)
					EntityLib.Root.AssemblyLinearVelocity = Vel
				else
					Modified = nil
				end
			end,
		}
		
		FastClimb = Movement:CreateModule({
			Name = 'FastClimb',
			Info = 'Increases the speed at which you climb ladders',
			Enabled = function()
				local Climbed
				FastClimb:Clean(RunService.PreSimulation:Connect(function(Delta)
					if not EntityLib.Alive then return end
					local State = EntityLib.Humanoid:GetState()
					if State == Enum.HumanoidStateType.Climbing then
						if EntityLib.Humanoid.MoveDirection ~= vector.zero then
							Functions[Method.Value](Delta)
							Climbed = true
						end
					elseif Climbed then
						if Method.Value == 'Velocity' and ResetVel.Enabled then
							EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 16, EntityLib.Root.AssemblyLinearVelocity.Z)
						end
						Climbed = nil
						Modified = nil
					end
				end))
			end,
			ExtraText = function()
				return Method.Value
			end
		})
		
		Speed = FastClimb:CreateSlider({
			Name = 'Speed',
			Default = 20,
			Min = 1,
			Max = 200
		})
		
		Method = FastClimb:CreateDropdown({
			Name = 'Method',
			List = {'Velocity'},
			Info = 'Velocity - Increases the Y velocity of your character.',
			Function = function(Val)
				ResetVel:SetVisible(Val == 'Velocity')
			end
		})
		
		ResetVel = FastClimb:CreateToggle({
			Name = 'Reset Y Velocity',
			Info = 'Resets your Y velocity to zero after climbing a ladder',
		})
	end)

	Run(function() -- Float
		local Float, Method, Color, UpOffset, DownOffset, UpSpeed, DownSpeed, UpKeybind, DownKeybind
		local E, Q, EDown, QDown
		local Part
		
		Float = Movement:CreateModule({
			Name = 'Float',
			Info = 'Uses various different methods to make you float',
			Function = function(Enabled)
				if Enabled then
					EDown, QDown = UpKeybind:IsPressed(), DownKeybind:IsPressed()
					E, Q = EDown and 1 or 0, QDown and 1 or 0
		
					if Method.Value == 'Part' then
						Part = Float:CreateInstance('Part', 'Part', {
							Color = Color.Color,
							Transparency = Color.Transparency,
							Size = vector.create(2, 0.2, 2),
							Anchored = true,
							CanTouch = false,
							CanQuery = false,
							CastShadow = false,
							AudioCanCollide = false,
							Parent = workspace
						})
						
						Float:Clean(RunService.PostSimulation:Connect(function()
							if not EntityLib.Alive then return end
							local Offset = (EntityLib.HipHeight - EntityLib.Root.Size.Y)
							local Y = -(EntityLib.HipHeight + 0.1) + ((E - Q) * Offset) + ((EDown and UpOffset.Value or 0) - (QDown and DownOffset.Value or 0))
							Part.CFrame = EntityLib.Root.CFrame * CFrame.new(0, Y, 0)
						end))
					else
						local Attachment, LinearVelocity
		
						const function LocalAdded()
							Attachment = Float:CreateInstance('Attachment', 'Attachment', {
								Name = 'RootAttachment',
								Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
								Parent = EntityLib.Root
							})
		
							LinearVelocity = Float:CreateInstance('LinearVelocity', 'LinearVelocity', {
								VelocityConstraintMode = Enum.VelocityConstraintMode.Line,
								LineDirection = vector.yAxis,
								ForceLimitsEnabled = false,
								LineVelocity = 0,
								Attachment0 = Attachment,
								Enabled = false,
								Parent = workspace
							})
						end
		
						const function LocalRemoved()
							Float:RemoveInstance('Attachment')
							Attachment = nil
						end
		
						Float:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
						Float:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
						Float:Clean(RunService.PreSimulation:Connect(function()
							if not (EntityLib.Alive and Attachment and LinearVelocity) then return end
							if (EDown or QDown) or (EntityLib.Humanoid.FloorMaterial == Enum.Material.Air and EntityLib.Root.AssemblyLinearVelocity.Y <= 0) then
								local Vel = (E * UpSpeed.Value) - (Q * DownSpeed.Value)
								if Vel < 0 and EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
									LinearVelocity.LineVelocity = 0
								else
									LinearVelocity.LineVelocity = Vel
									Attachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
									LinearVelocity.Enabled = true
								end
							elseif EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
								LinearVelocity.Enabled = false
							else
								LinearVelocity.LineVelocity = 0
							end
						end))
		
						if EntityLib.Alive then
							LocalAdded()
						end
					end
		
					for i = 1, 0, -1 do
						local Signal = i == 1 and UIS.InputBegan or UIS.InputEnded
						Float:Clean(Signal:Connect(function(Input)
							if i == 1 and UIS:GetFocusedTextBox() then return end
							if UpKeybind:Check(Input) then
								E = i
								EDown = E == 1
							elseif DownKeybind:Check(Input) then
								Q = i
								QDown = Q == 1
							end
						end))
					end
				else
					Part = nil
				end
			end,
			ExtraText = function()
				return Method.Value
			end
		})
		
		Method = Float:CreateDropdown({
			Name = 'Method',
			List = {'Part', 'LinearVelocity'},
			Function = function(Val)
				Float:Restart()
			end
		})
		
		UpOffset = Method:BindSliderTo('Part', {
			Name = 'Up Offset',
			Default = 0,
			Min = 0,
			Max = 1,
			Decimal = 1000
		})
		
		DownOffset = Method:BindSliderTo('Part', {
			Name = 'Down Offset',
			Default = 0,
			Min = 0,
			Max = 1,
			Decimal = 1000
		})
		
		Color = Method:BindColorPickerTo('Part', {
			Name = 'Color',
			Default = Color3.fromRGB(163, 162, 165),
			Function = function(Color, Transparency)
				if Part then
					Part.Color = Color
					Part.Transparency = Transparency
				end
			end
		})
		
		UpSpeed = Method:BindSliderTo('LinearVelocity', {	
			Name = 'Up Speed',
			Default = 20,
			Min = 1,
			Max = 100
		})
		
		DownSpeed = Method:BindSliderTo('LinearVelocity', {
			Name = 'Down Speed',
			Default = 20,
			Min = 1,
			Max = 100
		})
		
		UpKeybind = Float:CreateKeybind({
			Name = 'Up',
			Keybind = 'E',
			Secondary = true
		})
		
		DownKeybind = Float:CreateKeybind({
			Name = 'Down',
			Keybind = 'Q',
			Secondary = true
		})
	end)

	Run(function() -- Fly
		local Fly, HorizontalSpeed, VerticalSpeed, FlyMethod, FloatMethod, AlignMethod, MoveMethod, PlatformStand, Sit, SpoofJump, JumpValue, State, StateMode
		local UpKeybind, DownKeybind
		local UsePercentage, Percentage
		local UseLimits, MinSpeed, MaxSpeed
		local Shift, ShiftSpeed
		local ShiftUsePercentage, ShiftPercentage
		local UseShiftLimits, MinShiftSpeed, MaxShiftSpeed, ShiftKeybind
		local W, A, S, D, E, Q, ShiftPressed
		
		const function GetMoveDirection()
			if MoveMethod.Value == 'MoveDirection' then
				return EntityLib.Humanoid.MoveDirection
			else
				return (Camera.CFrame.LookVector * (W - S)) + (Camera.CFrame.RightVector * (D - A))
			end
		end
		
		const function GetVerticalDirection()
			if MoveMethod.Value == 'MoveDirection' then
				return vector.create(0, E - Q, 0)
			else
				return Camera.CFrame.UpVector * (E - Q)
			end
		end

		const function GetSpeedFromPercentage(Percentage: number): number
			return EntityLib.Humanoid.WalkSpeed * (Percentage / 100)
		end
		
		const function GetHortVel()
			const MoveDirection = GetMoveDirection()
			local Vel
		
			if Shift.Enabled and ShiftPressed then
				Vel = ShiftUsePercentage.Enabled and GetSpeedFromPercentage(ShiftPercentage.Value) or ShiftSpeed.Value
				if ShiftUsePercentage.Enabled and UseShiftLimits.Enabled then
					Vel = math.clamp(Vel, MinShiftSpeed.Value, MaxShiftSpeed.Value)
				end
			else
				Vel = UsePercentage.Enabled and GetSpeedFromPercentage(Percentage.Value) or HorizontalSpeed.Value
				if UsePercentage.Enabled and UseLimits.Enabled then
					Vel = math.clamp(Vel, MinSpeed.Value, MaxSpeed.Value)
				end
			end
		
			return (TargetStrafeVector or MoveDirection) * Vel
		end
		
		const function GetVertVel()
			const Direction = GetVerticalDirection()
			
			return Direction * VerticalSpeed.Value
		end
		
		const FlyMethods = {
			LinearVelocity = {
				Init = function()
					const Attachment = Fly:CreateInstance('Attachment', 'HortAttachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})
		
					Fly:CreateInstance('LinearVelocity', 'HortLinearVelocity', {
						ForceLimitMode = Enum.ForceLimitMode.PerAxis,
						MaxAxesForce = vector.huge,
						VectorVelocity = GetHortVel(),
						Attachment0 = Attachment,
						Parent = workspace
					})
				end,
				Function = function()
					const ExistingLinearVelocity, ExistingAttachment = Fly:GetInstance('HortLinearVelocity'), Fly:GetInstance('HortAttachment')
					if ExistingLinearVelocity and ExistingAttachment then
						ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
						ExistingLinearVelocity.VectorVelocity = GetHortVel()
					end
				end
			},
			Velocity = {
				Function = function()
					const CurrentVel = EntityLib.Root.AssemblyLinearVelocity
					const Vel = GetHortVel()
					EntityLib.Root.AssemblyLinearVelocity = vector.create(Vel.X, CurrentVel.Y, Vel.Z)
				end,
			},
			CFrame = {
				Function = function(Delta)
					EntityLib.Character:TranslateBy(GetHortVel() * Delta)
				end,
			},
		}

		const FloatMethods = {
			LinearVelocity = {
				Init = function()
					const Attachment = Fly:CreateInstance('Attachment', 'VertAttachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})

					Fly:CreateInstance('LinearVelocity', 'VertLinearVelocity', {
						ForceLimitMode = Enum.ForceLimitMode.PerAxis,
						MaxAxesForce = vector.huge,
						VectorVelocity = GetVertVel(),
						Attachment0 = Attachment,
						Parent = workspace
					})
				end,
				Function = function()
					const HortLinearVelocity = Fly:GetInstance('HortLinearVelocity')
					const CurrentLinearVelocity, CurrentAttachment = Fly:GetInstance('VertLinearVelocity'), Fly:GetInstance('VertAttachment')
					if HortLinearVelocity then
						if CurrentLinearVelocity then
							CurrentLinearVelocity.Enabled = false
						end
						HortLinearVelocity.VectorVelocity += GetVertVel()
					else
						if CurrentLinearVelocity and CurrentAttachment then
							CurrentLinearVelocity.Enabled = true
							CurrentAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
							CurrentLinearVelocity.VectorVelocity = GetVertVel()
						end
					end
				end,
			},
			Velocity = {
				Function = function()
					const Vel = EntityLib.Root.AssemblyLinearVelocity
					EntityLib.Root.AssemblyLinearVelocity = vector.create(Vel.X, GetVertVel().Y, Vel.Z)
				end,
			},
			CFrame = {
				Function = function(Delta)
					EntityLib.Root.AssemblyLinearVelocity = vector.yAxis
					EntityLib.Character:TranslateBy(GetVertVel() * Delta)
				end
			}
		}
		
		const AlignMethods = {
			AlignOrientation = {
				Init = function()
					local Attachment = Fly:CreateInstance('Attachment', 'AlignAttachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})
		
					Fly:CreateInstance('AlignOrientation', 'AlignOrientation', {
						Mode = Enum.OrientationAlignmentMode.OneAttachment,
						Attachment0 = Attachment,
						RigidityEnabled = true,
						CFrame = Camera.CFrame,
						Parent = workspace
					})
				end,
				Function = function()
					local ExistingAlignOrientation, ExistingAttachment = Fly:GetInstance('AlignOrientation'), Fly:GetInstance('AlignAttachment')
					if ExistingAlignOrientation and ExistingAttachment then
						ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
						ExistingAlignOrientation.CFrame = Camera.CFrame
					end
				end,
			},
			CFrame = {
				Function = function()
					EntityLib.Root.CFrame = CFrame.lookAlong(EntityLib.Root.Position, Camera.CFrame.LookVector)
					EntityLib.Root.AssemblyAngularVelocity = vector.zero
				end,
			}
		}
		
		const function LocalRemoved()
			FrictionTable.Fly = nil
			UpdateFriction()
			Fly:CleanUp()
			Fly:ClearInstances()
		end
		
		const function LocalAdded()
			LocalRemoved()
			const CurrentFlyMethod = FlyMethods[FlyMethod.Value]
			if CurrentFlyMethod and CurrentFlyMethod.Init then
				CurrentFlyMethod.Init()
			end

			const CurrentFloatMethod = FloatMethods[FloatMethod.Value]
			if CurrentFloatMethod and CurrentFloatMethod.Init then
				CurrentFloatMethod.Init()
			end
			
			const CurrentAlignMethod = AlignMethods[AlignMethod.Value]
			if CurrentAlignMethod and CurrentAlignMethod.Init then
				CurrentAlignMethod.Init()
			end
		end
		
		Fly = Movement:CreateModule({
			Name = 'Fly',
			Info = 'Allows you to fly through the air using extra detected methods',
			Function = function(Enabled)
				if Enabled then
					Modules.Speed:DisableMovers()
					if Modules.LongJump and Modules.LongJump.Enabled then
						Modules.LongJump:Toggle(true)
					end
					if Modules.HighJump and Modules.HighJump.Enabled then
						Modules.HighJump:Toggle(true)
					end
					
					W = UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0
					A = UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0
					S = UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0
					D  = UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0
					E = UpKeybind:IsPressed() and 1 or 0
					Q = DownKeybind:IsPressed() and 1 or 0
					ShiftPressed = ShiftKeybind:IsPressed()
			
					FrictionTable.Fly = FlyMethod.Value == 'Velocity' or nil
					UpdateFriction()
		
					if EntityLib.Alive then
						LocalAdded()
					end
		
					Fly:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Fly:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Fly:Clean(RunService.PreRender:Connect(function()
						if AlignMethod.Value ~= 'None' and EntityLib.Alive then
							AlignMethods[AlignMethod.Value].Function()
						end
					end))
		
					Fly:Clean(RunService.PreSimulation:Connect(function(Delta)
						if not EntityLib.Alive then return end
						if PlatformStand.Enabled then
							EntityLib.Humanoid.PlatformStand = true
						end

						if Sit.Enabled then
							EntityLib.Humanoid.Sit = true
						end

						if SpoofJump.Enabled then
							sethiddenproperty(EntityLib.Humanoid, 'JumpReplicate', JumpValue.Enabled)
						end

						if State.Value ~= 'None' then
							if StateMode.Value == 'Regular' then
								EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType[State.Value])
							else
								sethiddenproperty(EntityLib.Humanoid, 'NetworkHumanoidState', Enum.HumanoidStateType[State.Value].Value)
							end
						end

						FlyMethods[FlyMethod.Value].Function(Delta)
						FloatMethods[FloatMethod.Value].Function(Delta)
					end))
					
					for i = 1, 0, -1 do
						local Signal = i == 1 and UIS.InputBegan or UIS.InputEnded
						Fly:Clean(Signal:Connect(function(Input)
							if i == 1 and UIS:GetFocusedTextBox() then return end
							if Input.KeyCode == Enum.KeyCode.W then
								W = i
							elseif Input.KeyCode == Enum.KeyCode.A then
								A = i
							elseif Input.KeyCode == Enum.KeyCode.S then
								S = i
							elseif Input.KeyCode == Enum.KeyCode.D then
								D = i
							elseif UpKeybind:Check(Input) then
								E = i
							elseif DownKeybind:Check(Input) then
								Q = i
							elseif ShiftKeybind:Check(Input) then
								ShiftPressed = i == 1
							end
						end))
					end
				else
					Modules.Speed:EnableMovers()
					FrictionTable.Fly = nil
					UpdateFriction()
					
					if EntityLib.Alive and PlatformStand.Enabled then
						EntityLib.Humanoid.PlatformStand = false
					end

					if EntityLib.Alive and Sit.Enabled then
						EntityLib.Humanoid.Sit = false
					end

					if EntityLib.Alive and State.Value ~= 'None' then
						EntityLib.Humanoid:ChangeState(EntityLib.Humanoid.FloorMaterial == Enum.Material.Air and Enum.HumanoidStateType.Freefall or Enum.HumanoidStateType.Running)
					end

					W, A, S, D, E, Q = nil, nil, nil, nil, nil, nil
					ShiftPressed = false
				end
			end,
			ExtraText = function()
				return FlyMethod.Value
			end,
		})
		
		UpKeybind = Fly:CreateKeybind({
			Name = 'Up',
			Keybind = 'E',
			Secondary = true
		})
		
		DownKeybind = Fly:CreateKeybind({
			Name = 'Down',
			Keybind = 'Q',
			Secondary = true
		})
		
		HorizontalSpeed = Fly:CreateSlider({
			Name = 'Horizontal Speed',
			Default = 50,
			Min = 0,
			Max = 500,
		})
		
		VerticalSpeed = Fly:CreateSlider({
			Name = 'Vertical Speed',
			Default = 50,
			Min = 0,
			Max = 500,
		})
		
		FlyMethod = Fly:CreateDropdown({
			Name = 'Fly Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame'},
			Tooltip = 'LinearVelocity - Uses a LinearVelocity object to modify your Velocity.\nVelocity - Adjusts the Velocity of your character.\nDirectly adjusts the position of your character.',
			Function = function(Val)
				if Fly.Enabled then
					if Val ~= 'LinearVelocity' then
						Fly:RemoveInstance('HortAttachment')
						Fly:RemoveInstance('HortLinearVelocity')
					end
					FrictionTable.Fly = (Val == 'Velocity' or FloatMethod.Value == 'Velocity') or nil
					UpdateFriction()
				end
			end
		})

		FloatMethod = Fly:CreateDropdown({
			Name = 'Float Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame'},
			Tooltip = 'LinearVelocity - Uses a LinearVelocity object to modify your Velocity.\nVelocity - Adjusts the Velocity of your character.\nDirectly adjusts the position of your character.',
			Function = function(Val)
				if Fly.Enabled then
					if Val ~= 'LinearVelocity' then
						Fly:RemoveInstance('VertAttachment')
						Fly:RemoveInstance('VertLinearVelocity')
					end
					FrictionTable.Fly = (Val == 'Velocity' or FlyMethod.Value == 'Velocity') or nil
					UpdateFriction()
				end
			end
		})
		
		AlignMethod = Fly:CreateDropdown({
			Name = 'Align Method',
			List = {'AlignOrientation', 'CFrame', 'None'},
			Tooltip = 'AlignOrientation - Smoothly orientates your character based on the rotation of your camera.\nCFrame - Directly adjusts the Orientation of your character based on the rotation of your camera. (Recommended to use PlatformStand with this)\nNone - Doesn\'t align your character with your camera.',
			Function = function(Val)
				if Fly.Enabled then
					if Val ~= 'AlignOrientation' then
						Fly:RemoveInstance('AlignOrientation')
						Fly:RemoveInstance('AlignAttachment')
					end
				end
			end
		})
		
		MoveMethod = Fly:CreateDropdown({
			Name = 'Move Method',
			List = {'Camera', 'MoveDirection'},
			Tooltip = 'Camera - Moves based off the orientation of your camera.\nMoveDirection - Moves based off the move direction of your Humanoid.'
		})

		PlatformStand = Fly:CreateToggle({
			Name = 'Platform Stand',
			Tooltip = 'Puts your Humanoid into the PlatformStanding state, which disables regular physics allowing for smoother movement and fixes CFrame align method. This may cause detections.',
			Function = function(Enabled)
				if EntityLib.Alive and Fly.Enabled then
					EntityLib.Humanoid.PlatformStand = Enabled
				end
			end
		})

		Sit = Fly:CreateToggle({
			Name = 'Sit',
			Tooltip = 'Makes your character sit.',
			Function = function(Enabled)
				if EntityLib.Alive and Fly.Enabled then
					EntityLib.Humanoid.Sit = Enabled
				end
			end
		})

		SpoofJump = Fly:CreateToggle({
			Name = 'Spoof Jump',
			Tooltip = 'Spoofs your Humanoid.Jump property to the server, which is used to tell the server if you are currently holding jump.'
		})

		JumpValue = SpoofJump:CreateToggle({
			Name = 'Jump Value',
			Tooltip = 'Value to spoof Humanoid.Jump to'
		})
		
		State = Fly:CreateDropdown({
			Name = 'State',
			List = {'None', 'FallingDown', 'Ragdoll', 'GettingUp', 'Jumping', 'Swimming', 'Freefall', 'Flying', 'Landed', 'Running', 'RunningNoPhysics', 'StrafingNoPhysics', 'Climbing', 'Seated', 'Physics'},
			Function = function(Val)
				if Fly.Enabled and EntityLib.Alive and Val == 'None' then
					EntityLib.Humanoid:ChangeState(EntityLib.Humanoid.FloorMaterial == Enum.Material.Air and Enum.HumanoidStateType.Freefall or Enum.HumanoidStateType.Running)
				end
				StateMode:SetVisible(Val ~= 'None')
			end
		})

		StateMode = Fly:CreateDropdown({
			Name = 'State Mode',
			List = {'Regular', 'Spoof'},
			Tooltip = 'Regular - Changes your Humanoid\'s state normally.\nSpoof - Spoofs your Humanoid\'s state to the server, while not affecting your Humanoid\'s actual state.',
			Visible = false
		})
		
		UsePercentage = Fly:CreateToggle({
			Name = 'Use Percentage',
			Info = 'Uses speed based off a percentage of your Humanoid\'s walk speed',
		})
		
		Percentage = UsePercentage:CreateSlider({
			Name = 'Percentage',
			Default = 110,
			Min = 0,
			Max = 200,
			Suffix = '%'
		})
		
		UseLimits = UsePercentage:CreateToggle({
			Name = 'Use Limits',
			Info = 'Limits the speed calculated by Speed Percentage between the minimum and maximum values',
		})
		
		MinSpeed = UseLimits:CreateSlider({
			Name = 'Min Speed',
			Default = 0,
			Min = 0,
			Max = 32
		})
		
		MaxSpeed = UseLimits:CreateSlider({
			Name = 'Max Speed',
			Default = 32,
			Min = 0,
			Max = 64
		})
		
		Shift = Fly:CreateToggle({
			Name = 'Shift',
			Info = 'Allows you to toggle a faster speed when holding your keybind'
		})
		
		ShiftSpeed = Shift:CreateSlider({
			Name = 'Shift Speed',
			Default = 32,
			Min = 16,
			Max = 200,
		})
		
		ShiftUsePercentage = Shift:CreateToggle({
			Name = 'Shift Use Percentage',
		})
		
		ShiftPercentage = ShiftUsePercentage:CreateSlider({
			Name = 'Shift Percentage',
			Default = 120,
			Min = 0,
			Max = 300,
			Suffix = '%',
		})
		
		UseShiftLimits = ShiftUsePercentage:CreateToggle({
			Name = 'Use Shift Limits',
			Info = 'Limits the speed calculated by Speed Percentage between the minimum and maximum values'
		})
		
		MinShiftSpeed = UseShiftLimits:CreateSlider({
			Name = 'Min Shift Speed',
			Default = 0,
			Min = 0,
			Max = 32
		})
		
		MaxShiftSpeed = UseShiftLimits:CreateSlider({
			Name = 'Max Shift Speed',
			Default = 32,
			Min = 0,
			Max = 64
		})
		
		ShiftKeybind = Shift:CreateKeybind({
			Name = 'Shift',
			Keybind = 'LeftShift'
		})
	end)

	Run(function() -- HighJump
		local HighJump, Method, JumpPower, ResetVel, CustomGravity, JumpingGravity, FallingGravity, AutoDisable, Down
		
		local CustomVel
		
		const function StepCFrame(Delta)
			CustomVel -= (CustomGravity.Enabled and (CustomVel > 0 and JumpingGravity.Value or FallingGravity.Value) or workspace.Gravity) * Delta
			EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 0, EntityLib.Root.AssemblyLinearVelocity.Z)
			EntityLib.Character:TranslateBy(vector.create(0, CustomVel * Delta, 0))
			RunService.PostSimulation:Wait()
			if not EntityLib.Alive then return end
			EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 0, EntityLib.Root.AssemblyLinearVelocity.Z)
		end
		
		const function StepLinearVel(Delta)
			CustomVel -= (CustomGravity.Enabled and (CustomVel > 0 and JumpingGravity.Value or FallingGravity.Value) or workspace.Gravity) * Delta
			local ExistingLinearVelocity, ExistingAttachment = HighJump:GetInstance('LinearVelocity'), HighJump:GetInstance('Attachment')
			if ExistingLinearVelocity and ExistingAttachment then
				ExistingLinearVelocity.LineVelocity = CustomVel
				ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
			end
		end
		
		local Methods = {
			LinearVelocity = {
				Init = function()
					CustomVel = JumpPower.Value
					local Attachment = HighJump:CreateInstance('Attachment', 'Attachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})
					HighJump:CreateInstance('LinearVelocity', 'LinearVelocity', {
						VelocityConstraintMode = Enum.VelocityConstraintMode.Line,
						LineDirection = vector.yAxis,
						ForceLimitsEnabled = false,
						LineVelocity = CustomVel,
						Attachment0 = Attachment,
						Parent = workspace
					})
					local TimeOut = os.clock() + 1
					repeat
						if not EntityLib.Alive then return end
						local Delta = RunService.PreSimulation:Wait()
						if not EntityLib.Alive then return end
						StepLinearVel(Delta)
					until not HighJump.Enabled or not EntityLib.Alive or EntityLib.Humanoid.FloorMaterial == Enum.Material.Air or os.clock() >= TimeOut
				end,
				Function = StepLinearVel
			},
			Velocity = {
				Init = function()
					EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, JumpPower.Value, EntityLib.Root.AssemblyLinearVelocity.Z)
					local TimeOut = os.clock() + 1
					while EntityLib.Alive and EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air and HighJump.Enabled and os.clock() < TimeOut do
						RunService.PostSimulation:Wait()
					end
				end,
				Function = function(Delta)
					if CustomGravity.Enabled then
						EntityLib.Root.AssemblyLinearVelocity += vector.create(0, Delta * (workspace.Gravity - (EntityLib.Root.AssemblyLinearVelocity.Y > 0 and JumpingGravity.Value or FallingGravity.Value)), 0)
					end
				end
			},
			CFrame = {
				Init = function()
					CustomVel = JumpPower.Value
					local TimeOut = os.clock() + 1
					repeat
						if not EntityLib.Alive then return end
						local Delta = RunService.PreSimulation:Wait()
						if not EntityLib.Alive then return end
						StepCFrame(Delta)
					until not HighJump.Enabled or not EntityLib.Alive or EntityLib.Humanoid.FloorMaterial == Enum.Material.Air or os.clock() >= TimeOut
				end,
				Function = StepCFrame
			}
		}
		
		const function Jump()
			if not EntityLib.Alive then return end
			if EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
				Methods[Method.Value].Init()
				if Methods[Method.Value].Function then
					repeat
						local Delta = RunService.PreSimulation:Wait()
						if not EntityLib.Alive then break end
						Methods[Method.Value].Function(Delta)
					until not HighJump.Enabled or EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air
				end
			end
			if HighJump.Enabled and AutoDisable.Enabled then
				HighJump:Toggle(true)
			end
		end
		
		const function LocalRemoved()
			HighJump:CleanUp()
		end
		
		const function LocalAdded()
			LocalRemoved()
			HighJump:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('FloorMaterial'):Connect(function()
				if EntityLib.Humanoid.FloorMaterial ~= Enum.HumanoidStateType.Air and Down then
					Jump()
				end
			end))
		end
		
		HighJump = Movement:CreateModule({
			Name = 'HighJump',
			Info = 'Makes you jump high',
			Function = function(Enabled)
				if Enabled then
					if AutoDisable.Enabled then
						Jump()
					else
						Down = false
						HighJump:Clean(UIS.InputBegan:Connect(function(Input)
							if Input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
								Down = true
								if EntityLib.Humanoid.FloorMaterial ~= Enum.HumanoidStateType.Air then
									Jump()
								end
							end
						end))
						HighJump:Clean(UIS.InputEnded:Connect(function(Input)
							if Input.KeyCode == Enum.KeyCode.Space then
								Down = false
							end
						end))
						HighJump:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
						HighJump:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
						if EntityLib.Alive then
							LocalAdded()
						end
					end
				elseif ResetVel.Enabled and EntityLib.Alive and EntityLib.Root.AssemblyLinearVelocity.Y > 0 then
					EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 0, EntityLib.Root.AssemblyLinearVelocity.Z)
				end
			end,
			ExtraText = function()
				return Method.Value
			end
		})
		
		Method = HighJump:CreateDropdown({
			Name = 'Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame'},
			Function = function(Val)
				ResetVel:SetVisible(Val ~= 'CFrame')
			end
		})
		
		JumpPower = HighJump:CreateSlider({
			Name = 'Jump Power',
			Default = 100,
			Min = 1,
			Max = 250
		})
		
		ResetVel = HighJump:CreateToggle({
			Name = 'Reset Vel',
			Info = 'Resets you Y velocity after disabling HighJump',
		})
		
		CustomGravity = HighJump:CreateToggle({
			Name = 'Custom Gravity',
		})
		
		JumpingGravity = CustomGravity:CreateSlider({
			Name = 'Jumping Gravity',
			Default = 196.2,
			Min = 0,
			Max = 500,
			Decimal = 10,
		})
		
		FallingGravity = CustomGravity:CreateSlider({
			Name = 'Falling Gravity',
			Default = 196.2,
			Min = 0,
			Max = 500,
			Decimal = 10,
		})
		
		AutoDisable = HighJump:CreateToggle({
			Name = 'Auto Disable',
			Default = true,
			Function = function(Enabled)
				if HighJump.Enabled and Enabled then
					HighJump:Toggle(true)
				end
			end
		})
	end)

	Run(function() -- LongJump
		local LongJump, Method, Speed, CustomJump, CustomJumpPower, CustomJumpMethod, JumpPower, CustomGravity, JumpingGravity, FallingGravity, AutoDisable, Down
		
		const Methods = {
			LinearVelocity = {
				Init = function()
					local Attachment = LongJump:CreateInstance('Attachment', 'Attachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})
					LongJump:CreateInstance('LinearVelocity', 'LinearVelocity', {
						ForceLimitMode = Enum.ForceLimitMode.PerAxis,
						MaxAxesForce = vector.hugeXZ,
						VectorVelocity = EntityLib.Humanoid.MoveDirection * Speed.Value,
						Attachment0 = Attachment,
						Parent = workspace
					})
				end,
				Function = function()
					local ExistingLinearVelocity, ExistingAttachment = LongJump:GetInstance('LinearVelocity'), LongJump:GetInstance('Attachment')
					if ExistingLinearVelocity and ExistingAttachment then
						ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
						ExistingLinearVelocity.VectorVelocity = EntityLib.Humanoid.MoveDirection * Speed.Value
					end
				end,
			},
			Velocity = {
				Function = function()
					local MoveDirection = EntityLib.Humanoid.MoveDirection
					EntityLib.Root.AssemblyLinearVelocity = vector.create(MoveDirection.X * Speed.Value, EntityLib.Root.AssemblyLinearVelocity.Y, MoveDirection.Z * Speed.Value)
				end,
			},
			CFrame = {
				Function = function(Delta)
					local Vel = EntityLib.Humanoid.MoveDirection * (Speed.Value - EntityLib.Humanoid.WalkSpeed)
					EntityLib.Character:TranslateBy(Vel * Delta)
				end,
			},
		}
		
		local CustomVel
		
		const function StepCFrame(Delta)
			CustomVel -= (CustomGravity.Enabled and (CustomVel > 0 and JumpingGravity.Value or FallingGravity.Value) or workspace.Gravity) * Delta
			EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 0, EntityLib.Root.AssemblyLinearVelocity.Z)
			EntityLib.Character:TranslateBy(vector.create(0, CustomVel * Delta, 0))
			RunService.PostSimulation:Wait()
			if not EntityLib.Alive then return end
			EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, 0, EntityLib.Root.AssemblyLinearVelocity.Z)
		end
		
		const function StepLinearVel(Delta)
			CustomVel -= (CustomGravity.Enabled and (CustomVel > 0 and JumpingGravity.Value or FallingGravity.Value) or workspace.Gravity) * Delta
			local ExistingLinearVelocity, ExistingAttachment = LongJump:GetInstance('VertLinearVelocity'), LongJump:GetInstance('VertAttachment')
			if ExistingLinearVelocity and ExistingAttachment then
				ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
				ExistingLinearVelocity.LineVelocity = CustomVel
			end
		end
		
		const CustomJumpMethods = {
			LinearVelocity = {
				Init = function()
					CustomVel = CustomJumpPower.Enabled and JumpPower.Value or EntityLib.Humanoid.JumpPower

					local Attachment = LongJump:CreateInstance('Attachment', 'VertAttachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})

					LongJump:CreateInstance('LinearVelocity', 'VertLinearVelocity', {
						VelocityConstraintMode = Enum.VelocityConstraintMode.Line,
						LineDirection = vector.yAxis,
						ForceLimitsEnabled = false,
						LineVelocity = CustomVel,
						Attachment0 = Attachment,
						Parent = workspace
					})
		
					repeat
						const Delta = RunService.PreSimulation:Wait()
						if EntityLib.Alive then
							StepLinearVel(Delta)
						end
					until not LongJump.Enabled or not EntityLib.Alive or EntityLib.Humanoid.FloorMaterial == Enum.Material.Air
				end,
				Function = StepLinearVel,
			},
			Velocity = {
				Init = function()
					EntityLib.Root.AssemblyLinearVelocity = vector.create(EntityLib.Root.AssemblyLinearVelocity.X, JumpPower.Value, EntityLib.Root.AssemblyLinearVelocity.Z)
					repeat
						RunService.PostSimulation:Wait()
					until not LongJump.Enabled or not EntityLib.Alive or EntityLib.Humanoid.FloorMaterial == Enum.Material.Air
				end,
				Function = function(Delta)
					if CustomGravity.Enabled then
						EntityLib.Root.AssemblyLinearVelocity += vector.create(0, Delta * (workspace.Gravity - (EntityLib.Root.AssemblyLinearVelocity.Y > 0 and JumpingGravity.Value or FallingGravity.Value)), 0)
					end
				end
			},
			CFrame = {
				Init = function()
					CustomVel = CustomJumpPower.Enabled and JumpPower.Value or EntityLib.Humanoid.JumpPower
					repeat
						const Delta = RunService.PreSimulation:Wait()
						if EntityLib.Alive then
							StepCFrame(Delta)
						end
					until not LongJump.Enabled or not EntityLib.Alive or EntityLib.Humanoid.FloorMaterial == Enum.Material.Air
				end,
				Function = StepCFrame
			}
		}

		const END_STATES = {
			[Enum.HumanoidStateType.FallingDown] = true,
			[Enum.HumanoidStateType.Swimming] = true,
			[Enum.HumanoidStateType.Ragdoll] = true
		}
		
		const function Jump()
			if EntityLib.Alive and EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
				Modules.Speed:DisableMovers()

				if Methods[Method.Value].Init then
					Methods[Method.Value].Init()
				end

				FrictionTable.LongJump = Method.Value == 'Velocity' or nil
				UpdateFriction()
				
				if CustomJump.Enabled then
					CustomJumpMethods[CustomJumpMethod.Value].Init()
				else
					EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					repeat
						RunService.PostSimulation:Wait()
					until EntityLib.Humanoid.FloorMaterial == Enum.Material.Air or not LongJump.Enabled
				end
				
				if LongJump.Enabled and EntityLib.Alive then
					repeat
						const Delta = RunService.PreSimulation:Wait()
						if not EntityLib.Alive then break end
		
						if CustomJump.Enabled then
							const CurrentJumpMethod = CustomJumpMethods[CustomJumpMethod.Value]
							if CurrentJumpMethod.Function then
								CustomJumpMethods[CustomJumpMethod.Value].Function(Delta)
							end
						end

						Methods[Method.Value].Function(Delta)
					until EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air or END_STATES[EntityLib.Humanoid:GetState()] or not LongJump.Enabled
				else
					FrictionTable.LongJump = nil
					UpdateFriction()
				end
			end
		
			Modules.Speed:EnableMovers()
		
			if LongJump.Enabled and AutoDisable.Enabled then
				LongJump:Toggle(true)
			end
		end
		
		const function LocalAdded()
			LongJump:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('FloorMaterial'):Connect(function()
				if EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air and Down then
					Jump()
				end
			end))
		end

		const function LocalRemoved()
			LongJump:CleanUp()
		end
		
		LongJump = Movement:CreateModule({
			Name = 'LongJump',
			Info = 'Makes your jump very much long',
			Function = function(Enabled)
				if Enabled then
					if AutoDisable.Enabled then
						Jump()
					else
						LongJump:Clean(UIS.InputBegan:Connect(function(Input)
							if Input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
								Down = true
								if EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
									Jump()
								end
							end
						end))

						LongJump:Clean(UIS.InputEnded:Connect(function(Input)
							if Input.KeyCode == Enum.KeyCode.Space then 
								Down = false
							end
						end))
						LongJump:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
						LongJump:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))

						if EntityLib.Alive then
							LocalAdded()
						end
					end
				else
					Down = nil
				end
			end,
			ExtraText = function()
				return Method.Value
			end
		})
		
		Method = LongJump:CreateDropdown({
			Name = 'Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame'}
		})
		
		Speed = LongJump:CreateSlider({
			Name = 'Speed',
			Default = 50,
			Min = 1,
			Max = 500
		})
		
		CustomJump = LongJump:CreateToggle({
			Name = 'Custom Jump',
		})
		
		CustomJumpMethod = CustomJump:CreateDropdown({
			Name = 'Custom Jump Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame'},
		})
		
		CustomJumpPower = CustomJump:CreateToggle({
			Name = 'Custom Jump Power',
			Default = true
		})
		
		JumpPower = CustomJumpPower:CreateSlider({
			Name = 'Jump Power',
			Default = 50,
			Min = 1,
			Max = 100,
		})
		
		CustomGravity = CustomJump:CreateToggle({
			Name = 'Custom Gravity',
		})
		
		JumpingGravity = CustomGravity:CreateSlider({
			Name = 'Jumping Gravity',
			Default = 196.2,
			Min = 0,
			Max = 500,
			Decimal = 10
		})
		
		FallingGravity = CustomGravity:CreateSlider({
			Name = 'Falling Gravity',
			Default = 196.2,
			Min = 0,
			Max = 500,
			Decimal = 10
		})
		
		AutoDisable = LongJump:CreateToggle({
			Name = 'Auto Disable',
			Default = true,
			Function = function(Enabled)
				if LongJump.Enabled and Enabled then
					LongJump:Toggle(true)
				end
			end
		})
	end)

	Run(function() -- Speed
		local Speed, Value, Method, UsePercentage, Percentage, UseLimits, MinSpeed, MaxSpeed, AutoJump, CustomJump, CustomJumpPower, IgnoreCars
		local Shift, ShiftSpeed, ShiftUsePercentage, ShiftPercentage, UseShiftLimits, MinShiftSpeed, MaxShiftSpeed, ShiftKeybind
		local OldWalkSpeed, WalkSpeedCon, db
		
		local ShiftPressed = false
		
		const function GetMoveDirection()
			local CalculatedSpeed
			if Shift.Enabled and ShiftPressed then
				CalculatedSpeed = ShiftUsePercentage.Enabled and EntityLib.Humanoid.WalkSpeed * (ShiftPercentage.Value / 100) or ShiftSpeed.Value
				if ShiftUsePercentage.Enabled and UseShiftLimits.Enabled then
					CalculatedSpeed = math.clamp(CalculatedSpeed, MinShiftSpeed.Value, MaxShiftSpeed.Value)
				end
			else
				CalculatedSpeed = UsePercentage.Enabled and EntityLib.Humanoid.WalkSpeed * (Percentage.Value / 100) or Value.Value
				if UsePercentage.Enabled and UseLimits.Enabled then
					CalculatedSpeed = math.clamp(CalculatedSpeed, MinSpeed.Value, MaxSpeed.Value)
				end
			end
		
			return (TargetStrafeVector or EntityLib.Humanoid.MoveDirection) * CalculatedSpeed
		end
		
		const function GetWalkSpeed()
			local CalculatedSpeed = UsePercentage.Enabled and OldWalkSpeed * (Percentage.Value / 100) or Value.Value
			if UsePercentage.Enabled and UseLimits.Enabled then
				CalculatedSpeed = math.clamp(CalculatedSpeed, MinSpeed.Value, MaxSpeed.Value)
			end
			return CalculatedSpeed
		end
		
		const function UpdateWalkSpeed()
			if Speed.Enabled and Method.Value == 'WalkSpeed' and EntityLib.Alive then
				db = true
				EntityLib.Humanoid.WalkSpeed = GetWalkSpeed()
			end
		end
		
		local Methods = {
			LinearVelocity = {
				Init = function()
					local Attachment = Speed:CreateInstance('Attachment', 'Attachment', {
						Name = 'RootAttachment',
						Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position,
						Parent = EntityLib.Root
					})
					Speed:CreateInstance('LinearVelocity', 'LinearVelocity', {
						ForceLimitMode = Enum.ForceLimitMode.PerAxis,
						MaxAxesForce = vector.hugeXZ,
						Attachment0 = Attachment,
						VectorVelocity = GetMoveDirection(),
						Parent = workspace
					})
				end,
				Function = function()
					local ExistingLinearVelocity, ExistingAttachment = Speed:GetInstance('LinearVelocity'), Speed:GetInstance('Attachment')
					if ExistingLinearVelocity and ExistingAttachment then
						ExistingAttachment.Position = EntityLib.Root.AssemblyCenterOfMass - EntityLib.Root.Position
						ExistingLinearVelocity.VectorVelocity = GetMoveDirection()
					end
				end,
				Disable = function()
					local LinearVelocity = Speed:GetInstance('LinearVelocity')
					if LinearVelocity then
						LinearVelocity.Enabled = false
						LinearVelocity.VectorVelocity = vector.zero
					end
				end,
				Enable = function()
					local LinearVelocity = Speed:GetInstance('LinearVelocity')
					if LinearVelocity then
						LinearVelocity.Enabled = true
					end
				end,
			},
			Velocity = {
				Function = function()
					local MoveDirection = GetMoveDirection()
					local Vel = vector.create(MoveDirection.X, EntityLib.Root.AssemblyLinearVelocity.Y, MoveDirection.Z)
					EntityLib.Root.AssemblyLinearVelocity = Vel
				end,
			},
			CFrame = {
				Function = function(Delta)
					local MoveDirection = GetMoveDirection()
					local CurrentMoveDirection = (EntityLib.Humanoid.MoveDirection * EntityLib.Humanoid.WalkSpeed)
					
					EntityLib.Character:TranslateBy((MoveDirection - CurrentMoveDirection) * Delta)
				end,
			},
		}
		
		const function LocalRemoved()
			if WalkSpeedCon then
				WalkSpeedCon:Disconnect()
				WalkSpeedCon = nil
			end
			Speed:CleanUp()
			Speed:ClearInstances()
			FrictionTable.Speed = nil
			UpdateFriction()
		end
		
		const function LocalAdded()
			LocalRemoved()
			if Method.Value == 'WalkSpeed' then
				OldWalkSpeed = EntityLib.Humanoid.WalkSpeed
				EntityLib.Humanoid.WalkSpeed = GetWalkSpeed()
				
				WalkSpeedCon = Speed:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
					if db then db = false; return end
					db = true
					OldWalkSpeed = EntityLib.Humanoid.WalkSpeed
					EntityLib.Humanoid.WalkSpeed = GetWalkSpeed()
				end))
			else
				local CurrentMethod = Methods[Method.Value]
				if CurrentMethod.Init then
					CurrentMethod.Init()
				end
			end
		end
		
		const function DisableCurrentMethod()
			local CurrentMethod = Methods[Method.Value]
			if CurrentMethod.Disable then
				CurrentMethod.Disable()
			end
		end
		
		const function EnableCurrentMethod()
			local CurrentMethod = Methods[Method.Value]
			if CurrentMethod.Enable then
				CurrentMethod.Enable()
			end
		end
		
		local Sat = false
		const function SeatCheck()
			if IgnoreCars.Enabled then
				if EntityLib.Humanoid.SeatPart then
					if not Sat then
						Sat = true
						DisableCurrentMethod()
		
						return true
					end
				elseif Sat then
					Sat = false
					EnableCurrentMethod()
				end
			end
		
			return false
		end
		
		local Climbed = false
		const function ClimbingCheck()
			local State = EntityLib.Humanoid:GetState()
			if State == Enum.HumanoidStateType.Climbing then
				if not Climbed then
					Climbed = true
					DisableCurrentMethod()
				end
		
				return true
			elseif Climbed then
				Climbed = false
				EnableCurrentMethod()
			end
		
			return false
		end
		
		Speed = Movement:CreateModule({
			Name = 'Speed',
			Info = 'Increases your speed using various methods',
			Function = function(Enabled)
				if Enabled then
					Speed:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Speed:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))

					if EntityLib.Alive then
						LocalAdded()
					end
		
					ShiftPressed = ShiftKeybind:IsPressed()
		
					FrictionTable.Speed = Method.Value == 'Velocity' or nil
					UpdateFriction()
		
					for i = 1, 0, -1 do
						local Signal = i == 1 and UIS.InputBegan or UIS.InputEnded
						Speed:Clean(Signal:Connect(function(Input)
							if i == 1 and UIS:GetFocusedTextBox() then return end
							if ShiftKeybind:Check(Input) then
								ShiftPressed = i == 1
							end
						end))
					end
		
					Climbed = false
					Sat = false
					
					if Method.Value ~= 'WalkSpeed' then
						Speed:Clean(RunService.PreSimulation:Connect(function(Delta)
							if not EntityLib.Alive or (Modules.Fly and Modules.Fly.Enabled) or (Modules.LongJump and Modules.LongJump.Enabled) then return end
							if SeatCheck() then return end
							if ClimbingCheck() then return end
							
							Methods[Method.Value].Function(Delta)
		
							if AutoJump.Enabled and EntityLib.Humanoid.MoveDirection ~= vector.zero and EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
								if CustomJump.Enabled then
									local Vel = EntityLib.Root.AssemblyLinearVelocity
									Vel = vector.create(Vel.X, CustomJumpPower.Value, Vel.Z)
									EntityLib.Root.AssemblyLinearVelocity = Vel
								else
									EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							end
						end))
					end
				else
					FrictionTable.Speed = nil
					UpdateFriction()
					if Method.Value == 'WalkSpeed' and OldWalkSpeed and EntityLib.Alive then
						EntityLib.Humanoid.WalkSpeed = OldWalkSpeed
					end
					OldWalkSpeed = nil
				end
			end,
			ExtraText = function()
				return Method.Value
			end,
		})
		
		function Speed:DisableMovers()
			Sat = false
			Climbed = false
			DisableCurrentMethod()
		end
		
		function Speed:EnableMovers()
			if not SeatCheck() and not ClimbingCheck() then
				EnableCurrentMethod()
			end
		end
		
		Value = Speed:CreateSlider({
			Name = 'Speed',
			Default = 16,
			Min = 0,
			Max = 200,
			Function = UpdateWalkSpeed
		})
		
		Method = Speed:CreateDropdown({
			Name = 'Method',
			List = {'LinearVelocity', 'Velocity', 'CFrame', 'WalkSpeed'},
			Info = 'LinearVelocity - Uses a LinearVelocity Instance to modify your Velocity.\nVelocity - Directly adjusts the Velocity of your character.\nCFrame - Directly adjusts the position of your character.\nWalkSpeed - Adjusts the WalkSpeed of your Humanoid.',
			Function = function(Val)
				if Speed.Enabled then
					if Val ~= 'WalkSpeed' and OldWalkSpeed then
						if EntityLib.Alive then
							LocalRemoved()
							EntityLib.Humanoid.WalkSpeed = OldWalkSpeed
						end
						OldWalkSpeed = nil
					end
					Speed:Restart()
				end
			end
		})
		
		UsePercentage = Speed:CreateToggle({
			Name = 'Use Percentage',
			Info = 'Uses speed based off a percentage of your humanoid\'s walk speed',
			Function = UpdateWalkSpeed,
		})
		
		Percentage = UsePercentage:CreateSlider({
			Name = 'Percentage',
			Min = 0,
			Default = 110,
			Max = 200,
			Suffix = '%',
			Function = UpdateWalkSpeed
		})
		
		UseLimits = UsePercentage:CreateToggle({
			Name = 'Use Limits',
			Info = 'Limits the speed calculated by Speed Percentage between the minimum and maximum values',
			Function = UpdateWalkSpeed,
		})
		
		MinSpeed = UseLimits:CreateSlider({
			Name = 'Min Speed',
			Default = 0,
			Min = 0,
			Max = 32,
			Function = UpdateWalkSpeed
		})
		
		MaxSpeed = UseLimits:CreateSlider({
			Name = 'Max Speed',
			Default = 32,
			Min = 0,
			Max = 64,
			Function = UpdateWalkSpeed
		})
		
		AutoJump = Speed:CreateToggle({
			Name = 'Auto Jump',
			Info = 'Automatically jumps when moving',
		})
		
		CustomJump = AutoJump:CreateToggle({
			Name = 'Custom Jump',
			Info = 'Allows you to have a custom jump',
		})
		
		CustomJumpPower = CustomJump:CreateSlider({
			Name = 'Jump Power',
			Default = 30,
			Min = 1,
			Max = 75,
		})
		
		Shift = Speed:CreateToggle({
			Name = 'Shift',
			Info = 'Allows you to toggle a faster speed when holding your keybind',
		})
		
		ShiftSpeed = Shift:CreateSlider({
			Name = 'Shift Speed',
			Default = 32,
			Min = 16,
			Max = 200,
		})
		
		ShiftUsePercentage = Shift:CreateToggle({
			Name = 'Shift Use Percentage',
		})
		
		ShiftPercentage = ShiftUsePercentage:CreateSlider({
			Name = 'Shift Percentage',
			Default = 120,
			Min = 0,
			Max = 300,
			Suffix = '%',
		})
		
		UseShiftLimits = ShiftUsePercentage:CreateToggle({
			Name = 'Use Shift Limits',
			Info = 'Limits the speed calculated by Speed Percentage between the minimum and maximum values',
			Function = UpdateWalkSpeed,
		})
		
		MinShiftSpeed = UseShiftLimits:CreateSlider({
			Name = 'Min Shift Speed',
			Default = 0,
			Min = 0,
			Max = 32,
			Function = UpdateWalkSpeed
		})
		
		MaxShiftSpeed = UseShiftLimits:CreateSlider({
			Name = 'Max Shift Speed',
			Default = 32,
			Min = 0,
			Max = 64,
			Function = UpdateWalkSpeed
		})
		
		ShiftKeybind = Shift:CreateKeybind({
			Name = 'Shift',
			Keybind = 'LeftShift',
		})
		
		IgnoreCars = Speed:CreateToggle({
			Name = 'Ignore Cars',
			Info = 'Disables speed while inside a car',
			Default = true,
			Function = function(Enabled)
				if Speed.Enabled and not Enabled and Sat then
					Sat = false
					EnableCurrentMethod()
				end
			end
		})
	end)

	Run(function() -- Spider
		local Spider, Speed, Radius, Method, ResetVel, MaxAngle
		
		local Params = RaycastParams.new()
		Params.RespectCanCollide = true
		Params.IgnoreWater = true
		
		local Methods = {
			Velocity = function()
				EntityLib.Root.AssemblyLinearVelocity += vector.create(0, Speed.Value, 0)
			end,
			CFrame = function(Delta)
				EntityLib.Character:TranslateBy(vector.create(0, Speed.Value * Delta, 0))
			end,
		}
		
		Spider = Movement:CreateModule({
			Name = 'Spider',
			Info = 'Makes you climb up walls like a spider 🕷️',
			Enabled = function()
				local ClimbedLastFrame
		
				local Exclusions = {}
		
				const function RefreshExclusions()
					table.clear(Exclusions)
					if EntityLib.Alive then
						Exclusions[1] = EntityLib.Character
						Params.CollisionGroup = EntityLib.Root.CollisionGroup
					end

					for _, Entity in EntityLib.List do
						table.insert(Exclusions, Entity.Character)
					end

					Params.FilterDescendantsInstances = Exclusions
				end
		
				RefreshExclusions()
		
				Spider:Clean(EntityLib.Events.LocalAdded:Connect(RefreshExclusions))
				Spider:Clean(EntityLib.Events.LocalRemoved:Connect(RefreshExclusions))
				Spider:Clean(EntityLib.Events.EntityAdded:Connect(RefreshExclusions))
				Spider:Clean(EntityLib.Events.EntityRemoved:Connect(RefreshExclusions))
				Spider:Clean(RunService.PreSimulation:Connect(function(Delta)
					if not EntityLib.Alive then return end
		
					local MoveDirection = EntityLib.Humanoid.MoveDirection * Radius.Value
					
					local Raycast = workspace:Raycast(EntityLib.Root.Position - vector.create(0, EntityLib.HipHeight - 0.5, 0), MoveDirection, Params)
					if Raycast and Raycast.Normal.Y <= MaxAngle then
						ClimbedLastFrame = true
						Methods[Method.Value](Delta)
					elseif ClimbedLastFrame then
						if ResetVel.Enabled then
							local Vel = EntityLib.Root.AssemblyLinearVelocity
							EntityLib.Root.AssemblyLinearVelocity = vector.create(Vel.X, 0, Vel.Z)
						end
						ClimbedLastFrame = nil
					end
				end))
			end,
			ExtraText = function()
				return Method.Value
			end,
		})
		
		Speed = Spider:CreateSlider({
			Name = 'Speed',
			Default = 20,
			Min = 0,
			Max = 100,
		})
		
		Radius = Spider:CreateSlider({
			Name = 'Radius',
			Default = 2.5,
			Min = 1,
			Max = 9,
			Decimal = 10
		})
		
		Spider:CreateSlider({
			Name = 'Max Angle',
			Default = 10,
			Min = 0,
			Max = 90,
			Function = function(Val)
				MaxAngle = 1 - math.cos(math.rad(Val))
			end
		})
		
		MaxAngle = 1 - math.cos(math.rad(10))
		
		Method = Spider:CreateDropdown({
			Name = 'Method',
			List = {'Velocity', 'CFrame'},
			Function = function(Val)
				ResetVel:SetVisible(Val == 'Velocity')
			end,
		})
		
		ResetVel = Spider:CreateToggle({
			Name = 'Reset Vel',
			Info = 'Resets your Y velocity back to zero after climbing over a wall'
		})
	end)

	Run(function() -- SpinBot
		local SpinBot, Speed, IgnoreCars
		
		SpinBot = Movement:CreateModule({
			Name = 'SpinBot',
			Info = 'Makes you spin (Doesn\'t work in first person)',
			Function = function(Enabled)
				FrictionTable.SpinBot = Enabled or nil
				UpdateFriction()
				if Enabled then
					SpinBot:Clean(RunService.PreSimulation:Connect(function()
						if EntityLib.Alive then
							if IgnoreCars.Enabled and EntityLib.Humanoid.SeatPart then return end
							
							EntityLib.Root.AssemblyAngularVelocity = vector.create(EntityLib.Root.AssemblyAngularVelocity.X, Speed.Value, EntityLib.Root.AssemblyAngularVelocity.Z)
						end
					end))
				end
			end
		})
		
		Speed = SpinBot:CreateSlider({
			Name = 'Speed',
			Default = 45,
			Min = 0,
			Max = 360
		})
		
		IgnoreCars = SpinBot:CreateToggle({
			Name = 'Ignore Cars',
			Default = true
		})
	end)

	Run(function() -- Step
		local Step, Radius, MinSize, MaxSize, MaxAngle
		
		local Params = RaycastParams.new()
		Params.RespectCanCollide = true
		Params.IgnoreWater = true
		
		Step = Movement:CreateModule({
			Name = 'Step',
			Info = 'Allows you to walk up parts instantly',
			Enabled = function()
				local Exclusions = {}
		
				const function RefreshExclusions()
					table.clear(Exclusions)
					if EntityLib.Alive then
						Exclusions[1] = EntityLib.Character
						Params.CollisionGroup = EntityLib.Root.CollisionGroup
					end

					for _, Entity in EntityLib.List do
						table.insert(Exclusions, Entity.Character)
					end

					Params.FilterDescendantsInstances = Exclusions
				end
		
				RefreshExclusions()
		
				Step:Clean(EntityLib.Events.LocalAdded:Connect(RefreshExclusions))
				Step:Clean(EntityLib.Events.LocalRemoved:Connect(RefreshExclusions))
				Step:Clean(EntityLib.Events.EntityAdded:Connect(RefreshExclusions))
				Step:Clean(EntityLib.Events.EntityRemoved:Connect(RefreshExclusions))
				Step:Clean(RunService.PreSimulation:Connect(function()
					if not EntityLib.Alive then return end
		
					local MoveDirection = EntityLib.Humanoid.MoveDirection * Radius.Value
					
					local Raycast = workspace:Raycast(EntityLib.Root.Position - vector.create(0, EntityLib.HipHeight - 0.5, 0), MoveDirection, Params)
					if Raycast and Raycast.Normal.Y <= MaxAngle then
						local TopPoint = Raycast.Instance.Position.Y + (Raycast.Instance.Size.Y / 2)
						local HitPoint = Raycast.Position.Y - 0.5
						local Diff = TopPoint - HitPoint
		
						if Diff >= MinSize.Value and Diff <= MaxSize.Value then
							EntityLib.Character:TranslateBy(vector.create(0, Diff, 0))
						end
					end
				end))
			end
		})
		
		Radius = Step:CreateSlider({
			Name = 'Radius',
			Default = 1.5,
			Min = 1,
			Max = 9,
			Decimal = 10
		})
		
		MinSize = Step:CreateSlider({
			Name = 'Min Size',
			Default = 2,
			Min = 0,
			Max = 4
		})
		
		MaxSize = Step:CreateSlider({
			Name = 'Max Size',
			Default = 4,
			Min = 1,
			Max = 20
		})
		
		Step:CreateSlider({
			Name = 'Max Angle',
			Default = 10,
			Min = 0,
			Max = 90,
			Function = function(Val)
				MaxAngle = 1 - math.cos(math.rad(Val))
			end
		})
		
		MaxAngle = 1 - math.cos(math.rad(10))
	end)

	Run(function() -- Swim
		local Swim, Speed, UsePercentage, Percentage, UseLimits, MinSpeed, MaxSpeed
		
		local UpKeybind, DownKeybind
		local W: number, A: number, S: number, D: number, Q: number, E: number
		
		local DisabledStates = Enum.HumanoidStateType:GetEnumItems()
		DisabledStates[17] = nil
		table.remove(DisabledStates, 15)
		table.remove(DisabledStates, 5)
		local PrevStates = {}
		
		const function LocalRemoved()
			Swim:CleanUp()
			table.clear(PrevStates)
		end
		
		const function LocalAdded()
			LocalRemoved()
			for _, State in DisabledStates do
				PrevStates[State] = EntityLib.Humanoid:GetStateEnabled(State)
				if PrevStates[State] then
					EntityLib.Humanoid:SetStateEnabled(State, false)
				end
			end

			EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

			local db = false
			Swim:Clean(EntityLib.Humanoid.StateEnabledChanged:Connect(function(State, Enabled)
				if db then return end
				db = true
				PrevStates[State] = Enabled
				if Enabled then
					EntityLib.Humanoid:SetStateEnabled(State, false)
				end
				db = false
			end))
		end
		
		Swim = Movement:CreateModule({
			Name = 'Swim',
			Info = 'Makes you swim',
			Function = function(Enabled)
				if Enabled then
					Swim:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Swim:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					if EntityLib.Alive then
						LocalAdded()
					end
		
					W = UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0
					A = UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0
					S = UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0
					D = UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0
					E, Q = UpKeybind:IsPressed() and 1 or 0, DownKeybind:IsPressed() and 1 or 0
		
					for i = 1, 0, -1 do
						local Signal = i == 1 and UIS.InputBegan or UIS.InputEnded
						Swim:Clean(Signal:Connect(function(Input)
							if Input.KeyCode == Enum.KeyCode.W then
								W = i
							elseif Input.KeyCode == Enum.KeyCode.A then
								A = i
							elseif Input.KeyCode == Enum.KeyCode.S then
								S = i
							elseif Input.KeyCode == Enum.KeyCode.D then
								D = i
							elseif UpKeybind:Check(Input) then
								E = i
							elseif DownKeybind:Check(Input) then
								Q = i
							end
						end))
					end
		
					Swim:Clean(RunService.PreSimulation:Connect(function(Delta)
						if EntityLib.Alive then
							EntityLib.Root.AssemblyLinearVelocity += vector.create(0, Delta * workspace.Gravity, 0)
						end
		
						RunService.PostSimulation:Wait()
		
						if EntityLib.Alive then
							if math.max(W, A, S, D, E, Q) ~= 0 then
								local Multi = UsePercentage.Enabled and (EntityLib.Humanoid.WalkSpeed * (Percentage.Value / 100)) or Speed.Value
								if UsePercentage.Enabled and UseLimits.Enabled then
									Multi = math.clamp(Multi, MinSpeed.Value, MaxSpeed.Value)
								end
		
								const CameraCFrame = Camera.CFrame
								const Forward = CameraCFrame.LookVector * (W - S)
								const Horizontal = CameraCFrame.RightVector * (D - A)
								const Vertical = vector.yAxis * (E - Q)
		
								EntityLib.Root.AssemblyLinearVelocity = vector.normalize(Forward + Horizontal + Vertical) * Multi
							else
								EntityLib.Root.AssemblyLinearVelocity = vector.zero
							end
						end
					end))
				else
					if EntityLib.Alive then
						for State, Enabled in PrevStates do
							EntityLib.Humanoid:SetStateEnabled(State, Enabled)
						end
					end
					table.clear(PrevStates)
				end
			end
		})
		
		UpKeybind = Swim:CreateKeybind({
			Name = 'Up',
			Keybind = 'Space',
			Secondary = true
		})
		
		DownKeybind = Swim:CreateKeybind({
			Name = 'Down',
			Secondary = true
		})
		
		Speed = Swim:CreateSlider({
			Name = 'Speed',
			Default = 16,
			Min = 0,
			Max = 64,
		})
		
		UsePercentage = Swim:CreateToggle({
			Name = 'Use Percentage',
			Info = 'Uses speed based off a percentage of your humanoid\'s walk speed',
		})
		
		Percentage = UsePercentage:CreateSlider({
			Name = 'Percentage',
			Min = 0,
			Default = 110,
			Max = 200,
			Suffix = '%',
		})
		
		UseLimits = UsePercentage:CreateToggle({
			Name = 'Use Limits',
			Info = 'Limits the speed calculated by Speed Percentage between the minimum and maximum values',
		})
		
		MinSpeed = UseLimits:CreateSlider({
			Name = 'Min Speed',
			Default = 0,
			Min = 0,
			Max = 32,
		})
		
		MaxSpeed = UseLimits:CreateSlider({
			Name = 'Max Speed',
			Default = 32,
			Min = 0,
			Max = 64,
		})
	end)

	Run(function() -- TargetStrafe
		-- completely skidded from Vape V4
		
		local TargetStrafe, SearchRange, StrafeRange, YFactor, UsePlayers, UseNPCs, WallCheck
		
		const Params = RaycastParams.new()
		Params.RespectCanCollide = true
		
		const AirCheckVector = vector.create(0, -70, 0)
		
		local Module, Old, Fly, Angle, LastEntity
		
		local MoveFunction = function(self, MoveDirection, Face)
			local Entity = not UIS:IsKeyDown(Enum.KeyCode.S) and EntityLib:GetClosestEntity({
				Range = SearchRange.Value,
				WallCheck = WallCheck.Enabled,
				Players = UsePlayers.Enabled,
				NPCs = UseNPCs.Enabled,
				Part = 'Root'
			}) or nil
		
			if Entity then
				local RootPos = Entity.Root.Position
				Params.FilterDescendantsInstances = {EntityLib.Character, Entity.Character}
				Params.CollisionGroup = EntityLib.Root.CollisionGroup
		
				if Fly.Enabled or workspace:Raycast(RootPos, AirCheckVector, Params) then
					local LocalPos = EntityLib.Root.Position
					local Factor = 0
					if Entity ~= LastEntity then
						local _, Y = CFrame.lookAt(RootPos, EntityLib.Root.Position):ToOrientation()
						Angle = math.deg(Y)
					end
		
					local yFactor = math.abs(LocalPos.Y - RootPos.Y) * (YFactor.Value / 100)
					local CharPos = vector.create(RootPos.X, LocalPos.Y, RootPos.Z)
					local LookVector = CFrame.Angles(0, math.rad(Angle), 0).LookVector
					local NewPos = CharPos + (LookVector * (StrafeRange.Value - yFactor))
					local Origin = CharPos
					local Target = NewPos
		
					if not WallCheck.Enabled and workspace:Raycast(RootPos, (LocalPos - RootPos), Params) then
						Origin = CharPos + (LookVector * vector.magnitude(CharPos - LocalPos))
						Target = CharPos
					end
					
					local Magnitude = vector.magnitude(LocalPos - NewPos)
					if Magnitude < 3 then
						Factor = (8 - math.min(Magnitude, 3))
					else
						local Blockcast = workspace:Blockcast(CFrame.new(Origin), vector.create(1, EntityLib.HipHeight + (EntityLib.Root.Size.Y / 2), 1), (Target - Origin), Params)
						if Blockcast then
							NewPos = Blockcast.Position + (Blockcast.Normal * 1.5)
							Factor = Magnitude > 3 and 0 or (8 - math.min(Magnitude, 3))
						end
					end
		
					local Raycast = workspace:Raycast(NewPos, AirCheckVector, Params)
					
					if not Fly.Enabled and not Raycast then
						NewPos = CharPos
						Factor = 40
					end
		
					Angle += Factor % 360
					MoveDirection = (NewPos - LocalPos) * vector.hort
					MoveDirection = MoveDirection ~= vector.zero and vector.normalize(MoveDirection) or vector.zero
					LastEntity = Entity
				else
					Entity = nil
				end
			end
		
			TargetStrafeVector = Entity and MoveDirection or nil
			LastEntity = Entity
		
			return Old(self, MoveDirection, Face)
		end
		
		TargetStrafe = Movement:CreateModule({
			Name = 'TargetStrafe',
			Info = 'Automatically strafes around enemies',
			Enabled = function()
				Fly = Modules.Fly or {Enabled = false}
		
				if require then
					if not Module then
						local PlayerScripts = Plr:FindFirstChildOfClass('PlayerScripts')
						local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild('PlayerModule')
						if not PlayerModule then
							Notify({
								Text = 'Failed to find player module',
								Duration = 5,
								Type = 'Error'
							})
		
							return
						end
						
						Module = require(PlayerModule).controls
					end
		
					Old = Module.moveFunction
					Module.moveFunction = MoveFunction
		
					TargetStrafe:Clean(function()
						if Module and Old then
							Module.moveFunction = Old
						end
						Old = nil
						LastEntity = nil
						TargetStrafeVector = nil
						Fly = nil
					end)
				else
					Old = Plr.Move
		
					TargetStrafe:Clean(RunService.PreRender:Connect(function()
						if EntityLib.Alive then
							MoveFunction(Plr, EntityLib.Humanoid.MoveDirection, false)
						end
					end))
		
					TargetStrafe:Clean(function()
						Old = nil
						LastEntity = nil
						TargetStrafeVector = nil
						Fly = nil
					end)
				end
			end,
		})
		
		UsePlayers = TargetStrafe:CreateToggle({
			Name = 'Use Players',
			Default = true
		})
		
		UseNPCs = TargetStrafe:CreateToggle({
			Name = 'Use NPCs',
		})
		
		WallCheck = TargetStrafe:CreateToggle({
			Name = 'Wall Check',
			Info = 'Ignores enemies through walls',
			Default = true
		})
		
		SearchRange = TargetStrafe:CreateSlider({
			Name = 'Search Range',
			Min = 1,
			Max = 30,
			Default = 15,
		})
		
		StrafeRange = TargetStrafe:CreateSlider({
			Name = 'Strafe Range',
			Min = 1,
			Max = 20,
			Default = 10,
		})
		
		YFactor = TargetStrafe:CreateSlider({
			Name = 'Y Factor',
			Min = 0,
			Max = 100,
			Default = 100,
			Suffix = '%'
		})
	end)
	
	Run(function() -- Timer
		local Timer, Speed
	
		Timer = Movement:CreateModule({
			Name = 'Timer',
			Info = 'Changes the speed of your character',
			Enabled = function()
				Timer:Clean(RunService.PreRender:Connect(function(Delta)
					if EntityLib.Alive and Speed.Value > 1 then
						RunService:Pause()
						workspace:StepPhysics(Delta * (Speed.Value - 1), {EntityLib.Root})
						RunService:Run()
					end
				end))
			end
		})
		
		Speed = Timer:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 1,
			Max = 5,
			Decimal = 10,
		})
	end)
end)

Run(function() -- Visuals
	Run(function() -- AntiLag
		local AntiLag
		
		const Objects = {}
		
		const function EnabledFunction(Obj, Property)
			Property = Property or 'Enabled'
			const OldValues = {[Property] = Obj[Property]}
			Obj[Property] = false

			AntiLag:Clean(Obj:GetPropertyChangedSignal(Property):Connect(function()
				OldValues[Property] = Obj[Property]
				Obj[Property] = false
			end))

			Objects[Obj] = OldValues
		end

		const function VisibleFunction(Obj)
			EnabledFunction(Obj, 'Visible')
		end
		
		const function PartFunction(Part)
			const OldValues = {Material = Part.Material, Reflectance = Part.Reflectance, CastShadow = Part.CastShadow}

			for Property, Value in {Material = Enum.Material.Plastic, Reflectance = 0, CastShadow = false} do
				Part[Property] = Value
				Part:GetPropertyChangedSignal(Property):Connect(function()
					OldValues[Property] = Part[Property]
					Part[Property] = Value
				end)
			end

			Objects[Part] = OldValues
		end

		const function TransparencyFunction(Obj)
			const OldValues = {Transparency = Obj.Transparency}
			Obj.Transparency = 1
			
			AntiLag:Clean(Obj:GetPropertyChangedSignal('Transparency'):Connect(function()
				OldValues.Transparency = Obj.Transparency
				Obj.Transparency = 1
			end))
			
			Objects[Obj] = OldValues
		end

		const Functions = {
			Decal = TransparencyFunction,
			Texture = TransparencyFunction,
			ParticleEmitter = EnabledFunction,
			Trail = EnabledFunction,
			Sparkles = EnabledFunction,
			Smoke = EnabledFunction,
			Fire = EnabledFunction,
			ForceField = VisibleFunction,
			Explosion = VisibleFunction,
		}

		const function DescendantAdded(Obj, AlreadyAdded)
			const Function = Obj:IsA('BasePart') and PartFunction or Functions[Obj.ClassName]
			if Function then
				Function(Obj)
			end
		end

		const function DescendantRemoved(Obj)
			if Objects[Obj] then
				Objects[Obj] = nil
			end
		end
		
		AntiLag = Visuals:CreateModule({
			Name = 'AntiLag',
			Info = 'Removes textures and effects to improve performance.',
			Function = function(Enabled)
				if Enabled then
					AntiLag:Clean(workspace.DescendantAdded:Connect(DescendantAdded))
					AntiLag:Clean(workspace.DescendantRemoving:Connect(DescendantRemoved))

					const Children = workspace:QueryDescendants('BasePart, Decal, Texture, ParticleEmitter, Trail, Explosion, Sparkles, Smoke, Fire, ForceField')
					table.remove(Children, table.find(Children, workspace.Terrain))
					
					for _, Obj in Children do
						DescendantAdded(Obj, true)
					end
				else
					for Obj, Properties in Objects do
						for Property, OldValue in Properties do
							Obj[Property] = OldValue
						end
					end
					table.clear(Objects)
				end
			end
		})
	end)

	Run(function() -- BoxESP
		local BoxESP, Mode, Priority, UseTeamColor, Thickness, SizeX, SizeY
		local UsePlayers, OutlineColor, FillColor
		local UseNPCs, NPC_FillColor, NPC_OutlineColor
		local UseLimits, MinDistance, MaxDistance
		
		local Folder
		local ScreenGui
		local Boxes = {}
		local Entities = 0
		
		local function EntityRemoved(Entity)
			local Box = Boxes[Entity.Character]
			if Box then
				Entities -= 1
				BoxESP:UpdateTextGUI()
				local Obj = Box.Frame or Box.Canvas
				Obj:Destroy()
				Boxes[Entity.Character] = nil
			end
		end

		const function CreateControlPointsTable(Amount)
			const Tab = {}
			for i = 1, Amount do
				Tab[i] = Path2DControlPoint.new()
			end
			return Tab
		end

		const function CreateLine(Name, Parent)
			const Line = Instance.new('Path2D')
			Line.Name = Name
			Line.Color3 = Color3.White
			Line.Thickness = Thickness.Value
			Line.Parent = Parent
			return Line
		end

		const function Vector2ToUDim2(Vec)
			return UDim2.fromOffset(Vec.X, Vec.Y)
		end
		
		const function EntityAdded(Entity)
			if Entity.Player and not UsePlayers.Enabled then return end
			if Entity.NPC and not UseNPCs.Enabled then return end
			if Priority.Value ~= 'All' then
				if (Priority.Value == 'Enemies' and Entity.Teammate) or (Priority.Value == 'Teammates' and not Entity.Teammate) or (Priority.Value == 'Friends' and not IsFriend(Entity.Player)) then
					return
				end
			end
			
			Entities += 1
			BoxESP:UpdateTextGUI()

			const Player = Entity.Player
			const Name = Player and Player.Name or Entity.Character.Name
			const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
			const OutlineTransparency = Player and OutlineColor.Transparency or NPC_OutlineColor.Transparency
			const FillTransparency = Player and FillColor.Transparency or NPC_FillColor.Transparency
			const OutlineColor = EntityColor or (Player and OutlineColor.Color or NPC_OutlineColor.Color)
			const FillColor = EntityColor or (Player and FillColor.Color or NPC_FillColor.Color)

			if Mode.Value == '2D' then
				const Box = Instance.new('Frame')
				Box.Name = `{Name}_BoxESP`
				Box.BackgroundColor3 = FillColor
				Box.BackgroundTransparency = FillTransparency
				Box.Active = false
				Box.Interactable = false
				Box.AnchorPoint = Vector2.new(0.5, 0.5)
				Box.ZIndex = 0
				Box.BorderSizePixel = 0
				Box.Visible = false
				Box.Parent = Folder
				
				const Outline = Instance.new('UIStroke')
				Outline.Thickness = Thickness.Value
				Outline.Color = OutlineColor
				Outline.Transparency = OutlineTransparency
				Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				Outline.LineJoinMode = Enum.LineJoinMode.Miter
				Outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
				Outline.Parent = Box
			
				Boxes[Entity.Character] = {
					Frame = Box,
					Entity = Entity
				}
			elseif Mode.Value == '3D' then
				const Canvas = Instance.new('CanvasGroup')
				Canvas.Name = `{Name}_BoxESP`
				Canvas.Size = UDim2.fromScale(1, 1)
				Canvas.BackgroundTransparency = 1
				Canvas.Active = false
				Canvas.Interactable = false
				Canvas.GroupTransparency = OutlineTransparency
				Canvas.GroupColor3 = OutlineColor
				Canvas.Visible = false
				Canvas.Parent = ScreenGui

				const MainLine = CreateLine('Main', Canvas)
				const ExtraLine1 = CreateLine('Extra1', Canvas)
				const ExtraLine2 = CreateLine('Extra2', Canvas)
				const ExtraLine3 = CreateLine('Extra3', Canvas)

				Boxes[Entity.Character] = {
					Canvas = Canvas,
					MainLine = MainLine,
					ExtraLine1 = ExtraLine1,
					ExtraLine2 = ExtraLine2,
					ExtraLine3 = ExtraLine3,
					Entity = Entity,
					MainControlPoints = CreateControlPointsTable(10),
					ExtraControlPoints1 = CreateControlPointsTable(2),
					ExtraControlPoints2 = CreateControlPointsTable(2),
					ExtraControlPoints3 = CreateControlPointsTable(2),
				}
			end
		end
		
		const function RenderBoxes()
			const CameraPosition: vector = Camera.CFrame.Position
			const CameraLookDirection: vector = Camera.CFrame.LookVector

			for _, Tab in Boxes do
				const Box = Tab.Frame
				const Entity = Tab.Entity

				if EntityLib.Alive and UseLimits.Enabled then
					local Magnitude = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position)
					if Magnitude > MaxDistance.Value or Magnitude < MinDistance.Value then
						Box.Visible = false
						continue
					end
				end

				if vector.dot(vector.normalize(Entity.Root.Position - CameraPosition), CameraLookDirection) < 0 then
					Box.Visible = false
					continue
				end
				
				const ScreenPoint, Visible = Camera:WorldToViewportPoint(Entity.Root.Position)
		
				if Visible then
					Box.Size = UDim2.fromOffset(((134400 * SizeX.Value) / Camera.FieldOfView) / ScreenPoint.Z, ((134400 * SizeY.Value) / Camera.FieldOfView) / ScreenPoint.Z)
					Box.Position = UDim2.fromOffset(ScreenPoint.X, ScreenPoint.Y)
					Box.Visible = true
				else
					Box.Visible = false
				end
			end
		end

		const function Render3D_Boxes()
			const CameraPosition: vector = Camera.CFrame.Position
			const CameraLookDirection: vector = Camera.CFrame.LookVector

			for _, Tab in Boxes do
				const Entity = Tab.Entity

				if EntityLib.Alive and UseLimits.Enabled then
					local Magnitude = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position)
					if Magnitude > MaxDistance.Value or Magnitude < MinDistance.Value then
						Tab.Canvas.Visible = false
						continue
					end
				end

				if vector.dot(vector.normalize(Entity.Root.Position - CameraPosition), CameraLookDirection) < 0 then
					Tab.Canvas.Visible = false
					continue
				end

				const MainLine = Tab.MainLine
				const ExtraLine1 = Tab.ExtraLine1
				const ExtraLine2 = Tab.ExtraLine2
				const ExtraLine3 = Tab.ExtraLine3

				const MiddleCFrame = CFrame.Angles(Entity.Root.CFrame:ToOrientation()) + Entity.Root.AssemblyCenterOfMass

				if select(2, Camera:WorldToViewportPoint(Entity.Root.Position)) then
					const MainControlPoints = Tab.MainControlPoints
					const ExtraControlPoints1 = Tab.ExtraControlPoints1
					const ExtraControlPoints2 = Tab.ExtraControlPoints2
					const ExtraControlPoints3 = Tab.ExtraControlPoints3

					const Size = Entity.Character:GetExtentsSize() / 2
					const X = Size.X
					const Y = Size.Y
					const Z = Size.X

					const FrontTopLeftPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(-X, Y, -Z)).Position)
					const FrontTopRightPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(X, Y, -Z)).Position)
					const FrontBottomRightPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(X, -Y, -Z)).Position)
					const FrontBottomLeftPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(-X, -Y, -Z)).Position)

					const BackBottomLeftPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(-X, -Y, Z)).Position)
					const BackBottomRightPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(X, -Y, Z)).Position)
					const BackTopRightPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(X, Y, Z)).Position)
					const BackTopLeftPoint = Camera:WorldToViewportPoint(MiddleCFrame:ToWorldSpace(CFrame.new(-X, Y, Z)).Position)

					MainControlPoints[1].Position = Vector2ToUDim2(FrontBottomLeftPoint)
					MainControlPoints[2].Position = Vector2ToUDim2(FrontBottomRightPoint)
					MainControlPoints[3].Position = Vector2ToUDim2(BackBottomRightPoint)
					MainControlPoints[4].Position = Vector2ToUDim2(BackBottomLeftPoint)
					MainControlPoints[5].Position = Vector2ToUDim2(FrontBottomLeftPoint)
					MainControlPoints[6].Position = Vector2ToUDim2(FrontTopLeftPoint)
					MainControlPoints[7].Position = Vector2ToUDim2(FrontTopRightPoint)
					MainControlPoints[8].Position = Vector2ToUDim2(BackTopRightPoint)
					MainControlPoints[9].Position = Vector2ToUDim2(BackTopLeftPoint)
					MainControlPoints[10].Position = Vector2ToUDim2(FrontTopLeftPoint)

					ExtraControlPoints1[1].Position = Vector2ToUDim2(FrontBottomRightPoint)
					ExtraControlPoints1[2].Position = Vector2ToUDim2(FrontTopRightPoint)

					ExtraControlPoints2[1].Position = Vector2ToUDim2(BackBottomRightPoint)
					ExtraControlPoints2[2].Position = Vector2ToUDim2(BackTopRightPoint)

					ExtraControlPoints3[1].Position = Vector2ToUDim2(BackBottomLeftPoint)
					ExtraControlPoints3[2].Position = Vector2ToUDim2(BackTopLeftPoint)

					MainLine:SetControlPoints(MainControlPoints)
					ExtraLine1:SetControlPoints(ExtraControlPoints1)
					ExtraLine2:SetControlPoints(ExtraControlPoints2)
					ExtraLine3:SetControlPoints(ExtraControlPoints3)

					Tab.Canvas.Visible = true
				else
					Tab.Canvas.Visible = false
				end
			end
		end
		
		const function UpdateBoxes()
			for _, Tab in Boxes do
				const Entity = Tab.Entity
				const Player = Entity.Player
				const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil

				if Mode.Value == '2D' then
					const Frame = Tab.Frame
					const Outline = Frame.UIStroke
			
					Frame.BackgroundColor3 = EntityColor or (Player and FillColor.Color or NPC_FillColor.Color)
					Frame.BackgroundTransparency = Player and FillColor.Transparency or NPC_FillColor.Transparency
					Outline.Transparency = Player and OutlineColor.Transparency or NPC_OutlineColor.Transparency
					Outline.Color = EntityColor or (Player and OutlineColor.Color or NPC_OutlineColor.Color)
					Outline.Thickness = Thickness.Value
				else
					Tab.Canvas.GroupColor3 = EntityColor or (Player and OutlineColor.Color or NPC_OutlineColor.Color)
					Tab.Canvas.GroupTransparency = Player and OutlineColor.Transparency or NPC_OutlineColor.Transparency
					Tab.MainLine.Thickness = Thickness.Value
					Tab.ExtraLine1.Thickness = Thickness.Value
					Tab.ExtraLine2.Thickness = Thickness.Value
					Tab.ExtraLine3.Thickness = Thickness.Value
				end
			end
		end
		
		BoxESP = Visuals:CreateModule({
			Name = 'BoxESP',
			Tooltip = 'Renders Boxes over Players/NPCs',
			Function = function(Enabled)
				if Enabled then
					if Mode.Value == '2D' then
						Folder = Instance.new('Folder')
						Folder.Name = 'BoxESP'
						Folder.Parent = TidalWave.Gui
					else
						ScreenGui = Instance.new('ScreenGui')
						ScreenGui.Name = 'BoxESP'
						ScreenGui.IgnoreGuiInset = true
						ScreenGui.DisplayOrder = -1
						ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						ScreenGui.Parent = TidalWave.Gui
					end
					
					BoxESP:Clean(RunService.PreRender:Connect(Mode.Value == '2D' and RenderBoxes or Render3D_Boxes))
					BoxESP:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					BoxESP:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
					for _, Entity in EntityLib.List do
						EntityAdded(Entity)
					end
				else
					if Folder then
						Folder:Destroy()
						Folder = nil
					end
					if ScreenGui then
						ScreenGui:Destroy()
						ScreenGui = nil
					end
		
					Entities = 0
					table.clear(Boxes)
				end
			end,
			ExtraText = function()
				return tostring(Entities)
			end
		})

		Mode = BoxESP:CreateDropdown({
			Name = 'Mode',
			List = {'2D', '3D'},
			Restart = true
		})
		
		Priority = BoxESP:CreateDropdown({
			Name = 'Priority',
			List = {'All', 'Enemies', 'Teammates', 'Friends'},
			Restart = true
		})

		UseTeamColor = BoxESP:CreateToggle({
			Name = 'Use Team Color',
			Tooltip = 'Uses team based coloring for boxes.',
			Default = true,
			Function = UpdateBoxes
		})
		
		UsePlayers = BoxESP:CreateToggle({
			Name = 'Players',
			Tooltip = 'Whether or not to show players',
			Default = true,
			Restart = true
		})
		
		OutlineColor = UsePlayers:CreateColorPicker({
			Name = 'Outline Color',
			Function = UpdateBoxes
		})
		
		FillColor = UsePlayers:CreateColorPicker({
			Name = 'Fill Color',
			Transparency = 1,
			Function = UpdateBoxes
		})
		
		UseNPCs = BoxESP:CreateToggle({
			Name = 'NPCs',
			Tooltip = 'Whether or not to show NPCs',
			Restart = true
		})
		
		NPC_OutlineColor = UseNPCs:CreateColorPicker({
			Name = 'NPC Outline Color',
			Function = UpdateBoxes
		})
		
		NPC_FillColor = UseNPCs:CreateColorPicker({
			Name = 'NPC Fill Color',
			Transparency = 1,
			Function = UpdateBoxes
		})
		
		Thickness = BoxESP:CreateSlider({
			Name = 'Outline Thickness',
			Default = 1,
			Min = 1,
			Max = 5,
			Function = UpdateBoxes
		})
		
		SizeX = BoxESP:CreateSlider({
			Name = 'X Size',
			Default = 1.5,
			Min = 0,
			Max = 3,
			Decimal = 100,
		})
		
		SizeY = BoxESP:CreateSlider({
			Name = 'Y Size',
			Default = 2.5,
			Min = 0,
			Max = 3,
			Decimal = 100,
		})

		UseLimits = BoxESP:CreateToggle({
			Name = 'Use Limits',
			Tooltip = 'Sets a minimum and maximum distance to render boxes inside.',
		})
		
		MinDistance = UseLimits:CreateSlider({
			Name = 'Min Distance',
			Default = 0,
			Min = 0,
			Max = 50
		})
		
		MaxDistance = UseLimits:CreateSlider({
			Name = 'Max Distance',
			Default = 1000,
			Min = 100,
			Max = 1000
		})
	end)

	Run(function() -- Breadcrumbs
		local Breadcrumbs, Texture, Lifetime, Thickness, FadeIn, FadeOut

		local Trail, Point, Point2

		const function LocalAdded()
			Point.Parent = EntityLib.Root
			Point2.Parent = EntityLib.Root
			Trail.Parent = Camera
		end
		
		Breadcrumbs = Visuals:CreateModule({
			Name = 'Breadcrumbs',
			Tooltip = 'Shows a trail behind your character.',
			Function = function(Enabled)
				if Enabled then
					Point = Instance.new('Attachment')
					Point.Position = vector.create(0, Thickness.Value - 2.7, 0)

					Point2 = Instance.new('Attachment')
					Point2.Position = vector.create(0, -Thickness.Value - 2.7, 0)

					Trail = Instance.new('Trail')
					Trail.Texture = Texture.Value
					Trail.TextureMode = Enum.TextureMode.Static
					Trail.Color = ColorSequence.new(FadeIn.Color, FadeOut.Color)
					Trail.Lifetime = Lifetime.Value
					Trail.Attachment0 = Point
					Trail.Attachment1 = Point2
					Trail.FaceCamera = true

					Breadcrumbs:Clean(Trail.Destroying:Once(function()
						task.delay(0, Breadcrumbs.Restart, Breadcrumbs)
					end))

					Breadcrumbs:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
		
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					Trail:Destroy()
					Trail = nil

					Point:Destroy()
					Point = nil

					Point2:Destroy()
					Point2 = nil
				end
			end,
		})

		Texture = Breadcrumbs:CreateAssetTextBox({
			Name = 'Texture',
			Default = 'rbxassetid://14166981368',
			Placeholder = '[rbxassetid://12345]',
			Function = function(Asset)
				Trail.Texture = Asset
			end
		})

		FadeIn = Breadcrumbs:CreateColorPicker({
			Name = 'Fade In',
			Function = function(Color)
				if Trail then
					Trail.Color = ColorSequence.new(Color, FadeOut.Color)
				end
			end
		})

		FadeOut = Breadcrumbs:CreateColorPicker({
			Name = 'Fade Out',
			Function = function(Color)
				if Trail then
					Trail.Color = ColorSequence.new(FadeIn.Color, Color)
				end
			end
		})
		
		Lifetime = Breadcrumbs:CreateSlider({
			Name = 'Lifetime',
			Default = 3,
			Min = 1,
			Max = 5,
			Decimal = 10,
			Function = function(Val)
				if Trail then
					Trail.Lifetime = Val
				end
			end,
		})

		Thickness = Breadcrumbs:CreateSlider({
			Name = 'Thickness',
			Default = 0.1,
			Min = 0,
			Max = 2,
			Decimal = 100,
			Function = function(Val)
				if Point then
					Point.Position = vector.create(0, Val - 2.7, 0)
				end

				if Point2 then
					Point2.Position = vector.create(0, -Val - 2.7, 0)
				end
			end,
		})
	end)

	Run(function() -- CameraMode
		local CameraMode, Mode
		local db, OldCameraMode
		
		local function GetCameraMode()
			return Mode.Value == 'First Person' and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
		end
		
		CameraMode = Visuals:CreateModule({
			Name = 'CameraMode',
			Info = 'Sets your camera to third/first person',
			Function = function(Enabled)
				if Enabled then
					OldCameraMode = Plr.CameraMode
					Plr.CameraMode = GetCameraMode()
					CameraMode:Clean(Plr:GetPropertyChangedSignal('CameraMode'):Connect(function()
						if db then return end
						db = true
						OldCameraMode = Plr.CameraMode
						Plr.CameraMode = GetCameraMode()
						db = false
					end))
				else
					if OldCameraMode then
						Plr.CameraMode = OldCameraMode
						OldCameraMode = nil
					end
		
					db = nil
				end
			end
		})
		
		Mode = CameraMode:CreateDropdown({
			Name = 'Camera Mode',
			List = {'Third Person', 'First Person'},
			Function = function(Val)
				if CameraMode.Enabled then
					db = true
					Plr.CameraMode = GetCameraMode()
					db = false
				end
			end
		})
	end)

	Run(function() -- CameraZoom
		local CameraZoom, MinZoom, MaxZoom
		
		local db, db2, OldMinZoom, OldMaxZoom
		
		CameraZoom = Visuals:CreateModule({
			Name = 'CameraZoom',
			Info = 'Sets your camera min/max zoom to the specified values.',
			Function = function(Enabled)
				if Enabled then
					OldMinZoom = Plr.CameraMinZoomDistance
					OldMaxZoom = Plr.CameraMaxZoomDistance
					Plr.CameraMaxZoomDistance = MaxZoom.Value
					Plr.CameraMinZoomDistance = MinZoom.Value
		
					CameraZoom:Clean(Plr:GetPropertyChangedSignal('CameraMinZoomDistance'):Connect(function()
						if db then return end
						db = true
						OldMinZoom = Plr.CameraMinZoomDistance
						Plr.CameraMinZoomDistance = MinZoom.Value
						db = false
					end))
		
					CameraZoom:Clean(Plr:GetPropertyChangedSignal('CameraMaxZoomDistance'):Connect(function()
						if db2 then return end
						db2 = true
						OldMaxZoom = Plr.CameraMaxZoomDistance
						Plr.CameraMaxZoomDistance = MaxZoom.Value
						db2 = false
					end))
				else
					Plr.CameraMinZoomDistance = OldMinZoom
					Plr.CameraMaxZoomDistance = OldMaxZoom
					OldMinZoom, OldMaxZoom = nil, nil
					db, db2 = nil, nil
				end
			end,
		})
		
		MinZoom = CameraZoom:CreateSlider({
			Name = 'Min Zoom',
			Default = math.round(Plr.CameraMinZoomDistance * 10) / 10,
			Min = 0.5,
			Max = 100,
			Decimal = 10,
			Function = function(Val)
				if CameraZoom.Enabled then
					db = true
					Plr.CameraMinZoomDistance = Val
					db = false
				end
			end
		})
		
		MaxZoom = CameraZoom:CreateSlider({
			Name = 'Max Zoom',
			Default = math.round(Plr.CameraMaxZoomDistance),
			Min = 1,
			Max = 1000,
			Function = function(Val)
				if CameraZoom.Enabled then
					db2 = true
					Plr.CameraMaxZoomDistance = Val
					db2 = false
				end
			end
		})
	end)

	Run(function() -- Cape
		local Cape, Texture, Part, Motor
		
		const function CreateMotor()
			if Motor then
				Motor:Destroy()
				Motor = nil
			end
		
			local Part1 = EntityLib.Torso or EntityLib.Root
		
			Part.Parent = Camera
			Motor = Instance.new('Motor6D')
			Motor.MaxVelocity = 0.08
			Motor.Part0 = Part
			Motor.Part1 = Part1
			Motor.C0 = CFrame.new(0, 2, 0) * CFrame.Angles(0, math.rad(-90), 0)
			Motor.C1 = CFrame.new(0, Part1.Size.Y / 2, 0.45) * CFrame.Angles(0, math.rad(90), 0)
			Motor.Parent = Part
		end

		const function LocalRemoved()
			Part.Parent = nil
		end

		const BASE_ANGLE_DEG       = 8    -- resting flare when standing still
		const SPEED_ANGLE_MULTI    = 0.9  -- how much horizontal speed pushes the cape back (deg per stud/s)
		const MAX_SPEED            = 90   -- cap used for the speed contribution
		const FALL_LIFT_MULTI      = 1    -- how much falling makes the cape billow upward
		const FALL_LIFT_CLAMP_UP   = 90   -- max degrees of lift from vertical velocity
		const FALL_LIFT_CLAMP_DOWN = 8    -- max degress of drop from vertical velocity
		const FLUTTER_SPEED_A      = 9    -- flutter speed a
		const FLUTTER_SPEED_B      = 13.7 -- flutter speed b
		const FLUTTER_STRENGTH     = 32   -- degrees, scaled down at low speed
		const SPRING_STIFFNESS     = 50   -- higher = snappier
		const SPRING_DAMPING       = 1    -- higher = less overshoot/wobble

		Cape = Visuals:CreateModule({
			Name = 'Cape',
			Info = 'Adds a cool cape to your character',
			Function = function(Enabled)
				if Enabled then
					Part = Instance.new('Part')
					Part.Size = vector.create(2, 4, 0.1)
					Part.CanCollide = false
					Part.CanQuery = false
					Part.CastShadow = false
					Part.AudioCanCollide = false
					Part.Massless = true
					Part.Material = Enum.Material.SmoothPlastic
					Part.Color = Color3.Black
					Part.Parent = Camera

					Cape:Clean(Part.Destroying:Once(function() -- me when violence district calls Destroy() for all Instances inside the Camera
						task.delay(0, Cape.Restart, Cape)
					end))
		
					if EntityLib.Alive then
						CreateMotor()
					end
					
					local SurfaceGui = Instance.new('SurfaceGui')
					SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
					SurfaceGui.Adornee = Part
					SurfaceGui.Parent = Part
		
					if Texture.Value:find('.webm') then
						local VideoFrame = Instance.new('VideoFrame')
						VideoFrame.Video = Texture.Value
						VideoFrame.Size = UDim2.fromScale(1, 1)
						VideoFrame.BackgroundTransparency = 1
						VideoFrame.Looped = true
						VideoFrame.Parent = SurfaceGui
						VideoFrame:Play()
					else
						local Image = Instance.new('ImageLabel')
						Image.Image = Texture.Value
						Image.Size = UDim2.fromScale(1, 1)
						Image.BackgroundTransparency = 1
						Image.Parent = SurfaceGui
					end

					local CurrentAngle = 0
					local AngleVelocity = 0
		
					Cape:Clean(EntityLib.Events.LocalAdded:Connect(CreateMotor))
					Cape:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Cape:Clean(RunService.PreRender:Connect(function(Delta) -- not vibe coded (trust)
						if EntityLib.Alive and Motor then
							const Vel = EntityLib.Root.AssemblyLinearVelocity
							const FlatVel = vector.create(Vel.X, 0, Vel.Z)
							const HorizontalVel = math.min(vector.magnitude(FlatVel), MAX_SPEED)
							const VerticalVel = Vel.Y

							local TargetAngle = math.rad(BASE_ANGLE_DEG + HorizontalVel * SPEED_ANGLE_MULTI) - math.rad(math.clamp(VerticalVel * FALL_LIFT_MULTI, -FALL_LIFT_CLAMP_UP, FALL_LIFT_CLAMP_DOWN))

							if HorizontalVel > 1 then
								const Now = os.clock()
								const Flutter = math.sin(Now * FLUTTER_SPEED_A) * 0.5 + math.sin(Now * FLUTTER_SPEED_B + 1.3) * 0.3
								const SpeedScale = math.clamp(HorizontalVel / 20, 0, 1)
								TargetAngle += math.rad(Flutter * SpeedScale * FLUTTER_STRENGTH)
							end

							const Diff = TargetAngle - CurrentAngle
							AngleVelocity += Diff * SPRING_STIFFNESS * Delta
							AngleVelocity *= math.exp(-SPRING_DAMPING * 10 * Delta)
							CurrentAngle += AngleVelocity * Delta

							Motor.DesiredAngle = CurrentAngle
						end

						const ThirdPerson = IsThirdPerson()
						SurfaceGui.Enabled = ThirdPerson
						Part.Transparency = ThirdPerson and 0 or 1
					end))
				else
					Part:Destroy()
					Part = nil
					
					if Motor then
						Motor:Destroy()
						Motor = nil
					end
				end
			end,
		})
		
		Texture = Cape:CreateAssetTextBox({
			Name = 'Texture',
			Default = 'rbxassetid://14637958134',
			Placeholder = '[rbxassetid://12345 | coolimage.png]',
			Function = function()
				Cape:Restart()
			end
		})
	end)

	Run(function() -- Chams
		local Chams, Priority, UseTeamColor, UseLimits, MinDistance, MaxDistance
		local ShowPlayers, OutlineColor, FillColor
		local ShowNPCs, NPC_OutlineColor, NPC_FillColor
		
		local Folder
		local Highlights = {}
		local Entities = 0
		
		const function EntityRemoved(Entity)
			const Tab = Highlights[Entity.Character]
			if Tab then
				Entities -= 1
				Chams:UpdateTextGUI()
				Tab.Highlight:Destroy()
				Highlights[Entity.Character] = nil
			end
		end
		
		const function EntityAdded(Entity)
			EntityRemoved(Entity)
		
			if not ShowPlayers.Enabled and Entity.Player then return end
			if not ShowNPCs.Enabled and Entity.NPC then return end
			if Priority.Value ~= 'All' then
				if (Priority.Value == 'Enemies' and Entity.Teammate) or (Priority.Value == 'Teammates' and not Entity.Teammate) or (Priority.Value == 'Friends' and not IsFriend(Entity.Player)) then
					return
				end
			end
		
			Entities += 1
			Chams:UpdateTextGUI()
		
			const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
			const Player = Entity.Player
			const Name = Player and Player.Name or Entity.Character.Name
		
			const Highlight = Instance.new('Highlight')
			Highlight.Name = Name .. '_Chams'
			Highlight.OutlineColor = EntityColor or (Player and OutlineColor.Color or NPC_OutlineColor.Color)
			Highlight.FillColor = EntityColor or (Player and FillColor.Color or NPC_FillColor.Color)
			Highlight.OutlineTransparency = (Player and OutlineColor.Transparency or NPC_OutlineColor.Transparency)
			Highlight.FillTransparency = (Player and FillColor.Transparency or NPC_FillColor.Transparency)
			Highlight.Adornee = Entity.Character

			if UseLimits.Enabled and EntityLib.Alive then
				const Distance = vector.magnitude(Entity.Root.Position - EntityLib.Root.Position)
				Highlight.Enabled = Distance >= MinDistance.Value and Distance <= MaxDistance.Value 
			end

			Highlight.Parent = Folder
		
			Highlights[Entity.Character] = {
				Highlight = Highlight,
				Entity = Entity
			}
		end
		
		const function UpdateHighlights()
			for _, Tab in Highlights do
				const Entity = Tab.Entity
				const Highlight = Tab.Highlight
				const Player = Entity.Player
				const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
		
				Highlight.OutlineColor = EntityColor or (Player and OutlineColor.Color or NPC_OutlineColor.Color)
				Highlight.FillColor = EntityColor or (Player and FillColor.Color or NPC_FillColor.Color)
				Highlight.OutlineTransparency = (Player and OutlineColor.Transparency or NPC_OutlineColor.Transparency)
				Highlight.FillTransparency = (Player and FillColor.Transparency or NPC_FillColor.Transparency)
			end
		end
		
		Chams = Visuals:CreateModule({
			Name = 'Chams',
			Info = 'Renders Players/NPCs through walls',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'Chams'
					Folder.Parent = TidalWave.Gui
					
					Chams:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					Chams:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
					for _, Entity in EntityLib.List do
						EntityAdded(Entity)
					end

					if UseLimits.Enabled then
						while task.wait(0.05) do
							if not EntityLib.Alive then continue end
	
							const LocalPosition = EntityLib.Root.Position
	
							for _, Tab in Highlights do
								const Entity = Tab.Entity
								const Highlight  = Tab.Highlight
								const Distance = vector.magnitude(Entity.Position - LocalPosition)
	
								if Distance >= MinDistance.Value and Distance <= MaxDistance.Value then
									Highlight.Enabled = true
								else
									Highlight.Enabled = false
								end
							end
						end
					end
				else
					Folder:Destroy()
					Folder = nil
					Entities = 0
					table.clear(Highlights)
				end
			end,
			ExtraText = function()
				return tostring(Entities)
			end
		})
		
		Priority = Chams:CreateDropdown({
			Name = 'Priority',
			List = {'All', 'Enemies', 'Teammates', 'Friends'},
			Restart = true
		})

		UseTeamColor = Chams:CreateToggle({
			Name = 'Use Team Color',
			Tooltip = 'Uses team based coloring for chams.',
			Default = true,
			Function = UpdateHighlights
		})
		
		ShowPlayers = Chams:CreateToggle({
			Name = 'Players',
			Info = 'Whether or not to show players',
			Default = true,
			Restart = true
		})
		
		OutlineColor = ShowPlayers:CreateColorPicker({
			Name = 'Outline Color',
			Function = UpdateHighlights
		})
		
		FillColor = ShowPlayers:CreateColorPicker({
			Name = 'Fill Color',
			Transparency = 1,
			Function = UpdateHighlights
		})
		
		ShowNPCs = Chams:CreateToggle({
			Name = 'NPCs',
			Info = 'Whether or not to show NPCs',
			Restart = true
		})
		
		NPC_OutlineColor = ShowNPCs:CreateColorPicker({
			Name = 'NPC Outline Color',
			Function = UpdateHighlights
		})
		
		NPC_FillColor = ShowNPCs:CreateColorPicker({
			Name = 'NPC Fill Color',
			Transparency = 1,
			Function = UpdateHighlights
		})

		UseLimits = Chams:CreateToggle({
			Name = 'Use Limits',
			Info = 'Sets a minimum and maximum distance to render chams inside',
			Restart = true
		})

		MinDistance = UseLimits:CreateSlider({
			Name = 'Min Distance',
			Default = 0,
			Min = 0,
			Max = 50
		})

		MaxDistance = UseLimits:CreateSlider({
			Name = 'Max Distance',
			Default = 1000,
			Min = 100,
			Max = 1000
		})
	end)

	Run(function() -- FovChanger
		local FovChanger, Fov
		
		local OldFov, db
		
		FovChanger = Visuals:CreateModule({
			Name = 'FovChanger',
			Info = 'Sets your field of view to the specified value',
			Function = function(Enabled)
				if Enabled then
					OldFov = Camera.FieldOfView
					Camera.FieldOfView = Fov.Value
		
					FovChanger:Clean(Camera:GetPropertyChangedSignal('FieldOfView'):Connect(function()
						if db then return end
						db = true
						OldFov = Camera.FieldOfView
						Camera.FieldOfView = Fov.Value
						db = false
					end))
				else
					if OldFov then
						Camera.FieldOfView = OldFov
						OldFov = nil
					end
		
					db = false
				end
			end,
			ExtraText = function()
				return tostring(Fov.Value)
			end
		})
		
		function FovChanger:Enable()
			db = false
		end
		
		function FovChanger:Disable()
			db = true
		end
		
		Fov = FovChanger:CreateSlider({
			Name = 'Field Of View',
			Default = math.floor(Camera.FieldOfView),
			Min = 1,
			Max = 120,
			Function = function(Val)
				if FovChanger.Enabled then
					db = true
					Camera.FieldOfView = Val
					db = false
					FovChanger:UpdateTextGUI()
				end
			end
		})
	end)

	Run(function() -- Fullbright
		local Fullbright

		local Bloom, db
		
		const AtmosphereProperties = {Density = 0, Offset = 0, Glare = 0, Haze = 0}
		local LightingProperties = {}
		local EnabledProperties = {}
		local OldValues = {}
		
		const function AddAtmosphere(Atmosphere)
			local OldAtmosphereProperties = {}
			for Prop, Value in AtmosphereProperties do
				OldAtmosphereProperties[Prop] = Atmosphere[Prop]
				Atmosphere[Prop] = Value
			end

			local db2 = false
			Fullbright:Clean(Atmosphere.Changed:Connect(function(Property)
				if AtmosphereProperties[Property] and not db2 then
					db2 = true
					OldAtmosphereProperties[Property] = Atmosphere[Property]
					Atmosphere[Property] = AtmosphereProperties[Property]
					db2 = false
				end
			end))

			OldValues[Atmosphere] = OldAtmosphereProperties
		end
		
		const function AddEffect(Effect)
			const IsGameBloom = Effect ~= Bloom

			local OldEffectProperties = {
				Enabled = Effect.Enabled
			}

			Effect.Enabled = not IsGameBloom
			Fullbright:Clean(Effect:GetPropertyChangedSignal('Enabled'):Connect(function()
				OldEffectProperties.Enabled = Effect.Enabled
				Effect.Enabled = not IsGameBloom
			end))

			OldValues[Effect] = OldEffectProperties
		end

		const function Lighting_DescendantAdded(Obj)
			if Obj:IsA('Atmosphere') then
				AddAtmosphere(Obj)
			elseif Obj:IsA('PostEffect') then
				AddEffect(Obj)
			end
		end

		const function Camera_DescendantAdded(Obj)
			if Obj:IsA('PostEffect') then
				AddEffect(Obj)
			end
		end
		
		Fullbright = Visuals:CreateModule({
			Name = 'Fullbright',
			Info = 'Increases the brightness of lighting and removes visual effects that can make it harder to see',
			Function = function(Enabled)
				if Enabled then
					Bloom = Instance.new('BloomEffect')
					Bloom.Intensity = 0
					Bloom.Size = 0
					Bloom.Threshold = 0
					Bloom.Parent = Lighting
		
					local OldLightingProperties = {}
		
					for Prop, v in LightingProperties do
						OldLightingProperties[Prop] = Lighting[Prop]
						if EnabledProperties[Prop].Enabled then
							Lighting[Prop] = v.Value or v.Color
						end
					end
		
					OldValues[Lighting] = OldLightingProperties
					Fullbright:Clean(Lighting.Changed:Connect(function(Property)
						const ConfiguredOption = LightingProperties[Property]
						if ConfiguredOption and EnabledProperties[Property].Enabled and not db then
							db = true
							OldLightingProperties[Property] = Lighting[Property]
							Lighting[Property] = ConfiguredOption.Value or ConfiguredOption.Color
							db = false
						end
					end))
		
					Fullbright:Clean(Lighting.DescendantAdded:Connect(Lighting_DescendantAdded))
					Fullbright:Clean(Camera.DescendantAdded:Connect(Camera_DescendantAdded))

					for _, Effect in Lighting:QueryDescendants('Atmosphere, PostEffect') do
						Lighting_DescendantAdded(Effect)
					end
					for _, Effect in Camera:QueryDescendants('PostEffect') do
						Camera_DescendantAdded(Effect)
					end
				else
					Bloom:Destroy()
					Bloom = nil
					db = nil
					for Obj, Tab in OldValues do
						for Prop, Value in Tab do
							Obj[Prop] = Value
						end
					end
					table.clear(OldValues)
				end
			end
		})
		
		EnabledProperties.ExposureCompensation = Fullbright:CreateToggle({
			Name = 'Set Exposure',
			Default = true,
			Restart = true
		})
		
		LightingProperties.ExposureCompensation = EnabledProperties.ExposureCompensation:CreateSlider({
			Name = 'Exposure',
			Default = 0,
			Min = -3,
			Max = 3,
			Decimal = 100,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.ExposureCompensation.Enabled then
					db = true
					Lighting.ExposureCompensation = Val
					db = false
				end
			end
		})
		
		EnabledProperties.Brightness = Fullbright:CreateToggle({
			Name = 'Set Brightness',
			Default = true,
			Restart = true
		})
		
		LightingProperties.Brightness = EnabledProperties.Brightness:CreateSlider({
			Name = 'Brightness',
			Default = 3,
			Min = 0,
			Max = 10,
			Decimal = 10,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.Brightness.Enabled then
					db = true
					Lighting.Brightness = Val
					db = false
				end
			end
		})
		
		EnabledProperties.Ambient = Fullbright:CreateToggle({
			Name = 'Set Ambient',
			Default = true,
			Restart = true
		})
		
		LightingProperties.Ambient = EnabledProperties.Ambient:CreateColorPicker({
			Name = 'Ambient',
			Function = function(Color)
				if Fullbright.Enabled and EnabledProperties.Ambient.Enabled then
					db = true
					Lighting.Ambient = Color
					db = false
				end
			end
		})
		
		EnabledProperties.OutdoorAmbient = Fullbright:CreateToggle({
			Name = 'Set Outdoor Ambient',
			Default = true,
			Restart = true
		})
		
		LightingProperties.OutdoorAmbient = EnabledProperties.OutdoorAmbient:CreateColorPicker({
			Name = 'Outdoor Ambient',
			Function = function(Color)
				if Fullbright.Enabled and EnabledProperties.OutdoorAmbient.Enabled then
					db = true
					Lighting.OutdoorAmbient = Color
					db = false
				end
			end
		})
		
		EnabledProperties.ColorShift_Bottom = Fullbright:CreateToggle({
			Name = 'Set Color Shift Bottom',
			Default = true,
			Restart = true
		})
		
		LightingProperties.ColorShift_Bottom = EnabledProperties.ColorShift_Bottom:CreateColorPicker({
			Name = 'Color Shift Bottom',
			Default = Color3.White,
			Function = function(Color)
				if Fullbright.Enabled and EnabledProperties.ColorShift_Bottom.Enabled then
					db = true
					Lighting.ColorShift_Bottom = Color
					db = false
				end
			end
		})
		
		EnabledProperties.ColorShift_Top = Fullbright:CreateToggle({
			Name = 'Set Color Shift Top',
			Default = true,
			Restart = true
		})
		
		LightingProperties.ColorShift_Top = EnabledProperties.ColorShift_Top:CreateColorPicker({
			Name = 'Color Shift Top',
			Default = Color3.White,
			Function = function(Color)
				if Fullbright.Enabled and EnabledProperties.ColorShift_Top.Enabled then
					db = true
					Lighting.ColorShift_Top = Color
					db = false
				end
			end
		})
		
		EnabledProperties.GlobalShadows = Fullbright:CreateToggle({
			Name = 'Set Shadows',
			Default = true,
			Restart = true
		})
		
		LightingProperties.GlobalShadows = EnabledProperties.GlobalShadows:CreateToggle({
			Name = 'Shadows',
			Function = function(Enabled)
				if Fullbright.Enabled and EnabledProperties.GlobalShadows.Enabled then
					db = true
					Lighting.GlobalShadows = Enabled
					db = false
				end
			end
		})
		
		EnabledProperties.EnvironmentDiffuseScale = Fullbright:CreateToggle({
			Name = 'Set Diffuse Scale',
			Default = true,
			Restart = true
		})
		
		LightingProperties.EnvironmentDiffuseScale = EnabledProperties.EnvironmentDiffuseScale:CreateSlider({
			Name = 'Diffuse Scale',
			Default = 0,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.EnvironmentDiffuseScale.Enabled then
					db = true
					Lighting.EnvironmentDiffuseScale = Val
					db = false
				end
			end
		})
		
		EnabledProperties.EnvironmentSpecularScale = Fullbright:CreateToggle({
			Name = 'Set Specular Scale',
			Default = true,
			Restart = true
		})
		
		LightingProperties.EnvironmentSpecularScale = EnabledProperties.EnvironmentSpecularScale:CreateSlider({
			Name = 'Specular Scale',
			Default = 0,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.EnvironmentSpecularScale.Enabled then
					db = true
					Lighting.EnvironmentSpecularScale = Val
					db = false
				end
			end
		})
		
		EnabledProperties.ClockTime = Fullbright:CreateToggle({
			Name = 'Set Clock Time',
			Default = true,
			Restart = true
		})
		
		LightingProperties.ClockTime = EnabledProperties.ClockTime:CreateSlider({
			Name = 'Clock Time',
			Default = 12,
			Min = 0,
			Max = 24,
			Decimal = 10,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.ClockTime.Enabled then
					db = true
					Lighting.ClockTime = Val
					db = false
				end
			end
		})
		
		EnabledProperties.FogStart = Fullbright:CreateToggle({
			Name = 'Set Fog Start',
			Default = true,
			Restart = true
		})
		
		LightingProperties.FogStart = EnabledProperties.FogStart:CreateSlider({
			Name = 'Fog Start',
			Default = Lighting.FogStart,
			Min = 0,
			Max = 100,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.FogStart.Enabled then
					db = true
					Lighting.FogStart = Val
					db = false
				end
			end
		})
		
		EnabledProperties.FogEnd = Fullbright:CreateToggle({
			Name = 'Set Fog End',
			Default = true,
			Restart = true
		})
		
		LightingProperties.FogEnd = EnabledProperties.FogEnd:CreateSlider({
			Name = 'Fog End',
			Default = 100000,
			Min = 0,
			Max = 100000,
			Function = function(Val)
				if Fullbright.Enabled and EnabledProperties.FogEnd.Enabled then
					db = true
					Lighting.FogEnd = Val
					db = false
				end
			end
		})
		
		EnabledProperties.FogColor = Fullbright:CreateToggle({
			Name = 'Set Fog Color',
			Restart = true
		})
		
		LightingProperties.FogColor = EnabledProperties.FogColor:CreateColorPicker({
			Name = 'Fog Color',
			Function = function(Color)
				if Fullbright.Enabled and EnabledProperties.FogColor.Enabled then
					db = true
					Lighting.FogColor = Color
					db = false
				end
			end
		})
	end)

	Run(function() -- NameTags
		local NameTags, TextSize, Font, Priority, UseTeamColor, UseLimits, MinDistance, MaxDistance
		local UsePlayers, TextColor, BackgroundColor
		local UseNPCs, NPC_TextColor, NPC_BackgroundColor
		local ShowName, ShowDisplayName, ShowHealth, ShowHealthAsPercentage, ShowDistance, PixelsOffset
		
		local Folder
		local Entities = 0
		const Rendered = {}
		
		const function EntityRemoved(Entity)
			const Tab = Rendered[Entity.Character]
			if Tab then
				Entities -= 1
				NameTags:UpdateTextGUI()
				Tab.NameTag:Destroy()
				Rendered[Entity.Character] = nil
			end
		end
		
		const function EntityAdded(Entity)
			EntityRemoved(Entity)
		
			if Entity.Player and not UsePlayers.Enabled then return end
			if Entity.NPC and not UseNPCs.Enabled then return end
			if Priority.Value ~= 'All' then
				if (Priority.Value == 'Enemies' and Entity.Teammate) or (Priority.Value == 'Teammates' and not Entity.Teammate) or (Priority.Value == 'Friends' and not IsFriend(Entity.Player)) then
					return
				end
			end
		
			Entities += 1
			NameTags:UpdateTextGUI()
		
			const Player = Entity.Player
			const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
		
			local TextLabel = Instance.new('TextLabel')
			TextLabel.Active = false
			TextLabel.Interactable = false
			TextLabel.Name = `{Player and Player.Name or Entity.Character.Name}_NameTag`
			TextLabel.BorderSizePixel = 0
			TextLabel.BackgroundColor3 = Player and BackgroundColor.Color or NPC_BackgroundColor.Color
			TextLabel.BackgroundTransparency = Player and BackgroundColor.Transparency or NPC_BackgroundColor.Transparency
			TextLabel.TextColor3 = EntityColor or (Player and TextColor.Color or NPC_TextColor.Color)
			TextLabel.TextTransparency = Player and TextColor.Transparency or NPC_TextColor.Transparency
			TextLabel.TextSize = TextSize.Value
			TextLabel.FontFace = Font.Value
			TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel.RichText = true
			TextLabel.ZIndex = 0
			TextLabel.Parent = Folder
		
			Rendered[Entity.Character] = {
				NameTag = TextLabel,
				Entity = Entity
			}
		
			return TextLabel
		end
		
		local StudsOffsetVector = vector.yAxis
		
		const function RenderNameTags()
			const CameraPosition: vector = Camera.CFrame.Position
			const CameraLookDirection: vector = Camera.CFrame.LookVector

			for _, Tab in Rendered do
				const NameTag = Tab.NameTag
				const Entity = Tab.Entity

				if vector.dot(vector.normalize(Entity.Root.Position - CameraPosition), CameraLookDirection) < 0 then
					NameTag.Visible = false
					continue
				end
		
				if EntityLib.Alive and UseLimits.Enabled then
					const Magnitude = vector.magnitude(EntityLib.Root.Position - Entity.Root.Position)
					if Magnitude > MaxDistance.Value or Magnitude < MinDistance.Value then
						NameTag.Visible = false
						continue
					end
				end
		
				const HeadPos, HeadOnScreen = Camera:WorldToViewportPoint(Entity.Head.Position + StudsOffsetVector)
				if HeadOnScreen then
					local Text = ''
					const Player = Entity.Player
					const Character = Entity.Character

					if ShowDistance.Enabled and EntityLib.Alive then
						Text ..= `[<font color = 'rgb(255, 255, 255)'>{math.floor(vector.magnitude(EntityLib.Root.Position - Entity.Root.Position))}</font>]`
					end

					if ShowName.Enabled and ShowDisplayName.Enabled then
						Text ..= `{Text == '' and '' or ' '}{Player and GetFullPlayerName(Player) or Character.Name}`
					elseif ShowName.Enabled then
						Text ..= `{Text == '' and '' or ' '}{Player and Player.Name or Character.Name}`
					elseif ShowDisplayName.Enabled then
						Text ..= `{Text == '' and '' or ' '}{Player and Player.DisplayName or Character.Name}`
					end

					if ShowHealth.Enabled then
						const Alpha = (Entity.Health or 100) / (Entity.MaxHealth or 100)
						const HealthColor = Color3.fromHSV((1 / 3) * Alpha, 1, 1)
						const Health = math.floor(ShowHealthAsPercentage.Enabled and Alpha * 100 or Entity.Health or 100)
						Text ..= `{Text == '' and '' or ' '}<font color = '#{HealthColor:ToHex()}'>{Health}{ShowHealthAsPercentage.Enabled and '%' or ''}</font>`
					end

					if NameTag.Text ~= Text then
						const TextBounds = GetTextBounds(Text, TextSize.Value, Font.Value)
						NameTag.Text = Text
						NameTag.Size = UDim2.fromOffset(TextBounds.X + 8, TextBounds.Y + 8)
					end
					
					NameTag.Position = UDim2.fromOffset(HeadPos.X, HeadPos.Y - PixelsOffset.Value)
					NameTag.Visible = true
				else
					NameTag.Visible = false
				end
			end
		end
		
		const function UpdateNameTags()
			if not NameTags.Enabled then return end
			for _, Tab in Rendered do
				const NameTag = Tab.NameTag
				const Entity = Tab.Entity
				const Player = Tab.Entity.Player
				const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
				
				NameTag.BackgroundColor3 = Player and BackgroundColor.Color or NPC_BackgroundColor.Color
				NameTag.BackgroundTransparency = Player and BackgroundColor.Transparency or NPC_BackgroundColor.Transparency
				NameTag.TextColor3 = EntityColor or (Player and TextColor.Color or NPC_TextColor.Color)
				NameTag.TextTransparency = Player and TextColor.Transparency or NPC_TextColor.Transparency
				NameTag.TextSize = TextSize.Value
				NameTag.FontFace = Font.Value
			end
		end
		
		NameTags = Visuals:CreateModule({
			Name = 'NameTags',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'NameTags'
					Folder.Parent = TidalWave.Gui
		
					NameTags:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					NameTags:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
					NameTags:Clean(RunService.PreRender:Connect(RenderNameTags))
					
					for _, Ent in EntityLib.List do
						EntityAdded(Ent)
					end
				else
					Folder:Destroy()
					Folder = nil
					
					Entities = 0
					table.clear(Rendered)
				end
			end,
			ExtraText = function()
				return tostring(Entities)
			end
		})
		
		Priority = NameTags:CreateDropdown({
			Name = 'Priority',
			List = {'All', 'Enemies', 'Teammates', 'Friends'},
			Restart = true
		})

		UseTeamColor = NameTags:CreateToggle({
			Name = 'Use Team Color',
			Tooltip = 'Uses team based coloring for NameTag text color.',
			Default = true,
			Function = UpdateNameTags
		})
		
		UsePlayers = NameTags:CreateToggle({
			Name = 'Players',
			Info = 'Whether or not to show players',
			Default = true,
			Restart = true
		})
		
		TextColor = UsePlayers:CreateColorPicker({
			Name = 'Text Color',
			Function = UpdateNameTags
		})
		
		BackgroundColor = UsePlayers:CreateColorPicker({
			Name = 'Background Color',
			Default = Color3.Black,
			Transparency = 0.5,
			Function = UpdateNameTags
		})
		
		UseNPCs = NameTags:CreateToggle({
			Name = 'NPCs',
			Info = 'Whether or not to show NPCs',
			Restart = true
		})
		
		NPC_TextColor = UseNPCs:CreateColorPicker({
			Name = 'NPC Text Color',
			Function = UpdateNameTags
		})

		NPC_BackgroundColor = UseNPCs:CreateColorPicker({
			Name = 'NPC Background Color',
			Default = Color3.Black,
			Transparency = 0.5,
			Function = UpdateNameTags
		})
		
		TextSize = NameTags:CreateSlider({
			Name = 'Text Size',
			Default = 16,
			Min = 8,
			Max = 32,
			Function = UpdateNameTags
		})
		
		Font = NameTags:CreateFont({
			Name = 'Font',
			Function = UpdateNameTags
		})
		
		NameTags:CreateSlider({
			Name = 'Studs Offset',
			Default = 1,
			Min = 0,
			Max = 10,
			Decimal = 100,
			Function = function(Val)
				StudsOffsetVector = vector.create(0, Val, 0)
			end
		})
		
		PixelsOffset = NameTags:CreateSlider({
			Name = 'Pixels Offset',
			Default = 12,
			Min = 0,
			Max = 50
		})
		
		ShowName = NameTags:CreateToggle({
			Name = 'Name',
			Default = true
		})
		
		ShowDisplayName = NameTags:CreateToggle({
			Name = 'Display Name',
		})
		
		ShowHealth = NameTags:CreateToggle({
			Name = 'Health',
			Default = true
		})
		
		ShowHealthAsPercentage = ShowHealth:CreateToggle({
			Name = 'Show Health As Percentage',
		})
		
		ShowDistance = NameTags:CreateToggle({
			Name = 'Distance',
			Default = true
		})
		
		UseLimits = NameTags:CreateToggle({
			Name = 'Use Limits',
			Info = 'Sets a minimum and maximum distance to render nametags inside',
		})
		
		MinDistance = UseLimits:CreateSlider({
			Name = 'Min Distance',
			Default = 0,
			Min = 0,
			Max = 50
		})
		
		MaxDistance = UseLimits:CreateSlider({
			Name = 'Max Distance',
			Default = 1000,
			Min = 100,
			Max = 1000
		})
	end)

	Run(function() -- NoRender
		Visuals:CreateModule({
			Name = 'NoRender',
			Info = 'Disables 3D Rendering',
			Function = function(Enabled)
				RunService:Set3dRenderingEnabled(not Enabled)
			end
		})
	end)

	Run(function() -- PartESP
		local PartESP, NameCheckMethod, HighlightType, OutlineColor, FillColor, SearchMethod, Names, FilterType
		
		local DepthMode
		local Shading, ModelSizeMode
		
		local Folder, Path
		local Highlights = {}
		local BoxConnections = {}
		
		const function GetSize(Part)
			if Part:IsA('Model') then
				if ModelSizeMode.Value == 'ExtentsSize' or Part.PrimaryPart == nil then
					return Part:GetExtentsSize()
				else
					return Part.PrimaryPart.Size
				end
			else
				return Part.Size
			end
		end
		
		const function HighlightPart(Part)
			if HighlightType.Value == 'Highlight' then
				local Highlight = Instance.new('Highlight')
				Highlight.Name = `{Part.Name}_ESP`
				Highlight.OutlineColor = OutlineColor.Color
				Highlight.FillColor = FillColor.Color
				Highlight.OutlineTransparency = OutlineColor.Transparency
				Highlight.FillTransparency = FillColor.Transparency
				Highlight.DepthMode = Enum.HighlightDepthMode[DepthMode.Value]
				Highlight.Adornee = Part
				Highlight.Parent = Folder
		
				table.insert(Highlights, Highlight)
			else
				local Box = Instance.new('BoxHandleAdornment')
				Box.Shading = Enum.AdornShading[Shading.Value]
				Box.Size = GetSize(Part)
				Box.Name = `{Part.Name}_ESP`
				Box.Color3 = FillColor.Color
				Box.Transparency = FillColor.Transparency
				Box.Adornee = Part
				Box.ZIndex = 1
				Box.Parent = Folder
		
				BoxConnections[Box] = {
					PartESP:Clean(Part.ChildAdded:Connect(function(Child)
						if Child:IsA('BasePart') then
							Box.Size = GetSize(Part)
						end
					end)),
					PartESP:Clean(Part.ChildRemoved:Connect(function(Child)
						if Child:IsA('BasePart') then
							Box.Size = GetSize(Part)
						end
					end))
				}
			end
		end
		
		const function NameCheck(Child)
			if FilterType.Value == 'None' then return true end
			local Name = Child.Name:lower()
			for _, v in Names.Enabled do
				local ListName = v:lower()
				if NameCheckMethod.Value == 'Exact Name' then
					return if FilterType.Value == 'Include' then Name:sub(1, #ListName) == Name else Name:sub(1, #ListName) ~= Name
				else
					return if FilterType == 'Include' then Name:match(ListName) else not Name:match(ListName)
				end
			end
			return false
		end
		
		const function ChildRemoved(Child)
			for _, Highlight in Highlights do
				if Highlight.Adornee == Child then
					Highlight:Destroy()
					Highlights[Highlight] = nil
					break
				end
			end
		
			for Box, Tab in BoxConnections do
				if Box.Adornee == Child then
					Box:Destroy()
					for _, Connection in Tab do
						Connection:Disconnect()
					end
					table.clear(Tab)
					BoxConnections[Box] = nil
					break
				end
			end
		end
		
		const function Loop(Obj)
			for _, v in Obj:GetChildren() do
				if v:IsA('Folder') then
					Loop(v)
				elseif (v:IsA('BasePart') or v:IsA('Model')) and NameCheck(v) then
					HighlightPart(v)
				end
			end
		
			PartESP:Clean(Obj.ChildAdded:Connect(function(Child)
				if (Child:IsA('Model') or Child:IsA('BasePart')) and NameCheck(Child) then
					HighlightPart(Child)
				end
			end))
			
			PartESP:Clean(Obj.ChildRemoved:Connect(function(Child)
				if Child:IsA('Model') or Child:IsA('BasePart') then
					ChildRemoved(Child)
				end
			end))
		end
		
		const function UpdateHighlights()
			for Highlight in Highlights do
				Highlight.OutlineColor = OutlineColor.Color
				Highlight.FillColor = FillColor.Color
				Highlight.OutlineTransparency = OutlineColor.Transparency
				Highlight.FillTransparency = FillColor.Transparency
			end
		
			for Box in BoxConnections do
				Box.Color3 = FillColor.Color
				Box.Transparency = FillColor.Transparency
			end
		end
		
		PartESP = Visuals:CreateModule({
			Name = 'PartESP',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'PartESP'
					Folder.Parent = TidalWave.Gui
		
					local RootPath = Path or workspace
		
					if SearchMethod.Value == 'Children' then
						Loop(RootPath)
					else
						for _, v in RootPath:QueryDescendants('BasePart, Model') do
							if NameCheck(v) then
								HighlightPart(v)
							end
						end

						PartESP:Clean(RootPath.DescendantAdded:Connect(function(Child)
							if Child:IsA('BasePart') or Child:IsA('Model') then
								if NameCheck(Child) then
									HighlightPart(Child)
								end
							end
						end))

						PartESP:Clean(RootPath.DescendantRemoving:Connect(function(Child)
							if Child:IsA('Model') or Child:IsA('BasePart') then
								ChildRemoved(Child)
							end
						end))
					end
				else
					Folder:Destroy()
					Folder = nil
					table.clear(Highlights)
					table.clear(BoxConnections)
				end
			end
		})
		
		HighlightType = PartESP:CreateDropdown({
			Name = 'Highlight Type',
			List = {'Highlight', 'BoxHandle'},
			Restart = true
		})
		
		Shading = HighlightType:BindDropdownTo('BoxHandle', {
			Name = 'Shading',
			List = {'AlwaysOnTop', 'Default', 'Shaded', 'XRay', 'XRayShaded'},
			Function = function(Val)
				for _, Highlight in Highlights do
					Highlight.Shading = Enum.AdornShading[Val]
				end
			end,
		})
		
		ModelSizeMode = HighlightType:BindDropdownTo('BoxHandle', {
			Name = 'Model Size Mode',
			List = {'ExtentsSize', 'PrimaryPart'},
			Function = function(Val)
				for Box in BoxConnections do
					Box.Size = GetSize(Box.Adornee)
				end
			end
		})
		
		DepthMode = HighlightType:BindDropdownTo('Highlight', {
			Name = 'Depth Mode',
			List = {'AlwaysOnTop', 'Occluded'},
			Function = function(Val)
				for _, Highlight in Highlights do
					Highlight.DepthMode = Enum.HighlightDepthMode[Val]
				end
			end,
		})
		
		OutlineColor = HighlightType:BindColorPickerTo('Highlight', {
			Name = 'Outline Color',
			Function = UpdateHighlights
		})
		
		FillColor = PartESP:CreateColorPicker({
			Name = 'Fill Color',
			Transparency = 0.5,
			Function = UpdateHighlights
		})
		
		PartESP:CreateTextBox({
			Name = 'Folder Path',
			PlaceholderText = 'Enter path',
			Function = function(Text, Loaded)
				if Text:match('%w+') then
					local Function = loadstring(`return {Text}`)
					if typeof(Function) == 'function' then
						local Success, Result = pcall(Function)
						if Success and typeof(Result) == 'Instance' then
							Path = Result
							if Loaded then return end

							Notify({
								Text = `Set Object to {GetFullName(Path)}`,
								Duration = 5
							})
						elseif typeof(Result) == 'string' then
							Path = nil
							if Loaded then return end

							Notify({
								Text = Result,
								Duration = 10,
								Type = 'Error'
							})
						end
					elseif typeof(Function) == 'string' then
						Notify({
							Text = Function,
							Duration = 10,
							Type = 'Error'
						})
					end
				else
					Path = nil
				end
			end
		})
		
		SearchMethod = PartESP:CreateDropdown({
			Name = 'Search Method',
			List = {'Children', 'Descendants'},
			Restart = true
		})
		
		FilterType = PartESP:CreateDropdown({
			Name = 'Filter Type',
			List = {'None', 'Include', 'Exclude'},
			Restart = true
		})
		
		NameCheckMethod = FilterType:BindDropdownToAllExcept('None', {
			Name = 'Name Method',
			List = {'Exact Name', 'Contains String'},
			Restart = true
		})
		
		Names = FilterType:BindTextListToAllExcept('None', {
			Name = 'Names',
			Restart = true
		})
	end)

	Run(function() -- Tracers
		local Tracers, Priority, UseTeamColor, Thickness, TracerPosition, TracerTarget, TracerOffsetX, TracerOffsetY, TracerOffsetZ
		local UsePlayers, Color
		local UseNPCs, NPC_Color
		local XBoxConnect, HideMainTracer
		
		local ScreenGui, PlayerHolder, NPC_Holder
		local TracerOffset = vector.zero
		local Entities = 0
		
		const Presets = {
			['Top Left'] = Path2DControlPoint.new(UDim2.fromScale(0, 0)),
			['Top'] = Path2DControlPoint.new(UDim2.fromScale(0.5, 0)),
			['Top Right'] = Path2DControlPoint.new(UDim2.fromScale(1, 0)),
			['Left'] = Path2DControlPoint.new(UDim2.fromScale(0, 0.5)),
			['Middle'] = Path2DControlPoint.new(UDim2.fromScale(0.5, 0.5)),
			['Right'] = Path2DControlPoint.new(UDim2.fromScale(1, 0.5)),
			['Bottom Left'] = Path2DControlPoint.new(UDim2.fromScale(0, 1)),
			['Bottom'] = Path2DControlPoint.new(UDim2.fromScale(0.5, 1)),
			['Bottom Right'] = Path2DControlPoint.new(UDim2.fromScale(1, 1)),
			['Mouse'] = Path2DControlPoint.new()
		}
		
		const TracerPath = {
			R15 = {
				LeftFoot = {
					{'LowerTorso'},
					{'LeftUpperLeg'},
					{'LeftLowerLeg'},
					{'LeftFoot'}
				},
				RightFoot = {
					{'LowerTorso'},
					{'RightUpperLeg'},
					{'RightLowerLeg'},
					{'RightFoot'}
				},
				LeftHand = {
					{'LowerTorso'},
					{'UpperTorso', {vector.create(0, 0.25, 0)}},
					{'LeftUpperArm'},
					{'LeftLowerArm'},
					{'LeftHand'}
				},
				RightHand = {
					{'UpperTorso', {vector.create(0, 0.25, 0)}},
					{'RightUpperArm'},
					{'RightLowerArm'},
					{'RightHand'}
				},
				Head = {
					{'UpperTorso', {vector.create(0, 0.25, 0)}},
					{'Head'}
				}
			},
			R6 = {
				LeftFoot = {
					{'Torso', vector.create(0, -0.25, 0)},
					{'Left Leg', vector.create(0, 0.25, 0)},
					{'Left Leg', vector.create(0, -0.25, 0)},
				},
				RightFoot = {
					{'Torso', vector.create(0, -0.25, 0)},
					{'Right Leg', vector.create(0, 0.25, 0)},
					{'Right Leg', vector.create(0, -0.25, 0)}
				},
				LeftHand = {
					{'Torso', vector.create(0, -0.25, 0)},
					{'Torso', vector.create(0, 0.25, 0)},
					{'Left Arm', vector.create(0, 0.25, 0)},
					{'Left Arm', vector.create(0, -0.25, 0)}
				},
				RightHand = {
					{'Torso', vector.create(0, -0.25, 0)},
					{'Torso', vector.create(0, 0.25, 0)},
					{'Right Arm', vector.create(0, 0.25, 0)},
					{'Right Arm', vector.create(0, -0.25, 0)}
				},
				Head = {
					{'Torso', vector.create(0, 0.25, 0)},
					{'Head'}
				}
			}
		}
		
		local TracerObjects = {}
		local ScreenPointCache = {}
		
		local From = Presets.Bottom
		
		const function RenderTracers()
			const CameraCFrame = Camera.CFrame
			const CameraLookDirection: vector = CameraCFrame.LookVector
			const CameraPosition: vector = CameraCFrame.Position
		
			if TracerPosition.Value == 'Mouse' then
				const MouseLocation = GetMouseLocation()
				From.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
			end
		
			for _, Tab in TracerObjects do
				local Tracers = Tab.Tracers
				local Entity = Tab.Entity
				local ControlPoints = Tab.ControlPoints
				
				if vector.dot(vector.normalize(Entity.Root.Position - CameraPosition), CameraLookDirection) < 0 then
					for _, v in Tracers do
						v.Visible = false
					end
		
					continue
				end
		
				if HideMainTracer.Enabled then
					Tracers.Tracer.Visible = false
				else
					local Tracer = Tracers.Tracer
					local Part = Entity[TracerTarget.Value] or Entity.Root
					local ScreenPoint, Visible = Camera:WorldToViewportPoint(Part.Position + TracerOffset)
					if Visible then
						local ControlPoint = ControlPoints[Tracer]
						ControlPoint.Position = UDim2.fromOffset(ScreenPoint.X, ScreenPoint.Y)
						Tracer:SetControlPoints({
							[1] = From,
							[2] = ControlPoint
						})
		
						Tracer.Visible = true
					else
						Tracer.Visible = false
					end
				end
		
				if XBoxConnect.Enabled then
					for LimbGroup, Data in TracerPath[Entity.RigType.Name] do
						local i = 0
						local AnyCreated
						local CurrentTracer = Tracers[LimbGroup]
						local CurrentControlPoints = ControlPoints[CurrentTracer]
						local RenderedControlPoints = {}
		
						for _, LimbData in Data do
							local Limb
							local LimbName = LimbData[1]
							local Cache = Entity[LimbName]
		
							if Cache then
								Limb = Cache
							else
								Limb = Entity.Character:FindFirstChild(LimbName)
								Entity[LimbName] = Limb
							end
		
							if not Limb then break end
		
							local LimbPos, LimbVisible
		
							if LimbData[2] then
								LimbPos = Limb.CFrame:ToWorldSpace(CFrame.new(Limb.Size * LimbData[2])).Position
							else
								LimbPos = Limb.Position
							end
		
							local CachedPoint = ScreenPointCache[LimbName]
		
							if CachedPoint and CachedPoint.CFrame == Camera.CFrame and CachedPoint.Position == LimbPos then
								LimbPos, LimbVisible = CachedPoint.ScreenPoint, CachedPoint.Visible
							else
								local WorldPosition = LimbPos
								LimbPos, LimbVisible = Camera:WorldToViewportPoint(LimbPos)
								ScreenPointCache[LimbName] = {
									CFrame = Camera.CFrame,
									Position = WorldPosition,
									ScreenPoint = LimbPos,
									Visible = LimbVisible
								}
							end
							
							if LimbVisible then
								i += 1
								CurrentControlPoints[i].Position = UDim2.fromOffset(LimbPos.X, LimbPos.Y)
								RenderedControlPoints[i] = CurrentControlPoints[i]
								AnyCreated = true
							else
								break
							end
						end
		
						if AnyCreated then
							CurrentTracer:SetControlPoints(RenderedControlPoints)
							CurrentTracer.Visible = true
						else
							CurrentTracer.Visible = false
						end
					end
				end
			end
		end
		
		const function CreateTracer(Entity, LimbName)
			const Player = Entity.Player
			const Name = Player and Player.Name or Entity.Character.Name
			const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
		
			const Line = Instance.new('Path2D')
			Line.Name = `{Name}_{LimbName}_Tracer`
			Line.Color3 = EntityColor or (Player and Color.Color or NPC_Color.Color)
			Line.Thickness = Thickness.Value
			Line.Parent = Entity.Player and PlayerHolder or NPC_Holder
		
			return Line
		end
		
		const function EntityRemoved(Entity)
			const Tab = TracerObjects[Entity.Character]
			if Tab then
				Entities -= 1
				Tracers:UpdateTextGUI()
		
				for _, Tracer in Tab.Tracers do
					Tracer:Destroy()
				end
				TracerObjects[Entity.Character] = nil
			end
		end
		
		const function EntityAdded(Entity)
			if Entity.Player and not UsePlayers.Enabled then return end
			if Entity.NPC and not UseNPCs.Enabled then return end
			if Priority.Value ~= 'All' then
				if (Priority.Value == 'Enemies' and Entity.Teammate) or (Priority.Value == 'Teammates' and not Entity.Teammate) or (Priority.Value == 'Friends' and not IsFriend(Entity.Player)) then
					return
				end
			end
			
			Entities += 1
			Tracers:UpdateTextGUI()
			local MainControlPoint = Path2DControlPoint.new()
			local MainTracer = CreateTracer(Entity, 'Main')
			MainTracer:SetControlPoints({
				[1] = From,
				[2] = MainControlPoint
			})
		
			local Tracers = {
				Tracer = MainTracer
			}
		
			local ControlPoints = {
				[MainTracer] = MainControlPoint
			}
		
			for Limb, Data in TracerPath[Entity.RigType.Name] do
				local NewTracer = CreateTracer(Entity, Limb)
		
				local NewControlPoints = {}
				for i = 1, table.len(Data) do
					NewControlPoints[i] = Path2DControlPoint.new()
				end
		
				NewTracer:SetControlPoints(NewControlPoints)
				ControlPoints[NewTracer] = NewControlPoints
		
				Tracers[Limb] = NewTracer
			end
		
			local Tab = {
				Entity = Entity,
				Tracers = Tracers,
				ControlPoints = ControlPoints
			}
			
			TracerObjects[Entity.Character] = Tab
		end
		
		const function UpdateTracers()
			if not Tracers.Enabled then return end
			PlayerHolder.GroupTransparency = Color.Transparency
			NPC_Holder.GroupTransparency = Color.Transparency

			for _, Tab in TracerObjects do
				const Entity = Tab.Entity
				const EntityColor = UseTeamColor.Enabled and EntityLib:GetEntityColor(Entity) or nil
				const Color = EntityColor or (Tab.Entity.Player and Color.Color or NPC_Color.Color)
				for _, Tracer in Tab.Tracers do
					Tracer.Color3 = Color
					Tracer.Thickness = Thickness.Value
				end
			end
		end
		
		Tracers = Visuals:CreateModule({
			Name = 'Tracers',
			Info = 'Creates tracers',
			Function = function(Enabled)
				if Enabled then
					ScreenGui = Instance.new('ScreenGui')
					ScreenGui.Name = 'Tracers'
					ScreenGui.IgnoreGuiInset = true
					ScreenGui.DisplayOrder = -1
					ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					ScreenGui.Parent = TidalWave.Gui

					PlayerHolder = Instance.new('CanvasGroup')
					PlayerHolder.Name = 'Players'
					PlayerHolder.BackgroundTransparency = 1
					PlayerHolder.Active = false
					PlayerHolder.Interactable = false
					PlayerHolder.Size = UDim2.fromScale(1, 1)
					PlayerHolder.Parent = ScreenGui

					NPC_Holder = Instance.fromExisting(PlayerHolder)
					NPC_Holder.Name = 'NPCs'
					NPC_Holder.Parent = ScreenGui
		
					for _, Entity in EntityLib.List do
						EntityAdded(Entity)
					end
		
					Tracers:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					Tracers:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
					Tracers:Clean(RunService.PreRender:Connect(RenderTracers))
				else
					ScreenGui:Destroy()
					ScreenGui = nil
		
					Entities = 0
					table.clear(TracerObjects)
				end
			end,
			ExtraText = function()
				return tostring(Entities)
			end
		})
		
		Priority = Tracers:CreateDropdown({
			Name = 'Priority',
			List = {'All', 'Enemies', 'Teammates', 'Friends'},
			Restart = true
		})

		UseTeamColor = Tracers:CreateToggle({
			Name = 'Use Team Color',
			Tooltip = 'Uses team based coloring for tracers.',
			Default = true,
			Function = UpdateTracers
		})
		
		UsePlayers = Tracers:CreateToggle({
			Name = 'Players',
			Tooltip = 'Renders tracers on Players.',
			Default = true,
			Restart = true
		})
		
		Color = UsePlayers:CreateColorPicker({
			Name = 'Color',
			Function = UpdateTracers
		})
		
		UseNPCs = Tracers:CreateToggle({
			Name = 'NPCs',
			Tooltip = 'Renders tracers on NPCs.',
			Restart = true
		})
		
		NPC_Color = UseNPCs:CreateColorPicker({
			Name = 'NPC Color',
			Function = UpdateTracers
		})
		
		TracerPosition = Tracers:CreateDropdown({
			Name = 'Position',
			List = {'Bottom', 'Bottom Left', 'Bottom Right', 'Top Left', 'Top', 'Top Right', 'Left', 'Middle', 'Right', 'Mouse'},
			Function = function(Val)
				From = Presets[Val]
			end
		})
		
		Thickness = Tracers:CreateSlider({
			Name = 'Thickness',
			Default = 1,
			Min = 1,
			Max = 5,
			Function = UpdateTracers
		})
		
		TracerTarget = Tracers:CreateDropdown({
			Name = 'Tracer Target',
			List = {'Root', 'Head', 'Torso'}
		})
		
		XBoxConnect = Tracers:CreateToggle({
			Name = 'XBox Connect',
			Info = 'It connects the xbox.',
			Function = function(Enabled)
				if not Enabled then
					for _, v in TracerObjects do
						for i2, v2 in v.Tracers do
							if i2 ~= 'Tracer' then
								v2.Visible = false
							end
						end
					end
				end
			end
		})
		
		HideMainTracer = XBoxConnect:CreateToggle({
			Name = 'Hide Main Tracer',
			Info = 'Hides the main tracer for if you want to only see xbox connect'
		})
		
		TracerOffsetX = Tracers:CreateSlider({
			Name = 'Tracer Offset X',
			Default = 0,
			Min = -3,
			Max = 3,
			Decimal = 100,
			Function = function(Val)
				TracerOffset = vector.create(Val, TracerOffsetY.Value, TracerOffsetZ.Value)
			end
		})
		
		TracerOffsetY = Tracers:CreateSlider({
			Name = 'Tracer Offset Y',
			Default = 0,
			Min = -3,
			Max = 3,
			Decimal = 100,
			Function = function(Val)
				TracerOffset = vector.create(TracerOffsetX.Value, Val, TracerOffsetZ.Value)
			end
		})
		
		TracerOffsetZ = Tracers:CreateSlider({
			Name = 'Tracer Offset Z',
			Default = 0,
			Min = -3,
			Max = 3,
			Decimal = 100,
			Function = function(Val)
				TracerOffset = vector.create(TracerOffsetX.Value, TracerOffsetY.Value, Val)
			end
		})
	end)

	Run(function() -- Viewmodel
		local Viewmodel, X, Y, Z, RotationX, RotationY, RotationZ
				
		local OldTool, Handle
		local VisualOffset, VisualRotation
		const Offset = CFrame.new(2.6, -0.5, -4)
		const Rotation = CFrame.Angles(math.rad(90), 0, 0)
		
		const function ToolAdded(Tool)
			const TimeOut = os.clock() + 3
			repeat
				Handle = Tool:FindFirstChild('Handle')
			until Handle or not Viewmodel.Enabled or os.clock() >= TimeOut
		
			if not (Viewmodel.Enabled and Handle) then return end
		
			OldTool = Tool
		
			ViewmodelTool = Instance.fromExisting(Handle)
			ViewmodelTool.CanCollide = false
			ViewmodelTool.Massless = true
			ViewmodelTool.Anchored = true
			ViewmodelTool.Parent = Camera
		
			const Mesh = Handle:FindFirstChildWhichIsA('DataModelMesh', true)
			if Mesh then
				Instance.fromExisting(Mesh).Parent = ViewmodelTool
			end
		
			Handle.LocalTransparencyModifier = 1
		end
		
		const function LocalAdded()
			const Tool = EntityLib.Character:FindFirstChildWhichIsA('Tool', true)
			if Tool then
				ToolAdded(Tool)
			end
		
			Viewmodel:Clean(EntityLib.Character.DescendantAdded:Connect(function(Tool)
				if Tool:IsA('Tool') then
					ToolAdded(Tool)
				end
			end))
			
			Viewmodel:Clean(EntityLib.Character.DescendantRemoving:Connect(function(Obj)
				if Obj == OldTool then 
					ViewmodelTool:Destroy()
					ViewmodelTool = nil
					OldTool = nil
					Handle = nil
				end
			end))
		end
		
		const function LocalRemoved()
			if ViewmodelTool then
				ViewmodelTool:Destroy()
				ViewmodelTool = nil
			end
			OldTool = nil
			Handle = nil
		end
		
		Viewmodel = Visuals:CreateModule({
			Name = 'Viewmodel',
			Info = 'Creates a custom viewmodel for tools',
			Function = function(Enabled)
				if Enabled then
					ViewmodelMotor = Instance.new('Motor6D')
		
					if EntityLib.Alive then
						LocalAdded()
					end
		
					Viewmodel:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Viewmodel:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Viewmodel:Clean(RunService.PreRender:Connect(function()
						if ViewmodelTool then
							ViewmodelTool.CFrame = ((Camera.CFrame * Offset * Rotation) * ViewmodelMotor.C0) * VisualOffset * VisualRotation
							const ThirdPerson = IsThirdPerson()
							ViewmodelTool.LocalTransparencyModifier = ThirdPerson and 1 or 0
							Handle.LocalTransparencyModifier = ThirdPerson and 0 or 1
						end
					end))
				else
					if Handle then
						Handle.LocalTransparencyModifier = 0
						Handle = nil
					end
					
					OldTool = nil
		
					if ViewmodelTool then 
						ViewmodelTool:Destroy()
						ViewmodelTool = nil
					end
					if ViewmodelMotor then
						ViewmodelMotor:Destroy()
						ViewmodelMotor =  nil
					end
				end
			end,
		})
		
		const function UpdateCF()
			VisualOffset = CFrame.new(X.Value, Y.Value, Z.Value)
		end
		
		X = Viewmodel:CreateSlider({
			Name = 'X',
			Default = 0,
			Min = -5,
			Max = 5,
			Decimal = 100,
			Function = UpdateCF
		})
		
		Y = Viewmodel:CreateSlider({
			Name = 'Y',
			Default = 0,
			Min = -5,
			Max = 5,
			Decimal = 100,
			Function = UpdateCF
		})
		
		Z = Viewmodel:CreateSlider({
			Name = 'Z',
			Default = 0,
			Min = -10,
			Max = 0,
			Decimal = 100,
			Function = UpdateCF
		})
		
		const function UpdateRotation()
			VisualRotation = CFrame.Angles(math.rad(RotationX.Value), math.rad(RotationY.Value), math.rad(RotationZ.Value))
		end
		
		RotationX = Viewmodel:CreateSlider({
			Name = 'X Rotation',
			Default = 0,
			Min = -360,
			Max = 360,
			Function = UpdateRotation
		})
		
		RotationY = Viewmodel:CreateSlider({
			Name = 'Y Rotation',
			Default = 0,
			Min = -360,
			Max = 360,
			Function = UpdateRotation
		})
		
		RotationZ = Viewmodel:CreateSlider({
			Name = 'Z Rotation',
			Default = 0,
			Min = -360,
			Max = 360,
			Function = UpdateRotation
		})
		
		UpdateCF()
		UpdateRotation()
	end)

	Run(function() -- ViewportChams
		local ViewportChams, Priority
		
		local ShowPlayers, Color
		local ShowNPCs, NPC_Color
		local GlobalColor
		
		local ViewportFrame, ViewportModel
		local Entities = {}
		
		const AllowedClasses = {
			Part = true,
			MeshPart = true,
			Mesh = true,
			SpecialMesh = true,
			Attachment = true,
			Decal = true,
			Texture = true,
			Shirt = true,
			Pants = true,
			ShirtGraphic = true,
			BodyColors = true,
			Accessory = true,
			WrapLayer = true,
			WrapTarget = true,
			SurfaceAppearance = true,
			Humanoid = true,
			Animator = true,
			AnimationController = true
		}
		
		const function EntityRemoved(Entity)
			const Character = Entity.Character
		
			for i, Tab in Entities do
				if Tab.Entity.Character == Character then
					Tab.Model:Destroy()
					table.remove(Entities, i)
		
					ViewportChams:UpdateTextGUI()
					break
				end
			end
		end
		
		const function EntityAdded(Entity)
			if Entity.Player and not ShowPlayers.Enabled then return end
			if Entity.NPC and not ShowNPCs.Enabled then return end
			if Priority.Value ~= 'All' then
				if (Priority.Value == 'Enemies' and Entity.Teammate) or (Priority.Value == 'Teammates' and not Entity.Teammate) or (Priority.Value == 'Friends' and not IsFriend(Entity.Player)) then
					return
				end
			end
		
			ViewportChams:UpdateTextGUI()
		
			local Tab = {
				Entity = Entity,
				Parts = {},
				Tracks = {}
			}
		
			local OtherObjects = {}
			local PendingJoints = {}
			local ClonedAnimator
		
			const function Recursive(Obj, Parent)
				for _, Child in Obj:GetChildren() do
					if Child:IsA('JointInstance') then
						PendingJoints[Child] = true
						continue
					end
					if not AllowedClasses[Child.ClassName] then continue end
		
					local Clone = Instance.fromExisting(Child)
					if Clone:IsA('BasePart') then
						Clone.Color = Entity.Player and Color.Color or NPC_Color.Color
						Clone.LocalTransparencyModifier = Entity.Player and Color.Transparency or NPC_Color.Transparency
						Tab.Parts[Child] = Clone
					else
						OtherObjects[Child] = Clone
					end
		
					if Child:IsA('Animator') then
						ClonedAnimator = Clone
					elseif Child == Entity.Root then
						Clone.Anchored = true
						Tab.Root = Clone
					end
					
					Clone.Parent = Parent
					Recursive(Child, Clone)
				end
			end
		
			local Model = Instance.new('Model')
			Model.Name = (Entity.Player and Entity.Player.Name or Entity.Character.Name) .. '_Chams'
			Model.Parent = ViewportModel
		
			Tab.Model = Model
		
			Recursive(Entity.Character, Model)
		
			const function TrySetupJoint(Joint)
				local Part0 = Tab.Parts[Joint.Part0]
				local Part1 = Tab.Parts[Joint.Part1]
		
				if not Part0 or not Part1 then
					return false
				end
		
				local Clone = Instance.fromExisting(Joint)
				Clone.Part0 = Part0
				Clone.Part1 = Part1
				Clone.Parent = Part0.Parent
		
				return true
			end
		
			for Joint in PendingJoints do
				if TrySetupJoint(Joint) then
					PendingJoints[Joint] = nil
				end
			end
		
			ViewportChams:Clean(Entity.Character.DescendantAdded:Connect(function(Child)
				if Child:IsA('JointInstance') then
					if not TrySetupJoint(Child) then
						PendingJoints[Child] = true
					end
					return
				end
				if not AllowedClasses[Child.ClassName] then return end
		
				local Clone = Instance.fromExisting(Child)
				if Child:IsA('BasePart') then
					Clone.Color = Entity.Player and Color.Color or NPC_Color.Color
					Clone.LocalTransparencyModifier = Entity.Player and Color.Transparency or NPC_Color.Transparency
					Tab.Parts[Child] = Clone
		
					for Joint in PendingJoints do
						if Joint.Part0 == Child or Joint.Part1 == Child then
							if TrySetupJoint(Joint) then
								PendingJoints[Joint] = nil
							end
						end
					end
				else
					OtherObjects[Child] = Clone
				end
				
				if Child:IsA('Animator') then
					ClonedAnimator = Clone
				elseif Child == Entity.Root then
					Tab.Root = Entity.Root
				end
				
				Clone.Parent = Tab.Parts[Child.Parent] or OtherObjects[Child.Parent] or Model
			end))
		
			ViewportChams:Clean(Entity.Character.DescendantRemoving:Connect(function(Child)
				if not AllowedClasses[Child.ClassName] then return end
				if Tab.Parts[Child] then
					Tab.Parts[Child]:Destroy()
					Tab.Parts[Child] = nil
				elseif OtherObjects[Child] then
					OtherObjects[Child]:Destroy()
					OtherObjects[Child] = nil
				end
			end))
		
			const function AnimationPlayed(Track: AnimationTrack)
				if not Track.Animation then
					for i = 1, 3 do
						task.wait()
						if Track.Animation then break end
					end
				end
		
				if Track.Animation then
					local ClonedTrack = Tab.Tracks[Track] or ClonedAnimator:LoadAnimation(Track.Animation)
					ClonedTrack.Looped = Track.Looped
					ClonedTrack:Play(0, Track.WeightCurrent, Track.Speed)
					ClonedTrack.TimePosition = Track.TimePosition
					
					if not Tab.Tracks[Track] then
						Tab.Tracks[Track] = ClonedTrack
					end
			
					ViewportChams:Clean(Track.Ended:Once(function()
						Track:Stop(0)
					end))
				end
			end
		
			ViewportChams:Clean(Entity.Humanoid.AnimationPlayed:Connect(AnimationPlayed))
			for _, Track in Entity.Humanoid:GetPlayingAnimationTracks() do
				AnimationPlayed(Track)
			end
		
			table.insert(Entities, Tab)
		end
		
		const function RenderChams()
			const CameraCFrame = Camera.CFrame
			const CameraLookDirection: vector = CameraCFrame.LookVector
			const CameraPosition: vector = Camera.CFrame.Position
			
			for _, Tab in Entities do
				const Entity = Tab.Entity
		
				if vector.dot(vector.normalize(Entity.Root.Position - CameraPosition), CameraLookDirection) >= 0 then
					Entity.Root.CFrame = Entity.Root.CFrame
					for Track, Clone in Tab.Tracks do
						if Clone.WeightCurrent ~= Track.WeightCurrent then
							Clone:AdjustWeight(Track.WeightCurrent)
						end
						if Clone.Speed ~= Track.Speed then
							Clone:AdjustSpeed(Track.Speed)
						end
						if Clone.TimePosition ~= Track.TimePosition then
							Clone.TimePosition = Track.TimePosition
						end
					end
				end
			end
		end
		
		ViewportChams = Visuals:CreateModule({
			Name = 'ViewportChams',
			Info = 'Renders Players/NPCs through walls using viewport frames. (This is way laggier than regular chams).',
			Function = function(Enabled)
				if Enabled then
					ViewportFrame = Instance.new('ViewportFrame')
					ViewportFrame.Name = 'ViewportChams'
					ViewportFrame.Size = UDim2.fromScale(1, 1)
					ViewportFrame.BackgroundTransparency = 1
					ViewportFrame.CurrentCamera = Camera
					ViewportFrame.Ambient = Color3.White
					ViewportFrame.LightColor = Color3.White
					ViewportFrame.ImageColor3 = GlobalColor.Color
					ViewportFrame.ImageTransparency = GlobalColor.Transparency
					ViewportFrame.LightDirection = vector.zero
					ViewportFrame.ZIndex = -1
					ViewportFrame.Parent = TidalWave.Gui
		
					ViewportModel = Instance.new('WorldModel')
					ViewportModel.Name = 'ChamsWorldModel'
					ViewportModel.Parent = ViewportFrame
					
					ViewportChams:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					ViewportChams:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
					ViewportChams:Clean(RunService.PreRender:Connect(RenderChams))
					for _, Entity in EntityLib.List do
						EntityAdded(Entity)
					end
				else
					ViewportFrame:Destroy()
					ViewportFrame = nil
					ViewportModel = nil
					table.clear(Entities)
				end
			end,
			ExtraText = function()
				return tostring(#Entities)
			end
		})
		
		Priority = ViewportChams:CreateDropdown({
			Name = 'Priority',
			List = {'All', 'Enemies', 'Teammates', 'Friends'},
			Restart = true
		})
		
		ShowPlayers = ViewportChams:CreateToggle({
			Name = 'Players',
			Info = 'Whether or not to show players',
			Default = true,
			Function = function()
				ViewportChams:Restart()
			end
		})
		
		Color = ShowPlayers:CreateColorPicker({
			Name = 'Color',
			Function = function(Color)
				for _, Tab in Entities do
					local Entity = Tab.Entity
					if Entity.Player then
						for _, Part in Tab.Parts do
							Part.Color = Color
						end
					end
				end
			end
		})
		
		ShowNPCs = ViewportChams:CreateToggle({
			Name = 'NPCs',
			Info = 'Whether or not to show NPCs',
			Function = function()
				ViewportChams:Restart()
			end
		})
		
		NPC_Color = ShowNPCs:CreateColorPicker({
			Name = 'Color',
			Function = function(Color)
				for _, Tab in Entities do
					local Entity = Tab.Entity
					if Entity.NPC then
						for _, Part in Tab.Parts do
							Part.Color = Color
						end
					end
				end
			end
		})
		
		GlobalColor = ViewportChams:CreateColorPicker({
			Name = 'Global Color',
			Function = function(Color, Transparency)
				if ViewportFrame then
					ViewportFrame.ImageColor3 = Color
					ViewportFrame.ImageTransparency = Transparency
				end
			end
		})
	end)

	Run(function() -- WaterModifier
		local WaterModifier, WaterColor, WaterTransparency, WaterReflectance, WaterWaveSize, WaterWaveSpeed
		
		local Terrain = workspace.Terrain
		local Properties, db
		local OldValues = {}
		
		WaterModifier = Visuals:CreateModule({
			Name = 'WaterModifier',
			Info = 'Allows you to modify different properties of terrain water',
			Function = function(Enabled)
				if Enabled then
					OldValues = {
						WaterColor = Terrain.WaterColor,
						WaterTransparency = Terrain.WaterTransparency,
						WaterReflectance = Terrain.WaterReflectance,
						WaterWaveSize = Terrain.WaterWaveSize,
						WaterWaveSpeed = Terrain.WaterWaveSpeed
					}
		
					for Prop, Option in Properties do
						OldValues[Prop] = Terrain[Prop]
						Terrain[Prop] = Option.Value or Option.Color
					end
		
					WaterModifier:Clean(Terrain.Changed:Connect(function(Prop)
						if OldValues[Prop] and not db then
							db = true
							OldValues[Prop] = Terrain[Prop]
							Terrain[Prop] = Properties[Prop].Value
							db = false
						end
					end))
				else
					db = false
					for Prop, Value in OldValues do
						Terrain[Prop] = Value
					end
					table.clear(OldValues)
				end
			end
		})
		
		WaterColor = WaterModifier:CreateColorPicker({
			Name = 'Water Color',
			Default = Terrain.WaterColor,
			Function = function(Color)
				if WaterModifier.Enabled then
					db = true
					Terrain.WaterColor = Color
					db = false
				end
			end
		})
		
		WaterTransparency = WaterModifier:CreateSlider({
			Name = 'Water Transparency',
			Default = Terrain.WaterTransparency,
			Min = 0,
			Max = 1,
			Function = function(Val)
				db = true
				Terrain.WaterTransparency = Val
				db = false
			end
		})
		
		WaterReflectance = WaterModifier:CreateSlider({
			Name = 'Water Reflectance',
			Default = Terrain.WaterReflectance,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Function = function(Val)
				if WaterModifier.Enabled then
					db = true
					Terrain.WaterReflectance = Val
					db = false
				end
			end
		})
		
		WaterWaveSize = WaterModifier:CreateSlider({
			Name = 'Water Wave Size',
			Default = Terrain.WaterWaveSize,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Function = function(Val)
				if WaterModifier.Enabled then
					db = true
					Terrain.WaterWaveSize = Val
					db = false
				end
			end
		})
		
		WaterWaveSpeed = WaterModifier:CreateSlider({
			Name = 'Water Wave Speed',
			Default = Terrain.WaterWaveSpeed,
			Min = 0,
			Max = 100,
			Function = function(Val)
				if WaterModifier.Enabled then
					db = true
					Terrain.WaterWaveSpeed = Val
					db = false
				end
			end
		})
		
		Properties = {
			WaterColor = WaterColor,
			WaterTransparency = WaterTransparency,
			WaterReflectance = WaterReflectance,
			WaterWaveSize = WaterWaveSize,
			WaterWaveSpeed = WaterWaveSpeed
		}
	end)

	Run(function() -- Xray
		local Xray, Transparency, FilterType, Filter, Path
		
		local Modified = {}
		
		local function DescendantAdded(Part)
			if Part:IsA('BasePart') then
				if not Part.Parent then
					local TimeOut = os.clock() + 5
					repeat
						task.wait()
					until Part.Parent or os.clock() >= TimeOut or not Xray.Enabled
		
					if not Part.Parent or not Xray.Enabled then return end
				end
		
				if Part.Parent.ClassName == 'Model' and Players:GetPlayerFromCharacter(Part.Parent) then return end
		
				if FilterType.Value == 'None' or (FilterType.Value == 'Include' and not Filter:Find(Part.Name)) or (FilterType.Value == 'Exclude' and Filter:Find(Part.Name)) then
					Modified[Part] = Part.LocalTransparencyModifier
					Part.LocalTransparencyModifier = Transparency.Value
				end
			end
		end
			
		Xray = Visuals:CreateModule({
			Name = 'Xray',
			Info = 'Makes parts transparent',
			Function = function(Enabled)
				if Enabled then
					for _, Part in workspace:QueryDescendants('BasePart') do
						task.spawn(DescendantAdded, Part)
					end
					Xray:Clean(workspace.DescendantAdded:Connect(DescendantAdded))
					Xray:Clean(workspace.DescendantRemoving:Connect(function(Descendant)
						if Modified[Descendant] then
							Modified[Descendant] = nil
						end
					end))
				else
					for Part, Transparency in Modified do
						Part.LocalTransparencyModifier = Transparency
					end
					table.clear(Modified)
				end
			end,
		})
		
		Transparency = Xray:CreateSlider({
			Name = 'Transparency',
			Default = 0.5,
			Min = 0,
			Max = 1,
			Decimal = 100,
			Function = function(Val)
				for Part in Modified do
					Part.LocalTransparencyModifier = Val
				end
			end
		})
		
		Xray:CreateTextBox({
			Name = 'Path',
			Info = 'The folder/model to look through',
			PlaceholderText = '[Path]',
			Function = function(Text, Loaded)
				if Text:match('%w+') then
					local Function = loadstring(`return {Text}`)
					if typeof(Function) == 'function' then
						Path = Function() or Path
						if Loaded then return end
						if typeof(Path) == 'Instance' then
							Notify({Text = `Set Object to {GetFullName(Path)}`, Duration = 4})
						else
							Path = nil
							Notify({Text = `Expected type 'Instance' got '{typeof(Path)}'`, Duration = 6, Type = 'Error'})
						end
					elseif typeof(Function) == 'string' and not Loaded then
						Notify({Text = Function, Duration = 6, Type = 'Error'})
					end
				else
					Path = nil
				end
			end
		})
		
		FilterType = Xray:CreateDropdown({
			Name = 'Filter Type',
			List = {'None', 'Exclude', 'Include'},
			Function = function()
				if Xray.Enabled then
					Xray:Toggle(true)
					Xray:Toggle(true)
				end
			end
		})
		
		Filter = Xray:CreateTextList({
			Name = 'Filter',
			Function = function()
				for Part, Transparency in Modified do
					if (FilterType.Value == 'Include' and not Filter:Find(Part.Name)) or (FilterType.Value == 'Exclude' and Filter:Find(Part.Name)) then
						Part.LocalTransparencyModifier = Transparency
						Modified[Part] = nil
					end
				end
			end
		})
	end)
end)

Run(function() -- World
	Run(function() -- AntiVoid
		local AntiVoid, AlignMethod, Y_Position, Y_Offset, Color, Transparency, Material, MoveMethod, Power

		local Part
		local LowestY = 0

		local AlignMethods = {
			DestroyHeight = function()
				const Pos = EntityLib.Root.Position
				Part.Position = vector.create(Pos.X, (workspace.FallenPartsDestroyHeight + 10) + Y_Offset.Value, Pos.Z)
			end,
			Dynamic = function()
				if EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
					Part.Position = EntityLib.Root.Position + vector.create(0, -15, 0) + vector.create(0, Y_Offset.Value, 0)
				end
			end,
			Position = function()
				const Pos = EntityLib.Root.Position
				Part.Position = vector.create(Pos.X, Y_Position.Value, Pos.Z)
			end,
			LowestPart = function()
				const Pos = EntityLib.Root.Position
				Part.Position = vector.create(Pos.X, LowestY + Y_Offset.Value, Pos.Z)
			end
		}

		const Limbs = {
			['Head'] = true,
			-- R15
			['LowerTorso'] = true,
			['UpperTorso'] = true,
			['UpperRightArm'] = true,
			['LowerRightArm'] = true,
			['UpperLeftArm'] = true,
			['LowerLeftArm'] = true,
			['UpperRightLeg'] = true,
			['LowerRightLeg'] = true,
			['UpperLeftLeg'] = true,
			['LowerLeftLeg'] = true,
			['HumanoidRootPart'] = true,
			-- R6
			['Torso'] = true,
			['Right Arm'] = true,
			['Left Arm'] = true,
			['Right Leg'] = true,
			['Left Leg'] = true,
		}

		AntiVoid = World:CreateModule({
			Name = 'AntiVoid',
			Tooltip = 'Prevents you from falling into the void',
			Function = function(Enabled)
				if Enabled then
					for _, Part in workspace:QueryDescendants('BasePart[CanCollide = true]') do
						if Limbs[Part.Name] then continue end

						if Part.Position.Y < LowestY then
							LowestY = Part.Position.Y
						end
					end

					AntiVoid:Clean(workspace.DescendantAdded:Connect(function(Obj)
						if Obj:IsA('BasePart') and Obj.CanCollide and not Limbs[Obj.Name] and Obj.Position.Y < LowestY then
							LowestY = Obj.Position.Y
						end
					end))

					Part = Instance.new('Part')
					Part.Anchored = true
					Part.CanCollide = MoveMethod.Value == 'Collide'
					Part.CanQuery = false
					Part.AudioCanCollide = false
					Part.Color = Color.Color
					Part.Transparency = Transparency.Value
					Part.Size = vector.create(2048, 1, 2048)
					Part.Material = Enum.Material[Material.Value]
					if EntityLib.Alive then
						AlignMethods[AlignMethod.Value]()
					end
					Part.Parent = workspace

					AntiVoid:Clean(Part.Touched:Connect(function(Hit)
						if MoveMethod.Value == 'Velocity' and EntityLib.Alive and Hit.Parent == EntityLib.Character then
							const OldVel = EntityLib.Root.AssemblyLinearVelocity
							EntityLib.Root.AssemblyLinearVelocity = vector.create(OldVel.X, Power.Value, OldVel.Z)
						end
					end))

					AntiVoid:Clean(task.spawn(function()
						repeat
							if EntityLib.Alive then
								AlignMethods[AlignMethod.Value]()
							end

							task.wait(0.05)
						until not AntiVoid.Enabled
					end))
				else
					Part:Destroy()
					Part = nil
					LowestY = nil
				end
			end
		})

		AlignMethod = AntiVoid:CreateDropdown({
			Name = 'Align Method',
			List = {'DestroyHeight', 'Dynamic', 'Position', 'LowestPart'},
			Function = function(Val)
				Y_Offset:SetVisible(Val ~= 'Position')
			end
		})

		Y_Position = AlignMethod:BindSliderTo('Position', {
			Name = 'Y Position',
			Default = 0,
			Min = -100,
			Max = 100
		})

		Y_Offset = AntiVoid:CreateSlider({
			Name = 'Y Offset',
			Default = 0,
			Min = -100,
			Max = 100
		})

		MoveMethod = AntiVoid:CreateDropdown({
			Name = 'Move Method',
			List = {'Collide', 'Velocity'},
			Function = function(Val)
				if Part then
					Part.CanCollide = Val == 'Collide'
				end
			end
		})

		Color = MoveMethod:BindColorPickerTo('Collide', {
			Name = 'Color',
			Default = Color3.fromRGB(0, 255, 255),
			Function = function(Color)
				if Part then
					Part.Color = Color
				end
			end
		})

		Transparency = MoveMethod:BindTransparencySliderTo('Collide', {
			Name = 'Transparency',
			Default = 0.5,
			Function = function(Val)
				if Part then
					Part.Transparency = Val
				end
			end
		})

		local List = {'ForceField'}
		for _, v in Enum.Material:GetEnumItems() do
			if v.Name ~= 'ForceField' then
				table.insert(List, v.Name)
			end
		end

		Material = MoveMethod:BindDropdownTo('Collide', {
			Name = 'Material',
			List = List,
			Function = function(Val)
				Part.Material = Enum.Material[Val]
			end
		})

		Power = MoveMethod:BindSliderTo('Velocity', {
			Name = 'Power',
			Default = 30,
			Min = 0,
			Max = 100
		})
	end)

	Run(function() -- FastProximityPrompts
		local FastProximityPrompts, Duration, Mode, Thread
		
		local Modified = {}
		
		FastProximityPrompts = World:CreateModule({
			Name = 'FastProximityPrompts',
			Info = 'Changes how fast you interact with proximity prompts',
			Function = function(Enabled)
				if Enabled then
					if Mode.Value == 'Signal' then
						FastProximityPrompts:Clean(ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt, Player)
							if Player == Plr then
								Thread = task.delay(Prompt.HoldDuration * (Duration.Value / 100), function()
									Thread = nil
									fireproximityprompt(Prompt)
								end)
							end
						end))
						FastProximityPrompts:Clean(ProximityPromptService.PromptButtonHoldEnded:Connect(function(Prompt, Player)
							if Player == Plr and Thread then
								task.cancel(Thread)
								Thread = nil
							end
						end))
					else
						FastProximityPrompts:Clean(ProximityPromptService.PromptShown:Connect(function(Prompt)
							if not Modified[Prompt] then
								Modified[Prompt] = Prompt.HoldDuration
							end
							Prompt.HoldDuration = Modified[Prompt] * (Duration.Value / 100)
						end))
		
						FastProximityPrompts:Clean(ProximityPromptService.PromptHidden:Connect(function(Prompt)
							if Modified[Prompt] then
								Prompt.HoldDuration = Modified[Prompt]
								Modified[Prompt] = nil
							end
						end))
					end
				else
					if Thread then
						task.cancel(Thread)
						Thread = nil
					end
		
					for Prompt, OldDuration in Modified do
						Prompt.HoldDuration = OldDuration
					end
		
					table.clear(Modified)
				end
			end,
		})
		
		Mode = FastProximityPrompts:CreateDropdown({
			Name = 'Mode',
			List = {'Signal', 'Property'},
			Function = function()
				FastProximityPrompts:Restart()
			end
		})
		
		Duration = FastProximityPrompts:CreateSlider({
			Name = 'Duration',
			Default = 50,
			Min = 0,
			Max = 100,
			Suffix = '%',
			Function = function(Val)
				for Prompt, OldDuration in Modified do
					Prompt.HoldDuration = OldDuration * (Val / 100)
				end
			end
		})
	end)

	Run(function() -- Gravity
		local Gravity, Value, Method
		local OldGravity, db
		
		local Methods = {
			Velocity = {
				Function = function(Delta)
					EntityLib.Root.AssemblyLinearVelocity += vector.create(0, Delta * (workspace.Gravity - Value.Value), 0)
				end
			},
			Gravity = {
				Init = function()
					OldGravity = workspace.Gravity
					workspace.Gravity = Value.Value
					Gravity:Clean(workspace:GetPropertyChangedSignal('Gravity'):Connect(function()
						if db then return end
						db = true
						OldGravity = workspace.Gravity
						workspace.Gravity = Value.Value
						db = false
					end))
				end
			},
		}
		
		Gravity = World:CreateModule({
			Name = 'Gravity',
			Info = 'Changes the speed at which you fall',
			Function = function(Enabled)
				if Enabled then
					local CurrentMethod = Methods[Method.Value]
					if CurrentMethod.Init then
						CurrentMethod:Init()
					end

					const Function = CurrentMethod.Function
					if Function then
						Gravity:Clean(RunService.PreSimulation:Connect(function(Delta)
							if EntityLib.Alive and EntityLib.Humanoid.FloorMaterial == Enum.Material.Air then
								Function(Delta)
							end
						end))
					end
				else
					if OldGravity then
						workspace.Gravity = OldGravity
						OldGravity = nil
					end
		
					db = nil
				end
			end
		})
		
		Value = Gravity:CreateSlider({
			Name = 'Gravity',
			Default = 196.2,
			Min = 0,
			Max = 1000,
			Decimal = 10,
			Function = function(Val)
				if Gravity.Enabled and Method.Value == 'Gravity' then
					db = true
					workspace.Gravity = Val
					db = false
				end
			end
		})
		
		Method = Gravity:CreateDropdown({
			Name = 'Method',
			List = {'Velocity', 'Gravity'},
			Function = function()
				Gravity:Restart()
			end
		})
	end)

	Run(function() -- Jesus
		local Jesus
				
		local Params = RaycastParams.new()
		Params.RespectCanCollide = true
		Params.FilterType = Enum.RaycastFilterType.Include
		Params.FilterDescendantsInstances = {workspace.Terrain}

		local Part
		
		Jesus = World:CreateModule({
			Name = 'Jesus',
			Info = 'Allows you to walk on water',
			Function = function(Enabled)
				if Enabled then
					Part = Instance.new('Part')
					Part.Transparency = 1
					Part.Size = vector.create(2, 0.2, 2)
					Part.Anchored = true
					Part.CanCollide = false
					Part.CanTouch = false
					Part.CanQuery = false
					Part.AudioCanCollide = false
					Part.CastShadow = false
					Part.Parent = workspace

					Jesus:Clean(RunService.PostSimulation:Connect(function()
						if not EntityLib.Alive then return end
						local Raycast = workspace:Raycast(EntityLib.Root.Position, vector.create(0, -(EntityLib.HipHeight + 0.1), 0), Params)
						if Raycast and Raycast.Material == Enum.Material.Water then
							Part.Position = Raycast.Position
							Part.CanCollide = true
						else
							Part.CanCollide = false
						end
					end))
				else
					Part:Destroy()
					Part = nil
				end
			end
		})
	end)

	Run(function() -- Tpua
		local Tpua, Fling, Player
		
		const Limbs = {
			['Head'] = true,
			-- R15
			['LowerTorso'] = true,
			['UpperTorso'] = true,
			['UpperRightArm'] = true,
			['LowerRightArm'] = true,
			['UpperLeftArm'] = true,
			['LowerLeftArm'] = true,
			['UpperRightLeg'] = true,
			['LowerRightLeg'] = true,
			['UpperLeftLeg'] = true,
			['LowerLeftLeg'] = true,
			['HumanoidRootPart'] = true,
			-- R6
			['Torso'] = true,
			['Right Arm'] = true,
			['Left Arm'] = true,
			['Right Leg'] = true,
			['Left Leg'] = true,
		}
		
		const Movers = {}

		const function CharacterCheck(Obj)
			return Limbs[Obj.Name] or (EntityLib.Alive and Obj:IsDescendantOf(EntityLib.Character))
		end

		const function CreateBodyPosition(Obj)
			const BodyPosition = Instance.new('BodyPosition')
			BodyPosition.D = Fling.Enabled and 1 or 1250
			BodyPosition.MaxForce = vector.huge
			BodyPosition.Parent = Obj
			Movers[Obj] = BodyPosition
		end

		const function DescendantAdded(Obj)
			if Obj:IsA('BasePart') and not CharacterCheck(Obj) then
				CreateBodyPosition(Obj)
			end
		end

		const function DescendantRemoved(Obj)
			if Movers[Obj] then
				Movers[Obj]:Destroy()
				Movers[Obj] = nil
			end
		end
		
		Tpua = World:CreateModule({
			Name = 'Tpua',
			Info = 'Teleports un-anchored parts to the specified player.\nYou must have network ownership of the parts for it to work.',
			Function = function(Enabled)
				if Enabled then
					for _, Part in workspace:QueryDescendants('BasePart') do
						if CharacterCheck(Part) then continue end
						CreateBodyPosition(Part)
					end

					Tpua:Clean(workspace.DescendantAdded:Connect(DescendantAdded))
					Tpua:Clean(workspace.DescendantRemoving:Connect(DescendantRemoved))
					Tpua:Clean(RunService.PostSimulation:Connect(function()
						const Entity = EntityLib:FindEntity(Player)
						if Entity then
							for _, AlignPosition in Movers do
								AlignPosition.Position = Entity.Root.Position
							end
						end
					end))
				else
					for _, Mover in Movers do
						Mover:Destroy()
					end
					table.clear(Movers)
				end
			end
		})
		
		Tpua:CreatePlayerTextBox({
			Name = 'Target',
			PlaceholderText = '[Player Name]',
			Function = function(NewPlayer)
				Player = NewPlayer
			end
		})
		
		Fling = Tpua:CreateToggle({
			Name = 'Fling',
			Info = 'Flings people that touch the parts',
			Function = function(Enabled)
				for _, Mover in Movers do
					Mover.D = Enabled and 1 or 1250
				end
			end
		})
	end)

	Run(function() -- VehiclePhase
		local VehiclePhase
		
		local Modified = {}
		
		VehiclePhase = World:CreateModule({
			Name = 'VehiclePhase',
			Info = 'Allows the vehicle you\'re currently driving to phase through walls',
			Function = function(Enabled)
				if Enabled then
					local Vehicle
		
					local function SeatChanged()
						if EntityLib.Humanoid.SeatPart then
							Vehicle = EntityLib.Humanoid.SeatPart
							while Vehicle.Parent.ClassName == 'Model' do
								Vehicle = Vehicle.Parent
							end
						else
							Vehicle = nil
						end
					end
		
					local function LocalAdded()
						VehiclePhase:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('SeatPart'):Connect(SeatChanged))
						if EntityLib.Humanoid.SeatPart then
							SeatChanged()
						end
					end
		
					local function LocalRemoved()
						Vehicle = nil
						VehiclePhase:CleanUp()
						for Part in Modified do
							Part.CanCollide = true
						end
						table.clear(Modified)
					end
		
					VehiclePhase:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					VehiclePhase:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					VehiclePhase:Clean(RunService.PreSimulation:Connect(function()
						if Vehicle then
							for _, Part in Vehicle:QueryDescendants('BasePart[CanCollide = true]') do
								Modified[Part] = true
								Part.CanCollide = false
							end
						end
					end))
		
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					for Part in Modified do
						Part.CanCollide = true
					end
					table.clear(Modified)
				end
			end
		})
	end)
end)

Run(function() -- Other
	Run(function() -- AntiAFK
		local AntiAFK
		
		AntiAFK = Other:CreateModule({
			Name = 'AntiAFK',
			Info = 'Prevents you from getting kicked for being idle',
			Enabled = function()
				if getconnections then
					local Connections = getconnections(Plr.Idled)
					for _, Connection in Connections do
						Connection:Disable()
					end
					
					AntiAFK:Clean(function()
						for _, Connection in Connections do
							Connection:Enable()
						end
					end)
				else
					const InputManager = Instance.new('VirtualInputManager')
					AntiAFK:Clean(Plr.Idled:Connect(function()
						InputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
						InputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
					end))
				end
			end
		})
	end)

	Run(function() -- AntiFling
		local AntiFling
		
		local Modified = {}
		
		AntiFling = Other:CreateModule({
			Name = 'AntiFling',
			Info = 'Prevents you from getting flung by other players',
			Function = function(Enabled)
				if Enabled then
					AntiFling:Clean(RunService.PreSimulation:Connect(function()
						for _, Ent in EntityLib.List do
							for _, Part in Ent.Character:QueryDescendants('BasePart[CanCollide = true]') do
								Modified[Part] = true
								Part.CanCollide = false
							end
						end
					end))
				else
					for Part in Modified do
						Modified.CanCollide = true
					end
					table.clear(Modified)
				end
			end
		})
	end)

	Run(function() -- AntiKick
		local AntiKick, OldIndex, OldNamecall
		
		AntiKick = Other:CreateModule({
			Name = 'AntiKick',
			Info = 'Prevents you from getting kicked by local scripts',
			Enabled = function()
				if not hookmetamethod then NotifyPoopSploit('hookmetamethod'); return end
				if not getnamecallmethod then NotifyPoopSploit('getnamecallmethod'); return end
		
				OldIndex = hookmetamethod(game, '__index', newcclosure(function(self, Key)
					if self == Plr and Key:lower() == 'kick' then
						return error("Expected ':' not '.' calling member function Kick", 2)
					end
		
					return OldIndex(self, Key)
				end))
		
				OldNamecall = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
					if self == Plr and getnamecallmethod():lower() == 'kick' then
						return
					end
		
					return OldNamecall(self, ...)
				end))
		
				AntiKick:Clean(function()
					hookmetamethod(game, '__index', OldIndex)
					hookmetamethod(game, '__namecall', OldNamecall)
				end)
			end,
		})
	end)

	Run(function() -- AntiTeleport
		local AntiTeleport, OldIndex, OldNamecall
		
		AntiTeleport = Other:CreateModule({
			Name = 'AntiTeleport',
			Info = 'Prevents you from getting teleported by local scripts',
			Enabled = function()
				if not hookmetamethod then NotifyPoopSploit('hookmetamethod'); return end
				if not getnamecallmethod then NotifyPoopSploit('getnamecallmethod'); return end
		
				OldIndex = hookmetamethod(game, '__index', newcclosure(function(self, Key)
					if self == TeleportService then
						if Key:lower() == 'teleport' then
							return error("Expected ':' not '.' calling member function Teleport", 2)
						elseif Key == 'TeleportToPlaceInstance' then
							return error("Expected ':' not '.' calling member function TeleportToPlaceInstance", 2)
						end
					end
		
					return OldIndex(self, Key)
				end))
		
				OldNamecall = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
					if self == TeleportService then
						local Method = getnamecallmethod()
						if Method:lower() == 'teleport' or Method == 'TeleportToPlaceInstance' then
							return
						end
					end
		
					return OldNamecall(self, ...)
				end))
		
				AntiTeleport:Clean(function()
					hookmetamethod(game, '__index', OldIndex)
					hookmetamethod(game, '__namecall', OldNamecall)
				end)
			end,
		})
	end)

	Run(function() -- CameraPhase
		local CameraPhase

		const function GetQueryPointFunctions()
			if filtergc then
				return filtergc('function', {Name = 'queryPoint'})
			else
				local Items = {}
				for i, v in getgc() do
					if typeof(v) == 'function' and debug.info(v, 'n') == 'queryPoint' then
						table.insert(Items, v)
					end
				end
				return Items
			end
		end
		
		CameraPhase = Other:CreateModule({
			Name = 'CameraPhase',
			Info = 'Allows your camera to phase through walls',
			Enabled = function()
				if debug.setconstant and debug.getconstants and getgc then
					local Functions = GetQueryPointFunctions()
					for _, Function in Functions do
						if debug.info(Function, 's'):find('ZoomController%.Popper') then
							for i, c in debug.getconstants(Function) do
								if c == 0.25 then
									debug.setconstant(Function, i, 0)
									CameraPhase:Clean(debug.setconstant, Function, i, 0.25)
									break
								end
							end
							break
						end
					end
				else
					Notify({
						Text = 'Your executor doesn\'t support debug library/getgc, Using Invisicam instead.',
						Duration = 5,
						Type = 'Warning'
					})
		
					local Old = Plr.DevCameraOcclusionMode
					CameraPhase:Clean(function()
						Plr.DevCameraOcclusionMode = Old
					end)
		
					Plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
				end
			end
		})
	end)

	Run(function() -- Freecam
		local Freecam, Speed, ShiftMultiplier, Sensitivity, CameraLimits
		
		local OldCameraType, OldMouseBehavior, OldMouseIconEnabled
		local Yaw: number, Pitch: number
		local ActionName
		
		const Keyboard = {
			W = 0,
			A = 0,
			S = 0,
			D = 0,
			E = 0,
			Q = 0,
			LeftShift = 0,
			Space = 0
		}
		
		const half_pi = math.pi / 2
		
		const function KeyPress(_, State, Input)
			Keyboard[Input.KeyCode.Name] = State == Enum.UserInputState.Begin and 1 or 0
		end
		
		const function MouseMove(_, State, Input)
			if State ~= Enum.UserInputState.Change then return end
			local Delta = Input.Delta
			local Sens = Sensitivity.Value / 240
		
			Yaw -= Delta.X * Sens
			Pitch -= Delta.Y * Sens
		
			if CameraLimits.Enabled then
				Pitch = math.clamp(Pitch, -half_pi, half_pi)
			end
		end
		
		const function StepCamera(Delta)
			if UIS.MouseBehavior == Enum.MouseBehavior.Default and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				OldMouseBehavior = UIS.MouseBehavior
				UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
			end
		
			local Direction = vector.create(Keyboard.D - Keyboard.A, 0, Keyboard.S - Keyboard.W)
			if Direction ~= vector.zero then
				Direction = vector.normalize(Direction)
			end
		
			Direction = vector.create(Direction.X, Keyboard.E - Keyboard.Q, Direction.Z) * Speed.Value
			if Keyboard.LeftShift == 1 then
				Direction *= ShiftMultiplier.Value
			end
		
			local Rotation = CFrame.Angles(0, Yaw, 0) * CFrame.Angles(Pitch, 0, 0)
			local Step = Rotation:VectorToWorldSpace(Direction) * 50 * Delta
		
			Camera.CFrame = CFrame.new(Camera.CFrame.Position + Step) * Rotation
		end
		
		Freecam = Other:CreateModule({
			Name = 'Freecam',
			Function = function(Enabled)
				if Enabled then
					Yaw, Pitch = 0, 0
		
					local MouseBehavior = UIS.MouseBehavior == Enum.MouseBehavior.Default and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and UIS.MouseBehavior or nil
		
					OldCameraType = Camera.CameraType
					OldMouseBehavior = MouseBehavior
					OldMouseIconEnabled = UIS.MouseIconEnabled
		
					Camera.CameraType = Enum.CameraType.Scriptable
					if MouseBehavior then
						UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
					end
					UIS.MouseIconEnabled = false
		
					local db = false
					local db2 = false
		
					Freecam:Clean(Camera:GetPropertyChangedSignal('CameraType'):Connect(function()
						if db then return end
						db = true
						OldCameraType = Camera.CameraType
						Camera.CameraType = Enum.CameraType.Scriptable
						db = false
					end))
		
					Freecam:Clean(UIS:GetPropertyChangedSignal('MouseEnabled'):Connect(function()
						if db2 then return end
						db2 = true
						OldMouseIconEnabled = UIS.MouseIconEnabled
						UIS.MouseIconEnabled = false
						db2 = false
					end))
		
					Yaw = select(2, Camera.CFrame:ToOrientation())
					Pitch = CameraLimits.Enabled and math.asin(math.clamp(Camera.CFrame.LookVector.Y, -1, 1)) or Camera.CFrame.LookVector.Y
		
					ActionName = HttpService:GenerateGUID(false)
		
					RunService:BindToRenderStep(`FreecamRenderStepped_{ActionName}`, 200, StepCamera)
					ContextActionService:BindActionAtPriority(`FreecamKeyboard_{ActionName}`, KeyPress, false, 69420,
						Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
						Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.LeftShift, Enum.KeyCode.Space
					)
		
					ContextActionService:BindActionAtPriority(`FreecamMouse_{ActionName}`, MouseMove, false, 69420, Enum.UserInputType.MouseMovement)
		
					for Key in Keyboard do
						Key = Enum.KeyCode[Key]
						if UIS:IsKeyDown(Key) then
							KeyPress(nil, Enum.UserInputState.Begin, {KeyCode = Key})
						end
					end
				else
					Yaw, Pitch = nil, nil
		
					Camera.CameraType = OldCameraType
					UIS.MouseIconEnabled = OldMouseIconEnabled
		
					if OldMouseBehavior then
						UIS.MouseBehavior = OldMouseBehavior
						OldMouseBehavior = nil
					end
		
					OldCameraType, OldMouseIconEnabled = nil, nil
		
					for Key in Keyboard do
						Keyboard[Key] = 0
					end
		
					ContextActionService:UnbindAction(`FreecamKeyboard_{ActionName}`)
					ContextActionService:UnbindAction(`FreecamMouse_{ActionName}`)
					RunService:UnbindFromRenderStep(`FreecamRenderStepped_{ActionName}`)
					ActionName = nil
				end
			end
		})
		
		Speed = Freecam:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 0,
			Max = 10,
		})
		
		ShiftMultiplier = Freecam:CreateSlider({
			Name = 'Shift Multiplier',
			Default = 2,
			Min = 0,
			Max = 10,
		})
		
		Sensitivity = Freecam:CreateSlider({
			Name = 'Sensitivity',
			Default = 1,
			Min = 0.1,
			Max = 3,
			Decimal = 0.1
		})
		
		CameraLimits = Freecam:CreateToggle({
			Name = 'Camera Limits',
			Info = 'Limits the max angle you can look up/down',
			Default = true
		})
	end)

	Run(function() -- Freelook
		local Freelook, ResetCamera

		local ControlModule

		Freelook = Other:CreateModule({
			Name = 'Freelook',
			Tooltip = 'Allows your camera to rotate freely while keeping your original move direction',
			Function = function(Enabled)
				if Enabled then
					if not ControlModule then
						ControlModule = require(Plr.PlayerScripts.PlayerModule.ControlModule)
					end

					local LookCFrame = EntityLib.Alive and EntityLib.Root.CFrame or vector.zero
					local OldCFrame = Camera.CFrame

					local Old = ControlModule.calculateRawMoveVector
					function ControlModule:calculateRawMoveVector(Humanoid, MoveVector)
						if MoveVector ~= vector.zero then
							return LookCFrame:VectorToWorldSpace(MoveVector)
						end

						return vector.zero
					end

					Freelook:Clean(EntityLib.Events.LocalAdded:Connect(function()
						LookCFrame = EntityLib.Root.CFrame
					end))

					Freelook:Clean(function()
						if ResetCamera.Enabled then
							Camera.CFrame = OldCFrame
						end
						ControlModule.calculateRawMoveVector = Old
					end)
				end
			end
		})

		ResetCamera = Freelook:CreateToggle({
			Name = 'Reset Camera',
			Tooltip = 'Resets your camera\'s orientation after disabling Freelook.',
			Default = true
		})
	end)

	Run(function() -- GameplayPausedDisabler
		Other:CreateModule({
			Name = 'GameplayPausedDisabler',
			Info = 'Removes the gameplay paused popup',
			Function = function(Enabled)
				GuiService:SetGameplayPausedNotificationEnabled(not Enabled)
			end
		})
	end)

	Run(function() -- Panic
		Other:CreateButton({
			Name = 'Panic',
			Info = 'Disables all the currently enabled modules',
			Function = function()
				for _, v in Modules do
					if v.Enabled then
						v:Toggle(true)
					end
				end
			end,
		})
	end)

	Run(function() -- PartPath
		local PartPath
		
		PartPath = Other:CreateModule({
			Name = 'Part Path',
			Info = 'Copies the path of parts you click on',
			Enabled = function()
				if not setclipboard then
					NotifyPoopSploit('setclipboard')
					PartPath:Toggle(true)
					return
				end
		
				PartPath:Clean(UIS.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and CanClick() then
						local MouseLocation = GetMouseLocation()
						local MouseRaycast = Camera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
						local Raycast = workspace:Raycast(MouseRaycast.Origin, MouseRaycast.Direction * 1000)
						if Raycast then
							local FullName = GetFullName(Raycast.Instance)
							setclipboard(FullName)
		
							Notify({
								Text = 'Copied path to Clipboard',
								Duration = 3
							})
						end
					end
				end))
			end
		})
	end)

	Run(function() -- Rejoin
		Other:CreateButton({
			Name = 'Rejoin',
			Function = function()
				if #Players:GetPlayers() > 1 then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
				else
					TeleportService:Teleport(game.PlaceId)
				end
			end
		})
	end)

	Run(function() -- ServerHop
		local ServerHop, SortOrder
		
		local Cache
		local CacheExpireTime = 0
		local Attempted = {}
		
		local function ServerHopFunction(Cursor)
			local Success, Data = pcall(function()
				return os.time() < CacheExpireTime and Cache or game:HttpGet(`https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder={SortOrder.Value == 'Ascending' and 1 or 2}&excludeFullGames=true&limit=100{Cursor and `&cursor={Cursor}` or ''}`)
			end)
		
			local Body = Success and HttpService:JSONDecode(Data) or nil
		
			if Body and Body.data then
				for _, v in Body.data do
					if tonumber(v.playing) < Players.MaxPlayers and v.id ~= game.JobId and not table.find(Attempted, v.id) then
						Cache, CacheExpireTime = Data, os.time()
		
						table.insert(Attempted, v.id)
						TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
						return
					end
				end
		
				if Body.nextPageCursor then
					ServerHopFunction(Body.nextPageCursor)
				else
					Notify({
						Text = 'Failed to find any servers',
						Duration = 5,
						Type = 'Error'
					})
				end
			else
				Notify({
					Text = 'Failed to grab servers',
					Duration = 5,
					Type = 'Error'
				})
			end
		end
		
		ServerHop = Other:CreateButton({
			Name = 'Server Hop',
			Function = function()
				ServerHopFunction()
			end
		})
		
		SortOrder = ServerHop:CreateDropdown({
			Name = 'Sort Order',
			List = {'Descending', 'Ascending'},
			Info = 'Descending - Prefers full servers\nAscending - Prefers empty servers'
		})
	end)

	Run(function() -- ShiftLock
		local ShiftLock, Keybinds
		
		local Old
		local OldKeys
		local BoundKeys
		
		local function GrabBoundKeys()
			local PlayerScripts = Plr:FindFirstChildOfClass('PlayerScripts')
			local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild('PlayerModule')
			local CameraModule = PlayerModule and PlayerModule:FindFirstChild('CameraModule')
			local MouseLockController = CameraModule and CameraModule:FindFirstChild('MouseLockController')
			BoundKeys = MouseLockController and MouseLockController:FindFirstChild('BoundKeys')
		end
		
		ShiftLock = Other:CreateModule({
			Name = 'ShiftLock',
			Info = 'Force enables the option to toggle shift lock',
			Function = function(Enabled)
				if Enabled then
					if BoundKeys then
						OldKeys = BoundKeys.Value
						BoundKeys.Value = table.concat(Keybinds.Enabled, ',')
					end
					Old = Plr.DevEnableMouseLock
					Plr.DevEnableMouseLock = true
				else
					if BoundKeys and OldKeys then
						BoundKeys.Value = OldKeys
						OldKeys = nil
					end
					Plr.DevEnableMouseLock = Old
					Old = nil
				end
			end,
		})
		
		GrabBoundKeys()
		
		Keybinds = ShiftLock:CreateTextList({
			Name = 'Keybinds',
			List = BoundKeys and BoundKeys.Value:split(',') or {'LeftShift', 'RightShift'},
			Function = function(Enabled)
				if ShiftLock.Enabled then
					if not BoundKeys then
						GrabBoundKeys()
					end
		
					if BoundKeys then
						if not OldKeys then
							OldKeys = BoundKeys.Value
						end
						BoundKeys.Value = table.concat(Enabled, ',')
					end
				end
			end
		})
	end)

	Run(function() -- View
		local View, TextBox, Player
		
		local function PlayerAdded(NewPlayer)
			if TextBox:CheckPlayer(NewPlayer) then
				Player = NewPlayer
			end
		end
		
		local function PlayerRemoved(PlayerRemoving)
			if PlayerRemoving == Player then
				Notify({
					Text = 'View has been disabled becuase the player left',
					Duration = 10
				})
		
				Player = nil
				View:Toggle(true)
			end
		end
		
		View = Other:CreateModule({
			Name = 'View',
			Info = 'Views the specified player',
			Function = function(Enabled)
				if Enabled then
					TextBox:Refresh()
		
					local Ent = Player and EntityLib:FindEntity(Player) or nil
		
					local function CharacterAdded(Char)
						if Char.Player and Char.Player == Player then
							Camera.CameraSubject = Char.Humanoid
						end
					end
		
					local function CharacterRemoved(Char)
						if Char.Player and Char.Player == Player and EntityLib.Alive then
							Camera.CameraSubject = EntityLib.Humanoid
						end
					end
		
					View:Clean(Camera:GetPropertyChangedSignal('CameraSubject'):Connect(function()
						if Ent then
							Camera.CameraSubject = Ent.Humanoid
						end
					end))
		
					if Ent then
						Camera.CameraSubject = Ent.Humanoid
					end
		
					View:Clean(EntityLib.Events.EntityAdded:Connect(CharacterAdded))
					View:Clean(EntityLib.Events.EntityRemoved:Connect(CharacterRemoved))
					View:Clean(Players.PlayerAdded:Connect(PlayerAdded))
					View:Clean(Players.PlayerRemoving:Connect(PlayerRemoved))
				else
					if EntityLib.Alive then
						Camera.CameraSubject = EntityLib.Humanoid
					end
				end
			end
		})
		
		TextBox = View:CreatePlayerTextBox({
			Name = 'Target',
			Placeholder = '[Player Name]',
			Function = function(NewPlayer)
				Player = NewPlayer
			end
		})
	end)

	Run(function() -- Zoom
		local Zoom, ZoomSpeed, ZoomFactor, AllowScrolling, ScrollSpeed, SensitivityFactor, IgnoreThirdPerson, Keybind
		
		local OldFov: number, OldSensitivity: number
		local Con, ActionName, db, db2, Zoomed
		
		local function ScrollFunction(_, _, Input)
			if UIS:GetFocusedTextBox() or not AllowScrolling.Enabled then return end
			if Zoomed then
				if Con then
					Con:Disconnect()
				end
				local Start = Camera.FieldOfView
				local Goal = math.min(Start - (Input.Position.Z * ScrollSpeed.Value * (Start / 12)), 120)
				local Alpha = 0
		
				db, db2 = true, true
				Modules.FovChanger:Disable()
		
				Con = RunService.PreRender:Connect(function(Delta)
					Alpha = math.min(Alpha + Delta * 2.5, 1)
					local Value = TweenService:GetValue(Alpha, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
					Camera.FieldOfView = math.lerp(Start, Goal, Value)
					UIS.MouseDeltaSensitivity = math.min((Camera.FieldOfView / OldFov) * SensitivityFactor.Value, OldSensitivity)
		
					if Value >= 1 then
						Con:Disconnect()
						Con = nil
						task.wait()
						db, db2 = false, false
						Modules.FovChanger:Enable()
					end
				end)
			end
		end
		
		Zoom = Other:CreateModule({
			Name = 'Zoom',
			Info = 'Zooms in your camera when pressing your binded key',
			Function = function(Enabled)
				if Enabled then
					OldFov = Camera.FieldOfView
					OldSensitivity = UIS.MouseDeltaSensitivity

					ActionName = HttpService:GenerateGUID(false)
		
					Zoom:Clean(UIS:GetPropertyChangedSignal('MouseDeltaSensitivity'):Connect(function()
						if db2 then return end
						OldSensitivity = UIS.MouseDeltaSensitivity
					end))
		
					Zoom:Clean(Camera:GetPropertyChangedSignal('FieldOfView'):Connect(function()
						if db then return end
						db = true
						OldFov = Camera.FieldOfView
		
						if Zoomed then
							Modules.FovChanger:Disable()
							Camera.FieldOfView = OldFov * (1 / ZoomFactor.Value)
							UIS.MouseDeltaSensitivity = math.min((Camera.FieldOfView / OldFov) * SensitivityFactor.Value, OldSensitivity)
							Modules.FovChanger:Enable()
						end
		
						db = false
					end))
					
					Zoom:Clean(UIS.InputBegan:Connect(function(Input)
						if UIS:GetFocusedTextBox() or (IgnoreThirdPerson.Enabled and IsThirdPerson()) then return end
						if Keybind:Check(Input) then
							if Con then
								Con:Disconnect()
							end
		
							local Alpha = 0
		
							db, db2 = true, true
							Modules.FovChanger:Disable()
		
							Con = RunService.PreRender:Connect(function(Delta)
								Alpha = math.min(Alpha + (Delta * ZoomSpeed.Value), 1)
								local Value = TweenService:GetValue(Alpha, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
								Camera.FieldOfView = math.lerp(OldFov, OldFov * (1 / ZoomFactor.Value), Value)
								UIS.MouseDeltaSensitivity = math.min((Camera.FieldOfView / OldFov) * SensitivityFactor.Value, OldSensitivity)
		
								if Value >= 1 then
									Con:Disconnect()
									Con = nil
									Zoomed = true
									ContextActionService:BindActionAtPriority(`ZoomScroll_{ActionName}`, ScrollFunction, false, 69420, Enum.UserInputType.MouseWheel)
									task.wait()
									db, db2 = false, false
									Modules.FovChanger:Enable()
								end
							end)
						end
					end))
		
					Zoom:Clean(UIS.InputEnded:Connect(function(Input)
						if Keybind:Check(Input) and (Con or Zoomed) then
							if Con then
								Con:Disconnect()
							end
							
							Zoomed = false
							ContextActionService:UnbindAction(`ZoomScroll_{ActionName}`)
		
							local Start = Camera.FieldOfView
							local Alpha = 0
		
							db, db2 = true, true
							Modules.FovChanger:Disable()
							
							Con = RunService.PreRender:Connect(function(Delta)
								Alpha = math.min(Alpha + (Delta * ZoomSpeed.Value), 1)
								local Value = TweenService:GetValue(Alpha, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
								Camera.FieldOfView = math.lerp(Start, OldFov, Value)
								UIS.MouseDeltaSensitivity = math.min((Camera.FieldOfView / OldFov) * SensitivityFactor.Value, OldSensitivity)
		
								if Value >= 1 then
									db, db2 = false, false
									Modules.FovChanger:Enable()
									Con:Disconnect()
									Con = nil
								end
							end)
						end
					end))
				else
					if Con then
						Con:Disconnect()
						Con = nil
					end
					Modules.FovChanger:Disable()
					Camera.FieldOfView = OldFov
					UIS.MouseDeltaSensitivity = OldSensitivity
					ContextActionService:UnbindAction(`ZoomScroll_{ActionName}`)
					Modules.FovChanger:Enable()
				end
			end
		})
		
		ZoomSpeed = Zoom:CreateSlider({
			Name = 'Zoom Speed',
			Default = 2.5,
			Min = 1,
			Max = 5,
			Decimal = 10
		})
		
		ZoomFactor = Zoom:CreateSlider({
			Name = 'Zoom Factor',
			Default = 2,
			Min = 1,
			Max = 5,
			Decimal = 10
		})
		
		AllowScrolling = Zoom:CreateToggle({
			Name = 'Allow Scrolling',
			Info = 'Allows you to scroll to change the zoom factor',
			Default = true
		})
		
		ScrollSpeed = AllowScrolling:CreateSlider({
			Name = 'Scroll Speed',
			Default = 2,
			Min = 1,
			Max = 5
		})
		
		SensitivityFactor = Zoom:CreateSlider({
			Name = 'Sensitivity Factor',
			Default = 1,
			Min = 0.5,
			Max = 2,
			Decimal = 10
		})
		
		IgnoreThirdPerson = Zoom:CreateToggle({
			Name = 'Ignore Third Person',
			Default = true
		})
		
		Keybind = Zoom:CreateKeybind({
			Name = 'Zoom',
			Keybind = 'C'
		})
	end)

	Run(function()
		local AdminCommands, Command

		AdminCommands = Other:CreateButton({
			Name = 'AdminCommands',
			Tooltip = 'Runs Commands to other TidalWave users even if they don\'t have chat.',
			Function = function()
				local Val = Command.Value
				if not Val:match(';') then
					Val = ';' .. Val
				end

				TidalWave.Libraries.Whitelist.Socket:Send(Val)
			end
		})

		Command = AdminCommands:CreateTextBox({
			Name = 'Command',
			PlaceholderText = '[Command][Targets][Args]'
		})
	end)
end)

Run(function() -- Animations
	Run(function() -- AnimationSpeed
		local AnimationSpeed, Speed, UseMulti, Multi
		
		local Tracks = {}
		local db = {}
		
		const function CalculateSpeed(Track)
			return UseMulti.Enabled and (Tracks[Track] * Multi.Value) or Speed.Value
		end
		
		const function AnimationPlayed(Track: AnimationTrack)
			if not Tracks[Track] then
				Tracks[Track] = Track.Speed
			end
			Track:AdjustSpeed(CalculateSpeed(Track))
		end
		
		const function LocalRemoved()
			table.clear(Tracks)
			table.clear(db)
			AnimationSpeed:CleanUp()
		end
		
		const function LocalAdded()
			AnimationSpeed:Clean(EntityLib.Humanoid.AnimationPlayed:Connect(AnimationPlayed))
			for _, Track in EntityLib.Humanoid:GetPlayingAnimationTracks() do
				AnimationPlayed(Track)
			end
		end
		
		AnimationSpeed = Animations:CreateModule({
			Name = 'AnimationSpeed',
			Info = 'Sets the speed of all your currently playing animations',
			Function = function(Enabled)
				if Enabled then
					AnimationSpeed:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					AnimationSpeed:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					AnimationSpeed:Clean(RunService.PreAnimation:Connect(function()
						for Track in Tracks do
							Track:AdjustSpeed(CalculateSpeed(Track))
						end
					end))
					
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					for Track, OldSpeed in Tracks do
						Track:AdjustSpeed(OldSpeed)
					end
					table.clear(Tracks)
					table.clear(db)
				end
			end,
		})
		
		Speed = AnimationSpeed:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 0,
			Max = 3,
			Decimal = 10,
			Function = function(Val)
				if AnimationSpeed.Enabled and not UseMulti.Enabled then
					for Track in Tracks do
						db[Track] = true
						local Speed = CalculateSpeed(Track)
						Track:AdjustSpeed(Speed)
						db[Track] = nil
					end
				end
			end
		})
		
		UseMulti = AnimationSpeed:CreateToggle({
			Name = 'Use Multi',
			Info = 'Multiplies the speed of all your animations rather than just setting it',
		})
		
		Multi = UseMulti:CreateSlider({
			Name = 'Multi',
			Default = 1,
			Min = 0,
			Max = 3,
			Decimal = 10,
			Function = function(Val)
				if AnimationSpeed.Enabled and UseMulti.Enabled then
					for Track in Tracks do
						db[Track] = true
						local Speed = CalculateSpeed(Track)
						Track:AdjustSpeed(Speed)
						db[Track] = nil
					end
				end
			end
		})
	end)

	function Animations:CreatePlayerTargetModule(Properties)
		local Module, TargetTextBox

		const Data = {
			Player = nil,
			Entity = nil
		}
		
		const function PlayerAdded(NewPlayer)
			if TargetTextBox:CheckPlayer(NewPlayer) then
				Data.Player = NewPlayer
			end
		end
		
		const function PlayerRemoved(PlayerRemoving)
			if PlayerRemoving == Data.Player then
				Notify({
					Title = Properties.Name,
					Text = Properties.Name ..  ' has been disabled because the player left',
					Type = 'Warning',
					Duration = 10
				})
		
				Module:Toggle(true)
				Data.Player = nil
			end
		end

		const function EntityAdded(Entity)
			if Entity.Player and Data.Player and Entity.Player == Data.Player then
				Data.Entity = Entity
			end
		end

		const function EntityRemoved(Entity)
			if Entity.Player and Data.Player and Entity.Player == Data.Player then
				Data.Entity = nil
			end
		end

		Module = Animations:CreateModule({
			Name = Properties.Name,
			Tooltip = Properties.Tooltip,
			Enabled = Properties.Enabled,
			Function = function(Enabled)
				if Enabled then
					TargetTextBox:Refresh()

					Module:Clean(Players.PlayerAdded:Connect(PlayerAdded))
					Module:Clean(Players.PlayerRemoving:Connect(PlayerRemoved))
					Module:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
					Module:Clean(EntityLib.Events.EntityRemoved:Connect(EntityRemoved))
				end

				Properties.Function(Enabled)
			end,
		})

		TargetTextBox = Module:CreatePlayerTextBox({
			Name = 'Target',
			Placeholder = '[Player Name]',
			Function = function(SelectedPlayer)
				Data.Player = SelectedPlayer
				Data.Entity = Data.Player and EntityLib:FindEntity(Data.Player) or nil
			end
		})

		return Module, Data
	end

	Run(function() -- Bang
		local Bang, Data, Speed

		const Offset = CFrame.new(0, 0, 1.1)
		const Animation = Instance.new('Animation')

		local Track
		
		const function LocalAdded()
			if EntityLib.Animator then
				Animation.AnimationId = EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R15 and 'rbxassetid://5918726674' or 'rbxassetid://148840371'
				Track = EntityLib.Animator:LoadAnimation(Animation)
				Track.Looped = true
				Track.Priority = Enum.AnimationPriority.Action4
				Track:Play(0, 1, Speed.Value * 3)
			else
				Notify({
					Title = 'Bang',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end

		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end

		const function UpdateCharacter()
			if EntityLib.Alive and Data.Entity then
				EntityLib.Root.CFrame = Data.Entity.Root.CFrame * Offset
				EntityLib.Root.AssemblyLinearVelocity = vector.zero
			end
		end
		
		Bang, Data = Animations:CreatePlayerTargetModule({
			Name = 'Bang',
			Tooltip = 'Bangs the specified player.',
			Function = function(Enabled)
				if Enabled then
					Bang:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Bang:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Bang:Clean(RunService.PreSimulation:Connect(UpdateCharacter))
					Bang:Clean(RunService.PostSimulation:Connect(UpdateCharacter))

					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end
		})

		Speed = Bang:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 0,
			Max = 3,
			Decimal = 100,
			Function = function(Val)
				if Track then
					Track:AdjustSpeed(Val * 3)
				end
			end
		})
	end)

	Run(function() -- BendOver
		local BendOver, Data

		const Offset = CFrame.new(0.4, 0, -2.1) * CFrame.Angles(0, math.rad(14), 0)

		const Animation = Instance.new('Animation')
		Animation.AnimationId = 'rbxassetid://10214311282'

		local Track
		
		const function LocalAdded()
			if EntityLib.Animator then
				if EntityLib.RigType == Enum.HumanoidRigType.R15 then
					Track = EntityLib.Animator:LoadAnimation(Animation)
					Track.Priority = Enum.AnimationPriority.Action4
					Track:Play(0.1, 1, 1)
					Track.TimePosition = 4
					Track:AdjustSpeed(0)
				else
					Notify({
						Title = 'BendOver',
						Text = 'BendOver only works on R15',
						Type = 'Error',
						Duration = 10
					})
			
					BendOver:Toggle(true)
				end
			else
				Notify({
					Title = 'BendOver',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end

		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end

		const function UpdateCharacter()
			if EntityLib.Alive and Data.Entity then
				EntityLib.Root.AssemblyLinearVelocity = vector.zero
				EntityLib.Root.CFrame = Data.Entity.Root.CFrame * Offset
			end
		end

		BendOver, Data = Animations:CreatePlayerTargetModule({
			Name = 'BendOver',
			Tooltip = 'Makes you bend over in front of the specified player.',
			Function = function(Enabled)
				if Enabled then
					BendOver:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					BendOver:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					BendOver:Clean(RunService.PreSimulation:Connect(UpdateCharacter))
					BendOver:Clean(RunService.PostSimulation:Connect(UpdateCharacter))

					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end
		})
	end)

	Run(function() -- Carpet
		local Carpet, Data

		const Animation = Instance.new('Animation')
		Animation.AnimationId = 'rbxassetid://282574440'

		const AngleOffset = CFrame.Angles(math.rad(-90), 0, 0)

		local Track

		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end
		
		const function LocalAdded()
			if EntityLib.Animator then
				if EntityLib.RigType == Enum.HumanoidRigType.R6 then
					Track = EntityLib.Animator:LoadAnimation(Animation)
					Track.Priority = Enum.AnimationPriority.Action4
					Track.Looped = true
					Track:Play(0, 1, 1)
				end
			else
				Notify({
					Title = 'Carpet',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end

		const function UpdateCharacter()
			if EntityLib.Alive and Data.Entity then
				if EntityLib.RigType == Enum.HumanoidRigType.R15 then
					EntityLib.Root.CFrame = Data.Entity.Root.CFrame:ToWorldSpace(AngleOffset + vector.create(0, -EntityLib.HipHeight, 0))
					EntityLib.Root.AssemblyLinearVelocity = vector.zero
					EntityLib.Root.AssemblyAngularVelocity = vector.zero
				else
					EntityLib.Root.CFrame = Data.Entity.Root.CFrame
					EntityLib.Root.AssemblyLinearVelocity = vector.zero
				end
			end
		end

		Carpet, Data = Animations:CreatePlayerTargetModule({
			Name = 'Carpet',
			Tooltip = 'You become the specified player\'s carpet.',
			Function = function(Enabled)
				if Enabled then
					Carpet:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Carpet:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Carpet:Clean(RunService.PreSimulation:Connect(UpdateCharacter))
					Carpet:Clean(RunService.PostSimulation:Connect(UpdateCharacter))

					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end
		})
	end)

	Run(function() -- Dance
		local Dance, Track, R15Dance, R6Dance
		
		const R6Dances = {
			['Dance'] = 'rbxassetid://27789359',
			['Moonwalk'] = 'rbxassetid://30196114',
			['Dance Like There\'s no Tomorrow'] = 'rbxassetid://248263260',
			['Disco'] = 'rbxassetid://45834924',
			['Party'] = 'rbxassetid://33796059',
			['Goal'] = 'rbxassetid://28488254',
			['Flute Dance'] = 'rbxassetid://52155728'
		}
		
		const R15Dances = {
			['River Dance'] = 'rbxassetid://3333432454',
			['Keeping Time'] = 'rbxassetid://4555808220',
			['Line Dance'] = 'rbxassetid://4049037604',
			['Air Dance'] = 'rbxassetid://4555782893',
			['Break Dance'] = 'rbxassetid://10214311282',
			['Reflex'] = 'rbxassetid://10714010337',
			['Around Town'] = 'rbxassetid://10713981723',
			['Idol Face'] = 'rbxassetid://10714372526',
			['Fancy Feet'] = 'rbxassetid://10714076981',
			['Robot'] = 'rbxassetid://10714392151',
			['Still Standing'] = 'rbxassetid://11444443576'
		}
		
		const Animation = Instance.new('Animation')
		
		const function LocalAdded()
			if EntityLib.Animator then
				Animation.AnimationId = EntityLib.RigType == Enum.HumanoidRigType.R15 and R15Dances[R15Dance.Value] or R6Dances[R6Dance.Value]
		
				Track = EntityLib.Animator:LoadAnimation(Animation)
				Track.Priority = Enum.AnimationPriority.Action4
				Track.Looped = true
				Track:Play(0, 1, 1)
			else
				Notify({
					Title = 'Dance',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end
		
		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end
		
		Dance = Animations:CreateModule({
			Name = 'Dance',
			Info = 'It makes you dance',
			Function = function(Enabled)
				if Enabled then
					Dance:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Dance:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end,
		})
		
		local R6List = {}
		
		for i, v in R6Dances do
			table.insert(R6List, i)
		end
		
		R6Dance = Dance:CreateDropdown({
			Name = 'R6 Dance',
			List = R6List,
			Function = function(Val)
				if Dance.Enabled and EntityLib.Alive and EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R6 then
					LocalRemoved()
					Animation.AnimationId = R6Dances[R6Dance.Value]
					LocalAdded()
				end
			end
		})
		
		local R15List = {}
		
		for i, v in R15Dances do
			table.insert(R15List, i)
		end
		
		R15Dance = Dance:CreateDropdown({
			Name = 'R15 Dance',
			List = R15List,
			Function = function(Val)
				if Dance.Enabled and EntityLib.Alive and EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R15 then
					LocalRemoved()
					Animation.AnimationId = R15Dances[Val]
					LocalAdded()
				end
			end
		})
	end)

	Run(function() -- HeadSit
		local HeadSit, Data
		
		const HeadOffset = CFrame.new(0, 1.6, 0.4)

		const function LocalRemoved()
			HeadSit:CleanUp()
		end
		
		const function LocalAdded()
			EntityLib.Humanoid.Sit = true
			HeadSit:Clean(EntityLib.Humanoid:GetPropertyChangedSignal('Sit'):Once(function()
				HeadSit:Toggle(true)
			end))
		end
		
		const function UpdateCharacter()
			if EntityLib.Alive and Data.Entity then
				EntityLib.Root.CFrame = Data.Entity.Root.CFrame:ToWorldSpace(HeadOffset)
				EntityLib.Root.AssemblyLinearVelocity = vector.zero
			end
		end

		HeadSit, Data = Animations:CreatePlayerTargetModule({
			Name = 'HeadSit',
			Tooltip = 'Sits on the specified player\'s head.',
			Function = function(Enabled)
				if Enabled then
					HeadSit:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					HeadSit:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					HeadSit:Clean(RunService.PreSimulation:Connect(UpdateCharacter))
					HeadSit:Clean(RunService.PostSimulation:Connect(UpdateCharacter))

					if EntityLib.Alive then
						LocalAdded()
					end
				end
			end
		})
	end)

	Run(function() -- HeadThrow
		local HeadThrow, Speed, Track
		
		const Animation = Instance.new('Animation')
		Animation.AnimationId = 'rbxassetid://35154961'
		
		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end
		
		const function LocalAdded()
			if EntityLib.Animator then
				if EntityLib.Humanoid.RigType == Enum.HumanoidRigType.R6 then
					Track = EntityLib.Animator:LoadAnimation(Animation)
					Track.Priority = Enum.AnimationPriority.Action4
					Track.Looped = true
					Track:Play(0, 1, Speed.Value)
				else
					Notify({
						Title = 'HeadThrow',
						Text = 'HeadThrow only works on R6',
						Type = 'Error',
						Duration = 10
					})
					
					HeadThrow:Toggle(true)
				end
			else
				Notify({
					Title = 'HeadThrow',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end
		
		HeadThrow = Animations:CreateModule({
			Name = 'HeadThrow',
			Function = function(Enabled)
				if Enabled then
					HeadThrow:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					HeadThrow:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
		
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end,
		})
		
		Speed = HeadThrow:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 0,
			Max = 10,
			Function = function(Val)
				if Track then
					Track:AdjustSpeed(Val)
				end
			end
		})
	end)

	Run(function() -- Jerk
		local Jerk, Speed, Track
		
		const Animation = Instance.new('Animation')
		
		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end
		
		const function LocalAdded()
			if EntityLib.Animator then
				Animation.AnimationId = EntityLib.RigType == Enum.HumanoidRigType.R15 and 'rbxassetid://698251653' or 'rbxassetid://72042024'
		
				Track = EntityLib.Animator:LoadAnimation(Animation)
				Track.Priority = Enum.AnimationPriority.Action4
				Track:Play(0, 1, Speed.Value * 0.7)
				Track.TimePosition = 0.6
			else
				Notify({
					Title = 'Jerk',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end
		
		Jerk = Animations:CreateModule({
			Name = 'Jerk',
			Info = 'Makes you absolutely jork it',
			Function = function(Enabled)
				if Enabled then
					Jerk:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Jerk:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					Jerk:Clean(RunService.PreRender:Connect(function()
						if EntityLib.Alive and Track and Track.TimePosition >= 0.7 then
							Track.TimePosition = 0.6
						end
					end))
					
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end,
		})
		
		Speed = Jerk:CreateSlider({
			Name = 'Speed',
			Default = 1,
			Min = 0,
			Max = 10,
			Decimal = 10,
			Function = function(Val)
				if Track then
					Track:AdjustSpeed(Val * 0.7)
				end
			end
		})
	end)

	Run(function() -- Orbit
		local Orbit, Data, Speed, Distance

		local Rotation = 0

		const function UpdateRotation()
			if EntityLib.Alive and Data.Entity then
				local cf = CFrame.new(Data.Entity.Root.Position) * CFrame.Angles(0, math.rad(Rotation), 0) * CFrame.new(0, 0, Distance.Value)
				EntityLib.Root.AssemblyLinearVelocity = vector.zero
				EntityLib.Root.CFrame = cf
			end
		end
		
		const function StepRotation(Delta)
			if EntityLib.Alive and Data.Entity then
				Rotation += Speed.Value * Delta
				UpdateRotation()
			end
		end

		Orbit, Data = Animations:CreatePlayerTargetModule({
			Name = 'Orbit',
			Tooltip = 'Orbits around the specified player.',
			Function = function(Enabled)
				if Enabled then
					Rotation = 0

					Orbit:Clean(RunService.PreSimulation:Connect(StepRotation))
					Orbit:Clean(RunService.PostSimulation:Connect(UpdateRotation))
				end
			end
		})

		Speed = Orbit:CreateSlider({
			Name = 'Speed',
			Default = 45,
			Min = 0,
			Max = 360,
		})

		Distance = Orbit:CreateSlider({
			Name = 'Distance',
			Default = 5,
			Min = 0,
			Max = 20,
			Decimal = 10
		})
	end)

	Run(function() -- Spasm
		local Spasm
		
		const Animation = Instance.new('Animation')
		Animation.AnimationId = 'rbxassetid://33796059'

		local Track
		
		const function LocalRemoved()
			if Track then
				Track:Stop()
				Track:Destroy()
				Track = nil
			end
		end
		
		const function LocalAdded()
			if EntityLib.Animator then
				if EntityLib.RigType == Enum.HumanoidRigType.R6 then
					Track = EntityLib.Animator:LoadAnimation(Animation)
					Track.Priority = Enum.AnimationPriority.Action4
					Track.Looped = true
					Track:Play(0, 1, 100)
				else
					Notify({
						Title = 'Spasm',
						Text = 'Spasm only works on R6',
						Type = 'Error',
						Duration = 10
					})
					
					Spasm:Toggle(true)
				end
			else
				Notify({
					Title = 'Spasm',
					Text = 'Failed to play animation (No Animator found)',
					Type = 'Error',
					Duration = 10
				})
			end
		end
		
		Spasm = Animations:CreateModule({
			Name = 'Spasm',
			Function = function(Enabled)
				if Enabled then
					Spasm:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					Spasm:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
		
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					LocalRemoved()
				end
			end,
		})
	end)

	Run(function() -- Stare
		local Stare, Data

		const function UpdateLookDirection()
			if EntityLib.Alive and Data.Entity then
				const LocalPosition = EntityLib.Root.Position
				const Position = Data.Entity.Root.Position
				const At = vector.create(Position.X, LocalPosition.Y, Position.Z)
				EntityLib.Root.CFrame = CFrame.lookAt(LocalPosition, At)
			end
		end

		Stare, Data = Animations:CreatePlayerTargetModule({
			Name = 'Stare',
			Tooltip = 'Stares at the specified player.',
			Function = function(Enabled)
				if Enabled then
					Stare:Clean(RunService.PreRender:Connect(UpdateLookDirection))
				end
			end
		})
	end)
end)

Run(function() -- Hud
	Run(function() -- FPS
		local FPS, UpdateInterval
		
		--[[
			Grabbing an accurate count of the current framerate
			Source: https://devforum.roblox.com/t/get-client-FPS-trough-a-script/282631
		]]
		
		FPS = Hud:CreateLabel({
			Name = 'FPS',
			Text = '0 FPS',
			Enabled = function()
				local Frames = {}
				local Start = os.clock()
				local UpdateClock = Start
		
				FPS:Clean(RunService.PostSimulation:Connect(function()
					local Clock = os.clock()
					for i = #Frames, 1, -1 do
						table.insert(Frames, Frames[i] >= Clock - 1 and Frames[i] or nil)
					end
		
					Frames[1] = Clock
					if UpdateClock < Clock then
						UpdateClock = Clock + UpdateInterval.Value
						FPS.Label.Text = `{math.floor(Clock - Start >= 1 and #Frames or #Frames / (Clock - Start))} FPS`
					end
				end))
			end
		})
		
		UpdateInterval = FPS:CreateSlider({
			Name = 'Update Interval',
			Default = 0.1,
			Min = 0.05,
			Max = 1,
			Decimal = 100,
			Clamp = {0, 1}
		})
	end)

	Run(function() -- Ping
		local Ping, UpdateInterval
				
		Ping = Hud:CreateLabel({
			Name = 'Ping',
			Text = '0 ms',
			Enabled = function()
				repeat
					Ping.Label.Text = `Ping: {math.floor(Stats.PerformanceStats.Ping:GetValue())}`
					task.wait(UpdateInterval.Value)
				until not Ping.Enabled
			end
		})
		
		UpdateInterval = Ping:CreateSlider({
			Name = 'Update Interval',
			Default = 0.5,
			Min = 0.25,
			Max = 1,
			Decimal = 100,
			Clamp = {0, 1}
		})
	end)

	Run(function() -- SpeedMeter
		local SpeedMeter, UpdateInterval, Decimal, Mode
		
		SpeedMeter = Hud:CreateLabel({
			Name = 'SpeedMeter',
			Text = '0 sps',
			Enabled = function()
				repeat
					if EntityLib.Alive then
						if Mode.Value == 'Velocity' then
							local Magnitude = vector.magnitude(EntityLib.Root.AssemblyLinearVelocity * vector.hort)
							SpeedMeter.Label.Text = `{math.floor(Magnitude * Decimal.Value) / Decimal.Value} sps`
							task.wait(UpdateInterval.Value)
						else
							local LastPosition = EntityLib.Root.Position * vector.hort
							local Delta = task.wait(UpdateInterval.Value)
							if not EntityLib.Alive then continue end
							local CurrentPosition = EntityLib.Root.Position * vector.hort
							local Diff = (LastPosition - CurrentPosition) * (1 / Delta)
							local Magnitude = vector.magnitude(Diff)
							SpeedMeter.Label.Text = `{math.floor(Magnitude * Decimal.Value) / Decimal.Value} sps`
						end
					else
						task.wait(UpdateInterval.Value)
					end
				until not SpeedMeter.Enabled
			end
		})
		
		UpdateInterval = SpeedMeter:CreateSlider({
			Name = 'Update Interval',
			Default = 0.1,
			Min = 0.05,
			Max = 1,
			Decimal = 100,
			Clamp = {0, 1}
		})
		
		Decimal = SpeedMeter:CreateSlider({
			Name = 'Decimal',
			Default = 1,
			Min = 1,
			Max = 100,
			Clamp = {1, 100000}
		})
		
		Mode = SpeedMeter:CreateDropdown({
			Name = 'Mode',
			List = {'Magnitude', 'Velocity'},
			Info = 'Magnitude - Calculates the distance you traveled\nVelocity - Shows your current velocity',
			Function = function()
				SpeedMeter:Restart()
			end
		})
	end)
end)

return nil