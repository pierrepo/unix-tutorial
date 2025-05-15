# Introduction et contexte

Dans le tutoriel précédent :

- Vous avez reproduit la méthodologie publiée dans l'article [*Investigating Conservation of the Cell-Cycle-Regulated Transcriptional Program in the Fungal Pathogen, Cryptococcus neoformans*](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1006453) (Kelliher *et al.*, PLOS Genetics, 2016) pour analyser des données RNA-seq de *Saccharomyces cerevisiae*.
- Vous avez utilisé un script (`script_local_2.sh`) pour accélérer le fonctionnement des logiciels `star` et `cuffquant` en utilisant plusieurs processeurs.
- Enfin vous avez utilisé un autre script (`script_local_3.sh`) pour automatiser l'analyse **successive** de plusieurs fichiers de données RNA-seq *.fastq.gz*.

L'objectif de ce tutoriel est d'utiliser toute la puissance d'un cluster de calcul pour analyser **simultanément** plusieurs jeux de données RNA-seq en ayant à disposition plusieurs milliers de processeurs.

```{note}
Dans ce tutoriel, les termes « processeur » (ou *Central Processing Unit*, CPU), « cœur » (*core*) et « *thread* » seront equivalents. C'est une approximation. Un processeur est un composant électronique qui est branché sur une carte mère et qui peut contenir plusieurs cœurs qui eux-mêmes peuvent avoir plusieurs *threads*.
```

## Prérequis

- Posséder un compte sur le cluster de calcul de l'IFB.
- Avoir réalisé le tutoriel [Introduction à Unix](../tuto1/tutorial.md).
- Avoir réalisé le tutoriel [Analyse RNA-seq avec Unix](../tuto2/0_intro.md).


## Configuration du JupyterLab

 Depuis le <a href="https://ondemand.cluster.france-bioinformatique.fr/" target="_blank">portail Open OnDemand</a> de l'IFB, lancez l'application JupyterLab avec les paramètres suivants :
 
- Reservation: `No reservation` 
- Account: `2501_duo` ⚠️
- Partition: `fast`
- Number of CPUs: `2` ⚠️
- Amount of memory: `2G` ⚠️
- GPUs: `No GPU`
- Number of hours: `8` ⚠️

```{warning}
La configuration demandée pour cette session est différente de celle demandée la dernière fois. Soyez particulièrement attentif aux paramètres *Number of CPUs* et *Amount of memory*.

Vous remarquerez que nous utilisons cette fois apparemment peu de processeurs et de mémoire vive.
```

## Analyse de données RNA-seq avec un cluster de calcul

1. [Automatiser l'analyse RNA-seq avec un cluster](1_automatiser.md)
1. [Compter les heures de calculs, surveiller les jobs et récupérer les résultats](2_compter_surveiller_recuperer.md)
1. [Automatiser encore plus avec Snakemake](3_automatiser_snakemake.md)
