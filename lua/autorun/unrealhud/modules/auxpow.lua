--[[------------------------------------------------------------------
  AUXILIARY POWER COMPATIBILITY
  Item indicating current aux. power charge
]]--------------------------------------------------------------------

if CLIENT then

  if (AUXPOW) then
    U1HUD.ITEMS:SetItemFunction("flashlight", function() return AUXPOW:GetFlashlight(); end);
    U1HUD.ITEMS:RegisterItem("auxpow", Material("unrealhud/amplifier.png"), function() return AUXPOW:GetPower(); end);

    local lastPow = 1;
    hook.Add("AuxPowerHUDPaint", "u1hud_auxpow", function()
      if (not U1HUD:IsEnabled() or not U1HUD:IsItemTrayEnabled()) then return; end
      if (lastPow ~= AUXPOW:GetPower()) then
        if (lastPow > AUXPOW:GetPower() and AUXPOW:GetPower() > 0) then
          if (not U1HUD.ITEMS:IsItemActive("auxpow")) then
            U1HUD.ITEMS:SetActive("auxpow", true);
          end
        else
          U1HUD.ITEMS:SetItemActive("auxpow", false);
        end
        lastPow = AUXPOW:GetPower();
      end
      return true;
    end);

    hook.Add("EP2FlashlightHUDPaint", "u1hud_auxpow_fl", function()
      if (U1HUD:IsEnabled() and U1HUD:IsItemTrayEnabled()) then return true; end
    end);
  end

end
