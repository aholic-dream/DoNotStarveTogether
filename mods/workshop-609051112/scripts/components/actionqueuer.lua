local Image = require "widgets/image"

--------------------------------------------------------------------
local UPDATE_PERIOD = 0.1
local SELECTION_BOX_TINT = {1, 1, 1, 0.15} -- r, g, b, a
local UNSELECTABLE_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO"}

--------------------------------------------------------------------
local GeoUtil = {}

function GeoUtil.ManhattanDistance(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y) + math.abs(a.z - b.z)
end

function GeoUtil.MapScreenPt(x, y)
	return Vector3(TheSim:ProjectScreenPos(x, y))
end

-- Returns a function which computes the barycentric coordinates of its input relative to (A, B, C).
-- A is taken to be the origin, with directions B-A and C-A.
function GeoUtil.BarycentricCoordinates(A, B, C)
	local v0 = C - A
	local v1 = B - A

	local dot00 = v0:Dot(v0)
	local dot01 = v0:Dot(v1)
	local dot11 = v1:Dot(v1)

	local scale = 1/(dot00*dot11 - dot01 * dot01)

	return function(P)
		local v2 = P - A

		local dot02 = v0:Dot(v2)
		local dot12 = v1:Dot(v2)

		local u = (dot11*dot02 - dot01*dot12)*scale
		local v = (dot00*dot12 - dot01*dot02)*scale

		return u, v
	end
end

-- Returns a function which tests if a point is in a given triangle.
function GeoUtil.NewTriangleTester(A, B, C)
	local coordsOf = GeoUtil.BarycentricCoordinates(A, B, C)

	return function(P)
		local u, v = coordsOf(P)
		return u >= 0 and v >= 0 and u + v <= 1
	end
end

-- Returns a function which tests if a point is in a given quadrilateral.
function GeoUtil.NewQuadrilateralTester(A, B, C, D)
	local tritest1, tritest2 = GeoUtil.NewTriangleTester(A, B, C), GeoUtil.NewTriangleTester(C, D, A)

	return function(P)
		return tritest1(P) or tritest2(P)
	end
end

local function CancelThread(thread)
	if thread then thread:SetList(nil) end
end

-- local plant_names = { --acorn berrybush berrybush2 sapling grass marsh_bush trap_teeth marblebean
-- 	["pinecone"] = true,
-- 	["acorn"] = true,
-- 	["dug_berrybush"] = true,
-- 	["dug_berrybush2"] = true,
-- 	["dug_berrybush_juicy"] = true,
-- 	["dug_sapling"] = true,
-- 	["dug_grass"] = true,
-- 	["dug_marsh_bush"] = true,
-- 	["trap_teeth"] = true,
-- 	["twiggy_nut"] = true,
-- 	["marblebean"] = true,
-- 	["wall_stone_item"] = true,
-- }

local extend_deploy_names = {
	["trap_teeth"] = true,
}

local function GetDeployMode(item)
	if not item or not item.replica then return nil end
	local ii = item.replica.inventoryitem
	if ii then
		if ii.inst.components.deployable then return ii.inst.components.deployable.mode end
		if ii.classified and ii.classified.deploymode then return ii.classified.deploymode:value() end
	end
	return nil
end

local function CheckDeploy(item)
	if item and extend_deploy_names[item.prefab] == true then return true end
	local dm = GetDeployMode(item)
	if dm == DEPLOYMODE.PLANT or dm == DEPLOYMODE.WALL then return true end
	return false
end

