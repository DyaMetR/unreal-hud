--[[------------------------------------------------------------------
  ARMOUR
  Displays current player's armour with no negative numbers; support
  for different modes
]]--------------------------------------------------------------------

if CLIENT then

  local BATTERY_TEXTURE = Material("unrealhud/hl2/battery.png");

  --[[------------------------------------------------------------------
    Draws suit energy
    @param {number} x
    @param {number} y
    @param {number} health
    @param {number|nil} mode
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawArmour(x, y, armour, mode, scale)
    if (not U1HUD:IsHealthEnabled()) then return end
    mode = mode or 0;
    if (mode >= 5) then return end
    scale = scale or 1;
    armour = math.max(armour, 0);
    surface.SetDrawColor(U1HUD.WHITE);
    surface.SetMaterial(U1HUD.CONTAINER);
    surface.DrawTexturedRect(x, y, math.ceil(32 * scale), math.ceil(32 * scale));
    surface.SetMaterial(BATTERY_TEXTURE);
    surface.DrawTexturedRect(x, y, math.ceil(32 * scale), math.ceil(32 * scale));

    local showBar = mode <= 0 or mode == 3; -- should display bar only

    -- Numbers
    if (mode <= 0) then
      U1HUD:DrawNumber(x + (32 * scale), y + (2 * scale), armour, nil, nil, scale);
    elseif (not showBar) then
      U1HUD:DrawSmallNumber(x + math.ceil(24 * scale), y + math.floor(24) * scale, armour, U1HUD.GRAY, scale);
    end

    -- Bar
    if (showBar) then
      U1HUD:DrawBar(x, y, armour/100, scale);
    end
  end

end
