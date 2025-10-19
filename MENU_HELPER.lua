--[[
    ZAXPLOIT SCRIPT
    DEVELOPER: ZAXPLOIT
    JOIN DISCORD: https://discord.gg/Q3uNB7xG29
]]
local commands = {}

function overlay(text)
    local var = {}
    var[0] = "OnTextOverlay"
    var[1] = "`8[ZAXPLOIT] `9" .. text
    var.netid = -1
    SendVarlist(var)
end

function RegisterCommand(name, func)
	commands[name] = func
end


function handleCommand(type, packet)
	if packet:find("action|input") then
		local text = packet:match("text%|(.+)")
		if text and text:sub(1, 1) == "/" then
			local cmd, args = text:match("^/(%w+)%s*(.*)$")
			if commands[cmd] then
				commands[cmd](args)
				return true
			end
		end
	end
end

AddCallback("CommandHandler", "OnPacket", handleCommand)

RegisterCommand("dw", function(args)
    function dropItem(itemID, count)
        local packet = [[action|dialog_return
    dialog_name|drop_item
    itemID|]] .. itemID .. [[|
    count|]] .. count .. "\n"
        SendPacket(2, packet)
    end

    local num = tonumber(args)
    if num then
        if GetItemCount(242) < 1 then
            overlay("`4Tidak mempunyai `w"..GetIteminfo(242).name)
            return
        end
        dropItem(242, num)
    else
        overlay("`4Usage: /dw <number>")
    end
end)
RegisterCommand("dd", function(args)
    function dropItem(itemID, count)
        local packet = [[action|dialog_return
    dialog_name|drop_item
    itemID|]] .. itemID .. [[|
    count|]] .. count .. "\n"
        SendPacket(2, packet)
    end

    local num = tonumber(args)
    if num then
        if GetItemCount(1796) < 1 then
            overlay("`4Tidak mempunyai `w"..GetIteminfo(1796).name)
            return
        end
        dropItem(1796, num)
    else
        overlay("`4Usage: /dd <number>")
    end
end)
RegisterCommand("db", function(args)
    function dropItem(itemID, count)
        local packet = [[action|dialog_return
    dialog_name|drop_item
    itemID|]] .. itemID .. [[|
    count|]] .. count .. "\n"
        SendPacket(2, packet)
    end

    local num = tonumber(args)
    if num then
        if GetItemCount(7188) < 1 then
            overlay("`4Tidak mempunyai `w"..GetIteminfo(7188).name)
            return
        end
        dropItem(7188, num)
    else
        overlay("`4Usage: /db <number>")
    end
end)

RegisterCommand("save1", function()
	local me = GetLocal()
	if me then
		savedPos1 = { x = me.tile_x, y = me.tile_y }
		overlay("`2Posisi disimpan: " .. savedPos1.x .. ", " .. savedPos1.y)
	else
		overlay("`4Gagal mengambil posisi.")
	end
end)

RegisterCommand("tp1", function()
	if savedPos1 then
		overlay("`2Teleport ke: " .. savedPos1.x .. ", " .. savedPos1.y)
		FindPath(savedPos1.x, savedPos1.y)
	else
		overlay("`4Belum ada posisi yang disimpan. Gunakan /save1 dulu.")
	end
end)

RegisterCommand("save2", function()
	local me = GetLocal()
	if me then
		savedPos2 = { x = me.tile_x, y = me.tile_y }
		overlay("`2Posisi disimpan: " .. savedPos2.x .. ", " .. savedPos2.y)
	else
		overlay("`4Gagal mengambil posisi.")
	end
end)

RegisterCommand("tp2", function()
	if savedPos2 then
		overlay("`2Teleport ke: " .. savedPos2.x .. ", " .. savedPos2.y)
		FindPath(savedPos2.x, savedPos2.y)
	else
		overlay("`4Belum ada posisi yang disimpan. Gunakan /save2 dulu.")
	end
end)

RegisterCommand("collect", function()
	if not savedPos1 or not savedPos2 then
		overlay("`4Posisi save1 dan save2 belum lengkap.")
		return
	end

	local me = GetLocal()
	if not me then
		overlay("`4Gagal mengambil posisi saat ini.")
		return
	end
	local returnPos = { x = me.tile_x, y = me.tile_y }

	local minX = math.min(savedPos1.x, savedPos2.x)
	local maxX = math.max(savedPos1.x, savedPos2.x)
	local minY = math.min(savedPos1.y, savedPos2.y)
	local maxY = math.max(savedPos1.y, savedPos2.y)

	local targets = {}
	for _, obj in pairs(GetObjects()) do
		local tileX = math.floor(obj.pos_x / 32)
		local tileY = math.floor(obj.pos_y / 32)

		if tileX >= minX and tileX <= maxX and tileY >= minY and tileY <= maxY then
			table.insert(targets, { x = tileX, y = tileY })
		end
	end

	if #targets == 0 then
		overlay("`4Tidak ada item di area tersebut.")
		return
	end

	RunThread(function()
		overlay("`2Menuju save1...")
		FindPath(savedPos1.x, savedPos1.y)
		Sleep(500)

		for _, pos in pairs(targets) do
			FindPath(pos.x, pos.y)
			Sleep(300)
		end

		overlay("`2Menuju save2...")
		FindPath(savedPos2.x, savedPos2.y)
		Sleep(500)

		overlay("`2Kembali ke posisi awal...")
		FindPath(returnPos.x, returnPos.y)
	end)
end)

