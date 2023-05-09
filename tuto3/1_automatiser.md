# Automatiser l'analyse RNA-seq avec un cluster 🚀

```{contents}
```

## Découvrir le cluster

Un cluster de calcul met à disposition de ses utilisateurs des processeurs et de la mémoire vive pour réaliser des calculs. Ces ressouces sont réparties sur plusieurs machines, appelées *nœuds de calcul*. Chaque nœud de calcul contient plusieurs dizaines de processeurs (ou coeurs) et plusieurs centaines de Go de mémoire vive.

Plusieurs utilisateurs utilisent simultanément un cluster de calcul. Pour vous en rendre compte, dans JupyterLab, ouvrez un terminal puis entrez la commande suivante qui va lister tous les calculs (appelés *job*) en cours sur le cluster :

```bash
$ squeue -t RUNNING
```

```{admonition} Rappel
:class: tip
Ne tapez pas le caractère `$` en début de ligne et faites bien attention aux majuscules et au minuscules.
```

Vous voyez que vous n'êtes pas seul ! Comptez maintenant le nombre de jobs en cours d'exécution en chaînant la commande précédente avec `wc -l` :

```bash
$ squeue -t RUNNING | wc -l
```

Vous pouvez aussi compter le nombre de jobs en attente d'exécution :

```bash
$ squeue -t PENDING | wc -l
```

Et vous alors ? Avez-vous lancé un calcul ? Vérifiez-le en entrant la commande suivante qui va lister les calculs en cours pour votre compte :

```bash
$ squeue -u $USER
```

La colonne `ST` indique le statut de votre job :

- `CA` (*cancelled*) : le job a été annulé
- `F` (*failed*) : le job a planté
- `PD` (*pending*) : le job est en attente que des ressources soient disponibles
- `R` (*running*) : le job est en cours d'exécution

Bizarre ! Vous avez un job avec le statut *running* en cours d'exécution alors que vous n'avez a priori rien lancé 🤔

En fait, le JupyterLab dans lequel vous êtes est lui-même un job lancé sur le cluster. C'est d'ailleurs pour cela qu'avant de lancer JupyterLab, vous avez dû préciser le compte à utiliser (`202304_duo`) et choisir le nombre de processeurs et la quantité de mémoire vive dont vous aviez besoin.

