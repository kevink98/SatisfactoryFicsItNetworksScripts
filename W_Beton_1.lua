local identifier = "W_Beton_1"
local name = "Wueste W_Beton_1 1"

local typ_1 = "Beton"
local typ_2 = ""
local typ_3 = ""

local itemsPerStack_1 = 100
local itemsPerStack_2 = 0
local itemsPerStack_3 = 0

local partsPerMinute_1 = 15
local partsPerMinute_2 = 0
local partsPerMinute_3 = 0

local numStorages_1 = 1
local numStorages_2 = 0
local numStorages_3 = 0

local numProductions_1 = 6
local numProductions_2 = 0
local numProductions_3 = 0
---------------------------------------------------------------------------------------------------

local gpu = computer.getGPUs()[1]
local screen = component.proxy(component.findComponent(identifier .. "_Screen")[1])
local network = component.proxy(component.findComponent(identifier .. "_Network")[1])
local power, power1, power2, power3

local compPower = component.findComponent(identifier .. "_Power")
if #compPower > 0 then
 power = component.proxy(compPower[1])
end

local compPower1 = component.findComponent(identifier .. "_Power1")
if #compPower1 > 0 then
 power1 = component.proxy(compPower1[1])
end

local compPower2 = component.findComponent(identifier .. "_Power2")
if #compPower2 > 0 then
 power2 = component.proxy(compPower2[1])
end

local compPower3 = component.findComponent(identifier .. "_Power3")
if #compPower3 > 0 then
 power3 = component.proxy(compPower3[1])
end 

local storages_1 = {}
for i=1, numStorages_1 do
 table.insert(storages_1, component.proxy(component.findComponent(identifier .. "_L1_" .. i)[1]))
end

local storages_2 = {}
for i=1, numStorages_2 do
 table.insert(storages_2, component.proxy(component.findComponent(identifier .. "_L2_" .. i)[1]))
end

local storages_3 = {}
for i=1, numStorages_3 do
 table.insert(storages_3, component.proxy(component.findComponent(identifier .. "_L3_" .. i)[1]))
end
local prods_1 = {}
for i=1, numProductions_1 do
 table.insert(prods_1, component.proxy(component.findComponent(identifier .. "_P1_" .. i)[1]))
end
local prods_2 = {}
for i=1, numProductions_2 do
 table.insert(prods_2, component.proxy(component.findComponent(identifier .. "_P2_" .. i)[1]))
end

local prods_3 = {}
for i=1, numProductions_3 do
 table.insert(prods_3, component.proxy(component.findComponent(identifier .. "_P3_" .. i)[1]))
end

gpu:bindScreen(screen)
gpu:setBackground(0,0,0,0)
w,h = gpu:getSize()
gpu:fill(0,0,w,h," ")

local productivity_1 = 0
local powerConsum_1 = 0
local sumPartsPerMinute_1 = 0

local productivity_2 = 0
local powerConsum_2 = 0
local sumPartsPerMinute_2 = 0

local productivity_3 = 0
local powerConsum_3 = 0
local sumPartsPerMinute_3 = 0

