-- PrimeUI by JackMacWindows
-- Public domain/CC0

local expect = require "system.expect"
local framebuffer = require "system.framebuffer"
local keys = require "system.keys"
local terminal = require "system.terminal"
local util = require "system.util"

-- Initialization code
local PrimeUI = {}
do
    local coros = {}
    local restoreCursor

    --- Adds a task to run in the main loop.
    ---@param func function The function to run, usually a `coroutine.yield` loop
    function PrimeUI.addTask(func)
        expect(1, func, "function")
        coros[#coros+1] = {coro = coroutine.create(func)}
    end

    --- Sends the provided arguments to the run loop, where they will be returned.
    ---@param ... any The parameters to send
    function PrimeUI.resolve(...)
        coroutine.yield(coros, ...)
    end

    --- Clears the screen and resets all components. Do not use any previously
    --- created components after calling this function.
    ---@param term Terminal The root terminal object
    function PrimeUI.clear(term)
        -- Reset the screen.
        term.setCursorPos(1, 1)
        term.setCursorBlink(false)
        term.setBackgroundColor(terminal.colors.black)
        term.setTextColor(terminal.colors.white)
        term.clear()
        -- Reset the task list and cursor restore function.
        coros = {}
        restoreCursor = nil
    end

    --- Sets or clears the window that holds where the cursor should be.
    ---@param win window|nil The window to set as the active window
    function PrimeUI.setCursorWindow(win)
        expect(1, win, "table", "nil")
        restoreCursor = win and win.restoreCursor
    end

    --- Gets the absolute position of a coordinate relative to a window.
    ---@param win window The window to check
    ---@param x number The relative X position of the point
    ---@param y number The relative Y position of the point
    ---@return number x The absolute X position of the window
    ---@return number y The absolute Y position of the window
    function PrimeUI.getWindowPos(win, x, y)
        while win.getParent do
            if not win.getPosition then return x, y end
            local wx, wy = win.getPosition()
            x, y = x + wx - 1, y + wy - 1
            win = win.getParent()
        end
        return x, y
    end

    --- Runs the main loop, returning information on an action.
    ---@return any ... The result of the coroutine that exited
    function PrimeUI.run()
        while true do
            -- Restore the cursor and wait for the next event.
            if restoreCursor then restoreCursor() end
            local event, param = coroutine.yield()
            -- Run all coroutines.
            for _, v in ipairs(coros) do
                -- Resume the coroutine, passing the current event.
                local res = table.pack(coroutine.resume(v.coro, event, param))
                -- If the call failed, bail out. Coroutines should never exit.
                if not res[1] then error(res[2], 2) end
                -- Execute syscalls if requested by the coroutine. (Preemption is handled internally by the OS.)
                while res[2] == "syscall" do
                    -- Execute the syscall, and resume the coroutine, passing the result.
                    local res = table.pack(coroutine.resume(v.coro, coroutine.yield(table.unpack(res, 2, res.n))))
                    -- If the call failed, bail out. Coroutines should never exit.
                    if not res[1] then error(res[2], 2) end
                end
                -- If the coroutine resolved, return its values.
                if res[2] == coros then return table.unpack(res, 3, res.n) end
            end
        end
    end
end

-- DO NOT COPY THIS LINE
return PrimeUI