-- Load required libraries
local _G = _G
local Game = Game
local Obj_AI_Hero = Obj_AI_Hero
local math = math
local string = string

-- Load DamageLib library
local DamageLib = require "DamageLib"

-- Calculate damage for each ability
local Qdamage = DamageLib:getdmg("Q", target, myHero)
local Wdamage = DamageLib:getdmg("W", target, myHero)
local Edamage = DamageLib:getdmg("E", target, myHero)
local Rdamage = DamageLib:getdmg("R", target, myHero)

-- Calculate auto attack damage
local AAdamage = DamageLib:GetAADamage(myHero, target)


-- Define Garen as the champion
local myHero = _G.myHero
if myHero.charName ~= "Garen" then return end
-- Define Garen's abilities
local Q = { range = myHero:GetSpellData(_Q).range, delay = myHero:GetSpellData(_Q).delay, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width }
local W = { range = myHero:GetSpellData(_W).range }
local E = { range = myHero:GetSpellData(_E).range }
local R = { range = myHero:GetSpellData(_R).range }

-- Create menu for the script
local menu = MenuElement({type = MENU, id = "GarenScript", name = "Garen Script"})

-- Add menu elements for the abilities
menu:MenuElement({id = "UseQ", name = "Use Q", value = true})
menu:MenuElement({id = "UseW", name = "Use W", value = true})
menu:MenuElement({id = "UseE", name = "Use E", value = true})
menu:MenuElement({id = "UseR", name = "Use R", value = true})
-- Create laneclear submenu
local laneclearMenu = menu:MenuElement({type = MENU, id = "Laneclear", name = "Laneclear Settings"})

-- Add laneclear toggle to submenu
laneclearMenu:MenuElement({id = "Enabled", name = "Enabled", value = true})

-- Callback function to execute laneclear logic
Callback.Add("Tick", function()
  -- Only execute laneclear logic if laneclear toggle is enabled
  if laneclearMenu.Enabled:Value() then
    -- Get minions in range of Q ability
    local minionsQ = GetEnemyMinions(Q.range)
    
    -- Iterate through minions and use Q ability if it will kill them
    for i, minion in ipairs(minionsQ) do
      if Qdamage > minion.health then
        Control.CastSpell(HK_Q, minion)
      end
    end
    
    -- Get minions in range of E ability
    local minionsE = GetEnemyMinions(E.range)
    
    -- Iterate through minions and use E ability if it will kill them
    for i, minion in ipairs(minionsE) do
      if Edamage > minion.health then
        Control.CastSpell(HK_E, minion)
      end
    end
  end
end)
-- Create killsteal submenu
local killstealMenu = menu:MenuElement({type = MENU, id = "Killsteal", name = "Killsteal Settings"})

-- Add killsteal toggle to submenu
killstealMenu:MenuElement({id = "Enabled", name = "Enabled", value = true})

-- Callback function to execute killsteal logic
Callback.Add("Tick", function()
  -- Only execute killsteal logic if killsteal toggle is enabled
  if killstealMenu.Enabled:Value() then
    -- Get enemies in range of R ability
    local enemiesR = GetEnemyHeroes(R.range)
    
    -- Iterate through enemies and use R ability if it will kill them
    for i, enemy in ipairs(enemiesR) do
      if Rdamage > enemy.health then
        Control.CastSpell(HK_R, enemy)
      end
    end
  end
end)
