local Collision = {
	height = 30,
	width = 30,
  layer = 0,
  mask = 0,
  event = nil
}

function Collision:init()
  self.event = {}
end

function Collision:on_collision(event, game , k)
  
end


Collision.Layer_None = 0
Collision.Layer_Map = 2 -- 1 << 1 -- 2
Collision.Layer_Unit = 4 -- 1 << 2 -- 4
Collision.Layer_Projectile = 8 -- 1 << 3 -- 8

Collision.Mask_None = 0
Collision.Mask_Map = Collision.Layer_Map
Collision.Mask_Map_Unit = 12 -- Collision.Layer_Map | Collision.Layer_Unit -- 12

local function bit(p)
  return 2 ^ (p - 1)  -- 1-based indexing
end

local function hasbit(x, p)
  return x % (p + p) >= p       
end

Collision.Layer_Mask_Collision = {}
for i = 0,16 do
  Collision.Layer_Mask_Collision[i] = {}
  for j = 0,16 do
    Collision.Layer_Mask_Collision[i][j] = hasbit(j,bit(i))
  end
end

function Collision.check_layer_and_mask(c1,c2)
  -- return c1.layer & c2.mask || c2.layer & c1.mask
  -- return hasbit(c1.mask, bit(c2.layer)) or hasbit(c2.mask, bit(c1.layer))
  return Collision.Layer_Mask_Collision[c1.layer][c2.mask]
    or Collision.Layer_Mask_Collision[c2.layer][c1.mask]
end

Collision.__index = Collision

return Collision