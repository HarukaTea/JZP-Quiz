--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.Modules.UI.Vanilla)
local Events = require(RepS.Modules.Data.Events)
local Fusion = require(RepS.Modules.Packages.Fusion)
local TypeWriter = require(RepS.Modules.Packages.TypeWriter)

local v2New = Vector2.new
local fromScale = UDim2.fromScale
local fromRGB = Color3.fromRGB

local function TextFrame(self: table) : Frame
    self.text = Fusion.Value("")

    --// Connections
    local function _setText(text: string)
        self.text:set(text)
    end
    self.Typer.onTextUpdated:Connect(_setText)
    self.Typer.onTyperFinished:Connect(_setText)

    local function _playText(text: string)
        if text == "Clear" then self.isShown:set(false) return end

        self.isShown:set(true)
        TypeWriter:TypeText(text)
    end
    Events.PlayText:Connect(_playText)


    return Components.Frame({
        Name = "TextFrame",

        [Fusion.Children] = {
            Components.ImageLabel({
                Name = "Shadow",
                AnchorPoint = v2New(0.5, 1),
                Position = fromScale(0.5, 1),
                Size = fromScale(1, 0.4),
                Rotation = 180,
                Image = "rbxassetid://1178694188",
                ImageColor3 = fromRGB(),
                ImageTransparency = 0.2
            }),
            Components.TextLabel({
                Name = "Text",
                AnchorPoint = v2New(0, 1),
                Position = fromScale(0, 0.96),
                Size = fromScale(1, 0.06),
                Text = Fusion.Computed(function(use)
                    return use(self.text)
                end),
                ZIndex = 2,

                [Fusion.Children] = {
                    Fusion.New("UITextSizeConstraint")({ MaxTextSize = 32 }),
                    Components.TextUIStroke({ Thickness = 3 })
                }
            })
        }
    })
end

return TextFrame
