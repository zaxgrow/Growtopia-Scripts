posisi = "kiri" -- option "kanan" or "kiri"
bait = {3018, 3020, 3012, 2914, 3098, 3014} -- bait ids
-- 5616 3028 1522 3022 5614 8252 444 846 8966 
trash = {5616, 5612, 12236, 3184, 3028, 1522, 3022, 5614, 8252, 444, 846, 8966, 1520, 3204, 3228}


function wear(id)
    local packet = {}
    packet.type = 10 
    packet.int_data = id
    SendPacketRaw(packet)
end

function overlay(text)
    local var = {}
    var[0] = "OnTextOverlay"
    var[1] = "`8[ZAXPLOIT] `9" .. text
    var.netid = -1
    SendVarlist(var)
end

function message(text)
    local var = {
        [0] = "OnConsoleMessage",
        [1] = "`8[ZAXPLOIT] `9"..text,
        netid = -1
    }
    SendVarlist(var)
end

function bubble(text)
    local var = {
        [0] = "OnTalkBubble",
        [1] = 1,
        [2] = "`8[ZAXPLOIT] `9"..text,
        netid = -1
    }
    SendVarlist(var)
end

function trashALL()
    for _, id in pairs(trash) do
        if GetItemCount(id) > 0 then
            SendPacket(2, [[action|dialog_return
            dialog_name|trash_item2
            itemID|]]..id..[[|
            count|]]..GetItemCount(id)..[[|]].."\n")
            message(GetIteminfo(id).name.." `5Trashed")
        end
    end
end

function putUmpan()
    for _, id in ipairs(bait) do
        if GetItemCount(id) > 0 then
            if posisi == "kanan" then
                put(id, 1, 1)
            elseif posisi == "kiri" then
                put(id, -1, 1)
            end
            message("Umpan `5"..GetIteminfo(id).name)
            return
        end
    end
    message("Semua umpan habis!")
    bubble("Semua umpan habis!")
end

function convert()
    local kontol = GetItemCount(242)
    if kontol > 100 then
        wear(242)
    else return
    end
    local sesudah = math.floor(GetItemCount(1796))
    bubble("DL `5"..sesudah)
end

function put(id, x, y)
    local me = GetLocal()
    local packet = {
        type = 3,
        int_data = id,
        pos_x = me.pos_x,
        pos_y = me.pos_y,
        int_x = (me.pos_x // 32) + x,
        int_y = (me.pos_y // 32) + y
    }
    SendPacketRaw(packet)
end

function hook(varlist)
    -- detect crot
    if varlist[0] == "OnPlayPositioned" and varlist[1] == "audio/splash.wav" then
        bubble("Fish hooked!")
        putUmpan()
        if GetItemCount(242) > 100 then
            convert()
            message("DL `5"..GetItemCount(1796))
        end
        return false
    end
    -- detect janda
    if varlist[0] == "OnConsoleMessage" and varlist[1]:find("You caught a") or varlist[1]:find("There was nothing on the line!") then
        message("Fishing!")
        putUmpan()
        trashALL()
        SendPacket(2, "action|dialog_return\ndialog_name|sellfish\nbuttonClicked|sell_all\nautosell|1\n")
        return false
    end
end

AddCallback("ikanHook", "OnVarlist", hook)

putUmpan()


