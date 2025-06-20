local TIMECYC = exports.timecyc

local screenW, screenH = guiGetScreenSize()
local screenSource
local shaderColorFilterPS
local shaderPs2ColorBlend
local renderTarget

-- Strength of the post processing colours
local PS_MODULATE_SCALE = 0.5

-- Amount of warmth added during the day
local WARM_DAYTIME_FACTORS = { r = 1.1, g = 0.95, b = 0.9 }

local function applyWarmTint(r, g, b)
    local hour = getTime()
    if hour >= 9 and hour <= 17 then
        r = r * WARM_DAYTIME_FACTORS.r
        g = g * WARM_DAYTIME_FACTORS.g
        b = b * WARM_DAYTIME_FACTORS.b
    end
    return r, g, b
end

local function init()
    screenSource = dxCreateScreenSource(screenW, screenH)
    shaderColorFilterPS = dxCreateShader("shader/colorFilterPS.fx")
    shaderPs2ColorBlend = dxCreateShader("shader/ps2ColorBlend.fx")
    renderTarget = dxCreateRenderTarget(screenW, screenH)
    addEventHandler("onClientHUDRender", root, renderColorFilter, false, "low")
end

function renderColorFilter()
    if not screenSource then return end
    dxUpdateScreenSource(screenSource, true)
    local rgba1 = TIMECYC:getTimeCycleValue("postfx1")
    local rgba2 = TIMECYC:getTimeCycleValue("postfx2")
    if not rgba1 or not rgba2 then return end

    local r1, g1, b1, a1 = rgba1[1]*2, rgba1[2]*2, rgba1[3]*2, rgba1[4]*2
    local r2, g2, b2, a2 = rgba2[1]*2, rgba2[2]*2, rgba2[3]*2, rgba2[4]*2

    r1, g1, b1, a1 = math.min(r1,255), math.min(g1,255), math.min(b1,255), math.min(a1,255)
    r2, g2, b2, a2 = math.min(r2,255), math.min(g2,255), math.min(b2,255), math.min(a2,255)

    r1, g1, b1 = applyWarmTint(r1, g1, b1)
    r2, g2, b2 = applyWarmTint(r2, g2, b2)

    r1, g1, b1, a1 = r1*PS_MODULATE_SCALE, g1*PS_MODULATE_SCALE, b1*PS_MODULATE_SCALE, a1*PS_MODULATE_SCALE
    r2, g2, b2, a2 = r2*PS_MODULATE_SCALE, g2*PS_MODULATE_SCALE, b2*PS_MODULATE_SCALE, a2*PS_MODULATE_SCALE

    dxSetRenderTarget(renderTarget, true)
    dxSetShaderValue(shaderColorFilterPS, "tex", screenSource)
    dxSetShaderValue(shaderColorFilterPS, "rgb1", {r1/255, g1/255, b1/255, a1/255})
    dxSetShaderValue(shaderColorFilterPS, "rgb2", {r2/255, g2/255, b2/255, a2/255})
    dxDrawImage(0, 0, screenW, screenH, shaderColorFilterPS)

    dxSetShaderValue(shaderPs2ColorBlend, "src", renderTarget)
    dxSetShaderValue(shaderPs2ColorBlend, "dst", screenSource)
    dxSetShaderValue(shaderPs2ColorBlend, "srcAlpha", a1 / 255)
    dxSetRenderTarget()
    dxDrawImage(0, 0, screenW, screenH, shaderPs2ColorBlend)
end

addEventHandler("onClientResourceStart", resourceRoot, init)
