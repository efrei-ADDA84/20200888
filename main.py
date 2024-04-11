import os
import requests
from dotenv import load_dotenv

load_dotenv()

lat = os.getenv("LAT")
long = os.getenv("LONG")
apikey = os.getenv("API_KEY")


def make_api_call(latitude, longitude, api_key):
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}"
    try:
        response = requests.get(url)
        response.raise_for_status() 
        return response.json()
    except requests.exceptions.HTTPError as err:
        raise SystemExit(err)


def extract_weather(data):
    try:
        weather = data['weather'][0]['main']
        return weather
    except KeyError as err:
        raise SystemExit(err)


def main():
    data = make_api_call(lat, long, apikey)
    weather = extract_weather(data)
    print(f"The weather at position [{lat}, {long}] is {weather}")


if __name__ == "__main__":
    main()



