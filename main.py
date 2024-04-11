from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv
import os
import requests

app = FastAPI()

load_dotenv()

def make_api_call(latitude: float, longitude: float, api_key: str):
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}"
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as err:
        raise HTTPException(status_code=400, detail=str(err))

def extract_weather(data):
    try:
        weather = data['weather'][0]['main']
        return weather
    except KeyError as err:
        raise HTTPException(status_code=404, detail="Weather data not found")

# FastAPI route
@app.get("/")
def get_weather(lat: float, lon: float):
    api_key = os.getenv("API_KEY")
    if not api_key:
        raise HTTPException(status_code=500, detail="API key not configured")
    data = make_api_call(lat, lon, api_key)
    weather = extract_weather(data)
    return {"latitude": lat, "longitude": lon, "weather": weather}
