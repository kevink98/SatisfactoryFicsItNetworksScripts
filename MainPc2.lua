local control1 = component.proxy("F3367E544E087866A491F195C98BCC2D")
local network = component.proxy("B8A7D87C40A5401A3E407DA2037E6794")

local data = {
    {name="Schrauben Wüste 1", y=9, z=0, line=1, power="F7B5582C4C68A5CE802636B4A50E44DB", network="6C25C8864518F2363E614B82162DE152"}
}

-----------------Threads-----------------
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


-----------------Data-----------------
for _,d in pairs(data) do
    d.display1 = control1:getModule(1, d.y, d.z)
    d.display2 = control1:getModule(5, d.y, d.z)
    
    d.display1:setText(d.name)
    d.display1:setSize(20)
    d.display2:setSize(20)
    
    d.powerComp = component.proxy(d.power)
end

-----------------Network-----------------
local openTasks = {}
local updateCounter = 0
function updateDisplay()
    if updateCounter >= 5000 then
        for _,d in pairs(data) do
            local ix = #openTasks + 1
            openTasks[ix] = {requestNetwork=d.network, data=d}
            network:send(d.network, 1001, ix, d.line)
            updateCounter = 0
        end
    else
        updateCounter = updateCounter + 1
    end
end

network:open(1001)
event.listen(network)

-----------------Threads-----------------
function check()
    while true do
        e, sender, senderNetwork, port, index, productivity, powerConsum, sumPartsPerMinute = event.pull(0)
        if e ~= nil then
            if e == "NetworkMessage" then   
                local powerText = "Aus"    
                if openTasks[index].data.powerComp:isConnected() then
                    powerText = "An"
                end
                openTasks[index].data.display1:setText(string.format("%s \nStrom: %s", openTasks[index].data.name, powerText))
                openTasks[index].data.display2:setText(string.format("Produktivitaet: %.2f %% \nTeileproduktion: %.2f Teile / Minute \nStromverbrauch: %.2f MW", productivity * 100, sumPartsPerMinute, powerConsum))
                openTasks[index] = nil
            end
        end    
        updateDisplay()    
    end
end

t1 = thread.create(check)
thread.run()