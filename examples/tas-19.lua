--[[

This is a TAS script for Chamber 19. The expected result is that
it will do the spiderman route with the TAS shot save up to the
first door, open it, and then end.

]]


-- Get access to TAS, which will be in `/lua/libraries/tas.lua`
local tas = require("tas")

-- Start a TAS.
tas.start({
    map = "testchmb_a_15", -- Load chamber 19 through the `map` command
    auto_pause = true -- Auto TAS pause at the end of the script.
}, function() 

    -- Waiting because the map command introduces artificial delay.
    tas.wait(150)



    -- Enable TAS strafing with these options.
    tas.strafe(StrafeVectorial.ON, StrafeType.ACCEL, StrafeDirection.YAW, {yaw = 0})
    
    -- Aim above the sign, lerp for 30 ticks, "true" means "suspend", which will
    -- basically do "tas.wait(30)" automatically.
    tas.aim(-19, 0, 30, true)
    
    -- Fire orange.
    input.attack2:tap()
    tas.wait(1)

    -- Jump and hold duck.
    input.jump:tap()
    input.duck:hold()
    
    -- Aim at the floor and fire blue.
    tas.aim(62, 0, 33, true)
    input.attack:tap()

    -- Disable TAS strafe and wait 1 tick after the jump.
    tas.strafe(false)
    tas.wait(1)

    -- Using aim_local because we're going to be traveling through a portal,
    -- so this will allow the lerp to work properly. These angles are NOT what
    -- what is shown in cl_showpos, they're what is returned by player.get_local_ang()
    tas.aim_local(-4.283190, -100.435471, 33, true)
    input.attack:tap()
    input.duck:release()

    -- Using aim_local here for the same reason.
    tas.aim_local(-18.803200, -104.890495, 34, true)
    input.attack:tap()

    -- Since we're in spiderman, the rest of this is just a series of aim and shoot.
    tas.aim(-7.524158, -103.730019, 34, true)
    input.attack:tap()

    tas.aim(-8.294158, -94.544968, 34, true)
    input.attack:tap()

    tas.aim(-12.749159, -96.964981, 34, true)
    input.attack:tap()

    tas.aim(-84.854172, 56.870106, 34, true)
    input.attack:tap()

    tas.aim(-65.764160, 57.030029, 34, true)
    input.attack:tap()

    tas.aim(-54.816422, 29.081017, 34, true)
    input.attack:tap()
    -- Sometimes when shots are pretty precise, you need to wait 1 tick after firing before
    -- trying to aim. Otherwise, the first tick of lerping for the next aim will make this shot
    -- off by just enough that it won't work.
    tas.wait(1)
    -- The omittance of "true" here means that we're going to wait 34 ticks,
    -- but the following code will get executed immediately, since we're not "suspending".
    tas.aim(-9.661416, 8.951014, 33)
    -- Walking over a bit so we can see the next shot better.
    tas.strafe(StrafeType.W_STRAFE, {yaw = -90})
    tas.wait(10)
    tas.strafe(false)
    tas.wait(24)
    -- Firing blue next to the door.
    input.attack:tap()
    tas.wait(1)
    -- Snapping our angle so we're looking through the portal in the right direction.
    tas.aim(-89.000000, 180, 15, true)
    input.jump:tap()
    events.player_teleport:wait()
    -- Strafe towards the door.
    tas.strafe(StrafeType.ACCEL, {yaw = -35})
    -- Look at the door.
    tas.aim(9.437987, -35, 10)
    tas.wait(20)
    -- Press use on the door to open it.
    input.use:tap()

    -- Disable TAS strafe.
    tas.strafe(false)
    tas.wait(30)
end)