# Automatiser l'analyse RNA-seq

Dans la section précédente, vous avez analysé les données RNA-seq d'un seul échantillon en exécutant, une à une, chaque étape de l'analyse (contrôle qualité, alignement des *reads*...).

Nous allons maintenant automatiser l'analyse d'un échantillon en une seule fois en utilisant un script. Puis nous automatiserons l'analyse de plusieurs échantillons.

## Vérifier l'environnement logiciel et les données

Si cela n'est pas déjà fait, chargez les outils nécessaires à l'analyse des données RNA-seq :

```bash
$ module load sra-tools fastqc star htseq cufflinks samtools
```

```{hint}
La commande `module list` affiche les modules déjà chargés.
```
Vérifiez ensuite que vous êtes bien dans le répertoire `/shared/projects/202304_duo/$USER/rnaseq` avec la commande `pwd` et déplacez-vous dans ce répertoire avec la commande `cd` si ce n'est pas le cas.

Supprimez les répertoires qui contiennet les résultats de l'analyse précédente :

```bash
rm -rf genome_index reads_qc reads_map counts
```

```{warning}
Attention à la commande `rm` qui supprime irrémédiablement fichiers et répertoires.
```

Enfin, vérifiez que les données RNA-seq et le génome de *S. cerevisiae* sont bien disponibles :

```bash
$ tree
.
├── genome
│   ├── genes.gtf
│   └── genome.fa
└── reads
    ├── SRR3405783.fastq.gz
    ├── SRR3405784.fastq.gz
    └── SRR3405785.fastq.gz
```

## Variables Bash

Une variable va contenir de l'information qui sera utilisable autant de fois que nécessaire.

Création de variables :

```bash
$ toto=33
$ t="salut"
```

```{warning}
Il faut coller le nom de la variable et son contenu au symbole `=`.
```

Affichage de variables :

```bash
$ echo $toto
33
$ echo "$t Pierre"
salut Pierre
```

La commande `echo` affiche une chaîne de caractère, une variable, ou les deux.

Pour utiliser une variable (et accéder à son contenu), il faut précéder son nom du caractère `$`. Attention, ce symbole n'est pas à confondre avec celui qui désigne l'invite de commande de votre *shell* Linux.

Enfin, une bonne pratique consiste à utiliser une variable avec le symbole `$` et son nom entre accolades :

```bash
$ echo ${toto}
33
$ echo "${t} Pierre"
salut Pierre
```

## Script Bash

Un script est un fichier texte qui contient des instructions Bash. Par convention, il porte l'extension `.sh`. L'objectif premier d'un script Bash est d'**automatiser l'exécution de plusieurs commandes** Bash, la plupart du temps pour manipuler ou analyser des fichiers.

Dans un script Bash, tout ce qui suit le symbole `#` est considéré comme un commentaire et n'est donc pas traité par Bash.

## Automatiser l'analyse d'un échantillon

Téléchargez un premier script Bash avec la commande `wget` :

```bash
wget xxx
```

Ouvrez ce script dans un éditeur de texte :
- Soit dans un terminal avec l'éditeur de texte nano (`nano script_local_1.sh`).
- Soit depuis le navigateur de fichiers de JupyterLab, en double-cliquant sur son nom. Cette seconde solution est la plus confortable.

Modifiez la variable `sample`, à la ligne 2 du script avec votre numéro d'échantillon. Vous avez le choix entre `SRR3405783`, `SRR3405784` et `SRR3405785`. Veuillez à bien respecter :
- la casse (majuscules et minuscules),
- les guillemets autour du numéro de l'échantillon
- et l'absence d'espace autour du signe `=`.

Retrouvez également dans ce script les différentes étapes de l'analyse RNA-seq que vous avez réalisées précédemment.

Lancez le script avec la commande :
```bash
$ bash script_local_1.sh
```

