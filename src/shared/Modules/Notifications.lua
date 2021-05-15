-- Notifications.lua
-- Senko
-- 5/15/2021

--[[
    API:
    this.new(number: interval, table: passed)
        + Creates a new Notifications object.
        + The interval argument represents how much time you want passed before the client sends another notification.
        + The passed argument is a table that holds all of the data for the notification. (Ex. Title, Text, Icon, Duration)


    object:Destroy()
        + Destroys the object, and disconnects/destroys all instances associated with it.

    object.CallbackButtonClicked:Connect(function(response)
    end)
        + Signal
        + Fires whenever the player presses on 1 o/ two callback buttons.
        + Only works whenever Callback == true
]]

local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))

local module = {}
module.__index = module

local valid = {
    Title = "string",
    Text = "string",
    Icon = "string",

    Duration = "number",

    Callback = "boolean",
    Button1 = "string",
    Button2 = "string"
}

function module.new(interval, passed)
    if (typeof(interval) ~= "number") then
        warn("[Notifications] 'interval' argument is not a number; rather it is a(n) ".. typeof(interval)..'.')
        return
    end
    if (typeof(passed) ~= "table") then
        warn("[Notifications] 'passed' argument is not a table; rather it is a(n) ".. typeof(passed)..'.')
        return
    end

    local self = setmetatable({["NotificationData"] = {}}, module)

    for i,v in pairs(passed) do
        if (valid[i] ~= nil) and (typeof(v) == valid[i]) then
            if (i == "Callback" and v ~= false) then
                self.CallbackFunction = {}
            else
                self.NotificationData[i] = v 
            end
        end            
    end

    self.PrevSend = "None"
    self.Interval = interval

    if (self.CallbackFunction ~= nil) then
        print("do callback stuff")
        --[[
            self.CallbackFunction = {
                Instance: "Instance"
            }
        ]]
        self.CallbackButtonClicked = Signal.new()

        local bindableFunc = Instance.new("BindableFunction")
        bindableFunc.Name = "CallbackInvoke"

        function bindableFunc.OnInvoke(resp)
            self.CallbackButtonClicked:Fire(resp)
        end
        self.CallbackFunction.Instance = bindableFunc
        self.NotificationData.Callback = self.CallbackFunction.Instance
    end

    self.Connection = RunService.RenderStepped:Connect(function()
        if (self.PrevSend == "None") or ((os.clock() - self.PrevSend) >= (self.Interval + self.NotificationData.Duration)) then
            StarterGui:SetCore("SendNotification", self.NotificationData)
            self.PrevSend = os.clock()
        end
    end)
    return self
end
function module:Destroy()
    if (self.Connection ~= nil) then
        self.Connection:Disconnect()
    end
    if (self.NotificationData.Callback == true) then
        -- has a callback
        self.CallbackButtonClicked:Destroy()
        self.CallbackFunction.Instance:Destroy()
    end
    setmetatable(self, nil)
end


return module