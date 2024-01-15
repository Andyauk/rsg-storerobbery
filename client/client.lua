local RSGCore = exports['rsg-core']:GetCoreObject()
PlayerJob = RSGCore.Functions.GetPlayerData().job

local currentRegister = 0
local usingAdvanced = false
local CurrentLawmen = 0

CreateThread(
    function()
        Wait(1000)
        if RSGCore.Functions.GetPlayerData().job ~= nil and next(RSGCore.Functions.GetPlayerData().job) then
            PlayerJob = RSGCore.Functions.GetPlayerData().job
        end
    end
)

CreateThread(
    function()
        Wait(1000)
        setupRegister()
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = false
            for k in pairs(Config.Registers) do
                local dist = #(pos - Config.Registers[k][1].xyz)
            end
            if not inRange then
                Wait(2000)
            end
            Wait(3)
        end
    end
)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    usingAdvanced = isAdvanced
    local src = source -- Get the source/player ID attempting the action
    local inCooldown = false

    -- Check if the player's action is in cooldown
    for k, register in ipairs(Config.Registers) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Registers[k][1].xyz)
        
        if dist <= 1 and register.time > 0 and register.robbed then
            inCooldown = true
            break -- Exit the loop if in cooldown
        end
    end

    if inCooldown then
        -- Notify the player about the cooldown
        lib.notify({ title = 'You are currently in a cooldown. You can\'t rob this yet.', type = 'error', duration = 5000 })
    else
        -- Proceed with the action (lockpicking, etc.)
        for k, register in ipairs(Config.Registers) do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - Config.Registers[k][1].xyz)
            
            if dist <= 1 and not register.robbed then
                --RSGCore.Functions.TriggerCallback('police:GetCops', function(result)
                RSGCore.Functions.TriggerCallback('rsg-lawman:server:getlaw', function(result)
                    local currentLawmen = result
                    if currentLawmen >= Config.MinimumLawmen then
                        if usingAdvanced then
                            lockpick(true)
                            currentRegister = k
                        else
                            lockpick(true)
                            currentRegister = k
                        end
                    else
                        lib.notify({ title = 'Not enough lawmen on duty!', type = 'error', duration = 5000 })
                    end
                end)
            end
        end
    end
end)

function setupRegister()
    RSGCore.Functions.TriggerCallback(
        'rsg-storerobbery:server:getRegisterStatus',
        function(Registers)
            for k in pairs(Registers) do
                Config.Registers[k].robbed = Registers[k].robbed
            end
        end
    )
end

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage(
        {
            action = 'ui',
            toggle = bool
        }
    )
    SetCursorLocation(0.5, 0.2)
end

local openingDoor = false

-- if success
RegisterNUICallback(
    'success',
    function(_, cb)
        if currentRegister ~= 0 then
            lockpick(false)
            if Config.Alerts == true then
                --TriggerServerEvent('police:server:policeAlert', 'People are tampering with registers')
                TriggerServerEvent('rsg-lawman:server:lawmanAlert', 'People are tampering with registers')
            end
            TriggerServerEvent('rsg-storerobbery:server:setRegisterStatus', currentRegister)
            local lockpickTime = 60000
            RSGCore.Functions.Progressbar(
                'search_register',
                'Stealing Cash',
                lockpickTime,
                false,
                true,
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
                {
                    animDict = 'script_ca@cachr@ig@ig4_vaultloot',
                    anim = 'ig13_14_grab_money_front01_player_zero',
                    flags = 1
                },
                {},
                {},
                function()
                    -- Done
                    openingDoor = false
                    ClearPedTasks(PlayerPedId())
                    print('Success')
                    TriggerServerEvent('rsg-storerobbery:server:takeMoney')
                    if Config.RewardType == false then
                        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'coins', 90.0)
                    end
                end,
                function()
                    -- Cancel
                    openingDoor = false
                    ClearPedTasks(PlayerPedId())
                    lib.notify({title = 'Lockpick Cancelled', type = 'error', duration = 5000})
                    currentRegister = 0
                end
            )
            CreateThread(
                function()
                    while openingDoor do
                        TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                        Wait(10000)
                    end
                end
            )
        else
            SendNUIMessage(
                {
                    action = 'kekw'
                }
            )
        end
        cb('ok')
    end
)

--if fail
RegisterNUICallback(
    'fail',
    function(_, cb)
        if usingAdvanced then
            if math.random(1, 100) < Config.AdvLockpickBreak then
                TriggerServerEvent('rsg-storerobbery:server:RemoveItem', 'advancedlockpick', 1)
                TriggerEvent('inventory:client:ItemBox', RSGCore.Shared.Items['advancedlockpick'], 'remove')
            end
        else
            if math.random(1, 100) < Config.LockpickBreak then
                TriggerServerEvent('rsg-storerobbery:Server:RemoveItem', 'lockpick', 1)
                TriggerEvent('inventory:client:ItemBox', RSGCore.Shared.Items['lockpick'], 'remove')
            end
        end
        lockpick(false)
        cb('ok')
    end
)

RegisterNUICallback(
    'exit',
    function(_, cb)
        lockpick(false)
        cb('ok')
    end
)

RegisterNetEvent(
    'rsg-storerobbery:client:setRegisterStatus',
    function(batch, val)
        -- Has to be a better way maybe like adding a unique id to identify the register
        if (type(batch) ~= 'table') then
            Config.Registers[batch] = val
        else
            for k in pairs(batch) do
                Config.Registers[k] = batch[k]
            end
        end
    end
)
