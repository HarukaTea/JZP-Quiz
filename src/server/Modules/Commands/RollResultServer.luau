--!nocheck

local SSS = game:GetService("ServerScriptService")

local Signals = require(SSS.Modules.Data.ServerSignals)

return function (_, result)
    Signals.RollResult:Fire(result)
end
