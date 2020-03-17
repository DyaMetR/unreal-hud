--[[------------------------------------------------------------------
  ITEMS
  Display an array of items
]]--------------------------------------------------------------------

if CLIENT then

  U1HUD.ITEMS = { Items = {}, Keys = {}, Active = nil};
  local OUTLINE_TEXTURE = Material("unrealhud/overlay.png");
  local WIDTH, HEIGHT = 32, 32;
  local i = 0;

  --[[------------------------------------------------------------------
    Registers an item
    @param {string} id
    @param {string} texture
    @param {function} function that returns value to display (between 0 and 1)
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:RegisterItem(id, texture, func)
    i = i + 1;
    U1HUD.ITEMS.Keys[i] = id;
    U1HUD.ITEMS.Items[id] = {texture = texture, func = func, active = false, pos = i, active = false};
    if (table.Count(U1HUD.ITEMS.Items) <= 1) then
      U1HUD.ITEMS.Active = id;
    end
  end

  --[[------------------------------------------------------------------
    Replaces an item's function
    @param {string} id
    @param {function} function that returns value to display (between 0 and 1)
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:SetItemFunction(id, func)
    U1HUD.ITEMS.Items[id].func = func;
  end

  --[[------------------------------------------------------------------
    Replaces an item's texture
    @param {string} id
    @param {string} texture
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:SetItemTexture(id, texture)
    U1HUD.ITEMS.Items[id].texture = Material(texture);
  end

  --[[------------------------------------------------------------------
    Sets a specific item as active, be it highlighted or not
    @param {string} item
    @param {boolean} active
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:SetItemActive(item, active)
    U1HUD.ITEMS.Items[item].active = active;
  end

  --[[------------------------------------------------------------------
    Highlights an item slot
    @param {string} active
    @param {boolean} should the item be activated itself as well
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:SetActive(cursor, active)
    U1HUD.ITEMS.Active = cursor;
    if (not active) then return; end
    U1HUD.ITEMS:SetItemActive(cursor, active);
  end

  --[[------------------------------------------------------------------
    Returns which item is highlighted
    @return {string} item
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:GetCursor()
    return U1HUD.ITEMS.Active;
  end

  --[[------------------------------------------------------------------
    Returns whether an item is active
    @param {string} item
    @return {boolean} is active
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:IsItemActive(item)
    return U1HUD.ITEMS.Items[item].active;
  end

  --[[------------------------------------------------------------------
    Draws an item
    @param {number} x
    @param {number} y
    @param {string} id
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:DrawItem(x, y, item, scale)
    scale = scale or 1;
    -- Draw item icon
    if (U1HUD.ITEMS:IsItemActive(item)) then
      surface.SetDrawColor(U1HUD.RED);
    else
      surface.SetDrawColor(U1HUD.WHITE);
    end
    surface.SetMaterial(U1HUD.CONTAINER);
    surface.DrawTexturedRect(x, y, math.ceil(WIDTH * scale), math.ceil(HEIGHT * scale));
    surface.SetMaterial(U1HUD.ITEMS.Items[item].texture);
    surface.DrawTexturedRect(x, y, math.ceil(WIDTH * scale), math.ceil(HEIGHT * scale));
    -- Draw bar
    local value = 1;
    if (U1HUD.ITEMS.Items[item].func) then
      value = U1HUD.ITEMS.Items[item].func();
    end
    U1HUD:DrawBar(x, y, value, scale, U1HUD.ITEMS:IsItemActive(item));
  end

  --[[------------------------------------------------------------------
    Draws the item tray
    @param {number} x
    @param {number} y
    @param {number} mode
    @param {number} align
    @param {number} scale
  ]]--------------------------------------------------------------------
  function U1HUD.ITEMS:DrawItems(x, y, mode, align, scale)
    if (not U1HUD:IsItemTrayEnabled()) then return end
    mode = mode or 0;
    if (mode >= 5) then return end
    local count = table.Count(U1HUD.ITEMS.Items);
    if (count <= 0 or not U1HUD.ITEMS.Active) then return end
    scale = scale or 1;
    -- Alignment
    local offset = 0;
    local mul = -1;
    if (align == TEXT_ALIGN_LEFT) then
      mul = 1;
    elseif (align == TEXT_ALIGN_CENTER) then
      mul = 1;
      x = x - (WIDTH * scale * 0.5);
    end

    -- Get items
    local iCur = U1HUD.ITEMS.Items[U1HUD.ITEMS.Active];
    local iNext = U1HUD.ITEMS.Keys[iCur.pos + 1];
    local iPrev = U1HUD.ITEMS.Keys[iCur.pos - 1];
    if (count >= 3) then
      if (not iPrev) then
        iPrev = U1HUD.ITEMS.Keys[table.Count(U1HUD.ITEMS.Items)];
      end
      if (not iNext) then
        iNext = U1HUD.ITEMS.Keys[1];
      end
    end

    -- Draw next
    if (iNext and mode < 4) then
      U1HUD.ITEMS:DrawItem(x + math.ceil(WIDTH * scale * (mul - 2)), y, iNext, scale);
    end

    -- Draw current
    local pos = mul - 1;
    if (mode >= 4) then pos = mul; end
    U1HUD.ITEMS:DrawItem(x + math.ceil(WIDTH * scale * pos), y, U1HUD.ITEMS.Active, scale);

    -- Draw previous
    if (iPrev and mode < 4) then
      U1HUD.ITEMS:DrawItem(x + math.ceil(WIDTH * scale * (mul)), y, iPrev, scale);
    end

    -- Draw active outline
    if (iCur.active) then
      surface.SetDrawColor(U1HUD.RED);
    else
      surface.SetDrawColor(U1HUD.WHITE);
    end
    surface.SetMaterial(OUTLINE_TEXTURE);
    surface.DrawTexturedRect(x + math.ceil(WIDTH * scale * pos), y, WIDTH * scale, HEIGHT * scale);
  end
end
