--Splitter für Teilung Mod. Rahmen

local splitter = component.proxy("CE509A944CE371AF51F463804B7909F6")
local counter = 0

splitter:transferItem(1)
event.listen(splitter)

function transfer()
    if counter < 20 then
        if not splitter:transferItem(2) then
            splitter:transferItem(1)
        end
    else
        if not splitter:transferItem(1) then
            splitter:transferItem(2)
        end
    end

    counter = counter + 1
    if counter >= 30 then
        counter = 0
    end
end

while true do
    e = event.pull(1)
    if e == "ItemRequest" then
        transfer()
    else
        while splitter:getInput() do
            transfer()
        end
    end
end