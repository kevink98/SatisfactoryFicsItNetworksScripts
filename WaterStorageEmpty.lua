local storage = component.proxy("3FC69D7448230D6623AF478E385DFF68")

thread = {
    threads = {},
    current = 1
}
   
function thread.create(func)
    local t = {}
    t.co = coroutine.create(func)
    function t:stop()
        for i,th in pairs(thread.threads) do
            if th == t then
                table.remove(thread.threads, i)
            end
        end
    end
    table.insert(thread.threads, t)
    return t
end
   
function thread:run()
    while true do
        if #thread.threads < 1 then
            return
        end
        if thread.current > #thread.threads then
            thread.current = 1
        end
        coroutine.resume(true, thread.threads[thread.current].co)
        thread.current = thread.current + 1
    end
end

function sleep()
    event.pull(0.0)
end

function checkStorage()
    while true do
        sleep()        
        if storage.fluidContent >= (storage.maxFluidContent * 0.9) then
            storage:flush()
        end
    end
end

t1 = thread.create(checkStorage)
thread.run()