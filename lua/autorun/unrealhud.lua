--[[------------
     Unreal
Heads Up Display
 Version 2.0.1
    29/10/19
By DyaMetR
]]--------------


-- Main framework table
U1HUD = {};

-- Version and patch notes
U1HUD.Version = "2.0.1";


--[[
  Correctly includes a file
  @param {string} file
  @void
]]--
function U1HUD:IncludeFile(file)
  if SERVER then
    include(file);
    AddCSLuaFile(file);
  end
  if CLIENT then
    include(file);
  end
end

-- Includes
U1HUD:IncludeFile("unrealhud/core.lua");