--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Signal = require(RepS.Modules.Packages.Signal)

local NewSignal = Signal.new

local Signals = {
    ChooseCategory = NewSignal(),
    LuckyPlayer = NewSignal(),
    NewQuestion = NewSignal(),
	StartQuiz = NewSignal(),
    SpinR = NewSignal(),
    RollResult = NewSignal(),
    WinQuiz = NewSignal()
}

return Signals
