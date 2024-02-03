--!nocheck

local hosts = { "JZP007X", "IceX_Dust" }

local tFind = table.find

return function (registry)
    registry:RegisterHook("BeforeRun", function(context)
        if context.Group == "Host" and not tFind(hosts, context.Executor.Name) then
            return "No permission for that!"

        elseif context.Group == "DefaultAdmin" and not tFind(hosts, context.Executor.Name) then
            return "No permission for that!"
        end
    end)
end
