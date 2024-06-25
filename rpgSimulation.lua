-- RPG-Simulation in Lua

-- Modul für Kreaturen
local Creature = {}

function Creature:new(name, health, attackPower)
    local newObj = { name = name, health = health, attackPower = attackPower }
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

function Creature:heal(amount)
    self.health = self.health + amount
    print(self.name .. " heals for " .. amount .. ". Health: " .. self.health)
end

function Creature:attack(target)
    print(self.name .. " attacks " .. target:getName() .. " for " .. self.attackPower .. " damage.")
    target:takeDamage(self.attackPower)
end

-- Modul für Humanoide
local Humanoid = {}
setmetatable(Humanoid, { __index = Creature })

function Humanoid:new(name, health, attackPower, weapon)
    local newObj = Creature.new(self, name, health, attackPower)
    newObj.weapon = weapon or "Fists"
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Humanoid:getWeapon()
    return self.weapon
end

function Humanoid:attack(target)
    local damage = self.attackPower
    print(self.name .. " attacks " .. target:getName() .. " with " .. self.weapon .. " for " .. damage .. " damage.")
    target:takeDamage(damage)
end

-- Modul für Zauberer
local Spellcaster = {}
setmetatable(Spellcaster, { __index = Creature })

function Spellcaster:new(name, health, attackPower, spell)
    local newObj = Creature.new(self, name, health, attackPower)
    newObj.spell = spell or "Magic Missile"
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Spellcaster:getSpell()
    return self.spell
end

function Spellcaster:castSpell(target)
    local damage = self.attackPower * 1.5
    print(self.name .. " casts " .. self.spell .. " on " .. target:getName() .. " for " .. damage .. " damage.")
    target:takeDamage(damage)
end

-- Modul für Krieger
local Warrior = {}
setmetatable(Warrior, { __index = Humanoid })

function Warrior:new(name, health, attackPower, weapon)
    return Humanoid.new(self, name, health, attackPower, weapon)
end

-- Modul für Magier
local Mage = {}
setmetatable(Mage, { __index = Spellcaster })

function Mage:new(name, health, attackPower, spell)
    return Spellcaster.new(self, name, health, attackPower, spell)
end

-- Modul für Inventar
local Inventory = {}

function Inventory:new()
    local newObj = { items = {} }
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Inventory:addItem(item)
    table.insert(self.items, item)
    print(item .. " added to inventory.")
end

function Inventory:removeItem(item)
    for i, v in ipairs(self.items) do
        if v == item then
            table.remove(self.items, i)
            print(item .. " removed from inventory.")
            return true
        end
    end
    print(item .. " not found in inventory.")
    return false
end

function Inventory:listItems()
    print("Inventory:")
    for i, item in ipairs(self.items) do
        print(i .. ". " .. item)
    end
end

-- Modul für Quests
local Quest = {}

function Quest:new(name, description, reward)
    local newObj = { name = name, description = description, reward = reward, completed = false }
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Quest:complete()
    self.completed = true
    print("Quest '" .. self.name .. "' completed! Reward: " .. self.reward)
end

-- Hauptspielmodul
local Game = {}

function Game:new()
    local newObj = {
        player = nil,
        inventory = Inventory:new(),
        quests = {},
        enemies = {}
    }
    setmetatable(newObj, self)
    self.__index = self
    return newObj
end

function Game:start()
    print("Welcome to the RPG game!")
    
    -- Spielercharakter erstellen
    self:createCharacter()

    -- Beispielquest erstellen
    local quest = Quest:new("Defeat Morgana", "Defeat the evil mage Morgana and save the kingdom.", "100 Gold")
    table.insert(self.quests, quest)

    -- Beispielgegner erstellen
    local enemy = Mage:new("Morgana", 80, 12, "Fireball")
    table.insert(self.enemies, enemy)

    -- Inventar mit Heiltränken füllen
    self.inventory:addItem("Health Potion")
    self.inventory:addItem("Health Potion")
    self.inventory:addItem("Mana Potion")

    -- Hauptspielschleife
    while true do
        self:showMenu()
        local choice = tonumber(io.read())
        if choice == 1 then
            self:showStats()
        elseif choice == 2 then
            self:manageInventory()
        elseif choice == 3 then
            self:showQuests()
        elseif choice == 4 then
            self:startBattle()
        elseif choice == 5 then
            print("Exiting game. Goodbye!")
            break
        else
            print("Invalid choice. Please try again.")
        end
    end
