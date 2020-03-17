--[[------------------------------------------------------------------
  TARGET NAME
  Displays the name of the player you're looking at
]]--------------------------------------------------------------------

if CLIENT then

  local tick = 0;
  local alpha = 0;
  local lastName = "";

  --[[------------------------------------------------------------------
    Draws a name on the screen when looking at a player
    @param {number} x
    @param {number} y
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawTargetName(x, y, scale)
    if (not U1HUD:IsPlayerNameEnabled()) then return end
    local trace = LocalPlayer():GetEyeTrace();
    if (trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer()) then
      lastName = trace.Entity:GetName();
      alpha = 1;
    end -- update data
    if (alpha <= 0) then return end
    if (tick < CurTime()) then
      alpha = math.max(alpha - 0.01, 0);
      tick = CurTime() + 0.01;
    end
    local labelSize = U1HUD:GetTextSize("Name: ", scale);
    local nameSize = U1HUD:GetTextSize(lastName, scale);
    local size = labelSize + nameSize;
    U1HUD:DrawText(x - size * 0.5, y, "Name: ", nil, true, scale, Color(31, 163, 4, 255 * alpha));
    U1HUD:DrawText(x - (size * 0.5) + labelSize, y, lastName, nil, true, scale, Color(29, 255, 4, 255 * alpha));
  end

  -- Replace default
  hook.Add("HUDDrawTargetID", "u1hud_target", function()
    if (not U1HUD:IsEnabled() or not U1HUD:IsPlayerNameEnabled()) then return end
    return true;
  end);

end
