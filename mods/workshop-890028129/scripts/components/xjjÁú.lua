--[[
  * 
  * Author: LongFei
  * Date: 2016/10/19
  * Time: 3:32
  * 
--]]
local easing = require("easing")
local PHOTOSYNTHESIS_PERCENT = 1/10 -- 食物饱食度转变为光合度的比率

local Samansha = Class(function(self,inst)
    self.inst= inst
    self:DoInit(inst)
end)


function Samansha:DoInit(inst)
    -- 在着火的树旁边会降低脑残
    local function SanityDecreaseByFire(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local delta = 0
        local max_rad = 10
        local ents = TheSim:FindEntities(x, y, z, max_rad, { "fire" })
        for i, v in ipairs(ents) do
            if v:HasTag("evergreen") or v:HasTag("evergreen_sparse") or v:HasTag("deciduoustree") then
                if v.components.burnable ~= nil and v.components.burnable:IsBurning() then
                    local rad = v.components.burnable:GetLargestLightRadius() or 1
                    local sz = TUNING.SANITYAURA_TINY * math.min(max_rad, rad) / max_rad
                    local distsq = inst:GetDistanceSqToInst(v) - 9
                    delta = delta - sz / math.max(1, distsq)
                end
            end
        end
        return delta
    end
    self.inst.components.sanity.custom_rate_fn = SanityDecreaseByFire
    self:Fade()
    local function oneat(inst,food)
        -- 花形态吃食物增加光合度（食物饥饿度的十分之一）
        if inst:HasTag("flower") and inst.components.photosynthesis then
            local photosynthesisDelta = food.components.edible:GetHunger(inst)*PHOTOSYNTHESIS_PERCENT
            inst.components.photosynthesis:DoDelta(photosynthesisDelta)
        end
        -- 进食莲子+20能量，莲叶+10能量
        if food.prefab =="lotus_seed" then
            inst.components.mana:DoDelta(TUNING_SAMANSHA.MANA.LOTUS_SEED)
        elseif food.prefab =="lotus_leaf" then
            inst.components.mana:DoDelta(TUNING_SAMANSHA.MANA.LOTUS_LEAF)
        end
    end
    inst.components.eater:SetOnEatFn(oneat)

    inst:AddComponent("photosynthesis")
    inst.components.photosynthesis:SetOnBloomFn(function(inst)
        inst.components.samansha:Bloom()
    end)
    inst.components.photosynthesis:SetOnFadeFn(function(inst)
        inst.components.samansha:Fade()
    end)

    inst:AddComponent("mana")

    -- 光合作用会增加能量，按百分比增加
    inst:ListenForEvent("photosynthesisIncrease",function(inst,data)
        if data and data.delta then
            local self = inst.components.mana
            local delta = self.max*data.delta/100
            self:DoDelta(delta)
        end
    end)

    -- 精神不会受湿度影响
    inst.components.sanity.custom_rate_fn = function(inst)
        return -easing.inSine(self.inst.components.moisture:GetMoisture(), 0, TUNING.MOISTURE_SANITY_PENALTY_MAX, self.inst.components.moisture:GetMaxMoisture())
    end



end
local function TransformState(inst,state)
    if state == "plant" then
        inst.AnimState:SetBuild("samansha")
        inst:RemoveTag("flower")
        inst.components.combat.damagemultiplier = 0.5
    elseif state == "flower" then
        inst.AnimState:SetBuild("samansha_flower")
        inst:AddTag("flower")
        inst.components.combat.damagemultiplier = 1
    end
end
function Samansha:Bloom()
    print("here?")
    TransformState(self.inst,"flower")
end

function Samansha:Fade()
    TransformState(self.inst,"plant")
end

return Samansha

