--[[------------------------------------------------------------------
  FRAGS
  Displays the amount of players killed
]]--------------------------------------------------------------------

if CLIENT then

  local FRAGS_TEXTURE = Material("unrealhud/frags.png");

  --[[------------------------------------------------------------------
    Draws the frag counter
    @param {number} x
    @param {number} y
    @param {number} frag amount
    @param {number} mode
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawFrags(x, y, frags, mode, scale)
    if (not U1HUD:IsFragsCounterEnabled() or mode >= 5) then return end
    scale = scale or 1;
    y = y - math.ceil(32 * scale);
    local w, h = math.ceil(32 * scale), math.ceil(32 * scale);
    surface.SetMaterial(FRAGS_TEXTURE);
    surface.SetDrawColor(U1HUD.WHITE);
    surface.DrawTexturedRect(x, y, w, h);
    U1HUD:DrawSmallNumber(x + w - math.ceil(6 * scale), y + h - math.ceil(6 * scale), frags, nil, scale);
  end

end
