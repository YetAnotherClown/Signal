# Signal

<a href="https://yetanotherclown.github.io/Signal/"><strong>View docs</strong></a>

A Typed Signal Implementation similar to [`RBXScriptSignal`](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) with Performance in mind.

---
    
#### Features
- Typed
- Thread Pooling
- Parallel Support
- Designed for performance
    
#### Usage
```lua
    local Signal = require(path.to.module)
    
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

For more help, check out [the Rojo documentation](https://rojo.space/docs).