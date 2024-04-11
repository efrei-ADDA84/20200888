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
docker run --env LAT="31.2504" --env LONG="-99.2506" --env API_KEY=**** weatherapp
```
<br/>

Tag et Upload vers DockerHub: 
```bash
docker tag weatherapp jzhg02/weatherapp_devops_efrei-adda84:v1
docker push jzhg02/weatherapp_devops_efrei-adda84:v1
```
Pull image:
```bash
docker pull jzhg02/weatherapp_devops_efrei-adda84
```

Lien du [Docker image](https://hub.docker.com/r/jzhg02/weatherapp_devops_efrei-adda84).
