# Préparer l'environnement logiciel 🧰

```{contents}
```

## Valider la dimension de votre espace de travail 

Exécutez la commande suivante pour connaitre le nombre de coeurs disponibles : 

```bash
$ echo "${SLURM_CPUS_PER_TASK}"
```

```{admonition} Rappel
:class: tip
Ne tapez pas le caractère `$` en début de ligne et faites bien attention aux majuscules et au minuscules.
```

Vous devriez obtenir `6`, ce qui correspond au nombre de `CPU(S)` demandé lors de [configuration](0_intro.md) de votre environnment JupyterHub/JupyterLab. Si ce n'est pas le cas, sollicitez-moi car vous serez bloqué par la suite.


## Lister les logiciels nécessaires

Le cluster de calcul de l'IFB propose de nombreux logiciels pré-installés. Pour utiliser ces logiciels, il suffit de les charger dans l'environnement de travail avec la commande `module load`.


Nous allons utiliser [SRA Toolkit](https://github.com/ncbi/sra-tools) pour télécharger les données brutes de séquençage.

L'article indique :

> Raw FASTQ files were aligned to the respective yeast genomes using STAR [78]. Aligned reads were assembled into transcripts, quantified, and normalized using Cufflinks2 [79]. Samples from each yeast time series were normalized together using the CuffNorm feature.

Le fichier *S1 Supporting Information Methods* fournit des précisions supplémentaires :

> Raw FASTQ files from each experiment were aligned to the respective yeast reference genome using STAR [1].

> Reads mapping uniquely to annotated gene features were quantified using HTSeq-count [3].

> Transcript quantification of annotated yeast genes was performed using alignment files output from STAR and Cufflinks2 [4]. Time point samples from the respective yeasts were then normalized together using the CuffNorm feature.

En résumé, nous avons besoin d'installer les outils : `STAR`, `HTSeq-count` et `Cufflinks`. Aucune version de logiciel n'étant spécifiée, nous allons installer la dernière version disponible sur le cluster.

Nous installerons également [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) pour contrôler la qualité des *reads*, ainsi que `samtools` qui n'est pas explicitement mentionné dans l'article ni dans les *Supporting Information* mais qui est nécessaire pour trier et indexer les *reads* alignés.

Récapitulons les logiciels nécessaires :

- `sra-tools` : télécharger les données brutes de séquençage.
- `fastqc` : contrôler la qualité des *reads*.
- `star` : aligner les *reads* sur le génome de référence.
- `htseq` : quantifier les *reads* alignés sur les gènes.
- `cufflinks` : compter les transcrits (puis normaliser les comptages).
- `samtools` : trier et indexer les *reads* alignés.


## Vérifier la disponibilité des logiciels

Vérifiez avec la commande `module avail XXX` (avec `XXX` le nom du logiciel) que chacun des logiciels dont vous avez besoin est disponible :

Par exemple pour `sra-tools`, vous devriez obtenir :

```bash
$ module avail sra-tools
--------------------- /shared/software/modulefiles ----------------------
sra-tools/2.10.0  sra-tools/2.10.3  sra-tools/2.11.0
```

Trois versions de `sra-tools` sont disponibles. Par défaut, la commande 


```bash
$ module load sra-tools
```

chargera la dernière version disponible, ici la version `2.11.0`.

Complétez le tableau suivant en indiquant, pour chaque logiciel, la version la plus ancienne (plus petit numéro) et la version la plus récente (plus grand numéro) disponibles sur le cluster de l'IFB :

| Logiciel  | Version la plus ancienne | Version la plus récente |
|-----------|--------------------------|-------------------------|
| sra-tools |                          |                         |
| fastqc    |                          |                         |
| star      |                          |                         |
| htseq     |                          |                         |
| cufflinks |                          |                         |
| samtools  |                          |                         |



```{admonition} Que faire si un logiciel n'est pas disponible ?
:class: tip
Si un outil que vous souhaitez utiliser n'est pas disponible ou pas dans la version souhaitée. Vous pouvez demander gentillement son installation au [support communautaire de l'IFB](https://community.france-bioinformatique.fr/). Pour cela, créez un ticket dans la rubrique « IFB Core Cluster ».

Les administrateurs du cluster sont habituellement très réactifs (voir un [exemple](https://community.france-bioinformatique.fr/t/installation-htseq-0-11-3/1092) de demande de mise-à-jour pour le logiciel htseq).
```

## Charger les logiciels

Chargez les différents logiciels dans votre espace de travail avec la commande `module load` :

```bash
$ module load sra-tools fastqc star htseq cufflinks samtools
```

Affichez maintenant la liste des modules chargés dans votre espace de travail :

```bash
$ module list
Currently Loaded Modulefiles:
 1) sra-tools/2.11.0   3) star/2.7.10b   5) cufflinks/2.2.1  
 2) fastqc/0.11.9      4) htseq/0.13.5   6) samtools/1.15.1  
```

Vérifiez enfin les versions des logiciels en appelant chaque logiciel individuellement. Ette étape est utilise pour vérifier que les versions des logiciels chargés avec `module load` sont bien les versions attendues.

### sra-tools

Si c'est la première fois que vous utilisez `fasterq-dump`, lancez au préalable la commande suivante :

```bash
$ vdb-config --interactive
```
puis tapez sur la touche <kbd>X</kbd>.

Ensuite :
```bash
$ fasterq-dump --version

"fasterq-dump" version 2.11.0
```

### fastqc

```bash
$ fastqc --version
FastQC v0.11.9
```

### STAR
```bash
$ STAR --version
2.7.10b
```

### samtools

```bash
$ samtools --version | head -n 1
samtools 1.15.1
```

### htseq-count

```bash
$ htseq-count --version
0.13.5
```

### cufflinks

```bash
$ cufflinks 2>&1 | head -n 1
cufflinks v2.2.1
```


```{important}
Notez toujours la version des logiciels que vous utilisez pour analyser vos données. C'est une information indispensable pour assurer la **reproductibilité de vos analyses**.
Quand vous publiez vos résultats dans un article, vous **devez** fournir les versions des logiciels que vous avez utilisés pour analyser vos données.
```
