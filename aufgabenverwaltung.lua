-- Aufgabenverwaltungssystem in Lua

-- Aufgabenklasse
Task = {}
Task.__index = Task

function Task:new(title, description, priority, dueDate)
    local task = {
        id = os.time(),
        title = title,
        description = description,
        priority = priority,
        dueDate = dueDate,
        status = "offen"
    }
    setmetatable(task, Task)
    return task
end

function Task:getDetails()
    return string.format("ID: %d\nTitel: %s\nBeschreibung: %s\nPriorität: %s\nFällig am: %s\nStatus: %s",
        self.id, self.title, self.description, self.priority, self.dueDate, self.status)
end

-- Aufgabenverwaltungsklasse
TaskManager = {}
TaskManager.__index = TaskManager

function TaskManager:new()
    local manager = {
        tasks = {}
    }
    setmetatable(manager, TaskManager)
    return manager
end

function TaskManager:addTask(task)
    table.insert(self.tasks, task)
    print("Aufgabe hinzugefügt:")
    print(task:getDetails())
end

function TaskManager:removeTask(id)
    for i, task in ipairs(self.tasks) do
        if task.id == id then
            table.remove(self.tasks, i)
            print("Aufgabe mit ID " .. id .. " entfernt.")
            return
        end
    end
    print("Aufgabe mit ID " .. id .. " nicht gefunden.")
end

function TaskManager:updateTask(id, title, description, priority, dueDate, status)
    for _, task in ipairs(self.tasks) do
        if task.id == id then
            task.title = title or task.title
            task.description = description or task.description
            task.priority = priority or task.priority
            task.dueDate = dueDate or task.dueDate
            task.status = status or task.status
            print("Aufgabe aktualisiert:")
            print(task:getDetails())
            return
        end
    end
    print("Aufgabe mit ID " .. id .. " nicht gefunden.")
end

function TaskManager:listTasks()
    if #self.tasks == 0 then
        print("Keine Aufgaben vorhanden.")
        return
    end
    for _, task in ipairs(self.tasks) do
        print(task:getDetails())
        print("--------------------------")
    end
end

-- Initialisiere die Aufgabenverwaltung
manager = TaskManager:new()

-- Eingabeverarbeitung
while true do
    print("\nBefehle: add, remove, update, list, quit")
    io.write("> ")
    local input = io.read()
    local command, argument = input:match("^(%S*)%s*(.-)$")
    
    if command == "add" then
        print("Titel:")
        local title = io.read()
        print("Beschreibung:")
        local description = io.read()
        print("Priorität (hoch, mittel, niedrig):")
        local priority = io.read()
        print("Fälligkeitsdatum (YYYY-MM-DD):")
        local dueDate = io.read()
        local task = Task:new(title, description, priority, dueDate)
        manager:addTask(task)
    elseif command == "remove" then
        print("Aufgaben-ID:")
        local id = tonumber(io.read())
        manager:removeTask(id)
    elseif command == "update" then
        print("Aufgaben-ID:")
        local id = tonumber(io.read())
        print("Neuer Titel (leer lassen, um nicht zu ändern):")
        local title = io.read()
        print("Neue Beschreibung (leer lassen, um nicht zu ändern):")
        local description = io.read()
        print("Neue Priorität (hoch, mittel, niedrig; leer lassen, um nicht zu ändern):")
        local priority = io.read()
        print("Neues Fälligkeitsdatum (YYYY-MM-DD; leer lassen, um nicht zu ändern):")
        local dueDate = io.read()
        print("Neuer Status (offen, erledigt; leer lassen, um nicht zu ändern):")
        local status = io.read()
        manager:updateTask(id, title ~= "" and title or nil, description ~= "" and description or nil, priority ~= "" and priority or nil, dueDate ~= "" and dueDate or nil, status ~= "" and status or nil)
    elseif command == "list" then
        manager:listTasks()
    elseif command == "quit" then
        print("Programm beendet.")
        break
    else
        print("Unbekannter Befehl: " .. command)
    end
end