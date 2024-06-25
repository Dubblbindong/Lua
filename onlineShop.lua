-- Modul für den Online-Shop
local OnlineShop = {}

-- Produkte im Shop
OnlineShop.products = {
    { id = 1, name = "T-Shirt", price = 15.99, stock = 10 },
    { id = 2, name = "Jeans", price = 29.99, stock = 5 },
    { id = 3, name = "Sneakers", price = 49.99, stock = 3 },
    { id = 4, name = "Hoodie", price = 24.99, stock = 7 }
}

-- Warenkorb des Benutzers
local cart = {}

-- Funktion zur Anzeige des Produktkatalogs
function OnlineShop.displayCatalog()
    print("=== Welcome to Our Online Shop ===")
    print("Available Products:")
    for _, product in ipairs(OnlineShop.products) do
        print(product.id .. ". " .. product.name .. " - $" .. product.price .. " (" .. product.stock .. " in stock)")
    end
    print("===============================")
end

-- Funktion zum Hinzufügen eines Produkts zum Warenkorb
function OnlineShop.addToCart(productId, quantity)
    local product = OnlineShop.findProductById(productId)
    if product then
        if product.stock >= quantity then
            table.insert(cart, { id = productId, name = product.name, price = product.price, quantity = quantity })
            product.stock = product.stock - quantity
            print("Added " .. quantity .. "x " .. product.name .. " to your cart.")
        else
            print("Insufficient stock for " .. product.name .. ". We have " .. product.stock .. " available.")
        end
    else
        print("Product with ID " .. productId .. " not found.")
    end
end

-- Funktion zum Berechnen des Gesamtpreises im Warenkorb
function OnlineShop.calculateTotal()
    local total = 0
    for _, item in ipairs(cart) do
        total = total + (item.price * item.quantity)
    end
    return total
end

-- Funktion zum Abschließen des Kaufs
function OnlineShop.checkout()
    local total = OnlineShop.calculateTotal()
    if total > 0 then
        print("\n=== Your Cart ===")
        for _, item in ipairs(cart) do
            print(item.quantity .. "x " .. item.name .. " - $" .. (item.price * item.quantity))
        end
        print("Total: $" .. total)
        print("Thank you for shopping with us!")
        -- Reset cart after checkout
        cart = {}
    else
        print("Your cart is empty. Please add some items.")
    end
end

-- Hilfsfunktion zur Suche nach einem Produkt anhand der ID
function OnlineShop.findProductById(id)
    for _, product in ipairs(OnlineShop.products) do
        if product.id == id then
            return product
        end
    end
    return nil
end

-- Hauptprogramm
function main()
    print("Welcome to the Online Shop!")
    OnlineShop.displayCatalog()

    while true do
        print("\nChoose an option:")
        print("1. Add to Cart")
        print("2. View Cart and Checkout")
        print("3. Exit")

        io.write("Enter your choice: ")
        local choice = tonumber(io.read())

        if choice == 1 then
            io.write("Enter product ID: ")
            local productId = tonumber(io.read())
            io.write("Enter quantity: ")
            local quantity = tonumber(io.read())
            OnlineShop.addToCart(productId, quantity)
        elseif choice == 2 then
            OnlineShop.checkout()
        elseif choice == 3 then
            print("Thank you for visiting. Goodbye!")
            break
        else
            print("Invalid choice. Please try again.")
        end
    end
end

-- Starte das Hauptprogramm
main()

return OnlineShop
