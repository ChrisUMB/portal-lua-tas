---@class tas
local tas = {}
local tick = 0

local fps_max = console.var_find("fps_max")
local mat_norendering = console.var_find("mat_norendering")
local spt_tas_strafe = console.var_find("spt_tas_strafe")
local spt_tas_strafe_type = console.var_find("spt_tas_strafe_type")
local spt_tas_strafe_jumptype = console.var_find("spt_tas_strafe_jumptype")
local spt_tas_anglespeed = console.var_find("spt_tas_anglespeed")
local spt_tas_strafe_vectorial = console.var_find("spt_tas_strafe_vectorial")
local spt_tas_strafe_dir = console.var_find("spt_tas_strafe_dir")
local spt_tas_strafe_yaw = console.var_find("spt_tas_strafe_yaw")
local spt_tas_strafe_scale = console.var_find("spt_tas_strafe_scale")
local spt_tas_strafe_lgagst = console.var_find("spt_tas_strafe_lgagst")
local spt_tas_strafe_lgagst_min = console.var_find("spt_tas_strafe_lgagst_min")
local spt_tas_strafe_lgagst_max = console.var_find("spt_tas_strafe_lgagst_max")
local spt_autojump = console.var_find("spt_autojump")
local spt_ivp_seed = console.var_find("spt_set_ivp_seed_on_load")

---@class StrafeOption : string

---@class StrafeType
---@field ACCEL StrafeOption Max acceleration strafing
---@field ANGLE StrafeOption Max angle strafing
---@field ACCEL_CAPPED StrafeOption Max acceleration strafing with a speed cap
---@field W_STRAFE StrafeOption W strafing
StrafeType = {
    ACCEL = "spt_tas_strafe_type 0",
    ANGLE = "spt_tas_strafe_type 1",
    ACCEL_CAPPED = "spt_tas_strafe_type 2",
    W_STRAFE = "spt_tas_strafe_type 3"
}

StrafeType[0] = StrafeType.ACCEL
StrafeType[1] = StrafeType.ANGLE
StrafeType[2] = StrafeType.ACCEL_CAPPED
StrafeType[3] = StrafeType.W_STRAFE

---@class JumpType
---@field NONE StrafeOption No special jump type
---@field ABH StrafeOption Accelerated backwards hopping
---@field BUNNY_HOP StrafeOption Bunny hop, useful in games like HL2 OE
---@field GLITCHESS StrafeOption Glitchless bunny hopping
JumpType = {
    NONE = "spt_tas_strafe_jumptype 0",
    ABH = "spt_tas_strafe_jumptype 1",
    BUNNY_HOP = "spt_tas_strafe_jumptype 2",
    GLITCHESS = "spt_tas_strafe_jumptype 3"
}

JumpType[0] = JumpType.NONE
JumpType[1] = JumpType.ABH
JumpType[2] = JumpType.BUNNY_HOP
JumpType[3] = JumpType.GLITCHESS

---@class StrafeDirection
---@field LEFT StrafeOption Strafe to the left
---@field RIGHT StrafeOption Strafe to the right
---@field YAW StrafeOption Strafe towards `spt_tas_strafe_yaw`
StrafeDirection = {
    LEFT = "spt_tas_strafe_dir 0",
    RIGHT = "spt_tas_strafe_dir 1",
    YAW = "spt_tas_strafe_dir 3"
}

StrafeDirection[0] = StrafeDirection.LEFT
StrafeDirection[1] = StrafeDirection.RIGHT
StrafeDirection[3] = StrafeDirection.YAW

---@class AutoJump
---@field ON StrafeOption Enables autojump
---@field OFF StrafeOption Disables autojump
AutoJump = {
    ON = "spt_autojump 1",
    OFF = "spt_autojump 0"
}

---@class DuckSpam
DuckSpam = {
    ON = "+spt_spam duck",
    OFF = "-spt_spam duck"
}

---@class UseSpam
UseSpam = {
    ON = "+spt_spam use",
    OFF = "-spt_spam use"
}

---@class JumpBug
JumpBug = {
    ON = "spt_tas_strafe_autojb 1",
    OFF = "spt_tas_strafe_autojb 0"
}

