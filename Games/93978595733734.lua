const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
	return cloneref(game:GetService(Service))
end

const Players: Players = GetService('Players')
const ReplicatedStorage: ReplicatedStorage = GetService('ReplicatedStorage')

const Plr = Players.LocalPlayer

const TidalWave = shared.TidalWave
const Categories = TidalWave.Categories
const Libraries = TidalWave.Libraries
const EntityLib = Libraries.EntityLib
const ObjectFunctions = Libraries.ObjectFunctions

const Combat = Categories.Combat
const Movement = Categories.Movement
const World = Categories.World
const Visuals = Categories.Visuals
const PlayerCategory = Categories.Player
const Other = Categories.Other
const Animations = Categories.Animations

const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)

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

const function Run(f)
	f()
end

const function SafeRef(Obj, Path)
	return ObjectFunctions:SafeRef(Obj, Path)
end

const function Notify(Properties)
	TidalWave:Notify(Properties)
end

for i, v in {'KillAura', 'Reach', 'HitboxExpander', 'Viewmodel', 'SilentAim', 'Swim', 'AutoClicker', 'TriggerBot', 'Drop Tools', 'VehiclePhase', 'Aimbot'} do
	TidalWave:RemoveModule(v)
end

local vd = {}
local AddCheckConditionsHook, RemoveCheckConditionHook
local Map, Remotes

Run(function()
	local Modules
	local SurvivorModules
	local KillerModules

	const InitSuccess = TidalWave:WaitForInit(function()
		Map = workspace:FindFirstChild('Map')
		Modules = ReplicatedStorage:FindFirstChild('Modules')
		SurvivorModules = Modules and Modules:FindFirstChild('Survivors')
		KillerModules = Modules and Modules:FindFirstChild('Killers')
		Remotes = ReplicatedStorage:FindFirstChild('Remotes')
		return Map and Modules and SurvivorModules and KillerModules and Remotes
	end)
	if not InitSuccess then return end

	vd = {
		Survivor = {
			Actions = require(SurvivorModules.SurvivorActions),
			AnimationsController = require(SurvivorModules.SurvivorAnimationsController),
			Config = require(SurvivorModules.SurvivorConfig),
			Vault = require(SurvivorModules.SurvivorVault)
		},
		Killer = {
			Config = require(KillerModules.KillerConfig)
		}
	}

	local CheckConditionHooks = {}
	local OldCheckCondition

	AddCheckConditionsHook = function(Args)
		if not OldCheckCondition then
			OldCheckCondition = vd.Survivor.AnimationsController._checkConditions

			vd.Survivor.AnimationsController._checkConditions = function(self)
				local QueuedFunctions = {}
				for _, Tab in CheckConditionHooks do
					if Tab.Function then
						Tab.Function(self)
					end

					if Tab.PostFunction then
						table.insert(QueuedFunctions, Tab.PostFunction)
					end
				end

				local Result = OldCheckCondition(self)

				for _, Function in QueuedFunctions do
					Function(self)
				end

				return Result
			end
		end

		const Function = Args.Function
		const PostFunction = Args.PostFunction
		const Priority = Args.Priority or 1

		table.insert(CheckConditionHooks, {
			Function = Function,
			PostFunction = PostFunction,
			Priority = Priority
		})

		table.sort(CheckConditionHooks, function(a, b)
			return a.Priority < b.Priority
		end)
	end

	RemoveCheckConditionHook = function(Function)
		for i, v in CheckConditionHooks do
			if v.Function == Function then
				table.remove(CheckConditionHooks, i)
				break
			end
		end

		if #CheckConditionHooks == 0 then
			vd.Survivor.AnimationsController._checkConditions = OldCheckCondition
			OldCheckCondition = nil
		else
			table.sort(CheckConditionHooks, function(a, b)
				return a.Priority < b.Priority
			end)
		end
	end
end)

