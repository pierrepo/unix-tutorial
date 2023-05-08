# Automatiser l'analyse RNA-seq avec un cluster 🚀

```{contents}
```

## Découvrir le cluster

Un cluster de calcul met à disposition de ses utilisateurs des processeurs et de la mémoire vive pour réaliser des calculs. Ces ressouces sont réparties sur plusieurs machines, appelées *nœuds de calcul*. Chaque nœud de calcul contient plusieurs dizaines de processeurs (ou coeurs) et plusieurs centaines de Go de mémoire vive.

Plusieurs utilisateurs utilisent simultanément un cluster de calcul. Pour vous en rendre compte, dans JupyterLab, ouvrez un terminal puis entrez la commande suivante qui va lister tous les calculs (appelés *job*) en cours sur le cluster :

```bash
$ squeue -t RUNNING
```

```{admonition} Rappel
:class: tip
Ne tapez pas le caractère `$` en début de ligne et faites bien attention aux majuscules et au minuscules.
```

Vous voyez que vous n'êtes pas seul ! Comptez maintenant le nombre de jobs en cours d'exécution en chaînant la commande précédente avec `wc -l` :

```bash
$ squeue -t RUNNING | wc -l
```

Vous pouvez aussi compter le nombre de jobs en attente d'exécution :

```bash
$ squeue -t PENDING | wc -l
```


Et vous alors ? Avez-vous lancé un calcul ? Vérifiez-le en entrant la commande suivante qui va lister les calculs en cours pour votre compte :

```bash
$ squeue -u $USER
```

Bizarre ! Vous avez un job en cours d'exécution alors que vous n'avez a priori rien lancé 🤔

En fait, le JupyterLab dans lequel vous êtes est lui-même un job en cours d'exécution sur le cluster. C'est d'ailleurs pour cela qu'avant de lancer JupyterLab, vous avez dû préciser le compte à utiliser (`202304_duo`) et choisir le nombre de processeurs et la quantité de mémoire vive dont vous aviez besoin.

