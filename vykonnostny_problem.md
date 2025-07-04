# Úloha 4 – Výkonnostný problém v SQL transformácii

## Problém

Kolega nasadil SQL transformáciu do produkcie. Spočiatku fungovala rýchlo (napr. 1 hodina), no s pribúdajúcimi dňami sa čas spracovania predlžoval – až na takmer 3 hodiny denne. Na grafe je vidieť rastúci trend.

## Možné príčiny


1. **Rast objemu vstupných dát**
   - Transformácia zrejme spracúva celú historickú tabuľku (full load), nie len nové prírastky.

2. **Chýbajúca particionácia alebo clustering v BigQuery**
   - Pri veľkých dátach môže absencia `PARTITION BY` a `CLUSTER BY` spôsobiť pomalé čítanie dát.

3. **Zložité výrazy v transformácii**
   - Používanie `REGEXP_CONTAINS`, `CASE`, `SAFE_CAST` alebo `JOIN` nad celou tabuľkou môže výrazne spomaliť výpočty.

---

## Odporúčané riešenia

| Problém                        | Riešenie                                                                 |
|-------------------------------|--------------------------------------------------------------------------|
| Full load pri každom spustení | Implementovať **inkrementálne spracovanie** – spracuj len nové dáta     |
| Pomalé čítanie dát             | Pridať **PARTITION BY dátum** alebo **CLUSTER BY** relevantné stĺpce    |
| Zložité výrazy                 | Presunúť validáciu mimo SQL transformáciu |