Run(function() -- Player
	Run(function() -- FastVaultModifier
		local FastVaultModifier, AnyAngle, AnySpeed, AntiBlock, FinesseVault

		const function LocalAdded()
			EntityLib.Character:SetAttribute('Flowstate', true)

			local db = false
			FastVaultModifier:Clean(EntityLib.Character:GetAttributeChangedSignal('Flowstate'):Connect(function()
				if db then return end
				db = true
				EntityLib.Character:SetAttribute('Flowstate', true)
				db = false
			end))
		end

		const function CheckRun(Samples, Index, WindowLookVector, AllowedSpeed, MaxDistance)
			local Distance = 0
			local ClosestSample = Samples[Index]
		
			for i = Index - 1, 1, -1 do
				local CurrentSample = Samples[i]
				local SecondSample = Samples[i + 1]
				local TimeDiff = SecondSample.t - CurrentSample.t
				local Magnitude = vector.magnitude((SecondSample.pos - CurrentSample.pos) * vector.hort)
		
				if TimeDiff <= 0 or TimeDiff > 0.15 or AllowedSpeed * TimeDiff + 0.1 < Magnitude then
					return false, 'stale', Distance
				end
		
				local IsFacingFirst = false
		
				if CurrentSample.facing then
					const LookDirection = vector.normalize(CurrentSample.facing * vector.hort)
					IsFacingFirst = vector.dot(LookDirection, WindowLookVector) + 0.0001 >= vd.Survivor.Vault.DOT
				end
		
				if IsFacingFirst then
					const LookDirection = vector.normalize(SecondSample.facing * vector.hort)
					local IsFacingSecond = vector.dot(LookDirection, WindowLookVector) + 0.0001 >= vd.Survivor.Vault.DOT
					if not IsFacingSecond then
						return false, 'facing', Distance
					end
				end
				
				local Diff = (ClosestSample.pos - CurrentSample.pos) * vector.hort
				TimeDiff = ClosestSample.t - CurrentSample.t
				local DiffMagnitude = vector.magnitude(Diff)
		
				if TimeDiff >= 0.075 or MaxDistance <= DiffMagnitude then
					if vector.magnitude(Diff) / TimeDiff < vd.Survivor.Vault.MIN_SPEED then
						return false, 'pace', Distance
					end
		
					if MaxDistance <= DiffMagnitude then
						return true, 'ready', DiffMagnitude
					end
		
					Distance = DiffMagnitude
					ClosestSample = CurrentSample
				end
			end
		
			return false, 'distance', Distance
		end

		FastVaultModifier = PlayerCategory:CreateModule({
			Name = 'FastVaultModifier',
			Info = 'Modifies the behavior of fast vaults',
			Enabled = function()
				local Old = vd.Survivor.Vault.evaluate
				vd.Survivor.Vault.evaluate = function(Samples, Args)
					if Args.blocked and not AntiBlock.Enabled then
						return false, 'locked'
					end

					if not Args.sprinting then
						return false, 'walking'
					end

					if not AnySpeed.Enabled then
						if Args.allowedSpeed < 15.3 then
							return false, 'slowed'
						elseif vector.magnitude(Args.intent * vector.hort) < 0.05 then
							return false, 'input'
						end
					end

					if AnyAngle.Enabled then
						return true, 'arrival', 0
					end
				
					const WindowLookVector = vector.normalize(Args.axis * vector.hort)
					const LocalDirection = vector.normalize(Args.facing * vector.hort)
				
					if not vector.dot(LocalDirection, WindowLookVector) + 0.0001 >= vd.Survivor.Vault.DOT then
						return false, 'facing'
					end
				
					local Len = #Samples
					if Len < 2 then
						return false, 'samples'
					end
				
					if Args.now - Samples[Len].t > 0.15 then
						return false, 'stale'
					end
				
					local SamplesClone = table.clone(Samples)
					if Args.now > SamplesClone[Len].t then
						SamplesClone[Len + 1] = {
							t = Args.now,
							pos = Args.position,
							facing = Args.facing
						}
					end
				
					local AllowedSpeed = math.max(Args.allowedSpeed, 17) * 1.75
					local REPEAT_DISTANCE = Args.repeatingWindow == true and vd.Survivor.Vault.REPEAT_DISTANCE or vd.Survivor.Vault.DISTANCE
					local Facing, Reason, Distance = CheckRun(SamplesClone, #SamplesClone, WindowLookVector, AllowedSpeed, REPEAT_DISTANCE)
				
					if Facing then
						return Facing, Reason, Distance
					end
				
					if Reason ~= 'stale' then
						const HortVel = Args.velocity * vector.hort
				
						if vector.magnitude((Args.position - Args.entryPosition) * vector.hort) <= 4 and vector.magnitude(HortVel) < vd.Survivor.Vault.MIN_SPEED and Reason ~= 'facing' then
							for i = #SamplesClone - 1, 2, -1 do
								if Args.now - SamplesClone[i].t > vd.Survivor.Vault.ARRIVE_GRACE then
									break
								end
				
								Facing, _, Distance = CheckRun(SamplesClone, i, WindowLookVector, AllowedSpeed, REPEAT_DISTANCE)
				
								if Facing then
									return true, 'arrival', Distance
								end
							end
						end
					end
				
					return false, Reason, Distance
				end

				FastVaultModifier:Clean(function()
					vd.Survivor.Vault.evaluate = Old
					Old = nil
				end)

				if FinesseVault.Enabled then
					FastVaultModifier:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))

					if EntityLib.Alive then
						LocalAdded()
					end
				end
			end
		})

		AnyAngle = FastVaultModifier:CreateToggle({
			Name = 'Any Angle',
			Tooltip = 'Allows you to get fast vaults from any angle.',
			Default = true,
			Restart = true
		})

		AnySpeed = FastVaultModifier:CreateToggle({
			Name = 'Any Speed',
			Tooltip = 'Allows you to get fast vaults at any speed, even while standing still.',
			Default = true,
			Restart = true
		})

		AntiBlock = FastVaultModifier:CreateToggle({
			Name = 'AntiBlock',
			Tooltip = 'Prevents windows from getting blocked',
			Default = true,
			Restart = true
		})

		FinesseVault = FastVaultModifier:CreateToggle({
			Name = 'Finesse Vault',
			Tooltip = 'Plays a faster vault animation',
			Restart = true
		})
	end)

	Run(function() -- PalletBreakSpeed
		local PalletBreakSpeed, Duration

		PalletBreakSpeed = PlayerCategory:CreateModule({
			Name = 'PalletBreakSpeed',
			Tooltip = 'Modifies how fast you break pallets',
			Function = function(Enabled)
				if Enabled then
					vd.Killer.Config.PALLET_BREAK_DURATION = Duration.Value
				else
					vd.Killer.Config.PALLET_BREAK_DURATION = 2.16
				end
			end
		})

		Duration = PalletBreakSpeed:CreateSlider({
			Name = 'Duration',
			Default = 2.16,
			Min = 0.01,
			Max = 5,
			Decimal = 100,
			Clamp = {0.01, 100},
			Function = function(Val)
				if PalletBreakSpeed.Enabled then
					vd.Killer.Config.PALLET_BREAK_DURATION = Val
				end
			end
		})
	end)

	Run(function() -- GeneratorBreakSpeed
		local GeneratorBreakSpeed, Duration

		GeneratorBreakSpeed = PlayerCategory:CreateModule({
			Name = 'GeneratorBreakSpeed',
			Tooltip = 'Modifies how fast you break generators',
			Function = function(Enabled)
				if Enabled then
					vd.Killer.Config.GEN_BREAK_DURATION = Duration.Value
				else
					vd.Killer.Config.GEN_BREAK_DURATION = 1.9
				end
			end
		})

		Duration = GeneratorBreakSpeed:CreateSlider({
			Name = 'Duration',
			Default = 1.9,
			Min = 0.01,
			Max = 5,
			Decimal = 100,
			Clamp = {0.01, 100},
			Function = function(Val)
				if GeneratorBreakSpeed.Enabled then
					vd.Killer.Config.GEN_BREAK_DURATION = Val
				end
			end
		})
	end)

	Run(function() -- KillerVaultSpeed
		local KillerVaultSpeed, Duration

		KillerVaultSpeed = PlayerCategory:CreateModule({
			Name = 'KillerVaultSpeed',
			Tooltip = 'Modifies how fast you vault windows as killer.',
			Function = function(Enabled)
				if Enabled then
					vd.Killer.Config.VAULT_DURATION = Duration.Value
				else
					vd.Killer.Config.VAULT_DURATION = 1.525
				end
			end
		})

		Duration = KillerVaultSpeed:CreateSlider({
			Name = 'Duration',
			Default = 1.525,
			Min = 0.01,
			Max = 5,
			Decimal = 100,
			Clamp = {0.01, 100},
			Function = function(Val)
				if KillerVaultSpeed.Enabled then
					vd.Killer.Config.VAULT_DURATION = Val
				end
			end
		})
	end)
