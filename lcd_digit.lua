local l1 = self.children.l1.properties
local l2 = self.children.l2.properties
local l3 = self.children.l3.properties
local l4 = self.children.l4.properties
local l5 = self.children.l5.properties
local l6 = self.children.l6.properties
local l7 = self.children.l7.properties
local l8 = self.children.l8.properties
local l9 = self.children.l9.properties

local matrix = {
  d0 = {
    8, 8, 8,
    8, 0, 8,
    8, 0, 8,
    8, 0, 8,
    8, 8, 8,
  },
  d1 = {
    0, 0, 8,
    0, 0, 8,
    0, 0, 8,
    0, 0, 8,
    0, 0, 8,
  },
  d2 = {
    8, 8, 8,
    0, 0, 8,
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
  },
  d3 = {
    8, 8, 8,
    0, 0, 8,
    8, 8, 8,
    0, 0, 8,
    8, 8, 8,
  },
  d4 = {
    8, 0, 8,
    8, 0, 8,
    8, 8, 8,
    0, 0, 8,
    0, 0, 8,
  },
  d5 = {
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
    0, 0, 8,
    8, 8, 8,
  },
  d6 = {
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
  },
  d7 = {
    8, 8, 8,
    0, 0, 8,
    0, 0, 8,
    0, 0, 8,
    0, 0, 8,
  },
  d8 = {
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
  },
  d9 = {
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    0, 0, 8,
    8, 8, 8,
  },
  dA = {
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    8, 0, 8,
    8, 0, 8,
  },
  dE = {
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
  },
  dF = {
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
    8, 0, 0,
    8, 0, 0,
  },
  dG = {
    8, 8, 8,
    8, 0, 0,
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
  },
  dI= {
    0, 0, 0,
    0, 8, 0,
    0, 0, 0,
    0, 8, 0,
    0, 0, 0,
  },
  dK = {
    8, 0, 8,
    8, 0, 8,
    8, 8, 8,
    8, 8, 0,
    8, 0, 0,
  },
  dL = {
    8, 0, 0,
    8, 0, 0,
    8, 0, 0,
    8, 0, 0,
    8, 8, 8,
  },
  dM = {
    8, 8, 8,
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    8, 0, 8,
  },
  dN = {
    0, 0, 0,
    0, 0, 0,
    8, 8, 8,
    8, 0, 8,
    8, 0, 8,
  },
  dP = {
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    8, 0, 0,
    8, 0, 0,
  },
  dR = {
    8, 8, 8,
    8, 0, 8,
    8, 8, 8,
    8, 8, 0,
    8, 0, 0,
  },
  dT = {
    8, 8, 8,
    0, 8, 0,
    0, 0, 0,
    0, 8, 0,
    0, 0, 0,
  },
}

function applyMatrix(m)
  if m[2] == 8 then l1.visible = false else l1.visible = true end
  if m[4] == 8 then l4.visible = false else l4.visible = true end
  if m[5] == 8 then l8.visible = false else l8.visible = true end
  if m[6] == 8 then l5.visible = false else l5.visible = true end
  if m[8] == 8 then l2.visible = false else l2.visible = true end
  if m[10] == 8 then l6.visible = false else l6.visible = true end
  if m[11] == 8 then l9.visible = false else l9.visible = true end
  if m[12] == 8 then l7.visible = false else l7.visible = true end
  if m[14] == 8 then l3.visible = false else l3.visible = true end
end

function onReceiveNotify(c,v)
  if c == 'update' then
    self.parent.children.button.values.x = 0.7
    local s = 'd' .. v
    print('MATRIX: ' .. s)
    applyMatrix(matrix[s])
  end
end