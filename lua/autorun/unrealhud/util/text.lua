--[[------------------------------------------------------------------
  TEXT
  Map characters from a texture and render text
]]--------------------------------------------------------------------

if CLIENT then

  local FILE_W, FILE_H = 256, 128;
  local CHARACTERS = {
    ["!"] = {x = 7, y = 1, w = 6, h = 10},
    ["\""] = {x = 14, y = 1, w = 7, h = 10},
    ["#"] = {x = 22, y = 1, w = 9, h = 10},
    ["$"] = {x = 31, y = 1, w = 9, h = 10},
    ["%"] = {x = 41, y = 1, w = 8, h = 10},
    ["&"] = {x = 49, y = 1, w = 9, h = 10},
    ["`"] = {x = 59, y = 1, w = 8, h = 10},
    ["'"] = {x = 59, y = 1, w = 8, h = 10},
    ["("] = {x = 67, y = 1, w = 6, h = 10},
    [")"] = {x = 75, y = 1, w = 6, h = 10},
    ["*"] = {x = 83, y = 1, w = 10, h = 10},
    ["+"] = {x = 93, y = 1, w = 8, h = 10},
    [","] = {x = 101, y = 1, w = 7, h = 10},
    ["-"] = {x = 109, y = 1, w = 8, h = 10},
    ["."] = {x = 119, y = 1, w = 6, h = 10},
    ["/"] = {x = 127, y = 1, w = 9, h = 10},
    ["0"] = {x = 137, y = 1, w = 8, h = 10},
    ["1"] = {x = 146, y = 1, w = 5, h = 10},
    ["2"] = {x = 152, y = 1, w = 8, h = 10},
    ["3"] = {x = 161, y = 1, w = 8, h = 10},
    ["4"] = {x = 170, y = 1, w = 8, h = 10},
    ["5"] = {x = 179, y = 1, w = 8, h = 10},
    ["6"] = {x = 188, y = 1, w = 8, h = 10},
    ["7"] = {x = 197, y = 1, w = 8, h = 10},
    ["8"] = {x = 206, y = 1, w = 8, h = 10},
    ["9"] = {x = 215, y = 1, w = 8, h = 10},
    [":"] = {x = 224, y = 1, w = 8, h = 10},
    [";"] = {x = 234, y = 1, w = 8, h = 10},
    ["<"] = {x = 241, y = 1, w = 8, h = 10},
    ["="] = {x = 1, y = 11, w = 8, h = 10},
    [">"] = {x = 11, y = 11, w = 7, h = 10},
    ["?"] = {x = 18, y = 11, w = 8, h = 10},
    ["@"] = {x = 27, y = 11, w = 9, h = 10},
    ["A"] = {x = 37, y = 11, w = 8, h = 10},
    ["B"] = {x = 46, y = 11, w = 8, h = 10},
    ["C"] = {x = 55, y = 11, w = 8, h = 10},
    ["D"] = {x = 64, y = 11, w = 8, h = 10},
    ["E"] = {x = 73, y = 11, w = 8, h = 10},
    ["F"] = {x = 82, y = 11, w = 8, h = 10},
    ["G"] = {x = 91, y = 11, w = 8, h = 10},
    ["H"] = {x = 100, y = 11, w = 8, h = 10},
    ["I"] = {x = 109, y = 11, w = 6, h = 10},
    ["J"] = {x = 116, y = 11, w = 8, h = 10},
    ["K"] = {x = 126, y = 11, w = 8, h = 10},
    ["L"] = {x = 133, y = 11, w = 8, h = 10},
    ["M"] = {x = 142, y = 11, w = 8, h = 10},
    ["N"] = {x = 151, y = 11, w = 8, h = 10},
    ["O"] = {x = 160, y = 11, w = 8, h = 10},
    ["P"] = {x = 169, y = 11, w = 8, h = 10},
    ["Q"] = {x = 178, y = 11, w = 8, h = 10},
    ["R"] = {x = 187, y = 11, w = 8, h = 10},
    ["S"] = {x = 196, y = 11, w = 8, h = 10},
    ["T"] = {x = 205, y = 11, w = 8, h = 10},
    ["U"] = {x = 214, y = 11, w = 8, h = 10},
    ["V"] = {x = 223, y = 11, w = 8, h = 10},
    ["W"] = {x = 232, y = 11, w = 8, h = 10},
    ["X"] = {x = 241, y = 11, w = 8, h = 10},
    ["Y"] = {x = 1, y = 21, w = 8, h = 10},
    ["Z"] = {x = 10, y = 21, w = 8, h = 10},
    ["["] = {x = 21, y = 21, w = 9, h = 10},
    ["\\"] = {x = 27, y = 21, w = 9, h = 10},
    ["]"] = {x = 37, y = 21, w = 5, h = 10},
    ["_"] = {x = 54, y = 21, w = 8, h = 10},
    ["a"] = {x = 71, y = 21, w = 8, h = 10},
    ["b"] = {x = 80, y = 21, w = 8, h = 10},
    ["c"] = {x = 89, y = 21, w = 8, h = 10},
    ["d"] = {x = 98, y = 21, w = 8, h = 10},
    ["e"] = {x = 107, y = 21, w = 8, h = 10},
    ["f"] = {x = 116, y = 21, w = 8, h = 9},
    ["g"] = {x = 125, y = 21, w = 8, h = 9},
    ["h"] = {x = 134, y = 21, w = 8, h = 10},
    ["i"] = {x = 143, y = 21, w = 5, h = 9},
    ["j"] = {x = 149, y = 21, w = 8, h = 10},
    ["k"] = {x = 158, y = 21, w = 7, h = 10},
    ["l"] = {x = 166, y = 21, w = 6, h = 10},
    ["m"] = {x = 173, y = 21, w = 9, h = 9},
    ["n"] = {x = 183, y = 21, w = 7, h = 10},
    ["o"] = {x = 191, y = 21, w = 8, h = 9},
    ["p"] = {x = 200, y = 21, w = 8, h = 9},
    ["q"] = {x = 209, y = 21, w = 8, h = 9},
    ["r"] = {x = 218, y = 21, w = 8, h = 10},
    ["s"] = {x = 227, y = 21, w = 8, h = 9},
    ["t"] = {x = 236, y = 21, w = 7, h = 9},
    ["u"] = {x = 0, y = 31, w = 8, h = 10},
    ["v"] = {x = 9, y = 31, w = 8, h = 10},
    ["w"] = {x = 19, y = 31, w = 8, h = 10},
    ["x"] = {x = 28, y = 31, w = 8, h = 10},
    ["y"] = {x = 36, y = 31, w = 9, h = 10},
    ["z"] = {x = 46, y = 31, w = 9, h = 10},
    ["("] = {x = 56, y = 31, w = 7, h = 10},
    ["|"] = {x = 65, y = 31, w = 7, h = 10},
    [")"] = {x = 74, y = 31, w = 9, h = 10},
    ["{"] = {x = 56, y = 31, w = 7, h = 10},
    ["}"] = {x = 56, y = 31, w = 7, h = 10},
  };
  local FONT_TEXTURE = Material("unrealhud/font1.png", "noclamp");
  local WHITE_TEXTURE = Material("unrealhud/font2.png", "noclamp");
  local BLANK = 5;

  --[[------------------------------------------------------------------
    Draws a character
    @param {number} x
    @param {number} y
    @param {string} character
    @param {boolean|nil} should be tinted white
    @param {number|nil} scale
    @param {Color|nil} colour
  ]]--------------------------------------------------------------------
  function U1HUD:DrawCharacter(x, y, char, tint, scale, colour)
    if (not CHARACTERS[char]) then return end
    scale = scale or 1;
    colour = colour or U1HUD.WHITE;
    if (tint) then
      surface.SetMaterial(WHITE_TEXTURE);
    else
      surface.SetMaterial(FONT_TEXTURE);
    end
    surface.SetDrawColor(colour);
    local data = CHARACTERS[char];
    surface.DrawTexturedRectUV(x, y, math.Round(data.w * scale), math.Round(data.h * scale), data.x/FILE_W, data.y/FILE_H, (data.x + data.w)/FILE_W, (data.y + data.h)/FILE_H);
  end

  --[[------------------------------------------------------------------
    Returns the text size
    @param {string} text
    @param {number} scale
    @return {number} width
  ]]--------------------------------------------------------------------
  function U1HUD:GetTextSize(text, scale)
    if (type(text) == "string") then text = string.ToTable(text); end
    local size = 0;
    for i, char in pairs(text) do
      if (CHARACTERS[char]) then
        size = size + (CHARACTERS[char].w * scale);
      else
        size = size + (BLANK * scale);
      end
    end
    return size;
  end

  --[[------------------------------------------------------------------
    Draws a text
    @param {number} x
    @param {number} y
    @param {string} text
    @param {number|nil} alignment
    @param {boolean|nil} should be tinted white
    @param {number|nil} scale
    @param {Color|nil} colour
  ]]--------------------------------------------------------------------
  function U1HUD:DrawText(x, y, text, align, tint, scale, colour)
    scale = scale or 1;
    local chars = string.ToTable(text);

    -- Apply offset
    local offset = 0;
    local size = 0;
    if (align == TEXT_ALIGN_RIGHT) then
      offset = -U1HUD:GetTextSize(text, scale);
    elseif (align == TEXT_ALIGN_CENTER) then
      offset = -U1HUD:GetTextSize(text, scale) * 0.5;
    end

    -- Draw
    local pos = 0;
    for i, char in pairs(chars) do
      if (not CHARACTERS[char]) then pos = pos + (BLANK * scale); continue; end
      U1HUD:DrawCharacter(x + offset + pos, y, char, tint, scale, colour);
      pos = pos + (CHARACTERS[char].w * scale);
    end
  end

end
