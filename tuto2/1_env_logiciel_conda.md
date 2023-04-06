# Préparer l'environnement logiciel 🧰

Le cluster de calcul de l'IFB propose de nombreux logiciels pré-installés. Pour utiliser ces logiciels, il suffit de les charger dans l'environnement de travail.

Le premier outil que nous allons utiliser est `conda` qui permet de créer des environnements logiciels. Pour l'utiliser, il faut d'abord le charger :

```bash
module load conda
```

Vérifiez que `conda` est bien installé avec la commande suivante :

```bash
$ conda --version
conda 4.10.1
```

Copiez / collez également ces deux lignes dans votre terminal, puis exécutez-les. Elles vont faciliter l'utilisation de `conda` dans les prochaines étapes.

```
CONDA_ROOT=/shared/software/miniconda/
source $CONDA_ROOT/etc/profile.d/conda.sh
```

## Créer l'environnement conda

Créez un environnement conda :

```bash
conda create -n rnaseq -y
```
et patientez quelques secondes que la commande s'exécute.

Activez ensuite cet environnement :

```bash
conda activate rnaseq
```

## Installer les logiciels nécessaires

Nous allons utiliser [SRA Toolkit](https://github.com/ncbi/sra-tools) pour télécharger les données brutes de séquençage.

L'article indique :

> Raw FASTQ files were aligned to the respective yeast genomes using STAR [78]. Aligned reads were assembled into transcripts, quantified, and normalized using Cufflinks2 [79]. Samples from each yeast time series were normalized together using the CuffNorm feature.

Le fichier *S1 Supporting Information Methods* fournit des précisions supplémentaires :

> Raw FASTQ files from each experiment were aligned to the respective yeast reference genome using STAR [1].

> Reads mapping uniquely to annotated gene features were quantified using HTSeq-count [3].

> Transcript quantification of annotated yeast genes was performed using alignment files output from STAR and Cufflinks2 [4]. Time point samples from the respective yeasts were then normalized together using the CuffNorm feature.

En résumé, nous avons besoin d'installer les outils : `STAR`, `HTSeq-count` et `Cufflinks`. Aucune version de logiciel n'étant spécifiée, nous allons installer la dernière version disponible.

Nous installerons également [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) pour contrôler la qualité des *reads*, ainsi que `samtools` qui n'est pas explicitement mentionné dans l'article ni dans les *Supporting Information* mais qui est nécessaire pour indexer les *reads* alignés.

Dans l'environnement conda `rnaseq`, installez tous les logiciels nécessaires :

```bash
mamba install -c conda-forge -c bioconda sra-tools fastqc star htseq cufflinks samtools -y
```
Cette étape va prendre quelques minutes.

Vérifiez alors les différentes versions des logiciels :

```bash
$ fasterq-dump --version

"fasterq-dump" version 2.11.0
```

```bash
$ fastqc --version
FastQC v0.11.9
```

```bash
$ STAR --version
2.7.10a
```

```bash
$ htseq-count --version
0.13.5
```

```bash
$ cufflinks 2>&1 | head -n 1
cufflinks v2.2.1
```

```bash
$ samtools --version | head -n 1
samtools 1.14
```