end)

Run(function() -- Movement
	Run(function() -- NoSprintDelay
		local NoSprintDelay
		
		local OldSetWalkSpeed = false

		const SetWalkSpeedHook = function(self, Speed)
			Speed = (self:_shouldHardLockSpeed() and 0) or Speed
			self.targetBaseWalkSpeed = Speed
			self.smoothedBaseWalkSpeed = Speed
			self.humanoid.WalkSpeed = Speed * self.currentTurnSlowFactor

			return Speed
		end

		const ConditionHook = function(self)
			if not self.isSlowedFromFall and EntityLib.Humanoid.WalkSpeed ~= 0 and EntityLib.Health > 70 and not self.isCtrlHeld and self.isShiftHeld and not self.cantupdatespeed and not EntityLib.Character:GetAttribute('Aiming') and not EntityLib.Character:GetAttribute('MovementLocked') then
				OldSetWalkSpeed = self._setWalkSpeedSmooth
				self._setWalkSpeedSmooth = SetWalkSpeedHook
			end
		end
		
		const PostConditionHook = function(self)
			if OldSetWalkSpeed then
				self._setWalkSpeedSmooth = OldSetWalkSpeed
			end
		end

		NoSprintDelay = Movement:CreateModule({
			Name = 'NoSprintDelay',
			Info = 'Removes the time taken to accelerate to max speed when you begin sprinting',
			Function = function(Enabled)
				if Enabled then
					AddCheckConditionsHook({
						Function = ConditionHook,
						PostFunction = PostConditionHook,
						Priority = 2
					})
				else
					RemoveCheckConditionHook(ConditionHook)
				end
			end
		})
	end)

	Run(function() -- NoSlowdown
		local NoSlowdown

		local OldSpeedBoost
		local OldPalletDrop
		local SlowConnection
		local ServerSlowConnection

		const function WaitForConnection(Signal)
			local Con = getconnections(Signal)[1]
			if Con and Con.Function then
				return Con
			end

			repeat
				task.wait()
				if not NoSlowdown.Enabled then return end
				Con = getconnections(Signal)[1]
			until Con and Con.Function

			return Con
		end

		const function ScriptAdded(Script)
			if Script.Name == 'Animations-new' then
				SlowConnection = WaitForConnection(ReplicatedStorage.Remotes.Mechanics.Slow.Event)
				ServerSlowConnection = WaitForConnection(ReplicatedStorage.Remotes.Mechanics.Slowserver.OnClientEvent)

				if not (SlowConnection and ServerSlowConnection and NoSlowdown.Enabled) then return end

				SlowConnection:Disable()
				ServerSlowConnection:Disable()
			end
		end

		const function LocalAdded()
			NoSlowdown:Clean(EntityLib.Character.ChildAdded:Connect(ScriptAdded))
			const Script = EntityLib.Character:FindFirstChild('Animations-new')
			if Script then
				ScriptAdded(Script)
			end
		end

		const ConditionHook = function(self)
			self.isSlowedFromFall = false
		end

		NoSlowdown = Movement:CreateModule({
			Name = 'NoSlowdown',
			Info = 'Prevents you from getting slowed down',
			Function = function(Enabled)
				if Enabled then
					OldSpeedBoost = vd.Survivor.AnimationsController._getSpeedBoost
					vd.Survivor.AnimationsController._getSpeedBoost = function(self)
						return math.max(EntityLib.Character:GetAttribute('speedboost') or 1, 1)
					end

					AddCheckConditionsHook({
						Function = ConditionHook,
						Priority = 1
					})

					OldPalletDrop = vd.Survivor.AnimationsController._onPalletDrop
					vd.Survivor.AnimationsController._onPalletDrop = function(self, Trigger, Sprinting)
						local Old = self._setWalkSpeedInstant
						self._setWalkSpeedInstant = function() end
						local Result = OldPalletDrop(self, Trigger, Sprinting)
						self._setWalkSpeedInstant = Old
						return Result
					end

					NoSlowdown:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					RemoveCheckConditionHook(ConditionHook)
					if OldSpeedBoost then
						vd.Survivor.AnimationsController._getSpeedBoost = OldSpeedBoost
						OldSpeedBoost = nil
					end
					if OldPalletDrop then
						vd.Survivor.AnimationsController._onPalletDrop = OldPalletDrop
						OldPalletDrop = nil
					end
					if SlowConnection then
						SlowConnection:Enable()
						SlowConnection = nil
					end
					if ServerSlowConnection then
						ServerSlowConnection:Enable()
						ServerSlowConnection = nil
					end
				end
			end
		})
	end)
end)

