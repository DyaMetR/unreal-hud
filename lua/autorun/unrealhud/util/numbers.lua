--[[------------------------------------------------------------------
  NUMBERS
  Map digit textures and display numbers
]]--------------------------------------------------------------------

if CLIENT then

  local BAR_TEXTURE = surface.GetTextureID("gui/gradient");
  local BRIGHT_COLOUR = Color(255, 255, 255, 180);
  local BAR_COLOUR = Color(233, 233, 80);
  local RED_COLOUR = Color(255, 50, 50);
  local NUMBERS_TEXTURE = Material("unrealhud/numbers.png", "noclamp");
  local NUMBERS_RED_TEXTURE = Material("unrealhud/numbers_red.png", "noclamp");
  local NUMBERS_SMALL = Material("unrealhud/numbers_small.png", "noclamp");
  local WIDTH, HEIGHT = 16, 27;
  local FILE_W, FILE_H = 256, 32;
  local SWIDTH, SHEIGHT = 4, 6;
  local SFILE_W, SFILE_H = 64, 8;

  --[[------------------------------------------------------------------
    Draws a single digit; requires texture initialization beforehand
    @param {number} x
    @param {number} y
    @param {number} digit
  ]]--------------------------------------------------------------------
  function U1HUD:DrawDigit(x, y, digit, scale)
    scale = scale or 1;
    local u = ((WIDTH + 3) * digit);
    surface.DrawTexturedRectUV(x, y, math.ceil(WIDTH * scale), math.ceil(HEIGHT * scale), u/FILE_W, 0, (u + WIDTH)/FILE_W, HEIGHT/FILE_H);
  end

  --[[------------------------------------------------------------------
    Draws a number
    @param {number} x
    @param {number} y
    @param {number} number
    @param {number|nil} align
    @param {boolean|nil} should be red
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawNumber(x, y, number, align, red, scale)
    scale = scale or 1;
    local digits = string.ToTable(tostring(number)); -- digit table

    surface.SetDrawColor(U1HUD.WHITE);

    if (not red) then
      surface.SetMaterial(NUMBERS_TEXTURE);
    else
      surface.SetMaterial(NUMBERS_RED_TEXTURE);
    end -- select texture to use

    local offset = 0; -- alignment offset
    if (align == TEXT_ALIGN_RIGHT) then
      offset = WIDTH * table.Count(digits) * scale;
    end

    for i, digit in pairs(digits) do
      U1HUD:DrawDigit(x + (WIDTH * (i - 1) * scale) - offset, y, tonumber(digit), scale);
    end -- draw digits
  end

  --[[------------------------------------------------------------------
    Draws a single small digit; requires texture initialization beforehand
    @param {number} x
    @param {number} y
    @param {string} digit
  ]]--------------------------------------------------------------------
  function U1HUD:DrawSmallDigit(x, y, digit, scale)
    scale = scale or 1;
    if (digit == "-") then
      surface.DrawTexturedRectUV(x, y, SWIDTH * scale, SHEIGHT * scale, 50/SFILE_W, 0, 54/SFILE_W, SHEIGHT/SFILE_H);
    else
      local u = ((SWIDTH + 1) * tonumber(digit));
      surface.DrawTexturedRectUV(x, y, SWIDTH * scale, SHEIGHT * scale, u/SFILE_W, 0, (u + SWIDTH)/SFILE_W, SHEIGHT/SFILE_H);
    end
  end

  --[[------------------------------------------------------------------
    Draws a small number
    @param {number} x
    @param {number} y
    @param {number} number
    @param {Color|nil} colour
    @param {number|nil} scale
  ]]--------------------------------------------------------------------
  function U1HUD:DrawSmallNumber(x, y, number, colour, scale)
    scale = scale or 1;
    colour = colour or U1HUD.WHITE;
    local digits = string.ToTable(tostring(number)); -- digit table
    local count = table.Count(digits) - 1;

    surface.SetDrawColor(colour);
    surface.SetMaterial(NUMBERS_SMALL);

    for i, digit in pairs(digits) do
      U1HUD:DrawSmallDigit(x + ((SWIDTH + 1) * (i - 1) * scale) - ((SWIDTH + 1) * count) * scale, y, digit, scale);
    end -- draw digits
  end

  --[[------------------------------------------------------------------
    Draws a bar in a 32x32 square
    @param {number} x
    @param {number} y
    @param {number} value
    @param {number|nil} scale
    @param {boolean|nil} tint red
  ]]--------------------------------------------------------------------
  function U1HUD:DrawBar(x, y, value, scale, tint)
    scale = scale or 1;
    value = math.Clamp(value, 0, 1);
    local colour = BAR_COLOUR;
    if (tint) then
      colour = U1HUD.RED;
    end
    draw.RoundedBox(0, x + (3 * scale), y + math.floor(30 * scale), (26 * scale) * value, 1 * scale, colour);
    surface.SetTexture(BAR_TEXTURE);
    if (tint) then
      surface.SetDrawColor(RED_COLOUR);
    else
      surface.SetDrawColor(BRIGHT_COLOUR);
    end
    surface.DrawTexturedRect(x + (3 * scale), y + math.floor(30 * scale), (26 * scale) * value, 1 * scale);
  end

end