local ActionGetter
do
	local function disRight(target, right)
		if right then
			return false
		end
		return true
	end
	local function disLeft(target, right)
		if not right then
			return false
		end
		return true
	end
	local allowed_actions = {
		[ACTIONS.REPAIR] = true,
		[ACTIONS.CHOP] = true,
		[ACTIONS.COOK] = true,
		[ACTIONS.PICK] = true,
		[ACTIONS.PICKUP] = true,
		[ACTIONS.MINE] = true,
		[ACTIONS.DIG] = true,
		[ACTIONS.GIVE] = true,
		[ACTIONS.DRY] = true,
		[ACTIONS.EXTINGUISH] = true,
		[ACTIONS.BAIT] = true,
		[ACTIONS.CHECKTRAP] = true,
		[ACTIONS.HARVEST] = true,
		[ACTIONS.SHAVE] = true,
		[ACTIONS.NET] = true,
		[ACTIONS.FERTILIZE] = true,
		[ACTIONS.HAMMER] = true,
		[ACTIONS.RESETMINE] = true,
		[ACTIONS.ACTIVATE] = true,
		[ACTIONS.TURNON] = true,
		[ACTIONS.TURNOFF] = true,
		[ACTIONS.USEITEM] = true,
		[ACTIONS.TAKEITEM] = true,
		[ACTIONS.PLANT] = true,
		[ACTIONS.ADDFUEL] = true,
		[ACTIONS.ADDWETFUEL] = true,
	}
	local special_cases = {}
	special_cases[ACTIONS.HAMMER] = disLeft
	special_cases[ACTIONS.GIVE] = disRight
	special_cases[ACTIONS.NET] = disRight
	special_cases[ACTIONS.ADDFUEL] = disRight
	special_cases[ACTIONS.ADDWETFUEL] = disRight
	special_cases[ACTIONS.COOK] = disRight
	special_cases[ACTIONS.FERTILIZE] = disRight
	special_cases[ACTIONS.MINE] = disRight
	special_cases[ACTIONS.CHOP] = disRight
	special_cases[ACTIONS.PICK] = disRight
	special_cases[ACTIONS.DRY] = disRight
	special_cases[ACTIONS.PLANT] = disRight
	special_cases[ACTIONS.SHAVE] = function(target, right)
		if right then
			return false
		end
		if target:HasTag("player") then
			return false
		end
		return true
	end
	special_cases[ACTIONS.HARVEST] = function(target, right)
		if right then
			return false
		end
		if target:HasTag("cage") then
			return false
		end
		return true
	end
	special_cases[ACTIONS.PICKUP] = function(target, right)
		if right then
			return false
		end
		if target.components.mine and not target.components.mine.inactive then
			return false
		end
		if target.components.trap and not target.components.trap.isset then
			return false
		end
		if ThePlayer and not ThePlayer.components.playercontroller.ismastersim and target:HasTag("trap") then 
			return false
		end
		return true
	end
	local function filter_actions(actions, target, right ,nactions)
		for i,v in ipairs(actions) do
			if v ~= nil then
				local act = v.action
				if allowed_actions[act] then
					if not special_cases[act] or (special_cases[act] and special_cases[act](target, right)) then
						v.isRight = right
						table.insert(nactions,v)
					end
				end
			end
		end
	end
	local function bufaction_less(a, b)
		return a.action.priority > b.action.priority
	end
	ActionGetter = function(inst, get_buffered)
		return function(target, right)
			local actions = nil
			local nactions = {}
			local useitem = inst.replica.inventory:GetActiveItem()
		    local equipitem = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if right and target ~= nil and inst.components.playeractionpicker.containers[target] then
	       	 	actions = inst.components.playeractionpicker:GetSceneActions(target, true)
		    elseif useitem ~= nil and useitem:IsValid() then
	            if target == inst then
	                actions = inst.components.playeractionpicker:GetInventoryActions(useitem, right)
	            elseif target ~= nil then
	                actions = inst.components.playeractionpicker:GetUseItemActions(target, useitem, right)
                end
		    elseif target ~= nil and target ~= inst then
		        if equipitem ~= nil and equipitem:IsValid() then
		            actions = inst.components.playeractionpicker:GetEquippedItemActions(target, equipitem, right)
		        end
		        if actions == nil or #actions == 0 then
		            actions = inst.components.playeractionpicker:GetSceneActions(target, right)
		        end
		    end
			actions = actions or {}
			filter_actions(actions, target, right, nactions)
			return nactions
		end
	end
end

--------------------------------------------------------------------
local AddMouseButtonHandler
local AddMouseMoveHandler
local InitializeHandlerAdders
do
	require "events"

	local mousedown = EventProcessor()
	local mouseup = EventProcessor()
	local mousemove = EventProcessor()

	AddMouseButtonHandler = function(button, down, fn)
		local proc = down and mousedown or mouseup

		proc:AddEventHandler(button, fn)
	end

	AddMouseMoveHandler = function(fn)
		mousemove:AddEventHandler("move", fn)
	end

	local initialized_handlers = false
	InitializeHandlerAdders = function()
		if initialized_handlers then return end

		local TheFrontEnd = rawget(_G, "TheFrontEnd")
		if not TheFrontEnd then return end

		TheFrontEnd.OnMouseButton = (function()
			local onbutt = TheFrontEnd.OnMouseButton

			return function(self, button, down, x, y)
				if not onbutt(self, button, down, x, y) then
					local proc = down and mousedown or mouseup
					proc:HandleEvent(button, x, y)
				else
					return true
				end
			end
		end)()

		TheFrontEnd.OnMouseMove = (function()
			local onmove = TheFrontEnd.OnMouseMove

			return function(self, x, y)
				mousemove:HandleEvent("move", x, y)
				return onmove(self, x, y)
			end
		end)()

		initialized_handlers = true
	end