Comme plusieurs utilisateurs peuvent lancer des jobs sur un cluster, un gestionnaire de jobs (ou ordonnanceur) s'occupe de répartir les ressources entre les différents utilisateurs. Sur le cluster de l'IFB, le gestionnaire de jobs est [Slurm](https://slurm.schedmd.com/). Désormais le lancement de vos analyses se fera via Slurm.

## Analyser un échantillon

Déplacez-vous le répertoire `/shared/projects/202304_duo/$USER/rnaseq` puis vérifiez que vous êtes dans le bon répertoire avec la commande `pwd`.

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts
```

Téléchargez dans un terminal de JupyterLab un premier script Bash ([`script_cluster_0.sh`](script_cluster_0.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto3/script_cluster_0.sh
```

Ce script est le script `script_local_2.sh` adapté pour une utilisation sur un cluster. Ouvrez ce script avec l'éditeur de texte de JupyterLab et essayez d'identifier les différences avec `script_local_2.sh`. 

1. Au début du script, deux lignes sont nouvelles :

    ```
    #SBATCH --mem=2G
    #SBATCH --cpus-per-task=8
    ```

    Ces lignes commencent par le caractère `#` qui indique qu'il s'agit de commentaires pour Bash, elles seront donc ignorées par le *shell*. Par contre, elles ont un sens très particulier pour le gestionnaire de jobs du cluster Slurm. Ces lignes indiquent à Slurm que le job a besoin de 2 Go de mémoire vive et de 8 processeurs pour s'exécuter.

2. Un peu plus loin, on indique explicitement les modules (les logiciels) à charger avec leurs versions :

    ```bash
    module load fastqc/0.11.9
    module load star/2.7.9a
    module load samtools/1.14
    module load htseq/0.13.5
    module load cufflinks/2.2.1
    ```

2. De plus, à l'étape d'indexation du génome de référence, dans la ligne

    ```
    srun STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
    ```

    la variable `SLURM_CPUS_PER_TASK` est utilisée pour indiquer à STAR le nombre de processeurs à utiliser. Cette variable est automatiquement définie par Slurm lors de l'exécution du script. Dans le cas présent, elle vaut 8. Le lancement de `STAR` est précédé de l'instruction `srun` qui va explicitement indique à Slurm qu'il s'agit d'un sous-job. Nous en verrons l'utilité plus tard.


Lancez enfin le script avec la commande suivante :

```bash
$ sbatch -A 202304_duo script_cluster_0.sh
```

Vous devriez obtenir un message du type `Submitted batch job 33332280`. Ici, `33332280` correspond au numéro du job. Notez bien le numéro de votre job.


- L'instruction `sbatch` est la manière de demander à Slurm de lancer un script.
- L'option `-A 202304_duo` spécifie quel projet utiliser (facturer) pour cette commande. Un même utilisateur peut appartenir à plusieurs projets. Le nombre d'heures de calcul attribuées à un projet étant limité, il est important de savoir quel projet imputer pour telle ou telle commande. Pensez-y pour vos futurs projets.

Vérifiez que votre script est en train de tourner avec la commande :

```bash
$ squeue -u $USER
```

Et pour avoir plus de détails, utilisez la commande :

$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID

avec `JOBID` (en fin de ligne) le numéro de votre job à remplacer par le vôtre.

Voici un exemple de sortie que vous pourriez obtenir :

```bash
$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j 33332280
       JobID    JobName      State               Start    Elapsed    CPUTime        NodeList 
------------ ---------- ---------- ------------------- ---------- ---------- --------------- 
33332280     script_cl+    RUNNING 2023-05-10T00:11:56   00:01:10   00:09:20     cpu-node-19 
33332280.ba+      batch    RUNNING 2023-05-10T00:11:56   00:01:10   00:09:20     cpu-node-19 
33332280.0         STAR  COMPLETED 2023-05-10T00:11:57   00:00:10   00:01:20     cpu-node-19 
33332280.1       fastqc    RUNNING 2023-05-10T00:12:07   00:00:59   00:07:52     cpu-node-19
```

Quand la colonne *State* est à `COMPLETED`, cela signifie que le sous-job est terminé. Un sous-job est créé à chaque fois que la commande `srun` est utilisée dans le script de soumission. Ici, on voit que le sous-job `STAR` est terminé, mais que le sous-job `fastqc` est toujours en cours d'exécution.

Relancez régulièrement la commande précédente pour suivre l'avancement de votre job.

Quand vous avez terminé l'alignement sur le génome de référence , c'est-à-dire que vous avez obtenu un second sous-job `STAR` avec le statut `COMPLETED`, stopper le job en cours avec la commande :

```bash
$ scancel JOBID
```

avec `JOBID` le numéro de votre job à remplacer par le vôtre.


```{note}
Le fichier `slurm-JOBID.out` (avec `JOBID` le numéro de votre job) contient le « journal » de votre job. C'est-à-dire tout ce qui s'affiche habituellement à l'écran a été enregistré dans ce fichier.

Ouvrez ce fichier avec l'éditeur de texte de JupyterLab pour vous en rendre compte.
```

## Analyser 50 échantillons

Maintenant que nous savons comment analyser un échantillon avec un cluster de calcul, nous allons automatiser l'analyse de 50 échantillons. Mais pour cela nous prendre plusieurs précautions :

- Nous allons séparer les étapes suivantes :
    1. Indexer le génome de référence -- ne doit ce que faire une seule fois.
    2. Contrôler la qualité, aligner et quantifier les *reads* -- qui doit se faire pour chaque échantillon, donc 50 fois.
    3. Normaliser les comptages de tous les échantillons ensemble -- ne doit ce que faire une seule fois.
- L'étape 2 ne doit pas se faire successivement pour chaque échantillon, mais en parallèle. C'est-à-dire qu'on souhaite idéalement lancer l'analyse des 50 échantillons **en même temps**.

### Préparer les données

Nous avons préparer pour vous les 50 échantillons (fichiers .fastq.gz) ainsi que le génome de référencee et ses annotations dans le répertoire `/shared/projects/202304_duo/data/rnaseq_scere`. Vérifiez son contenu avec la commande :

```bash
$ tree /shared/projects/202304_duo/data/rnaseq_scere
```

### Lancer le script de l'étape 1

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts
```

Téléchargez dans un terminal de JupyterLab le script Bash ([`script_cluster_1.sh`](script_cluster_1.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto3/script_cluster_1.sh
```
Ouvrez ce script avec l'éditeur de texte de JupyterLab et essayez d'identifier comment sont définies les variables `base_dir` et `data_dir`.

Puis lancez le script en n'oubliant pas d'indiquer explicitement le compte à utiliser (`202304_duo`) :

```bash
$ sbatch -A 202304_duo script_cluster_1.sh
```

Vérifiez avec les commandes `squeue` et `sacct` que le job est lancé et se termine correctement (normalement rapidement).

```{rappel}
Le fichier `slurm-JOBID.out` (avec `JOBID` le numéro de votre job) contient le « journal » de votre job. N'hésitez pas à le consulter.
```

### Lancer le script de l'étape 2


Téléchargez dans un terminal de JupyterLab le script Bash ([`script_cluster_2.sh`](script_cluster_2.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/tuto3/script_cluster_2.sh
```
Ouvrez ce script avec l'éditeur de texte de JupyterLab. Notez en début de script la ligne 

```
#SBATCH --array=0-49 
```

qui nous permettra de créer un *job array*, c'est-à-dire un ensemble de 50 (de 0 à 49 inclus) sous-jobs qui vont être lancés en parallèle.

Pour chacun des sous-job, on lui attribue un échantillon avec les commandes suivantes :

```bash
# liste de tous les fichiers .fastq.gz dans un tableau
fastq_files=(${fastq_dir}/*fastq.gz)
# extraction de l'identifiant de l'échantillon
# à partir du nom de fichier : /shared/projects/form_2021_29/data/rnaseq_tauri/reads/SRR3405783.fastq.gz
# on extrait : SRR3405783
sample=$(basename -s .fastq.gz "${fastq_files[$SLURM_ARRAY_TASK_ID]}")
```

Cette étape est importante car elle permet de savoir quel échantillon traiter pour chaque sous-job. Par exemple, le sous-job 0 va être associé à l'échantillon `SRR3405783` (le premier par ordre alphabétique).

Pour ne pas emboliser le cluster et pour que tout le monde puisse obtenir des résultats, modifier la ligne 

```
#SBATCH --array=0-49 
```

par

```
#SBATCH --array=0-4
```

Vous n'analyserez que 5 échantillons dans 5 jobs en parallèle.  Pensez à sauvegarder vos modifications.

Lancez enfin le script :

```bash
$ sbatch -A 202304_duo script_cluster_2.sh
```

Suivez la progression de vos jobs avec la commande :

```bash
$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

avec `JOBID` le numéro de votre job.

Vous avez mérité une pause café ☕️


Plutôt que de relancer en permanence la commande `sacct` vous pouvez demander à la commande `watch` d'afficher les éventuels changements :

```bash
$ watch sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

```{hint}
Utilisez la combinaison de touches <kbd>Ctrl</kbd> + <kbd>C</kbd> pour arrêter la commande `watch`.
```

### Lancer le script de l'étape 3