# Signal

<a href="https://yetanotherclown.github.io/Signal/"><strong>View docs</strong></a>

A Typed Signal Implementation similar to [`RBXScriptSignal`](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) with camelCasing & thread-pooling.

---
    
#### Features
- Typed
- Thread-Pooling
- Parallel Support
    
#### Usage
```lua
    local Signal = require("signal.luau)
    
    local mySignal = Signal.new()
    local myConnection = mySignal:connect(function(...)
        print(...)
    end)
    
    mySignal:fire("Hello, world!")
    -- Prints "Hello, world!"

    -- Always disconnect your Connections!
    myConnection:disconnect()

    -- Or to disconnect all:
    mySignal:disconnectAll()
```

#### Building with Rojo

To build yourself, use: 
```bash
rojo build -o "Signal.rbxm"
```

Note: Wally does not export types automatically and will display a type-error in one of the Dependencies.
To fix this, see https://github.com/JohnnyMorganz/wally-package-types.

For more help, check out [the Rojo documentation](https://rojo.space/docs).