-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local creatingCharacter = false
local cam = -1
local headingToCam = GetEntityHeading(PlayerPedId())
local camOffset = 2
local customCamLocation = nil
local PlayerData = {}
local previousSkinData = {}
local removeWear = false
local skinData = {
    ["face"] =                 {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["face2"] =                {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["facemix"] =              {skinMix = 0, shapeMix = 0, defaultSkinMix = 0.0, defaultShapeMix = 0.0},
    ["pants"] =                {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["hair"] =                 {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["eyebrows"] =             {item = -1,   texture = 1,  defaultItem = -1,     defaultTexture = 1},
    ["beard"] =                {item = -1,   texture = 1,  defaultItem = -1,     defaultTexture = 1},
    ["blush"] =                {item = -1,   texture = 1,  defaultItem = -1,     defaultTexture = 1},
    ["lipstick"] =             {item = -1,   texture = 1,  defaultItem = -1,     defaultTexture = 1},
    ["makeup"] =               {item = -1,   texture = 1,  defaultItem = -1,     defaultTexture = 1},
    ["ageing"] =               {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["arms"] =                 {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["t-shirt"] =              {item = 1,    texture = 0,  defaultItem = 1,      defaultTexture = 0},
    ["torso2"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["vest"] =                 {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["bag"] =                  {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["shoes"] =                {item = 0,    texture = 0,  defaultItem = 1,      defaultTexture = 0},
    ["mask"] =                 {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["hat"] =                  {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["glass"] =                {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["ear"] =                  {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["watch"] =                {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["bracelet"] =             {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["accessory"] =            {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["decals"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["eye_color"] =            {item = -1,   texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["moles"] =                {item = 0,    texture = 0,  defaultItem = -1,     defaultTexture = 0},
    ["nose_0"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["nose_1"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["nose_2"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["nose_3"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["nose_4"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["nose_5"] =               {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["cheek_1"] =              {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["cheek_2"] =              {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["cheek_3"] =              {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["eye_opening"] =          {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["lips_thickness"] =       {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["jaw_bone_width"] =       {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["eyebrown_high"] =        {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["eyebrown_forward"] =     {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["jaw_bone_back_lenght"] = {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["chimp_bone_lowering"] =  {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["chimp_bone_lenght"] =    {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["chimp_bone_width"] =     {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["chimp_hole"] =           {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
    ["neck_thikness"] =        {item = 0,    texture = 0,  defaultItem = 0,      defaultTexture = 0},
}
local clothingCategories = {
    ["arms"] =                 {type = "variation", id = 3},
    ["t-shirt"] =              {type = "variation", id = 8},
    ["torso2"] =               {type = "variation", id = 11},
    ["pants"] =                {type = "variation", id = 4},
    ["vest"] =                 {type = "variation", id = 9},
    ["shoes"] =                {type = "variation", id = 6},
    ["bag"] =                  {type = "variation", id = 5},
    ["hair"] =                 {type = "hair",      id = 2},
    ["eyebrows"] =             {type = "overlay",   id = 2},
    ["face"] =                 {type = "face",      id = 2},
    ["face2"] =                {type = "face",      id = 2},
    ["facemix"] =              {type = "face",      id = 2},
    ["beard"] =                {type = "overlay",   id = 1},
    ["blush"] =                {type = "overlay",   id = 5},
    ["lipstick"] =             {type = "overlay",   id = 8},
    ["makeup"] =               {type = "overlay",   id = 4},
    ["ageing"] =               {type = "ageing",    id = 3},
    ["mask"] =                 {type = "mask",      id = 1},
    ["hat"] =                  {type = "prop",      id = 0},
    ["glass"] =                {type = "prop",      id = 1},
    ["ear"] =                  {type = "prop",      id = 2},
    ["watch"] =                {type = "prop",      id = 6},
    ["bracelet"] =             {type = "prop",      id = 7},
    ["accessory"] =            {type = "variation", id = 7},
    ["decals"] =               {type = "variation", id = 10},
    ["eye_color"] =            {type = "eye_color", id = 1},
    ["moles"] =                {type = "moles",     id = 1},
    ["jaw_bone_width"] =       {type = "cheek",     id = 1},
    ["jaw_bone_back_lenght"] = {type = "cheek",     id = 1},
    ["lips_thickness"]   =     {type = "nose",      id = 1},
    ["nose_0"] =               {type = "nose",      id = 1},
    ["nose_1"] =               {type = "nose",      id = 1},
    ["nose_2"] =               {type = "nose",      id = 2},
    ["nose_3"] =               {type = "nose",      id = 3},
    ["nose_4"] =               {type = "nose",      id = 4},
    ["nose_5"] =               {type = "nose",      id = 5},
    ["cheek_1"] =              {type = "cheek",     id = 1},
    ["cheek_2"] =              {type = "cheek",     id = 2},
    ["cheek_3"] =              {type = "cheek",     id = 3},
    ["eyebrown_high"] =        {type = "nose",      id = 1},
    ["eyebrown_forward"] =     {type = "nose",      id = 2},
    ["eye_opening"] =          {type = "nose",      id = 1},
    ["chimp_bone_lowering"] =  {type = "chin",      id = 1},
    ["chimp_bone_lenght"] =    {type = "chin",      id = 2},
    ["chimp_bone_width"] =     {type = "cheek",     id = 3},
    ["chimp_hole"] =           {type = "cheek",     id = 4},
    ["neck_thikness"] =        {type = "cheek",     id = 5},
}
local faceProps = {
    [1] = { ["Prop"] = -1, ["Texture"] = -1 },
    [2] = { ["Prop"] = -1, ["Texture"] = -1 },
    [3] = { ["Prop"] = -1, ["Texture"] = -1 },
    [4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
    [5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
    [6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
}


-- sendet eine NUIMessage mit Informationen über die jeweiligen Max-Werte der Kleidungskategorien für das Menu
function GetMaxValues()
    local maxModelValues = {
        ["arms"] =                 {type = "clothing",    item = 0,     texture = 0},
        ["t-shirt"] =              {type = "clothing",    item = 0,     texture = 0},
        ["torso2"] =               {type = "clothing",    item = 0,     texture = 0},
        ["pants"] =                {type = "clothing",    item = 0,     texture = 0},
        ["shoes"] =                {type = "clothing",    item = 0,     texture = 0},
        ["vest"] =                 {type = "clothing",    item = 0,     texture = 0},
        ["accessory"] =            {type = "clothing",    item = 0,     texture = 0},
        ["decals"] =               {type = "clothing",    item = 0,     texture = 0},
        ["bag"] =                  {type = "clothing",    item = 0,     texture = 0},
        ["hair"] =                 {type = "hair",        item = 0,     texture = 0},
        ["eyebrows"] =             {type = "hair",        item = 0,     texture = 0},
        ["beard"] =                {type = "hair",        item = 0,     texture = 0},
        ["lipstick"] =             {type = "hair",        item = 0,     texture = 0},
        ["makeup"] =               {type = "hair",        item = 0,     texture = 0},
        ["ageing"] =               {type = "hair",        item = 0,     texture = 0},
        ["eye_color"] =            {type = "hair",        item = 0,     texture = 0},
        ["blush"] =                {type = "hair",        item = 0,     texture = 0},
        ["moles"] =                {type = "hair",        item = 0,     texture = 0},
        ["face"] =                 {type = "character",   item = 0,     texture = 0},
        ["face2"] =                {type = "character",   item = 0,     texture = 0},
        ["facemix"] =              {type = "character",   shapeMix = 0, skinMix = 0},
        ["eye_opening"] =          {type = "character",   id = 1},
        ["jaw_bone_width"] =       {type = "character",   item = 0,     texture = 0},
        ["jaw_bone_back_lenght"] = {type = "character",   item = 0,     texture = 0},
        ["lips_thickness"] =       {type = "character",   item = 0,     texture = 0},
        ["cheek_1"] =              {type = "character",   item = 0,     texture = 0},
        ["cheek_2"] =              {type = "character",   item = 0,     texture = 0},
        ["cheek_3"] =              {type = "character",   item = 0,     texture = 0},
        ["eyebrown_high"]       =  {type = "character",   item = 0,     texture = 0},
        ["eyebrown_forward"] =     {type = "character",   item = 0,     texture = 0},
        ["nose_0"] =               {type = "character",   item = 0,     texture = 0},
        ["nose_1"] =               {type = "character",   item = 0,     texture = 0},
        ["nose_2"] =               {type = "character",   item = 0,     texture = 0},
        ["nose_3"] =               {type = "character",   item = 0,     texture = 0},
        ["nose_4"] =               {type = "character",   item = 0,     texture = 0},
        ["nose_5"] =               {type = "character",   item = 0,     texture = 0},
        ["chimp_bone_lowering"] =  {type = "character",   item = 0,     texture = 0},
        ["chimp_bone_lenght"] =    {type = "character",   item = 0,     texture = 0},
        ["chimp_bone_width"] =     {type = "character",   item = 0,     texture = 0},
        ["chimp_hole"] =           {type = "character",   item = 0,     texture = 0},
        ["neck_thikness"] =        {type = "character",   item = 0,     texture = 0},
        ["mask"] =                 {type = "accessoires", item = 0,     texture = 0},
        ["hat"] =                  {type = "accessoires", item = 0,     texture = 0},
        ["glass"] =                {type = "accessoires", item = 0,     texture = 0},
        ["ear"] =                  {type = "accessoires", item = 0,     texture = 0},
        ["watch"] =                {type = "accessoires", item = 0,     texture = 0},
        ["bracelet"] =             {type = "accessoires", item = 0,     texture = 0},
    }
    local ped = PlayerPedId()
    for k, v in pairs(clothingCategories) do
        if v.type == "variation" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) -1
        end

        if v.type == "hair" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "mask" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id))
        end

        if v.type == "face" or v.type == "face2" then
            maxModelValues[k].item = 45
            maxModelValues[k].texture = 15
        end

        if v.type == "facemix" then
            maxModelValues[k].shapeMix = 10
            maxModelValues[k].skinMix = 10
        end

        if v.type == "ageing" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 0
        end

        if v.type == "overlay" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "prop" then
            maxModelValues[k].item = GetNumberOfPedPropDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedPropTextureVariations(ped, v.id, GetPedPropIndex(ped, v.id))
        end

        if v.type == "eye_color" then
            maxModelValues[k].item = 31
            maxModelValues[k].texture = 0
        end

        if v.type == "moles" then
            maxModelValues[k].item = GetNumHeadOverlayValues(9) -1
            maxModelValues[k].texture = 10
        end

        if v.type == "nose" or v.type == "cheek" or v.type == "chin" then
            maxModelValues[k].item = 30
            maxModelValues[k].texture = 0
        end
    end

    SendNUIMessage({
        action = "updateMax",
        maxValues = maxModelValues
    })
end

-- zeigt die privious ausgewählte Kleidung wieder an, wenn im Kleidungsmenu auf "cancel" gedrückt wurde
-- data ist die previousSkinData
-- TODO: hier muss auch das Model gesetzt werden!
local function resetClothing(data)
    local ped = PlayerPedId()

    -- Face
    SetPedHeadBlendData(ped, data["face"].item, data["face2"].item, nil, data["face"].texture, data["face2"].texture, nil, data["facemix"].shapeMix, data["facemix"].skinMix, nil, true)

    -- Pants
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)

    -- Hair
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)

    -- Eyebrows
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)

    -- Beard
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)

    -- Blush
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)

    -- Lipstick
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].item, 0)

    -- Makeup
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)

    -- Ageing
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)

    -- Arms
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)

    -- T-Shirt
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)

    -- Vest
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)

    -- Torso 2
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)

    -- Shoes
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)

    -- Mask
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)

    -- Badge
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)

    -- Accessory
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)

    -- Bag
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    SetPedEyeColor(ped, data['eye_color'].item)
    SetPedHeadOverlay(ped, 9, data['moles'].item, data['moles'].texture)
    SetPedFaceFeature(ped, 0, data['nose_0'].item)
    SetPedFaceFeature(ped, 1, data['nose_1'].item)
    SetPedFaceFeature(ped, 2, data['nose_2'].item)
    SetPedFaceFeature(ped, 3, data['nose_3'].item)
    SetPedFaceFeature(ped, 4, data['nose_4'].item)
    SetPedFaceFeature(ped, 5, data['nose_5'].item)
    SetPedFaceFeature(ped, 6, data['eyebrown_high'].item)
    SetPedFaceFeature(ped, 7, data['eyebrown_forward'].item)
    SetPedFaceFeature(ped, 8, data['cheek_1'].item)
    SetPedFaceFeature(ped, 9, data['cheek_2'].item)
    SetPedFaceFeature(ped, 10, data['cheek_3'].item)
    SetPedFaceFeature(ped, 11, data['eye_opening'].item)
    SetPedFaceFeature(ped, 12, data['lips_thickness'].item)
    SetPedFaceFeature(ped, 13, data['jaw_bone_width'].item)
    SetPedFaceFeature(ped, 14, data['jaw_bone_back_lenght'].item)
    SetPedFaceFeature(ped, 15, data['chimp_bone_lowering'].item)
    SetPedFaceFeature(ped, 16, data['chimp_bone_lenght'].item)
    SetPedFaceFeature(ped, 17, data['chimp_bone_width'].item)
    SetPedFaceFeature(ped, 18, data['chimp_hole'].item)
    SetPedFaceFeature(ped, 19, data['neck_thikness'].item)

    -- Hat
    if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
        SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
    else
        ClearPedProp(ped, 0)
    end

    -- Glass
    if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
        SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
    else
        ClearPedProp(ped, 1)
    end

    -- Ear
    if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
        SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
    else
        ClearPedProp(ped, 2)
    end

    -- Watch
    if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
        SetPedPropIndex(ped, 6, data["watch"].item, data["watch"].texture, true)
    else
        ClearPedProp(ped, 6)
    end

    -- Bracelet
    if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
        SetPedPropIndex(ped, 7, data["bracelet"].item, data["bracelet"].texture, true)
    else
        ClearPedProp(ped, 7)
    end
end

-- Funktion nur für cam im Kleidungsmenu
local function GetPositionByRelativeHeading(ped, head, dist)
    local pedPos = GetEntityCoords(ped)

    local finPosx = pedPos.x + math.cos(head * (math.pi / 180)) * dist
    local finPosy = pedPos.y + math.sin(head * (math.pi / 180)) * dist

    return finPosx, finPosy
end

-- wird nur in openMenu() aufgerufen
local function enableCam()
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
    end

    if customCamLocation ~= nil then
        SetCamCoord(cam, customCamLocation.x, customCamLocation.y, customCamLocation.z)
        SetCamRot(cam, 0.0, 0.0, customCamLocation.w)
    end

    headingToCam = GetEntityHeading(PlayerPedId()) + 90
    camOffset = 2.0
end

-- wird nur aufgerufen, wenn Menu geschlossen wird
local function disableCam()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)

    FreezeEntityPosition(PlayerPedId(), false)
    cam = -1
end

local function openMenu(allowedMenus)
    previousSkinData = json.encode(skinData)
    creatingCharacter = true
    PlayerData = QBCore.Functions.GetPlayerData()
    local trackerMeta = PlayerData.metadata["tracker"]
    local translations = {}
    for k in pairs(Lang.fallback and Lang.fallback.phrases or Lang.phrases) do
        if k:sub(0, ('ui.'):len()) then
            translations[k:sub(('ui.'):len() + 1)] = Lang:t(k)
        end
    end
    GetMaxValues()
    SendNUIMessage({
        action = "open",
        menus = allowedMenus,
        currentClothing = skinData,
        hasTracker = trackerMeta,
        translations = translations,
    })
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    FreezeEntityPosition(PlayerPedId(), true)
    enableCam()
end

local function ChangeVariation(data)
    local ped = PlayerPedId()
    local clothingCategory = data.clothingType
    local type = data.type
    local item = data.articleNumber

    if clothingCategory == "pants" then
        if type == "item" then
            SetPedComponentVariation(ped, 4, item, 0, 0)
            skinData["pants"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 4)
            SetPedComponentVariation(ped, 4, curItem, item, 0)
            skinData["pants"].texture = item
        end
    elseif clothingCategory == "face" then
        if type == "item" then
            SetPedHeadBlendData(ped, tonumber(item), skinData["face2"].item, nil, skinData["face"].texture, skinData["face2"].texture, nil, skinData["facemix"].shapeMix, skinData["facemix"].skinMix, nil, true)
            skinData["face"].item = item
        elseif type == "texture" then
            SetPedHeadBlendData(ped, skinData["face"].item, skinData["face2"].item, nil, item, skinData["face2"].texture, nil, skinData["facemix"].shapeMix, skinData["facemix"].skinMix, nil, true)
            skinData["face"].texture = item
        end
    elseif clothingCategory == "face2" then
        if type == "item" then
            SetPedHeadBlendData(ped, skinData["face"].item, tonumber(item), nil, skinData["face"].texture, skinData["face2"].texture, nil, skinData["facemix"].shapeMix, skinData["facemix"].skinMix , nil, true)
            skinData["face2"].item = item
        elseif type == "texture" then
            SetPedHeadBlendData(ped, skinData["face"].item, skinData["face2"].item, nil, skinData["face"].texture, item, nil, skinData["facemix"].shapeMix, skinData["facemix"].skinMix , nil, true)
            skinData["face2"].texture = item
        end
    elseif clothingCategory == "facemix" then
        if type == "skinMix" then
            SetPedHeadBlendData(ped, skinData["face"].item, skinData["face2"].item, nil, skinData["face"].texture, skinData["face2"].texture, nil, skinData["facemix"].shapeMix, item, nil, true)
            skinData["facemix"].skinMix = item
        elseif type == "shapeMix" then
            SetPedHeadBlendData(ped, skinData["face"].item, skinData["face2"].item, nil, skinData["face"].texture, skinData["face2"].texture, nil, item, skinData["facemix"].skinMix , nil, true)
            skinData["facemix"].shapeMix = item
        end
    elseif clothingCategory == "hair" then
        SetPedHeadBlendData(ped, skinData["face"].item, skinData["face2"].item, nil, skinData["face"].texture, skinData["face2"].texture, nil, skinData["facemix"].shapeMix, skinData["facemix"].skinMix , nil, true)
        if type == "item" then
            SetPedComponentVariation(ped, 2, item, 0, 0)
            skinData["hair"].item = item
        elseif type == "texture" then
            SetPedHairColor(ped, item, item)
            skinData["hair"].texture = item
        end
    elseif clothingCategory == "eyebrows" then
        if type == "item" then
            SetPedHeadOverlay(ped, 2, item, 1.0)
            skinData["eyebrows"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 2, 1, item, 0)
            skinData["eyebrows"].texture = item
        end
    elseif clothingCategory == "beard" then
        if type == "item" then
            SetPedHeadOverlay(ped, 1, item, 1.0)
            skinData["beard"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 1, 1, item, 0)
            skinData["beard"].texture = item
        end
    elseif clothingCategory == "blush" then
        if type == "item" then
            SetPedHeadOverlay(ped, 5, item, 1.0)
            skinData["blush"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 5, 1, item, 0)
            skinData["blush"].texture = item
        end
    elseif clothingCategory == "lipstick" then
        if type == "item" then
            SetPedHeadOverlay(ped, 8, item, 1.0)
            skinData["lipstick"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 8, 1, item, 0)
            skinData["lipstick"].texture = item
        end
    elseif clothingCategory == "makeup" then
        if type == "item" then
            SetPedHeadOverlay(ped, 4, item, 1.0)
            skinData["makeup"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 4, 1, item, 0)
            skinData["makeup"].texture = item
        end
    elseif clothingCategory == "ageing" then
        if type == "item" then
            SetPedHeadOverlay(ped, 3, item, 1.0)
            skinData["ageing"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 3, 1, item, 0)
            skinData["ageing"].texture = item
        end
    elseif clothingCategory == "arms" then
        if type == "item" then
            SetPedComponentVariation(ped, 3, item, 0, 2)
            skinData["arms"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 3)
            SetPedComponentVariation(ped, 3, curItem, item, 0)
            skinData["arms"].texture = item
        end
     elseif clothingCategory == "eye_color" then
        if type == "item" then
            SetPedEyeColor(ped, item)
            skinData["eye_color"].item = item
        end
    elseif clothingCategory == "moles" then
        if type == "item" then
            SetPedHeadOverlay(ped, 9, item, 1.0)
            skinData["moles"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 9)
            local newitem = (item / 10)
            SetPedHeadOverlayColor(ped, 9, curItem, newitem)
            skinData["moles"].texture = item
        end
    elseif clothingCategory == "nose_0" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 0, newitem)
            skinData["nose_0"].item = item
        end

    elseif clothingCategory == "nose_1" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 1, newitem)
            skinData["nose_1"].item = item
        end
    elseif clothingCategory == "nose_2" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 2, newitem)
            skinData["nose_2"].item = item
        end
    elseif clothingCategory == "nose_3" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 3, newitem)
            skinData["nose_3"].item = item
        end
    elseif clothingCategory == "nose_4" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 4, newitem)
            skinData["nose_4"].item = item
        end
    elseif clothingCategory == "nose_5" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 5, newitem)
            skinData["nose_5"].item = item
        end
    elseif clothingCategory == "eyebrown_high" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 6, newitem)
            skinData["eyebrown_high"].item = item
        end
    elseif clothingCategory == "eyebrown_forward" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 7, newitem)
            skinData["eyebrown_forward"].item = item
        end
    elseif clothingCategory == "cheek_1" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 8, newitem)
            skinData["cheek_1"].item = item
        end
    elseif clothingCategory == "cheek_2" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 9, newitem)
            skinData["cheek_1"].item = item
        end
    elseif clothingCategory == "cheek_3" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 10, newitem)
            skinData["cheek_3"].item = item
        end
    elseif clothingCategory == "eye_opening" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 11, newitem)
            skinData["eye_opening"].item = item
        end
    elseif clothingCategory == "lips_thickness" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 12, newitem)
            skinData["lips_thickness"].item = item
        end
    elseif clothingCategory == "jaw_bone_width" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 13, newitem)
            skinData["jaw_bone_width"].item = item
        end
    elseif clothingCategory == "jaw_bone_back_lenght" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 14, newitem)
            skinData["jaw_bone_back_lenght"].item = item
        end
    elseif clothingCategory == "chimp_bone_lowering" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 15, newitem)
            skinData["chimp_bone_lowering"].item = item
        end
    elseif clothingCategory == "chimp_bone_lenght" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 16, newitem)
            skinData["chimp_bone_lenght"].item = item
        end
    elseif clothingCategory == "chimp_bone_width" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 17, newitem)
            skinData["chimp_bone_width"].item = item
        end
    elseif clothingCategory == "chimp_hole" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 18, newitem)
            skinData["chimp_hole"].item = item
        end
    elseif clothingCategory == "neck_thikness" then
        if type == "item" then
            local newitem = (item / 10)
            SetPedFaceFeature(ped, 19, newitem)
            skinData["chimp_hole"].item = item
        end
    elseif clothingCategory == "t-shirt" then
        if type == "item" then
            SetPedComponentVariation(ped, 8, item, 0, 2)
            skinData["t-shirt"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 8)
            SetPedComponentVariation(ped, 8, curItem, item, 0)
            skinData["t-shirt"].texture = item
        end
    elseif clothingCategory == "vest" then
        if type == "item" then
            SetPedComponentVariation(ped, 9, item, 0, 2)
            skinData["vest"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 9, skinData["vest"].item, item, 0)
            skinData["vest"].texture = item
        end
    elseif clothingCategory == "bag" then
        if type == "item" then
            SetPedComponentVariation(ped, 5, item, 0, 2)
            skinData["bag"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 5, skinData["bag"].item, item, 0)
            skinData["bag"].texture = item
        end
    elseif clothingCategory == "decals" then
        if type == "item" then
            SetPedComponentVariation(ped, 10, item, 0, 2)
            skinData["decals"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 10, skinData["decals"].item, item, 0)
            skinData["decals"].texture = item
        end
    elseif clothingCategory == "accessory" then
        if type == "item" then
            SetPedComponentVariation(ped, 7, item, 0, 2)
            skinData["accessory"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 7, skinData["accessory"].item, item, 0)
            skinData["accessory"].texture = item
        end
    elseif clothingCategory == "torso2" then
        if type == "item" then
            SetPedComponentVariation(ped, 11, item, 0, 2)
            skinData["torso2"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 11)
            SetPedComponentVariation(ped, 11, curItem, item, 0)
            skinData["torso2"].texture = item
        end
    elseif clothingCategory == "shoes" then
        if type == "item" then
            SetPedComponentVariation(ped, 6, item, 0, 2)
            skinData["shoes"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 6)
            SetPedComponentVariation(ped, 6, curItem, item, 0)
            skinData["shoes"].texture = item
        end
    elseif clothingCategory == "mask" then
        if type == "item" then
            SetPedComponentVariation(ped, 1, item, 0, 2)
            skinData["mask"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 1)
            SetPedComponentVariation(ped, 1, curItem, item, 0)
            skinData["mask"].texture = item
        end
    elseif clothingCategory == "hat" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 0, item, skinData["hat"].texture, true)
            else
                ClearPedProp(ped, 0)
            end
            skinData["hat"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 0, skinData["hat"].item, item, true)
            skinData["hat"].texture = item
        end
    elseif clothingCategory == "glass" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 1, item, skinData["glass"].texture, true)
                skinData["glass"].item = item
            else
                ClearPedProp(ped, 1)
            end
        elseif type == "texture" then
            SetPedPropIndex(ped, 1, skinData["glass"].item, item, true)
            skinData["glass"].texture = item
        end
    elseif clothingCategory == "ear" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 2, item, skinData["ear"].texture, true)
            else
                ClearPedProp(ped, 2)
            end
            skinData["ear"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 2, skinData["ear"].item, item, true)
            skinData["ear"].texture = item
        end
    elseif clothingCategory == "watch" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 6, item, skinData["watch"].texture, true)
            else
                ClearPedProp(ped, 6)
            end
            skinData["watch"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 6, skinData["watch"].item, item, true)
            skinData["watch"].texture = item
        end
    elseif clothingCategory == "bracelet" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 7, item, skinData["bracelet"].texture, true)
            else
                ClearPedProp(ped, 7)
            end
            skinData["bracelet"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 7, skinData["bracelet"].item, item, true)
            skinData["bracelet"].texture = item
        end
    end

    GetMaxValues()
