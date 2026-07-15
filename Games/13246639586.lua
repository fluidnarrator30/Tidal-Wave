local cloneref = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return cloneref(game:GetService(Service))
end

local Players: Players = GetService("Players")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")
local RunService: RunService = GetService("RunService")
local TweenService: TweenService = GetService("TweenService")
local UIS: UserInputService = GetService('UserInputService')
local CollectionService: CollectionService = GetService('CollectionService')

local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib
local Prediction = TidalWave.Libraries.Prediction
local Modules = TidalWave.Modules
local CustomLocalMethods = TidalWave.Libraries.CustomLocalMethods

local Plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Combat = Categories.Combat
local PlayerCategory = Categories.Player
local Movement = Categories.Movement
local Visuals = Categories.Visuals
local World = Categories.World
local Other = Categories.Other

local getupvalue = debug.getupvalue or getupvalue

local LowLevel = table.find({'Xeno', 'Solara'}, identifyexecutor and identifyexecutor() or 'Solara')

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

local function SafeRef(Obj, Path)
    return CustomLocalMethods:SafeRef(Obj, Path)
end

local skywars, remotes = {}, {}
local store = {
	blocks = {},
	hand = {},
	inventory = {},
	tools = {},
	noShoot = tick()
}

local function collection(tags, module, customadd, customremove)
	tags = typeof(tags) ~= 'table' and {tags} or tags
	local objs, connections = {}, {}

	for _, tag in tags do
		table.insert(connections, CollectionService:GetInstanceAddedSignal(tag):Connect(function(v)
			if customadd then
				customadd(objs, v, tag)
				return
			end
			table.insert(objs, v)
		end))
		table.insert(connections, CollectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
			if customremove then
				customremove(objs, v, tag)
				return
			end
			v = table.find(objs, v)
			if v then
				table.remove(objs, v)
			end
		end))

		for _, v in CollectionService:GetTagged(tag) do
			if customadd then
				customadd(objs, v, tag)
				continue
			end
			table.insert(objs, v)
		end
	end

	local cleanFunc = function()
		for _, v in connections do
			v:Disconnect()
		end
		table.clear(connections)
		table.clear(objs)
	end
	if module then
		module:Clean(cleanFunc)
	end
	return objs, cleanFunc
end

local function getItem(check)
	for _, item in store.inventory do
		if item.Type == check then
			return item
		end
	end
end

local function getSword()
	local bestSword, bestSwordSlot, bestSwordDamage = nil, nil, 0
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local swordDamage = item.Melee and item.Melee.Damage or 0
		if swordDamage > bestSwordDamage then
			bestSword, bestSwordSlot, bestSwordDamage = item, slot, swordDamage
		end
	end
	return bestSword, bestSwordSlot
end

local function getPickaxe()
	local bestPick, bestPickSlot, bestPickDamage = nil, nil, math.huge
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		local pickDamage = item.Pickaxe and item.Pickaxe.TimeMultiplier or math.huge
		if pickDamage < bestPickDamage then
			bestPick, bestPickSlot, bestPickDamage = item, slot, pickDamage
		end
	end
	return bestPick, bestPickSlot
end

local function parsePositions(v, func)
	if v:IsA('Part') and v.Size // 1 == v.Size then
		local start = (v.Position - (v.Size / 2)) + Vector3.new(1.5, 1.5, 1.5)
		for x = 0, v.Size.X - 1, 3 do
			for y = 0, v.Size.Y - 1, 3 do
				for z = 0, v.Size.Z - 1, 3 do
					func(start + Vector3.new(x, y, z))
				end
			end
		end
	end
end

Run(function() -- CharacterLib
    function CharacterLib:GetUpdateConnections(Character)
        return {
			Character.Player:GetAttributeChangedSignal('Health'),
		}
    end

    function CharacterLib:IsTeammate(Character)
        if TidalWave:IsFriend(Character.Player) then return true end
        return Plr:GetAttribute('TeamId') == Character.Player:GetAttribute('TeamId')
    end

    function CharacterLib:GetTeamColor(Character)
        local IsFriend, FriendColor = TidalWave:IsFriend(Character.Player)
        if IsFriend and FriendColor then
            return FriendColor
        end
        return skywars.TeamController:getTeamColour(Character.Player:GetAttribute('TeamId'))
    end

    CharacterLib:Restart()
end)

