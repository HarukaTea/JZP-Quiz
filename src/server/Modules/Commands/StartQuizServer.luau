--!nocheck

local SSS = game:GetService("ServerScriptService")

local Signals = require(SSS.Modules.Data.ServerSignals)

return function (_, password)
    if password ~= "1234" then return "Wrong Password!" end

    Signals.StartQuiz:Fire()
end