end

--------------------------------------------------------------------
local MouseManager = Class(function(self, parent, button)
	self.parent = parent
	self.inst = parent.inst
	self.button = button

	self.selection_box_modifier = nil
	self.cherry_picking_modifier = nil

	self.handlers = nil

	self.ondown = function()
		return self:OnDown()
	end

	self.onup = function()
		return self:OnUp()
	end

	self.thread = nil
end)

function MouseManager:SetSelectionBoxModifier(key)
	self.selection_box_modifier = key
end

function MouseManager:SetCherryPickingModifier(key)
	self.cherry_picking_modifier = key
end

function MouseManager:IsSelecting()
	return self.thread ~= nil
end

function MouseManager:Clear()
	if self.thread then
		CancelThread(self.thread)
		self.thread = nil
		self.parent:ClearSelectionRectangle()
	end
	if self.handlers and self.handlers.move then
		self.handlers.move:Remove()
		self.handlers.move = nil
	end
	self.update_selection = nil
end

local function MouseManager_OnDown_SelectionBox(self)
	local queued_movement = false
	local started_selection = false

	assert(self.handlers).move = AddMouseMoveHandler(function()
		queued_movement = true
	end)

	local pos0 = TheInput:GetScreenPosition()
	local x0, y0 = pos0.x, pos0.y

	local inst = self.inst
	local TheInput = _G.TheInput

	local is_right = (self.button == MOUSEBUTTON_RIGHT)
	local getAction = ActionGetter(inst)

	local previous_ents = {}

	self.update_selection = function()
		local pos = TheInput:GetScreenPosition()

		if not started_selection then
			if GeoUtil.ManhattanDistance(pos, pos0) > 64 then
				started_selection = true
			else
				return
			end
		end

		local xmin, xmax = x0, pos.x
		if xmax < xmin then
			xmin, xmax = xmax, xmin
		end

		local ymin, ymax = y0, pos.y
		if ymax < ymin then
			ymin, ymax = ymax, ymin
		end

		self.parent:SetSelectionRectangle(xmin, ymin, xmax, ymax)

		local A, B, C, D = GeoUtil.MapScreenPt(xmin, ymin), GeoUtil.MapScreenPt(xmax, ymin), GeoUtil.MapScreenPt(xmax, ymax), GeoUtil.MapScreenPt(xmin, ymax)
		self.parent.A = Vector3(TheSim:ProjectScreenPos(xmin,ymin))
		self.parent.B = Vector3(TheSim:ProjectScreenPos(xmax,ymin))
		self.parent.C = Vector3(TheSim:ProjectScreenPos(xmin,ymax))
		self.parent.D = Vector3(TheSim:ProjectScreenPos(xmax,ymax))

		local isBounded = GeoUtil.NewQuadrilateralTester(A, B, C, D)

		local center = GeoUtil.MapScreenPt((xmin + xmax)/2, (ymin + ymax)/2)
		local x, y, z = center:Get()

		local radiussq = math.max(
			center:DistSq(A),
			center:DistSq(B),
			center:DistSq(C),
			center:DistSq(D)
		)

		local cur_ents = {}
		local ents = TheSim:FindEntities(x, y, z, math.sqrt(radiussq), nil, UNSELECTABLE_TAGS)
		for _, target in ipairs(ents) do
			if target.Transform and target:IsValid() and not target:IsInLimbo() and isBounded(target:GetPosition()) then
				local actions = getAction(target, is_right)
				if actions[1] then
					cur_ents[target] = true
					self.parent:SelectEntity(target, is_right)
				end
			end
		end
		for inst in pairs(previous_ents) do
			if not cur_ents[inst] then
				self.parent:DeselectEntity(inst)
			end
		end
		previous_ents = cur_ents
	end

	self.thread = self.inst:StartThread(function()
		while inst:IsValid() do
			if queued_movement then
				self.update_selection()
				queued_movement = false
			end
			Sleep(UPDATE_PERIOD)
		end
		self:Clear()
	end)