---@class StrafeVectorial
---@field ON StrafeOption Enables vectorial strafing
---@field OFF StrafeOption Disables vectorial strafing
StrafeVectorial = {
    ON = "spt_tas_strafe_vectorial 1",
    OFF = "spt_tas_strafe_vectorial 0"
}

---@class LGAGST
---@field ON StrafeOption Enables LGAGST
---@field OFF StrafeOption Disables LGAGST
LGAGST = {
    ON = "spt_tas_strafe_lgagst 1",
    OFF = "spt_tas_strafe_lgagst 0"
}

---@enum AimMode
AimMode = {
    GLOBAL = 0,
    LOCAL = 1,
}

---@class LGAGSTConfiguration
---@field min number? Minimum LGAGST speed
---@field max number? Maximum LGAGST speed
---@field minspeed number? Minimum speed to start LGAGST

---@class StrafeConfiguration : StrafeOption[]
---@field enabled boolean? Whether to enable or disable strafing
---@field scale number? Scale of the strafing
---@field yaw number? Yaw angle to strafe towards
---@field lgagst LGAGSTConfiguration? LGAGST configuration

--- If supplied a `StrafeOption[]`, this will apply all of the options in the array.<br>
--- If supplied a `StrafeConfiguration`, this will apply the configuration.<br>
--- If supplied a `boolean`, this will enable or disable strafing.<br>
--- This function can accept both `StrafeOption[]` and `StrafeConfiguration` as arguments.<br>
---@param ... StrafeOption|StrafeConfiguration|boolean
function tas.strafe(...)
    local args = { ... }

    local found_bool = false

    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            console.exec(arg)
        elseif type(arg) == "boolean" then
            spt_tas_strafe:set_bool(arg)
            found_bool = true
        elseif type(arg) == "table" then
            for _, option in ipairs(arg) do
                console.exec(option)
                console.msg("Strafe Config Option: \"%s\"\n", option)
            end

            if arg.yaw then
                spt_tas_strafe_yaw:set_number(arg.yaw)
            end

            if arg.scale then
                spt_tas_strafe_scale:set_number(arg.scale)
            end

            if arg.enabled ~= nil then
                spt_tas_strafe:set_bool(arg.enabled)
            end
        end
    end

    if not found_bool then
        spt_tas_strafe:set_bool(true)
    end
end

--- Fast forward the TAS. To stop fast forwarding, invoke this with `false`.
---@param fast_forward boolean Whether to enable or disable fast forward.
---@param disable_render boolean|nil Whether to disable rendering.
---@overload fun(fast_forward: boolean)
function tas.fast_forward(fast_forward, disable_render)
    mat_norendering:set_bool(disable_render or false)

    if fast_forward then
        fps_max:set_number(1000)
    else
        fps_max:set_number(1.0 / 0.015)
    end
end

---Set the playback speed of the TAS.
---@param speed number Sets the speed to use.
function tas.playback_speed(speed)
    fps_max:set_number(speed * (1.0 / 0.015))
end

local _aim_mode

---@param aim_mode AimMode|nil The aim mode to use, or nil to get the current aim mode.
---@return AimMode The current aim mode.
---@overload fun(): AimMode
function tas.aim_mode(aim_mode)
    if aim_mode ~= nil then
        _aim_mode = aim_mode
    end

    return _aim_mode
end

--- Pauses the TAS.
function tas.pause()
    console.exec("tas_pause 1")
end

---@param ticks number|function|nil Sets the number of ticks to skip, or a function to test every tick. nil to wait 1 tick.
---@return number The number of ticks waited.
---@async
function tas.wait(ticks)
    if ticks == 0 then
        return 0
    end

    local ticks_waited = 0

    ticks = ticks or 1
    if type(ticks) == "function" then
        while not ticks() do
            tas.wait(1)
            ticks_waited = ticks_waited + 1
        end
        return ticks_waited
    end

    ticks_waited = ticks
    events.sim_tick:wait(ticks)
    return ticks_waited
end

