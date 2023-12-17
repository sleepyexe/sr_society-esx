local ox_inventory = exports.ox_inventory

local Jobs = {}
local employeeData = {}
local query = false

AddEventHandler('onResourceStart', function (res)
	if res ~= GetCurrentResourceName() then return end
	if query then return end
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end
	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if ESX.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0 due to no job grades found'):format(v.name))
		end
	end


	local retdata = MySQL.query.await('SELECT `job`, `identifier`, `firstname`, `lastname`, `job_grade` FROM users')
	for k, v in pairs(retdata) do
		if not employeeData[v.job] then
			employeeData[v.job] = {}
		end
		employeeData[v.job][v.identifier] = {
			identifier = v.identifier,
			name = (v.firstname..' '..v.lastname) or '',
			grade = Jobs[v.job].grades[tostring(v.job_grade)].label,
		}
	end
	query = true
end)

-- Keep The Cache Update
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer, job)
	local xPly = xPlayer
	if not employeeData[xPly.job.name] then
		employeeData[xPly.job.name] = {}
		employeeData[xPly.job.name][xPly.identifier] = {
			identifier = xPly.identifier,
			name = xPly.getName,
			grade = xPly.job.grade_label,
		}
	end
end)

-- Keep The Cache Update When Setjob Via Command
RegisterNetEvent('esx:setJob', function (source, job, lastjob)
	local xPlayer = ESX.GetPlayerFromId(source)

	if lastjob.name ~= job.name or lastjob.grade_label ~= job.grade_label then
		if employeeData[lastjob.name] then
			employeeData[lastjob.name][xPlayer.identifier] = nil
		end

		if not employeeData[job.name] then
			employeeData[job.name] = {}
		end

		employeeData[job.name][xPlayer.identifier] = {
			identifier = xPlayer.identifier,
			name = xPlayer.getName(),
			grade = job.grade_label,
		}
	end
end)

-- need to loop to prevent nill value
local function fetchEmployee(job, name)
	local employees = {}
	local id = 0
	for k, v in pairs(employeeData[job]) do
		if v.name ~= name then
			id += 1
			employees[#employees+1] = {
				id = id,
				name = v.name,
				grade = v.grade,
				identifier = v.identifier
			}
		end
	end
	return employees
end

lib.callback.register("sr_society:server:getSocietyData", function(src, data)
	local xPlayer = ESX.GetPlayerFromId(src)
	local job = data.job
	local gradeInfo = {}
	local balance = 0
	local employees = {}

	for k, v in pairs(Jobs[job].grades) do
		if v.grade <= xPlayer.job.grade then
			gradeInfo[#gradeInfo+1] = {
					grade = k,
					grade_label = v.label
				}
		end
	end

	if employeeData[job] then
		local id = 0
		for k, v in pairs(employeeData[job]) do
			if v.name ~= xPlayer.getName() then
				id += 1
				employees[#employees+1] = {
					id = id,
					name = v.name,
					identifier = v.identifier,
					grade = v.grade
				}
			end
		end
	end

	TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(account)
		if account then
			balance = account.money
		end
	end)
	return { grades = gradeInfo, employees = employees, balance = balance, job = xPlayer.getJob().grade_name }
end)

lib.callback.register("sr_society:server:withdrawMoney", function(src, data)
	local job = data.job
	local xPlayer = ESX.GetPlayerFromId(src)
	local amount = data.amount
	local balance = 0
	TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(account)
		if amount > 0 and account.money >= amount then
			balance = account.money - amount
			account.removeMoney(amount)
			xPlayer.addMoney(amount, "Kontol")
			xPlayer.showNotification("Lu Kontol")
		else
			xPlayer.showNotification("Memet Kontol Jamet")
		end
	end)
	return balance
end)

lib.callback.register("sr_society:server:depositMoney", function(src, data)
	local job = data.job
	local xPlayer = ESX.GetPlayerFromId(src)
	local uang = ox_inventory:Search(xPlayer.source, "count", "money")
	local balance = 0
	ox_inventory:RemoveItem(xPlayer.source, "money", data.amount)
	TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(account)
		if account then
			if uang >= data.amount then
				balance = account.money + data.amount
				account.addMoney(data.amount)
			else
				balance = account.money
                xPlayer.showNotification('Tidak memiliki cukup uang')
                return balance
			end
			xPlayer.showNotification("Anjay Mabar Kontol Memek Jamet Pepek")
		else
			xPlayer.showNotification("Memet Kontol Jamet")
		end
	end)
	return balance
