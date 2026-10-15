const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
	return cloneref(game:GetService(Service))
end

const RunService: RunService = GetService('RunService')
const HttpService = GetService('HttpService')
const Players: Players = GetService('Players')
const CoreGui: CoreGui = GetService('CoreGui')
const TweenService: TweenService = GetService('TweenService')
const UIS: UserInputService = GetService('UserInputService')
const TextService: TextService = GetService('TextService')
const MarketplaceService: MarketplaceService = GetService('MarketplaceService')
const GuiService: GuiService = GetService('GuiService')

const GetTextBoundsParams = Instance.new('GetTextBoundsParams')
GetTextBoundsParams.Width = math.huge

local TextGUI, Components, ModulesTopBar, ThemesDropdown
local PrevMenu, HudMenu, GuiMenu, ConfigMenu, FriendsMenu, MenuOptions, ProfilesMenu
local Gui, Tooltip, TopBar, GuiScale, Modala
local NotificationHolder, HudFolder, CategoryHolder, MenuHolder, CurrentColorPicker, ColorPickerHidMenuOptions

const Plr: Player = Players.LocalPlayer
local Camera: Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
const Mouse: Mouse = cloneref(Plr:GetMouse())

const Color3 = table.clone(Color3)
Color3.White = Color3.new(1, 1, 1)
Color3.Black = Color3.new()
Color3.Red = Color3.new(1, 0, 0)
Color3.Green = Color3.new(0, 1, 0)
Color3.Blue = Color3.new(0, 0, 1)
Color3.Yellow = Color3.new(1, 1, 0)
Color3.Cyan = Color3.new(0, 1, 1)
Color3.Pink = Color3.new(1, 0, 1)
Color3.fromRGBT = function(R, G, B, T)
	const self = {}
	self.R = R or 255
	self.G = G or 255
	self.B = B or 255
	self.T = T or 0
	self.Transparency = self.T
	self.Color = Color3.fromRGB(self.R, self.G, self.B)

	return self
end

const UDim2 = table.clone(UDim2)
UDim2.zero = UDim2.new()

const UDim = table.clone(UDim)
UDim.zero = UDim.new()

const table = table.clone(table)
table.len = function(Tab)
	local Len = 0
	for _ in Tab do
		Len += 1
	end
	return Len
end

const IsStudio = RunService:IsStudio()
const RootPath = shared.RootPath or script

const Lucide = IsStudio and require(RootPath.Libraries.Lucide) or loadstring(game:HttpGet('https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua'), 'Lucide')()
const loadstring = IsStudio and require(RootPath.Libraries.Loadstring) or loadstring
const getcustomasset = getcustomasset or function(Path) return `rbxasset://{Path}` end
const gethui = gethui or function() return (CoreGui and CoreGui:FindFirstChild('RobloxGui')) or CoreGui or Plr:FindFirstChildOfClass('PlayerGui') end
const queueonteleport = queueonteleport or queue_on_teleport
local readfile, isfile, writefile, delfile, listfiles = readfile, isfile, writefile, delfile, listfiles

if IsStudio then
	const FileSystem = require(RootPath.Libraries.FileSystem)
	readfile = FileSystem.readfile
	isfile = FileSystem.isfile
	writefile = FileSystem.writefile
	delfile = FileSystem.delfile
	listfiles = FileSystem.listfiles
end

const BuiltInThemes = {
	TidalWave = {
		Main = {
			Accent = Color3.fromRGBT(18, 124, 230),
			Icons = Color3.fromRGBT(255, 255, 255),
			EnabledBar = Color3.fromRGBT(8, 120, 209),
			DisabledBar = Color3.fromRGBT(0, 75, 133),
		},
		Text = {
			ModuleEnabled = Color3.fromRGBT(55, 188, 255),
			Primary = Color3.fromRGBT(255, 255, 255),
			Secondary = Color3.fromRGBT(200, 200, 200),
			Placeholder = Color3.fromRGBT(127, 127, 127),
			Shadow = Color3.fromRGBT(0, 0, 0),
			Tooltip = Color3.fromRGBT(255, 255, 255)
		},
		Background = {
			Primary = Color3.fromRGBT(25, 25, 25),
			Secondary = Color3.fromRGBT(18, 18, 18),
			Button = Color3.fromRGBT(20, 20, 20),
			ButtonHover = Color3.fromRGBT(40, 40, 40),
			Tooltip = Color3.fromRGBT(0, 0, 0, 0.3),
			Notification = Color3.fromRGBT(0, 0, 0, 0.2),
		},
		Outline = {
			Primary = Color3.fromRGBT(0, 0, 0),
			Tooltip = Color3.fromRGBT(0, 0, 0),
			Notification = Color3.fromRGBT(0, 0, 0),
		},
		Slider = {
			Handle = Color3.fromRGBT(18, 124, 230),
			HandleHover = Color3.fromRGBT(0, 128, 255),
			HandlePress = Color3.fromRGBT(18, 124, 230),
			LeftBar = Color3.fromRGBT(14, 97, 180),
			RightBar = Color3.fromRGBT(40, 40, 40),
		},
		Notification = {
			ProgressBar = Color3.fromRGBT(255, 255, 255),
			Info = Color3.fromRGBT(255, 255, 255),
			Warning = Color3.fromRGBT(255, 100, 0),
			Error = Color3.fromRGBT(255, 50, 50),
			ModuleEnabled = Color3.fromRGBT(75, 255, 75),
			ModuleDisabled = Color3.fromRGBT(255, 75, 75),
		},
	}
}

local TidalWave = {
	Scale = true,
	Tooltip = true,
	Notifications = true,
	CategoryAnimations = true,
	RGBSpeed = 1,
	RGBSpread = 1,
	RGBRefreshRate = 60,
	ModuleToggledNotificationDuration = 2,
	NotificationCornerRadius = 6,
	Profile = 'Default',
	NotificationHorizontalAlignment = 'Right',
	NotificationVerticalAlignment = 'Bottom',
	NotificationFillDirection = 'Up',
	Version = '2.3.0-beta',
	Theme = 'TidalWave',
	RGBTable = {
		Linear = {},
		Gradient = {
			All = {}
		},
	},
	Profiles = {},
	Friends = {},
	PressedKeys = {},
	Menus = {},
	Modules = {},
	Buttons = {},
	Categories = {},
	Fonts = {
		Regular = Font.fromEnum(Enum.Font.Gotham),
		Medium = Font.fromEnum(Enum.Font.GothamMedium),
		Bold = Font.fromEnum(Enum.Font.GothamBold)
	},
	Themes = table.clone(BuiltInThemes),
	PlaceName = (function()
		const Success, Result = pcall(function()
			return MarketplaceService:GetProductInfoAsync(game.PlaceId)
		end)

		if Success and Result then
			return Result.Name:gsub('^[%s]*', ''):gsub('(%w)[%s]*$', function(Match) return Match end)
		else
			return 'Unknown'
		end
	end)()
}

--#region Functions

const function Run(f)
	f()
end

const function AddMaid(Obj)
	Obj.Connections = {}

	const CONNECTED_METATABLE = {
		__index = function(self, i)
			if i == 'Connected' then
				return self._Connected()
			end

			return nil
		end
	}

	const function Remove(Tab, Item)
		const Index = table.find(Tab, Item)
		if Index then
			table.remove(Tab, Index)
		end
	end

	const Types = {
		Instance = function(self, Item)
			local AncestryChanged

			const Disconnect = function()
				if AncestryChanged then
					AncestryChanged:Disconnect()
					AncestryChanged = nil
				end
				Item:Destroy()
				Remove(self.Connections, Item)
			end
			
			const Connected = function()
				return Item and Item.Parent ~= nil
			end

			AncestryChanged = Item.AncestryChanged:Connect(function(_, Parent)
				if Parent == nil then
					Disconnect()
				end
			end)

			return Disconnect, Connected
		end,
		['function'] = function(self, Item, Args)
			const Disconnect = function()
				Remove(self.Connections, Item)
				Item(table.unpack(Args))
			end

			const Connected = function()
				return true
			end

			return Disconnect, Connected
		end,
		RBXScriptConnection = function(self, Item)
			const Disconnect = function()
				Item:Disconnect()
				Remove(self.Connections, Item)
			end

			const Connected = function()
				return Item and Item.Connected
			end

			return Disconnect, Connected
		end,
		thread = function(self, Item)
			const Disconnect = function()
				pcall(task.cancel, Item)
				Remove(self.Connections, Item)
			end

			const Connected = function()
				return Item and coroutine.status(Item) ~= 'dead'
			end

			return Disconnect, Connected
		end,
		table = function(self, Item)
			if not Item._fn then return end

			const Disconnect = function()
				Item:Disconnect()
				Remove(self.Connections, Item)
			end

			const Connected = function()
				return Item and Item._connected
			end
			
			return Disconnect, Connected
		end
	}

	function Obj:Clean(Item, ...)
		const Type = typeof(Item)
		const Function = Types[typeof(Item)]
		assert(Function, `Invalid type '{Type}' to Clean()`)
		const Disconnect, Connected = Function(self, Item, {...})
		assert(Disconnect and Connected, `Invalid type '{Type}' to Clean()`)

		const Connection = setmetatable({}, CONNECTED_METATABLE)
		Connection.Disconnect = Disconnect
		Connection.Destroy = Disconnect
		Connection.Remove = Disconnect
		Connection.Type = Type
		Connection._Connected = Connected

		table.insert(Obj.Connections, Connection)

		return Connection
	end

	function Obj:CleanUp()
		for i = #self.Connections, 1, -1 do
			if not self.Connections[i].Connected then
				table.remove(self.Connections, i)
			end
		end
	end

	function Obj:DisconnectAll()
		for _, Connection in self.Connections do
			Connection:Disconnect()
		end
	end
end

const function AddInstanceTable(Obj)
	Obj.Instances = {}
	Obj.InstanceConnections = {}

	function Obj:GetInstance(Name)
		return self.Instances[Name]
	end

	function Obj:RemoveInstance(Name)
		const Con = self.InstanceConnections[Name]
		if Con then
			Con:Disconnect()
			self.InstanceConnections[Name] = nil
		end

		const Object = self.Instances[Name]
		if Object then
			Object:Destroy()
			self.Instances[Name] = nil
		end
	end

	function Obj:CreateInstance(Class, Name, Properties)
		self:RemoveInstance(Name)
		const Obj = Instance.new(Class)
		if Properties then
			const Parent = Properties.Parent
			Properties.Parent = nil
			for Property, Value in Properties do
				Obj[Property] = Value
			end
			Obj.Parent = Parent
		end

		self.Instances[Name] = Obj
		self.InstanceConnections[Name] = Obj.AncestryChanged:Connect(function(_, Parent)
			if Parent == nil then
				self:RemoveInstance(Name)
			end
		end)

		return Obj
	end

	function Obj:ClearInstances()
		for Name in self.Instances do
			self:RemoveInstance(Name)
		end
	end
end

const SearchMatches = {}
const ListeningObjects = {
	Colors = {},
	Fonts = {
		Regular = {},
		Medium = {},
		Bold = {},
	},
	FontSizes = {}
}

for Category, Colors in BuiltInThemes.TidalWave do
	ListeningObjects.Colors[Category] = {}

	for Name, Color in Colors do
		ListeningObjects.Colors[Category][Name] = {}
	end
end

const GuiObjectBackgroundProperties = {
	Frame = {'BackgroundColor3', 'BackgroundTransparency'},
	ScrollingFrame = {'BackgroundColor3', 'BackgroundTransparency'},
	TextButton = {'BackgroundColor3', 'BackgroundTransparency'},
	TextLabel = {'BackgroundColor3', 'BackgroundTransparency'},
	TextBox = {'BackgroundColor3', 'BackgroundTransparency'},
	ImageLabel = {'ImageColor3', 'ImageTransparency'},
	ImageButton = {'ImageColor3', 'ImageTransparency'},
	UIStroke = {'Color', 'Transparency'},
}

const GuiObjectTextProperties = {
	TextLabel = {'TextColor3', 'TextTransparency'},
	TextButton = {'TextColor3', 'TextTransparency'},
	TextBox = {'TextColor3', 'TextTransparency', 'PlaceholderColor3'},
}

const function ListenObject(Obj, First, Second, Callback)
	local SplitText = First and First:split('/') or nil
	if SplitText then
		ListeningObjects.Colors[SplitText[1]][SplitText[2]][Obj] = Callback or 'None'
	end
	SplitText = Second and Second:split('/') or nil
	if SplitText then
		ListeningObjects.Colors[SplitText[1]][SplitText[2]][Obj] = Callback or 'None'
	end
end

const function ListenFont(Obj, Font, Callback)
	ListeningObjects.Fonts[Font][Obj] = Callback or 'None'
end

const function StopListeningFont(Obj)
	local Found
	for Font, Objects in ListeningObjects.Fonts do
		for Object in Objects do
			if Object == Obj then
				Objects[Obj] = nil
				Found = true
				break
			end
		end
		if Found then break end
	end
end

const function StopListeningObject(Obj)
	for _, Category in ListeningObjects.Colors do
		local Found
		for _, Colors in Category do
			for Object, Function in Colors do
				if Object == Obj then
					Found = true
					Colors[Object] = nil
					break
				end
			end
			if Found then break end
		end
		if Found then break end
	end
end

const function GetCurrentTheme()
	return TidalWave.Themes[TidalWave.Theme]
end

const function GetColor(Type)
	const CurrentTheme = GetCurrentTheme()
	if CurrentTheme then
		local CurrentColor
		for _, v in Type:split('/') do
			CurrentColor = (CurrentColor or CurrentTheme)[v]
			if not CurrentColor then
				return Color3.White
			end
		end

		return CurrentColor.Color, CurrentColor.T
	else
		return Color3.White
	end
end

const function SetColor(Type, Color, Transparency)
	const CurrentTheme = GetCurrentTheme()
	if CurrentTheme and not BuiltInThemes[TidalWave.Theme] then
		const First, Second = table.unpack(Type:split('/'))
		if Color.R > 1 or Color.G > 1 or Color.B > 1 then
			Color = {R = Color.R / 255, G = Color.G / 255, B = Color.B / 255}
		end
		CurrentTheme[First][Second] = Color3.fromRGBT(Color.R * 255, Color.G * 255, Color.B * 255, Transparency or CurrentTheme[First][Second].Transparency or 0)
		const Tab = First == 'Text' and GuiObjectTextProperties or GuiObjectBackgroundProperties
		for Obj, Callback in ListeningObjects.Colors[First][Second] do
			const Properties = Tab[Obj.ClassName]
			const ColorProp, TransparencyProp = Properties[1], Properties[2]
			if typeof(Callback) == 'function' then
				Callback()
			else
				Obj[ColorProp] = Color
				if TransparencyProp then
					Obj[TransparencyProp] = Transparency
				end
			end
		end
	end
end

const function GetFont(FontName)
	return TidalWave.Fonts[FontName]
end

const function SetFont(FontType, NewFont)
	TidalWave.Fonts[FontType] = NewFont

	for Object, Callback in ListeningObjects.Fonts[FontType] do
		if typeof(Callback) == 'function' then
			Callback()
		else
			Object.FontFace = NewFont
		end
	end
end

const function AddCorner(Obj, CornerRadius)
	const UICorner = Instance.new('UICorner')
	UICorner.CornerRadius = CornerRadius
	UICorner.Parent = Obj
end

const function GetTextBounds(Text, TextSize, Font)
	GetTextBoundsParams.Text = Text
	GetTextBoundsParams.Size = TextSize
	GetTextBoundsParams.Font = Font or GetFont('Regular')
	GetTextBoundsParams.RichText = Text:match('<[^<>]->') ~= nil

	return TextService:GetTextBoundsAsync(GetTextBoundsParams)
end

const function CreateTopBarButton(Properties)
	const self = {}

	const TextWidth = math.max(GetTextBounds(Properties.Name, 24).X + 10, 80)

	const Button = Instance.new('TextButton')
	Button.Text = Properties.Name
	Button.Name = Properties.Name
	Button.LayoutOrder = #TopBar:GetChildren()
	Button.Size = UDim2.fromOffset(TextWidth, 36)
	Button.BackgroundColor3 = GetColor('Background/Button')
	Button.BackgroundTransparency = 0.25
	Button.BorderSizePixel = 0
	Button.TextColor3 = GetColor('Text/Primary')
	Button.AutoButtonColor = false
	Button.FontFace = GetFont('Regular')
	Button.TextSize = 24
	Button.Parent = TopBar
	AddCorner(Button, UDim.new(0, 9))
	ListenObject(Button, 'Background/Button', 'Text/Primary', function()
		Button.BackgroundColor3 = TidalWave.SelectedTopBar == Button and GetColor('Background/ButtonHover') or GetColor('Background/Button')
		Button.TextColor3 = GetColor('Text/Primary')
	end)
	ListenFont(Button, 'Regular')

	TopBar.Size += UDim2.fromOffset(TextWidth + 8, 0)

	const Info = TweenInfo.new(0.1)

	function self:Select(...)
		if CurrentColorPicker then
			CurrentColorPicker.Visible = false
			CurrentColorPicker = nil
		end

		for _, Obj in TopBar:GetChildren() do
			if Obj:IsA('TextButton') then
				if Obj == Button then
					const HoverColor = GetColor('Background/ButtonHover')
					if Obj.BackgroundColor3 ~= HoverColor then
						TweenService:Create(Button, Info, {BackgroundColor3 = HoverColor}):Play()
					end

					if Properties.Function then
						Properties.Function(...)
					end
				else
					const ButtonColor = GetColor('Background/Button')
					if Obj.BackgroundColor3 ~= ButtonColor then
						TweenService:Create(Obj, Info, {BackgroundColor3 = ButtonColor}):Play()
					end
				end
			end
		end
		TidalWave.SelectedTopBar = Button
	end

	Button.MouseButton1Click:Connect(self.Select)

	self.Object = Button

	return self
end

const GUICHECK_BLACKLIST = {
	Tooltip = true,
	Cursor = true
}

const function GuiCheck(GuiObject)
	const Parent = Gui.Parent:IsA('BasePlayerGui') and Gui.Parent or CoreGui
	const Objects = Parent:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)

	for _, Obj in Objects do
		if Obj == GuiObject then
			return true
		elseif Obj.Visible and Obj.BackgroundTransparency ~= 1 and Obj.Active and Obj.Interactable and not GUICHECK_BLACKLIST[Obj] and Obj:IsDescendantOf(Gui) then
			return false
		end
	end

	return false
end

const function AddTooltip(Obj, Text, NoGuiCheck)
	if typeof(Text) == 'string' and Text:match('%w+') then
		const function OnMouseMoved(X, Y)
			if not TidalWave.Tooltip then
				Tooltip.Visible = false
				return
			end
			Y -= Tooltip.AbsoluteSize.Y
			if X + Tooltip.AbsoluteSize.X > Camera.ViewportSize.X then
				X -= Tooltip.AbsoluteSize.X
			end
			Tooltip.Position = UDim2.fromOffset(X / GuiScale.Scale, Y / GuiScale.Scale)

			if NoGuiCheck then
				Tooltip.Visible = true
			else
				if GuiCheck(Obj) then
					Tooltip.Visible = true
				else
					Tooltip.Visible = false
				end
			end
		end

		Obj.MouseEnter:Connect(function(X, Y)
			if not TidalWave.Tooltip then return end
			local TextBounds = GetTextBounds(Text, Tooltip.TextSize * GuiScale.Scale, Tooltip.FontFace) / GuiScale.Scale
			Tooltip.Text = Text
			Tooltip.Size = UDim2.fromOffset(TextBounds.X + 10, TextBounds.Y + 8)

			OnMouseMoved(X, Y)
		end)

		Obj.MouseMoved:Connect(OnMouseMoved)
		Obj.MouseLeave:Connect(function()
			Tooltip.Visible = false
		end)
	end
end

const function AddHighlight(Obj: GuiObject, CustomColor: string?, NoGuiCheck: boolean?)
	const function MouseEnter()
		if not NoGuiCheck and not GuiCheck(Obj) then return end
		
		local Color, Transparency = GetColor('Background/ButtonHover')
		Obj.BackgroundColor3, Obj.BackgroundTransparency = Color, Transparency
	end

	const function MouseLeave()
		if SearchMatches[Obj] then
			MouseEnter()
			return
		end

		local Color, Transparency = GetColor(CustomColor or 'Background/Button')
		Obj.BackgroundColor3, Obj.BackgroundTransparency = Color, Transparency
	end

	const function MouseMove()
		if NoGuiCheck then return end
		
		if GuiCheck(Obj) then
			if Obj.BackgroundColor3 ~= GetColor('Background/ButtonHover') then
				MouseEnter()
			end
		else
			MouseLeave()
		end
	end

	Obj.MouseMoved:Connect(MouseMove)
	Obj.MouseEnter:Connect(MouseEnter)
	Obj.MouseLeave:Connect(MouseLeave)
end

const function SetIcon(Obj, IconName)
	const Icon = Lucide.GetAsset(IconName)
	Obj.Image = Icon.Url
	Obj.ImageRectOffset = Icon.ImageRectOffset
	Obj.ImageRectSize = Icon.ImageRectSize
end

const LoopClean_SearchedTables = {}

const function LoopClean(Tab, First)
	if getmetatable(Tab) then
		setmetatable(Tab, nil)
	end

	if table.len(Tab) > 0 then
		for i, v in Tab do
			if typeof(v) == 'table' and not table.find(LoopClean_SearchedTables, v) then
				table.insert(LoopClean_SearchedTables, v)
				LoopClean(v)
			elseif typeof(v) == 'thread' then
				pcall(task.cancel, v)
			elseif typeof(v) == 'RBXScriptConnection' then
				v:Disconnect()
			end
		end
	end

	if First then
		table.clear(LoopClean_SearchedTables)
	end

	table.clear(Tab)
end

const function RemoveTags(Str)
	return Str:gsub('<[^<>]->', '')
end

const function Notify(Properties)
	TidalWave:Notify(Properties)
end

const function NotifyPoopSploit(Function)
	Notify({
		Title = 'Poop Sploit',
		Text = `Your executor doesn't support '{Function}'`,
		Type = 'Error',
		Duration = 5,
	})
end

const function GetAssetFromText(Text)
	const RbxAsset = Text:match('^rbxassetid://%d+$')
	if RbxAsset then
		return RbxAsset
	else
		const Id = Text:match('^%d+$')
		if Id then
			return `rbxassetid://{Id}`
		elseif getcustomasset and Text ~= '' then
			local Checked = false
			local Exists = false
			if isfile then
				Checked = true
				Exists = isfile(Text)
			end
			
			if Checked then
				if Exists then
					return getcustomasset(Text)
				else
					return nil, 'File not found'
				end
			else
				const Success, Result = pcall(function()
					return getcustomasset(Text)
				end)

				if Success and Result and Result ~= '' then
					return Result
				else
					return nil, Result
				end
			end
		end
	end

	return nil
end

