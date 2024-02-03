--!nocheck

local BS = game:GetService("BadgeService")
local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")
local TS = game:GetService("TweenService")

local AssetBook = require(RepS.Modules.Data.AssetBook)
local Events = require(SSS.Modules.Data.ServerEvents)
local QuestionLib = require(SSS.Modules.Data.QuestionLib)
local Spawn = require(RepS.Modules.Packages.Spawn)
local Signals = require(SSS.Modules.Data.ServerSignals)

local sounds = workspace.Sounds
local stage = workspace.Stage

local stageLight = workspace.Maps.Shaders.StageShader.SurfaceLight :: SurfaceLight

local wait = task.wait
local insert, tFind, remove, clone = table.insert, table.find, table.remove, table.clone
local cfNew = CFrame.new
local v3New = Vector3.new
local tweenInfoNew = TweenInfo.new
local random = math.random
local fromRGB = Color3.fromRGB

--// Setups
sounds.BeforeQuiz:Play()

--// Connections
local questions = clone(QuestionLib.Category)
local function startQuiz()
    TS:Create(sounds.BeforeQuiz, AssetBook.TweenInfos.one, { Volume = 0 }):Play()

    wait(1)
    sounds.BeforeQuiz:Stop()

    --- locate players
    wait(0.5)
    local playerLocations = stage.PlayerLocations:GetChildren()

    Spawn(function()
        for index, plr in Players:GetPlayers() do
            if plr:IsDescendantOf(Players) and plr.Character then
                local char = plr.Character

                char:PivotTo(playerLocations[index].CFrame)
                char.Humanoid.WalkSpeed = 0
                char.Humanoid.JumpPower = 0
            end
        end
    end)

    --- locate experts
    wait(0.5)
    local players = Players:GetPlayers()
    local seats = stage.Spinner.Seats:GetChildren()
    Spawn(function()
        for i = 1, 8 do
            local plr = players[i] :: Player
            local seat = seats[i] :: Seat

            if plr and plr.Character then
                seat:Sit(plr.Character.Humanoid)
                seat:SetAttribute("Player", plr.DisplayName)
                seat:SetAttribute("PlayerId", plr.Name)

                plr.Team = Teams.Expert
            else
                local noob = workspace.Noob:Clone() :: Model
                noob.Parent = stage

                seat:Sit(noob.Humanoid)
                seat:SetAttribute("Player", "Noob")
                seat:SetAttribute("PlayerId", "Noob")
            end

            seat.Name = "Seat"..i
        end

        for _, seat in seats do
            seat.Booth.Screen.SurfaceGui.TextLabel.Text = 0
        end
    end)

    Events.CameraPos:Fires(stage.Cameras.Category)
    Events.SpinR:Fires(52)

    sounds.Intro:Play()

    wait(1)
    Events.PlayText:Fires("欢迎来到：问答节目2024版本，除夕特辑！")

    wait(4)
    Events.PlayText:Fires("本次大赛将选出 两位 获胜者！规则如下：")

    wait(5)
    Events.PlayText:Fires("有8个人将被选出，成为'专家'，而你们八位，最后分数最高的获胜。")

    wait(6)
    Events.PlayText:Fires("场外观众，你们也是一样的，最后分数最高的获胜。")

    wait(6)
    Events.PlayText:Fires("话不多说，我们先来介绍下今天的专家们，和各自的主题。")

    wait(6)
    for i = 1, 8 do
        local seat = stage.Spinner.Seats["Seat"..i] :: Seat

        Events.CameraPos:Fires(seat.Booth.Camera, "Follow")
        Events.PlayText:Fires(seat:GetAttribute("Player")..", 负责的主题是："..questions[i])
        wait(3)
    end

    Events.CameraPos:Fires(stage.Cameras.Category)
    Events.PlayText:Fires("那么，接下来，问答节目2024版本，除夕特辑，正式开始！")

    TS:Create(sounds.Intro, AssetBook.TweenInfos.one, { Volume = 0 }):Play()

    wait(1)
    sounds.Intro:Stop()
end
Signals.StartQuiz:Connect(startQuiz)


