--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.Modules.UI.Vanilla)
local Events = require(RepS.Modules.Data.Events)
local Fusion = require(RepS.Modules.Packages.Fusion)
local TypeWriter = require(RepS.Modules.Packages.TypeWriter)

local ChoiceFrame = require(RepS.Modules.UI.Views.ChoiceFrame)
local CategoryFrame = require(RepS.Modules.UI.Views.CategoryFrame)
local TextFrame = require(RepS.Modules.UI.Views.TextFrame)

local Children, Value = Fusion.Children, Fusion.Value

local Quiz = {}
Quiz.__index = Quiz

return function (plr: Player)
    local self = setmetatable({}, Quiz)

    self.Typer = TypeWriter.new()

    self.plr = plr
    self.char = plr.Character or plr.CharacterAdded:Wait()
    self.UI = Value()

    self.isShown = Value(false)

    Components.ScreenGui({
        Name = "TextPlayer",
        Parent = plr.PlayerGui,
        [Fusion.Ref] = self.UI,

        [Children] = {
            Components.Frame({
                Name = "BG",
                Visible = Fusion.Computed(function(use)
                    return use(self.isShown)
                end),

                [Children] = {
                    TextFrame(self),
                    CategoryFrame(self),
                    ChoiceFrame(self)
                }
            })
        }
    })

    --// Destroy
    local function _clearGarbadge()
        self.Typer:Destroy()

        Events.NewQuestion:DisconnectAll()
        Events.PlayText:DisconnectAll()
        Events.ChooseCategory:DisconnectAll()

        Fusion.peek(self.UI):Destroy()
    end
    self.char.Humanoid.Died:Once(_clearGarbadge)
end