end

local function ChangeToSkinNoUpdate(skin)
    print("ChangeToSkinNoUpdate")

    local model = GetHashKey(skin)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)

        for k, v in pairs(skinData) do
            if skin == "mp_m_freemode_01" or skin == "mp_f_freemode_01" then
                ChangeVariation({
                    clothingType = k,
                    articleNumber = v.defaultItem,
                    type = "item",
                })
            else
                if k ~= "face" and k ~= "hair" and k ~= "face2" then
                    ChangeVariation({
                        clothingType = k,
                        articleNumber = v.defaultItem,
                        type = "item",
                    })
                end
            end

            if skin == "mp_m_freemode_01" or skin == "mp_f_freemode_01" then
                ChangeVariation({
                    clothingType = k,
                    articleNumber = v.defaultTexture,
                    type = "texture",
                })
            else
                if k ~= "face" and k ~= "hair" and k ~= "face2" then
                    ChangeVariation({
                        clothingType = k,
                        articleNumber = v.defaultTexture,
                        type = "texture",
                    })
                end
            end
        end
    end)
end

-- speichert den aktuellen Skin (Model + Kleidung) in die Datenbank
local function SaveSkin()
    local model = GetEntityModel(PlayerPedId())
    local clothing = json.encode(skinData)
    TriggerServerEvent("qb-clothing:saveSkin", model, clothing)