end

local function MouseManager_OnDown_CherryPick(self)
	local getAction = ActionGetter(self.inst)
	local is_right = (self.button == MOUSEBUTTON_RIGHT)

	local ents = TheInput:GetAllEntitiesUnderMouse()

	for _, target in ipairs(ents) do
		if target.Transform and target:IsValid() and not target:IsInLimbo() then
			local actions = getAction(target, is_right)
			if actions[1] then
				self.parent:ToggleEntitySelection(target, is_right)
				return
			end
		end
	end

end

function MouseManager:OnDown()
	self:Clear()

	if not self.inst:IsValid() or self.parent:IsSelecting() then return end

	if not self.cherry_picking_modifier or TheInput:IsKeyDown(self.cherry_picking_modifier) then
		MouseManager_OnDown_CherryPick(self)
	end

	if not self.selection_box_modifier or TheInput:IsKeyDown(self.selection_box_modifier) then
		MouseManager_OnDown_SelectionBox(self)
	end
end

function MouseManager:OnUp()
	if self.update_selection then
		self.update_selection()
		if ThePlayer and self.button == MOUSEBUTTON_RIGHT then
			local aItem = ThePlayer.replica.inventory:GetActiveItem()
			if aItem and CheckDeploy(aItem) then 
				self.parent:ApplyToDeploy()
				self:Clear()
				return 
			end
		end
	end
	self.parent:ApplyToSelection()
	self:Clear()
end

function MouseManager:Attach()
	if self.handlers then return end
	self.handlers = {}

	self.handlers.down = AddMouseButtonHandler(self.button, true, self.ondown)
	self.handlers.up = AddMouseButtonHandler(self.button, false, self.onup)
	self.handlers.move = nil
end

function MouseManager:Dettach()
	self:Clear()

	if self.handlers then
		for _, handler in pairs(self.handlers) do
			handler:Remove()
		end
		self.handlers = nil
	end
end

--------------------------------------------------------------------
local function NewSelectionWidget(self)
	local widget = Image("images/selection_square.xml", "selection_square.tex")
	widget:SetTint(unpack(SELECTION_BOX_TINT))
	return widget
end

local ActionQueuer = Class(function(self, inst)
	self.inst = inst
	self.buttons = {MOUSEBUTTON_LEFT, MOUSEBUTTON_RIGHT}

	self.selection_box_modifier = nil
	self.cherry_picking_modifier = nil

	self.selection_widget = nil

	self.isDstNewVersion = true
	self.doAutoCollect = false
	-- Maps inst to "right button?" (true or false)
	self.selected_insts = {}

	self.managers = {}
	self.event_listeners = nil

	self.enabled = false
	self.interrupted = false
	inst:DoTaskInTime(0, function(inst)
		if not (inst:IsValid() and inst.components.actionqueuer) then return end

		if inst.HUD and inst.HUD.controls then
			InitializeHandlerAdders()

			self.selection_widget = inst.HUD.controls:AddChild(NewSelectionWidget(self))
			self.selection_widget:Hide()
			
			for _, button in ipairs(self.buttons) do
				local mgr = MouseManager(self, button)
				mgr:SetSelectionBoxModifier(self.selection_box_modifier)
				mgr:SetCherryPickingModifier(self.cherry_picking_modifier)
				self.managers[button] = mgr
			end
		end

		self:Enable()
	end)
end)

function ActionQueuer:SetConfig(val1)
	self.isDstNewVersion = val1
end

function ActionQueuer:SetSelectionBoxModifier(key)
	self.selection_box_modifier = key
	for _, mgr in pairs(self.managers) do
		mgr:SetSelectionBoxModifier(key)
	end
end

function ActionQueuer:SetCherryPickingModifier(key)
	self.cherry_picking_modifier = key
	for _, mgr in pairs(self.managers) do
		mgr:SetCherryPickingModifier(key)
	end
end

function ActionQueuer:IsSelecting()
	for _, mgr in pairs(self.managers) do
		if mgr:IsSelecting() then
			return true
		end
	end
	return false
end

function ActionQueuer:IsSelectedEntity(inst)
	return self.selected_insts[inst] ~= nil
end