---@class TASOptions
---@field load string|nil The name of the save to load before the TAS starts.
---@field map string|nil The name of the map to load before the TAS starts.
---@field auto_save string|nil Enables auto saving, and sets the name of the save to use.
---@field auto_record string|nil Enables auto recording, and sets the name of the demo to use.
---@field buffer_demo number|nil Enables demo buffering, which adds ticks to the end of the demo. Defaults to 25.
---@field auto_pause boolean|nil Enables auto TAS pause, disabled by default.
---@field seed number|nil Sets the seed to use for the TAS. This applies to IVP seeding, and will also apply to any other seeding that is found in the future.
---@field commands string|table|nil A list of commands to run before the TAS starts.

---Starts a TAS, where it will load the save, then run the function passed in a coroutine context.
---@param options TASOptions The options to use for the TAS.
---@param func function The function to invoke after TAS has run its setup code. TAS will also run it's completion code after the TAS has finished, which will save the game, write the demo, and TAS pause.
---@async
function tas.start(options, func)
    coroutine.resume(coroutine.create(function()
        tas.start_yield(options, func)
    end))
end

---@param options TASOptions The options to use for the TAS.
---@param func function The function to invoke after TAS has run its setup code. TAS will also run it's completion code after the TAS has finished, which will save the game, write the demo, and TAS pause.
---Starts a TAS, where it will load the save, then run the function passed, NOT in a coroutine context.
function tas.start_yield(options, func)
    local s, e = pcall(function()
        console.msg(0x8888FF, "\n\nStarting TAS...\n\n")

        if options.load and options.map then
           console.msg(0xFF8888, "TAS Error: Cannot have a load and map specified at the same time!\n")
           return
        end

        tas.reset()
        console.exec("sv_cheats 1;tas_pause 0;cl_mouseenable 0;host_framerate 0.015")
        
        if options.commands then
            local cmd = options.commands

            if type(cmd) == "string" then
                console.exec(cmd)
            elseif type(cmd) == "table" then
                for _, v in ipairs(cmd) do
                    console.exec(v)
                end
            end
        end

        if options.seed then
            spt_ivp_seed:set_number(options.seed)
        else
            spt_ivp_seed:set_number(1)
        end
        
        if options.load then
            console.exec("load " .. options.load)
        elseif options.map then
            console.exec("map " .. options.map)
        end
        
        if options.auto_record then
            console.exec("spt_record %s", options.auto_record)
        end

        if options.load or options.map then
            events.sim_tick:wait()
        end
        
        tick = 0

        local cancel = events.sim_tick:listen(function()
            tick = tick + 1
        end)
        
        func()

        cancel()

        -- We write this anyway so that the demo parser can know when the TAS "ended" even if we didn't write a save.
        console.exec("echo #SAVE#")
        
        if options.auto_save then
            game.save(options.auto_save)
        end


        console.msg(0x8888FF, "\n\nEnded TAS!\n\n")
        
        local buffer = options.buffer_demo or 25

        if options.auto_record then
            -- We can't use tas.wait if auto_pause is enabled because sim_ticks don't occur when tas_pause is 1.
            if not options.auto_pause and buffer and buffer >= 0 then
                tas.wait(buffer)
            end
            
            console.exec("spt_record_stop")
        end
    end)

    if not s then
        console.msg(0xFF8888, "TAS Error: " .. e .. "\n")
    end

    console.exec("cl_mouseenable 1")
    if options.auto_pause then
        tas.pause()
    end
    
    tas.wait(1)
    tas.reset()
end

---@return integer tick The current tick that the TAS is on.
function tas.get_tick()
    return tick
end

--- Resets the TAS to its default state.
-- TODO: Capture all delayed tasks related to TAS' and cancel them all.
function tas.reset()
    spt_tas_anglespeed:set_number(0)
    spt_tas_strafe:set_bool(false)
    spt_tas_strafe_lgagst:set_bool(false)
    spt_tas_strafe_lgagst_min:set_number(150)
    spt_tas_strafe_lgagst_max:set_number(270)
    spt_tas_strafe_scale:set_number(1.0)
    spt_autojump:set_bool(false)
    tas.playback_speed(1)
    console.exec("tas_aim_reset")
    console.exec("tas_anglespeed 0")
    console.exec("tas_strafe_buttons \"\"")
    tas.aim_mode(AimMode.GLOBAL)
    input.reset()
