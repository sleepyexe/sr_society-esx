local ox_target = exports.ox_target

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
  ESX.PlayerData.job = job
end)

local function checkAkses(job, akses)
  return ShSociety.Access[job][akses] and ESX.PlayerData.job.grade >=ShSociety.Access[job][akses] and true or false
end

local function fetchData(data)
  if ESX.PlayerData.job.name ~= data.job then
    ESX.ShowNotification('Kamu tidak memiliki akses', 'error')
    return
  end
  local result = lib.callback.await('sr_society:server:getSocietyData', false, {job = data.job})
  lib.progressBar({
    label = 'Membuka Boss Menu',
    duration = 1000,
  })
  local access = {
    withdraw = checkAkses(data.job, 'withdraw'),
    deposit = checkAkses(data.job, 'deposit'),
    hire = checkAkses(data.job, 'hire'),
    fire = checkAkses(data.job, 'fire'),
    setRank = checkAkses(data.job, 'setRank'),
    bonus = checkAkses(data.job, 'bonus'),
  }
  SendNUIMessage({
    action = 'openSociety',
    data = {
      balance = result.balance,
      groups = 'police',
      employees = #result.employees,
      employeeList = result.employees,
      access = access,
      visible = true
    }
  })
  SendNUIMessage({
    action = 'setSocietyGrades',
    data = result.grades
  })
  SetNuiFocus(true, true)
end

CreateThread(function ()
  for i = 1, #ShSociety.Locations do
    local data = ShSociety.Locations[i]
    ox_target:addBoxZone({
      name = data.name or ('BossMenu_%s'):format(i),
      coords = data.coords,
      size = data.size,
      rotation = data.rotation,
      options = {
        {
          label = 'Buka Boss Menu',
          job = data.job,
          groups = data.job,
          onSelect = fetchData
        }
      }
    })
  end
end)

RegisterNUICallback('exit', function(_, cb)
  SetNuiFocus(false, false)
end)

RegisterNUICallback('withdrawMoney', function (data, cb)
  local money = lib.callback.await('sr_society:server:withdrawMoney', false, {amount = tonumber(data.amount), job = data.society})
  Wait(1000)
  cb(money)
end)


RegisterNUICallback('recruitPlayer', function (data, cb)
  if data.grade == "" or data.playerId == "" then
    ESX.ShowNotification('Harap Input Data Yang Benar')
    cb()
    return
  end
  local ret = lib.callback.await('sr_society:server:recruitPlayer', false, {job = data.job, grade = tonumber(data.grade), player = tonumber(data.playerId)})
  cb(ret)
end)

RegisterNUICallback('depositMoney', function (data, cb)
  local result = lib.callback.await('sr_society:server:depositMoney', false, {job = data.society, amount = tonumber(data.amount)})
  cb(result)
end)

RegisterNUICallback('giveBonus', function (data, cb)
  local result = lib.callback.await('sr_society:server:giveBonus', false, {job = data.society, identifier = data.target, amount = tonumber(data.amount)})
  cb(result)
end)


RegisterNUICallback('fireEmployee', function (data, cb)
  local result = lib.callback.await('sr_society:server:fireEmployee', false, {job = data.society, identifier = data.identifier})
  cb({employee = result, count = #result})
end)

RegisterNUICallback('setPlayerRank', function (data, cb)
  local result = lib.callback.await('sr_society:server:setPlayerRank', false, {job = data.job, identifier = data.identifier, grade = tonumber(data.grade)})
  cb(result)
end)