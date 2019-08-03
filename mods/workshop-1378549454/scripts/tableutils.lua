--[[
Copyright (C) 2018 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

function table.makeuniquei(t)
    local ut = {}
    local exists = {}
    for i, v in ipairs(t) do
        if not exists[v] then
            ut[#ut + 1] = v
            exists[v] = true
        end
    end
    return ut
end

function table.makeunique(t)
    local ut = {}
    local exists = {}
    for k, v in pairs(t) do
        if not exists[v] then
            ut[k] = v
            exists[v] = true
        end
    end
    return ut
end

Queue = Class(function(self, entries)
    local _head = 0
    local _tail = 0
    local _queue = {}

    local function Reset(self)
        _head = 0
        _tail = 0
    end

    function self:Size()
        return _head - _tail
    end

    function self:Push(v)
        _head = _head + 1
        _queue[_head] = v
    end

    self.Push_Front = self.Push

    function self:Push_Back(v)
        _tail = _tail - 1
        _queue[_tail] = v
    end

    function self:Pop()
        if self:IsEmpty() then return nil end
        _tail = _tail + 1
        local r = _queue[_tail]
        _queue[_tail] = nil
        if self:IsEmpty() then Reset(self) end
        return r
    end

    self.Pop_Back = self.Pop

    function self:Pop_Front()
        if self:IsEmpty() then return nil end
        _head = _head - 1
        local r = _queue[_head]
        _queue[_head] = nil
        if self:IsEmpty() then Reset(self) end
        return r
    end

    function self:Peek()
        return _queue[_tail + 1]
    end

    self.Peek_Back = self.Peek

    function self:Peek_Front()
        return _queue[_head - 1]
    end

    function self:Contents()
        return function()
            --the first value determines whether or not to stop the for loop, since nil is a valid value to return for self:Pop_Back() we do a IsEmpty check
            return not self:IsEmpty() and true or nil, self:Pop_Back()
        end, self, nil
    end

    function self:RContents()
        return function()
            --the first value determines whether or not to stop the for loop, since nil is a valid value to return for self:Pop_Front() we do a IsEmpty check
            return not self:IsEmpty() and true or nil, self:Pop_Front()
        end, self, nil
    end

    function self:IsEmpty()
        return self:Size() == 0
    end

    for i, v in ipairs(type(entries) == "table" and entries or {}) do
        self:Push_Back(v)
    end
end)