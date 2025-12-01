Remeber to set this into server.cfg or permissions.cfg or equalent

```
add_ace group.admin peak.admin allow
add_ace group.owner peak.admin allow
```

📘 PeakHouseMenu – Admin Coin Manager for Peak HouseRobbery

PeakHouseMenu is an administrative tool designed for servers using the Peak HouseRobbery script.
It allows trusted staff members to easily:

🔍 Search for any player (online or offline)
🟢 View all currently online players
📁 Browse all Peak HouseRobbery profiles stored in the database
➕ Add coins to a player
➖ Remove coins from a player
📜 View detailed robbery history for each player
📨 Send automatic Discord webhook logs

Everything is done through a clean ox_lib UI, with full support for RP names, Peak names, and citizenid-based lookup.
📦 Features
Fully localized (English + Danish included)
Works with QBX 1.23+
Automatically fetches:
RP name from players table
Peak name from peak_houserobbery_profiles
Robbery history from peak_houserobbery_history
Admin permission check (QBX groups or ACE perms)
Webhook support for logging all coin changes
Clean and intuitive ox_lib menu structure

🛠️ Installation
Drag the folder peakhousemenu into your resources directory.
Add the resource to your server.cfg:
ensure peakhousemenu

Make sure your server uses:
ox_lib
oxmysql
qbx_core
peak_houserobbery

Set up admin permissions using either:

QBX groups: admin / god / owner

OR ACE:

add_ace group.admin peak.admin allow

🌍 Changing the Script Language to English
This script includes a full localization system inside config.lua.
To use English:
1. Open config.lua
Find this line:
Config.Locale = "da"
Change "da" to "en":
Config.Locale = "en"

That’s it!

The entire admin panel will now display all text in English, including:
Menu titles
Buttons
Descriptions
Error messages
Server notifications
Webhook messages
🎮 Usage (In-game)
Admin opens the panel via:
/peakhousemenu

From the menu you can:
Search for any player
View online players
Browse database profiles
Add or remove coins
View robbery history
Ideal for staff members handling support, refunds, or punishments.

🔧 Webhook Integration
Insert your webhook URL in config.lua:
Config.Webhook = "YOUR_DISCORD_WEBHOOK_URL"

The script will automatically send embeds showing:
Admin name + ID
Target citizenid
RP name
Peak name
Action taken (add/remove coins)
Amount changed
Timestamp
Perfect for auditing/admin transparency.