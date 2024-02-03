--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.Modules.UI.Vanilla)
local Events = require(RepS.Modules.Data.Events)
local Fusion = require(RepS.Modules.Packages.Fusion)

local Children = Fusion.Children

local udNew, fromScale = UDim.new, UDim2.fromScale

local function CategoryFrame(self: table) : Frame
    self.categories = Fusion.Value({})
    self.method = "Choose"

    --// Connections
    local function _setCategories(categories: table, method: string)
        self.categories:set(categories)
        self.method = method
    end
    Events.ChooseCategory:Connect(_setCategories)


    return Components.Frame({
        Name = "CategoryFrame",

        [Children] = {
            Fusion.New("UIAspectRatioConstraint")({ AspectRatio = 2.583 }),
            Fusion.New("UIListLayout")({
                Padding = udNew(0.04, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            Fusion.ForValues(self.categories, function(use, category)
                return Components.TextButton({
                    Name = "Category",
                    Size = fromScale(0.2, 0.07),
                    Text = category,

                    [Fusion.OnEvent("MouseButton1Click")] = function()
                        self.categories:set({})

                        Events.ChooseCategory:Fire(category, self.method)
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

return CategoryFrame
