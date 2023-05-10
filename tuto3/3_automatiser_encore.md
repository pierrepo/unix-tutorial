# Automatiser encore plus avec Snakemake 🐍 ⚙

Précédemment, vous avez automatisé votre analyse RNA-seq en utilisant plusieurs scripts Bash que vous avez soumis au gestionnaire du cluster, Slurm.

D'abord `script_cluster_1.sh` pour indexer le génome de référence, puis `script_cluster_2.sh` pour contrôler la qualité, aligner et quantifier les *reads* et enfin, `script_cluster_3.sh` pour normaliser les comptages de tous les échantillons.

Lancer ces trois scripts les uns après les autres est fastidieux. On peut automatiser cela plus encore avec un gestionnaire de workflow comme [Snakemake](https://snakemake.readthedocs.io/en/stable/). Un gestionnaire de workflow va s'occuper de lancer les différents jobs dans le bon ordre et de gérer les dépendances entre les jobs.



