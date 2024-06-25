-- Kreaturen-Modellierung in einem Fantasy-Spiel

-- Definition der Klasse Creature (Basis-Klasse)
local Creature = {}

function Creature:new(name)
    local newObj = { name = name, health = 100 }
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Creature:getName()
    return self.name
end

function Creature:getHealth()
    return self.health
end

function Creature:takeDamage(amount)
    self.health = self.health - amount
    if self.health < 0 then
        self.health = 0
    end
    print(self.name .. " took " .. amount .. " damage. Health: " .. self.health)
end

-- Definition der Klasse Humanoid (Unterklasse von Creature)
local Humanoid = {}
setmetatable(Humanoid, { __index = Creature })

function Humanoid:new(name, weapon)
    local newObj = Creature.new(self, name)
    newObj.weapon = weapon or "Fists"  -- Standardwert setzen, wenn keine Waffe übergeben wird
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Humanoid:getWeapon()
    return self.weapon
end

function Humanoid:attack(target)
    local damage = math.random(10, 20)
    target:takeDamage(damage)
    print(self.name .. " attacks " .. target:getName() .. " with " .. self.weapon .. " for " .. damage .. " damage.")
end

-- Definition der Klasse Spellcaster (Unterklasse von Creature)
local Spellcaster = {}
setmetatable(Spellcaster, { __index = Creature })

function Spellcaster:new(name, spell)
    local newObj = Creature.new(self, name)
    newObj.spell = spell or "Fireball"  -- Standardwert setzen, wenn kein Zauber übergeben wird
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Spellcaster:getSpell()
    return self.spell
end

function Spellcaster:castSpell(target)
    local damage = math.random(15, 30)
    target:takeDamage(damage)
    print(self.name .. " casts " .. self.spell .. " on " .. target:getName() .. " for " .. damage .. " damage.")
end

-- Definition der Klasse Wizard (Mehrfachvererbung von Humanoid und Spellcaster)
local Wizard = {}
setmetatable(Wizard, { __index = Humanoid })

function Wizard:new(name, weapon, spell)
    local newObj = Humanoid.new(self, name, weapon)
    newObj.spell = spell or "Fireball"  -- Standardwert setzen, wenn kein Zauber übergeben wird
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Wizard:getSpell()
    return self.spell
end

function Wizard:castSpell(target)
    local damage = math.random(15, 30)
    target:takeDamage(damage)
    print(self.name .. " casts " .. self.spell .. " on " .. target:getName() .. " for " .. damage .. " damage.")
end

-- Hauptprogramm
function main()
    print("Creating characters...")
    local warrior = Humanoid:new("Warrior", "Sword")
    local mage = Spellcaster:new("Mage", "Fireball")
    local wizard = Wizard:new("Gandalf", "Staff", "Lightning Bolt")

    -- Debugging-Ausgabe, um sicherzustellen, dass die Variablen gesetzt sind
    print("Debugging: Warrior - Name: " .. warrior:getName() .. ", Weapon: " .. warrior:getWeapon() .. ", Health: " .. warrior:getHealth())
    print("Debugging: Mage - Name: " .. mage:getName() .. ", Spell: " .. mage:getSpell() .. ", Health: " .. mage:getHealth())
    print("Debugging: Wizard - Name: " .. wizard:getName() .. ", Weapon: " .. wizard:getWeapon() .. ", Spell: " .. wizard:getSpell() .. ", Health: " .. wizard:getHealth())

    -- Ausgabe der Charaktere für die Schlacht
    print("\nCharacters ready for battle:")
    print("Warrior - Weapon: " .. warrior:getWeapon() .. ", Health: " .. warrior:getHealth())
    print("Mage - Spell: " .. mage:getSpell() .. ", Health: " .. mage:getHealth())
    print("Wizard - Weapon: " .. wizard:getWeapon() .. ", Spell: " .. wizard:getSpell() .. ", Health: " .. wizard:getHealth())

    -- Beginn der Schlacht
    print("\nBattle starts...")
    warrior:attack(mage)
    mage:castSpell(wizard)
    wizard:attack(warrior)
end

-- Starte das Hauptprogramm
main()

return { Creature = Creature, Humanoid = Humanoid, Spellcaster = Spellcaster, Wizard = Wizard }
