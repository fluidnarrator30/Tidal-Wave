local Methods = {}

local function FindSpecificObj(Obj, Index, Method, Compare)
    local Found = 0
    for _, v in Obj[Method](Obj) do
        if Compare(v) then
            Found += 1
            if Found == Index then
                return v
            end
        end
    end
    return nil
end

function Methods:FindSpecificChild(Obj, Name, Index)
    return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj)
        return Obj.Name == Name
    end)
end

function Methods:FindSpecificChildOfClass(Obj, Class, Index)
    return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj)
        return Obj.ClassName == Class
    end)
end

function Methods:FindSpecificChildWhichIsA(Obj, Class, Index)
    return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj)
        return Obj:IsA(Class)
    end)
end

function Methods:FindSpecificDescendant(Obj, Name, Index)
    return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj)
        return Obj.Name == Name
    end)
end

function Methods:FindSpecificDescendantOfClass(Obj, Class, Index)
    return FindSpecificObj(Obj, Index, function(Obj)
        return Obj.ClassName == Class
    end)
end

function Methods:FindSpecificDescendantWhichIsA(Obj, Class, Index)
    return FindSpecificObj(Obj, Index, function(Obj)
        return Obj:IsA(Class)
    end)
end

function Methods:FindFirstDescendant(Obj, Name)
    return Methods:FindSpecificDescendant(Obj, Name, 1)
end

function Methods:FindFirstDescendantOfClass(Obj, Class)
    return Methods:FindSpecificDescendantOfClass(Obj, Class, 1)
end

function Methods:FindFirstDescendantWhichIsA(Obj, Class)
    return Methods:FindSpecificDescendantWhichIsA(Obj, Class, 1)
end

local function WaitForChildFunction(Obj, TimeOut, Method, Added)
    local Thread = coroutine.running()
    local DelayThread

    local Con; Con = Obj[Method]:Connect(function(Child)
        if Added(Child) then
            Con:Disconnect()
            if DelayThread then
                task.cancel(DelayThread)
                DelayThread = nil
            end
            coroutine.resume(Thread, Child)
        end
    end)

    if TimeOut then
        DelayThread = task.delay(TimeOut, function()
            Con:Disconnect()
            DelayThread = nil
            coroutine.resume(Thread, nil)
        end)
    end

    return coroutine.yield()
end

function Methods:WaitForSpecificChild(Obj, Name, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj.Name == Name end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'ChildAdded', function()
        local SpecificChild = FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj.Name == Name end)
        return SpecificChild ~= nil
    end)
end

function Methods:WaitForSpecificChildOfClass(Obj, Class, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj.ClassName == Class end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'ChildAdded', function()
        return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj.ClassNamee == Class end) ~= nil
    end)
end

function Methods:WaitForSpecificChildWhichIsA(Obj, Class, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj:IsA(Class) end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'ChildAdded', function()
        return FindSpecificObj(Obj, Index, 'GetChildren', function(Obj) return Obj:IsA(Class) end) ~= nil
    end)
end

function Methods:WaitForSpecificDescendant(Obj, Name, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj.Name == Name end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'DescendantAdded', function()
        return FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj.Name == Name end) ~= nil
    end)
end

function Methods:WaitForSpecificDescendantOfClass(Obj, Class, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj.ClassName == Class end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'DescendantAdded', function()
        return FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj.ClassNamee == Class end) ~= nil
    end)
end

function Methods:WaitForSpecificDescendantWhichIsA(Obj, Class, Index, TimeOut)
    local ExistingObj = FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj:IsA(Class) end)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'DescendantAdded', function()
        return FindSpecificObj(Obj, Index, 'GetDescendants', function(Obj) return Obj:IsA(Class) end) ~= nil
    end)
end

function Methods:WaitForChildOfClass(Obj, Class, TimeOut)
    local ExistingObj = Obj:FindFirstChildOfClass(Class)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'ChildAdded', function(Child)
        return Child.ClassName == Class
    end)
end

function Methods:WaitForChildWhichIsA(Obj, Class, TimeOut)
    local ExistingObj = Obj:FindFirstChildWhichIsA(Class)
    if ExistingObj then return ExistingObj end
    return WaitForChildFunction(Obj, TimeOut, 'ChildAdded', function(Child)
        return Obj:IsA(Class)
    end)
end

function Methods:WaitForDescendant(Obj, Name, TimeOut)
    return Methods:WaitForSpecificDescendant(Obj, Name, 1, TimeOut)
end

function Methods:WaitForDescendantOfClass(Obj, Class, TimeOut)
    return Methods:WaitForSpecificDescendantOfClass(Obj, Class, 1, TimeOut)
end

function Methods:WaitForDescendantWhichIsA(Obj, Class, TimeOut)
    return Methods:WaitForSpecificDescendantWhichIsA(Obj, Class, 1, TimeOut)
end

function Methods:GetFullName(Obj)
    if typeof(Obj) ~= "Instance" then return nil end
    if Obj == game then return "game" end
    if Obj.Parent == game then return Obj.ClassName == "Workspace" and "workspace" or `game:GetService("{Obj.ClassName}")` end

    local Parts = {}

    while Obj.Parent ~= game do
        local Name = Obj.Name
        Name = Name:match("^[%a_][%w_]*$") and `.{Name}` or `["{Name}"]`

        Parts[#Parts + 1] = {
            Name = Name,
            DebugId = Obj.Parent[Obj.Name] ~= Obj and Obj:GetDebugId() or nil
        }

        Obj = Obj.Parent
    end

    local FullName = Obj.ClassName == "Workspace" and "workspace" or `game:GetService("{Obj.ClassName}")`

    local DebugIdUsed = false

    for i = #Parts, 1, -1 do
        local Part = Parts[i]
        if Part.DebugId then
            FullName = `GetObjFromId({FullName}, "{Part.DebugId}")`
            DebugIdUsed = true
        else
            FullName ..= Part.Name
        end
    end

    if DebugIdUsed then
        return "local function GetObjFromId(Obj, Id) for i, v in Obj:GetChildren() do if v:GetDebugId() == Id then return v end end end\n" .. FullName
    end

    return FullName
end

return Methods
