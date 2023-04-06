# Analyser les données RNA-seq 💻

```{contents}
```

Dans cette partie, nous allons analyser manuellement, c'est-à-dire étape par étape, les données RNA-seq de *S. cerevisiae*.
## Vérifier l'environnement logiciel

Si cela n'est pas déjà fait, chargez les outils nécessaires à l'analyse des données RNA-seq :

```bash
$ module load sra-tools fastqc star htseq cufflinks samtools
```

## Vérifier les données

Déplacez-vous ensuite dans le répertoire contenant les répertoires `/shared/projects/202304_duo/$USER/rnaseq`. 

Vous devriez obtenir l'arborescence suivante :

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

Choississez un échantillon parmi ceux téléchargés dans le répertoire `reads` :

```bash
reads
├── SRR3405783.fastq.gz
├── SRR3405784.fastq.gz
└── SRR3405785.fastq.gz
```

Par exemple : `SRR3405783.fastq.gz`, mais vous pouvez choisir un autre fichier. Il faudra modifier le nom de l'échantillon dans les commandes suivantes.


## Contrôler la qualité des reads

Créez le répertoire `reads_qc` qui va contenir les fichiers produits par le contrôle qualité des fichiers *fastq.gz* :

```bash
mkdir -p reads_qc
```

Lancez FastQC avec la commande :

```bash
fastqc reads/SRR3405783.fastq.gz --outdir reads_qc
```

FastQC va produire deux fichiers (un fichier avec l’extension `.html` et un autre avec l’extension `.zip`) dans le répertoire `reads_qc`. Si par exemple, vous avez analysé le fichier `reads/SRR3405783.fastq.gz`, vous obtiendrez les fichiers `reads_qc/SRR3405783_fastqc.html` et `reads_qc/SRR3405783_fastqc.zip`.

Depuis l'explorateur de fichiers de JupyterLab, déplacez-vous dans le répertoire `reads_qc`, puis double-cliquez sur le  le fichier `.html` ainsi créé. Le rapport d'analyse créé par FastQC va alors s'ouvrir dans un nouvel onglet de JupyterLab.


## Indexer le génome de référence

L’indexation du génome de référence est une étape indispensable pour accélérer l’alignement des reads sur le génome. Elle consiste à créer un annuaire du génome de référence.

Dans un terminal, créez le répertoire `genome_index` qui contiendra les index du génome de référence :

```bash
mkdir -p genome_index
```

Lancez l’indexation du génome de référence :

```bash
STAR --runMode genomeGenerate \
--genomeDir genome_index \
--genomeFastaFiles genome/genome.fa \
--sjdbGTFfile genome/genes.gtf \
--sjdbOverhang 50 \
--genomeSAindexNbases 10
```

L'aide de STAR pour l'option `--sjdbOverhang` indique :

```
sjdbOverhang                            100
    int>0: length of the donor/acceptor sequence on each side of the junctions, ideally = (mate_length - 1)
```

Cela signifie que cette option doit être égale à la longueur maximale des *reads* - 1. Le fichier *S1 Supporting Information Methods* mentionne :

> S. cerevisiae total mRNA was prepared in libraries of stranded 50 base-pair single-end reads and multiplexed at 10 time point samples per sequencing lane.

Les *reads* obtenus devraient donc a priori être constitué de 50 bases. On peut le vérifier en affichant les premières lignes d'un fichier *.fastq.gz*, par exemple `reads/SRR3405783.fastq.gz` :