Run(function() -- World
	Run(function() -- PromptRange
		local PromptRange, Range

		PromptRange = World:CreateModule({
			Name = 'PromptRange',
			Info = 'Modifies the range you can interact with prompts at.',
			Function = function(Enabled)
				if Enabled then
					vd.Survivor.Config.DETECTION_RADIUS = Range.Value
				else
					vd.Survivor.Config.DETECTION_RADIUS = 4
				end
			end
		})

		Range = PromptRange:CreateSlider({
			Name = 'Range',
			Default = 4,
			Min = 0,
			Max = 12,
			Function = function(Val)
				if PromptRange.Enabled then
					vd.Survivor.Config.DETECTION_RADIUS = Val
				end
			end
		})
	end)
end)

Run(function() -- Visuals
	Run(function() -- GeneratorESP
		local GeneratorESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency
		local CompletedOutlineColor, CompletedFillColor, CompletedOutlineTransparency, CompletedFillTransparency

		local Folder
		const Highlights = {}

		const FOLDER_NAMES = {
			Generators = true,
			Generator = true,
			Gens = true
		}

		const function UpdateHighlights()
			for Generator, Highlight in Highlights do
				const Completed = Generator:GetAttribute('Completed')
				Highlight.OutlineColor = Completed and CompletedOutlineColor.Color or OutlineColor.Color
				Highlight.FillColor = Completed and CompletedFillColor.Color or FillColor.Color
				Highlight.OutlineTransparency = Completed and CompletedOutlineTransparency.Value or OutlineTransparency.Value
				Highlight.FillTransparency = Completed and CompletedFillTransparency.Value or FillTransparency.Value
			end
		end

		const function HighlightGenerator(Generator)
			const Completed = Generator:GetAttribute('Completed')

			const Highlight = Instance.new('Highlight')
			Highlight.OutlineColor = Completed and CompletedOutlineColor.Color or OutlineColor.Color
			Highlight.FillColor = Completed and CompletedFillColor.Color or FillColor.Color
			Highlight.OutlineTransparency = Completed and CompletedOutlineTransparency.Value or OutlineTransparency.Value
			Highlight.FillTransparency = Completed and CompletedFillTransparency.Value or FillTransparency.Value
			Highlight.Adornee = Generator
			Highlight.Parent = Folder

			GeneratorESP:Clean(Generator:GetAttributeChangedSignal('Completed'):Connect(UpdateHighlights))

			Highlights[Generator] = Highlight
		end

		const function ChildAdded(Obj)
			if Obj:IsA('Folder') and FOLDER_NAMES[Obj.Name] then
				GeneratorESP:Clean(Obj.ChildAdded:Connect(HighlightGenerator))

				for _, Generator in Obj:GetChildren() do
					HighlightGenerator(Generator)
				end
			end
		end

		const function ChildRemoved(Obj)
			if Obj:IsA('Folder') and FOLDER_NAMES[Obj.Name] then
				Folder:ClearAllChildren()
				table.clear(Highlights)
			end
		end

		GeneratorESP = Visuals:CreateModule({
			Name = 'GeneratorESP',
			Tooltip = 'Renders generators through walls.',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'Generator_ESP'
					Folder.Parent = TidalWave.Gui

					GeneratorESP:Clean(Map.ChildAdded:Connect(ChildAdded))
					GeneratorESP:Clean(Map.ChildRemoved:Connect(ChildRemoved))

					local Generators
					for Name in FOLDER_NAMES do
						if not Generators then
							Generators = Map:FindFirstChild(Name)
						end
					end
					
					if Generators then
						ChildAdded(Generators)
					end
				else
					Folder:Destroy()
					Folder = nil
					table.clear(Highlights)
				end
			end
		})

		OutlineColor = GeneratorESP:CreateColorPicker({
			Name = 'Outline Color',
			Default = Color3.Red,
			Function = UpdateHighlights
		})

		FillColor = GeneratorESP:CreateColorPicker({
			Name = 'Fill Color',
			Default = Color3.Red,
			Function = UpdateHighlights
		})

		OutlineTransparency = GeneratorESP:CreateTransparencySlider({
			Name = 'Outline Transparency',
			Default = 0,
			Function = UpdateHighlights
		})

		FillTransparency = GeneratorESP:CreateTransparencySlider({
			Name = 'Fill Transparency',
			Default = 0.5,
			Function = UpdateHighlights
		})

		CompletedOutlineColor = GeneratorESP:CreateColorPicker({
			Name = 'Completed Outline Color',
			Default = Color3.Green,
			Function = UpdateHighlights
		})

		CompletedFillColor = GeneratorESP:CreateColorPicker({
			Name = 'Completed Fill Color',
			Default = Color3.Green,
			Function = UpdateHighlights
		})

		CompletedOutlineTransparency = GeneratorESP:CreateTransparencySlider({
			Name = 'Completed Outline Transparency',
			Default = 0,
			Function = UpdateHighlights
		})

		CompletedFillTransparency = GeneratorESP:CreateTransparencySlider({
			Name = 'Completed Fill Transparency',
			Default = 0.5,
			Function = UpdateHighlights
		})
	end)

	Run(function() -- PalletESP
		local PalletESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency

		local Folder
		local Highlights = {}

		const function HighlightPallet(Pallet)
			local Highlight = Instance.new('Highlight')
			Highlight.OutlineColor = OutlineColor.Color
			Highlight.FillColor = FillColor.Color
			Highlight.OutlineTransparency = OutlineTransparency.Value
			Highlight.FillTransparency = FillTransparency.Value
			Highlight.Adornee = Pallet
			Highlight.Parent = Folder
			table.insert(Highlights, Highlight)
		end

		const function UpdateHighlights()
			for _, Highlight in Highlights do
				Highlight.OutlineColor = OutlineColor.Color
				Highlight.FillColor = FillColor.Color
				Highlight.OutlineTransparency = OutlineTransparency.Value
				Highlight.FillTransparency = FillTransparency.Value
			end
		end

		const function DescendantAdded(Obj)
			if Obj:IsA('Model') and Obj.Name == 'Palletwrong' then
				HighlightPallet(Obj)
			end
		end

		const function DescendantRemoved(Obj)
			if Obj:IsA('Model') and Obj.Name == 'Palletwrong' then
				for i, Highlight in Highlights do
					if Highlight.Adornee == Obj then
						Highlight:Destroy()
						table.remove(Highlights, i)
						break
					end
				end
			end
		end

		PalletESP = Visuals:CreateModule({
			Name = 'PalletESP',
			Tooltip = 'Renders pallets through walls.',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'Pallet_ESP'
					Folder.Parent = TidalWave.Gui

					PalletESP:Clean(Map.DescendantAdded:Connect(DescendantAdded))
					PalletESP:Clean(Map.DescendantRemoving:Connect(DescendantRemoved))

					for _, Pallet in Map:QueryDescendants('Model #Palletwrong') do
						HighlightPallet(Pallet)
					end
				else
					Folder:Destroy()
					Folder = nil
					table.clear(Highlights)
				end
			end
		})

		OutlineColor = PalletESP:CreateColorPicker({
			Name = 'Outline Color',
			Default = Color3.Yellow,
			Function = UpdateHighlights
		})

		FillColor = PalletESP:CreateColorPicker({
			Name = 'Fill Color',
			Default = Color3.Yellow,
			Function = UpdateHighlights
		})

		OutlineTransparency = PalletESP:CreateTransparencySlider({
			Name = 'Outline Transparency',
			Default = 0,
			Function = UpdateHighlights
		})

		FillTransparency = PalletESP:CreateTransparencySlider({
			Name = 'Fill Transparency',
			Default = 0.5,
			Function = UpdateHighlights
		})
	end)

	Run(function() -- WindowESP
		local WindowESP, OutlineColor, FillColor, OutlineTransparency, FillTransparency

		local Folder
		local Highlights = {}
		local Modified = {}

		const function HighlightWindow(Window)
			local Bottom = Window:FindFirstChild('Bottom')
			if Bottom then
				Modified[Bottom] = Bottom.Transparency
				Bottom.Transparency = 0
			end

			local Highlight = Instance.new('Highlight')
			Highlight.OutlineColor = OutlineColor.Color
			Highlight.FillColor = FillColor.Color
			Highlight.OutlineTransparency = OutlineTransparency.Value
			Highlight.FillTransparency = FillTransparency.Value
			Highlight.Adornee = Window
			Highlight.Parent = Folder
			table.insert(Highlights, Highlight)
		end

		const function DescendantAdded(Obj)
			if Obj:IsA('Model') and Obj.Name == 'Window' then
				HighlightWindow(Obj)
			end
		end

		const function DescendantRemoved(Obj)
			if Obj:IsA('Model') and Obj.Name == 'Window' then
				for i, Highlight in Highlights do
					if Highlight.Adornee == Obj then
						Highlight:Destroy()
						table.remove(Highlights, i)
						break
					end
				end
			end
		end

		const function UpdateHighlights()
			for _, Highlight in Highlights do
				Highlight.OutlineColor = OutlineColor.Color
				Highlight.FillColor = FillColor.Color
				Highlight.OutlineTransparency = OutlineTransparency.Value
				Highlight.FillTransparency = FillTransparency.Value
			end
		end

		WindowESP = Visuals:CreateModule({
			Name = 'WindowESP',
			Tooltip = 'Renders windows through walls.',
			Function = function(Enabled)
				if Enabled then
					Folder = Instance.new('Folder')
					Folder.Name = 'Window_ESP'
					Folder.Parent = TidalWave.Gui

					WindowESP:Clean(Map.DescendantAdded:Connect(DescendantAdded))
					WindowESP:Clean(Map.DescendantRemoving:Connect(DescendantRemoved))
					for _, Window in Map:QueryDescendants('Model #Window') do
						HighlightWindow(Window)
					end
				else
					Folder:Destroy()
					Folder = nil
					table.clear(Highlights)
					for Part, OldTransparency in Modified do
						Part.Transparency = OldTransparency
					end
				end
			end
		})

		OutlineColor = WindowESP:CreateColorPicker({
			Name = 'Outline Color',
			Default = Color3.Yellow,
			Function = UpdateHighlights
		})

		FillColor = WindowESP:CreateColorPicker({
			Name = 'Fill Color',
			Default = Color3.Yellow,
			Function = UpdateHighlights
		})

		OutlineTransparency = WindowESP:CreateTransparencySlider({
			Name = 'Outline Transparency',
			Default = 0,
			Function = UpdateHighlights
		})

		FillTransparency = WindowESP:CreateTransparencySlider({
			Name = 'Fill Transparency',
			Default = 0.5,
			Function = UpdateHighlights
		})
	end)
end)

