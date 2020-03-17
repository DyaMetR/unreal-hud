--[[------------------------------------------------------------------
  CONFIGURATION
  Handle HUD settings and its menu
]]--------------------------------------------------------------------

if CLIENT then

  local DEFAULT_PARAMETERS = {
    ["u1hud_enabled"] = 1,
    ["u1hud_scale"] = 1,
    ["u1hud_mode"] = 0,
    ["u1hud_health"] = 1,
    ["u1hud_ammo"] = 1,
    ["u1hud_ammo_mode"] = 0,
    ["u1hud_items"] = 1,
    ["u1hud_damage"] = 1,
    ["u1hud_pickup"] = 1,
    ["u1hud_killfeed"] = 1,
    ["u1hud_killfeed_npc"] = 0,
    ["u1hud_welcome"] = 1,
    ["u1hud_target"] = 1,
    ["u1hud_underwater"] = 1,
    ["u1hud_filter"] = 0,
    ["u1hud_frags"] = 1
  }; -- default convar parameters

  for convar, value in pairs(DEFAULT_PARAMETERS) do
    CreateClientConVar(convar, value, true);
  end -- initialize convars

  -- Console command to reset everything back to default
  concommand.Add("u1hud_reset", function(ply, com, args)
    for convar, value in pairs(DEFAULT_PARAMETERS) do
      RunConsoleCommand(convar, value);
    end
  end);

  --[[------------------------------------------------------------------
    Whether the HUD is enabled
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsEnabled()
    return GetConVar("u1hud_enabled"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the current HUD scale
    @return {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD:GetScale()
    return GetConVar("u1hud_scale"):GetFloat();
  end

  --[[------------------------------------------------------------------
    Gets the current HUD composition
    @return {number} composition
  ]]--------------------------------------------------------------------
  function U1HUD:GetMode()
    return math.Clamp(GetConVar("u1hud_mode"):GetInt(), 0, 5);
  end

  --[[------------------------------------------------------------------
    Whether the health panel is enabled
    @return {boolean} is health panel enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsHealthEnabled()
    return GetConVar("u1hud_health"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the ammunition panel is enabled
    @return {boolean} is ammo panel enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsAmmoEnabled()
    return GetConVar("u1hud_ammo"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Returns the ammunition display mode
    @return {number} ammunition display mode
  ]]--------------------------------------------------------------------
  function U1HUD:GetAmmoMode()
    return GetConVar("u1hud_ammo_mode"):GetInt();
  end

  --[[------------------------------------------------------------------
    Whether the item tray is enabled
    @return {boolean} is item tray enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsItemTrayEnabled()
    return GetConVar("u1hud_items"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the damage effect is enabled
    @return {boolean} is damage effect enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsDamageEnabled()
    return GetConVar("u1hud_damage"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the pickup history is enabled
    @return {boolean} is pickup history enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsPickupHistoryEnabled()
    return GetConVar("u1hud_pickup"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the welcome message is enabled
    @return {boolean} is welcome message enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsWelcomeMessageEnabled()
    return GetConVar("u1hud_welcome"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the player name is enabled
    @return {boolean} is player name enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsPlayerNameEnabled()
    return GetConVar("u1hud_target"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the under water overlay is enabled
    @return {boolean} is the under water overlay enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsUnderWaterOverlayEnabled()
    return GetConVar("u1hud_underwater"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the texture filtering is enabled
    @return {boolean} is texture filtering enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsTextureFilteringEnabled()
    return GetConVar("u1hud_filter"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the frags counter is enabled
    @return {boolean} is frag counter enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsFragsCounterEnabled()
    return GetConVar("u1hud_frags"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the kill feed feature is enabled
    @return {boolean} is kill feed enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsKillFeedEnabled()
    return GetConVar("u1hud_killfeed"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the kill feed should report NPC deaths
    @return {boolean} is kill feed for NPCs enabled
  ]]--------------------------------------------------------------------
  function U1HUD:IsKillFeedForNPCsEnabled()
    return GetConVar("u1hud_killfeed_npc"):GetInt() >= 1;
  end

  -- Setup menu
  hook.Add( "PopulateToolMenu", "u1hud_menu", function()
    spawnmenu.AddToolMenuOption( "Options", "DyaMetR", "u1hud", "Unreal HUD", nil, nil, function(panel)
      panel:ClearControls();

      panel:AddControl( "CheckBox", {
    		Label = "Enabled",
        Command = "u1hud_enabled"
    		}
    	);

      panel:AddControl( "Slider", {
        Label = "Scale",
        Type = "Float",
        Min = "0",
        Max = "10",
        Command = "u1hud_scale"}
      );

      panel:AddControl( "Slider", {
        Label = "Layout",
        Type = "Integer",
        Min = "0",
        Max = "5",
        Command = "u1hud_mode"}
      );

      panel:AddControl( "CheckBox", {
    		Label = "Health panel enabled",
        Command = "u1hud_health"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Ammunition panel enabled",
        Command = "u1hud_ammo"
    		}
    	);

      panel:AddControl( "Slider", {
        Label = "Ammo display mode",
        Type = "Integer",
        Min = "0",
        Max = "4",
        Command = "u1hud_ammo_mode"}
      );

      panel:AddControl( "CheckBox", {
    		Label = "Damage overlay enabled",
        Command = "u1hud_damage"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Pickup history enabled",
        Command = "u1hud_pickup"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Killfeed enabled",
        Command = "u1hud_killfeed"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Show kill feed for NPC deaths",
        Command = "u1hud_killfeed_npc"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Item tray enabled",
        Command = "u1hud_items"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Frag counter enabled",
        Command = "u1hud_frags"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Player names enabled",
        Command = "u1hud_target"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Welcome message enabled",
        Command = "u1hud_welcome"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Under water overlay enabled",
        Command = "u1hud_underwater"
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Texture filtering enabled",
        Command = "u1hud_filter"
    		}
    	);

      panel:AddControl( "Button", {
    		Label = "Reset to default",
        Command = "u1hud_reset"
    		}
    	);

      -- Credits
      panel:AddControl( "Label" , { Text = ""} );
      panel:AddControl( "Label",  { Text = "Version " .. U1HUD.Version});
      panel:AddControl( "Label",  { Text = "Made by DyaMetR"});
      panel:AddControl( "Label",  { Text = "Concept and resources by Digital Extremes"});
      panel:AddControl( "Label",  { Text = "UT icons by Raffine52"});
    end );
  end);

end