```bash
$ zcat reads/SRR3405783.fastq.gz | head
@SRR3405783.1 3NH4HQ1:254:C5A48ACXX:1:1101:1135:2105/1
GGTTGAANGGCGTCGCGTCGTAACCCAGCTTGGTAAGTTGGATTAAGCACT
+
?8?D;DD#2<C?CFE6CGGIFFFIE@DFF<FFB===C7=F37@C)=DE>EA
@SRR3405783.2 3NH4HQ1:254:C5A48ACXX:1:1101:1210:2111/1
GTTTCTGTACTTACCCTTACCGGCTCTCAATTTCTTGGACTTCAAGACCTT
+
;?@DDD>BFF?F>GE:CFFFFBFFIFFFIIIEIFFI9BFDCFFC<FFF>FF
@SRR3405783.3 3NH4HQ1:254:C5A48ACXX:1:1101:1408:2208/1
CTGCAGACAAGGCATCTCCTCTCAAGGCCAAATGACGTTGGTCCAACAGTA
```

En réalité, les *reads* ont une longueur de 51 bases et non pas 50 comme supposé.

Le paramètre `--sjdbOverhang` vaut donc 50 (51 - 1).

```{hint}
La commande `zcat` est particulière car elle affiche le contenu d'un fichier compressé (ici un fichier .gz) en le décompressant à la volée. La commande `cat` (sans le `z`) n'aurait pas permis une telle manipulation.
```

Vérifiez également que la longueur des *reads* est bien 51 en consultant les résultats du contrôle qualité fournis par FastQC (première page, *Basic Statistics*).

Enfin, le paramètre `--genomeSAindexNbases 10` est conseillé par STAR. Si on utilise STAR sans ce paramètre, on obtient le message :

> !!!!! WARNING: --genomeSAindexNbases 14 is too large for the genome size=12157105, which may cause seg-fault at the mapping step. Re-run genome generation with recommended --genomeSAindexNbases 10

Nous vous rappelons que l’indexation du génome n’est à faire qu’une seule fois pour chaque génome et chaque logiciel d’alignement.


## Aligner les *reads* sur le génome de référence

Le fichier *S1 Supporting Information Methods* précise la commande utilisée pour l'alignement :

```bash
STAR --runThreadN 1 --runMode alignReads --genomeDir
path_to_yeast_genome_build --sjdbGTFfile path_to_yeast_transcriptome_gtf
--readFilesIn sample.fastq --outFilterType BySJout --alignIntronMin 10 --
alignIntronMax 3000 --outFileNamePrefix ./STAR_out/ --
outFilterIntronMotifs RemoveNoncanonical
```

Les alignements des *reads* seront stockés dans le répertoire `reads_map` :

```bash
mkdir -p reads_map
```

Avec nos chemins de fichiers et quelques adaptations, la commande d'alignement devient :

```bash
STAR --runThreadN 1 \
--runMode alignReads \
--genomeDir genome_index \
--sjdbGTFfile genome/genes.gtf \
--readFilesCommand zcat \
--readFilesIn reads/SRR3405783.fastq.gz \
--outFilterType BySJout \
--alignIntronMin 10 \
--alignIntronMax 3000 \
--outFileNamePrefix reads_map/SRR3405783_ \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM Unsorted
```

```{note}
- L'article orginal du logiciel d'alignement STAR « [STAR: ultrafast universal RNA-seq aligner](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3530905/) » (*Bioinformatics*, 2013) précise que :
    > STAR’s default parameters are optimized for mammalian genomes. Other species may require significant modifications of some alignment parameters; in particular, the maximum and minimum intron sizes have to be reduced for organisms with smaller introns.
    
    Ceci explique pourquoi les options `--alignIntronMin 10` et `--alignIntronMax 3000` ont été adaptées pour le génome de la levure *S. cerevisiae*.

- L'option `--readFilesCommand zcat` n'était pas présente dans la commande fournie en *Supporting information*. Nous l'avons ajoutée car les fichiers contenant les *reads* (*.fastq.gz*) sont compressés et il faut demander explicitement à STAR de le prendre en charge. Pensez à toujour consulter la [documentation](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf) de l'outil que vous utilisez (même si c'est un peu pénible) !
```

Lancez l'alignement avec STAR et vérifiez que tout se déroule sans problème.
L'alignement devrait prendre environ entre 5 et 10 minutes.


