--!strict

--[[
    Signal     1.0.0-beta
    A Typed Signal Implementation similar to RBXScriptSignal with Performance in mind.

    https://clownxz.github.io/Signal/
]]

local Connection = require(script.Connection)
local ThreadPool = require(script.ThreadPool)

export type Connection = Connection.Connection
export type ThreadPool = ThreadPool.ThreadPool

--[=[
    @class Signal

    A typed implementation of Roblox's RBXScriptSignal based on Stravant's Goodsignal, designed to replicate the behavior of [`RBXScriptSignal`](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal).
    
    **Usage**
    
    ```lua
    	local Signal = require(path.to.module)
    	
    	local mySignal = Signal.new()
    	mySignal:connect(function(...)
    		print(...)
    	end)
    	
    	mySignal:fire("Hello, world!")
    	-- Prints "Hello, world!""
    ```
]=]
local Signal = {}
Signal.__index = Signal

--[=[
	@method connect
	@within Signal
	
	Creates a Connection with a Signal. When the Signal is fired with `Signal:fire(...)`, the Connection will run the supplied function.
	
	@param callback (T...) -> nil
	
	@return Connection
]=]
function Signal:connect<T...>(callback: (T...) -> nil)
	local connection = Connection.new(callback)
	table.insert(self._connections, connection)

	return connection
end

--[=[
	@method connectParallel
	@within Signal
	
	Creates a Connection with a Signal. When the Signal is fired with `Signal:fire(...: T...)`, the Connection will run the supplied function in a desyncronized state.
	
	:::note
	The Script calling this Method must be rooted under an [**Actor**](https://create.roblox.com/docs/reference/engine/classes/Actor).
	
	@param callback (...: T...) -> nil
	
	@return Connection
]=]
function Signal:connectParallel<T...>(callback: (T...) -> nil)
	local connection = Connection.new(function(...)
		task.desynchronize()

		callback(...)
	end)
	table.insert(self._connections, connection)

	return connection
end

--[=[
	@method disconnectAll
	@within Signal
	
	Disconnects all the Connections associated with the Signal. 
	
	@return void
]=]
function Signal:disconnectAll(): nil
	for index, connection: Connection in self._connections do
		self._threadPool:spawn(connection.disconnect, connection)

		self._connections[index] = nil
	end

	return
end

--[=[
	@method fire
	@within Signal
	
	Fires the Signal, calling all Connections with the supplied parameters.
	
	@param ... ...T
	
	@return void
]=]
function Signal:fire<T...>(...: T...): nil
	for index, connection: Connection in self._connections do
		if not connection._active then
			self._connections[index] = nil
			continue
		end

		self._threadPool:spawn(connection._callback, ...)
	end

	return
end

--[=[
	@method once
	@within Signal
	
	Connects to the Signal once, runs the provided callback after the Signal is fired one time.
	
	@param callback (...: T...) -> nil
	
	@return Connection
]=]
function Signal:once<T...>(callback: (T...) -> nil)
	local connection: Connection
	connection = Connection.new(function(...)
		connection:disconnect()

		self._threadPool:spawn(callback, ...)
	end)
	table.insert(self._connections, connection)

	return connection
end

--[=[
	@method wait
	@within Signal
	@yields
	
	Yields the current thread until the Signal is fired upon with `Signal:fire(...)`, returning the parameters given in the `fire` method.
	
	```lua
		-- Yields the thread until the Signal is fired upon.
		local param1, param2... = mySignal:wait()
	```
	
	@return ...any
]=]
function Signal:wait(): any
	local success = false
	local returnedValues

	local connection: Connection
	connection = Connection.new(function(...)
		returnedValues = { ... }
		success = true

		connection:disconnect()
	end)
	table.insert(self._connections, connection)

	while not success and connection._active do
		task.wait()
	end

	return returnedValues and table.unpack(returnedValues)
end

--[=[
	@function new
	@within Signal
	
	Creates a new Signal Instance and returns it.
	
	@return Signal
]=]
function Signal.new()
	local self = {}
	setmetatable(self, Signal)

	--[=[
		@prop _connections table
		@within Signal
		@private
		@tag Internal Use Only
		
		An internal table of Connection Instances.
	]=]
	self._connections = {}

	--[=[
    	@prop _threadPool ThreadPool
    	@within Signal
    	@private
    	@tag Internal Use Only
    	
    	A ThreadPool for recycling threads.
    ]=]
	self._threadPool = ThreadPool.new()

	return self
end

export type Signal = typeof(Signal.new())

return Signal