Vérifiez que le déroulement du script se passe bien. Vous avez le temps de prendre un café (~ 25 '), voir plusieurs ☕ 🍪 ☕ 🍪.

Évaluez approximativement le temps nécessaire au script 1 pour s'exécuter. ⏱️ À partir de cette valeur, extrapoler le temps nécessaire qu'il faudrait pour analyser les 3 échantillons.

Utilisez enfin la commande `tree` pour contempler votre travail (ici avec l'échantillon `SRR3405783`) :

```bash
$ tree
.
├── counts
│   └── SRR3405783
│       ├── abundances.cxb
│       └── count_SRR3405783.txt
├── genome
│   ├── genes.gtf
│   └── genome.fa
├── genome_index
│   ├── chrLength.txt
│   ├── chrNameLength.txt
│   ├── chrName.txt
│   ├── chrStart.txt
│   ├── exonGeTrInfo.tab
│   ├── exonInfo.tab
│   ├── geneInfo.tab
│   ├── Genome
│   ├── genomeParameters.txt
│   ├── Log.out
│   ├── SA
│   ├── SAindex
│   ├── sjdbInfo.txt
│   ├── sjdbList.fromGTF.out.tab
│   ├── sjdbList.out.tab
│   └── transcriptInfo.tab
├── reads
│   ├── SRR3405783.fastq.gz
│   ├── SRR3405784.fastq.gz
│   └── SRR3405785.fastq.gz
├── reads_map
│   ├── SRR3405783_Aligned.out.bam
│   ├── SRR3405783_Aligned.sorted.out.bam
│   ├── SRR3405783_Aligned.sorted.out.bam.bai
│   ├── SRR3405783_Log.final.out
│   ├── SRR3405783_Log.out
│   ├── SRR3405783_Log.progress.out
│   ├── SRR3405783_SJ.out.tab
│   └── SRR3405783__STARgenome
│       ├── exonGeTrInfo.tab
│       ├── exonInfo.tab
│       ├── geneInfo.tab
│       ├── sjdbInfo.txt
│       ├── sjdbList.fromGTF.out.tab
│       ├── sjdbList.out.tab
│       └── transcriptInfo.tab
├── reads_qc
│   ├── SRR3405783_fastqc.html
│   └── SRR3405783_fastqc.zip
├── runs_scere_small.txt
├── runs_scere.txt
├── script_local_1.sh
├── sra_explorer_fastq_download_2.sh
├── sra_explorer_fastq_download_2_small.sh
├── sra_explorer_fastq_download.sh
└── SraRunTable.txt
```


Affichez enfin la taille occupée par chaque sous-répertoire ainsi que la taille totale avec la commande :

```bash
$ du -csh *
5.3M    counts
24M     genome
117M    genome_index
2.5G    reads
1.5G    reads_map
1.1M    reads_qc
4.0K    runs_scere_small.txt
4.0K    runs_scere.txt
4.0K    script_local_1.sh
8.0K    sra_explorer_fastq_download_2.sh
4.0K    sra_explorer_fastq_download_2_small.sh
12K     sra_explorer_fastq_download.sh
32K     SraRunTable.txt
4.1G    total
```

## Automatiser l'analyse de 3 échantillons

Vérifiez que vous êtes bien dans le répertoire `/shared/projects/202304_duo/$USER/rnaseq`. Assurez-vous également que vous avez préparé les données correctement, notamment les répertoires `reads` et `genome` :

```bash
$ tree
.
├── genome
│   ├── genes.gtf
│   └── genome.fa
└── reads
    ├── SRR3405783.fastq.gz
    ├── SRR3405784.fastq.gz
    └── SRR3405785.fastq.gz
```

Téléchargez le script `analyse_locale.sh` qui analyse 3 échantillons :

```bash
wget https://raw.githubusercontent.com/omics-school/analyse-rna-seq-scere/master/analyse_locale.sh
```

Vérifiez dans le script que la ligne

```bash
samples="SRR3405783 SRR3405784 SRR3405788"
```

corresponde à VOS échantillons. Modifiez-la le cas échéant.

Lancez ensuite le script d'analyse :

```bash
bash analyse_locale.sh
```

L'analyse devrait prendre plusieurs dizaines de minutes.

Vérifiez régulièrement votre terminal qu'aucune erreur n'apparaît.

Le fichier qui contient le comptage normalisé des transcrits est `counts/genes.count_table`.