end)


lib.callback.register('sr_society:server:recruitPlayer', function (src, data)
    local job = data.job
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(data.player)

    if xPlayer.source == data.player then
        xPlayer.showNotification('Tidak bisa set job ke diri sendiri', 'error')
		return
    end

    if not xTarget then
        xPlayer.showNotification('Player Yang Dituju sedang tidak online', 'error')
		return
	end

	if xTarget.getJob().name ~= 'unemployed' then
		xPlayer.showNotification('Player Tersebut Masih memiliki Pekerjaan', 'error')
		return
	end

    if ESX.DoesJobExist(job, data.grade) then
        xTarget.setJob(job, data.grade)
        xPlayer.showNotification('Kamu berhasil recruit')
        xTarget.showNotification(('Kamu di recruit oleh %s'):format(xPlayer.getName()))
    end

	employeeData[job][xTarget.identifier] = {
		name = xTarget.getName,
		identifier = xTarget.identifier,
		grade = Jobs[job].grades[tostring(data.grade)].label,
	}

	local employees = fetchEmployee(job, xPlayer.getName())
	return {employeeList = employees, employees = #employees}
end)

lib.callback.register('sr_society:server:fireEmployee', function (src, data)
	local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromIdentifier(data.identifier)

	if xTarget then
		xTarget.setJob('unemployed', 0)
		xTarget.showNotification('Kamu telah dikeluarkan', 'info')
		xPlayer.showNotification('Berhasil memecat player tersebut')
	else
		MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
			"unemployed", "0", data.identifier
		})
		xPlayer.showNotification('Berhasil memecat player tersebut')
	end
	-- persistence update
	if employeeData[data.job][data.identifier] then
		employeeData[data.job][data.identifier] = nil
	end
	local employees = fetchEmployee(data.job, xPlayer.getName())
	return employees
end)

lib.callback.register('sr_society:server:giveBonus', function (source, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = data.job
	local xTarget = ESX.GetPlayerFromIdentifier(data.identifier)
	local balance = 0
	TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(account)
		if account then
			if not xTarget then
				balance = account.money
				xPlayer.showNotification('Tidak bisa memberi bonus ke warga yang tidak ada didalam kota', 'error')
			else
				account.removeMoney(data.amount)
				balance = account.money - data.amount
				ox_inventory:AddItem(xTarget.source, 'money', data.amount)
				xPlayer.showNotification("Berhasil Memberikan Bonus")
			end
		else
			xPlayer.showNotification("Memet Kontol Jamet")
		end
	end)
	return balance
end)

lib.callback.register('sr_society:server:setPlayerRank', function (src, data)
	local xPlayer = ESX.GetPlayerFromId(src)
	local job = data.job
	local xTarget = ESX.GetPlayerFromIdentifier(data.identifier)
	if xTarget then
		xTarget.setJob(job, data.grade)
		xTarget.showNotification('Kamu mendapat kenaikan jabatan')
	else
		MySQL.update("UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?", {
			job , data.grade, data.identifier
		})
	end
	-- persistence update
	employeeData[job][data.identifier].grade = Jobs[job].grades[tostring(data.grade)].label
	Wait(100)
	local employees = fetchEmployee(data.job, xPlayer.getName())
	return employees
end)

lib.addCommand('migrasibcs', {
	help = 'Migrasi bcs_licensemanager',
    params = {
        {
            name = 'job',
            type = 'string',
            help = 'Job',
        },
    },
	restricted = 'group.superadmin',
}, function (source, args, raw)
	local uang = MySQL.single.await('SELECT money FROM jobs WHERE name = ?', {
		args.job
	})
	if not uang then return end
	print(uang.money)

	TriggerEvent('esx_addonaccount:getSharedAccount', ('society_%s'):format(args.job), function (account)
		if account then
			account.setMoney(uang.money)
			print('Uang Sudah Di Update Ke Script sr_society',account.money)
		end
	end)
end)