## Compter les *reads* et les transcrits

Le fichier *S1 Supporting Information Methods* précise les commandes utilisées pour le comptage des *reads* :

```bash
htseq-count --order=pos --stranded=reverse --mode=intersection-nonempty
sample.aligned.sorted.sam path_to_yeast_transcriptome_gtf > sample.txt
```

et celui des transcrits :

```bash
cuffquant --library-type=fr-firststrand path_to_yeast_transcriptome_gtf
sample.aligned.sorted.sam
```

Enfin, la normalisation des comptages des transcrits :

```bash
cuffnorm --library-type=fr-firststrand path_to_yeast_transcriptome_gtf
*.cxb
```

Nous allons réaliser nous-mêmes ces étapes avec quelques adaptations.

Créez tout d'abord le répertoire `counts/SRR3405783` dans lequel seront stockés les fichiers de comptage :

```bash
mkdir -p counts/SRR3405783
```

Les étapes de tri et d'indexation des *reads* alignés ne sont pas explicitement mentionnées dans les *Supporting Informations* mais elles sont cependant nécessaires pour `HTSeq` :

```bash
samtools sort reads_map/SRR3405783_Aligned.out.bam -o reads_map/SRR3405783_Aligned.sorted.out.bam
samtools index reads_map/SRR3405783_Aligned.sorted.out.bam
```

```{note}
Le tri des *reads* peut, a priori, se faire directement avec STAR en utilisant l'option `--outSAMtype BAM SortedByCoordinate`. Cependant, les tests réalisés sur le cluster ont montré qu'il y avait parfois des soucis avec cette option. Nous préférons donc utiliser explicitement `samtools` pour le tri des *reads*.
```

La commande pour compter les *reads* devient alors :

```bash
htseq-count --order=pos --stranded=reverse \
--mode=intersection-nonempty \
reads_map/SRR3405783_Aligned.sorted.out.bam genome/genes.gtf > counts/SRR3405783/count_SRR3405783.txt
```

Puis celle pour compter les transcrits :

```bash
cuffquant --library-type=fr-firststrand genome/genes.gtf \
reads_map/SRR3405783_Aligned.sorted.out.bam \
--output-dir counts/SRR3405783
```

```{note}
- Par défaut, `cuffquant` écrit un fichier `abundances.cxb`.
- Nous ajoutons l'option `--output-dir counts/SRR3405783` pour indiquer où stocker les résultats produits par `cuffquant` (voir la [documentation](http://cole-trapnell-lab.github.io/cufflinks/cuffquant/) à ce propos). Cela nous permet de distinguer les résultats obtenus à partir de différents fichiers *.fastq.gz*.
```

Enfin, on normalise les comptages des transcrits :

```bash
cuffnorm --library-type=fr-firststrand genome/genes.gtf \
counts/*/*.cxb --output-dir counts
```

```{note}
- Dans le cas présent, cette normalisation va échouer car nous n'avons aligné et quantifié qu'un seul fichier *.fastq.gz*. Cette étape sera par contre pertinente lorsque plusieurs fichiers *.fastq.gz* seront traités. On le verra par la suite.
- L'option `--output-dir counts` indique où stocker les fichiers produits par `cuffnorm` (voir la [documentation](http://cole-trapnell-lab.github.io/cufflinks/cuffnorm/) à ce propos).
```

## Conclusion

Pour analyser les données RNA-seq de *S. cerevisiae*, vous avez lancé à la main plus d'une demi-douzaine de commandes dans un terminal Unix.
C'était fastidieux et ces commandes étaient parfois complexes avec de nombreuses options. Dans ce cas, le copier-coller était votre meilleur ami !

**Mais**, vous avez été capable de reproduire toutes ces étapes en suivant les instructions de ce tutoriel. C'est là la grande force d'Unix et de la ligne commande : la capacité à décrire une analyse complexe en une suite d'instructions *écrites* et donc *facilement* répétables. 
