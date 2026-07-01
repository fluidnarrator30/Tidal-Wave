local TidalWave = shared.TidalWave
local Categories = TidalWave.Categories
local CharacterLib = TidalWave.Libraries.CharacterLib

local World = Categories.World

local firetouchinterest = firetouchinterest

World:CreateButton({
    Name = "Claim Obby Reward",
    Function = function()
        if not CharacterLib.Alive then return end
        local Lobby = workspace:FindFirstChild("new lobby")
        local Obby = Lobby and Lobby:FindFirstChild("obby")
        local Reward = Obby and Obby:FindFirstChild("Reward")
        if Reward then
            if firetouchinterest then
                firetouchinterest(Reward, CharacterLib.Root, true)
                firetouchinterest(Reward, CharacterLib.Root, false)
            else
                CharacterLib.Root.CFrame = Reward.CFrame
            end
        end
    end
})