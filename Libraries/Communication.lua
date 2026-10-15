const TidalWave = shared.TidalWave
const Libraries = TidalWave.Libraries
const Signal = Libraries.Signal
const EntityLib = Libraries.EntityLib

const Communication = {}

const function Encode(Channel, Message)
    const ID = math.floor(os.clock() * 10000)
    return `rbxassetid://{ID}\255{Channel}\255{Message}`
end

const function Decode(Message)
    const Data = Message:sub(14):split('\255')
    if #Data == 3 then
        return {
            ID = Data[1],
            Channel = Data[2],
            Message = Data[3]
        }
    end

    return nil
end

local ReplicateSignalSuccess = true

function Communication:Connect(Channel)
    const Socket = {}
    Socket.Connections = {}
    Socket.Processed = {}
    Socket.OnMessage = Signal.new()
	Socket.Animation = Instance.new('Animation')

    function Socket:Send(Message)
		const Animator = EntityLib.Alive and EntityLib.Animator or nil
		if not Animator then return end

		const AnimationId = Encode(Channel, Message)
		if replicatesignal and ReplicateSignalSuccess then
			ReplicateSignalSuccess = pcall(replicatesignal, Animator.OnCombinedUpdate, AnimationId, true, 0, 0.0001, 0, 0, Enum.AnimationPriority.Core, true, 255)
			if not ReplicateSignalSuccess then
				Socket:Send(Message)
			end
		else
			Socket.Animation.AnimationId = AnimationId

			local Track = Animator:LoadAnimation(Socket.Animation)
			Track:Play()
			Track:Stop()
			Track:Destroy()
			Track = nil
		end
    end

    function Socket:Close()
        Socket.OnMessage:DisconnectAll()
        for _, Connection in self.Connections do
            Connection:Disconnect()
        end
        table.clear(self.Connections)
    end

    function Socket:Clean(Connection)
        table.insert(self.Connections, Connection)
    end

    const function EntityAdded(Entity)
        if Entity.NPC then return end
        
        Socket:Clean(Entity.Humanoid.AnimationPlayed:Connect(function(Track)
            if not Track.Animation then
                task.wait()
            end

            if Track.Animation then
                const Data = Decode(Track.Animation.AnimationId)
                if Data and not Socket.Processed[Data.ID] then
                    Socket.Processed[Data.ID] = true
                    Socket.OnMessage:Fire(Entity.Player, Data.Message)
                end
            end
        end))
    end

    Socket:Clean(EntityLib.Events.EntityAdded:Connect(EntityAdded))
    for _, Entity in EntityLib.List do
        EntityAdded(Entity)
    end

    return Socket
end

return Communication