function ActionQueuer:SelectEntity(inst, right)
	if not inst:IsValid() or inst:IsInLimbo() then
		self:DeselectEntity(inst)
		return
	end
	if self.selected_insts[inst] == nil then
		self.selected_insts[inst] = right or false
		local highlight = inst.components.highlight
		if not highlight then
			inst:AddComponent("highlight")
			highlight = inst.components.highlight
		end
		if not highlight.highlit then
			local override = inst.highlight_override
			if override then
				highlight:Highlight(override[1], override[2], override[3])
			else
				highlight:Highlight()
			end
		end
	end
end

function ActionQueuer:DeselectEntity(inst)
	if self.selected_insts[inst] ~= nil then
		self.selected_insts[inst] = nil
		if inst:IsValid() and inst.components.highlight then
			inst.components.highlight:UnHighlight()
		end
	end
end

function ActionQueuer:ToggleEntitySelection(inst, right)
	if self:IsSelectedEntity(inst) then
		self:DeselectEntity(inst)
	else
		self:SelectEntity(inst, right)
	end
end

function ActionQueuer:ClearSelectedEntities()
	for inst in pairs(self.selected_insts) do
		self:DeselectEntity(inst)
	end
end

function ActionQueuer:SetSelectionRectangle(x0, y0, x1, y1)
	local widget = self.selection_widget
	if widget then
		widget:SetPosition((x0 + x1)/2, (y0 + y1)/2)
		widget:SetSize(x1 - x0, y1 - y0)
		widget:Show()
	end
end

function ActionQueuer:ClearSelectionRectangle()
	local widget = self.selection_widget
	if widget then
		widget:Hide()	
	end
end

function ActionQueuer:RPCRight(act,position,target,isreleased,controlmods,force)
	if self.isDstNewVersion == true then
		SendRPCToServer(RPC.RightClick, act.action.code, position.x, position.z, target, act.rotation ~= 0 and act.rotation or nil,isreleased, controlmods, force, act.action.mod_name)
	else
		SendRPCToServer(RPC.RightClick, act.action.code, position.x, position.z, target,isreleased, controlmods, force, act.action.mod_name)
	end
end

function ActionQueuer:WaitAction(isWaitWork)
	local inst = self.inst
	local pc = inst.components.playercontroller
	if pc.locomotor ~= nil then
		repeat
			Sleep(0.06)
		until self.interrupted or (inst:HasTag("idle") and inst.sg and inst.sg:HasStateTag("idle") and not inst:HasTag("moving") and not inst.sg:HasStateTag("moving") and not pc:IsDoingOrWorking())
	else
		if isWaitWork then
			repeat Sleep(FRAMES)
			until not inst:HasTag("idle") or inst:HasTag("moving") or pc:IsDoingOrWorking()
		end
		repeat 
		    Sleep(0.06)
		until self.interrupted or (not inst:HasTag("moving") and not pc:IsDoingOrWorking())
	end
end

local function checkLineParam(p1,p2)
	if p1.x == p2.x or math.abs(p1.x-p2.x)<0.5 then
		return 1
	elseif p1.z == p2.z or math.abs(p1.z-p2.z)<0.5 then 
		return 2
	else 
		return 0
	end
end
local function calLineParam(p2,p1)
	local k,b
	if p1.x == p2.x then
		k = 0
		b = p1.x		
	else
		k = (p2.z-p1.z)/(p2.x-p1.x)
		b = p2.z-k*p2.x
	end
	return k,b
end

