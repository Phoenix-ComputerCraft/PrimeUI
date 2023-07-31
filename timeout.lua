local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "system.expect" -- DO NOT COPY THIS LINE
local util = require "system.util" -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Runs a function or action after the specified time period, with optional canceling.
---@param time number The amount of time to wait for, in seconds
---@param action function|string The function to call when the timer completes, or a `run` event to send
---@return function cancel A function to cancel the timer
function PrimeUI.timeout(time, action)
    expect(1, time, "number")
    expect(2, action, "function", "string")
    -- Start the timer.
    local timer = util.timer(time)
    -- Add a task to wait for the timer.
    PrimeUI.addTask(function()
        while true do
            -- Wait for a timer event.
            local event, param = coroutine.yield()
            if event == "timer" and param.id == timer then
                -- Fire the timer action.
                if type(action) == "string" then PrimeUI.resolve("timeout", action)
                else action() end
            end
        end
    end)
    -- Return a function to cancel the timer.
    return function() util.cancel(timer) end
end