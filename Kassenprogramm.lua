-- Kassenprogramm-Simulation mit Menüauswahl in Lua

-- Definiere eine Tabelle für Produkte mit ihren Preisen
local products = {
    { id = 1, name = "Apple", price = 1.25 },
    { id = 2, name = "Banana", price = 0.75 },
    { id = 3, name = "Orange", price = 1.00 },
    { id = 4, name = "Grapes", price = 2.50 }
}

-- Funktion zur Anzeige des Produktkatalogs
function displayCatalog()
    print("=== Product Catalog ===")
    for _, product in ipairs(products) do
        print(product.id .. ". " .. product.name .. " - $" .. product.price)
    end
    print("======================")
end

-- Funktion zur Durchführung des Verkaufs
function processSale()
    local cart = {}
    local totalAmount = 0

    print("\nStarting a new sale...")
    displayCatalog()

    while true do
        print("\nEnter product ID to add to cart (0 to finish): ")
        local input = io.read()
        local productId = tonumber(input)

        if productId == 0 then
            break
        end

        local product = findProductById(productId)
        if product then
            table.insert(cart, product)
            totalAmount = totalAmount + product.price
            print("Added " .. product.name .. " to cart.")
        else
            print("Invalid product ID. Please try again.")
        end
    end

    -- Print receipt
    print("\n=== Receipt ===")
    for _, product in ipairs(cart) do
        print(product.name .. " - $" .. product.price)
    end
    print("Total: $" .. totalAmount)
    print("==============")
end

-- Hilfsfunktion zur Suche nach einem Produkt anhand der ID
function findProductById(id)
    for _, product in ipairs(products) do
        if product.id == id then
            return product
        end
    end
    return nil
end

-- Hauptprogramm
print("Welcome to the Simple Cash Register Program!")

while true do
    print("\nChoose an option:")
    print("1. Start a new sale")
    print("2. Exit")

    io.write("Enter your choice: ")
    local choice = io.read()

    if choice == "1" then
        processSale()
    elseif choice == "2" then
        print("Thank you for using the program. Goodbye!")
        break
    else
        print("Invalid choice. Please try again.")
    end
end
