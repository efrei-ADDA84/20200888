# 20200888
Repo de Jacques ZHANG

<h1>TP1</h1>

Objectif: Wrapper renseignant la condition météorologique de la position donnée par les coordonnées (latitude, longitude) dans les variables d'environnement. <br/> Utilisation de l'API de OpenWeather. <br/> 

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

Objectif: Création du Github Actions Workflow directement depuis GitHub. 
J'ai set up un workflow en partant d'un fichier yml vierge. J'ai pris les lignes/configurations nécessaires pour chaque action en browsant le Marketplace. 
Le plus dure a été de comprendre comment fonctionne un yml puisque j'en ai jamais set up un auparavant. <br/>
Il y a 1 job push-and-build avec 3 actions: 
- Lint du dockerfile
- Login vers le dockerhub 
- build-and-push du docker image. 

J'ai transformé le wrapper en API directement sur le main.py en utilisant FastAPI. 

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

<h1>TP3</h1>

Objectif: Push l'image sur Azure Container Registry et puis vers un Container Instances en utilisant les secrets à disposition. 
J'ai rajouté 4 jobs supplémentaires : 
- Login vers l'ACR
- Build and push de l'image vers l'ACR
- Login vers l'Azure CLI
- Déploiement vers une ACI.

Vu que les secrets étaient déjà mis au niveau de l'organisation, je n'ai juste eu à ajouter mon API_KEY en tant que secret. 

Au début, j'ai eu des difficultés à call l'API. En lisant le JSON de mon container instance, j'ai remarqué que le port exposé était 80 alors que je l'expose au port 8081 sur mon Dockerfile. Donc j'ai dû le rajouter dans mon yml lors du déploiement du container. 
Et bien sûr, il faudrait call l'API au port 8081. 

Pour call l'API: 
```bash
curl "http://devops-20200888.francecentral.azurecontainer.io:8081/?lat=5.902785&lon=102.754175"
```

<h1>TP4</h1>

Le TP4 est disponible dans le dossier TP4-Terraform 

Si vous n'êtes pas dans le dossier TP4-Terraform:
```bash
cd .\TP4-Terraform\
```

Objectif: Créer une machine virtuelle Azure (VM) avec une adresse IP publique dans un réseau existant en utilisant Terraform et se connecter à la VM avec SSH

4 fichiers tf ont été créés : 
- provider.tf
    - azurerm
    - tls

azurerm pour gérer les ressources Azure et tls pour la génération de la clef SSH

- variables.tf
    - location
    - azure_subscription_id
    - azure_resource_group_name
    - network_name
    - subnet
    - azure_vm_name
    - user_admin

Ce sont principalement les contraintes qui reviennent, donc je les ai mis en variables afin d'éviter la duplication de code (Bonus 2)

- main.tf
    - data "azurerm_resource_group"
    - data "azurerm_virtual_network"
    - data "azurerm_subnet"
    - resource "azurerm_public_ip"
    - resource "azurerm_network_interface"
    - resource "tls_private_key"
    - resource "azurerm_linux_virtual_machine"

Nous avons 3 data et 4 ressources dans ce fichier. Les data sont les ressource group, virtual network et subnet qui sont données. Pour faire marcher notre projet, nous avons besoin d'une addresse ip publique, d'une network interface et de la machine virtuelle, sans oublier la ressource pour générer la clef SSH. 

- outputs.tf
    - resource_group_name
    - public_ip_address
    - private_key

La private key est masquée et donc nous utiliserons une commande pour l'output vers un fichier id_rsa.

Vérifions que les fichiers tf sont bien formatés (Bonus 3): 
```bash
terraform fmt -recursive
```

Login Azure CLI: 
```bash
az login
```

Initialisation:
```bash
terraform init -upgrade
```

Définition du plan: 
```bash
terraform plan -out=tfplan
```

Application du plan: 
```bash
terraform apply "tfplan"
```
Toutes les ressources devraient être créées. Les 3 outputs devraient apparaître sur le terminal. 

Commande pour output la clef SSH privé vers un fichier nommé id_rsa, et l'addresse ip publique vers un fichier vm_ip_address: 
```bash
terraform output -raw private_key > id_rsa; terraform output -raw public_ip_address > vm_ip_address
```

Pour tester la connexion et afficher /etc/os-release
```bash
ssh -i id_rsa devops@$(<vm_ip_address) cat /etc/os-release
```
On devrait obtenir quelque chose de similaire à ca: 
```bash
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.4 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

Supression des fichiers id_rsa et vm_ip_address: 
```bash
rm id_rsa vm_ip_address
```

Afin de supprimer toutes nos ressources: 
```bash
terraform destroy
```

Difficultés rencontrées: 
- Il était plus difficile pour moi de me documenter sur le sujet. Je me principalement reposé sur la documentation de [Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) et celle de [Microsoft](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli) parmi d'autres. 
- La génération de la clef SSH a été la partie la plus "compliquée" notamment parce que je n'arrivais pas à trouver de documentation sur comment l'implémenter correctement. Mais également parce que je suis sur Windows et j'ai un terminal Windows/PowerShell. Et lors de la copie de la clef privé vers un fichier (id_rsa par exemple), j'obtenais l'erreur: 
```bash
Load key "id_rsa": invalid format
devops@{PUBLILC_IP_ADDRESS}: Permission denied (publickey).
```
En switchant vers un terminal bash, la copie de la clef marchait correctement et la connexion était établie. 

<h1>Conclusion</h1>

Ces 4 TPs ont été très fructueux. Le TP1 a permis de faire quelques rappels sur Docker et de me faire découvrir la possiblité de pouvoir push des images sur le DockerHub. Dans le TP2 et 3, j'ai pu apprendre à utiliser Github Actions qui est un outil très utile pour l'automatisation de tâches. Il aurait été à mon avis plus intéressant de rajouter aussi une petite partie de tests automatiques. Le TP4 m'a permis d'approfondir mes connaissances sur Azure et de me faire découvrir Terraform, une technologie que je n'ai jamais touché mais dont j'en ai déjàentendu parler, donc je suis très enthousiaste à l'idée de l'explorer davantage dans mes futurs projets. 
