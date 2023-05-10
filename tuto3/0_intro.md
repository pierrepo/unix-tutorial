# Introduction et contexte

Dans le tutoriel précédent :

- Vous avez reproduit la méthodologie publié dans l'article [*Investigating Conservation of the Cell-Cycle-Regulated Transcriptional Program in the Fungal Pathogen, Cryptococcus neoformans*](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1006453) (Kelliher *et al.*, PLOS Genetics, 2016) pour analyser des données RNA-seq de *Saccharomyces cerevisiae*.
- Vous avez utilisé un script pour automatiser l'analyse **successive** de plusieurs fichiers de données RNA-seq .fastq.gz.
- Enfin, vous avez accéléré le fonctionnement des logiciels `star` et `cuffquant` en utilisant plusieurs processeurs.

L'objectif de ce tutoriel est d'utiliser toute la puissance d'un cluster de calcul pour analyser **simultanément** plusieurs jeux de données RNA-seq en ayant à disposition plusieurs milliers de processeurs.

## Prérequis

- Posséder un compte sur le cluster de calcul de l'IFB.
- Avoir réalisé le tutoriel [Introduction à Unix](../tuto1/tutorial.md).
- Avoir réalisé le tutoriel [Analyse RNA-seq avec Unix](../tuto2/0_intro.md).

## Configuration du JupyterHub

Connectez-vous au serveur JupyterHub de l'IFB.

Dans la page *Server Options*, choisissez les paramètres suivants :
- Reservation: `No reservation` 
- Account: `202304_duo`  ⚠️
- Partition: `fast`
- CPU(s): `2`  ⚠️
- Memory (in GB): `2`  ⚠️
- GPU(s): `0` `No GRES`

```{warning}
La configuration demandée pour cette session est différente de celle demandée la dernière fois. Soyez particulièrement attentif aux paramètres `Account`, `CPU(s)` et `Memory (in GB)`.

Vous remarquerez que nous utilisons cette fois apparemment peu de processeurs et de mémoire vive.
```

## Analyse de données RNA-seq avec un cluster de calcul

1. [Automatiser l'analyse RNA-seq avec un cluster](1_automatiser.md)
1. [Compter les heures de calculs, surveilles les jobs et récupérer les résultats](2_compter_surveiller_recuperer.md)
1. [Automatiser encore plus avec Snakemake](3_automatiser_encore.md)