function ActionQueuer:ApplyToDeploy()
	if self.selection_thread then return end
	local A = self.A
	local C = self.C
	local B = self.B
	local D = self.D
	if not A or not B or not C or not D or A == C or C == D or not self.inst:IsValid() or not self.inst.components.playercontroller then return end
	if not self.inst.replica.inventory then return end
	local aItem = self.inst.replica.inventory:GetActiveItem()
	if not aItem or not CheckDeploy(aItem) then return end
	self.selection_thread = self.inst:StartThread(function()
		local inst = self.inst
		local pc = inst.components.playercontroller
		inst:ClearBufferedAction()
		self.interrupted = false
		local cP = C
		local cD = D
		local ox,oz = C.x,C.z

		local vhcd = checkLineParam(C,D)
		local kcd,bcd = calLineParam(C,D)
		local xdcd = C.x<D.x and 1 or -1
		local zdcd = C.z<D.z and 1 or -1 
		local vhca = checkLineParam(C,A)
		local kca,bca = calLineParam(C,A)
		local xdca = C.x<A.x and 1 or -1
		local zdca = C.z<A.z and 1 or -1 
		vhca = vhcd == 1 and 2 or vhca
		vhca = vhcd == 2 and 1 or vhca
		vhcd = vhca == 1 and 2 or vhcd
		vhcd = vhca == 2 and 1 or vhcd
		
		local offset = 0.3
		local addVal = 0.25 --0.25
		if vhca == 0 then addVal = 0.5 end
		local function calAbleDeployPos(vh,zd,xd,k,b)
			if vh == 1 then
				cP.z = cP.z + addVal * zd
			elseif vh == 2 then
				cP.x = cP.x + addVal * xd
			else 
				cP.x = cP.x + addVal * xd
				cP.z = k * cP.x + b
			end
		end
		local function checkOutRange(vh,zd,xd,po)
			if vh == 1 then
				if zd == 1 and cP.z > po.z + offset then return true end
				if zd == -1 and cP.z < po.z - offset then return true end
			elseif vh == 2 then
				if xd == 1 and cP.x > po.x + offset then return true end
				if xd == -1 and cP.x < po.x - offset then return true end
			else 
				if zd == 1 and cP.z > po.z + offset then return true end
				if zd == -1 and cP.z < po.z - offset then return true end
				if xd == 1 and cP.x > po.x + offset then return true end
				if xd == -1 and cP.x < po.x - offset then return true end
			end
			return false
		end
		local dm = GetDeployMode(aItem)
		local function checkPosEntity(x,z)
			if dm ~= DEPLOYMODE.WALL then return false end
			local es = TheSim:FindEntities(x, 0, z, 0.9, nil, UNSELECTABLE_TAGS)
			local esc = #es
			if esc > 0 then
				if es[1] == inst then esc = esc - 1 end
				if esc > 0 then return true end
			end
			return false
		end
		local ainame = aItem.prefab
		local vorh = false
		while not self.interrupt do
			local cai = inst.replica.inventory:GetActiveItem()
			if not cai then
				local ic = nil
				if inst.replica.inventory:GetOverflowContainer() and inst.replica.inventory:GetOverflowContainer():Has(ainame,1) then
					ic = inst.replica.inventory:GetOverflowContainer()
				elseif inst.replica.inventory:Has(ainame,1) then
					ic = inst.replica.inventory
				end
				if ic then
					local itemslots = nil
					if ic.GetItems then 
						itemslots = ic:GetItems() 
					elseif pc.ismastersim then
						itemslots = ic.itemslots or ic.slots
					end
					local slot = nil
					for k,v in pairs(itemslots or {}) do
						if v.prefab == ainame then
							slot = k
							break
						end
					end
					if slot then 
						ic:TakeActiveItemFromAllOfSlot(slot)
						cai = inst.replica.inventory:GetActiveItem()
					end
				end
			end
			if self.interrupted or not cai or not cai.replica or not cai.replica.inventoryitem then return self:Interrupt() end
			if not vorh then
				while (not cai.replica.inventoryitem:CanDeploy(cP) or checkPosEntity(cP.x,cP.z)) and not self.interrupt do
					calAbleDeployPos(vhcd,zdcd,xdcd,kcd,bcd)
					if checkOutRange(vhcd,zdcd,xdcd,cD) then 
						vorh = true
						cP.x = ox
						cP.z = oz
						break
					end
				end
			end
			if vorh then
				repeat
					calAbleDeployPos(vhca,zdca,xdca,kca,bca)
					if checkOutRange(vhca,zdca,xdca,A) then 
						vorh = false
						return self:Interrupt() 
					end
				until (cai.replica.inventoryitem:CanDeploy(cP)) or self.interrupt 
				cD.x = cD.x - (ox - cP.x)
				cD.z = cD.z - (oz - cP.z)
				ox = cP.x
				oz = cP.z
				bcd = cP.z-kcd*cP.x
				vorh = false
			end
			if self.interrupted or not cai or not cai.replica or not cai.replica.inventoryitem then return self:Interrupt() end
			local bufaction = BufferedAction(inst, nil , ACTIONS.DEPLOY, cai, Vector3(cP.x,0,cP.z))
			if pc.deployplacer ~= nil and bufaction.action == ACTIONS.DEPLOY then
            	bufaction.rotation = pc.deployplacer.Transform:GetRotation()
        	end
			if pc.ismastersim then
				inst.components.combat:SetTarget(nil)
		        pc:DoAction(bufaction) 
	    	else
	    		local position = Vector3(cP.x,0,cP.z)
	            local mouseover = nil
	            local controlmods = pc:EncodeControlMods()
	            if pc.locomotor == nil then
	                pc.remote_controls[CONTROL_SECONDARY] = 0
	                self:RPCRight(bufaction,position,mouseover,nil,controlmods,bufaction.action.canforce)
	            elseif bufaction.action ~= ACTIONS.WALKTO and pc:CanLocomote() then
	                bufaction.preview_cb = function()
	                    pc.remote_controls[CONTROL_SECONDARY] = 0
	                    local isreleased = true
	                    self:RPCRight(bufaction,position,mouseover,isreleased,controlmods,nil)
	                end
	            end
	            pc:DoAction(bufaction)
		    end
		    self:WaitAction()
		end
	end)
