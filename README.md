# 20200888
Repo de Jacques ZHANG

Wrapper renseignant la condition météorologique de la position donnée par les coordonnées (latitude, longitude) dans les variables d'environnement. <br/> Utilisation de l'API de OpenWeather. <br/> 

Commandes utilisées pour la conteneurisation sur Docker: <br/>

Création de l'image: 
```bash
docker build -t weatherapp .
```
Vérification de la création de l'image: 
```bash
docker images
```
Création et Run le container: 
```bash
docker run --name weather-app weatherapp
```
Simple Run: 
```bash
docker start -i weather-app
```