end

local function reloadSkin(health)
    local model

    local gender = QBCore.Functions.GetPlayerData().charinfo.gender
    local maxhealth = GetEntityMaxHealth(PlayerPedId())

    if gender == 1 then -- Gender is ONE for FEMALE
        model = GetHashKey("mp_f_freemode_01") -- Female Model
    else
        model = GetHashKey("mp_m_freemode_01") -- Male Model
    end

    RequestModel(model)

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    Citizen.Wait(1000) -- Safety Delay

    TriggerServerEvent("qb-clothes:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES
    TriggerServerEvent("qb-clothing:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES - Event 2

    SetPedMaxHealth(PlayerId(), maxhealth)
    Citizen.Wait(1000) -- Safety Delay
    SetEntityHealth(PlayerPedId(), health)
end
-- Exports
exports['reloadSkin', reloadSkin]

exports('IsCreatingCharacter', function()
    return creatingCharacter
end)

local function getOutfits(gradeLevel, data)
    local gender = "male"
    if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then gender = "female" end
    QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
        openMenu({
            {menu = "roomOutfits", label = Lang:t("outfits.roomOutfits"), selected = true, outfits = data[gender][gradeLevel]},
            {menu = "myOutfits", label = Lang:t("outfits.myOutfits"), selected = false, outfits = result},
            {menu = "character", label = Lang:t("outfits.character"), selected = false},
            {menu = "accessoires", label = Lang:t("outfits.accessoires"), selected = false}
        })
    end)
end

exports('getOutfits',getOutfits)



RegisterNetEvent('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('qb-clothing:client:openMenu', function()
    customCamLocation = nil
    openMenu({
        {menu = "character", label = Lang:t("menu.features"), selected = true},
        {menu = "hair", label = Lang:t("menu.hair"), selected = false},
        {menu = "clothing", label = Lang:t("menu.character"), selected = false},
        {menu = "accessoires", label = Lang:t("menu.accessoires"), selected = false}
    })
end)

RegisterNetEvent('qb-clothing:client:reloadOutfits', function(myOutfits)
    SendNUIMessage({
        action = "reloadMyOutfits",
        outfits = myOutfits
    })
end)

-- hiermit kann der Spieler seinen ersten Character beim Firstjoin erstellen
-- wird aufgerufen in nc-login
RegisterNetEvent('qb-clothes:client:CreateFirstCharacter', function()
    QBCore.Functions.GetPlayerData(function(pData)
        local skin = "mp_m_freemode_01"
        openMenu({
            {menu = "character", label = Lang:t("menu.features"), selected = true},
            {menu = "hair", label = Lang:t("menu.hair"), selected = false},
            {menu = "clothing", label = Lang:t("menu.character"), selected = false},
            {menu = "accessoires", label = Lang:t("menu.accessoires"), selected = false}
        })

        if pData.charinfo.gender == 1 then
            skin = "mp_f_freemode_01"
        end

        ChangeToSkinNoUpdate(skin)
        SendNUIMessage({
            action = "ResetValues",
        })
    end)
end)

-- setzt dem Spieler das ausgewählt Model, NICHT DIE KLEIDUNG
-- wird beim joinen durch den server gecallt
RegisterNetEvent("qb-clothes:loadSkin", function(_, model, data)
    model = model ~= nil and tonumber(model) or false
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)

        data = json.decode(data)
        TriggerEvent('qb-clothing:client:loadPlayerClothing', data, PlayerPedId())
    end)
