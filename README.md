# GymBeam - Data Engineer Case Study

Toto je moje kompletné riešenie úlohy pre výberové konanie na pozíciu Data Engineer v spoločnosti GymBeam. Riešenie pokrýva 5 zadaní so zameraním na dátové modelovanie, integráciu dát, prácu s Keboola platformou a aplikáciu osvedčených postupov.

---

## [01_data_model](01_data_model)
- **ER diagram** a **Star schema** vytvorené na základe CSV súboru.
- Model pokrýva entitno-relačné vzťahy aj optimalizovanú dátovú štruktúru pre reporting.

## [02_data_integration](02_data_integration)
- **Python skript** na extrakciu dát z Golemio API (knižnice v Prahe).
- CSV výstup obsahuje upravené a štandardizované adresy + otváracie hodiny.
- Súčasťou je návrh denného spúšťania úlohy pre Windows/Linux/macOS.

## [03_manual_input](03_manual_input)
- Nahraný CSV súbor do Keboola Storage.
- **SQL transformácia** na čistenie nekonzistentných údajov: formáty dátumov, e-maily, typy a kategórie.
- Analýza chýb v dátach pomocou Pandas (EDA).

## [04_vykonnostny_problem.md](04_vykonnostny_problem.md)
- Identifikácia príčin zhoršujúcej sa výkonnosti SQL transformácií.
- Praktické odporúčania: inkrementálne spracovanie, limitovanie vstupov, správne používanie indexov, atď.

## [05_osvedcene_postupy.md](05_osvedcene_postupy.md)
- Vyhodnotenie 19 potenciálnych problémov v dátových pipeline.
- Ku každému bodu pridávam vysvetlenie a odporúčané riešenie, vrátane poznámok z praxe (Data Science / ML projekty).

---

## Autor
**Jozef Ivančo**  
GitHub: [@ivjozko](https://github.com/ivjozko)

---

## Poznámka
Projekt je zostavený výhradne pre účely výberového konania. V prípade otázok ma neváhajte kontaktovať.

