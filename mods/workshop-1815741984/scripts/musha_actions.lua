ACTIONS.ADDFUEL.str = STRINGS.ACTIONS.ADDFUEL
ACTIONS.ADDFUEL.id = "ADDFUEL"

ACTIONS.ADDFUEL.strfn = function(act)
	local targ = act.target or act.invobject

	if targ:HasTag("musha_items") then
		STRINGS.ACTIONS.ADDFUEL = (STRINGS.MUSHA_ACTION_REPAIR)
		return 
	else
		STRINGS.ACTIONS.ADDFUEL = (STRINGS.MUSHA_ACTION_ADDFUEL)
		return 
	end	
end

--compatible with MyPet

ACTIONS.RUMMAGE.fn = function(act)
    local targ = act.target or act.invobject
	

    if targ ~= nil and targ.components.container ~= nil and not targ:HasTag("critter") and not targ:HasTag("yamcheb") then
 
        if targ.components.container:IsOpenedBy(act.doer) then
            targ.components.container:Close()
            act.doer:PushEvent("closecontainer", { container = targ })
            return true
        elseif targ.components.container:IsOpen() then
            return false, "INUSE"
        elseif targ.components.container.canbeopened then
            --Silent fail for opening containers in the dark
            if GLOBAL.CanEntitySeeTarget(act.doer, targ) then
                act.doer:PushEvent("opencontainer", { container = targ })
                targ.components.container:Open(act.doer)
            end
            return true
        end
		
	elseif targ ~= nil and targ.components.container ~= nil and (targ:HasTag("critter") or targ:HasTag("yamcheb")) and not targ.house then
		local owner = act.target.components.follower.leader
	if act.doer == owner then
 
        if targ.components.container:IsOpenedBy(act.doer) then
            targ.components.container:Close()
            act.doer:PushEvent("closecontainer", { container = targ })
            return true
        elseif targ.components.container:IsOpen() then
            return false, "INUSE"
        elseif targ.components.container.canbeopened then
            --Silent fail for opening containers in the dark
            if GLOBAL.CanEntitySeeTarget(act.doer, targ) then
                act.doer:PushEvent("opencontainer", { container = targ })
                targ.components.container:Open(act.doer)
            end
            return true
        end
	else
		return false
		
		end
	
	elseif targ ~= nil and targ.components.container ~= nil and (targ:HasTag("critter") or targ:HasTag("yamcheb")) and targ.house then
		 
        if targ.components.container:IsOpenedBy(act.doer) then
            targ.components.container:Close()
            act.doer:PushEvent("closecontainer", { container = targ })
            return true
        elseif targ.components.container:IsOpen() then
            return false, "INUSE"
        elseif targ.components.container.canbeopened then
            --Silent fail for opening containers in the dark
            if GLOBAL.CanEntitySeeTarget(act.doer, targ) then
                act.doer:PushEvent("opencontainer", { container = targ })
                targ.components.container:Open(act.doer)
            end
            return true
        end
	
	
end	
end

ACTIONS.PICKUP.fn = function(act)
if not act.doer:HasTag("critter") and not act.doer:HasTag("yamcheb") then
    if act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
        (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player"))) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then

		if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
			return false, "restriction"
		end

        act.doer:PushEvent("onpickupitem", { item = act.target })

        --special case for trying to carry two backpacks
        if not act.target.components.inventoryitem.cangoincontainer and act.target.components.equippable and act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) then
            local item = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
            if item.components.inventoryitem and item.components.inventoryitem.cangoincontainer then
                
                --act.doer.components.inventory:SelectActiveItemFromEquipSlot(act.target.components.equippable.equipslot)
                act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target.components.equippable.equipslot))
            else
                act.doer.components.inventory:DropItem(act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot))
            end
            act.doer.components.inventory:Equip(act.target)
            return true
        end

        if act.doer:HasTag("player") and
            (   act.target.components.equippable ~= nil and
                not act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot) or
                act.doer.components.inventory:GetNumSlots() <= 0
            ) then
            act.doer.components.inventory:Equip(act.target)
        else
            act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
        end
        return true
    end
elseif act.doer:HasTag("critter") or act.doer:HasTag("yamcheb") then	
	if act.doer.components.container ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
        (act.target.components.inventoryitem.canbepickedupalive )) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then

		if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
			return false, "restriction"
		end

        act.doer:PushEvent("onpickupitem", { item = act.target })

    act.doer.components.container:GiveItem(act.target, nil, act.target:GetPosition())
        end
        return true
    


end
end

ACTIONS.HARVEST.fn = function(act)
    if act.target.components.crop ~= nil then
        local harvested = act.target.components.crop:Harvest(act.doer)
        return harvested
    elseif act.target.components.harvestable ~= nil then
        return act.target.components.harvestable:Harvest(act.doer)
    elseif act.target.components.stewer ~= nil then
        return act.target.components.stewer:Harvest(act.doer)
    elseif act.target.components.dryer ~= nil then
        return act.target.components.dryer:Harvest(act.doer)
    elseif act.target.components.occupiable ~= nil and act.target.components.occupiable:IsOccupied() then
        local item = act.target.components.occupiable:Harvest(act.doer)
        if item ~= nil then
			if not act.doer:HasTag("critter") and not act.doer:HasTag("yamcheb") then
			act.doer.components.inventory:GiveItem(item)
			elseif act.doer:HasTag("critter") or act.doer:HasTag("yamcheb") then
			act.doer.components.container:GiveItem(item)
			end
			return true
        end
    end
end