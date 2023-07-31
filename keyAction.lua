local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "system.expect" -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Adds an action to trigger when a key is pressed.
---@param key key The key to trigger on, from `keys.*`
---@param action function|string A function to call when clicked, or a string to use as a key for a `run` return event
function PrimeUI.keyAction(key, action)
    expect(1, key, "number")
    expect(2, action, "function", "string")
    PrimeUI.addTask(function()
        while true do
            local event, param = coroutine.yield() -- wait for key
            if event == "key" and param.keycode == key then
                if type(action) == "string" then PrimeUI.resolve("keyAction", action)
                else action() end
            end
        end
    end)
end
