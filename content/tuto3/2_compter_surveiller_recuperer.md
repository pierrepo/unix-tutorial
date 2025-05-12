# Compter ⏲ les heures, surveiller 📬 les jobs et récupérer 📥 les résultats

```{contents}
```

## Compter les heures de calcul consommées

Expérimentez la commande `sreport` pour avoir une idée du temps de calcul consommé par tous vos jobs :

```bash
$ sreport -t hour Cluster UserUtilizationByAccount Start=2025-01-01 End=$(date --iso-8601)T23:59:59 Users=$USER
```

La colonne `Used` indique le nombre d'heures CPU consommées. Cette valeur est utile pour estimer le « coût CPU » d'un projet.

Voici un exemple de rapport produit par `sreport` :

```bash
$ sreport -t hour Cluster UserUtilizationByAccount Start=2025-01-01 End=$(date --iso-8601)T23:59:59 Users=$USER
--------------------------------------------------------------------------------
Cluster/User/Account Utilization 2025-01-01T00:00:00 - 2025-05-12T09:59:59 (11350800 secs)
Usage reported in CPU Hours
--------------------------------------------------------------------------------
  Cluster     Login     Proper Name         Account     Used   Energy 
--------- --------- --------------- --------------- -------- -------- 
     core  ppoulain  Pierre Poulain        2501_duo      252        0 
     core  ppoulain  Pierre Poulain      202304_duo       16        0 
     core  ppoulain  Pierre Poulain          gonseq        8        0
```

Ainsi, l'utilisateur `ppoulain` a déjà consommé 252 heures CPU sur le projet `2501_duo`.

```{warning}
`sreport` ne prend pas en compte les heures immédiatement consommées. Il lui faut quelques minutes pour consolider les données.
```

Il est également possible de connaître la consommation CPU pour un projet en particulier et par utilisateur :

```bash
$ sreport -t hour Cluster AccountUtilizationByUser Start=2025-01-01 End=$(date --iso-8601)T23:59:59 Accounts=2501_duo
--------------------------------------------------------------------------------
Cluster/Account/User Utilization 2025-01-01T00:00:00 - 2025-05-12T09:59:59 (11350800 secs)
Usage reported in CPU Hours
--------------------------------------------------------------------------------
  Cluster         Account     Login     Proper Name     Used   Energy 
--------- --------------- --------- --------------- -------- -------- 
     core        2501_duo                               3549        0 
     core        2501_duo  acoudert  Amelie Coudert      245        0 
     core        2501_duo    alebre AnneSophie Leb+       85        0 
     core        2501_duo cdoncarli Caroline Donca+      395        0 
     core        2501_duo cdroilla+ Clement Droill+       88        0 
     core        2501_duo   dlesage    Denis Lesage      158        0 
     core        2501_duo flevavas+ Francoise Leva+      351        0 
     core        2501_duo glelanda+ Gaëlle Leland+      369        0 
     core        2501_duo gruprich+ Gwenael Rupric+      262        0 
     core        2501_duo jcouturi+ Jeanne Couturi+      250        0 
     core        2501_duo   labjean  Laurene Abjean      194        0 
     core        2501_duo    mehmig    Muriel Ehmig      201        0 
     core        2501_duo mnascime+ Megane Nascime+      249        0 
     core        2501_duo  ppoulain  Pierre Poulain      252        0 
     core        2501_duo   rsantos   Renata Santos       82        0 
     core        2501_duo salawabdh  Sana Al Awabdh      179        0 
     core        2501_duo tpetersen  Tania Petersen      190        0
```

Au 12/05/2025, un total de 3549 heures de calcul a déjà été consommé sur le projet `2501_duo` ⏱️.


## Surveiller les jobs

L'analyse RNA-seq présentée ici tourne en 20-25', c'est relativement rapide, car le génome de *S. cerevisiae* est petit (environ 12 Mb). Les temps d'analyse seront plus longs avec des génomes plus gros.

