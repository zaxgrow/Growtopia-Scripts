--------------------------------
-- add vending stock
AddCallback("vendingDialog", "OnVarlist", function(varlist)
    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|vending|Close|Update|") then
        local x = tonumber(varlist[1]:match("embed_data|tilex|(%d+)"))
        local y = tonumber(varlist[1]:match("embed_data|tiley|(%d+)"))
        local dialog = [[action|dialog_return
dialog_name|vending
tilex|]]..x..[[|
tiley|]]..y..[[|
buttonClicked|addstocks
]].."\n"
    SendPacket(2, dialog)
    return true
    end
end)
-------------------------------------
-- ret ut
AddCallback("UT", "OnVarlist", function(varlist)
    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("itemsucker_block") then
        local x = tonumber(varlist[1]:match("embed_data|tilex|(%d+)"))
        local y = tonumber(varlist[1]:match("embed_data|tiley|(%d+)"))
        local dialog = [[action|dialog_return
dialog_name|itemsucker_block
tilex|]]..x..[[|
tiley|]]..y..[[|
buttonClicked|retrieveitem]].."\n"
    SendPacket(2, dialog)
    return true
    end

    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("itemremovedfromsucker") then
        local x = tonumber(varlist[1]:match("embed_data|tilex|(%d+)"))
        local y = tonumber(varlist[1]:match("embed_data|tiley|(%d+)"))
        local count = tonumber(varlist[1]:match("add_text_input|itemtoremove|Amount:|(%d+)"))
        local dialeg = [[action|dialog_return
dialog_name|itemremovedfromsucker
tilex|]]..x..[[|
tiley|]]..y..[[|
itemtoremove|]]..count.."\n"
    SendPacket(2, dialeg)
    return true
    end
end)
---------------------------------------