end)

-- Funktion nur um ein paar Zeilen in qb-clothing:client:loadPlayerClothing zu sparen
local function applyPedProp(pred, prop, propId, data)
    if data[prop].item ~= -1 and data[prop].item ~= 0 then
        SetPedPropIndex(ped, propId, data[prop].item, data[prop].texture, true)
    else
        ClearPedProp(ped, propId)
    end
end

-- setzt dem Spieler die ausgewählte Kleidung, NICHT DAS MODEL
-- wird anschließend an qb-clothes:loadSkin (also beim Joinen) gecallt
RegisterNetEvent('qb-clothing:client:loadPlayerClothing', function(data, ped)
    if ped == nil then ped = PlayerPedId() end

    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 0)
    end

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    -- Face
    if not data["facemix"] or not data["face2"] then
        data["facemix"] = skinData["facemix"]
        data["facemix"].shapeMix = data["facemix"].defaultShapeMix
        data["facemix"].skinMix = data["facemix"].defaultSkinMix
        data["face2"] = skinData["face2"]
    end

    SetPedHeadBlendData(ped, data["face"].item, data["face2"].item, nil, data["face"].texture, data["face2"].texture, nil, data["facemix"].shapeMix, data["facemix"].skinMix, nil, true)

    -- Pants:
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    -- Hair:
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)
    -- Eyebrows:
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)
    -- Beard:
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)
    -- Blush:
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)
    -- Lipstick:
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].texture, 0)
    -- Makeup:
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)
    -- Ageing:
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)
    -- Arms:
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    -- T-Shirt:
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    -- Vest:
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    -- Torso 2:
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    -- Shoes:
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    -- Mask:
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    -- Badge:
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    -- Accessory:
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
    -- Bag:
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    applyPedProp(ped, "hat", 0, data)
    applyPedProp(ped, "glass", 1, data)
    applyPedProp(ped, "ear", 2, data)
    applyPedProp(ped, "watch", 6, data)
    applyPedProp(ped, "bracelet", 7, data)

    if data["eye_color"].item ~= -1 and data["eye_color"].item ~= 0 then
        SetPedEyeColor(ped, data['eye_color'].item)
    end

    if data["moles"].item ~= -1 and data["moles"].item ~= 0 then
        SetPedHeadOverlay(ped, 9, data['moles'].item, (data['moles'].texture / 10))
    end

    SetPedFaceFeature(ped, 0, (data['nose_0'].item / 10))
    SetPedFaceFeature(ped, 1, (data['nose_1'].item / 10))
    SetPedFaceFeature(ped, 2, (data['nose_2'].item / 10))
    SetPedFaceFeature(ped, 3, (data['nose_3'].item / 10))
    SetPedFaceFeature(ped, 4, (data['nose_4'].item / 10))
    SetPedFaceFeature(ped, 5, (data['nose_5'].item / 10))
    SetPedFaceFeature(ped, 6, (data['eyebrown_high'].item / 10))
    SetPedFaceFeature(ped, 7, (data['eyebrown_forward'].item / 10))
    SetPedFaceFeature(ped, 8, (data['cheek_1'].item / 10))
    SetPedFaceFeature(ped, 9, (data['cheek_2'].item / 10))
    SetPedFaceFeature(ped, 10,(data['cheek_3'].item / 10))
    SetPedFaceFeature(ped, 11, (data['eye_opening'].item / 10))
    SetPedFaceFeature(ped, 12, (data['lips_thickness'].item / 10))
    SetPedFaceFeature(ped, 13, (data['jaw_bone_width'].item / 10))
    SetPedFaceFeature(ped, 14, (data['jaw_bone_back_lenght'].item / 10))
    SetPedFaceFeature(ped, 15, (data['chimp_bone_lowering'].item / 10))
    SetPedFaceFeature(ped, 16, (data['chimp_bone_lenght'].item / 10))
    SetPedFaceFeature(ped, 17, (data['chimp_bone_width'].item / 10))
    SetPedFaceFeature(ped, 18, (data['chimp_hole'].item / 10))
    SetPedFaceFeature(ped, 19, (data['neck_thikness'].item / 10))
    skinData = data
