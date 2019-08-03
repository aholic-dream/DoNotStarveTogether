-- test
local SpawnPrefab = GLOBAL.SpawnPrefab
local TheWorld = GLOBAL.TheWorld
local GetTime = GLOBAL.GetTime

local require = GLOBAL.require
local Cookable = require "components/cookable"
local Crop = require "components/crop"
local Harvestable = require "components/harvestable"
local Pickable = require "components/pickable"
local Stewer = require "components/stewer"
local Dryer = require "components/dryer"

function Cookable:GetProduct()
    local prefab = nil 
    if self.product then 
        prefab = self.product
        if type(self.product) == "function" then
            prefab = self.product(self.inst)
        end
    end 
    return prefab
end 
AddComponentPostInit("cookable", Cookable)


function Crop:Harvest(harvester)
    if self.matured or self.inst:HasTag("withered") then
        local product = nil
        if self.grower ~= nil and
            (self.grower.components.burnable ~= nil and self.grower.components.burnable:IsBurning()) or
            (self.inst.components.burnable ~= nil and self.inst.components.burnable:IsBurning()) then
            local temp = SpawnPrefab(self.product_prefab)
            product = SpawnPrefab(temp.components.cookable ~= nil and temp.components.cookable.product or "seeds_cooked")
            temp:Remove()
        else
            product = SpawnPrefab(self.product_prefab)
        end

        if product ~= nil then
            if product.components.inventoryitem ~= nil then
                product.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
            end

            if harvester ~= nil and harvester.components.inventory ~= nil and not harvester:HasTag("yamcheb") and not harvester:HasTag("critter") then
                harvester.components.inventory:GiveItem(product, nil, self.inst:GetPosition())
			elseif harvester ~= nil and harvester.components.container ~= nil and (harvester:HasTag("yamcheb") or harvester:HasTag("critter")) then
                harvester.components.container:GiveItem(product, nil, self.inst:GetPosition())
            else
                -- just drop the thing (happens if you haunt the fully grown crop)
                product.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
            end
            ProfileStatsAdd("grown_"..product.prefab)
        end

        self.matured = false
        self.growthpercent = 0
        self.product_prefab = nil
        if self.grower ~= nil and self.grower:IsValid() and self.grower.components.grower ~= nil then
            self.grower.components.grower:RemoveCrop(self.inst)
        end
        self.grower = nil

        return true, product
    end
end
AddComponentPostInit("crop",Crop)


function Harvestable:Harvest(picker)
    if self:CanBeHarvested() then
        local produce = self.produce
        self.produce = 0

        if self.onharvestfn ~= nil then
            self.onharvestfn(self.inst, picker, produce)
        end
		
		if self.product ~= nil then
			if picker ~= nil and not picker:HasTag("yamcheb") and not picker:HasTag("critter") and picker.components.inventory ~= nil then
				picker:PushEvent("harvestsomething", { object = self.inst })
			end
			if picker ~= nil and (picker:HasTag("yamcheb") or picker:HasTag("critter")) and picker.components.container ~= nil then
				picker:PushEvent("harvestsomething", { object = self.inst })
			end
			
			for i = 1, produce, 1 do
				local loot = SpawnPrefab(self.product)
				if loot ~= nil then
					if loot.components.inventoryitem ~= nil then
						loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
					end
					if picker ~= nil and not picker:HasTag("yamcheb") and not picker:HasTag("critter") and picker.components.inventory ~= nil then
						picker.components.inventory:GiveItem(loot)
					elseif picker ~= nil and (picker:HasTag("yamcheb") or picker:HasTag("critter")) and picker.components.container ~= nil then
						picker.components.container:GiveItem(loot)	
					else
						LaunchAt(loot, self.inst, nil, 1, 1)
					end
				end
			end
        end
        self:StartGrowing()
        return true
    end
end
AddComponentPostInit("harvestable",Harvestable)

function Dryer:Harvest(harvester)
    if not self:IsDone() or harvester == nil or (harvester.components.inventory == nil and harvester.components.container == nil) then
        return false
    end

    local loot = SpawnPrefab(self.product)
    if loot ~= nil then
        if loot.components.perishable ~= nil then
            loot.components.perishable:SetPercent(self:GetTimeToSpoil() / TUNING.PERISH_PRESERVED)
            loot.components.perishable:StartPerishing()
        end
        if loot.components.inventoryitem ~= nil and not self.protectedfromrain then
            loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
        end
		if harvester ~= nil and not harvester:HasTag("yamcheb") and not harvester:HasTag("critter") and harvester.components.inventory then
        harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
		elseif harvester ~= nil and (harvester:HasTag("yamcheb") or harvester:HasTag("critter")) and harvester.components.container then
		harvester.components.container:GiveItem(loot, nil, self.inst:GetPosition())
		end
       
    end

    self.ingredient = nil
    self.product = nil
    self.remainingtime = nil
    self.tasktotime = nil
    if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
    end
    StopWatchingRain(self)

    if self.onharvest ~= nil then
        self.onharvest(self.inst)
    end
    return true