Run(function() -- Init
    if LowLevel then
        Notify({Title = 'Poop Sploit', Text = "Come back with a real executor buddy not some xeno solara crap", Duration = 10, Type = 'Error'})
        error('[Tidal Wave]: Come back with a real executor buddy not some xeno solara crap', 2)
    else
        local Flamework = require(ReplicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
        local ControllerTable = {}

        if not getupvalue(Flamework.ignite, 1) then
            repeat task.wait() until getupvalue(Flamework.ignite, 1)
        end

        local function searchFunction(name, i2, v2)
            for _, v3 in debug.getconstants(v2) do
                if tostring(v3):find('-') == 9 then
                    remotes[(rawget(remotes, i2) and name..':' or '')..i2] = v3
                end
            end
        end

        for i, v in getupvalue(Flamework.ignite, 2).idToObj do
            local name = tostring(v)
            ControllerTable[name] = Flamework.resolveDependency(i)
            for i2, v2 in v do
                if type(v2) == 'function' then
                    searchFunction(name, i2, v2)

                    for _, v3 in debug.getprotos(v2) do
                        searchFunction(name, i2, v3)
                    end
                end
            end
        end

        local roactCheck = ReplicatedStorage['rbxts_include']['node_modules']['@rbxts']:FindFirstChild('roact')
        skywars = setmetatable({
            CameraUtil = require(Plr.PlayerScripts.TS.util['camera-util']).CameraUtil,
            FireOrigin = getupvalue(ControllerTable.ProjectileController.chargeBow, 11).ORIGIN_OFFSET,
            Gravity = getupvalue(ControllerTable.ProjectileController.chargeBow, 13).WORLD_ACCELERATION.Y,
            ItemMeta = getupvalue(ControllerTable.HotbarController.getSword, 1),
            Remotes = getupvalue(ControllerTable.MeleeController.strikeDesktop, 6),
            Roact = require(roactCheck and roactCheck.src or ReplicatedStorage['rbxts_include']['node_modules']['@rbxts'].ReactLua['node_modules']['@jsdotlua']['roact-compat']),
            Store = require(Plr.PlayerScripts.TS.ui.rodux['global-store']).GlobalStore,
            Shop = require(ReplicatedStorage.TS.game.shop['game-shop']).Shops
        }, {
            __index = function(self, ind)
                rawset(self, ind, ControllerTable[ind])
                return rawget(self, ind)
            end
        })

        local function updateStore(newStore, oldStore)
            if newStore.ActiveSlot ~= oldStore.ActiveSlot then
                store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
                store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
            end

            if newStore.Inventory ~= oldStore.Inventory then
                store.inventory = newStore.Inventory.Contents
                store.hand = newStore.Inventory.Contents[newStore.ActiveSlot]
                store.hand = store.hand and skywars.ItemMeta[store.hand.Type] or {}
                store.tools.sword = getSword()
                store.tools.pickaxe = getPickaxe()
            end
        end

        local storeChanged = skywars.Store.changed:connect(updateStore)
        updateStore(skywars.Store:getState(), {})

        TidalWave:Clean(workspace.BlockContainer.DescendantAdded:Connect(function(v)
            parsePositions(v, function(pos)
                store.blocks[pos] = v
            end)
        end))
        TidalWave:Clean(workspace.BlockContainer.DescendantRemoving:Connect(function(v)
            parsePositions(v, function(pos)
                store.blocks[pos] = nil
            end)
        end))
        for _, v in workspace.BlockContainer:GetDescendants() do
            parsePositions(v, function(pos)
                store.blocks[pos] = v
            end)
        end

        TidalWave:Clean(function()
            table.clear(ControllerTable)
            table.clear(skywars)
            table.clear(store.blocks)
            table.clear(store)
            storeChanged:disconnect()
            storeChanged = nil
        end)
    end
end)

Run(function() -- Combat
    Run(function() -- KillAura
        local Killaura
        local WallCheck
        local AttackRange
        local AngleCheck
        local Max
        local Mouse
        local Limit
        local Swing
        
        local function getAttackData()
            if Mouse.Enabled then
                if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return false end
            end
        
            return (not Limit.Enabled) and store.tools.sword or store.hand
        end
        
        Killaura = Combat:CreateModule({
            Name = 'KillAura',
            Function = function(callback)
                if callback then
                    repeat
                        local attacked = {}
                        local tool = getAttackData()
                        if tool and tool.Melee then
                            local plrs = CharacterLib:GetClosestCharacters({
                                Range = AttackRange.Value,
                                WallCheck = WallCheck.Enabled,
                                Part = 'Root',
                                Players = true,
                                Limit = Max.Value
                            })
                            local switched = false
        
                            if #plrs > 0 then
                                local localfacing = CharacterLib.Root.CFrame.LookVector * Vector3.new(1, 0, 1)
                                store.noShoot = tick() + 1
        
                                for _, v in plrs do
                                    local delta = (v.Root.Position - CharacterLib.Root.Position)
                                    local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                                    if angle > (math.rad(AngleCheck.Value) / 2) then continue end
                                    table.insert(attacked, v)
        
                                    if Swing.Enabled then
                                        skywars.MeleeController:playAnimation(Plr.Character, tool)
                                    end
        
                                    if not switched then
                                        switched = true
                                        skywars.Remotes[remotes.updateActiveItem]:fire(tool.Name)
                                    end
        
                                    skywars.Remotes[remotes.strikeDesktop]:fire(v.Player)
                                end
                            end
        
                            if switched then
                                skywars.Remotes[remotes.updateActiveItem](store.hand.Name)
                            end
                        end
        
                        task.wait(0.05)
                    until not Killaura.Enabled
                end
            end,
            Info = 'Attack players around you\nwithout aiming at them.'
        })
        WallCheck = Killaura:CreateToggle({
            Name = 'WallCheck',
            Info = 'Ignores players behind walls.'
        })
        AttackRange = Killaura:CreateSlider({
            Name = 'Attack range',
            Min = 1,
            Max = 18,
            Default = 18,
            Suffix = function(val)
                return val == 1 and 'stud' or 'studs'
            end
        })
        AngleCheck = Killaura:CreateSlider({
            Name = 'Max angle',
            Min = 1,
            Max = 360,
            Default = 360
        })
        Max = Killaura:CreateSlider({
            Name = 'Max targets',
            Min = 1,
            Max = 10,
            Default = 10
        })
        Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
        Swing = Killaura:CreateToggle({
            Name = 'Swing',
            Info = 'Whether or not to play the swing animation',
            Default = true
        })
        Limit = Killaura:CreateToggle({
            Name = 'Limit to items',
            Info = 'Only attacks when the sword is held'
        })
    end)

    Run(function() -- SilentAimbot
        local TargetPart
        local FOV
        local old, oldMobile
        local rayCheck = RaycastParams.new()
        rayCheck.FilterType = Enum.RaycastFilterType.Exclude
        
        local function aimFunction(...)
            if store.hand and store.hand.Ranged then
                local WithinMouse = CharacterLib:GetCharacterWithinMouse({
                    Range = FOV.Value,
                    Part = 'Root',
                    Players = true
                })
        
                if WithinMouse then
                    rayCheck.FilterDescendantsInstances = {WithinMouse.Character, Camera}
                    rayCheck.CollisionGroup = WithinMouse[TargetPart.Value].CollisionGroup
                    local offsetpos = CharacterLib.Root.CFrame * skywars.FireOrigin
                    local calc = Prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), WithinMouse[TargetPart.Value].Position, WithinMouse[TargetPart.Value].Velocity, workspace.Gravity, WithinMouse.HipHeight, nil, rayCheck)
        
                    if calc then
                        return CFrame.lookAlong(offsetpos.Position, calc).LookVector
                    end
                end
            end
            
            return old(...)
        end
        
        local ProjectileAimbot = Combat:CreateModule({
            Name = 'SilentAimbot',
            Function = function(callback)
                if callback then
                    old = hookfunction(skywars.CameraUtil.getCursorDirection, function(...)
                        return aimFunction(...)
                    end)
        
                    oldMobile = hookfunction(skywars.CameraUtil.getDirection, function(...)
                        return aimFunction(...)
                    end)
                else
                    hookfunction(skywars.CameraUtil.getCursorDirection, old)
                    hookfunction(skywars.CameraUtil.getDirection, oldMobile)
                    old = nil
                    oldMobile = nil
                end
            end,
            Info = 'Silently adjusts your aim towards the nearest enemy'
        })
        TargetPart = ProjectileAimbot:CreateDropdown({
            Name = 'Part',
            List = {'RootPart', 'Head'}
        })
        FOV = ProjectileAimbot:CreateSlider({
            Name = 'FOV',
            Min = 1,
            Max = 1000,
            Default = 1000
        })
    end)

    Run(function() -- ProjectileAura
        local ProjectileAura
        local WallCheck
        local Range
        local List
        local rayCheck = RaycastParams.new()
        rayCheck.FilterType = Enum.RaycastFilterType.Exclude
        local FireDelays = {}
        
        local function getProjectiles()
            local items = {}
            for slot, item in store.inventory do
                item = skywars.ItemMeta[item.Type]
                if item.Ranged and table.find(List.Enabled, item.Ranged.ProjectileType) and getItem(item.Ranged.ProjectileType) then
                    table.insert(items, item)
                end
            end
            return items
        end
        
        ProjectileAura = Combat:CreateModule({
            Name = 'ProjectileAura',
            Function = function(callback)
                if callback then
                    repeat
                        local Character = CharacterLib:GetClosestCharacter({
                            Part = 'Root',
                            Range = Range.Value,
                            Players = true,
                            WallCheck = WallCheck.Enabled
                        })
        
                        if Character then
                            local offsetpos = CharacterLib.Root.CFrame * skywars.FireOrigin
                            for _, item in getProjectiles() do
                                if (FireDelays[item] or 0) < tick() then
                                    rayCheck.FilterDescendantsInstances = {Character.Character, Camera}
                                    rayCheck.CollisionGroup = Character.Character.Root.CollisionGroup
                                    local calc = Prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), Character.Character.Root.Position, Character.Character.Root.AssemblyLinearVelocity, workspace.Gravity, Character.Character.HipHeight, nil, rayCheck)
        
                                    if calc then
                                        FireDelays[item] = tick() + 0.5
                                        skywars.Remotes[remotes.updateActiveItem]:fire(item.Name)
                                        skywars.Remotes[remotes.chargeBow]:fire(CFrame.new(offsetpos.Position, calc).LookVector, 1)
                                        skywars.Remotes[remotes.updateActiveItem](store.hand.Name)
                                        break
                                    end
                                end
                            end
                        end
        
                        task.wait(0.1)
                    until not ProjectileAura.Enabled
                end
            end,
            Info = 'Shoots people around you'
        })
        WallCheck = ProjectileAura:CreateToggle({
            Name = 'WallCheck',
            Default = true
        })
        List = ProjectileAura:CreateTextList({
            Name = 'Projectiles',
            List = {'Arrow', 'Snowball', 'Capybara'}
        })
        Range = ProjectileAura:CreateSlider({
            Name = 'Range',
            Min = 1,
            Max = 50,
            Default = 50,
            Suffix = function(val)
                return val == 1 and 'stud' or 'studs'
            end
        })
    end)

    Run(function() -- AutoWin
        local AutoWin

        local function GameInProgress()
            return workspace:FindFirstChild('Lobby') == nil
        end

        local Params = RaycastParams.new()
        Params.RespectCanCollide = true
        Params.FilterType = Enum.RaycastFilterType.Include
        
        AutoWin = Combat:CreateModule({
            Name = "AutoWin",
            Info = "It Win For You (:",
            Enabled = function()
                repeat
                    task.wait()
                until GameInProgress() or not AutoWin.Enabled
                if not AutoWin.Enabled then return end

                local SpawnLocations

                repeat
                    SpawnLocations = SafeRef(workspace, {'BlockContainer', 'Map', 'SpawnLocations'})
                    task.wait()
                until SpawnLocations or not AutoWin.Enabled

                while GameInProgress() and AutoWin.Enabled do
                    for _, SpawnLocation in SpawnLocations:GetChildren() do
                        if #SpawnLocation:GetChildren() <= 0 then
                            local Portals
                            repeat
                                Portals = SafeRef(workspace, {'BlockContainer', 'Map', 'Portals'})
                                task.wait()
                            until Portals or not AutoWin.Enabled
                            if Portals and AutoWin.Enabled then
                                for _, v in Portals:GetChildren() do
                                    if v:IsA('BasePart') then
                                        if firetouchinterest then
                                            firetouchinterest(CharacterLib.Root, v, true)
                                            task.wait()
                                            firetouchinterest(CharacterLib.Root, v, false)
                                        else
                                            CharacterLib.Root.CFrame = v.CFrame
                                        end
                                    end
                                end
                            end
                            task.wait()
                            break
                        end
                        if not AutoWin.Enabled then break end
                    end
                    task.wait()
                end
            end,
        })
    end)
