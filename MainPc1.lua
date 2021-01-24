local control1 = component.proxy("F3367E544E087866A491F195C98BCC2D")
local network = component.proxy("48762A4E4FB864901979F0BF1348D1C2")

local data = {
    {name="Wueste W_Beton_1 1", y=1, z=1, line=1, power="968C552C414E97B7AF51ECBB63E70632", network="6C45C30144737F7BEA43C1B34CA2E7A5"},

    {name="Wueste Eisenplatten 1", y=9, z=0, line=1, power="87CFE52C44BDCB7B79F577824C5E78F3", network="551AEFC44E16CD5F5CBF9AA50477413A"},
    {name="Wueste Stangen 1", y=7, z=0, line=1, power="5965F8C2441A55256506B39FB1ADFF0D", network="C187F68B44C460CEA82D8089AA958AA1"},
    {name="Schrauben Wüste 1", y=5, z=0, line=1, power="F7B5582C4C68A5CE802636B4A50E44DB", network="6C25C8864518F2363E614B82162DE152"},
    {name="Wueste Draht 1", y=3, z=0, line=1, power="2FB18222474468FED7A1DDAA6B757B28", network="97F7C3804DDBA2AB29096B877E1CF285"},
    {name="Wueste Kabel 1", y=1, z=0, line=2, power="3812F61B4FCB16C6B14B649EB36171B4", network="97F7C3804DDBA2AB29096B877E1CF285"},
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

local elements = {}

-----------------Data-----------------
for id,d in pairs(data) do
    d.id = id
    d.lever = control1:getModule(0, d.y, d.z)
    d.powerComp = component.proxy(d.power)    

    d.display1 = control1:getModule(1, d.y, d.z)
    d.display2 = control1:getModule(5, d.y, d.z)
    
    d.display1:setText(d.name)
    d.display1:setSize(20)
    d.display2:setSize(20)

    elements[d.lever:getHash()] = d
    event.listen(d.lever)
end

-----------------Network-----------------
local openTasks = {}
local updateCounter = 0
function updateDisplay()
    if updateCounter >= 5000 then
        for _,d in pairs(data) do
            openTasks[d.id] = {requestNetwork=d.network, data=d}
            network:send(d.network, 1001, d.id, d.line)
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
                local data = openTasks[index].data  
                for k,v in pairs(data) do
                    print(string.format("%s %s", k, v))
                end
                
                local powerText = "Aus"    
                if data.powerComp:isConnected() then
                    powerText = "An"
                end
                data.display1:setText(string.format("%s \nStrom: %s", data.name, powerText))
                data.display2:setText(string.format("Produktivitaet: %.2f %% \nTeileproduktion: %.2f Teile / Minute \nStromverbrauch: %.2f MW", productivity * 100, sumPartsPerMinute, powerConsum))
                
            elseif e == "ChangeState" then
                local element = elements[sender:getHash()]
                element.powerComp:setConnected(sender:getState())
            end
        end    
        updateDisplay()   
    end
end

t1 = thread.create(check)
thread.run()