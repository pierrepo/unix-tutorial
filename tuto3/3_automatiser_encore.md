# Automatiser encore plus avec Snakemake 🐍 ⚙

Précédemment, vous avez automatisé votre analyse RNA-seq en utilisant plusieurs scripts Bash que vous avez soumis au gestionnaire du cluster, Slurm.

D'abord `script_cluster_1.sh` pour indexer le génome de référence, puis `script_cluster_2.sh` pour contrôler la qualité, aligner et quantifier les *reads* et enfin, `script_cluster_3.sh` pour normaliser les comptages de tous les échantillons.

Lancer ces trois scripts les uns après les autres est fastidieux. On peut automatiser cela plus encore avec un gestionnaire de workflow comme [Snakemake](https://snakemake.readthedocs.io/en/stable/). Un gestionnaire de workflow va s'occuper de lancer les différents jobs dans le bon ordre et de gérer les dépendances entre les jobs.

Depuis un terminal de JupyterLab, vérifiez que vous êtes toujours dans le répertoire `/shared/projects/202304_duo/$USER/rnaseq`.

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts slurm*.out
```

Téléchargez le script Bash ([`snakemake.zip`](snakemake.zip)) avec la commande `wget` :

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

Avec l'éditeur de fichier de JupyterLab, ouvrez les fichiers `run_snakemake.sh` et `Snakefile`. Le fichier `run_snakemake.sh` est relativement court. Le fichier `Snakefile` est plus complexe mais vous devriez y retrouver les différentes étapes de l'analyse. Pour chaque étape d'analyse, on définit en *input* les fichiers nécessaire pour cette étape et en *output* les fichiers qui seront produits.

Lancez l'analyse avec Snakemake avec la commande :

```bash
$ sbatch -A 202304_duo run_snakemake.sh
```

La commande `sacct` ne sera ici pas très utile car tous les jobs seront lancés indépendamment les uns des autres.

La commande `squeue` avec quelques options d'affichage sera plus utile : 


```bash
$ squeue --format="%.10i %.40j %.8T %.8M %.9P %.10u %R" -u $USER
```

N'hésitez pas à préfixer cette commande par `watch -x` pour afficher l'avancement du calcul.