end

--- Launches an async function.
---@param func fun() The function to launch.
---@async
function tas.async(func)
    return game.async(func)
end

--[[
    TAS Aiming Functionality
        Beyond This Point
]]
local function calc_pitch_yaw_towards(from, to)
    local dx = to.x - from.x
    local dy = to.y - from.y
    local dz = (to.z or 0.0) - from.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    local nx = dx / dist
    local ny = dy / dist
    local nz = dz / dist

    local yaw = math.deg(math.atan2(ny, nx))
    local pitch = math.deg(math.atan2(nz, math.sqrt(nx * nx + ny * ny)))
    return -pitch, yaw
end

local function look_at(position, ticks, suspend)
    if ticks == nil then
        local pitch, yaw = calc_pitch_yaw_towards(player.get_eye_pos(), position)
        player.set_ang(vec2(pitch, yaw))
    end

    if not suspend then
        coroutine.resume(coroutine.create(function()
            look_at(position, ticks, true)
        end))
        return
    end

    for _ = 1, ticks do
        look_at(position, nil, nil)
        tas.wait(1)
    end
end

-- [ Lerp Utilities ] --

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function smooth_lerp(a, b, t)
    return lerp(a, b, t * t * (3 - 2 * t))
end

local function adjust_angle_lerp(a, b)
    local diff = math.abs(b - a)
    if diff < 180 then
        return a, b
    end

    return math.fmod(a + 360, 360), math.fmod(b + 360, 360)
end

local function look_interpolated_then_back(fade_to_ticks, stay_ticks, fade_back_ticks, pitch, yaw, interp_func, suspend)
    if not suspend then
        coroutine.resume(coroutine.create(function()
            look_interpolated_then_back(fade_to_ticks, stay_ticks, fade_back_ticks, pitch, yaw, interp_func, true)
        end))
        return
    end

    local start_ang = player.get_ang()
    local target_ang = vec3(pitch, yaw, 0)

    local start_pitch, target_pitch = adjust_angle_lerp(start_ang.x, target_ang.x)
    local start_yaw, target_yaw = adjust_angle_lerp(start_ang.y, target_ang.y)

    local total_ticks = fade_to_ticks + stay_ticks + fade_back_ticks
    local pct_fade_to = 1.0 / fade_to_ticks
    local pct_fade_back = 1.0 / fade_back_ticks

    for i = 1, total_ticks do
        if i <= fade_to_ticks then
            local pct = i * pct_fade_to
            local new_pitch = interp_func(start_pitch, target_pitch, pct)
            local new_yaw = interp_func(start_yaw, target_yaw, pct)
            player.set_ang(vec2(new_pitch, new_yaw))
        elseif i <= fade_to_ticks + stay_ticks then
            player.set_ang(vec2(target_pitch, target_yaw))
        else
            local pct = (i - (fade_to_ticks + stay_ticks)) * pct_fade_back
            local new_pitch = interp_func(target_pitch, start_pitch, pct)
            local new_yaw = interp_func(target_yaw, start_yaw, pct)
            player.set_ang(vec2(new_pitch, new_yaw))
        end
        tas.wait(1)
    end
end

local function look_interpolated(ticks, pitch, yaw, interp_func, suspend, get_ang, set_ang)
    if not suspend then
        coroutine.resume(coroutine.create(function()
            look_interpolated(ticks, pitch, yaw, interp_func, true, get_ang, set_ang)
        end))

        return
    end

    local start_ang = get_ang()
    local target_ang = vec3(pitch, yaw, 0)

    local start_pitch, target_pitch = adjust_angle_lerp(start_ang.x, target_ang.x)
    local start_yaw, target_yaw = adjust_angle_lerp(start_ang.y, target_ang.y)

    for i = 1, ticks do
        local pct = i / ticks
        local new_pitch = interp_func(start_pitch, target_pitch, pct)
        local new_yaw = interp_func(start_yaw, target_yaw, pct)
        set_ang(vec2(new_pitch, new_yaw))
        tas.wait(1)
    end
