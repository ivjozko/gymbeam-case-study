# Úloha 2 – Golemio API extraktor (mestské knižnice)

Tento skript [golemio_extractor.py](./golemio_extractor.py) sťahuje dáta z otvoreného API Golemio a ukladá ich do CSV súboru [golemio_libraries.csv)](./golemio_libraries.csv).

## Použité technológie:
- Jazyk: **Python 3**
- Knižnice: `requests`, `pandas`
- Zdroj dát: [Golemio API – Municipal Libraries](https://api.golemio.cz/docs/openapi/#/🏠️%20Municipal%20Libraries%20(v2))

## Výstupné údaje

Skript generuje CSV súbor s týmito stĺpcami:

| Stĺpec         | Popis                             |
|----------------|------------------------------------|
| `library_id`   | Interné ID knižnice                |
| `name`         | Názov knižnice                     |
| `street`       | Ulica (z `street_address`)         |
| `postal_code`  | PSČ                                |
| `city`         | Mesto (z `address_locality`)       |
| `region`       | *(prázdne – API ho neposkytuje)*   |
| `country`      | Krajina                            |
| `latitude`     | Zemepisná šírka                    |
| `longitude`    | Zemepisná dĺžka                    |
| `opening_hours`| Otváracie hodiny (iba bežné časy)  |

> 📝 **Poznámka k atribútu `region`:**  
> API Golemio priamo neposkytuje informáciu o regióne pre jednotlivé knižnice.  
> Tento údaj by bolo možné **odvodiť manuálne**, napríklad na základe názvu mesta alebo mestskej časti (`city`) – napr. `"Praha 4"` by sa dalo priradiť k `"Hlavní město Praha"`.  
>  
> Takéto riešenie by si však vyžadovalo:
> - vytvorenie vlastného mapovania všetkých miest / obvodov na príslušné kraje
> - externý dataset a dodatočné spracovanie údajov  
>  
> Z dôvodu rozsahu a zámeru zadania (ktoré nevyžaduje obohatenie údajov) sme sa rozhodli ponechať pole `region` prázdne a túto možnosť len odporučiť ako rozšírenie do budúcnosti.


### Formát otváracích hodín:
Mon 13:00–17:00 | Tue 16:00–20:00 | Wed 15:00–17:00


> Filtrujeme iba hodnoty s `"is_default": true` – teda **štandardné otváracie hodiny**. Výnimočné zmeny (napr. sviatky, výluky) sú vynechané pre jednoduchosť.

---

## ▶️ Spustenie

1. Získaj **API token** z [https://api.golemio.cz/api-keys/dashboard](https://api.golemio.cz/api-keys/dashboard)
2. Vlož token do premennej `API_TOKEN` v skripte
3. Spusti skript:

[Zobraziť zdrojový kód skriptu (golemio_extractor.py)](./golemio_extractor.py)


## Automatizácia spúšťania (Windows 10)
Skript je možné spúšťať automaticky každý deň o 07:00 pomocou Task Scheduler:

Otvor Task Scheduler (Plánovač úloh)

Vytvor novú úlohu: "Create Basic Task..."

Frekvencia: Daily, čas: 07:00

Akcia: Start a program

Program/script: python

Add arguments: C:\cesta\k\tvojmu\golemio_extractor.py

Potvrď a hotovo

✅ Python musí byť v PATH, alebo zadaj plnú cestu k python.exe


## Súbory v priečinku:
golemio_extractor.py – hlavný extraktor

golemio_libraries.csv – výstupný súbor

README.md – táto dokumentácia
