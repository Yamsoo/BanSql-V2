

function cmdban(source, args)
	local license,identifier,liveid,xblid,discord,playerip
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)


	if args[1] then		
		if reason == "" then
			reason = Text.noreason
		end
		if target and target > 0 then
			local ping = GetPlayerPing(target)
        
			if ping and ping > 0 then
				if duree and duree < 365 then
					local targetplayername = GetPlayerName(target)
					local sourceplayername = ""
					if source == false then
						sourceplayername = "Console"
					else
						sourceplayername = source.name
					end

						for k,v in ipairs(GetPlayerIdentifiers(target))do
							if string.sub(v, 1, string.len("license:")) == "license:" then
								license = v
							elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
								identifier = v
							elseif string.sub(v, 1, string.len("live:")) == "live:" then
								liveid = v
							elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
								xblid  = v
							elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
								discord = v
							elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
								playerip = v
							end
						end
				
					if duree > 0 then
						ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
						DropPlayer(target, Text.yourban .. reason)
					else
						ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
						DropPlayer(target, Text.yourpermban .. reason)
					end
				
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
				end	
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidid)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdban)
	end
end

function cmdunban(source, args)
	if args[1] then
	local target = table.concat(args, " ")
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE license like @playername', 
	{
		['@playername'] = ("%"..target.."%")
	}, function(data)
		if data[1] then
			if #data > 1 then
				TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
				for i=1, #data, 1 do
					TriggerEvent('bansql:sendMessage', source, data[i].license)
				end
			else
				MySQL.Async.execute(
				'DELETE FROM banlist WHERE license = @name',
				{
				  ['@name']  = data[1].license
				},
					function ()
					loadBanList()
						local sourceplayername = ""
						if source == false then
							sourceplayername = "Console"
						else
							sourceplayername = source.name
						end
						local message = (data[1].license .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
						sendToDiscord(Config.webhookunban, message)
					TriggerEvent('bansql:sendMessage', source, data[1].license .. Text.isunban)
				end)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end

	end)
	else
		TriggerEvent('bansql:sendMessage', source, Text.invalidname)
	end
end

function cmdbanoffline(source, args)
	if args ~= "" then
		local target           = args[1]
		local duree            = tonumber(args[2])
		local reason           = table.concat(args, " ",3)
		local sourceplayername = ""
		print(target)
		if source == false then
			sourceplayername = "Console"
		else
			sourceplayername = source.name
		end

		if duree ~= "" then
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE license = @license', 
				{
					['@license'] = "license:"..target
				}, function(data)
					if data[1] then
						if duree and duree < 365 then
							if reason == "" then
								reason = Text.noreason
							end
							if duree > 0 then --Here if not perm ban
								ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,0) --Timed ban here
							else --Here if perm ban
								ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].playername,sourceplayername,duree,reason,1) --Perm ban here
							end
						else
							TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidid)
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
	end
end

function cmdbanhistory(source, args)
	if args[1] and BanListHistory then
	local nombre = (tonumber(args[1]))
	local name   = table.concat(args, " ",1)
		if name ~= "" then
			if nombre and nombre > 0 then
				local expiration = BanListHistory[nombre].expiration
				local timeat     = BanListHistory[nombre].timeat
				local calcul1    = expiration - timeat
				local calcul2    = calcul1 / 86400
				local calcul2 	 = math.ceil(calcul2)
				local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)

				TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
			else
				for i = 1, #BanListHistory, 1 do
					if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
						local expiration = BanListHistory[i].expiration
						local timeat     = BanListHistory[i].timeat
						local calcul1    = expiration - timeat
						local calcul2    = calcul1 / 86400
						local calcul2 	 = math.ceil(calcul2)					
						local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[i].added)

						TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
					end
				end
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.invalidname)
		end
	else
		TriggerEvent('bansql:sendMessage', source, Text.cmdhistory)
	end
end

function sendToDiscord(canal,message)
	local DiscordWebHook = canal
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
	MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..targetplayername.."%")
	}, function(data)
		if not data[1] then
			local expiration = duree * 86400 --calcul total expiration (en secondes)
			local timeat     = os.time()
			local added      = os.date()

			if expiration < os.time() then
				expiration = os.time()+expiration
			end
			
			table.insert(BanList, {
				license    = license,
				identifier = identifier,
				liveid     = liveid,
				xblid      = xblid,
				discord    = discord,
				playerip   = playerip,
				reason     = reason,
				expiration = expiration,
				permanent  = permanent
			  })

			MySQL.Async.execute(
					'INSERT INTO banlist (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = reason,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
					['@permanent']        = permanent,
					},
					function ()
			end)

			if permanent == 0 then
				TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
			else
				TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
			end

			if Config.EnableDiscordLink then
				local license1,identifier1,liveid1,xblid1,discord1,playerip1,targetplayername1,sourceplayername1,message
				if not license          then license1          = "N/A" else license1          = license          end
				if not identifier       then identifier1       = "N/A" else identifier1       = identifier       end
				if not liveid           then liveid1           = "N/A" else liveid1           = liveid           end
				if not xblid            then xblid1            = "N/A" else xblid1            = xblid           end
				if not discord          then discord1          = "N/A" else discord1          = discord          end
				if not playerip         then playerip1         = "N/A" else playerip1         = playerip         end
				if not targetplayername then targetplayername1 = "N/A" else targetplayername1 = targetplayername end
				if not sourceplayername then sourceplayername1 = "Joueur Inconnu" else sourceplayername1 = sourceplayername end
				if permanent == 0 then
					message = (targetplayername1..Text.isban.." "..duree..Text.forr..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."```")
				else
					message = (targetplayername1..Text.isban.." "..Text.permban..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."\n"..playerip1.."```")
				end
				sendToDiscord(Config.webhookban, message)
			end

			MySQL.Async.execute(
					'INSERT INTO banlisthistory (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = reason,
					['@added']            = added,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
					['@permanent']        = permanent,
					},
					function ()
			end)
			
			BanListHistoryLoad = false
		else
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. Text.alreadyban .. reason))
		end
	end)
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
    end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				license          = data[i].license,
				identifier       = data[i].identifier,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanList()
	end)
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		for i = 1, #BanList, 1 do
			if 
				  ((tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord) 
				or (tostring(BanList[i].playerip)) == tostring(playerip)) 
			then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break

				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

					deletebanned(license)
					break

				end
			end
		end
	end
end