end
AddComponentPostInit("dryer",Dryer)


function Pickable:Pick(picker)
    if self.canbepicked and self.caninteractwith then
        if self.transplanted and self.cycles_left ~= nil then
            self.cycles_left = math.max(0, self.cycles_left - 1)
        end

        if self.protected_cycles ~= nil then
            self.protected_cycles = self.protected_cycles - 1
            if self.protected_cycles < 0 then
                self.protected_cycles = nil
                if self.inst.components.witherable ~= nil then
                    self.inst.components.witherable:Enable(true)
                end
            end
        end

        local loot = nil
        if picker ~= nil and not picker:HasTag("yamcheb") and not picker:HasTag("critter") and picker.components.inventory ~= nil and self.product ~= nil then
            if self.droppicked and self.inst.components.lootdropper ~= nil then
                local num = self.numtoharvest or 1
                local pt = self.inst:GetPosition()
                pt.y = pt.y + (self.dropheight or 0)
                for i = 1, num do
                    self.inst.components.lootdropper:SpawnLootPrefab(self.product, pt)
                end
            else
                loot = SpawnPrefab(self.product)
                if loot ~= nil then
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                    end
                    if self.numtoharvest > 1 and loot.components.stackable ~= nil then
                        loot.components.stackable:SetStackSize(self.numtoharvest)
                    end
                    picker:PushEvent("picksomething", { object = self.inst, loot = loot })
                    picker.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
                end
            end
			elseif picker ~= nil and (picker:HasTag("yamcheb") or picker:HasTag("critter")) and picker.components.container ~= nil and self.product ~= nil then
            if self.droppicked and self.inst.components.lootdropper ~= nil then
                local num = self.numtoharvest or 1
                local pt = self.inst:GetPosition()
                pt.y = pt.y + (self.dropheight or 0)
                for i = 1, num do
                    self.inst.components.lootdropper:SpawnLootPrefab(self.product, pt)
                end
            else
                loot = SpawnPrefab(self.product)
                if loot ~= nil then
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                    end
                    if self.numtoharvest > 1 and loot.components.stackable ~= nil then
                        loot.components.stackable:SetStackSize(self.numtoharvest)
                    end
                    picker:PushEvent("picksomething", { object = self.inst, loot = loot })
                    picker.components.container:GiveItem(loot, nil, self.inst:GetPosition())
                end
            end
        end

        if self.onpickedfn ~= nil then
            self.onpickedfn(self.inst, picker, loot)
        end

        self.canbepicked = false

        if self.baseregentime ~= nil and not (self.paused or self:IsBarren() or self.inst:HasTag("withered")) then
            if TheWorld.state.isspring then
                self.regentime = self.baseregentime * TUNING.SPRING_GROWTH_MODIFIER
            end

            if self.task ~= nil then
                self.task:Cancel()
            end
            self.task = self.inst:DoTaskInTime(self.regentime, OnRegen)
            self.targettime = GetTime() + self.regentime
        end

        self.inst:PushEvent("picked", { picker = picker, loot = loot, plant = self.inst })
    end
end
AddComponentPostInit("pickable",Pickable)


function Stewer:Harvest(harvester)
    if self.done then
        if self.onharvest ~= nil then
            self.onharvest(self.inst)
        end

        if self.product ~= nil then
            local loot = SpawnPrefab(self.product)
            if loot ~= nil then
				local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
				local stacksize = recipe and recipe.stacksize or 1
				if stacksize > 1 then
					loot.components.stackable:SetStackSize(stacksize)
				end
            
                if self.spoiltime ~= nil and loot.components.perishable ~= nil then
                    local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
                    loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
                    loot.components.perishable:StartPerishing()
                end
                if harvester ~= nil and harvester.components.inventory ~= nil and not harvester:HasTag("yamcheb") and not harvester:HasTag("critter") then
                    harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
				elseif harvester ~= nil and harvester.components.container ~= nil and (harvester:HasTag("yamcheb") or harvester:HasTag("critter")) then
                    harvester.components.container:GiveItem(loot, nil, self.inst:GetPosition())
                else
                    LaunchAt(loot, self.inst, nil, 1, 1)
                end
            end
            self.product = nil
        end

        if self.task ~= nil then
            self.task:Cancel()
            self.task = nil
        end
        self.targettime = nil
        self.done = nil
        self.spoiltime = nil
        self.product_spoilage = nil

        if self.inst.components.container ~= nil then      
            self.inst.components.container.canbeopened = true
        end

        return true
    end
end
AddComponentPostInit("stewer",Stewer)
