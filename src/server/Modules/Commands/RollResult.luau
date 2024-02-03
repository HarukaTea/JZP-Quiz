--!nocheck

return {
    Name = "rollresult",
    Description = "Show the roll result",
    Group = "Host",
    Args = {
        function(context)
            return {
                Type = context.Cmdr.Util.MakeEnumType("RollResults",
                { "Normal", "Double", "Out" }),
                Name = "result",
                Description = "The roll result"
            }
        end
    }
}
