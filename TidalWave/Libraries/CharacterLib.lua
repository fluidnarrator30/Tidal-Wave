local CloneRef = cloneref or function(Obj) return Obj end

local function GetService(Service)
    return CloneRef(game:GetService(Service))
end

local Players: Players = GetService("Players")
local UIS: UserInputService = GetService("UserInputService")

local TidalWave = shared.TidalWave

local Plr = Players.LocalPlayer
local Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")

local function Run(f)
    f()
end

local CharacterLib = {
    Alive = false,
    Running = false,
    List = {},
    Connections = {},
    PlayerConnections = {},
    CharacterThreads = {}
}

Run(function()
    local Event = {}
    Event.__index = Event

    function Event.new()
        local self = setmetatable({}, Event)
        self.Event = Instance.new("BindableEvent")

        return self
    end

    function Event:Destroy()
        self.Event:Destroy()
        self.Event = nil
    end

    function Event:Fire(...)
        self.Event:Fire(...)
    end

    function Event:Connect(f)
        return self.Event.Event:Connect(f)
    end

    function Event:Once(f)
        return self.Event.Event:Once(f)
    end

    function Event:Wait()
        return self.Event.Event:Wait()
    end

    CharacterLib.Events = setmetatable({}, {
        __index = function(self, i)
            self[i] = Event.new()
            return self[i]
        end
    })
end)

local function LoopClean(Tab)
    for i, v in Tab do
        if typeof(v) == "table" then
            LoopClean(v)
        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect()
        elseif typeof(v) == "thread" then
            pcall(task.cancel, v)
        end
    end
    table.clear(Tab)
end

function CharacterLib:WaitForChild(Obj, Name, TimeOut, Property)
    local Object = if Property then Obj[Name] else Obj:FindFirstChildOfClass(Name)
    if Object then
        return Object
    end

    local Thread = coroutine.running()

    if Property then
        local End = TimeOut and os.clock() + TimeOut
        repeat
            local Prop = Obj[Name]
            if Prop then
                return Prop
            end
            if End and os.clock() >= End then break end
            task.wait()
        until false
    else
        if CharacterLib.Connections[Obj] then return end

        local Con

        local function Disconnect()
            if Con then
                if Con.Connected then
                    Con:Disconnect()
                end
                Con = nil
            end
            if CharacterLib.Connections and CharacterLib.Connections[Obj] then
                CharacterLib.Connections[Obj] = nil
            end
        end

        CharacterLib.Connections[Obj] = {
            Disconnect = function()
                Disconnect()
                coroutine.resume(Thread, nil)
            end
        }

        Con = Obj.ChildAdded:Connect(function(Child)
            if Child:IsA(Name) then
                Disconnect()
                coroutine.resume(Thread, Child)
            end
        end)

        if TimeOut then
            task.delay(TimeOut, function()
                Disconnect()
                coroutine.resume(Thread, nil)
            end)
        end
    end

    return coroutine.yield()
end

function CharacterLib:IsTeammate(Character)
    if Character.NPC then return false end
    if TidalWave:IsFriend(Character.Player) then return true end
    if not Plr.Team then return false end
    if not Character.Player.Team then return false end
    if Character.Player.Team ~= Plr.Team then return false end
    return #Plr.Team:GetPlayers() ~= #Character.Player.Team:GetPlayers()
end

function CharacterLib:FindCharacter(Char)
    for i, v in CharacterLib.List do
        if v.Player == Char or v.Character == Char then
            return v, i
        end
    end
    return nil
end

function CharacterLib:GetUpdateConnections(Char)
    return {
        Char.Humanoid:GetPropertyChangedSignal("Health"),
        Char.Humanoid:GetPropertyChangedSignal("MaxHealth")
    }
end

function CharacterLib:GetTeamUpdateConnections(Char)
    return {
        Char.Player and Char.Player:GetPropertyChangedSignal("Team") or nil
    }
end

function CharacterLib:CanAttack(Character)
    return Character.Health > 0 and not Character.Character:FindFirstChildOfClass("ForceField")
end

function CharacterLib:GetTeamColor(Character)
    local IsFriend, FriendColor = TidalWave:IsFriend(Character.Player)
    return IsFriend and FriendColor or Character.Player and Character.Player.Team and Character.Player.TeamColor.Color or nil
end

local Params = RaycastParams.new()
Params.RespectCanCollide = true

function CharacterLib:WallCheck(Origin, Target)
    local IgnoreList = {CharacterLib.Character}
    for _, Character in CharacterLib.List do
        if not Character.CanAttack then
            table.insert(IgnoreList, Character.Character)
        end
    end

    Params.FilterDescendantsInstances = IgnoreList

	return workspace.Raycast(workspace, Origin, (Target - Origin), Params)