end)

Run(function() -- Player
    Run(function() -- NoFall
        local NoFall

        local Params = RaycastParams.new()
        Params.RespectCanCollide = true
        Params.FilterType = Enum.RaycastFilterType.Include
        Params.FilterDescendantsInstances = {workspace.BlockContainer}

        local Down = vector.create(0, -13, 0)
        local GroundPosition = vector.zero

        local Air = Enum.Material.Air
        local Ragdoll = Enum.HumanoidStateType.Ragdoll
        local Running = Enum.HumanoidStateType.Running

        NoFall = PlayerCategory:CreateModule({
            Name = 'NoFall',
            Info = 'Prevents you from taking fall damage.',
            Enabled = function()
                while NoFall.Enabled and RunService.PreSimulation:Wait() do
                    if CharacterLib.Alive then
                        if CharacterLib.Humanoid.FloorMaterial ~= Air then
                            GroundPosition = CharacterLib.Root.Position
                        end
                        if (GroundPosition.Y - CharacterLib.Root.Position.Y) > 10 then
                            local Raycast = workspace:Raycast(CharacterLib.Root.Position, Down, Params)
                            if not Raycast then
                                CharacterLib.Humanoid:ChangeState(Ragdoll)
                                Notify({Text = 'Stopped fall damage.', Duration = 1})
                                task.wait(0.1)
                                CharacterLib.Humanoid:ChangeState(Running)
                                local TimeOut = os.clock() + 0.05
                                repeat
                                    RunService.PostSimulation:Wait()
                                until CharacterLib.Humanoid.FloorMaterial ~= Air or os.clock() >= TimeOut
                            end
                        end
                    end
                end
            end
        })
    end)

    Run(function() -- NoSlowdown
        local old, oldcheck
        
        PlayerCategory:CreateModule({
            Name = 'NoSlowdown',
            Info = 'Prevents slowing down when using items.',
            Function = function(callback)
                if callback then
                    old = skywars.HumanoidController.addSpeedModifier
                    oldcheck = skywars.SprintingController.setCanSprint
        
                    skywars.HumanoidController.addSpeedModifier = function(self, index, speed)
                        speed = math.max(speed, 1)
                        return old(self, index, speed)
                    end
        
                    skywars.SprintingController.setCanSprint = function(self, canSprint)
                        return oldcheck(self, true)
                    end
        
                    for i, v in skywars.HumanoidController.speedModifiers do
                        if v < 1 then
                            skywars.HumanoidController:removeSpeedModifier(i)
                        end
                    end
        
                    skywars.SprintingController:setCanSprint(true)
                    skywars.SprintingController:enableSprinting()
                else
                    skywars.HumanoidController.addSpeedModifier = old
                    skywars.SprintingController.setCanSprint = oldcheck
                    old = nil
                    oldcheck = nil
                end
            end
        })
    end)
end)

