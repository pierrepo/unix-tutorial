# Préparer les données 🗃️

```{contents}
```

Maintenant que nous avons tous les logiciels nécessaires pour notre analyse RNA-Seq, nous allons nous occuper des données à analyser.

## Identifier les données

L'article orginal publié en 2016 par [Kelliher *et al.*](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1006453) indique dans la rubrique *Data Availability* :

> RNA-Sequencing gene expression data from this manuscript have been submitted to the NCBI Gene Expression Omnibus (GEO; http://www.ncbi.nlm.nih.gov/geo/) under accession number GSE80474.

Le numéro du projet qui nous intéresse est donc : **GSE80474**


## Créer le répertoire de travail

Sur le cluster de l'IFB, vous ne devez pas travailler dans votre répertoire personnel, car l'espace disponible est très limité. Il faut travailler dans un répertoire dédié à votre projet, ici, l'espace créé pour cette formation du DUO : `/shared/projects/2501_duo`.

Depuis l'interface JupyterLab, ouvrez un terminal, créez un répertoire pour les données de ce tutoriel, puis déplacez-vous dans ce répertoire :

```bash
$ mkdir -p /shared/projects/2501_duo/$USER/rnaseq
$ cd /shared/projects/2501_duo/$USER/rnaseq
```

```{admonition} Rappel
:class: tip
Ne tapez pas le caractère `$` en début de ligne et faites bien attention aux majuscules et au minuscules.
```

```{note}
- Ici, `$USER` va automatiquement être remplacé par votre nom d'utilisateur. Vous n'avez rien à faire.
- L'option `-p` de `mkdir` évite de déclencher un message d'erreur si le répertoire que vous souhaitez créer existe déjà. Cette option est utile si vous exécutez plusieurs fois cette commande.
```


## Télécharger les données de séquençage

L'article de Kelliher *et al.* fournit le numéro du projet sur GEO. Cependant, l'étude a porté sur deux organismes :
- *Saccharomyces cerevisiae*
- *Cryptococcus neoformans var. grubii*.

Nous nous intéressons uniquement aux données de *Saccharomyces cerevisiae* que nous allons devoir sélectionner.

```{attention}
Nous présentons ici 2 méthodes pour télécharger les fichiers *.fastq.gz*. La méthode 2 est beaucoup plus rapide, **c'est la méthode que vous utiliserez pendant le TP**. Vous pourrez bien sûr revenir à la méthode 1 plus tard si vous le souhaitez.

➡️ [**Cliquez-ici pour aller directement à la méthode 2**](label:datamethode2) ⬅️
```

### Méthode 1 : SRA Run Selector

**Sur votre machine du DU**

Dans l'outil [SRA Run Selector](https://trace.ncbi.nlm.nih.gov/Traces/study/), entrez l'identifiant du projet : GSE80474. 

Un total de 74 *runs* sont disponibles. Cliquez alors sur le bouton gris *Metadata* correspondant au total.

Téléchargez le fichier `SraRunTable.csv` sur votre machine locale. Il s'agit d'un fichier CSV, c'est-à-dire d'un fichier tabulé avec des colonnes séparées par des virgules. Ouvrez-le avec Microsoft Excel ou LibreOffice Calc pour voir à quoi il ressemble, mais ne le modifiez pas.

**Depuis l'interface JupyterLab de l'IFB**

Dans JupyterLab, utilisez l'explorateur de fichiers (à gauche) pour vous déplacer dans le répertoire que vous avez créé précédemment (`/shared/projects/2501_duo/$USER/rnaseq` avec `$USER` votre identifiant).

En cliquant sur l'icône ⬆️ *Upload Files*, importez le fichier `SraRunTable.csv` dans votre répertoire projet.

Sélectionnez les identifiants des *runs* correspondant à *S. cerevisiae* avec la commande :

```bash
$ grep "Saccharomyces cerevisiae" SraRunTable.csv | cut -d"," -f1 > runs_scere.txt
```

Pouvez-vous expliquer ce que fait cette commande ?

````{admonition} Solution
:class: tip, dropdown

La commande `grep "Saccharomyces cerevisiae" SraRunTable.csv` extrait du fichier `SraRunTable.csv` les lignes qui contiennent le texte `Saccharomyces cerevisiae`.

Le résultat est ensuite envoyé à la commande `cut` via le pipe `|`.

La commande `cut -d"," -f1` va extraire de chaque ligne le premier champ (`-f1`) séparé par une virgule (`-d","`).

Le résultat est enfin enregistré dans le fichier `runs_scere.txt` avec la redirection `>`.
````

Vérifiez que vous avez bien 50 *runs* de listés dans le fichier `runs_scere.txt` :

```bash
$ wc -l runs_scere.txt 
50 runs_scere.txt
```

Créez ensuite un fichier qui ne va contenir que les 3 premiers échantillons avec la commande :

```bash
$ grep "Saccharomyces cerevisiae" SraRunTable.csv | cut -d"," -f1 | head -n 3 > runs_scere_small.txt
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

Cette étape va prendre plusieurs minutes, patientez.

Vérifiez ensuite la taille des fichiers téléchargés avec la commande `du` :

```bash
$ du -csh reads/*
4,1G    reads/SRR3405783.fastq
4,7G    reads/SRR3405784.fastq
4,3G    reads/SRR3405785.fastq
13G     total
```

Pour économiser un peu d'espace, compressez les fichiers fastq avec `gzip` :

```bash
$ gzip reads/*
```

Cette commande va prendre quelques minutes sans qu'aucune indication ne soit affichée dans le terminal, patientez.

Vérifiez que vous avez gagné de l'espace :

```bash
$ du -csh reads/*
864M    reads/SRR3405783.fastq.gz
983M    reads/SRR3405784.fastq.gz
910M    reads/SRR3405785.fastq.gz
2.7G    total
```

On a gagné environ 10 Go d'espace disque, ce qui n'est pas négligeable.

(label:datamethode2)=
### Méthode 2 : SRA Explorer

Le numéro du projet GSE80474 commence par les lettres `GSE` ce qui nous indique que c'est un projet initialement déposé dans la base de données GEO. Cette base n'étant pas toujours bien prise en charge par l'outil SRA Explorer, nous allons tout d'abord récupérer sur le site SRA Run Selector l'identifiant *BioProject* correspondant.

Sur le site [SRA Run Selector](https://trace.ncbi.nlm.nih.gov/Traces/study/) :

1. Entrez l'identifiant du projet : GSE80474.
2. Cliquez sur le bouton bleu *Search*.
3. Dans la rubrique *Common Fields* (tout en haut), récupérez l'identifiant *BioProject* : PRJNA319029

C'est avec cet identifiant BioProject que nous allons récupérer les données.

Sur le site [SRA Explorer](https://sra-explorer.info/) :

1. Indiquez le numéro du *BioProject*, ici PRJNA319029, puis cliquez sur la petite loupe pour lancer la recherche.
1. Vous obtenez ensuite 74 réponses qui correspondent aux différents fichiers / échantillons.
1. Affinez les réponses en tapant « Scerevisiae » dans le champ « Filter results: ». Vous devriez obtenir 50 résultats.
1. Sélectionnez tous les résultats en cliquant sur le case vide à droite de *Title*.
1. Cliquez sur le bouton bleu « Add 50 to collection ».
1. Cliquez ensuite en haut à droite sur le bouton bleu « 50 saved datasets ».
1. Cliquez enfin sur « Bash script for downloading FastQ files ».
1. Cliquez sur le bouton « Download » pour enregistrer sur votre **machine locale** le script qui permettra de télécharger tous les fichiers .fastq.gz (`sra_explorer_fastq_download.sh`).
1. Dans JupyterLab, utilisez l'explorateur de fichiers (à gauche) pour vous déplacer dans le répertoire que vous avez créé précédemment (`/shared/projects/2501_duo/$USER/rnaseq` avec `$USER` votre identifiant). En cliquant sur l'icône ⬆️ *Upload Files*, importez le fichier `sra_explorer_fastq_download.sh` dans votre répertoire projet.

Voici les 5 premières lignes du script téléchargé :

```bash
$ head -n 5 sra_explorer_fastq_download.sh
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/009/SRR3405789/SRR3405789.fastq.gz -o SRR3405789_GSM2128026_Scerevisiae_YEPD_aF_30min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/001/SRR3405791/SRR3405791.fastq.gz -o SRR3405791_GSM2128028_Scerevisiae_YEPD_aF_40min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/004/SRR3405784/SRR3405784.fastq.gz -o SRR3405784_GSM2128021_Scerevisiae_YEPD_aF_5min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/003/SRR3405783/SRR3405783.fastq.gz -o SRR3405783_GSM2128020_Scerevisiae_YEPD_aF_0min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz
```

Il s'agit d'un script Bash car la première ligne est `#!/usr/bin/env bash`. Ensuite, chaque ligne qui débute par `curl` télécharge un fichier .fastq.gz. La syntaxe de la commande `curl` est la suivante :

```bash
curl -L ADRESSE-DU-FICHIER-À-TÉLÉCHARGER -o NOM-DU-FICHIER-SUR-LE-DISQUE-LOCAL
```

```{note}
Il est possible que vous n'ayez pas exactement les mêmes lignes de commande `curl` avec les mêmes numéros d'accession. C'est normal, le script renvoyé par SRA Explorer ne liste pas toujours les fichiers à télécharger dans le même ordre. 
```

Nous aimerions modifier ce script pour faire en sorte que :

1. Le nom du fichier enregistré localement ne contienne que le numéro d'accession du fichier, tel que présent sur les serveurs de SRA (par exemple : `SRR3405789`) et pas les métadonnées associées (par exemple : `_GSM2128026_Scerevisiae_YEPD_aF_30min_Saccharomyces_cerevisiae_RNA-Seq.fastq.gz`). Pour cela, il faut remplacer l'option `-o` par `-O` (sans argument).
2. Tous les fichiers soient enregistrés dans le même répertoire (par exemple `reads`). Il faut alors ajouter l'option `--output-dir` avec l'argument `reads`.

Nous utilisons ici la commande `sed` qui modifie les lignes d'un fichier (ici le script de téléchargement) :

```bash
$ sed -E 's/-o .*/-O --output-dir reads/' sra_explorer_fastq_download.sh  > sra_explorer_fastq_download_2.sh
```

Voici les 5 premières lignes du nouveau script de téléchargement `sra_explorer_fastq_download_2.sh` : 

```bash
$ head -n 5 sra_explorer_fastq_download_2.sh
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/009/SRR3405789/SRR3405789.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/001/SRR3405791/SRR3405791.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/004/SRR3405784/SRR3405784.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/003/SRR3405783/SRR3405783.fastq.gz -O --output-dir reads
```

Le téléchargement des données peut prendre beaucoup de temps. Pour ce tutoriel, nous allons nous limiter à 3 échantillons dont les identifiants sont `SRR3405801`, `SRR3405802` et `SRR3405804`. La commande `grep` va sélectionner les fichiers voulus :


```bash
$ grep -E "bash|SRR3405801|SRR3405802|SRR3405804" sra_explorer_fastq_download_2.sh > sra_explorer_fastq_download_2_small.sh
```

Si vous affichez le contenu de `sra_explorer_fastq_download_2_small.sh` vous devriez obtenir :

```
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/001/SRR3405801/SRR3405801.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/002/SRR3405802/SRR3405802.fastq.gz -O --output-dir reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR340/004/SRR3405804/SRR3405804.fastq.gz -O --output-dir reads
```

```{note}
L'option `-E` permet de créer un motif avec des expressions régulières. Ici, on cherche toutes les lignes qui contient `bash` (la toute première ligne), ou `SRR3405801`, ou `SRR3405802`, ou `SRR3405804`.
```

Le script fonctionne avec une version récente de `curl`, chargez cette version avec :

```bash
$ module load curl/7.80.0
```

Vérifiez que c'est bien le cas :

```bash
$ curl --version | head -n 1
curl 7.80.0 (x86_64-conda-linux-gnu) libcurl/7.80.0 OpenSSL/3.0.0 zlib/1.2.11 libssh2/1.10.0 nghttp2/1.43.0
```

Enfin, lancez le script pour télécharger les données :

```bash
$ mkdir -p reads
$ bash sra_explorer_fastq_download_2_small.sh
```

Patientez quelques minutes que le téléchargement se termine.

```{hint}
- Le script télécharge directement les fichiers .fastq.gz, c'est-à-dire les fichiers .fastq compressés, ce qui est beaucoup plus rapide que de télécharger les données non compressées puis de les compresser (ce qui est fait dans la méthode 1).
- Pour information, les 50 fichiers .fastq.gz représentent environ 40 Go et sont téléchargés en 45 minutes avec cette méthode.
```

Calculez l'espace occupé par les données :

```bash
$ du -csh reads/*
541M    reads/SRR3405801.fastq.gz
625M    reads/SRR3405802.fastq.gz
625M    reads/SRR3405804.fastq.gz
1.8G    total
```

## Vérifier l'intégrité des données

Vous avez téléchargé des données, mais vous n'êtes pas certains de leur intégrité. En effet, ces fichiers sont gros et il y a pu avoir un problème lors du téléchargement.

Téléchargez le fichier `reads_md5sum.txt` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/content/tuto2/reads_md5sum.txt
```

Affichez le contenu de ce fichier avec la commande `cat` :

```bash
$ cat reads_md5sum.txt
1a1a546a4995ec7708ab2aaf25c8eac4  reads/SRR3405801.fastq.gz
d1edba91890651879b4e93b57e800f81  reads/SRR3405802.fastq.gz
d483da006512cc4543ede8330fbbe7e5  reads/SRR3405804.fastq.gz
```

La première colonne contient l'empreinte MD5 du fichier et la seconde colonne contient le nom du fichier (avec son chemin relatif).

Vérifiez maintenant l'intégrité des 3 fichiers que vous avez téléchargés :

```bash
$ md5sum -c reads_md5sum.txt 
reads/SRR3405801.fastq.gz: OK
reads/SRR3405802.fastq.gz: OK
reads/SRR3405804.fastq.gz: OK
```

Si vous n'obtenez pas `OK` à côté de chaque fichier, cela signifie que le fichier a été corrompu lors du téléchargement. Il faut le supprimer et le télécharger à nouveau.

```{note}
- Habituellement, la commande `md5sum` calcule la somme de contrôle MD5 d'un fichier dont le nom est passé en argument.
- Ici, nous utilisons l'option `-c` (comme *check*) pour vérifier l'intégrité de plusieurs fichiers dont le nom et la somme de contrôle de référence sont fournis dans le fichier `reads_md5sum.txt`. Cette option automatise la vérification de l'intégrité de nombreux fichiers en une seule commande.
```

## Compter les *reads*

La commande `zcat` est l'équivalent de la commande `cat`, mais pour les fichiers texte compressés. Vous pouvez l'utiliser pour afficher le premier *read* du fichier `reads/SRR3405783.fastq.gz` :

```bash
$ zcat reads/SRR3405801.fastq.gz | head -n 4
@SRR3405801.1 3NH4HQ1:254:C5A48ACXX:3:1101:1115:2179/1
CTTGGGTCTTTTGAGAACCACGTAGTAAACCGGTTCTTCTGGCAGCAATCA
+
CCCFFFBDHHHHHIIIIJIIJJJJIIGIJJJJI@HIIIJJJJJJJJIJJJG
```

La première ligne contient l'identifiant du *read*, la deuxième la séquence du *read* et la quatrième ligne les scores de qualité. La troisième ligne est un marqueur de séparation : `+`.

Compter le nombre de marqueurs de séparation `+` dans un fichier *.fastq.gz* revient à compter le nombre de *reads*. Pour cela, nous allons utiliser la commande `zgrep` qui est l'équivalent de la commande `grep`, mais pour les fichiers texte compressés.

```bash
$ zgrep -c -e "^+$" reads/*.fastq.gz 
reads/SRR3405801.fastq.gz:12511891
reads/SRR3405802.fastq.gz:15413066
reads/SRR3405804.fastq.gz:14987456
```

Patientez quelques secondes pour obtenir le résultat.

```{admonition} Explications
:class: note
- Tout comme `grep`, la commande `zgrep` recherche un motif dans un fichier, mais un fichier texte compressé.
- Le motif à chercher est le caractère `+`, seul sur une ligne. `^` désigne le début de la ligne et `$` désigne la fin de la ligne. L'option `-e "^+$"` permet de spécifier le motif à chercher sous la forme d'une expression régulière.
- Enfin, l'options `-c` compte le nombre de lignes qui contiennent le motif cherché.
```


## Télécharger le génome de référence et ses annotations

On trouve dans le fichier *S1 Supporting Information Methods* la description du génome de *S. cerevisiae* utilisé par Kelliher *et al.* :

> The S. cerevisiae S288C genome (Ensembl build R64-1-1) was downloaded from Illumina iGenomes on March 2, 2016 (https://support.illumina.com/sequencing/sequencing_software/igenome.html).

Téléchargez le fichier concerné (`Ensembl build R64-1-1.tar.gz`) et décompressez l'archive :

```bash
$ wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Saccharomyces_cerevisiae/Ensembl/R64-1-1/Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
$ tar -zxvf Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
```

Récupérez ensuite les fichiers contenant la séquence du génome et ses annotations :

```bash
$ mkdir -p genome
$ cp Saccharomyces_cerevisiae/Ensembl/R64-1-1/Annotation/Genes/genes.gtf genome
$ cp Saccharomyces_cerevisiae/Ensembl/R64-1-1/Sequence/WholeGenomeFasta/genome.fa genome
```

Supprimez enfin le répertoire `Saccharomyces_cerevisiae` et l'archive contenant le génome qui ne nous intéressent plus :

```bash
$ rm -rf Saccharomyces_cerevisiae Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz README.txt
```

In fine, vous devriez obtenir l'organisation de fichiers suivante (pour le début) :

```bash
$ tree
.
├── genome
│   ├── genes.gtf
│   └── genome.fa
├── reads
│   ├── SRR3405801.fastq.gz
│   ├── SRR3405802.fastq.gz
│   └── SRR3405804.fastq.gz
├── reads_md5sum.txt
[...]
```

Les options `--du -h` de `tree` sont pratiques pour afficher la taille des fichiers et des répertoires :

```bash
$ tree --du -h
.
├── [ 23M]  genome
│   ├── [ 11M]  genes.gtf
│   └── [ 12M]  genome.fa
├── [1.8G]  reads
│   ├── [540M]  SRR3405801.fastq.gz
│   ├── [655M]  SRR3405802.fastq.gz
│   └── [642M]  SRR3405804.fastq.gz
├── [ 180]  reads_md5sum.txt
[...]
```

## Conclusion

Vous avez sélectionné puis téléchargé les données pour votre analyse RNA-seq. Vous avez contrôlé l'intégrité des fichiers *.fastq.gz* et compté leur nombre de *reads*. Vous êtes maintenant prêts à lancer l'analyse.


## Plan B

Si le téléchargement des données prend trop de temps ou échoue, lancez les commandes suivantes pour obtenir les données nécessaires :

```bash
$ mkdir -p reads
$ cp /shared/projects/2501_duo/data/rnaseq_scere/reads/SRR340580{1,2,4}.fastq.gz reads/
$ cp -R /shared/projects/2501_duo/data/rnaseq_scere/genome .
```
