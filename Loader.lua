if not game:IsLoaded() then game.Loaded:Wait() end

if shared.TidalWave then
    shared.TidalWave:Shutdown()
end

if shared.TidalWaveLoader then return end
shared.TidalWaveLoader = Instance.new('ScreenGui')

const Start = os.clock()
const cloneref = cloneref or function(Obj) return Obj end

const function GetService(Service)
    return cloneref(game:GetService(Service))
end

const RunService: RunService = GetService('RunService')
const CoreGui: CoreGui = GetService('CoreGui')
const Players: Players = GetService('Players')
const TweenService: TweenService = GetService('TweenService')

const Plr = Players.LocalPlayer
const IsStudio = RunService:IsStudio()

const gethui = gethui or function() return (CoreGui and CoreGui:FindFirstChild('RobloxGui')) or CoreGui or Plr:FindFirstChildOfClass('PlayerGui') end
const getcustomasset = getcustomasset or function(Path) return `rbxasset://{Path}` end
local writefile, makefolder, isfolder, isfile, readfile, listfiles, delfile = writefile, makefolder, isfolder or function(s) return false end, isfile or function(s) return false end, readfile, listfiles, delfile

const RootPath = IsStudio and script.Parent or nil
local Gui = 'TidalWave'
local SupportedGame
local Commit = 'main'

if IsStudio then
	shared.RootPath = RootPath

    const FileSystem = require(RootPath.Libraries.FileSystem)
    writefile, makefolder, isfile, isfolder, readfile = FileSystem.writefile, FileSystem.makefolder, FileSystem.isfile, FileSystem.isfolder, FileSystem.readfile
end

const function DownloadFile(Path, Function)
	if not isfile(Path) then
		const Success, Result = pcall(function()
			return game:HttpGet(`https://raw.githubusercontent.com/fluidnarrator30/Tidal-Wave/{Commit}/{Path}`, true)
		end)
        if Success and Result ~= '404: Not Found' then
            writefile(Path, Result)
        end
	end
    
    return (Function or readfile)(`TidalWave/{Path}`)
end

const function WipeFolder(Path)
	if not isfolder(Path) then return end
	for _, File in listfiles(Path) do
		if isfile(File) then
			delfile(File)
		end
	end
end

local LoadingScreen, TidalWave

const function Error(Msg, Name, Er)
    if TidalWave then
        TidalWave:Notify({
            Text = `{Msg}\nCheck logs for more info.`,
            Type = 'Error',
            Duration = 5
        })
    end
    LoadingScreen:Destroy()
    warn(`[TidalWave]: Failed to load '{Name}': {Er}`)
end

const function AddCorner(Obj, CornerRadius)
    const Corner = Instance.new('UICorner')
    Corner.CornerRadius = CornerRadius
    Corner.Parent = Obj
end

for _, v in {'TidalWave', 'TidalWave/Games', 'TidalWave/Guis', 'TidalWave/Libraries', 'TidalWave/Profiles', 'TidalWave/Assets'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

if isfile('TidalWave/Profiles/Gui.txt') then
    Gui = readfile('TidalWave/Profiles/Gui.txt')
else
    writefile('TidalWave/Profiles/Gui.txt', Gui)
end

if not IsStudio then
    if shared.TidalWaveDev then
        SupportedGame = isfile(`TidalWave/Games/{game.PlaceId}.lua`) and readfile(`TidalWave/Games/{game.PlaceId}.lua`) or nil
    else
        const Success, GitHub = pcall(function()
            return game:HttpGet('https://github.com/fluidnarrator30/Tidal-Wave')
        end)

        const Index = Success and GitHub and GitHub:find('currentOid')
        if Index then
            const Subbed = GitHub:sub(Index + 13, Index + 52)
            if #Subbed == 40 then
                Commit = Subbed
            end
        end

        if Commit == 'main' or (isfile('TidalWave/Profiles/Commit.txt') and readfile('TidalWave/Profiles/Commit.txt') or '') ~= Commit then
            WipeFolder('TidalWave/Games')
            WipeFolder('TidalWave/Guis')
            WipeFolder('TidalWave/Libraries')
        end

        writefile('TidalWave/Profiles/Commit.txt', Commit)

        if isfile(`TidalWave/Games/{game.PlaceId}.lua`) then
            SupportedGame = readfile(`TidalWave/Games/{game.PlaceId}.lua`)
        else
            const Success2, Result = pcall(function()
                return game:HttpGet(`https://raw.githubusercontent.com/fluidnarrator30/Tidal-Wave/{Commit}/Games/{game.PlaceId}.lua`, true)
            end)

            if Success2 and Result ~= '404: Not Found' then
                SupportedGame = Result
                writefile(`TidalWave/Games/{game.PlaceId}.lua`, Result)
            end
        end
    end
end

LoadingScreen = shared.TidalWaveLoader
LoadingScreen.Name = 'TidalWave Loader'
LoadingScreen.DisplayOrder = 69420
LoadingScreen.IgnoreGuiInset = true
LoadingScreen.ResetOnSpawn = false
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingScreen.Parent = gethui()

const LoadingFrame = Instance.new('Frame')
LoadingFrame.Size = UDim2.fromOffset(300, 150)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LoadingFrame.Parent = LoadingScreen
AddCorner(LoadingFrame, UDim.new(0, 6))

const ImageLabel = Instance.new('ImageLabel')
ImageLabel.Size = UDim2.fromOffset(125, 72)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.fromOffset(87, 10)
ImageLabel.Image = DownloadFile('Assets/LoadingIcon.webp', getcustomasset)
ImageLabel.Parent = LoadingFrame

const LoadingInfo = Instance.new('TextLabel')
LoadingInfo.Size = UDim2.fromOffset(290, 35)
LoadingInfo.BackgroundTransparency = 1
LoadingInfo.Position = UDim2.fromOffset(5, 96)
LoadingInfo.TextSize = 20
LoadingInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingInfo.Text = ''
LoadingInfo.FontFace = Font.fromEnum(Enum.Font.Gotham)
LoadingInfo.Parent = LoadingFrame

const ProgressBar = Instance.new('CanvasGroup')
ProgressBar.Size = UDim2.fromOffset(290, 5)
ProgressBar.Position = UDim2.new(0, 5, 0, 140)
ProgressBar.BorderSizePixel = 0
ProgressBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ProgressBar.Parent = LoadingFrame
AddCorner(ProgressBar, UDim.new(0, 6))

const ProgressBarFill = Instance.new('Frame')
ProgressBarFill.Size = UDim2.fromScale(0, 1)
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBarFill.Parent = ProgressBar

local CurrentLoaded = 0
local AmountToLoad = 11

if SupportedGame then
    AmountToLoad += 1
end

const function IncrementBar()
    CurrentLoaded += 1
    TweenService:Create(ProgressBarFill, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.fromScale(CurrentLoaded / AmountToLoad, 1)}):Play()
