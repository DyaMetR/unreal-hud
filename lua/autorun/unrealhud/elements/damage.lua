--[[------------------------------------------------------------------
  DAMAGE
  Tints the screen red after taking damage
]]--------------------------------------------------------------------

if CLIENT then

  -- Variables
  local tick = 0;
  local damage = 0;
  local lastHP = 100;
  local alpha = 0;
  local blink = false;

  -- Internal function; animates the flashing screen
  local function Animate()
    local hp = LocalPlayer():Health();
    if (hp ~= lastHP) then
      blink = false;
      if (hp < lastHP and damage < lastHP - hp and hp > 0) then
        damage = 10 + (lastHP - hp);
      end
      lastHP = hp;
    end
    if (damage > 0) then
      if (tick < CurTime()) then
        if (not blink) then
          if (alpha < 1) then
            alpha = alpha + 0.08;
          else
            blink = true
          end
        else
          if (alpha > 0) then
            alpha = math.max(alpha - 0.01, 0);
          else
            damage = 0;
            blink = false;
          end
        end
        tick = CurTime() + 0.001;
      end
    end
  end

  --[[------------------------------------------------------------------
    Draws the damage overlay
    @void
  ]]--------------------------------------------------------------------
  function U1HUD:DrawDamage()
    if (not U1HUD:IsDamageEnabled() or not LocalPlayer():Alive()) then alpha = 0; damage = 0; return end
    Animate();
    local colour = Color(255, 50 * math.Clamp((damage - 33)/33, 0, 1), 50 * math.Clamp((damage - 33)/33, 0, 1), 255 * alpha * damage * 0.01);
    if (LocalPlayer():Armor() > 0) then
      colour = Color(255, 255, 255, 255 * alpha * damage * 0.005);
    end
    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), colour);
  end

end