end

function CharacterLib:GetCharacterWithinMouse(Settings)
	if CharacterLib.Alive then
		local MouseLocation = Settings.MouseOrigin or UIS.GetMouseLocation(UIS)
        local WithinMouse = {}
		for i, v in CharacterLib.List do
			if not Settings.Players and v.Player then continue end
			if not Settings.NPCS and v.NPC then continue end
			if v.Teammate then continue end
            local Vector, OnScreen = Camera:WorldToViewportPoint(v[Settings.Part or "Root"].Position)
			if not OnScreen then continue end
			local Magnitude = (MouseLocation - Vector2.new(Vector.X, Vector.Y)).Magnitude
			if Magnitude > Settings.Range then continue end
			if CharacterLib:CanAttack(v) then
				table.insert(WithinMouse, {
					Character = v,
					Magnitude = Magnitude,
                    Vector = Vector
				})
			end
		end

		table.sort(WithinMouse, CharacterLib.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in WithinMouse do
			if Settings.WallCheck and CharacterLib:WallCheck(Settings.Origin or Camera.CFrame, v.Character[Settings.Part or "Root"].Position) then continue end
			return v.Character, v.Vector
		end
	end

    return nil
end

function CharacterLib:GetClosestCharacter(Settings)
	if CharacterLib.Alive then
		local RootPos, ClosestPlayers = Settings.Origin or CharacterLib.Root.Position, {}
		for _, v in CharacterLib.List do
			if not Settings.Players and v.Player then continue end
			if not Settings.NPCs and v.NPC then continue end
			if v.Teammate then continue end
			local Magnitude = (v[Settings.Part or "Root"].Position - RootPos).Magnitude
			if Magnitude > (Settings.Range or math.huge) then continue end
			if CharacterLib:CanAttack(v) then
				table.insert(ClosestPlayers, {Character = v, Magnitude = Magnitude})
			end
		end

		table.sort(ClosestPlayers, Settings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in ClosestPlayers do
			if Settings.WallCheck and CharacterLib:WallCheck(RootPos, v.Character[Settings.Part or "Root"].Position) then continue end
			return v
		end
	end

    return nil
end

function CharacterLib:GetClosestCharacters(Settings)
	local Returned = {}
	if CharacterLib.Alive then
		local RootPos, ClosestPlayers = Settings.Origin or CharacterLib.Root.Position, {}
		for _, v in CharacterLib.List do
			if not Settings.Players and v.Player then continue end
			if not Settings.NPCs and v.NPC then continue end
			if v.Teammate then continue end
			local Magnitude = (v[Settings.Part or "Root"].Position - RootPos).Magnitude
			if Magnitude > (Settings.Range or math.huge) then continue end
			if CharacterLib:CanAttack(v) then
				table.insert(ClosestPlayers, {Character = v, Magnitude = Magnitude})
			end
		end

		table.sort(ClosestPlayers, Settings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in ClosestPlayers do
			if Settings.WallCheck and CharacterLib:WallCheck(RootPos, v.Character[Settings.Part or "Root"].Position) then continue end
			table.insert(Returned, v.Character)
			if #Returned >= (Settings.Limit or math.huge) then break end
		end
	end

	return Returned
end

local LocalPlayerFilter = {"NPC", "Connections"}

function CharacterLib:AddCharacter(Char, Player)
    if not Char then return end
    CharacterLib.CharacterThreads[Char] = task.spawn(function()
        local Humanoid = CharacterLib:WaitForChild(Char, "Humanoid", 10)
        local Root = Humanoid and CharacterLib:WaitForChild(Humanoid, "RootPart", workspace.StreamingEnabled and 9e9 or 10, true)
        local Head = Char:WaitForChild("Head", 10) or Root

        if Root and Humanoid then
            local Character = {
                Player = Player,
                Character = Char,
                Humanoid = Humanoid,
                Animator = Humanoid:FindFirstChildOfClass("Animator"),
                Root = Root,
                Head = Head,
                Health = Humanoid.Health,
                MaxHealth = Humanoid.MaxHealth,
                HipHeight = Humanoid.HipHeight + (Root.Size.Y / 2) + (Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
                RigType = Humanoid.RigType,
                NPC = Player == nil,
                Connections = {}
            }

            if Player == Plr then
                for i, v in Character do
                    if table.find(LocalPlayerFilter, i) then continue end
                    CharacterLib[i] = v
                end
                CharacterLib.Alive = true
                CharacterLib.Events.LocalAdded:Fire(Character)
            else
                Character.Teammate = CharacterLib:IsTeammate(Character)
                for _, v in CharacterLib:GetUpdateConnections(Character) do
                    table.insert(Character.Connections, v:Connect(function()
                        Character.Health = Humanoid.Health
                        Character.MaxHealth = Humanoid.MaxHealth
                        CharacterLib.Events.CharacterUpdated:Fire(Character)
                    end))
                end
                for _, v in CharacterLib:GetTeamUpdateConnections(Character) do
                    table.insert(Character.Connections, v:Connect(function()
                        for _, v2 in CharacterLib.List do
                            if v2.Teammate ~= CharacterLib:IsTeammate(v2) then
                                CharacterLib:RefreshCharacter(v2.Character, v2.Player)
                            end
                        end
                        
                        if Player == Plr then
                            CharacterLib:Refresh()
                        else
                            CharacterLib:RefreshCharacter(Character.Character, Player)
                        end
                    end))
                end
                table.insert(CharacterLib.List, Character)
                CharacterLib.Events.CharacterAdded:Fire(Character)
            end
        end
        CharacterLib.CharacterThreads[Char] = nil
    end)
end

local ItemsToClear = {"Character", "Animator", "Humanoid", "Root", "Head", "Health", "MaxHealth", "HipHeight", "RigType"}

function CharacterLib:RemoveCharacter(Char, Player)
    if not Char then return end
    local Character, Index = CharacterLib:FindCharacter(Char)

    if Player == Plr then
        for _, v in ItemsToClear do
            CharacterLib[v] = nil
        end
        CharacterLib.Alive = false
        CharacterLib.Events.LocalRemoved:Fire(CharacterLib)
    elseif Character then
        local Thread = CharacterLib.CharacterThreads[Char]
        if Thread then
            task.cancel(Thread)
            CharacterLib.CharacterThreads[Char] = nil
        end
        LoopClean(Character.Connections)
        table.remove(CharacterLib.List, Index)
        CharacterLib.Events.CharacterRemoved:Fire(Character)
    end
end

function CharacterLib:RefreshCharacter(Char, Player)
    CharacterLib:RemoveCharacter(Char, Player)
    CharacterLib:AddCharacter(Char, Player)
end

function CharacterLib:AddPlayer(Player)
    if Player.Character then
        CharacterLib:RemoveCharacter(Player.Character, Player)
        CharacterLib:AddCharacter(Player.Character, Player)
    end

    CharacterLib.PlayerConnections[Player] = {
        Player.CharacterAdded:Connect(function(Char)
            CharacterLib:RefreshCharacter(Char, Player)
        end),
        Player.CharacterRemoving:Connect(function(Char)
            CharacterLib:RemoveCharacter(Char, Player)
        end),
    }
end

function CharacterLib:RemovePlayer(Player)
    local PlayerConnections = CharacterLib.PlayerConnections[Player]
    if PlayerConnections then
        for _, v in PlayerConnections do
            v:Disconnect()
        end
        table.clear(PlayerConnections)
        CharacterLib.PlayerConnections[Player] = nil
    end
    CharacterLib:RemoveCharacter(Player)
end

function CharacterLib:Start()
    if CharacterLib.Running then
        CharacterLib:Stop()
    end
    table.insert(CharacterLib.Connections, Players.PlayerAdded:Connect(function(Player)
        CharacterLib:AddPlayer(Player)
    end))
    table.insert(CharacterLib.Connections, Players.PlayerRemoving:Connect(function(Player)
        CharacterLib:RemovePlayer(Player)
    end))
    table.insert(CharacterLib.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    end))
    for i, Player in Players:GetPlayers() do
        CharacterLib:AddPlayer(Player)
    end
    CharacterLib.Running = true
end

function CharacterLib:Stop()
    for _, v in CharacterLib.Connections do
        v:Disconnect()
    end
    for _, v in CharacterLib.PlayerConnections do
        for _, v2 in v do
            v2:Disconnect()
        end
        table.clear(v)
    end
    table.clear(CharacterLib.Connections)
    table.clear(CharacterLib.PlayerConnections)
    CharacterLib.Running = false
end

function CharacterLib:Shutdown()
    if CharacterLib.Running then
        CharacterLib:Stop()
    end
    for i, v in CharacterLib.Events do
        v:Destroy()
    end

    LoopClean(CharacterLib)
end

function CharacterLib:Refresh()
    local Clone = table.clone(CharacterLib.List)
    for i, v in Clone do
        CharacterLib:RefreshCharacter(Clone.Character, Clone.Player)
    end
    table.clear(Clone)
end

function CharacterLib:Restart()
    CharacterLib:Stop()
    CharacterLib:Start()
end

CharacterLib:Start()

return CharacterLib