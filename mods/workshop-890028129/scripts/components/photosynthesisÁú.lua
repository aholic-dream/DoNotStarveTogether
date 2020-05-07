--[[****************************************************************************
  * Copyright (c) 2016. LongFei
  ****************************************************************************]]

--[[
    *
    *
    * 光合作用
    * 光合作用组件为人物提供光合作用功能。
    *
    * 光合度
    * 光合度是Samansha的独有特性。Samansha通过光合作用获得光合度。
    * 光合作用的速率由多个调节器共同调节。它们为叠乘关系。
    * 默认调节器：光强，自身温度，自身湿度，其它调节器可以自行通过API添加
    *
--]]
local rate_modifiers_data = {
    light = function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local light = TheSim:GetLightAtPoint(x, y, z)
        return math.min(light, 3)
    end,
    temperature = function(inst)
        local bodyTemperature = inst.components.temperature:GetCurrent()
        return 2 * math.sin(bodyTemperature / 50 * math.pi)
    end,
    moisture = function(inst)
        local moisture = inst.components.moisture:GetMoisture()
        return 1.5 * math.sin(moisture / 100 * math.pi) + 0.5
    end,
}
local function oncurrent(self,current)
    self.inst.photosynthesis:set(current)
end
local function onproducing(self,producing)
    self.inst.producing:set(producing)
end
local function onwinterpause(self,winterpause)
    self.inst.winterpause:set(winterpause)
end
local Photosynthesis = Class(function(self, inst)
    self.inst = inst
    self.max = 100 -- 到达最大值后绽放
    self.current = 0
    self.base_rate = TUNING_SAMANSHA.PHOTOSYNTHESIS.BASE_RATE -- 光合基础速率，按每天一半时间光合计算，基础速率为每天10点
    self.fade_rate = TUNING_SAMANSHA.PHOTOSYNTHESIS.FADE_RATE -- 凋零速率
    self.fade_threhold = TUNING_SAMANSHA.PHOTOSYNTHESIS.FADE_THREHOLD -- 凋零阈值
    self.rate_modifiers = {}
    self.producing = true
    self.winterpause = false
    self:DoInit()
end,
nil,
{
    current = oncurrent,
    producing = onproducing,
    winterpause = onwinterpause,
})
local function onTaskTick(inst, self, period)
    self:DoInc(period)
end

function Photosynthesis:DoInit()
    local period = 1
    self.produceTask = self.inst:DoPeriodicTask(period, onTaskTick, nil, self, period)
    self.inst:WatchWorldState("iswinter", function(inst, iswinter)
        if iswinter then
            self.winterpause = true
        else
            self.winterpause = false
        end
    end)
    for key, fn in pairs(rate_modifiers_data) do
        self:AddRateModifier(key, fn)
    end
end

function Photosynthesis:OnSave()
    local data = {
        producing = self.producing,
        winterpause = self.winterpause,
        current = self.current,
        fading = self.fading,
    }
    return data
end

function Photosynthesis:OnLoad(data)
    self.producing = data.producing
    self.winterpause = data.winterpause or false
    self.current = data.current or 0
    self.fading = data.fading
    if self.fading then
        self.inst:DoTaskInTime(0,function() self:Bloom() end)
    end
end


function Photosynthesis:CanProduce()
    if not self.producing then
        return false
    end
    if self.winterpause then
        return false
    end
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local light = TheSim:GetLightAtPoint(x, y, z)
    if light < 1 then
        return false
    end
    return true
end

function Photosynthesis:Toggole()
    self.producing = not self.producing
end
function Photosynthesis:Pause()
    self.producing = false
end
function Photosynthesis:Resume()
    self.producing = true
end

function Photosynthesis:AddRateModifier(key, mod)
    self.rate_modifiers[key] = mod
end

function Photosynthesis:RemoveRateModifier(key)
    self.rate_modifiers[key] = nil
end

function Photosynthesis:GetRateModifier()
    local mod = 1
    for k, v in pairs(self.rate_modifiers) do
        local multiplier = (type(v) == "number" and v) or (type(v) == "function" and v(self.inst))
        mod = mod * multiplier
    end
    return mod
end

function Photosynthesis:DoDelta(delta)
    self.current = math.clamp(self.current + delta, 0, self.max)
    if self.current >= self.max then
        self.current = (1-TUNING_SAMANSHA.PHOTOSYNTHESIS.FADE_PERCENT)*self.max
        self:Bloom()
    end
end

function Photosynthesis:CalcDelta(delta)
    delta = delta * self:GetRateModifier()
    return delta
end

function Photosynthesis:DoInc(dt)
    if self:CanProduce() then
        local delta = self:CalcDelta(dt * self.base_rate)
        self:DoDelta(delta)
        self.inst:PushEvent("photosynthesisIncrease", { delta = delta })
    end
end

function Photosynthesis:SetOnBloomFn(fn)
    self.onbloomfn = fn
end
-- 绽放
function Photosynthesis:Bloom()
    if self.onbloomfn then
        self.onbloomfn(self.inst)
    end
    self:StartFade()
end


-- 开始凋零
function Photosynthesis:StartFade()
    self:StopFade()
    self:Pause()
    local period = 1
    local function fadeTaskFn(inst, self, period)
        self:DoDelta(-period * self.fade_rate)
        if self.current < self.fade_threhold then
            self:Fade()
        end
    end
    self.fading = true
    self.fadeTask = self.inst:DoPeriodicTask(period, fadeTaskFn, nil, self, period)
end

function Photosynthesis:SetOnFadeFn(fn)
    self.onfadefn = fn
end
-- 彻底凋零
function Photosynthesis:Fade()
    if self.onfadefn then
        self.onfadefn(self.inst)
    end
    self.fading = false
    self:StopFade()
end
-- 停止凋零
function Photosynthesis:StopFade()
    if self.fadeTask then
        self.fadeTask:Cancel()
        self.fadeTask = nil
    end
    self:Resume()
end

function Photosynthesis:LongUpdate(dt)
    if self.fadeTask == nil then
        self:DoInc(dt)
    else
        self:DoDelta(-dt * self.fade_rate)
    end
end
return Photosynthesis