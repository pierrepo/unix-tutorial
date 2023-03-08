# Connexion au Juptyer Hub de l'IFB

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
- Patientez quelques secondes, le temps qu'une nouvelle session soit créées sur le Jupyter Hub de l'IFB.
- Une fois dans l'interface Jupyter Hub, dans la page *Launcher* qui est en face de vous, cliquez sur l'icône *Terminal* en bas à gauche.
