# Automatiser avec Snakemake 🐍 ⚙

## Introduction

Précédemment, vous avez automatisé votre analyse RNA-seq en utilisant plusieurs scripts Bash que vous avez soumis au gestionnaire du cluster, Slurm.

D'abord `script_cluster_1.sh` pour indexer le génome de référence, puis `script_cluster_2.sh` pour contrôler la qualité, aligner et quantifier les *reads* et enfin, `script_cluster_3.sh` pour normaliser les comptages de tous les échantillons.

Lancer ces trois scripts les uns après les autres est fastidieux. On peut automatiser cela plus encore avec un gestionnaire de workflow comme [Snakemake](https://snakemake.readthedocs.io/en/stable/). Un gestionnaire de workflow va s'occuper de lancer les différentes étapes du workflow d'analyse dans le bon ordre et de gérer les dépendances entre ces étapes.


## Mise en oeuvre

Depuis un terminal de JupyterLab, vérifiez que vous êtes toujours dans le répertoire `/shared/projects/202304_duo/$USER/rnaseq`.

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts slurm*.out
```

Téléchargez le fichier ([`snakemake.zip`](snakemake.zip)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto3/snakemake.zip
```

Désarchivez cette archive :

```bash
unzip snakemake.zip
```

Deux nouveaux fichiers vont être créés ainsi qu'un répertoire :

- `run_snakemake.sh` : script Bash pour lancer Snakemake via Slurm.
- `Snakefile` : fichier de configuration de Snakemake qui contient la définition des différentes étapes de l'analyse.
- `snakemake_profiles/` : répertoire qui contient des fichiers de configuration de Snakemake.

Avec l'éditeur de fichier de JupyterLab, ouvrez les fichiers `run_snakemake.sh` et `Snakefile`. Le fichier `run_snakemake.sh` est relativement court. Le fichier `Snakefile` est plus complexe, mais vous devriez y retrouver les différentes étapes de l'analyse. Pour chaque étape d'analyse, on définit en *input* les fichiers nécessaire pour cette étape et en *output* les fichiers qui seront produits.

Lancez l'analyse avec Snakemake :

```bash
$ sbatch -A 202304_duo run_snakemake.sh
```

La commande `sacct` ne sera ici pas très utile, car tous les jobs seront lancés **indépendamment** les uns des autres (donc avec des numéros de jobs différents).

La commande `squeue` avec quelques options d'affichage sera plus pertinente pour suivre la progression du calcul : 

```bash
$ squeue --format="%.10i %.40j %.8T %.8M %.9P %.10u %R" -u $USER
```

N'hésitez pas à préfixer cette commande par `watch -x` pour afficher automatiquement l'avancement du calcul.

```{hint}
Utilisez la combinaison de touches <kbd>Ctrl</kbd> + <kbd>C</kbd> pour arrêter la commande `watch`.
```

## Pour aller plus loin

Si vous souhaitez découvrir Snakemake, voici deux vidéos d'introduction à Snakemake :

- [Reproducible data analysis with Snakemake](https://www.youtube.com/watch?v=UOKxta3061g), 2019, (YouTube, 2'). Très courte vidéo d'introduction à Snakemake.
- [Reproducible data analysis with Snakemake](https://www.youtube.com/watch?v=hPrXcUUp70Y), 2019, (YouTube, 1h22'). Tutoriel pour une analyse RNA-Seq, par Johannes Köster, le créateur de Snakemake.
