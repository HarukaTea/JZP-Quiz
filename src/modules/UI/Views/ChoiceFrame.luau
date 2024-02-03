--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.Modules.UI.Vanilla)
local Events = require(RepS.Modules.Data.Events)
local Fusion = require(RepS.Modules.Packages.Fusion)

local Children = Fusion.Children

local fromScale = UDim2.fromScale
local tFind = table.find

local function ChoiceFrame(self: table) : Frame
    self.choices = Fusion.Value({})

    --// Connections
    local function _setChoices(choices: table)
        self.choices:set(choices)
    end
    Events.NewQuestion:Connect(_setChoices)


    return Components.Frame({
        Name = "ChoiceFrame",

        [Children] = {
            Fusion.New("UIAspectRatioConstraint")({ AspectRatio = 2.583 }),
            Fusion.New("UIGridLayout")({
                CellPadding = fromScale(0.05, 0.08),
                CellSize = fromScale(0.4, 0.07),
                FillDirectionMaxCells = 2,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            Fusion.ForValues(self.choices, function(use, choice)
                local choices = { "A", "B", "C", "D" }
                local index = tFind(Fusion.peek(self.choices), choice)
                local choiceIndex = choices[index]

                return Components.TextButton({
                    Name = choiceIndex,
                    Size = fromScale(0.2, 0.07),
                    Text = choiceIndex.."."..choice,

                    [Fusion.OnEvent("MouseButton1Click")] = function()
                        self.choices:set({})

                        Events.NewQuestion:Fire(choiceIndex, workspace.Stage.Countdown.Value)
                    end,

                    [Children] = {
                        Components.RoundUICorner(),
                        Components.UIStroke({
                            Thickness = 3,
                            Enabled = true
                        })
                    }
                })
            end, Fusion.cleanup)
        }
    })
end

return ChoiceFrame
