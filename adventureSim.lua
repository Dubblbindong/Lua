-- Erweiterte Adventure Simulation in Lua

-- Raumklasse
Room = {}
Room.__index = Room

function Room:new(name, description)
    local room = {
        name = name,
        description = description,
        items = {},
        connections = {},
        npcs = {}
    }
    setmetatable(room, Room)
    return room
end

function Room:addItem(item)
    table.insert(self.items, item)
end

function Room:addNPC(npc)
    table.insert(self.npcs, npc)
end

function Room:connectRoom(room, direction)
    self.connections[direction] = room
end

function Room:getDescription()
    local desc = self.description .. "\n"
    if #self.items > 0 then
        desc = desc .. "Du siehst: "
        for i, item in ipairs(self.items) do
            desc = desc .. item .. " "
        end
        desc = desc .. "\n"
    end
    if #self.npcs > 0 then
        desc = desc .. "NPCs hier: "
        for i, npc in ipairs(self.npcs) do
            desc = desc .. npc.name .. " "
        end
        desc = desc .. "\n"
    end
    return desc
end

-- NPC-Klasse
NPC = {}
NPC.__index = NPC

function NPC:new(name, dialogue)
    local npc = {
        name = name,
        dialogue = dialogue,
        inventory = {}
    }
    setmetatable(npc, NPC)
    return npc
end

function NPC:addItem(item)
    table.insert(self.inventory, item)
end

function NPC:getDialogue()
    return self.dialogue
end

-- Spielklasse
Game = {}
Game.__index = Game

function Game:new(startRoom)
    local game = {
        currentRoom = startRoom,
        inventory = {},
        health = 100
    }
    setmetatable(game, Game)
    return game
end

function Game:move(direction)
    if self.currentRoom.connections[direction] then
        self.currentRoom = self.currentRoom.connections[direction]
        print("Du gehst " .. direction)
        self:describe()
    else
        print("Du kannst nicht in diese Richtung gehen.")
    end
end

function Game:describe()
    print(self.currentRoom:getDescription())
end

function Game:takeItem(item)
    for i, roomItem in ipairs(self.currentRoom.items) do
        if roomItem == item then
            table.remove(self.currentRoom.items, i)
            table.insert(self.inventory, item)
            print("Du nimmst " .. item)
            return
        end
    end
    print("Dieses Item gibt es hier nicht.")
end

function Game:talkTo(npcName)
    for _, npc in ipairs(self.currentRoom.npcs) do
        if npc.name == npcName then
            print(npc:getDialogue())
            return
        end
    end
    print("Dieser NPC ist nicht hier.")
end

function Game:attack(npcName)
    for i, npc in ipairs(self.currentRoom.npcs) do
        if npc.name == npcName then
            print("Du greifst " .. npcName .. " an!")
            -- Einfache Kampfmechanik
            self.health = self.health - 10
            print("Du verlierst 10 Gesundheit. Aktuelle Gesundheit: " .. self.health)
            table.remove(self.currentRoom.npcs, i)
            return
        end
    end
    print("Dieser NPC ist nicht hier.")
end

-- Initialisiere die Räume
room1 = Room:new("Wohnzimmer", "Du bist im Wohnzimmer. Es ist gemütlich und warm.")
room2 = Room:new("Küche", "Du bist in der Küche. Es riecht nach frischem Essen.")
room3 = Room:new("Schlafzimmer", "Du bist im Schlafzimmer. Es ist ruhig und dunkel.")

-- Verbinde die Räume
room1:connectRoom(room2, "Osten")
room2:connectRoom(room1, "Westen")
room2:connectRoom(room3, "Norden")
room3:connectRoom(room2, "Süden")

-- Füge Items hinzu
room1:addItem("Buch")
room2:addItem("Apfel")
room3:addItem("Schlüssel")

-- Füge NPCs hinzu
npc1 = NPC:new("Hans", "Hallo! Ich bin Hans. Schön dich zu sehen.")
npc2 = NPC:new("Anna", "Hey! Hast du schon den Schlüssel gefunden?")
room1:addNPC(npc1)
room2:addNPC(npc2)

-- Starte das Spiel
game = Game:new(room1)
game:describe()

-- Eingabeverarbeitung
while true do
    io.write("> ")
    local input = io.read()
    local command, argument = input:match("^(%S*)%s*(.-)$")
    
    if command == "gehe" then
        game:move(argument)
    elseif command == "nimm" then
        game:takeItem(argument)
    elseif command == "rede" then
        game:talkTo(argument)
    elseif command == "angriff" then
        game:attack(argument)
    elseif command == "inventar" then
        print("Dein Inventar: " .. table.concat(game.inventory, ", "))
    elseif command == "quit" or command == "exit" then
        print("Spiel beendet.")
        break
    else
        print("Unbekannter Befehl: " .. command)
    end
end