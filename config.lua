Config = {}

Config.AllowedGroups = {    -- add_ace group.admin peak.admin allow
    admin = true,           -- add_ace identifier.steam:11000010xxxxxxx peak.admin allow
    superadmin = true,      -- add_ace identifier.discord:xxxxxxxxxxxxxxx peak.admin allow
    god = true,
}

Config.RequiredAce = "peak.admin"  --/peakhousemenu

Config.Debug = true

-- Webhook URL
Config.Webhook = ""

Config.Locale = "en" -- "da" / "en" / whatever you add later

Config.Locales = {}

Config.Locales["da"] = {
    menu_title = "Peak HouseRobbery – Admin Panel",
    search_player = "🔍 Søg spiller",
    search_player_desc = "Find spiller via navn, ID eller citizenid",

    online_players = "🟢 Online spillere",
    online_players_desc = "Se alle spillere der er online",

    db_profiles = "📁 Peak Profiler (DB)",
    db_profiles_desc = "Se alle profiler registreret af HouseRobbery",

    no_results = "Ingen resultater",
    no_results_desc = "Ingen spillere matchede søgningen.",

    no_online = "Ingen spillere online",
    no_online_desc = "Der er ingen spillere på serveren.",

    no_profiles = "Ingen profiler",
    no_profiles_desc = "Peak DB indeholder ingen profiler.",

    player_actions = "Handlinger for spiller",
    add_coins = "➕ Tilføj Coins",
    remove_coins = "➖ Fjern Coins",
    history = "📜 Vis History",

    modify_add = "Tilføj Coins",
    modify_remove = "Fjern Coins",
    modify_label = "Antal coins",

    coins_updated = "Coins opdateret",
    coins_updated_desc = "%s %s coins for %s",

    history_empty = "Ingen historik",
    history_empty_desc = "Der er ingen registreret historik.",

    search_title = "Søg spiller",
    search_label = "Navn / CID / ID",
    -- SERVER MESSAGES
    server_admin_denied = "Du har ikke adgang til dette.",
    server_invalid_data = "Ugyldige data modtaget.",
    server_apply_success = "Opdaterede %s coins for %s.",
    server_apply_add = "Tilføjede",
    server_apply_remove = "Fjernede",
    -- WEBHOOK
    webhook_title = "Peak HouseRobbery – Coin Update",
    webhook_field_admin = "Admin",
    webhook_field_target = "Target CitizenID",
    webhook_field_peakname = "Peak Navn",
    webhook_field_rpname = "RP Navn",
    webhook_field_action = "Handling",
    webhook_field_amount = "Antal",
    webhook_action_add = "Tilføjede Coins",
    webhook_action_remove = "Fjernede Coins",
    -- DEBUG
    debug_database_test = "Tester database-forbindelse...",
    debug_admin_check = "ADMIN CHECK — PLAYER GROUP:",
    debug_apply = "APPLY %s %s to %s",
    debug_no_webhook = "Ingen webhook konfigureret.",
    debug_invalid_apply = "apply -> invalid data",
}

Config.Locales["en"] = {
    menu_title = "Peak HouseRobbery – Admin Panel",
    search_player = "🔍 Search Player",
    search_player_desc = "Find a player by name, ID or citizenid",

    online_players = "🟢 Online Players",
    online_players_desc = "View all players currently online",

    db_profiles = "📁 Peak Profiles (DB)",
    db_profiles_desc = "View all profiles registered by HouseRobbery",

    no_results = "No results",
    no_results_desc = "No players matched your search.",

    no_online = "No players online",
    no_online_desc = "There are no players on the server.",

    no_profiles = "No profiles",
    no_profiles_desc = "The Peak DB contains no profiles.",

    player_actions = "Player Actions",
    add_coins = "➕ Add Coins",
    remove_coins = "➖ Remove Coins",
    history = "📜 Show History",

    modify_add = "Add Coins",
    modify_remove = "Remove Coins",
    modify_label = "Number of coins",

    coins_updated = "Coins Updated",
    coins_updated_desc = "%s %s coins for %s",

    history_empty = "No History",
    history_empty_desc = "There is no recorded history for this player.",

    search_title = "Search Player",
    search_label = "Name / CID / ID",

    -- SERVER MESSAGES
    server_admin_denied = "You do not have permission to do this.",
    server_invalid_data = "Invalid data received.",
    server_apply_success = "Updated %s coins for %s.",
    server_apply_add = "Added",
    server_apply_remove = "Removed",

    -- WEBHOOK
    webhook_title = "Peak HouseRobbery – Coin Update",
    webhook_field_admin = "Admin",
    webhook_field_target = "Target CitizenID",
    webhook_field_peakname = "Peak Name",
    webhook_field_rpname = "RP Name",
    webhook_field_action = "Action",
    webhook_field_amount = "Amount",
    webhook_action_add = "Added Coins",
    webhook_action_remove = "Removed Coins",

    -- DEBUG
    debug_database_test = "Testing database connection...",
    debug_admin_check = "ADMIN CHECK — PLAYER GROUP:",
    debug_apply = "APPLY %s %s to %s",
    debug_no_webhook = "No webhook configured.",
    debug_invalid_apply = "apply -> invalid data",
}


-- Helper (ingen ændringer nødvendige)
local function L(key)
    local locale = Config.Locale or "da"
    return Config.Locales[locale][key] or ("MISSING LOCALE: "..key)
end

Config.L = L
