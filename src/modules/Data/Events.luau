--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Warp = require(RepS.Modules.Packages.Warp)

local Net = Warp.Client

local Events = {
    CameraPos = Net("CameraPos"),
    ChooseCategory = Net("ChooseCategory"),
    NewQuestion = Net("NewQuestion"),
	StartQuiz = Net("StartQuiz"),
    SpinR = Net("SpinR"),
    PlayText = Net("PlayText")
}

return Events
