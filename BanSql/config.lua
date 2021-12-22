Config                   = {}

--GENERAL
Config.Permission        = "admin" -- Perm qui peuvent faire les commandes
Config.ForceSteam        = true    -- Autotification Steam 
Config.MultiServerSync   = false   --This will check if a ban is add in the sql all 30 second, use it only if you have more then 1 server (true-false)


--WEBHOOK
Config.EnableDiscordLink = true --Logs Discord
Config.webhookban        = "https://discord.com/api/webhooks/921846612010094613/uCeNshLx3rI_l-tjNOkcJIAohv5u3ZtVrDkxWhQvFgvA8qONGENP1VtNgANIksK72Ozb"
Config.webhookunban      = "https://discord.com/api/webhooks/921846612010094613/uCeNshLx3rI_l-tjNOkcJIAohv5u3ZtVrDkxWhQvFgvA8qONGENP1VtNgANIksK72Ozb"


--LANGUAGE
Config.TextFr = {
	start         = "[Version New ESX] La BanList et l'historique a ete charger avec succes",
	starterror    = "[Version New ESX] ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.",
	banlistloaded = "[Version New ESX] BanList a ete charger avec succes.",
	historyloaded = "[Version New ESX] BanListHistory a ete charger avec succes.",
	loaderror     = "[Version New ESX] ERREUR : La BanList n a pas été charger.",
	cmdban        = "/sqlban (ID) (Durée en jours) (Raison)",
	cmdbanchat 	  = "ID | Durée en jours | Raison",
	cmdbanoff     = "/sqlbanoffline (Permid) (Durée en jours) (Raison)",
	cmdhistory    = "/sqlbanhistory (Steam name) ou /sqlbanhistory 1,2,2,4......",
	noreason      = "Raison Inconnue",
	during        = " pendant : ",
	noresult      = "Il n'y a pas autant de résultats !",
	isban         = " a été ban",
	isunban       = " a été déban",
	invalidsteam  =  "Vous devriez ouvrir steam",
	invalidid     = "ID du joueur incorrect",
	invalidname   = "Le champ n'est pas valide",
	invalidtime   = "Duree du ban incorrecte",
	alreadyban    = " étais déja bannie pour : ",
	yourban       = "Vous avez ete ban pour : ",
	yourpermban   = "Vous avez ete ban permanent pour : ",
	youban        = "Vous avez banni : ",
	forr          = " jours. Pour : ",
	permban       = " de facon permanente pour : ",
	timeleft      = ". Il reste : ",
	toomanyresult = "Trop de résultats, veillez être plus précis.",
	day           = " Jours ",
	hour          = " Heures ",
	minute        = " Minutes ",
	by            = "par",
	ban           = "Bannir un joueurs qui est en ligne",
	banoff        = "Bannir un joueurs qui est hors ligne",
	bansearch     = "Trouver l'id permanent d'un joueur qui est hors ligne",
	dayhelp       = "Nombre de jours",
	reason        = "Raison du ban",
	permid        = "Trouver l'id permanent avec la commande (sqlsearch)",
	history       = "Affiche tout les bans d'un joueur",
	reload        = "Recharge la BanList et la BanListHistory",
	unban         = "Retirez un ban de la liste",
	steamname     = "(Nom Steam)",
}