end

const function Load(Path, Name)
    LoadingInfo.Text = `Loading {Name}...`
    if IsStudio then
        local Ref = RootPath
        for _, v in Path:gsub('%.lua', ''):split('/') do
            Ref = Ref[v]
        end
        const Result = require(Ref)
        IncrementBar()
        return Result
    else
        const Function, LoadResult = loadstring(DownloadFile(Path), Name)
        if Function then
            const Result = Function()
            IncrementBar()
            return Result
        else
            return Error(`Failed to load '{Name}'`, Name, LoadResult)
        end
    end
end

TidalWave = Load(`Guis/{Gui}.lua`, 'Gui')
shared.TidalWave = TidalWave
const Libraries = {}
TidalWave.Libraries = Libraries
Libraries.Signal = Load('Libraries/Signal.lua', 'Signal')
Libraries.Drawing = Load('Libraries/Drawing.lua', 'Drawing')
Libraries.ObjectFunctions = Load('Libraries/ObjectFunctions.lua', 'ObjectFunctions')
Libraries.Prediction = Load('Libraries/Prediction.lua', 'Prediction')
Libraries.Hash = Load('Libraries/Hash.lua', 'Hash')
Libraries.EntityLib = Load('Libraries/EntityLib.lua', 'EntityLib')
Libraries.Communication = Load('Libraries/Communication.lua', 'Communication')
Libraries.Whitelist = Load('Libraries/Whitelist.lua', 'Whitelist')
Libraries.AuraAnimations = Load('Libraries/AuraAnimations.lua', 'AuraAnimations')
Load('Games/Universal.lua', 'Universal')

if SupportedGame then
    LoadingInfo.Text = `Loading {TidalWave.PlaceName} Modules...`
    const Function = loadstring(SupportedGame, `{TidalWave.PlaceName}/{game.PlaceId}`)
    
    if typeof(Function) == 'function' then
        Function()
        IncrementBar()
    else
        Error(`Failed to load game: '{TidalWave.PlaceName}/{game.PlaceId}'`, TidalWave.PlaceName, Function)
    end
end

LoadingInfo.Text = 'Finished Loading!'

const Tween = TweenService:Create(LoadingFrame, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.In, 0, false, 0.75), {Position = UDim2.new(0.5, -150, 0, -150)})
Tween:Play()
Tween.Completed:Once(function()
    shared.TidalWaveLoader = nil
	LoadingScreen:Destroy()
end)

const LoadTime = os.clock() - Start
const RoundedTime = math.floor(LoadTime * 1000) / 1000

TidalWave:Notify({
    Text = `Loaded TidalWave in {RoundedTime} seconds.\nPress {TidalWave.Menus.Config.Keybinds.Menu.Keybind} to open gui.`,
    Duration = 5
})

task.defer(TidalWave.Load, TidalWave)