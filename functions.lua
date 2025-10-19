function move(x, y)
    local player = GetLocal()
    local x = math.floor(player.pos_x / 32) + x
    local y = math.floor(player.pos_y / 32) + y
    FindPath(x, y)
end
move(1,0)
-- notif
local function notif(message)
    local var = {
        [0] = "OnAddNotification",
        [1] = "interface/NEXUS.rttex",
        [2] = "`4[ZaXploit] `w"..message,
        [3] = "audio/fart6.wav",
        netid = -1
    }
    SendVarlist(var)
end
-- overlay
function overlay(text)
    local var = {}
    var[0] = "OnTextOverlay"
    var[1] = "`8[ZAXPLOIT] `9" .. text
    var.netid = -1
    SendVarlist(var)
end
-- notele
local function hit(x, y)
    local packet = {
        type = 3,
        int_data = 18,     
        int_x = x,             
        int_y = y,             
        pos_x = x * 32,       
        pos_y = y * 32    
    }
    SendPacketRaw(packet)
    Sleep(130)
end
function take(x, y)
    local obj = GetObjects()
    for _, o in pairs(obj) do
        local packet = {
            type = 11,
            int_data = o.oid,
            pos_x = o.pos_x,
            pos_y = o.pos_y
        }
        SendPacketRaw(packet)
    end
end
-- teleport
function tp(x, y)
    local packet = {
        type = 0,
        pos_x = x * 32,
        pos_y = y * 32
    }
    SendPacketRaw(packet)
end
------------------------------------------------------------
-- collect jauh
function tp(x, y)
    local packet = {
        type = 0,
        pos_x = x * 32,
        pos_y = y * 32
    }
    SendPacketRaw(packet)
end
function take(x, y)
    for _, obj in pairs(GetObjects()) do
        if math.floor(obj.pos_x / 32) == x and math.floor(obj.pos_y / 32) == y then
            SendPacketRaw({
                type = 11,
                int_data = obj.oid,
                pos_x = obj.pos_x,
                pos_y = obj.pos_y
            })
        end
    end
end
tp(23, 24)
take(23, 24)
-----------------------------------------------------------

-- collect tile world
local function collect(x, y)
    for _, obj in pairs(GetObjects()) do
        local ox = math.floor(obj.pos_x / 32)
        local oy = math.floor(obj.pos_y / 32)

        if ox == x and oy == y and obj.id ~= 0 then
            local pkt = {
                type = 11,
                pos_x = obj.pos_x,
                pos_y = obj.pos_y,
                int_data = obj.oid
            }
            SendPacketRaw(pkt)
        end
    end
end


-- collect
local function collectItems(range)
    local player = GetLocal()
    local px = player.pos_x
    local py = player.pos_y
    range = (range or 4) * 32 -- Default range is 4 tiles (128 pixels)

    for _, obj in pairs(GetObjects()) do
        if obj.id ~= 0 then 
            local distanceX = math.abs(px - obj.pos_x)
            local distanceY = math.abs(py - obj.pos_y)

            if distanceX < range and distanceY < range then
                local pkt = {}
                pkt.type = 11
                pkt.pos_x = obj.pos_x
                pkt.pos_y = obj.pos_y
                pkt.int_data = obj.oid
                SendPacketRaw(pkt)
            end
        end
    end
end
collectItems(3)

-- collect(1, 0)
local function take(dx, dy)
    local me = GetLocal()
    local px = math.floor(me.pos_x / 32)
    local py = math.floor(me.pos_y / 32)

    local target_x = px + dx
    local target_y = py + dy

    for _, obj in pairs(GetObjects()) do
        local ox = math.floor(obj.pos_x / 32)
        local oy = math.floor(obj.pos_y / 32)

        if ox == target_x and oy == target_y then
            local pkt = {
                type = 11,
                pos_x = obj.pos_x,
                pos_y = obj.pos_y,
                int_data = obj.oid
            }
            SendPacketRaw(pkt)
        end
    end
end

-- drop item
function dropItem(itemID, count)
    local packet = [[action|dialog_return
dialog_name|drop_item
itemID|]] .. itemID .. [[|
count|]] .. count .. "\n"
    SendPacket(2, packet)
end

-- webhook
function sendClearWebhook(status)
    local webhook = "https://discord.com/api/webhooks/1428441358699466833/yUIg17DllPS9ohtGFR8xbAlP7RG3zwiQODiogItY9QKltZshxmr4l8Jbu5CJ5txTYp6m"
    local bannerImage = "https://cdn.discordapp.com/attachments/1427431962917998622/1428435555263320096/banner_zaxploit.gif?ex=68f27dc7&is=68f12c47&hm=3577c5a67ab36e5c6846b0236a16820f6895933ba176919de907a2d1320818ed&"
    local footerText = "ZaXploit Automation"
    local footerIcon = "https://copypastatext.com/wp-content/uploads/2021/12/index-14.jpg"

    local nameEmoji = "👤"
    local worldEmoji = "🌍"
    local lockEmoji = "🔒"
    local sizeEmoji = "📐"
    local delayEmoji = "⏱️"
    local statusEmoji = "🧹"

    local payload = [[{
        "content": "",
        "embeds": [{
            "title": "🧹 Auto Clear World by ZaXploit",
            "description": "Script sedang berjalan dalam mode relatif...",
            "color": 5814783,
            "image": {
                "url": "]] .. bannerImage .. [["
            },
            "fields": [
                {
                    "name": "]] .. nameEmoji .. [[ Name",
                    "value": "]] .. tostring(GetLocal().name) .. [[",
                    "inline": true
                },
                {
                    "name": "]] .. worldEmoji .. [[ World Type",
                    "value": "]] .. tostring(worldType) .. [[",
                    "inline": true
                },
                {
                    "name": "]] .. lockEmoji .. [[ Lock ID",
                    "value": "]] .. tostring(lock) .. [[",
                    "inline": true
                },
                {
                    "name": "]] .. sizeEmoji .. [[ Size",
                    "value": "]] .. tostring(sizeX) .. "x" .. tostring(sizeY) .. [[",
                    "inline": true
                },
                {
                    "name": "]] .. delayEmoji .. [[ Clear Delay",
                    "value": "]] .. tostring(clearDelay) .. [[ms",
                    "inline": true
                },
                {
                    "name": "]] .. statusEmoji .. [[ Status",
                    "value": "]] .. status .. [[",
                    "inline": false
                }
            ],
            "footer": {
                "text": "]] .. footerText .. [[",
                "icon_url": "]] .. footerIcon .. [["
            },
            "timestamp": "]] .. os.date("!%Y-%m-%dT%H:%M:%SZ") .. [["
        }]
    }]]
    SendWebhook(webhook, payload)
end
