local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Get data from the brottsregister, requires the date of birth and the last digits
RegisterServerEvent('jsfour-brottsregister:getPlayerData')
AddEventHandler('jsfour-brottsregister:getPlayerData', function(personnummer, lastdigits)
  local _source = source
  local playerData = {}
  MySQL.Async.fetchAll(
    'SELECT * FROM jsfour_brottsregister WHERE dateofbirth = @dateofbirth AND lastdigits = @lastdigits', {['@dateofbirth'] = personnummer, ['@lastdigits'] = lastdigits},
    function (result)
      if (result[1] ~= nil) then
        for i=1, #result, 1 do
          table.insert(playerData, {
  					firstname = result[i].firstname,
            lastname = result[i].lastname,
            dateofcrime = result[i].dateofcrime,
            crime = result[i].crime
  				})
        end
        TriggerClientEvent('jsfour_brottsregister:searchCallback', _source, false, playerData)
      else
        TriggerClientEvent('jsfour_brottsregister:searchCallback', _source, true, 0)
      end
    end)
end)

-- Add to brottsregister, requires Player ID, date and a reason
RegisterServerEvent('jsfour-brottsregister:add')
AddEventHandler('jsfour-brottsregister:add', function(id, date, reason)
  local identifier = ESX.GetPlayerFromId(id).identifier
  MySQL.Async.fetchAll(
    'SELECT firstname, lastname, dateofbirth, lastdigits FROM users WHERE identifier = @identifier',{['@identifier'] = identifier},
    function(result)
    if (result[1] ~= nil) then
      MySQL.Async.execute(
        'UPDATE jsfour_brottsregister SET lastcrime = @lastcrime WHERE lastdigits = @lastdigits',
        {
          ['@lastdigits'] = result[1].lastdigits,
          ['@lastcrime'] = 0
        },
        function (rowsChanged)
        MySQL.Async.execute('INSERT INTO jsfour_brottsregister (firstname, lastname, dateofbirth, lastdigits, dateofcrime, crime, lastcrime) VALUES (@firstname, @lastname, @dateofbirth, @lastdigits, @dateofcrime, @crime, @lastcrime)',
          {
            ['@firstname']    = result[1].firstname,
            ['@lastname']     = result[1].lastname,
            ['@dateofbirth']  = result[1].dateofbirth,
            ['@lastdigits']   = result[1].lastdigits,
            ['@dateofcrime']  = date,
            ['@crime']        = reason,
            ['@lastcrime']    = 1
          }
        )
      end)
    end
  end)
end)

-- Remove from brottsregister, requires PlayerId
RegisterServerEvent('jsfour-brottsregister:remove')
AddEventHandler('jsfour-brottsregister:remove', function(id)
  local identifier = ESX.GetPlayerFromId(id).identifier
  MySQL.Async.fetchAll(
    'SELECT lastdigits FROM users WHERE identifier = @identifier',{['@identifier'] = identifier},
    function(result)
    if (result[1] ~= nil) then
      MySQL.Async.execute('DELETE FROM jsfour_brottsregister WHERE lastdigits = @lastdigits AND lastcrime = @lastcrime',
      {
        ['@lastdigits']    = result[1].lastdigits,
        ['@lastcrime']     = 1
      }
    )
    end
  end)
end)
