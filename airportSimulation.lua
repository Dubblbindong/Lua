-- Flughafen-Simulation in Lua

-- Modul für Flugzeug- und Passagierverwaltung
local AirportSimulation = {}

-- Flugzeugdatenbank
AirportSimulation.airplanes = {
    { id = 1, model = "Boeing 747", capacity = 400, status = "grounded" },
    { id = 2, model = "Airbus A380", capacity = 550, status = "grounded" },
    { id = 3, model = "Boeing 787", capacity = 300, status = "grounded" }
}

-- Passagierdatenbank
AirportSimulation.passengers = {}

-- Funktion zur Anzeige der verfügbaren Flugzeuge
function AirportSimulation.displayAirplanes()
    print("=== Available Airplanes ===")
    for _, airplane in ipairs(AirportSimulation.airplanes) do
        print(airplane.id .. ". " .. airplane.model .. " - Capacity: " .. airplane.capacity .. " - Status: " .. airplane.status)
    end
    print("==========================")
end

-- Funktion zum Buchen eines Fluges für einen Passagier
function AirportSimulation.bookFlight(passengerId, airplaneId)
    local passenger = AirportSimulation.findPassengerById(passengerId)
    local airplane = AirportSimulation.findAirplaneById(airplaneId)

    if passenger and airplane then
        table.insert(passenger.flights, { airplaneId = airplane.id, model = airplane.model })
        print("Flight booked for Passenger ID " .. passengerId .. " on " .. airplane.model)
    else
        print("Passenger or Airplane not found.")
    end
end

-- Funktion zum Finden eines Passagiers anhand der ID
function AirportSimulation.findPassengerById(id)
    for _, passenger in ipairs(AirportSimulation.passengers) do
        if passenger.id == id then
            return passenger
        end
    end
    return nil
end

-- Funktion zum Finden eines Flugzeugs anhand der ID
function AirportSimulation.findAirplaneById(id)
    for _, airplane in ipairs(AirportSimulation.airplanes) do
        if airplane.id == id then
            return airplane
        end
    end
    return nil
end

-- Hauptprogramm
function main()
    print("Welcome to Airport Simulation!")

    -- Beispiel Passagiere hinzufügen
    table.insert(AirportSimulation.passengers, { id = 1, name = "John Doe", flights = {} })
    table.insert(AirportSimulation.passengers, { id = 2, name = "Jane Smith", flights = {} })
    table.insert(AirportSimulation.passengers, { id = 3, name = "Jeffrey Henry", flights = {}})
    table.insert(AirportSimulation.passengers, { id = 4, name = "Teletubby", flights = {}})
    table.insert(AirportSimulation.passengers, { id = 5, name = "Donald Duck", flights = {}})


    AirportSimulation.displayAirplanes()

    -- Beispiel Flugbuchung
    AirportSimulation.bookFlight(1, 1)
    AirportSimulation.bookFlight(2, 2)
    AirportSimulation.bookFlight(3, 3)
    AirportSimulation.bookFlight(4, 3)
    AirportSimulation.bookFlight(5, 3)


    -- Ausgabe der gebuchten Flüge
    print("\n=== Booked Flights ===")
    for _, passenger in ipairs(AirportSimulation.passengers) do
        print(passenger.name .. "'s Flights:")
        for _, flight in ipairs(passenger.flights) do
            print("- " .. flight.model)
        end
    end
    print("=======================")
end

-- Starte das Hauptprogramm
main()

return AirportSimulation
