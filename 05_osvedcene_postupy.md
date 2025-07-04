# Úloha 5 – Hodnotenie osvedčených postupov

### 1. Používanie hardcoded hodnôt v ETL procesoch pre biznis pravidlá

* Nie je osvedčený postup.
* Mení sa ťažko, zmena si vyžaduje úpravu kódu.
* Odporúčam použiť konfiguračné tabuľky alebo parametre.
* V DataCamp projekte sme pri tvorbe klasifikátora nastavovali prahy ako premenné, nie pevne v kóde, čo zjednodušilo ladenie.

---

### 2. Neindexovanie stĺpcov, ktoré sú často dotazované vo veľkých tabuľkách

* Nie je osvedčený postup.
* Vedie k pomalým dopytom.
* V BigQuery alebo SQL odporúčam `CLUSTER BY`, resp. v iných DBMS indexy.
* Pri EDA som pozoroval spomalenie dopytov pri filtrovaní bez indexov, najmä pri väčších CSV.

---

### 3. Ukladanie logov a záloh na rovnaký server ako produkčná databáza

* Nie je osvedčený postup.
* Zaplnenie disku môže znefunkčniť produkčnú DB.
* Odporúčam šifrovaný cloud storage (napr. GCS/S3).
* Čítal som viacero incident reportov, kde zlyhanie log rotácie ovplyvnilo produkciu.

---

### 4. Používanie zdieľaných servisných účtov na pripojenie k databázam v ETL nástrojoch

* Nie je osvedčený postup.
* Nemožnosť auditovať, častý výskyt bezpečnostných dier.
* Každý užívateľ by mal mať osobný prístup alebo dedikovaný service account.
* V enterprise systémoch je auditovateľnosť kľúcová.

---

### 5. Budovanie dátových kanálov bez implementácie mechanizmov na opakovanie alebo zotavenie pri zlyhaní

* Nie je osvedčený postup.
* Dočasné chyby môžu padnúť celú pipeline.
* Odporúčam retry logiku (napr. 3x pokus, exponential backoff).
* V Data Science som riešil podobne batch scraping s retry mechanizmom pre nestabilné API.

---

### 6. Povoľovanie priameho prístupu ku zdrojovým dátam všetkým členom tímu bez kontroly prístupu.

* Nie je osvedčený postup.
* Riziko chýb, zneužitia a neporiadku.
* RBAC (role-based access control) alebo view-only prístup.
* V DataCamp sme mali read-only prístup k datasetom, čo zabezpečilo konzistentnosť.

---

### 7. Vynechanie validácie schémy pri načítavaní externých dát

* Nie je osvedčený postup.
* Prichádzajúce CSV môže mať iné stĺpce alebo datové typy ako očakávame.
* Validácia cez `pandas.dtypes` alebo schema registry.
* V EDA som robil kontrolu stĺpcov a typov pred merge.

---

### 8. Používanie zastaraných ETL procesov bez pravidelných revízií optimalizácie

* Nie je osvedčený postup.
* Zvyšuje zložitosť a chybovosť.
* Revízia transformácií raz za kvartál.
  Učili sme sa o "data debt" ktoré vznikajú dočasnými/zastaralými riešeniami a o potrebe pipeline refactoring. Myslím, že v data science je niečo podobné ako napríklad zefektívnenie kódu alebo odstránenie starého kódu z EDA.

---

### 9. Nepremazanie alebo neodstránenie zastaraných tabuliek a pohľadov z dátového skladu.

* Nie je osvedčený postup.
* Zmätok, zbytočný storage, nesprávne reporty.
* Označovať ako `deprecated`, neskôr mazať.

---

### 10. Nenastavenie upozornení na zlyhané úlohy alebo oneskorenia kanálov.

* Nie je osvedčený postup.
* Tiché chyby s veľkými dôsledkami.
* E-mail alert, Slack notifikácie, monitoring.

---

### 11. Ukladanie citlivých údajov bez šifrovania pri ukladaní alebo prenose.

* Nie je osvedčený postup.
* Porušenie GDPR, ISO noriem.
* Šifrovať pri prenose aj uložení, použiť hashovanie.

---

### 12. Ignorovanie obmedzení dátových typov pri vytváraní schém v dátovom sklade.

* Nie je osvedčený postup.
* Môže viesť k truncation, overflow, zlým výpočtom.
* Presne definovať typy: `INT64`, `NUMERIC`, `DATE`
* V modeli som zistil, že typ `object` z pandas spôsobil chybu v regresii – musel byť prevedený.

---

### 13. Povoľovanie kruhových závislostí medzi ETL úlohami.

* Nie je osvedčený postup.
* Môžu spôsobiť deadlock alebo reštartovacie smyčky.
* Použiť DAG (acyklický graf) kde každá úloha má jasný smer a nikdy sa nevracia späť.

---

### 14. Vykonávanie transformácií priamo na produkčných databázach namiesto staging vrstiev.

* Nie je osvedčený postup.
* Vysoké riziko chyby a spomalenia systému. Produkcia môže padnúť.
* Odporúčam staging vrstvu čo je dočasná, izolovaná databázová oblasť.

---

### 15. Výber dátového modelu (napr. hviezdica vs. snehová vločka) bez zohľadnenia použitia.

* Nie je osvedčený postup.
* Vedie k neefektívnym dotazom.
* Star schema pre reporting, snowflake pre detailné analýzy.
* V GymBeam úłohe som vedome zvolil hviezdicovú schému kvôli jednoduchosti BI dopytov.

---

### 16. Používanie VARCHAR(MAX) ako predvoleného dátového typu pre textové polia.

* Nie je osvedčený postup.
* Plytvanie pamäťou, horší výkon.
* Nastaviť rozumný limit, napr. `VARCHAR(100)`.
* V pandas som raz mal extrémne dlhé reťazce, ktoré spôsobili problém pri exporte do .parquet

---

### 17. Pridávanie všetkých stĺpcov zo zdrojového systému do dátového skladu bez ohľadu na ich relevantnosť.

* Nie je osvedčený postup.
* Zbytočné dáta, zložitejšie dotazy.
* Selektovať len hodnotné stĺpce.
* V EDA som najprv urobil `df.describe()` a dropol stĺpce, ktoré mali len NaN alebo len jednu hodnotu.

---

### 18. Vynechanie partitioningu alebo clusteringu pre veľké faktové tabuľky.

* Nie je osvedčený postup.
* Spomaľuje veľké dopyty.
* Použiť `PARTITION BY` napr. dátum, `CLUSTER BY` ID.

---

### 19. Vývoj a nasadenie zmien v pipeline bez verzovania alebo testovania.

* Nie je osvedčený postup.
* Rizikové, bez verzie nevieme čo sa zmenilo, bez testovania neviem či to funguje.
* Continuous integration alebo continuous deployment, verzovanie cez Git aby sme mali historiu zmien a možnosť návratu späť.
  
