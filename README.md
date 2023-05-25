# Portal SPT tas.lua

This library is to be used with the latest SPT version with Lua support.

At the time of writing, this is only available through my [fork](https://github.com/ChrisUMB/SourcePauseTool-vlua).

## Installation
To install, simply download `tas.lua` and place it in the `lua/libraries` folder in your Portal game directory. This directory should already exist if you have downloaded and loaded the latest version of SPT with Lua support.

## Usage

To use, add:

`local tas = require("tas")`

To the top of any `.lua` file you want to use the TAS functionality in.

Then, to execute the TAS, just execute it like any other lua file with `spt_lua_run <file name>`.

**Note:** It's often best to run `spt_lua_reset` before running a TAS, because TAS functionality often relies on "coroutines", so if you are in the middle of a TAS and try to run another TAS, it will still try to finish the previous execution.

## Example

You can find more examples in the `examples` folder, all of which are ready to
be ran, and littered with comments explaining things.

```lua
local tas = require("tas")

tas.start({
     map = "testchmb_a_15"
}, function() 

    tas.wait(100)
    input.forward:hold()
    tas.wait(50)
    input.jump:tap()
    tas.wait(50)
    input.forward:release()
    tas.wait(50)

end)
```