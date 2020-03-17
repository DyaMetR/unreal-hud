--[[------------------------------------------------------------------
  LAYOUT
  Display HUD elements in different positions based on configuration
]]--------------------------------------------------------------------

if CLIENT then

  -- Internal function; returns the health element position
  local function HealthPos(mode, scale)
    if (mode >= 4) then
      return ScrW() - math.floor(64 * scale), ScrH();
    elseif (mode >= 2 and mode < 4) then
      return ScrW() - math.floor(128 * scale), ScrH();
    end
    return 0, ScrH();
  end

  -- Internal function; returns the armour element position
  local function ArmourPos(mode, scale)
    if (mode >= 4) then
      return ScrW() - math.floor(64 * scale), ScrH() - math.floor(64 * scale);
    elseif (mode >= 2) then
      return 0, ScrH()  - math.floor(32 * scale);
    end
    return 0, 0;
  end

  -- Internal function; returns the items origin position
  local function ItemsPos(mode, scale)
    if (mode >= 4) then
      return ScrW(), ScrH() - math.floor(64 * scale);
    elseif (mode == 3) then
      return ScrW(), ScrH() - math.floor(64 * scale);
    elseif (mode == 2) then
      return ScrW() * 0.5, ScrH() - math.floor(32 * scale);
    end
    return ScrW(), 0;
  end

  -- Internal function; returns the frags counter position
  local function FragsPos(mode, scale)
    if (mode <= 2) then
      return ScrW() - math.floor(32 * scale), ScrH() - math.floor(32 * scale);
    elseif (mode == 3) then
      if (LocalPlayer():Armor() > 0) then
        return 0, ScrH() - math.floor(32 * scale);
      else
        return 0, ScrH();
      end
    else
      return 0, ScrH();
    end
  end

  --[[------------------------------------------------------------------
    Draws the HUD
    @param {number} mode
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawHUD(mode, scale)
    U1HUD:DrawDamage();
    U1HUD:DrawUnderWater();
    local x, y = HealthPos(mode, scale);
    U1HUD:DrawHealth(x, y, LocalPlayer():Health(), mode, scale);
    if (LocalPlayer():Armor() > 0) then
      x, y = ArmourPos(mode, scale);
      U1HUD:DrawArmour(x, y, LocalPlayer():Armor(), mode, scale);
    end
    U1HUD:DrawAmmunition(ScrW(), ScrH(), mode, scale);
    x, y = ItemsPos(mode, scale);
    local align = nil;
    if (mode == 2) then align = TEXT_ALIGN_CENTER; end
    U1HUD.ITEMS:DrawItems(x, y, mode, align, scale);
    if (not game.SinglePlayer()) then
      x, y = FragsPos(mode, scale);
      U1HUD:DrawFrags(x, y, LocalPlayer():Frags(), mode, scale);
    end -- display only in multiplayer
    U1HUD:DrawPickupHistory(ScrW() * 0.5, ScrH()  - 38 - (8 * scale), scale);
    U1HUD:DrawWelcomeMessage(ScrW() * 0.5, 40, scale);
    U1HUD:DrawKillFeed(4, 3, scale);
    U1HUD:DrawTargetName(ScrW() * 0.5, ScrH() - 45 - (17 * scale), scale);
  end

end
