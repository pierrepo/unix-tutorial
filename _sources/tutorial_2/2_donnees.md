# Préparer les données 🗃️

L'article orginal publié en 2016 par [Kelliher *et al.*](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1006453) indique dans la rubrique *Data Availability* :

> RNA-Sequencing gene expression data from this manuscript have been submitted to the NCBI Gene Expression Omnibus (GEO; http://www.ncbi.nlm.nih.gov/geo/) under accession number GSE80474.

Le numéro du projet qui nous intéresse est donc : **GSE80474**


## Créer le répertoire de travail

Sur le cluster de l'IFB, il ne faut pas travailler dans votre répertoire personnel car l'espace disponible est très limité. Il faut travailler dans un répertoire dédié à votre projet (ici, la formation DUO : `/shared/projects/202304_duo`)

Depuis l'interface JupyterLab du cluster IFB, ouvrez un terminal, créez un répertoire pour les données de ce tutoriel puis déplacez-vous y :

```bash
mkdir -p /shared/projects/202304_duo/$USER/rnaseq
cd /shared/projects/202304_duo/$USER/rnaseq
```

Ici, `$USER` va automatiquement être remplacé par votre nom d'utilisateur. Vous n'avez rien à faire.


## Télécharger les données de séquençage

L'article de Kelliher *et al.* nous a fourni le numéro du projet sur GEO. Cependant, l'étude a porté sur deux organismes : *Saccharomyces cerevisiae* et *Cryptococcus neoformans var. grubii*. Nous ne sommes intéressés que par les données de *Saccharomyces cerevisiae* que nous allons devoir sélectionner.


### Méthode 1 : SRA Run Selector

Dans l'outil [SRA Run Selector](https://trace.ncbi.nlm.nih.gov/Traces/study/), entrez l'identifiant du projet : GSE80474. 

Un total de 74 *runs* sont disponibles. Cliquez alors sur le bouton gris *Metadata* correspondant au total.

**Sur votre machine du DU**

Téléchargez le fichier `SraRunTable.txt` sur votre machine locale. Il s'agit d'un fichier CSV, c'est-à-dire d'un fichier tabulé avec des colonnes séparées par des virgules. Ouvrez-le avec Microsoft Excel ou LibreOffice Calc pour voir à quoi il ressemble.

**Depuis l'interface JupyterLab du cluster IFB**

Dans JupyterLab, utilisez l'explorateur de fichiers (à gauche) pour vous déplacer dans le répertoire que vous avez créé précédemment (`/shared/projects/202304_duo/$USER/rnaseq`).

En cliquant sur l'icône *Upload Files*, importez le fichier `SraRunTable.txt` dans votre répertoire projet.

Sélectionnez les identifiants des *runs* correspondant à *S. cerevisiae* avec la commande :

```bash
grep "Saccharomyces cerevisiae" SraRunTable.txt | cut -d"," -f1 > runs_scere.txt
```

Pouvez-vous expliquer ce que fait cette commande ?

````{admonition} Solution
:class: tip, dropdown

La commande `grep "Saccharomyces cerevisiae" SraRunTable.txt` extraie du fichier `SraRunTable.txt` les lignes qui contiennent le texte `Saccharomyces cerevisiae`.

Le résultat est ensuite envoyé à la commande `cut` via le pipe `|`.

La commande `cut -d"," -f1` va extraire de chaque ligne le premier champ (`-f1`) séparé par une virgule (`-d","`).

Le résultat est enfin enregistré dans le fichier `runs_scere.txt` avec la rediction `>`.
````

Vérifiez que vous avez bien 50 *runs* de listés dans le fichier `runs_scere.txt` :

```bash
$ wc -l runs_scere.txt 
50 runs_scere.txt
```

Créez ensuite un fichier qui ne va contenir que les 3 premiers échantillons avec la commande :

```bash
grep "Saccharomyces cerevisiae" SraRunTable.txt | cut -d"," -f1 | head -n 3 > runs_scere_small.txt
```

```{attention}
À partir de maintenant, n'exécutez plus les commandes suivantes car le téléchargement et la compression des données vont prendre plusieurs dizaines de minutes. Lisez les commandes proposées et essayez de comprendre ce qu'elles font.

Reprenez l'exécution des commandes à la méthode 2.
```


Téléchargez les fichiers fastq associés aux 3 premiers échantillons :

```bash
mkdir -p reads
for sample in $(cat runs_scere_small.txt)
do 
    echo ${sample}
    fasterq-dump --progress --outdir reads ${sample}
done
```

Cette commande va prendre plusieurs minutes, patientez.

```bash
$ du -csh reads/*
4,1G    reads/SRR3405783.fastq
4,7G    reads/SRR3405784.fastq
4,3G    reads/SRR3405785.fastq
13G     total
```

Pour économiser un peu d'espace, compressez les fichiers fastq avec `gzip` :

```bash
gzip reads/*
```

Cette commande va prendre quelques minutes, patientez.


Vérifiez que vous avez gagné de l'espace :

```bash
$ du -csh reads/*
864M    reads/SRR3405783.fastq.gz
983M    reads/SRR3405784.fastq.gz
910M    reads/SRR3405785.fastq.gz
2.7G    total
```

On a gagné environ 10 Go d'espace disque, ce qui n'est pas négligeable.

### Méthode 2 : SRA Explorer

Le numéro du projet GSE80474 commence par les lettres `GSE` ce qui nous indique que c'est un projet initialement déposé dans la base de données GEO. Cette base n'étant pas toujours bien prise en charge par l'outil sra-explorer, nous allons tout d'abord récupérer sur le site SRA Run Selector l'identifiant *BioProject* correspondant.

Sur le site [SRA Run Selector](https://trace.ncbi.nlm.nih.gov/Traces/study/) :

1. Entrez l'identifiant du projet : GSE80474.
2. Cliquez sur le bouton bleu *Search*.
3. Dans la rubrique *Common Fields* (tout en haut), récupérez l'identifiant *BioProject* : PRJNA319029

C'est avec cet identifiant BioProject que nous allons récupérer les données.

Sur le site [SRA EXplorer](https://sra-explorer.info/) :

1. Indiquez le numéro du *BioProject*, ici PRJNA319029, puis cliquez sur le petite loupe pour lancer la recherche.
1. Vous obtenez ensuite 74 réponses qui correspondent aux différents fichiers / échantillons.
1. Affinez les réponses en tapant « Scerevisiae » dans le champ « Filter results: ». Vous devriez obtenir 50 résultats.
1. Sélectionnez tous les résultats en cliquant sur le case vide à droite de *Title*.
1. Cliquez sur le bouton « Add 50 to collection ».
1. Cliquez ensuite en haut à droite sur le bouton bleu « 50 saved datasets ».
1. Cliquez enfin sur « Bash script for downloading FastQ files ».
1. Téléchargez sur votre **machine locale** le script qui vous permettra de télécharger tous les fichiers fastq (`sra_explorer_fastq_download.sh`).
1. Importer ce script dans l'interface JupyterLab du cluster IFB, dans votre répertoire projet.

Voici les 5 premières lignes du script téléchargé :

```bash
$ head -n 5 sra_explorer_fastq_download.sh
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/009/SRR3405789/SRR3405789.fastq.gz -o SRR3405789_GSM2128026_Scerevisiae_YEPD_aF_30min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/001/SRR3405791/SRR3405791.fastq.gz -o SRR3405791_GSM2128028_Scerevisiae_YEPD_aF_40min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/004/SRR3405784/SRR3405784.fastq.gz -o SRR3405784_GSM2128021_Scerevisiae_YEPD_aF_5min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/003/SRR3405783/SRR3405783.fastq.gz -o SRR3405783_GSM2128020_Scerevisiae_YEPD_aF_0min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
```

C'est bien un script Bash car la première ligne est `#!/usr/bin/env bash`. Ensuite, chaque ligne qui débute par `curl` télécharge un fichier .fastq.gz. La syntaxe de la commande `curl` est la suivante :

```bash
curl -L ADRESSE-DU-FICHIER-À-TÉLÉCHARGER -o NOM-DU-FICHIER-SUR-LE-DISQUE-LOCAL
```

Nous aimerions modifier ce script pour faire en sorte que 

1. Le nom du fichier enregistré localement ne contienne que le numéro d'accession du fichier, tel que présent sur les serveurs de SRA (par exemple : `SRR3405789`) et pas les métadonnnées associées (par exemple : `_GSM2128026_Scerevisiae_YEPD_aF_30min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz`). Pour cela, il faut remplacer l'option `-o` par `-O` (sans argument).
2. Tous les fichiers soient enregistrés dans le même répertoire (par exemple `reads`). Il faut alors ajouter l'option `--output-dir` avec l'argument `reads`.

Nous utilisons ici la commande `sed` qui peut modifier à la volée les lignes d'un fichier :

```bash
sed -E 's/-o .*/-O --output-dir reads/' sra_explorer_fastq_download.sh  > sra_explorer_fastq_download_2.sh
```

Voici les 5 premières lignes du script `sra_explorer_fastq_download_2.sh` : 

```bash
$ head -n 5 sra_explorer_fastq_download_2.sh
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/009/SRR3405789/SRR3405789.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/001/SRR3405791/SRR3405791.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/004/SRR3405784/SRR3405784.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/003/SRR3405783/SRR3405783.fastq.gz -O --output-dir reads
```

Pour vérifier que notre script fonctionne, nous allons télécharger les 3 premiers fichiers *.fastq.gz*. Pour cela, créez un script intermédiaire en ne sélectionnant que les 4 premières lignes du script de téléchargement :

```bash
head -n 4 sra_explorer_fastq_download_2.sh > sra_explorer_fastq_download_2_small.sh
```

Le script fonctionne avec un version récente de `curl`, chargez cette version avec :

```bash
module load curl
```

Vérifiez que c'est bien le cas :

```bash
$ curl --version | head -n 1
curl 7.80.0 (x86_64-conda-linux-gnu) libcurl/7.80.0 OpenSSL/3.0.0 zlib/1.2.11 libssh2/1.10.0 nghttp2/1.43.0
```

Enfin, lancez le script pour télécharger les données :

```bash
mkdir -p reads
bash sra_explorer_fastq_download_2_small.sh
```

Patientez quelques minutes que le téléchargement se termine.

```{hint} text
Le script télécharge directement les données compressées, ce qui est beaucoup plus rapide que de télécharger les données non compressées puis de les compresser.
```

Calculez l'espace occupé par les données :

```bash
$ du -csh reads/*
776M    reads/SRR3405783.fastq.gz
883M    reads/SRR3405784.fastq.gz
818M    reads/SRR3405785.fastq.gz
2.5G    total
```

## Télécharger le génome de référence et ses annotations

On trouve dans le fichier *S1 Supporting Information Methods* la desciption du génome de *S. cerevisiae* utilisé :

> The S. cerevisiae S288C genome (Ensembl build R64-1-1) was downloaded from Illumina iGenomes on March 2, 2016 (https://support.illumina.com/sequencing/sequencing_software/igenome.html).

Téléchargez le fichier concerné (`Ensembl build R64-1-1.tar.gz`) et décompressez l'archive :

```bash
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Saccharomyces_cerevisiae/Ensembl/R64-1-1/Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
tar zxvf Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
```

Récupérez ensuite les fichiers contenant le génome et les annotations :
```bash
mkdir -p genome
cp Saccharomyces_cerevisiae/Ensembl/R64-1-1/Annotation/Genes/genes.gtf genome
cp Saccharomyces_cerevisiae/Ensembl/R64-1-1/Sequence/WholeGenomeFasta/genome.fa genome
```

Supprimez enfin le répertoire `Saccharomyces_cerevisiae` et l'archive contenant le génome qui ne nous intéressent plus :

```bash
rm -rf Saccharomyces_cerevisiae Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz README.txt
```

In fine, vous devriez obtenir l'organisation de fichiers suivante :

```bash
$ tree
.
├── genome
│   ├── genes.gtf
│   └── genome.fa
├── reads
│   ├── SRR3405783.fastq.gz
│   ├── SRR3405784.fastq.gz
│   └── SRR3405785.fastq.gz
├── runs_scere_small.txt
├── runs_scere.txt
├── sra_explorer_fastq_download_2.sh
├── sra_explorer_fastq_download_2_small.sh
├── sra_explorer_fastq_download.sh
└── SraRunTable.txt

2 directories, 11 files
```

Les options `--du -h` de `tree` sont pratiques pour afficher aussi la taille des fichiers et des répertoires :

```bash
 tree --du -h
.
├── [ 23M]  genome
│   ├── [ 11M]  genes.gtf
│   └── [ 12M]  genome.fa
├── [2.4G]  reads
│   ├── [776M]  SRR3405783.fastq.gz
│   ├── [883M]  SRR3405784.fastq.gz
│   └── [817M]  SRR3405785.fastq.gz
├── [  32]  runs_scere_small.txt
├── [ 550]  runs_scere.txt
├── [5.2K]  sra_explorer_fastq_download_2.sh
├── [ 341]  sra_explorer_fastq_download_2_small.sh
├── [8.7K]  sra_explorer_fastq_download.sh
└── [ 29K]  SraRunTable.txt

 2.4G used in 2 directories, 11 files
```
