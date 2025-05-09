# Automatiser l'analyse RNA-seq avec un cluster 🚀

```{contents}
```

## Découvrir le cluster

Un cluster de calcul met à disposition de ses utilisateurs des processeurs et de la mémoire vive pour réaliser des calculs. Ces ressources sont réparties sur plusieurs machines, appelées *nœuds de calcul*. Chaque nœud de calcul contient plusieurs dizaines de processeurs (ou cœurs) et plusieurs centaines de Go de mémoire vive.

Plusieurs utilisateurs utilisent simultanément un cluster de calcul. Pour vous en rendre compte, dans JupyterLab, ouvrez un terminal puis entrez la commande suivante qui va lister tous les calculs (appelés *job*) en cours sur le cluster :

```bash
$ squeue -t RUNNING
```

```{admonition} Rappel
:class: tip
Ne tapez pas le caractère `$` en début de ligne et faites attention aux majuscules et au minuscules.
```

Vous voyez que vous n'êtes pas seul ! Comptez maintenant le nombre de jobs en cours d'exécution en chaînant la commande précédente avec `wc -l` :

```bash
$ squeue -t RUNNING | wc -l
```

Vous pouvez aussi compter le nombre de jobs en attente d'exécution :

```bash
$ squeue -t PENDING | wc -l
```

Et vous alors ? Avez-vous lancé un calcul ? Vérifiez-le en entrant la commande suivante pour lister les calculs associés à votre compte :

```bash
$ squeue -u $USER
```

La colonne `ST` indique le statut de votre job :

- `CA` (*cancelled*) : le job a été annulé
- `F` (*failed*) : le job a planté
- `PD` (*pending*) : le job est en attente que des ressources soient disponibles
- `R` (*running*) : le job est en cours d'exécution

Bizarre ! Vous avez un job avec le statut *running* en cours d'exécution alors que vous n'avez a priori rien lancé 🤔

En fait, le JupyterLab dans lequel vous êtes est lui-même un job lancé sur le cluster. C'est d'ailleurs pour cela qu'avant de lancer JupyterLab, vous avez dû préciser le compte à utiliser (`2501_duo`) et choisir le nombre de processeurs et la quantité de mémoire vive dont vous aviez besoin. Finalement, vous étiez dans la matrice sans même le savoir 😱.

