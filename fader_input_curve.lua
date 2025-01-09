--[[

Change below value to change overall initial dampening. The bigger the value,
the greater the initial high precision around the touch starting point.

]]--
local sensitivity = 1.5

-- no changes needed after this point :) 

local lastValue = {
  x = nil,
  y = nil,
}
local zero_x
local zero_y
local horz_x = nil
local scale = 0

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

function onValueChanged(k)
  local pointer = self.pointers[1]
  if pointer == nil then return end
  if horz_x == nil then getOrientation() end
  -- let's go
  if k == 'touch' and self.values.touch then
    -- init touch start point on touch press
    zero_x = pointer.x
    zero_y = pointer.y
    scale = 0
  elseif k == 'x' or k == 'y' then
    -- process current pointer position
    if lastValue[k] == nil then
      lastValue[k] = self.values[k]
      return
    end
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
    scale = math.max(0, scale, math.min(1, math.abs(rel/max)))
    local delta = (self.values[k] - lastValue[k]) * scale
    lastValue[k] = lastValue[k] + delta
    -- print('Scale: ' .. string.format("%.6f", scale))
    self.values[k] = lastValue[k]
  end
end
