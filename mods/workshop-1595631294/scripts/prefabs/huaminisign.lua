
local assets =
{
    Asset("ANIM", "anim/sign_mini.zip"),
}

local function dig_up(inst)--, worker)
	if inst.huachest ~= nil then
		inst.huachest:AddTag("nohuaminisign")
		inst.huachest.huafx = nil		
	end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("sign_mini")
    inst.AnimState:SetBuild("sign_mini")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("sign")
	inst:AddTag("fx")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	if TUNING.HUAMINISIGN  == true then
		inst:RemoveTag("fx")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.DIG)
		inst.components.workable:SetOnFinishCallback(dig_up)
		inst.components.workable:SetWorkLeft(1)	
	end
	
	inst.persists = false
    return inst
end

return Prefab("huaminisign", fn, assets)
