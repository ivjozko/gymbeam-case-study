import requests
import pandas as pd

# API endpoint pre mestské knižnice
API_URL = "https://api.golemio.cz/v2/libraries"

def fetch_libraries():
    response = requests.get(API_URL, headers=headers)
    if response.status_code == 200:
        data = response.json()["_items"]
        libraries = []

        for lib in data:
            lib_info = {
                "library_id": lib.get("id"),
                "name": lib.get("name"),
                "street": lib.get("address", {}).get("street", ""),
                "postal_code": lib.get("address", {}).get("postal_code", ""),
                "city": lib.get("address", {}).get("city", ""),
                "region": lib.get("address", {}).get("region", ""),
                "country": lib.get("address", {}).get("country", ""),
                "latitude": lib.get("location", {}).get("latitude"),
                "longitude": lib.get("location", {}).get("longitude"),
                "opening_hours": lib.get("opening_hours", "")
            }
            libraries.append(lib_info)

        df = pd.DataFrame(libraries)
        df.to_csv("golemio_libraries.csv", index=False)
        print("Data saved to golemio_libraries.csv")
    else:
        print(f"Failed to fetch data: {response.status_code}")

if __name__ == "__main__":
    fetch_libraries()
