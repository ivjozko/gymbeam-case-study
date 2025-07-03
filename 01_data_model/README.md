# Dátový model – e-commerce platforma

Tento priečinok obsahuje ER diagram a SQL schému pre zadanie č. 1 (Data Engineer – GymBeam).

## ER Diagram
![ERD](./er_diagram.png)

# Star schema – analytický model predaja

Tento model reprezentuje analytickú dátovú štruktúru určenú na analýzu predajov podľa rôznych dimenzií ako sú čas, produkt, kategória a región zákazníka.

## Prehľad schémy

- `fact_sales`: Hlavná faktová tabuľka obsahujúca transakčné údaje – množstvo, jednotková cena a celková suma.
- `dim_product`: Informácie o produktoch – názov, cena a kategória.
- `dim_category`: Hierarchia produktových kategórií (vrátane nadradených kategórií).
- `dim_customer`: Informácie o zákazníkoch a ich regióne.
- `dim_date`: Časová dimenzia pre analýzu podľa dní, mesiacov, kvartálov a rokov.

## Poznámka k denormalizácii

Pole `category_id` je zahrnuté priamo vo faktovej tabuľke `fact_sales` kvôli výkonnosti – aby nebolo potrebné spájať tabuľky `fact_sales → dim_product → dim_category` pri analytických dotazoch. Ide o zámernú denormalizáciu.

## Diagram

![Star Schema Diagram](./star_schema.png)
