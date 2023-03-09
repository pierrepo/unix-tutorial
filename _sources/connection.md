# Connexion au JupyterHub de l'IFB

- Cliquez sur le lien suivant <a href="https://jupyterhub.cluster.france-bioinformatique.fr/" target="_blank">https://jupyterhub.cluster.france-bioinformatique.fr/</a> qui va s'ouvrir dans un nouvel onglet de votre navigateur internet.
- Utilisez vos identifiants du cluster IFB pour vous connecter.
- Dans la page *Server Options*, choisissez ensuite les paramètres suivants :
    - Reservation: `No reservation` 
    - Account: `202304_duo` (ce paramètre est très important, vérifiez qu'il est correct)
    - Partition: `fast`
    - CPU(s): `1`
    - Memory (in GB): `2GB`
    - GPU(s): `0` `No GRES`

    Cliquez ensuite sur le bouton *Start*
- Patientez quelques secondes, le temps qu'une nouvelle session soit créée sur le JupyterHub de l'IFB.
- Une fois dans l'interface JupyterLab, dans la page *Launcher* qui est en face de vous, cliquez sur l'icône *Terminal* en bas à gauche pour lancer un terminal.


```{note}
Les paramètres de mémoire et de CPU pourront être différents d'une séance à l'autre, suivant le type d'analyse que nous aurons à réaliser.
```

Voici une illustration de la connexion au JupyterHub de l'IFB ainsi que les premiers pas dans l'interface JupyterLab :

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/LIUKSxrPBnc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

