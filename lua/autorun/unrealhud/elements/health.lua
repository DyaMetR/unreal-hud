--[[------------------------------------------------------------------
  HEALTH
  Displays current player's health with no negative numbers; support
  for different modes
]]--------------------------------------------------------------------

if CLIENT then

  local HEALTH_TEXTURE = Material("unrealhud/health.png");

  --[[------------------------------------------------------------------
    Draws health
    @param {number} x
    @param {number} y
    @param {number} health
    @param {number|nil} mode
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawHealth(x, y, health, mode, scale)
    if (not U1HUD:IsHealthEnabled()) then return end
    mode = mode or 0;
    if (mode >= 5) then return end
    scale = scale or 1;
    y = y - math.floor(32 * scale);
    health = math.max(health, 0);
    surface.SetMaterial(HEALTH_TEXTURE);
    surface.SetDrawColor(U1HUD.WHITE);
    surface.DrawTexturedRect(x, y, math.ceil(32 * scale), math.ceil(32 * scale));

    local showBar = mode <= 0 or mode == 3; -- should display bar only

    -- Numbers
    if (mode <= 0) then
      U1HUD:DrawNumber(x + (32 * scale), y + (2 * scale), health, nil, health < 25, scale);
    elseif (not showBar) then
      U1HUD:DrawSmallNumber(x + math.ceil(24 * scale), y + math.floor(24) * scale, health, U1HUD.GRAY, scale);
    end

    -- Bar
    if (showBar) then
      U1HUD:DrawBar(x, y, health/LocalPlayer():GetMaxHealth(), scale);
    end
  end

end
