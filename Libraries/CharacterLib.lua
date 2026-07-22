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
    LocalConnections = {},
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
    for _, v in Tab do
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
            if End and os.clock() >= End then break end
            local Prop = Obj[Name]
            if Prop then
                return Prop
            end
            task.wait()
        until false
    else
        if CharacterLib.Connections[Obj] then return end

        local Con, DelayThread

        local function Disconnect()
            if Con then
                Con:Disconnect()
                Con = nil
            end
            if DelayThread then
                task.cancel(DelayThread)
                DelayThread = nil
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
            DelayThread = task.delay(TimeOut, function()
                DelayThread = nil
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
    if Character.Player.Team == Plr.Team then return true end
    if #Plr.Team:GetPlayers() == #Character.Player.Team:GetPlayers() then return true end
    return false
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
    return {}
end

function CharacterLib:GetCharacterProperties(Char)
    return {
        Health = Char.Humanoid.Health,
        MaxHealth = Char.Humanoid.MaxHealth
    }
end

function CharacterLib:CanAttack(Character)
    return Character.Health > 0 and not Character.Character:FindFirstChildOfClass("ForceField")
end

function CharacterLib:GetTeamColor(Character)
    return (Character.Player and Character.Player.Team and Character.Player.TeamColor.Color) or nil
end

local Params = RaycastParams.new()
Params.RespectCanCollide = true

function CharacterLib:WallCheck(Origin, Target)
    local IgnoreList = {CharacterLib.Character}
    for _, Character in CharacterLib.List do
        if not Character.CanAttack then
            IgnoreList[#IgnoreList + 1] = Character.Character
        end
    end

    Params.FilterDescendantsInstances = IgnoreList

	return workspace.Raycast(workspace, Origin, (Target - Origin), Params)
end

function CharacterLib:GetCharacterWithinMouse(Settings)
	if CharacterLib.Alive then
		local MouseLocation = Settings.MouseOrigin or UIS.GetMouseLocation(UIS)
        local WithinMouse = {}
        local Part = Settings.Part or 'Root'
		for _, v in CharacterLib.List do
            if v.Player and not Settings.Players then continue end
            if v.NPC and not Settings.NPCS then continue end
            if v.Teammate then continue end
            local Vector, OnScreen = Camera:WorldToViewportPoint(v[Part].Position)
            if OnScreen then
                local Magnitude = (MouseLocation - Vector2.new(Vector.X, Vector.Y)).Magnitude
                if Magnitude <= Settings.Range and CharacterLib:CanAttack(v) then
                    WithinMouse[#WithinMouse + 1] = {
                        Character = v,
                        Magnitude = Magnitude,
                        Vector = Vector
                    }
                end
            end
		end

		table.sort(WithinMouse, CharacterLib.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in WithinMouse do
			if Settings.WallCheck and CharacterLib:WallCheck(Settings.Origin or Camera.CFrame, v.Character[Part].Position) then continue end
			return v.Character, v.Vector
		end
	end

    return nil
end

function CharacterLib:GetClosestCharacter(Settings)
	if CharacterLib.Alive then
		local RootPos, ClosestPlayers = Settings.Origin or CharacterLib.Root.Position, {}
        local Part = Settings.Part or 'Root'
        local Range = Settings.Range or math.huge
		for _, v in CharacterLib.List do
			if v.Player and not Settings.Players then continue end
            if v.NPC and not Settings.NPCS then continue end
            if v.Teammate then continue end
			local Magnitude = (v[Part].Position - RootPos).Magnitude
			if Magnitude <= Range and CharacterLib:CanAttack(v) then
                ClosestPlayers[#ClosestPlayers + 1] = {
                    Character = v,
                    Magnitude = Magnitude
                }
			end
		end

		table.sort(ClosestPlayers, Settings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in ClosestPlayers do
			if Settings.WallCheck and CharacterLib:WallCheck(RootPos, v.Character[Part].Position) then continue end
			return v.Character
		end
	end

    return nil
end

function CharacterLib:GetClosestCharacters(Settings)
	local Returned = {}
	if CharacterLib.Alive then
		local RootPos, ClosestPlayers = Settings.Origin or CharacterLib.Root.Position, {}
        local Part = Settings.Part or 'Root'
        local Range = Settings.Range or math.huge
        local Limit = Settings.Limit or math.huge
		for _, v in CharacterLib.List do
			if v.Player and not Settings.Players then continue end
            if v.NPC and not Settings.NPCS then continue end
            if v.Teammate then continue end
			local Magnitude = (v[Part].Position - RootPos).Magnitude
			if Magnitude <= Range and CharacterLib:CanAttack(v) then
                ClosestPlayers[#ClosestPlayers + 1] = {
                    Character = v,
                    Magnitude = Magnitude
                }
			end
		end

		table.sort(ClosestPlayers, Settings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in ClosestPlayers do
			if Settings.WallCheck and CharacterLib:WallCheck(RootPos, v.Character[Part].Position) then continue end
            local i = #Returned + 1
            Returned[i] = v.Character
			if i >= Limit then break end
		end
	end

	return Returned
end

local LocalCharacterPropertyBlacklist = {
    NPC = true,
    Connections = true
}

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
                Torso = if Humanoid.RigType == Enum.HumanoidRigType.R6 then Char:FindFirstChild('Torso') else Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("LowerTorso"),
                HipHeight = Humanoid.HipHeight + (Root.Size.Y / 2) + (Humanoid.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
                RigType = Humanoid.RigType,
                NPC = Player == nil,
                Connections = {}
            }

            for i, v in CharacterLib:GetCharacterProperties(Character) do
                Character[i] = v
            end

            local ConnectionsTable = Player == Plr and CharacterLib.LocalConnections or Character.Connections

            for _, v in CharacterLib:GetUpdateConnections(Character) do
                ConnectionsTable[#ConnectionsTable + 1] = v:Connect(function()
                    for Property, Value in CharacterLib:GetCharacterProperties(Character) do
                        Character[Property] = Value
                        if LocalCharacterPropertyBlacklist[Property] then return end
                        CharacterLib[Property] = Value
                    end
                    CharacterLib.Events[Player == Plr and 'LocalUpdated' or 'CharacterUpdated']:Fire(Character)
                end)
            end
            for _, v in CharacterLib:GetTeamUpdateConnections(Character) do
                ConnectionsTable[#ConnectionsTable + 1] = v:Connect(function()
                    if Player == Plr then
                        CharacterLib:Refresh()
                    else
                        CharacterLib:RefreshCharacter(Character.Character, Player)
                    end
                    CharacterLib.Events[Player == Plr and 'LocalTeamChanged' or 'TeamChanged']:Fire(Character)
                end)
            end

            if Player == Plr then
                for i, v in Character do
                    if LocalCharacterPropertyBlacklist[i] then continue end
                    CharacterLib[i] = v
                end
                CharacterLib.Alive = true
                CharacterLib.Events.LocalAdded:Fire(Character)
            else
                Character.Teammate = CharacterLib:IsTeammate(Character)
                CharacterLib.List[#CharacterLib.List + 1] = Character
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
        for _, v in CharacterLib.LocalConnections do
            v:Disconnect()
        end
        table.clear(CharacterLib.LocalConnections)
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
        Player:GetPropertyChangedSignal("Team"):Connect(function()
            if Player == Plr then
                CharacterLib:Refresh()
            else
                CharacterLib:RefreshCharacter(Player.Character, Player)
            end
        end)
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
    CharacterLib.Connections[#CharacterLib.Connections + 1] = Players.PlayerAdded:Connect(function(Player)
        CharacterLib:AddPlayer(Player)
    end)
    CharacterLib.Connections[#CharacterLib.Connections + 1] = Players.PlayerRemoving:Connect(function(Player)
        CharacterLib:RemovePlayer(Player)
    end)
    CharacterLib.Connections[#CharacterLib.Connections + 1] = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        Camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    end)
    for _, Player in Players:GetPlayers() do
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
    for _, Player in Players:GetPlayers() do
        CharacterLib:RemovePlayer(Player)
    end
    for _, Character in CharacterLib.List do
        CharacterLib:RemoveCharacter(Character)
    end
    table.clear(CharacterLib.Connections)
    table.clear(CharacterLib.PlayerConnections)
    CharacterLib.Running = false
end

function CharacterLib:Shutdown()
    if CharacterLib.Running then
        CharacterLib:Stop()
    end
    for _, v in CharacterLib.Events do
        v:Destroy()
    end

    LoopClean(CharacterLib)
end

function CharacterLib:Refresh()
    for _, Char in  CharacterLib.List do
        CharacterLib:RefreshCharacter(Char.Character, Char.Player)
    end
end

function CharacterLib:Restart()
    CharacterLib:Stop()
    CharacterLib:Start()
end

CharacterLib:Start()

return CharacterLib