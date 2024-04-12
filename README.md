# 20200888
Repo de Jacques ZHANG

<h1>TP1</h1>

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

<h1>TP2</h1>

Création du Github Actions Workflow directement depuis GitHub. 
J'ai set up un workflow en partant d'un fichier yml vierge. J'ai pris les lignes/configurations nécessaires pour chaque action en browsant le Marketplace. 
Le plus dure a été de compdrendre comment fonctionne un yml puisque j'en ai jamais set up un auparavant. 

J'ai transformé le wrapper en API directement sur le main.py 

Re-création de l'image: 
```bash
docker build -t weatherapp .
```
Run l'API en utilisant l'image: 
```bash
docker run -p 8081:8081 --env API_KEY=**** weatherapp
```
Call l'API dans un autre terminal: 
```bash
curl "http://localhost:8081/?lat=5.902785&lon=102.754175"
```
