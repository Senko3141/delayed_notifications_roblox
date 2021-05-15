-- test notification.lua

if (not game:IsLoaded()) then
    game.Loaded:Wait()
end
repeat wait() until (script.Parent.Parent ~= nil) and (script.Parent.Parent:IsDescendantOf(game.Players))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Notification = require(ReplicatedStorage:WaitForChild("Shared").Modules.Notifications)

wait(3)
local new_notif = Notification.new(3,
    {
        Title = "Test",
        Text = "Yoo",
        Duration = 2,
        Callback = true,

        Button1 = "Test1",
        Button2 = "Test2"
    }
)
new_notif.CallbackButtonClicked:Connect(function(buttonName) -- Obviously, if you're not planning to do callbacks, remove this function.
    print("Button clicked: ".. buttonName)
end)

wait(10)
new_notif:Destroy()