end)

local function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end
RegisterNetEvent('qb-clothing:client:loadOutfit', function(oData)
    local ped = PlayerPedId()

    local data = oData.outfitData

    if typeof(data) ~= "table" then data = json.decode(data) end

    for k in pairs(data) do
        skinData[k].item = data[k].item
        skinData[k].texture = data[k].texture

        -- To secure backwards compability for facemixing
        if data[k].shapeMix then
            skinData[k].shapeMix = data[k].shapeMix
        end

        if data[k].skinMix then
            skinData[k].skinMix = data[k].skinMix
        end
    end

    -- Pants
    if data["pants"] ~= nil then
        SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    end

    -- Arms
    if data["arms"] ~= nil then
        SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    end

    -- T-Shirt
    if data["t-shirt"] ~= nil then
        SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    end

    -- Vest
    if data["vest"] ~= nil then
        SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    end

    -- Torso 2
    if data["torso2"] ~= nil then
        SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    end

    -- Shoes
    if data["shoes"] ~= nil then
        SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Badge
    if data["decals"] ~= nil then
        SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    end

    -- Accessory
    if data["accessory"] ~= nil then
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
        end
    else
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, -1, 0, 2)
        end
    end

    -- Mask
    if data["mask"] ~= nil then
        SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Hat
    if data["hat"] ~= nil then
        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
        else
            ClearPedProp(ped, 0)
        end
    end

    -- Glass
    if data["glass"] ~= nil then
        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
        else
            ClearPedProp(ped, 1)
        end
    end

    -- Ear
    if data["ear"] ~= nil then
        if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
            SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
        else
            ClearPedProp(ped, 2)
        end
    end

    if oData.outfitName ~= nil then
        QBCore.Functions.Notify("Klicke auf 'confirm', um das Outfit " .. oData.outfitName .. " anzuziehen.")
    end
