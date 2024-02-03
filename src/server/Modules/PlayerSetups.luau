--!nocheck

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")

local Spawn = require(RepS.Modules.Packages.Spawn)

local newInstance = Instance.new

local function setup(plr: Player)
	local leaderstats = newInstance("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr

    local score = newInstance("IntConstrainedValue")
    score.Name = "Score"
    score.MaxValue = 99999
    score.MinValue = 0
    score.Value = 0
    score.Parent = leaderstats

    plr:SetAttribute("Choice", "None")
    plr:SetAttribute("FinishAnswer", 0)
end

return function ()
    --- in case player joined before server starts
    for _, plr in Players:GetPlayers() do
        Spawn(setup, plr)
    end

    --// Connections
    local function _playerAdded(plr: Player)
        if plr:IsDescendantOf(Players) then --- in case player joins and left very quickly
            setup(plr)
        end
    end
    local function _playerLeft(plr: Player)
        warn(plr.Name.." left during Quiz.")
    end
    Players.PlayerAdded:Connect(_playerAdded)
    Players.PlayerRemoving:Connect(_playerLeft)
end
