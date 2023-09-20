--!strict

--[[
    Connection     1.0.0
    A Typed Connection Implementation similar to RBXScriptConnection.

    https://github.com/YetAnotherClown/Signal/blob/master/lib/Connection.lua
]]

--[=[
    @class Connection

    A Connection returned by [`Signal:connect`](/api/Signal#connect).
]=]
local Connection = {}
Connection.__index = Connection

--- @within Connection
function Connection:disconnect(): nil
	self._active = false

	return
end

--- @within Connection
function Connection.new<T...>(callback: (T...) -> nil): Connection
	local self = {}
	setmetatable(self, Connection)

	self._active = true
	self._callback = function(...: T...)
		if not self._active then
			return
		end

		callback(...)
	end

	return self
end

export type Connection = typeof(Connection.new(function(...) end))

return Connection