local SetSharedLootTable = GLOBAL.SetSharedLootTable

local dropChance = GetModConfigData("KRAMPUSSACKLOOTCHANCE")/100
local PigLoot = GetModConfigData("PIGLOOT")
local ButterflyLoot = GetModConfigData("BUTTERFLYLOOT")
local walrushatChance = GetModConfigData("WALRUSHATCHANCE")/100
local walrus_tuskChance = GetModConfigData("WALRUSTUSKCHANCE")/100

local function updateLootTableKrampus(inst)
   SetSharedLootTable( 'krampus',
  {
      {'monstermeat',  1.0},
      {'charcoal',     1.0},
      {'charcoal',     1.0},
      {'krampus_sack', dropChance},
  })                               
   if(inst.components.lootdropper == nil) then
      inst:AddComponent("lootdropper")
   end
   inst.components.lootdropper:SetChanceLootTable('krampus')
end
AddPrefabPostInit("krampus", updateLootTableKrampus)

local function updateLootTablePig(inst)
   if(inst.components.lootdropper == nil) then
      inst:AddComponent("lootdropper")
   end
   inst.components.lootdropper:SetLoot({})
   if(PigLoot == 1) then
     inst.components.lootdropper:AddRandomLoot("meat",5)
     inst.components.lootdropper:AddRandomLoot("pigskin",3)
     inst.components.lootdropper.numrandomloot = 2
   elseif(PigLoot == 2) then
     inst.components.lootdropper:AddRandomLoot("meat",4)
     inst.components.lootdropper:AddRandomLoot("pigskin",2)
     inst.components.lootdropper.numrandomloot = 1
   elseif(PigLoot == 3) then
     inst.components.lootdropper:AddRandomLoot("meat",3)
     inst.components.lootdropper:AddRandomLoot("pigskin",1)
     inst.components.lootdropper.numrandomloot = 1
   elseif(PigLoot == 4) then
     inst.components.lootdropper:AddRandomLoot("meat",5)
     inst.components.lootdropper:AddRandomLoot("pigskin",1)
     inst.components.lootdropper.numrandomloot = 1
   else
     inst.components.lootdropper:AddRandomLoot("meat",3)
     inst.components.lootdropper:AddRandomLoot("pigskin",1)
     inst.components.lootdropper.numrandomloot = 1 
   end
end
AddPrefabPostInit("pigman", updateLootTablePig)
AddPrefabPostInit("pigguard", updateLootTablePig)

local function updateLootTableButterfly(inst)
   if(inst.components.lootdropper == nil) then
      inst:AddComponent("lootdropper")
   end
    inst.components.lootdropper:SetLoot({})
    if(ButterflyLoot == 1) then
      inst.components.lootdropper:AddRandomLoot("butter", 3)
      inst.components.lootdropper:AddRandomLoot("butterflywings", 4)
      inst.components.lootdropper.numrandomloot = 1
    elseif(ButterflyLoot == 2) then
      inst.components.lootdropper:AddRandomLoot("butter", 2)
      inst.components.lootdropper:AddRandomLoot("butterflywings", 5)
      inst.components.lootdropper.numrandomloot = 1
    elseif(ButterflyLoot == 3) then
      inst.components.lootdropper:AddRandomLoot("butter", 0.1)
      inst.components.lootdropper:AddRandomLoot("butterflywings", 5)
      inst.components.lootdropper.numrandomloot = 1
    elseif(ButterflyLoot == 4) then                           
      inst.components.lootdropper:AddRandomLoot("butter", 0.1)
      inst.components.lootdropper:AddRandomLoot("butterflywings", 8)
      inst.components.lootdropper.numrandomloot = 1
    else
      inst.components.lootdropper:AddRandomLoot("butter", 0.1)
      inst.components.lootdropper:AddRandomLoot("butterflywings", 5)
      inst.components.lootdropper.numrandomloot = 1
    end
end
AddPrefabPostInit("butterfly", updateLootTableButterfly)

local function updateLootTableWalrus(inst)
   SetSharedLootTable( 'walrus',
  {
      {'meat',            1.00},
      {'blowdart_pipe',   1.00},
      {'walrushat',       walrushatChance},
      {'walrus_tusk',     walrus_tuskChance},
  })
  if(inst.components.lootdropper == nil) then
      inst:AddComponent("lootdropper")
   end
   inst.components.lootdropper:SetLoot({})
   inst.components.lootdropper:SetChanceLootTable('walrus')
end
AddPrefabPostInit("walrus", updateLootTableWalrus)