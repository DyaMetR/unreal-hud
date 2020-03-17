--[[------------------------------------------------------------------
  KILL FEED
  Displays messages based on player deaths
]]--------------------------------------------------------------------

-- Death type enum
local DEATH_SUICIDE = 0;
local DEATH_PLAYER = 1;
local DEATH_NPC = 2;
DMG_HEADSHOT = -10;
local NET = "u1hud_killfeed";
local NET_INIT = "u1hud_initspawn";

if CLIENT then

  -- Parameters
  local BY_NPC = "%s %s by a %s";
  local BY_PLAYER = "%s %s by %s";
  local SUICIDE = "%s %s";
  local CRIT = " throughly";
  local CRIT_AMOUNT = 40;
  local GENERIC = "was killed";
  local QUOTES = {};
  local WEAPON_QUOTES = {};
  local TIME = 6;
  local RED = Color(255, 0, 0);
  local WHITE = Color(200, 200, 200);

  -- Variables
  local KILLFEED = {};

  --[[------------------------------------------------------------------
    Adds a quote the kill feed can use
    @param {number|string} DMG_ enum or weapon class
    @param {string} action descriptor
  ]]--------------------------------------------------------------------
  function U1HUD:AddKillQuote(damageType, quote)
    if (type(damageType) == "string") then
      if (not WEAPON_QUOTES[damageType]) then WEAPON_QUOTES[damageType] = {}; end
      table.insert(WEAPON_QUOTES[damageType], quote);
    else
      if (not QUOTES[damageType]) then QUOTES[damageType] = {}; end
      table.insert(QUOTES[damageType], quote);
    end
  end

  --[[------------------------------------------------------------------
    Returns a random quote from the given death type or the generic one
    @param {number|string} DMG_ enum or weapon class
    @param {boolean|nil} was the hit critical
    @param {boolean|nil} is the killer an npc
    @return {string} action descriptor
  ]]--------------------------------------------------------------------
  function U1HUD:GetQuote(damageType, crit, isNPC)
    local critWord = "";
    if (crit) then critWord = CRIT; end
    local rand = math.random(1, 5);
    if (not QUOTES[damageType] and QUOTES[DMG_GENERIC] and not isNPC) then damageType = DMG_GENERIC; end
    if (rand == 1 or not QUOTES[damageType]) then return GENERIC; end
    return string.format(QUOTES[damageType][math.random(1, table.Count(QUOTES[damageType]))], critWord);
  end

  --[[------------------------------------------------------------------
    Whether a weapon has quotes attached to it
    @param {string} weapon class
    @param {boolean} has quotes
  ]]--------------------------------------------------------------------
  function U1HUD:WeaponHasQuote(weaponClass)
    return WEAPON_QUOTES[weaponClass];
  end

  --[[------------------------------------------------------------------
    Generates a quote to describe a player's death
    @param {string} player's name
    @param {number} damage dealt
    @param {string} attacker's name
    @param {number} DEATH_ enum
    @param {number} DMG_ enum
    @return {string} full quote
  ]]--------------------------------------------------------------------
  function U1HUD:GenerateKillQuote(player, damage, attacker, deathBy, damageType)
    if (deathBy == DEATH_PLAYER) then
      if (type(damageType) == "string" and U1HUD:WeaponHasQuote(damageType)) then
        local crit = "";
        if (damage >= CRIT_AMOUNT and math.random(1,3) >= 1) then crit = CRIT; end
        return string.format(WEAPON_QUOTES[damageType][math.random(1, table.Count(WEAPON_QUOTES[damageType]))], player, crit, attacker);
      else
        return string.format(BY_PLAYER, player, U1HUD:GetQuote(damageType, damage >= CRIT_AMOUNT and math.random(1,3) >= 1), attacker);
      end
    elseif (deathBy == DEATH_NPC) then
      return string.format(BY_NPC, player, U1HUD:GetQuote(damageType, nil, true), attacker);
    end
    return string.format(SUICIDE, player, U1HUD:GetQuote(damageType, nil, true));
  end

  --[[------------------------------------------------------------------
    Adds a quote to the kill feed
    @param {string} player's name
    @param {number} damage dealt
    @param {string} attacker's name
    @param {number} DEATH_ enum
    @param {number} DMG_ enum
    @return {string} full quote
  ]]--------------------------------------------------------------------
  function U1HUD:AddKill(player, damage, attacker, deathBy, damageType)
    table.insert(KILLFEED, 1, {quote = U1HUD:GenerateKillQuote(player, damage, attacker, deathBy, damageType), time = CurTime() + TIME});
  end

  --[[------------------------------------------------------------------
    Adds a normal message to display
    @param {string} message
  ]]--------------------------------------------------------------------
  function U1HUD:AddLog(message)
    table.insert(KILLFEED, 1, {quote = message, time = CurTime() + TIME, normal = true});
  end

  --[[------------------------------------------------------------------
    Whether the kill feed has entries to display
    @return {boolean} is active
  ]]--------------------------------------------------------------------
  function U1HUD:IsKillFeedActive()
    return table.Count(KILLFEED) > 0;
  end

  --[[------------------------------------------------------------------
    Draws the kill feed
    @param {number} x
    @param {number} y
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawKillFeed(x, y, scale)
    if (not U1HUD:IsKillFeedEnabled()) then return end
    scale = scale or 1;
    for i, killfeed in pairs(KILLFEED) do
      if (killfeed.time < CurTime()) then
        table.remove(KILLFEED, i);
      end -- animate
      local colour = RED;
      if (killfeed.normal) then colour = WHITE; end
      U1HUD:DrawText(x, y + (8 * scale * (i - 1)), killfeed.quote .. ".", nil, true, scale, colour); -- draw
    end
  end

  -- Replace default
  hook.Add("DrawDeathNotice", "u1hud_deathnotice_override", function(x, y)
    if (not U1HUD:IsEnabled() or not U1HUD:IsKillFeedEnabled()) then return end
    return false;
  end);

  -- Receive message
  net.Receive(NET, function(len)
    local victim = net.ReadString();
    local damage = net.ReadFloat();
    local attacker = net.ReadString();
    local deathBy = net.ReadFloat();
    local dmgType = net.ReadFloat();
    local weapon = net.ReadString();
    local vName, aName = language.GetPhrase(victim), language.GetPhrase(attacker);
    if (U1HUD:WeaponHasQuote(weapon)) then dmgType = weapon; end
    U1HUD:AddKill(vName, damage, aName, deathBy, dmgType);
  end);

  -- Receive log
  net.Receive(NET_INIT, function(len)
    local name = net.ReadString();
    local enter = net.ReadBool();
    if (enter) then
      U1HUD:AddLog(name .. " has entered the game");
    else
      U1HUD:AddLog(name .. " has left the game");
    end
  end);

end

if SERVER then

  util.AddNetworkString(NET);
  util.AddNetworkString(NET_INIT);

  -- Resets the Unreal HUD stats
  hook.Add("PlayerSpawn", "u1hud_spawn", function(ply)
    ply.U1HUD_DAMAGE = nil;
    ply.U1HUD_HEADSHOT = nil;
    ply.U1HUD_DMGTYPE = nil;
  end);

  -- Detects critical hits and headshots
  hook.Add("ScalePlayerDamage", "u1hud_damage", function(ply, hitgroup, dmginfo)
    if (not dmginfo:GetAttacker():IsPlayer()) then return end
    ply.U1HUD_HEADSHOT = hitgroup == HITGROUP_HEAD;
  end);

  -- Detects damage type
  hook.Add("EntityTakeDamage", "u1hud_dmgtype", function(ent, dmginfo)
    ent.U1HUD_DMGTYPE = dmginfo:GetDamageType();
    if (not ent:IsPlayer() and not ent:IsNPC()) then return end
    ent.U1HUD_DAMAGE = dmginfo:GetDamage();
  end);

  -- Internal function; called when either an NPC or a player dies
  local function EntityDies(ent, infl, attacker)
    local deathBy = DEATH_SUICIDE;
    local dmgType = ent.U1HUD_DMGTYPE or DMG_GENERIC;
    local weapon = "";
    local vName, aName = "", "";
    if (ent:IsPlayer()) then
      vName = ent:GetName();
    elseif (ent:IsNPC()) then
      vName = ent:GetClass();
    end -- get victim name
    if (attacker:IsPlayer() and attacker ~= ent) then
      aName = attacker:GetName();
      deathBy = DEATH_PLAYER;
    elseif (attacker:IsNPC()) then
      aName = attacker:GetClass();
      deathBy = DEATH_NPC;
    end -- get death type
    if (ent.U1HUD_HEADSHOT) then
      dmgType = DMG_HEADSHOT;
    end -- get damage type
    if ((attacker:IsNPC() or attacker:IsPlayer()) and IsValid(attacker:GetActiveWeapon())) then
      weapon = attacker:GetActiveWeapon():GetClass();
    end
    -- Send message
    net.Start(NET);
    net.WriteString(vName);
    net.WriteFloat(ent.U1HUD_DAMAGE or 0);
    net.WriteString(aName);
    net.WriteFloat(deathBy);
    net.WriteFloat(dmgType);
    net.WriteString(weapon);
    net.Broadcast();
  end

  -- Detect player death
  hook.Add("PlayerDeath", "u1hud_death", function(ply, infl, attacker)
    EntityDies(ply, infl, attacker);
  end);

  -- Detects NPC critical hits and headshots
  hook.Add("ScaleNPCDamage", "u1hud_damage", function(npc, hitgroup, dmginfo)
    if (not dmginfo:GetAttacker():IsPlayer()) then return end
    npc.U1HUD_HEADSHOT = hitgroup == HITGROUP_HEAD;
  end);

  -- Detect NPC death
  hook.Add("OnNPCKilled", "u1hud_death", function(npc, infl, attacker)
    EntityDies(npc, infl, attacker);
  end);

  -- Displays a message when someone spawns for the first time
  hook.Add("PlayerInitialSpawn", "u1hud_firstspawn", function(ply)
    net.Start(NET_INIT);
    net.WriteString(ply:GetName());
    net.WriteBool(true);
    net.Broadcast();
  end);

  -- Displays a message when someone leaves the server
  hook.Add("PlayerDisconnected", "u1hud_disconnect", function(ply)
    net.Start(NET_INIT);
    net.WriteString(ply:GetName());
    net.WriteBool(false);
    net.Broadcast();
  end);

end
