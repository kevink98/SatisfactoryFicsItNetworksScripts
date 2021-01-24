local splitter1 = component.proxy("D6B3429742618E52C52BC3B0306534F6")
local splitter2 = component.proxy("3BAEB1D24BD3186B250908BFE0E313BA")
local splitter3 = component.proxy("EC0850184DCF4F03BD6277824C820FAD")

local limit_s1 = 100
local limit_s2 = 100
local limit_s3 = 100

local counter_s1 = 0
local counter_s2 = 0
local counter_s3 = 0

splitter1:transferItem(1)
splitter2:transferItem(1)
splitter3:transferItem(1)

local nextMinute;

function transfer(splitter, counter, limit)
    if splitter:getInput() == nil then
       return
    end
    if counter < limit then
        splitter:transferItem(2)
        counter = counter + 1
    else
        splitter:transferItem(1)
    end    
    return counter
end

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

function checkTime_run()
    while true do
        sleep()
        local currentSeconds = computer.millis()        

        if nextMinute == nil or nextMinute <= currentSeconds then
            counter_s1 = 0
            counter_s2 = 0
            counter_s3 = 0
            nextMinute = currentSeconds + 60000
        end
    end
end

function splitter1_run()
    while true do
        sleep()        
        if splitter1:getInput() then
            counter_s1 = transfer(splitter1, counter_s1, limit_s1)
        end
    end
end

function splitter2_run()
    while true do
        sleep()
        if splitter2:getInput() then
            counter_s2 = transfer(splitter2, counter_s2, limit_s2)
        end
    end
end

function splitter3_run()
    while true do
        sleep()
        if splitter3:getInput() then
            counter_s3 = transfer(splitter3, counter_s3, limit_s3)
        end
    end
end

t1 = thread.create(checkTime_run)
t2 = thread.create(splitter1_run)
t3 = thread.create(splitter2_run)
t4 = thread.create(splitter3_run)

thread.run()