end

function Game:createCharacter()
    print("Enter your character's name:")
    local name = io.read()
    print("Choose your class: 1. Warrior 2. Mage")
    local classChoice = tonumber(io.read())
    if classChoice == 1 then
        self.player = Warrior:new(name, 100, 15, "Sword")
    elseif classChoice == 2 then
        self.player = Mage:new(name, 80, 12, "Fireball")
    else
        print("Invalid choice, defaulting to Warrior.")
        self.player = Warrior:new(name, 100, 15, "Sword")
    end
    print("Character created: " .. self.player:getName() .. ", Class: " .. (classChoice == 2 and "Mage" or "Warrior"))
end

function Game:showMenu()
    print("\nMain Menu:")
    print("1. Show Stats")
    print("2. Manage Inventory")
    print("3. Show Quests")
    print("4. Start Battle")
    print("5. Exit")
    io.write("Choose an option: ")
end

function Game:showStats()
    print("\nPlayer Stats:")
    print("Name: " .. self.player:getName())
    print("Health: " .. self.player:getHealth())
    if getmetatable(self.player) == Warrior then
        print("Weapon: " .. self.player:getWeapon())
    elseif getmetatable(self.player) == Mage then
        print("Spell: " .. self.player:getSpell())
    end
end

function Game:manageInventory()
    while true do
        print("\nInventory Menu:")
        print("1. Add Item")
        print("2. Remove Item")
        print("3. List Items")
        print("4. Back to Main Menu")
        io.write("Choose an option: ")
        local choice = tonumber(io.read())
        if choice == 1 then
            io.write("Enter item to add: ")
            local item = io.read()
            self.inventory:addItem(item)
        elseif choice == 2 then
            io.write("Enter item to remove: ")
            local item = io.read()
            self.inventory:removeItem(item)
        elseif choice == 3 then
            self.inventory:listItems()
        elseif choice == 4 then
            break
        else
            print("Invalid choice. Please try again.")
        end
    end
end

function Game:showQuests()
    print("\nActive Quests:")
    for _, q in ipairs(self.quests) do
        print(q.name .. ": " .. q.description .. (q.completed and " (Completed)" or ""))
    end
end

function Game:startBattle()
    if #self.enemies == 0 then
        print("No enemies to fight!")
        return
    end

    local enemy = self.enemies[1] -- Nehmen wir an, es gibt nur einen Feind für diesen Kampf

    print("\nBattle with " .. enemy:getName() .. " begins!")
    while self.player:getHealth() > 0 and enemy:getHealth() > 0 do
        print("\nChoose your action: 1. Attack 2. Use Inventory")
        local action = tonumber(io.read())
        if action == 1 then
            self.player:attack(enemy)
            if enemy:getHealth() > 0 then
                enemy:castSpell(self.player)
            end
        elseif action == 2 then
            self:useInventoryInBattle()
        else
            print("Invalid action. Skipping turn.")
        end
    end

    if self.player:getHealth() > 0 then
        print("You defeated " .. enemy:getName() .. "!")
        table.remove(self.enemies, 1)
        for _, quest in ipairs(self.quests) do
            if not quest.completed and quest.name == "Defeat Morgana" then
                quest:complete()
                self.inventory:addItem(quest.reward)
            end
        end
    else
        print("You were defeated by " .. enemy:getName() .. "...")
    end
end

function Game:useInventoryInBattle()
    self.inventory:listItems()
    io.write("Enter item number to use: ")
    local itemIndex = tonumber(io.read())
    local item = self.inventory.items[itemIndex]
    if item == "Health Potion" then
        self.player:heal(20)
        self.inventory:removeItem("Health Potion")
    elseif item == "Mana Potion" then
        print("Mana Potion used. (Effect not implemented yet)")
        self.inventory:removeItem("Mana Potion")
    else
        print("Invalid item or no item used.")
    end
end

-- Spiel starten
local game = Game:new()
game:start()
