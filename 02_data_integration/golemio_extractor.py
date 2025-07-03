import requests
import pandas as pd

# Golemio API endpoint
API_URL = "https://api.golemio.cz/v2/municipallibraries"
API_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mzc2MSwiaWF0IjoxNzUxNTQyOTg1LCJleHAiOjExNzUxNTQyOTg1LCJpc3MiOiJnb2xlbWlvIiwianRpIjoiMWU0NGQ5NDQtYTQzYy00MTI2LWE1ZDYtYzgzZmVmZjU1ZDUyIn0.CxkfijAba2zdbKcKfRXs78-hFMl7pYT3MkcjJkPYJfg"

headers = {
    "X-Access-Token": API_TOKEN,
    "User-Agent": "gymbeam-case-study",
    "Accept": "application/json"
}

def parse_opening_hours(hours_list):
    if not hours_list or not isinstance(hours_list, list):
        return ""

    # Vyfiltrujem len záznamy is_default = True (bežné otváracie hodiny)
    default_hours = [h for h in hours_list if h.get("is_default")]

    result = []
    for h in default_hours:
        day = h.get("day_of_week", "")[:3]  # napr. "Mon"
        opens = h.get("opens", "")
        closes = h.get("closes", "")
        if opens and closes:
            result.append(f"{day} {opens}–{closes}")
    return " | ".join(result)


def fetch_libraries():
    response = requests.get(API_URL, headers=headers)
    if response.status_code == 200:
        try:
            json_data = response.json()
            features = json_data["features"]

            libraries = []
            for lib in features:
                props = lib.get("properties", {})
                coordinates = lib.get("geometry", {}).get("coordinates", [None, None])

                lib_info = {
                    "library_id": props.get("id"),
                    "name": props.get("name"),
                    "street": props.get("address", {}).get("street_address", ""),
                    "postal_code": props.get("address", {}).get("postal_code", ""),
                    "city": props.get("address", {}).get("address_locality", ""),
                    "region": "", # API tento udaj neposkytuje
                    "country": props.get("address", {}).get("address_country", ""),
                    "latitude": coordinates[1],
                    "longitude": coordinates[0],
                    "opening_hours": parse_opening_hours(props.get("opening_hours", []))
                }
                libraries.append(lib_info)
            


            df = pd.DataFrame(libraries)
            df.to_csv("golemio_libraries.csv", index=False, encoding='utf-8')
            print("Dáta uložené do golemio_libraries.csv")

        except Exception as e:
            print(f"Chyba pri spracovaní dát: {e}")
    else:
        print(f"API požiadavka zlyhala: {response.status_code}")

if __name__ == "__main__":
    fetch_libraries()