function updateDisplay()
 gpu:setBackground(0,0,0,0)
 gpu:fill(0,0,w,h," ")
 gpu:setForeground(1,1,1,1)

 gpu:setText(2, 1, name)
 gpu:setText(5, 3,"Container:")

    local yPos = 5

    if typ_1 ~= "" then
        gpu:setText(8, yPos, typ_1)
        yPos = yPos + 2
        for i=1, numStorages_1 do
            local storage = storages_1[i]
            gpu:setText(10, yPos,"Container " .. i .. ": " .. storage:getInventories()[1].itemCount .. " / " .. storage:getInventories()[1].size * itemsPerStack_1 .. " Stueck")
            yPos = yPos + 2
        end 
    end

    if typ_2 ~= "" then
        gpu:setText(8, yPos, typ_2)
        yPos = yPos + 2
        for i=1, numStorages_2 do
            local storage = storages_2[i]
            gpu:setText(10, yPos,"Container " .. i .. ": " .. storage:getInventories()[1].itemCount .. " / " .. storage:getInventories()[1].size * itemsPerStack_2 .. " Stueck")
            yPos = yPos + 2
        end 
    end

    if typ_3 ~= "" then
        gpu:setText(8, yPos, typ_3)
        yPos = yPos + 2
        for i=1, numStorages_3 do
            local storage = storages_3[i]
            gpu:setText(10, yPos,"Container " .. i .. ": " .. storage:getInventories()[1].itemCount .. " / " .. storage:getInventories()[1].size * itemsPerStack_3 .. " Stueck")
            yPos = yPos + 2
        end 
    end

    if numProductions_1 > 0 then
        productivity_1 = 0
        powerConsum_1 = 0
        sumPartsPerMinute_1 = 0
        for i=1, numProductions_1 do
            productivity_1 = productivity_1 + prods_1[i].productivity 
            powerConsum_1 = powerConsum_1 + prods_1[i].powerConsumProducing 
            sumPartsPerMinute_1 = sumPartsPerMinute_1 + partsPerMinute_1 * prods_1[i].productivity 
        end
        productivity_1 = productivity_1 / numProductions_1
        gpu:setText(60, 3, typ_1)
        gpu:setText(65, 5, string.format("Produktivitaet: %.2f %%", productivity_1 * 100))
        gpu:setText(65, 7, string.format("Teileproduktion: %.2f Teile / Minute", sumPartsPerMinute_1))
        gpu:setText(65, 9, string.format("Stromverbrauch: %.2f MW", powerConsum_1))
    end

    if numProductions_2 > 0 then
        productivity_2 = 0
        powerConsum_2 = 0
        sumPartsPerMinute_2 = 0
        for i=1, numProductions_2 do
            productivity_2 = productivity_2 + prods_2[i].productivity 
            powerConsum_2 = powerConsum_2 + prods_2[i].powerConsumProducing 
            sumPartsPerMinute_2 = sumPartsPerMinute_2 + partsPerMinute_2 * prods_2[i].productivity 
        end
        productivity_2 = productivity_2 / numProductions_2
        gpu:setText(60, 13, typ_2)
        gpu:setText(65, 15, string.format("Produktivitaet: %.2f %%", productivity_2 * 100))
        gpu:setText(65, 17, string.format("Teileproduktion: %.2f Teile / Minute", sumPartsPerMinute_2))
        gpu:setText(65, 19, string.format("Stromverbrauch: %.2f MW", powerConsum_2))
    end

    if numProductions_3 > 0 then
        productivity_3 = 0
        powerConsum_3 = 0
        sumPartsPerMinute_3 = 0
        for i=1, numProductions_3 do
            productivity_3 = productivity_3 + prods_3[i].productivity 
            powerConsum_3 = powerConsum_3 + prods_3[i].powerConsumProducing 
            sumPartsPerMinute_3 = sumPartsPerMinute_3 + partsPerMinute_3 * prods_3[i].productivity 
        end
        productivity_3 = productivity_3 / numProductions_3
        gpu:setText(60, 23, typ_3)
        gpu:setText(65, 25, string.format("Produktivitaet: %.2f %%", productivity_3 * 100))
        gpu:setText(65, 27, string.format("Teileproduktion: %.2f Teile / Minute", sumPartsPerMinute_3))
        gpu:setText(65, 29, string.format("Stromverbrauch: %.2f MW", powerConsum_3))
    end

    gpu:flush()
end

network:open(1001)
event.listen(network)

while true do
    updateDisplay()
    e, sender, senderNetwork, port, index, lineId = event.pull(0.05)
    if e ~= nil and e == "NetworkMessage" then
        if lineId == 1 then
            network:send(senderNetwork, port, index, productivity_1, powerConsum_1, sumPartsPerMinute_1)
        elseif lineId == 2 then
            network:send(senderNetwork, port, index, productivity_2, powerConsum_2, sumPartsPerMinute_2)
        elseif lineId == 3 then
            network:send(senderNetwork, port, index, productivity_3, powerConsum_3, sumPartsPerMinute_3)
        end
    end
end