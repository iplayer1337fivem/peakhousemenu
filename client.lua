local L = Config.L

RegisterCommand("peakhousemenu", function()
    OpenMainMenu()
end)

function OpenMainMenu()
    lib.registerContext({
        id = 'peakhouse_main',
        title = L("menu_title"),
        menu = 'peakhouse_main',
        options = {
            {
                title = L("search_player"),
                description = L("search_player_desc"),
                onSelect = SearchPlayerMenu
            },
            {
                title = L("online_players"),
                description = L("online_players_desc"),
                onSelect = OnlinePlayersMenu
            },
            {
                title = L("db_profiles"),
                description = L("db_profiles_desc"),
                onSelect = OfflineProfilesMenu
            },
        }
    })

    lib.showContext('peakhouse_main')
end

function SearchPlayerMenu()
    local input = lib.inputDialog(L("search_title"), {
        { type = "input", label = L("search_label"), required = true }
    })

    if not input then return OpenMainMenu() end

    local query = input[1]
    local results = lib.callback.await("peakhousemenu:search", false, query)

    if not results or #results == 0 then
        lib.notify({
            title = L("no_results"),
            description = L("no_results_desc"),
            type = "error"
        })
        return OpenMainMenu()
    end

    local opts = {}
    for _, p in ipairs(results) do
        opts[#opts+1] = {
            title = ("%s (%s)"):format(p.name, p.citizenid),
            description = ("%s\nRP-navn: %s"):format(
                p.source and ("Online (ID "..p.source..")") or L("db_profiles"),
                p.rp_name or "Ukendt"
            ),
            onSelect = function() PlayerActionMenu(p) end
        }
    end

    lib.registerContext({
        id = 'peakhouse_search_results',
        title = L("search_player"),
        menu = 'peakhouse_main',
        options = opts
    })

    lib.showContext('peakhouse_search_results')
end

function OnlinePlayersMenu()
    local list = lib.callback.await("peakhousemenu:getOnline", false)

    if not list or #list == 0 then
        lib.notify({
            title = L("no_online"),
            description = L("no_online_desc"),
            type = "error"
        })
        return OpenMainMenu()
    end

    local opts = {}
    for _, p in ipairs(list) do
        opts[#opts+1] = {
            title = ("%s (%s)"):format(p.name, p.citizenid),
            description = ("ID: %s\nRP-navn: %s"):format(
                p.source,
                p.rp_name or "Ukendt"
            ),
            onSelect = function() PlayerActionMenu(p) end
        }
    end

    lib.registerContext({
        id = 'peakhouse_online',
        title = L("online_players"),
        menu = 'peakhouse_main',
        options = opts
    })

    lib.showContext('peakhouse_online')
end

function OfflineProfilesMenu()
    local profiles = lib.callback.await("peakhousemenu:getProfiles", false)

    if not profiles or #profiles == 0 then
        lib.notify({
            title = L("no_profiles"),
            description = L("no_profiles_desc"),
            type = "error"
        })
        return OpenMainMenu()
    end

    local opts = {}
    for _, row in ipairs(profiles) do
        opts[#opts+1] = {
            title = ("%s (%s coins)"):format(row.name or row.identifier, row.coins),
            description = ("%s\nRP-navn: %s"):format(
                row.identifier,
                row.rp_name or "Ukendt"
            ),
            onSelect = function()
                PlayerActionMenu({
                    citizenid = row.identifier,
                    name = row.name or row.identifier,
                    rp_name = row.rp_name,
                    source = nil
                })
            end
        }
    end

    lib.registerContext({
        id = 'peakhouse_profiles',
        title = L("db_profiles"),
        menu = 'peakhouse_main',
        options = opts
    })

    lib.showContext('peakhouse_profiles')
end

function PlayerActionMenu(player)
    lib.registerContext({
        id = 'peakhouse_player_actions',
        title = ("%s\nRP-navn: %s"):format(
            player.name,
            player.rp_name or "Ukendt"
        ),
        menu = 'peakhouse_main',
        options = {
            {
                title = L("add_coins"),
                onSelect = function() ModifyCoins(player, "add") end
            },
            {
                title = L("remove_coins"),
                onSelect = function() ModifyCoins(player, "remove") end
            },
            {
                title = L("history"),
                onSelect = function() ShowHistory(player) end
            }
        }
    })

    lib.showContext('peakhouse_player_actions')
end

function ModifyCoins(player, mode)
    local input = lib.inputDialog((mode == "add" and L("modify_add") or L("modify_remove")), {
        { type = "number", label = L("modify_label"), required = true }
    })

    if not input then return PlayerActionMenu(player) end

    TriggerServerEvent("peakhousemenu:apply", {
        citizenid = player.citizenid,
        amount = tonumber(input[1]),
        mode = mode
    })

    lib.notify({
        title = L("coins_updated"),
        description = L("coins_updated_desc"):format(
            mode == "add" and "Tilføjede" or "Fjernede",
            input[1],
            player.citizenid
        ),
        type = "success"
    })

    PlayerActionMenu(player)
end

function ShowHistory(player)
    local history = lib.callback.await("peakhousemenu:getHistory", false, player.citizenid)

    if not history or #history == 0 then
        lib.notify({
            title = L("history_empty"),
            description = L("history_empty_desc"),
            type = "error"
        })
        return PlayerActionMenu(player)
    end

    local opts = {}
    for _, h in ipairs(history) do
        opts[#opts+1] = {
            title = ("%s (%s)"):format(h.contract_name, h.status),
            description = ("Coins: %s | XP: %s"):format(
                h.decoded.coins or "?", 
                h.decoded.xp or "?"
            )
        }
    end

    lib.registerContext({
        id = 'peakhouse_history',
        title = L("history") .. ": " .. player.citizenid,
        menu = 'peakhouse_player_actions',
        options = opts
    })

    lib.showContext('peakhouse_history')
end
