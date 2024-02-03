--!nocheck

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local UGS = UserSettings():GetService("UserGameSettings")

local Cmdr = require(RepS:WaitForChild("CmdrClient"))

local plr = Players.LocalPlayer

local function cmdrRegister()
    Cmdr:SetActivationKeys({ Enum.KeyCode.Quote })
    Cmdr:SetPlaceName("JZP-Quiz-Gameshow")

    plr.Chatted:Connect(function(msg)
        if msg == "!cmds" then Cmdr:Show() end
    end)
end
cmdrRegister()

local function cameraSensitivityChange()
    UIS.MouseDeltaSensitivity = 0.74 / UGS.MouseSensitivity
end
cameraSensitivityChange()
UGS:GetPropertyChangedSignal("MouseSensitivity"):Connect(cameraSensitivityChange)
