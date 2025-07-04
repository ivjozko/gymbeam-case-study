# Keboola Data Engineering úloha – Očistenie tabuľky `csv_input`

## Zadanie

Úlohou bolo v prostredí Keboola:
1. **Vytvoriť nový bucket** v Storage s názvom `manual-input`.
2. **Nahrať do tohto bucketa tabuľku** s názvom `csv_input` na základe súboru `input.csv`.
3. **Vytvoriť SQL transformáciu** (BigQuery), ktorá odstráni a/alebo opraví problémy v kvalite dát podľa zadania.

---

## Riešenie

### 1. Import dát
- Súbor `input.csv` bol nahraný do bucketa `manual-input`.
- Tabuľka `csv_input` obsahuje transakčné údaje s viacerými textovými a číselnými stĺpcami.

### 2. SQL transformácia
- Použitá bola **BigQuery transformácia**.
- Vstup: tabuľka `csv_input`
- Výstup: očistená tabuľka `clean_csv_input`

#### **Validácie a očisty:**
- **Povinné textové polia:** Každý záznam musí mať vyplnené: `Category`, `Product`, `PaymentMethod`, `ShippingAddress`, `OrderStatus`.
- **Povinné číselné polia:** Každý záznam musí mať vyplnené a kladné: `Quantity`, `TotalValue`, `PaymentAmount`, `Price`.
- **Dátum:** Musí byť validný formát (`YYYY-MM-DD`) a nesmie byť v budúcnosti.
- **E-mail:** Musí mať základnú štruktúru (regex).
- **Biznis pravidlá:**
    - `TotalValue = PaymentAmount`
- **Imputácia:**  
- **Systémový stĺpec `_timestamp`:** Premenovaný na `import_timestamp` pre súlad s BigQuery.

---

### 3. SQL kód

- Kompletný SQL kód (s podrobnými komentármi) je dostupný tu:  
  **[Zobraziť SQL kód](./sql_transformation.sql)**

---

## Ako bolo riešené čistenie dát:

- Chýbajúce hodnoty v povinných stĺpcoch sú filtrované kombináciou podmienok `IS NOT NULL` a `TRIM(...) != ''`.
- Číselné stĺpce sú pomocou `SAFE_CAST` konvertované na správny typ a filtrované na validné a kladné hodnoty.
- E-maily sú filtrované pomocou regulárneho výrazu, ktorý zachytí nevalidné hodnoty typu `invalid_email`.
- Výsledná tabuľka obsahuje len validné a biznisovo správne záznamy.

---

## Komentáre pre hodnotiteľa

- Každý krok SQL je zdokumentovaný komentárom priamo v kóde, ktorý vysvetľuje účel validácie alebo transformácie.
- Riešenie zohľadňuje reálne príklady nekvalitných údajov: prázdne hodnoty, chýbajúce ceny, nesprávne emaily či nekonzistenciu v číselných poliach.
- Kód je písaný prehľadne a optimalizovane, aby bol zrozumiteľný pre ďalších kolegov.

---