local luckyOne: Player = nil
local function luckyPlayer()
    --- filter players
    -- local normals = {}
    -- for _, plr in Players:GetPlayers() do
    --     if plr.Team == Teams.Player then insert(normals, plr) end
    -- end
    local normals = Players:GetPlayers()

    ---- randomly decide
    local plr = normals[random(1, #normals)] :: Player
    luckyOne = plr

    sounds.ComingUp:Play()
    Events.PlayText:Fires("有请我们的随机幸运观众登场！")

    local char = plr.Character
    if char then
        char:PivotTo(stage.Elevator.CFrame * cfNew(0, 8, 0))

        TS:Create(stage.Elevator, tweenInfoNew(5), { Position = v3New(31.2, 3.8, 54.7) }):Play()
    end

    wait(6)
    Events.PlayText:Fires(plr.DisplayName..", 请挑选其中一个主题，场外观众们，也可以投票给你希望选中的主题。")
    Events.ChooseCategory:Fires(questions, "Choose")
end
Signals.LuckyPlayer:Connect(luckyPlayer)


local function chooseCategory()
    Events.PlayText:Fires("请挑选其中一个主题，场外观众们，也可以投票给你希望选中的主题。")
    Events.ChooseCategory:Fires(questions, "Choose")
end
Signals.ChooseCategory:Connect(chooseCategory)


local categoryChoose: number = 1
local function whatCategoryPlayerChoose(plr: Player, category: string, method: string)
    if plr ~= luckyOne then return end

    Events.ChooseCategory:Fires({}, "Clear")
    sounds.Chosen:Play()

    local index = tFind(QuestionLib.Category, category)
    local seat = stage.Spinner.Seats["Seat"..index] :: Seat
    local expert = seat:GetAttribute("Player") :: string
    local expertPlayer = seat:GetAttribute("PlayerId") :: string

    if method == "Choose" then
        Events.PlayText:Fires(plr.DisplayName.."选择了"..category)
        categoryChoose = index

        wait(3)
        Events.PlayText:Fires("也就意味着...如果转盘转到了"..expert..", 那么你回答的分数将会加倍。")

        if Players:FindFirstChild(expertPlayer) then
            RepS.Package.DoubleHighlight:Clone().Parent = Players[expertPlayer].Character
        end

        wait(4)
        Events.PlayText:Fires("现在，请选择你希望淘汰掉的主题。")
        Events.ChooseCategory:Fires(QuestionLib.Category, "Out")

    elseif method == "Out" then
        Events.PlayText:Fires(plr.DisplayName.."选择淘汰"..category)

        wait(3)
        Events.PlayText:Fires("也就意味着...如果转盘转到了"..expert..", 你将会被淘汰。")

        if Players:FindFirstChild(expertPlayer) then
            RepS.Package.OutHighlight:Clone().Parent = Players[expertPlayer].Character
        end

        wait(4)
        Events.PlayText:Fires("Clear")
        Signals.SpinR:Fire()
    end
end
Events.ChooseCategory:Connect(whatCategoryPlayerChoose)


local function spinR()
    local duration = random(5, 13)

    Events.SpinR:Fires(duration)
    Events.CameraPos:Fires(stage.Cameras.Spin)

    sounds.Intro:Play()
    sounds.Intro.Volume = 0.5

    wait(duration)
    Events.CameraPos:Fires(stage.Cameras.Category)

    TS:Create(sounds.Intro, AssetBook.TweenInfos.one, { Volume = 0 }):Play()

    wait(1)
    sounds.Intro:Stop()
end
Signals.SpinR:Connect(spinR)


local roll: string = "Normal"
local function rollResult(result: string)
    Spawn(function()
        for _, plr in Players:GetPlayers() do
            if plr.Character then
                local components = plr.Character:GetChildren()

                for _, component in components do
                    if component:IsA("Highlight") then component:Destroy() end
                end
            end
        end
    end)

    if result == "Normal" then
        sounds.Question:Play()
        roll = "Normal"

        Events.PlayText:Fires("无事发生，那么，请听题...")

        wait(3)
        Signals.NewQuestion:Fire()

    elseif result == "Double" then
        sounds.Double:Play()
        roll = "Double"

        stageLight.Color = fromRGB(255, 255, 0)

        wait(3)
        Events.PlayText:Fires("如果回答正确，你将获得两倍分数奖励，那么，请听题...")

        stageLight.Color = fromRGB(85, 170, 255)

        wait(3)
        Signals.NewQuestion:Fire()

    elseif result == "Out" then
        sounds.Out:Play()
        roll = "Out"
        stageLight.Color = fromRGB(255, 0, 0)

        wait(2)
        Events.PlayText:Fires("很遗憾，你被淘汰了...")
        TS:Create(stage.Elevator, tweenInfoNew(5), { Position = v3New(31.2, 60, 54.7) }):Play()

        wait(5)
        if luckyOne.Character then luckyOne.Character:PivotTo(workspace.Maps.Spawn.CFrame) end

        luckyOne = nil
        stageLight.Color = fromRGB(85, 170, 255)
    end
end
Signals.RollResult:Connect(rollResult)


local curQuestion = { 1, 1, 1, 1, 1, 1, 1, 1 }
local function newQuestion()
    if curQuestion[categoryChoose] >= 4 then curQuestion[categoryChoose] = 1 end

    local realQuestion = QuestionLib.Questions[categoryChoose][curQuestion[categoryChoose]] :: table
    local correctAnser = realQuestion.CorrectAnswer :: string

    for _, plr in Players:GetPlayers() do
        plr:SetAttribute("Choice", "None")
        plr:SetAttribute("FinishAnswer", 0)
    end

    Events.PlayText:Fires(realQuestion.Question)
    sounds.Countdown:Play()

    wait(2)
    stage.Countdown.Value = 12
    Events.NewQuestion:Fires(realQuestion.Choices)

    repeat
        wait(1)
        stage.Countdown.Value -= 1
    until stage.Countdown.Value <= 0

    Events.NewQuestion:Fires({})
    sounds.Countdown:Stop()
    sounds.EndCountdown:Play()

    wait(1)
    local choose = luckyOne:GetAttribute("Choice")
    Events.PlayText:Fires("你选择的是"..choose..", 正确答案是...")

    wait(4)
    Events.PlayText:Fires("正确答案是："..correctAnser.."!")

    Spawn(function()
        for _, plr in Players:GetPlayers() do
            if plr:GetAttribute("Choice") == realQuestion.CorrectAnswer then
                plr.leaderstats.Score.Value += plr:GetAttribute("FinishAnswer")
            end
        end
    end)
    Spawn(function()
        for _, seat in stage.Spinner.Seats:GetChildren() do
            local plr = seat:GetAttribute("PlayerId") :: string

            if Players:FindFirstChild(plr) then
                seat.Booth.Screen.SurfaceGui.TextLabel.Text = Players[plr].leaderstats.Score.Value
            end
        end
    end)

    curQuestion[categoryChoose] += 1

    if realQuestion.CorrectAnswer == choose then
        sounds.Correct:Play()

        stageLight.Color = fromRGB(255, 255, 0)

        if roll == "Double" then
            luckyOne.leaderstats.Score.Value += luckyOne:GetAttribute("FinishAnswer")
        end

        wait(5)
        stageLight.Color = fromRGB(85, 170, 255)

        remove(questions, categoryChoose)

        wait(1)
        Signals.ChooseCategory:Fire()

    else
        sounds.Out:Play()

        stageLight.Color = fromRGB(255, 0, 0)
        if curQuestion[categoryChoose] >= 4 then remove(questions, categoryChoose) end

        wait(2)
        TS:Create(stage.Elevator, tweenInfoNew(5), { Position = v3New(31.2, 60, 54.7) }):Play()

        wait(5)
        if luckyOne.Character then luckyOne.Character:PivotTo(workspace.Maps.Spawn.CFrame) end

        luckyOne = nil
        stageLight.Color = fromRGB(85, 170, 255)
    end
end
Signals.NewQuestion:Connect(newQuestion)


local function whatPlayerAnswer(plr: Player, answer: string, seconds: number)
    plr:SetAttribute("Choice", answer)
    plr:SetAttribute("FinishAnswer", seconds)

    local sfx = sounds.Press:Clone() :: Sound
    sfx.PlayOnRemove = true
    sfx.Parent = workspace

    wait()
    sfx:Destroy()
end
Events.NewQuestion:Connect(whatPlayerAnswer)


local function winQuiz()
    local highestScore1, highestScore2 = 0, 0
    local winner1: Player, winner2: Player = nil, nil

    local experts, normals = {}, {}

    for _, plr in Players:GetPlayers() do
        if plr.Team == Teams.Expert then
            insert(experts, plr)
        else
            insert(normals, plr)
        end
    end
    for _, plr in experts do
        if plr.leaderstats.Score.Value > highestScore1 then
            highestScore1 = plr.leaderstats.Score.Value

            winner1 = plr
        end
    end
    for _, plr in normals do
        if plr.leaderstats.Score.Value > highestScore2 then
            highestScore2 = plr.leaderstats.Score.Value

            winner2 = plr
        end
    end

    stageLight.Color = fromRGB(255, 255, 0)
    for _, particle in workspace.Maps:GetDescendants() do
        if particle:IsA("ParticleEmitter") then particle.Enabled = true end
    end
    sounds.WinnerCeremony:Play()

    if winner1 then
        warn("Winner 1: "..winner1.DisplayName..", with "..highestScore1.." score.")

        BS:AwardBadge(winner1.UserId, 2127288071)
        winner1.Team = Teams.Winner
    end
    if winner2 then
        warn("Winner 2: "..winner2.DisplayName..", with "..highestScore2.." score.")

        BS:AwardBadge(winner2.UserId, 2127288071)
        winner2.Team = Teams.Winner
    end

    if winner1 and winner2 then
        wait(6)
        Events.PlayText:Fires("恭喜"..winner1.DisplayName.."和"..winner2.DisplayName.."获得了最终的胜利！")
    end

    wait(6)
    Events.PlayText:Fires("他们获得了本次活动的限定奖章，其余的参赛者们，下期再战吧！")

    wait(6)
    Events.PlayText:Fires("Clear")
    Events.CameraPos:Fires("Free")

    for _, plr in Players:GetPlayers() do
        if plr.Character then
            local humanoid = plr.Character.Humanoid

            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end
Signals.WinQuiz:Connect(winQuiz)

--// Start the server once everything is done
require(SSS.Modules.ServerSetups)()
