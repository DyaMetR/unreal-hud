--[[------------------------------------------------------------------
  WELCOME MESSAGE
  Displays a message whenever the player enters a server to show its
  name, current map and gamemode running
]]--------------------------------------------------------------------

if CLIENT then

  -- Variables
  local alpha = 1;
  local tick = 0;

  --[[------------------------------------------------------------------
    Draws the welcome message
    @param {number} x
    @param {number} y
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawWelcomeMessage(x, y, scale)
    if (not U1HUD:IsWelcomeMessageEnabled()) then return end
    if (alpha <= 0) then return end
    if (tick < CurTime()) then
      alpha = math.max(alpha - 0.007, 0);
      tick = CurTime() + 0.02;
    end
    if (not game.SinglePlayer()) then
      U1HUD:DrawText(x, y, GetHostName(), TEXT_ALIGN_CENTER, true, scale, Color(25, 140, 255, 255 * alpha));
    end
    U1HUD:DrawText(x, y + 9 * scale, "Game Type: " .. gmod.GetGamemode().Name, TEXT_ALIGN_CENTER, true, scale, Color(255, 255, 255, 255 * alpha));
    U1HUD:DrawText(x, y + 18 * scale, "Map Title: " .. game.GetMap(), TEXT_ALIGN_CENTER, true, scale, Color(255, 255, 255, 255 * alpha));
    if (gmod.GetGamemode().Author) then
      U1HUD:DrawText(x, y + 28 * scale, "Author: " .. gmod.GetGamemode().Author, TEXT_ALIGN_CENTER, true, scale, Color(255, 255, 255, 255 * alpha));
    end
  end

end
