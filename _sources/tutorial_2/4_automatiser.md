# Automatiser l'analyse RNA-seq

Dans la section précédente, vous avez analysé les données RNA-seq d'un seul échantillon en exécutant, une à une, chaque étape de l'analyse (contrôle qualité, alignement des *reads*...).

Nous allons maintenant automatiser l'analyse d'un échantillon en une seule fois en utilisant un script. Puis nous automatiserons l'analyse de plusieurs échantillons.

## Automatiser l'analyse d'un échantillon


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