Run(function() -- Movement
    Run(function() -- Sprint
        local Sprint
        local old
        
        Sprint = Movement:CreateModule({
            Name = 'Sprint',
            Info = 'Sets your sprinting to true.',
            Function = function(callback)
                if callback then
                    old = skywars.SprintingController.disableSprinting
                    skywars.SprintingController.disableSprinting = function(tab, ...)
                        local data = old(tab, ...)
        
                        if not tab.canSprint then
                            task.spawn(function()
                                repeat task.wait(0.1) until tab.canSprint or not Sprint.Enabled
        
                                if Sprint.Enabled then
                                    skywars.SprintingController:enableSprinting(tab)
                                end
                            end)
                        else
                            skywars.SprintingController:enableSprinting(tab)
                        end
        
                        return data
                    end
        
                    Sprint:Clean(CharacterLib.Events.LocalAdded:Connect(function()
                        skywars.SprintingController:disableSprinting()
                    end))
        
                    skywars.SprintingController:disableSprinting()
                else
                    skywars.SprintingController.disableSprinting = old
                    skywars.SprintingController:disableSprinting()
                end
            end,
        })
    end)

    Run(function() -- Velocity
        local Velocity
        local Horizontal
        local Vertical
        local Chance
        local Targeting
        local connection
        local rand, old = Random.new()
        
        local function velocityFunction(...)
            if rand:NextNumber(0, 100) > Chance.Value then return old(...) end
        
            local args = table.pack(...)
            local check = (not Targeting.Enabled) or CharacterLib:GetClosestCharacter({
                Range = 50,
                Part = 'Root',
                Players = true
            })
        
            if check then
                local hort, vert = (Horizontal.Value / 100), (Vertical.Value / 100)
                if hort == 0 and vert == 0 then return end
                args[1] = Vector3.new(args[1].X * hort, args[1].Y * vert, args[1].Z * hort)
            end
        
            return old(unpack(args, 1, args.n))
        end
        
        Velocity = Movement:CreateModule({
            Name = 'Velocity',
            Info = 'Reduces knockback taken',
            Function = function(callback)
                if callback then
                    connection = getconnections(getupvalue(getupvalue(skywars.Remotes[remotes['PlayerVelocityController:onStart']].connect, 1).fireClient, 1).OnClientEvent)[1]
                    if not connection then return end
        
                    old = hookfunction(connection.Function, function(...)
                        return velocityFunction(...)
                    end)
                else
                    if old then
                        hookfunction(connection.Function, old)
                    end
                    connection = nil
                end
            end,
        })
        Horizontal = Velocity:CreateSlider({
            Name = 'Horizontal',
            Min = 0,
            Max = 100,
            Default = 0,
            Suffix = '%'
        })
        Vertical = Velocity:CreateSlider({
            Name = 'Vertical',
            Min = 0,
            Max = 100,
            Default = 0,
            Suffix = '%'
        })
        Chance = Velocity:CreateSlider({
            Name = 'Chance',
            Min = 0,
            Max = 100,
            Default = 100,
            Suffix = '%'
        })
        Targeting = Velocity:CreateToggle({Name = 'Only when targeting'})
    end)
end)

