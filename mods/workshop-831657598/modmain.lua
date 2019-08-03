
if GetModConfigData("stack_size") == 1 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 1
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 2
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 4
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 2 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 2
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 4
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 8
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 3 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 3
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 6
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 12
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 4 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 4
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 8
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 16
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 5 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 5
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 10
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 20
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 6 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 6
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 12
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 24
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 7 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 7
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 14
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 28
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 8 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 8
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 16
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 32
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 9 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 9
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 18
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 36
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 10 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 10
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 20
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 40
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 11 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 11
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 22
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 44
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 12 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 12
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 24
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 48
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 13 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 13
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 26
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 52
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 14 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 14
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 28
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 56
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 15 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 15
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 30
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 60
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 16 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 16
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 32
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 64
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 17 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 17
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 34
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 68
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 18 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 18
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 36
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 72
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 19 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 19
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 38
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 76
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 20 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 20
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 40
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 80
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end

if GetModConfigData("stack_size") == 30 then
	GLOBAL.TUNING.STACK_SIZE_LARGEITEM = 30
	GLOBAL.TUNING.STACK_SIZE_MEDITEM = 60
	GLOBAL.TUNING.STACK_SIZE_SMALLITEM = 120
	local r_s = GLOBAL.require("components/stackable_replica")
	r_s._ctor = function(self, inst)
		self.inst = inst
		self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
		self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
	end
end