end)


-- wenn der Spieler durch den QBCore geladen wurde, wird im von hier aus seine Kleidung gesetzt
-- 1. server: qb-clothes:loadPlayerSkin (Daten aus Datenbank)
-- 2. client: qb-clothes:loadSkin (Model wird dem Spieler gesetzt)
-- 3. client: qb-clothing:client:loadPlayerClothing (Kleidung wird dem Spieler gesetzt)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("qb-clothes:loadPlayerSkin")
    loadStores()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
end)

RegisterNetEvent('qb-clothing:client:openOutfitMenu', function()
    QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
        openMenu({
            {menu = "myOutfits", label = Lang:t("outfits.myOutfits"), selected = true, outfits = result},
        })
    end)
end)



-- wird ausgeführt, wenn ein Outfit ausgewählt wird (anschließend ist noch ein Klick auf "confirm" nötig -> saveClothing)
RegisterNUICallback('selectOutfit', function(data, cb)
    if data.outfitModel ~= nil then
        TriggerEvent("qb-clothes:loadSkin", false, data.outfitModel, json.encode(data.outfitData))
    else
        local model = GetEntityModel(PlayerPedId())

        if model == 1885233650 or model == -1667301416 then
            TriggerEvent('qb-clothing:client:loadOutfit', data)
        else
            TriggerEvent("QBCore:Notify", "Fehler: Du musst ein Outfit mit DEFAULT Model ausgewählt haben!", "error")
        end
    end
    cb('ok')
end)

RegisterNUICallback('TrackerError', function(_, cb)
    QBCore.Functions.Notify(Lang:t("notify.error_bracelet"), "error")
    cb('ok')
end)

-- wird ausgeführt, wenn der Spieler ein erstelltes Outfit abgespreichert
RegisterNUICallback('saveOutfit', function(data, cb)
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    TriggerServerEvent('qb-clothes:saveOutfit', data.outfitName, model, skinData)
    cb('ok')
end)

-- hiermit kann die Prespektive auf den eigenen Charakter im Kleidungsmenu geändert werden
-- wird bei Knopfdruck (D) ausgeführt
RegisterNUICallback('rotateRight', function(_, cb)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    local camPos = GetCamCoord(cam)
    local heading = headingToCam
    heading = heading + 2.5
    headingToCam = heading
    local cx, cy = GetPositionByRelativeHeading(ped, heading, camOffset)
    SetCamCoord(cam, cx, cy, camPos.z)
    PointCamAtCoord(cam, pedPos.x, pedPos.y, camPos.z)
    cb('ok')
end)

-- hiermit kann die Prespektive auf den eigenen Charakter im Kleidungsmenu geändert werden
-- wird bei Knopfdruck (A) ausgeführt
RegisterNUICallback('rotateLeft', function(_, cb)
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    local camPos = GetCamCoord(cam)
    local heading = headingToCam
    heading = heading - 2.5
    headingToCam = heading
    local cx, cy = GetPositionByRelativeHeading(ped, heading, camOffset)
    SetCamCoord(cam, cx, cy, camPos.z)
    PointCamAtCoord(cam, pedPos.x, pedPos.y, camPos.z)
    cb('ok')
end)

-- ?
RegisterNUICallback('rotateCam', function(data, cb)
    print("rotateCam")

    local rotType = data.type
    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 2.0, 0)
    if rotType == "left" then
        SetEntityHeading(ped, GetEntityHeading(ped) - 10)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180)
    else
        SetEntityHeading(ped, GetEntityHeading(ped) + 10)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180)
    end
    cb('ok')
end)

-- wird ausgefürt, wenn die Kameraperspektive über das Kleidungsmenu gewechselt wird
RegisterNUICallback('setupCam', function(data, cb)
    local value = data.value
    local pedPos = GetEntityCoords(PlayerPedId())
    if value == 1 then
        camOffset = 0.75
        local cx, cy = GetPositionByRelativeHeading(PlayerPedId(), headingToCam, camOffset)
        SetCamCoord(cam, cx, cy, pedPos.z + 0.65)
        PointCamAtCoord(cam, pedPos.x, pedPos.y, pedPos.z + 0.65)
    elseif value == 2 then
        camOffset = 1.0
        local cx, cy = GetPositionByRelativeHeading(PlayerPedId(), headingToCam, camOffset)
        SetCamCoord(cam, cx, cy, pedPos.z + 0.2)
        PointCamAtCoord(cam, pedPos.x, pedPos.y, pedPos.z + 0.2)
    elseif value == 3 then
        camOffset = 1.0
        local cx, cy = GetPositionByRelativeHeading(PlayerPedId(), headingToCam, camOffset)
        SetCamCoord(cam, cx, cy, pedPos.z + -0.5)
        PointCamAtCoord(cam, pedPos.x, pedPos.y, pedPos.z + -0.5)
    else
        camOffset = 2.0
        local cx, cy = GetPositionByRelativeHeading(PlayerPedId(), headingToCam, camOffset)
        SetCamCoord(cam, cx, cy, pedPos.z + 0.2)
        PointCamAtCoord(cam, pedPos.x, pedPos.y, pedPos.z + 0.2)
    end
    cb('ok')
end)

-- wird aufgerufen, wenn man im Kleidungsmenu auf "cancel" drückt
-- vorher wurde schon das gewählte Outfit angezeigt, mit dem reset wird das aktuell gespeicherte wieder gewählt
RegisterNUICallback('resetOutfit', function(_, cb)
    resetClothing(json.decode(previousSkinData))
    skinData = json.decode(previousSkinData)
    previousSkinData = {}
    cb('ok')
end)

