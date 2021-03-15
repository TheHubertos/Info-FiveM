ESX 			    			= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

webhook = "TFUJ_WEBHUK_LOL"

RegisterServerEvent('wolfi_log')
AddEventHandler('wolfi_log', function(message, color)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ExperienceRP", embeds = {{["color"] = color,["title"] = "Informacje o graczu",["description"] = "".. message .."",["footer"] = {["text"] = "ExperienceRP"},}},}), { ['Content-Type'] = 'application/json' })
end)

RegisterCommand('info', function(playerId, args, rawCommand)
	if playerId == 0 then
		print('Nie możesz użyć tej komendy z poziomu konsoli!')
	else
		local target = tonumber(args[1])
		local xTarget = ESX.GetPlayerFromId(target)
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local group = xPlayer.getGroup()
		local ids = ExtractIdentifiers(target)

		if group ~= 'user' then
			TriggerClientEvent('esx:showNotification', playerId, "Akcja wykonana pomyślnie!")
			TriggerEvent('wolfi_log', "**Nick:** "..GetPlayerName(playerId).."\n**Identyfikator:** "..xTarget.getIdentifier().."\n**Discord:** <@"..ids.discord:gsub("discord:", "")..">\n**Licencja: **"..ids.license.."\n**Imię Nazwisko:** ".. xTarget.getName() .."\n**Stan Konta:** ".. xTarget.getAccount('bank').money .."$\n**Stan gotówki:** ".. xTarget.getMoney() .."$\n **Grupa:** "..xTarget.getGroup().."\n**Praca:** "..xTarget.job.label.. " - "..xTarget.job.grade_label.." (".. xTarget.job.grade..")".."\n**Praca2:** "..xTarget.job2.label.. " - "..xTarget.job2.grade_label.." (".. xTarget.job2.grade..") \n**Koordynaty: **"..xPlayer.getCoords(true), "1")
        else
            TriggerClientEvent('esx:showNotification', playerId, 'Brak dostępu!')
        end
	end
end, false)