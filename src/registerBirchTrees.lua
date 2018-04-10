----------------------------------------------------------------------------------------------------
-- REGISTER SPRUCE TREES
----------------------------------------------------------------------------------------------------
-- Purpose: To register growing birch trees
-- Author:  reallogger
--
-- Copyright (c) Realismus Modding, 2017
----------------------------------------------------------------------------------------------------

registerBirchTrees = {}

local modItem = ModsUtil.findModItemByModName(g_currentModName)
registerBirchTrees.modDir = g_currentModDirectory

function registerBirchTrees:loadMap()
    local treeFilenames = {
        registerBirchTrees.modDir .. "resources/birch_stage1.i3d",
        registerBirchTrees.modDir .. "resources/birch_stage2.i3d",
        registerBirchTrees.modDir .. "resources/birch_stage3.i3d",
        registerBirchTrees.modDir .. "resources/birch_stage4.i3d",
        registerBirchTrees.modDir .. "resources/birch_stage5.i3d"
    }

    TreePlantUtil.registerTreeType("treeBirch", "Birch tree", treeFilenames, 300)
end

function registerBirchTrees:load()
end

function registerBirchTrees:deleteMap()
end

function registerBirchTrees:keyEvent(unicode, sym, modifier, isDown)
end

function registerBirchTrees:mouseEvent(posX, posY, isDown, isUp, button)
end

function registerBirchTrees:update(dt)
end

function registerBirchTrees:draw()
end

addModEventListener(registerBirchTrees)
