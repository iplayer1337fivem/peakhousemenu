local L = Config.L
local DB = Config.Database 

CreateThread(function()
    Wait(2000)
    print("^3[PEAK DEBUG]^7 " .. L("debug_database_test"))

    local ok, result = pcall(function()
        return exports.oxmysql:executeSync("SHOW DATABASES;")
    end)

    print("^2[PEAK TEST]^7 pcall OK:", ok)
    print("^2[PEAK TEST]^7 RESULT:", json.encode(result))
end)

local function Debug(msg)
    if Config.Debug then
        print("^6[PEAK DEBUG]^7 " .. tostring(msg))
    end
end

local function safeCID(src)
    local p = exports.qbx_core:GetPlayer(src)
    return p and p.PlayerData and p.PlayerData.citizenid or nil
end

local function IsAdmin(src)
    local p = exports.qbx_core:GetPlayer(src)
    if not p then return false end

    local group = p.PlayerData.group
    Debug(L("debug_admin_check") .. " " .. tostring(group))

    if group == "admin" or group == "god" or group == "owner" then 
        return true 
    end

    if IsPlayerAceAllowed(src, "peak.admin") then return true end

    return false
end

local function getOnlinePlayers()
    local results = {}

    for _, id in ipairs(GetPlayers()) do
        local p = exports.qbx_core:GetPlayer(tonumber(id))
        if p then
            results[#results + 1] = {
                source = tonumber(id),
                citizenid = p.PlayerData.citizenid,
                name = ("%s %s"):format(
                    p.PlayerData.charinfo.firstname,
                    p.PlayerData.charinfo.lastname
                ),
                rp_name = ("%s %s"):format(
                    p.PlayerData.charinfo.firstname,
                    p.PlayerData.charinfo.lastname
                )
            }
        end
    end

    return results
end

local function getPeakProfiles()
    local sql = string.format([[
        SELECT identifier, name, coins, xp, created_at, last_login
        FROM %s.peak_houserobbery_profiles
        ORDER BY coins DESC
        LIMIT 300
    ]], DB)

    local rows = exports.oxmysql:executeSync(sql) or {}

    for _, row in ipairs(rows) do
        local rp = exports.qbx_core:GetPlayerByCitizenId(row.identifier)
        if rp then
            local info = rp.PlayerData.charinfo
            row.rp_name = ("%s %s"):format(info.firstname, info.lastname)
        else
            row.rp_name = "Ukendt"
        end
    end

    return rows
end

local function getPlayerHistory(cid)
    local sql = string.format([[
        SELECT contract_name, status, timestamp, data, created_at
        FROM %s.peak_houserobbery_history
        WHERE identifier = ?
        ORDER BY created_at DESC
        LIMIT 50
    ]], DB)

    local rows = exports.oxmysql:executeSync(sql, { cid }) or {}

    for _, r in ipairs(rows) do
        local ok, decoded = pcall(function()
            return json.decode(r.data)
        end)
        r.decoded = ok and decoded or {}
    end

    return rows
end

lib.callback.register("peakhousemenu:search", function(source, query)
    if not IsAdmin(source) then return {} end
    if not query then return {} end

    query = query:lower()
    local results = {}

    -- Online search
    for _, p in ipairs(getOnlinePlayers()) do
        if p.name:lower():find(query) or p.citizenid:lower():find(query) then
            results[#results+1] = p
        end
    end

    -- Offline profiles
    for _, row in ipairs(getPeakProfiles()) do
        if row.identifier:lower():find(query) then
            results[#results+1] = {
                source = nil,
                citizenid = row.identifier,
                name = row.name or row.identifier,
                rp_name = row.rp_name
            }
        end
    end

    return results
end)

lib.callback.register("peakhousemenu:getOnline", function(source)
    if not IsAdmin(source) then return {} end
    return getOnlinePlayers()
end)

lib.callback.register("peakhousemenu:getProfiles", function(source)
    if not IsAdmin(source) then return {} end
    return getPeakProfiles()
end)

lib.callback.register("peakhousemenu:getHistory", function(source, cid)
    if not IsAdmin(source) then return {} end
    return getPlayerHistory(cid)
end)

local function SendWebhook(adminName, adminId, targetCid, peakName, rpName, mode, amount)

    if not Config.Webhook or Config.Webhook == "" then
        Debug(L("debug_no_webhook"))
        return
    end

    local color = mode == "add" and 3066993 or 15158332

    local embed = {{
        ["title"] = L("webhook_title"),
        ["color"] = color,
        ["fields"] = {
            { name = L("webhook_field_admin"), value = ("%s (ID %s)"):format(adminName, adminId) },
            { name = L("webhook_field_target"), value = targetCid, inline = true },
            { name = L("webhook_field_peakname"), value = peakName or "Ukendt", inline = true },
            { name = L("webhook_field_rpname"), value = rpName or "Ukendt", inline = true },
            { name = L("webhook_field_action"), value = mode == "add" and L("webhook_action_add") or L("webhook_action_remove"), inline = true },
            { name = L("webhook_field_amount"), value = tostring(amount), inline = true },
        },
        ["footer"] = { text = os.date("%Y-%m-%d %H:%M:%S") }
    }}

    PerformHttpRequest(Config.Webhook, function() end, "POST", json.encode({ embeds = embed }), {
        ["Content-Type"] = "application/json"
    })
end

RegisterNetEvent("peakhousemenu:apply", function(data)
    local src = source
    if not IsAdmin(src) then
        TriggerClientEvent("ox_lib:notify", src, { 
            title = "Error", 
            description = L("server_admin_denied"), 
            type = "error" 
        })
        return
    end

    local cid = data.citizenid
    local amount = tonumber(data.amount)
    local mode = data.mode

    if not cid or not amount or not mode then
        Debug(L("server_invalid_data"))
        return
    end

    Debug(L("debug_apply"):format(mode, amount, cid))

    local prof = exports.oxmysql:executeSync(
        "SELECT name FROM peak_houserobbery_profiles WHERE identifier = ?", 
        { cid }
    )
    local peakName = prof and prof[1] and prof[1].name or "Ukendt"

    local rpInfo = exports.oxmysql:executeSync(
        "SELECT charinfo FROM players WHERE citizenid = ?", 
        { cid }
    )

    local rpName = "Ukendt"
    if rpInfo and rpInfo[1] and rpInfo[1].charinfo then
        local ok, char = pcall(json.decode, rpInfo[1].charinfo)
        if ok and char.firstname then
            rpName = ("%s %s"):format(char.firstname, char.lastname or "")
        end
    end

    if mode == "add" then
        exports['peak_houserobbery']:addCoins(cid, amount)
    else
        exports['peak_houserobbery']:removeCoins(cid, amount)
    end

    SendWebhook(GetPlayerName(src), src, cid, peakName, rpName, mode, amount)

    local verb = mode == "add" and L("server_apply_add") or L("server_apply_remove")

    TriggerClientEvent("ox_lib:notify", src, {
        title = L("coins_updated"),
        description = (L("server_apply_success")):format(verb, cid),
        type = "success"
    })
end)

print("^2[PEAK ADMIN]^7 server.lua ready ✓")