end

function ActionQueuer:RepeatRecipe(recipe, skin)
	if self.selection_thread then return end
	if not self.inst.replica.builder then return end
	self.selection_thread = self.inst:StartThread(function()
		local inst = self.inst
		local pc = inst.components.playercontroller
		inst:ClearBufferedAction()
		self.interrupted = false

		while not self.interrupt do
			if self.interrupted or not inst.replica.builder:CanBuild(recipe.name) then return self:Interrupt() end
			if pc.ismastersim and inst.components.builder then
				inst.components.combat:SetTarget(nil)
		        inst.components.builder:MakeRecipeFromMenu(recipe, skin)
			else
				pc:RemoteMakeRecipeFromMenu(recipe, skin)
		    end
			self:WaitAction()
		end
	end)
end

function ActionQueuer:AutoCollect(c)
	if self.doAutoCollect == false or not c then return end

	--local c = target:GetPosition()
	local ents = TheSim:FindEntities(c.x, c.y, c.z, 4, nil, UNSELECTABLE_TAGS)
	for _, target in ipairs(ents) do
		repeat
			if target.Transform and target:IsValid() and not target:IsInLimbo() then
				local actions = self.inst.components.playeractionpicker:GetSceneActions(target, false)
				if actions[1] and (actions[1].action == ACTIONS.PICK or actions[1].action == ACTIONS.PICKUP) then
					if target.components.mine and not target.components.mine.inactive then
						break
					end
					if target.components.trap and not target.components.trap.isset then
						break
					end
					if ThePlayer and not ThePlayer.components.playercontroller.ismastersim and target:HasTag("trap") then 
						break
					end
					self:SelectEntity(target, false)
				end
			end
		until true
	end
end

