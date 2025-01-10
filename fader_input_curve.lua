--[[

Small script to:
 - ensure high-precision input on initial touch
 - Set control to zero on double-tap

]]--

local sensitivity = 1.5 -- Edit this to change initial sensitivity.
local enableDoubleTap = true -- enable double-tap behaviour
local tapDelay = 300 -- Delay for registering a double-tap

-- no changes needed after this point :) 

local lastValue
local zero_x
local zero_y
local horz_x = nil
local scale = 0
local lastTap = 0

function getOrientation()
  --[[
  This ensures that for:
    - vertical faders, and
    - 90 degrees rotated XY controls (EAST, WEST)
  we use the screen Y axis! to measure start point distance
  ]]--
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

function resetValue()
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

function onValueChanged(k)
  local pointer = self.pointers[1]
  if pointer == nil then return end
  if horz_x == nil then getOrientation() end
  -- let's go
  if k == 'touch' and not self.values.touch then
    if enableDoubleTap then
      -- Check for and set to zero on double tap
      local now = getMillis()
      if(now - lastTap < tapDelay) then
        resetValue()
        lastTap = 0
      else
        lastTap = now
      end
    end
  elseif k == 'touch' and self.values.touch then
    -- init touch start point on touch press
    zero_x = pointer.x
    zero_y = pointer.y
    scale = 0.0
  elseif k == 'x' or k == 'y' and self.values.touch then
    -- process current pointer position
    lastValue = self:getValueField(k, ValueField.LAST)
    local rel, max
    if (
      (k == 'x' and not horz_x) or
      (k == 'y' and horz_x)
    ) then
      max = self.frame.h * sensitivity
      rel = pointer.y - zero_y
    else
      max = self.frame.w * sensitivity
      rel = pointer.x - zero_x
    end
    if math.abs(rel) <= 0 then
      -- If not moved, yet, use value delta to calculate scale
      -- For absolute faders, this ensures movement start on touch begin
      rel = rel + (max * (scale + 0.02) / sensitivity)
    end
    scale = math.max(0, scale, math.min(1, math.abs(rel/max)))
    local delta = (self.values[k] - lastValue) * scale
    lastValue = lastValue + delta
    -- print('Scale: ' .. string.format("%.6f", scale))
    self.values[k] = lastValue
  end
end
