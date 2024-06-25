-- Bank Account Management System in Lua

-- Definiere eine Tabelle für Bankkonten
local bank = {}

-- Funktion zum Erstellen eines neuen Kontos
function createAccount(ownerName, initialBalance)
    local account = {
        owner = ownerName,
        balance = initialBalance,
        transactions = {}
    }
    
    -- Metatable für das Konto definieren
    local mt = {
        __index = {
            deposit = function(self, amount)
                if amount > 0 then
                    self.balance = self.balance + amount
                    table.insert(self.transactions, { type = "deposit", amount = amount })
                else
                    error("Deposit amount must be positive")
                end
            end,
            
            withdraw = function(self, amount)
                if amount > 0 and amount <= self.balance then
                    self.balance = self.balance - amount
                    table.insert(self.transactions, { type = "withdrawal", amount = amount })
                else
                    error("Invalid withdrawal amount")
                end
            end,
            
            getBalance = function(self)
                return self.balance
            end,
            
            getTransactions = function(self)
                return self.transactions
            end
        }
    }
    
    setmetatable(account, mt)
    return account
end

-- Beispielanwendung des Bankkontosystems
local account1 = createAccount("Alice", 1000)
local account2 = createAccount("Bob", 500)

print("Initial balances:")
print("Alice's balance:", account1:getBalance())
print("Bob's balance:", account2:getBalance())

-- Alice führt einige Transaktionen durch
account1:deposit(500)
account1:withdraw(200)

-- Bob führt eine Transaktion durch
account2:withdraw(100)

-- Ausgabe der aktuellen Kontostände und Transaktionen
print("\nCurrent balances:")
print("Alice's balance:", account1:getBalance())
print("Bob's balance:", account2:getBalance())

print("\nAlice's transactions:")
for _, transaction in ipairs(account1:getTransactions()) do
    print(transaction.type, transaction.amount)
end

print("\nBob's transactions:")
for _, transaction in ipairs(account2:getTransactions()) do
    print(transaction.type, transaction.amount)
end