function ActionQueuer:ApplyToSelection()
	if next(self.selected_insts) == nil then return end
	if self.selection_thread then
		return
	end
	if not self.inst:IsValid() then return end
	if not self.inst.components.playercontroller then return end
	local getActions = ActionGetter(self.inst, true)
	self.selection_thread = self.inst:StartThread(function()
		local inst = self.inst
		local pc = inst.components.playercontroller
		inst:ClearBufferedAction()
		local current_bufaction
		self.interrupted = false
		local last_entity, last_action ,last_pick_entity
		local last_chop_time,cur_chop_time
		local function apply_action(target, bufaction)
			if bufaction == nil or not bufaction:TestForStart() then
				return false
			end
			local isRight = bufaction.isRight
			if last_entity ~= nil and last_entity == target then
				if last_action == bufaction.action and (bufaction.action == ACTIONS.PICKUP or bufaction.action == ACTIONS.PICK) then
					if not pc.ismastersim then 
						return false
					else
						if last_pick_entity ~= nil and last_pick_entity == target then
							return false
						else
							last_pick_entity = target
						end
					end
				elseif (last_action == ACTIONS.TURNOFF and bufaction.action == ACTIONS.TURNON) or (last_action == ACTIONS.TURNON and bufaction.action == ACTIONS.TURNOFF) then
					return false
				elseif bufaction.action == ACTIONS.SHAVE then
					return false
				end
			end
			last_entity = target
			current_bufaction = bufaction
			last_action = bufaction.action
            if pc.ismastersim then
                self.inst.components.combat:SetTarget(nil)
                pc:DoAction(bufaction) 
                return true
            else
            	if isRight then
					local position = target:GetPosition()
		            local mouseover = target or nil
		            local controlmods = pc:EncodeControlMods()
		            if pc.locomotor == nil then
		                pc.remote_controls[CONTROL_SECONDARY] = 0
		                self:RPCRight(bufaction,position,mouseover,nil,controlmods,bufaction.action.canforce)
		            elseif bufaction.action ~= ACTIONS.WALKTO and pc:CanLocomote() then
		                bufaction.preview_cb = function()
		                    pc.remote_controls[CONTROL_SECONDARY] = 0
		                    local isreleased = true
		                    if bufaction.action == ACTIONS.HAMMER then
		                    	isreleased = false
		                    end
		                    self:RPCRight(bufaction,position,mouseover,isreleased,controlmods,nil)
		                end
		            end
            	else
			        local position = target:GetPosition()
			        if bufaction.action == ACTIONS.WALKTO then
			        	position = TheInput:GetWorldPosition()
					end
			        local mouseover = bufaction.action ~= ACTIONS.DROP and target or nil
			        local controlmods = pc:EncodeControlMods()
			        if pc.locomotor == nil then
			            pc.remote_controls[CONTROL_PRIMARY] = 0
			            SendRPCToServer(RPC.LeftClick, bufaction.action.code, position.x, position.z, mouseover, nil, controlmods, bufaction.action.canforce, bufaction.action.mod_name)
			        elseif bufaction.action ~= ACTIONS.WALKTO and pc:CanLocomote() then
			            bufaction.preview_cb = function()
			                pc.remote_controls[CONTROL_PRIMARY] = 0
			                local isreleased = true
			                if bufaction.action == ACTIONS.CHOP or bufaction.action == ACTIONS.MINE then
		                    	isreleased = false
		                    end
			                SendRPCToServer(RPC.LeftClick, bufaction.action.code, position.x, position.z, mouseover, isreleased, controlmods, nil, bufaction.action.mod_name)
			            end
			        end
			    end
		        pc:DoAction(bufaction) 
				if bufaction.action == ACTIONS.WALKTO then
					Sleep(0.2)
		        	inst.components.locomotor:Stop()
		        end
		    end
			return true
		end
		while not self.interrupted and inst:IsValid() and next(self.selected_insts) ~= nil do
			local target
			local mindistsq
			for ent in pairs(self.selected_insts) do
				if ent:IsValid() and not ent:IsInLimbo() then
					local distsq = inst:GetDistanceSqToInst(ent)
					if not mindistsq or distsq < mindistsq then
						mindistsq = distsq
						target = ent
					end
				else
					self:DeselectEntity(ent)
				end
			end
			if not target then break end
			local actions = getActions(target, self.selected_insts[target])
			local tpos = target:GetPosition()
			if #actions >= 1 and apply_action(target, actions[1]) then
				if self.interrupted then break end
				local at = actions[1].action--
				if pc.ismastersim and (at == ACTIONS.CHOP or at == ACTIONS.MINE or at == ACTIONS.HAMMER) then
					local delay = (14 - 1)*FRAMES
					if at == ACTIONS.CHOP and inst.prefab == "woodie" then
						delay = (10 - 1)*FRAMES
					end
					Sleep(delay)
				else
					self:WaitAction(true)
				end
				if at == ACTIONS.CHOP or at == ACTIONS.MINE or at == ACTIONS.HAMMER or at == ACTIONS.DIG then 
					self:AutoCollect(tpos)
				end
			else
				self:DeselectEntity(target)
			end
			current_bufaction = nil
		end
		self.selection_thread = nil
	end)
end

function ActionQueuer:Interrupt()
	self.A=nil
	self.C=nil
	self.B=nil
	self.D=nil
	self.interrupted = true
	self:ClearSelectedEntities()
	for _, mgr in pairs(self.managers) do
		mgr:Clear()
	end
	self:ClearSelectionRectangle()
	if self.selection_thread then
		CancelThread(self.selection_thread)
		self.selection_thread = nil
	end
end

--------------------------------------------------------------------
function ActionQueuer:Enable()
	if self.enabled then return end

	for _, mgr in pairs(self.managers) do
		mgr:Attach()
	end

	self.enabled = true
end

function ActionQueuer:Disable()
	self:Interrupt()

	if not self.enabled then return end

	for _, mgr in pairs(self.managers) do
		mgr:Dettach()
	end

	self.enabled = false
end

local function ActionQueuer_KillWidget(self)
	if self.selection_widget then
		self.selection_widget:Kill()
		self.selection_widget = nil
	end
end

function ActionQueuer:OnRemoveFromEntity()
	self:Disable()
	ActionQueuer_KillWidget(self)
end

function ActionQueuer:OnRemoveEntity()
	self:Disable()
	ActionQueuer_KillWidget(self)
end

--------------------------------------------------------------------
return ActionQueuer
