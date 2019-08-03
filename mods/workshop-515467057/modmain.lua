if GLOBAL.TheNet:GetIsMasterSimulation() then
	AddPrefabPostInit("cane", function(inst)
		inst.entity:Hide()
		inst:DoTaskInTime(0, inst.Remove)
	end)
	local MIN_SPEED = GetModConfigData("MIN_SPEED")
	local STEP_DOWN = GetModConfigData("STEP_DOWN")
	local MAX_SPEED = GetModConfigData("MAX_SPEED")
	local STEP_UP = GetModConfigData("STEP_UP")
	AddComponentPostInit("locomotor", function(self)
		if self.inst:HasTag("player") then
			local racingbonus = 1
			local racingtask = nil
			local _RunForward = self.RunForward
			self.RunForward = function(self, ...)
				_RunForward(self, ...)
				if not racingtask then
					local function speedUp(inst)
						if not self.isrunning then
							if racingbonus > MIN_SPEED then
								racingbonus = racingbonus - STEP_DOWN
								self:SetExternalSpeedMultiplier(self.inst, "RacingBonus", racingbonus)
							else
								racingbonus = MIN_SPEED
								self:SetExternalSpeedMultiplier(self.inst, "RacingBonus", racingbonus)
								if racingtask then
									racingtask:Cancel()
									racingtask = nil
								end
							end
						else
							if racingbonus < MAX_SPEED then
								racingbonus = racingbonus + STEP_UP
								self:SetExternalSpeedMultiplier(self.inst, "RacingBonus", racingbonus)
							end
						end
					end
					racingtask = self.inst:DoPeriodicTask(0.2, speedUp)
				end
			end
		end
	end)
end

local _GetValidRecipe = GLOBAL.GetValidRecipe
GLOBAL.GetValidRecipe = function(recname)
	return _GetValidRecipe(recname ~= "cane" and recname or nil)
end
