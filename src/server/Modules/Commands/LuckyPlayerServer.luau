--!nocheck

local SSS = game:GetService("ServerScriptService")

local Signals = require(SSS.Modules.Data.ServerSignals)

return function ()
    Signals.LuckyPlayer:Fire()
end
