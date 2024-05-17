types = {}

function addTypeHook(name, from, to, options, callback)
    types[name] = {
        from = from,
        to = to,
        options = options,
        callback = callback
    }
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if GetResourceState('ox_inventory') ~= 'started' then
        print('^1[logs] ^0ox_inventory is not started.')
        return
    end
    for name, data in pairs(types) do
        exports.ox_inventory:registerHook(
            'swapItems',
            function(payload)
                if payload.fromType == data.from and payload.toType == data.to then
                    --print('^3[logs] ^0' .. name .. ' type hook triggered.')
                    data.callback(payload)
                end
                --print(json.encode(payload, { indent = true }))
            end,
            data.options
        )
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:removeHooks()
end)