Run(function() -- Other
	Run(function() -- AutoSkillCheck
		local AutoSkillCheck

		local GenEvent, OldGen
		local HealEvent, OldHeal
		local HandleGenSkillCheck, HandlePlayerSkillCheck

		const function Check(Tab)
			for i = 1, Tab.n do
				if Tab[i] == nil then
					return false
				end
			end

			return true
		end

		const function Get(Function)
			local Result = table.pack(Function())

			if not Check(Result) then
				local Success
				repeat
					task.wait()
					Result = table.pack(Function())
					Success = Check(Result)
				until Success or not EntityLib.Alive or not AutoSkillCheck.Enabled

				if not (Success and EntityLib.Alive and AutoSkillCheck.Enabled) then return end
			end

			return table.unpack(Result)
		end

		const function LocalAdded()
			Get(function()
				return EntityLib.Alive and EntityLib.Character:FindFirstChild('Skillcheck-gen') and EntityLib.Character:FindFirstChild('Skillcheck-player') or nil
			end)

			GenEvent, HealEvent = Get(function()
				const GenConnection = getconnections(ReplicatedStorage.Remotes.Generator.SkillCheckEvent.OnClientEvent)[1]
				const HealConnection = getconnections(ReplicatedStorage.Remotes.Healing.SkillCheckEvent.OnClientEvent)[1]
				if GenConnection and GenConnection.Function and HealConnection and HealConnection.Function then
					return GenConnection, HealConnection
				else
					return nil
				end
			end)
			if not (GenEvent and HealEvent) then return end

			HandleGenSkillCheck, HandlePlayerSkillCheck = Get(function()
				local Gen, Player
				for i, v in filtergc('function', {Name = 'handleSkillCheck'}) do
					if debug.info(v, 's'):find('Skillcheck%-gen') then
						Gen = v
					else
						Player = v
					end
				end

				return Gen, Player
			end)
			if not (HandleGenSkillCheck and HandlePlayerSkillCheck) then return end

			const Line, Goal = Get(function()
				const Gui = SafeRef(Plr, {'PlayerGui', 'SkillCheckPromptGui', 'Check'})
				return Gui and SafeRef(Gui, {'Line'}) or nil, Gui and SafeRef(Gui, {'Goal'}) or nil
			end)
			
			if not (Line and Goal) then return end
			if not (GenEvent and GenEvent.Function and HealEvent and HealEvent.Function) then return end

			OldGen = hookfunction(GenEvent.Function, function(Generator, Point)
				OldGen(Generator, Point)

				task.wait(0.5)

				const SkillCheckSpeed = EntityLib.Alive and EntityLib.Character:GetAttribute('skillcheckspeed') or 1
				const TimeOut = os.clock() + math.max(1.3 * SkillCheckSpeed, 0.4)

				repeat
					task.wait()
				until Line.Rotation >= Goal.Rotation + 105 or os.clock() >= TimeOut
				if os.clock() >= TimeOut then return end

				HandleGenSkillCheck('success')
			end)

			OldHeal = hookfunction(HealEvent.Function, function(Player)
				OldHeal(Player)

				task.wait(0.5)

				const SkillCheckDuration = EntityLib.Character:GetAttribute('ambitiousmedic') and Player:GetAttribute('ambitiousmedic') and 1.68 or 1.2
				const TimeOut = os.clock() + SkillCheckDuration

				repeat
					task.wait()
				until Line.Rotation >= Goal.Rotation + 105 or os.clock() >= TimeOut
				if os.clock() >= TimeOut then return end

				HandlePlayerSkillCheck('success')
			end)
		end

		const function LocalRemoved()
			GenEvent, HealEvent = nil, nil
			OldGen, OldHeal = nil, nil
			HandleGenSkillCheck, HandlePlayerSkillCheck = nil, nil
		end

		AutoSkillCheck = Other:CreateModule({
			Name = 'AutoSkillCheck',
			Info = 'Automatically hits skill checks for you',
			Function = function(Enabled)
				if Enabled then
					AutoSkillCheck:Clean(EntityLib.Events.LocalAdded:Connect(LocalAdded))
					AutoSkillCheck:Clean(EntityLib.Events.LocalRemoved:Connect(LocalRemoved))
					
					if EntityLib.Alive then
						LocalAdded()
					end
				else
					if GenEvent and GenEvent.Function then
						if restorefunction then
							restorefunction(GenEvent.Function)
						elseif OldGen then
							hookfunction(GenEvent.Function, OldGen)
						end
					end

					GenEvent = nil
					OldGen = nil
				end
			end
		})
	end)
end)