Procédez toujours par itérations successives. Testez votre script d'analyse RNA-seq pour 1 échantillon, puis 3, puis la totalité.

Quand vous lancez un job qui sera potentiellement long, n'hésitez pas à ajouter les directives ci-dessous au début de votre script avec les autres instructions `#SBATCH` :

```
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=votre-adresse-mail@email.fr
```

Vous recevrez alors automatiquement un e-mail lorsque le job se termine ou si celui-ci plante.

Sur le cluster IFB :

- Un utilisateur ne peut utiliser plus de 300 coeurs en même temps.
- Un job dure, par défaut, au maximum 12 h. Une queue plus longue (appelée `long`) est disponible pour des jobs qui durent jusqu'à 30 jours et est utilisable via la directive `#SBATCH --partition=long` en début de script. D'autres queues plus spécifiques (plus de temps, beaucoup de mémoire vive, GPU) sont disponibles sur demande.

Prenez le temps d'explorer la [documentation très complète](https://ifb-elixirfr.gitlab.io/cluster/doc/) sur le cluster. Vous y trouverez notamment un [tutoriel](https://ifb-elixirfr.gitlab.io/cluster/doc/tutorials/analysis_slurm/) sur une autre analyse RNA-seq.


## Récupérer les résultats

Pour récupérer vos résultats et les transférer depuis le cluster de calcul vers votre machine locale, il y a 3 possibilités.


### Avec l'explorateur de fichiers de JupyterLab

Si les fichiers que vous souhaitez récupérer sont peu nombreux et peu volumineux (quelques Mo maximum), alors vous pouvez directement utiliser l'explorateur de fichiers de JupyterLab (panneau de gauche). Cliquez-droit sur un fichier puis sélectionnez *Download*.


### Avec FileZilla

```{admonition} Rappel
L'utilisation de FileZilla avait déjà été abordée dans le tutoriel sur les [formats et échange de données en biologie](https://cupnet.net/formats-echanges-donnees-biologie/)
```

Lancez le logiciel FileZilla. Puis entrez les informations suivantes :

- Hôte : `sftp://core.cluster.france-bioinformatique.fr`
- Identifiant : votre login sur le cluster
- Mot de passe : votre mot de passe sur le cluster

Cliquez ensuite sur le bouton *Connexion rapide*. Cliquez sur *OK* dans la fenêtre *Clé de l'hôte inconnue*

Une fois connecté :

- Dans le champ texte à côté de *Site local* (à gauche de la fenêtre), choisissez le répertoire local (sur votre machine) dans lequel vous souhaitez copier les fichiers.
- Dans le champ texte à côté de *Site distant* (à droite de la fenêtre), entrez le chemin `/shared/projects/2501_duo/LOGIN/rnaseq` (avec `LOGIN` votre identifiant sur le cluster).

Essayez de transférer des fichiers dans un sens puis dans l'autre. Double-cliquez sur les fichiers pour lancer les transferts.

### Avec scp

```{warning}
Uniquement si vous avez un Mac ou un Linux ou une machine sous Windows avec WSL.
```

Depuis un shell Unix sur une machine locale, déplacez-vous dans un répertoire dans lequel vous souhaitez copier les fichiers.

Lancez ensuite la commande suivante pour récupérer les fichiers de comptage :

```bash
$ scp LOGIN@core.cluster.france-bioinformatique.fr:/shared/projects/2501_duo/LOGIN/rnaseq/counts/genes.count_table .
```

où `LOGIN` est votre identifiant sur le cluster (qui apparait deux fois dans la ligne de commande ci-dessus). Faites bien attention à garder le `.` à la fin de la ligne de commande.

Entrez votre mot de passe du cluster en aveugle.

Pour récupérer directement le répertoire `counts` sur le cluster, vous auriez pu utiliser la commande :

```bash
$ scp -r LOGIN@core.cluster.france-bioinformatique.fr:/shared/projects/2501_duo/LOGIN/rnaseq/counts .
```

Notez l'option `-r` qui indique qu'on transfère un répertoire.
