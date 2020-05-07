--Glommer
AddPrefabPostInit("glommer", function(buzz)
	buzz.Transform:SetScale(GetModConfigData("Size"), GetModConfigData("Size"), GetModConfigData("Size"))
	buzz:RemoveTag("cattoyairborne")
	if GLOBAL.TheNet:GetIsServer() then
		buzz.components.health.maxhealth = GetModConfigData("MaxHealth")
		if GetModConfigData("HealthRegen") ~= false then buzz.components.health:StartRegen(10, GetModConfigData("HealthRegen"), false) end
		buzz.components.sanityaura.aura = TUNING.SANITYAURA_TINY * GetModConfigData("SanityAura")
		buzz.components.locomotor.walkspeed = GetModConfigData("Speed")
	end
end)
GLOBAL.GlommerVolume = GetModConfigData("Voice")

--Extra-adorable Lavae
AddPrefabPostInit("lavae_pet", function(cute)
	cute.Transform:SetScale(GetModConfigData("LavaeSize"), GetModConfigData("LavaeSize"), GetModConfigData("LavaeSize"))
	cute.Light:SetRadius(GetModConfigData("LavaeRadius"))
	cute.Light:SetIntensity(GetModConfigData("LightIntensity"))
	cute:AddTag("shadowcreature")
	if GLOBAL.TheNet:GetIsServer() then
		cute.components.health.maxhealth = GetModConfigData("LavaeHealth")
		if GetModConfigData("LavaeHealthRegen") ~= false then cute.components.health:StartRegen(10, GetModConfigData("LavaeHealthRegen"), false) end
		cute.components.locomotor.walkspeed = GetModConfigData("LavaeSpeed")
		cute:AddComponent("sanityaura")
		cute.components.sanityaura.aura = TUNING.SANITYAURA_TINY * GetModConfigData("LavaeSanityAura")
		cute.components.hunger.hungerrate = GetModConfigData("LavaeHunger")
		if GetModConfigData("FirePropagator") == false then cute:RemoveComponent("propagator") end
	end
end)

--Chester
AddPrefabPostInit("chester", function(chesty)
	chesty.Transform:SetScale(GetModConfigData("ChesterSize"), GetModConfigData("ChesterSize"), GetModConfigData("ChesterSize"))
	chesty:AddTag("shadowcreature")
	if GLOBAL.TheNet:GetIsServer() then
		chesty.components.health.maxhealth = GetModConfigData("ChesterHealth")
		if GetModConfigData("ChesterHealthRegen") ~= false then chesty.components.health:StartRegen(10, GetModConfigData("ChesterHealthRegen"), false) end
		chesty.components.locomotor.walkspeed = GetModConfigData("ChesterSpeed")
	end
end)

--Bird Pets
AddPrefabPostInit("smallbird", function(weirdo) --*sigh* Thanks, Danny.
	weirdo.Transform:SetScale(GetModConfigData("BirdSize"), GetModConfigData("BirdSize"), GetModConfigData("BirdSize"))
	if GLOBAL.TheNet:GetIsServer() then
		weirdo.components.health.maxhealth = GetModConfigData("BirdHealth")
		if GetModConfigData("BirdHealthRegen") ~= false then weirdo.components.health:StartRegen(10, GetModConfigData("BirdHealthRegen"), false) end
		weirdo.components.locomotor.walkspeed = GetModConfigData("BirdSpeed")
		weirdo.components.hunger.hungerrate = GetModConfigData("BirdHunger")
		weirdo.components.combat.defaultdamage = GetModConfigData("BirdAttack")
	end
end)
