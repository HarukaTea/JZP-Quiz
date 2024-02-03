--!nocheck

return {
    Name = "startquiz",
    Description = "Start the quiz",
    Group = "Host",
    Args = {
        {
            Type = "string",
            Name = "password",
            Description = "The password of starting the quiz."
        },
    }
}
