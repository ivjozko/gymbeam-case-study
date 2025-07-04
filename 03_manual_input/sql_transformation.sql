-- Vytvorenie očistenej tabuľky s validovanými a skontrolovanými dátami
CREATE OR REPLACE TABLE clean_csv_input AS
SELECT
-- Zachovávame pôvodné stĺpce, číselné hodnoty konvertujeme do správneho typu
    TransactionID,
    Category,
    Product,
    TransactionDate,
    SAFE_CAST(Quantity AS INT64) as Quantity,			-- Prevádza Quantity na celé číslo
    SAFE_CAST(Price AS FLOAT64) as Price,			-- Prevádza Price na desatinné číslo
    SAFE_CAST(TotalValue AS FLOAT64) as TotalValue,		-- Prevádza TotalValue na desatinné číslo
    CustomerID,
    PaymentMethod,
    ShippingAddress,
    Email,
    OrderStatus,
    DiscountCode,
    SAFE_CAST(PaymentAmount AS FLOAT64) as PaymentAmount,	-- Prevádza PaymentAmount na desatinné číslo
    _timestamp AS import_timestamp				-- Premenujeme systémový stĺpec, aby bol validný v BigQuery
FROM csv_input
WHERE
-- Kontrola povinných textových polí (nesmie byť NULL ani prázdny string)
    Category IS NOT NULL AND Category != '' 
    AND Product IS NOT NULL AND Product != ''
    AND TransactionDate IS NOT NULL
    AND SAFE_CAST(Price AS FLOAT64) IS NOT NULL
    AND PaymentMethod IS NOT NULL AND PaymentMethod != ''
    AND ShippingAddress IS NOT NULL AND ShippingAddress != ''
    AND OrderStatus IS NOT NULL AND OrderStatus != ''
    
    -- Kontrola číselných polí (nesmie byť NULL, záporné alebo nečíselné)
    AND SAFE_CAST(PaymentAmount AS FLOAT64) IS NOT NULL
    AND SAFE_CAST(Quantity AS INT64) IS NOT NULL
    AND SAFE_CAST(Quantity AS INT64) >= 1
    AND SAFE_CAST(Price AS FLOAT64) >= 0
    AND SAFE_CAST(TotalValue AS FLOAT64) >= 0
    
    -- Doplňujúce biznis pravidlá:
    -- 1. TotalValue musí byť presne Quantity * Price
    -- 2. TotalValue musí byť presne rovné PaymentAmount
    AND SAFE_CAST(TotalValue AS FLOAT64) = SAFE_CAST(Quantity AS INT64) * SAFE_CAST(Price AS FLOAT64)
    AND SAFE_CAST(TotalValue AS FLOAT64) = SAFE_CAST(PaymentAmount AS FLOAT64)
    AND SAFE_CAST(PaymentAmount AS FLOAT64) >= 0
    
    -- Kontrola formátu emailu
    AND REGEXP_CONTAINS(Email, r'^[^@]+@[^@]+\.[^@]+$')
    
    -- Kontrola dátumu (platný formát a nesmie byť v budúcnosti)
    AND SAFE.PARSE_DATE('%Y-%m-%d', TransactionDate) IS NOT NULL
    AND SAFE.PARSE_DATE('%Y-%m-%d', TransactionDate) <= CURRENT_DATE()
   