-- wird immer dann ausgeführt, wenn Menus geschlossen werden
-- insb. wenn auf "confirm" und "cancel" geklickt wird
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent('qb-clothing:client:onMenuClose')
    cb('ok')
end)

-- ?
RegisterNUICallback('getCatergoryItems', function(data, cb)
    cb(Config.Menus[data.category])
    print("getCatergoryItems")
end)

-- wird ausgeführt, wenn man eines der selbst erstellten Outfits durch Klick auf "delete" löscht
RegisterNUICallback('removeOutfit', function(data, cb)
    TriggerServerEvent('qb-clothing:server:removeOutfit', data.outfitName, data.outfitId)
    QBCore.Functions.Notify(Lang:t('notify.info_deleteOutfit', {outfit = data.outfitName}))
    cb('ok')
end)

-- wird ausgeführt, wenn im Kleidungsmenu das Model durch Klick auf den Pfeil nach links oder rechts oder durch den Schieberegeler geändert wird
RegisterNUICallback('setCurrentPed', function(data, cb)
    print("setCurrentPed")
    local playerData = QBCore.Functions.GetPlayerData()
    if playerData.charinfo.gender == 0 then
        cb(Config.ManPlayerModels[data.ped])
        ChangeToSkinNoUpdate(Config.ManPlayerModels[data.ped])
    else
        cb(Config.WomanPlayerModels[data.ped])
        ChangeToSkinNoUpdate(Config.WomanPlayerModels[data.ped])
    end
end)

-- wird ausgeführt, wenn Kategorien im Kleidungsmenu (außer Model) durch Klick auf den Pfeil nach links oder rechts oder durch den Schieberegeler geändert werden
-- außerdem auch bei der js Funktion QBClothing.ResetItemTexture, die ich aber noch nicht ganz gecheckt habe ?
RegisterNUICallback('updateSkin', function(data, cb)
    print("updateSkin")
    ChangeVariation(data)
    cb('ok')
end)

-- macht das gleiche wie updateSkin nur mit dem Unterschied, dass updateSkinOnInput ausgeführt wird, wenn eine Kleidungs-Zahl selbst eingegeben wurde, also ohne den Slíder oder die Pfeile zu benutzen
-- ? nicht ganz sicher
RegisterNUICallback('updateSkinOnInput', function(data, cb)
    print("updateSkinOnInput")
    ChangeVariation(data)
    cb('ok')
end)

-- wird ausgeführt, wenn im Kleidungsmenu auf "confirm" geklickt wird
RegisterNUICallback('saveClothing', function(_, cb)
    print("saveClothing")
    SaveSkin()
    cb('ok')
end)


-- /refreshskin Command
RegisterCommand("refreshskin", function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    reloadSkin(health)
end)


