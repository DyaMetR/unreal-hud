--[[------------------------------------------------------------------
  CORE
  Include all required files and run main hooks
]]--------------------------------------------------------------------

-- Include files
U1HUD:IncludeFile("core/config.lua");
U1HUD:IncludeFile("core/layout.lua");

U1HUD:IncludeFile("util/numbers.lua");
U1HUD:IncludeFile("util/text.lua");

U1HUD:IncludeFile("elements/health.lua");
U1HUD:IncludeFile("elements/armour.lua");
U1HUD:IncludeFile("elements/ammunition.lua");
U1HUD:IncludeFile("elements/items.lua");
U1HUD:IncludeFile("elements/frags.lua");
U1HUD:IncludeFile("elements/damage.lua");
U1HUD:IncludeFile("elements/underwater.lua");
U1HUD:IncludeFile("elements/pickup.lua");
U1HUD:IncludeFile("elements/welcome.lua");
U1HUD:IncludeFile("elements/killfeed.lua");
U1HUD:IncludeFile("elements/target.lua");

U1HUD:IncludeFile("modules/vanilla.lua");
U1HUD:IncludeFile("modules/auxpow.lua");

U1HUD:IncludeFile("data/ammo.lua");
U1HUD:IncludeFile("data/items.lua");
U1HUD:IncludeFile("data/quotes.lua");

-- Load add-ons
local files, directories = file.Find("autorun/unrealhud/add-ons/*.lua", "LUA");
for _, file in pairs(files) do
  U1HUD:IncludeFile("add-ons/"..file);
end

if CLIENT then

  -- Common constants
  U1HUD.WHITE = Color(255, 255, 255); -- White colour
  U1HUD.GRAY = Color(135, 135, 135); -- Grey colour
  U1HUD.RED = Color(255, 0, 0); -- Red item highlight colour
  U1HUD.GREEN = Color(0, 255, 0); -- Green colour
  U1HUD.CONTAINER = Material("unrealhud/container.png"); -- Container texture

  -- Compose and draw HUD
  hook.Add("HUDPaint", "u1hud_draw", function()
    if (not U1HUD:IsEnabled()) then return end
    -- Enable filtering
    if (U1HUD:IsTextureFilteringEnabled()) then
      render.PushFilterMag( TEXFILTER.ANISOTROPIC );
      render.PushFilterMin( TEXFILTER.ANISOTROPIC );
    end
    U1HUD:DrawHUD(U1HUD:GetMode(), U1HUD:GetScale());
    if (U1HUD:IsTextureFilteringEnabled()) then
      render.PopFilterMag();
      render.PopFilterMin();
    end
  end);

  -- Hide default HUD
  local hide = {
    CHudHealth = true,
    CHudBattery = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudDamageIndicator = true
  };

  hook.Add("HUDShouldDraw", "u1hud_hide", function(name)
    if (not U1HUD:IsEnabled()) then return end
    hide.CHudHealth = U1HUD:IsHealthEnabled();
    hide.CHudBattery = U1HUD:IsHealthEnabled();
    hide.CHudAmmo = U1HUD:IsAmmoEnabled();
    hide.CHudSecondaryAmmo = U1HUD:IsAmmoEnabled();
    hide.CHudDamageIndicator = U1HUD:IsDamageEnabled();
    if (not hide[name]) then return end
    return false;
  end);

end
