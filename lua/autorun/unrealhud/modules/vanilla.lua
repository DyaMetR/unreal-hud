--[[------------------------------------------------------------------
  VANILLA FEATURES RELATED ITEMS
  Items highlight when vanilla feature related items are used
]]--------------------------------------------------------------------

if CLIENT then

  -- Add items
  U1HUD.ITEMS:RegisterItem("chat", Material("unrealhud/translator.png"), nil);
  U1HUD.ITEMS:RegisterItem("flashlight", Material("unrealhud/flashlight.png"), nil);

  -- Flashlight
  hook.Add("PlayerBindPress", "u1hud_items_vanilla", function(_, bind, _)
    if (bind == "impulse 100") then
      U1HUD.ITEMS:SetActive("flashlight");
    end
  end);

  -- Chat
  hook.Add("StartChat", "u1hud_items_chat_start", function()
    U1HUD.ITEMS:SetActive("chat", true);
  end);

  hook.Add("FinishChat", "u1hud_items_chat_end", function()
    U1HUD.ITEMS:SetItemActive("chat", false);
  end);

end
