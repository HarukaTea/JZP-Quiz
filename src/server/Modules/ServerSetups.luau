--!nocheck

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local SSS = game:GetService("ServerScriptService")
local PS = game:GetService("PhysicsService")

local Cmdr = require(RepS.Modules.Packages.Cmdr)
local Spawn = require(RepS.Modules.Packages.Spawn)

local function mainSetup()
	--- clear extra events
	for _, mapPart in workspace:GetDescendants() do
		if mapPart:IsA("BasePart") then
			mapPart.CanTouch = false
		end
	end
    for _, mapPart in workspace.Maps.Buildings:GetDescendants() do
        if mapPart:IsA("BasePart") then
            mapPart.CanCollide = false
            mapPart.CanQuery = false
        end
    end

	--- server location info
	Spawn(function()
		if RS:IsStudio() then return end

		local serverInfo = HttpService:GetAsync("https://ipapi.co/json", true)

		if serverInfo then
			local realInfo = HttpService:JSONDecode(serverInfo)
			local serverLocation = realInfo.country

			if serverLocation then
				RepS.Package.ServerLocation.Value = serverLocation

				print("Server Location: "..serverLocation)
			else
				warn("Fetched IP data, but is empty")
			end
		else
			warn("Failed to fetch IP data")
		end
	end)
end

local function collisionRegister()
	PS:RegisterCollisionGroup("Player")
	PS:CollisionGroupSetCollidable("Player", "Player", false)
end

local function cmdrRegister()
	Cmdr:RegisterDefaultCommands({"Help", "DefaultAdmin"})
	Cmdr:RegisterCommandsIn(SSS.Modules.Commands)
	Cmdr:RegisterHooksIn(SSS.Modules.Hooks)
end

return function ()
    --// Setups
    collisionRegister()
    cmdrRegister()
    mainSetup()

    --// Connections
    local function _setCollisionGroup(object: Instance, group: string)
        if object:IsA("BasePart") then
            object.CollisionGroup = group
        end

        for _, child in object:GetChildren() do
            _setCollisionGroup(child, group)
        end
    end
    Players.PlayerAdded:Connect(function(plr)
        if plr:IsDescendantOf(Players) then --- in case player joins and left very quickly
            plr.CharacterAdded:Connect(function(char)
                _setCollisionGroup(char, "Player")
            end)
        end
    end)

    require(SSS.Modules.PlayerSetups)()
end