end

local function look_at_interpolated(target_pos, ticks, interp_function, suspend, get_ang, set_ang)
    if not suspend then
        coroutine.resume(coroutine.create(function()
            look_at_interpolated(target_pos, ticks, interp_function, true, get_ang, set_ang)
        end))

        return
    end

    local start_ang = get_ang()

    for i = 1, ticks do
        local pitch, yaw = calc_pitch_yaw_towards(player.get_eye_pos(), target_pos)
        local start_pitch, target_pitch = adjust_angle_lerp(start_ang.x, pitch)
        local start_yaw, target_yaw = adjust_angle_lerp(start_ang.y, yaw)

        local pct = i / ticks
        local new_pitch = smooth_lerp(start_pitch, target_pitch, pct)
        local new_yaw = smooth_lerp(start_yaw, target_yaw, pct)
        player.set_ang(vec2(new_pitch, new_yaw))
        tas.wait(1)
    end
end

---@alias target_fun fun():number,number
---@alias target entity|vec3|vec2|target_fun

---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, stay_ticks: number|nil, suspend:boolean|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, stay_ticks: number|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, suspend: boolean|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil)
---@overload fun(pitch: number, yaw: number)
function tas.aim_local(...)
    local mode = tas.aim_mode()
    tas.aim_mode(AimMode.LOCAL)
    tas.aim(...)
    tas.aim_mode(mode)
end

---@overload fun(target: target, lerp_ticks: number|nil, stay_ticks: number|nil, transform: mat4|portal|nil, suspend:boolean|nil)
---@overload fun(target: target, lerp_ticks: number|nil, stay_ticks: number|nil, transform: mat4|portal|nil)
---@overload fun(target: target, lerp_ticks: number|nil, stay_ticks: number|nil, suspend:boolean|nil)
---@overload fun(target: target, lerp_ticks: number|nil, stay_ticks: number|nil)
---@overload fun(target: target, lerp_ticks: number|nil, transform: mat4|portal|nil, suspend: boolean|nil)
---@overload fun(target: target, lerp_ticks: number|nil, transform: mat4|portal|nil)
---@overload fun(target: target, lerp_ticks: number|nil, suspend: boolean|nil)
---@overload fun(target: target, lerp_ticks: number|nil)
---@overload fun(target: target, transform: mat4|portal|nil)
---@overload fun(target: target)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, stay_ticks: number|nil, suspend:boolean|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, stay_ticks: number|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil, suspend: boolean|nil)
---@overload fun(pitch: number, yaw: number, lerp_ticks: number|nil)
---@overload fun(pitch: number, yaw: number)
function tas.aim(...)
	local args = {...}

	if #args == 0 then
		error("tas.look_at expected target (entity, vec3, vec2, or pitch/yaw), got nothing")
		return
	end

	local target_mt = getmetatable(args[1])

	local target
	local start_index = 2
	local end_index = #args

	local lerp_ticks = 0
	local stay_ticks = 0
	local suspend = false

	---@type mat4|nil
	local transform = nil

	if start_index <= end_index and type(args[end_index]) == "boolean" then
		suspend = args[end_index]
		end_index = end_index - 1
	end

	if start_index <= end_index then
		if getmetatable(args[end_index]) == mat4 then
			transform = args[end_index]
			end_index = end_index - 1
		elseif getmetatable(args[end_index]) == portal then
			transform = args[end_index]:get_matrix()
			end_index = end_index - 1
		end
	end

	if type(args[1]) == "function" then
		target = args[1]
	elseif target_mt == entity then
		if transform ~= nil then
			target = function() return calc_pitch_yaw_towards(player.get_eye_pos(), transform:transform(args[1]:get_pos())) end
		else
			target = function() return calc_pitch_yaw_towards(player.get_eye_pos(), args[1]:get_pos()) end
		end
	elseif target_mt == vec3 then
		if transform ~= nil then
			target = function() return calc_pitch_yaw_towards(player.get_eye_pos(), transform:transform(args[1])) end
		else
			target = function() return calc_pitch_yaw_towards(player.get_eye_pos(), args[1]) end
		end
	elseif target_mt == vec2 then
		target = function() return args[1].x, args[1].y end
	elseif end_index >= 2 and type(args[1]) == "number" and type(args[2]) == "number" then
		target = function() return args[1], args[2] end
		start_index = 3
	else
		error(string.format("tas.look_at expected entity, vec3, vec2, or pitch/yaw, got %s", type(args[1])))
	end

	if start_index <= end_index and type(args[start_index] == "number") then
		lerp_ticks = args[start_index]
		start_index = start_index + 1
	end

	if start_index <= end_index and type(args[start_index] == "number") then
		stay_ticks = args[start_index]
		start_index = start_index + 1
	end

	if start_index <= end_index then
		error(string.format("tas.look_at missing parameters or wrong types, got %s", type(args[start_index])))
	end

	local function do_aim_suspend()
		local get_ang = player.get_ang
		local set_ang = player.set_ang
		if tas.aim_mode() == AimMode.LOCAL then
			get_ang = player.get_local_ang
			set_ang = player.set_local_ang
		end

		local start_ang = get_ang()

		for i = 1, lerp_ticks do
			local pitch, yaw = target()
			local start_pitch, target_pitch = adjust_angle_lerp(start_ang.x, pitch)
			local start_yaw, target_yaw = adjust_angle_lerp(start_ang.y, yaw)

			local pct = i / lerp_ticks
			local new_pitch = smooth_lerp(start_pitch, target_pitch, pct)
			local new_yaw = smooth_lerp(start_yaw, target_yaw, pct)
			set_ang(vec2(new_pitch, new_yaw))
			tas.wait(1)
		end

		local pitch, yaw = target()
		set_ang(vec2(pitch, yaw))

		for _ = 1, stay_ticks do
			pitch, yaw = target()
			set_ang(vec2(pitch, yaw))
			tas.wait(1)
		end
	end

	if suspend then
		do_aim_suspend()
	else
		tas.async(function()
			do_aim_suspend()
		end)
	end
