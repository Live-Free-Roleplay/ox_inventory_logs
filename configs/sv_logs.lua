webhooks = {
    ['drop'] = 'https://discord.com/api/webhooks/1240815074395033650/xQExw-fFBG7hhvMjM-87SF-0KxhIVckJbW3_Tfk5wIUPWn0cTXnlTulaTr3j_5DcGHfP',
    ['pickup'] = 'https://discord.com/api/webhooks/1240813751494774877/wNhPfbOYeWisOLXn4ITDkl5xkFXvI1IKvtU_-MsKeCGaBQuz6YuyGEXvH1DtU5kI3DRW',
    ['give'] = 'https://discord.com/api/webhooks/1240813751494774877/wNhPfbOYeWisOLXn4ITDkl5xkFXvI1IKvtU_-MsKeCGaBQuz6YuyGEXvH1DtU5kI3DRW',
    ['stash'] = 'https://discord.com/api/webhooks/1240815200186269866/7zDjn1RKiTOg8bTEwlP9PUnGarqh8iHGs-owOq6SNZXme3UN2yNyxSBBQLboXyi4Mg3e',
    ['trunk'] = 'https://discord.com/api/webhooks/1240815253433090098/bYJbxcYpeBegF4zplxdvy5vYxk9S8smtzM9Zl4xtQYiXP6Jipr7jfw0B-4mqRgs5QUA_',
    ['glovebox'] = 'https://discord.com/api/webhooks/1240815296630099978/DdgZTDi8_k8zsWdBs0JVpOBTa89VVT3o4iZUihiZU0DJmOqO5g4gp5wVOQkqe-IufPGi',
    ['storage'] = 'https://discord.com/api/webhooks/1240815332982128681/C8NELOOPQm5jwjJJCGJsaTdE6mnclozxhtaRWymq3MNsBYx6IiRv-FHK6Sb99OoHWJvI',
    ['bag'] = 'https://discord.com/api/webhooks/1240821759612289125/4Vhpfy5xVWHa0ba1Ifrw0vr2CQl4jb8IrhSpU1jBo_RlnhRTl8MQYtmNrClR4iHhpn3H',
    ['shop'] = 'https://discord.com/api/webhooks/1240826888109162547/B47iFRg4wgezmlK8gX7SQUqH5WfavzNCSjEBzlssdjpHdZRYeG6t5iIxR1hSsQBM5Kgz',
}

--[[ 
Inventory Types
'player'
'shop'
'stash'
'crafting'
'container'
'drop'
'glovebox'
'trunk'
'dumpster'

Ex. Options
{
    itemFilter = {
        water = true,
    },
    inventoryFilter = {
        '^glove[%w]+',
        '^trunk[%w]+',
    },
    typeFilter = {
        player = true,
    },
}

]]--

hooks = {
    ['shop'] = {
        from = 'shop',
        to = 'player',
        type = 'buyItem',
        options = {},
        callback = function(payload)
            local playerName = GetPlayerName(payload.toInventory)
            local playerIdentifier = GetPlayerIdentifiers(payload.toInventory)[1]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.toInventory))
            sendWebhook('shop', {
                {
                    title = 'Shop',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) from shop **%s** for %s at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.toInventory,
                            payload.itemName,
                            payload.count,
                            json.encode(payload.metadata),
                            payload.shopType,
                            payload.price,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['bag_to'] = {
        from = 'player',
        to = 'stash',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
            inventoryFilter = {
                '^bag[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('bag', {
                {
                    title = 'Bag',
                    description = ('Player **%s** (%s, %s) **gave** item **%s** x%s (metadata: %s) **to bag %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['bag_from'] = {
        from = 'stash',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                stash = true,
            },
            inventoryFilter = {
                '^bag[%w]+',
		    }
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('bag', {
                {
                    title = 'Bag',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from bag %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['storage_to'] = {
        from = 'player',
        to = 'stash',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
            inventoryFilter = {
				'^STORAGE_UNIT_[%w]+',
				'^locker[%w]+',
		    }
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('storage', {
                {
                    title = 'Storage',
                    description = ('Player **%s** (%s, %s) **gave** item **%s** x%s (metadata: %s) **to storage %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['storage_from'] = {
        from = 'stash',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                stash = true,
            },
            inventoryFilter = {
                '^STORAGE_UNIT_[%w]+',
				'^locker[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('storage', {
                {
                    title = 'Storage',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from storage %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['trunk_to'] = {
        from = 'player',
        to = 'trunk',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
            inventoryFilter = {
                '^trunk[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('trunk', {
                {
                    title = 'Trunk',
                    description = ('Player **%s** (%s, %s) **gave** item **%s** x%s (metadata: %s) **to trunk %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['trunk_from'] = {
        from = 'trunk',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                trunk = true,
            },
            inventoryFilter = {
                '^trunk[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('trunk', {
                {
                    title = 'Trunk',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from trunk %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['glovebox_to'] = {
        from = 'player',
        to = 'glovebox',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
            inventoryFilter = {
                '^glove[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox',
                    description = ('Player **%s** (%s, %s) **gave** item **%s** x%s (metadata: %s) **to glovebox %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['glovebox_from'] = {
        from = 'glovebox',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                glovebox = true,
            },
            inventoryFilter = {
                '^glove[%w]+',
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('glovebox', {
                {
                    title = 'Glovebox',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from glovebox %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['drop'] = {
        from = 'player',
        to = 'drop',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('drop', {
                {
                    title = 'Drop',
                    description = ('Player **%s** (%s, %s) **placed** item **%s** x%s (metadata: %s) at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['pickup'] = {
        from = 'drop',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                drop = true,
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('pickup', {
                {
                    title = 'Pickup',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from the ground** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['give'] = {
        from = 'player',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
        },
        callback = function(payload)
            if payload.fromInventory == payload.toInventory then return end
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            local targetSource = payload.toInventory
            local targetName = GetPlayerName(targetSource)
            local targetIdentifier = GetPlayerIdentifiers(targetSource)[1]
            local targetCoords = GetEntityCoords(GetPlayerPed(targetSource))
            sendWebhook('give', {
                {
                    title = 'Transfer of items between players',
                    description = ('Player **%s** (%s, %s) **gave** player **%s** (%s, %s) item **%s** x%s (metadata: %s) on coordinates %s and %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            targetName,
                            targetIdentifier,
                            targetSource,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z),
                            ('%s, %s, %s'):format(targetCoords.x, targetCoords.y, targetCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['stash_pick'] = {
        from = 'player',
        to = 'stash',
        type = 'swapItems',
        options = {
            typeFilter = {
                player = true,
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('stash', {
                {
                    title = 'Stash',
                    description = ('Player **%s** (%s, %s) **gave** item **%s** x%s (metadata: %s) **to stash %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.toInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
    ['stash'] = {
        from = 'stash',
        to = 'player',
        type = 'swapItems',
        options = {
            typeFilter = {
                stash = true,
            },
        },
        callback = function(payload)
            local playerName = GetPlayerName(payload.source)
            local playerIdentifier = GetPlayerIdentifiers(payload.source)[2]
            local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))
            sendWebhook('stash', {
                {
                    title = 'Stash',
                    description = ('Player **%s** (%s, %s) **took** item **%s** x%s (metadata: %s) **from stash %s** at coordinates %s.')
                        :format(
                            playerName,
                            playerIdentifier,
                            payload.source,
                            payload.fromSlot.name,
                            payload.fromSlot.count,
                            json.encode(payload.fromSlot.metadata),
                            payload.fromInventory,
                            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)
                        ),
                    color = 0x00ff00
                }
            })
        end
    },
}
