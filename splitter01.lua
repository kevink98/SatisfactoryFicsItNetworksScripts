local splitter = component.proxy("CE509A944CE371AF51F463804B7909F6")
local counter = 0

splitter:transferItem(0)
event.listen(splitter)

function transfer()
    if counter < 1 then
        if not splitter:transferItem(0) then
            splitter:transferItem(1)
        end
    elseif counter < 3 then
        if not splitter:transferItem(1) then
            splitter:transferItem(0)
        end
    end

    counter = counter + 1
    if counter >= 3 then
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