const function CheckPlayer(Player: Player, Name: string): boolean
	Name = Name:lower()
	const PlayerName, DisplayName = Player.Name:lower(), Player.DisplayName:lower()
	const SubCheck = PlayerName:sub(1, #Name) == Name or Name:sub(1, #PlayerName) == PlayerName or DisplayName:sub(1, #Name) == Name or Name:sub(1, #DisplayName) == DisplayName
	const MatchCheck = (PlayerName:match(Name) or Name:match(PlayerName) or DisplayName:match(Name) or Name:match(DisplayName)) ~= nil
	return SubCheck or MatchCheck
end

const function FindPlayer(Name: string)
	if typeof(Name) ~= 'string' then return end
	Name = Name:lower()
	
	for _, Player in Players:GetPlayers() do
		if Player == Plr then continue end
		if Player.Name:lower():sub(1, #Name) == Name then
			return Player
		elseif Player.DisplayName:lower():sub(1, #Name) == Name then
			return Player
		end
	end
	
	return nil
end

const function GetFullPlayerName(Player: Player): string
	return Player.DisplayName == Player.Name and Player.Name or `{Player.DisplayName} (@{Player.Name})`
end

const function TableToUDim2(Tab)
	return UDim2.new(Tab.X.Scale, Tab.X.Offset, Tab.Y.Scale, Tab.Y.Offset)
end

const function FontToTable(Font)
	return {
		Family = Font.Family,
		Weight = Font.Weight.Name
	}
end

const function TableToFont(Tab)
	return Font.new(Tab.Family, Enum.FontWeight[Tab.Weight])
end

const function UDim2ToTable(Pos)
	return {
		X = {
			Scale = Pos.X.Scale,
			Offset = Pos.X.Offset
		},
		Y = {
			Scale = Pos.Y.Scale,
			Offset = Pos.Y.Offset
		}
	}
end

const function LoadThemes(JSON)
	if not JSON.Themes then return table.clone(BuiltInThemes) end
	const NewThemes = {}

	for ThemeName, Theme in JSON.Themes do
		NewThemes[ThemeName] = {}
		for CategoryName, Category in Theme do
			NewThemes[ThemeName][CategoryName] = {}
			for ColorName, Color in Category do
				NewThemes[ThemeName][CategoryName][ColorName] = Color3.fromRGBT(Color.R, Color.G, Color.B, Color.T)
			end
		end
	end

	return NewThemes
end

const function SaveThemes()
	const Tab = {}
	for i, v in TidalWave.Themes do
		if BuiltInThemes[i] then continue end
		Tab[i] = {}
		for i2, v2 in v do
			Tab[i][i2] = {}
			for i3, v3 in v2 do
				Tab[i][i2][i3] = {
					R = v3.R,
					G = v3.G,
					B = v3.B,
					T = v3.T
				}
			end
		end
	end

	return Tab
end

const CategoryArray = {}

const function UpdateCategoryPositions()
	local x = 0
	local y = 0
	for i, v in CategoryArray do
		const CurrentCategory = TidalWave.Categories[v]
		if CurrentCategory then
			if i > 9 then
				if i % 10 == 0 then
					x = 0
				end
				const AboveCategory = TidalWave.Categories[CategoryArray[i - 9]]
				y = AboveCategory.Object.Size.Y.Offset + AboveCategory.Children.Size.Y.Offset + 10
				x += i > 10 and (TidalWave.Categories[CategoryArray[i - 1]].Object.Size.X.Offset + 10) or 0
			elseif i > 1 then
				x += TidalWave.Categories[CategoryArray[i - 1]].Object.Size.X.Offset + 10
			end

			const Pos = UDim2.fromOffset(x, y)
			CurrentCategory:SetOpenedPosition(Pos)
			if TopBar.Visible and not CurrentCategory:IsMoving() then
				CurrentCategory.Object.Position = Pos
			end
		end
	end
end

--#endregion Functions

--#region Shared Functions

Run(function()
	const Notifications = {}
	
	const NotificationTweens = {
		Horizontal = {},
		Vertical = {},
	}

	const Info = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
	
	const function Tween(Obj, Goal, CustomTab)
		const Tab = NotificationTweens[CustomTab or 'Horizontal']
		if Tab[Obj] then
			Tab[Obj]:Cancel()
			Tab[Obj] = nil
		end

		if Obj.Parent and Obj.Visible then
			Tab[Obj] = TweenService:Create(Obj, Info, Goal)
			Tab[Obj].Completed:Once(function()
				Tab[Obj] = nil
			end)
			Tab[Obj]:Play()
		else
			for i, v in Goal do
				Obj[i] = v
			end
		end
	end

	function TidalWave:Notify(Properties: {Text: string, Title: string?, Duration: number?, Type: 'Info' | 'Warning' | 'Error'?})
		if not TidalWave.Notifications then return end
		task.delay(0, function()
			const TextWidth = math.max(GetTextBounds(Properties.Text, 16).X + 60, 260)
			const Duration = Properties.Duration or 2
			const Type = Properties.Type or 'Info'

			const RightAlignment = TidalWave.NotificationHorizontalAlignment == 'Right'
			const AnchorPoint = RightAlignment and Vector2.zero or Vector2.xAxis
			const TargetAnchorPoint = RightAlignment and Vector2.xAxis or Vector2.zero
			const HortAlignment = RightAlignment and 1 or 0
			const VertAlignment = TidalWave.NotificationVerticalAlignment == 'Bottom' and 1 or 0

			local YOffset = (29 + (78 * (#Notifications + 1)))
			local VertOffset = TidalWave.NotificationFillDirection == 'Up' and -YOffset or YOffset
			
			const Frame = Instance.new('Frame')
			Frame.Name = 'Notification'
			Frame.Position = UDim2.new(HortAlignment, RightAlignment and 1 or -1, VertAlignment, VertOffset)
			Frame.Size = UDim2.fromOffset(TextWidth, 75)
			Frame.BackgroundColor3, Frame.BackgroundTransparency = GetColor('Background/Notification')
			Frame.AnchorPoint = AnchorPoint

			const Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, 0)
			const CornerRadius = UDim.new(0, TidalWave.NotificationCornerRadius)
			if RightAlignment then
				Corner.TopLeftRadius = CornerRadius
				Corner.BottomLeftRadius = CornerRadius
			else
				Corner.TopRightRadius = CornerRadius
				Corner.BottomRightRadius = CornerRadius
			end
			Corner.Parent = Frame

			table.insert(Notifications, Frame)

			const UIStroke = Instance.new('UIStroke')
			UIStroke.Thickness = 1
			UIStroke.Color = GetColor('Outline/Notification')
			UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame

			const NotificationType = Instance.new('ImageLabel')
			NotificationType.Name = 'NotificationType'
			NotificationType.Size = UDim2.fromOffset(18, 18)
			NotificationType.Position = UDim2.fromOffset(6, 6)
			NotificationType.BackgroundTransparency = 1
			NotificationType.ImageColor3 = GetColor(`Notification/{Type}`)
			SetIcon(NotificationType, Type == 'Info' and 'info' or (Type == 'Warning' or Type == 'Error') and 'circle-alert')
			NotificationType.Parent = Frame

			const TitleShadow = Instance.new('TextLabel')
			TitleShadow.Name = 'TitleShadow'
			TitleShadow.Position = UDim2.fromOffset(40, 6)
			TitleShadow.Size = UDim2.new(1, -80, 0, 20)
			TitleShadow.BackgroundTransparency = 1
			TitleShadow.TextColor3 = GetColor('Text/Shadow')
			TitleShadow.TextSize = 18
			TitleShadow.FontFace = GetFont('Medium')
			TitleShadow.Text = Properties.Title and RemoveTags(Properties.Title) or 'Tidal Wave'
			TitleShadow.TextXAlignment = Enum.TextXAlignment.Center
			TitleShadow.Parent = Frame

			const Title = Instance.fromExisting(TitleShadow)
			Title.Size = UDim2.fromScale(1, 1)
			Title.Name = 'Title'
			Title.TextColor3 = GetColor('Text/Primary')
			Title.RichText = true
			Title.Text = Properties.Title or '<font color = "rgb(255, 215, 0)">Tidal</font> <font color = "rgb(20, 135, 255)">Wave</font>'
			Title.Position = UDim2.fromOffset(-1, -1)
			Title.Parent = TitleShadow

			const TextShadow = Instance.new('TextLabel')
			TextShadow.Name = 'TextShadow'
			TextShadow.Position = UDim2.fromOffset(0, 30)
			TextShadow.Size = UDim2.new(1, 0, 0, 40)
			TextShadow.BackgroundTransparency = 1
			TextShadow.TextColor3 = GetColor('Text/Shadow')
			TextShadow.TextSize = 15
			TextShadow.FontFace = GetFont('Regular')
			TextShadow.Text = RemoveTags(Properties.Text)
			TextShadow.TextXAlignment = Enum.TextXAlignment.Center
			TextShadow.TextWrapped = true
			TextShadow.Parent = Frame

			const Text = Instance.fromExisting(TextShadow)
			Text.Name = 'TextLabel'
			Text.Size = UDim2.fromScale(1, 1)
			Text.RichText = true
			Text.TextColor3 = GetColor('Text/Primary')
			Text.Text = Properties.Text
			Text.Position = UDim2.fromOffset(-1, -1)
			Text.Parent = TextShadow

			const Progress = Instance.new('Frame')
			Progress.Name = 'Progress'
			Progress.BackgroundColor3 = GetColor('Notification/ProgressBar')
			Progress.BorderSizePixel = 0
			Progress.Size = UDim2.new(1, -2, 0, 1)
			Progress.Position = UDim2.new(0, 3, 1, -3)
			Progress.Parent = Frame

			Frame.Parent = NotificationHolder

			Tween(Frame, {AnchorPoint = TargetAnchorPoint})
			TweenService:Create(Progress, TweenInfo.new(Duration), {Size = UDim2.fromOffset(0, 1)}):Play()

			task.delay(Duration, function()
				if not TidalWave then return end
				Tween(Frame, {AnchorPoint = AnchorPoint})
				task.wait(0.25)

				const Index = table.find(Notifications, Frame)
				if Index then
					table.remove(Notifications, Index)
				end
				Frame:Destroy()

				for i, Frame in Notifications do
					YOffset = (29 + (78 * i))
					VertOffset = TidalWave.NotificationFillDirection == 'Up' and -YOffset or YOffset
					const Goal = {Position = UDim2.new(HortAlignment, RightAlignment and 1 or -1, VertAlignment, VertOffset)}
					Tween(Frame, Goal, 'Vertical')
				end
			end)
		end)
	end
end)

function TidalWave:CreateCategory(Properties)
	return Components.Other.Category(Properties)
end

function TidalWave:CreateMenu(Properties)
	return Components.Other.Menu(Properties)
end

function TidalWave:Shutdown()
	self:Save()

	for _, Module in self.Modules do
		if Module.Enabled then
			Module:Toggle(true)
		end
		for _, Option in Module.Options do
			if Option.Enabled and Option.Toggle then
				Option:Toggle()
			end
		end
	end

	for _, Menu in self.Menus do
		for _, Option in Menu.Options do
			if Option.Enabled and Option.Toggle then
				Option:Toggle()
			end
			if Option.Options then
				for _, NestedOption in Option.Options do
					if NestedOption.Enabled and NestedOption.Toggle then
						NestedOption:Toggle()
					end
				end
			end
		end
	end

	if shared.TidalWaveLoader then
		shared.TidalWaveLoader:Destroy()
		shared.TidalWaveLoader = nil
	end

	Gui:Destroy()
	self.Gui = nil

	self:DisconnectAll()
	self.Libraries.EntityLib:Shutdown()
	table.clear(self.Libraries)
	self.Libraries = nil
	LoopClean(self, true)
	TidalWave = nil
	shared.TidalWave = nil
end

function TidalWave:Restart()
	if IsStudio then
		const Clone = shared.Loader:Clone()
		const Parent = shared.Loader.Parent
		shared.Loader:Destroy()
		shared.Loader = nil
		Clone.Parent = Parent
	else
		if shared.TidalWaveDev then
			loadstring(readfile('TidalWave/Loader.lua'), 'Loader')()
		else
			loadstring(game:HttpGet('https://raw.githubusercontent.com/fluidnarrator30/Tidal-Wave/refs/heads/main/Loader.lua', true))()
		end
	end
end

function TidalWave:RemoveModule(Name)
	const Module = self.Modules and self.Modules[Name]
	if Module then
		if Module.Enabled then
			Module:Toggle(true)
		end

		for _, Option in Module.Options do
			if Option.Enabled and Option.Toggle then
				Option:Toggle()
			end
		end

		for _, v in Module.Category.Options do
			if v.Object.LayoutOrder > Module.Object.LayoutOrder then
				v.Object.LayoutOrder -= 1
			end
		end

		Module.Object:Destroy()
		Module.Category = nil
		LoopClean(Module, true)
		self.Modules[Name] = nil
	end
end

function TidalWave:RemoveButton(Name)
	local Button = self.Buttons and self.Buttons[Name]
	if Button then
		for _, v in Button.Category.Options do
			if v.Object.LayoutOrder > Button.Object.LayoutOrder then
				v.Object.LayoutOrder -= 1
			end
		end

		Button.Object:Destroy()
		Button.Category = nil
		LoopClean(Button, true)
		self.Buttons[Button] = nil
	end
end

function TidalWave:LoadOptions(Options, JsonOptions)
	for i, v in JsonOptions do
		const Option = Options[i]
		if Option and Option.Load then
			Option:Load(v)
		end
	end
end

function TidalWave:SaveOptions(Options)
	if not Options then return end
	const Tab = {}
	for _, v in Options do
		if not v.Save then continue end
		v:Save(Tab)
	end
	return Tab
end

function TidalWave:Load(Profile)
	if not (isfile and readfile) then return end

	const Path = `TidalWave/Profiles/Gui{game.GameId}.json`
	const Config = isfile(Path) and HttpService:JSONDecode(readfile(Path)) or nil
	if not Config then return end

	if self.Scale ~= Config.Scale then
		self.Scale = Config.Scale
		GuiScale.Scale = self.Scale and math.max(Gui.AbsoluteSize.X / 1920, 0.6) or 1
	end

	self.Profile = Profile or Config.Profile or 'Default'
	self.Profiles = Config.Profiles or {'Default'}
	self.Friends = Config.Friends or {}
	self.Theme = Config.Theme or 'TidalWave'
	self.Themes = LoadThemes(Config)
	if Config.Fonts then
		self.Fonts = {
			Regular = TableToFont(Config.Fonts.Regular),
			Medium = TableToFont(Config.Fonts.Medium),
			Bold = TableToFont(Config.Fonts.Bold)
		}
	end

	local Index = 0
	for Name, Tab in self.Themes do
		if BuiltInThemes[Name] then continue end
		Index += 1
		if ThemesDropdown.Expanded then
			ThemesDropdown:CreateButton({
				Name = Name,
				LayoutOrder = Index,
				CanDelete = true
			})
		else
			ThemesDropdown:Add(Name)
		end
	end

	ThemesDropdown:SetValue(self.Theme)

	for Name, Saved in Config.Menus do
		if typeof(Saved) ~= 'table' then continue end
		const Menu = self.Menus[Name]
		if not Menu then continue end

		for OptionName, OptionData in Saved.Options do
			if OptionName == 'Gui' or OptionName == 'Themes' then continue end
			const Option = Menu.Options[OptionName]
			if not Option then continue end
			if typeof(OptionData) == 'table' and OptionData.Options and Option.Options then
				self:LoadOptions(Option.Options, OptionData.Options)
				if Option.Enabled ~= OptionData.Enabled then
					Option:Toggle()
				end
			else
				Option:Load(OptionData)
			end
		end

		for i2, v2 in Saved.Keybinds do
			local Keybind = Menu.Keybinds[i2]
			if not Keybind then continue end
			Keybind:Load(v2)
		end
	end

	for HudItem, SavedPosition in Config.HudLocations do
		local HudObject = HudFolder:FindFirstChild(HudItem)
		if HudObject then
			HudObject.Position = TableToUDim2(SavedPosition)
		end
	end

	for Name, Saved in Config.Categories do
		local Category = self.Categories[Name]
		if Category then
			Category:Load(Saved)
		end
	end

	const GameConfigPath = `TidalWave/Profiles/{self.Profile}{game.PlaceId}.json`
	if isfile(GameConfigPath) then
		const GameConfig = HttpService:JSONDecode(readfile(GameConfigPath))

		for Name, Saved in GameConfig.Modules do
			const Module = self.Modules[Name]
			if Saved and Module then
				Module:Load(Saved)
			end
		end

		for Name, Saved in GameConfig.Buttons do
			const Button = self.Buttons[Name]
			if Saved and Button then
				Button:Load(Saved)
			end
		end
	end
end

function TidalWave:ImportProfilesFromPlace(PlaceId: number)
	const GuiPath = `TidalWave/Profiles/Gui{game.GameId}.json`
	const Config = isfile(GuiPath) and HttpService:JSONDecode(readfile(GuiPath)) or nil
	if not Config then return end

	for _, Name in Config.Profiles or {} do
		if not table.find(self.Profiles, Name) then
			const Path = `TidalWave/Profiles/{Name}{PlaceId}.json`
			if isfile(Path) then
				writefile(`TidalWave/Profiles/{Name}{game.PlaceId}.json`, readfile(Path))
				table.insert(self.Profiles, Name)
			end
		end
	end
end

const MENU_SAVE_BLACKLIST = {
	Options = true,
	Profiles = true,
	MenuOptions = true
}

function TidalWave:Save(Profile, CustomGameConfig)
	if not writefile then return end

	const GuiConfig = {
		Scale = TidalWave.Scale,
		Profile = Profile or TidalWave.Profile or 'Default',
		Profiles = TidalWave.Profiles or {'Default'},
		Friends = TidalWave.Friends or {},
		Fonts = {
			Regular = FontToTable(self.Fonts.Regular),
			Medium = FontToTable(self.Fonts.Medium),
			Bold = FontToTable(self.Fonts.Bold),
		},
		Themes = SaveThemes(),
		Theme = TidalWave.Theme or 'TidalWave',
		Menus = {},
		HudLocations = {},
		Categories = {}
	}

	for Name, Menu in TidalWave.Menus do
		if MENU_SAVE_BLACKLIST[Name] then continue end

		const Saved = {
			Options = {},
			Keybinds = {}
		}

		for OptionName, Option in Menu.Options do
			if Option.Options then
				Saved.Options[OptionName] = {
					Enabled = Option.Enabled,
					Options = TidalWave:SaveOptions(Option.Options),
					Keybinds = TidalWave:SaveOptions(Option.Keybinds)
				}
			elseif Option.Save then
				Option:Save(Saved.Options)
			end
		end

		for _, Keybind in Menu.Keybinds do
			Keybind:Save(Saved.Keybinds)
		end

		GuiConfig.Menus[Name] = Saved
	end

	for _, Obj in HudFolder:GetChildren() do
		GuiConfig.HudLocations[Obj.Name] = UDim2ToTable(Obj.Position)
	end

	for Name, Category in TidalWave.Categories do
		Category:Save(GuiConfig.Categories)
	end

	local Data
	if CustomGameConfig then
		Data = CustomGameConfig
	else
		const GameConfig = {
			Modules = {},
			Buttons = {}
		}
	
		for _, Module in TidalWave.Modules do
			Module:Save(GameConfig.Modules)
		end
	
		for _, Button in TidalWave.Buttons do
			Button:Save(GameConfig.Buttons)
		end

		Data = HttpService:JSONEncode(GameConfig)
	end

	writefile(`TidalWave/Profiles/Gui{game.GameId}.json`, HttpService:JSONEncode(GuiConfig))
	writefile(`TidalWave/Profiles/{GuiConfig.Profile}{game.PlaceId}.json`, Data)
end

function TidalWave:StartRGB()
	if not self.RGBThread then
		self.RGBThread = task.spawn(function()
			while true do
				const Tick = (os.clock() * (self.RGBSpeed / 5)) % 1
				const LinearColor = Color3.fromHSV(Tick, 1, 1)
				const GradientLen = #self.RGBTable.Gradient
				const Spread = self.RGBSpread

				for _, v in self.RGBTable.Linear do
					v:SetColor(LinearColor)
				end

				for _, Group in self.RGBTable.Gradient do
					for i, v in Group do
						const Alpha = (i / GradientLen) / Spread
						const Hue = (Tick - Alpha) % 1
						const Color = Color3.fromHSV(Hue, 1, 1)
						v:SetColor(Color)
					end
				end

				task.wait(1 / self.RGBRefreshRate)
			end
		end)
	end
end

function TidalWave:AddRGB(Tab)
	table.insert(self.RGBTable.Linear, Tab)
	self:StartRGB()	
end

function TidalWave:AddRGBGradient(Tab, Group: string?, Index: number?)
	if Group and not self.RGBTable.Gradient[Group] then
		self.RGBTable.Gradient[Group] = {}
	end

	const Holder = self.RGBTable.Gradient[Group or 'All']

	table.insert(Holder, Index or #Holder, Tab)
	self:StartRGB()
end

function TidalWave:RemoveRGBGradient(Tab, Group: string?)
	const Holder = self.RGBTable.Gradient[Group or 'All']
	for i, v in Holder do
		if v == Tab then
			table.remove(Holder, i)
			break
		end
	end
end

const function IsRGBGradientLengthZero()
	for _, v in TidalWave.RGBTable.Gradient do
		if #v ~= 0 then
			return false
		end
	end

	return true
end

function TidalWave:RemoveRGB(Tab)
	for i, v in self.RGBTable.Linear do
		if v == Tab then
			table.remove(self.RGBTable.Linear, i)
			break
		end
	end

	if #self.RGBTable.Linear == 0 and IsRGBGradientLengthZero() then
		self:StopRGB()
	end
end

function TidalWave:StopRGB()
	if self.RGBThread then
		task.cancel(self.RGBThread)
		self.RGBThread = nil
	end
end

function TidalWave:Yield(Function)
	const Thread = coroutine.running()
	const Connection = self:Clean(coroutine.resume, Thread)

	const NewFunction = function()
		local Result = Function()
		if not Result then
			repeat
				Result = Function()
			until Result
		end

		Connection:Disconnect()
	end

	self:Clean(task.spawn(NewFunction))

	return coroutine.yield()
end

--#endregion Shared Functions

function TidalWave:Init()
	AddMaid(TidalWave)
	Gui = Instance.new('ScreenGui')
	Gui.Name = `TidalWave v{TidalWave.Version}`
	Gui.IgnoreGuiInset = true
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 69420
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	pcall(function() Gui.OnTopOfCoreBlur = true end)
	Gui.Parent = gethui()
	TidalWave.Gui = Gui
	
	const ScaledGui = Instance.new('Frame')
	ScaledGui.Name = 'ScaledGui'
	ScaledGui.BackgroundTransparency = 1
	ScaledGui.Size = UDim2.fromScale(1, 1)
	ScaledGui.Parent = Gui
	
	GuiScale = Instance.new('UIScale')
	GuiScale.Scale = math.max(Gui.AbsoluteSize.X / 1920, 0.6)
	GuiScale.Parent = ScaledGui
	ScaledGui.Size = UDim2.fromScale(1 / GuiScale.Scale, 1 / GuiScale.Scale)
	
	HudFolder = Instance.new('Frame')
	HudFolder.Name = 'Hud'
	HudFolder.Size = UDim2.fromScale(1, 1)
	HudFolder.BackgroundTransparency = 1
	HudFolder.Parent = ScaledGui
	
	const GuiFolder = Instance.new('Frame')
	GuiFolder.Name = 'Gui'
	GuiFolder.Size = UDim2.fromScale(1, 1)
	GuiFolder.BackgroundTransparency = 1
	GuiFolder.Parent = ScaledGui
	
	CategoryHolder = Instance.new('Frame')
	CategoryHolder.Name = 'Categories'
	CategoryHolder.Size = UDim2.fromScale(1, 1)
	CategoryHolder.BackgroundTransparency = 1
	CategoryHolder.Visible = false
	CategoryHolder.Parent = GuiFolder
	
	const CategoryHolderPadding = Instance.new('UIPadding')
	CategoryHolderPadding.PaddingTop = UDim.new(0, GuiService.TopbarInset.Height + 2)
	CategoryHolderPadding.PaddingLeft = UDim.new(0, 8)
	CategoryHolderPadding.Parent = CategoryHolder
	
	MenuHolder = Instance.new('Frame')
	MenuHolder.Name = 'Menus'
	MenuHolder.Size = UDim2.fromScale(1, 1)
	MenuHolder.BackgroundTransparency = 1
	MenuHolder.Parent = GuiFolder
	
	NotificationHolder  = Instance.new('TextButton')
	NotificationHolder.Name = 'Notifications'
	NotificationHolder.Size = UDim2.new(0, 270, 1)
	NotificationHolder.Position = UDim2.new(1, -270, 0, 0)
	NotificationHolder.BackgroundTransparency = 1
	NotificationHolder.Text = ''
	NotificationHolder.Active = false
	NotificationHolder.Interactable = false
	NotificationHolder.Parent = HudFolder
	
	Tooltip = Instance.new('TextLabel')
	Tooltip.Name = 'Tooltip'
	Tooltip.TextColor3 = GetColor('Text/Primary')
	Tooltip.BackgroundColor3 = GetColor('Background/Tooltip')
	Tooltip.BorderSizePixel = 0
	Tooltip.BackgroundTransparency = 0.3
	Tooltip.FontFace = GetFont('Regular')
	Tooltip.Size = UDim2.fromOffset(100, 24)
	Tooltip.TextSize = 16
	Tooltip.ZIndex = 3
	Tooltip.Visible = false
	Tooltip.Interactable = false
	Tooltip.Parent = GuiFolder
	AddCorner(Tooltip, UDim.new(0, 5))
	ListenObject(Tooltip, 'Background/Tooltip', 'Text/Primary')
	ListenFont(Tooltip, 'Regular')
	
	const TooltipUIStroke = Instance.new('UIStroke')
	TooltipUIStroke.Thickness = 1
	TooltipUIStroke.Color = GetColor('Outline/Tooltip')
	TooltipUIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	TooltipUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	TooltipUIStroke.Parent = Tooltip
	ListenObject(TooltipUIStroke, 'Outline/Tooltip')
	
	Modal = Instance.new('TextButton')
	Modal.Name = 'Modal'
	Modal.BackgroundTransparency = 1
	Modal.Interactable = false
	Modal.Active = false
	Modal.Modal = true
	Modal.Visible = false
	Modal.Text = ''
	Modal.Parent = Gui
	
	TopBar = Instance.new('Frame')
	TopBar.Name = 'TopBar'
	TopBar.BorderSizePixel = 0
	TopBar.BackgroundColor3 = GetColor('Background/Primary')
	TopBar.Position = UDim2.new(0.5, 0, 0, 12)
	TopBar.Size = UDim2.fromOffset(0, 44)
	TopBar.AnchorPoint = Vector2.new(0.5, 0)
	TopBar.Visible = false
	TopBar.Parent = GuiFolder
	AddCorner(TopBar, UDim.new(0, 11))
	ListenObject(TopBar, 'Background/Primary')
	
	const TopBarLayout = Instance.new('UIListLayout')
	TopBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TopBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TopBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TopBarLayout.FillDirection = Enum.FillDirection.Horizontal
	TopBarLayout.Padding = UDim.new(0, 8)
	TopBarLayout.Parent = TopBar
	
	const Cursor = Instance.new('ImageLabel')
	Cursor.Name = 'Cursor'
	Cursor.Image = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
	Cursor.Visible = false
	Cursor.Size = UDim2.fromOffset(64, 64)
	Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
	Cursor.BackgroundTransparency = 1
	Cursor.ZIndex = 69420
	Cursor.Parent = Gui
	
	TidalWave:Clean(Gui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
		if TidalWave.Scale then
			GuiScale.Scale = math.max(Gui.AbsoluteSize.X / 1920, 0.6)
		end
	end))
	
	TidalWave:Clean(GuiScale:GetPropertyChangedSignal('Scale'):Connect(function()
		CategoryHolderPadding.PaddingTop = UDim.new(0, (GuiService.TopbarInset.Height + 2) / GuiScale.Scale)
		CategoryHolderPadding.PaddingLeft = UDim.new(0, 8 / GuiScale.Scale)
		ScaledGui.Size = UDim2.fromScale(1 / GuiScale.Scale, 1 / GuiScale.Scale)
		for _, v in ScaledGui:QueryDescendants('GuiObject[Visible = true]') do
			v.Visible = false
			v.Visible = true
		end
	end))
	
	TidalWave:Clean(workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
		Camera = cloneref(workspace.CurrentCamera or workspace:FindFirstChildOfClass('Camera') or Instance.new('Camera'))
	end))

	TidalWave:Clean(task.spawn(function()
		while task.wait(10) do
			TidalWave:Save()
		end
	end))

	TidalWave:Clean(TidalWave.StopRGB, TidalWave)
	
	local StopEditingHudPositions, StartEditingHudPositions, AllowMouseBinding, MenuKeybind, DoneButton
	
	Run(function() -- Menus
		const function HideMenus(Exclusion, Visible)
			for i, v in TidalWave.Menus do
				if i == Exclusion then
					Exclusion = nil
					v.Object.Visible = true
					PrevMenu = i
				else
					v.Object.Visible = false
				end
			end
			CategoryHolder.Visible = if Visible ~= nil then Visible else false
		end
		
		Run(function() -- Options
			TidalWave:CreateMenu({
				Name = 'Options',
			})
			
			MenuOptions = TidalWave:CreateMenu({
				Name = 'Menu Options'
			})
			
			MenuOptions.Object.Title.Text = 'Options'
			MenuOptions:BindToClose(function()
				for i, v in TidalWave.Menus do
					if i == PrevMenu then
						v:Show()
						break
					end
				end
			end)
		end)
		
		Run(function() -- Config
			ConfigMenu = TidalWave:CreateMenu({
				Name = 'Config',
			})
			
			MenuKeybind = ConfigMenu:CreateKeybind({
				Name = 'Menu',
				Keybind = 'RightShift',
				Secondary = true
			})

			local KeepOnTeleport; KeepOnTeleport = ConfigMenu:CreateToggle({
				Name = 'Keep On Teleport',
				Info = 'Keeps TidalWave opened when teleporting through games',
				Default = true,
				Enabled = function()
					if not queueonteleport then return end
					KeepOnTeleport:Clean(Plr.OnTeleport:Once(function()
						local Code
						if shared.TidalWaveDev then
							Code = [[
								shared.TidalWaveDev = true
								loadstring(readfile('TidalWave/Loader.lua'), 'Loader')()
							]]
						else
							Code = 'loadstring(game:HttpGet(`https://raw.githubusercontent.com/fluidnarrator30/Tidal-Wave/{readfile("TidalWave/Profiles/Commit.txt")}/Loader.lua`, true))()'
						end
						queueonteleport(Code)
					end))
				end
			})
			
			AllowMouseBinding = ConfigMenu:CreateToggle({
				Name = 'Allow Mouse Binding',
				Info = 'Allows you to bind modules to mouse buttons',
				Function = function()
					table.clear(TidalWave.PressedKeys)
				end
			})

			ConfigMenu:CreateSlider({
				Name = 'RGB Speed',
				Default = 1,
				Min = 0.01,
				Max = 3,
				Decimal = 100,
				Clamp = {0.01, 100},
				Function = function(Val)
					TidalWave.RGBSpeed = Val
				end
			})

			ConfigMenu:CreateSlider({
				Name = 'RGB Spread',
				Default = 1,
				Min = 0.01,
				Max = 3,
				Decimal = 100,
				Clamp = {0.01, 100},
				Function = function(Val)
					TidalWave.RGBSpread = Val
				end
			})

			ConfigMenu:CreateSlider({
				Name = 'RGB Refresh Rate',
				Default = 60,
				Min = 1,
				Max = 240,
				Clamp = {1, 1000},
				Function = function(Val)
					TidalWave.RGBRefreshRate = Val
				end
			})
			
			ConfigMenu:CreateButton({
				Name = 'Reload',
				Function = function()
					task.defer(TidalWave.Restart, TidalWave)
				end,
			})
			
			ConfigMenu:CreateButton({
				Name = 'Close',
				Function = function()
					task.defer(TidalWave.Shutdown, TidalWave)
				end
			})
		end)
	
		Run(function() -- GUI
			GuiMenu = TidalWave:CreateMenu({
				Name = 'GUI',
			})
	
			GuiMenu:CreateButton({
				Name = 'Sort Categories',
				Function = UpdateCategoryPositions
			})
	
			GuiMenu:CreateOption({
				Name = 'Category Animations',
				Default = true,
				Function = function(Enabled)
					TidalWave.CategoryAnimations = Enabled
				end
			})
	
			GuiMenu:CreateToggle({
				Name = 'Auto-Scale Gui',
				Default = true,
				Function = function(Enabled)
					TidalWave.Scale = Enabled
					GuiScale.Scale = Enabled and math.max(Gui.AbsoluteSize.X / 1920, 0.6) or 1
				end
			})
	
			GuiMenu:CreateFont({
				Name = 'Regular Font',
				Default = 'Montserrat',
				Weight = 'Regular',
				Function = function(Font)
					SetFont('Regular', Font)
				end
			})
	
			GuiMenu:CreateFont({
				Name = 'Medium Font',
				Default = 'Montserrat',
				Weight = 'Medium',
				Function = function(Font)
					SetFont('Medium', Font)
				end
			})
	
			GuiMenu:CreateFont({
				Name = 'Bold Font',
				Default = 'Montserrat',
				Weight = 'Bold',
				Function = function(Font)
					SetFont('Bold', Font)
				end
			})
	
			Run(function() -- Themes
				function GuiMenu:CreateThemesDropdown(Properties)
					Properties.LayoutOrder = table.len(GuiMenu.Options) + table.len(GuiMenu.Keybinds)
					Properties.Parent = GuiMenu.Children
					return Components.Other.ThemesDropdown(Properties)
				end
	
				local ColorPickers = {}
	
				ThemesDropdown = GuiMenu:CreateThemesDropdown({
					Name = 'Theme',
					List = {'TidalWave'},
					Function = function(Val)
						TidalWave.Themes[Val] = table.clone(BuiltInThemes.TidalWave)
						TidalWave.Theme = Val
						for i, v in ColorPickers do
							local Color, Transparency = GetColor(i)
							if v.Color ~= Color or v.Transparency ~= Transparency then
								v:SetColor(Color, Transparency)
							end
							v:SetVisible(not BuiltInThemes[Val])
						end
					end
				})

				const ItemFormats = {
					Main = function(Item)
						return Item
					end,
					Outline = function(Item)
						return Item .. ' Outline'
					end,
					Text = function(Item)
						return Item .. ' Text'
					end,
					Background = function(Item)
						return Item .. ' Background'
					end
				}
	
				for i, v in BuiltInThemes.TidalWave do
					for i2, v2 in v do
						ColorPickers[`{i}/{i2}`] = GuiMenu:CreateColorPicker({
							Name = ItemFormats[i] and ItemFormats[i](i2) or `{i} {i2}`,
							Default = v2.Color,
							Transparency = v2.Transparency,
							Visible = false,
							Function = function(Color, Transparency)
								SetColor(`{i}/{i2}`, Color, Transparency)
							end
						})
					end
				end
				
				local List = {}
				if IsStudio then
					for _, v in RootPath.Guis:GetChildren() do
						table.insert(List, v.Name)
					end
				else
					for _, v in listfiles('TidalWave/Guis') do
						table.insert(List, v:gsub('\\', '/'):split('/')[3]:split('.')[1])
					end
				end
				
				local CurrentGui = readfile and readfile('TidalWave/Profiles/Gui.txt') or 'TidalWave'
	
				table.sort(List, function(a)
					return a == CurrentGui
				end)
	
				GuiMenu:CreateDropdown({
					Name = 'Gui',
					List = List,
					Function = function(Val)
						if writefile then
							writefile('TidalWave/Profiles/Gui.txt', Val)
							TidalWave:Restart()
						end
					end
				})
			end)
		end)
	
		Run(function() -- HUD
			HudMenu = TidalWave:CreateMenu({
				Name = 'HUD',
			})
	
			function HudMenu:CreateLabel(Properties)
				return Components.Other.HudLabel(Properties)
			end
	
			HudMenu:CreateToggle({
				Name = 'Allow Dragging Off Screen'
			})
	
			Run(function() -- Tooltip
				local TextSize

				local TooltipOptions = HudMenu:CreateOption({
					Name = 'Tooltip',
					Default = true,
					Function = function(Enabled)
						TidalWave.Tooltip = Enabled
						if Tooltip.Visible and not Enabled then
							Tooltip.Visible = false
						end
					end
				})

				Tooltip:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
					Tooltip.TextSize = TextSize.Value / GuiScale.Scale
				end)
	
				TextSize = TooltipOptions:CreateSlider({
					Name = 'Text Size',
					Default = 16,
					Min = 8,
					Max = 24,
					Function = function(Val)
						Tooltip.TextSize = TextSize.Value / GuiScale.Scale
					end
				})
			end)
	
			Run(function() -- Edit Hud Positions
				DoneButton = Instance.new('TextButton')
				DoneButton.Name = 'Done'
				DoneButton.Size = UDim2.fromOffset(200, 50)
				DoneButton.Position = UDim2.fromScale(0.5, 1)
				DoneButton.AnchorPoint = Vector2.new(0.5, 1)
				DoneButton.BackgroundColor3 = GetColor('Background/Button')
				DoneButton.BorderSizePixel = 0
				DoneButton.Text = 'Done'
				DoneButton.TextColor3 = GetColor('Text/Primary')
				DoneButton.TextSize = 36
				DoneButton.FontFace = GetFont('Regular')
				DoneButton.Visible = false
				DoneButton.Parent = GuiFolder
				ListenObject(DoneButton, 'Background/Button', 'Text/Primary')
				ListenFont(DoneButton, 'Regular')
	
				local Corner = Instance.new('UICorner')
				Corner.CornerRadius = UDim.new(0, 0)
				Corner.TopLeftRadius = UDim.new(0, 7)
				Corner.TopRightRadius = UDim.new(0, 7)
				Corner.Parent = DoneButton
	
				local Objects = {}
				local OldProperties = {}
				local EditingPositions = false
	
				StopEditingHudPositions = function()
					if not EditingPositions then return end
					EditingPositions = false
	
					for Obj, Properties in OldProperties do
						for Property, Value in Properties do
							Obj[Property] = Value
						end
					end
					for _, v in Objects do
						v:Destroy()
					end
					table.clear(Objects)
					table.clear(OldProperties)
					DoneButton.Visible = false
					HudMenu.Object.Visible = true
				end
	
				StartEditingHudPositions = function()
					if not HudMenu.Object.Visible then return end
					EditingPositions = true
					HudMenu.Object.Visible = false
					for _, v in HudFolder:GetChildren() do
						if v:IsA('GuiObject') then
							OldProperties[v] = {
								Interactable = v.Interactable
							}
							v.Interactable = true
	
							local DragDetector = Instance.new('UIDragDetector')
							DragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
							DragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
	
							if not HudMenu.Options.AllowDraggingOffScreen.Enabled then
								DragDetector.BoundingUI = HudFolder
								DragDetector.BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject
							end
	
							DragDetector.Parent = v
	
							local ExistingCorner = v:FindFirstChildOfClass('UICorner')
							if ExistingCorner then
								OldProperties[ExistingCorner] = {
									TopLeftRadius = ExistingCorner.TopLeftRadius,
									TopRightRadius = ExistingCorner.TopRightRadius,
									BottomLeftRadius = ExistingCorner.BottomLeftRadius,
									BottomRightRadius = ExistingCorner.BottomRightRadius
								}
	
								ExistingCorner.CornerRadius = UDim.zero
							end
	
							local UIStroke = Instance.new('UIStroke')
							UIStroke.Color = Color3.White
							UIStroke.Thickness = 2
							UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
							UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
							UIStroke.ZIndex = 69420
							UIStroke.Parent = v
	
							table.insert(Objects, DragDetector)
							table.insert(Objects, UIStroke)
						end
					end
	
					DoneButton.Visible = true
				end
	
				DoneButton.MouseButton1Click:Connect(StopEditingHudPositions)
	
				HudMenu:CreateButton({
					Name = 'Edit Positions',
					Function = StartEditingHudPositions
				})
			end)
	
			Run(function() -- Notifications
				local Notifications = HudMenu:CreateOption({
					Name = 'Notifications',
					Default = true,
					Function = function(Enabled)
						TidalWave.Notifications = Enabled
					end
				})
	
				Notifications:CreateDropdown({
					Name = 'Horizontal Alignment',
					List = {'Right', 'Left'},
					Function = function(Val)
						TidalWave.NotificationHorizontalAlignment = Val
					end
				})
	
				Notifications:CreateDropdown({
					Name = 'Vertical Alignment',
					List = {'Bottom', 'Top'},
					Function = function(Val)
						TidalWave.NotificationVerticalAlignment = Val
					end
				})
	
				Notifications:CreateDropdown({
					Name = 'Fill Direction',
					List = {'Up', 'Down'},
					Function = function(Val)
						TidalWave.NotificationFillDirection = Val
					end
				})
	
				Notifications:CreateSlider({
					Name = 'Corner Radius',
					Default = 6,
					Min = 0,
					Max = 24,
					Function = function(Val)
						TidalWave.NotificationCornerRadius = Val
					end
				})
	
				Notifications:CreateSlider({
					Name = 'Module Toggled Duration',
					Default = 2,
					Min = 0.5,
					Max = 4,
					Decimal = 100,
					Function = function(Val)
						TidalWave.ModuleToggledNotificationDuration = Val
					end
				})
			end)
	
			Run(function() -- TextGUI
				TextGUI = Components.Other.TextGUI()
				
				local TextGUIEnabled
	
				TextGUIEnabled = HudMenu:CreateOption({
					Name = 'TextGUI',
					Default = true,
					Function = function(Enabled)
						TextGUI.Object.Visible = Enabled
					end
				})
	
				local WatermarkEnabled = TextGUIEnabled:CreateToggle({
					Name = 'Watermark',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetWatermarkEnabled(Enabled)
					end
				})
	
				WatermarkEnabled:CreateTextBox({
					Name = 'Watermark Text',
					Text = `<font color = 'rgb(255, 215, 0)'>Tidal</font> <font color = 'rgb(20, 135, 255)'>Wave</font> v{TidalWave.Version}`,
					Placeholder = '[cool watermark text]',
					Function = function(Text)
						TextGUI:SetWatermarkText(Text)
					end
				})
	
				WatermarkEnabled:CreateColorPicker({
					Name = 'Watermark Text Color',
					Default = GetColor('Text/Primary'),
					Function = function(Color)
						TextGUI:SetWatermarkTextColor(Color)
					end
				})
	
				local ImageEnabled = TextGUIEnabled:CreateToggle({
					Name = 'Image',
					Function = function(Enabled)
						TextGUI:SetImageEnabled(Enabled)
					end
				})
	
				ImageEnabled:CreateAssetTextBox({
					Name = 'Image ID',
					Placeholder = '[rbxassetid://12345] or [cool_image.png]',
					Function = function(Asset)
						TextGUI:SetImage(Asset)
					end
				})
	
				ImageEnabled:CreateSlider({
					Name = 'Image Width',
					Default = 200,
					Min = 20,
					Max = 400,
					Function = function(Val)
						TextGUI:SetImageWidth(Val)
					end
				})
	
				ImageEnabled:CreateSlider({
					Name = 'Image Height',
					Default = 50,
					Min = 10,
					Max = 100,
					Function = function(Val)
						TextGUI:SetImageHeight(Val)
					end
				})
	
				ImageEnabled:CreateSlider({
					Name = 'Image Order',
					Default = 1,
					Min = 0,
					Max = 3,
					Function = function(Val)
						TextGUI:SetImageOrder(Val)
					end
				})
	
				ImageEnabled:CreateDropdown({
					Name = 'Image Alignment',
					List = {'Right', 'Center', 'Left'},
					Function = function(Val)
						TextGUI:SetImageAlignment(Val)
					end
				})
	
				local ImageRectEnabled = ImageEnabled:CreateToggle({
					Name = 'Image Rect Enabled',
					Function = function(Enabled)
						TextGUI:SetImageRectEnabled(Enabled)
					end
				})
	
				ImageRectEnabled:CreateSlider({
					Name = 'Rect Offset X',
					Default = 0,
					Min = 0,
					Max = 100,
					Function = function(Val)
						TextGUI:SetImageRectOffsetX(Val)
					end
				})
	
				ImageRectEnabled:CreateSlider({
					Name = 'Rect Offset Y',
					Default = 0,
					Min = 0,
					Max = 100,
					Function = function(Val)
						TextGUI:SetImageRectOffsetY(Val)
					end
				})
	
				ImageRectEnabled:CreateSlider({
					Name = 'Rect Size X',
					Default = 200,
					Min = 50,
					Max = 200,
					Function = function(Val)
						TextGUI:SetImageRectSizeX(Val)
					end
				})
	
				ImageRectEnabled:CreateSlider({
					Name = 'Rect Size Y',
					Default = 50,
					Min = 25,
					Max = 200,
					Function = function(Val)
						TextGUI:SetImageRectSizeY(Val)
					end
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Image Spacing',
					Default = 0,
					Min = 0,
					Max = 10,
					Function = function(Val)
						TextGUI:SetLayoutPadding(Val)
					end
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Scale',
					Default = 1,
					Min = 0.6,
					Max = 2,
					Decimal = 20,
					Function = function(Val)
						TextGUI:SetScale(Val)
					end
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Left Padding',
					Default = 4,
					Min = 0,
					Max = 12,
					Function = function(Val)
						TextGUI:SetLeftPadding(Val)
					end
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Right Padding',
					Default = 8,
					Min = 0,
					Max = 12,
					Function = function(Val)
						TextGUI:SetRightPadding(Val)
					end
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Spacing',
					Default = 0,
					Min = 0,
					Max = 6,
					Function = function(Val)
						TextGUI:SetSpacing(Val)
					end
				})
	
				TextGUIEnabled:CreateDropdown({
					Name = 'Sorting',
					Info = 'Biggest - Sorts the modules from biggest to smallest\nSmallest - Sorts the modules from smallest to biggest\na-z - Sorts the modules from a-z\nz-a - Sorts the modules from z-a',
					List = {'Biggest', 'Smallest', 'a-z', 'z-a'},
					Function = function(Val)
						TextGUI:SetSortingMethod(Val)
					end
				})
	
				TextGUIEnabled:CreateDropdown({
					Name = 'Alignment',
					Info = 'Right - Aligns the modules to the right\nLeft - Alings the modules to the left',
					List = {'Right', 'Left'},
					Function = function(Val)
						TextGUI:SetAlignment(Val)
					end
				})
	
				TextGUIEnabled:CreateFont({
					Name = 'Watermark Font',
					Default = 'Montserrat',
					Function = function(Font)
						TextGUI:SetWatermarkFont(Font)
					end
				})
	
				TextGUIEnabled:CreateFont({
					Name = 'Font',
					Default = 'Montserrat',
					Function = function(Font)
						TextGUI:SetFont(Font)
					end
				})
	
				local AnimationEnabled = TextGUIEnabled:CreateToggle({
					Name = 'Animation',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetAnimationEnabled(Enabled)
					end
				})
	
				AnimationEnabled:CreateSlider({
					Name = 'Animation Duration',
					Default = 0.3,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetAnimationDuration(Val)
					end
				})
	
				local BackgroundEnabled = TextGUIEnabled:CreateToggle({
					Name = 'Background Enabled',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetBackgroundEnabled(Enabled)
					end
				})
	
				BackgroundEnabled:CreateColorPicker({
					Name = 'Background Color',
					Default = Color3.fromRGB(0, 0, 0),
					DefaultTransparency = 0.5,
					Function = function(Color, Transparency)
						TextGUI:SetBackgroundColor(Color)
						TextGUI:SetBackgroundTransparency(Transparency)
					end,
				})
	
				TextGUIEnabled:CreateSlider({
					Name = 'Corner Radius',
					Default = 4,
					Min = 0,
					Max = 12,
					Function = function(Val)
						TextGUI:SetCornerRadius(Val)
					end
				})
	
				local BarEnabled = TextGUIEnabled:CreateToggle({
					Name = 'Bar Enabled',
					Info = 'Toggles the visibility of the bar on the modules',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetBarEnabled(Enabled)
					end
				})
	
				BarEnabled:CreateColorPicker({
					Name = 'Bar Color',
					Default = TextGUI.BarColor,
					Function = function(Color)
						TextGUI:SetBarColor(Color)
					end
				})
	
				BarEnabled:CreateSlider({
					Name = 'Bar Thickness',
					Default = 4,
					Min = 1,
					Max = 6,
					Function = function(Val)
						TextGUI:SetBarThickness(Val)
					end
				})
	
				TextGUIEnabled:CreateColorPicker({
					Name = 'Text Color',
					Default = Color3.fromRGB(20, 135, 255),
					Function = function(Color)
						TextGUI:SetTextColor(Color)
					end
				})
				
				local RGB = TextGUIEnabled:CreateToggle({
					Name = 'RGB',
					Info = 'Makes the TextGUI RGB (:',
					Function = function(Enabled)
						TextGUI:SetRGBEnabled(Enabled)
					end
				})
	
				local RGBText = RGB:CreateToggle({
					Name = 'RGB Text',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetRGBTextEnabled(Enabled)
					end
				})
	
				RGBText:CreateSlider({
					Name = 'Text Sat',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBTextSaturation(Val)
					end
				})
	
				RGBText:CreateSlider({
					Name = 'Text Val',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBTextValue(Val)
					end
				})
	
				local RGBBackground = RGB:CreateToggle({
					Name = 'RGB Background',
					Function = function(Enabled)
						TextGUI:SetRGBBackgroundEnabled(Enabled)
					end
				})
	
				RGBBackground:CreateSlider({
					Name = 'Background Sat',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBBackgroundSaturation(Val)
					end
				})
	
				RGBBackground:CreateSlider({
					Name = 'Background Val',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBBackgroundValue(Val)
					end
				})
	
				local RGBBar = RGB:CreateToggle({
					Name = 'RGB Bar',
					Default = true,
					Function = function(Enabled)
						TextGUI:SetRGBBarEnabled(Enabled)
					end
				})
	
				RGBBar:CreateSlider({
					Name = 'Bar Sat',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBBarSaturation(Val)
					end
				})
	
				RGBBar:CreateSlider({
					Name = 'Bar Val',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBBarValue(Val)
					end
				})
	
				local RGBWatermark = RGB:CreateToggle({
					Name = 'RGB Watermark',
					Function = function(Enabled)
						TextGUI:SetRGBWatermarkEnabled(Enabled)
					end
				})
	
				RGBWatermark:CreateSlider({
					Name = 'Watermark Sat',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBWatermarkSaturation(Val)
					end
				})
	
				RGBWatermark:CreateSlider({
					Name = 'Watermark Val',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBWatermarkValue(Val)
					end
				})
	
				local RGBImage = RGB:CreateToggle({
					Name = 'RGB Image',
					Function = function(Enabled)
						TextGUI:SetRGBImageEnabled(Enabled)
					end
				})
	
				RGBImage:CreateSlider({
					Name = 'Image Sat',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100
				})
	
				RGBImage:CreateSlider({
					Name = 'Image Val',
					Default = 1,
					Min = 0,
					Max = 1,
					Decimal = 100
				})
	
				RGB:CreateToggle({
					Name = 'RGB Gradient',
					Function = function(Enabled)
						TextGUI:SetRGBGradientEnabled(Enabled)
					end
				})
	
				RGB:CreateSlider({
					Name = 'RGB Speed',
					Default = 1,
					Min = 0.01,
					Max = 3,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBSpeed(Val)
					end
				})
	
				RGB:CreateSlider({
					Name = 'RGB Spread',
					Default = 1,
					Min = 0.01,
					Max = 3,
					Decimal = 100,
					Function = function(Val)
						TextGUI:SetRGBSpread(Val)
					end
				})
	
				RGB:CreateSlider({
					Name = 'RGB Refresh Rate',
					Default = 60,
					Min = 1,
					Max = 240,
					Function = function(Val)
						TextGUI:SetRGBRefreshRate(Val)
					end
				})
	
				RGB:CreateDropdown({
					Name = 'RGB Direction',
					Info = 'Down - The RGB effect goes down\nUp - The RGB effect goes up',
					List = {'Down', 'Up'},
					Function = function(Val)
						TextGUI:SetRGBDirection(Val)
					end
				})
			end)
		end)
	
		Run(function() -- TopBar Buttons
			ModulesTopBar = CreateTopBarButton({
				Name = 'Modules',
				Function = function(Visible)
					HideMenus('Modules', if Visible ~= nil then Visible else true)
				end,
			})
			ModulesTopBar:Select(false)
			TidalWave.SelectedTopBar = ModulesTopBar.Object
	
			CreateTopBarButton({
				Name = 'Config',
				Function = function()
					ConfigMenu:ShowOptions()
					HideMenus('Config')
					StopEditingHudPositions()
				end,
			})
	
			CreateTopBarButton({
				Name = 'GUI',
				Function = function()
					GuiMenu:ShowOptions()
					HideMenus('GUI')
					StopEditingHudPositions()
				end,
			})
	
			CreateTopBarButton({
				Name = 'HUD',
				Function = function()
					HudMenu:ShowOptions()
					HideMenus('HUD')
					StopEditingHudPositions()
				end,
			})
		end)
	
		Run(function() -- Profiles
			ProfilesMenu = TidalWave:CreateMenu({
				Name = 'Profiles',
			})
	
			function ProfilesMenu:CreateProfileButton(Properties)
				return Components.Other.ProfileButton(Properties)
			end

			const function ClearProfileMenu()
				for _, v in ProfilesMenu.Children:GetChildren() do
					if v:IsA('GuiObject') then
						v:Destroy()
					end
				end
			end

			const function CreateMainButtons()
				const PlusButton = Instance.new('TextButton')
				PlusButton.Name = 'Plus'
				PlusButton.BackgroundColor3 = GetColor('Background/Button')
				PlusButton.Text = ''
				PlusButton.BorderSizePixel = 0
				PlusButton.Size = UDim2.fromOffset(40, 40)
				PlusButton.AutoButtonColor = false
				PlusButton.LayoutOrder = 69420
				PlusButton.Parent = ProfilesMenu.Children
				AddCorner(PlusButton, UDim.new(0, 7))
				AddHighlight(PlusButton)
				ListenObject(PlusButton, 'Background/Button')

				const PlusImage = Instance.new('ImageLabel')
				PlusImage.Name = 'Image'
				PlusImage.BackgroundTransparency = 1
				PlusImage.Size = UDim2.fromOffset(24, 24)
				PlusImage.Position = UDim2.fromOffset(8, 8)
				SetIcon(PlusImage, 'plus')
				PlusImage.Parent = PlusButton
				ListenObject(PlusImage, 'Main/Icons')
				
				const Import = Instance.new('Frame')
				Import.Name = 'Import'
				Import.BackgroundColor3 = GetColor('Background/Button')
				Import.BorderSizePixel = 0
				Import.Size = UDim2.new(1, -100, 0, 40)
				Import.LayoutOrder = -1
				Import.Parent = ProfilesMenu.Children
				AddCorner(Import, UDim.new(0, 7))
				ListenObject(Import, 'Background/Button')

				const ImportButton = Instance.new('TextButton')
				ImportButton.Name = 'ImportButton'
				ImportButton.BackgroundColor3 = GetColor('Background/Secondary')
				ImportButton.Size = UDim2.fromOffset(125, 30)
				ImportButton.Position = UDim2.new(1, -130, 0, 5)
				ImportButton.TextSize = 24
				ImportButton.FontFace = GetFont('Regular')
				ImportButton.Text = 'Import'
				ImportButton.AutoButtonColor = false
				ImportButton.TextColor3 = GetColor('Text/Primary')
				ImportButton.Parent = Import
				AddCorner(ImportButton, UDim.new(0, 7))
				AddHighlight(ImportButton, 'Background/Secondary')
				ListenObject(ImportButton, 'Background/Secondary', 'Text/Primary')
				ListenFont(ImportButton, 'Regular'); do
					const ImportPadding = Instance.new('UIPadding')
					ImportPadding.PaddingLeft = UDim.new(0, 5)
					ImportPadding.Parent = ImportButton
				end
				
				const ImportBox = Instance.new('TextBox')
				ImportBox.BackgroundColor3 = GetColor('Background/Secondary')
				ImportBox.BorderSizePixel = 0
				ImportBox.Size = UDim2.fromOffset(300, 30)
				ImportBox.Position = UDim2.fromOffset(5, 5)
				ImportBox.ClearTextOnFocus = false
				ImportBox.PlaceholderText = '[Copied Config here]'
				ImportBox.TextColor3 = GetColor('Text/Primary')
				ImportBox.PlaceholderColor3 = GetColor('Text/Placeholder')
				ImportBox.FontFace = GetFont('Regular')
				ImportBox.TextSize = 24
				ImportBox.Text = ''
				ImportBox.ClipsDescendants = true
				ImportBox.Parent = Import
				AddCorner(ImportBox, UDim.new(0, 7))
				ListenObject(ImportBox, 'Background/Secondary', 'Text/Primary')
				ListenObject(ImportBox, 'Text/Placeholder')
				ListenFont(ImportBox, 'Regular'); do
					const TextPadding = Instance.new('UIPadding')
					TextPadding.PaddingLeft = UDim.new(0, 5)
					TextPadding.PaddingRight = UDim.new(0, 5)
					TextPadding.Parent = ImportBox
				end

				ImportButton.MouseButton1Click:Connect(function()
					if ImportBox.Text ~= '' then
						local Name = 'imported profile'
						if table.find(TidalWave.Profiles, Name) then
							Name ..= ' 2'
						end

						ProfilesMenu:CreateProfileButton({
							Name = Name,
							Imported = ImportBox.Text
						})
						ImportBox.Text = ''
					end
				end)

				PlusButton.MouseButton1Click:Connect(function()
					local Name = 'new profile'
					if table.find(TidalWave.Profiles, Name) then
						Name ..= ' 2'
					end

					ProfilesMenu:CreateProfileButton({
						Name = Name,
						New = true,
					})
				end)
			end

			const function CreateProfiles()
				for i, v in TidalWave.Profiles do
					ProfilesMenu:CreateProfileButton({
						Name = v,
						LayoutOrder = i
					})
				end
			end
	
			CreateTopBarButton({
				Name = 'Profiles',
				Function = function()
					HideMenus('Profiles')
					StopEditingHudPositions()
					ClearProfileMenu()
					CreateMainButtons()
					CreateProfiles()
				end,
			})
		end)
	
		Run(function() -- Friends
			FriendsMenu = TidalWave:CreateMenu({
				Name = 'Friends'
			})
	
			function FriendsMenu:CreateFriendButton(Properties)
				return Components.Other.FriendButton(Properties)
			end
	
			local UseFriends, RecolorFriends, FriendColor, AllowDisplayName, List
	
			local function Refresh()
				if TidalWave.Libraries and TidalWave.Libraries.EntityLib then
					TidalWave.Libraries.EntityLib:Refresh()
				end
			end
	
			UseFriends = FriendsMenu:CreateToggle({
				Name = 'Use Friends',
				Default = true,
				Function = Refresh
			})
	
			RecolorFriends = FriendsMenu:CreateToggle({
				Name = 'Recolor Friends',
				Default = true,
				Function = Refresh
			})
	
			FriendColor = FriendsMenu:CreateColorPicker({
				Name = 'Friend Color',
				Default = Color3.Green,
				Function = Refresh
			})
	
			AllowDisplayName = FriendsMenu:CreateToggle({
				Name = 'Allow Display Name',
				Info = 'Checks for Displaynames and Usernames',
				Default = true,
				Function = Refresh
			})
	
			List = FriendsMenu:CreateTextList({
				Name = 'Friends',
				Function = Refresh
			})
	
			local function Find(Name: string): boolean
				Name = Name:lower()
	
				for _, v in List.Enabled do
					if v:lower() == Name then
						return true
					end
				end
	
				return false
			end
	
			function TidalWave:IsFriend(Player: Player): boolean
				if typeof(Player) == 'Instance' and Player:IsA('Player') then
					if Find(Player.Name) then
						return true
					elseif AllowDisplayName.Enabled and Player.DisplayName ~= Player.Name then
						return Find(Player.DisplayName)
					end
				end
	
				return false
			end
			
			function TidalWave:GetFriendColor(Player: Player): (Color3, number)
				if typeof(Player) == 'Instance' and Player:IsA('Player') then
					local Valid = UseFriends.Enabled and RecolorFriends.Enabled and TidalWave:IsFriend(Player)
					if Valid then
						return FriendColor.Color, FriendColor.Transparency
					end
				end
				
				return nil, nil
			end
	
			CreateTopBarButton({
				Name = 'Friends',
				Function = function()
					FriendsMenu:ShowOptions()
					HideMenus('Friends')
					StopEditingHudPositions()
				end
			})
		end)
	end)
	
	Run(function() -- Input Handling
		local MouseEnabledCon, UpdateCursorCon, HeldModule
	
		local function OnMouseEnableChanged()
			if UIS.MouseIconEnabled then
				if UpdateCursorCon then
					UpdateCursorCon:Disconnect()
					UpdateCursorCon = nil
				end
				Cursor.Visible = false
			else
				Cursor.Visible = true
				UpdateCursorCon = RunService.PreRender:Connect(function()
					local MouseLocation = UIS:GetMouseLocation()
					Cursor.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
				end)
			end
		end
	
		local function StopCursorCon()
			if MouseEnabledCon then
				MouseEnabledCon:Disconnect()
				MouseEnabledCon = nil
			end
			if UpdateCursorCon then
				UpdateCursorCon:Disconnect()
				UpdateCursorCon = nil
			end
			Cursor.Visible = false
		end
	
		local function StartCursorCon()
			StopCursorCon()
			OnMouseEnableChanged()
			MouseEnabledCon = UIS:GetPropertyChangedSignal('MouseEnabled'):Connect(OnMouseEnableChanged)
		end
	
		local function CheckKeybind(Keybind, LatestInput)
			if Keybind == 'None' then return false end
			if Keybind:match(LatestInput) then
				for _, v in Keybind:split('+') do
					if not TidalWave.PressedKeys[v] then return false end
				end
				return true
			end
	
			return false
		end
	
		TidalWave:Clean(StopCursorCon)
	
		const UserInputTypes = {
			['MouseButton1'] = true,
			['MouseButton2'] = true,
			['MouseButton3'] = true,
		}
	
		local function Concat(Tab, Char)
			local String = ''
			local Index = 0
			for Name in Tab do
				Index += 1
				String ..= (String ~= '' and Char or '') .. Name
			end
			return String
		end
	
		TidalWave:Clean(UIS.InputBegan:Connect(function(Input)
			if UIS:GetFocusedTextBox() then return end
			if TidalWave.Binding and ((Input.KeyCode == Enum.KeyCode.None and not AllowMouseBinding.Enabled) or Input.KeyCode == Enum.KeyCode.Escape) then
				TidalWave.Binding:SetKeybind(TidalWave.Binding.Keybind)
				TidalWave.Binding = nil
			elseif ((Input.KeyCode ~= Enum.KeyCode.None or AllowMouseBinding.Enabled and UserInputTypes[Input.UserInputType.Name]) and Input.KeyCode ~= Enum.KeyCode.Escape) then
				local Key = Input.KeyCode == Enum.KeyCode.None and Input.UserInputType.Name or Input.KeyCode.Name
				TidalWave.PressedKeys[Key] = true
				if TidalWave.Binding then
					TidalWave.Binding:SetKeybind(Concat(TidalWave.PressedKeys, '+'))
				else
					if MenuKeybind:Check(Input) then
						if MenuOptions.Object.Visible then
							MenuOptions.Object.Visible = false
							for i, v in TidalWave.Menus do
								if i == PrevMenu then
									v:Show()
									break
								end
							end
							return
						end

						if CurrentColorPicker then
							CurrentColorPicker.Visible = false
							CurrentColorPicker = nil
							if ColorPickerHidMenuOptions then
								MenuOptions.Object.Visible = true
							else
								for i, v in TidalWave.Menus do
									if i == PrevMenu then
										v:Show()
										break
									end
								end
							end
							return
						end
	
						local Menu
						for _, v in TidalWave.Menus do
							if v.Object.Visible then
								Menu = v
							end
						end
						
						if Menu then
							ModulesTopBar:Select()
							return
						end
	
						if DoneButton.Visible then
							StopEditingHudPositions()
							return
						end
	
						TopBar.Visible = not CategoryHolder.Visible
						if not TidalWave.CategoryAnimations then
							CategoryHolder.Visible = not CategoryHolder.Visible
						end
	
						if CategoryHolder.Visible then
							Tooltip.Visible = false
							StopCursorCon()
						else
							StartCursorCon()
						end
	
						for _, Category in TidalWave.Categories do
							Category:Toggle()
						end
	
						if not CategoryHolder.Visible and TidalWave.CategoryAnimations then
							CategoryHolder.Visible = true
							Modal.Visible = true
						end
					else
						if TopBar.Visible and UserInputTypes[Key] then return end

						for _, Module in TidalWave.Modules do
							const Keybind = Module.Keybinds.Toggle
							if CheckKeybind(Keybind.Keybind, Key) then
								if Keybind.Hold then
									HeldModule = Module
									if not Module.Enabled then
										Module:Toggle()
									end
								else
									Module:Toggle()
								end
							end
						end

						for _, Button in TidalWave.Buttons do
							if CheckKeybind(Button.Keybinds.Toggle.Keybind, Key) then
								Button:Toggle()
							end
						end
					end
				end
			end
		end))
	
		TidalWave:Clean(UIS.InputEnded:Connect(function(Input)
			if Input.KeyCode == Enum.KeyCode.None and not AllowMouseBinding.Enabled then return end
			local Key = Input.KeyCode == Enum.KeyCode.None and Input.UserInputType.Name or Input.KeyCode.Name
			TidalWave.PressedKeys[Key] = nil
			if TidalWave.Binding then
				TidalWave.Binding = nil
				table.clear(TidalWave.PressedKeys)
			elseif HeldModule and HeldModule.Keybinds.Toggle.Keybind:match(Key) then
				if HeldModule.Enabled then
					HeldModule:Toggle()
				end
				HeldModule = nil
			end
		end))
	end)
	
	Run(function() -- Categories
		TidalWave:CreateCategory({
			Name = 'Combat',
		})
	
		TidalWave:CreateCategory({
			Name = 'Player',
		})
	
		TidalWave:CreateCategory({
			Name = 'Movement'
		})
	
		TidalWave:CreateCategory({
			Name = 'Visuals'
		})
	
		TidalWave:CreateCategory({
			Name = 'World'
		})
	
		TidalWave:CreateCategory({
			Name = 'Other'
		})
	
		TidalWave:CreateCategory({
			Name = 'Animations'
		})
	end)
	
	Run(function() -- Search
		local Search = Instance.new('TextBox')
		Search.Text = ''
		Search.Name = 'Search'
		Search.LayoutOrder = #TopBar:GetChildren()
		Search.Size = UDim2.fromOffset(160, 36)
		Search.BackgroundColor3 = GetColor('Background/Button')
		Search.BackgroundTransparency = 0.25
		Search.BorderSizePixel = 0
		Search.TextColor3 = GetColor('Text/Primary')
		Search.FontFace = GetFont('Regular')
		Search.TextSize = 24
		Search.TextXAlignment = Enum.TextXAlignment.Left
		Search.ClearTextOnFocus = false
		Search.PlaceholderText = 'Search'
		Search.PlaceholderColor3 = GetColor('Text/Placeholder')
		Search.Parent = TopBar
		AddCorner(Search, UDim.new(0, 9))
		ListenObject(Search, 'Background/Button', 'Text/Primary')
		ListenObject(Search, 'Text/Placeholder')
		ListenFont(Search, 'Regular')
		TopBar.Size += UDim2.fromOffset(168, 0)

		local function GetChildren()
			local Children = {}
			for _, Category in TidalWave.Categories do
				for _, Button in Category.Children:GetChildren() do
					if Button:IsA('TextButton') then
						table.insert(Children, Button)
					end
				end
			end
			return Children
		end

		local function ScrollTo(Object)
			const Children = Object.Parent
			const MinPosition = Children.AbsolutePosition.Y + Object.AbsoluteSize.Y
			const MaxPosition = Children.AbsolutePosition.Y - Object.AbsoluteSize.Y
			if Object.AbsolutePosition.Y < MinPosition then
				local Diff = MinPosition - Object.AbsolutePosition.Y
				Children.CanvasPosition -= Vector2.new(0, Diff)
			elseif Object.AbsolutePosition.Y > MaxPosition then
				local Diff = Object.AbsolutePosition.Y - MaxPosition
				Children.CanvasPosition += Vector2.new(0, Diff)
			end
		end

		local function HighlightButton(Object)
			Object.BackgroundColor3 = GetColor('Background/ButtonHover')
			SearchMatches[Object] = true
		end

		local function ClearHighlights()
			for Button in SearchMatches do
				Button.BackgroundColor3 = GetColor('Background/Button')
			end
			table.clear(SearchMatches)
		end
	
		Search:GetPropertyChangedSignal('Text'):Connect(function()
			const Text = Search.Text:lower():gsub(' ', '')
			const Blank = Text:match('%w+') == nil

			if Blank then
				ClearHighlights()
				return
			end

			const Children = GetChildren()
			const SubMatches = {}
			const Matches = {}
			
			local AnyHighlighted = false

			for _, Button in Children do
				const ButtonText = Button.Text:gsub(' ', ''):lower()

				if ButtonText == Text then
					ClearHighlights()
					HighlightButton(Button)
					ScrollTo(Button)
					AnyHighlighted = true
					break
				elseif ButtonText:sub(1, #Text) == Text then
					HighlightButton(Button)
					SubMatches[Button] = #ButtonText
					AnyHighlighted = true
				elseif not AnyHighlighted and ButtonText:match(Text) then
					Matches[Button] = true
				elseif SearchMatches[Button] then
					Button.BackgroundColor3 = GetColor('Background/Button')
					SearchMatches[Button] = nil
				end
			end

			if next(SubMatches) then
				const SearchLen = #Text
				local Closest, ClosestDiff = nil, math.huge
				for Button, Len in SubMatches do
					local Diff = math.abs(SearchLen - Len)
					if Diff < ClosestDiff then
						ClosestDiff = Diff
						Closest = Button
					end
				end

				if Closest then
					ScrollTo(Closest)
				end
			else
				for Button in Matches do
					HighlightButton(Button)
				end
			end
		end)
	
		local UIPadding = Instance.new('UIPadding')
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.Parent = Search
	
		local Icon = Instance.new('ImageLabel')
		Icon.Name = 'SearchIcon'
		Icon.BackgroundTransparency = 1
		Icon.Size = UDim2.fromOffset(24, 24)
		Icon.Position = UDim2.new(1, -32, 0, 6)
		SetIcon(Icon, 'search')
		Icon.Parent = Search
	end)
end

Components = {
	Category = {
		Module = function(Properties)
			const Module = {
				Enabled = false,
				Keybind = 'None',
				ExtraText = Properties.ExtraText,
				Category = Properties.Category,
				Options = {},
				Keybinds = {}
			}

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
		
			const Button = Instance.new('TextButton')
			Button.Name = `{SubbedName}Module`
			Button.BorderSizePixel = 0
			Button.BackgroundColor3 = GetColor('Background/Button')
			Button.Text = Name
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Button.Size = UDim2.new(1, 0, 0, 26)
			Button.TextColor3 = GetColor('Text/Primary')
			Button.TextSize = 15
			Button.AutoButtonColor = false
			Button.FontFace = GetFont('Regular')
			Button.LayoutOrder = table.len(Module.Category.Options)
			Button.Parent = Properties.Parent
			AddTooltip(Button, Properties.Tooltip or Properties.Info, true)
			AddHighlight(Button, nil, true)
			AddMaid(Module)
			AddInstanceTable(Module)
			ListenObject(Button, 'Background/Button', 'Text/Primary', function()
				Button.BackgroundColor3 = (SearchMatches[Button] or Button.GuiState == Enum.GuiState.Hover) and GetColor('Background/ButtonHover') or GetColor('Background/Button')
				Button.TextColor3 = Module.Enabled and GetColor('Text/ModuleEnabled') or GetColor('Text/Primary')
			end)
			ListenFont(Button, 'Regular')
		
			const Padding = Instance.new('UIPadding')
			Padding.PaddingLeft = UDim.new(0, 5)
			Padding.Parent = Button
		
			const EnabledBar = Instance.new('Frame')
			EnabledBar.Name = 'Enabled'
			EnabledBar.BackgroundColor3 = GetColor('Main/DisabledBar')
			EnabledBar.Size = UDim2.fromOffset(2, 20)
			EnabledBar.Position = UDim2.new(1, -6, 0, 3)
			EnabledBar.BorderSizePixel = 0
			EnabledBar.Parent = Button
			ListenObject(EnabledBar, 'Main/EnabledBar', 'Main/DisabledBar', function()
				EnabledBar.BackgroundColor3 = Module.Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
			end)
		
			const InitialTextBounds = GetTextBounds(Name, 15, Button.FontFace).X + 15
			if InitialTextBounds > Button.Parent.Parent.Parent.Size.X.Offset then
				Button.Parent.Parent.Parent.Size = UDim2.fromOffset(InitialTextBounds, Button.Parent.Parent.Parent.Size.Y.Offset)
				UpdateCategoryPositions()
			end

			Components.Options.Keybind({
				Name = 'Toggle',
				Text = 'Keybind',
				UseHold = true,
				Module = Module,
				Parent = TidalWave.Menus.Options.Children
			})
		
			function Module:Toggle(NoNotify)
				self.Enabled = not self.Enabled
				if not NoNotify then
					const ToggledString = self.Enabled and 'Enabled' or 'Disabled'
					const Color = GetColor(`Notification/Module{ToggledString}`):ToHex()
					Notify({
						Title = 'Module Toggled',
						Text = `{Name} has been <font color = '#{Color}'>{ToggledString}</font>`,
						Duration = TidalWave.ModuleToggledNotificationDuration,
					})
				end
		
				Button.TextColor3 = self.Enabled and GetColor('Text/ModuleEnabled') or GetColor('Text/Primary')
				EnabledBar.BackgroundColor3 = self.Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
		
				if self.Enabled then
					TextGUI:AddModule(Name, self.ExtraText)
					if Properties.Enabled then
						task.spawn(Properties.Enabled)
					end
				else
					TextGUI:RemoveModule(Name)
					self:DisconnectAll()
					self:ClearInstances()
				end
		
				if Properties.Function then
					task.spawn(Properties.Function, self.Enabled)
				end
			end

			function Module:Enable(NoNotify)
				if not self.Enabled then
					self:Toggle(NoNotify)
				end
			end

			function Module:Disable(NoNotify)
				if self.Enabled then
					self:Toggle(NoNotify)
				end
			end
		
			function Module:Restart()
				if self.Enabled then
					self:Toggle(true)
					self:Toggle(true)
				end
			end

			function Module:Save(Tab)
				Tab[SubbedName] = {
					Enabled = self.Enabled,
					Options = TidalWave:SaveOptions(self.Options),
					Keybinds = TidalWave:SaveOptions(self.Keybinds)
				}
			end

			function Module:Load(Tab)
				if Tab.Options then
					TidalWave:LoadOptions(self.Options, Tab.Options)
				end
				if Tab.Keybinds then
					TidalWave:LoadOptions(self.Keybinds, Tab.Keybinds)
				end
				if Tab.Enabled ~= self.Enabled then
					self:Toggle(true)
				end
			end
			
			function Module:UpdateTextGUI()
				TextGUI:UpdateExtraText(Name)
			end
			
			Button.MouseButton1Click:Connect(function()
				Module:Toggle()
			end)
			
			Button.MouseButton2Click:Connect(function()
				Tooltip.Visible = false
				CategoryHolder.Visible = false
				TidalWave.Menus.Options:HideChildren()
				for _, v in Module.Options do
					v.Object.Visible = if v.Visible ~= nil then v.Visible else true
				end
				for _, v in Module.Keybinds do
					v.Object.Visible = if v.Visible ~= nil then v.Visible else true
				end
				TidalWave.Menus.Options.Object.Title.Text = Name
				TidalWave.Menus.Options:Show()
			end)
			
			Module.Object = Button
		
			for i, v in Components.Options do
				Module[`Create{i}`] = function(_, Properties)
					Properties.Parent = TidalWave.Menus.Options.Children
					Properties.LayoutOrder = table.len(Module.Options) + table.len(Module.Keybinds)
					Properties.Module = Module
					return v(Properties)
				end
			end
		
			TidalWave.Modules[SubbedName] = Module
		
			return Module
		end,
		Button = function(Properties)
			const Button = {
				Keybind = 'None',
				Options = {},
				Keybinds = {},
				Category = Properties.Category
			}
			
			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
		
			const ButtonObject = Instance.new('TextButton')
			ButtonObject.BorderSizePixel = 0
			ButtonObject.Name = `{SubbedName}Button`
			ButtonObject.BackgroundColor3 = GetColor('Background/Button')
			ButtonObject.TextXAlignment = Enum.TextXAlignment.Left
			ButtonObject.Size = UDim2.new(1, 0, 0, 26)
			ButtonObject.TextColor3 = GetColor('Text/Primary')
			ButtonObject.TextSize = 15
			ButtonObject.FontFace = GetFont('Regular')
			ButtonObject.Text = Name
			ButtonObject.AutoButtonColor = false
			ButtonObject.LayoutOrder = table.len(Button.Category.Options)
			ButtonObject.Parent = Properties.Parent
			AddTooltip(ButtonObject, Properties.Tooltip or Properties.Info, true)
			AddHighlight(ButtonObject, nil, true)
			ListenObject(ButtonObject, 'Background/Button', 'Text/Primary')
			ListenFont(ButtonObject, 'Regular')
		
			const Padding = Instance.new('UIPadding')
			Padding.PaddingLeft = UDim.new(0, 5)
			Padding.Parent = ButtonObject
		
			function Button:Toggle()
				if Properties.Function then
					Properties.Function()
				end
			end

			function Button:Save(Tab)
				Tab[SubbedName] = {
					Options = TidalWave:SaveOptions(self.Options),
					Keybinds = TidalWave:SaveOptions(self.Keybinds)
				}
			end

			function Button:Load(Tab)
				if Tab.Options then
					TidalWave:LoadOptions(self.Options, Tab.Options)
				end
				if Tab.Keybinds then
					TidalWave:LoadOptions(self.Keybinds, Tab.Keybinds)
				end
			end
		
			Components.Options.Keybind({
				Name = 'Toggle',
				Text = 'Keybind',
				Module = Button,
				Parent = TidalWave.Menus.Options.Children
			})

			if Properties.Function then
				ButtonObject.MouseButton1Click:Connect(Properties.Function)
			end
		
			ButtonObject.MouseButton2Click:Connect(function()
				Tooltip.Visible = false
				CategoryHolder.Visible = false
				TidalWave.Menus.Options:HideChildren()

				for _, v in Button.Options do
					v.Object.Visible = if v.Visible ~= nil then v.Visible else true
				end

				for _, v in Button.Keybinds do
					v.Object.Visible = true
				end

				TidalWave.Menus.Options.Object.Title.Text = Name
				TidalWave.Menus.Options:Show()
			end)
		
			Button.Object = ButtonObject
		
			for i, v in Components.Options do
				Button[`Create{i}`] = function(_, Properties)
					Properties.Parent = TidalWave.Menus.Options.Children
					Properties.LayoutOrder = table.len(Button.Options) + table.len(Button.Keybinds)
					Properties.Module = Button

					return v(Properties)
				end
			end
		
			TidalWave.Buttons[SubbedName] = Button
			Button.Category.Options[SubbedName] = Button
		
			return Button
		end,
	},
	Options = {
		AssetTextBox = function(Properties)
			const Function = Properties.Function
			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			local CurrentText = Properties.Default or ''
			local TextBox
			
			Properties.Function = function(Text, Loaded)
				local Asset, Result = GetAssetFromText(Text)
			
				TextBox.Value = Asset or Properties.Default or ''
				CurrentText = Text
			
				if Asset then
					Function(Asset)
				elseif Result and not Loaded then
					Notify({
						Text = Result,
						Duration = 10,
						Type = 'Error'
					})
				end
			end
			
			TextBox = Components.Options.TextBox(Properties)
			
			function TextBox:Save(Tab)
				Tab[SubbedName] = {
					Value = CurrentText
				}
			end
			
			return TextBox
		end,
		Button = function(Properties)
			const Button = {
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			const Tooltip = Properties.Tooltip or Properties.Info
			const Function = Properties.Function
			const LayoutOrder = Properties.LayoutOrder or 0
			const Parent = Properties.Parent
			
			const ButtonObject = Instance.new('TextButton')
			ButtonObject.Name = `{Name}Button`
			ButtonObject.BackgroundColor3 = GetColor('Background/Button')
			ButtonObject.Size = UDim2.new(1, -100, 0, 40)
			ButtonObject.LayoutOrder = LayoutOrder
			ButtonObject.TextXAlignment = Enum.TextXAlignment.Left
			ButtonObject.TextSize = 24
			ButtonObject.FontFace = GetFont('Regular')
			ButtonObject.Text = Name
			ButtonObject.AutoButtonColor = false
			ButtonObject.TextColor3 = GetColor('Text/Primary')
			ButtonObject.Parent = Parent
			AddCorner(ButtonObject, UDim.new(0, 7))
			AddTooltip(ButtonObject, Tooltip)
			AddHighlight(ButtonObject)
			ListenObject(ButtonObject, 'Background/Button', 'Text/Primary')
			ListenFont(ButtonObject, 'Regular')

			const Padding = Instance.new('UIPadding')
			Padding.PaddingLeft = UDim.new(0, 5)
			Padding.Parent = ButtonObject

			if Function then
				ButtonObject.MouseButton1Click:Connect(Function)
				Button.Toggle = Function
			else
				Button.Toggle = function() end
			end

			Button.Object = ButtonObject
			Properties.Module.Buttons[SubbedName] = Button
			
			return Button
		end,
		ColorPicker = function(Properties)
			const DefaultColor = Properties.Color or Properties.DefaultColor or Properties.Default or Color3.White
			const DefaultHue, DefaultSaturation, DefaultValue = DefaultColor:ToHSV()
			const DefaultR = math.round(DefaultColor.R * 255)
			const DefaultG = math.round(DefaultColor.G * 255)
			const DefaultB = math.round(DefaultColor.B * 255)

			const UseTransparency = if Properties.UseTransparency ~= nil then Properties.UseTransparency else true
			const DefaultTransparency = Properties.Transparency or Properties.DefaultTransparency or 0
			const DefaultRainbow = if Properties.Rainbow ~= nil then Properties.Rainbow else false

			const ColorPicker = {
				Color = DefaultColor,
				R = DefaultR,
				G = DefaultG,
				B = DefaultB,
				Transparency = DefaultTransparency,
				UseTransparency = UseTransparency,
				Rainbow = DefaultRainbow,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}

			local Hue, Sat, Val = DefaultHue, DefaultSaturation, DefaultValue
			local HoldHSV = false
			local SavedTransparency = DefaultTransparency

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')

			const InitialTextBounds = GetTextBounds(Name, 24)

			const Frame = Instance.new('Frame')
			Frame.Name = `{Name}ColorPicker`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Parent = Properties.Parent

			const Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')

			const NameLabel = Instance.new('TextLabel')
			NameLabel.Position = UDim2.fromOffset(5, 0)
			NameLabel.Size = UDim2.fromOffset(InitialTextBounds.X + 5, 40)
			NameLabel.BackgroundTransparency = 1
			NameLabel.FontFace = GetFont('Regular')
			NameLabel.TextSize = 24
			NameLabel.TextColor3 = GetColor('Text/Primary')
			NameLabel.Text = Name
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.Parent = Background
			ListenObject(NameLabel, 'Text/Primary')
			ListenFont(NameLabel, 'Regular')

			const RGBFrame = Instance.new('Frame')
			RGBFrame.Name = 'RGBFrame'
			RGBFrame.BackgroundColor3 = GetColor('Background/Secondary')
			RGBFrame.BorderSizePixel = 0
			RGBFrame.Position = UDim2.fromOffset(InitialTextBounds.X + 10, 4)
			RGBFrame.Size = UDim2.fromOffset(200, 32)
			RGBFrame.Parent = Background
			AddCorner(RGBFrame, UDim.new(0, 7))
			ListenObject(RGBFrame, 'Background/Secondary')

			const RGBInput = Instance.new('TextBox')
			RGBInput.Name = 'RGBInput'
			RGBInput.BackgroundTransparency = 1
			RGBInput.Position = UDim2.fromOffset(4, 0)
			RGBInput.Size = UDim2.fromOffset(130, 32)
			RGBInput.FontFace = GetFont('Regular')
			RGBInput.TextColor3 = GetColor('Text/Primary')
			RGBInput.TextSize = 24
			RGBInput.PlaceholderColor3 = GetColor('Text/Placeholder')
			RGBInput.PlaceholderText = '[R, G, B]'
			RGBInput.Text = `{ColorPicker.R}, {ColorPicker.G}, {ColorPicker.B}`
			RGBInput.ClearTextOnFocus = false
			RGBInput.ClipsDescendants = true
			RGBInput.Parent = RGBFrame
			ListenObject(RGBInput, 'Text/Primary', 'Text/Placeholder')
			ListenFont(RGBInput, 'Regular')

			const ColorDisplay = Instance.new('ImageButton')
			ColorDisplay.Name = 'ColorDisplay'
			ColorDisplay.BackgroundColor3 = DefaultColor
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Position = UDim2.fromOffset(136, 4)
			ColorDisplay.Size = UDim2.fromOffset(24, 24)
			ColorDisplay.ImageTransparency = 1
			ColorDisplay.AutoButtonColor = false
			ColorDisplay.Parent = RGBFrame
			AddCorner(ColorDisplay, UDim.new(0, 7))

			const OpenMenuButton = Instance.new('ImageButton')
			OpenMenuButton.Name = 'OpenMenuButton'
			OpenMenuButton.BackgroundTransparency = 1
			OpenMenuButton.Position = UDim2.fromOffset(168, 4)
			OpenMenuButton.Size = UDim2.fromOffset(24, 24)
			OpenMenuButton.AutoButtonColor = false
			SetIcon(OpenMenuButton, 'pencil')
			OpenMenuButton.Parent = RGBFrame

			const PickerMenu = Instance.new('TextButton')
			PickerMenu.Name = `{Name}ColorPickerMenu`
			PickerMenu.Position = UDim2.new(0.5, -370 / 2, 0.5, 0)
			PickerMenu.Size = UDim2.fromOffset(370, 32)
			PickerMenu.BackgroundColor3 = GetColor('Main/Accent')
			PickerMenu.Text = ''
			PickerMenu.AutoButtonColor = false
			PickerMenu.Visible = false
			PickerMenu.Parent = MenuHolder
			ListenObject(PickerMenu, 'Main/Accent')

			const PickerMenuCorner = Instance.new('UICorner')
			PickerMenuCorner.CornerRadius = UDim.zero
			PickerMenuCorner.TopLeftRadius = UDim.new(0, 10)
			PickerMenuCorner.TopRightRadius = UDim.new(0, 10)
			PickerMenuCorner.Parent = PickerMenu

			const PickerMenuTitle = Instance.new('TextLabel')
			PickerMenuTitle.Name = 'Title'
			PickerMenuTitle.Size = UDim2.fromScale(1, 1)
			PickerMenuTitle.BackgroundTransparency = 1
			PickerMenuTitle.Text = `  {Name}`
			PickerMenuTitle.TextSize = 28
			PickerMenuTitle.FontFace = GetFont('Medium')
			PickerMenuTitle.TextColor3 = GetColor('Text/Primary')
			PickerMenuTitle.Parent = PickerMenu
			ListenObject(PickerMenuTitle, 'Text/Primary')
			ListenFont(PickerMenuTitle, 'Medium')

			const ColorPickerDropdown = Instance.new('Frame')
			ColorPickerDropdown.Name = 'Children'
			ColorPickerDropdown.Size = UDim2.fromScale(1, 0)
			ColorPickerDropdown.Position = UDim2.fromScale(0, 1)
			ColorPickerDropdown.BackgroundColor3 = GetColor('Background/Primary')
			ColorPickerDropdown.BorderSizePixel = 0
			ColorPickerDropdown.Parent = PickerMenu
			ListenObject(ColorPickerDropdown, 'Background/Primary')

			const PickerBodyCorner = Instance.new('UICorner')
			PickerBodyCorner.CornerRadius = UDim.zero
			PickerBodyCorner.BottomLeftRadius = UDim.new(0, 10)
			PickerBodyCorner.BottomRightRadius = UDim.new(0, 10)
			PickerBodyCorner.Parent = ColorPickerDropdown

			const PickerClose = Instance.new('TextButton')
			PickerClose.Name = 'Close'
			PickerClose.Size = UDim2.fromOffset(32, 32)
			PickerClose.Position = UDim2.new(1, -32, 0, 0)
			PickerClose.BackgroundTransparency = 1
			PickerClose.Text = ''
			PickerClose.Parent = PickerMenu

			const PickerCloseImage = Instance.new('ImageLabel')
			PickerCloseImage.Name = 'Image'
			PickerCloseImage.Size = UDim2.fromOffset(28, 28)
			PickerCloseImage.Position = UDim2.fromOffset(2, 2)
			PickerCloseImage.BackgroundTransparency = 1
			SetIcon(PickerCloseImage, 'x')
			PickerCloseImage.Parent = PickerClose
			ListenObject(PickerCloseImage, 'Main/Icons')

			const MenuColorDisplay = Instance.new('Frame')
			MenuColorDisplay.Name = 'MenuColorDisplay'
			MenuColorDisplay.BackgroundColor3 = DefaultColor
			MenuColorDisplay.BackgroundTransparency = ColorPicker.Transparency
			MenuColorDisplay.BorderSizePixel = 0
			MenuColorDisplay.Position = UDim2.fromOffset(10, 10)
			MenuColorDisplay.Size = UDim2.new(1, -20, 0, 30)
			MenuColorDisplay.ZIndex = 2
			MenuColorDisplay.Parent = ColorPickerDropdown

			const RainbowRow = Instance.new('Frame')
			RainbowRow.Name = 'RainbowToggle'
			RainbowRow.BackgroundTransparency = 1
			RainbowRow.Position = UDim2.fromOffset(10, 0)
			RainbowRow.Size = UDim2.new(1, -20, 0, 30)
			RainbowRow.ZIndex = 2
			RainbowRow.Parent = ColorPickerDropdown

			const RainbowLabel = Instance.new('TextLabel')
			RainbowLabel.Name = 'Label'
			RainbowLabel.BackgroundTransparency = 1
			RainbowLabel.Position = UDim2.fromOffset(5, 0)
			RainbowLabel.Size = UDim2.new(1, -60, 1, 0)
			RainbowLabel.FontFace = GetFont('Regular')
			RainbowLabel.TextSize = 24
			RainbowLabel.TextColor3 = GetColor('Text/Primary')
			RainbowLabel.Text = 'Rainbow'
			RainbowLabel.TextXAlignment = Enum.TextXAlignment.Left
			RainbowLabel.ZIndex = 2
			RainbowLabel.Parent = RainbowRow
			ListenObject(RainbowLabel, 'Text/Primary')
			ListenFont(RainbowLabel, 'Regular')

			const RainbowSwitch = Instance.new('TextButton')
			RainbowSwitch.Name = 'Switch'
			RainbowSwitch.AnchorPoint = Vector2.new(1, 0.5)
			RainbowSwitch.Position = UDim2.new(1, -5, 0.5, 0)
			RainbowSwitch.Size = UDim2.fromOffset(44, 22)
			RainbowSwitch.BackgroundColor3 = GetColor('Background/Button')
			RainbowSwitch.BorderSizePixel = 0
			RainbowSwitch.Text = ''
			RainbowSwitch.AutoButtonColor = false
			RainbowSwitch.ZIndex = 2
			RainbowSwitch.Parent = RainbowRow
			AddCorner(RainbowSwitch, UDim.new(1, 0))

			const RainbowKnob = Instance.new('Frame')
			RainbowKnob.Name = 'Knob'
			RainbowKnob.AnchorPoint = Vector2.new(0, 0.5)
			RainbowKnob.Position = UDim2.new(0, 3, 0.5, 0)
			RainbowKnob.Size = UDim2.fromOffset(16, 16)
			RainbowKnob.BackgroundColor3 = GetColor('Main/DisabledBar')
			RainbowKnob.BorderSizePixel = 0
			RainbowKnob.ZIndex = 2
			RainbowKnob.Parent = RainbowSwitch
			AddCorner(RainbowKnob, UDim.new(1, 0))
			ListenObject(RainbowKnob, 'Main/DisabledBar', 'Main/EnabledBar', function()
				RainbowKnob.BackgroundColor3 = ColorPicker.Rainbow and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
			end)

			RainbowSwitch.MouseButton1Click:Connect(function()
				ColorPicker:SetRainbow(not ColorPicker.Rainbow, true)
			end)

			const function OpenColorPickerMenu()
				if MenuOptions.Object.Visible then
					MenuOptions.Object.Visible = false
					ColorPickerHidMenuOptions = true
				else
					ColorPickerHidMenuOptions = false
					for i, v in TidalWave.Menus do
						if v.Object.Visible then
							v.Object.Visible = false
							PrevMenu = i
							break
						end
					end
				end
				CurrentColorPicker = PickerMenu
				PickerMenu.Visible = true
			end

			const function CloseColorPickerMenu()
				if ColorPickerHidMenuOptions then
					ColorPickerHidMenuOptions = false
					MenuOptions.Object.Visible = true
				else
					for i, v in TidalWave.Menus do
						if i == PrevMenu then
							v:Show()
							break
						end
					end
				end

				CurrentColorPicker = nil
				PickerMenu.Visible = false
			end

			const ColorBackground = Instance.new('ImageButton')
			ColorBackground.Name = 'ColorBackground'
			ColorBackground.BackgroundTransparency = 1
			ColorBackground.Position = UDim2.fromOffset(10, 50)
			ColorBackground.Size = UDim2.fromOffset(300, 180)
			ColorBackground.ZIndex = 2
			ColorBackground.Image = 'rbxassetid://1072518406'
			ColorBackground.ClipsDescendants = true
			ColorBackground.Parent = ColorPickerDropdown

			const ColorBackgroundDragDetector = Instance.new('UIDragDetector')
			ColorBackgroundDragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			ColorBackgroundDragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			ColorBackgroundDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
			ColorBackgroundDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
			ColorBackgroundDragDetector.Parent = ColorBackground

			const Plus = Instance.new('Frame')
			Plus.Name = 'Plus'
			Plus.BackgroundTransparency = 1
			Plus.AnchorPoint = Vector2.new(0.5, 0.5)
			Plus.Size = UDim2.fromOffset(24, 24)
			Plus.ZIndex = 2
			Plus.Parent = ColorBackground

			const PlusHorizontal = Instance.new('Frame')
			PlusHorizontal.Name = 'Horizontal'
			PlusHorizontal.BackgroundColor3 = Color3.Black
			PlusHorizontal.BorderSizePixel = 0
			PlusHorizontal.Size = UDim2.fromOffset(24, 2)
			PlusHorizontal.Position = UDim2.fromOffset(0, 11)
			PlusHorizontal.ZIndex = 2
			PlusHorizontal.Parent = Plus

			const PlusVertical = Instance.fromExisting(PlusHorizontal)
			PlusVertical.Name = 'Vertical'
			PlusVertical.Size = UDim2.fromOffset(2, 24)
			PlusVertical.Position = UDim2.fromOffset(11, 0)
			PlusVertical.Parent = Plus

			const ColorStrip = Instance.new('ImageButton')
			ColorStrip.Name = 'ColorStrip'
			ColorStrip.BackgroundTransparency = 1
			ColorStrip.Position = UDim2.fromOffset(325, 50)
			ColorStrip.Size = UDim2.fromOffset(12, 180)
			ColorStrip.ZIndex = 2
			ColorStrip.Image = 'rbxassetid://1072518502'
			ColorStrip.Parent = ColorPickerDropdown

			local ColorStripDragDetector = Instance.new('UIDragDetector')
			ColorStripDragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			ColorStripDragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			ColorStripDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
			ColorStripDragDetector.DragAxis = Vector2.new(0, 1)
			ColorStripDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
			ColorStripDragDetector.Parent = ColorStrip

			const Arrow = Instance.new('ImageLabel')
			Arrow.Name = 'Arrow'
			Arrow.BackgroundTransparency = 1
			Arrow.Size = UDim2.fromOffset(24, 24)
			Arrow.Position = UDim2.fromScale(1, 0)
			Arrow.AnchorPoint = Vector2.new(0, 0.5)
			Arrow.ZIndex = 2
			SetIcon(Arrow, 'chevron-left')
			Arrow.Parent = ColorStrip
			ListenObject(Arrow, 'Main/Icons')

			const Holder = Instance.new('Frame')
			Holder.Name = 'Holder'
			Holder.BackgroundTransparency = 1
			Holder.Size = UDim2.fromOffset(328, 160)
			Holder.Position = UDim2.fromOffset(10, 240)
			Holder.ZIndex = 2
			Holder.Parent = ColorPickerDropdown

			const Layout = Instance.new('UIListLayout')
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.VerticalAlignment = Enum.VerticalAlignment.Top
			Layout.Padding = UDim.new(0, 10)
			Layout.Parent = Holder

			const function FireCallback()
				if Properties.Function then
					Properties.Function(ColorPicker.Color, ColorPicker.Transparency)
				end
			end

			const function RefreshSwatch()
				RGBInput.Text = `{math.floor(ColorPicker.R)}, {math.floor(ColorPicker.G)}, {math.floor(ColorPicker.B)}`
				ColorStrip.ImageColor3 = Color3.fromHSV(Hue, Sat, 1)
				ColorDisplay.BackgroundColor3 = ColorPicker.Color
				ColorDisplay.BackgroundTransparency = ColorPicker.Transparency
				MenuColorDisplay.BackgroundColor3 = ColorPicker.Color
				MenuColorDisplay.BackgroundTransparency = ColorPicker.Transparency
			end

			const function RefreshHandles()
				local Scale = GuiScale.Scale
				local BackgroundMax = ColorBackground.AbsoluteSize / Scale
				Plus.Position = UDim2.fromOffset(
					math.clamp(BackgroundMax.X - (BackgroundMax.X * Hue), 0, BackgroundMax.X),
					math.clamp(BackgroundMax.Y - (BackgroundMax.Y * Sat), 0, BackgroundMax.Y)
				)

				local StripMax = ColorStrip.AbsoluteSize.Y / Scale
				Arrow.Position = UDim2.new(1, 0, 0, math.clamp(StripMax - (StripMax * Val), 0, StripMax))
			end

			const function SyncHSV()
				if HoldHSV then return end
				local H, S, V = ColorPicker.Color:ToHSV()
				if V > 0 then
					Sat = S
					if S > 0 then
						Hue = H
					end
				end
				Val = V
			end

			const function ApplyColor(SuppressCallback, SuppressHandles)
				ColorPicker.Color = Color3.fromRGB(ColorPicker.R, ColorPicker.G, ColorPicker.B)
				SyncHSV()
				RefreshSwatch()
				if not SuppressHandles then
					RefreshHandles()
				end
				if not SuppressCallback then
					FireCallback()
				end
			end

			const function CreateSlider(SliderProperties)
				const Max = SliderProperties.Max
				const InputDecimal = SliderProperties.InputDecimal
				const SliderDecimal = SliderProperties.SliderDecimal

				local Picker = Instance.new('Frame')
				Picker.Name = `{SliderProperties.Name}Picker`
				Picker.BackgroundTransparency = 1
				Picker.Size = UDim2.new(1, 0, 0, 30)
				Picker.ZIndex = 2
				Picker.Parent = Holder

				local Label = Instance.new('TextLabel')
				Label.Name = 'Label'
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(0, 20, 1, 0)
				Label.Position = UDim2.fromOffset(5, 0)
				Label.FontFace = GetFont('Regular')
				Label.TextSize = 24
				Label.TextColor3 = GetColor('Text/Primary')
				Label.Text = SliderProperties.Text
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.ZIndex = 2
				Label.Parent = Picker
				ListenObject(Label, 'Text/Primary')
				ListenFont(Label, 'Regular')

				local Input = Instance.new('TextBox')
				Input.Name = 'Input'
				Input.BackgroundColor3 = GetColor('Background/Button')
				Input.BorderSizePixel = 0
				Input.ClearTextOnFocus = false
				Input.Position = UDim2.fromOffset(30, 0)
				Input.Size = UDim2.new(0, 80, 1, 0)
				Input.FontFace = GetFont('Regular')
				Input.TextSize = 24
				Input.TextColor3 = GetColor('Text/Primary')
				Input.ZIndex = 2
				Input.Parent = Picker
				AddCorner(Input, UDim.new(0, 7))
				ListenObject(Input, 'Background/Button', 'Text/Primary')
				ListenFont(Input, 'Regular')

				local SliderFrame = Instance.new('ImageButton')
				SliderFrame.Name = 'SliderFrame'
				SliderFrame.BackgroundTransparency = 1
				SliderFrame.ImageTransparency = 1
				SliderFrame.Position = UDim2.fromOffset(120, 5)
				SliderFrame.Size = UDim2.fromOffset(200, 20)
				SliderFrame.ZIndex = 2
				SliderFrame.Parent = Picker

				local FrameDragDetector = Instance.new('UIDragDetector')
				FrameDragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
				FrameDragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
				FrameDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
				FrameDragDetector.DragAxis = Vector2.new(1, 0)
				FrameDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
				FrameDragDetector.Parent = SliderFrame

				local RightBar = Instance.new('Frame')
				RightBar.Name = 'RightBar'
				RightBar.BackgroundColor3 = GetColor('Slider/RightBar')
				RightBar.ZIndex = 2
				RightBar.BorderSizePixel = 0
				ListenObject(RightBar, 'Slider/RightBar')

				local LeftBar = Instance.new('Frame')
				LeftBar.Name = 'LeftBar'
				LeftBar.BackgroundColor3 = GetColor('Slider/LeftBar')
				LeftBar.BorderSizePixel = 0
				LeftBar.ZIndex = 2
				LeftBar.Position = UDim2.fromOffset(0, 9)
				ListenObject(LeftBar, 'Slider/LeftBar')

				local Handle = Instance.new('TextButton')
				Handle.Name = 'Handle'
				Handle.BackgroundColor3 = GetColor('Slider/Handle')
				Handle.BorderSizePixel = 0
				Handle.Size = UDim2.fromOffset(15, 15)
				Handle.AnchorPoint = Vector2.new(0.5, 0)
				Handle.AutoButtonColor = false
				Handle.ZIndex = 2
				Handle.Text = ''
				AddCorner(Handle, UDim.new(1, 0))
				ListenObject(Handle, 'Slider/Handle')

				const function PositionToValue(RawX, Decimal)
					local TrackWidth = SliderFrame.Size.X.Offset
					local Pos = math.clamp(RawX, 0, TrackWidth)
					local Scale = TrackWidth > 0 and (Pos / TrackWidth) or 0
					return Pos, math.round((Scale * Max) * Decimal) / Decimal
				end

				const function ValueToPosition(Value, Decimal)
					local TrackWidth = SliderFrame.Size.X.Offset
					return PositionToValue((Value / Max) * TrackWidth, Decimal)
				end

				const function SetVisuals(Pos, Value)
					Handle.Position = UDim2.new(0, Pos, 0, -7)
					LeftBar.Size = UDim2.fromOffset(Pos, 3)
					RightBar.Size = UDim2.fromOffset(SliderFrame.Size.X.Offset - Pos, 3)
					RightBar.Position = UDim2.fromOffset(Pos, 9)
					Input.Text = tostring(Value)
					ColorPicker[SliderProperties.Ref] = Value
				end

				const function OnFrameDragged(Source)
					local RawX = Source == 'Slider' and Handle.Position.X.Offset or (UIS:GetMouseLocation().X - SliderFrame.AbsolutePosition.X) / GuiScale.Scale
					local Pos, Value = PositionToValue(RawX, SliderDecimal)
					SetVisuals(Pos, Value)
					ApplyColor()
				end

				const function Set(Value, SuppressCallback, SuppressHandles)
					local Number = tonumber(Value)
					if Number then
						local Pos, RoundedValue = ValueToPosition(Number, InputDecimal)
						SetVisuals(Pos, RoundedValue)
						ApplyColor(SuppressCallback, SuppressHandles)
					end
					Input.Text = tostring(ColorPicker[SliderProperties.Ref])
				end

				local StartPos, StartValue = ValueToPosition(ColorPicker[SliderProperties.Ref], InputDecimal)
				SetVisuals(StartPos, StartValue)

				RightBar.Parent = SliderFrame
				LeftBar.Parent = SliderFrame
				Handle.Parent = LeftBar

				local HandleDragDetector = Instance.new('UIDragDetector')
				HandleDragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
				HandleDragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
				HandleDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine
				HandleDragDetector.DragAxis = Vector2.new(1, 0)
				HandleDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
				HandleDragDetector.Parent = Handle

				FrameDragDetector.DragStart:Connect(OnFrameDragged)
				FrameDragDetector.DragContinue:Connect(OnFrameDragged)
				HandleDragDetector.DragContinue:Connect(function()
					OnFrameDragged('Slider')
				end)

				Input.FocusLost:Connect(function()
					Set(Input.Text)
				end)

				const HoverTween = TweenInfo.new(0.2)
				const PressTween = TweenInfo.new(0.1)

				Handle.MouseEnter:Connect(function()
					TweenService:Create(Handle, HoverTween, {BackgroundColor3 = GetColor('Slider/HandleHover')}):Play()
				end)
				Handle.MouseLeave:Connect(function()
					TweenService:Create(Handle, HoverTween, {BackgroundColor3 = GetColor('Slider/Handle')}):Play()
				end)
				Handle.MouseButton1Down:Connect(function()
					TweenService:Create(Handle, PressTween, {BackgroundColor3 = GetColor('Slider/HandlePress')}):Play()
				end)
				Handle.MouseButton1Up:Connect(function()
					TweenService:Create(Handle, PressTween, {BackgroundColor3 = GetColor('Slider/HandleHover')}):Play()
				end)

				const Tab = {}
				Tab.Object = Picker
				function Tab:Set(Value, SuppressCallback, SuppressHandles)
					Set(Value, SuppressCallback, SuppressHandles)
				end

				return Tab
			end

			const RedSlider = CreateSlider({
				Name = 'Red',
				Text = 'R:',
				Ref = 'R',
				Max = 255,
				SliderDecimal = 1,
				InputDecimal = 1,
			})

			const GreenSlider = CreateSlider({
				Name = 'Green',
				Text = 'G:',
				Ref = 'G',
				Max = 255,
				SliderDecimal = 1,
				InputDecimal = 1,
			})

			const BlueSlider = CreateSlider({
				Name = 'Blue',
				Text = 'B:',
				Ref = 'B',
				Max = 255,
				SliderDecimal = 1,
				InputDecimal = 1,
			})

			const TransparencySlider = CreateSlider({
				Name = 'Transparency',
				Text = 'T:',
				Ref = 'Transparency',
				Max = 1,
				SliderDecimal = 100,
				InputDecimal = 100,
			})

			const function SetTransparencyValue(Value, SuppressCallback, SuppressHandles)
				if ColorPicker.UseTransparency then
					TransparencySlider:Set(Value, SuppressCallback, SuppressHandles)
				else
					ColorPicker.Transparency = Value
					ApplyColor(SuppressCallback, SuppressHandles)
				end
			end

			const function UpdateLayout()
				const SlidersHeight = ColorPicker.UseTransparency and 150 or 110
				TransparencySlider.Object.Visible = ColorPicker.UseTransparency
				Holder.Size = UDim2.fromOffset(328, SlidersHeight)
				RainbowRow.Position = UDim2.fromOffset(10, 240 + SlidersHeight + 10)
				const BodyHeight = 240 + SlidersHeight + 10 + 30 + 10
				ColorPickerDropdown.Size = UDim2.new(1, 0, 0, BodyHeight)
				PickerMenu.Position = UDim2.new(0.5, -370 / 2, 0.5, -(BodyHeight + 32) / 2)
			end

			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					RedSlider:Set(DefaultR, true, true)
					GreenSlider:Set(DefaultG, true, true)
					BlueSlider:Set(DefaultB, true, true)
					SetTransparencyValue(DefaultTransparency)

					if ColorPicker.Rainbow ~= DefaultRainbow then
						ColorPicker:SetRainbow(DefaultRainbow)
					end
				end
			})

			const function PushHSV()
				const Color = Color3.fromHSV(Hue, Sat, Val)
				HoldHSV = true
				RedSlider:Set(math.round(Color.R * 255), true, true)
				GreenSlider:Set(math.round(Color.G * 255), true, true)
				BlueSlider:Set(math.round(Color.B * 255), true, true)
				ApplyColor(false, true)
				HoldHSV = false
			end

			const function OnColorAreaDragged()
				const Scale = GuiScale.Scale
				const X = math.clamp((Mouse.X - ColorBackground.AbsolutePosition.X) / Scale, 0, ColorBackground.Size.X.Offset)
				const Y = math.clamp((Mouse.Y - ColorBackground.AbsolutePosition.Y) / Scale, 0, ColorBackground.Size.Y.Offset)
				Plus.Position = UDim2.fromOffset(X, Y)

				Hue = 1 - (X / ColorBackground.Size.X.Offset)
				Sat = 1 - (Y / ColorBackground.Size.Y.Offset)

				PushHSV()
			end

			const function OnColorStripDragged()
				const Scale = GuiScale.Scale
				const Y = math.clamp((Mouse.Y - ColorStrip.AbsolutePosition.Y) / Scale, 0, ColorStrip.Size.Y.Offset)
				Arrow.Position = UDim2.new(1, 0, 0, Y)

				Val = 1 - (Y / ColorStrip.Size.Y.Offset)

				PushHSV()
			end

			UpdateLayout()
			RefreshSwatch()
			RefreshHandles()

			OpenMenuButton.MouseButton1Click:Connect(function()
				OpenColorPickerMenu()
				RefreshHandles()
			end)

			PickerClose.MouseButton1Click:Connect(function()
				CloseColorPickerMenu()
			end)

			ColorBackgroundDragDetector.DragStart:Connect(OnColorAreaDragged)
			ColorBackgroundDragDetector.DragContinue:Connect(OnColorAreaDragged)
			ColorStripDragDetector.DragStart:Connect(OnColorStripDragged)
			ColorStripDragDetector.DragContinue:Connect(OnColorStripDragged)

			RGBInput.FocusLost:Connect(function()
				const Match = RGBInput.Text:gmatch('%d+%.?%d*')
				const Numbers = {Match(), Match(), Match(), Match()}
				if #Numbers == 0 then
					RedSlider:Set(ColorPicker.R, true, true)
					GreenSlider:Set(ColorPicker.G, true, true)
					BlueSlider:Set(ColorPicker.B, false, false)
				else
					const R = tonumber(Numbers[1])
					const G = tonumber(Numbers[2]) or R
					const B = tonumber(Numbers[3]) or R
					const Transparency = tonumber(Numbers[4]) or ColorPicker.Transparency
					RedSlider:Set(R, true, true)
					GreenSlider:Set(G, true, true)
					BlueSlider:Set(B, true, true)
					TransparencySlider:Set(Transparency, false, false)
				end
			end)

			function ColorPicker:Save(Tab)
				Tab[SubbedName] = {
					R = math.floor(self.R),
					G = math.floor(self.G),
					B = math.floor(self.B),
					Transparency = math.floor(self.Transparency * 100) / 100,
					Rainbow = self.Rainbow
				}
			end

			function ColorPicker:Load(Tab)
				local R, G, B, Transparency = Tab.R, Tab.G, Tab.B, Tab.Transparency
				if R and G and B then
					RedSlider:Set(R, true, true)
					GreenSlider:Set(G, true, true)
					BlueSlider:Set(B, Transparency ~= nil, Transparency ~= nil)
				end
				if Transparency then
					SetTransparencyValue(Transparency)
				end
				
				self:SetRainbow(Tab.Rainbow, false)
			end

			function ColorPicker:SetVisible(Visible)
				self.Visible = Visible
				Frame.Visible = self.Visible
			end

			function ColorPicker:OpenMenu()
				OpenColorPickerMenu()
				RefreshHandles()
			end

			function ColorPicker:CloseMenu()
				CloseColorPickerMenu()
			end

			function ColorPicker:SetUseTransparency(Use)
				self.UseTransparency = Use
				UpdateLayout()
				ApplyColor(false, true)
			end

			function ColorPicker:SetColor(Color, Transparency)
				RedSlider:Set(Color.R * 255, true, true)
				GreenSlider:Set(Color.G * 255, true, true)
				BlueSlider:Set(Color.B * 255, Transparency ~= nil, Transparency ~= nil)
				if Transparency then
					SetTransparencyValue(Transparency)
				end
			end

			function ColorPicker:SetTransparency(Transparency)
				SetTransparencyValue(Transparency)
			end

			const Info = TweenInfo.new(0.15)

			function ColorPicker:SetRainbow(Enabled, Animate)
				self.Rainbow = Enabled
				
				const KnobColor = self.Rainbow and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				const KnobPosition = UDim2.new(0, self.Rainbow and 25 or 3, 0.5, 0)
				if Animate then
					TweenService:Create(RainbowKnob, Info, {Position = KnobPosition, BackgroundColor3 = KnobColor}):Play()
				else
					RainbowKnob.BackgroundColor3 = KnobColor
					RainbowKnob.Position = KnobPosition
				end

				if Enabled then
					TidalWave:AddRGB(self)
				else
					TidalWave:RemoveRGB(self)
				end
			end

			ColorPicker.Object = Frame
			ColorPicker.Menu = PickerMenu
			Properties.Module.Options[SubbedName] = ColorPicker

			if ColorPicker.Rainbow then
				ColorPicker:SetRainbow(true, false)
			end

			return ColorPicker
		end,
		Delete = function(Properties)
			local Delete = Instance.new('TextButton')
			Delete.Name = 'Delete'
			Delete.BackgroundColor3 = GetColor('Background/Button')
			Delete.Text = ''
			Delete.BorderSizePixel = 0
			Delete.Size = UDim2.fromOffset(40, 40)
			Delete.Position = UDim2.new(1, -40, 0, 0)
			Delete.AutoButtonColor = false
			Delete.Parent = Properties.Parent
			AddCorner(Delete, UDim.new(0, 7))
			AddHighlight(Delete)
			ListenObject(Delete, 'Background/Button')
			
			local Image = Instance.new('ImageLabel')
			Image.Name = 'Image'
			Image.BackgroundTransparency = 1
			Image.Size = UDim2.fromOffset(24, 24)
			Image.Position = UDim2.fromOffset(8, 8)
			SetIcon(Image, 'x')
			Image.Parent = Delete
			ListenObject(Image, 'Main/Icons')

			if Properties.Function then
				Delete.MouseButton1Click:Connect(Properties.Function)
			end
			
			return Delete
		end,
		Dropdown = function(Properties)
			const List = Properties.List or {}
			const DefaultValue = List[1] or 'None'
			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			const Function = Properties.Function
			const Module = Properties.Module
			const RequiresRestart = Properties.Restart

			local Dropdown = {
				Value = DefaultValue,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true,
				Expanded = false
			}
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{SubbedName}Dropdown`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.fromOffset(5, 0)
			TextLabel.Size = UDim2.new(0, 200, 1, 0)
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextSize = 24
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Text = Name
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')
			
			local TopBar = Instance.new('TextButton')
			TopBar.BackgroundColor3 = GetColor('Background/Secondary')
			TopBar.Name = 'TopBar'
			TopBar.BorderSizePixel = 0
			TopBar.Size = UDim2.fromOffset(240, 30)
			TopBar.Position = UDim2.fromOffset(310, 5)
			TopBar.AutoButtonColor = false
			TopBar.Text = ''
			TopBar.Parent = Background
			AddTooltip(TopBar, Properties.Tooltip or Properties.Info)
			ListenObject(TopBar, 'Background/Secondary', 'Text/Primary')
			ListenFont(TopBar, 'Regular')
			
			local Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, 7)
			Corner.Parent = TopBar

			local TopBarLabel = Instance.new('TextLabel')
			TopBarLabel.BackgroundTransparency = 1
			TopBarLabel.Name = 'TopBarLabel'
			TopBarLabel.Size = UDim2.fromScale(1, 1)
			TopBarLabel.Position = UDim2.fromOffset(10, 0)
			TopBarLabel.FontFace = GetFont('Regular')
			TopBarLabel.TextColor3 = GetColor('Text/Primary')
			TopBarLabel.TextSize = 24
			TopBarLabel.TextXAlignment = Enum.TextXAlignment.Left
			TopBarLabel.Text = Dropdown.Value
			TopBarLabel.Parent = TopBar
			
			local Arrow = Instance.new('TextButton')
			Arrow.Name = 'Arrow'
			Arrow.Size = UDim2.fromOffset(30, 30)
			Arrow.Position = UDim2.new(1, -30, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = ''
			Arrow.Rotation = -90
			Arrow.Parent = TopBar
			AddCorner(Arrow, UDim.new(0, 7))
			
			local ArrowImage = Instance.new('ImageLabel')
			ArrowImage.Name = 'Image'
			ArrowImage.Size = UDim2.fromOffset(30, 30)
			ArrowImage.BackgroundTransparency = 1
			SetIcon(ArrowImage, 'chevron-down')
			ArrowImage.Parent = Arrow
			
			local Children = Instance.new('ScrollingFrame')
			Children.Name = 'Children'
			Children.Size = UDim2.fromScale(1, 0)
			Children.Position = UDim2.fromScale(0, 1)
			Children.BackgroundColor3 = GetColor('Background/Secondary')
			Children.CanvasSize = UDim2.zero
			Children.ScrollBarThickness = 0
			Children.ScrollBarImageTransparency = 1
			Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			Children.Active = true
			Children.ZIndex = 2
			Children.Visible = false
			Children.Parent = TopBar
			ListenObject(Children, 'Background/Secondary')
			
			local ChildrenCorner = Instance.new('UICorner')
			ChildrenCorner.CornerRadius = UDim.new(0, 0)
			ChildrenCorner.BottomLeftRadius = UDim.new(0, 7)
			ChildrenCorner.BottomRightRadius = UDim.new(0, 7)
			ChildrenCorner.Parent = Children
			
			local Padding = Instance.new('UIPadding')
			Padding.PaddingTop = UDim.new(0, 10)
			Padding.PaddingBottom = UDim.new(0, 10)
			Padding.Parent = Children
			
			local Layout = Instance.new('UIListLayout')
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.Padding = UDim.new(0, 5)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = Children

			const function GetChildrenHeight()
				return math.min((Layout.AbsoluteContentSize.Y / GuiScale.Scale) + 16, 220)
			end
			
			const function GetContentHeight()
				return (Layout.AbsoluteContentSize.Y / GuiScale.Scale) + 16
			end
			
			Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Children.CanvasSize = UDim2.new(1, 0, 0, GetContentHeight())
			end)
			
			local Tween, ArrowTween

			const Info = TweenInfo.new(0.2)
			const CreatedButtons = {}
			const BindedOptions = {Whitelist = {}, Blacklist = {}}
			for _, Val in List do
				BindedOptions.Whitelist[Val] = {}
				BindedOptions.Blacklist[Val] = {}
			end

			const function ProcessWhitelist(Val)
				if typeof(Val) == 'string' then
					return Dropdown.Value == Val
				elseif typeof(Val) == 'table' then
					for _, Item in Val do
						if Dropdown.Value == Item then
							return true
						end
					end

					return false
				end
				return nil
			end

			const function ProcessBlacklist(Val)
				if typeof(Val) == 'string' then
					return Dropdown.Value ~= Val
				elseif typeof(Val) == 'table' then
					for _, Item in Val do
						if Dropdown.Value ~= Item then
							return true
						end
					end

					return false
				end
				return nil
			end

			const function CreateTemplate(Name, Order)
				const Button = Instance.new('TextButton')
				Button.Size = UDim2.fromOffset(225, 30)
				Button.BackgroundColor3 = GetColor('Background/Button')
				Button.TextColor3 = GetColor('Text/Primary')
				Button.FontFace = GetFont('Regular')
				Button.TextSize = 20
				Button.Text = Name
				Button.LayoutOrder = Order or 0
				Button.ZIndex = 2
				Button.BorderSizePixel = 0
				Button.AutoButtonColor = false
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = Children
				AddCorner(Button, UDim.new(0, 7))
				AddHighlight(Button)
				ListenObject(Button, 'Background/Button', 'Text/Primary')
				ListenFont(Button, 'Regular')

				const Padding = Instance.new('UIPadding')
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.Parent = Button

				Button.MouseButton1Click:Connect(function()
					Dropdown:SetValue(Name)
				end)

				table.insert(CreatedButtons, Button)
			end
			
			function Dropdown:SetValue(Val)
				if not table.find(List, Val) then
					Val = DefaultValue
				end

				if self.Value ~= Val then
					self.Value = Val
					TopBarLabel.Text = Val

					const AlreadySet = {}

					for _, Item in BindedOptions.Whitelist do
						for _, Option in Item do
							if AlreadySet[Option] then continue end
							if Val == Item then
								AlreadySet[Option] = true
							end
							Option:SetVisible(Val == Item)
						end
					end

					for _, Item in BindedOptions.Blacklist do
						for _, Option in Item do
							if AlreadySet[Option] then continue end
							if Val ~= Item then
								AlreadySet[Option] = true
							end
							Option:SetVisible(Val ~= Item)
						end
					end

					if Function then
						Function(Val)
					end

					if Module.Enabled and Module.ExtraText then
						TextGUI:UpdateExtraText()
					end

					if RequiresRestart then
						Module:Restart()
					end
				end
			end

			function Dropdown:CreateButton(ButtonProperties)
				const Name = ButtonProperties.Name

				if not table.find(List, Name) then
					table.insert(List, Name)
				end
				
				if #CreatedButtons ~= 0 then
					CreateTemplate(Name, #List)
				end
			end
			
			function Dropdown:Expand()
				self.Expanded = not self.Expanded

				if Tween then
					Tween:Cancel()
				end
				if ArrowTween then
					ArrowTween:Cancel()
				end
				
				ArrowTween = TweenService:Create(Arrow, Info, {Rotation = self.Expanded and 0 or -90})

				if self.Expanded then
					if #CreatedButtons == 0 then
						for i, Name in List do
							CreateTemplate(Name, i)
						end
					end

					Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, GetChildrenHeight())})
					Children.Visible = true
					Corner.CornerRadius = UDim.new(0, 0)
					Corner.TopLeftRadius = UDim.new(0, 7)
					Corner.TopRightRadius = UDim.new(0, 7)
				else
					Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, 0)})
					Tween.Completed:Once(function(State)
						if State == Enum.PlaybackState.Completed then
							Children.Visible = false
							Corner.CornerRadius = UDim.new(0, 7)
							for _, Button in CreatedButtons do
								StopListeningObject(Button)
								StopListeningFont(Button)
								Button:Destroy()
							end
							table.clear(CreatedButtons)
						end
					end)
				end

				Tween:Play()
				ArrowTween:Play()
			end
			
			function Dropdown:Save(Tab)
				Tab[SubbedName] = {
					Value = self.Value
				}
			end
			
			function Dropdown:Load(Tab)
				if Dropdown.Value ~= Tab.Value then
					Dropdown:SetValue(Tab.Value)
				end
			end
			
			function Dropdown:SetVisible(Visible)
				Dropdown.Visible = Visible
				Frame.Visible = Dropdown.Visible
			end

			for i, v in Components.Options do
				Dropdown[`Bind{i}To`] = function(_, Val, Props)
					Props.Parent = Properties.Parent
					Props.LayoutOrder = table.len(Properties.Module.Options) + table.len(Properties.Module.Keybinds)
					Props.Visible = ProcessWhitelist(Val)
					Props.Module = Properties.Module

					const Component = v(Props)
					const SubbedName = Props.Name:gsub(' ', '')

					if typeof(Val) == 'table' then
						for _, Item in Val do
							BindedOptions.Whitelist[Val][SubbedName] = Component
						end
					elseif typeof(Val) == 'string' then
						BindedOptions.Whitelist[Val][SubbedName] = Component
					end
			
					return Component
				end

				Dropdown[`Bind{i}ToAllExcept`] = function(_, Val, Props)
					Props.Parent = Properties.Parent
					Props.LayoutOrder = table.len(Properties.Module.Options) + table.len(Properties.Module.Keybinds)
					Props.Visible = ProcessBlacklist(Val)
					Props.Module = Properties.Module

					const Component = v(Props)
					const SubbedName = Props.Name:gsub(' ', '')

					if typeof(Val) == 'table' then
						for _, Item in Val do
							BindedOptions.Blacklist[Val][SubbedName] = Component
						end
					elseif typeof(Val) == 'string' then
						BindedOptions.Blacklist[Val][SubbedName] = Component
					end
			
					return Component
				end
			end

			const function MouseEnter()
				if Children.AbsoluteCanvasSize.Y > Children.AbsoluteSize.Y then
					Frame.Parent.ScrollingEnabled = false
				end
			end

			const function MouseLeave()
				Frame.Parent.ScrollingEnabled = true
			end

			const function Expand()
				Dropdown:Expand()
			end
			
			Children.MouseEnter:Connect(MouseEnter)
			Children.MouseLeave:Connect(MouseLeave)
			Arrow.MouseButton1Click:Connect(Expand)
			Arrow.MouseButton2Click:Connect(Expand)
			TopBar.MouseButton1Click:Connect(Expand)
			TopBar.MouseButton2Click:Connect(Expand)
			
			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					Dropdown:SetValue(DefaultValue)
				end
			})
			
			Dropdown.Object = Frame
			Properties.Module.Options[SubbedName] = Dropdown
			
			return Dropdown
		end,
		Font = function(Properties)
			const DefaultFont = Properties.Default or Properties.Blacklist or 'Montserrat'
			const DefaultFamily = DefaultFont:find('rbxasset') and DefaultFont or Font.fromName(DefaultFont).Family
			const DefaultWeight = Properties.DefaultWeight or Properties.Weight or 'Regular'
			
			const Fonts = {
				'AccanthisADFStd',
				'AmaticSC',
				'Arial',
				'Arimo',
				'Balthazar',
				'Bangers',
				'BuilderExtended',
				'BuilderMono',
				'BuilderSans',
				'ComicNeueAngular',
				'Creepster',
				'DenkOne',
				'Fondamento',
				'FredokaOne',
				'GrenzeGotisch',
				'Guru',
				'HighwayGothic',
				'Inconsolata',
				'IndieFlower',
				'JosefinSans',
				'Jura',
				'Kalam',
				'LegacyArial',
				'LegacyArimo',
				'LuckiestGuy',
				'Merriweather',
				'Michroma',
				'Montserrat',
				'NotoSansCJKFallback',
				'Nunito',
				'Oswald',
				'PatrickHand',
				'PermanentMarker',
				'PressStart2P',
				'Roboto',
				'RobotoCondensed',
				'RobotoMono',
				'RomanAntique',
				'Sarpanch',
				'SourceSansPro',
				'SpecialElite',
				'TitilliumWeb',
				'Ubuntu',
				'Zekton',
			}
			
			const Weights = {
				'Thin',
				'ExtraLight',
				'Light',
				'Regular',
				'Medium',
				'SemiBold',
				'Bold',
				'ExtraBold',
				'Heavy'
			}
			
			const Index = table.find(Fonts, DefaultFont)
			if Index then
				table.remove(Fonts, Index)
				table.insert(Fonts, 1, DefaultFont)
			end
			
			local function GetFontName(Font)
				if Font.Family:match('rbxasset://') then
					return Font.Family:match('(%w+)%.json$')
				elseif Font.Family:match('%d+') then
					local Success, Result = pcall(function()
						return MarketplaceService:GetProductInfoAsync(tonumber(Font.Family:match('%d+'))).Name
					end)
					
					if Success and Result then
						return Result
					end
				end
			
				return nil
			end
			
			local Dropdown = {
				Value = Font.new(DefaultFamily, Enum.FontWeight[DefaultWeight]),
				Weight = DefaultWeight,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{Name}FontDropdown`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.BackgroundTransparency = 1
			TextLabel.Size = UDim2.new(0, 200, 1, 0)
			TextLabel.Position = UDim2.fromOffset(5, 0)
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextSize = 24
			TextLabel.Text = Name
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')

			local function CreateDropdown(Properties)
				local TopBar = Instance.new('TextButton')
				TopBar.Name = 'TopBar'
				TopBar.BackgroundColor3 = GetColor('Background/Secondary')
				TopBar.BorderSizePixel = 0
				TopBar.Size = UDim2.fromOffset(Properties.Size, 30)
				TopBar.Position = UDim2.fromOffset(Properties.Position, 5)
				TopBar.AutoButtonColor = false
				TopBar.Text = ''
				TopBar.Parent = Background
				ListenObject(TopBar, 'Background/Secondary')
				
				local Corner = Instance.new('UICorner')
				Corner.CornerRadius = UDim.new(0, 7)
				Corner.Parent = TopBar
				
				local TopBarLabel = Instance.new('TextLabel')
				TopBarLabel.Size = UDim2.fromScale(1, 1)
				TopBarLabel.Position = UDim2.fromOffset(10, 0)
				TopBarLabel.BackgroundTransparency = 1
				TopBarLabel.BorderSizePixel = 0
				TopBarLabel.Text = Properties.Text
				TopBarLabel.TextSize = 24
				TopBarLabel.TextColor3 = GetColor('Text/Primary')
				TopBarLabel.FontFace = GetFont('Regular')
				TopBarLabel.TextXAlignment = Enum.TextXAlignment.Left
				TopBarLabel.Parent = TopBar
				ListenObject(TopBarLabel, 'Text/Primary')
				ListenFont(TopBarLabel, 'Regular')
				
				local Arrow = Instance.new('TextButton')
				Arrow.Name = 'Arrow'
				Arrow.Size = UDim2.fromOffset(30, 30)
				Arrow.Position = UDim2.new(1, -30, 0, 0)
				Arrow.BackgroundTransparency = 1
				Arrow.Text = ''
				Arrow.Rotation = -90
				Arrow.Parent = TopBar
				AddCorner(Arrow, UDim.new(0, 7))
				
				local ArrowImage = Instance.new('ImageLabel')
				ArrowImage.Name = 'Image'
				ArrowImage.Size = UDim2.fromOffset(30, 30)
				ArrowImage.Position = UDim2.zero
				ArrowImage.BackgroundTransparency = 1
				SetIcon(ArrowImage, 'chevron-down')
				ArrowImage.Parent = Arrow
				
				local Children = Instance.new('ScrollingFrame')
				Children.Name = 'Children'
				Children.Size = UDim2.fromScale(1, 0)
				Children.Position = UDim2.fromScale(0, 1)
				Children.BackgroundColor3 = GetColor('Background/Secondary')
				Children.CanvasSize = UDim2.zero
				Children.ScrollBarThickness = 0
				Children.ScrollBarImageTransparency = 1
				Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
				Children.Active = true
				Children.Visible = false
				Children.ZIndex = 2
				Children.Parent = TopBar
				ListenObject(Children, 'Background/Secondary')
				
				local ChildrenCorner = Instance.new('UICorner')
				ChildrenCorner.CornerRadius = UDim.new(0, 0)
				ChildrenCorner.BottomLeftRadius = UDim.new(0, 7)
				ChildrenCorner.BottomRightRadius = UDim.new(0, 7)
				ChildrenCorner.Parent = Children
				
				local Padding = Instance.new('UIPadding')
				Padding.PaddingTop = UDim.new(0, 10)
				Padding.PaddingBottom = UDim.new(0, 10)
				Padding.Parent = Children
				
				local Layout = Instance.new('UIListLayout')
				Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				Layout.Padding = UDim.new(0, 5)
				Layout.SortOrder = Enum.SortOrder.LayoutOrder
				Layout.Parent = Children

				local function GetHeight()
					return (Layout.AbsoluteContentSize.Y + 16) / GuiScale.Scale
				end

				Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())
				end)
				Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())

				local Expanded = false
				local Tween, ArrowTween
				local CreatedButtons = {}
				local Info = TweenInfo.new(0.2)
				local LastCanvasPosition = Vector2.zero

				local Tab = {
					Label = TopBarLabel
				}

				local function Expand()
					Expanded = not Expanded

					if Tween then
						Tween:Cancel()
					end
					if ArrowTween then
						ArrowTween:Cancel()
					end

					Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, Expanded and 240 or 0)})
					ArrowTween = TweenService:Create(Arrow, Info, {Rotation = Expanded and 0 or -90})

					if Expanded then
						if #CreatedButtons == 0 then
							for i, Name in Properties.Items do
								local Button = Instance.new('TextButton')
								Button.Size = UDim2.new(1, -16, 0, 30)
								Button.BackgroundColor3 = GetColor('Background/Button')
								Button.TextColor3 = GetColor('Text/Primary')
								Button.FontFace = GetFont('Regular')
								Button.TextSize = 20
								Button.Text = Name
								Button.LayoutOrder = i
								Button.ZIndex = 2
								Button.BorderSizePixel = 0
								Button.AutoButtonColor = false
								Button.TextXAlignment = Enum.TextXAlignment.Left
								Button.Parent = Children
								AddCorner(Button, UDim.new(0, 7))
								AddHighlight(Button)
								ListenObject(Button, 'Background/Button', 'Text/Primary')
								ListenFont(Button, 'Regular')

								local Padding = Instance.new('UIPadding')
								Padding.PaddingLeft = UDim.new(0, 10)
								Padding.Parent = Button
				
								Button.MouseButton1Click:Connect(function()
									Properties.Function(Name)
								end)
				
								table.insert(CreatedButtons, Button)
							end
						end
				
						Children.CanvasPosition = LastCanvasPosition
						Children.Visible = true
						Corner.CornerRadius = UDim.new(0, 0)
						Corner.TopLeftRadius = UDim.new(0, 7)
						Corner.TopRightRadius = UDim.new(0, 7)
						task.defer(function()
							Children.CanvasPosition = LastCanvasPosition
						end)
					else
						LastCanvasPosition = Children.CanvasPosition
						Tween.Completed:Once(function(State)
							if State == Enum.PlaybackState.Completed then
								Children.Visible = false
								Corner.CornerRadius = UDim.new(0, 7)
								for _, v in CreatedButtons do
									StopListeningObject(v)
									StopListeningFont(v)
									v:Destroy()
								end
								table.clear(CreatedButtons)
							end
						end)
					end

					Tween:Play()
					ArrowTween:Play()
				end

				local function MouseEnter()
					if Children.AbsoluteCanvasSize.Y > Children.AbsoluteSize.Y then
						Frame.Parent.ScrollingEnabled = false
					end
				end

				local function MouseLeave()
					Frame.Parent.ScrollingEnabled = true
				end

				Children.MouseEnter:Connect(MouseEnter)
				Children.MouseLeave:Connect(MouseLeave)
				Arrow.MouseButton1Click:Connect(Expand)
				Arrow.MouseButton2Click:Connect(Expand)
				TopBar.MouseButton1Click:Connect(Expand)
				TopBar.MouseButton2Click:Connect(Expand)

				return Tab
			end

			local FontDropdown, WeightDropdown
			
			function Dropdown:SetFont(Name, Weight)
				if Name:find('rbxasset') then
					self.Value = Font.new(Name, Enum.FontWeight[Weight or self.Weight])
				else
					self.Value = Font.fromName(Name, Enum.FontWeight[Weight or self.Weight])
				end
				
				if Weight then
					WeightDropdown.Label.Text = Weight
				end
				
				FontDropdown.Label.Text = GetFontName(self.Value)
				if Properties.Function then
					Properties.Function(self.Value)
				end
			end
			
			function Dropdown:SetWeight(Weight)
				self.Value = Font.new(self.Value.Family, Enum.FontWeight[Weight])
				self.Weight = Weight
			
				WeightDropdown.Label.Text = Weight
				if Properties.Function then
					Properties.Function(self.Value)
				end
			end
			
			function Dropdown:Save(Tab)
				Tab[SubbedName] = {
					Family = self.Value.Family,
					Weight = self.Value.Weight.Name
				}
			end
			
			function Dropdown:Load(Tab)
				if Dropdown.Value.Family ~= Tab.Family or Dropdown.Value.Weight.Name ~= Tab.Weight then
					Dropdown:SetFont(Tab.Family, Tab.Weight)
				end
			end
			
			function Dropdown:SetVisible(Visible)
				self.Visible = Visible
				Frame.Visible = self.Visible
			end

			FontDropdown = CreateDropdown({
				Text = GetFontName(Dropdown.Value),
				Items = Fonts,
				Position = 330,
				Size = 220,
				Function = function(Val)
					Dropdown:SetFont(Val)
				end
			})

			WeightDropdown = CreateDropdown({
				Text = DefaultWeight,
				Items = Weights,
				Position = 160,
				Size = 160,
				Function = function(Val)
					Dropdown:SetWeight(Val)
				end
			})
			
			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					if Dropdown.Value.Family ~= DefaultFamily or Dropdown.Value.Weight.Name ~= DefaultWeight then
						Dropdown:SetFont(DefaultFont, DefaultWeight)
					end
				end
			})
			
			Dropdown.Object = Frame
			Properties.Module.Options[SubbedName] = Dropdown
			
			return Dropdown
		end,
		TextList = function(Properties)
			local DefaultList = Properties.List or Properties.Default or {}
			local DefaultEnabled = Properties.Enabled or table.clone(DefaultList)

			local TextList = {
				List = DefaultList,
				Enabled = DefaultEnabled,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{Name}TextList`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.BackgroundTransparency = 1
			TextLabel.Size = UDim2.new(0, 200, 1, 0)
			TextLabel.Position = UDim2.fromOffset(5, 0)
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextSize = 24
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Text = Name
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')
			
			local TopBar = Instance.new('TextButton')
			TopBar.Name = 'TopBar'
			TopBar.Size = UDim2.fromOffset(240, 30)
			TopBar.Position = UDim2.fromOffset(310, 5)
			TopBar.BackgroundColor3 = GetColor('Background/Secondary')
			TopBar.BorderSizePixel = 0
			TopBar.AutoButtonColor = false
			TopBar.Text = ''
			TopBar.Parent = Background
			ListenObject(TopBar, 'Background/Secondary')
			
			local Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, 7)
			Corner.Parent = TopBar
			
			local TopBarLabel = Instance.new('TextLabel')

			local function UpdateLabel()
				TopBarLabel.Text = #TextList.Enabled > 0 and table.concat(TextList.Enabled, ', ') or 'None'
			end
			UpdateLabel()

			TopBarLabel.Size = UDim2.new(1, -20, 1, 0)
			TopBarLabel.Position = UDim2.fromOffset(10, 0)
			TopBarLabel.BackgroundTransparency = 1
			TopBarLabel.BorderSizePixel = 0
			TopBarLabel.TextSize = 24
			TopBarLabel.TextColor3 = GetColor('Text/Primary')
			TopBarLabel.FontFace = GetFont('Regular')
			TopBarLabel.TextXAlignment = Enum.TextXAlignment.Left
			TopBarLabel.TextTruncate = Enum.TextTruncate.AtEnd
			TopBarLabel.Parent = TopBar
			ListenObject(TopBarLabel, 'Text/Primary')
			ListenFont(TopBarLabel, 'Regular')
			
			local Arrow = Instance.new('TextButton')
			Arrow.Name = 'Arrow'
			Arrow.Size = UDim2.fromOffset(30, 30)
			Arrow.Position = UDim2.new(1, -30, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = ''
			Arrow.Rotation = -90
			Arrow.Parent = TopBar
			AddCorner(Arrow, UDim.new(0, 7))
			
			local ArrowImage = Instance.new('ImageLabel')
			ArrowImage.Name = 'ArrowImage'
			ArrowImage.Size = UDim2.fromOffset(30, 30)
			ArrowImage.BackgroundTransparency = 1
			SetIcon(ArrowImage, 'chevron-down')
			ArrowImage.Parent = Arrow
			ListenObject(ArrowImage, 'Main/Icons')
			
			local Children = Instance.new('ScrollingFrame')
			Children.Name = 'Children'
			Children.Size = UDim2.fromScale(1, 0)
			Children.Position = UDim2.fromScale(0, 1)
			Children.BackgroundColor3 = GetColor('Background/Secondary')
			Children.CanvasSize = UDim2.zero
			Children.ScrollBarThickness = 0
			Children.ScrollBarImageTransparency = 1
			Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			Children.Active = true
			Children.Visible = false
			Children.ZIndex = 2
			Children.Parent = TopBar
			ListenObject(Children, 'Background/Secondary')
			
			local ScrollingFrameUICorner = Instance.new('UICorner')
			ScrollingFrameUICorner.CornerRadius = UDim.new(0, 0)
			ScrollingFrameUICorner.BottomLeftRadius = UDim.new(0, 7)
			ScrollingFrameUICorner.BottomRightRadius = UDim.new(0, 7)
			ScrollingFrameUICorner.Parent = Children
			
			local Padding = Instance.new('UIPadding')
			Padding.PaddingTop = UDim.new(0, 10)
			Padding.PaddingBottom = UDim.new(0, 10)
			Padding.Parent = Children
			
			local Layout = Instance.new('UIListLayout')
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.Padding = UDim.new(0, 5)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = Children
			
			local PlusButton
			
			if Properties.CanCreate or Properties.CanCreate == nil then
				PlusButton = Instance.new('TextButton')
				PlusButton.Name = 'Plus'
				PlusButton.BackgroundColor3 = GetColor('Background/Button')
				PlusButton.Text = ''
				PlusButton.BorderSizePixel = 0
				PlusButton.Size = UDim2.fromOffset(32, 32)
				PlusButton.AutoButtonColor = false
				PlusButton.LayoutOrder = 69420
				PlusButton.ZIndex = 2
				PlusButton.Parent = Children
				AddCorner(PlusButton, UDim.new(0, 7))
				AddHighlight(PlusButton)
				ListenObject(PlusButton, 'Background/Button')
			
				local PlusImage = Instance.new('ImageLabel')
				PlusImage.Name = 'Image'
				PlusImage.BackgroundTransparency = 1
				PlusImage.Size = UDim2.fromOffset(24, 24)
				PlusImage.Position = UDim2.fromOffset(4, 4)
				PlusImage.ZIndex = 2
				SetIcon(PlusImage, 'plus')
				PlusImage.Parent = PlusButton
				ListenObject(PlusImage, 'Main/Icons')
			end
			
			local function GetHeight()
				return (Layout.AbsoluteContentSize.Y + 12) / GuiScale.Scale
			end
			
			Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())
			end)
			Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())
			
			local Expanded = false
			local Info = TweenInfo.new(0.2)
			local Tween, ArrowTween
			local CreatedButtons = {}
			
			local TextListProperties = Properties
			
			local function CreateButton(Properties)
				local Enabled = Properties.Enabled == true
				local Button = Instance.new('TextButton')
				Button.Size = UDim2.fromOffset(220, 30)
				Button.BackgroundColor3 = GetColor('Background/Button')
				Button.TextColor3 = GetColor('Text/Primary')
				Button.FontFace = GetFont('Regular')
				Button.TextSize = 20
				Button.Text = Properties.Name
				Button.LayoutOrder = Properties.LayoutOrder or 0
				Button.ZIndex = 2
				Button.BorderSizePixel = 0
				Button.AutoButtonColor = false
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = Children
				AddCorner(Button, UDim.new(0, 7))
				AddHighlight(Button)
				ListenObject(Button, 'Background/Button', 'Text/Primary')
				ListenFont(Button, 'Regular')

				local Padding = Instance.new('UIPadding')
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.Parent = Button
			
				local EnabledBar = Instance.new('Frame')
				EnabledBar.Name = 'Enabled'
				EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				EnabledBar.Size = UDim2.new(0, 2, 1, -6)
				EnabledBar.Position = UDim2.new(1, -8, 0, 3)
				EnabledBar.BorderSizePixel = 0
				EnabledBar.ZIndex = 2
				EnabledBar.Parent = Button
				ListenObject(EnabledBar, 'Main/EnabledBar', 'Main/DisabledBar', function()
					EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				end)
			
				local DeleteButton, DeleteButtonImage, RenameTextBox
			
				local CanDelete = (TextListProperties.CanDelete or TextListProperties.CanDelete == nil)
				local CanRename = (TextListProperties.CanRename or TextListProperties.CanRename == nil)
			
				if CanDelete then
					if typeof(CanDelete) == 'function' and not CanDelete(Properties.Name) then return end
			
					DeleteButton = Instance.new('TextButton')
					DeleteButton.Name = 'Delete'
					DeleteButton.BackgroundTransparency = 1
					DeleteButton.BackgroundColor3 = GetColor('Background/Button')
					DeleteButton.Text = ''
					DeleteButton.BorderSizePixel = 0
					DeleteButton.Size = UDim2.fromOffset(30, 30)
					DeleteButton.Position = UDim2.new(1, -40, 0, 0)
					DeleteButton.AutoButtonColor = false
					DeleteButton.ZIndex = 2
					DeleteButton.Parent = Button
					AddCorner(DeleteButton, UDim.new(0, 7))
					AddTooltip(DeleteButton, 'Click to remove from list')
					ListenObject(DeleteButton, 'Background/Button')
			
					DeleteButtonImage = Instance.new('ImageLabel')
					DeleteButtonImage.Name = 'Image'
					DeleteButtonImage.BackgroundTransparency = 1
					DeleteButtonImage.Size = UDim2.fromOffset(24, 24)
					DeleteButtonImage.Position = UDim2.fromOffset(3, 3)
					DeleteButtonImage.ZIndex = 2
					SetIcon(DeleteButtonImage, 'x')
					DeleteButtonImage.Parent = DeleteButton
					ListenObject(DeleteButtonImage, 'Main/Icons')
			
					DeleteButton.MouseButton1Click:Connect(function()
						Tooltip.Visible = false
						TextList:Remove(Properties.Name)
						local Index = table.find(CreatedButtons, Frame)
						if Index then
							table.remove(CreatedButtons, Index)
						end
						StopListeningFont(Button)
						if RenameTextBox then
							StopListeningFont(RenameTextBox)
						end
						for _, v in {Button, EnabledBar, DeleteButton, DeleteButtonImage, RenameTextBox} do
							StopListeningObject(v)
						end
						Button:Destroy()
					end)
				end
			
				if CanRename then
					if typeof(CanRename) == 'function' and not CanRename(Properties.Name) then return end
			
					RenameTextBox = Instance.new('TextBox')
					RenameTextBox.Name = 'Rename'
					RenameTextBox.BackgroundTransparency = 1
					RenameTextBox.Size = UDim2.fromOffset(220, 30)
					RenameTextBox.TextSize = 20
					RenameTextBox.TextColor3 = GetColor('Text/Primary')
					RenameTextBox.FontFace = GetFont('Regular')
					RenameTextBox.ClearTextOnFocus = false
					RenameTextBox.TextXAlignment = Enum.TextXAlignment.Left
					RenameTextBox.Visible = false
					RenameTextBox.ZIndex = 2
					RenameTextBox.Parent = Button
					ListenObject(RenameTextBox, 'Text/Primary')
					ListenFont(RenameTextBox, 'Regular')
			
					local function Select()
						Button.TextTransparency = 1
						RenameTextBox.Text = Properties.Name
						RenameTextBox.Visible = true
						RenameTextBox:CaptureFocus()
						RenameTextBox.SelectionStart = 0
						RenameTextBox.CursorPosition = #RenameTextBox.Text + 1
						RenameTextBox.FocusLost:Once(function()
							local OldName, NewName = Properties.Name, RenameTextBox.Text
							TextList:Remove(OldName)
							TextList:Add(NewName, Enabled)
							RenameTextBox.Visible = false
							Button.Text = NewName
							Button.TextTransparency = 0
							Properties.Name = NewName
						end)
					end
			
					if Properties.New then
						Select()
					end
			
					Button.MouseButton2Click:Connect(Select)
				end
			
				Button.MouseButton1Click:Connect(function()
					Enabled = not Enabled
					EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
					if Enabled then
						TextList:Enable(Properties.Name)
					else
						TextList:Disable(Properties.Name)
					end
				end)
			
				table.insert(CreatedButtons, Button)
			end
			
			if PlusButton then
				PlusButton.MouseButton1Click:Connect(function()
					CreateButton({
						Name = 'new item',
						LayoutOrder = #TextList.List + 1,
						New = true,
						Enabled = true
					})
				end)
			end
			
			function TextList:Find(Val)
				local Index = table.find(TextList.Enabled, Val)
				if Index then
					return TextList.Enabled[Index], Index
				end
			
				return nil
			end
			
			function TextList:Add(Val, Enabled)
				if not table.find(TextList.List, Val) then
					table.insert(TextList.List, Val)
				end
				if Enabled and not table.find(TextList.Enabled, Val) then
					table.insert(TextList.Enabled, Val)
					if Properties.Function then
						Properties.Function(TextList.Enabled)
					end
					UpdateLabel()
				end
			end
			
			function TextList:Remove(Val)
				local Index = table.find(TextList.List, Val)
				if Index then
					table.remove(TextList.List, Index)
				end
				Index = table.find(TextList.Enabled, Val)
				if Index then
					table.remove(TextList.Enabled, Index)
					if Properties.Function then
						Properties.Function(TextList.Enabled)
					end
					UpdateLabel()
				end
			end
			
			function TextList:Enable(Val)
				if not table.find(TextList.Enabled, Val) then
					table.insert(TextList.Enabled, Val)
					if Properties.Function then
						Properties.Function(TextList.Enabled)
					end
					UpdateLabel()
				end
			end
			
			function TextList:Disable(Val)
				local Index = table.find(TextList.Enabled, Val)
				if Index then
					table.remove(TextList.Enabled, Index)
					if Properties.Function then
						Properties.Function(TextList.Enabled)
					end
					UpdateLabel()
				end
			end
			
			function TextList:Expand()
				Expanded = not Expanded
				if Tween then
					Tween:Cancel()
				end
				if ArrowTween then
					ArrowTween:Cancel()
				end

				Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, Expanded and 240 or 0)})
				ArrowTween = TweenService:Create(Arrow, Info, {Rotation = Expanded and 0 or -90})

				if Expanded then
					if #CreatedButtons == 0 then
						for i, v in TextList.List do
							CreateButton({
								Name = v,
								LayoutOrder = i,
								Enabled = TextList:Find(v) ~= nil
							})
						end
					end
					Children.Visible = true
					Corner.CornerRadius = UDim.new(0, 0)
					Corner.TopLeftRadius = UDim.new(0, 7)
					Corner.TopRightRadius = UDim.new(0, 7)
				else
					Tween.Completed:Once(function(State)
						if State == Enum.PlaybackState.Completed then
							Corner.CornerRadius = UDim.new(0, 7)
							Children.Visible = false
							for _, v in CreatedButtons do
								for _, v2 in v:GetDescendants() do
									StopListeningObject(v2)
								end
								v:Destroy()
							end
							table.clear(CreatedButtons)
						end
					end)
				end
				Tween:Play()
				ArrowTween:Play()
			end
			
			function TextList:Save(Tab)
				Tab[SubbedName] = {
					Enabled = TextList.Enabled,
					List = TextList.List
				}
			end
			
			function TextList:Load(Tab)
				for _, v in TextList.Enabled do
					TextList:Remove(v)
				end
				TextList.List = Tab.List
				TextList.Enabled = Tab.Enabled
				for _, v in TextList.Enabled do
					TextList:Add(v, true)
				end
				if Properties.Function then
					Properties.Function(TextList.Enabled)
				end
				UpdateLabel()
			end
			
			function TextList:SetVisible(Visible)
				TextList.Visible = Visible
				Frame.Visible = TextList.Visible
			end

			local function MouseEnter()
				if Children.AbsoluteCanvasSize.Y > Children.AbsoluteSize.Y then
					Frame.Parent.ScrollingEnabled = false
				end
			end

			local function MouseLeave()
				Frame.Parent.ScrollingEnabled = true
			end

			Children.MouseEnter:Connect(MouseEnter)
			Children.MouseLeave:Connect(MouseLeave)
			Arrow.MouseButton1Click:Connect(TextList.Expand)
			Arrow.MouseButton2Click:Connect(TextList.Expand)
			TopBar.MouseButton1Click:Connect(TextList.Expand)
			TopBar.MouseButton2Click:Connect(TextList.Expand)
			
			Components.Options.Delete({
				Parent = Frame,
				Function = function()
					if Properties.CanDelete or Properties.CanDelete == nil then
						for _, v in CreatedButtons do
							for _, v2 in v:GetDescendants() do
								StopListeningObject(v2)
							end
							v:Destroy()
						end

						table.clear(CreatedButtons)
						table.clear(TextList.List)
						table.clear(TextList.Enabled)

						if Properties.Function then
							Properties.Function(TextList.Enabled)
						end
					end
				end
			})
			
			TextList.Object = Frame
			Properties.Module.Options[SubbedName] = TextList
			
			return TextList
		end,
		Keybind = function(Properties)
			local Keybind = {
				Keybind = Properties.Keybind or 'None',
				Hold = if Properties.UseHold ~= nil then Properties.Hold or false else nil,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}
			
			local MainFrame = Instance.new('Frame')
			MainFrame.Name = `{Properties.Name}Keybind`
			MainFrame.BackgroundTransparency = 1
			MainFrame.Size = UDim2.new(1, -100, 0, 40)
			MainFrame.LayoutOrder = table.len(Properties.Module.Options) + table.len(Properties.Module.Keybinds)
			MainFrame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = MainFrame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local KeybindName = Instance.new('TextLabel')
			KeybindName.Name = 'KeybindName'
			KeybindName.BackgroundTransparency = 1
			KeybindName.Size = UDim2.fromOffset(200, 40)
			KeybindName.Position = UDim2.fromOffset(5, 0)
			KeybindName.TextColor3 = GetColor('Text/Primary')
			KeybindName.TextSize = 24
			KeybindName.FontFace = GetFont('Regular')
			KeybindName.Text = Properties.Text or `{Properties.Name} Keybind`
			KeybindName.TextXAlignment = Enum.TextXAlignment.Left
			KeybindName.Parent = Background
			ListenObject(KeybindName, 'Text/Primary')
			ListenFont(KeybindName, 'Regular')
			
			local BindButton = Instance.new('TextButton')
			BindButton.Name = 'BindButton'
			BindButton.BackgroundColor3 = GetColor('Background/Secondary')
			BindButton.BorderSizePixel = 0
			BindButton.Size = UDim2.fromOffset(200, 30)
			BindButton.Position = UDim2.fromOffset(200, 5)
			BindButton.TextColor3 = GetColor('Text/Primary')
			BindButton.TextSize = 24
			BindButton.FontFace = GetFont('Regular')
			BindButton.Text = Properties.Keybind or 'None'
			BindButton.AutoButtonColor = false
			BindButton.Parent = Background
			AddCorner(BindButton, UDim.new(0, 7))
			AddHighlight(BindButton, 'Background/Secondary')
			AddTooltip(BindButton, 'Click to bind')
			ListenObject(BindButton, 'Background/Secondary', 'Text/Primary')
			ListenFont(BindButton, 'Regular')
			
			local EnabledBar
			
			if Properties.UseHold then
				local Hold = Instance.new('TextButton')
				Hold.Name = 'Hold'
				Hold.BackgroundColor3 = GetColor('Background/Secondary')
				Hold.BorderSizePixel = 0
				Hold.Size = UDim2.fromOffset(140, 30)
				Hold.Position = UDim2.fromOffset(410, 5)
				Hold.TextColor3 = GetColor('Text/Primary')
				Hold.TextSize = 24
				Hold.FontFace = GetFont('Regular')
				Hold.AutoButtonColor = false
				Hold.Text = 'Hold'
				Hold.Parent = Background
				AddCorner(Hold, UDim.new(0, 7))
				AddHighlight(Hold, 'Background/Secondary')
				AddTooltip(Hold, 'Changes the behavior of the keybind to require holding instead of toggling')
				ListenObject(Hold, 'Background/Secondary', 'Text/Primary')
				ListenFont(Hold, 'Regular')
			
				EnabledBar = Instance.new('Frame')
				EnabledBar.Name = 'Enabled'
				EnabledBar.BackgroundColor3 = Keybind.Hold and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				EnabledBar.Size = UDim2.fromOffset(2, 24)
				EnabledBar.Position = UDim2.new(1, -8, 0, 3)
				EnabledBar.BorderSizePixel = 0
				EnabledBar.Parent = Hold
				ListenObject(EnabledBar, 'Main/EnabledBar', nil, function()
					EnabledBar.BackgroundColor3 = Keybind.Hold and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				end)

				Hold.MouseButton1Click:Connect(function()
					Keybind:ToggleHold()
				end)
			else
				BindButton.Position += UDim2.fromOffset(150, 0)
			end
			
			BindButton.MouseButton1Click:Connect(function()
				if TidalWave.Binding then
					TidalWave.Binding = nil
					BindButton.Text = Keybind.Keybind or 'None'
				else
					BindButton.Text = 'Press Key'
					task.wait()
					TidalWave.Binding = Keybind
				end
			end)
			
			function Keybind:SetKeybind(Bind)
				self.Keybind = Bind or 'None'
				BindButton.Text = self.Keybind
				if Properties.Function then
					Properties.Function(self.Keybind)
				end
			end
			
			function Keybind:ToggleHold()
				if self.Hold ~= nil and EnabledBar then
					self.Hold = not self.Hold
					EnabledBar.BackgroundColor3 = self.Hold and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				end
			end
			
			local UserInputTypes = {
				['MouseButton1'] = true,
				['MouseButton2'] = true,
				['MouseButton3'] = true,
			}
			
			local SecondaryKeybind
			
			function Keybind:IsPressed()
				if SecondaryKeybind and SecondaryKeybind:IsPressed() then return true end
				if self.Keybind == 'None' then return false end
				for _, v in self.Keybind:split('+') do
					local Key = (UserInputTypes[v] and (not TopBar.Visible and Enum.UserInputType[v].Name or '') or nil) or Enum.KeyCode[v].Name
					if not TidalWave.PressedKeys[Key] then return false end
				end
			
				return true
			end
			
			function Keybind:Check(Input)
				if SecondaryKeybind and SecondaryKeybind:Check(Input) then return true end
				if self.Keybind == 'None' then return false end
				if Input.KeyCode == Enum.KeyCode.None and not UserInputTypes[Input.UserInputType.Name] then return false end
				local Split = self.Keybind:split('+')
				local Key = Input.KeyCode == Enum.KeyCode.None and (not TopBar.Visible and Input.UserInputType.Name or '') or Input.KeyCode.Name
				if Key == Split[1] then
					table.remove(Split, 1)
					for _, v in Split do
						if not TidalWave.PressedKeys[v] then return false end
					end
					
					return true
				end
			
				return false
			end
			
			function Keybind:SetVisible(Visible)
				self.Visible = Visible
				MainFrame.Visible = Visible
			end
			
			local Name = Properties.Name:gsub(' ', '')
			
			function Keybind:Save(Tab)
				Tab[Name] = {
					Keybind = self.Keybind,
					Hold = self.Hold
				}
			end
			
			function Keybind:Load(Tab)
				if self.Keybind ~= Tab.Keybind then
					self:SetKeybind(Tab.Keybind)
				end
				if self.Hold ~= nil and Tab.Hold ~= nil and self.Hold ~= Tab.Hold then
					self:ToggleHold()
				end
			end
			
			Components.Options.Delete({
				Parent = MainFrame,
				Function = function()
					Keybind:SetKeybind('None')
				end
			})
			
			Keybind.Object = MainFrame
			Properties.Module.Keybinds[Name] = Keybind
			
			if Properties.Secondary or Properties.SecondaryKeybind then
				Properties.Text = `{Properties.Name} Keybind 2`
				Properties.Name ..= '2'
				Properties.Secondary = nil
				Properties.Keybind = Properties.SecondaryKeybind
				SecondaryKeybind = Components.Options.Keybind(Properties)
			end
			
			return Keybind
		end,
		PlayerTextBox = function(Properties)
			local OldFunction = Properties.Function
			Properties.Function = function(Text, NoNotify)
				if Text:match('%w+') then
					local Player = FindPlayer(Text)
			
					OldFunction(Player)
			
					if NoNotify then return end
			
					if Player then
						Notify({
							Text = `Set player to {GetFullPlayerName(Player)}`,
							Duration = 5
						})
					else
						Notify({
							Text = 'Failed to find player',
							Duration = 5,
							Type = 'Error'
						})
					end
				else
					OldFunction(nil)
				end
			end
			
			local TextBox = Components.Options.TextBox(Properties)
			
			function TextBox:Refresh()
				Properties.Function(TextBox.Value, true)
			end
			
			function TextBox:CheckPlayer(Player)
				return TextBox.Value:match('%w+') ~= nil and CheckPlayer(Player, TextBox.Value)
			end
			
			return TextBox
		end,
		Reset = function(Properties)
			local Reset = Instance.new('TextButton')
			Reset.Name = 'Reset'
			Reset.BackgroundColor3 = GetColor('Background/Button')
			Reset.Text = ''
			Reset.BorderSizePixel = 0
			Reset.Size = UDim2.fromOffset(40, 40)
			Reset.Position = UDim2.new(1, -40, 0, 0)
			Reset.AutoButtonColor = false
			Reset.Parent = Properties.Parent
			AddCorner(Reset, UDim.new(0, 7))
			AddHighlight(Reset)
			ListenObject(Reset, 'Background/Button')
			
			local Image = Instance.new('ImageLabel')
			Image.Name = 'Image'
			Image.BackgroundTransparency = 1
			Image.Size = UDim2.fromOffset(24, 24)
			Image.Position = UDim2.fromOffset(8, 8)
			SetIcon(Image, 'rotate-cw')
			Image.Parent = Reset
			ListenObject(Image, 'Main/Icons')
			
			Reset.MouseButton1Click:Connect(Properties.Function)
			
			return Reset
		end,
		Slider = function(Properties)
			local Slider = {
				Value = Properties.Default or 0,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{Properties.Name}Slider`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Visible = Slider.Visible
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local Input = Instance.new('TextBox')
			
			local function SetInputText(Number)
				local Suffix = typeof(Properties.Suffix) == 'function' and Properties.Suffix(Number) or Properties.Suffix or ''
				Input.Text = `{Number}{Suffix}`
			end
			
			Input.Name = 'Input'
			Input.BackgroundColor3 = GetColor('Background/Secondary')
			Input.TextColor3 = GetColor('Text/Primary')
			Input.Size = UDim2.fromOffset(80, 30)
			Input.Position = UDim2.fromOffset(200, 5)
			SetInputText(Properties.Default)
			Input.ClearTextOnFocus = false
			Input.FontFace = GetFont('Regular')
			Input.TextSize = 24
			Input.ClipsDescendants = true
			Input.Parent = Background
			AddCorner(Input, UDim.new(0, 7))
			ListenObject(Input, 'Background/Secondary', 'Text/Primary')
			ListenFont(Input, 'Regular')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.Size = UDim2.fromOffset(200, 40)
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextSize = 24
			TextLabel.Text = ` {Properties.Name}`
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')
			
			local SliderFrame = Instance.new('TextButton')
			SliderFrame.Name = 'SliderFrame'
			SliderFrame.BackgroundTransparency = 1
			SliderFrame.Text = ''
			SliderFrame.Size = UDim2.fromOffset(230, 20)
			SliderFrame.Position = UDim2.fromOffset(300, 10)
			SliderFrame.Parent = Background
			
			local FrameDragDetector = Instance.new('UIDragDetector')
			FrameDragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			FrameDragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			FrameDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
			FrameDragDetector.DragAxis = Vector2.new(1, 0)
			FrameDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
			FrameDragDetector.Parent = SliderFrame
			
			local RightBar = Instance.new('Frame')
			RightBar.Name = 'RightBar'
			RightBar.BackgroundColor3 = GetColor('Slider/RightBar')
			RightBar.BorderSizePixel = 0
			RightBar.Parent = SliderFrame
			ListenObject(RightBar, 'Slider/RightBar')
			
			local LeftBar = Instance.new('Frame')
			LeftBar.Name = 'LeftBar'
			LeftBar.BackgroundColor3 = GetColor('Slider/LeftBar')
			LeftBar.BorderSizePixel = 0
			LeftBar.Position = UDim2.fromOffset(0, 9)
			LeftBar.Parent = SliderFrame
			ListenObject(LeftBar, 'Slider/LeftBar')
			
			local Handle = Instance.new('TextButton')
			
			local Decimals = typeof(Properties.Decimal) == 'number' and Properties.Decimal or 1
			
			local function CalculatePosition(Type, CustomPosition)
				local X = Type == 'Mouse' and (UIS:GetMouseLocation().X - SliderFrame.AbsolutePosition.X) / GuiScale.Scale or Type == 'Slider' and Handle.Position.X.Offset or Type == 'Custom' and CustomPosition
				
				local MaxSize = math.floor(SliderFrame.AbsoluteSize.X / GuiScale.Scale)
				local Pos = math.clamp(X, 0, MaxSize)
				local Scale = math.clamp(Pos / MaxSize, 0, 1)
			
				local Value = Properties.Min + (Scale * (Properties.Max - Properties.Min))
			
				if Type ~= 'Custom' then
					Value = math.clamp(Value, Properties.Min, Properties.Max)
				end
			
				Value = math.round(Value * Decimals) / Decimals
			
				return Pos, Value
			end
			
			local function CalculatePositionFromValue(Value)
				local Scale = (Value - Properties.Min) / (Properties.Max - Properties.Min)
			
				local MaxSize = math.floor(SliderFrame.AbsoluteSize.X / GuiScale.Scale)
				local Position = Scale * MaxSize
			
				return CalculatePosition('Custom', Position)
			end
			
			local StartPos = CalculatePositionFromValue(Properties.Default)
			
			LeftBar.Size = UDim2.fromOffset(StartPos, 3)
			RightBar.Size = UDim2.fromOffset(SliderFrame.Size.X.Offset - StartPos, 3)
			RightBar.Position = UDim2.fromOffset(StartPos, 9)
			Handle.Name = 'Handle'
			Handle.BackgroundColor3 = GetColor('Slider/Handle')
			Handle.BorderSizePixel = 0
			Handle.Size = UDim2.fromOffset(15, 15)
			Handle.Position = UDim2.new(0, StartPos, 0, -7)
			Handle.AnchorPoint = Vector2.new(0.5, 0)
			Handle.AutoButtonColor = false
			Handle.Text = ''
			Handle.Parent = LeftBar
			AddCorner(Handle, UDim.new(1, 0))
			ListenObject(Handle, 'Slider/Handle')
			
			local Info = TweenInfo.new(0.2)
			local Info2 = TweenInfo.new(0.1)
			
			Handle.MouseEnter:Connect(function()
				TweenService:Create(Handle, Info, {BackgroundColor3 = GetColor('Slider/HandleHover')}):Play()
			end)
			Handle.MouseLeave:Connect(function()
				TweenService:Create(Handle, Info, {BackgroundColor3 = GetColor('Slider/Handle')}):Play()
			end)
			Handle.MouseButton1Down:Connect(function()
				TweenService:Create(Handle, Info2, {BackgroundColor3 = GetColor('Slider/HandlePress')}):Play()
			end)
			Handle.MouseButton1Up:Connect(function()
				TweenService:Create(Handle, Info2, {BackgroundColor3 = GetColor('Slider/HandleHover')}):Play()
			end)
			
			local DragDetector = Instance.new('UIDragDetector')
			DragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			DragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			DragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine
			DragDetector.DragAxis = Vector2.new(1, 0)
			DragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Offset
			DragDetector.Parent = Handle
			
			local function OnFrameDragged(Type)
				local Pos, Value = CalculatePosition(typeof(Type) == 'string' and Type or 'Mouse')
				Handle.Position = UDim2.new(0, Pos, 0, -7)
				LeftBar.Size = UDim2.fromOffset(Pos, 3)
				RightBar.Size = UDim2.fromOffset(SliderFrame.Size.X.Offset - Pos, 3)
				RightBar.Position = UDim2.fromOffset(Pos, 9)
				Slider.Value = Value
				SetInputText(Slider.Value)
				if Properties.Function then
					Properties.Function(Value)
				end
			end
			
			FrameDragDetector.DragStart:Connect(OnFrameDragged)
			FrameDragDetector.DragContinue:Connect(OnFrameDragged)
			
			DragDetector.DragContinue:Connect(function()
				OnFrameDragged('Slider')
			end)
			
			local function InputNumber(Number)
				Number = tonumber(Number)
				if Number then
					if Properties.Clamp == true then
						Number = math.clamp(Number, Properties.Min, Properties.Max)
					elseif typeof(Properties.Clamp) == 'table' then
						Number = math.clamp(Number, Properties.Clamp[1], Properties.Clamp[2])
					elseif typeof(Properties.Clamp) == 'function' then
						Number = Properties.Clamp(Number)
					end
					local Pos = CalculatePositionFromValue(Number)
					Handle.Position = UDim2.new(0, Pos, 0, -7)
					LeftBar.Size = UDim2.fromOffset(Pos, 3)
					RightBar.Size = UDim2.fromOffset(SliderFrame.Size.X.Offset - Pos, 3)
					RightBar.Position = UDim2.fromOffset(Pos, 9)
					Slider.Value = Number
					if Properties.Function then
						Properties.Function(Number)
					end
				end
				SetInputText(Slider.Value)
			end
			
			Input.Focused:Connect(function()
				Input.Text = tostring(Slider.Value)
			end)
			
			Input.FocusLost:Connect(function()
				InputNumber(Input.Text)
			end)
			
			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					InputNumber(Properties.Default)
				end
			})
			
			local Name = Properties.Name:gsub(' ', '')
			
			function Slider:Save(Tab)
				Tab[Name] = {
					Value = self.Value
				}
			end
			
			function Slider:Load(Tab)
				if Slider.Value ~= Tab.Value then
					InputNumber(Tab.Value)
				end
			end
			
			function Slider:SetVisible(Visible)
				Slider.Visible = Visible
				Frame.Visible = Slider.Visible
			end
			
			Slider.Object = Frame
			
			Properties.Module.Options[Name] = Slider
			
			return Slider
		end,
		TextBox = function(Properties)
			const DefaultText = Properties.Text or Properties.Default or ''

			local TextBox = {
				Visible = if Properties.Visible ~= nil then Properties.Visible else true,
				Value = DefaultText
			}
			
			const SubbedName = Properties.Name:gsub(' ', '')
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{Properties.Name}TextBox`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Visible = false
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 0, 40)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.fromOffset(5, 0)
			TextLabel.Size = UDim2.fromOffset(200, 40)
			TextLabel.TextSize = 24
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Text = Properties.Name
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')
			
			local TextBoxObject = Instance.new('TextBox')
			TextBoxObject.BackgroundColor3 = GetColor('Background/Secondary')
			TextBoxObject.BorderSizePixel = 0
			TextBoxObject.Size = UDim2.fromOffset(335, 30)
			TextBoxObject.Position = UDim2.fromOffset(215, 5)
			TextBoxObject.ClearTextOnFocus = false
			TextBoxObject.PlaceholderText = Properties.PlaceholderText or Properties.Placeholder or ''
			TextBoxObject.TextColor3 = GetColor('Text/Primary')
			TextBoxObject.PlaceholderColor3 = GetColor('Text/Placeholder')
			TextBoxObject.FontFace = GetFont('Regular')
			TextBoxObject.TextSize = 24
			TextBoxObject.Text = DefaultText
			TextBoxObject.ClipsDescendants = true
			TextBoxObject.Parent = Background
			AddCorner(TextBoxObject, UDim.new(0, 7))
			ListenObject(TextBoxObject, 'Background/Secondary', 'Text/Primary')
			ListenObject(TextBoxObject, 'Text/Placeholder')
			ListenFont(TextBoxObject, 'Regular')
			
			local Padding = Instance.new('UIPadding')
			Padding.PaddingLeft = UDim.new(0, 5)
			Padding.PaddingRight = UDim.new(0, 5)
			Padding.Parent = TextBoxObject
			
			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					TextBox.Value = DefaultText
					TextBoxObject.Text = DefaultText
				end
			})
			
			TextBoxObject.FocusLost:Connect(function()
				TextBox.Value = TextBoxObject.Text
				if Properties.Function then
					Properties.Function(TextBox.Value, false)
				end
			end)
			
			function TextBox:SetVisible(Visible)
				TextBox.Visible = Visible
				Frame.Visible = Visible
			end
			
			function TextBox:Save(Tab)
				Tab[SubbedName] = {
					Value = self.Value
				}
			end
			
			function TextBox:Load(Tab)
				if self.Value ~= Tab.Value then
					self.Value = Tab.Value
					TextBoxObject.Text = self.Value
					if Properties.Function then
						Properties.Function(self.Value, true)
					end
				end
			end
			
			TextBox.Object = Frame
			Properties.Module.Options[SubbedName] = TextBox
			
			return TextBox
		end,
		Toggle = function(Properties)
			const Toggle = {
				Enabled = false,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true
			}
			AddMaid(Toggle)
			AddInstanceTable(Toggle)
			
			const BindedOptions = {}
			const SubbedName = Properties.Name:gsub(' ', '')
			
			const Frame = Instance.new('Frame')
			Frame.Name = `{SubbedName}Toggle`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Visible = Toggle.Visible
			Frame.Parent = Properties.Parent
			
			const Button = Instance.new('TextButton')
			Button.Name = 'Button'
			Button.BackgroundColor3 = GetColor('Background/Button')
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Button.Size = UDim2.new(1, -45, 0, 40)
			Button.TextColor3 = GetColor('Text/Primary')
			Button.TextSize = 24
			Button.FontFace = GetFont('Regular')
			Button.Text = ` {Properties.Name}`
			Button.AutoButtonColor = false
			Button.Parent = Frame
			AddCorner(Button, UDim.new(0, 7))
			AddTooltip(Button, Properties.Tooltip or Properties.Info)
			AddHighlight(Button)
			ListenObject(Button, 'Background/Button', 'Text/Primary', function()
				Button.BackgroundColor3 = Button.GuiState == Enum.GuiState.Hover and GetColor('Background/ButtonHover') or GetColor('Background/Button')
				Button.TextColor3 = Toggle.Enabled and GetColor('Text/ModuleEnabled') or GetColor('Text/Primary')
			end)
			ListenFont(Button, 'Regular')
			
			const EnabledBar = Instance.new('Frame')
			EnabledBar.Name = 'Enabled'
			EnabledBar.BackgroundColor3 = GetColor('Main/DisabledBar')
			EnabledBar.Size = UDim2.new(0, 3, 1, -6)
			EnabledBar.Position = UDim2.new(1, -9, 0, 3)
			EnabledBar.BorderSizePixel = 0
			EnabledBar.Parent = Button
			ListenObject(EnabledBar, 'Main/EnabledBar', 'Main/DisabledBar', function()
				EnabledBar.BackgroundColor3 = Toggle.Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
			end)
			
			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					if Toggle.Enabled ~= (Properties.Default or false) then
						Toggle:Toggle()
					end
				end
			})
			
			function Toggle:Toggle()
				self.Enabled = not self.Enabled
				EnabledBar.BackgroundColor3 = self.Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				Button.TextColor3 = self.Enabled and GetColor('Text/ModuleEnabled') or GetColor('Text/Primary')
				for _, Object in BindedOptions do
					Object:SetVisible(self.Enabled and self.Visible)
				end

				if self.Enabled then
					if Properties.Enabled then
						task.spawn(Properties.Enabled)
					end
				else
					self:DisconnectAll()
					self:ClearInstances()
				end

				if Properties.Function then
					task.spawn(Properties.Function, self.Enabled)
				end

				if Properties.Restart then
					Properties.Module:Restart()
				end
			end
			
			function Toggle:Show(Bool)
				Frame.Visible = if Bool then Bool else self.Visible
				for _, Object in BindedOptions do
					Object:SetVisible(self.Enabled and self.Visible)
				end
			end
			
			function Toggle:Hide()
				Frame.Visible = false
				for _, Object in BindedOptions do
					Object:Hide()
				end
			end
			
			function Toggle:SetVisible(Visible)
				self.Visible = Visible or false
				Frame.Visible = self.Visible
				for _, Object in BindedOptions do
					Object:SetVisible(self.Enabled and self.Visible)
				end
			end
			
			function Toggle:Save(Tab)
				Tab[SubbedName] = {
					Enabled = self.Enabled,
				}
			end
			
			function Toggle:Load(Tab)
				if self.Enabled ~= Tab.Enabled and Tab.Enabled ~= nil then
					self:Toggle()
				end
			end
			
			Button.MouseButton1Click:Connect(function()
				const MouseLocation = UIS:GetMouseLocation()
				if GuiCheck(Button, MouseLocation.X, MouseLocation.Y) then
					Toggle:Toggle()
				end
			end)
			
			for i, v in Components.Options do
				Toggle[`Create{i}`] = function(_, ComponentProperties)
					ComponentProperties.Parent = Properties.Parent
					ComponentProperties.LayoutOrder = table.len(Properties.Module.Options) + table.len(Properties.Module.Keybinds)
					ComponentProperties.Visible = Toggle.Enabled and Toggle.Visible
					ComponentProperties.Module = Properties.Module

					const Component = v(ComponentProperties)
					const ComponentName = ComponentProperties.Name:gsub(' ', '')
			
					BindedOptions[ComponentName] = {
						SetVisible = function(_, Visible)
							Component:SetVisible(Visible)
						end,
						Hide = function()
							if Component.Hide then
								Component:Hide()
							else
								Component.Object.Visible = false
							end
						end,
						Object = Component.Object,
					}
			
					return Component
				end
			end
			
			Toggle.Object = Frame
			
			Properties.Module.Options[SubbedName] = Toggle

			if Properties.Default then
				task.defer(Toggle.Toggle, Toggle)
			end
			
			return Toggle
		end,
		TransparencySlider = function(Properties)
			Properties.Min = 0
			Properties.Max = 1
			Properties.Decimal = 100
			
			if not Properties.Default then
				Properties.Default = 0
			end
			
			return Components.Options.Slider(Properties)
		end,
	},
	Other = {
		Category = function(Properties)
			const Rand = Random.new(table.len(TidalWave.Categories))
			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			const Category = {
				Expanded = true,
				ClosedPosition = UDim2.fromScale(Rand:NextNumber(-1, 1), Rand:NextInteger(0, 1) == 0 and -1 or 1),
				OpenedPosition = UDim2.zero,
				Options = {}
			}
			
			const Info = TweenInfo.new(0.2)
			const CloseInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			const TidalWaveTopBar = TopBar
			local OpenTween, CloseTween, ExpandTween, ArrowTween
			
			const TopBar = Instance.new('TextButton')
			TopBar.BackgroundColor3 = GetColor('Main/Accent')
			TopBar.Name = `{Name}Category`
			TopBar.Position = Category.ClosedPosition
			TopBar.Size = UDim2.fromOffset(180, 26)
			TopBar.Text = ''
			TopBar.Parent = CategoryHolder
			ListenObject(TopBar, 'Main/Accent')
			
			const Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, 0)
			Corner.TopLeftRadius = UDim.new(0, 5)
			Corner.TopRightRadius = UDim.new(0, 5)
			Corner.Parent = TopBar
			
			const NameLabel = Instance.new('TextLabel')
			NameLabel.BackgroundTransparency = 1
			NameLabel.Name = 'Title'
			NameLabel.Text = Name
			NameLabel.TextColor3 = GetColor('Text/Primary')
			NameLabel.FontFace = GetFont('Medium')
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextSize = 20
			NameLabel.Size = UDim2.fromScale(1, 1)
			NameLabel.Position = UDim2.fromOffset(10, 0)
			NameLabel.Parent = TopBar
			ListenObject(NameLabel, 'Text/Primary')
			ListenFont(NameLabel, 'Medium')
			
			const DragDetector = Instance.new('UIDragDetector')
			DragDetector.CursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			DragDetector.ActivatedCursorIcon = 'rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png'
			DragDetector.Parent = TopBar

			const ChildrenFrame = Instance.new('Frame')
			ChildrenFrame.Name = 'ChildrenFrame'
			ChildrenFrame.Size = UDim2.new(1, 0, 0, 380)
			ChildrenFrame.Position = UDim2.fromScale(0, 1)
			ChildrenFrame.BackgroundColor3 = GetColor('Background/Button')
			ChildrenFrame.BorderSizePixel = 0
			ChildrenFrame.Active = true
			ChildrenFrame.Parent = TopBar
			ListenObject(ChildrenFrame, 'Background/Button')
			
			const ChildrenCorner = Instance.new('UICorner')
			ChildrenCorner.CornerRadius = UDim.new(0, 0)
			ChildrenCorner.BottomLeftRadius = UDim.new(0, 5)
			ChildrenCorner.BottomRightRadius = UDim.new(0, 5)
			ChildrenCorner.Parent = ChildrenFrame
			
			const Children = Instance.new('ScrollingFrame')
			Children.Name = 'Children'
			Children.Size = UDim2.new(1, 0, 1, -4)
			Children.BackgroundTransparency = 1
			Children.CanvasSize = UDim2.zero
			Children.ScrollBarThickness = 0
			Children.ScrollBarImageTransparency = 1
			Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			Children.Active = true
			Children.Parent = ChildrenFrame
			
			const Padding = Instance.new('UIPadding')
			Padding.PaddingBottom = UDim.new(0, 4)
			Padding.Parent = Children
			
			const Layout = Instance.new('UIListLayout')
			Layout.Name = 'Layout'
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = Children
			
			const Arrow = Instance.new('TextButton')
			Arrow.Name = 'Arrow'
			Arrow.Size = UDim2.fromOffset(26, 26)
			Arrow.Position = UDim2.new(1, -26, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = ''
			Arrow.Parent = TopBar
			
			const ArrowImage = Instance.new('ImageLabel')
			ArrowImage.Name = 'Image'
			ArrowImage.Size = UDim2.fromOffset(24, 24)
			ArrowImage.Position = UDim2.fromOffset(1, 1)
			ArrowImage.BackgroundTransparency = 1
			SetIcon(ArrowImage, 'chevron-down')
			ArrowImage.Parent = Arrow
			ListenObject(ArrowImage, 'Main/Icons')

			const function GetChildrenSize()
				const Size = Category.Expanded and Layout.AbsoluteContentSize.Y / GuiScale.Scale or 0

				return math.min(Size, (26 * 16)) + 4
			end

			const function GetCanvasSize()
				const Size = Category.Expanded and Layout.AbsoluteContentSize.Y / GuiScale.Scale or 0

				return Size
			end
			
			Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				ChildrenFrame.Size = UDim2.new(1, 0, 0, GetChildrenSize())
				Children.CanvasSize = UDim2.new(1, 0, 0, GetCanvasSize())
			end)
			
			function Category:Expand(Instant)
				self.Expanded = not self.Expanded
				if not TidalWave.CategoryAnimations or Instant == true then
					ChildrenFrame.Size = UDim2.new(1, 0, 0, GetChildrenSize())
					Children.Visible = self.Expanded
					Arrow.Rotation = self.Expanded and 0 or -90
					Corner.BottomLeftRadius = UDim.new(0, self.Expanded and 0 or 5)
					Corner.BottomRightRadius = UDim.new(0, self.Expanded and 0 or 5)
					return
				end

				if ExpandTween then
					ExpandTween:Cancel()
				end
				if ArrowTween then
					ArrowTween:Cancel()
				end

				ExpandTween = TweenService:Create(ChildrenFrame, Info, {Size = UDim2.new(1, 0, 0, GetChildrenSize())})
				ArrowTween = TweenService:Create(Arrow, Info, {Rotation = self.Expanded and 0 or -90})

				if self.Expanded then
					ChildrenFrame.Visible = true
					Corner.BottomLeftRadius = UDim.new(0, 0)
					Corner.BottomRightRadius = UDim.new(0, 0)
				else
					ExpandTween.Completed:Once(function(State)
						if State == Enum.PlaybackState.Completed then
							ChildrenFrame.Visible = false
							Corner.BottomLeftRadius = UDim.new(0, 5)
							Corner.BottomRightRadius = UDim.new(0, 5)
							ExpandTween, ArrowTween = nil, nil
						end
					end)
				end

				ExpandTween:Play()
				ArrowTween:Play()
			end
			
			DragDetector.DragContinue:Connect(function()
				Category.OpenedPosition = TopBar.Position
			end)
			
			function Category:Toggle()
				local Visible = CategoryHolder.Visible
				if TidalWave.CategoryAnimations then
					if Visible and not CloseTween then
						CloseTween = TweenService:Create(TopBar, CloseInfo, {Position = self.ClosedPosition})
						CloseTween:Play()
						CloseTween.Completed:Once(function(State)
							if State == Enum.PlaybackState.Completed and Visible then
								CategoryHolder.Visible = false
								Modal.Visible = false
							end
							CloseTween = nil
						end)
					else
						if CloseTween then
							CloseTween:Cancel()
							TidalWaveTopBar.Visible = true
						end
						OpenTween = TweenService:Create(TopBar, Info, {Position = self.OpenedPosition})
						OpenTween:Play()
						OpenTween.Completed:Once(function()
							OpenTween = nil
						end)
					end
				else
					Modal.Visible = Visible
					TidalWaveTopBar.Visible = Visible
					TopBar.Position = Visible and self.OpenedPosition or self.ClosedPosition
				end
			end
			
			function Category:SetOpenedPosition(Pos)
				self.OpenedPosition = Pos
				if CategoryHolder.Visible and not self:IsMoving() then
					TopBar.Position = self.OpenedPosition
				end
			end
			
			function Category:IsMoving()
				return OpenTween ~= nil or CloseTween ~= nil
			end

			function Category:Save(Tab)
				Tab[SubbedName] = {
					Location = UDim2ToTable(self.OpenedPosition),
					Expanded = self.Expanded
				}
			end

			function Category:Load(Tab)
				if Tab.Location then
					const Location = TableToUDim2(Tab.Location)
					self:SetOpenedPosition(Location)
				end

				if self.Expanded ~= Tab.Expanded then
					self:Expand(true)
				end
			end
			
			Arrow.MouseButton1Click:Connect(function()
				Category:Expand()
			end)

			Arrow.MouseButton2Down:Connect(function()
				Category:Expand()
			end)

			TopBar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton2 then
					Category:Expand()
				end
			end)
			
			function Category:CreateModule(Properties)
				TidalWave:RemoveModule(Properties.Name)

				Properties.Category = Category
				Properties.Parent = Children

				return Components.Category.Module(Properties)
			end
			
			function Category:CreateButton(Properties)
				TidalWave:RemoveButton(Properties.Name)

				Properties.Category = Category
				Properties.Parent = Children
				
				return Components.Category.Button(Properties)
			end
			
			Category.Object = TopBar
			Category.Children = Children
			
			TidalWave.Categories[SubbedName] = Category
			table.insert(CategoryArray, SubbedName)
			
			UpdateCategoryPositions()
			
			return Category
		end,
		FriendButton = function(Properties)
			local Frame = Instance.new('Frame')
			Frame.Name = `{Properties.Name}Button`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder or table.len(FriendsMenu.Options)
			Frame.Parent = FriendsMenu.Children
			
			local Background = Instance.new('Frame')
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.Size = UDim2.new(1, -45, 0, 40)
			Background.BorderSizePixel = 0
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local NameLabel = Instance.new('TextButton')
			NameLabel.BackgroundTransparency = 1
			NameLabel.Size = UDim2.fromOffset(400, 40)
			NameLabel.Position = UDim2.fromOffset(5, 0)
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.Text = Properties.Name
			NameLabel.TextSize = 24
			NameLabel.TextColor3 = GetColor('Text/Primary')
			NameLabel.FontFace = GetFont('Regular')
			NameLabel.AutoButtonColor = false
			NameLabel.Parent = Background
			AddHighlight(NameLabel)
			ListenObject(NameLabel, 'Text/Primary')
			ListenFont(NameLabel, 'Regular')
			
			local Enabled = if Properties.Enabled ~= nil then Properties.Enabled else true
			
			local EnabledBar = Instance.new('Frame')
			EnabledBar.Name = 'Enabled'
			EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
			EnabledBar.Size = UDim2.new(0, 2, 1, -6)
			EnabledBar.Position = UDim2.new(1, -8, 0, 3)
			EnabledBar.BorderSizePixel = 0
			EnabledBar.Parent = Background
			ListenObject(EnabledBar, 'Main/EnabledBar', 'Main/DisabledBar', function()
				EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
			end)
			
			local RenameTextBox = Instance.new('TextBox')
			RenameTextBox.Name = 'Rename'
			RenameTextBox.BackgroundTransparency = 1
			RenameTextBox.Size = UDim2.fromOffset(200, 40)
			RenameTextBox.TextSize = 24
			RenameTextBox.TextColor3 = GetColor('Text/Primary')
			RenameTextBox.FontFace = GetFont('Regular')
			RenameTextBox.ClearTextOnFocus = false
			RenameTextBox.TextXAlignment = Enum.TextXAlignment.Left
			RenameTextBox.Visible = false
			RenameTextBox.Parent = NameLabel
			ListenObject(RenameTextBox, 'Text/Primary')
			ListenFont(RenameTextBox, 'Regular')
			
			local DeleteButton = Instance.new('TextButton')
			DeleteButton.Name = 'Delete'
			DeleteButton.BackgroundColor3 = GetColor('Background/Button')
			DeleteButton.Text = ''
			DeleteButton.BorderSizePixel = 0
			DeleteButton.Size = UDim2.fromOffset(40, 40)
			DeleteButton.Position = UDim2.new(1, -40, 0, 0)
			DeleteButton.AutoButtonColor = false
			DeleteButton.Parent = Frame
			AddCorner(DeleteButton, UDim.new(0, 7))
			AddHighlight(DeleteButton)
			AddTooltip(DeleteButton, 'Click to remove friend')
			ListenObject(DeleteButton, 'Background/Button')
			
			local DeleteButtonImage = Instance.new('ImageLabel')
			DeleteButtonImage.Name = 'Image'
			DeleteButtonImage.BackgroundTransparency = 1
			DeleteButtonImage.Size = UDim2.fromOffset(24, 24)
			DeleteButtonImage.Position = UDim2.fromOffset(8, 8)
			SetIcon(DeleteButtonImage, 'x')
			DeleteButtonImage.Parent = DeleteButton
			ListenObject(DeleteButtonImage, 'Main/Icons')
			
			local Rename = Instance.new('TextButton')
			Rename.Name = 'Rename'
			Rename.BackgroundColor3 = GetColor('Background/Secondary')
			Rename.Text = 'Rename'
			Rename.BorderSizePixel = 0
			Rename.Size = UDim2.fromOffset(100, 30)
			Rename.Position = UDim2.new(1, -105, 0, 5)
			Rename.TextColor3 = GetColor('Text/Primary')
			Rename.TextSize = 24
			Rename.FontFace = GetFont('Regular')
			Rename.AutoButtonColor = false
			Rename.Parent = Background
			AddCorner(Rename, UDim.new(0, 7))
			AddHighlight(Rename, 'Background/Secondary')
			ListenObject(Rename, 'Background/Secondary', 'Text/Primary')
			ListenFont(Rename, 'Regular')
			
			local function Select()
				NameLabel.TextTransparency = 1
				RenameTextBox.Text = Properties.Name
				RenameTextBox.Visible = true
				RenameTextBox:CaptureFocus()
				RenameTextBox.SelectionStart = 0
				RenameTextBox.CursorPosition = #RenameTextBox.Text + 1
				RenameTextBox.FocusLost:Once(function()
					Properties.Name = RenameTextBox.Text
					TidalWave.Friends[Properties.Name] = Enabled
					RenameTextBox.Visible = false
					NameLabel.Text = Properties.Name
					NameLabel.TextTransparency = 0
				end)
			end
			
			if Properties.New then
				Select()
			end
			
			NameLabel.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				EnabledBar.BackgroundColor3 = Enabled and GetColor('Main/EnabledBar') or GetColor('Main/DisabledBar')
				TidalWave.Friends[Properties.Name] = Enabled
			end)
			
			Rename.MouseButton1Click:Connect(function()
				Select()
			end)
			
			DeleteButton.MouseButton1Click:Connect(function()
				Tooltip.Visible = false
				TidalWave.Friends[Properties.Name] = nil
				for _, v in {Frame, Background, NameLabel, EnabledBar, RenameTextBox, DeleteButton, DeleteButtonImage, Rename} do
					StopListeningObject(v)
				end
				Frame:Destroy()
			end)
		end,
		HudLabel = function(Properties)
			local Option, TextSize, TextColor, BackgroundColor, OutlineColor, OutlineThickness, Font, CornerRadius, TopLeftRadius, TopRightRadius, BottomLeftRadius, BottomRightRadius, SizeX, SizeY
			local Label, Corner, Outline

			Option = HudMenu:CreateOption({
				Name = Properties.Name,
				Enabled = Properties.Enabled,
				Function = function(Enabled)
					Label.Visible = Enabled
					if Properties.Function then
						Properties.Function(Enabled)
					end
				end,
			})
			
			TextSize = Option:CreateSlider({
				Name = 'Text Size',
				Default = 16,
				Min = 8,
				Max = 32,
				Clamp = {1, 100},
				Function = function(Val)
					Label.TextSize = Val
				end
			})
			
			TextColor = Option:CreateColorPicker({
				Name = 'Text Color',
				Function = function(Color, Transparency)
					Label.TextColor3 = Color
					Label.TextTransparency = Transparency
				end
			})
			
			BackgroundColor = Option:CreateColorPicker({
				Name = 'Background Color',
				Default = Color3.Black,
				Transparency = 0.5,
				Function = function(Color, Transparency)
					Label.BackgroundColor3 = Color
					Label.BackgroundTransparency = Transparency
				end
			})
			
			OutlineColor = Option:CreateColorPicker({
				Name = 'Outline Color',
				Default = Color3.Black,
				Function = function(Color, Transparency)
					Outline.Color = Color
					Outline.Transparency = Transparency
				end
			})
			
			OutlineThickness = Option:CreateSlider({
				Name = 'Outline Thickness',
				Default = 1,
				Min = 0,
				Max = 5,
				Function = function(Val)
					Outline.Thickness = Val
				end
			})
			
			Option:CreateDropdown({
				Name = 'Corner Mode',
				List = {'Single', 'Specific'},
				Function = function(Val)
					CornerRadius:SetVisible(Val == 'Single')
					for _, Slider in {TopLeftRadius, TopRightRadius, BottomLeftRadius, BottomRightRadius} do
						Slider:SetVisible(Val == 'Specific')
					end
			
					if Val == 'Single' then
						Corner.CornerRadius = UDim.new(0, CornerRadius.Value)
					else
						Corner.CornerRadius = UDim.new(0, 0)
						Corner.TopLeftRadius = UDim.new(0, TopLeftRadius.Value)
						Corner.TopRightRadius = UDim.new(0, TopLeftRadius.Value)
						Corner.BottomLeftRadius = UDim.new(0, TopLeftRadius.Value)
						Corner.BottomRightRadius = UDim.new(0, TopLeftRadius.Value)
					end
				end
			})
			
			const function CreateRadiusSlider(Name)
				const Property = Name:gsub(' ', '')
				return Option:CreateSlider({
					Name = Name,
					Default = 5,
					Min = 0,
					Max = 25,
					Visible = Name == 'Corner Radius',
					Function = function(Val)
						Corner[Property] = UDim.new(0, Val)
					end
				})
			end
			
			CornerRadius = CreateRadiusSlider('Corner Radius')
			TopLeftRadius = CreateRadiusSlider('Top Left Radius')
			TopRightRadius = CreateRadiusSlider('Top Right Radius')
			BottomLeftRadius = CreateRadiusSlider('Bottom Left Radius')
			BottomRightRadius = CreateRadiusSlider('Bottom Right Radius')
			
			Font = Option:CreateFont({
				Name = 'Font',
				Function = function(Font)
					Label.FontFace = Font
				end,
			})
			
			SizeX = Option:CreateSlider({
				Name = 'X Size',
				Default = Properties.SizeX or 90,
				Min = 50,
				Max = 150,
				Function = function(Val)
					Label.Size = UDim2.fromOffset(Val, Label.Size.Y.Offset)
				end
			})
			
			SizeY = Option:CreateSlider({
				Name = 'Y Size',
				Default = Properties.SizeY or 24,
				Min = 20,
				Max = 60,
				Function = function(Val)
					Label.Size = UDim2.fromOffset(Label.Size.X.Offset, Val)
				end
			})
			
			Label = Instance.new('TextLabel')
			Label.Name = Properties.Name
			Label.TextSize = TextSize.Value
			Label.FontFace = Font.Value
			Label.TextColor3 = TextColor.Color
			Label.TextTransparency = TextColor.Transparency
			Label.BackgroundColor3 = BackgroundColor.Color
			Label.BackgroundTransparency = BackgroundColor.Transparency
			Label.BorderSizePixel = 0
			Label.Size = UDim2.fromOffset(SizeX.Value, SizeY.Value)
			Label.Position = UDim2.fromOffset(0, 60)
			Label.Text = Properties.Text
			Label.Visible = false
			Label.Parent = HudFolder
			
			Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, CornerRadius.Value)
			Corner.Parent = Label
			
			Outline = Instance.new('UIStroke')
			Outline.Thickness = OutlineThickness.Value
			Outline.Color = OutlineColor.Color
			Outline.Transparency = OutlineColor.Transparency
			Outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
			Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Outline.Parent = Label
			
			Option.Label = Label
			
			return Option
		end,
		Menu = function(Properties)
			local Menu = {
				Options = {},
				Buttons = {},
				Keybinds = {}
			}
			
			local TopBar = Instance.new('TextButton')
			TopBar.Position = UDim2.new(0.5, -350, 0.5, -270)
			TopBar.Size = UDim2.fromOffset(700, 40)
			TopBar.BackgroundColor3 = GetColor('Main/Accent')
			TopBar.Text = ''
			TopBar.AutoButtonColor = false
			TopBar.Name = `{Properties.Name}Menu`
			TopBar.Visible = false
			TopBar.Parent = MenuHolder
			ListenObject(TopBar, 'Main/Accent')
			
			local UICorner = Instance.new('UICorner')
			UICorner.CornerRadius = UDim.new(0, 0)
			UICorner.TopLeftRadius = UDim.new(0, 10)
			UICorner.TopRightRadius = UDim.new(0, 10)
			UICorner.Parent = TopBar
			
			local NameLabel = Instance.new('TextLabel')
			NameLabel.Name = 'Title'
			NameLabel.Size = UDim2.fromScale(1, 1)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = `  {Properties.Name}`
			NameLabel.TextSize = 32
			NameLabel.FontFace = GetFont('Medium')
			NameLabel.TextColor3 = GetColor('Text/Primary')
			NameLabel.Parent = TopBar
			ListenObject(NameLabel, 'Text/Primary')
			ListenFont(NameLabel, 'Medium')
			
			local Children = Instance.new('ScrollingFrame')
			Children.Name = 'Children'
			Children.Size = UDim2.new(1, 0, 0, 500)
			Children.Position = UDim2.fromScale(0, 1)
			Children.BackgroundColor3 = GetColor('Background/Primary')
			Children.CanvasSize = UDim2.zero
			Children.ScrollBarThickness = 6
			Children.ScrollingDirection = Enum.ScrollingDirection.Y
			Children.BorderSizePixel = 0
			Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			Children.Active = true
			Children.Parent = TopBar
			ListenObject(Children, 'Background/Primary')
			
			local ScrollingFrameUICorner = Instance.new('UICorner')
			ScrollingFrameUICorner.CornerRadius = UDim.new(0, 0)
			ScrollingFrameUICorner.BottomLeftRadius = UDim.new(0, 10)
			ScrollingFrameUICorner.BottomRightRadius = UDim.new(0, 10)
			ScrollingFrameUICorner.Parent = Children
			
			local Padding = Instance.new('UIPadding')
			Padding.PaddingTop = UDim.new(0, 10)
			Padding.PaddingBottom = UDim.new(0, 10)
			Padding.Parent = Children
			
			local Layout = Instance.new('UIListLayout')
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.Padding = UDim.new(0, 5)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = Children
			
			local Close = Instance.new('TextButton')
			Close.Name = 'Close'
			Close.Size = UDim2.fromOffset(40, 40)
			Close.Position = UDim2.new(1, -40, 0, 0)
			Close.BackgroundTransparency = 1
			Close.Text = ''
			Close.Parent = TopBar
			
			local CloseImage = Instance.new('ImageLabel')
			CloseImage.Name = 'Image'
			CloseImage.Size = UDim2.fromOffset(36, 36)
			CloseImage.Position = UDim2.fromOffset(2, 2)
			CloseImage.BackgroundTransparency = 1
			SetIcon(CloseImage, 'x')
			CloseImage.Parent = Close
			ListenObject(CloseImage, 'Main/Icons')
			
			local function GetHeight()
				return (Layout.AbsoluteContentSize.Y + 400) / GuiScale.Scale
			end
			
			Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())
			end)
			Children.CanvasSize = UDim2.new(1, 0, 0, GetHeight())
			
			local CloseFunction = function()
				ModulesTopBar:Select()
			end
			
			Close.MouseButton1Click:Connect(function()
				TopBar.Visible = false
				if CloseFunction then
					CloseFunction()
				end
			end)
			
			function Menu:BindToClose(f)
				if typeof(f) == 'function' then
					CloseFunction = f
				end
			end
			
			function Menu:Show()
				TopBar.Visible = true
			end
			
			function Menu:Hide()
				TopBar.Visible = false
			end
			
			function Menu:HideOptions()
				for _, v in Menu.Options do
					v.Object.Visible = false
				end
			end
			
			function Menu:HideChildren()
				for _, v in Children:GetChildren() do
					if v:IsA('GuiObject') then
						v.Visible = false
					end
				end
			end
			
			function Menu:ShowOptions()
				for _, v in Menu.Options do
					v.Object.Visible = if v.Visible ~= nil then v.Visible else true
				end
			end
			
			function Menu:ShowChildren()
				for _, v in Children:GetChildren() do
					if v:IsA('GuiObject') then
						v.Visible = true
					end
				end
			end
			
			function Menu:ClearAllChildren()
				for _, v in Menu.Options do
					if v.Enabled then
						v:Toggle()
					end
					v.Object:Destroy()
				end
				table.clear(Menu.Options)
				table.clear(Menu.Keybinds)
			end
			
			function Menu:CreateOption(Properties)
				Properties.Parent = Children
				Properties.LayoutOrder = table.len(Menu.Options) + table.len(Menu.Keybinds)
				Properties.Module = Menu
				local Toggle = Components.Options.Toggle(Properties)
				Toggle.Options = {}
				Toggle.Buttons = {}
				Toggle.Keybinds = {}
			
				Toggle.Object.Button.MouseButton2Click:Connect(function()
					MenuOptions.Object.Title.Text = Properties.Name
					for i, v in TidalWave.Menus do
						v.Object.Visible = i == 'MenuOptions'
					end
					
					for i, v in MenuOptions.Options do
						if v.Hide then
							v:Hide()
						else
							v.Object.Visible = false
						end
					end
					for i, v in MenuOptions.Keybinds do
						v.Object.Visible = false
					end
					for i, v in MenuOptions.Buttons do
						v.Object.Visible = false
					end
			
					for i, v in Toggle.Options do
						if v.Show then
							v:Show()
						else
							v.Object.Visible = v.Visible
						end
					end
					for i, v in Toggle.Buttons do
						v.Object.Visible = v.Visible
					end
				end)
			
				local Name = Properties.Name:gsub(' ', '')
			
				for i, v in Components.Options do
					Toggle[`Create{i}`] = function(_, Properties)
						Properties.Parent = MenuOptions.Children
						Properties.LayoutOrder = table.len(Toggle.Options)
						Properties.Module = Toggle
						local Component = v(Properties)
						local Tab = (i == 'Keybind' and MenuOptions.Keybinds or i == 'Button' and MenuOptions.Buttons or MenuOptions.Options)
						Tab[Name..'_'..Properties.Name:gsub(' ', '')] = Component
			
						return Component
					end
				end
			
				Menu.Options[Name] = Toggle
			
				return Toggle
			end
			
			for i, v in Components.Options do
				Menu[`Create{i}`] = function(_, Properties)
					Properties.Parent = Children
					Properties.LayoutOrder = table.len(Menu.Options) + table.len(Menu.Keybinds)
					Properties.Module = Menu
					return v(Properties)
				end
			end
			
			Menu.Object = TopBar
			Menu.Children = Children
			
			TidalWave.Menus[Properties.Name:gsub(' ', '')] = Menu
			
			return Menu
		end,
		ProfileButton = function(Properties)
			local Frame = Instance.new('Frame')
			Frame.Name = `{Properties.Name}Button`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder or #TidalWave.Profiles
			Frame.Parent = ProfilesMenu.Children
			
			local Background = Instance.new('Frame')
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.Size = UDim2.new(1, -45, 0, 40)
			Background.BorderSizePixel = 0
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local NameLabel = Instance.new('TextButton')
			NameLabel.BackgroundTransparency = 1
			NameLabel.Size = UDim2.fromOffset(400, 40)
			NameLabel.Position = UDim2.fromOffset(5, 0)
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.Text = Properties.Name
			NameLabel.TextSize = 24
			NameLabel.TextColor3 = GetColor('Text/Primary')
			NameLabel.FontFace = GetFont('Regular')
			NameLabel.AutoButtonColor = false
			NameLabel.Parent = Background
			ListenObject(NameLabel, 'Text/Primary')
			ListenFont(NameLabel, 'Regular')
			
			local RenameTextBox = Instance.new('TextBox')
			RenameTextBox.Name = 'Rename'
			RenameTextBox.BackgroundTransparency = 1
			RenameTextBox.Size = UDim2.fromOffset(200, 40)
			RenameTextBox.TextSize = 24
			RenameTextBox.TextColor3 = GetColor('Text/Primary')
			RenameTextBox.FontFace = GetFont('Regular')
			RenameTextBox.ClearTextOnFocus = false
			RenameTextBox.TextXAlignment = Enum.TextXAlignment.Left
			RenameTextBox.Visible = false
			RenameTextBox.Parent = NameLabel
			ListenObject(RenameTextBox, 'Text/Primary')
			ListenFont(RenameTextBox, 'Regular')
			
			local DeleteButton = Instance.new('TextButton')
			DeleteButton.Name = 'Delete'
			DeleteButton.BackgroundColor3 = GetColor('Background/Button')
			DeleteButton.Text = ''
			DeleteButton.BorderSizePixel = 0
			DeleteButton.Size = UDim2.fromOffset(40, 40)
			DeleteButton.Position = UDim2.new(1, -40, 0, 0)
			DeleteButton.AutoButtonColor = false
			DeleteButton.Parent = Frame
			AddCorner(DeleteButton, UDim.new(0, 7))
			AddHighlight(DeleteButton)
			AddTooltip(DeleteButton, 'Click to delete the profile')
			ListenObject(DeleteButton, 'Background/Button')
			
			local DeleteButtonImage = Instance.new('ImageLabel')
			DeleteButtonImage.Name = 'Image'
			DeleteButtonImage.BackgroundTransparency = 1
			DeleteButtonImage.Size = UDim2.fromOffset(24, 24)
			DeleteButtonImage.Position = UDim2.fromOffset(8, 8)
			SetIcon(DeleteButtonImage, 'x')
			DeleteButtonImage.Parent = DeleteButton
			ListenObject(DeleteButtonImage, 'Main/Icons')
			
			local Load = Instance.new('TextButton')
			Load.Name = 'Load'
			Load.BackgroundColor3 = GetColor('Background/Secondary')
			Load.Text = 'Load'
			Load.BorderSizePixel = 0
			Load.Size = UDim2.fromOffset(100, 30)
			Load.Position = UDim2.new(1, -105, 0, 5)
			Load.TextColor3 = GetColor('Text/Primary')
			Load.TextSize = 24
			Load.FontFace = GetFont('Regular')
			Load.AutoButtonColor = false
			Load.Parent = Background
			AddCorner(Load, UDim.new(0, 7))
			AddHighlight(Load, 'Background/Secondary')
			ListenObject(Load, 'Background/Secondary', 'Text/Primary', function()
				Load.BackgroundColor3 = Load.GuiState == Enum.GuiState.Hover and GetColor('Background/ButtonHover') or GetColor('Background/Secondary')
				Load.TextColor3 = GetColor('Text/Primary')
			end)
			ListenFont(Load, 'Regular')
			
			local Save = Instance.new('TextButton')
			Save.Name = 'Save'
			Save.BackgroundColor3 = GetColor('Background/Secondary')
			Save.Text = 'Save'
			Save.BorderSizePixel = 0
			Save.Size = UDim2.fromOffset(100, 30)
			Save.Position = UDim2.new(1, -210, 0, 5)
			Save.TextColor3 = GetColor('Text/Primary')
			Save.TextSize = 24
			Save.FontFace = GetFont('Regular')
			Save.AutoButtonColor = false
			Save.Parent = Background
			AddCorner(Save, UDim.new(0, 7))
			AddHighlight(Save, 'Background/Secondary')
			ListenObject(Save, 'Background/Secondary', 'Text/Primary')
			ListenFont(Save, 'Regular')
			
			local Copy = Instance.new('TextButton')
			Copy.Name = 'Copy'
			Copy.BackgroundColor3 = GetColor('Background/Secondary')
			Copy.Text = 'Copy'
			Copy.BorderSizePixel = 0
			Copy.Size = UDim2.fromOffset(100, 30)
			Copy.Position = UDim2.new(1, -315, 0, 5)
			Copy.TextColor3 = GetColor('Text/Primary')
			Copy.TextSize = 24
			Copy.FontFace = GetFont('Regular')
			Copy.AutoButtonColor = false
			Copy.Parent = Background
			AddCorner(Copy, UDim.new(0, 7))
			AddHighlight(Copy, 'Background/Secondary')
			AddTooltip(Copy, 'Copies the Config to your clipboard.')
			ListenObject(Copy, 'Background/Secondary', 'Text/Primary')
			ListenFont(Copy, 'Regular')
			
			const function Select()
				NameLabel.TextTransparency = 1
				RenameTextBox.Text = Properties.Name
				RenameTextBox.Visible = true
				RenameTextBox:CaptureFocus()
				RenameTextBox.SelectionStart = 0
				RenameTextBox.CursorPosition = #RenameTextBox.Text + 1
				RenameTextBox.FocusLost:Once(function()
					local Text
					if table.find(TidalWave.Profiles, RenameTextBox.Text) then
						Text = RenameTextBox.Text .. ' 2'
					else
						Text = RenameTextBox.Text
					end

					table.insert(TidalWave.Profiles, Text)
					TidalWave:Save(Text)

					const Path = `TidalWave/Profiles/{Properties.Name}{game.PlaceId}.json`
					if delfile and isfile and isfile(Path) then
						delfile(Path)
					end

					const Index = table.find(TidalWave.Profiles, Properties.Name)
					if Index then
						table.remove(TidalWave.Profiles, Index)
					end

					RenameTextBox.Visible = false
					NameLabel.Text = Text
					NameLabel.TextTransparency = 0
					Properties.Name = Text
				end)
			end
			
			if Properties.New then
				Select()
			elseif Properties.Imported then
				local Text
				if table.find(TidalWave.Profiles, Properties.Name) then
					Text = Properties.Name .. ' 2'
				else
					Text = Properties.Name
				end

				table.insert(TidalWave.Profiles, Text)
				TidalWave:Save(Text, Properties.Imported)
			end
			
			local LastClick = 0
			
			NameLabel.MouseButton1Click:Connect(function()
				if os.clock() - LastClick <= 0.5 then
					Select()
					LastClick = 0
				else
					LastClick = os.clock()
				end
			end)
			
			Save.MouseButton1Click:Connect(function()
				TidalWave:Save(Properties.Name)
			end)
			
			Load.MouseButton1Click:Connect(function()
				TidalWave:Load(Properties.Name)
			end)

			Copy.MouseButton1Click:Connect(function()
				const Path = `TidalWave/Profiles/{Properties.Name}{game.PlaceId}.json`
				if isfile and isfile(Path) then
					setclipboard(readfile(Path))
				end
			end)
			
			DeleteButton.MouseButton1Click:Connect(function()
				if not delfile then NotifyPoopSploit('delfile'); return end
				local Path = `TidalWave/Profiles/{Properties.Name}{game.PlaceId}.json`
				Tooltip.Visible = false
				if isfile then
					if isfile(Path) then
						delfile(Path)
					end
				else
					pcall(delfile, Path)
				end
				local Index = table.find(TidalWave.Profiles, Properties.Name)
				if Index then
					table.remove(TidalWave.Profiles, Index)
				end
				for _, v in {Frame, Background, NameLabel, RenameTextBox, DeleteButton, DeleteButtonImage, Load, Save} do
					StopListeningObject(v)
					StopListeningFont(v)
				end
				Frame:Destroy()
			end)
		end,
		TextGUI = function(Properties)
			const TextGUI = {
				Sorting = 'Biggest',
				Text = `<font color = 'rgb(255, 215, 0)'>Tidal</font> <font color = 'rgb(20, 135, 255)'>Wave</font> v{TidalWave.Version}`,
				AnimationEnabled = true,
				AnimationDuration = 0.3,
				OutlineOffset = 1,
				Scale = 1,
				RightPadding = 8,
				LeftPadding = 4,
				Spacing = 0,
				LayoutPadding = 0,
				CornerRadius = 4,
				BackgroundTransparency = 0.5,
				BarThickness = 4,
				BackgroundEnabled = false,
				BarEnabled = true,
				TextShadow = true,
				WatermarkEnabled = true,
				ImageEnabled = false,
				Image = '',
				ImageWidth = 200,
				ImageHeight = 50,
				ImageRectEnabled = false,
				ImageRectOffsetX = 0,
				ImageRectOffsetY = 0,
				ImageRectSizeX = 200,
				ImageRectSizeY = 50,
				BackgroundColor = Color3.fromRGB(0, 0, 0),
				BarColor = Color3.fromRGB(0, 200, 255),
				TextColor = Color3.fromRGB(30, 150, 255),
				WatermarkTextColor = GetColor('Text/Primary'),
				WatermarkFont = GetFont('Bold'),
				Font = GetFont('Medium'),
				Alignment = 'Right',
				RGB = false,
				RGBText = false,
				RGBBackground = false,
				RGBBar = false,
				RGBWatermark = false,
				RGBImage = false,
				RGBGradient = false,
				RGBRefreshRate = 60,
				RGBSpeed = 1,
				RGBSpread = 1,
				RGBDirection = 'Down',
				RGBTextSaturation = 1,
				RGBTextValue = 1,
				RGBBackgroundSaturation = 1,
				RGBBackgroundValue = 1,
				RGBBarSaturation = 1,
				RGBBarValue = 1,
				RGBWatermarkSaturation = 1,
				RGBWatermarkValue = 1
			}
			
			const DefaultSize = UDim2.fromOffset(math.max(GetTextBounds(TextGUI.Text, 24, TextGUI.WatermarkFont).X, 300), 32)
			const TopBar = Instance.new('TextButton')
			TopBar.Name = 'TextGUI'
			TopBar.Size = DefaultSize
			TopBar.Position = UDim2.new(1, -DefaultSize.X.Offset - 7, 0, 7)
			TopBar.BackgroundTransparency = 1
			TopBar.Text = ''
			TopBar.Active = false
			TopBar.Interactable = false
			TopBar.Visible = false
			TopBar.Parent = HudFolder
			
			TextGUI.Object = TopBar
			
			const Layout = Instance.new('UIListLayout')
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = TopBar
			
			const WatermarkShadow = Instance.new('TextLabel')
			WatermarkShadow.Name = 'Watermark'
			WatermarkShadow.Size = DefaultSize
			WatermarkShadow.BackgroundTransparency = 1
			WatermarkShadow.Text = RemoveTags(TextGUI.Text)
			WatermarkShadow.TextColor3 = GetColor('Text/Shadow')
			WatermarkShadow.TextSize = 24
			WatermarkShadow.FontFace = TextGUI.WatermarkFont
			WatermarkShadow.RichText = true
			WatermarkShadow.TextXAlignment = Enum.TextXAlignment.Right
			WatermarkShadow.LayoutOrder = 1
			WatermarkShadow.Parent = TopBar
			
			const WatermarkShadowPadding = Instance.new('UIPadding')
			WatermarkShadowPadding.PaddingRight = UDim.new(0, 5)
			WatermarkShadowPadding.Parent = WatermarkShadow
			
			const Watermark = Instance.fromExisting(WatermarkShadow)
			Watermark.RichText = true
			Watermark.TextColor3 = GetColor('Text/Primary')
			Watermark.Size = UDim2.fromScale(1, 1)
			Watermark.Text = TextGUI.Text
			Watermark.Position = UDim2.fromOffset(-1, -1)
			Watermark.Parent = WatermarkShadow
			
			const WatermarkGradient = Instance.new('UIGradient')
			WatermarkGradient.Rotation = 90
			WatermarkGradient.Enabled = false
			WatermarkGradient.Parent = Watermark
			
			const Image = Instance.new('ImageLabel')
			Image.Size = UDim2.fromOffset(200, 50)
			Image.BackgroundTransparency = 1
			Image.Image = ''
			Image.Visible = false
			Image.LayoutOrder = 2
			Image.Parent = TopBar
			
			const ImageGradient = Instance.new('UIGradient')
			ImageGradient.Rotation = 90
			ImageGradient.Enabled = false
			ImageGradient.Parent = Image
			
			const Children = Instance.new('Frame')
			Children.Name = 'Children'
			Children.Size = UDim2.new(1, 0, 0, 0)
			Children.Position = UDim2.fromOffset(0, 32)
			Children.AutomaticSize = Enum.AutomaticSize.Y
			Children.BackgroundTransparency = 1
			Children.ClipsDescendants = true
			Children.Active = false
			Children.LayoutOrder = 3
			Children.Parent = TopBar
			
			const HorizontalTweens = {}
			const VerticalTweens = {}
			const Modules = {}
			
			local Info = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			
			const function GetFullText(Module)
				local Name = Module.Name
				local RichText
				local ExtraText = typeof(Module.ExtraText) == 'function' and Module.ExtraText() or Module.ExtraText
				if ExtraText then
					local Color = GetColor('Text/Secondary')
					RichText = `{Name} <font color = '#{Color:ToHex()}'>{ExtraText}</font>`
					Name ..= ' ' .. ExtraText
				end
				return Name, RichText
			end
			
			const function Sort()
				if TextGUI.Sorting == 'a-z' or TextGUI.Sorting == 'z-a' then
					table.sort(Modules, function(a, b)
						a = GetFullText(a):lower()
						b = GetFullText(b):lower()
						if TextGUI.Sorting == 'a-z' then
							return a < b
						else
							return a > b
						end
					end)
				else
					const Medium = GetFont('Medium')
					const Scale = TextGUI.Scale
			
					table.sort(Modules, function(a, b)
						const aText = GetFullText(a)
						const bText = GetFullText(b)
						a = GetTextBounds(aText, 16 * Scale, Medium).X
						b = GetTextBounds(bText, 16 * Scale, Medium).X
			
						if a == b then
							return aText:lower() < bText:lower()
						end
			
						if TextGUI.Sorting == 'Biggest' then
							return a > b
						else
							return a < b
						end
					end)
				end
			end
			
			const function UpdateCorners()
				const Length = #Modules
				for Index, CurrentModule in Modules do
					const NextModule = Modules[Index + 1]
					const NextModuleSize = NextModule and NextModule.Frame.Size.X.Offset or 0
			
					const CurrentModuleSize = CurrentModule.Frame.Size.X.Offset
			
					const Diff = CurrentModuleSize - NextModuleSize
					const AbsoluteDiff = math.min(math.abs(Diff), TextGUI.CornerRadius)
			
					const Corner = CurrentModule.Frame.TextShadow.UICorner
					const BarCorner = CurrentModule.Frame.Bar.UICorner
					const CornerRadius = UDim.new(0, AbsoluteDiff)
			
					Corner.CornerRadius = UDim.zero
					BarCorner.CornerRadius = UDim.zero
			
					if TextGUI.Sorting == 'a-z' or TextGUI.Sorting == 'z-a' then
						Corner[`Bottom{TextGUI.Alignment == 'Right' and 'Left' or 'Right'}Radius`] = Diff > 0 and CornerRadius or UDim.zero
			
						if Index ~= 1 then
							const LastModule = Modules[Index - 1]
							const LastModuleSize = LastModule and LastModule.Frame.Size.X.Offset or 0
							const Diff2 = LastModuleSize - CurrentModuleSize
							const AbsoluteDiff2 = math.min(math.abs(Diff2), TextGUI.CornerRadius)
			
							Corner[`Top{TextGUI.Alignment == 'Right' and 'Left' or 'Right'}Radius`] = Diff2 > 0 and UDim.new(0, AbsoluteDiff2) or UDim.zero
						end
					else
						Corner[`{TextGUI.Sorting == 'Biggest' and 'Bottom' or 'Top'}{TextGUI.Alignment == 'Right' and 'Left' or 'Right'}Radius`] = CornerRadius
					end
			
					if Index == 1 then
						Corner.TopLeftRadius = CornerRadius
						Corner.TopRightRadius = CornerRadius
						BarCorner[`Top{TextGUI.Alignment}Radius`] = CornerRadius
					end
					if Index == Length then
						Corner.BottomRightRadius = CornerRadius
						BarCorner[`Bottom{TextGUI.Alignment}Radius`] = CornerRadius
					end
				end
			end
			
			const function SetPadding(UIPadding)
				if TextGUI.Alignment == 'Right' then
					UIPadding.PaddingLeft = UDim.zero
					UIPadding.PaddingRight = UDim.new(0, TextGUI.RightPadding)
				else
					UIPadding.PaddingRight = UDim.zero
					UIPadding.PaddingLeft = UDim.new(0, TextGUI.RightPadding)
				end
			end
			
			const function UpdateBarThickness()
				for _, Module in Modules do
					const Text = GetFullText(Module)
					const TextWidth = GetTextBounds(Text, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
					const Height = 20 * TextGUI.Scale
					const Size = UDim2.fromOffset(TextWidth, Height)
					const BarSize = UDim2.fromOffset(TextGUI.BarThickness, Height)
					
					Module.Frame.Size = Size
					Module.Frame.Bar.Size = BarSize
				end
			end
			
			const function UpdateYPositions(NoTween)
				for i, v in Modules do
					const Height = 20 * TextGUI.Scale
					const Y = (Height + TextGUI.Spacing) * (i - 1)
					const Goal = UDim2.new(v.Frame.Position.X.Scale, v.Frame.Position.X.Offset, 0, Y)
					if NoTween or not TextGUI.AnimationEnabled then
						v.Frame.Position = Goal
					else
						const ExistingTween = VerticalTweens[v.Frame]
						if ExistingTween then
							ExistingTween:Cancel()
						end
			
						const NewTween = TweenService:Create(v.Frame, Info, {Position = Goal})
						NewTween:Play()
						NewTween.Completed:Once(function(State)
							if State == Enum.PlaybackState.Completed then
								VerticalTweens[v.Frame] = nil
							end
						end)
			
						VerticalTweens[v.Frame] = NewTween
					end
				end
			end
			
			const function UpdateExtraText(Module)
				const FullText, RichText = GetFullText(Module)
				const Width = GetTextBounds(FullText, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
				const Height = 20 * TextGUI.Scale
				const Size = UDim2.fromOffset(Width, Height)
			
				Module.Frame.Size = Size
				Module.Frame.TextShadow.Text = FullText
				Module.Frame.TextShadow.TextLabel.Text = RichText or FullText
			end
			
			const function Find(Frame)
				for i, v in Modules do
					if v.Frame == Frame then
						return i, v
					end
				end
				
				return nil
			end
			
			const function TweenModule(Frame)
				if TextGUI.AnimationEnabled then
					const NewTween = TweenService:Create(Frame, Info, {AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.xAxis or Vector2.zero})
					NewTween:Play()
					NewTween.Completed:Once(function(State)
						if State == Enum.PlaybackState.Completed then
							HorizontalTweens[Frame] = nil
						end
					end)
					
					HorizontalTweens[Frame] = NewTween
				else
					Frame.AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.xAxis or Vector2.zero
				end
			
				Sort()
				UpdateYPositions()
				UpdateCorners()
			end
			
			function TextGUI:AddModule(ModuleName, ExtraText)
				const ExistingModule = Children:FindFirstChild(ModuleName)
				if ExistingModule then
					const Tween = HorizontalTweens[ExistingModule]
					if Tween and Tween.Closing then
						Tween.Closing = false
			
						const Tab = {
							Frame = ExistingModule,
							Name = ModuleName,
							ExtraText = ExtraText
						}
			
						table.insert(Modules, Tab)
			
						Sort()
			
						TweenModule(ExistingModule)
					end
				else
					const Frame = Instance.new('Frame')
			
					const Tab = {
						Frame = Frame,
						Name = ModuleName,
						ExtraText = ExtraText
					}
			
					table.insert(Modules, Tab)
			
					Sort()
			
					const Index = Find(Frame)
			
					const Text, RichText = GetFullText(Tab)
					const Width = GetTextBounds(Text, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
					const Height = 20 * TextGUI.Scale
					const Size = UDim2.fromOffset(Width, Height)
					const Position = UDim2.new(TextGUI.Alignment == 'Right' and 1 or 0, 0, 0, (Height + TextGUI.Spacing) * (Index - 1))
					local AnchorPoint
			
					if TextGUI.AnimationEnabled then
						AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.zero or Vector2.xAxis
					else
						AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.xAxis or Vector2.zero
					end
			
					Frame.BackgroundTransparency = 1
					Frame.Size = Size
					Frame.Position = Position
					Frame.AnchorPoint = AnchorPoint
					Frame.Name = ModuleName
			
					const TextShadow = Instance.new('TextLabel')
					TextShadow.Name = 'TextShadow'
					TextShadow.Size = UDim2.fromScale(1, 1)
					TextShadow.BackgroundColor3 = TextGUI.RGB and TextGUI.RGBBackground and Color3.White or TextGUI.BackgroundColor
					TextShadow.BackgroundTransparency = TextGUI.BackgroundEnabled and TextGUI.BackgroundTransparency or 1
					TextShadow.BorderSizePixel = 0
					TextShadow.TextColor3 = GetColor('Text/Shadow')
					TextShadow.FontFace = TextGUI.Font
					TextShadow.TextSize = 16 * TextGUI.Scale
					TextShadow.Text = Text
					TextShadow.TextXAlignment = Enum.TextXAlignment[TextGUI.Alignment]
					TextShadow.Parent = Frame
			
					const Padding = Instance.new('UIPadding')
					if TextGUI.Alignment == 'Right' then
						Padding.PaddingRight = UDim.new(0, TextGUI.RightPadding)
					else
						Padding.PaddingLeft = UDim.new(0, TextGUI.RightPadding)
					end
					Padding.Parent = TextShadow
			
					const Corner = Instance.new('UICorner')
					Corner.CornerRadius = UDim.zero
					Corner.Parent = TextShadow
			
					const Gradient = Instance.new('UIGradient')
					Gradient.Rotation = 90
					Gradient.Enabled = TextGUI.RGB and TextGUI.RGBBackground
					Gradient.Parent = TextShadow
			
					const TextLabel = Instance.fromExisting(TextShadow)
					TextLabel.Name = 'TextLabel'
					TextLabel.TextColor3 = TextGUI.TextColor
					TextLabel.Position = UDim2.fromOffset(-TextGUI.OutlineOffset, -TextGUI.OutlineOffset)
					TextLabel.BackgroundTransparency = 1
					TextLabel.Text = RichText or Text
					TextLabel.RichText = true
					TextLabel.Parent = TextShadow
			
					const Bar = Instance.new('Frame')
					Bar.Name = 'Bar'
					Bar.BorderSizePixel = 0
					Bar.BackgroundColor3 = TextGUI.RGB and TextGUI.RGBBar and Color3.White or TextGUI.BarColor
					Bar.Size = UDim2.fromOffset(TextGUI.BarThickness, Height)
					Bar.Position = UDim2.fromScale(TextGUI.Alignment == 'Right' and 1 or 0, 0)
					Bar.AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.xAxis or Vector2.zero
					Bar.Visible = TextGUI.BarEnabled
					Bar.Parent = Frame
			
					const BarCorner = Instance.new('UICorner')
					BarCorner.CornerRadius = UDim.zero
					BarCorner.Parent = Bar
			
					const Gradient2 = Instance.new('UIGradient')
					Gradient2.Rotation = 90
					Gradient2.Enabled = TextGUI.RGB and TextGUI.RGBBar
					Gradient2.Parent = Bar
					
					Frame.Parent = Children
			
					TweenModule(Frame, Size)
				end
			end
			
			function TextGUI:RemoveModule(ModuleName)
				const ExistingModule = Children:FindFirstChild(ModuleName)
				if ExistingModule then
					if TextGUI.AnimationEnabled then
						const Tween = TweenService:Create(ExistingModule, Info, {AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.zero or Vector2.xAxis})
						Tween:Play()
						Tween.Completed:Once(function(State)
							if State == Enum.PlaybackState.Completed then
								HorizontalTweens[ExistingModule] = nil
								ExistingModule:Destroy()
							end
						end)
			
						HorizontalTweens[ExistingModule] = {
							Closing = true,
							Tween = Tween
						}
					else
						ExistingModule.AnchorPoint = TextGUI.Alignment == 'Right' and Vector2.zero or Vector2.xAxis
						ExistingModule:Destroy()
					end
			
					const Index = Find(ExistingModule)
					if Index then
						table.remove(Modules, Index)
					end
			
					UpdateYPositions()
					UpdateCorners()
				end
			end
			
			function TextGUI:SetWatermarkFont(Font)
				self.WatermarkFont = Font
				WatermarkShadow.FontFace = Font
				Watermark.FontFace = Font
			
				const Width = math.max(GetTextBounds(TextGUI.Text, 24 * TextGUI.Scale, TextGUI.Font).X, 300)
				const Height = 32 * TextGUI.Scale
				
				WatermarkShadow.Size = UDim2.fromOffset(Width, Height)
			end
			
			function TextGUI:SetFont(Font)
				self.Font = Font
				for i, Module in Modules do
					const Text = GetFullText(Module)
					const Width = GetTextBounds(Text, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
					Module.Frame.Size = UDim2.fromOffset(Width, 20 * TextGUI.Scale)
					Module.Frame.TextShadow.FontFace = Font
					Module.Frame.TextShadow.TextLabel.FontFace = Font
				end
			
				Sort()
				UpdateYPositions()
				UpdateCorners()
			end
			
			function TextGUI:SetAnimationEnabled(Enabled)
				self.AnimationEnabled = Enabled
			end
			
			function TextGUI:SetAnimationDuration(Duration)
				self.Duration = Duration
				Info = TweenInfo.new(Duration, Info.EasingStyle, Info.EasingDirection)
			end
			
			function TextGUI:SetWatermarkEnabled(Enabled)
				self.WatermarkEnabled = Enabled
				WatermarkShadow.Visible = Enabled
			end
			
			function TextGUI:SetImageEnabled(Enabled)
				self.ImageEnabled = Enabled
				Image.Visible = Enabled
			end
			
			function TextGUI:SetImage(Asset)
				self.Image = Asset
				Image.Image = Asset
			end
			
			function TextGUI:SetImageWidth(Width)
				self.ImageWidth = Width
				Image.Size = UDim2.fromOffset(Width, Image.Size.Y.Offset)
			end
			
			function TextGUI:SetImageHeight(Height)
				self.ImageHeight = Height
				Image.Size = UDim2.fromOffset(Image.Size.X.Offset, Height)
			end
			
			function TextGUI:SetImageOrder(Order)
				self.ImageOrder = Order
				Image.LayoutOrder = Order
			end
			
			function TextGUI:SetImageAlignment(Alignment)
				self.ImageAlignment = Alignment
				Layout.HorizontalAlignment = Enum.HorizontalAlignment[Alignment]
			end
			
			function TextGUI:SetLayoutPadding(Padding)
				self.LayoutPadding = Padding
				Layout.Padding = UDim.new(0, Padding)
			end
			
			function TextGUI:SetImageRectEnabled(Enabled)
				self.ImageRectEnabled = Enabled
			
				if Enabled then
					Image.ImageRectOffset = Vector2.new(self.ImageRectOffsetX, self.ImageRectOffsetY)
					Image.ImageRectSize = Vector2.new(self.ImageRectSizeX, self.ImageRectSizeY)
				else
					Image.ImageRectOffset = Vector2.zero
					Image.ImageRectSize = Vector2.zero
				end
			end
			
			function TextGUI:SetImageRectOffsetX(X)
				self.ImageRectOffsetX = X
				if self.ImageRectEnabled then
					Image.ImageRectOffset = Vector2.new(X, self.ImageRectOffsetY)
				end
			end
			
			function TextGUI:SetImageRectOffsetY(Y)
				self.ImageRectOffsetY = Y
				if self.ImageRectEnabled then
					Image.ImageRectOffset = Vector2.new(self.ImageRectOffsetX, Y)
				end
			end
			
			function TextGUI:SetImageRectSizeX(X)
				self.ImageRectSizeX = X
				if self.ImageRectEnabled then
					Image.ImageRectSize = Vector2.new(X, self.ImageRectSizeY)
				end
			end
			
			function TextGUI:SetImageRectSizeY(Y)
				self.ImageRectSizeY = Y
				if self.ImageRectEnabled then
					Image.ImageRectSize = Vector2.new(self.ImageRectSizeX, Y)
				end
			end
			
			function TextGUI:SetOutlineOffset(Offset)
				Watermark.Position = UDim2.fromOffset(-TextGUI.OutlineOffset, -TextGUI.OutlineOffset)
				TextGUI.OutlineOffset = Offset
			
				for i, Module in Modules do
					Module.Frame.TextShadow.TextLabel.Position = UDim2.fromOffset(-TextGUI.OutlineOffset, -TextGUI.OutlineOffset)
				end
			end
			
			function TextGUI:SetBarThickness(Thickness)
				TextGUI.BarThickness = Thickness
				UpdateBarThickness()
			end
			
			function TextGUI:SetCornerRadius(CornerRadius)
				TextGUI.CornerRadius = CornerRadius
				UpdateCorners()
			end
			
			function TextGUI:UpdateExtraText(Module)
				if Module then
					local FoundModule = Children:FindFirstChild(Module)
					if FoundModule then
						local _, Tab = Find(FoundModule)
						if Tab then
							UpdateExtraText(Tab)
						end
					end
				else
					for _, v in Modules do
						UpdateExtraText(v)
					end
				end
			
				Sort()
				UpdateYPositions()
				UpdateCorners()
			end
			
			local LastSize = TopBar.Size
			
			function TextGUI:SetScale(Scale)
				TextGUI.Scale = Scale
				local WatermarkWidth = math.max(GetTextBounds(TextGUI.Text, 24 * Scale, TextGUI.WatermarkFont).X, 300)
				local WatermarkSize = UDim2.fromOffset(WatermarkWidth, 32 * Scale)
				TopBar.Size = WatermarkSize
				WatermarkShadow.Size = WatermarkSize
				WatermarkShadow.TextSize = 24 * TextGUI.Scale
				Watermark.TextSize = 24 * TextGUI.Scale
			
				for i, Module in Modules do
					local Text = GetFullText(Module)
					local Width = GetTextBounds(Text, 16 * Scale, TextGUI.Font).X
					local Height = 20 * Scale
					local ModuleSize = UDim2.fromOffset(Width + TextGUI.RightPadding + TextGUI.LeftPadding, Height)
					Module.Frame.Size = ModuleSize
					Module.Frame.TextShadow.TextSize = 16 * Scale
					Module.Frame.TextShadow.TextLabel.TextSize = 16 * Scale
					Module.Frame.Position = UDim2.fromOffset(TextGUI.Alignment == 'Right' and WatermarkSize.X.Offset or 0, (Height + TextGUI.Spacing) * (i - 1))
					Module.Frame.Bar.Size = UDim2.fromOffset(TextGUI.BarThickness, Height)
				end
			
				local Diff = TopBar.Size - LastSize
				
				TopBar.Position -= UDim2.new(Diff.X.Scale / 2, Diff.X.Offset / 2, Diff.Y.Scale / 2, Diff.Y.Offset / 2)
				LastSize = TopBar.Size
			
				Sort()
				UpdateYPositions()
				UpdateCorners()
			end
			
			function TextGUI:SetWatermarkText(Text)
				TextGUI.Text = Text
				local Width = math.max(GetTextBounds(Text, 24 * TextGUI.Scale, TextGUI.WatermarkFont).X, 300)
				local TextBounds = UDim2.fromOffset(Width, 32 * TextGUI.Scale)
				WatermarkShadow.Size = TextBounds
			
				if TextGUI.TextShadow then
					WatermarkShadow.Text = RemoveTags(Text)
					Watermark.Text = Text
				else
					WatermarkShadow.Text = Text
				end
			end
			
			function TextGUI:SetWatermarkTextShadowEnabled(Enabled)
				TextGUI.TextShadow = Enabled
				Watermark.Visible = Enabled
				WatermarkShadow.RichText = not Enabled
				WatermarkShadow.TextColor3 = Enabled and GetColor('Text/Shadow') or TextGUI.WatermarkTextColor
			end
			
			function TextGUI:SetSpacing(Spacing)
				TextGUI.Spacing = Spacing
				UpdateYPositions(true)
			end
			
			function TextGUI:SetRightPadding(Padding)
				TextGUI.RightPadding = Padding
			
				for i, Module in Modules do
					local Text = GetFullText(Module)
					local Height = 20 * TextGUI.Scale
					local Width = GetTextBounds(Text, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
					local Size = UDim2.fromOffset(Width, Height)
					Module.Frame.Size = Size
					SetPadding(Module.Frame.TextShadow.UIPadding)
				end
			end
			
			function TextGUI:SetLeftPadding(Padding)
				TextGUI.LeftPadding = Padding
			
				for i, Module in Modules do
					local Text = GetFullText(Module)
					local Height = 20 * TextGUI.Scale
					local Width = GetTextBounds(Text, 16 * TextGUI.Scale, TextGUI.Font).X + TextGUI.RightPadding + TextGUI.LeftPadding
					local Size = UDim2.fromOffset(Width, Height)
					Module.Frame.Size = Size
					Module.Frame.TextShadow.UIPadding[`Padding{TextGUI.Alignment == 'Right' and 'Left' or 'Right'}`] = UDim.new(0, TextGUI.RightPadding)
					Module.Frame.TextShadow.UIPadding[`Padding{TextGUI.Alignment}`] = UDim.new(0, TextGUI.RightPadding)
				end
			end
			
			function TextGUI:SetAlignment(Alignment)
				TextGUI.Alignment = Alignment
				WatermarkShadow.TextXAlignment = Enum.TextXAlignment[Alignment]
				Watermark.TextXAlignment = WatermarkShadow.TextXAlignment
				WatermarkShadowPadding.PaddingRight = UDim.zero
				WatermarkShadowPadding.PaddingLeft = UDim.zero
			
				if Alignment == 'Left' then
					WatermarkShadowPadding.PaddingLeft = UDim.new(0, 5)
				elseif Alignment == 'Right' then
					WatermarkShadowPadding.PaddingRight = UDim.new(0, 5)
				end
			
				for i, Module in Modules do
					local Height = (20 * TextGUI.Scale)
					local FrameX = Alignment == 'Right' and TopBar.Size.X.Offset or 0
					local FrameY = (Height + TextGUI.Spacing) * (i - 1)
					local AnchorPoint = Alignment == 'Right' and Vector2.xAxis or Vector2.zero
			
					Module.Frame.Position = UDim2.fromOffset(FrameX, FrameY)
					Module.Frame.AnchorPoint = AnchorPoint
					Module.Frame.Bar.Position = UDim2.fromScale(Alignment == 'Right' and 1 or 0, 0)
					Module.Frame.Bar.AnchorPoint = AnchorPoint
					Module.Frame.TextShadow.TextXAlignment = Enum.TextXAlignment[Alignment]
					Module.Frame.TextShadow.TextLabel.TextXAlignment = Enum.TextXAlignment[Alignment]
			
					SetPadding(Module.Frame.TextShadow.UIPadding)
				end
			
				UpdateCorners()
			end
			
			function TextGUI:SetBackgroundEnabled(Enabled)
				TextGUI.BackgroundEnabled = Enabled
				for _, v in Modules do
					v.Frame.TextShadow.BackgroundTransparency = Enabled and TextGUI.BackgroundTransparency or 1
				end
			end
			
			function TextGUI:SetBackgroundTransparency(Transparency)
				TextGUI.BackgroundTransparency = Transparency
				for _, v in Modules do
					v.Frame.TextShadow.BackgroundTransparency = TextGUI.BackgroundEnabled and Transparency or 1
				end
			end
			
			function TextGUI:SetBarEnabled(Enabled)
				TextGUI.BarEnabled = Enabled
				for _, v in Modules do
					v.Frame.Bar.Visible = Enabled
				end
			end
			
			function TextGUI:SetBarColor(Color)
				TextGUI.BarColor = Color
				if TextGUI.RGB and TextGUI.RGBBar then return end
				for _, v in Modules do
					v.Frame.Bar.BackgroundColor3 = Color
				end
			end
			
			function TextGUI:SetBackgroundColor(Color)
				TextGUI.BackgroundColor = Color
				if TextGUI.RGB and TextGUI.RGBBackground then return end
				for _, v in Modules do
					v.Frame.TextShadow.BackgroundColor3 = Color
				end
			end
			
			function TextGUI:SetTextColor(Color)
				TextGUI.TextColor = Color
				if TextGUI.RGB and TextGUI.RGBText then return end
				for _, v in Modules do
					v.Frame.TextShadow.TextLabel.TextColor3 = Color
				end
			end
			
			function TextGUI:SetWatermarkTextColor(Color)
				TextGUI.WatermarkTextColor = Color
				if TextGUI.RGB and TextGUI.RGBWatermark then return end
				Watermark.TextColor3 = Color
			end
			
			function TextGUI:SetRGBImageEnabled(Enabled)
				TextGUI.RGBImage = Enabled
				ImageGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBGradient
			end
			
			function TextGUI:SetSortingMethod(Method)
				TextGUI.Sorting = Method
				Sort()
				UpdateYPositions(true)
				UpdateCorners()
			end
			
			local Thread
			
			function TextGUI:SetRGBEnabled(Enabled)
				TextGUI.RGB = Enabled
				if Thread then
					pcall(task.cancel, Thread)
					Thread = nil
				end
			
				for _, Module in Modules do
					Module.Frame.TextShadow.UIGradient.Enabled = Enabled and TextGUI.RGBBackground and TextGUI.RGBGradient
					Module.Frame.TextShadow.BackgroundColor3 = Enabled and TextGUI.RGBBackground and TextGUI.RGBGradient and Color3.White or TextGUI.BackgroundColor
					Module.Frame.Bar.UIGradient.Enabled = Enabled and TextGUI.RGBBar and TextGUI.RGBGradient
					Module.Frame.Bar.BackgroundColor3 = Enabled and TextGUI.RGBBar and TextGUI.RGBGradient and Color3.White or TextGUI.BarColor
				end
			
				WatermarkGradient.Enabled = Enabled and TextGUI.RGBWatermark and TextGUI.RGBGradient
				Watermark.TextColor3 = Enabled and TextGUI.RGBWatermark and TextGUI.RGBGradient and Color3.White or TextGUI.WatermarkTextColor
				ImageGradient.Enabled = Enabled and TextGUI.RGBImage and TextGUI.RGBGradient
			
				if Enabled then
					Thread = task.spawn(function()
						while TextGUI.RGB do
							local Len = #Modules
							if Len == 0 then
								task.wait()
								continue
							end
			
							const Tick = (os.clock() * (TextGUI.RGBSpeed / 5)) % 1
							const Spread = TextGUI.RGBSpread * 5
							const Down = TextGUI.RGBDirection == 'Down'
							local IndexOffset = 0
			
							if TextGUI.RGBWatermark then
								Len += 1
								IndexOffset += 1
								const Alpha = (IndexOffset / Len) / Spread
								const Hue = (Tick - (Down and Alpha or -Alpha)) % 1
								const Sat = TextGUI.RGBWatermarkSaturation
								const Val = TextGUI.RGBWatermarkSaturation
								const Color = Color3.fromHSV(Hue, Sat, Val)
								
								if TextGUI.RGBGradient then
									const NextOffset = ((IndexOffset + 1) / Len) / Spread
									const NextHue = (Tick - (Down and NextOffset or -NextOffset)) % 1
									const GoalColor = Color3.fromHSV(NextHue, Sat, Val)
									WatermarkGradient.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color),
										ColorSequenceKeypoint.new(1, GoalColor)
									})
								else
									Watermark.TextColor3 = Color
								end
							end
			
							if TextGUI.RGBImage then
								Len += 1
								IndexOffset += 1
			
								const Alpha = (IndexOffset / Len) / Spread
								const Hue = (Tick - (Down and Alpha or -Alpha)) % 1
								const Sat = TextGUI.RGBWatermarkSaturation
								const Val = TextGUI.RGBWatermarkSaturation
								local Color = Color3.fromHSV(Hue, Sat, Val)
								
								if TextGUI.RGBGradient then
									local NextOffset = (2 / Len) / Spread
									local NextHue = (Tick - (Down and NextOffset or -NextOffset)) % 1
									local GoalColor = Color3.fromHSV(NextHue, Sat, Val)
									ImageGradient.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color),
										ColorSequenceKeypoint.new(1, GoalColor)
									})
								else
									Image.ImageColor3 = Color
								end
							end
			
							for i, Module in Modules do
								if Module.Frame.Parent == nil then continue end

								i += IndexOffset
								
								const Offset = (i / Len) / Spread
								const Hue = (Tick - (Down and Offset or -Offset)) % 1
								
								if TextGUI.RGBText then
									Module.Frame.TextShadow.TextLabel.TextColor3 = Color3.fromHSV(Hue, TextGUI.RGBTextSaturation, TextGUI.RGBTextValue)
								end

								if TextGUI.RGBBackground or TextGUI.RGBBar then
									const NextOffset = ((i + 1) / Len) / Spread
									const NextHue = (Tick - (Down and NextOffset or -NextOffset)) % 1
			
									if TextGUI.RGBBackground then
										const BackgroundSaturation = TextGUI.RGBBackgroundSaturation
										const BackgroundValue = TextGUI.RGBBackgroundValue
										if TextGUI.RGBGradient then
											const Color = Color3.fromHSV(Hue, BackgroundSaturation, BackgroundValue)
											const GoalColor = Color3.fromHSV(NextHue, BackgroundSaturation, BackgroundValue)
			
											Module.Frame.TextShadow.UIGradient.Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, Color),
												ColorSequenceKeypoint.new(1, GoalColor)
											})
										else
											Module.Frame.TextShadow.BackgroundColor3 = Color3.fromHSV(Hue, BackgroundSaturation, BackgroundValue)
										end
									end
									
									if TextGUI.RGBBar then
										const BarSaturation = TextGUI.RGBBarSaturation
										const BarValue = TextGUI.RGBBarValue
										if TextGUI.RGBGradient then
											const Color = Color3.fromHSV(Hue, BarSaturation, BarValue)
											const GoalColor = Color3.fromHSV(NextHue, BarSaturation, BarValue)
			
											Module.Frame.Bar.UIGradient.Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, Color),
												ColorSequenceKeypoint.new(1, GoalColor)
											})
										else
											Module.Frame.Bar.BackgroundColor3 = Color3.fromHSV(Hue, BarSaturation, BarValue)
										end
									end
								end
							end
			
							task.wait(1 / TextGUI.RGBRefreshRate)
						end
					end)
				else
					TextGUI:SetTextColor(TextGUI.TextColor)
					TextGUI:SetBackgroundColor(TextGUI.BackgroundColor)
					TextGUI:SetBarColor(TextGUI.BarColor)
				end
			end
			
			TidalWave:Clean(function()
				if Thread then
					pcall(task.cancel, Thread)
					Thread = nil
				end
			end)
			
			function TextGUI:SetRGBTextEnabled(Enabled)
				TextGUI.RGBText = Enabled
				if TextGUI.RGB and not Enabled then
					for _, Module in Modules do
						Module.Frame.TextShadow.TextLabel.TextColor3 = TextGUI.TextColor
					end
				end
			end
			
			function TextGUI:SetRGBSpeed(Speed)
				TextGUI.RGBSpeed = Speed
			end
			
			function TextGUI:SetRGBSpread(Speed)
				TextGUI.RGBSpread = Speed
			end
			
			function TextGUI:SetRGBDirection(Direction)
				TextGUI.RGBDirection = Direction
			end
			
			function TextGUI:SetRGBRefreshRate(Rate)
				TextGUI.RGBRefreshRate = Rate
			end
			
			function TextGUI:SetRGBBackgroundEnabled(Enabled)
				TextGUI.RGBBackground = Enabled
				for i, Module in Modules do
					Module.Frame.TextShadow.UIGradient.Enabled = Enabled and TextGUI.RGB
					Module.Frame.TextShadow.BackgroundColor3 = Enabled and TextGUI.RGB and Color3.White or TextGUI.BackgroundColor
				end
			end
			
			function TextGUI:SetRGBTextSaturation(Saturation)
				TextGUI.RGBTextSaturation = Saturation
			end
			
			function TextGUI:SetRGBTextValue(Value)
				TextGUI.RGBTextValue = Value
			end
			
			function TextGUI:SetRGBBackgroundSaturation(Saturation)
				TextGUI.RGBBackgroundSaturation = Saturation
			end
			
			function TextGUI:SetRGBBackgroundValue(Value)
				TextGUI.RGBBackgroundValue = Value
			end
			
			function TextGUI:SetRGBBarEnabled(Enabled)
				TextGUI.RGBBar = Enabled
				for i, Module in Modules do
					Module.Frame.Bar.UIGradient.Enabled = Enabled and TextGUI.RGB
					Module.Frame.Bar.BackgroundColor3 = Enabled and TextGUI.RGB and Color3.White or TextGUI.BarColor
				end
			end
			
			function TextGUI:SetRGBBarSaturation(Saturation)
				TextGUI.RGBBarSaturation = Saturation
			end
			
			function TextGUI:SetRGBBarValue(Value)
				TextGUI.RGBarValue = Value
			end
			
			function TextGUI:SetRGBWatermarkEnabled(Enabled)
				TextGUI.RGBWatermark = Enabled
				Watermark.Text = Enabled and `Tidal Wave v{TidalWave.Version}` or TextGUI.Text
				WatermarkGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBGradient
				Watermark.TextColor3 = Enabled and TextGUI.RGB and TextGUI.RGBGradient and Color3.White or TextGUI.WatermarkTextColor
			end
			
			function TextGUI:SetRGBWatermarkSaturation(Sat)
				TextGUI.RGBWatermarkSaturation = Sat
			end
			
			function TextGUI:SetRGBWatermarkValue(Value)
				TextGUI.RGBwatermarkValue = Value
			end
			
			function TextGUI:SetRGBGradientEnabled(Enabled)
				TextGUI.RGBGradient = Enabled
				for _, Module in Modules do
					Module.Frame.TextShadow.UIGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBBackground
					Module.Frame.TextShadow.BackgroundColor3 = Enabled and TextGUI.RGB and TextGUI.RGBBackground and Color3.White or TextGUI.BackgroundColor
					Module.Frame.Bar.UIGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBBar
					Module.Frame.Bar.BackgroundColor3 = Enabled and TextGUI.RGB and TextGUI.RGBBar and Color3.White or TextGUI.BarColor
				end
				WatermarkGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBWatermark
				Watermark.TextColor3 = Enabled and TextGUI.RGB and TextGUI.RGBWatermark and Color3.White or TextGUI.WatermarkTextColor
				ImageGradient.Enabled = Enabled and TextGUI.RGB and TextGUI.RGBImage
			end
			
			return TextGUI
		end,
		ThemesDropdown = function(Properties)
			local Dropdown = {
				Value = Properties.List[1],
				List = Properties.List,
				Visible = if Properties.Visible ~= nil then Properties.Visible else true,
				Expanded = false
			}

			const Name = Properties.Name
			const SubbedName = Name:gsub(' ', '')
			
			local Frame = Instance.new('Frame')
			Frame.Name = `{SubbedName}Dropdown`
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, -100, 0, 40)
			Frame.LayoutOrder = Properties.LayoutOrder
			Frame.Parent = Properties.Parent
			
			local Background = Instance.new('Frame')
			Background.Name = 'Background'
			Background.BackgroundColor3 = GetColor('Background/Button')
			Background.BorderSizePixel = 0
			Background.Size = UDim2.new(1, -45, 1, 0)
			Background.Parent = Frame
			AddCorner(Background, UDim.new(0, 7))
			ListenObject(Background, 'Background/Button')
			
			local TextLabel = Instance.new('TextLabel')
			TextLabel.TextColor3 = GetColor('Text/Primary')
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.fromOffset(5, 0)
			TextLabel.Size = UDim2.new(0, 200, 1, 0)
			TextLabel.FontFace = GetFont('Regular')
			TextLabel.TextSize = 24
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Text = Name
			TextLabel.Parent = Background
			ListenObject(TextLabel, 'Text/Primary')
			ListenFont(TextLabel, 'Regular')
			
			local TopBar = Instance.new('TextButton')
			TopBar.BackgroundColor3 = GetColor('Background/Secondary')
			TopBar.Name = 'TopBar'
			TopBar.BorderSizePixel = 0
			TopBar.Size = UDim2.fromOffset(240, 30)
			TopBar.Position = UDim2.fromOffset(310, 5)
			TopBar.AutoButtonColor = false
			TopBar.Text = ''
			TopBar.Parent = Background
			AddTooltip(TopBar, Properties.Tooltip or Properties.Info)
			ListenObject(TopBar, 'Background/Secondary', 'Text/Primary')
			ListenFont(TopBar, 'Regular')
			
			local Corner = Instance.new('UICorner')
			Corner.CornerRadius = UDim.new(0, 7)
			Corner.Parent = TopBar

			local TopBarLabel = Instance.new('TextLabel')
			TopBarLabel.BackgroundTransparency = 1
			TopBarLabel.Name = 'TopBarLabel'
			TopBarLabel.Size = UDim2.fromScale(1, 1)
			TopBarLabel.Position = UDim2.fromOffset(10, 0)
			TopBarLabel.FontFace = GetFont('Regular')
			TopBarLabel.TextColor3 = GetColor('Text/Primary')
			TopBarLabel.TextSize = 24
			TopBarLabel.TextXAlignment = Enum.TextXAlignment.Left
			TopBarLabel.Text = Dropdown.Value
			TopBarLabel.Parent = TopBar
			
			local Arrow = Instance.new('TextButton')
			Arrow.Name = 'Arrow'
			Arrow.Size = UDim2.fromOffset(30, 30)
			Arrow.Position = UDim2.new(1, -30, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = ''
			Arrow.Rotation = -90
			Arrow.Parent = TopBar
			AddCorner(Arrow, UDim.new(0, 7))
			
			local ArrowImage = Instance.new('ImageLabel')
			ArrowImage.Name = 'Image'
			ArrowImage.Size = UDim2.fromOffset(30, 30)
			ArrowImage.BackgroundTransparency = 1
			SetIcon(ArrowImage, 'chevron-down')
			ArrowImage.Parent = Arrow
			
			local Children = Instance.new('ScrollingFrame')
			Children.Name = 'Children'
			Children.Size = UDim2.fromScale(1, 0)
			Children.Position = UDim2.fromScale(0, 1)
			Children.BackgroundColor3 = GetColor('Background/Secondary')
			Children.CanvasSize = UDim2.zero
			Children.ScrollBarThickness = 0
			Children.ScrollBarImageTransparency = 1
			Children.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			Children.Active = true
			Children.ZIndex = 2
			Children.Visible = false
			Children.Parent = TopBar
			ListenObject(Children, 'Background/Secondary')
			
			local ChildrenCorner = Instance.new('UICorner')
			ChildrenCorner.CornerRadius = UDim.new(0, 0)
			ChildrenCorner.BottomLeftRadius = UDim.new(0, 7)
			ChildrenCorner.BottomRightRadius = UDim.new(0, 7)
			ChildrenCorner.Parent = Children
			
			local Padding = Instance.new('UIPadding')
			Padding.PaddingTop = UDim.new(0, 10)
			Padding.PaddingBottom = UDim.new(0, 10)
			Padding.Parent = Children
			
			local Layout = Instance.new('UIListLayout')
			Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Layout.Padding = UDim.new(0, 5)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = Children

			const function GetChildrenHeight()
				return math.min((Layout.AbsoluteContentSize.Y / GuiScale.Scale) + 16, 220)
			end
			
			const function GetContentHeight()
				return (Layout.AbsoluteContentSize.Y / GuiScale.Scale) + 16
			end
			
			Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Children.CanvasSize = UDim2.new(1, 0, 0, GetContentHeight())
			end)
			
			local Info = TweenInfo.new(0.2)
			local Tween, ArrowTween
			local CreatedButtons = {}
			
			function Dropdown:SetValue(Val)
				Dropdown.Value = Val
				TopBarLabel.Text = Val
				if Properties.Function then
					Properties.Function(Val)
				end
			end
			
			function Dropdown:Remove(Value)
				local Index = table.find(Dropdown.List, Value)
				if Index then
					table.remove(Dropdown.List, Index)
				end
			end
			
			function Dropdown:Add(Value)
				if not table.find(Dropdown.List, Value) then
					table.insert(self.List, Value)
				end
			end
			
			local PlusButton = Instance.new('TextButton')
			PlusButton.Name = 'Plus'
			PlusButton.BackgroundColor3 = GetColor('Background/Button')
			PlusButton.Text = ''
			PlusButton.BorderSizePixel = 0
			PlusButton.Size = UDim2.fromOffset(32, 32)
			PlusButton.AutoButtonColor = false
			PlusButton.LayoutOrder = 69420
			PlusButton.ZIndex = 2
			PlusButton.Parent = Children
			AddCorner(PlusButton, UDim.new(0, 7))
			AddHighlight(PlusButton)
			ListenObject(PlusButton, 'Background/Button')
			
			local PlusImage = Instance.new('ImageLabel')
			PlusImage.Name = 'Image'
			PlusImage.BackgroundTransparency = 1
			PlusImage.Size = UDim2.fromOffset(24, 24)
			PlusImage.Position = UDim2.fromOffset(4, 4)
			PlusImage.ZIndex = 2
			SetIcon(PlusImage, 'plus')
			PlusImage.Parent = PlusButton
			ListenObject(PlusImage, 'Main/Icons')
			
			PlusButton.MouseButton1Click:Connect(function()
				Dropdown:CreateButton({
					Name = 'new theme',
					New = true,
					CanEdit = true,
					LayoutOrder = #CreatedButtons + 1,
				})
			end)
			
			function Dropdown:CreateButton(Properties)
				while table.find(self.List, Properties.Name) do
					Properties.Name ..= ' 2'
				end
				
				local Button = Instance.new('TextButton')
				Button.Size = UDim2.fromOffset(220, 30)
				Button.BackgroundColor3 = GetColor('Background/Button')
				Button.TextColor3 = GetColor('Text/Primary')
				Button.FontFace = GetFont('Regular')
				Button.TextSize = 20
				Button.Text = Properties.Name
				Button.LayoutOrder = Properties.LayoutOrder or 0
				Button.ZIndex = 2
				Button.BorderSizePixel = 0
				Button.AutoButtonColor = false
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = Children
				AddCorner(Button, UDim.new(0, 7))
				AddHighlight(Button)
				AddTooltip(Button, Properties.CanEdit and 'Left Click to select.\nRight Click to rename.' or 'Left Click to select.')
				ListenObject(Button, 'Background/Button', 'Text/Primary')
				ListenFont(Button, 'Regular')

				const Padding = Instance.new('UIPadding')
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.Parent = Button
			
				if Properties.CanEdit then
					local Delete = Instance.new('TextButton')
					Delete.Name = 'Delete'
					Delete.BackgroundTransparency = 1
					Delete.Size = UDim2.fromOffset(30, 30)
					Delete.Position = UDim2.new(1, -30, 0, 0)
					Delete.ZIndex = 2
					Delete.Text = ''
					Delete.Parent = Button
			
					local Image = Instance.new('ImageLabel')
					Image.Name = 'Image'
					Image.BackgroundTransparency = 1
					Image.Size = UDim2.fromOffset(24, 24)
					Image.Position = UDim2.fromOffset(3, 3)
					Image.ZIndex = 2
					SetIcon(Image, 'x')
					Image.Parent = Delete
					ListenObject(Image, 'Main/Icons')
			
					local RenameTextBox = Instance.new('TextBox')
					RenameTextBox.Name = 'Rename'
					RenameTextBox.BackgroundTransparency = 1
					RenameTextBox.Size = UDim2.fromOffset(220, 30)
					RenameTextBox.Position = UDim2.fromOffset(10, 0)
					RenameTextBox.TextSize = 20
					RenameTextBox.TextColor3 = GetColor('Text/Primary')
					RenameTextBox.FontFace = GetFont('Regular')
					RenameTextBox.ClearTextOnFocus = false
					RenameTextBox.TextXAlignment = Enum.TextXAlignment.Left
					RenameTextBox.Visible = false
					RenameTextBox.ZIndex = 2
					RenameTextBox.Parent = Button
					ListenObject(RenameTextBox, 'Text/Primary')
					ListenFont(RenameTextBox, 'Regular')
			
					Delete.MouseButton1Click:Connect(function()
						Tooltip.Visible = false
						Dropdown:Remove(Properties.Name)
						local Index = table.find(CreatedButtons, Button)
						if Index then
							table.remove(CreatedButtons, Index)
						end
						for _, v in {Button, Delete, Image, RenameTextBox} do
							StopListeningObject(v)
							StopListeningFont(v)
						end
						Button:Destroy()
						TidalWave.Themes[Properties.Name] = nil
						Dropdown:SetValue('TidalWave')
					end)
			
					local function Select()
						Button.TextTransparency = 1
						RenameTextBox.Text = Properties.Name
						RenameTextBox.Visible = true
						RenameTextBox:CaptureFocus()
						RenameTextBox.SelectionStart = 0
						RenameTextBox.CursorPosition = #RenameTextBox.Text + 1
						RenameTextBox.FocusLost:Once(function()
							local OldName, NewName = Properties.Name, RenameTextBox.Text
							Dropdown:Remove(OldName)
							Dropdown:Add(NewName)
							Dropdown:SetValue(NewName)
							RenameTextBox.Visible = false
							Button.Text = NewName
							Button.TextTransparency = 0
							Properties.Name = NewName
						end)
					end
			
					if Properties.New then
						Select()
					else
						Dropdown:Add(Properties.Name)
					end
			
					Button.MouseButton2Click:Connect(Select)
				end
			
				Button.MouseButton1Click:Connect(function()
					Dropdown:SetValue(Properties.Name)
				end)
			
				table.insert(CreatedButtons, Button)
			end
			
			function Dropdown:Expand()
				self.Expanded = not self.Expanded

				if Tween then
					Tween:Cancel()
				end
				if ArrowTween then
					ArrowTween:Cancel()
				end
				
				ArrowTween = TweenService:Create(Arrow, Info, {Rotation = self.Expanded and 0 or -90})

				if self.Expanded then
					if #CreatedButtons == 0 then
						for i, v in Dropdown.List do
							Dropdown:CreateButton({
								Name = v,
								CanEdit = not BuiltInThemes[v],
								LayoutOrder = i,
							})
						end
					end

					Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, GetChildrenHeight())})
					Children.Visible = true
					Corner.CornerRadius = UDim.new(0, 0)
					Corner.TopLeftRadius = UDim.new(0, 7)
					Corner.TopRightRadius = UDim.new(0, 7)
				else
					Tween = TweenService:Create(Children, Info, {Size = UDim2.new(1, 0, 0, 0)})
					Tween.Completed:Once(function(State)
						if State == Enum.PlaybackState.Completed then
							Corner.CornerRadius = UDim.new(0, 7)
							Children.Visible = false
							for _, v in CreatedButtons do
								for _, v2 in v:GetDescendants() do
									StopListeningObject(v2)
								end
								v:Destroy()
							end
							table.clear(CreatedButtons)
						end
					end)
				end

				Tween:Play()
				ArrowTween:Play()
			end
			
			function Dropdown:Save(Tab)
				Tab[Name] = {
					List = self.List,
					Value = self.Value
				}
			end
			
			function Dropdown:Load(Tab)
				self.List = Tab.List
				Dropdown:SetValue(Tab.Value)
				if self.Expanded then
					for _, v in CreatedButtons do
						for _, v2 in v:GetDescendants() do
							StopListeningObject(v2)
						end
						v:Destroy()
					end
					table.clear(CreatedButtons)
					for i, v in Dropdown.List do
						Dropdown:CreateButton({
							Name = v,
							CanDelete = not BuiltInThemes[v],
							LayoutOrder = i,
						})
					end
				end
			end
			
			function Dropdown:SetVisible(Visible)
				Dropdown.Visible = Visible
				Frame.Visible = Dropdown.Visible
			end

			const function Expand()
				Dropdown:Expand()
			end
			
			Arrow.MouseButton1Click:Connect(Expand)
			Arrow.MouseButton2Click:Connect(Expand)
			TopBar.MouseButton1Click:Connect(Expand)
			TopBar.MouseButton2Click:Connect(Expand)

			Components.Options.Reset({
				Parent = Frame,
				Function = function()
					Dropdown:SetValue('TidalWave')
				end
			})
			
			Dropdown.Object = Frame
			
			GuiMenu.Options[Name] = Dropdown
			
			return Dropdown
		end,
	},
}

TidalWave:Init()

return TidalWave