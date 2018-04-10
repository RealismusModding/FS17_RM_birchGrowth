----------------------------------------------------------------------------------------------------
-- BIRCH GROWTH MANAGER
----------------------------------------------------------------------------------------------------
-- Purpose: To randomly plance growing birch trees
-- Author:  reallogger
--
-- Copyright (c) Realismus Modding, 2018
----------------------------------------------------------------------------------------------------

birchGrowthManager= {}
birchGrowthManager.TREE_LIMIT = 1000
birchGrowthManager.TREES_PER_HOUR = 1   -- for vanilla
birchGrowthManager.TREE_PER_YEAR = 300     -- for Seasons

local modItem = ModsUtil.findModItemByModName(g_currentModName)
birchGrowthManager.modDir = g_currentModDirectory

function birchGrowthManager:loadMap()
    g_currentMission.environment:addMinuteChangeListener(self)

    self.enabled = true
    
    self.plantingTime = math.floor(Utils.clamp(60 / self.TREES_PER_HOUR, 1, 12 * 60))

end

function birchGrowthManager:load()
end

function birchGrowthManager:save()
end

function birchGrowthManager:minuteChanged()
    local minuteInDay = g_currentMission.environment.currentMinute + g_currentMission.environment.currentHour * 60

    if g_seasons ~= nil then
        self.plantingTime = math.floor(Utils.clamp(3 * g_seasons.environment.daysInSeason * 24 * 60 / self.TREE_PER_YEAR, 1, 12 * 60))
    end

    if math.fmod(minuteInDay, self.plantingTime) == 0 and table.getn(g_currentMission.plantedTrees.growingTrees) < self.TREE_LIMIT then
        if g_seasons ~= nil then
            if g_seasons.environment:currentSeason() ~= g_seasons.environment.SEASON_WINTER then
                self:plantOneTree()
            end
        else
            self:plantOneTree()
        end
    end
end

function birchGrowthManager:plantOneTree()
    local size = g_currentMission.terrainSize
    local x = (math.random() - 0.5) * size
    local z = (math.random() - 0.5) * size
    
    local dx = 5
    local dz = 5
    
    local grassId = g_currentMission.fruits[FruitUtil.FRUITTYPE_GRASS].id
    local _, grassArea , _ = getDensityParallelogram(
        grassId,
        x-dx/2, z-dz/2, dx, 0, 0, dz,
        0, g_currentMission.numFruitStateChannels)
    
    local forestGrassId = getTerrainDetailByName(g_currentMission.terrainRootNode, "forestGrassDark")
    local forestGrassDensity, forestGrassArea
    if forestGrassId ~= nil and forestGrassId ~= 0 then
        forestGrassDensity, forestGrassArea , _ = getDensityParallelogram(
            forestGrassId,
            x-dx/2, z-dz/2, dx, 0, 0, dz,
            0, 1)
    end
    
    local y = getTerrainHeightAtWorldPos(g_currentMission.terrainRootNode,x,0,z)
    local densityBits = getDensityAtWorldPos(g_currentMission.terrainDetailId, x, y, z)
    
    if (grassArea > 115 and densityBits == 0) or forestGrassDensity > 100 then
        local yRot = math.random() * 2*math.pi
        TreePlantUtil.plantTree(g_currentMission.plantedTrees, TreePlantUtil.TREETYPE_TREEBIRCH, x,y,z, 0,yRot,0, 0)
        
        logInfo("Planted tree at: ",x,z)
    end
end

function birchGrowthManager:bgLoadTreeNode(superFunc, treesData, treeData, x, y, z, rx, ry, rz, growthStateI, splitShapeFileId)
    local treeId, splitShapeFileId = superFunc(self, treesData, treeData, x, y, z, rx, ry, rz, growthStateI, splitShapeFileId)

    g_seasons.replaceVisual:updateTextures(treeId)
    
    return treeId, splitShapeFileId
end

function birchGrowthManager:update(dt)
end

function birchGrowthManager:deleteMap()
end

function birchGrowthManager:keyEvent(unicode, sym, modifier, isDown)
end

function birchGrowthManager:mouseEvent(posX, posY, isDown, isUp, button)
end

function birchGrowthManager:draw()
--local x, y, z = localToWorld(g_currentMission.player.cameraNode, 0, 0, 0.5)
--renderText(0.44, 0.78, 0.01, "player at: " .. tostring(x) .. "," .. tostring(z))

--local id = getTerrainDetailByName(g_currentMission.terrainRootNode, "forestGrassDark")
--id = getChild(g_currentMission.terrainRootNode, "forestGrassDark")
--local densityBits = getDensityAtWorldPos(g_currentMission.terrainDetailId, x, y, z)
--renderText(0.44, 0.76, 0.01, "area: " .. tostring(densityBits))
end

function logInfo(...)
    local str = "[Birch Weed]"
    for i = 1, select("#", ...) do
        str = str .. " " .. tostring(select(i, ...))
    end
    print(str)
end

function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    pos = tostring(pos)
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

TreePlantUtil.loadTreeNode = Utils.overwrittenFunction(TreePlantUtil.loadTreeNode , birchGrowthManager.bgLoadTreeNode)
addModEventListener(birchGrowthManager)
