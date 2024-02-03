--!nocheck

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")

local Spawn = require(RepS.Modules.Packages.Spawn)

local plr = Players:GetPlayerFromCharacter(script.Parent)

local moduleList = {
    RepS.Modules.UI.Quiz,
    RepS.Modules.UI.PostStroke
}
for _, module in moduleList do
    Spawn(function()
        require(module)(plr)
    end)
end
