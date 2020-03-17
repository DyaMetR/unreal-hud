--[[------------------------------------------------------------------
  DEFAULT DEATH QUOTES
  Adds custom strings for the kill feed
]]--------------------------------------------------------------------

if CLIENT then

  U1HUD:AddKillQuote(DMG_GENERIC, "was%s trounced");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s ripped");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s trounced");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s creamed");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s sliced");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s neutered");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s trashed");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s shredded");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s ripped a new one");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s given a new definition of pain");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s shafted");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s perforated");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s annihilated");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s ruled");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s splooged");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s shut out");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s smacked down");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s smeared");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s whipped");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s busted");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s messed up real bad");
  U1HUD:AddKillQuote(DMG_GENERIC, "was%s canned");

  U1HUD:AddKillQuote(DMG_BLAST, "was blown up");
  U1HUD:AddKillQuote(DMG_BURN, "was incinerated");
  U1HUD:AddKillQuote(DMG_FALL, "left a small crater");
  U1HUD:AddKillQuote(DMG_CRUSH, "was crushed");
  U1HUD:AddKillQuote(DMG_HEADSHOT, "was%s beheaded");
  U1HUD:AddKillQuote(DMG_HEADSHOT, "was%s decapitated");
  U1HUD:AddKillQuote(DMG_ACID, "was%s slimed");
  U1HUD:AddKillQuote(DMG_SLASH, "was hacked");
  U1HUD:AddKillQuote(DMG_DROWN, "drowned");

  U1HUD:AddKillQuote("weapon_ut99_flak", "%s was%s ripped to shreds by %s's flak cannon");

end
