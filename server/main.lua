local QBCore = exports['qb-core']:GetCoreObject()
local fibs = {}

RegisterServerEvent("qb-clothing:saveSkin", function(model, skin)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
        
    if model ~= nil and skin ~= nil then
        -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
        MySQL.query('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
            MySQL.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.PlayerData.citizenid,
                model,
                skin,
                1
            })
        end)
    end
    TriggerClientEvent('nc-login:client:firstCharacterCreated', src)
end)

local function getTableIndex(table, value)
    for index, v in pairs(table) do
        if v == value then
            return index
        end
    end

    return nil
end

RegisterServerEvent("qb-clothes:loadPlayerSkin", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
    if result[1] ~= nil then
        TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin)
    else
        TriggerClientEvent("qb-clothes:loadSkin", src, true)
    end

    local index = getTableIndex(fibs, src)
    if index ~= nil then
        table.remove(fibs, index)
    end
end)

RegisterServerEvent("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            outfitName,
            model,
            json.encode(skinData),
            outfitId
        }, function()
            local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
            if result[1] ~= nil then
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
        Player.PlayerData.citizenid,
        outfitName,
        outfitId
    }, function()
        local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('qb-clothing:client:reloadOutfits', src, nil)
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local anusVal = {}

    local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            anusVal[k] = v
        end
        cb(anusVal)
    end
    cb(anusVal)
end)

QBCore.Commands.Add('changeOutfit', 'Open Menu to select your saved Outfits (Admin Only)', {}, false, function(source, _)
    TriggerClientEvent('qb-clothing:client:openOutfitMenu', source)
end, 'admin')

QBCore.Commands.Add('fib', 'Your saved FIB outfit (Admins Only)', {}, false, function(source, _)
    local foundFIBOutfit = false
    local index = getTableIndex(fibs, source)

    if index == nil then

        QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', source, function(result)
            for _, outfit in pairs(result) do
                if not foundFIBOutfit and outfit.outfitname == "FIB" then
                    foundFIBOutfit = true
                    table.insert(fibs, source)
    
                    TriggerClientEvent("qb-clothes:loadSkin", source, false, outfit.model, json.encode(outfit.skin))
                    
                    SetPlayerInvincible(source, true)

                    TriggerClientEvent("QBCore:Notify", source, "FIB-Dienst angetreten.", "success")

                    local coords = QBCore.Functions.GetCoords(GetPlayerPed(source))
                    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, vector3(coords.x, coords.y, coords.z), 20, 'lord', 0.1)
                end
            end
    
            if not foundFIBOutfit then
                TriggerClientEvent("QBCore:Notify", source, "Du hast kein Outfit mit dem Namen 'FIB' abgespeichet!", "error")
            end
        end)

    else

        table.remove(fibs, index)

        local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { QBCore.Functions.GetPlayer(source).PlayerData.citizenid, 1 })
        if result[1] ~= nil then
            TriggerClientEvent("qb-clothes:loadSkin", source, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("qb-clothes:loadSkin", source, true)
        end

        SetPlayerInvincible(source, false)
        TriggerClientEvent("QBCore:Notify", source, "Du bist nicht mehr im FIB-Dienst.", "error")

    end
end, 'admin')