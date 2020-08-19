local splitter = component.proxy("D191211E4063E168FFC864A581E6AF46")

local acceptList = {"Stator", "KI-Begrenzer", "Stahlbetontr??ger"}

splitter:transferItem(2)
event.listen(splitter)

function transfer()
    local item = splitter:getInput()
    if item == nil then
       return
else
    end
    local access = false
    for k,v in pairs(acceptList) do
        if tostring(v) == tostring(item.type) then          
            splitter:transferItem(1)
            access = true
        end
    end
    
    if not access then
        splitter:transferItem(2)
    end
end

while true do
    e = event.pull(1)
    if e == "ItemRequest" then
        transfer()
    else
        while splitter:getInput() do
            transfer(s)
        end
    end
end