Run(function() -- World
    Run(function() -- AutoLoot
        local ChestSteal
        local Range
        local Open
        local Delay = {}
        
        ChestSteal = World:CreateModule({
            Name = 'AutoLoot',
            Function = function(callback)
                if callback then
                    local chests = collection('block:chest', ChestSteal)
                    ChestSteal:Clean(skywars.Remotes[remotes['ChestController:onStart']]:connect(function(self, items)
                        if Delay[self] then return end
        
                        for _, item in items do
                            skywars.Remotes[remotes.updateChest]:fire(self, item.Type, -item.Quantity)
                        end
        
                        skywars.Remotes[remotes.closeChest]:fire(self)
                        Delay[self] = true
                    end))
        
                    repeat
                        if CharacterLib.Alive and not Open.Enabled then
                            local localPosition = CharacterLib.Root.Position
                            for i, v in chests do
                                if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude <= Range.Value and not Delay[v] then
                                    skywars.Remotes[remotes.openChest]:fire(v)
                                end
                            end
                        end
        
                        task.wait(0.1)
                    until not ChestSteal.Enabled
                end
            end,
            Info = 'Grabs items from near chests.'
        })
        Range = ChestSteal:CreateSlider({
            Name = 'Range',
            Min = 0,
            Max = 10,
            Default = 10,
            Suffix = function(val)
                return val == 1 and 'stud' or 'studs'
            end
        })
        Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
    end)

    Run(function() -- Scaffold
        local Scaffold
        local Expand
        local Tower
        local Downwards
        local Diagonal
        local LimitItem
        local adjacent, lastpos = {}, Vector3.zero
        
        for x = -3, 3, 3 do
            for y = -3, 3, 3 do
                for z = -3, 3, 3 do
                    local vec = Vector3.new(x, y, z)
                    if vec.Y ~= 0 and (vec.X ~= 0 or vec.Z ~= 0) then
                        continue
                    end
        
                    if vec ~= Vector3.zero then
                        table.insert(adjacent, vec)
                    end
                end
            end
        end
        
        local function getBlocksInPoints(s, e)
            local list = {}
            for x = s.X, e.X, 3 do
                for y = s.Y, e.Y, 3 do
                    for z = s.Z, e.Z, 3 do
                        local vec = Vector3.new(x, y, z)
                        if store.blocks[vec] then
                            table.insert(list, vec)
                        end
                    end
                end
            end
            return list
        end
        
        local function roundPos(vec)
            return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
        end
        
        local function nearCorner(poscheck, pos)
            local startpos = poscheck - Vector3.new(3, 3, 3)
            local endpos = poscheck + Vector3.new(3, 3, 3)
            local check = poscheck + (pos - poscheck).Unit * 100
            if math.abs(check.Y - startpos.Y) > 3 then
                return Vector3.new(poscheck.X, math.clamp(check.Y, startpos.Y, endpos.Y), poscheck.Z)
            end
        
            return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
        end
        
        local function blockProximity(pos)
            local mag, returned = 60
            local tab = getBlocksInPoints(pos - Vector3.new(21, 21, 21), pos + Vector3.new(21, 21, 21))
        
            for _, v in tab do
                local blockpos = nearCorner(v, pos)
                local newmag = (pos - blockpos).Magnitude
                if newmag < mag then
                    mag, returned = newmag, blockpos
                end
            end
        
            table.clear(tab)
            return returned
        end
        
        local function checkAdjacent(pos)
            for _, v in adjacent do
                if store.blocks[pos + v] then return true end
            end
            return false
        end
        
        local function getBlock()
            for slot, item in store.inventory do
                item = skywars.ItemMeta[item.Type]
                if item.Rewrite then return item, slot end
            end
        end
        
        Scaffold = World:CreateModule({
            Name = 'Scaffold',
            Function = function(callback)
                if callback then
                    repeat
                        if CharacterLib.Alive then
                            local wool = (not LimitItem.Enabled) and getBlock() or store.hand.Rewrite and store.hand
                            if wool then
                                local root = CharacterLib.Root
                                if Tower.Enabled and UIS:IsKeyDown(Enum.KeyCode.Space) and (not UIS:GetFocusedTextBox()) then
                                    root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
                                end
        
                                for i = Expand.Value, 1, -1 do
                                    local currentpos = roundPos(root.Position - Vector3.new(0, CharacterLib.HipHeight + (Downwards.Enabled and UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + CharacterLib.Humanoid.MoveDirection * (i * 3))
                                    if Diagonal.Enabled then
                                        if math.abs(math.round(math.deg(math.atan2(-CharacterLib.Humanoid.MoveDirection.X, -CharacterLib.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
                                            local dt = (lastpos - currentpos)
                                            if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
                                                currentpos = lastpos
                                            end
                                        end
                                    end
        
                                    local block = store.blocks[currentpos]
                                    if not block then
                                        local blockpos = checkAdjacent(currentpos) and currentpos or blockProximity(currentpos)
                                        if blockpos then
                                            local block = skywars.ItemMeta[wool.Rewrite.Type:gsub('{TeamId}', skywars.TeamController:getPlayerTeamId(Plr) or 'White')]
                                            skywars.BlockController:placeBlock(blockpos, wool.Name, block, vector.zero)
                                        end
                                    end
                                    lastpos = currentpos
                                end
                            end
                        end
        
                        task.wait(0.03)
                    until not Scaffold.Enabled
                end
            end,
            Info = 'Helps you make bridges/scaffold walk.'
        })
        Expand = Scaffold:CreateSlider({
            Name = 'Expand',
            Default = 1,
            Min = 1,
            Max = 6
        })
        Tower = Scaffold:CreateToggle({
            Name = 'Tower',
            Default = true
        })
        Downwards = Scaffold:CreateToggle({
            Name = 'Downwards',
            Default = true
        })
        Diagonal = Scaffold:CreateToggle({
            Name = 'Diagonal',
            Default = true
        })
        LimitItem = Scaffold:CreateToggle({
            Name = 'Limit to items'
        })
    end)

    Run(function() -- AntiVoid
        local AntiFall
        local Mode
        local Material
        local Color
        local part
        
        local function getLowGround()
            local mag = math.huge
            for pos in store.blocks do
                if pos.Y < mag and not store.blocks[pos + Vector3.new(0, 3, 0)] then
                    mag = pos.Y
                end
            end
            return mag
        end
        
        AntiFall = PlayerCategory:CreateModule({
            Name = 'AntiFall',
            Info = 'Help\'s you with your Parkinson\'s\nPrevents you from falling into the void.',
            Function = function(callback)
                if callback then
                    local pos, debounce = getLowGround(), tick()
                    if pos ~= math.huge then
                        local middle = next(store.blocks)
                        part = Instance.new('Part')
                        part.Size = Vector3.new(10000, 1, 10000)
                        part.Transparency = Color.Transparency
                        part.Material = Enum.Material[Material.Value]
                        part.Color = Color.Color
                        part.Position = Vector3.new(middle.X, pos - 2, middle.Z)
                        part.CanCollide = Mode.Value == 'Collide'
                        part.Anchored = true
                        part.CanQuery = false
                        part.Parent = workspace
                        AntiFall:Clean(part.Touched:Connect(function(touchedpart)
                            if touchedpart.Parent == Plr.Character and CharacterLib.Alive and debounce < tick() then
                                local root = CharacterLib.Root
                                debounce = tick() + 0.1
                                if Mode.Value == 'Velocity' then
                                    root.Velocity = Vector3.new(root.Velocity.X, 100, root.Velocity.Z)
                                end
                            end
                        end))
                    end
                else
                    if part then
                        part:Destroy()
                        part = nil
                    end
                end
            end,
        })
        Mode = AntiFall:CreateDropdown({
            Name = 'Move Mode',
            List = {'Velocity', 'Collide'},
            Function = function(val)
                if part then
                    part.CanCollide = val == 'Collide'
                end
            end,
            Info = 'Velocity - Launches you upward after touching\nCollide - Allows you to walk on the part'
        })
        local materials = {'ForceField'}
        for _, v in Enum.Material:GetEnumItems() do
            if v.Name ~= 'ForceField' then
                table.insert(materials, v.Name)
            end
        end
        Material = AntiFall:CreateDropdown({
            Name = 'Material',
            List = materials,
            Function = function(val)
                if part then
                    part.Material = Enum.Material[val]
                end
            end
        })
        Color = AntiFall:CreateColorPicker({
            Name = 'Color',
            Default = Color3.fromRGB(255, 255, 255),
            Transparency = 0.5,
            Function = function(Color, Transparency)
                if part then
                    part.Color = Color
                    part.Transparency = Transparency
                end
            end
        })
    end)

    Run(function() -- EggNuker
        local Breaker
        local Range
        local BreakerPart
        local BreakerUI
        local BreakerRef = skywars.Roact.createRef()
        
        local function clean()
            if not BreakerUI then return end
            if BreakerPart then
                BreakerPart:Destroy()
            end
        
            skywars.Roact.unmount(BreakerUI)
            BreakerUI = nil
            BreakerPart = nil
        end

        local White = Color3.new(1, 1, 1)
        
        local function customHealthbar(block, health, maxHealth, changeHealth)
            if not BreakerPart then
                local create = skywars.Roact.createElement
                local percent = math.clamp(health / maxHealth, 0, 1)
                local part = Instance.new('Part')
                part.Size = Vector3.one
                part.CFrame = block.PrimaryPart.CFrame
                part.Transparency = 1
                part.Anchored = true
                part.CanCollide = false
                part.Parent = workspace
                BreakerPart = part
        
                BreakerUI = skywars.Roact.mount(create('BillboardGui', {
                    Size = UDim2.fromOffset(249, 102),
                    StudsOffset = Vector3.new(0, 2.5, 0),
                    Adornee = part,
                    MaxDistance = 40,
                    AlwaysOnTop = true
                }, {
                    create('Frame', {
                        Size = UDim2.fromOffset(160, 50),
                        Position = UDim2.fromOffset(44, 32),
                        BackgroundColor3 = Color3.new(),
                        BackgroundTransparency = 0.5
                    }, {
                        create('UICorner', {CornerRadius = UDim.new(0, 5)}),
                        create('TextLabel', {
                            Size = UDim2.fromOffset(145, 14),
                            Position = UDim2.fromOffset(13, 12),
                            BackgroundTransparency = 1,
                            Text = block.Name,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            TextColor3 = Color3.new(),
                            TextScaled = true,
                            Font = Enum.Font.Arial
                        }),
                        create('TextLabel', {
                            Size = UDim2.fromOffset(145, 14),
                            Position = UDim2.fromOffset(12, 11),
                            BackgroundTransparency = 1,
                            Text = block.Name,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            TextColor3 = White,
                            TextScaled = true,
                            Font = Enum.Font.Arial
                        }),
                        create('Frame', {
                            Size = UDim2.fromOffset(138, 4),
                            Position = UDim2.fromOffset(12, 32),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                        }, {
                            create('UICorner', {CornerRadius = UDim.new(1, 0)}),
                            create('Frame', {
                                [skywars.Roact.Ref] = BreakerRef,
                                Size = UDim2.fromScale(percent, 1),
                                BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
                            }, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
                        })
                    })
                }), part)
        
                task.delay(5, clean)
            end
        
            local progress = math.clamp((health - changeHealth) / maxHealth, 0, 1)
            if progress == 0 then
                clean()
                return
            end
        
            task.delay(0, function()
                local val = BreakerRef:getValue()
                if val then
                    TweenService:Create(val, TweenInfo.new(0.3), {
                        Size = UDim2.fromScale(progress, 1),
                        BackgroundColor3 = Color3.fromHSV(math.clamp(progress / 2.5, 0, 1), 0.89, 0.75)
                    }):Play()
                end
            end)
        end
        
        Breaker = World:CreateModule({
            Name = 'EggNuker',
            Function = function(callback)
                if callback then
                    local eggs = collection('egg', Breaker)
                    local currentblock
                    local oldblockhealth = 0
        
                    repeat
                        if CharacterLib.Alive and store.hand then
                            local localPosition = CharacterLib.Root.CFrame.Position
                            for _, v in eggs do
                                if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude < Range.Value then
                                    local hp = v:GetAttribute('Health') or 0
                                    if v:GetAttribute('TeamId') == Plr:GetAttribute('TeamId') then continue end
                                    if currentblock ~= v then
                                        oldblockhealth = hp
                                        currentblock = v
                                    end
        
                                    if hp ~= oldblockhealth then
                                        customHealthbar(v, oldblockhealth, 100, oldblockhealth - hp)
                                        oldblockhealth = hp
                                    end
        
                                    store.noShoot = tick() + 1
                                    if hp <= 0 then continue end
        
                                    if store.hand.Melee then
                                        skywars.Remotes[remotes['MeleeController:attemptStrikeDesktop']]:fire(v)
                                    elseif store.hand.Pickaxe then
                                        skywars.Remotes[remotes.hitBlock]:fire((v.PrimaryPart.Position + Vector3.new(0, 1.5, 0)) // 1)
                                    end
                                end
                            end
                        end
        
                        task.wait(1 / 60)
                    until not Breaker.Enabled
                end
            end,
            Info = 'Automatically destroys eggs around you.'
        })
        Range = Breaker:CreateSlider({
            Name = 'Break range',
            Min = 1,
            Max = 40,
            Default = 40,
            Suffix = function(val)
                return val == 1 and 'stud' or 'studs'
            end
        })
    end)
end)

Run(function() -- Other
    Run(function() -- InvMove
        local InvMove, Old
        
        InvMove = Other:CreateModule({
            Name = 'InvMove',
            Info = 'Allows you to move while in your inventory and in shops.',
            Function = function(callback)
                if callback then
                    Old = skywars.FocusedController.enableFocus
                    skywars.FocusedController.enableFocus = function(self, screen, ...)
                        return Old(self, true, ...)
                    end
                else
                    skywars.FocusedController.enableFocus = Old
                    Old = nil
                end
            end
        })
    end)
end)

Notify({Text = 'Credits to @7GrandDad for the skywars modules.', Duration = 5})