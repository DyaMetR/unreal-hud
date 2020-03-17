--[[------------------------------------------------------------------
  UNDER WATER
  Tints the screen when underwater
]]--------------------------------------------------------------------

if CLIENT then

  -- Variables
  local tick = 0;
  local alpha = 0;

  -- Internal function; animates the flashing screen
  local function Animate()
    if (tick < CurTime()) then
      if (LocalPlayer():WaterLevel() >= 3) then
        alpha = math.min(alpha + 0.05, 1);
      else
        alpha = math.max(alpha - 0.05, 0);
      end
      tick = CurTime() + 0.01;
    end
  end

  --[[------------------------------------------------------------------
    Draws the under water overlay
    @void
  ]]--------------------------------------------------------------------
  function U1HUD:DrawUnderWater()
    if (not U1HUD:IsUnderWaterOverlayEnabled()) then return end
    Animate();
    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(32, 49, 44, 150 * alpha));
  end

end