end

--[[
    TAS Movement Functionality
        Beyond This Point
]]
local STRAFE_SCALE = 0.24400000
local STRAFE_DISTANCE = 0.08235
local STRAFE_TICKS = 1

local MIN_STRAFE_SCALE = 0.244

---@return number, number
local function walk_to_point_math(dest)
    local _, yaw = calc_pitch_yaw_towards(player.get_eye_pos(), dest)
    local pos = player.get_pos()
    local deltaX = dest.x - pos.x
    local deltaY = dest.y - pos.y
    local dist = math.sqrt(deltaX * deltaX + deltaY * deltaY)

    return yaw, dist
end

local function circle_intersection_points(circleA, circleB)
    local deltaX = circleB.x - circleA.x
    local deltaY = circleB.y - circleA.y
    local rA = circleA.r
    local rB = circleB.r
    local d = math.sqrt(deltaX * deltaX + deltaY * deltaY)

    -- Check if the distance between the centers is zero
    if d == 0 then
        return nil, nil, "The circles are the same"
    end

    -- Check if the circles intersect
    if d > rA + rB or d < math.abs(rA - rB) then
        return nil, nil, "The circles do not intersect: d = " .. d .. ", rA = " .. rA .. ", rB = " .. rB
    end

    local a = (rA * rA - rB * rB + d * d) / (2.0 * d)

    -- Check if a is valid
    if a < 0 or a > rA then
        return nil, nil, "The circles do not intersect (a)"
    end

    local h = math.sqrt(rA * rA - a * a)
    local x2 = circleA.x + a * (circleB.x - circleA.x) / d
    local y2 = circleA.y + a * (circleB.y - circleA.y) / d
    local x3a = x2 + h * (circleB.y - circleA.y) / d
    local y3a = y2 - h * (circleB.x - circleA.x) / d
    local x3b = x2 - h * (circleB.y - circleA.y) / d
    local y3b = y2 + h * (circleB.x - circleA.x) / d
    return { x = x3a, y = y3a }, { x = x3b, y = y3b }, nil
end

