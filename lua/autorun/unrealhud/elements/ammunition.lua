--[[------------------------------------------------------------------
  AMMUNITION
  Displays current player's weapon ammunition and reserve ammunition;
  support for different modes
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local ICONS = {};
  local AMMO_TRAY_TEXTURE = Material("unrealhud/ammo_stack.png");
  local GENERIC_AMMO = {
    Material("unrealhud/og/asmd.png"),
    Material("unrealhud/og/bullets.png"),
    Material("unrealhud/og/dispersion.png"),
    Material("unrealhud/og/flak.png"),
    Material("unrealhud/og/gesbio.png"),
    Material("unrealhud/og/razor.png"),
    Material("unrealhud/og/rockets.png"),
    Material("unrealhud/og/shards.png"),
    Material("unrealhud/og/sniper.png"),
  };
  local RED = Color(170, 0, 0);

  -- Variables
  local lastAmmoType = -1;
  local i = 0;

  --[[------------------------------------------------------------------
    Adds an ammunition icon
    @param {string} ammunition type
    @param {string} material path
  ]]--------------------------------------------------------------------
  function U1HUD:AddAmmoIcon(ammoType, texture)
    ICONS[game.GetAmmoID(ammoType)] = Material(texture);
  end

  --[[------------------------------------------------------------------
    Gets the texture tied to the given ammunition type, or a random
    original one in case is not registered
    @param {string} ammunition type
    @param {boolean|nil} avoid generation
    @return {IMaterial} material
  ]]--------------------------------------------------------------------
  function U1HUD:GetAmmoIcon(ammoType, avoidGeneration)
    if (ICONS[ammoType] == nil) then
      if ((lastAmmoType == nil or lastAmmoType ~= ammoType) and not avoidGeneration) then
        lastAmmoType = ammoType;
        i = math.random(1, table.Count(GENERIC_AMMO) - 1);
      end
      return GENERIC_AMMO[i];
    end
    return ICONS[ammoType];
  end

  -- Internal function; returns what should go on primary ammo display
  local function GetClip1()
    local weapon = LocalPlayer():GetActiveWeapon();
    if (not IsValid(weapon)) then return -1, -1, -1 end
    local clip = weapon:Clip1();
    local primary = weapon:GetPrimaryAmmoType();
    local secondary = weapon:GetSecondaryAmmoType();
    local alt = LocalPlayer():GetAmmoCount(secondary);
    local reserve = LocalPlayer():GetAmmoCount(primary);
    if (primary <= 0 and secondary <= 0) then return -1; end
    if (primary <= 0) then
      return alt, secondary, game.GetAmmoMax(secondary);
    end
    if (weapon:Clip1() <= -1) then
      return reserve, primary, game.GetAmmoMax(primary);
    else
      return reserve + clip, primary, game.GetAmmoMax(primary) + weapon:GetMaxClip1();
    end
  end

  -- Internal function; draws an ammunition bar
  local function DrawAmmoBar(x, y, ammoType, pos, scale, weapon, max, slot)
    -- Draw slot
    local colour = U1HUD.GRAY;
    if (weapon and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == weapon) then
      colour = U1HUD.WHITE;
    end
    U1HUD:DrawSmallNumber(x + math.floor(6 * scale * (pos - 1)), y - (9 * scale), slot, colour, scale);

    -- Draw bar
    max = max or 0;
    local clip = 0;
    if (weapon and LocalPlayer():HasWeapon(weapon)) then clip = LocalPlayer():GetWeapon(weapon):Clip1(); end
    local ammunition = (LocalPlayer():GetAmmoCount(ammoType) + math.max(clip, 0));
    local value = math.Clamp(ammunition/(game.GetAmmoMax(ammoType) + max), 0, 1);
    local crit = math.min(value / 0.5, 1);
    draw.RoundedBox(0, x + (6 * scale * (pos - 1)), y + math.Round(math.ceil(15 * scale) * (1-value)), 4 * scale, math.Round(math.ceil(15 * scale) * value), Color(255 * (1 - crit), 255 * crit, 0, 66));

    -- Draw low ammo
    if (value > 0.5 or ammunition >= 10 or ammunition <= 0) then return end
    U1HUD:DrawSmallNumber(x + math.floor(6 * scale * (pos - 1)), y + (3 * scale), ammunition, RED, scale);
  end

  --[[------------------------------------------------------------------
    Draws current ammunition
    @param {number} x
    @param {number} y
    @param {number} ammunition type
    @param {number} ammunition amount
    @param {number|nil} mode
    @param {number|nil} ammunition mode
    @param {number|nil} scale
    @param {boolean|nil} ignore < 10 ammo warning
  ]]--------------------------------------------------------------------
  function U1HUD:DrawWeapon(x, y, clip1, ammoType, max, mode, aMode, scale, ignore)
    if (clip1 <= -1) then return end
    x = x - math.floor(32 * scale);
    y = y - math.floor(32 * scale);
    surface.SetDrawColor(U1HUD.WHITE);
    surface.SetMaterial(U1HUD.CONTAINER);
    surface.DrawTexturedRect(x, y, math.ceil(32 * scale), math.ceil(32 * scale));
    surface.SetMaterial(U1HUD:GetAmmoIcon(ammoType, ignore));
    surface.DrawTexturedRect(x, y, math.ceil(32 * scale), math.ceil(32 * scale));

    local showBar = mode <= 0 or mode == 3; -- should display bar only

    -- Additional clip display
    local clip = LocalPlayer():GetActiveWeapon():Clip1();
    local weapon = LocalPlayer():GetActiveWeapon();
    if (clip > -1 and weapon:GetPrimaryAmmoType() > 0 and not ignore and aMode > 0) then
      local num = 0;
      if (aMode == 1) then
        local offset = 0;
        if (clip >= 100) then offset = 4; end
        U1HUD:DrawText(x - (10 + offset) * scale, y - 10 * scale, "Clip: ", TEXT_ALIGN_RIGHT, true, scale, U1HUD.GREEN);
        U1HUD:DrawText(x, y - 10 * scale, tostring(clip), TEXT_ALIGN_RIGHT, true, scale, U1HUD.GREEN);
      elseif (aMode == 2) then
        num = clip;
      elseif (aMode == 3) then
        num = clip1 - clip;
        clip1 = clip;
        max = weapon:GetMaxClip1();
      elseif (aMode == 4) then
        num = clip;
        clip1 = clip1 - clip;
        max = max - weapon:GetMaxClip1();
      end
      if (aMode >= 2) then
        local offset = 0;
        if (showBar or mode <= 0) then offset = 6; end
        U1HUD:DrawSmallNumber(x + math.ceil(24 * scale), y + math.floor(16 + offset) * scale, num, U1HUD.GRAY, scale);
      end
    end

    -- Main number display
    if (mode <= 0) then
      U1HUD:DrawNumber(x, y + (2 * scale), clip1, TEXT_ALIGN_RIGHT, (clip1 < 10 and not ignore) or clip1 <= 0, scale);
    elseif (not showBar) then
      U1HUD:DrawSmallNumber(x + math.ceil(24 * scale), y + math.floor(24) * scale, clip1, U1HUD.GRAY, scale);
    end

    if (showBar) then
      U1HUD:DrawBar(x, y, clip1/max, scale);
    end
  end

  --[[------------------------------------------------------------------
    Draws the ammunition tray
    @param {number} x
    @param {number} y
    @param {number|nil} mode
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawAmmoTray(x, y, mode, scale)
    mode = mode or 0;
    if (mode >= 4) then return end
    scale = scale or 1;
    x = x - math.floor(64 * scale);
    y = y - math.floor(32 * scale);
    surface.SetDrawColor(U1HUD.WHITE);
    surface.SetMaterial(AMMO_TRAY_TEXTURE);
    surface.DrawTexturedRect(x, y, 64 * scale, 32 * scale);
    if (not LocalPlayer():Alive()) then return end
    local u, v = x + (3 * scale), y + (14 * scale);
    DrawAmmoBar(u, v, game.GetAmmoID("Pistol"), 1, scale, "weapon_pistol", 18, 1);
    DrawAmmoBar(u, v, game.GetAmmoID("357"), 2, scale, "weapon_357", 6, 2);
    DrawAmmoBar(u, v, game.GetAmmoID("SMG1"), 3, scale, "weapon_smg1", 45, 3);
    DrawAmmoBar(u, v, game.GetAmmoID("SMG1_Grenade"), 4, scale, nil, nil, 4);
    DrawAmmoBar(u, v, game.GetAmmoID("Ar2"), 5, scale, "weapon_ar2", 30, 5);
    DrawAmmoBar(u, v, game.GetAmmoID("AR2AltFire"), 6, scale, nil, nil, 6);
    DrawAmmoBar(u, v, game.GetAmmoID("Buckshot"), 7, scale, "weapon_shotgun", 6, 7);
    DrawAmmoBar(u, v, game.GetAmmoID("XBowBolt"), 8, scale, "weapon_crossbow", 1, 8);
    DrawAmmoBar(u, v, game.GetAmmoID("Grenade"), 9, scale, "weapon_frag", nil, 9);
    DrawAmmoBar(u, v, game.GetAmmoID("RPG_Round"), 10, scale, "weapon_rpg", nil, 0);
  end

  --[[------------------------------------------------------------------
    Draws the ammunition indicator set
    @param {number} x
    @param {number} y
    @param {number|nil} mode
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawAmmunition(x, y, mode, scale)
    if (not U1HUD:IsAmmoEnabled()) then return end
    mode = mode or 0;
    if (mode >= 5) then return end
    scale = scale or 1;

    -- Draw ammo tray
    U1HUD:DrawAmmoTray(x, y, mode, scale);

    -- Draw primary and secondary ammo
    local weapon = LocalPlayer():GetActiveWeapon();
    if (not IsValid(weapon)) then return end
    local offset = 64;
    if (mode >= 4) then offset = 0; end
    local clip1, primary, max = GetClip1();
    U1HUD:DrawWeapon(x - offset * scale, y, clip1, primary, max, mode, U1HUD:GetAmmoMode(), scale);
    local secondary = weapon:GetSecondaryAmmoType();
    if (secondary > 0 and weapon:GetPrimaryAmmoType() > 0) then
      local hOff, vOff = 0, 0;
      if (U1HUD:IsFragsCounterEnabled() and not game.SinglePlayer() and mode < 3) then
        hOff = 32;
      end -- move aside to display frag counter
      if (mode >= 3 and U1HUD:IsItemTrayEnabled()) then
        vOff = 32;
      end -- move above to display items
      local amount = LocalPlayer():GetAmmoCount(weapon:GetSecondaryAmmoType());
      U1HUD:DrawWeapon(x - hOff * scale, y - (32 + vOff) * scale, amount, secondary, game.GetAmmoMax(secondary), mode, 0, scale, lastAmmoType > -1);
    end
  end

end
