--!nocheck

local RS = game:GetService("RunService")
local RF = game:GetService("ReplicatedFirst")
local SG = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

RF:RemoveDefaultLoadingScreen()
SG:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
SG:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
SG:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)

UIS.ModalEnabled = true

local coreCall do
    local MAX_RETRIES = 9999

    function coreCall(method, ...)
        local result = {}
        for i = 1, MAX_RETRIES do
            result = { pcall(SG[method], SG, ...) }
            if result[1] then
                break
            end
            RS.Stepped:Wait()
        end
        return unpack(result)
    end
end
coreCall('SetCore', 'ResetButtonCallback', false)

print("Preload Finished")