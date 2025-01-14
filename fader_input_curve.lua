---@diagnostic disable: lowercase-global, undefined-global
-- ####################
-- Small script to:
--
-- - Ensure high-precision input on initial touch. With moving, input gradually
--   returns to normal sensitivity. (E.g. to absolute input for absolute controls,
--   or the relative factor for relative control faders etc.)
--
--  - Optionally set control to its default value upon double-tap.
--
-- - Display MIDI value or an approximated "real" value in a separate label or
--   text control. Specify the optional real range and the respective text
--   control below in the config.
--
-- ####################

-- #####
-- Config:
--
local sensitivity = 1.5 -- Initial sensitivity (from 0.2 coarse to 10 for super high precision)
local enableDoubleTap = false -- enable double-tap behaviour
local tapDelay = 300 -- Delay for registering a double-tap
local valueLabelControl = nil -- pass label or text control here, if desired
local realValue = {
  low = nil,
  high = nil,
  precision  = 1,
  min = nil,
  max = nil
}
-- #####
-- Example for real value specs:
--
-- Scale the control value in the range -100.5 to +85.
-- Use a precision of 100 (2 decimal places)
-- But, cut the final value at lower boundary -100 and upper +85
-- (The extra cut boundaries min and max allow to corret for a possibly
-- imprecise mapping of MIDI value to the actual range in the target
-- instrument.)
--
--   local realValue = {
--     low = -100.5,
--     high = 85,
--     precision  = 100,
--     min = -100,
--     max = 85
--   }
-- #####


-- #####
-- # No changes needed after this point :) 
-- #####

local zero_x
local zero_y
local horz_x = nil
local scale = 0
local lastTap = 0

-- #####
-- This ensures that for:
-- - vertical faders, and
-- - 90 degrees rotated XY controls (EAST, WEST)
--
-- we use the screen Y axis! to measure start point distance
-- #####
function _getOrientation()
  horz_x = true
  if (
    self.properties.orientation == Orientation.NORTH or
    self.properties.orientation == Orientation.SOUTH
  ) then
    -- vertical fader!
    if self.type == ControlType.FADER then horz_x = false end
  else
    -- 90 degrees rotated XY control!
    if self.type == ControlType.XY then horz_x = false end
  end
end

function _resetValuesToDefault()
  local k ={ 'x', 'y' }
  for i=1,2 do
    if self.values[k[i]] ~= nil then
      if self:getValueProperty(k[i], ValueProperty.LOCKED_DEFAULT_CURRENT) then
        self.values[k[i]] = self.properties.centered == true and 0.5 or 0
      else
        self.values[k[i]] = self:getValueField(k[i], ValueField.DEFAULT)
      end
    end
  end
end

function _showTrueValue(val)
  if valueLabelControl == nil then return end
  local s
  if realValue == nil then
    -- just show x or y with 4 decimals
    s = string.format('%.4f', val)
  else
    s = string.format('%.1f', _calcRealValue(val))
  end
  valueLabelControl.values.text = s
end

function _calcRealValue(val)
  local i = realValue.low
  local j = realValue.high
  -- do nothing if low or high is missing
  if i == nil or j == nil then return val end
  local p = realValue.precision
  if p == nil then p = 1 end
  local min = realValue.min
  local max = realValue.max
  if min == nil then min = i end
  if max == nil then max = j end
  local d = j-i
  return math.min(max, math.max(min, math.floor(val*d*p+0.5)/p+i))
end

function _checkForDoubleTap()
  if enableDoubleTap then
    local now = getMillis()
    if(now - lastTap < tapDelay) then
      _resetValuesToDefault()
      lastTap = 0
    else
      lastTap = now
    end
  end
end

function _setStartPoint()
  zero_x = self.pointers[1].x
  zero_y = self.pointers[1].y
  scale = 0.0
end

function _getScaleFactor()
  local rel, max
  if (k == 'x' and not horz_x) or (k == 'y' and horz_x) then
    max = self.frame.h * sensitivity
    rel = self.pointers[1].y - zero_y
  else
    max = self.frame.w * sensitivity
    rel = self.pointers[1].x - zero_x
  end
  if math.abs(rel) <= 0 then
    -- If not moved, yet, use value delta to calculate scale
    -- For absolute faders, this ensures movement start on touch begin
    rel = rel + (max * (scale + 0.02) / sensitivity)
  end
  return math.max(0, scale, math.min(1, math.abs(rel/max)))

end

function onValueChanged(k)
  -- Check for double-tap
  if k == 'touch' and not self.values.touch then _checkForDoubleTap() end
  -- Send true value to label control
  if k == 'x' or k == 'y' then _showTrueValue(self.values[k]) end
  -- break if we don't have a pointer (programmatic value update)
  if self.pointers[1] == nil then return end
  -- initialize orientation
  if horz_x == nil then _getOrientation() end
  -- start smoothing value
  if k == 'touch' and self.values.touch then
    _setStartPoint()
  elseif k == 'x' or k == 'y' and self.values.touch then
    -- process current pointer position
    local lastValue = self:getValueField(k, ValueField.LAST)
    local delta = (self.values[k] - lastValue) * _getScaleFactor()
    self.values[k] = lastValue + delta
  end
end