Comme plusieurs utilisateurs peuvent lancer des jobs sur un cluster, un gestionnaire de jobs (ou ordonnanceur) s'occupe de répartir les ressources entre les différents utilisateurs. Sur le cluster de l'IFB, le gestionnaire de jobs est [Slurm](https://slurm.schedmd.com/). Désormais le lancement de vos analyses se fera via Slurm.


## Analyser un échantillon

Déplacez-vous le répertoire `/shared/projects/2501_duo/$USER/rnaseq` puis vérifiez que vous êtes dans le bon répertoire avec la commande `pwd`.

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts
```

Téléchargez dans un terminal de JupyterLab un premier script Bash ([`script_cluster_0.sh`](script_cluster_0.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/content/tuto3/script_cluster_0.sh
```

Ce script correspond au script `script_local_2.sh` adapté pour une utilisation sur un cluster. Ouvrez le script `script_cluster_0.sh` avec l'éditeur de texte de JupyterLab et essayez d'identifier les différences avec `script_local_2.sh`. 

1. Au début du script, deux lignes sont nouvelles :

    ```
    #SBATCH --mem=2G
    #SBATCH --cpus-per-task=8
    ```

    Ces lignes commencent par le caractère `#` qui indique qu'il s'agit de commentaires pour Bash, elles seront donc ignorées par le *shell*. Par contre, elles ont un sens très particulier pour le gestionnaire de jobs du cluster Slurm. Ici, ces lignes indiquent à Slurm que le job a besoin de 2 Go de mémoire vive et de 8 processeurs pour s'exécuter.

1. Un peu plus loin, on indique explicitement les modules (les logiciels) à charger avec leurs versions :

    ```bash
    module load fastqc/0.11.9
    module load star/2.7.10b
    module load samtools/1.15.1
    module load htseq/0.13.5
    module load cufflinks/2.2.1
    ```

1. L'appel aux différents programmes (`STAR`, `fastqc`, `samtools`...) est préfixé par l'instruction `srun` qui va explicitement indiquer à Slurm qu'il s'agit d'un sous-job. Nous en verrons l'utilité plus tard.

1. Pour STAR, l'indication du nombre de cœurs à utiliser est défini sous la forme :

    ```bash
    srun STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
    ```

    La variable `SLURM_CPUS_PER_TASK` est utilisée pour indiquer à STAR le nombre de processeurs à utiliser. Cette variable est automatiquement définie par Slurm lors de l'exécution du script et la lecture de l'instruction `#SBATCH --cpus-per-task=8`. Dans le cas présent, elle vaut 8.


Lancez enfin le script avec la commande suivante :

```bash
$ sbatch -A 2501_duo script_cluster_0.sh
```

Vous devriez obtenir un message du type `Submitted batch job 33389786`. Ici, `33389786` correspond au numéro du job. Notez bien le numéro de votre job.


- L'instruction `sbatch` est la manière de demander à Slurm de lancer un script.
- L'option `-A 2501_duo` spécifie quel projet utiliser (facturer) pour cette commande. Un même utilisateur peut appartenir à plusieurs projets. Le nombre d'heures de calcul attribuées à un projet étant limité, il est important de savoir quel projet imputer pour telle ou telle commande. Pensez-y pour vos futurs projets.

Vérifiez que votre script est en train de tourner avec la commande :

```bash
$ squeue -u $USER
```

Le statut du job devrait être *RUNNING* (`R`).

Et pour avoir plus de détails, utilisez la commande :

```bash
$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

avec `JOBID` (en fin de ligne) le numéro du job à remplacer par le vôtre.

Voici un exemple de sortie que vous pourriez obtenir :

```
$  sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j 33389786
       JobID    JobName      State               Start    Elapsed    CPUTime        NodeList 
------------ ---------- ---------- ------------------- ---------- ---------- --------------- 
33389786     script_cl+    RUNNING 2023-05-12T10:25:21   00:00:46   00:06:08     cpu-node-11 
33389786.ba+      batch    RUNNING 2023-05-12T10:25:21   00:00:46   00:06:08     cpu-node-11 
33389786.0         STAR  COMPLETED 2023-05-12T10:25:23   00:00:08   00:01:04     cpu-node-11 
33389786.1       fastqc    RUNNING 2023-05-12T10:25:31   00:00:36   00:04:48     cpu-node-11 
```

Quand la colonne *State* est à `COMPLETED`, cela signifie que le sous-job est terminé. Un sous-job est créé à chaque fois que la commande `srun` est utilisée dans le script de soumission. Ici, on voit que le sous-job `STAR` est terminé, mais que le sous-job `fastqc` est toujours en cours d'exécution.

Relancez régulièrement la commande précédente pour suivre l'avancement de votre job.

```{note}
Pour rappeller une commande précédente, vous pouvez utiliser la flèche du haut de votre clavier. Cela vous évitera de retaper la commande à chaque fois.
```

Notez le moment où vous avez terminé l'alignement sur le génome de référence, c'est-à-dire que vous avez obtenu un second sous-job `STAR` avec le statut `COMPLETED` dans la sortie renvoyée par `sacct`. Par exemple :

```
$  sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j 33389786
       JobID    JobName      State               Start    Elapsed    CPUTime        NodeList 
------------ ---------- ---------- ------------------- ---------- ---------- --------------- 
33389786     script_cl+    RUNNING 2023-05-12T10:25:21   00:03:25   00:27:20     cpu-node-11 
33389786.ba+      batch    RUNNING 2023-05-12T10:25:21   00:03:25   00:27:20     cpu-node-11 
33389786.0         STAR  COMPLETED 2023-05-12T10:25:23   00:00:08   00:01:04     cpu-node-11 
33389786.1       fastqc  COMPLETED 2023-05-12T10:25:31   00:01:23   00:11:04     cpu-node-11 
33389786.2         STAR  COMPLETED 2023-05-12T10:26:54   00:01:36   00:12:48     cpu-node-11 
33389786.3     samtools    RUNNING 2023-05-12T10:28:30   00:00:16   00:02:08     cpu-node-11 
```

Nous ne souhaitons pas poursuivre plus longtemps cette analyse, car cela prendrait trop de temps.

Stoppez le job en cours avec la commande :

```bash
$ scancel JOBID
```

avec `JOBID` le numéro de votre job.

Vérifiez avec la commande `squeue -u $USER` que votre job ne tourne plus.


```{note}
Le fichier `slurm-JOBID.out` (avec `JOBID` le numéro de votre job) contient le « journal » de votre job. C'est-à-dire tout ce qui s'affiche habituellement à l'écran a été enregistré dans ce fichier.

Ouvrez ce fichier avec l'éditeur de texte de JupyterLab pour vous en rendre compte.
```

## Analyser 50 échantillons (ou pas loin)

Maintenant que nous savons comment analyser un échantillon avec un cluster de calcul, nous allons automatiser l'analyse de 50 échantillons. Mais pour cela nous allons prendre plusieurs précautions :

- Nous allons séparer les étapes suivantes :
    1. Indexer le génome de référence -- ne doit être fait qu'une seule fois.
    2. Contrôler la qualité, aligner et quantifier les *reads* -- doit être fait pour chaque échantillon, donc 50 fois.
    3. Normaliser les comptages de tous les échantillons ensemble -- ne doit être fait qu'une seule fois.
- L'étape 2 ne doit pas se faire successivement pour chaque échantillon, mais en parallèle. C'est-à-dire qu'on souhaite idéalement lancer l'analyse des 50 échantillons **en même temps**.

### Préparer les données

Nous avons téléchargé pour vous les 50 échantillons (fichiers *.fastq.gz*) ainsi que le génome de référence et ses annotations dans le répertoire `/shared/projects/202304_duo/data/rnaseq_scere`. Vérifiez son contenu avec la commande :

```bash
$ tree /shared/projects/2501_duo/data/rnaseq_scere
```

### Lancer le script de l'étape 1 (indexer le génome de référence)

Supprimez les répertoires qui contiennent les résultats d'une éventuelle précédente analyse :

```bash
$ rm -rf genome_index reads_qc reads_map counts slurm*.out
```

Téléchargez dans un terminal de JupyterLab le script Bash ([`script_cluster_1.sh`](script_cluster_1.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/content/tuto3/script_cluster_1.sh
```
Ouvrez ce script avec l'éditeur de texte de JupyterLab et essayez d'identifier comment sont définies les variables `base_dir` et `data_dir`.

Puis lancez le script en n'oubliant pas d'indiquer explicitement le compte à utiliser (`202304_duo`) :

```bash
$ sbatch -A 2501_duo script_cluster_1.sh
```

Vérifiez avec les commandes `squeue` et `sacct` que le job est lancé et se termine correctement (normalement rapidement).

```{rappel}
Le fichier `slurm-JOBID.out` (avec `JOBID` le numéro de votre job) contient le « journal » de votre job. N'hésitez pas à le consulter.
```


### Lancer le script de l'étape 2 (traiter les échantillons)

Téléchargez dans un terminal de JupyterLab le script Bash ([`script_cluster_2.sh`](script_cluster_2.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/content/tuto3/script_cluster_2.sh
```
Ouvrez ce script avec l'éditeur de texte de JupyterLab. Notez en début de script la ligne :

```
#SBATCH --array=0-49 
```

qui nous permettra de créer un *job array*, c'est-à-dire un ensemble de 50 (de 0 à 49 inclus) jobs qui vont être lancés en parallèle.

Pour chacun des jobs, on lui attribue un échantillon avec les commandes suivantes :

```bash
# liste de tous les fichiers .fastq.gz dans un tableau
fastq_files=(${fastq_dir}/*fastq.gz)
# extraction de l'identifiant de l'échantillon
# à partir du nom de fichier : /shared/projects/2501_duo/data/rnaseq_scere/reads/SRR3405783.fastq.gz
# on extrait : SRR3405783
sample=$(basename -s .fastq.gz "${fastq_files[$SLURM_ARRAY_TASK_ID]}")
```

Cette étape est importante, car elle permet de savoir quel échantillon traiter pour chaque job. Par exemple, le job 0 va être associé à l'échantillon `SRR3405783` (le premier par ordre alphabétique).

Pour ne pas emboliser le cluster et pour que tout le monde puisse obtenir des résultats rapidement, modifiez la ligne 

```
#SBATCH --array=0-49 
```

par

```
#SBATCH --array=0-2
```

Vous n'analyserez que 3 échantillons dans 3 jobs en parallèle. Pensez à sauvegarder vos modifications.

Lancez enfin le script :

```bash
$ sbatch -A 2501_duo script_cluster_2.sh
```

Suivez la progression de vos jobs avec la commande :

```bash
$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

avec `JOBID` le numéro de votre job.

Plutôt que de relancer en permanence la commande `sacct` vous pouvez demander à la commande `watch` d'afficher les éventuels changements :

```bash
$ watch sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

Vous devriez obtenir un affichage du type :

```
Every 2.0s: sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j ...  Wed May 10 22:22:53 2023

       JobID    JobName      State               Start    Elapsed    CPUTime        NodeList
------------ ---------- ---------- ------------------- ---------- ---------- ---------------
33361021_0   script_cl+    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-20
33361021_0.+      batch    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-20
33361021_0.0     fastqc    RUNNING 2023-05-10T22:21:56   00:00:57   00:07:36     cpu-node-20
33361021_1   script_cl+    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-23
33361021_1.+      batch    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-23
33361021_1.0     fastqc    RUNNING 2023-05-10T22:21:56   00:00:57   00:07:36     cpu-node-23
33361021_2   script_cl+    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-25
33361021_2.+      batch    RUNNING 2023-05-10T22:21:54   00:00:59   00:07:52     cpu-node-25
33361021_2.0     fastqc    RUNNING 2023-05-10T22:21:56   00:00:57   00:07:36     cpu-node-25
```

On apprend ici que 3 jobs sont en cours d'exécution (`RUNNING`) et qu'ils sont appelés `33361021_0`, `33361021_1` et `33361021_2`. Chacun de ces jobs a été lancé sur un noeud de calcul différent (`cpu-node-20`, `cpu-node-23` et `cpu-node-25`) mais cela aurait pu être le même. Chaque job est décomposé en sous-jobs, pour le moment à l'étape `fastqc`.

Le temps que les 3 jobs se terminent, profitez-en pour faire une pause café ☕️ bien méritée et réaliser à quel point la bioinformatique et ses possibilités d'automatisation sont cools.

```{hint}
Utilisez la combinaison de touches <kbd>Ctrl</kbd> + <kbd>C</kbd> pour arrêter la commande `watch`.
```

Quand tous les jobs sont à `COMPLETED`, comparez le temps d'exécution de chacun (dans la colonne *Elapsed* au niveau des lignes *script_cl+*). Ce temps d'exécution devrait être compris entre 15 et 20 min, ce qui est équivalent au temps d'exécution du script `script_local_2.sh` pour un **seul échantillon**. C'est tout l'intérêt de lancer des jobs en parallèle.

Remarquez que le temps CPU (`CPUTime`) qui correspond au temps de calcul consommé par tous les processeurs est supérieur au temps « humain » (*Elapsed*). Ainsi, si vous avez lancé un job avec 8 coeurs qui se termine en 1 heure, la consommation CPU sera de 8 coeurs x 1 heure = 8 heures. Sur un cluster, c'est toujours le temps CPU qui est facturé.


### Lancer le script de l'étape 3 (normaliser les comptages)

Vous allez maintenant normaliser les différents comptages.

Téléchargez dans un terminal de JupyterLab le script Bash ([`script_cluster_3.sh`](script_cluster_3.sh)) avec la commande `wget` :

```bash
$ wget https://raw.githubusercontent.com/pierrepo/unix-tutorial/master/content/tuto3/script_cluster_3.sh
```

Ouvrez ce script avec l'éditeur de texte de JupyterLab. Retrouvez les lignes spécifiques à l'utilisation d'un cluster de calcul et qui débutent par :

- `#SBATCH`
- `module load`
- `srun`

Puis lancez le script :

```bash
$ sbatch -A 2501_duo script_cluster_3.sh
```

Affichez l'avancement de votre job avec la commande `sacct` :

```bash
$ sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

ou

```bash
$ watch sacct --format=JobID,JobName,State,Start,Elapsed,CPUTime,NodeList -j JOBID
```

avec `JOBID` le numéro de votre job.

L'exécution de ce script devrait moins d'une minute.

Le fichier qui contient le comptage normalisé des transcrits est `counts/genes.count_table`.


## Bilan

Vous avez lancé une analyse RNA-seq complète en utilisant le gestionnaire de ressources (Slurm) d'un cluster de calcul. Bravo ✨

Un peu plus tard, nous vous inviterons à reprendre cette analyse, mais cette fois sur les 50 échantillons. Pour cela, il vous faudra modifier le script `script_cluster_2.sh` en remplaçant la ligne `#SBATCH --array=0-2` (pour 3 échantillons) par `#SBATCH --array=0-49` (pour 50 échantillons). Pensez aussi à relancer le script `script_cluster_3.sh` pour normaliser les résultats de comptage.


## Aller plus loin : connecter les jobs

```{note}
Vous n'êtes pas obligé de lancer les commandes ci-dessous. Elles sont là pour vous montrer comment automatiser le lancement de plusieurs jobs les uns après les autres.
```

Pour cette analyse, il faut lancer 3 scripts à la suite : `script_cluster_1.sh`, `script_cluster_2.sh` et `script_cluster_3.sh`. À chaque fois, il faut attendre que le précédent soit terminé, ce qui peut être pénible. Slurm offre la possibilité de chaîner les jobs les uns avec les autres avec l'option `--dependency`. Voici un exemple d'utilisation.

Tout d'abord on lance le script `script_cluster_1.sh` :

```bash
$ sbatch -A 2501_duo script_cluster_1.sh
Submitted batch job 33390286
```

On récupère le job id (`33390286`) puis on lance immédiatement le script `script_cluster_2.sh` :
```bash
$ sbatch -A 2501_duo --dependency=afterok:33390286 script_cluster_2.sh
Submitted batch job 33390299
```

On récupère le nouveau job id (`33390299`) puis on lance immédiatement le dernier script `script_cluster_3.sh` :

```bash
$ sbatch -A 2501_duo --dependency=afterok:33390299 script_cluster_3.sh
Submitted batch job 33390315
```

Dans l'exemple ci-dessus, le job `33390315` (pour `script_cluster_3.sh`) ne va s'exécuter que quand le job `33390299` (pour `script_cluster_2.sh`) sera terminé avec succès. Et le job `33390299` ne va s'exécuter que quand le job `33390286` (pour `script_cluster_1.sh`) sera, lui aussi, terminé avec succès.

Voici le résultat obtenu avec `squeue` : 

```
$ squeue -u ppoulain
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          33390315      fast script_c ppoulain PD       0:00      1 (Dependency)
          33389748      fast  jupyter ppoulain  R      28:36      1 cpu-node-15
        33390299_0      fast script_c ppoulain  R       1:44      1 cpu-node-2
        33390299_1      fast script_c ppoulain  R       1:44      1 cpu-node-30
        33390299_2      fast script_c ppoulain  R       1:44      1 cpu-node-35
```

Dans cet exemple le premier job (`33390286`) est déjà terminé (et n'apparait pas). Le job `33390299` est en cours d'exécution (pour 3 échantillons seulement) et le job `33390315` est en attente que le job `33390299` se termine.

Cette méthode évite d'attendre que le job précédent se termine pour lancer le suivant, mais il faut quand même les lancer manuellement pour récupérer les job ids. On peut automatiser cela avec les commandes suivantes :


```bash
jobid1=$(sbatch -A 2501_duo script_cluster_1.sh | cut -d' ' -f 4)
echo "Running job 1: ${jobid1}"
jobid2=$(sbatch -A 2501_duo --dependency=afterok:${jobid1} script_cluster_2.sh | cut -d' ' -f 4)
echo "Running job 2: ${jobid2}"
sbatch -A 2501_duo --dependency=afterok:${jobid2} script_cluster_3.sh
squeue -u $USER
```

La commande `squeue` à la fin permet simplement de vérifier que le premier job est en cours d'exécution et que les deux autres sont en attente.
