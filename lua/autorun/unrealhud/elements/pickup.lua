--[[------------------------------------------------------------------
  PICKUP HISTORY
  Displays a message whenever you pick up an item
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local ITEMS = {};
  local DEFAULT_PREFIX = "You got the ";
  local AMMO_PREFIX = "You got ";

  -- Variables
  local alpha = 0;
  local tick = 0;
  local message = ""; -- current message to display

  --[[------------------------------------------------------------------
    Adds an item string
    @param {string} item class
    @param {string} string
  ]]--------------------------------------------------------------------
  function U1HUD:AddItemString(item, string)
    ITEMS[item] = string;
  end

  --[[------------------------------------------------------------------
    Returns the string to display when picking up a certain item
    @param {string} item
    @return {string} string
  ]]--------------------------------------------------------------------
  function U1HUD:GetItemString(item)
    if (ITEMS[item]) then
      return ITEMS[item];
    else
      return DEFAULT_PREFIX .. language.GetPhrase(item) .. ".";
    end
  end

  --[[------------------------------------------------------------------
    Sets the message to display and triggers the display sequence
    @param {string} message
  ]]--------------------------------------------------------------------
  function U1HUD:SetPickupMessage(string)
    message = string;
    alpha = 1;
  end

  --[[------------------------------------------------------------------
    Draws the pickup history
    @param {number} x
    @param {number} y
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawPickupHistory(x, y, scale)
    if (not U1HUD:IsPickupHistoryEnabled()) then return end
    scale = scale or 1;
    if (alpha <= 0) then return end
    if (tick < CurTime()) then
      alpha = math.max(alpha - 0.005, 0);
      tick = CurTime() + 0.02;
    end -- animate
    U1HUD:DrawText(x, y, message, TEXT_ALIGN_CENTER, true, scale, Color(255, 255, 255, 255 * alpha));
  end

  -- Override hooks and get items
  hook.Add("HUDDrawPickupHistory", "u1hud_pickup", function()
    if (not U1HUD:IsEnabled() or not U1HUD:IsPickupHistoryEnabled()) then return; end
    return true;
  end);

  hook.Add("HUDAmmoPickedUp", "u1hud_ammo_pickup", function(ammoType, amount)
    if (amount <= 1) then amount = "a"; end
    U1HUD:SetPickupMessage(AMMO_PREFIX .. amount .. " " .. language.GetPhrase(ammoType .. "_ammo") .. ".");
  end);

  hook.Add("HUDItemPickedUp", "u1hud_item_pickup", function(item)
    U1HUD:SetPickupMessage(U1HUD:GetItemString(item));
  end);

  hook.Add("HUDWeaponPickedUp", "u1hud_weapon_pickup", function(weapon)
    local name = weapon:GetClass()
    if weapon.GetPrintName then name = weapon:GetPrintName() end
    U1HUD:SetPickupMessage(DEFAULT_PREFIX .. language.GetPhrase(name) .. ".");
  end);

end