local function circle_intersection_points_normalize(circleA, circleB)
    local point, _, error = circle_intersection_points(circleA, circleB)

    if error ~= nil then
        console.msg(0xFF5522, "ERROR: %s\n", error)
        return nil
    end

    if point == nil then
        console.msg(0xFF5522, "NULL POINT: %s\n")
        return nil
    end

    return vec3(point.x, point.y, 0)
end

local function wait_until_zero_velocity()
    repeat
        local vel = player.get_vel()
        local velLen = math.sqrt(vel.x * vel.x + vel.y * vel.y)
        tas.wait(1)
    until (velLen == 0)
end

local function tas_strafe_for(ticks, speed)
    tas.strafe(true, { scale = speed })
    tas.wait(ticks)
    tas.strafe(false)
end

---@param point vec3 Point to walk to.
---@param precise boolean If true, precise mode will be used, getting as close as possible with the cost of 4 extra ticks.
function tas.move_to_point(point, precise, extra_precise)
    local yaw, dist = walk_to_point_math(point)
    if dist == 0.0 then
        return
    end

    tas.strafe(StrafeVectorial.ON, AutoJump.ON, StrafeType.W_STRAFE, StrafeDirection.YAW, JumpType.GLITCHESS)

    local start_time = game.get_client_tick()

    while true do
        yaw, dist = walk_to_point_math(point)
        local scale = dist > 28.0 and 1.0 or math.max(dist / 30, MIN_STRAFE_SCALE)

        local vel = player.get_vel()
        local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y)
        if dist <= STRAFE_DISTANCE * 2 and speed < 8 then
            break
        end

        tas.strafe({ yaw = yaw, scale = scale })
        tas.wait(1)
    end

    tas.strafe(false, { scale = 1.0 })

    if precise then
        repeat
            wait_until_zero_velocity()

            yaw, dist = walk_to_point_math(point)
            while dist > STRAFE_DISTANCE * 2 do
                console.msg(0xFF5522, "Taking extra step towards point (distance %.4f)\n", dist)

                tas.strafe({ yaw = yaw })
                tas_strafe_for(STRAFE_TICKS, STRAFE_SCALE)
                yaw, dist = walk_to_point_math(point)
            end

            wait_until_zero_velocity()
            local pos = player.get_pos()

            local circleA = { x = pos.x, y = pos.y, r = STRAFE_DISTANCE }
            local circleB = { x = point.x, y = point.y, r = STRAFE_DISTANCE }
            local pointA = circle_intersection_points_normalize(circleA, circleB)

            if pointA == nil or pointA.x ~= pointA.x or pointA.y ~= pointA.y then
                console.msg(0xFF5522, "ERROR: No valid strategy found, retrying\n")
                tas_strafe_for(5, 1)
                tas.move_to_point(point, precise, extra_precise)
                break
            end

            yaw, dist = walk_to_point_math(pointA)
            tas.strafe({ yaw = yaw })

            tas_strafe_for(STRAFE_TICKS, STRAFE_SCALE)
            wait_until_zero_velocity()
            
            yaw, dist = walk_to_point_math(pointA)
            if dist ~= 0 and extra_precise then
                console.msg(0xFF5522, "ERROR: Did not reach intersection point, retrying (distance %f)\n", dist)
                tas_strafe_for(1, 0.5)
            else
                yaw, dist = walk_to_point_math(point)
                tas.strafe({ yaw = yaw })
                tas_strafe_for(STRAFE_TICKS, STRAFE_SCALE)
                wait_until_zero_velocity()

                yaw, dist = walk_to_point_math(point)

                if dist == 0 then
                    break
                elseif extra_precise then
                    console.msg(0xFF5522, "ERROR: Did not reach destination, retrying (distance %f)\n", dist)
                    tas_strafe_for(1, 0.5)
                end
            end
        until (not extra_precise)
        tas.strafe({ scale = 1.0 })
    end

    local end_time = game.get_client_tick()
    yaw, dist = walk_to_point_math(point)
    console.msg(0x22FF55, "Took %d ticks, dist: %f\n", end_time - start_time, dist)
    return end_time - start_time
end

return tas