RegisterCommand("gems1", function()
	local me = GetLocal()
	if me then
		gemsPos1 = { x = me.tile_x, y = me.tile_y }
		overlay("`2GemsPos1 disimpan: " .. gemsPos1.x .. ", " .. gemsPos1.y)
	else
		overlay("`4Gagal menyimpan posisi.")
	end
end)

RegisterCommand("gems2", function()
	local me = GetLocal()
	if me then
		gemsPos2 = { x = me.tile_x, y = me.tile_y }
		overlay("`2GemsPos2 disimpan: " .. gemsPos2.x .. ", " .. gemsPos2.y)
	else
		overlay("`4Gagal menyimpan posisi.")
	end
end)

RegisterCommand("check", function()
	if not gemsPos1 then
		overlay("`4GemsPos1 belum disimpan. Gunakan /gems1 dulu.")
		return
	elseif not gemsPos2 then
		overlay("`4GemsPos2 belum disimpan. Gunakan /gems2 dulu.")
		return
	end

	local count1, count2 = 0, 0
	for _, obj in pairs(GetObjects()) do
		if obj.id == 112 then
			local x = math.floor(obj.pos_x / 32)
			local y = math.floor(obj.pos_y / 32)

			if x == gemsPos1.x and y == gemsPos1.y then
				count1 = count1 + obj.count
			elseif x == gemsPos2.x and y == gemsPos2.y then
				count2 = count2 + obj.count
			end
		end
	end

	overlay("`9Gems di GemsPos1: `2" .. count1 .. " `9| GemsPos2: `2" .. count2)
end)

RegisterCommand("cgems", function()
	if not gemsPos1 or not gemsPos2 then
		overlay("`4GemsPos1 dan GemsPos2 belum lengkap.")
		return
	end

	local me = GetLocal()
	if not me then
		overlay("`4Gagal mengambil posisi saat ini.")
		return
	end
	local returnPos = { x = me.tile_x, y = me.tile_y }

	RunThread(function()
		overlay("`2Menuju GemsPos1...")
		FindPath(gemsPos1.x, gemsPos1.y)
		Sleep(500)

		overlay("`2Menuju GemsPos2...")
		FindPath(gemsPos2.x, gemsPos2.y)
		Sleep(500)

		overlay("`2Kembali ke posisi awal...")
		FindPath(returnPos.x, returnPos.y)
	end)
end)

RegisterCommand("zax", function()
	local dialog = {}
	dialog[0] = "OnDialogRequest"
	dialog[1] = [[
add_label_with_icon|big|`bZAXPLOIT SCRIPT MENU``|left|5956|
add_textbox|`w Halo, ]]..GetLocal().name..[[``|left|
add_textbox|`9Script ini `2gratis`9, jika anda beli maka ketipu. Jangan percaya siapapun yang menjualnya, karena ZAXPLOIT dibuat untuk komunitas secara cuma-cuma.``|left|
add_spacer|small|
add_textbox|`bCommands``|left|
add_label_with_icon|small|`9/dw <jumlah> `w→ Drop World Lock``|left|242|
add_label_with_icon|small|`9/dd <jumlah> `w→ Drop Diamond Lock``|left|1796|
add_label_with_icon|small|`9/db <jumlah> `w→ Drop Blue Gem Lock``|left|7188|
add_spacer|small|
add_label_with_icon|small|`9/save1 `w→ Simpan posisi pertama``|left|3802|
add_label_with_icon|small|`9/save2 `w→ Simpan posisi kedua``|left|3802|
add_label_with_icon|small|`9/tp1 `w→ Teleport posisi kesatu``|left|3802|
add_label_with_icon|small|`9/tp2 `w→ Teleport posisi kedua``|left|3802|
add_label_with_icon|small|`9/collect `w→ Ambil item di area save1–save2``|left|3802|
add_spacer|small|
add_label_with_icon|small|`9/gems1 `w→ Simpan posisi gems pertama``|left|1622|
add_label_with_icon|small|`9/gems2 `w→ Simpan posisi gems kedua``|left|1622|
add_label_with_icon|small|`9/check `w→ Cek jumlah gems di kedua tile``|left|1622|
add_label_with_icon|small|`9/cgems `w→ Teleport ke gems1 → gems2 → balik``|left|1622|
add_spacer|small|
add_label_with_icon|small|`9/zax `w→ Show menu``|left|32|
add_quick_exit|
end_dialog|zax_menu|OK||
]]
	dialog.netid = math.floor(GetLocal().netid) and -1
	SendVarlist(dialog)
end)