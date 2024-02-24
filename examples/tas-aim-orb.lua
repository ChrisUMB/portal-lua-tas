-- Get access to TAS, which will be in `/lua/libraries/tas.lua`
local tas = require("tas")

-- Start a TAS.
tas.start({
    map = "testchmb_a_15", -- Load chamber 19 through the `map` command
    auto_pause = true -- Auto TAS pause at the end of the script.
}, function() 

    -- Waiting because the map command introduces artificial delay.
    tas.wait(75)

    -- Look at the wall by lerping for 75 ticks, and wait those 75 ticks.
    tas.aim(8.799999, 6.984996, 75, true)
    
    input.attack2:tap()

    -- Enable TAS strafing with these options.
    tas.strafe(StrafeVectorial.ON, StrafeType.ACCEL, StrafeDirection.YAW, {yaw = 0})
    -- Walk forward, look at the ground, then perform a QCE into blue.
    tas.wait(1)
    tas.aim(69, 0, 65)
    tas.wait(40)
    input.duck:hold()
    tas.wait(20)
    tas.strafe(false)
    tas.wait(4)
    input.duck:release()
    input.attack:tap()
    
    -- Aim at the wall and fire blue.
    tas.wait(10)
    tas.aim(8.754638, -104.300026, 24, true)
    input.attack:tap()

    -- Peek through blue, then fire orange.
    tas.wait(1)
    tas.strafe({yaw = 90})
    tas.aim_local(81.051628, 104.017303, 33)
    tas.wait(10)
    tas.strafe(false)
    tas.wait(23)
    input.attack2:tap()

    -- Wait for orange to land, then peek through blue and fire orange again, doing a portal peek.
    tas.wait(1)
    tas.aim_local(86.606659, -18.259048, 33)
    tas.wait(14)
    tas.strafe({yaw = 164})
    tas.wait(8)
    tas.strafe(false)
    tas.wait(11)
    input.attack2:tap()
    tas.wait(1)
    tas.strafe({yaw = -110})
    tas.wait(8)
    tas.strafe(false)
    tas.wait(100)
    
    -- Locate the nearest orb.
    local orb = entity.closest("prop_energy_ball")
    
    -- Look at the orb by lerping for 50 ticks, then tracking it for 120 ticks.
    -- "true" at the end means to suspend.
    tas.aim(orb, 50, 170, portal.orange(), true)
    
    tas.aim(0.875158, -64.282082, 175, true)
    
    -- Orb died, get the new one.
    orb = entity.closest("prop_energy_ball")
    
    -- Look at the orb by lerping for 50 ticks, then tracking it for 200 ticks.
    -- Do all of that, while applying the transform of the orange portal, or "looking through" the blue.
    -- "true" at the end means to suspend.
    tas.aim(orb, 50, 200, true)
    tas.wait(100)
end)