-- erstellt für jeden Store aus der Config den passenden Blip auf der Map
Citizen.CreateThread(function()
    for k, _ in pairs (Config.Stores) do
        if Config.Stores[k].shopType == "clothing" then
            local clothingShop = AddBlipForCoord(Config.Stores[k].coords)
            SetBlipSprite(clothingShop, 73)
            SetBlipColour(clothingShop, 47)
            SetBlipScale(clothingShop, 0.7)
            SetBlipAsShortRange(clothingShop, true)
            --BeginTextCommandSetBlipName("STRING")
            --AddTextComponentString(Lang:t("store.clothing"))
            --EndTextCommandSetBlipName(clothingShop)
        end

        if Config.Stores[k].shopType == "barber" then
            local barberShop = AddBlipForCoord(Config.Stores[k].coords)
            SetBlipSprite(barberShop, 71)
            SetBlipColour(barberShop, 0)
            SetBlipScale(barberShop, 0.7)
            SetBlipAsShortRange(barberShop, true)
            --BeginTextCommandSetBlipName("STRING")
            --AddTextComponentString(Lang:t("store.barber"))
            --EndTextCommandSetBlipName(barberShop)
        end

        if Config.Stores[k].shopType == "surgeon" then
            local surgeonShop = AddBlipForCoord(Config.Stores[k].coords)
            SetBlipSprite(surgeonShop, 102)
            SetBlipColour(surgeonShop, 0)
            SetBlipScale(surgeonShop, 0.7)
            SetBlipAsShortRange(surgeonShop, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Plastische Chirurgie")
            EndTextCommandSetBlipName(surgeonShop)
        end
    end
end)


local insideMarkerZone = false
local insideUseZone = false

local function createMarkerZone(key, value)
    local name = value.shopType
    if value.shopType == 'clothingroom' then
        name = value.shopType .. "_" .. key
    end

    return CircleZone:Create(vector3(value.coords.x, value.coords.y, value.coords.z + 0.05), 5, {
        name = name,
        debugPoly = false,
        useZ = true
    })
end

local function createUseZone(key, value)
    local name = value.shopType
    if value.shopType == 'clothingroom' then
        name = value.shopType .. "_" .. key
    end

    return CircleZone:Create(vector3(value.coords.x, value.coords.y, value.coords.z + 1.0), 1, {
        name = name,
        debugPoly = false,
        useZ = true
    })
end

function canPlayerAccessClothingRoom(zone)
    local splittedZoneName = QBCore.Shared.SplitStr(zone.name, "_")
    if splittedZoneName[1] ~= nil and splittedZoneName[2] ~= nil then
        if splittedZoneName[1] == 'clothingroom' then
            local zoneID = tonumber(QBCore.Shared.SplitStr(zone.name, "_")[2])
            local job = Config.ClothingRooms[zoneID].isGang and PlayerData.gang.name or (not QBCore.Shared.QBJobsStatus and PlayerData.job.name)
                            
            if (job == Config.ClothingRooms[zoneID].requiredJob) then
                return true
            end
        end
    end

    return false
end

RegisterCommand('noob', function()
    loadStores()
end)

function loadStores()
    CreateThread(function()
        local markerZones = {}
        local useZones = {}

        for key, value in pairs(Config.Stores) do
            markerZones[#markerZones + 1] = createMarkerZone(key, value)
            useZones[#useZones + 1] = createUseZone(key, value)
        end

        for key, value in pairs(Config.OutfitChangers) do
            markerZones[#markerZones + 1] = createMarkerZone(key, value)
            useZones[#useZones + 1] = createUseZone(key, value)
        end

        for key, value in pairs(Config.ClothingRooms) do
            markerZones[#markerZones + 1] = createMarkerZone(key, value)
            useZones[#useZones + 1] = createUseZone(key, value)
        end

        markerComboZone = ComboZone:Create(markerZones, {name = "clothing_markers", debugPoly = false})
        markerComboZone:onPlayerInOut(function(isPointInside, _, zone)
            if zone then
                print(zone)
                if isPointInside and not insideMarkerZone then
                    insideMarkerZone = true
                    local canAccessClothingRoom = canPlayerAccessClothingRoom(zone)
                    
                    CreateThread(function()
                        if canAccessClothingRoom then
                            while insideMarkerZone do
                                local centerCoords = zone:getCenter()
                                DrawMarker(27, centerCoords.x, centerCoords.y, centerCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.75, 1.75, 1.75, 255, 128, 0, 255, false, false, 2, true, nil, nil, false)
                                Wait(0)
                            end
                        elseif zone.name == 'surgeon' or zone.name == 'clothing' or zone.name == 'barber' or zone.name == 'outfit' then
                            while insideMarkerZone do
                                local centerCoords = zone:getCenter()
                                DrawMarker(27, centerCoords.x, centerCoords.y, centerCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.75, 1.75, 1.75, 255, 128, 0, 255, false, false, 2, true, nil, nil, false)
                                Wait(0)
                            end
                        end
                    end)
                else
                    insideMarkerZone = false
                end
            end
        end)

        useComboZone = ComboZone:Create(useZones, {name = "clothing_use", debugPoly = false})
        useComboZone:onPlayerInOut(function(isPointInside, _, zone)
            if zone then
                if isPointInside and not insideUseZone then
                    insideUseZone = true
                    local canAccessClothingRoom = canPlayerAccessClothingRoom(zone)

                    local text
                    if zone.name == 'surgeon' then
                        text = "Plastische Operation mit ~INPUT_CONTEXT~ vornahmen."
                    elseif zone.name == 'clothing' then
                        text = "Kaufe Kleidung mit ~INPUT_CONTEXT~ ein."
                    elseif zone.name == 'barber' then
                        text = "Frisur mit ~INPUT_CONTEXT~ wählen."
                    elseif zone.name == 'outfit' then
                        text = "Ziehe dir eines deiner Outfits mit ~INPUT_CONTEXT~ an."
                    elseif canAccessClothingRoom then
                        text = "Ziehe deine Dienstkleidung mit ~INPUT_CONTEXT~ an."
                    end

                    if text ~= nil then
                        AddTextEntry('clothing_use', text)
                        BeginTextCommandDisplayHelp('clothing_use')
                        EndTextCommandDisplayHelp(0, true, true, -1)
                    end

                    CreateThread(function()
                        while insideUseZone do
                            if IsControlJustPressed(0, 38) then
                                ClearAllHelpMessages()
                                customCamLocation = nil

                                if zone.name == 'surgeon' then
                                    openMenu({
                                        {menu = "character", label = Lang:t("menu.features"), selected = true},
                                    })
                                elseif zone.name == 'clothing' then
                                    openMenu({
                                        {menu = "clothing", label = Lang:t("menu.character"), selected = true},
                                        {menu = "accessoires", label = Lang:t("menu.accessoires"), selected = false}
                                    })
                                elseif zone.name == 'barber' then
                                    openMenu({
                                        {menu = "hair", label = Lang:t("menu.hair"), selected = true},
                                    })
                                elseif zone.name == 'outfit' then
                                    TriggerEvent('qb-clothing:client:openOutfitMenu')
                                elseif canAccessClothingRoom then
                                    local zoneID = tonumber(QBCore.Shared.SplitStr(zone.name, "_")[2])
                                    local clothingRoom = Config.ClothingRooms[zoneID]
                                    local gradeLevel = clothingRoom.isGang and PlayerData.gang.grade.level or (not QBCore.Shared.QBJobsStatus and PlayerData.job.grade.level)

                                    customCamLocation = clothingRoom.cameraLocation
                                    getOutfits(gradeLevel, Config.Outfits[clothingRoom.requiredJob])
                                end
                            end
                            Wait(0)
                        end
                    end)
                else
                    insideUseZone = false
                    ClearAllHelpMessages()
                end
            end
        end)
    end)
end


-- wird nur in qb-clothing:client:adjustfacewear verwendet
-- was das macht weiß ich nicht :(
local function loadAnimDict(dict)
     while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-- wird nicht in diesem Skript verwendet aber vielleicht in anderen?
-- hier kann wahrscheinlich die Maske an-/ausgezogen werden
RegisterNetEvent("qb-clothing:client:adjustfacewear", function(type)
    if QBCore.Functions.GetPlayerData().metadata["ishandcuffed"] then return end
    removeWear = not removeWear
    local AnimSet = "mp_masks@on_foot"
    local AnimationOn = "put_on_mask"
    local AnimationOff = "put_on_mask"
    local PropIndex = 0

    faceProps[6]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 0)
    faceProps[6]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 0)
    faceProps[6]["Texture"] = GetPedTextureVariation(PlayerPedId(), 0)

    for i = 0, 3 do
        if GetPedPropIndex(PlayerPedId(), i) ~= -1 then
            faceProps[i+1]["Prop"] = GetPedPropIndex(PlayerPedId(), i)
        end
        if GetPedPropTextureIndex(PlayerPedId(), i) ~= -1 then
            faceProps[i+1]["Texture"] = GetPedPropTextureIndex(PlayerPedId(), i)
        end
    end

    if GetPedDrawableVariation(PlayerPedId(), 1) ~= -1 then
        faceProps[4]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 1)
        faceProps[4]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 1)
        faceProps[4]["Texture"] = GetPedTextureVariation(PlayerPedId(), 1)
    end

    if GetPedDrawableVariation(PlayerPedId(), 11) ~= -1 then
        faceProps[5]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 11)
        faceProps[5]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 11)
        faceProps[5]["Texture"] = GetPedTextureVariation(PlayerPedId(), 11)
    end

    if type == 1 then
        PropIndex = 0
    elseif type == 2 then
        PropIndex = 1

        AnimSet = "clothingspecs"
        AnimationOn = "take_off"
        AnimationOff = "take_off"

    elseif type == 3 then
        PropIndex = 2
    elseif type == 4 then
        PropIndex = 1
        if removeWear then
            AnimSet = "missfbi4"
            AnimationOn = "takeoff_mask"
            AnimationOff = "takeoff_mask"
        end
    elseif type == 5 then
        PropIndex = 11
        AnimSet = "oddjobs@basejump@ig_15"
        AnimationOn = "puton_parachute"
        AnimationOff = "puton_parachute"
    end

    loadAnimDict( AnimSet )
    if type == 5 then
        if removeWear then
            SetPedComponentVariation(PlayerPedId(), 3, 2, faceProps[6]["Texture"], faceProps[6]["Palette"])
        end
    end
    if removeWear then
        TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        Citizen.Wait(500)
        if type ~= 5 then
            if type == 4 then
                SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
            else
                if type ~= 2 then
                    ClearPedProp(PlayerPedId(), tonumber(PropIndex))
                end
            end
        end
    else
        TaskPlayAnim( PlayerPedId(), AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        Citizen.Wait(500)
        if type ~= 5 and type ~= 2 then
            if type == 4 then
                SetPedComponentVariation(PlayerPedId(), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
            else
                SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
            end
        end
    end
    if type == 5 then
        if not removeWear then
            SetPedComponentVariation(PlayerPedId(), 3, 1, faceProps[6]["Texture"], faceProps[6]["Palette"])
            SetPedComponentVariation(PlayerPedId(), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
        else
            SetPedComponentVariation(PlayerPedId(), PropIndex, -1, -1, -1)
        end
        Citizen.Wait(1800)
    end
    if type == 2 then
        Citizen.Wait(600)
        if removeWear then
            ClearPedProp(PlayerPedId(), tonumber(PropIndex))
        end

        if not removeWear then
            Citizen.Wait(140)
            SetPedPropIndex( PlayerPedId(), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
        end
    end
    if type == 4 and removeWear then
        Citizen.Wait(1200)
    end
    ClearPedTasks(PlayerPedId())
end)